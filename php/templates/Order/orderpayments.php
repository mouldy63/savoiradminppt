<?php use Cake\Routing\Router; ?>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#invoicedate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true
});
$( "#invoicedate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});
</script>
<div class="container" style="padding-left:20px;">
<form name="paymentsform" id="paymentsform" method="post" class="xview" action="/php/Order/saveOrderpayments">
<input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />
<div class="row">
    <hr class="h-divider">
</div> 
<div class="row justify-content-center">
    <div class="col-12">
    <p align="center" style="font-weight:bold">Order Payments</p> 
    </div>  
</div>
<div class="row">
<div class="col-12">
<?php if ($purchase['quote']=='n') { 
    if ($orderhasexportsnoinvoices != '' || $orderhasexports != '') { ?>
            <table border="0" align="right" class="delfloatright xview" bgcolor="#CCCCCC">
            <tr>
            <td valign="top" class="floatleft"><strong>Invoice No.</strong> <br>
            <input name="invoiceno" type="text" id="invoiceno" size="10" maxlength="25" ></td>
            <td valign="top" class="floatleft"><strong>Invoice Date</strong>:<br>
            <input name="invoicedate" type="text" id="invoicedate" size="10" maxlength="25" >&nbsp;<a href="clearinvoicedate();">X</a>
           </td>
            <td valign="top" class="floatleft"><strong>Print: </strong><br>
            
           
            <select name="invoiceType" id="invoiceType">
            <option value="n">Please Select</option>
            <option value="/php/commercialinvoice.pdf?cid=XXX&pno=<%=order%>">Commercial Invoice</option>
            <option value="/php/SavoirInvoice.pdf?invno=YYY&cid=XXX&pno=<%=order%>">Standard Invoice</option>
           
            </select></td>
            <?php if ($purchase['balanceoutstanding'] > 0.0) { ?>
                <td valign="top"><strong>Payment:</strong>
                <br>
                <?=$this->OrderForm->getCurrencySymbol()?><input name="additionalpayment" type="text" id="additionalpayment" size="10" maxlength="25" onKeyUp="checkPaymentTotal()" >&nbsp; <br>
                <br> <strong>Payment Type:</strong><br>
                <select name="paymentmethod" id="paymentmethod" onChange="paymentMethodChanged();" >
                <option value="" >Please Select</option>
                <?php foreach ($paymentmethods as $paymentmethod): 
              ?>
              <option value="<?= $paymentmethod['paymentmethodid'] ?>" ><?= $paymentmethod['paymentmethod'] ?> </option>  
              <?php endforeach; ?> 
                </select>
                <br>
                <span id="creditdetailsheader">Enter credit details</span>
   <br>
   <input type="text" name="creditdetails" id="creditdetails" size="20" maxlength="50" />
                </td>
                <?php } ?>
        </tr>
        </table>
       <?php } 
 } ?>
 </div>
 </div>
 <div class="row text-right" style="margin-top:15px;">
 <div class="col-12">
    <input type="submit" name="psubmit" value="Update Payments" id="psubmit" class="btn btn-info otherfield" />
</div>
</div>
 
 <div class="row">
    <hr class="h-divider">
</div>
</form>

</div>
<script>
    function orderpaymentsInit() {
    
        overrideOrderpaymentsSubmit();

        $(".orderpaymentsfield").on("change", function() {
            orderpaymentsFieldChanged = true;
        });
        $(".orderpaymentsfield").on("focus", function() {
            submitComponentForm(99);
        });
    }

    function paymentMethodChanged()
        {
        var selection = $("#paymentmethod").val();

        if (selection == "7")
        { // Customer Credit
            showHideCreditDetails(true);
        }
        else
        {
            showHideCreditDetails(false);
            $("#creditdetails").val("");
        }
    }

    function showHideCreditDetails(show)
    {
        if (show)
        {
            $('#creditdetails').show();
            $('#creditdetailsheader').show();
        }
        else
        {
            $('#creditdetails').hide();
            $('#creditdetailsheader').hide();
        }
    }

    function checkPaymentTotal()
    {
        var additionalpayment = $('#additionalpayment').val() / 1.0;
        var invno = $('#invoiceno').val();
        var outstanding = $('#OS' + invno).val() / 1.0;

        if (additionalpayment > <?= $purchase['balanceoutstanding'] ?>)
        {
            alert("You have an amount greater than the amount outstanding for this invoice which is " + <?= $purchase['balanceoutstanding'] ?>);
            $('#additionalpayment').val('');
        }
    }

    function clearinvoicedate() {
        $('#invoicedate').val('');
    }

   function validatePaymentsForm(theForm) {
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

    function overrideOrderpaymentsSubmit() { 
        $('#paymentsform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Order/saveOrderpayments',
                data: formData,
                success: function(compsToReload) {
                    reloadComponents(compsToReload);
                },
                error: function(xhr, status, error) {
                    console.error(error);
                },
                complete: function() {
                    $('#loading-spinner').hide();
                }
            });
        });
        orderpaymentsFieldChanged = false;
    }




    function submitOrderpaymentsForm() {
        $('#paymentsform').submit();
    }    
    
</script>
