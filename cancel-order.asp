<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="emailfuncs.asp" -->
<!-- #include file="generalfuncs.asp" -->
<%
dim reasonText, con, rs, rs3, rs4, sql, purchase_no, payments, n, orderCurrency, paymentsTotal, refundAmt, refundmethodname, refundmethod, reason, contactIdLocation, emailIdLocation, cancelcustomername, contactno, noOfPurchases
dim isVIP, isVIPmanuallyset, totalspend, vals, orderTotals, i
set con = getMysqlConnection()

purchase_no = request("purchase_no")
noOfPurchases=0
Set rs4 = getMysqlQueryRecordSet("Select * from savoir_user where user_id like '" & retrieveUserID() & "'", con)
	contactIdLocation = rs4("id_location")
	emailIdLocation=rs4("adminemail")
	call closeRs(rs4)
	
if request("submit") <> "" then
	' update the order
	con.begintrans
	
	set rs = getMysqlUpdateRecordSet("select * from purchase where purchase_no=" & purchase_no, con)
	contactno=rs("contact_no")
	set rs3 = getMysqlQueryRecordSet("select count(purchase_no) as x from purchase where (quote='n' or quote is null) and (cancelled='n' or cancelled is null) and contact_no=" & contactno, con)
		noOfPurchases=Cdbl(rs3("x"))
	rs3.close
	'update address to prospect if customer only has one order i.e. the current one '
	if noOfPurchases<2 then
		set rs3 = getMysqlUpdateRecordSet("select * from Address WHERE CODE in (Select A.CODE from Address A, Contact C where C.Code=A.Code and C.Contact_no=" & contactno & ")", con)
			rs3("Status")="Prospect"
		rs3.update
		rs3.close
	end if
		
	set rs3 = getMysqlUpdateRecordSet("select * from purchase where purchase_no=" & purchase_no, con)
	refundAmt = safeCCur(request("refund"))
	'response.write("refundAmt=" & refundAmt)
	if refundAmt > 0.0 then
		rs("balanceoutstanding") = safeCCur(rs("balanceoutstanding")) + refundAmt
		
		rs("paymentstotal") = safeCCur(rs("paymentstotal")) - refundAmt
	end if

	rs("cancelled") = "y"
	reason=request("reasontext")
	reason = reason & " " & defaultString(request("reason"), "")
	if len(reason) > 254 then reason = left(reason,254)
	rs("cancelled_reason") = reason
	rs.update
	rs.close

	' remove VIP status if no longer applicable
	sql = "Select * from contact WHERE contact_no=" & contactno
	Set rs = getMysqlUpdateRecordSet(sql, con)
	if rs("isVIP")="y" then
		orderTotals = getVIPCustomerOrdersTotal(con, contactno)
		totalspend = 0.0
		for i = 1 to ubound(orderTotals)
			response.write("orderTotals(i)=" & orderTotals(i) & "<br>")
			vals = split(orderTotals(i), ":")
			if vals(0)="GBP" then
				totalspend = vals(1)
			end if
		next

		if totalspend < 19999 and rs("isVIPmanuallyset") = "n" then 
			rs("isVIP")="n"
			rs.Update
		end if
	end if
	rs.close
	set rs=nothing

	' do the refund
	if refundAmt > 0.0 then
		refundmethod=Request("refundmethod")
		If refundmethod <> "" then
			sql="Select * from paymentmethod WHERE paymentmethodid=" & refundmethod
			Set rs = getMysqlQueryRecordSet(sql, con)
			refundmethodname=rs("paymentmethod")
			call closemysqlrs(rs)
		end if

		Set rs = getMysqlUpdateRecordSet("Select * from payment where purchase_no=" & purchase_no, con)
		rs.AddNew
		rs("amount") = refundAmt * -1.0
		rs("salesusername") = retrieveUserName()
		rs("paymentmethodid") = refundmethod
		rs("reasonforamend")="Order Cancelled"
		rs("paymenttype") = "Refund"
		rs("purchase_no") = purchase_no
		rs("placed") = toDbDateTime(now)
		rs("receiptno") = getNextReceiptNumber(con)
		rs.update
		call closemysqlrs(rs)
	end if
	
	Set rs = getMysqlUpdateRecordSet("Select * from exportlinks where purchase_no=" & purchase_no, con)
	If not rs.eof then
	  do until rs.eof
		  call log(scriptname, "deleting from exportlinks where purchase_no=" & purchase_no)
	  rs.delete
	  rs.movenext
	  loop
	end if
	call closemysqlrs(rs)
	
	con.committrans
	call sendCancellationEmail(con, purchase_no, refundAmt)
	call closemysqlcon(con)
	'response.end
	response.redirect("ordercomplete.asp?val=" & purchase_no)
end if

reasonText = toDisplayDate(now()) & ", " & retrieveUserName() & ": "
payments = getPaymentsForOrder(purchase_no, con)
sql = "select * from purchase where purchase_no=" & purchase_no
set rs = getMysqlQueryRecordSet(sql, con)
orderCurrency = rs("ordercurrency")
paymentsTotal = safeCCur(rs("paymentstotal"))
call closemysqlrs(rs)
%>

<html>
	<head>
		<script src="common/jquery.js"></script>
        <link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
	</head>
	<body>
    <div class="container">
    <div class="content brochure">
    <div class="one-col head-col">
		<div>
		  <h1 class="largertext">Do you wish to continue?</h1>
		  <h1 class="largertext">You are about to cancel this order, and this cannot be undone.</h1>
		  <p>&nbsp;</p>
		</div>
		<div><button type="button" id="proceedorder" onClick="JavaScript:showForm();">Proceed to Cancel Order</button></div>
		<div><button type="button" id="returnorder" onClick="JavaScript:window.location='<%=request("ret")%>';">Keep Order, Return to Order</button></div>
        <div class="clear"></div>
		<div id="formdiv">
			<form method="post" name="cancelorderform" id="cancelorderform" onSubmit="return validateForm(this);">
				<input type="hidden" name="purchase_no" value="<%=purchase_no%>" />
				Reason for cancellation (user and date are automatically added to the field below):<br />
				<textarea name="reason" cols="60" rows="6"></textarea>
                <input name="reasontext" type="hidden" value="<%=reasontext%>">
<br /><br />
			    <%if ubound(payments) > 0 then %>
			      <table>
				     <tr><td>Payments/Refunds</td></tr>
				     <tr>
				     	<td>Type</td><td>Payment Method</td><td>Receipt No.</td><td>Amount</td><td>Credit Details</td>
				     </tr>
				     <%
				     for n = 1 to ubound(payments)
					     %>
					     <tr>
					       <td><%=payments(n).paymentType%></td>
					       <td><%=payments(n).paymentMethod%></td>
					       <td><%=payments(n).receiptNo%></td>
					       <td><%=fmtCurr2(abs(payments(n).amount), true, orderCurrency)%></td>
					       <% if payments(n).creditDetails <> "" then %>
					       	   <td><%=payments(n).creditDetails%></td>
					       <% end if %>
					     </tr>
				     <%next%>
				     </table>
			     <% end if %>
				 <br/>Payments Total&nbsp;<%=fmtCurr2(paymentsTotal, true, orderCurrency)%><br/>
			     <% if paymentsTotal > 0.0 then %>
			     <br/>Enter Refund&nbsp;
			           <%=getCurrencySymbolForCurrency(orderCurrency)%><input name="refund" type="text" id="refund" size="10" maxlength="25" >&nbsp;
			           <select name="refundmethod" id="refundmethod">
			           <%
			               Set rs3 = getMysqlUpdateRecordSet("Select * from paymentmethod", con)
			               while not rs3.eof
			                   %> <option value="<%=rs3("paymentmethodid")%>" ><%=rs3("paymentmethod")%></option> <%
			                   rs3.movenext
			               wend
			               call closers(rs3)
			           %>
			           </select>
			     <% end if %>

				<br/><input type="submit" name="submit" value="Cancel Order" id="cancelsubmit" />
			</form>
            </div>
      </div>
		</div>
      </div>
	</body>
</html>
<% call closemysqlcon(con) %>
<script language="JavaScript" type="text/javascript">
	
	$(document).ready(init());
	
	function init() {
		$('#formdiv').hide();
	}

	function showForm() {
		$('#formdiv').show();
	}
	
	function validateForm(theForm) {
		 if (theForm.reason.value == "")
  {
    alert("Please enter a reason for the cancellation");
    theForm.reason.focus();
    return (false);
  }
	}

	$('#refund').blur(function() {
		var paymentsTotal = <%=paymentsTotal%>;
		var refund = $('#refund').val() / 1.0; // this makes sure we get a number
		if (refund > paymentsTotal) {
			$('#refund').val(paymentsTotal.toFixed(2));
		}
	});

</script>

<%
sub sendCancellationEmail(byref acon, aPurchaseNo, aRefundAmt)

	dim subject, msg, ars
	set ars = getMysqlQueryRecordSet("select * from purchase P, contact C where purchase_no=" & aPurchaseNo & " and P.code=C.code", acon)
	subject = "Order Cancellation - Order No. " & ars("order_number")
cancelcustomername=""
	if ars("title")<>"" then cancelcustomername=ars("title")
	if ars("first")<>"" then cancelcustomername=cancelcustomername & " " & ars("first")
	if ars("surname")<>"" then cancelcustomername=cancelcustomername & " " & ars("surname")
	msg="<html><body><font face=""Arial, Helvetica, sans-serif""><b>ORDER CANCELLATION</b><br/>"
	msg=msg & "<table width=""98%"" border=""1""  cellpadding=""3"" cellspacing=""0"">"
	msg=msg & "<tr><td>Customer Name</td><td>" & cancelcustomername & "</td></tr>"
	msg=msg & "<tr><td>Customer Reference</td><td>" & ars("customerreference") & "</td></tr>"
	msg=msg & "<tr><td>Order Number</td><td>" & ars("order_number") & "</td></tr>"
	msg=msg & "<tr><td>Refund Amount</td><td>" & fmtCurr2(aRefundAmt, true, ars("orderCurrency")) & "</td></tr>"
	msg=msg & "<tr><td>Cancellation Reason</td><td>" & ars("cancelled_reason") & "</td></tr>"
	msg=msg & "</table></font></body></html>"
	
	call closers(ars)

	call sendBatchEmail(subject, msg, "noreply@savoirbeds.co.uk", "SavoirAdminCancellations@savoirbeds.co.uk", "", emailIdLocation, true, acon)	
		
end sub
%>
<!-- #include file="common/logger-out.inc" -->
