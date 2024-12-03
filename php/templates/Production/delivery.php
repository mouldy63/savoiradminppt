<?php use Cake\Routing\Router; ?>
<div class="container" style="padding-left:20px;">
<form name="deliveryform" id="deliveryform" method="post" action="/php/Order/saveDelivery">
<input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />
<div class="form-row">
        <div class="form-group col-sm-4">
        <label for="accesscheck">Access Check Required?<br></label>  
        <select name = "accesscheck" id = "accesscheck" class="form-select deliveryfield">
              <?php
              $slctedno='';
              $slctedyes='';
              if ($purchase['accesscheck']=='No') {
                $slctedno='selected';
              }
              if ($purchase['accesscheck']=='Yes') {
                $slctedyes='selected';
              } ?>
              <option value="No" <?=$slctedno ?> >No</option> 
              <option value="Yes" <?=$slctedyes ?> >Yes</option>  
         </select>  
        </div>
       

    <div class="form-group col-sm-5">
        <label for="disposal">Disposal of Bed?<br></label>  
        <select name = "disposal" id = "disposal" class="form-select deliveryfield">
              <?php
              $slctedno='';
              $slctedyes='';
              if ($purchase['accesscheck']=='No') {
                $slctedno='selected';
              }
              if ($purchase['accesscheck']=='Yes') {
                $slctedyes='selected';
              } ?>
              <option value="" <?=$slctedno ?> >--</option>
              <option value="No" <?=$slctedno ?> >No</option> 
              <option value="Yes" <?=$slctedyes ?> >Yes</option>  
         </select>  
        </div>
        <div class="form-group form-inline col-sm-3 justify-content-end xview">
        <label for="deliveryprice">Delivery:</label>
        <?=$this->OrderForm->getCurrencySymbol()?><input style="max-width:90px;" name = "deliveryprice" type = "number" id = "deliveryprice" class="form-select deliveryfield" size = "15" value="<?= $purchase['deliveryprice'] ?>" placeholder=0 maxlength = "100">

        </div>
        
    </div>	

<div class="form-row">
    <div class="form-group col-sm-8">
    <label for="specialinstructionsdelivery">Delivery Special Instructions:</label><br>
    <textarea name = "specialinstructionsdelivery" id="specialinstructionsdelivery" class="deliveryfield"  style="width:90%" rows = "1" maxlength="250"><?= $purchase['specialinstructionsdelivery'] ?></textarea><span class="pull-right label label-default" id="deliverycount"></span>
    </div>
</div>  <!-- row end -->


<!-- <input type = "submit" name = "submit" value = "Save Delivery" id = "submit" class = "button" /> -->
</div>
<!-- container end -->
</form>

<script>
    var deliveryFieldChanged = false;
    function deliveryInit() {
        $('.showWholesale').hide();
        instructionsCount('specialinstructionsdelivery','deliverycount',250);
        overrideDeliverySubmit();

        $(".deliveryfield").on("change", function() {
            deliveryFieldChanged = true;
        });
        $(".deliveryfield").on("focus", function() {
            submitComponentForm(99);
        });
    }

    function instructionsCount(textfield,messagefieldid,maxlength) { 
        var text_length = $('#'+textfield).val().length;
        var textremaining=maxlength-text_length;
        $('#'+messagefieldid).html(textremaining + ' / ' + maxlength );
        $('#'+textfield).keyup(function() {
            var text_length = $('#'+textfield).val().length;
            textremaining = maxlength - text_length;
            $('#'+messagefieldid).html(textremaining + ' / ' + maxlength);
        });
    };


    function overrideDeliverySubmit() { 
        $('#deliveryform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Order/saveDelivery',
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
        deliveryFieldChanged = false;
    }

    function submitDeliveryForm() {
        $('#deliveryform').submit();
    }    
    
</script>
