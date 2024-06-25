<form method="get" target="_blank" name="form_wholesale_standalone" id="form_wholesale_standalone" action="php/WholesaleInvoice.pdf" onsubmit="return wholesaleInvoiceFormSubmitHandler();">
<input name="pn" type="hidden" value="<%=order%>">
<%Set rs3 = getMysqlQueryRecordSet("Select * from wholesale_invoices where purchase_no=" & order, con)
Dim winvoiceno, winvoicedate
if not rs3.eof then
winvoiceno=rs3("wholesale_inv_no")
winvoicedate=rs3("wholesale_inv_date")
end if
rs3.close
set rs3=nothing
%>
 <table width="350" class="bordergris" border="0" cellspacing="0" cellpadding="3" align="right">
  <tr>
    <td colspan="2"><div align="center"><strong>Wholesale Invoicing</strong></div></td>
    </tr>
  <tr>
    <td>Allocate Wholesale Invoice Number : &nbsp;</td>
    <td><input name="winvoiceno" type="text" id="winvoiceno" size="10" maxlength="25" onKeyUp="showWholesalePDFButton();" value="<%=winvoiceno%>" >&nbsp;</td>
  </tr>
  <tr>
    <td>Invoice Date :&nbsp;</td>
    <td><input name="winvoicedate" type="text" id="winvoicedate" size="10" maxlength="25" onChange="showWholesalePDFButton();" value="<%=winvoicedate%>" >&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2"><div align="center"><strong><input name="wholesalePDF" type="submit" id="wholesalePDF" value="Wholesale Invoice PDF"></strong></div></td>
    </tr>
</table>
</form>

<script type = "text/javascript">
	function wholesaleInvoiceFormSubmitHandler() {
		var go = confirm('Unsaved changes to the order will be lost. Click OK to proceed.');
		if (!go) return false;
		
		var url = "ajaxSaveWholesalePrices.asp?pn=<%=order%>";

		url += getWholesaleInvoiceFormParam("Wmattressprice");
		url += getWholesaleInvoiceFormParam("Wtopperprice");
		url += getWholesaleInvoiceFormParam("WBaseFabricprice");
		url += getWholesaleInvoiceFormParam("WBaseUphprice");
		url += getWholesaleInvoiceFormParam("WBaseTrimprice");
		url += getWholesaleInvoiceFormParam("WBaseDrawerprice");
		url += getWholesaleInvoiceFormParam("WBaseprice");
		url += getWholesaleInvoiceFormParam("Wlegsprice");
		url += getWholesaleInvoiceFormParam("WSupportlegsprice");
		url += getWholesaleInvoiceFormParam("WHBFabricprice");
		url += getWholesaleInvoiceFormParam("WHBTrimprice");
		url += getWholesaleInvoiceFormParam("WHBprice");
		url += getWholesaleInvoiceFormParam("Wvalanceprice");
		url += getWholesaleInvoiceFormParam("Wvalancefabprice");
		url += getWholesaleInvoiceFormParam("manhattantrim");
		for (var i = 1; i<=20; i++) {
			var val = getWholesaleInvoiceFormParam("acc_wholesalePrice" + i);
			if (val != "") {
				var acc_id = $('#acc_id' + i).val();
				url += "&acc_id" + i + "=" + acc_id;
				url += val;
			}
		}
		
		jQuery.ajaxSetup({async:false});
		var ret = false;
		$.get(url, function(result) {
			if (result == 'success') ret = true;
		});
		jQuery.ajaxSetup({async:true});
		if (!ret) {
			alert("Failed to save wholesale prices");
		}
		return ret;
	}
	
	function getWholesaleInvoiceFormParam(paramName) {
		var val = $('#' + paramName).val();
		if (typeof val === "undefined" || val == "") return "";
		return "&" + paramName + "=" + encodeURI(val);
	}
	
</script>