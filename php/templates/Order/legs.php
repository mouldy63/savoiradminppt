<?php use Cake\Routing\Router; ?>
<div class="container" style="padding-left:20px;">
<form name="legsform" id="legsform" method="post" action="/php/Order/saveLegs">
<input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />
<input type = "hidden" name = "legslistprice" id = "legslistprice" value = "<?=$legsDiscount['standardPrice']?>" onchange = "setLegsPrice();" />
<input type = "hidden" name = "addlegslistprice" id = "addlegslistprice" value = "<?=$addLegsDiscount['standardPrice']?>" onchange = "setAddLegsPrice();" />
<div id="legs_div">
	<div class="form-row">
        <div class="form-group col-sm-2">
        <label for="legstyle">Feature Leg:<br></label>  
        <select name = "legstyle" id = "legstyle" class="form-select legsfield" onChange = "setLegFinishes(); showFloorType(); getLegsListPrice(); showLegStylePriceField(); setLegQty();">
         <?php foreach ($legs as $legsrow): 
                $slcted=''; 
                if ($purchase['legstyle']== $legsrow['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $legsrow['optionText'] ?>" <?=$slcted ?> ><?= $legsrow['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
        </div>
        <div class="form-group col-sm-2">
        <label for="legqty">Qty Legs:<br></label>  
            <select name = "legqty" id = "legqty" class="form-select legsfield" onChange = "getLegsListPrice();" >
            <?php
            for($i=0; $i<=13; $i++)
            {
                $slcted='';
                if ($purchase['LegQty']==$i) {
                    $slcted='selected';
                }

            ?> 
                <option value="<?= $i ?>" <?=$slcted ?> ><?= $i ?> </option>  
            <?php } ?> 
            </select>  
        </div>
        <div class="form-group col-sm-2">
        <label for="legfinish">Leg Finish:<br></label>  
        <select name = "legfinish" id = "legfinish" class="form-select legsfield" onChange = "getLegsListPrice();" >
              <?php if ($purchase['legfinish'] != '') { ?>
	            <option value="<?= $purchase['legfinish']?>" selected><?=$purchase['legfinish']?></option>
              <?php } ?>
              <option value="">  </option>  
             
         </select>  
        </div>

        <div class="form-group col-sm-2">
        <label for="legheight">Leg Height:<br></label>  
        <select name = "legheight" id = "legheight" class="form-select legsfield" onChange="legspecialheightSelected(true);">
        <?php if ($purchase['legheight'] != '') { ?>
	            <option value="<?= $purchase['legheight']?>" selected><?= $purchase['legheight']?></option>
              <?php } ?>
              <option value="">  </option> 
             
         </select>&nbsp;<span id="legspecialheight">Special:<input name="speciallegheight" type="text" id="speciallegheight" class="legsfield" value="<?=$prodsizes['legheight']?>" size = "10" /></span>
        </div>

        <div class="form-group col-sm-2 floortypeclass">
        <label for="floortype">Floor Type:<br></label>  
        <select name = "floortype" id = "floortype" class="form-select legsfield" >
         <?php foreach ($floortype as $floortyperow): 
                $slcted=''; 
                if ($purchase['floortype']== $floortyperow['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $floortyperow['optionText'] ?>" <?=$slcted ?> ><?= $floortyperow['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
        </div>
    </div>

    <div class="form-row">
        <div class="form-group col-sm-2">
        <label for="addlegstyle">Support Leg:<br></label>  
        <select name = "addlegstyle" id = "addlegstyle" class="form-select legsfield" onChange = "setAddLegFinishes(); getAddLegsListPrice();">
         <?php foreach ($supportleg as $supportlegrow): 
                $slcted=''; 
                if ($purchase['addlegstyle']== $supportlegrow['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $supportlegrow['optionText'] ?>" <?=$slcted ?> ><?= $supportlegrow['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
        </div>
        <div class="form-group col-sm-2">
        <label for="addlegqty">Qty Legs:<br></label>  
            <select name = "addlegqty" id = "addlegqty" class="form-select legsfield" onChange = "getAddLegsListPrice();">
            <?php
            for($i=0; $i<=13; $i++)
            {
                $slcted='';
                if ($purchase['AddLegQty']==$i) {
                    $slcted='selected';
                }

            ?> 
                <option value="<?= $i ?>" <?=$slcted ?> ><?= $i ?> </option>  
            <?php } ?> 
            </select>  
        </div>
        <div class="form-group col-sm-2">
        <label for="addlegfinish">Leg Finish:<br></label>  
        <select name = "addlegfinish" id = "addlegfinish" class="form-select legsfield" >
              <?php if ($purchase['addlegfinish'] != '') { ?>
	            <option value="<?= $purchase['addlegfinish']?>" selected><?= $purchase['addlegfinish']?></option>
              <?php } ?>
              <option value="">  </option>  
             
         </select>  
        </div>
    </div>
    <div class="form-row">
            <div class="form-group col-sm-12">
            <label for="legsinstructions">Legs Special Instructions:</label><br>
            <textarea name = "legsinstructions" id="legsinstructions" class="form-control legsfield"  style="width:90%" rows = "1" maxlength="130"><?= $purchase['specialinstructionslegs'] ?></textarea><span class="pull-right label label-default" id="legcount"></span>
            </div>
        </div> 
    <div class="form-row xview" style="margin-bottom:0px;">
    <div class="col-sm-2">
    <p class="legsdiscountcls">Legs List Price <?=$this->OrderForm->getCurrencySymbol()?><span id = "legslistpricespan"><?=$legsDiscount['standardPrice']?></span></p>
    </div>
<div class="col-sm-4">

<label for="legsdiscount" class="legsdiscountcls">Discount:</label>
    <div class="form-check form-check-inline legsdiscountcls">
    <label class="form-check-label" for="legsdiscount">%</label>
        <input class="form-check-input legsfield" type="radio" name="legsdiscounttype" id="legsdiscounttype1" value="percent" <?= $legsDiscount['discountType']=="percent" ? 'checked' : '' ?> onchange = "setLegsPrice();" >
    </div>
    <div class="form-check form-check-inline legsdiscountcls">
        <label class="form-check-label" for="inlineRadio2"><?=$this->OrderForm->getCurrencySymbol()?></label>
        <input class="form-check-input legsfield" type="radio" name="legsdiscounttype" id="legsdiscounttype2" value="currency" <?= $legsDiscount['discountType']=="currency" ? 'checked' : '' ?> onchange = "setLegsPrice();">
        <input name = "legsdiscount" type = "text" id = "legsdiscount" class="legsfield" size = "10" value="<?=$legsDiscount['discount']?>" onchange = "setLegsPrice();">
    </div>
</div>
        <div class="form-group form-inline col-sm-6 justify-content-end">
        <label for="legprice">Legs&nbsp;</label><?=$this->OrderForm->getCurrencySymbol()?>
    <input style="max-width:90px;" name = "legprice" type = "number" id = "legprice" class="form-select legsfield" size = "15" value="<?= $purchase['legprice'] ?>" placeholder=0 onchange="setLegsDiscount();">
        </div>
    </div>

    <div class="form-row xview" style="margin-top:0px;">
    <div class="col-sm-2">
    <p class="addlegsdiscountcls">Support List Price <?=$this->OrderForm->getCurrencySymbol()?><span id = "addlegslistpricespan"><?=$addLegsDiscount['standardPrice']?></span></p>
    </div>
<div class="col-sm-4">

<label for="addlegsdiscount" class="addlegsdiscountcls">Discount:</label>
    <div class="form-check form-check-inline addlegsdiscountcls">
    <label class="form-check-label" for="addlegsdiscount">%</label>
        <input class="form-check-input legsfield" type="radio" name="addlegsdiscounttype" id="addlegsdiscounttype1" value="percent" <?= $addLegsDiscount['discountType']=="percent" ? 'checked' : '' ?> onchange = "setAddLegsPrice();" >
    </div>
    <div class="form-check form-check-inline addlegsdiscountcls">
        <label class="form-check-label" for="inlineRadio2"><?=$this->OrderForm->getCurrencySymbol()?></label>
        <input class="form-check-input legsfield" type="radio" name="addlegsdiscounttype" id="addlegsdiscounttype2" value="currency" <?= $addLegsDiscount['discountType']=="currency" ? 'checked' : '' ?> onchange = "setAddLegsPrice();">
        <input name = "addlegsdiscount" value = "<?= $addLegsDiscount['discount'] ?>" type = "text" id = "addlegsdiscount" size = "10" class="legsfield" onchange = "setAddLegsPrice();">
    </div>
</div>
    <div class="form-group form-inline col-sm-6 justify-content-end addlegsdiscountcls xview">
        <label for="addlegsprice">Support Legs&nbsp;</label><?=$this->OrderForm->getCurrencySymbol()?>
        <input style="max-width:90px;" name = "addlegsprice" type = "number" id = "addlegsprice" class="form-select legsfield" size = "15" value="<?= $purchase['addlegprice'] ?>" placeholder=0 onchange="setAddLegsDiscount();">

        </div>
    </div>
<div class="form-row showWholesale xview">
    <div class="col-sm-9">
    </div>
    <div class="form-group  bordergris col-sm-3">
    <p align='right'><b>Wholesale Pricing</b></p>
        <p align='right'>
        Wholesale Legs&nbsp;
        <?=$this->OrderForm->getCurrencySymbol()?>    
        <input style="max-width:90px;" name = "wlegprice" type = "text" class="form-select legsfield" id = "wlegprice" size = "10" value="<?= $legswholesaleprice ?>">
        </p>
        <p align='right'>Support Leg Price <?=$this->OrderForm->getCurrencySymbol()?>    
        <input style="max-width:90px;" name = "wsupportlegprice" type = "text" class="form-select legsfield" id = "wsupportlegprice" size = "10" value="<?= $supportlegswholesaleprice ?>">
        </p>
    </div> 

</div>
<!-- <input type = "submit" name = "submit" value = "Save Legs" id = "submit" class = "button" /> -->
</div>
</div> <!-- legs_div end -->
</form>

<script>
    var legsFieldChanged = false;
    function legsInit() {
        $('.showWholesale').hide();
        showFloorType();
        instructionsCount('legsinstructions','legcount',130);
        overrideLegsSubmit();

        $(".legsfield").on("change", function() {
            legsFieldChanged = true;
        });
        $(".legsfield").on("focus", function() {
            submitComponentForm(7);
        });
        hideLegsDiscountFields();
        legspecialheightSelected(false);
        showLegStylePriceField();
        showHideWholesale();
        disableLegsComponentSections(<?=$isComponentLocked?>, '<?=$lockColour?>');
    }

    function hideLegsDiscountFields() {
        if (($('#legslistprice').val() / 1.0) == 0.0) {
            $('.legsdiscountcls').hide();
        } else {
            $('.legsdiscountcls').show();
        }
    }

function setLegFinishes() {
    var slct = $("#legstyle option:selected").val();
    var finishOptions = [];
    var heightOptions = [];
    var defaultFinishSelection = "";
    var defaultHeightSelection = "";

    if (slct == "TBC") {
    finishOptions.push("TBC");
    heightOptions.push("TBC");
    } else if (slct == "Wooden Tapered") {
    finishOptions.push("TBC");
    finishOptions.push("Natural Maple");
    finishOptions.push("Oak");
    finishOptions.push("Walnut");
    finishOptions.push("Ebony");
    finishOptions.push("Rosewood");
    finishOptions.push("Upholstered");
    finishOptions.push("Special (as instructions)");
    heightOptions.push("TBC");
    heightOptions.push("9.5cm/ Low");
    heightOptions.push("13.5cm/ Standard");
    heightOptions.push("17cm/ Tall");
    heightOptions.push("21cm/ Very Tall");
    heightOptions.push("Special Height");
    } else if (slct == "Holly") {
    finishOptions.push("TBC");
    finishOptions.push("Natural Maple");
    finishOptions.push("Oak");
    finishOptions.push("Ebony");
    finishOptions.push("Rosewood");
    finishOptions.push("Walnut");
    finishOptions.push("Special (as instructions)");
    defaultFinishSelection = "Rosewood";
    heightOptions.push("15cm");
    defaultHeightSelection = "15cm";
    } else if (slct == "Ian Leg")
    {
        heightOptions.push("15cm");
        defaultHeightSelection = "15cm";
    } else if (slct == "Metal") {
    finishOptions.push("Brass");
    finishOptions.push("Silver");
    heightOptions.push("15cm");
    defaultHeightSelection = "15cm";
    }
    else if (slct == "Penelope") {
    finishOptions.push("Upholstered");
    heightOptions.push("15cm");
    }
    else if (slct == "Cloud") {
    finishOptions.push("Bronze");
    heightOptions.push("15cm");
    }
    else if (slct == "Cylindrical") {
    finishOptions.push("TBC");
    finishOptions.push("Natural");
    finishOptions.push("Oak");
    finishOptions.push("Walnut");
    finishOptions.push("Ebony");
    finishOptions.push("Rosewood");
    finishOptions.push("Special (as instructions)");
    heightOptions.push("TBC");
    heightOptions.push("9.5cm/ Low");
    heightOptions.push("13.5cm/ Standard");
    heightOptions.push("17cm/ Tall");
    heightOptions.push("21cm/ Very Tall");
    heightOptions.push("Special Height");
    defaultHeightSelection = "TBC";
    }
    else if (slct == "Georgian" || slct == "Georgian (Brass cap)" || slct == "Georgian (Chrome cap)") {
    finishOptions.push("Ebony");
    finishOptions.push("Walnut");
    finishOptions.push("Oak");
    finishOptions.push("Rosewood");
    finishOptions.push("Fabric Upholstered");
    finishOptions.push("Special (as instructions)");
    heightOptions.push("20cm");
    }
    else if (slct == "Harlech Leg") {
    finishOptions.push("Black Brushed Chrome");
    finishOptions.push("Antique Brass")
    heightOptions.push("17cm");
    }
    else if (slct == "Manhattan") {
    finishOptions.push("TBC");
    finishOptions.push("Natural Maple");
    finishOptions.push("Oak");
    finishOptions.push("Ebony");
    finishOptions.push("Walnut");
    finishOptions.push("Special (as instructions)");
    defaultFinishSelection = "Ebony";
    heightOptions.push("13.5cm");
    heightOptions.push("TBC");
    heightOptions.push("9.5cm/ Low");
    heightOptions.push("17cm/ Tall");
    heightOptions.push("21cm/ Very Tall");
    heightOptions.push("Special Height");
    defaultHeightSelection = "13.5cm";
    } else if (slct == "Block Leg") {
    finishOptions.push("TBC");
    finishOptions.push("Ebony");
    finishOptions.push("Oak");
    finishOptions.push("Natural Maple");
    finishOptions.push("Rosewood");
    finishOptions.push("Walnut");
    finishOptions.push("Special (as instructions)");
    heightOptions.push("3cm/Low");
    heightOptions.push("Special Height");
    } else if (slct == "Ball & Claw") {
    finishOptions.push("TBC");
    finishOptions.push("Silver Gilded");
    finishOptions.push("Gold Gilded");
    finishOptions.push("Special (as instructions)");
    heightOptions.push("15cm");
    } else if (slct == "Castors") {
    finishOptions.push("Brown");
    heightOptions.push("TBC");
    heightOptions.push("9.5cm/ Low");
    heightOptions.push("13.5cm/ Standard");
    heightOptions.push("17cm/ Tall");
    heightOptions.push("21cm/ Very Tall");
    heightOptions.push("Special Height");
    } else if (slct == "Perspex") {
    finishOptions.push("Perspex");
    heightOptions.push("TBC");
    heightOptions.push("9.5cm/ Low");
    heightOptions.push("13.5cm/ Standard");
    heightOptions.push("17cm/ Tall");
    heightOptions.push("21cm/ Very Tall");
    heightOptions.push("Special Height");
    } else if (slct == "Special (as instructions)") {
    finishOptions.push("Special (as instructions)");
    heightOptions.push("Special Height");
}

$('#legfinish').find('option').remove();

$.each(finishOptions, function(val, text) {
$('#legfinish').append($('<option></option>').val(text).html(text));
});

if (defaultFinishSelection != "") {
$("#legfinish option[value='" + defaultFinishSelection + "']").attr('selected', 'selected');
}

$('#legheight').find('option').remove();

$.each(heightOptions, function(val, text) {
$('#legheight').append($('<option></option>').val(text).html(text));
});

if (defaultHeightSelection != "") {
$("#legheight option[value='" + defaultHeightSelection + "']").attr('selected', 'selected');
}
}

function setAddLegFinishes() {

var slct = $("#addlegstyle option:selected").val();
var finishOptions = [];

if (slct == "TBC") {
finishOptions.push("TBC");
} else if (slct == "Wooden Tapered") {
finishOptions.push("TBC");
finishOptions.push("Natural Maple");
finishOptions.push("Oak");
finishOptions.push("Walnut");
finishOptions.push("Ebony");
finishOptions.push("Rosewood");
finishOptions.push("Special (as instructions)");
} else if (slct == "Perspex") {
finishOptions.push("Perspex Clear");
}  else if (slct == "Cylindrical") {
finishOptions.push("TBC");
finishOptions.push("Ebony");
finishOptions.push("Beech");
}
else if (slct == "Maple") {
finishOptions.push("TBC");
}

$('#addlegfinish').find('option').remove();

$.each(finishOptions, function(val, text) {
$('#addlegfinish').append($('<option></option>').val(text).html(text));
});

}

function showFloorType() {
    var slct = $("#legstyle option:selected").val();
    if (slct == "Castors") {
        $('.floortypeclass').show();
    } else {
        $('.floortypeclass').hide();
    }
}


function setLegQty() {
    var basewidth = $("#basewidth option:selected").val();
    var basetype = $("#basetype option:selected").val();
    var legtype = $("#legstyle option:selected").val();
    var legQty = 0;
    var addLegQty = 0;
    var isException = false;
    if (legtype == "Penelope" || legtype == "Ball & Claw") {
    	isException = true;
    }

    var rBaseWidth = new String(basewidth); 
    rBaseWidth = rBaseWidth.replace(/[^0-9.]/g, ''); // strip out the chars

    if (basetype == "North-South Split") {
        legQty = 4;
        addLegQty = 4;
        if (isException) {
            legQty = 2;
            addLegQty = 6;
        }
    } else if (basetype == "East-West Split") {
        legQty = 4;
        addLegQty = 4;
        if (rBaseWidth > 139) addLegQty = 7;
        if (isException) {
            legQty = 2;
            addLegQty = 6;
            if (rBaseWidth > 139) addLegQty = 9;
        }
    } else if (basewidth != "n") {
        legQty = 4;
        addLegQty = 0;
        if (rBaseWidth > 139) addLegQty = 7;
        if (isException) {
            legQty = 2;
            addLegQty = 2;
            if (rBaseWidth > 139) addLegQty = 9;
        }
    }
    $('#legqty').val(legQty);
    $('#addlegqty').val(addLegQty);
}

function legspecialheightSelected(clearvalues) {
    hidelegspecialheight(clearvalues);
    var slct = $("#legheight option:selected").val();
    if (slct == "Special Height") {
        $('#legspecialheight').show();
    }
}

function hidelegspecialheight(clearvalues) {
    $('#legspecialheight').hide();
    if (clearvalues) {
        $("#speciallegheight").val("");
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

    function disableLegsComponentSections(disable, lockColour) {
        if (disable) {
            $('#legsrequired_y').attr('disabled', true);
            $('#legsrequired_n').attr('disabled', true);
            $('#legs_div :input').attr('disabled', true);
            $('#legs_div :input').css('color', lockColour);
            $('.showWholesale :input').attr('disabled', false);
        }
    }

    function overrideLegsSubmit() { 
        $('#legsform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Order/saveLegs',
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
        legsFieldChanged = false;
    }

    function submitLegsForm() {
        $('#legsform').submit();
    }   
    
</script>
