<?php use Cake\Routing\Router; ?>

<form name="mattressform" id="mattressform" method="post" action="/php/Order/saveMattress" style="padding:5px;">
<input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />
<input type = "hidden" name = "mattresslistprice" id = "mattresslistprice" class="mattressfield" value = "<?=$mattressDiscount['standardPrice']?>" onchange = "setMattressPrice();" />

<div id="mattress_div">
	<div class="form-row">
    <div class="form-group col-sm-2">
    <label for="savoirmodel"> Savoir Model:  <br></label>    
          <p><select id = "savoirmodel" name = "savoirmodel" class="form-select mattressfield" onChange="defaultVentPosition(); showtickingoptions(); getMattressListPrice(); mattressvegantext(); getMadeAt();" >
          <option value = "n">--</option>
             <?php foreach ($bedmodels as $bedmodel): 
                $slcted=''; 
                if ($purchase['savoirmodel']== $bedmodel['bedmodel']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $bedmodel['bedmodel'] ?>" <?=$slcted ?> ><?= $bedmodel['bedmodel'] ?> </option>    
            <?php endforeach; ?>       
            </select>  
        </div> 
        <div class="form-group col-sm-3">
        <label for="mattresstype"> Mattress Type:  <br></label>        
        <select name = "mattresstype" id = "mattresstype" class="form-select mattressfield" onChange = "mattspecialwidthSelected(true); mattspeciallengthSelected(true);" >
        <?php foreach ($comptypes as $comptype): 
                $slcted=''; 
                if ($purchase['mattresstype']== $comptype['componentType']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $comptype['componentType'] ?>" <?=$slcted ?> ><?= $comptype['componentType'] ?> </option>  
              <?php endforeach; ?> 
        </select>    
        </div>
        <div class="form-group col-sm-2">
        <label for="mattresstype"> Ticking Options:  <br></label> 
        <select name = "tickingoptions" class="form-select mattressfield" id = "tickingoptions">
            <?php foreach ($ticking as $tickingtype): 
                $slcted=''; 
                if ($purchase['tickingoptions']== $tickingtype['tickingOption']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $tickingtype['tickingOption'] ?>" <?=$slcted ?> ><?= $tickingtype['tickingOption'] ?> </option>  
              <?php endforeach; ?> 
        </select>   
        </div>

        <div class="form-group col-sm-2">
        <label for="mattresstype"> Mattress Width: <br></label> 
            <select name = "mattresswidth" class="form-select mattressfield" id = "mattresswidth"
        onChange = "mattspecialwidthSelected(true);  setMattressTypes($('#mattresstype option:selected').val());  getMattressListPrice();">
            <?php foreach ($compwidths as $compwidth): 
                $slcted=''; 
                if ($purchase['mattresswidth']== $compwidth['componentDim']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $compwidth['componentDim'] ?>" <?=$slcted ?> ><?= $compwidth['componentDim'] ?> </option>  
              <?php endforeach; ?> 
            </select>     
        </div> 

        <div class="form-group col-sm-2">
        <label for="mattresstype"> Mattress Length: <br></label>
         <select name = "mattresslength" class="form-select mattressfield" id = "mattresslength"  onChange = "mattspeciallengthSelected(true); setMattressTypes($('#mattresstype option:selected').val());  getMattressListPrice(); ">
         <?php foreach ($complengths as $complength): 
                $slcted=''; 
                if ($purchase['mattresslength']== $complength['componentDim']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $complength['componentDim'] ?>" <?=$slcted ?> ><?= $complength['componentDim'] ?> </option>  
              <?php endforeach; ?> 
         </select>
        </div> 
    </div> <!-- row end -->
   
    
    <div class="form-row" id="hidespecial" style="margin-top:-10px;">
        <div id = "mattspecialwidth1" class="col-sm-3"><label for="mattresstype">Matt 1 Special Width cm:<br></label> <input name = "matt1width" type = "text" id = "matt1width" class="mattressfield" value = "<?= empty($prodsizes['Matt1Width']) ? '' : htmlspecialchars($prodsizes['Matt1Width']) ?>" size = "7"></div>
        <div id = "mattspecialwidth2" class="col-sm-3"><label for="mattresstype">Matt 2 Special Width cm:<br></label><input name = "matt2width" type = "text" id = "matt2width" class="mattressfield" value = "<?= empty($prodsizes['Matt2Width']) ? '' : htmlspecialchars($prodsizes['Matt2Width']) ?>" size = "7"></div>
        <div id = "mattspeciallength1" class="col-sm-3"><label for="mattresstype">Matt 1 Special Length cm:<br></label><input name = "matt1length" type = "text" id = "matt1length" class="mattressfield" value = "<?= empty($prodsizes['Matt1Length']) ? '' : htmlspecialchars($prodsizes['Matt1Length']) ?>" size = "7"></div>
        <div id = "mattspeciallength2" class="col-sm-3"><label for="mattresstype">Matt 2 Special Length cm:<br></label><input name = "matt2length" type = "text" id = "matt2length" class="mattressfield" value = "<?= empty($prodsizes['Matt2Length']) ? '' : htmlspecialchars($prodsizes['Matt2Length']) ?>" size = "7"></div>
    </div>
    
    
    <div class="form-row">
        <div class="col-sm-12">
            <p>Support (as viewed from the foot looking toward the head end):</p>
        </div>
    </div>
    <div class="form-row">
        <div class="form-group col-sm-2">
        <label for="leftsupport">Left support::<br></label> 
                        <select name = "leftsupport" id = "leftsupport" class="form-select mattressfield">
                        <?php foreach ($support as $supportrow): 
                    $slcted=''; 
                    if ($purchase['leftsupport']== $supportrow['support']) {
                        $slcted='selected';
                    } 
                ?>
                <option value="<?= $supportrow['support'] ?>" <?=$slcted ?> ><?= $supportrow['support'] ?> </option>  
                <?php endforeach; ?> 
            </select>
        </div>
        <div class="form-group col-sm-2">
        <label for="rightsupport">Right support:<br></label>
                        <select name = "rightsupport" id = "rightsupport" class="form-select mattressfield">
                        <?php foreach ($support as $supportrow): 
                    $slcted=''; 
                    if ($purchase['rightsupport']== $supportrow['support']) {
                        $slcted='selected';
                    } 
                ?>
                <option value="<?= $supportrow['support'] ?>" <?=$slcted ?> ><?= $supportrow['support'] ?> </option>  
                <?php endforeach; ?> 
                        </select>
        </div> 
        <div class="form-group col-sm-2">
        <label for="ventposition">Vent Position:<br></label>
                    <select name = "ventposition" id = "ventposition" class="form-select mattressfield">
                    <option value = "n">--</option>
                    <?php foreach ($ventpos as $ventposition): 
                $slcted=''; 
                if ($purchase['ventposition']== $ventposition['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $ventposition['optionText'] ?>" <?=$slcted ?> ><?= $ventposition['optionText'] ?> </option>  
              <?php endforeach; ?> 
                    </select> 
        </div>
        <div class="form-group col-sm-2">
        <label for="ventfinish">Vent Finish:<br></label>
                 <select name = "ventfinish" id = "ventfinish"  class="form-select mattressfield">
                 <?php foreach ($ventfinish as $ventfinishrow): 
                $slcted=''; 
                if ($purchase['ventfinish']== $ventfinishrow['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $ventfinishrow['optionText'] ?>" <?=$slcted ?> ><?= $ventfinishrow['optionText'] ?> </option>  
              <?php endforeach; ?> 
                    </select>
        </div>
        <div id = "tick1" class="form-group col-sm-4">
        <img src = "/img/white-trellis.jpg" alt = "White Trellis" height="50px" align="right">
        </div>

        <div id = "tick2" class="form-group col-sm-4">
        <img src = "/img/grey-trellis.jpg" alt = "Grey Trellis" height="50px" align="right">
        </div>

        <div id = "tick3" class="form-group col-sm-4">
        <img src = "/img/silver-trellis.jpg" alt = "Silver Trellis" height="50px" align="right">
        </div>

        <div id = "tick4" class="form-group col-sm-4">
        <img src = "/img/oatmeal-trellis.jpg" alt = "oatmeal Trellis" height="50px" align="right">
        </div>
</div>
<div class="form-row">
    <div class="col-sm-10">
    Mattress Special Instructions:<br>
    <textarea name = "mattressinstructions" id="mattressinstructions" class="mattressfield" style="width:90%" onKeyUp="return taCount(this,'myCounter')"  cols = "65" rows = "2" maxlength="250"><?= $purchase['mattressinstructions'] ?></textarea>
    &nbsp;<B><SPAN id=myCounter>250</SPAN></B>/250
<div class = "clear">
&nbsp;
</div>
    </div>
    

</div>  
<div class="form-row xview">
<div class="col-sm-2">
    <p class="mattressdiscountcls">List Price <?=$this->OrderForm->getCurrencySymbol()?><span id = "mattresslistpricespan"><?=$mattressDiscount['standardPrice']?></span></p>
    </div>
<div class="col-sm-4">
    <label for="mattressdiscount" class="mattressdiscountcls">Discount:</label>
    <div class="form-check form-check-inline mattressdiscountcls">
        <label class="form-check-label" for="mattressdiscount">%</label>
        <input class="form-check-input mattressfield" type="radio" name="mattressdiscounttype" id="mattressdiscounttype1" value="percent" <?= $mattressDiscount['discountType']=="percent" ? 'checked' : '' ?> onchange = "setMattressPrice();" >
    </div>
    <div class="form-check form-check-inline mattressdiscountcls">
        <label class="form-check-label" for="inlineRadio2"><?=$this->OrderForm->getCurrencySymbol()?></label>
        <input class="form-check-input mattressfield" type="radio" name="mattressdiscounttype" id="mattressdiscounttype2" value="currency" <?= $mattressDiscount['discountType']=="currency" ? 'checked' : '' ?> onchange = "setMattressPrice();">
        <input name = "mattressdiscount" type = "text" id = "mattressdiscount" class="mattressfield" size = "10" value="<?=$mattressDiscount['discount']?>" onchange = "setMattressPrice();">
    </div>
</div>
    <div class="form-group form-inline col-sm-6 justify-content-end">
    <label for="mattressprice">Mattress&nbsp;</label> <?=$this->OrderForm->getCurrencySymbol()?>
        <input style="max-width:90px;" name = "mattressprice" type = "text" class="form-select mattressfield" id = "mattressprice" size = "10" value="<?= $purchase['mattressprice'] ?>" onchange="setMattressDiscount();">
    </div>
</div>
<div class="form-row showWholesale xview">
    <div class="col-sm-9">
    </div>
    <div class="form-group  bordergris col-sm-3">
    <p align='right'><b>Wholesale Pricing</b></p>
    <p align='right'>Wholesale Mattress&nbsp;
        <?=$this->OrderForm->getCurrencySymbol()?>    
        <input style="max-width:90px;" name = "wmattressprice" type = "text" class="form-select mattressfield" id = "wmattressprice" size = "10" value="<?= $mattresswholesaleprice ?>"></p>
    </div> 
</div>
            
</div> <!-- mattress_div end -->
<!-- <input type = "submit" name = "submit" value = "Save Mattress" id = "submit" class = "button" /> -->
</form>

<script>
    var mattressFieldChanged = false;
    function mattressInit() {
        $('.showWholesale').hide();
        mattressTickingSelected();
        $("#tickingoptions").change(mattressTickingSelected);
        mattspecialwidthSelected(false);
        mattspeciallengthSelected(false);
        overrideMattressSubmit();

        $(".mattressfield").on("change", function() {
            mattressFieldChanged = true;
            console.log("mattressFieldChanged");
        });
        $(".mattressfield").on("focus", function() {
            submitComponentForm(1);
        });
        hideMattressDiscountFields();
        showHideWholesale();
        disableMattressComponentSections(<?=$isComponentLocked?>, '<?=$lockColour?>');
    }

    function hideMattressDiscountFields() {
        if (($('#mattresslistprice').val() / 1.0) == 0.0) {
            $('.mattressdiscountcls').hide();
        } else {
            $('.mattressdiscountcls').show();
        }
    }

    function setMattressTypes(defaultSelection) {
        var slct = $("#mattresswidth option:selected").val();
        if (defaultSelection == null) defaultSelection = "";

        var mattressTypeOptions = [];
        if (slct == "90cm" || slct == "96.5cm" || slct == "100cm" || slct == "105cm" || slct == "120cm" || slct == "140cm") {
            mattressTypeOptions.push("--");
            mattressTypeOptions.push("TBC");
            mattressTypeOptions.push("One Piece");
            localDefault = "One Piece";
            if (defaultSelection != "TBC" && defaultSelection != "One Piece") {
            defaultSelection = "One Piece";
            }
        } else {
            mattressTypeOptions.push("--");
            mattressTypeOptions.push("TBC");
            mattressTypeOptions.push("One Piece");
            mattressTypeOptions.push("Zipped Pair");
            mattressTypeOptions.push("Zipped Pair (Centre Only)");
        }

        $('#mattresstype').find('option').remove();
        $.each(mattressTypeOptions, function(val, text) {
        $('#mattresstype').append($('<option></option>').val(text).html(text));
        });
        if (defaultSelection != "") {
            $("#mattresstype option[value='" + defaultSelection + "']").attr('selected', 'selected');
        }
    }

    
    function showtickingoptions() {
        var selection = $("#savoirmodel").val();
        if (selection == "No. 4v") {
        
        $("#tickingoptions option[value='Grey Trellis']").show();
        $("#tickingoptions option[value='n']").hide();
        $("#tickingoptions option[value='TBC']").hide();
        $("#tickingoptions option[value='White Trellis']").hide();
        $("#tickingoptions option[value='Silver Trellis']").hide();
        $("#tickingoptions option[value='Grey Trellis']").attr('selected', 'selected');
        $('#mattressinstructions').val('Vegan Bed - Vegan materials to be used');
        mattressTickingSelected();
        defaultTopperTickingOptions();
        defaultBaseTickingOptions();
        } else {
        $("#tickingoptions option[value='n']").show();
        $("#tickingoptions option[value='TBC']").show();
        $("#tickingoptions option[value='White Trellis']").show();
        $("#tickingoptions option[value='Silver Trellis']").show();
        $("#tickingoptions option[value='Grey Trellis']").show();
        $('#mattressinstructions').val('');
        }
        
    }
    function mattressTickingSelected() {
        $('#tick1').hide();
        $('#tick2').hide();
        $('#tick3').hide();
        $('#tick4').hide();
        
        var selection = $("#tickingoptions").val();
        if (selection == "White Trellis") {
            $('#tick1').show();
        } else if (selection == "Grey Trellis") {
            $('#tick2').show();
        } else if (selection == "Silver Trellis") {
            $('#tick3').show();
        }
    }

    function defaultVentPosition() {
        var slct = $("#savoirmodel").val();
        var ventPositionDefault = null;
        console.log('slct='+slct);
        if (slct == "No. 1" || slct == "No. 2") {
            ventPositionDefault = "Vents on Ends";
        } else if (slct == "No. 3" || slct == "No. 4" || slct == "No. 5") {
            ventPositionDefault = "Vents on Sides";
        }
        if (ventPositionDefault != null) {
            $("#ventposition").val(ventPositionDefault);
        }
    }

    function hidemattspecialwidth(clearvalues) {
        $('#specialwidth').hide();
        $('#mattspecialwidth1').hide();
        $('#mattspecialwidth2').hide();
        if (clearvalues) {
        $("#matt1width").val("");
        $("#matt2width").val("");
        }
        }

    function hidemattspeciallength(clearvalues) {
        $('#mattspeciallength1').hide();
        $('#mattspeciallength2').hide();
        if (clearvalues) {
        $("#matt1length").val("");
        $("#matt2length").val("");
        }
    }

    function mattspecialwidthSelected(clearvalues) {
        hidemattspecialwidth(clearvalues);
        var selection = $("#mattresswidth").val();
        var selection2 = $("#mattresstype").val();
        if ((selection == "Special Width") && ((selection2 == "Zipped Pair") || (selection2 == "Zipped Pair (Centre Only)"))) {
        $('#specialwidth').show();
        $('#mattspecialwidth1').show();
        $('#mattspecialwidth2').show();
        }
        if ((selection == "Special Width") && ((selection2 != "Zipped Pair") && (selection2 != "Zipped Pair (Centre Only)"))) {
        $('#specialwidth').show();
        $('#mattspecialwidth1').show();
        }
    }

    function mattressvegantext() {
        var selection = $("#savoirmodel").val();
        if (selection == "No. 4v") {
            $('#mattressinstructions').val('Vegan Bed - Vegan materials to be used. ' + $('#mattressinstructions').val());
        }
    }

    function mattspeciallengthSelected(clearvalues) {
        hidemattspeciallength(clearvalues);
        var selection = $("#mattresslength").val();
        var selection2 = $("#mattresstype").val();
        if (selection == "Special Length" && (selection2 == "Zipped Pair" || selection2 == "Zipped Pair (Centre Only)")) {
        $('#mattspeciallength1').show();
        $('#mattspeciallength2').show();
        }
        if ((selection == "Special Length") && ((selection2 != "Zipped Pair") && (selection2 != "Zipped Pair (Centre Only)"))) {
        $('#mattspeciallength1').show();
        $('#mattspeciallength2').hide();
        }
    }

    function disableMattressComponentSections(disable, lockColour) {
        if (disable) {
            $('#mattressrequired_y').attr('disabled', true);
            $('#mattressrequired_n').attr('disabled', true);
            $('#mattress_div :input').attr('disabled', true);
            $('#mattress_div :input').css('color', lockColour);
            $('.showWholesale :input').attr('disabled', false);
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

    function overrideMattressSubmit() { 
        $('#mattressform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Order/saveMattress',
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
        mattressFieldChanged = false;
    }

    function submitMattressForm() {
        $('#mattressform').submit();
    }
    
</script>
