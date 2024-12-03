<?php use Cake\Routing\Router; ?>
<div class="container" style="padding-left:20px;">
<form name="valanceform" id="valanceform" method="post" action="/php/Order/saveValance">
<input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />
<div id="valance_div">
<div class="form-row">
        <div class="form-group col-sm-6">
            <label for="valancefabric">Fabric Company:</label><br>
            <input name = "valancefabric" style="width:95%" value = "<?= $purchase['valancefabric'] ?>" class="valancefield" type = "text" id = "valancefabric" maxlength = "50"  >
        </div>
        <div class="form-group col-sm-6">
            <label for="valancefabricchoice">Fabric Design, Colour & Code:</label><br>
            <input name = "valancefabricchoice" style="width:95%" value = "<?= $purchase['valancefabricchoice'] ?>" class="valancefield" type = "text" id = "valancefabricchoice" maxlength = "100"  >
        </div>
    </div>	

<div class="form-row">
        
        <div class="form-group col-sm-4">
        <label for="pleats">No. of Pleats:<br></label>  
        <select name = "pleats" id = "pleats" class="form-select valancefield">
         <?php foreach ($pleatno as $pleat): 
                $slcted=''; 
                if ($purchase['pleats']== $pleat['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $pleat['optionText'] ?>" <?=$slcted ?> ><?= $pleat['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
        </div>
        <div class="form-group col-sm-4">
        <label for="valancefabricoptions">Fabric Options:<br></label>  
        <select name = "valancefabricoptions" id = "valancefabricoptions" class="form-select valancefield">
         <?php foreach ($fabricoptions as $fabricoption): 
                $slcted=''; 
                if ($purchase['hbfabricoptions']== $fabricoption['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $fabricoption['optionText'] ?>" <?=$slcted ?> ><?= $fabricoption['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
        </div>

        <div class="form-group col-sm-4">
        <label for="valancefabricdirection">Fabric Fabric Direction:<br></label>  
        <select name = "valancefabricdirection" id = "valancefabricdirection" class="form-select valancefield">
         <?php foreach ($valancefabdirection as $valancefabdirectionrow): 
                $slcted=''; 
                if ($purchase['valancefabricdirection']== $valancefabdirectionrow['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $valancefabdirectionrow['optionText'] ?>" <?=$slcted ?> ><?= $valancefabdirectionrow['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
        </div>

        
    </div>
    
    <div class="form-row">
    <div class="form-group col-sm-4 xview">
            <label for="valfabriccost">Price Per Metre:</label><br>
            <input name = "valfabriccost" style="max-width:90px;" value = "<?= $purchase['valfabriccost'] ?>" class="valancefield" type = "number" class="xview" id = "valfabriccost" size = "15" placeholder="0" onchange="calculateValFabricTotal()">
        </div>
    <div class="form-group col-sm-4">
        <label for="valfabricmeters">Fabric Quantity (meters):</label><br> 
        <input name = "valfabricmeters" style="max-width:90px;" value = "<?= $purchase['valfabricmeters'] ?>" class="valancefield" type = "number" id = "valfabricmeters" size = "15" placeholder="0" onchange="calculateValFabricTotal()">
    </div>
    <div class="form-group col-sm-4 xview">
        <label for="valfabricprice">Fabric Price Total:</label><br>
        <input name = "valfabricprice" style="max-width:90px;" value = "<?= $purchase['valfabricprice'] ?>" class="valancefield" type = "number" class="xview" id = "valfabricprice" size = "15" placeholder="0" onchange="calculateValFabricTotal()">
    </div>
</div>

<div class="form-row">
    <div class="form-group col-sm-4">
            <label for="valancedrop">Valance Drop:</label><br>
            <input name = "valancedrop" style="max-width:90px;" value = "<?= $purchase['valancedrop'] ?>" class="valancefield" type = "number" class="xview" id = "valancedrop" size = "15" placeholder="0">
        </div>
    <div class="form-group col-sm-4">
        <label for="valancewidth">Valance Width:</label><br> 
        <input name = "valancewidth" style="max-width:90px;" value = "<?= $purchase['valancewidth'] ?>" class="valancefield" type = "number" id = "valancewidth" size = "15" placeholder="0" >
    </div>
    <div class="form-group col-sm-4">
        <label for="valancelength">Valance Length:</label><br>
        <input name = "valancelength" style="max-width:90px;" value = "<?= $purchase['valancelength'] ?>" class="valancefield" type = "number" class="xview" id = "valancelength" size = "15" placeholder="0" >
    </div>
</div>
   
<div class="form-row">
    <div class="form-group col-sm-9">
        <label for="specialinstructionsvalance">Valance Special Instructions:</label><br> 
        <textarea name = "specialinstructionsvalance" id="specialinstructionsvalance" class="valancefield"  style="width:93%" rows = "1" maxlength="250"><?= $purchase['specialinstructionsvalance'] ?></textarea><span class="pull-right label label-default" id="specialinstructionsvalancecount"></span>
    </div>
    <div class="form-group form-inline col-sm-3 justify-content-end xview">
        <label for="valanceprice">Valance&nbsp;</label><?=$this->OrderForm->getCurrencySymbol()?>
        <input style="max-width:90px;" name = "valanceprice" type = "number" id = "valanceprice" class="form-select valancefield" size = "15" value="<?= $purchase['valanceprice'] ?>" placeholder=0>

        </div>
</div> 

<div class="form-row showWholesale xview">
    <div class="col-sm-9">
    </div>
    <div class="form-group bordergris col-sm-3">
    <p align='right'><b>Wholesale Pricing</b></p>
        <p align='right'>
        Wholesale Valance&nbsp;
        <?=$this->OrderForm->getCurrencySymbol()?>    
        <input style="max-width:90px;" name = "wvalanceprice" type = "text" class="form-select valancefield" id = "wvalanceprice" size = "10" value="<?= $valancewholesaleprice ?>">
        </p>
        <p align='right'>Fabric Price per meter <?=$this->OrderForm->getCurrencySymbol()?>    
        <input style="max-width:90px;" name = "wvalancefabricprice" type = "text" class="form-select valancefield" id = "wvalancefabricprice" size = "10" value="<?= $valancefabricwholesaleprice ?>">
        </p>
    </div> 

</div>
<!-- <input type = "submit" name = "submit" value = "Save Valance" id = "submit" class = "button" /> -->
</div><!-- container end -->
</div> <!-- valance_div end -->
</form>

<script>
    var valanceFieldChanged = false;
    function valanceInit() {
        $('.showWholesale').hide();
        instructionsCount('specialinstructionsvalance','specialinstructionsvalancecount',250);
        overrideValanceSubmit();
        $(".valancefield").on("change", function() {
            valanceFieldChanged = true;
        });
        $(".valancefield").on("focus", function() {
            submitComponentForm(6);
        });
        showHideWholesale();
        disableValanceComponentSections(<?=$isComponentLocked?>, '<?=$lockColour?>');

        <?php if ($valancePoNo != '') { ?>
            $('#valancefabric').attr('disabled', 'disabled');
            $('#valancefabricchoice').attr('disabled', 'disabled');
            $('#valancefabricoptions').attr('disabled', 'disabled');
            $('#valancefabricdirection').attr('disabled', 'disabled');
            $('#valfabricmeters').attr('disabled', 'disabled');
            $('#valancedrop').attr('disabled', 'disabled');
            $('#valancewidth').attr('disabled', 'disabled');
            $('#valancelength').attr('disabled', 'disabled');
        <?php } ?>
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

    function calculateValFabricTotal() {
        var number1 = document.getElementById('valfabricmeters').value;
        var number2 = document.getElementById('valfabriccost').value;

        var total = parseFloat(number1) * parseFloat(number2);

        if (!isNaN(total)) {
            document.getElementById('valfabricprice').value = total;
        } else {
            document.getElementById('valfabricprice').value = 0;
        }
    }

    function disableValanceComponentSections(disable, lockColour) {
        if (disable) {
            $('#valancerequired_y').attr('disabled', true);
            $('#valancerequired_n').attr('disabled', true);
            $('#valance_div :input').attr('disabled', true);
            $('#valance_div :input').css('color', lockColour);
            $('.showWholesale :input').attr('disabled', false);
        }
    }

    function overrideValanceSubmit() { 
        $('#valanceform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Order/saveValance',
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
        valanceFieldChanged = false;
    }

    function submitValanceForm() {
        $('#valanceform').submit();
    }   
    
</script>
