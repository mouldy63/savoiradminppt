
<div id = "pendinginvoice">
<form method = "post" name = "form_pendinginvoice" id = "form_pendinginvoice"
action = "updatependinginvoice.asp" onsubmit = "return validateUpdateForm(this);">
<table border="0" cellspacing="2" cellpadding="5">
<tr>
    <td>Payment Type:</td>
    <td>Invoice Amount:</td>
    <td>Payments</td>
    <td>Outstanding</td>
  </tr>
  <tr>
    <td><input name="depositradio" type="checkbox" id="depositradio" value="y" /> 
      Deposit</td>
    <td><%= fmtCurr2(CDbl(rs("total"))/2, false, orderCurrency) %></td>
    <td><%=getPaymentsForInvoiceNo(invno,order,con)%></td>
    <td><%= fmtCurr2(CDbl(rs("total"))/2, false, orderCurrency) %></td>
  </tr>
</table>

<table border = "0" align = "right" class = "delfloatright" bgcolor = "#CCCCCC">
<tr>
<td valign = "top" class = "floatleft">
<strong>Invoice No.</strong>

<br>
<input name = "invoiceno" type = "text" id = "invoiceno" size = "10" maxlength = "25">
</td>

<td valign = "top" class = "floatleft">
<strong>Invoice Date</strong>:
<br>
<input name = "invoicedate" type = "text" id = "invoicedate" size = "10" maxlength = "25">
<div id="invoicedate_div1">
<a href = "javascript:calendar_window=window.open('calendar_ext.aspx?formname=form_pendinginvoice.invoicedate','calendar_window','width=154,height=288');calendar_window.focus()">
<br>
Choose Date |</a> <a href = "javascript:clearinvoicedate();">X</a></div>
</td>

<td valign = "top" class = "floatleft">
  <p><strong>Print: </strong></p>
  <p>
  <input type="hidden" name="pn" id="pn" value="<%=order%>" />
  
    <input type = "submit" name = "submit" value = "Record Invoice no and Date" id = "submit"
class = "button" tabindex = "105" />
    <br>
    <br>
    <img src = "trans.gif" width = "120" height = "1">
  </p>
  </td>


</tr>
</table>

</form>
</div>
 <script Language="JavaScript" type="text/javascript">
   function validateUpdateForm(theForm) {
 if (theForm.depositradio.checked && ( theForm.invoiceno.value == "" || theForm.invoicedate.value == "" ) ) 
{
alert ( "Please enter an invoice date / number" ); 
return false;
}

if (!theForm.depositradio.checked) 
{
alert ( "Please check the deposit radio button" ); 
return false;
}

   }
  </script>
  
  
  
