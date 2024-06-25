<?php use Cake\Routing\Router; ?>
<div class="container" style="padding-left:20px;">
<form name="headboardform" id="headboardform" method="post" action="/php/Order/saveHeadboard">
<input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />
<input type = "hidden" name = "headboardlistprice" id = "headboardlistprice" value = "<?=$headboardDiscount['standardPrice']?>" onchange = "setHeadboardPrice();" />
<div id="headboard_div">
	<div class="form-row">
        <div class="form-group col-sm-4">
        <label for="headboardstyle">Headboard Style:<br></label>  
        <select name = "headboardstyle" id = "headboardstyle" class="form-select headboardfield" onchange = "headboardStyle(); manhattanTrimOptions(); defaultHeadboardHeight(); getHeadboardListPrice(); getHeadboardTrimListPrice(); resetPriceField('headboardtrimprice',10); showHideHeadboardPriceSummaryRow(10); getMadeAt();">
         <?php foreach ($headboards as $headboard): 
                $slcted=''; 
                if ($purchase['headboardstyle']== $headboard['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $headboard['optionText'] ?>" <?=$slcted ?> ><?= $headboard['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
        </div>

        <div class="form-group col-sm-4">
        <label for="headboardheight">Headboard Height:<br></label>  
        <select name = "headboardheight" id = "headboardheight" class="form-select headboardfield">
         <?php foreach ($headboardheights as $headboardheight): 
                $slcted=''; 
                if ($purchase['headboardheight']== $headboardheight['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $headboardheight['optionText'] ?>" <?=$slcted ?> ><?= $headboardheight['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
        </div>
        <div class="form-group col-sm-2">
        <label for="headboardfinish">Headboard Finish:<br></label>  
        <select name = "headboardfinish" id = "headboardfinish" class="form-select headboardfield">
         <?php foreach ($footboardfinish as $footboardfinishrow): 
                $slcted=''; 
                if ($purchase['headboardfinish']== $footboardfinishrow['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $footboardfinishrow['optionText'] ?>" <?=$slcted ?> ><?= $footboardfinishrow['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
        </div>
        <div class="form-group col-sm-2">
        <label for="hbwidth">Headboard Width:<br></label>  
        <select name = "hbwidth" id = "hbwidth" class="form-select headboardfield" >
            <?php foreach ($compwidths as $compwidth): 
                $slcted=''; 
                if ($purchase['headboardWidth']== $compwidth['componentDim']) {
                    $slcted='selected';
                } else if (!isset($purchase['headboardWidth']) && $purchase['mattresswidth']== $compwidth['componentDim']) {
                    $slcted='selected';
                } else if (!isset($purchase['headboardWidth']) && !isset($purchase['mattressWidth']) && $purchase['baseWidth']== $compwidth['componentDim']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $compwidth['componentDim'] ?>" <?=$slcted ?> ><?= $compwidth['componentDim'] ?> </option>  
              <?php endforeach; ?> 
            </select>   
        </div>
        
    </div>

    <div class="form-row">
        <div class="form-group col-sm-4">
        <label for="hblegqty">Supporting Leg Qty:<br></label>  
        <select name = "hblegqty" id = "hblegqty" class="form-select headboardfield" >
            <?php
            for($i=0; $i<=11; $i++)
            {
                $slcted='';
                if ($purchase['headboardlegqty']==$i) {
                    $slcted='selected';
                }

            ?> 
                <option value="<?= $i ?>" <?=$slcted ?> ><?= $i ?> </option>  
            <?php } ?> 
            </select>  
        </div>

        <div class="form-group col-sm-4" id="footboard">
        <label for="footboardheight">Footboard Height:<br></label>  
        <select name = "footboardheight" id = "footboardheight" class="form-select headboardfield">
         <?php foreach ($footboardheights as $footboardheight): 
                $slcted=''; 
                if ($purchase['footboardheight']== $footboardheight['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $footboardheight['optionText'] ?>" <?=$slcted ?> ><?= $footboardheight['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
        </div>

        <div class="form-group col-sm-4" id="manhattantrimdiv">
        <label for="manhattantrim">Wooden Headboard Trim:<br></label>  
        <select name = "manhattantrim" id = "manhattantrim" class="form-select headboardfield" onchange = "getHeadboardTrimListPrice(); resetPriceField('headboardtrimprice',10); showHideHeadboardPriceSummaryRow(10); manhattanTrim();">
         <?php foreach ($hbtrim as $hbtrimrow): 
                $slcted=''; 
                if ($purchase['manhattantrim']== $hbtrimrow['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $hbtrimrow['optionText'] ?>" <?=$slcted ?> ><?= $hbtrimrow['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
        </div>

        <div class="form-group col-sm-4" id="footboardfinishdiv">
        <label for="footboardfinish">Footboard Finish:<br></label>  
        <select name = "footboardfinish" id = "footboardfinish" class="form-select headboardfield">
         <?php foreach ($footboardfinish as $footboardfinishrow): 
                $slcted=''; 
                if ($purchase['footboardfinish']== $footboardfinishrow['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $footboardfinishrow['optionText'] ?>" <?=$slcted ?> ><?= $footboardfinishrow['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
        </div>
        
    </div>
    <div class="form-row">
        <div class="form-group col-sm-2">
        <label for="hbfabricoptions">Fabric Options:<br></label>  
        <select name = "hbfabricoptions" id = "hbfabricoptions" class="form-select headboardfield">
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
        <div class="form-group col-sm-2">
        <label for="basefabricdirection" class="uphhide">Headboard Fabric Direction</label><br>
        <select name = "hbfabricdirection" id = "hbfabricdirection" class="form-select headboardfield" >
            <?php foreach ($hbfabdirection as $hbfabdirectionrow): 
                $slcted=''; 
                if ($purchase['headboardfabricdirection']== $hbfabdirectionrow['optionVal']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $hbfabdirectionrow['optionVal'] ?>" <?=$slcted ?> ><?= $hbfabdirectionrow['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>
    </div>
        <div class="form-group col-sm-8">
            <label for="headboardfabric">Headboard Fabric Company:</label><br>
            <input name = "headboardfabric"style="width:95%" value = "<?= $purchase['headboardfabric'] ?>" class="form-control form-control-sm headboardfield" type = "text" id = "headboardfabric" maxlength = "50"  >
        </div>
        
    </div>
    <div class="form-row">
    <div class="form-group col-sm-2">
            <label for="hbfabricmeters">Fabric Quantity (meters):</label><br> 
            <input name = "hbfabricmeters" value = "<?= $purchase['hbfabricmeters'] ?>" class="form-control form-control-sm headboardfield" type = "number" id = "hbfabricmeters" size = "15" placeholder="0"oninput="calcHBFabricPrice()">
            </div>
        <div class="form-group col-sm-2">
        <label for="hbfabriccost">Price Per Metre:</label><br>
            <input name = "hbfabriccost" value = "<?= $purchase['hbfabriccost'] ?>" class="form-control form-control-sm headboardfield" type = "number" class="xview" id = "hbfabriccost" size = "15" placeholder="0" oninput="calcHBFabricPrice()">
            </div>
            
            <div class="form-group col-sm-8">
            <label for="headboardfabricchoice">Fabric Design, Colour & Code:</label><br>
            
                <input name = "headboardfabricchoice" style="width:95%" value = "<?= $purchase['headboardfabricchoice'] ?>" class="form-control form-control-sm headboardfield" type = "text" id = "headboardfabricchoice" maxlength = "100">
            </div>
</div>

<div class="form-row">
    <div class="form-group col-sm-6">
        <label for="headboardfabricdesc">Headboard Fabric Description:</label><br> 
        <textarea name = "headboardfabricdesc" id="headboardfabricdesc" class="form-control headboardfield"  style="width:90%" rows = "1" maxlength="250"><?= $purchase['headboardfabricdesc'] ?></textarea><span class="pull-right label label-default" id="headboardfabricdesccount"></span>
    </div>

    <div class="form-group col-sm-6">
        <label for="specialinstructionsheadboard">Headboard Special Instructions:</label><br> 
        <textarea name = "specialinstructionsheadboard" id="specialinstructionsheadboard" class="form-control headboardfield"  style="width:93%" rows = "1" maxlength="250"><?= $purchase['specialinstructionsheadboard'] ?></textarea><span class="pull-right label label-default" id="specialinstructionsheadboardcount"></span>
    </div>
</div> 
    <div class="form-row">
        <div class="form-group col-sm-2">
        <div id = "tick5">
<img src = "/img/virginia.gif" alt = "Virginia" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick6">
<img src = "/img/savoy.gif" alt = "Savoy" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick7">
<img src = "/img/penelope.gif" alt = "Penelope" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick8">
<img src = "/img/nicky.gif" alt = "Nicky" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick9">
<img src = "/img/mary.gif" alt = "Mary" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick10">
<img src = "/img/ian.gif" alt = "Ian" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick11">
<img src = "/img/hatti.gif" alt = "Hatti" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick12">
<img src = "/img/holly.gif" alt = "Holly" width = "77" height = "119" hspace = "30"
align = "right">
</div>

<div id = "tick13">
<img src = "/img/f100.gif" alt = "F100" width = "77" height = "119" hspace = "30"
align = "right">
</div>

<div id = "tick14">
<img src = "/img/MF31.gif" alt = "Alex (M31)" width = "115" height = "119" hspace = "30"
align = "right">
</div>

<div id = "tick15">
<img src = "/img/MF32.gif" alt = "Elizabeth (M32)" width = "112" height = "119" hspace = "30"
align = "right">
</div>

<div id = "tick16">
<img src = "/img/Animal.gif" alt = "Animal" width = "91" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick17">
<img src = "/img/leo.gif" alt = "Leo (CF5)" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick18">
<img src = "/img/lotti.gif" alt = "Lotti (CF4)" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick19">
<img src = "/img/harlech.gif" alt = "Harlech (CF2)" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick20">
<img src = "/img/felix.gif" alt = "Felix (TF30)" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick21">
<img src = "/img/claudia.gif" alt = "Claudia" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick22">
<img src = "/img/gorrivan.gif" alt = "Gorrivan" width = "115" height = "119" hspace = "30"
align = "right">
</div>
        </div>
    </div>

    

<div class="form-row xview" style="margin-bottom:0px;">
        <div class="col-sm-9"> 
            <p>Headboard price summary
        </div>
        <div class="form-group form-inline col-sm-3 justify-content-end headboardsummary15">
        <label for="hbfabricprice">Fabric Price Total&nbsp;</label><?=$this->OrderForm->getCurrencySymbol()?>
        <input style="max-width:90px;" name = "hbfabricprice" type = "number" id = "hbfabricprice" class="form-select headboardfield" size = "15" value="<?= $purchase['hbfabricprice'] ?>" placeholder=0  onchange="calcTotalHeadboardPrice()" readonly>
        </div>
</div>

<div class="form-row xview" style="margin-top:0px;">
    <div class="col-sm-2 xview">
    <span class="headboardtrimdiscountcls headboardsummary10">
		List Price: <?=$this->OrderForm->getCurrencySymbol()?><span id="headboardtrimlistpricespan"><?=$headboardTrimDiscount['standardPrice']?></span>
		<input type="hidden" name="headboardtrimlistprice" id="headboardtrimlistprice" value="<?=$headboardTrimDiscount['standardPrice']?>" onchange="setHeadboardTrimPrice();" />
	</span>
    </div>
    <div class="col-sm-4 xview">
        <span class="headboardtrimdiscountcls headboardsummary10">
            Discount: %
            <input type="radio" name="headboardtrimdiscounttype" id="headboardtrimdiscounttype1" class="headboardfield" value="percent" <?= $headboardTrimDiscount['discountType']=="percent" ? 'checked' : '' ?> onchange="setHeadboardTrimPrice();" />
            &nbsp;<?=$this->OrderForm->getCurrencySymbol()?>
            <input type="radio" name="headboardtrimdiscounttype" id="headboardtrimdiscounttype2" class="headboardfield" value="currency" <?= $headboardTrimDiscount['discountType']=="currency" ? 'checked' : '' ?> onchange="setHeadboardTrimPrice();" />
            &nbsp;
            <input name="headboardtrimdiscount" value="<?=$headboardTrimDiscount['discount']?>" type="text" id="headboardtrimdiscount" size="10" class="headboardfield" onchange="setHeadboardTrimPrice();" />
	    </span>
    </div>
    <div class="form-group form-inline col-sm-6 justify-content-end headboardsummary10 xview">Trim&nbsp;
		<span class="cursym"><?=$this->OrderForm->getCurrencySymbol()?></span>
		<label><input name="headboardtrimprice" value="<?=$purchase['headboardtrimprice']?>" type="text" id="headboardtrimprice" class="headboardfield" size="10" onchange="setHeadboardTrimDiscount();"></label>
        </div>
</div>



<div class="form-row xview" style="margin-top:0px;">
    <div class="col-sm-2">
    <p class="headboarddiscountcls">List Price: <?=$this->OrderForm->getCurrencySymbol()?><span id = "headboardlistpricespan"><?=$headboardDiscount['standardPrice']?></span></p>
    </div>
    <div class="col-sm-6">
        <span class="headboarddiscountcls">
        <label for="headboarddiscount">Discount:</label>&nbsp;
        <label class="form-check-label" for="headboarddiscounttype">%</label>
        <input class="headboardfield" type="radio" name="headboarddiscounttype" id="headboarddiscounttype1" value="percent" <?= $headboardDiscount['discountType']=="percent" ? 'checked' : '' ?> onchange = "setHeadboardPrice();" >&nbsp;&nbsp;
        <label class="form-check-label" for="headboarddiscounttype"> <?=$this->OrderForm->getCurrencySymbol()?> </label>
        <input class="headboardfield" type="radio" name="headboarddiscounttype" id="headboarddiscounttype2" value="currency" <?= $headboardDiscount['discountType']=="currency" ? 'checked' : '' ?> onchange = "setHeadboardPrice();">
        <input name = "headboarddiscount" type = "text" id = "headboarddiscount" class="headboardfield" size = "10" value="<?=$headboardDiscount['discount']?>" onchange = "setHeadboardPrice();">
        </span>
    </div>

    <div class="form-group form-inline col-sm-4 justify-content-end">
        <label for="headboardprice">Headboard&nbsp;</label><?=$this->OrderForm->getCurrencySymbol()?>
        <input style="max-width:90px;" name = "headboardprice" type = "number" id = "headboardprice" class="form-select headboardfield" size = "15" value="<?= $purchase['headboardprice'] ?>" placeholder=0 onchange="calcTotalHeadboardPrice(); setHeadboardDiscount();">

        </div>
    </div>
    <div class="form-row xview" style="margin-top:0px;">
    <div class="col-sm-6">
            </div>
        <div class="form-group form-inline col-sm-6 justify-content-end">
        <label for="totalheadboardprice">Total Headboard Price&nbsp;</label><?=$this->OrderForm->getCurrencySymbol()?>
        <input style="max-width:90px;" name = "totalheadboardprice" type = "number" id = "totalheadboardprice" class="form-select headboardfield" size = "15" value="" placeholder=0 readonly>

        </div>
</div>
<div class="form-row showWholesale xview">
    <div class="col-sm-9">
    </div>
    <div class="form-group  bordergris col-sm-3">
    <p align='right'><b>Wholesale Pricing</b></p>
        <p align='right'>
        Fabric Price per meter&nbsp;
        <?=$this->OrderForm->getCurrencySymbol()?>    
        <input style="max-width:90px;" name = "whbfabricprice" type = "text" class="form-select headboardfield" id = "whbfabricprice" size = "10" value="<?= $hbfabricwholesaleprice ?>">
        </p>
        <p align='right' class="showTrimWholesale">Trim <?=$this->OrderForm->getCurrencySymbol()?>    
        <input style="max-width:90px;" name = "whbtrimprice" type = "text" class="form-select headboardfield" id = "whbtrimprice" size = "10" value="<?= $hbtrimwholesaleprice ?>">
        </p>
        <p align='right'>Headboard <?=$this->OrderForm->getCurrencySymbol()?>    
        <input style="max-width:90px;" name = "whbprice" type = "text" class="form-select headboardfield" id = "whbprice" size = "10" value="<?= $hbwholesaleprice ?>">
        </p>
    </div> 

</div>
<!-- <input type = "submit" name = "submit" value = "Save Headboard" id = "submit" class = "button" /> -->  
</div><!-- container end -->
<div id="headboard_div">
</form>

<script>
    var headboardFieldChanged = false;
    function headboardInit() {
        $('.showWholesale').hide();
        headboardStyle();
        defaultHeadboardHeight("<?=$purchase['headboardheight']?>")
        manhattanTrimOptions();
        manhattanTrim();
        $("#headboardstyle").change(headboardstyle);
        $("#headboardstyle").change(manhattanTrim);

        instructionsCount('specialinstructionsheadboard','specialinstructionsheadboardcount',250);
        instructionsCount('headboardfabricdesc','headboardfabricdesccount',250);
        calcTotalHeadboardPrice();
        overrideHeadboardSubmit();

        $(".headboardfield").on("change", function() {
            headboardFieldChanged = true;
        });
        $(".headboardfield").on("focus", function() {
            submitComponentForm(8);
        });
        hideHeadboardDiscountFields();
        showHideWholesale();
        disableHeadboardComponentSections(<?=$isComponentLocked?>, '<?=$lockColour?>');
    }

    function hideHeadboardDiscountFields() {
        if (($('#headboardlistprice').val() / 1.0) == 0.0) {
            $('.headboarddiscountcls').hide();
        } else {
            $('.headboarddiscountcls').show();
        }
        if (($('#headboardtrimlistprice').val() / 1.0) == 0.0) {
            $('.headboardtrimdiscountcls').hide();
        } else {
            $('.headboardtrimdiscountcls').show();
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

    function calcHBFabricPrice() {
        var hbfabriccost = $('#hbfabriccost').val() * 1.0
        var hbfabricmeters = $('#hbfabricmeters').val() * 1.0
        var hbFabricPrice = hbfabriccost * hbfabricmeters;
        $('#hbfabricprice').val((hbFabricPrice).toFixed(2));
        calcTotalHeadboardPrice();
    }

	$("#hbfabricprice").change(function(){
    	calcTotalHeadboardPrice();
	});

	$("#headboardprice").change(function(){
    	calcTotalHeadboardPrice();
	});

	$("#headboardtrimprice").change(function(){
    	calcTotalHeadboardPrice();
	});
	
	$("#WHBFabricprice").change(function(){
    	calcTotalWholesaleHeadboardPrice();
	});

	$("#WHBprice").change(function(){
    	calcTotalWholesaleHeadboardPrice();
	});

	$("#WHBTrimprice").change(function(){
    	calcTotalWholesaleHeadboardPrice();
	});

	function calcTotalHeadboardPrice() {
		var price = 0.0;
		price = price + $('#hbfabricprice').val() / 1.0;
		price = price + $('#headboardprice').val() / 1.0;
		price = price + $('#headboardtrimprice').val() / 1.0;
		$('#totalheadboardprice').val(price.toFixed(2));
	}
	
	function calcTotalWholesaleHeadboardPrice() {
		var price = 0.0;
		price = price + $('#WHBFabricprice').val() / 1.0;
		price = price + $('#WHBprice').val() / 1.0;
		price = price + $('#WHBTrimprice').val() / 1.0;
		$('#Wtotalheadboardprice').val(price.toFixed(2));
	}
	
	function showHideHeadboardPriceSummaryRow(compId) {
		if (isComponentRequired(compId)) {
			$('.headboardsummary'+compId).show();
		} else {
			$('.headboardsummary'+compId).hide();
		}
	}

function headboardStyle() {
    hideAllHeadboardSwatches();
    var selection = $("#headboardstyle").val();
    if (selection == "Virginia") {
    $('#tick5').show();
    } else if (selection == "Savoy") {
    $('#tick6').show();
    } else if (selection == "Penelope") {
    $('#tick7').show();
    } else if (selection == "Nicky") {
    $('#tick8').show();
    } else if (selection == "Mary") {
    $('#tick9').show();
    } else if (selection == "Ian (Headboard)") {
    $('#tick10').show();
    } else if (selection == "Hatti") {
    $('#tick11').show();
    } else if (selection == "Holly") {
    $('#tick12').show();
    } else if (selection == "Elliot (F100)") {
    $('#tick13').show();
    } else if (selection == "Alex (MF31)") {
    $('#tick14').show();
    } else if (selection == "Elizabeth (MF32)") {
    $('#tick15').show();
    } else if (selection == "Animal") {
    $('#tick16').show();
    } else if (selection == "Leo (CF5)") {
    $('#tick17').show();
    } else if (selection == "Lotti (CF4)") {
    $('#tick18').show();
    } else if (selection == "Harlech (CF2)") {
    $('#tick19').show();
    } else if (selection == "Felix (TF30)") {
    $('#tick20').show();
    } else if (selection == "Claudia") {
    $('#tick21').show();
    } else if (selection == "Gorrivan") {
    $('#tick22').show();
    }
}

function hideAllHeadboardSwatches() {
$('#tick5').hide();
$('#tick6').hide();
$('#tick7').hide();
$('#tick8').hide();
$('#tick9').hide();
$('#tick10').hide();
$('#tick11').hide();
$('#tick12').hide();
$('#tick13').hide();
$('#tick14').hide();
$('#tick15').hide();
$('#tick16').hide();
$('#tick17').hide();
$('#tick18').hide();
$('#tick19').hide();
$('#tick20').hide();
$('#tick21').hide();
$('#tick22').hide();
}
function defaultHeadboardHeight() {
    var selection = $("#headboardstyle").val();
    $("#footboard").hide();
    $("#footboardfinishdiv").hide();
    if (selection == "Animal" || selection == "Cloud" || selection == "Jane" || selection == "Mary" || selection == "Nicky" || selection == "Ocean" || selection == "Screen" || selection == "Sky" || selection == "(Special as instructions)" || selection == "Upholstered Pull Out Bed (One Double)" || selection == "Upholstered Pull Out Bed (Two Single)") {
        $("#headboardheight").val('TBC');
    }
    if (selection == "Agnes (TF22)" || selection == "Harlech (CF2)" || selection == "Leo (CF5)" || selection == "Lotti (CF4)" || selection == "Olivia)") {
        $("#headboardheight").val('71cm Above Mattress/ Topper');
    }
    if (selection == "Alex (MF31)") {
        $("#headboardheight").val('80cm Above Mattress/ Topper');
    }
    if (selection == "Amelia") {
        $("#headboardheight").val('92cm Above Mattress/ Topper');
    }

    if (selection == "Casper" || selection == "Shift" || selection == "Stella" || selection == "Talia") {
        $("#headboardheight").val('70cm above topper');
    }
    if (selection == "Churchill (Stitched With Trim)" || selection == "Manhattan Holly (Buttoned)" || selection == "Winston (Stitched)") {
        $("#headboardheight").val('145cm From Floor (excluding leg)');
    }
    if (selection == "Claudia") {
        $("#headboardheight").val('124cm Above Mattress/ Topper');
    }
    if (selection == "Couturier") {
        $("#headboardheight").val('134cm From Floor (including leg)');
    }
    if (selection == "Edward") {
        $("#headboardheight").val('105cm above topper');
    }
    if (selection == "Elizabeth (MF32)") {
        $("#headboardheight").val('100cm Above Mattress/ Topper');
    }
    if (selection == "Elliot (F100)" || selection == "Elliot Bedframe (F100 Bedframe)") {
        $("#headboardheight").val('41cm Above Mattress/ Topper');
    }
    if (selection == "Felicity" || selection == "Pierre" || selection == "Soho") {
        $("#headboardheight").val('90cm above topper');
    }
    if (selection == "Felix (TF30)" || selection == "Max") {
        $("#headboardheight").val('94cm Above Mattress/ Topper');
    }
    if (selection == "Finlay") {
        $("#headboardheight").val('120cm above topper');
    }
    if (selection == "Francis") {
        $("#headboardheight").val('77.5cm Above Mattress/ Topper');
    }
    if (selection == "Fringe") {
        $("#headboardheight").val('175cm floor to top');
    }
    if (selection == "George" || selection == "Hugo") {
        $("#headboardheight").val('160cm Floor to Top');
    }
    if (selection == "Gorrivan" || selection == "Gorrivan Headboard & Footboard") {
        $("#headboardheight").val('108cm Above Mattress/ Topper');
    }
    if (selection == "Gorrivan Headboard & Footboard") {
        $("#footboard").show();
        $("#footboardfinishdiv").show();
        $("#footboardheight").val('10cm Above Mattress/Topper');
    } else {
        $("#footboard").hide();
        $("#footboardfinishdiv").hide();
    }
    if (selection == "Hatti" || selection == "Holly" || selection == "Holly Bedframe") {
        $("#headboardheight").val('145cm From Floor (excluding leg)');
    }
    if (selection == "Heston") {
        $("#headboardheight").val('75cm above topper');
    }
    if (selection == "Ian (Bedframe)") {
        $("#headboardheight").val('100cm From Floor (excluding leg)');
    }
    if (selection == "Ian (Headboard)") {
        $("#headboardheight").val('50cm Above Mattress/ Topper');
    }
    if (selection == "Kiku") {
        $("#headboardheight").val('150cm Above Mattress/ Topper');
    }
    if (selection == "Lenoir" || selection == "Savoy") {
        $("#headboardheight").val('75cm Above Mattress/ Topper');
    }
    if (selection == "Margot" || selection == "William") {
        $("#headboardheight").val('100cm above topper');
    }
    if (selection == "Moon - Standard") {
        $("#headboardheight").val('125cm above topper');
    }
    if (selection == "Moon - Tall") {
        $("#headboardheight").val('140cm above topper');
    }
    if (selection == "Penelope" || selection=="Sebastian") {
        $("#headboardheight").val('150cm from floor');
    }
    if (selection == "State") {
        $("#headboardheight").val('180cm From Floor (excluding leg)');
    }
    if (selection == "Virginia") {
        $("#headboardheight").val('60cm Above Mattress/ Topper');
    }
}

function manhattanTrimOptions() {
    var slct = $("#headboardstyle").val();
    if (slct && (slct.substring(0, 9) == 'Manhattan' || slct == 'Holly' || slct == 'Hatti' || slct == 'Harlech (CF2)' || slct == 'Lotti (CF4)' || slct == 'Leo (CF5)' || slct == 'Winston (Stitched)' || slct == 'C2' || slct == 'C4' || slct == 'C5' || slct == 'CF2' || slct == 'CF4' || slct == 'CF5')) {
    $('#manhattantrimdiv').show();
    } else {
    $("#manhattantrim option[value='--']").attr('selected', 'selected');
    $('#manhattantrimdiv').hide();
    }
}

function manhattanTrim() {
    var slct = $("#manhattantrim").val();
    if (slct && (slct.substring(0, 2) == '--' )) {
       $('#WHBTrimprice').val(0);
	   $('.showTrimWholesale').hide();
    } else {
        $('.showTrimWholesale').show();
    }
}

    function disableHeadboardComponentSections(disable, lockColour) {
        if (disable) {
            $('#headboardrequired_y').attr('disabled', true);
            $('#headboardrequired_n').attr('disabled', true);
            $('#headboard_div :input').attr('disabled', true);
            $('#headboard_div :input').css('color', lockColour);
            $('.showWholesale :input').attr('disabled', false);
        }
    }

    function overrideHeadboardSubmit() { 
        $('#headboardform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Order/saveHeadboard',
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
        headboardFieldChanged = false;
    }

    function submitHeadboardForm() {
        $('#headboardform').submit();
    }   
    
</script>
