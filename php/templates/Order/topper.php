<?php use Cake\Routing\Router; ?>

<form name="topperform" id="topperform" method="post" action="/php/Order/saveTopper" style="padding:5px;">
<input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />
<input type = "hidden" name = "topperlistprice" id = "topperlistprice" value = "<?=$topperDiscount['standardPrice']?>" onchange = "setTopperPrice();" />
<div id="topper_div">
	<div class="form-row">
        <div class="form-group col-sm-2">
        <label for="toppertype">Topper Type:<br></label>    
        
          <p><select name = "toppertype" class="form-select topperfield"  id = "toppertype" onchange = "showtoppertickingoptions(); getTopperListPrice(); toppervegantext(); getMadeAt();" >
          <option value="TBC">TBC</option>  
        <?php foreach ($toppernames as $toppername): 
                $slcted=''; 
                if ($purchase['toppertype']== $toppername['COMPONENTNAME']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $toppername['COMPONENTNAME'] ?>" <?=$slcted ?> ><?= $toppername['COMPONENTNAME'] ?> </option>  
              <?php endforeach; ?> 
        </select>     
        </div> 
        <div class="form-group col-sm-2">
        <label for="topperwidth">Topper Width:</br></label>    
        
            <select name = "topperwidth" class="form-select topperfield" id = "topperwidth" onChange = "topperspecialwidthSelected(true); getTopperListPrice();">
                <?php foreach ($compwidths as $compwidth): 
                    $slcted=''; 
                    if ($purchase['topperwidth']== $compwidth['componentDim']) {
                        $slcted='selected';
                    } 
                ?>
                <option value="<?= $compwidth['componentDim'] ?>" <?=$slcted ?> ><?= $compwidth['componentDim'] ?> </option>  
                <?php endforeach; ?> 
                </select> 
        </div>
        <div class="form-group col-sm-2">
        <label for="topperlength">Topper Length:</br></label>    
        <select name = "topperlength" class="form-select topperfield" id = "topperlength"  onChange = "topperspeciallengthSelected(true); getTopperListPrice();">
         <?php foreach ($complengths as $complength): 
                $slcted=''; 
                if ($purchase['topperlength']== $complength['componentDim']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $complength['componentDim'] ?>" <?=$slcted ?> ><?= $complength['componentDim'] ?> </option>  
              <?php endforeach; ?> 
         </select>
        </div>
        <div class="form-group col-sm-4">
        <label for="toppertickingoptions">Ticking Options:</br></label>    
        <select name = "toppertickingoptions" class="form-select topperfield" id = "toppertickingoptions" onChange = "defaultTopperTickingOptions();">
            <?php foreach ($ticking as $tickingtype): 
                $slcted=''; 
                if ($selectedTicking != '') {
                    if ($selectedTicking== $tickingtype['tickingOption']) {
                        $slcted='selected';
                    }

                }
            
              ?>
              <option value="<?= $tickingtype['tickingOption'] ?>" <?=$slcted ?> ><?= $tickingtype['tickingOption'] ?> </option>  
              <?php endforeach; ?> 
        </select>   
        </div>
        <div id = "tick1t" class="form-group col-sm-2">
        <img src = "/img/white-trellis.jpg" alt = "White Trellis"  height="50px" align="right">
        </div>

        <div id = "tick2t" class="form-group col-sm-2">
        <img src = "/img/grey-trellis.jpg" alt = "Grey Trellis"  height="50px" align="right">
        </div>

        <div id = "tick3t" class="form-group col-sm-2">
        <img src = "/img/silver-trellis.jpg" alt = "Silver Trellis"  height="50px" align="right">
        </div>

        <div id = "tick4t" class="form-group col-sm-2">
        <img src = "/img/oatmeal-trellis.jpg" alt = "oatmeal Trellis"  height="50px" align="right">
        </div>
    </div><!-- row end -->
    <div class="form-row" id="hidespecial" style="margin-top:10px; margin-bottom:10px;" align="left">
        
            <div id = "topperspecialwidth1" class="form-group col-sm-2">
            <label for="topper1width">Topper 1 Special Width cm</label><br> 
             <input name = "topper1width" type = "text" class="form-select topperfield" size = "7" id = "topper1width" value = "<?= $prodsizes['topper1Width'] ?>"></div>
        
            <div id = "topperspeciallength1" class="col-sm-2">
            <label for="topper1width">Topper 1 Special Length cm</label><br> 
            <input name = "topper1length" type = "text" class="form-select topperfield" size = "7" id = "topper1length" value = "<?= $prodsizes['topper1Length'] ?>"></div>
        </div>
<div class="form-row">
    <div class="form-group col-sm-12">
    <label for="specialinstructionstopper">Topper Special Instructions:</label><br>
    <textarea name = "specialinstructionstopper" id="specialinstructionstopper" class="form-control topperfield"  style="width:90%" rows = "1" maxlength="250"><?= $purchase['specialinstructionstopper'] ?></textarea><span class="pull-right label label-default" id="toppercount"></span>
    </div>
</div>  <!-- row end -->
<div class="form-row xview">
    <div class="col-sm-2">
    <p class="topperdiscountcls">List Price <?=$this->OrderForm->getCurrencySymbol()?><span id = "topperlistpricespan"><?=$topperDiscount['standardPrice']?></span></p>
    </div>
    <div class="col-sm-4">

<label for="topperdiscount" class="topperdiscountcls">Discount:</label>
    <div class="form-check form-check-inline topperdiscountcls">
    <label class="form-check-label" for="topperdiscount">%</label>
        <input class="form-check-input topperfield" type="radio" name="topperdiscounttype" id="topperdiscounttype1" value="percent" <?= $topperDiscount['discountType']=="percent" ? 'checked' : '' ?> onchange = "setTopperPrice();" >
    </div>
    <div class="form-check form-check-inline topperdiscountcls">
        <label class="form-check-label" for="inlineRadio2"><?=$this->OrderForm->getCurrencySymbol()?></label>
        <input class="form-check-input topperfield" type="radio" name="topperdiscounttype" id="topperdiscounttype2" value="currency" <?= $topperDiscount['discountType']=="currency" ? 'checked' : '' ?> onchange = "setTopperPrice();">
        <input name = "topperdiscount" type = "text" id = "topperdiscount" class="topperfield" size = "10" value="<?=$topperDiscount['discount']?>" onchange = "setTopperPrice();">
    </div>
    </div>
    <div class="form-group form-inline col-sm-6 justify-content-end">
    Topper <?=$this->OrderForm->getCurrencySymbol()?>
        <input style="max-width:90px;" name = "topperprice" type = "text" class="form-select topperfield" id = "topperprice" size = "10" value="<?= $purchase['topperprice'] ?>" onchange = "setTopperDiscount();">
    </div>
</div>
<div class="form-row showWholesale xview">
    <div class="col-sm-9">
    </div>
    <div class="form-group bordergris col-sm-3">
    <p align='right'><b>Wholesale Pricing</b></p>
    <p align='right'>Wholesale Topper&nbsp;
        <?=$this->OrderForm->getCurrencySymbol()?>  
        <input style="max-width:90px;" name = "wtopperprice" type = "text" class="form-select topperfield" id = "wtopperprice" size = "10" value="<?= $topperwholesaleprice ?>"></p>
    </div> 

</div>
</div> <!-- topper_div end -->
<!-- <input type = "submit" name = "submit" value = "Save Topper" id = "submit" class = "button" /> -->

</form>

<script>
    var topperFieldChanged = false;
    function topperInit() {
        $('.showWholesale').hide();
        topperTickingSelected();
        topperspecialwidthSelected(false);
        topperspeciallengthSelected(false);
        instructionsCount('specialinstructionstopper','toppercount',250);
        showtoppertickingoptions();
        overrideTopperSubmit();

        $(".topperfield").on("change", function() {
            topperFieldChanged = true;
        });
        $(".topperfield").on("focus", function() {
            submitComponentForm(5);
        });
        hideTopperDiscountFields();
        showHideWholesale();
        disableTopperComponentSections(<?=$isComponentLocked?>, '<?=$lockColour?>');
    }

    function hideTopperDiscountFields() {
        if (($('#topperlistprice').val() / 1.0) == 0.0) {
            $('.topperdiscountcls').hide();
        } else {
            $('.topperdiscountcls').show();
        }
    }

function topperTickingSelected() {
    $('#tick1t').hide();
    $('#tick2t').hide();
    $('#tick3t').hide();
    $('#tick4t').hide();

    var selection = $("#toppertickingoptions").val();
    if (selection == "White Trellis") {
        $('#tick1t').show();
    } else if (selection == "Grey Trellis") {
        $('#tick2t').show();
    } else if (selection == "Silver Trellis") {
        $('#tick3t').show();
    }
}  
function showtoppertickingoptions() {
    
    var selection = $("#toppertype").val();
    if (selection == "CFv Topper") {
    
    $("#toppertickingoptions option[value='n']").hide();
    $("#toppertickingoptions option[value='TBC']").hide();
    $("#toppertickingoptions option[value='White Trellis']").hide();
    $("#toppertickingoptions option[value='Silver Trellis']").hide();
    $("#toppertickingoptions option[value='Grey Trellis']").attr('selected', 'selected');
    $('#specialinstructionstopper').val('Vegan Bed - Vegan materials to be used');
    } else {
    $("#toppertickingoptions option[value='n']").show();
    $("#toppertickingoptions option[value='TBC']").show();
    $("#toppertickingoptions option[value='White Trellis']").show();
    $("#toppertickingoptions option[value='Silver Trellis']").show();
    $("#toppertickingoptions option[value='Grey Trellis']").show();
    $('#specialinstructionstopper').val('');
    }
    
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
    function defaultTopperTickingOptions() {
    var slct = $("#tickingoptions option:selected").val();
    $("#toppertickingoptions option[value='" + slct + "']").attr('selected', 'selected');
    topperTickingSelected();
    }

    function hidetopperspecialwidth(clearvalues) {
        $('#specialwidth').hide();
        $('#topperspecialwidth1').hide();
        if (clearvalues) {
        $("#topper1width").val("");
        }
        }

        function hidetopperspeciallength(clearvalues) {
        $('#topperspeciallength1').hide();
        if (clearvalues) {
        $("#topper1length").val("");
        }
    }

    function topperspecialwidthSelected(clearvalues) {
        hidetopperspecialwidth(clearvalues);
        var selection = $("#topperwidth").val();
        if (selection == "Special Width") {
        $('#specialwidth').show();
        $('#topperspecialwidth1').show();
        }
    }

    function topperspeciallengthSelected(clearvalues) {
        hidetopperspeciallength(clearvalues);
        var selection = $("#topperlength").val();
        if (selection == "Special Length") {
        $('#topperspeciallength1').show();
        }
    }

    function toppervegantext() {
        var selection = $("#toppertype").val();
        if (selection == "CFv Topper") {
            $('#specialinstructionstopper').val('Vegan Bed - Vegan materials to be used');
        } else {
            $('#specialinstructionstopper').val('');
        }
    }

    function taCount(taObj,Cnt) { 
        if (typeof(objCnt) != "undefined") {
            objCnt=createObject(Cnt);
            objVal=taObj.value;
            if (objVal.length>maxL) objVal=objVal.substring(0,maxL);
            if (objCnt) {
                if(bName == "Netscape"){	
                    objCnt.textContent=maxL-objVal.length;}
                else{objCnt.innerText=maxL-objVal.length;}
            }
        return true;
        }
    }
    
    function disableTopperComponentSections(disable, lockColour) {
        if (disable) {
            $('#topperrequired_y').attr('disabled', true);
            $('#topperrequired_n').attr('disabled', true);
            $('#topper_div :input').attr('disabled', true);
            $('#topper_div :input').css('color', lockColour);
            $('.showWholesale :input').attr('disabled', false);
        }
    }

    function overrideTopperSubmit() { 
        $('#topperform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Order/saveTopper',
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
        topperFieldChanged = false;
    }

    function submitTopperForm() {
        $('#topperform').submit();
    }   
    
</script>
