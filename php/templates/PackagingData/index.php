<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->script('SpryTabbedPanels.js', ['block' => true]);
 echo $this->Html->css('SpryTabbedPanels.css', ['block' => true]);
  ?>





<div id="brochureform" class="brochure">
<div class="one-col head-col">
<div id="TabbedPanels1" class="TabbedPanels">
<ul class="TabbedPanelsTabGroup">
<li class="TabbedPanelsTab" tabindex="0">Product Information</li>
<li class="TabbedPanelsTab" tabindex="0">Box / Crate Information</li>

</ul>
<div class="TabbedPanelsContentGroup">
<div class="TabbedPanelsContent"><p>Click on Product Name to Edit - <a href="/php/packagingdata/add">or click here to Add New Product</a></p>
<table cellspacing="1" cellpadding="5" class="tableborder">
<tr>
<td>Product Type</td>
<td>Product Item</td>
<td>Weight per Square Cm (linear for headboards)</td>
<td>Harmonised Tariff Code</td>
<td>Depth of Products (cms)</td>
</tr>

<?php foreach ($packagingdata as $row): ?>
<tr>
<td><?= $row['component'] ?></td>
<td><a href="/php/editcompdata?lid=<?= $row['COMPONENTDATA_ID'] ?>"><?= $row['COMPONENTNAME'] ?></a></td>
<td><?= $row['WEIGHT'] ?></td>
<td><?= $row['TARIFFCODE'] ?></td>
<td><?= $row['DEPTH'] ?></td>
</tr>
<?php endforeach; ?>
</table>


<p><a href="add-component-data.asp">Add new product</a></p></div>
<form name="form1" method="post" action="packagingdata/edit">
<div class="TabbedPanelsContent">

<table border="0"  cellpadding="2px" cellspacing="2px">
<tr>
<td width="111">Shipping Boxes</td>
<td width="75">&nbsp;</td>
<td width="9">&nbsp;</td>
<td width="58">&nbsp;</td>
<td width="6">&nbsp;</td>
<td width="62">&nbsp;</td>
<td width="53">&nbsp;</td>
<td width="58">&nbsp;</td>
<td colspan="2">Packaging Allowance cm</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>Width cm</td>
<td>&nbsp;</td>
<td>Length cm</td>
<td>&nbsp;</td>
<td>Weight (kg)</td>
<td>Depth cm</td>
<td>&nbsp;</td>
<td width="61">Width cm</td>
<td width="125">Length cm</td>
</tr>
<tr><input name="shippingBoxID" type="hidden" value="<?php echo $smallbox['ShippingBoxID']; ?>">
<td align="right">Small</td>
<td>
<label for="widthS"></label>
<input name="widthS" type="text" id="widthS" size="5" value="<?= $smallbox['Width'] ?>">
</td>
<td>x</td>
<td><input name="lengthS" type="text" id="lengthS" value="<?= $smallbox['Length'] ?>" size="5"></td>
<td>&nbsp;</td>
<td><input name="weightS" type="text" id="weightS" value="<?= $smallbox['Weight'] ?>" size="5"></td>
<td><input name="depthS" type="text" id="depthS" value="<?= $smallbox['Depth'] ?>" size="5"></td>
<td>&nbsp;</td>
<td><input name="packwidthS" type="text" id="weightS" value="<?= $smallbox['PackAllowanceWidth'] ?>" size="5"></td>
<td><input name="packlengthS" type="text" id="packlengthS" value="<?= $smallbox['PackAllowanceLength'] ?>" size="5"></td>
</tr>

<tr>
<input name="mediumshippingBoxID" type="hidden" value="<?php echo $mediumbox['ShippingBoxID']; ?>">
<td align="right">Medium</td>
<td>
<label for="widthM"></label>
<input name="widthM" type="text" id="widthM" size="5" value="<?= $mediumbox['Width'] ?>">
</td>
<td>x</td>
<td><input name="lengthM" type="text" id="lengthM" value="<?= $mediumbox['Length'] ?>" size="5"></td>
<td>&nbsp;</td>
<td><input name="weightM" type="text" id="weightM" value="<?= $mediumbox['Weight'] ?>" size="5"></td>
<td><input name="depthM" type="text" id="depthM" value="<?= $mediumbox['Depth'] ?>" size="5"></td>
<td>&nbsp;</td>
<td><input name="packwidthM" type="text" id="weightM" value="<?= $mediumbox['PackAllowanceWidth'] ?>" size="5"></td>
<td><input name="packlengthM" type="text" id="packlengthM" value="<?= $mediumbox['PackAllowanceLength'] ?>" size="5"></td>
</tr>

<tr>
<input name="largeshippingBoxID" type="hidden" value="<?php echo $largebox['ShippingBoxID']; ?>">
<td align="right">Medium</td>
<td>
<label for="widthL"></label>
<input name="widthL" type="text" id="widthL" size="5" value="<?= $largebox['Width'] ?>">
</td>
<td>x</td>
<td><input name="lengthL" type="text" id="lengthL" value="<?= $largebox['Length'] ?>" size="5"></td>
<td>&nbsp;</td>
<td><input name="weightL" type="text" id="weightL" value="<?= $largebox['Weight'] ?>" size="5"></td>
<td><input name="depthL" type="text" id="depthL" value="<?= $largebox['Depth'] ?>" size="5"></td>
<td>&nbsp;</td>
<td><input name="packwidthL" type="text" id="weightL" value="<?= $largebox['PackAllowanceWidth'] ?>" size="5"></td>
<td><input name="packlengthL" type="text" id="packlengthL" value="<?= $largebox['PackAllowanceLength'] ?>" size="5"></td>
</tr>

<tr>
<td align="right">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td align="right">&nbsp;</td>
<td>Height cm</td>
<td>&nbsp;</td>
<td>Width cm</td>
<td>&nbsp;</td>
<td>Depth cm</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

<tr>
<input name="legshippingBoxID" type="hidden" value="<?php echo $legbox['ShippingBoxID']; ?>">
<td align="right">Leg Box</td>
<td><input name="heightLB" type="text" id="heightLB" size="5" value="<?= $legbox['Height'] ?>"></td>
<td>x</td>
<td><input name="widthLB" type="text" id="widthLB" size="5" value="<?= $legbox['Width'] ?>"></td>
<td>x</td>
<td><input name="depthLB" type="text" id="depthLB" size="5" value="<?= $legbox['Depth'] ?>"></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td align="right">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

<tr>
<td colspan="2" align="right">&nbsp;</td>
<td colspan="5">Weight per sq. mtr. (kg)</td>

<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

<tr>
<input name="woodcrateshippingBoxID" type="hidden" value="<?php echo $woodcrate['ShippingBoxID']; ?>">
<td colspan="4" align="right">Wooden Crates</td>
<td colspan="2"><input name="woodencrates" type="text" id="woodencrates" value="<?= $woodcrate['Weight'] ?>" size="5"></td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

<tr>
<input name="internalcrateshippingBoxID" type="hidden" value="<?php echo $internalcrate['ShippingBoxID']; ?>">
<td colspan="4" align="right">Internal Crate / Product Allowance</td>
<td  colspan="2" align="left"><input name="internalcrate" type="text" id="internalcrate" value="<?= $internalcrate['Allowance'] ?>" size="5">
cm</td>
<td align="right">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr> 

<tr>
<input name="additionalcrateshippingBoxID" type="hidden" value="<?php echo $additionalcrate['ShippingBoxID']; ?>">
<td colspan="4" align="right">Additional Crate Packaging Allowance</td>
<td  colspan="2" align="left"><input name="additionalcrate" type="text" id="additionalcrate" value="<?= $additionalcrate['Allowance'] ?>" size="5">
cm</td>
<td align="right">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr> 

<tr>
<input name="roundcrateshippingBoxID" type="hidden" value="<?php echo $roundtonearest['ShippingBoxID']; ?>">
<td colspan="4" align="right">Round Crate to nearest</td>
<td  colspan="2" align="left"><input name="roundtonearest" type="text" id="roundtonearest" value="<?= $roundtonearest['RoundToNearest'] ?>" size="5">
cm</td>
<td align="right">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr> 
<tr>
<td colspan="3" align="right">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

<tr>
<td colspan="3" align="left">Folded Topper Allowance cm</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<input name="hcashippingBoxID" type="hidden" value="<?php echo $hcatopper['ShippingBoxID']; ?>">
<td align="right">HCa Topper</td>
<td align="left"><input name="hca" type="text" id="hca" value="<?= $hcatopper['Allowance'] ?>" size="5"></td>
<td align="left">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

<tr>
<input name="statehcashippingBoxID" type="hidden" value="<?php echo $statehcatopper['ShippingBoxID']; ?>">
<td align="right">State HCa Topper</td>
<td align="left"><input name="statehca" type="text" id="statehca" value="<?= $statehcatopper['Allowance'] ?>" size="5"></td>
<td align="left">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

<tr>
<input name="hwshippingBoxID" type="hidden" value="<?php echo $hwtopper['ShippingBoxID']; ?>">
<td align="right">HW Topper</td>
<td align="left"><input name="hw" type="text" id="hw" value="<?= $hwtopper['Allowance'] ?>" size="5"></td>
<td align="left">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

<tr>
<input name="cwshippingBoxID" type="hidden" value="<?php echo $cwtopper['ShippingBoxID']; ?>">
<td align="right">CW Topper</td>
<td align="left"><input name="cw" type="text" id="cw" value="<?= $cwtopper['Allowance'] ?>" size="5"></td>
<td align="left">&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

</table>
<hr />


<table width="100%" border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td>Savoir Stock Ref.</td>
    <td>Crate Name</td>
    <td>Internal Length</td>
    <td>Internal Width</td>
    <td>Internal Height</td>
    <td>External Length</td>
    <td>External Width</td>
    <td>External Height</td>
    <td>Crate Weight</td>
  </tr>

<tr><input name="expakmbshippingBoxID" type="hidden" value="<?php echo $expakmb['ShippingBoxID']; ?>">
    <td><?= $expakmb['SavoirStockRef'] ?></td>
    <td><?= $expakmb['sName'] ?></td>
    <td><input name="internalLengthExpakMB" type="text" id="internalLengthExpakMB" size="5" value="<?= $expakmb['InternalLength'] ?>"></td>
    <td><input name="internalWidthExpakMB" type="text" id="internalHeightExpakMB" size="5" value="<?= $expakmb['InternalWidth'] ?>"></td>
    <td><input name="internalHeightExpakMB" type="text" id="internalHeightExpakMB" size="5" value="<?= $expakmb['InternalHeight'] ?>"></td>
    <td><input name="lengthExpakMB" type="text" id="lengthExpakMB" size="5" value="<?= $expakmb['Length'] ?>"></td>
    <td><input name="widthExpakMB" type="text" id="widthExpakMB" size="5" value="<?= $expakmb['Width'] ?>"></td>
    <td><input name="heightExpakMB" type="text" id="heightExpakMB" size="5" value="<?= $expakmb['Height'] ?>"></td>
    <td><input name="weightExpakMB" type="text" id="weightExpakMB" size="5" value="<?= $expakmb['Weight'] ?>"></td>
  </tr>
  
<tr><input name="expaktshippingBoxID" type="hidden" value="<?php echo $expakt['ShippingBoxID']; ?>">
    <td><?= $expakt['SavoirStockRef'] ?></td>
    <td><?= $expakt['sName'] ?></td>
    <td><input name="internalLengthExpakT" type="text" id="internalLengthExpakT" size="5" value="<?= $expakt['InternalLength'] ?>"></td>
    <td><input name="internalWidthExpakT" type="text" id="internalHeightExpakT" size="5" value="<?= $expakt['InternalWidth'] ?>"></td>
    <td><input name="internalHeightExpakT" type="text" id="internalHeightExpakT" size="5" value="<?= $expakt['InternalHeight'] ?>"></td>
    <td><input name="lengthExpakT" type="text" id="lengthExpakT" size="5" value="<?= $expakt['Length'] ?>"></td>
    <td><input name="widthExpakT" type="text" id="widthExpakT" size="5" value="<?= $expakt['Width'] ?>"></td>
    <td><input name="heightExpakT" type="text" id="heightExpakT" size="5" value="<?= $expakt['Height'] ?>"></td>
    <td><input name="weightExpakT" type="text" id="weightExpakT" size="5" value="<?= $expakt['Weight'] ?>"></td>
  </tr>
  
<tr><input name="expak1mshippingBoxID" type="hidden" value="<?php echo $expak1m['ShippingBoxID']; ?>">
    <td><?= $expak1m['SavoirStockRef'] ?></td>
    <td><?= $expak1m['sName'] ?></td>
    <td><input name="internalLengthExpak1M" type="text" id="internalLengthExpak1M" size="5" value="<?= $expak1m['InternalLength'] ?>"></td>
    <td><input name="internalWidthExpak1M" type="text" id="internalHeightExpak1M" size="5" value="<?= $expak1m['InternalWidth'] ?>"></td>
    <td><input name="internalHeightExpak1M" type="text" id="internalHeightExpak1M" size="5" value="<?= $expak1m['InternalHeight'] ?>"></td>
    <td><input name="lengthExpak1M" type="text" id="lengthExpak1M" size="5" value="<?= $expak1m['Length'] ?>"></td>
    <td><input name="widthExpak1M" type="text" id="widthExpak1M" size="5" value="<?= $expak1m['Width'] ?>"></td>
    <td><input name="heightExpak1M" type="text" id="heightExpak1M" size="5" value="<?= $expak1m['Height'] ?>"></td>
    <td><input name="weightExpak1M" type="text" id="weightExpak1M" size="5" value="<?= $expak1m['Weight'] ?>"></td>
  </tr>
  
  <tr><input name="expakhshippingBoxID" type="hidden" value="<?php echo $expakh['ShippingBoxID']; ?>">
    <td><?= $expakh['SavoirStockRef'] ?></td>
    <td><?= $expakh['sName'] ?></td>
    <td><input name="internalLengthExpakH" type="text" id="internalLengthExpakH" size="5" value="<?= $expakh['InternalLength'] ?>"></td>
    <td><input name="internalWidthExpakH" type="text" id="internalHeightExpakH" size="5" value="<?= $expakh['InternalWidth'] ?>"></td>
    <td><input name="internalHeightExpakH" type="text" id="internalHeightExpakH" size="5" value="<?= $expakh['InternalHeight'] ?>"></td>
    <td><input name="lengthExpakH" type="text" id="lengthExpakH" size="5" value="<?= $expakh['Length'] ?>"></td>
    <td><input name="widthExpakH" type="text" id="widthExpakH" size="5" value="<?= $expakh['Width'] ?>"></td>
    <td><input name="heightExpakH" type="text" id="heightExpakH" size="5" value="<?= $expakh['Height'] ?>"></td>
    <td><input name="weightExpakH" type="text" id="weightExpakH" size="5" value="<?= $expakh['Weight'] ?>"></td>
  </tr>
    
</table>
<input type="submit" name="Submit" id="Submit" value="Submit">
<br /><br />
</form></div>

</div>
</div>

</div>
</div>

<div>
</div>

<script type="text/javascript">
var TabbedPanels1 = new Spry.Widget.TabbedPanels("TabbedPanels1");
</script>
</body>
</html>
		 
		</div>
        

    
    

</div>