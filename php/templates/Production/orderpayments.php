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
<form name="paymentsform" id="paymentsform" method="post" class="xview" action="/php/Order/saveOrderpayments" onSubmit="return validatePaymentsForm(this);">
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
 
    <?php 

   
    if ($purchase['quote']=='n') { 
        if ((isset($orderhasexportsnoinvoices) && $orderhasexportsnoinvoices !='' && !empty($orderhasexportsnoinvoices)) || (isset($orderhasexports) && $orderhasexports !='' && !empty($orderhasexports))) { 
            
                ?>
                <table border="0" align="right" class="xview" bgcolor="#CCCCCC">
                <tr>
                <td valign="top" class="floatleft"><strong>Invoice No</strong> <br>
                <input name="invoiceno" type="text" id="invoiceno" size="5" maxlength="15" ></td>
                <td valign="top" class="floatleft"><strong>Invoice Date</strong>:<br>
                <input name="invoicedate" type="text" id="invoicedate" size="8" maxlength="15" >&nbsp;<a href="clearinvoicedate();">X</a>
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
                    <?php foreach ($paymentmethods as $paymentmethod):?>
                <option value="<?= $paymentmethod['paymentmethodid'] ?>" ><?= $paymentmethod['paymentmethod'] ?> </option>  
                <?php endforeach; ?> 
                    </select>
                    <br>
                    <span id="creditdetailsheader">Enter credit details</span>
                    <br>
                    <input type="text" name="creditdetails" id="creditdetails" size="20" maxlength="50" />
                    </td>
                <?php } ?>
                <?php if ($purchase['paymentstotal'] > 0.0) { ?>
                    <td valign="top"><strong>Refund:</strong>
                    <br>
                    <?=$this->OrderForm->getCurrencySymbol()?><input name="refund" type="text" id="refund" size="10" maxlength="25" onKeyUp="checkRefundTotal()">
                    <br><br><strong>Payment Type: <br> </strong>
                    <select name="refundmethod" id="refundmethod">
                        <option value="" >Please Select</option>
                        <?php foreach ($paymentmethods as $paymentmethod):?>
                            <option value="<?= $paymentmethod['paymentmethodid'] ?>" ><?= $paymentmethod['paymentmethod'] ?> </option>
                        <?php endforeach; ?>
                    </select> &nbsp;</td>
                <?php } ?>
            </tr>
            </table>
        <?php } 
        ?>
            <?php if (isset($orderhasexports) && $orderhasexports !='' && !empty($orderhasexports) || isset($orderhasexportsnoinvoices) && $orderhasexportsnoinvoices !='' && !empty($orderhasexportsnoinvoices)) { 
                 
                ?>
                
                <table border="0" cellpadding="2" class="xview">
                <tr>
                <td valign="top" align="right"><strong>Invoice Date</strong><br><img src="trans.gif" width="90" height="1"></td>
                <td valign="top" align="right"><strong>Invoice No.<br><img src="trans.gif" width="80" height="1"></strong></td>
                <td valign="top" align="right"><strong>Invoice Amount</strong><br><img src="trans.gif" width="90" height="1"></td>
                <td valign="top" align="right"><strong>Payments</strong></td>
                <td valign="top" align="right"><strong>Outstanding</strong></td>
                </tr>
                
                
                <?php 
                $expdate='';
                $totalinvoiced=0;
               
                foreach ($orderhasexports as $exportrow):
                    $expdate=$this->MyForm->mysqlToUsStrDate($exportrow['CollectionDate']);
                    $sql="Select L.componentid, L.invoiceNo, L.invoicedate, E.exportCollectionsID from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=".$purchase['PURCHASE_No']." and E.collectiondate='".$exportrow['CollectionDate']."' AND L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID and L.invoiceNo<>'' and L.invoiceNo is not null";

                    
                    $invdate=''; 
                    $totalcompprice2=0;
                    $totalcompprice=0;
                    
                    $rs = $this->AuxiliaryData->getDataArray($sql,[]);  
                    foreach ($rs as $rows):
                        if (!empty($rows['invoiceNo'])) {
                            if ($rows['componentid']>0) {
                                $compIDarray = [];
                                $expcount2 = count($compIDarray);
                                $compIDarray[$expcount2] = $rows['componentid'];
                                $compprice=$this->OrderForm->getComponentPriceXVat(true, $rows['componentid'], $purchase['PURCHASE_No'], true);
                                if (!empty($compprice) && is_numeric($compprice)) {
                                    $totalcompprice = $totalcompprice + $compprice;
                                }

                                $invdate=date("d/m/Y", strtotime(substr($rows['invoicedate'],0,10)));
                                $invno=$rows['invoiceNo'];
                                $cid=$rows['exportCollectionsID'];
                            }
                        }
                        if (!empty($purchase['deliveryprice']) && $purchase['deliverycharge'] == 'y') {
                            $totalcompprice = $totalcompprice + $purchase['deliveryprice'];
                        }

                    ?><?php
                endforeach;?>
                        <tr>
                        <td valign="top" align="left">
                            <input type="radio" name="exportchoice" id="exportchoice<?=$exportrow['exportcollectionsID']?>" value="<?=$exportrow['exportcollectionsID']?>" onChange="pushInvoiceInfo('<?=$rows['invoiceNo']?>','<?=$invdate ?>','<?=$rows['exportCollectionsID']?>')">&nbsp;<?=$invdate ?>
                            <input type="hidden" name="cid" id="cid" value="<?=$cid?>" /></td>
                        <td valign="top" align="right"><?=$invno?></td>
                        
                        <td valign="top" align="right"><input type="hidden" name="T<?=$invno?>" id="T<?=$invno?>" value="<?=$totalcompprice?>" /><?=$this->OrderForm->getCurrencySymbol()?><?=floatval($totalcompprice)?></td>
                        <td valign="top" align="right"><input type="hidden" name="PA<?=$invno?>" id="PA<?=$invno?>" value="<?=$this->OrderForm->getPaymentsForInvoiceNo(true, $invno, $purchase['PURCHASE_No'])?>" /><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($this->OrderForm->getPaymentsForInvoiceNo(true, $invno, $purchase['PURCHASE_No']),2)?>&nbsp;</td>
                        <td valign="top" align="right"><input type="hidden" name="OS<?=$invno?>" id="OS<?=$invno?>" value="<?=$this->OrderForm->getOutstandingForInvoiceNo(true, $totalcompprice, $invno, $purchase['PURCHASE_No'])?>" /><?=number_format($this->OrderForm->getOutstandingForInvoiceNo(true, $totalcompprice, $invno, $purchase['PURCHASE_No']),2)?>&nbsp;</td>
                        </tr>

                <?php
            
                    $totalinvoiced=$totalinvoiced+$totalcompprice;    
                    endforeach; 
                ?>  
                </table>

                <input name="totalinvoiced" id="totalinvoiced" type="hidden" value="<?=number_format($totalinvoiced,2)?>">



                <table border="0" cellpadding="2" class="floatleft xview">
                <tr>
            <?php 
            $totalnotinvoiced=0;
            $totalcompprice2=0;
            
            if ($noofinvoices < 0) { 
                
                ?>
                <td valign="middle">
                <?php } else {
                    
                
                foreach ($orderhasexportsnoinvoices as $exportNIrow):
                    $expdate=$this->MyForm->mysqlToUsStrDate($exportNIrow['CollectionDate']);
                    $sql="Select L.componentid, L.invoiceNo, L.invoicedate, E.exportCollectionsID from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=".$purchase['PURCHASE_No']." and E.collectiondate='".$exportNIrow['CollectionDate']."' AND L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID and (L.invoiceNo IS NULL or L.invoiceNo='')";
                    $rs = $this->AuxiliaryData->getDataArray($sql,[]); 
                    foreach ($rs as $rows):
                        $expcount3=0;
                        if ($rows['componentid']>0) {
                            $expocount2=$expcount3+1;
                            $compIDarray[$expcount3] = $rows['componentid'];
                                $compprice=$this->OrderForm->getComponentPriceXVat(true, $rows['componentid'], $purchase['PURCHASE_No'], true);
                                
                                if (!empty($compprice)) {
                                    $totalcompprice2 = $totalcompprice2 + $compprice;
                                }
                        }
                        ?>
        
                        <?php   
                        endforeach;
                        
                        if (!empty($purchase['discount'])) {
                            if ($purchase['discount']>0 && $purchase['discounttype']=='percent') {
                                $totalcompprice2=(1-$purchase['discount'])/100 * $totalcompprice2;
                            } else {
                                $totalcompprice2=(1-$purchase['discount'])/100 * $totalcompprice2;
                            }
                        }?>
                        <input type="radio" name="exportchoice" id="exportchoice_<?=$exportNIrow['exportcollectionsID']?>" value="<?=$exportNIrow['exportcollectionsID']?>" onChange="clearInvoiceInfo()">&nbsp;<strong>Ex&nbsp;works&nbsp;Date:</strong>&nbsp;<?=$exportNIrow['CollectionDate']?>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Amount:</strong>&nbsp;<?=$this->OrderForm->getCurrencySymbol()?><?=number_format($totalcompprice2,2)?><br>
                        <?php 
                            $totalnotinvoiced=$totalnotinvoiced + $totalcompprice2;
                        ?>
                        <br>

                <?php   
                        endforeach; 
                
                    } ?> 
                </td>
        </tr>
    </table>
    </div></div>
    <input name="totalnotinvoiced" id="totalnotinvoiced" type="hidden" value="<?=$totalnotinvoiced?>">
    <div class="clear"></div>
        <?php }  else { 
             ?>
    <!-- not export -->
   
    <table border="0" align="center" cellpadding="6" class="xview">
    <tr>
    <td valign="top">Invoice No:<br> <input name="invoiceno" type="text" id="invoiceno" size="10" maxlength="25" ></td>
    <td valign="top">Invoice Date:<br>
    <input name="invoicedate" type="text" id="invoicedate" size="10" maxlength="25" > <br>
    Choose Date |</a> <a href="javascript:clearinvoicedate();">X</a></td>
    <?php if ($purchase['balanceoutstanding'] > 0.0) { ?>
    <td valign="top">Payment: <br>
    <?=$this->OrderForm->getCurrencySymbol()?><input name="additionalpayment" type="text" id="additionalpayment" size="10" maxlength="25" >&nbsp;</td>
    <td valign="top">Payment Type:
    <br>
    <select name="paymentmethod" id="paymentmethod" onChange="paymentMethodChanged();" >
                    <option value="" >Please Select</option>
                    <?php foreach ($paymentmethods as $paymentmethod):?>
                <option value="<?= $paymentmethod['paymentmethodid'] ?>" ><?= $paymentmethod['paymentmethod'] ?> </option>  
                <?php endforeach; ?> 
                    </select>
                    <br>
                    <span id="creditdetailsheader">Enter credit details</span>
                    <br>
                    <input type="text" name="creditdetails" id="creditdetails" size="20" maxlength="50" /></td>
    <?php } ?>
    <?php if ($purchase['paymentstotal'] > 0.0) { ?>
                    <td valign="top"><strong>Refund:</strong>
                <br>
                    <?=$this->OrderForm->getCurrencySymbol()?><input name="refund" type="text" id="refund" size="10" maxlength="25" onKeyUp="checkRefundTotal()">
                    <br><strong>Refund Type: <br> </strong>
                    <select name="refundmethod" id="refundmethod">
                        <option value="" >Please Select</option>
                        <?php foreach ($paymentmethods as $paymentmethod):?>
                            <option value="<?= $paymentmethod['paymentmethodid'] ?>" ><?= $paymentmethod['paymentmethod'] ?> </option>
                        <?php endforeach; ?>
                    </select> &nbsp;</td>
                <?php } ?>
        <td></td>
    </tr>
    </table>
    </div></div>


<?php }
}

?>
<div class="clear">&nbsp;</div>
 
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
        $('#creditdetails').hide();
        $('#creditdetailsheader').hide();

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

    function pushInvoiceInfo(invno, invdate)
    {
        $("#invoiceno").val(invno);
        $("#invoicedate").val(invdate);
    }

    function clearInvoiceInfo()
    {
        $("#invoiceno").val('');
        $("#invoicedate").val('');
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

    function checkRefundTotal()
    {
        var refund = $('#refund').val() / 1.0;
        var invno = $('#invoiceno').val();
        var payments = $('#PA' + invno).val() / 1.0;
        console.log("payments=" + payments + " refund=" + refund)

        if (refund > payments)
        {
            alert("You are refunding more than has been paid for this invoice which is " + payments);
            $('#refund').val('');
        }
    }

    function clearinvoicedate() {
        $('#invoicedate').val('');
    }

   function validatePaymentsForm(theForm) {
     if (paymentsform.additionalpayment && paymentsform.additionalpayment.value != "" && paymentsform.paymentmethod.value == "") {
       alert('Please select a payment type');
       paymentsform.paymentmethod.focus();
        return false;
     }
     if (paymentsform.refund && paymentsform.refund.value != "" && paymentsform.refundmethod.value == "") {
       alert('Please select a refund payment type');
       paymentsform.refundmethod.focus();
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
                    alert("Remember to update the order otherwise the updated payments will be lost");
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
