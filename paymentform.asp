<!-- #include file="pendinginvoicefuncs.asp" -->
<%
dim finalInvoiceData, finalInvoiceNo, finalInvoiceDate
finalInvoiceData = getFinalInvoiceNo(con, order)
finalInvoiceNo = finalInvoiceData(1)
finalInvoiceDate = finalInvoiceData(2)
%>
<div id="payment_table_standalone">

<form method="post" name="form_payments_standalone" id="form_payments_standalone" action="updatepayments.asp" onSubmit="return validatePaymentsForm(this);">

<%'if1
if (idlocation=14 or idlocation=30 or idlocation=40 or idlocation=41) and pendinginvoiceexists="y" then
%>
	<p>Invoice number <%= pendinginvoiceNo %> and invoice date <%= pendinginvoiceDate %> has been allocated to the deposit <a href="savoir-invoice-deposit.asp?idlocation=<%=idlocation%>&invdt=<%=pendinginvoiceDate%>&invno=<%=pendinginvoiceNo%>&pno=<%=order%>" target="_blank"><font color="red"><b>>> PRINT DEPOSIT <<</b></font></a></p>
	<% if finalInvoiceNo = "" then %>
		<p>Final Invoice number:&nbsp;<input type="text" name="finalinvno" id="finalinvno" />
		 Date:&nbsp;<input name="finalinvdate" type="text" id="finalinvdate" size="10" maxlength="25" >
 <a href="javascript:calendar_window=window.open('calendar_ext.aspx?formname=form_payments_standalone.finalinvdate','calendar_window','width=154,height=288');calendar_window.focus()">&nbsp;
 Choose Date</a>  | <a href="javascript:clearfinalinvdate();">X</a>&nbsp;<a href="#" onclick="return saveAndShowFinalInvoice('<%=idlocation%>', '<%=order%>');"><font color="red"><b>>> PRINT FINAL <<</b></font></a></p><br />
	<% else %>
		<p>Final invoice number <%= finalInvoiceNo %> and invoice date <%= finalInvoiceDate %> has been allocated to the final payment&nbsp;<a href="#" onclick="return showFinalInvoice('<%=idlocation%>', '<%=finalInvoiceDate%>', '<%=order%>', '<%=finalInvoiceNo%>');"><font color="red"><b>>> PRINT FINAL <<</b></font></a></p><br />
	<% end if %>
<%
end if
if orderhasexports="y" then%>

 <table border="0" align="right" class="delfloatright xview" bgcolor="#CCCCCC">
 <tr>
 <td valign="top" class="floatleft"><strong>Invoice No.</strong> <br>
 <input name="invoiceno" type="text" id="invoiceno" size="10" maxlength="25" ></td>
 <td valign="top" class="floatleft"><strong>Invoice Date</strong>:<br>
 <input name="invoicedate" type="text" id="invoicedate" size="10" maxlength="25" >
 <a href="javascript:calendar_window=window.open('calendar_ext.aspx?formname=form_payments_standalone.invoicedate','calendar_window','width=154,height=288');calendar_window.focus()"> <br>
 Choose Date |</a> <a href="javascript:clearinvoicedate();">X</a></td>
 <td valign="top" class="floatleft"><strong>Print: </strong><br>
 

 <select name="invoiceType" id="invoiceType">
 <option value="n">Please Select</option>
 <option value="/php/commercialinvoice.pdf?cid=XXX&pno=<%=order%>">Commercial Invoice</option>
 <option value="/php/SavoirInvoice.pdf?invno=YYY&cid=XXX&pno=<%=order%>">Standard Invoice</option>

 </select></td>
 <%'if2
  if outstanding > 0.0 then %>
 <td valign="top"><strong>Payment:</strong>
 <br>
 <%=getCurrencySymbolForCurrency(orderCurrency)%><input name="additionalpayment" type="text" id="additionalpayment" size="10" maxlength="25" onKeyUp="checkPaymentTotal()" >&nbsp; <br>
 <br> <strong>Payment Type:</strong><br>
 <select name="paymentmethod" id="paymentmethod" onChange="paymentMethodChanged();" >
 <option value="" >Please Select</option>
 <%
 Set rs3 = getMysqlUpdateRecordSet("Select * from paymentmethod", con)
 while not rs3.eof
  %>
  <option value="<%=rs3("paymentmethodid")%>" ><%=rs3("paymentmethod")%></option>
  <%
  rs3.movenext
 wend
 call closers(rs3)
 %>
 </select>
 <br>
 <br> <span id="creditdetailsheader">Enter credit details</span> <br>
 <input type="text" name="creditdetails" id="creditdetails" size="20" maxlength="50" />
 <br> <img src="trans.gif" width="120" height="1"></td>
 
 <%'end if2
 end if %>
  <%'if2
   if paymentSum > 0.0 then
 %>
  <td valign="top"><strong>Refund:</strong><br>
 <%=getCurrencySymbolForCurrency(orderCurrency)%><input name="refund" type="text" id="refund" size="10" maxlength="25" onKeyUp="checkRefundTotal()">
 <br>
 <br>
 <strong>Payment Type: <br>
 </strong>
 <select name="refundmethod" id="refundmethod">
 <option value="" >Please Select</option>
 <%
 Set rs3 = getMysqlUpdateRecordSet("Select * from paymentmethod", con)
 while not rs3.eof
  %>
  <option value="<%=rs3("paymentmethodid")%>" ><%=rs3("paymentmethod")%></option>
  <%
  rs3.movenext
 wend
 call closers(rs3)
 %>
 </select> &nbsp;</td>
 <%'end if2
 end if%>
 </tr>
 </table>
 <%'end if1
  end if %>
 
 <%'if1
if invoicenumbersexistfororder="y" then%>
  
  <table border="0" cellpadding="2" class="rowlineheight xview">
  <tr>
  <td valign="top"><strong>Invoice Date...</strong><br><img src="trans.gif" width="90" height="1"></td>
  <td valign="top"><strong>Invoice No.<br><img src="trans.gif" width="80" height="1"></strong></td>
  <td valign="top"><strong>Invoice Amount</strong><br><img src="trans.gif" width="90" height="1"></td>
  <td valign="top"><strong>Payment</strong>s</td>
  <td valign="top"><strong>Outstanding</strong></td>
  
  </tr>
  
  <%'end if1
  end if
  'if1
  if orderhasexports="y" then
   for i= 1 to expcount3
  
    expdate = toUSADate(exportdatearrayWithInvoice(i))
       sql="Select L.componentid, L.invoiceNo, L.invoicedate, E.exportCollectionsID from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=" & order & " and E.collectiondate='" & expdate & "' AND L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID"
       'response.write("<br>sql = " & sql)
   
       Set rs6 = getMysqlQueryRecordSet(sql, con)
	   'if2
       if not rs6.eof then
         expcount2=0
         totalcompprice2=0
         
		 if rs6("invoiceno")<>"" then exporthasinvoiceno="y"
         do until rs6.eof
         'if3 
          if rs6("componentid")>0 then
            expcount2=expcount2+1
            redim preserve compIDarray(expcount2)
            compIDarray(expcount2)=rs6("componentid")
            compprice=getComponentPrice(con,compIDarray(expcount2),order)
            if not isnull(compprice) and compprice <> "" then totalcompprice2=CDbl(totalcompprice2)+CDbl(compprice)
           'end if3
		      end if
          invdate=rs6("invoicedate")
          invno=rs6("invoiceNo")
          cid=rs6("exportCollectionsID")
          rs6.movenext
          loop
		  if (rs("deliveryprice") <>"" and not isnull(rs("deliveryprice"))) then
		  if rs("deliverycharge")="y" then totalcompprice2=CDbl(totalcompprice2)+CDbl(rs("deliveryprice"))
		  end if
     %>
     
      
      <tr>
     
      <td valign="middle">
      <input type="radio" name="exportchoice" id="exportchoice" value="<%=exportdatearrayWithInvoice(i)%>" onChange="pushInvoiceInfo('<%=invno%>','<%=invdate%>','<%=cid%>')"><%=invdate%>
      <input type="hidden" name="cid<%=replace(exportdatearrayWithInvoice(i), "/", "")%>" id="cid<%=replace(exportdatearrayWithInvoice(i), "/", "")%>" value="<%=cid%>" />
      </td>
     <td valign="middle"><%=invno%><%'=exportdatearrayWithInvoice(i) this is ex-works date%></td>
     <%'if3
	 if isTrade then
	 'if4
      if totalcompprice2<>"" then
        totalcompprice2=totalcompprice2+(totalcompprice2*(CDbl(rs("vatrate"))/100))
      'end if4
	  end if
     'totalcompprice2=totalcompprice2/(1+(CDbl(rs("vatrate"))/100))
    'end if3
	end if%>
     <td valign="middle"><input type="hidden" name="T<%=invno%>" id="T<%=invno%>" value="<%=totalcompprice2%>" /><%response.Write(fmtCurr2(totalcompprice2, true, orderCurrency))%></td>
     <td valign="middle"><input type="hidden" name="PA<%=invno%>" id="PA<%=invno%>" value="<%=getPaymentsForInvoiceNo(invno,order,con)%>" /><%response.Write(fmtCurr2(getPaymentsForInvoiceNo(invno,order,con), true, orderCurrency))%>
    &nbsp;</td>
     <td valign="middle"><input type="hidden" name="OS<%=invno%>" id="OS<%=invno%>" value="<%=getOutstandingForInvoiceNo(totalcompprice2,invno,order,con)%>" /><%response.Write(fmtCurr2(getOutstandingForInvoiceNo(totalcompprice2,invno,order,con), true, orderCurrency))%>&nbsp;</td>
     <%
     totalinvoiced=totalinvoiced+totalcompprice2%>
    
     </tr>
         <%
         rs6.close
         set rs6=nothing
		 'end if2
       end if
  next
    %>
   
  </table>
  <input name="totalinvoiced" id="totalinvoiced" type="hidden" value="<%=FormatNumber(totalinvoiced,,,,0)%>">
  
   <table border="0" class="floatleft xview">
   <tr>
  <%'if2
  if expcount <1 then
   else%>
   <td valign="middle">
   
   <%
   
   for i= 1 to expcount
    expdate = toUSADate(exportdatearray(i))
       sql="Select L.componentid, L.invoiceNo, L.invoicedate from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=" & order & " and E.collectiondate='" & expdate & "' AND L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID"
       Set rs6 = getMysqlQueryRecordSet(sql, con)
       'if3
	   if not rs6.eof then
         expcount2=0
         totalcompprice=0
		
         if rs6("invoiceno")<>"" then exporthasinvoiceno="y"
         do until rs6.eof
		 'if4
          if rs6("componentid")>0 then
            expcount2=expcount2+1
            redim preserve compIDarray(expcount2)
            redim preserve invDatearray(expcount2)
            compIDarray(expcount2)=rs6("componentid")
            'invDatearray(expcount2)=rs6("invoiceno")
            compprice=getComponentPrice(con,compIDarray(expcount2),order)
            if not isnull(compprice) and compprice <> "" then totalcompprice=totalcompprice+CDbl(compprice)
           'end if4
		   end if
           rs6.movenext
          loop
          rs6.close
          set rs6=nothing
        'end if3
		end if
    %>
    <%if not isnull(rs("discount")) then
		if cdbl(rs("discount")) <> 0.0 then
			if rs("discounttype") = "percent" then
				totalcompprice = (1.0-cdbl(rs("discount"))/100.0) * totalcompprice
			else
				totalcompprice = totalcompprice - cdbl(rs("discount"))
			end if
		end if
	end if

	if isTrade then
	     totalcompprice=((CDbl(rs("vatrate"))/100) * totalcompprice)+totalcompprice
	end if
    %>
    <input type="radio" name="exportchoice" id="exportchoice" value="<%=exportdatearray(i)%>" onChange="clearInvoiceInfo()">&nbsp;<strong>Ex&nbsp;works&nbsp;Date:</strong>&nbsp;<%=exportdatearray(i)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Amount:</strong>&nbsp;<%=getCurrencySymbolForCurrency(orderCurrency)%><%=FormatNumber(totalcompprice,,,,0)%><br>
    <%totalnotinvoiced=totalnotinvoiced+totalcompprice
    %><br>
    <%
   next
   %><img src="trans.gif" width="300" height="1">
   </td>
   
   <%'end if2
   end if%>
    <td><input type="submit" name="submit" value="Update Payments" id="submit" class="button" tabindex="105" /></td>
   </tr>
   </table>
   <input name="totalnotinvoiced" id="totalnotinvoiced" type="hidden" value="<%=FormatNumber(totalnotinvoiced,,,,0)%>">
   <div class="clear"></div>
   
  
  <%else%>
  <!-- not export -->
   <table border="0" align="center" cellpadding="6" class="xview">
   <tr>
   
   <td valign="top">Invoice No.<br> <input name="invoiceno" type="text" id="invoiceno" size="10" maxlength="25" ></td>
   <td valign="top">Invoice Date:<br>
   <input name="invoicedate" type="text" id="invoicedate" size="10" maxlength="25" ><a href="javascript:calendar_window=window.open('calendar_ext.aspx?formname=form_payments_standalone.invoicedate','calendar_window','width=154,height=288');calendar_window.focus()"> <br>
   Choose Date |</a> <a href="javascript:clearinvoicedate();">X</a></td>
   
   <% 'if2
   if outstanding > 0.0 then %>
   <td valign="top">Payment: <br>
   <%=getCurrencySymbolForCurrency(orderCurrency)%><input name="additionalpayment" type="text" id="additionalpayment" size="10" maxlength="25" >&nbsp;</td>
   <td valign="top">Payment Type:
   <br>
   <select name="paymentmethod" id="paymentmethod" onChange="paymentMethodChanged();" >
   <option value="" >Please Select</option>
   <%
   Set rs3 = getMysqlUpdateRecordSet("Select * from paymentmethod", con)
   while not rs3.eof
    %> <option value="<%=rs3("paymentmethodid")%>" ><%=rs3("paymentmethod")%></option> <%
    rs3.movenext
   wend
   call closers(rs3)
   %>
   </select>
   <br>
   <br>
   <span id="creditdetailsheader">Enter credit details</span>
   <br>
   <input type="text" name="creditdetails" id="creditdetails" size="20" maxlength="50" /></td>
   <%'end if2
   end if%>
   <%'if2
    if paymentSum > 0.0 then %>
   <td valign="top">Refund:<br>
  <%=getCurrencySymbolForCurrency(orderCurrency)%><input name="refund" type="text" id="refund" size="10" maxlength="25" >&nbsp; <br></td><td valign="top">Payment Type:
   <br>
  <select name="refundmethod" id="refundmethod">
   <option value="" >Please Select</option>
   <%
   Set rs3 = getMysqlUpdateRecordSet("Select * from paymentmethod", con)
   while not rs3.eof
    %> <option value="<%=rs3("paymentmethodid")%>" ><%=rs3("paymentmethod")%></option> <%
    rs3.movenext
   wend
   call closers(rs3)
   %>
   </select></td>
   <%'end if2
   end if%>
    <td><input type="submit" name="submit" value="Update Payments" id="submit" class="button" tabindex="105" /></td>
   </tr>
  </table>
  </div>
  
  <%'end if1
   end if %>

<input type="hidden" name="total" id="total" value="<%=fmtCurr2(rs("total"), false, orderCurrency)%>" />
<input type="hidden" name="outstanding" id="outstanding" value="<%=outstanding%>" />
<input type="hidden" name="pn" id="pn" value="<%=order%>" />
<input type="hidden" name="clientssurname" id="clientssurname" value="<%=rs1("surname")%>" />
<input type="hidden" name="company" id="company" value="<%=rs2("company")%>" />
<input type="hidden" name="orderno" id="orderno" value="<%=orderno%>" />
<input type="hidden" name="orderCurrency" id="orderCurrency" value="<%=orderCurrency%>" />
<input type="hidden" name="ordertypename" id="ordertypename" value="<%=rs("ordertype")%>" />
<input type="hidden" name="pricelist" id="pricelist" value="<%=pricelist%>" />
</form>
  
  <script Language="JavaScript" type="text/javascript">
   function validatePaymentsForm(theForm) {
     //if (theForm.additionalpayment && theForm.additionalpayment.value != "" && theForm.invoiceno.value == "") {
     //  alert('Please enter an invoice number');
     //  theForm.invoiceno.focus();
     //   return false;
     //}
     //if (theForm.additionalpayment && theForm.additionalpayment.value != "" && theForm.invoicedate.value == "") {
     //  alert('Please enter an invoice date');
     //  theForm.invoicedate.focus();
     //   return false;
     //}
     if (theForm.additionalpayment && theForm.additionalpayment.value != "" && theForm.paymentmethod.value == "") {
       alert('Please select a payment type');
       theForm.paymentmethod.focus();
        return false;
     }
     if (theForm.refund && theForm.refund.value != "" && theForm.refundmethod.value == "") {
       alert('Please select a refund payment type');
       theForm.refundmethod.focus();
        return false;
     }
   }
   
	function saveAndShowFinalInvoice(idlocation, order) {
		var finalinvno = $("#finalinvno").val();
		var finalinvnodate = $("#finalinvdate").val();
		if (finalinvno == '' && finalinvnodate == '') {
			alert("Please enter a final invoice number and / or date");
			$("#finalinvno").focus();
			return false;
		}
		var finalInvoiceDate = $("#finalinvdate").val();
		var url = "ajaxSaveFinalInvoiceNumber.asp?invno=" + finalinvno + "&pn=<%=order%>&invdt=" + finalInvoiceDate + "&ts=" + (new Date()).getTime();
		$.get(url, function(result) {
			if (result == "success") {
				var url = "savoir-invoice-final.asp?idlocation=" + idlocation + "&invdt=" + finalInvoiceDate + "&invno=" + finalinvno + "&pno=" + order;
				window.open(url, '_blank');
			} else {
				alert(result);
			}
		});
	}

	function showFinalInvoice(idlocation, finalInvoiceDate, order, finalinvno) {
		var url = "savoir-invoice-final.asp?idlocation=" + idlocation + "&invdt=" + finalInvoiceDate + "&invno=" + finalinvno + "&pno=" + order;
		console.log("url=" + url);
		window.open(url, '_blank');
	}
  </script>
  
  
