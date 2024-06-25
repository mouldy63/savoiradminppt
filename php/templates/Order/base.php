<?php use Cake\Routing\Router; ?>
<form name="baseform" id="baseform" method="post" action="/php/Order/saveBase" style="padding:5px;">
<input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />
<div id="base_div">
	<div class="form-row">
        <div class="form-group col-md-2">
        <label for="basesavoirmodel">Savoir Model:</label>     
        
          <p><select id = "basesavoirmodel" class="form-select basefield"  name = "basesavoirmodel" onChange="getBaseListPrice();  getBaseTrimListPrice(); getBaseUpholsteryListPrice(); getMadeAt(); showbasetickingoptions(false); basevegantext();" >
          <option value = "n">--</option>
             <?php foreach ($bedmodels as $bedmodel): 
                $slcted=''; 
                if ($purchase['basesavoirmodel']== $bedmodel['bedmodel']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $bedmodel['bedmodel'] ?>" <?=$slcted ?> ><?= $bedmodel['bedmodel'] ?> </option>    
            <?php endforeach; ?>       
            </select>  
        </div> 
        <div class="form-group col-md-2">
        <label for="basetype">Base Type:</label>   
        
        <select name = "basetype" class="form-select basefield" id = "basetype" onChange = "basespecialwidthSelected(true); basespeciallengthSelected(true); setLinkPosition(null);" >
        <?php foreach ($comptypes as $comptype): 
                $slcted=''; 
                if ($purchase['basetype']== $comptype['componentType']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $comptype['componentType'] ?>" <?=$slcted ?> ><?= $comptype['componentType'] ?> </option>  
              <?php endforeach; ?> 
        </select>    
        </div>
        <div class="form-group col-md-2">
        <label for="basetickingoptions">Ticking Options:</label>     
        <select name = "basetickingoptions" id = "basetickingoptions" class="form-select basefield" >
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
        <div class="form-group col-sm-2">
        <label for="basewidth">Base Width: </label> 
            <select name = "basewidth" id = "basewidth"
            onChange = "basespecialwidthSelected(true); getBaseListPrice();" class="form-select basefield" >
            <?php foreach ($compwidths as $compwidth): 
                $slcted=''; 
                if ($purchase['basewidth']== $compwidth['componentDim']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $compwidth['componentDim'] ?>" <?=$slcted ?> ><?= $compwidth['componentDim'] ?> </option>  
              <?php endforeach; ?> 
            </select>     
        </div>  
        <div class="form-group col-sm-2">
        <label for="baselength">Base Length: </label>     
         <select name = "baselength" id = "baselength"  onChange = "basespeciallengthSelected(true);  getBaseListPrice(); " class="form-select basefield" >
         <?php foreach ($complengths as $complength): 
                $slcted=''; 
                if ($purchase['baselength']== $complength['componentDim']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $complength['componentDim'] ?>" <?=$slcted ?> ><?= $complength['componentDim'] ?> </option>  
              <?php endforeach; ?> 
         </select>
        </div> 
       
        <div id = "tick1b"  class="form-group col-sm-2">
        <img src = "/img/white-trellis.jpg" alt = "White Trellis" height="50px" align="right">
        </div>

        <div id = "tick2b"  class="form-group col-sm-2">
        <img src = "/img/grey-trellis.jpg" alt = "Grey Trellis" height="50px" align="right">
        </div>

        <div id = "tick3b"  class="form-group col-sm-2">
        <img src = "/img/silver-trellis.jpg" alt = "Silver Trellis" height="50px" align="right">
        </div>

        <div id = "tick4b"  class="form-group col-sm-2">
        <img src = "/img/oatmeal-trellis.jpg" alt = "oatmeal Trellis" height="50px" align="right">
        </div>
    </div> <!-- row end -->
    <div class="form-row" id="hidespecial">
        
        <div id = "basespecialwidth1" class="form-group col-sm-2">
        <label for="base1width">Base 1 Special Width cm </label><br><input name = "base1width" type = "text" id = "base1width" value = "<?= empty($prodsizes['Base1Width']) ? '' : htmlspecialchars($prodsizes['Base1Width']) ?>" size = "7" class="form-select basefield" ></div>
    
        <div id = "basespecialwidth2" class="form-group col-sm-2">
        <label for="base2width">Base 2 Special Width cm </label><br><input name = "base2width" type = "text" id = "base2width" value = "<?= empty($prodsizes['Base2Width']) ? '' : htmlspecialchars($prodsizes['Base2Width']) ?>" size = "7" class="form-select basefield" ></div>

        <div id = "basespeciallength1" class="form-group col-sm-2">
        <label for="base1length">Base 1 Special Length cm </label><br><input name = "base1length" type = "text" id = "base1length" value = "<?= empty($prodsizes['Base1Length']) ? '' : htmlspecialchars($prodsizes['Base1Length']) ?>" size = "7" class="form-select basefield" ></div>

        <div id = "basespeciallength2" class="form-group col-sm-2">
        <label for="base2length">Base 2 Special Length cm </label><br><input name = "base2length" type = "text" id = "base2length" value = "<?= empty($prodsizes['Base2Length']) ? '' : htmlspecialchars($prodsizes['Base2Length']) ?>" size = "7" class="form-select basefield" ></div>
   
    </div>
 
    
       
    
 <div class="form-row">
    <div class="form-group col-sm-2">
    <label for="linkposition">Link Position:</label> 
         <select name = "linkposition" id = "linkposition"  onChange = "linkPositionChanged();" class="form-select basefield" >
         <?php foreach ($linkposition as $linkpos): 
                $slcted=''; 
                if ($purchase['linkposition']== $linkpos['linkPosition']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $linkpos['linkPosition'] ?>" <?=$slcted ?> ><?= $linkpos['linkPosition'] ?> </option>  
              <?php endforeach; ?> 
         </select>
    </div>
    <div class="form-group col-sm-2" id="linkfinish1">
    <label for="linkfinish">Link Finish:</label><br>
         <select name = "linkfinish" id = "linkfinish" class="form-select basefield" >
         <?php foreach ($linkfinish as $finish): 
                $slcted=''; 
                if ($purchase['linkfinish']== $finish['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $finish['optionText'] ?>" <?=$slcted ?> ><?= $finish['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>
    </div>
    <div class="form-group col-sm-2">
        <label for="spring">Height Spring:</label>    
        
         <select name = "spring" id = "spring" class="form-select basefield" >
         <?php foreach ($heightspring as $spring): 
                $slcted=''; 
                if ($purchase['baseheightspring']== $spring['BaseHeightSpring']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $spring['BaseHeightSpring'] ?>" <?=$slcted ?> ><?= $spring['BaseHeightSpring'] ?> </option>  
              <?php endforeach; ?> 
         </select>
        </div> 
</div>
<div class="form-row">
    <div class="form-group col-sm-2">
    <label for="basetrim">Base Trim:</label>
         <select name = "basetrim" id = "basetrim" onchange = "setBaseTrimColours(); getBaseTrimListPrice(); resetPriceField('basetrimprice',11); showHideBasePriceSummaryRow(11); baseTrim();" class="form-select basefield" >
         <?php foreach ($basetrim as $basetrimrow): 
                $slcted=''; 
                if ($purchase['basetrim']== $basetrimrow['optionVal']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $basetrimrow['optionVal'] ?>" <?=$slcted ?> ><?= $basetrimrow['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>
    </div>
    <div class="form-group col-sm-2" id="basetrimcolour1">
    <label for="basetrimcolour">Base Trim Colour:</label>
    
         <select name = "basetrimcolour" id = "basetrimcolour" class="form-select basefield" >
         <?php foreach ($basetrimcolour as $basetrimcolourrow): 
                $slcted=''; 
                if ($purchase['basetrimcolour']== $basetrimcolourrow['optionText']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $basetrimcolourrow['optionText'] ?>" <?=$slcted ?> ><?= $basetrimcolourrow['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>
    </div>
    <div class="form-group col-sm-2">
    <label for="drawers">Drawers:</label> <br>
         <select name = "drawerconfig" id = "drawerconfig" onchange = "showDrawersSection(); getBaseDrawersListPrice(); resetPriceField('basedrawersprice',13); showHideBasePriceSummaryRow(13);" class="form-select basefield" >
         <option value="n">No</option>  
         <?php foreach ($drawers as $drawersrow): 
                $slcted=''; 
                if ($purchase['basedrawerconfigID']== $drawersrow['DrawerConfig']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $drawersrow['DrawerConfig'] ?>" <?=$slcted ?> ><?= $drawersrow['DrawerConfig'] ?> </option>  
              <?php endforeach; ?> 
         </select>
    </div>
    <div class="form-group col-sm-2" id="drawerheight1">
    <label for="drawerheight">Drawer Height:</label>
         <select name = "drawerheight" id = "drawerheight" class="form-select basefield" >
         <?php foreach ($drawerheight as $drawerheightrow): 
                $slcted=''; 
                if ($purchase['basedrawerheight']== $drawerheightrow['drawerHeight']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $drawerheightrow['drawerHeight'] ?>" <?=$slcted ?> ><?= $drawerheightrow['drawerHeight'] ?> </option>  
              <?php endforeach; ?> 
         </select>
    </div>
</div>

<div class="form-row">
    <div class="form-group col-sm-12">
    <label for="baseinstructions">Base Special Instructions:</label><br>
    <textarea name = "baseinstructions" id="baseinstructions" class="form-control basefield"  style="width:90%" rows = "1" maxlength="250"><?= $purchase['baseinstructions'] ?></textarea><span class="pull-right label label-default" id="basecount"></span>
    </div>
</div>  
<div class="form-row">
    <div class="form-group col-sm-2">
    <label for="upholsteredbase">Upholstered Base:</label><br>
    <select name = "upholsteredbase" id = "upholsteredbase" onChange = "setLinkPosition(null); upholsteredBaseChanged(); getBaseUpholsteryListPrice(); showHideBasePriceSummaryRow(17); showHideBasePriceSummaryRow(12);" class="form-select basefield" >
         <?php foreach ($uphbase as $uphbaserow): 
                $slcted=''; 
                if ($purchase['upholsteredbase']== $uphbaserow['optionVal']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $uphbaserow['optionVal'] ?>" <?=$slcted ?> ><?= $uphbaserow['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>
    </div>
    <div class="form-group col-sm-2">
    <label for="basefabricdirection" class="uphhide">Base Fabric Direction</label><br>
    <select name = "basefabricdirection" id = "basefabricdirection" class="form-select basefield" >
         <?php foreach ($basefabdirection as $basefabdirectionrow): 
                $slcted=''; 
                if ($purchase['basefabricdirection']== $basefabdirectionrow['optionVal']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $basefabdirectionrow['optionVal'] ?>" <?=$slcted ?> ><?= $basefabdirectionrow['optionText'] ?> </option>  
              <?php endforeach; ?> 
         </select>
    </div>
    <div class="form-group col-sm-8">
    <label for="basefabric" class="uphhide">Fabric Company:</label><br>
        <input name = "basefabric" style="width:95%" value = "<?= $purchase['basefabric'] ?>" class="form-control form-control-sm uphhide basefield" type = "text" id = "basefabric" maxlength = "50"  >
    </div>
</div>
<!-- uphbase start -->
<div class="form-row" id="uphbase">
<div class="form-group col-sm-2">
<label for="basefabriccost">Price Per Metre:</label><br>
    <input name = "basefabriccost" value = "<?= $purchase['basefabriccost'] ?>" onchange="calculateBaseFabricTotal()" class="form-control form-control-sm xview basefield" type = "number" id = "basefabriccost" size = "15" placeholder="0">
    </div>
    <div class="form-group col-sm-2">
    <label for="basefabricmeters">Fabric Quantity:</label><br> 
    <input name = "basefabricmeters" value = "<?= $purchase['basefabricmeters'] ?>" onchange="calculateBaseFabricTotal()" class="form-control form-control-sm basefield" type = "number" id = "basefabricmeters" size = "15" placeholder="0">
    </div>
    <div class="form-group col-sm-8">
    <label for="basefabricchoice">Fabric Design, Colour & Code:</label><br>
        <input name = "basefabricchoice" style="width:95%" value = "<?= $purchase['basefabricchoice'] ?>" class="form-control form-control-sm basefield" type = "text" id = "basefabricchoice" maxlength = "100">
    </div>
</div>

<div class="form-row">
    <div class="form-group col-sm-12">
    <label for="basefabricdesc" class="uphhide">Base Fabric Description:</label><br> 
    <textarea name = "basefabricdesc" id="basefabricdesc" class="form-control uphhide basefield"  style="width:90%" rows = "1" maxlength="250"><?= $purchase['basefabricdesc'] ?></textarea><span class="pull-right label label-default uphhide" id="basefabriccount"></span>
   
            </div>
</div> <!-- uphbase end -->

<div class="form-row xview">
    <div class="col-sm-12">
        <p><b>Base price summary</b></p>
    </div>
</div>

<div class="form-row basesummary17 xview" style="margin-top:0px;">
    <div class="col-sm-2 xview">
        <input type="hidden" name="basefabriclistprice" id="basefabriclistprice" value="<?=$baseFabricDiscount['standardPrice']?>" onchange="setBaseFabricPrice();" />
        <p class="basefabricdiscountcls">List Price <?=$this->OrderForm->getCurrencySymbol()?><span id = "basefabriclistpricespan"><?=$baseFabricDiscount['standardPrice']?></span>
        </div>
    <div class="col-sm-7 xview">
        <label for="basefabricdiscount" class="basefabricdiscountcls">Discount:</label>
        <div class="form-check form-check-inline basefabricdiscountcls">
        <label class="form-check-label" for="basefabricdiscount">%</label>
            <input class="form-check-input basefield" type="radio" name="basefabricdiscounttype" id="basefabricdiscounttype1" value="percent" <?=$baseFabricDiscount['discountType']=="percent" ? 'checked' : '' ?> onchange = "setBaseFabricPrice();" >
            <label class="form-check-label" for="inlineRadio2"><?=$this->OrderForm->getCurrencySymbol()?></label>
            <input class="form-check-input basefield" type="radio" name="basefabricdiscounttype" id="basefabricdiscounttype2" value="currency" <?=$baseFabricDiscount['discountType']=="currency" ? 'checked' : '' ?> onchange = "setBaseFabricPrice();" >
            <input name="basefabricdiscount" value="<?=$baseFabricDiscount['discount']?>" type="text" id="basefabricdiscount" size="10" onchange="setBaseFabricPrice();" />
        </div>
    </div>
        <div class="form-group form-inline col-sm-3 justify-content-end xview">
        <label>Fabric Price Total <?=$this->OrderForm->getCurrencySymbol()?></label>
            <input style="max-width:90px;" name = "basefabricprice" class="basefield" type = "number" id = "basefabricprice" size = "10" value="<?= $purchase['basefabricprice'] ?>" placeholder=0 onchange="setBaseFabricDiscount();" >

        </div>
    </div>
    <div class="form-row basesummary12 xview" style="margin-top:0px;">
    <div class="col-sm-2 xview">
        <input type="hidden" name="upholsterylistprice" id="upholsterylistprice" value="<?=$baseUpholsteryDiscount['standardPrice']?>" onchange="setBaseUpholsteryPrice();" />
        <p class=" upholsterydiscountcls">List Price <?=$this->OrderForm->getCurrencySymbol()?><span id = "upholsterylistpricespan"><?=$baseUpholsteryDiscount['standardPrice']?></span>
        </div>
    <div class="col-sm-7 xview">
        <label for="upholsterydiscount" class="upholsterydiscountcls">Discount:</label>
        <div class="form-check form-check-inline upholsterydiscountcls">
        <label class="form-check-label" for="upholsterydiscount">%</label>
            <input class="form-check-input basefield" type="radio" name="upholsterydiscounttype" id="upholsterydiscounttype1" value="percent" <?=$baseUpholsteryDiscount['discountType']=="percent" ? 'checked' : '' ?> onchange = "setBaseUpholsteryPrice();" >
            <label class="form-check-label" for="inlineRadio2"><?=$this->OrderForm->getCurrencySymbol()?></label>
            <input class="form-check-input basefield" type="radio" name="upholsterydiscounttype" id="upholsterydiscounttype2" value="currency"  <?=$baseUpholsteryDiscount['discountType']=="currency" ? 'checked' : '' ?> onchange = "setBaseUpholsteryPrice();">
            <input name="upholsterydiscount" value="<?=$baseUpholsteryDiscount['discount']?>" type="text" id="upholsterydiscount" size="10" class="basefield" onchange="setBaseUpholsteryPrice();" />
        </div>
    </div>
        <div class="form-group form-inline col-sm-3 justify-content-end xview">
        <label>Upholstery <?=$this->OrderForm->getCurrencySymbol()?></label>
            <input style="max-width:90px;" name = "upholsteryprice" class="basefield" type = "number" id = "upholsteryprice" size = "10" value="<?= $purchase['upholsteryprice'] ?>" placeholder=0 onchange="setBaseUpholsteryDiscount();" >

        </div>
    </div>
<div class="form-row  basesummary11 xview" style="margin-top:0px;">
<div class="col-sm-2 xview">
        <input type="hidden" name="basetrimlistprice" id="basetrimlistprice" value="<?=$baseTrimDiscount['standardPrice']?>" onchange="setBaseTrimPrice();" />
        <p class="basetrimdiscountcls">List Price <?=$this->OrderForm->getCurrencySymbol()?><span id = "basetrimlistpricespan"><?=$baseTrimDiscount['standardPrice']?></span>
        </div>
    <div class="col-sm-7 xview">
        <label for="basetrimdiscount" class="basetrimdiscountcls">Discount:</label>
        <div class="form-check form-check-inline basetrimdiscountcls">
        <label class="form-check-label" for="basetrimdiscount">%</label>
            <input class="form-check-input basefield" type="radio" name="basetrimdiscounttype" id="basetrimdiscounttype1" value="percent" <?=$baseTrimDiscount['discountType']=="percent" ? 'checked' : '' ?> onchange = "setBaseTrimPrice();" >
            <label class="form-check-label" for="inlineRadio2"><?=$this->OrderForm->getCurrencySymbol()?></label>
            <input class="form-check-input basefield" type="radio" name="basetrimdiscounttype" id="basetrimdiscounttype2" value="currency" <?=$baseTrimDiscount['discountType']=="currency" ? 'checked' : '' ?> onchange = "setBaseTrimPrice();">
            <input name="basetrimdiscount" value="<?=$baseTrimDiscount['discount']?>" type="text" id="basetrimdiscount" size="10" class="basefield" onchange="setBaseTrimPrice();" />
        </div>
    </div>
        <div class="form-group form-inline col-sm-3 justify-content-end xview">
        <label>Trim <?=$this->OrderForm->getCurrencySymbol()?></label>
            <input style="max-width:90px;" name = "basetrimprice" class="basefield" type = "number" id = "basetrimprice" size = "10" value="<?= $purchase['basetrimprice'] ?>" placeholder=0 onchange="setBaseTrimDiscount();" >

        </div>
    </div>
    <div class="form-row basesummary13 xview" style="margin-top:0px;">
    <div class="col-sm-2 xview">
        <input type="hidden" name="basedrawerslistprice" id="basedrawerslistprice" size="10" value="<?=$baseDrawersDiscount['standardPrice']?>" onchange="setBaseDrawersPrice();" />
        <p class=" basedrawersdiscountcls">List Price <?=$this->OrderForm->getCurrencySymbol()?><span id = "basedrawerslistpricespan"><?=$baseDrawersDiscount['standardPrice']?></span>
        </div>
    <div class="col-sm-7 xview">
        <label for="basedrawersdiscount" class="basedrawersdiscountcls">Discount:</label>
        <div class="form-check form-check-inline basedrawersdiscountcls">
        <label class="form-check-label" for="basedrawersdiscount">%</label>
            <input class="form-check-input basefield" type="radio" name="basedrawersdiscounttype" id="basedrawersdiscounttype1" value="percent" <?=$baseDrawersDiscount['discountType']=="percent" ? 'checked' : '' ?> onchange="setBaseDrawersPrice();" >
            <label class="form-check-label" for="inlineRadio2"><?=$this->OrderForm->getCurrencySymbol()?></label>
            <input class="form-check-input basefield" type="radio" name="basedrawersdiscounttype" id="basedrawersdiscounttype2" value="currency" <?=$baseDrawersDiscount['discountType']=="currency" ? 'checked' : '' ?> onchange="setBaseDrawersPrice();" >
            <input name="basedrawersdiscount" value="<?=$baseDrawersDiscount['discount']?>" type="text" id="basedrawersdiscount" size="10" class="basefield" onchange="setBaseDrawersPrice();" />
        </div>
    </div>
        <div class="form-group form-inline col-sm-3 justify-content-end xview">
        <label>Drawers <?=$this->OrderForm->getCurrencySymbol()?></label>
            <input style="max-width:90px;" name = "basedrawersprice" class="basefield" type = "number" id = "basedrawersprice" size = "10" value="<?= $purchase['basedrawersprice'] ?>" placeholder=0 onchange="setBaseDrawersDiscount();">

        </div>
    </div>
<div class="form-row xview" style="margin-top:0px;">
<div class="col-sm-2 xview">
        <input type = "hidden" name = "baselistprice" id = "baselistprice" value = "<?=$baseDiscount['standardPrice']?>" onchange = "setBasePrice();" />
        <p class="basediscountcls">List Price <?=$this->OrderForm->getCurrencySymbol()?><span id = "baselistpricespan"><?=$baseDiscount['standardPrice']?></span>
        </div>
    <div class="col-sm-7 xview">
        <label for="basediscount" class="basediscountcls">Discount:</label>
        <div class="form-check form-check-inline basediscountcls">
        <label class="form-check-label" for="basediscount">%</label>
            <input class="form-check-input basefield" type="radio" name="basediscounttype" id="basediscounttype1" value="percent" <?= $baseDiscount['discountType']=="percent" ? 'checked' : '' ?> onchange = "setBasePrice();" >
            <label class="form-check-label" for="inlineRadio2"><?=$this->OrderForm->getCurrencySymbol()?></label>
            <input class="form-check-input basefield" type="radio" name="basediscounttype" id="basediscounttype2" value="currency" <?= $baseDiscount['discountType']=="currency" ? 'checked' : '' ?> onchange = "setBasePrice();">
            <input name = "basediscount" type = "text" id = "basediscount" class="basefield" size = "10" value="<?=$baseDiscount['discount']?>" onchange = "setBasePrice();">
        </div>
    </div>
        <div class="form-group form-inline col-sm-3 justify-content-end xview">
        <label>Base <?=$this->OrderForm->getCurrencySymbol()?></label>
            <input style="max-width:90px;" name = "baseprice" class="basefield" type = "number" id = "baseprice" size = "10" value="<?= $purchase['baseprice'] ?>" placeholder=0 onchange="setBaseDiscount();">

        </div>
    </div>
<div class="form-row xview" style="margin-top:0px;">
        <div class="col-sm-9"> 
           
        </div>
        <div class="form-group form-inline col-sm-3 justify-content-end">
        <label for="totalbaseprice"><strong>Total Base Price</strong>&nbsp;</label><?=$this->OrderForm->getCurrencySymbol()?>
        <input style="max-width:90px;" name = "totalbaseprice" type = "number" id = "totalbaseprice" class="form-select basefield" readonly="true" size = "10" >

        </div>
    </div>

<div class="form-row showWholesale xview">
    <div class="col-sm-9">
    </div>
    <div class="form-group bordergris col-sm-3">
    <p align='right'><b>Wholesale Pricing</b></p>
        <p align='right'>Fabric Price (mtr)&nbsp;
        <?=$this->OrderForm->getCurrencySymbol()?>    
        <input style="max-width:90px;" name = "wbasefabricprice" type = "text" class="form-select basefield" id = "wbasefabricprice" size = "10" value="<?= $basefabricwholesaleprice ?>"></p>
        <p align='right'>Upholstery&nbsp;
        <?=$this->OrderForm->getCurrencySymbol()?>    
        <input style="max-width:90px;" name = "wbaseuphprice" type = "text" class="form-select basefield" id = "wbaseuphprice" size = "10" value="<?= $baseuphwholesaleprice ?>"></p>
        <p align='right'>Trim&nbsp;
        <?=$this->OrderForm->getCurrencySymbol()?>    
        <input style="max-width:90px;" name = "wbasetrimprice" type = "text" class="form-select basefield" id = "wbasetrimprice" size = "10" value="<?= $basetrimwholesaleprice ?>"></p>
        <p align='right'>Base&nbsp;
        <?=$this->OrderForm->getCurrencySymbol()?>    
        <input style="max-width:90px;" name = "wbaseprice" type = "text" class="form-select basefield" id = "wbaseprice" size = "10" value="<?= $basewholesaleprice ?>"></p>
        
    </div> 

</div>
</div> <!-- base_div end -->
<!-- <input type = "submit" name = "submit" value = "Save Base" id = "submit" class = "button" />  -->


</form>

<script>

    function calcBaseFabricListPrice(baseFabricListPrice) {
        if (baseFabricListPrice == null || baseFabricListPrice == 0.0) {
            var basefabriccost = $('#basefabriccost').val()*1.0
            var basefabricmeters = $('#basefabricmeters').val()*1.0
            baseFabricListPrice = basefabriccost * basefabricmeters;
        }
        $('#baseFabricListPrice').val((baseFabricListPrice).toFixed(2));
        $('#basefabriclistpricespan').html(baseFabricListPrice.toFixed(2));
        setBaseFabricPrice();
    }

    var baseFieldChanged = false;
    function baseInit() {
        $('.showWholesale').hide();
        baseTickingSelected();
        $("#tickingoptions").change(baseTickingSelected);
        basespecialwidthSelected(false);
        basespeciallengthSelected(false);
        setLinkPosition("<?=$purchase['linkposition']?>");
        setBaseTrimColours("<?=$purchase['basetrimcolour']?>");
        showDrawersSection();
        instructionsCount('baseinstructions','basecount',250);
        instructionsCount('basefabricdesc','basefabriccount',250);
        upholsteredBaseChanged();
        showbasetickingoptions(true); // so that the ticking options are restricted on page load for vegan beds
        baseTrim();
	    wholesaleDrawers();
        // show/hide the lines of the base price summary table
        showHideBasePriceSummaryRow(11);
        showHideBasePriceSummaryRow(12);
        showHideBasePriceSummaryRow(13);
        showHideBasePriceSummaryRow(17);
        calcTotalWholesaleBasePrice();
        calcTotalBasePrice();
        overrideBaseSubmit();

        $(".basefield").on("change", function() {
            baseFieldChanged = true;
        });
        
        $(".basefield").on("focus", function() {
            submitComponentForm(3);
        });
        hideBaseDiscountFields();
        showHideWholesale();
        disableBaseComponentSections(<?=$isComponentLocked?>, '<?=$lockColour?>');
    }

    function hideBaseDiscountFields() {
        if (($('#baselistprice').val() / 1.0) == 0.0) {
            $('.basediscountcls').hide();
        } else {
            $('.basediscountcls').show();
        }
    }
   
    function setBaseTrimColours(defaultColour) {

        var selectedTrim = $("#basetrim option:selected").val();
        var colourOptions = [];

        if (selectedTrim == "Standard") {
            $("#basetrimcolour option[value='TBC']").show();
            $("#basetrimcolour option[value='Walnut']").show();
            $("#basetrimcolour option[value='Ebony']").show();
            $("#basetrimcolour option[value='Oak']").show();
            $("#basetrimcolour option[value='Maple']").show();
            $("#basetrimcolour option[value='Ebony Macassar']").hide();
            $("#basetrimcolour option[value='Burr Walnut']").hide();
        } else if (selectedTrim == "Self Levelling") {
            $("#basetrimcolour option[value='TBC']").show();
            $("#basetrimcolour option[value='Ebony Macassar']").show();
            $("#basetrimcolour option[value='Burr Walnut']").show();
            $("#basetrimcolour option[value='Walnut']").hide();
            $("#basetrimcolour option[value='Ebony']").hide();
            $("#basetrimcolour option[value='Oak']").hide();
            $("#basetrimcolour option[value='Maple']").hide();
        }
        if (defaultColour != "") {
            $("#basetrimcolour option[value='" + defaultColour + "']").attr('selected', 'selected');
        }

        if (selectedTrim == "n" || selectedTrim=='') {
            $('#basetrimcolour1').hide();
            $('#basetrimcolour2').hide();
        } else {
            $('#basetrimcolour1').show();
            $('#basetrimcolour2').show();
        }
}

    function showDrawersSection() {
        var value = $('#drawers').val();
        if (value!="n") {
            $('#drawerheight1').show();
            $('#drawerheight').show();
        } else{
            $('#drawerheight1').hide();
            $('#drawerheight').hide();
        }
    }

    function upholsteredBaseChanged() {
        var value = $('#upholsteredbase').val();
        if (value == 'n' || value == 'TBC') {
            $('#uphbase').hide("slow");
            $('.uphhide').hide("slow");
            $('#basefabricdirection').hide();
            $('#basefabric').val("");
            $('#basefabricchoice').val("");
            $('#basefabriccost').val("");
            $('#basefabricmeters').val("");
            $('#basefabricdesc').val("");
            $('#basefabricprice').val("");
        } else {
            $('.uphhide').show("slow");
            $('#basefabricdirection').show("slow");
            $('#uphbase').show("slow");
            
        }
    }

    function showbasetickingoptions(pageload) {
        var selection = $("#basesavoirmodel").val();
        if (selection == "No. 4v") {
            $("#basetickingoptions option[value='n']").hide();
            $("#basetickingoptions option[value='TBC']").hide();
            $("#basetickingoptions option[value='White Trellis']").hide();
            $("#basetickingoptions option[value='Silver Trellis']").hide();
            if (!pageload) {
                // only default the ticking option if we're here because the base model was changed
                $("#basetickingoptions option[value='Grey Trellis']").attr('selected', 'selected');
            }
            $('#specialinstructions2').val('Vegan Bed - Vegan materials to be used');
        } else {
            $("#basetickingoptions option[value='n']").show();
            $("#basetickingoptions option[value='TBC']").show();
            $("#basetickingoptions option[value='White Trellis']").show();
            $("#basetickingoptions option[value='Silver Trellis']").show();
            $("#basetickingoptions option[value='Grey Trellis']").show();
            $('#specialinstructions2').val('');
        }
    }

    function baseTickingSelected() {
        $('#tick1b').hide();
        $('#tick2b').hide();
        $('#tick3b').hide();
        $('#tick4b').hide();
        
        var selection = $("#tickingoptions").val();
        if (selection == "White Trellis") {
            $('#tick1b').show();
        } else if (selection == "Grey Trellis") {
            $('#tick2b').show();
        } else if (selection == "Silver Trellis") {
            $('#tick3b').show();
        }
    }

    function basespecialwidthSelected(clearvalues) {
        hidebasespecialwidth(clearvalues);
        var selection = $("#basewidth").val();
        var selection2 = $("#basetype").val();
        if ((selection == "Special Width") && ((selection2 == "North-South Split") || (selection2 == "East-West Split"))) {
        $('#specialwidth').show();
        $('#basespecialwidth1').show();
        $('#basespecialwidth2').show();
        }
        if ((selection == "Special Width") && ((selection2 != "North-South Split") && (selection2 != "East-West Split"))) {
        $('#specialwidth').show();
        $('#basespecialwidth1').show();
        }
    }

    function hidebasespecialwidth(clearvalues) {
        if (clearvalues) {
        $("#base1width").val("");
        $("#base2width").val("");
        }
        $('#specialwidth').hide();
        $('#basespecialwidth1').hide();
        $('#basespecialwidth2').hide();
        
        }

   
    function basespeciallengthSelected(clearvalues) {
        hidebasespeciallength(clearvalues);
        var selection = $("#baselength").val();
        var selection2 = $("#basetype").val();
        if (selection == "Special Length" && (selection2 == "North-South Split" || selection2 == "East-West Split")) {
        $('#basespeciallength1').show();
        $('#basespeciallength2').show();
        }
        if ((selection == "Special Length") && ((selection2 != "North-South Split") && (selection2 != "East-West Split"))) {
        $('#basespeciallength1').show();
        $("#base2length").val("");
        $('#basespeciallength2').hide();
        }
    }

    function hidebasespeciallength(clearvalues) {
        if (clearvalues) {
        $("#base1length").val("");
        $("#base2length").val("");
        }
        $('#basespeciallength1').hide();
        $('#basespeciallength2').hide();
        
    }

    function setLinkPosition(defaultSelection) {
        if (defaultSelection == null) defaultSelection = "";
        var slctUpBase = $("#upholsteredbase option:selected").val();
        var slctBaseType = $("#basetype option:selected").val();
        
        var linkPositionOptions = [];
        linkPositionOptions.push("Link Underneath");
        if (slctUpBase != "Yes") {
            $("#linkposition option[value='Link on Ends']").hide();
        } else {
            $("#linkposition option[value='Link on Ends']").show();
        }
        linkPositionOptions.push("No Link Required");
        
        if (defaultSelection == "") {
            if (slctBaseType == "One Piece") {
                defaultSelection = "No Link Required";
            } else {
                defaultSelection = "Link Underneath";
            }
        }
        //console.log("defaultSelection = " + defaultSelection);
        
        $('#linkposition').find('option').remove();
        $.each(linkPositionOptions, function(val, text) {
            $('#linkposition').append($('<option></option>').val(text).html(text));
        });
        if (defaultSelection != "") {
            $("#linkposition option[value='" + defaultSelection + "']").attr('selected', 'selected');
        }
        
        linkPositionChanged();
    }
    function linkPositionChanged() {
        var val = $("#linkposition option:selected").val();
        if (val == "No Link Required") {
        $("#linkfinish").val("n")
        $('#linkfinish1').hide();
        $('#linkfinish2').hide();
        } else {
        $('#linkfinish1').show();
        $('#linkfinish2').show();
        //$("#linkfinish").val('Brass'); 
        }
    }

    function basevegantext() {
        var selection = $("#basesavoirmodel").val();
        if (selection == "No. 4v") {
     	    $('#specialinstructions2').val('Vegan Bed - Vegan materials to be used,' + $('#specialinstructions2').val());
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

    function calculateBaseFabricTotal() {
        var number1 = document.getElementById('basefabriccost').value;
        var number2 = document.getElementById('basefabricmeters').value;

        var total = parseFloat(number1) * parseFloat(number2);

        if (!isNaN(total)) {
            var roundedTotal = total.toFixed(2);
            document.getElementById('basefabricprice').value = roundedTotal;
        } else {
            document.getElementById('basefabricprice').value = 0;
        }
    	calcTotalBasePrice();
    }

    $("#basefabricprice").change(function(){
    	calcTotalBasePrice();
	});
	
	$("#upholsteryprice").change(function(){
    	console.log("upholsteryprice changed");
    	calcTotalBasePrice();
	});

	$("#basetrimprice").change(function(){
    	console.log("basetrimprice changed");
    	calcTotalBasePrice();
	});

	$("#basedrawersprice").change(function(){
    	console.log("basedrawersprice changed");
    	calcTotalBasePrice();
	});

	$("#baseprice").change(function(){
    	console.log("baseprice changed");
    	calcTotalBasePrice();
	});
	
	$("#WBaseFabricprice").change(function(){
    	console.log("WBaseFabricprice changed");
    	calcTotalWholesaleBasePrice();
	});
	
	$("#WBaseUphprice").change(function(){
    	console.log("WBaseUphprice changed");
    	calcTotalWholesaleBasePrice();
	});

	$("#WBaseTrimprice").change(function(){
    	console.log("WBaseTrimprice changed");
    	calcTotalWholesaleBasePrice();
	});

	$("#WBaseDrawerprice").change(function(){
    	console.log("WBaseDrawerprice changed");
    	calcTotalWholesaleBasePrice();
	});

	$("#WBaseprice").change(function(){
    	console.log("WBaseprice changed");
    	calcTotalWholesaleBasePrice();
	});

    function baseTrim() {
        var slct = $("#basetrim").val();
        if (slct && (slct.substring(0, 1) == 'n' )) {
            $('#WBaseTrimprice').val(0);
            $('#showBaseTrimWholesale').hide();
        } else {
            $('#showBaseTrimWholesale').show();
        }
    }

    function wholesaleDrawers() {
        var slct = $("#drawerconfig").val();
        if (slct && (slct.substring(0, 1) == 'n' )) {
            $('#WBaseDrawerprice').val(0);
            $('#showDrawerWholesale').hide();
        } else {
            $('#showDrawerWholesale').show();
        }
    }

    function calcTotalBasePrice() {
		var price = 0.0;
		price = price + $('#basefabricprice').val() / 1.0;
		price = price + $('#upholsteryprice').val() / 1.0;
		price = price + $('#basetrimprice').val() / 1.0;
		price = price + $('#basedrawersprice').val() / 1.0;
		price = price + $('#baseprice').val() / 1.0;
		$('#totalbaseprice').val(price.toFixed(2));
	}

    function calcTotalWholesaleBasePrice() {
		var price = 0.0;
		price = price + $('#WBaseFabricprice').val() / 1.0;
		price = price + $('#WBaseUphprice').val() / 1.0;
		price = price + $('#WBaseTrimprice').val() / 1.0;
		price = price + $('#WBaseDrawerprice').val() / 1.0;
		price = price + $('#WBaseprice').val() / 1.0;
		$('#Wtotalbaseprice').val(price.toFixed(2));
	}

    function showHideBasePriceSummaryRow(compId) {
		console.log("showHideBasePriceSummaryRow: compId=" + compId);
		if (isComponentRequired(compId)) {
			$('.basesummary'+compId).show();
		} else {
			$('.basesummary'+compId).hide();
		}
	}
    
    function disableBaseComponentSections(disable, lockColour) {
        if (disable) {
            $('#baserequired_y').attr('disabled', true);
            $('#baserequired_n').attr('disabled', true);
            $('#base_div :input').attr('disabled', true);
            $('#base_div :input').css('color', lockColour);
            $('.showWholesale :input').attr('disabled', false);
        }
    }

    function overrideBaseSubmit() { 
        $('#baseform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Order/saveBase',
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
        baseFieldChanged = false;
    }

    function submitBaseForm() {
        $('#baseform').submit();
    }
</script>