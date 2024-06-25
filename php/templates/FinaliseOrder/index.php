<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure">
<form action="/php/FinaliseOrder/finaliseupdate" method="post" name="form1" class = "sigPad" onSubmit="return validateForm(this)">
<input name="pn" type="hidden" value="<?= $purchase['PURCHASE_No'] ?>" />
<div class="form-row">
    <div class="form-group col-sm-12">
        <h1>Order Summary - Order No. <?= $orderno ?> - <?= $custname ?></h1>
    </div>
</div>
<table class="table table-striped" style="width: 92%; margin-left:40px">
  <thead>
    <tr>
      <th scope="col">Item</th>
      <th scope="col">Price Charged</th>
      <?php if ($priceMatrixEnabled=='y') { ?>
      <th scope="col">Discount</th>
      <th scope="col">Percentage</th>
      <th scope="col">List Price</th>
      <?php } ?>
    </tr>
  </thead>
  <tbody>
    <?php if ($purchase['mattressrequired']=='y') { ?>
        <?= $this->element('finaliseOrderComponent', ['title'=>'Mattress', 'price'=>$purchase['mattressprice'], 'discountObj'=>$mattressDiscount, 'listPriceSpanId'=>'mattresslistpricespan', 'pmEnabled'=>$priceMatrixEnabled, 'formHelper'=>$this->OrderForm]) ?>
    <?php } ?>
    <?php if ($purchase['topperrequired']=='y') { ?>
        <?= $this->element('finaliseOrderComponent', ['title'=>'Topper', 'price'=>$purchase['topperprice'], 'discountObj'=>$topperDiscount, 'listPriceSpanId'=>'topperlistpricespan', 'pmEnabled'=>$priceMatrixEnabled, 'formHelper'=>$this->OrderForm]) ?>
    <?php } ?>
    <?php if ($purchase['legsrequired']=='y') { ?>
        <?= $this->element('finaliseOrderComponent', ['title'=>'Legs', 'price'=>$purchase['legprice'], 'discountObj'=>$legsDiscount, 'listPriceSpanId'=>'legslistpricespan', 'pmEnabled'=>$priceMatrixEnabled, 'formHelper'=>$this->OrderForm]) ?>
        <?php if (isset($purchase['AddLegQty']) && $purchase['AddLegQty']>0) { ?>
            <?= $this->element('finaliseOrderComponent', ['title'=>'Support Legs', 'price'=>$purchase['addlegprice'], 'discountObj'=>$addLegsDiscount, 'listPriceSpanId'=>'addlegslistpricespan', 'pmEnabled'=>$priceMatrixEnabled, 'formHelper'=>$this->OrderForm]) ?>
        <?php } ?>
    <?php } ?>
    <?php if ($purchase['baserequired']=='y') { ?>
        <?= $this->element('finaliseOrderComponent', ['title'=>'Base Fabric Price', 'price'=>$purchase['basefabricprice'], 'discountObj'=>$baseFabricDiscount, 'listPriceSpanId'=>'basefabriclistpricespan', 'pmEnabled'=>$priceMatrixEnabled, 'formHelper'=>$this->OrderForm]) ?>
        <?= $this->element('finaliseOrderComponent', ['title'=>'Base', 'price'=>$purchase['baseprice'], 'discountObj'=>$baseDiscount, 'listPriceSpanId'=>'baselistpricespan', 'pmEnabled'=>$priceMatrixEnabled, 'formHelper'=>$this->OrderForm]) ?>
        <?= $this->element('finaliseOrderComponent', ['title'=>'Upholstered Base', 'price'=>$purchase['upholsteryprice'], 'discountObj'=>$baseUpholsteryDiscount, 'listPriceSpanId'=>'baseuphpricespan', 'pmEnabled'=>$priceMatrixEnabled, 'formHelper'=>$this->OrderForm]) ?>
        <?= $this->element('finaliseOrderComponent', ['title'=>'Base Trim', 'price'=>$purchase['basetrimprice'], 'discountObj'=>$baseTrimDiscount, 'listPriceSpanId'=>'basetrimpricespan', 'pmEnabled'=>$priceMatrixEnabled, 'formHelper'=>$this->OrderForm]) ?>
        <?= $this->element('finaliseOrderComponent', ['title'=>'Base Drawers', 'price'=>$purchase['drawerprice'], 'discountObj'=>$baseDrawersDiscount, 'listPriceSpanId'=>'basedrawerslistpricespan', 'pmEnabled'=>$priceMatrixEnabled, 'formHelper'=>$this->OrderForm]) ?>
    <?php } ?>
    <?php if ($purchase['headboardrequired']=='y') { ?>
        <?= $this->element('finaliseOrderComponent', ['title'=>'Headboard', 'price'=>$purchase['headboardprice'], 'discountObj'=>$headboardDiscount, 'listPriceSpanId'=>'headboardpricespan', 'pmEnabled'=>$priceMatrixEnabled, 'formHelper'=>$this->OrderForm]) ?>
        <?= $this->element('finaliseOrderComponent', ['title'=>'Headboard Trim', 'price'=>$purchase['headboardtrimprice'], 'discountObj'=>$headboardTrimDiscount, 'listPriceSpanId'=>'headboardtrimpricespan', 'pmEnabled'=>$priceMatrixEnabled, 'formHelper'=>$this->OrderForm]) ?>
        <tr>
        <th scope="row">Headboard Fabric Price</th>
        <td><?=$this->OrderForm->formatCurrency($purchase['hbfabricprice'])?></td>
        <?php if ($priceMatrixEnabled=='y') { ?>
        <td></td>
        <td></td>
        <td></td>
        <?php } ?>
        </tr>
    <?php } ?>
    <?php if ($purchase['valancerequired']=='y') { ?>
        <tr>
        <th scope="row">Valance</th>
        <td><?=$this->OrderForm->formatCurrency($purchase['valanceprice'])?></td>
        <?php if ($priceMatrixEnabled=='y') { ?>
        <td></td>
        <td></td>
        <td></td>
        <?php } ?>
        </tr>
        <tr>
        <th scope="row">Valance Fabric Price</th>
        <?php if ($priceMatrixEnabled=='y') { ?>
        <td></td>
        <td></td>
        <td></td>
        <?php } ?>
        </tr>
    <?php } ?>
    <?php if ($purchase['accessoriesrequired']=='y') { ?>
        <tr>
        <th scope="row">Accessories</th>
        <td><?=$this->OrderForm->formatCurrency($purchase['accessoriestotalcost'])?></td>
        <?php if ($priceMatrixEnabled=='y') { ?>
        <td></td>
        <td></td>
        <td></td>
        <?php } ?>
        </tr>
    <?php } ?>
    <tr>
        <th scope="row">Bed Set Total</th>
        <td>
            <?=$this->OrderForm->formatCurrency($purchase['bedsettotal'])?>
            <input type="hidden" name="bedsettotal" id="bedsettotal" value="<?=$purchase['bedsettotal']?>" />
        </td>
        <?php
        if ($priceMatrixEnabled=='y') { 
            ?>
            <td><?=$this->OrderForm->formatCurrency($totalDiscount)?></td>
            <td>
                <?php
                $discountamt=0;
                if ($totalListPrice > 0) {
                    $discountamt=100*$totalDiscount/$totalListPrice; 
                }
                ?>
                <?= $this->OrderForm->formatPercent($discountamt) ?>
            </td>
            <td><?=$this->OrderForm->formatCurrency($totalListPrice)?></td>
        <?php } ?>
    </tr>
    </tbody>
</table>
<table style="width: 92%; margin-left:40px; max-width:370px;">
<tr id = "dceditdiv" class="xview">
    <td><button type = "button" class="xview" onClick = "showHideDiscounts(true);">Edit DC</button>
    </td>
</tr>

<tr id = "dcremovediv" class="xview">
    <td><button type = "button" class="xview" onClick = "showHideDiscounts(false);">Remove DC</button>
    </td>
</tr>

<tr id = "dcdiv" class="xview">
    <td>DC &nbsp;&nbsp; % 
        <?php if ($purchase['discounttype']=='currency') {
            $currencyChked='checked';
        } else {
            $currencyChked='';
        }
        if (!isset($purchase['discounttype']) || $purchase['discounttype']=='percent') {
            $percentChked='checked';
        } else {
            $percentChked='';
        }?>
        <input type="radio" name="dc" id="dc1" value="percent" <?=$percentChked?> >
            &nbsp;&nbsp; <?=$this->OrderForm->getCurrencySymbol()?>
        <input type="radio" name="dc" id="dc2" value="currency" <?=$currencyChked?> >
    </td>
    <td><label><input name = "dcresult" type = "text" id = "dcresult" size = "10" maxlength = "25" value = "<?= $purchase['discount'] ?>"></label>
    </td>
</tr>

    <tr>
        <th scope="row">Sub Total</th>
        <td>
            <span id="subtotalspan"><?=$this->OrderForm->formatCurrency($purchase['bedsettotal'])?></span>
            <input type="hidden" name="subtotal" id="subtotal" value="<?=$purchase['bedsettotal']?>" />
        </td>
    </tr>
    <?php if ($purchase['istrade']=='y') { ?>
        <?php if ($tradeDiscountRate > 0) { ?>
            <tr>
                <td>Trade Discount (<?=$tradeDiscountRate?>%)</td>
                <td>
                    <span id="tradediscountspan"></span>
                    <input type="hidden" name="tradediscount" id="tradediscount" />
                    <input type="hidden" name="tradediscountrate" id="tradediscountrate" value="<?=$tradeDiscountRate?>" />
                </td>
            </tr>
        <?php } ?>
		<tr>
            <td>Delivery Charge</td>
            <td>
                <?=$this->OrderForm->formatCurrency($purchase['deliveryprice'])?>
                <input type="hidden" name="deliveryprice" id="deliveryprice" value="<?=$purchase['deliveryprice']?>" />
            </td>
        </tr>
        <tr>
            <td><?=$OrderTotalExVAT?></td>
            <td>
                <span id="totalexvatspan"><?=$this->OrderForm->formatCurrency($purchase['totalexvat'])?></span>
                <input type="hidden" name="totalexvat" id="totalexvat" value="<?=$purchase['totalexvat']?>" />
            </td>
        </tr>
        <tr>
            <td><?=$vatWording?></td>
            <td>
                <span id="vatspan"><?=$this->OrderForm->formatCurrency($purchase['vat'])?></span>
                <input type="hidden" name="vat" id="vat" value="<?=$purchase['vat']?>" />
            </td>
        </tr>
    <?php } else { ?>
		<tr>
		    <td>Delivery Charge</td>
			<td>
                <?=$this->OrderForm->formatCurrency($purchase['deliveryprice'])?>
			    <input type="hidden" name="deliveryprice" id="deliveryprice" value="<?=$purchase['deliveryprice']?>" />
			</td>
		</tr>
        <tr>
            <td><?=$OrderTotalExVAT?></td>
            <td>
                <span id="totalexvatspan"><?=$this->OrderForm->formatCurrency($purchase['totalexvat'])?></span>
                <input type="hidden" name="totalexvat" id="totalexvat" value="<?=$purchase['totalexvat']?>" />
            </td>
        </tr>
        <tr>
            <td><?=$vatWording?></td>
            <td>
                <span id="vatspan"><?=$this->OrderForm->formatCurrency($purchase['vat'])?></span>
                <input type="hidden" name="vat" id="vat" value="<?=$purchase['vat']?>" />
            </td>
        </tr>
  <?php } ?>


    <tr>
        <th scope="row">TOTAL</th>
        <td>
            <span id="totalspan"><?=$this->OrderForm->formatCurrency($purchase['total'])?></span>
            <input type="hidden" name="total" id="total" value="<?=$purchase['total']?>" />
        </td>
    </tr>
    <tr><th scope="row">Deposit Paid</th><td><input name="deposit" type="text" id="deposit" size="10" maxlength="25"></td></tr>
    <tr>
        <th scope="row">Balance Outstanding</th>
        <td>
            <span id="outstandingspan"><?=$this->OrderForm->formatCurrency($purchase['balanceoutstanding'])?></span>
            <input type="hidden" name="outstanding" id="outstanding" value="<?=$purchase['balanceoutstanding']?>" />
        </td>
    </tr>
    <?php if (!$hidePaymentType) { ?>
        <tr><td><span id="creditdetailsheader">Enter credit details</span></td></tr>
        <tr>
            <th scope="row">Payment Method</th>
            <td>
                <select name="paymentmethod" id="paymentmethod" onChange="paymentMethodChanged()" >
                    <option value="n" >Please Select</option>
                    <?php foreach ($paymentmethods as $paymentmethod):?>
                        <option value="<?= $paymentmethod['paymentmethodid'] ?>" ><?= $paymentmethod['paymentmethod'] ?> </option>  
                    <?php endforeach; ?> 
                </select>
            </td>
            <td><input type="text" name="creditdetails" id="creditdetails" size="30" maxlength="50" /></td>
        </tr>
    <?php } else { ?>
        <input name="paymentmethod" value="5" type="hidden" id="paymentmethod" />
    <?php } ?>
    <tr><th  scope="row">Dispose of Old Bed</th><td><?= $purchase['oldbed']?></td></tr>
</table>
<div id="terms" style="margin-right:30px; margin-left:40px; font-size:11px; line-height: 14px;">
<?php if ($terms != '') {
    echo $terms;
}?>
<label><input name = "terms" type = "checkbox" id = "terms" value = "terms">
    I have read and understood, the terms and conditions above</label>
    <b>Customer Signature</b>
<br>
<br>
Print your name:

<input type = "text" name = "name" id = "name"
    value = "<?= $custname ?>"
<p class = "drawItDesc">Draw your signature</p>

<ul class = "sigNav">
    <li class = "clearButton"><a href = "#clear">Clear</a></li>
    <li class = "drawIt"><a href = "#draw-it">Please sign below</a></li>
</ul>

<div class = "sig sigWrapper">
    <div class = "typed"></div>

    <canvas class = "pad" width = "298" height = "55">
    </canvas>

    <input type = "hidden" name = "output" id = "output"
        class = "output">
</div>
<input type = "submit" name = "addorder" id = "addorder"  value = "PLACE ORDER">
<input type = "submit" name = "holdorder" id = "holdorder" value = "HOLD ORDER">
</form>
</div>

<?php echo $this->Html->script('json2.min.js', array('inline' => false)); ?>
<script>
    function IsNumeric(sText) {
        var ValidChars = "0123456789.";
        var IsNumber = true;
        var Char;

        for (i = 0; i < sText.length && IsNumber == true; i++) {
            Char = sText.charAt(i);
            if (ValidChars.indexOf(Char) == -1) {
                IsNumber = false;
            }
        }
        return IsNumber;
    }
       
    function validateForm(theForm) {
        if (theForm.terms && theForm.terms.checked == false) {
           alert("Please accept the terms and conditions");
           theForm.terms.focus();
           return (false);
        }
        
        if (!IsNumeric(theForm.dcresult.value)) { 
            alert('Please enter only numbers for DC section');
            theForm.dcresult.focus();
            return false; 
        }		
       
        if (theForm.deposit && !IsNumeric(theForm.deposit.value)) { 
            alert('Please enter only numbers for the deposit');
            theForm.deposit.focus();
            return false; 
        }	
             
       // require that the total Field be greater than the deposit Field
       if (theForm.deposit && theForm.total) {
           var chkVal = theForm.deposit.value/1.0;
           var chkVal2 = theForm.total.value/1.0;
           if (chkVal > chkVal2) {
               alert("The deposit cannot be greater than the total: " + chkVal + "," + chkVal2);
               theForm.deposit.focus();
               return false;
           }
       }

       return true;
    } 
       
</script>

<?php if ($purchase['ordertype']==1) { ?>
    <script>
        $(document).ready(function() {
            $('.sigPad').signaturePad({
                drawOnly: true
            });
        });
    </script>
<?php } ?>

<script>
    var vatRateJs;
    var isTradeJs;
    $(document ).ready(init());

    function init() {
        calcSubtotal();
        showHideCreditDetails(false);
        vatRateJs = <?=$purchase['vatrate']?>;
        <?php if ($purchase['istrade']=='y') { ?>
            isTradeJs = "y";
        <?php } else { ?>
            isTradeJs = "n";
        <?php } ?>
    }

    $('#dcresult').blur(function() {
        calcSubtotal();
    });

    $('#dc1').change(function() {
        calcSubtotal();
    });

    $('#dc2').change(function() {
        calcSubtotal();
    });

    function calcSubtotal() {
        var dcType = $('input[name="dc"]:checked').val();
        var discount = $('#dcresult').val() / 1.0; // this makes sure we get a number
        var bedsettotal = $('#bedsettotal').val();

        if (discount > 0.0) {
            var subtotal;

            if (dcType == 'percent') {
                subtotal = bedsettotal * (1.0 - discount / 100.0);
            } else {
                subtotal = bedsettotal - discount;
            }
            $('#subtotalspan').html(getCurrSym() + subtotal.toFixed(2));
            $('#subtotal').val(subtotal.toFixed(2));
        } else{
            $('#subtotalspan').html(getCurrSym() + (bedsettotal * 1.0).toFixed(2) );
            $('#subtotal').val((bedsettotal * 1.0).toFixed(2) );
        }
        setTotal();
    }

    function setTotal() {
        var deliveryPrice = $('#deliveryprice').val() * 1.0;
        var total = $('#subtotal').val() * 1.0;
        <?php if ($purchase['istrade']=='y') { ?>
            var jsIsTrade = true;
            var jsTradeDiscountRate = <?=$tradeDiscountRate?>;
        <?php } else { ?>
            var jsIsTrade = false;
        <?php } ?>
        var jsVatRate = <?=$purchase['vatrate']?>;
        var jsDelIncVat = true;
        <?php if (!$deliveryIncludesVat) { ?>
            jsDelIncVat = false;
        <?php } ?>

        if(jsIsTrade) {
            if (jsTradeDiscountRate > 0) {
                var tradeDiscount = total * jsTradeDiscountRate / 100.0;
                total = total - tradeDiscount;
                $('#tradediscountspan').html(getCurrSym() + tradeDiscount.toFixed(2));
                $('#tradediscount').val((tradeDiscount).toFixed(2));
            }
            if (jsDelIncVat) {
                total = total + deliveryPrice;
                var totalExVat = total;
                var vat = totalExVat * jsVatRate / 100.0;
                total = totalExVat + vat;
            } else {
                var vat = total * jsVatRate / 100.0;
                var totalExVat = total + deliveryPrice;
                total = totalExVat + vat;
            }
        } else {
            if (jsDelIncVat) {
                total = total + deliveryPrice;
                var totalExVat = total / (1 + jsVatRate / 100.0);
                var vat = total - totalExVat;
            } else {
                var totalExVat = total / (1 + jsVatRate / 100.0) + deliveryPrice;
                total = total + deliveryPrice;
                var vat = total - totalExVat;
            }
        }
        
        $('#totalexvatspan').html(getCurrSym() + totalExVat.toFixed(2));
        $('#totalexvat').val(totalExVat.toFixed(2));
        $('#vatspan').html(getCurrSym() + vat.toFixed(2));
        $('#vat').val((vat).toFixed(2));
        $('#totalspan').html(getCurrSym() + total.toFixed(2));
        $('#total').val((total).toFixed(2));
        setOutstanding();
    }

    function getCurrSym() {
        return '<?=$this->OrderForm->getCurrencySymbol()?>';
    }

    $('#deposit').blur(function() {
        setOutstanding();
    });

    function setOutstanding() {
        var outstanding = $('#total').val() * 1.0 - $('#deposit').val() * 1.0;
        $('#outstandingspan').html(getCurrSym() + outstanding.toFixed(2));
        $('#outstanding').val(outstanding.toFixed(2));
    }

    <?php if ($converttoorder == "y") { ?>
        showHideDiscounts(true);
    <?php } else { ?>
        showHideDiscounts(false);
    <?php } ?>


    function showHideDiscounts(show) {
        if (show) {
            $('#dceditdiv').hide();
            $('#dcremovediv').show();
            $('#dcdiv').show();
        } else {
            $('#dcresult').val('');
            $('#dcresult').blur();
            $('#dcremovediv').hide();
            $('#dcdiv').hide();
            $('#dceditdiv').show();
        }
    }

    function paymentMethodChanged() {
        var selection = $("#paymentmethod").val();

        if (selection == "7") {
            // Customer Credit
            showHideCreditDetails(true);
        } else {
            showHideCreditDetails(false);
            $("#creditdetails" ).val("");
        }
    }

    function showHideCreditDetails(show) {
        if (show) {
            $('#creditdetails').show();
            $('#creditdetailsheader').show();
        } else {
            $('#creditdetails').hide();
            $('#creditdetailsheader').hide();
        }
    }
</script>
