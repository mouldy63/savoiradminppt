<?php use Cake\Routing\Router; ?>



<div id="brochureform" class="brochure">
<form action="/php/CancelOrder/cancelUpdate" method="post" name="form1" class = "sigPad" onSubmit="return FrontPage_Form1_Validator(this)">
<input name="pn" type="hidden" value="<?= $purchase['PURCHASE_No'] ?>" />
<div class="form-row">
    <div class="form-group col-sm-12">
        <h1>Do you wish to continue?<br><br>
You are about to cancel this order, and this cannot be undone.</h1>
    </div>
</div>

<a href="#" class="btn btn-info otherfield" id="cancelbutton" style="padding-right:20px;"  onclick="showCancelDiv();">Proceed to cancel order</a>
<a href="/php/Order?pn=<?=$purchase['PURCHASE_No'] ?>" class="btn btn-info otherfield" onclick="return checkPurchaseStamp(event)">Keep order - return to order</a>

<div id="showCancelDiv">
<div id="cancelDiv">
    <p>Reason for cancellation (user and date are automatically added to the field below):
    
    <textarea name="reason" cols="60" rows="6"></textarea></p>
    <p>Payments Total: <?=$this->OrderForm->getCurrencySymbol()?><?=$paymenttotal?></p>
    <?php if ($paymenttotal > 0) { ?>
			     <p>Enter Refund&nbsp;
                 <?=$this->OrderForm->getCurrencySymbol()?><input name="refund" type="text" id="refund" size="10" maxlength="25" >&nbsp;
			           <select name="refundmethod" id="refundmethod">
                       <?php foreach ($paymentmethods as $paymentmethod): 
                        ?>
                     <option value="<?= $paymentmethod['paymentmethodid'] ?>" ><?= $paymentmethod['paymentmethod'] ?> </option>  
                        <?php endforeach; ?> 
			           </select></p>

    <?php } ?>
    <br>
    <input type="submit" name="submit" value="Confirm Cancellation" class="btn btn-info otherfield" id="submit" class="button" />
    
</div>
</div>

</form>
</div>



<script>

$(document).ready(function(){
    // Hide the div initially
    $('#cancelDiv').hide();
  });

  function showCancelDiv() {
    $('#cancelDiv').show();
    $('#cancelbutton').hide();
 }

 $('#refund').blur(function() {
		var paymentsTotal = <?=$paymenttotal?>;
		var refund = $('#refund').val() / 1.0; // this makes sure we get a number
		if (refund > paymentsTotal) {
			$('#refund').val(paymentsTotal.toFixed(2));
		}
	});

</script>

<?php echo $this->Html->script('json2.min.js', array('inline' => false)); ?>