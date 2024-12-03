<?php use Cake\Routing\Router; ?>
<div class="container" style="padding-left:20px;">
<form name="ordersummaryform" id="ordersummaryform" method="post" action="/php/Order/saveOrdersummary">
<input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />
<div class="row">
    <hr class="h-divider">
</div> 
<div class="row justify-content-center">
    <div class="col-12">
    <p align="center" style="font-weight:bold">Order Summary - Order No. <?= $purchase['ORDER_NUMBER'] ?></p> 
</div>  
<div class="row justify-content-center">
    <div class="col-auto">    
<table class="table table-responsive table-sm" style="line-height:12px;">
  <thead>
    <tr>
      <th scope="col" style="min-width:150px;">Item</th>
      <th scope="col" class="xview" style="min-width:100px; text-align:right;">Price</th>
      <th scope="col" class="xview" align='right' style="min-width:100px; text-align:right;">List Price</th>
      <th scope="col" class="xview" align='right' style="min-width:100px; text-align:right;">Discount</th>
    </tr>
  </thead>
  <tbody>
    <?php if ($mattressinc=='y') { ?>
    <tr>
      <td scope="row">Mattress</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['mattressprice']?></td>
      <?php if (isset($mattressDiscount['standardPrice']) && $mattressDiscount['standardPrice']>0) { ?>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><span id = "mattresslistpricespan"><?=$mattressDiscount['standardPrice']?></span></td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($mattressDiscount['standardPrice']-$mattressDiscount['price'],2)?></td>
      <?php } else {?>
        <td colspan=2>&nbsp;</td>
      <?php } ?>
    </tr>
    <?php } ?>
    <?php if ($topperinc=='y') { ?>
    <tr>
      <td scope="row">Topper</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['topperprice']?></td>
      <?php if (isset($topperDiscount['standardPrice']) && $topperDiscount['standardPrice']>0) { ?>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><span id = "topperlistpricespan"><?=$topperDiscount['standardPrice']?></span></td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($topperDiscount['standardPrice']-$topperDiscount['price'],2)?></td>
      <?php } else {?>
        <td colspan=2>&nbsp;</td>
      <?php } ?>
    </tr>
    <?php } ?>
    <?php if ($legsinc=='y') { ?>
    <tr>
      <td scope="row">Legs</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['legprice']?></td>
      <?php if (isset($legsDiscount['standardPrice']) && $legsDiscount['standardPrice']>0) { ?>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><span id = "legslistpricespan"><?=$legsDiscount['standardPrice']?></span></td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($legsDiscount['standardPrice']-$legsDiscount['price'],2)?></td>
      <?php } else {?>
        <td colspan=2>&nbsp;</td>
      <?php } ?>
    </tr>
    <tr>
      <td scope="row">Support Legs</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['addlegprice']?></td>
      <?php if (isset($addLegsDiscount['standardPrice']) && $addLegsDiscount['standardPrice']>0) { ?>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><span id = "addlegslistpricespan"><?=$addLegsDiscount['standardPrice']?></span></td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($addLegsDiscount['standardPrice']-$addLegsDiscount['price'],2)?></td>
      <?php } else {?>
        <td colspan=2>&nbsp;</td>
      <?php } ?>
    </tr>
    <?php } ?>
    <?php if ($baseinc=='y') { ?>
    <tr>
      <td scope="row">Base</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['baseprice']?></td>
      <?php if (isset($baseDiscount['standardPrice']) && $baseDiscount['standardPrice']>0) { ?>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><span id = "baselistpricespan"><?=$baseDiscount['standardPrice']?></span></td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($baseDiscount['standardPrice']-$baseDiscount['price'],2)?></td>
      <?php } else {?>
        <td colspan=2>&nbsp;</td>
      <?php } ?>
    </tr>
        <?php if ($purchase['upholsteredbase']=='TBC' || $purchase['upholsteredbase']=='Yes' || $purchase['upholsteredbase']=='Yes, Com') { ?>
        <tr>
        <td scope="row">Upholstered Base</td>
        <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['upholsteryprice']?></td>
        <?php if (isset($baseUpholsteryDiscount['standardPrice']) && $baseUpholsteryDiscount['standardPrice']>0) { ?>
          <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><span id = "upholsterylistpricespan"><?=$baseUpholsteryDiscount['standardPrice']?></span></td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($baseUpholsteryDiscount['standardPrice']-$baseUpholsteryDiscount['price'],2)?></td>
        <?php } else {?>
        <td colspan=2>&nbsp;</td>
        <?php } ?>
        </tr>
        <?php } ?>
    <tr>
      <td scope="row">Base Trim</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['basetrimprice']?></td>
      <?php if (isset($baseTrimDiscount['standardPrice']) && $baseTrimDiscount['standardPrice']>0) { ?>
        <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><span id = "basetrimlistpricespan"><?=$baseTrimDiscount['standardPrice']?></span></td>
        <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($baseTrimDiscount['standardPrice']-$baseTrimDiscount['price'],2)?></td>
        <?php } else {?>
          <td colspan=2>&nbsp;</td>
        <?php } ?>
    </tr>
    <tr>
      <td scope="row">Base Drawers</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['basedrawersprice']?></td>
      <?php if (isset($baseDrawersDiscount['standardPrice']) && $baseDrawersDiscount['standardPrice']>0) { ?>
        <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><span id = "basedrawerslistpricespan"><?=$baseDrawersDiscount['standardPrice']?></span></td>
        <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($baseDrawersDiscount['standardPrice']-$baseDrawersDiscount['price'],2)?></td>
        <?php } else {?>
          <td colspan=2>&nbsp;</td>
        <?php } ?>
    </tr>
    <tr>
      <td scope="row">Base Fabric</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['basefabricprice']?></td>
      <?php if (isset($baseFabricDiscount['standardPrice']) && $baseFabricDiscount['standardPrice']>0) { ?>
        <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><span id = "basefabriclistpricespan"><?=$baseFabricDiscount['standardPrice']?></span></td>
        <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($baseFabricDiscount['standardPrice']-$baseFabricDiscount['price'],2)?></td>
        <?php } else {?>
          <td colspan=2>&nbsp;</td>
        <?php } ?>
    </tr>
    <?php } ?>
    <?php if ($hbinc=='y') { ?>
    <tr>
      <td scope="row">Headboard</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['headboardprice']?></td>
      <?php if (isset($headboardDiscount['standardPrice']) && $headboardDiscount['standardPrice']>0) { ?>
        <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><span id = "headboardlistpricespan"><?=$headboardDiscount['standardPrice']?></span></td>
        <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($headboardDiscount['standardPrice']-$headboardDiscount['price'],2)?></td>
        <?php } else {?>
          <td colspan=2>&nbsp;</td>
        <?php } ?>
    </tr>
   <tr>
      <td scope="row">Headboard Fabric</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['hbfabricprice']?></td>
      <td class="xview" align='right'></td>
      <td class="xview" align='right'></td>
    </tr> 
    <tr>
      <td scope="row">Headboard Trim</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['headboardtrimprice']?></td>
      <?php if (isset($headboardTrimDiscount['standardPrice']) && $headboardTrimDiscount['standardPrice']>0) { ?>
        <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><span id = "headboardtrimlistpricespan"><?=$headboardTrimDiscount['standardPrice']?></span></td>
        <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($headboardTrimDiscount['standardPrice']-$headboardTrimDiscount['price'],2)?></td>
        <?php } else {?>
          <td colspan=2>&nbsp;</td>
        <?php } ?>
    </tr> 
    <?php } ?>
    <?php if ($valanceinc=='y') { ?>
    <tr>
      <td scope="row">Valance</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['valanceprice']?></td>
      <td class="xview" align='right'></td>
      <td class="xview" align='right'></td>
    </tr>
   <tr>
      <td scope="row">Valance Fabric</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['valfabricprice']?></td>
      <td class="xview" align='right'></td>
      <td class="xview" align='right'></td>
    </tr> 
   
    <?php } ?>
    <?php if ($accinc=='y') { ?>
    <tr>
      <td scope="row">Accessories</td>
      <td class="xview" align='right'><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['accessoriestotalcost']?></td>
      <td class="xview" align='right'></td>
      <td class="xview" align='right'></td>
    </tr>
    <?php } ?>
    <tr>
      <th scope="row">Bed Set Total</th>
      <td class="xview" align='right'>
            <?=$this->OrderForm->formatCurrency($purchase['bedsettotal'])?>
            <input type="hidden" name="bedsettotal" id="bedsettotal" value="<?=$purchase['bedsettotal']?>" />
        </td>
      <td class="xview" align='right'></td>
      <td class="xview" align='right'></td>
    </tr>
    <tr id = "dceditdiv" class="xview">
        <td><button type = "button" class="xview summaryfield" onClick = "showHideDiscounts(true);">Edit DC</button></td>
        <td>&nbsp;
        </td>
        <td>&nbsp;
        </td>
        <td>&nbsp;
        </td>
    </tr>
    <tr id = "dcremovediv" class="xview">
        <td><button type = "button" class="xview summaryfield" onClick = "showHideDiscounts(false);">Remove DC</button></td>
        <td>&nbsp;
        </td>
        <td>&nbsp;
        </td>
        <td>&nbsp;
        </td>
    </tr>

    <tr id = "dcdiv" class="xview">
        <td>
            DC &nbsp;&nbsp; %

            <input type = "radio" name = "dc" class="xview summaryfield" id = "dc" value = "percent" <?php if ($purchase["discounttype"]=="percent") echo 'checked' ?> >
            &nbsp;&nbsp; <?=$this->OrderForm->getCurrencySymbol()?>

            <input type = "radio" name = "dc" class="xview summaryfield" id = "dc2" value = "currency" <?php if ($purchase["discounttype"]=="currency") echo 'checked' ?> >
        </td>

        <td>
            <label>
            <input name = "dcresult" type = "text" class="xview summaryfield" id = "dcresult"
                value = "<?= $purchase['discount'] ?>" size = "10"
                maxlength = "25"></label>
        </td>
        <td>&nbsp;
        </td>
        <td>&nbsp;
        </td>

    </tr>
    <tr class="xview">
      <td scope="row">Sub Total</td>
      <td>
        <span id="subtotalspan"><?=$this->OrderForm->formatCurrency($purchase['subtotal'])?></span>
        <input type="hidden" name="subtotal" id="subtotal" value="<?=$purchase['subtotal']?>" />
      </td>
      <td></td>
      <td></td>
    </tr>
    <?php if ($purchase['istrade']=='y' && $purchase['tradediscountrate']>0) { ?>
    <tr class="xview">
      <td scope="row" class="xview">Trade Discount (<?=$purchase['tradediscountrate']?>%)</td>
      <td>
        <span id="tradediscountspan"></span>
        <input type="hidden" name="tradediscount" id="tradediscount" />
        <input type="hidden" name="tradediscountrate" id="tradediscountrate" value="<?=$purchase['tradediscountrate']?>" />
      </td>
      <td></td>
      <td></td>
    </tr>
<?php } ?>
<tr>
      <td scope="row">Delivery Charge</td>
      <td class="xview">
          <?=$this->OrderForm->formatCurrency($purchase['deliveryprice'])?>
          <input type="hidden" name="deliveryprice" id="deliveryprice" value="<?=$purchase['deliveryprice']?>" />
      </td>
      <td class="xview"></td>
      <td class="xview"></td>
    </tr>
    <tr class="xview">
      <td scope="row"><?php echo $OrderTotalExVAT ?></td>
      <td>
        <span id="totalexvatspan"><?=$this->OrderForm->formatCurrency($purchase['totalexvat'])?></span>
        <input type="hidden" name="totalexvat" id="totalexvat" value="<?=$purchase['totalexvat']?>" />
      </td>
      <td></td>
      <td></td>
    </tr>
    <tr class="xview">
      <td scope="row"><?php echo $VATWording ?></td>
      <td>
        <span id="vatspan"><?=$this->OrderForm->formatCurrency($purchase['vat'])?></span>
        <input type="hidden" name="vat" id="vat" value="<?=$purchase['vat']?>" />
      </td>
      <td></td>
      <td></td>
    </tr>

    <tr style="height:50px;" class="xview">
      <th scope="row">TOTAL</th>
      <td>
        <span id="totalspan"><?=$this->OrderForm->formatCurrency($purchase['total'])?></span>
        <input type="hidden" name="total" id="total" value="<?=$purchase['total']?>" />
      </td>
      <td></td>
      <td></td>
    </tr>
   
  </tbody>
</table>
<?php if (count($paymentsfororder)>0) { ?> 
<table class="table table-responsive table-sm xview" style="line-height:12px;">
  <thead>
  <tr>
      <th scope="col" colspan='8'>Payments / Refunds</th>
    </tr>
    <tr>
      <th scope="col">Type</th>
      <th scope="col">Payment Method</th>
      <th scope="col">Invoice Date</th>
      <th scope="col">Invoice No</th>
      <th scope="col">Date</th>
      <th scope="col">Receipt No.</th>
      <th scope="col">Amount</th>
      <th scope="col">Credit Details</th>
    </tr>
    

  </thead>
  <tbody>
  <?php foreach ($paymentsfororder as $payment): 
  if (isset($payment['invoicedate'])) {
    $invoicedate = date('d/m/Y', strtotime($payment['invoicedate']));
  } else {
    $invoicedate = '';
  }
  if (isset($payment['placed'])) {
    $dateplaced = date('d/m/Y', strtotime($payment['placed']));
  } else {
    $dateplaced = '';
  }
  ?>
    <tr>
      <td scope="col"><?=$payment['paymenttype']?></td>
      <td scope="col"><?=$payment['paymentmethod']?></td>
      <td scope="col"><?=$invoicedate?></td>
       <?php if ($payment['invoice_number']!='') { ?>
          <td scope="col"><?=$payment['invoice_number']?></td>
          <?php } else { ?>
          <td scope="col"><input class="summaryfield" name = "invono_<?= $payment['paymentid']?>" id = "invono_<?= $payment['paymentid']?>"type="text" size = "5"></td>
       <?php } ?>                                                                                        
      <td scope="col"><?=$dateplaced?></td>
      <td scope="col"><?=$payment['receiptno']?></td>
      <td scope="col"><?=$payment['amount']?></td>
      <td scope="col"><?=$payment['creditdetails']?></td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>
<?php } ?>
<table class="table table-responsive table-sm xview" style="line-height:12px;">
  
  <tbody>
    <tr>
      <th scope="row" style="min-width:150px;">Balance Outstanding</th>
      <td><?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['balanceoutstanding']?></td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th scope="row">Amount Invoiced</th>
      <td><?=$this->OrderForm->getCurrencySymbol()?><?=$paymentsTotal ?></td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <th scope="row">Amount Not Invoiced</th>
      <td><?=$this->OrderForm->getCurrencySymbol()?><?=number_format($notinvoiced,2)?></td>
      <td></td>
      <td></td>
    </tr>
  </tbody>
</table>

    </div></div>
 
</form>

</div>
<script>
    var summaryFieldChanged = false;
    function ordersummaryInit() {
    
        overrideOrdersummarySubmit();

        $(".summaryfield").on("change", function() {
            summaryFieldChanged = true;
        });
        $(".summaryfield").on("click", function() {
            summaryFieldChanged = true;
        });
        $(".summaryfield").on("focus", function() {
            submitComponentForm(98);
        });
    }

    function overrideOrdersummarySubmit() { 
        $('#ordersummaryform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Order/saveOrdersummary',
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
        summaryFieldChanged = false;
    }

  showHideDiscounts($('#dcresult').val() != "");

  $('#dcresult').blur(function()
{
    calcSubtotal();
});

$('#dc').change(function()
{
    calcSubtotal();
});

$('#dc2').change(function()
{
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
        } else {
            $('#subtotalspan').html(getCurrSym() + (bedsettotal * 1.0).toFixed(2));
            $('#subtotal').val((bedsettotal * 1.0).toFixed(2));
        }
        setTotal();
    }

    function setTotal() {
        var deliveryPrice = $('#deliveryprice').val() * 1.0;
        var total = $('#subtotal').val() * 1.0;
        <?php if ($purchase['istrade']=='y') { ?>
            var jsIsTrade = true;
            var jsTradeDiscountRate = <?=$purchase['tradediscountrate']?>;
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
  
    function setOutstanding() {
        var outstanding = $('#total').val() * 1.0 - $('#deposit').val() * 1.0;
        $('#outstandingspan').html(getCurrSym() + outstanding.toFixed(2));
        $('#outstanding').val(outstanding.toFixed(2));
    }

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

    function submitOrdersummaryForm() {
        $('#ordersummaryform').submit();
    }  
    
    function getCurrSym() {
        return '<?=$this->OrderForm->getCurrencySymbol()?>';
    }
    
</script>
