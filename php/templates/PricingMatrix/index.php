<?php use Cake\Routing\Router; ?>

<div class="brochure" style="background-color:#fff;">
<h1>Pricing Matrix</h1>
<form action="/php/PricingMatrix/edit" method="post" name="form1" id="form1" onsubmit="return validateForm()" >
<p>Retail to wholesale adjustment: <input name="adjustment" type="text" id="adjustment" size="10" value='2.5' /><input type="submit" style="margin-left:10px;" name="wtoretail" value="Update wholesale from retail prices" onclick="changeFormAction('form1', '/php/PricingMatrix/copy');" /><input type="submit" style="margin-left:10px;" name="wtoretail" value="Copy data from wholesale to ex works" onclick="changeFormAction('form1', '/php/PricingMatrix/copyex');" />&nbsp;&nbsp;&nbsp;
<a href="/php/PriceMatrixExport/export/">Download csv <i class="fa-solid fa-file-csv fa-3x"></i></a>&nbsp;&nbsp;&nbsp;
<a href="/php/PriceMatrixImport/">Upload csv <i class="fa-solid fa-file-csv fa-3x"></i></a></p>

<p style="font-size:13px;"><strong><a href="/php/PricingMatrix">All</a> | <a href="/php/PricingMatrix?comp=1">Mattress</a> | <a href="/php/PricingMatrix?comp=3">Base</a> | <a href="/php/PricingMatrix?comp=5">Topper</a> | <a href="/php/PricingMatrix?comp=7">Legs</a> | <a href="/php/PricingMatrix?comp=8">Headboard</a> |  <a href="PricingMatrix?comp=10">Headboard Trim</a> |  <a href="/php/PricingMatrix?comp=11">Base Trim</a> |  <a href="/php/PricingMatrix?comp=12">Base Upholstery</a> | <a href="/php/PricingMatrix?comp=13">Base Drawers</a> |  <a href="/php/PricingMatrix?comp=16">Support Legs</a></strong> </p>
<p><a href="/php/PricingMatrix/add" style="color:red;">Add Product/Price Combo</a></p>


<table id="pricematrix" class="display">
<thead>
<tr style='background-color:white;'>
<th>Row</th>
<th>Price Type</th>
<th>Component</th>
<th>Dimension&nbsp;1</th>
<th>Dimension&nbsp;2</th>
<th>Set Component 1</th>
<th>Set Component 2</th>
<th>Retail GBP</th>
<th>Retail USD</th>
<th>Retail</th>
<th>Wholesale GBP</th>
<th>Wholesale USD</th>
<th>Wholesale EUR</th>
<th>Ex Revenue 2014</th>
<th>Delete checkbox</th>
</tr>
</thead>


<tbody>
<?php 
$rowcounter=0;
foreach ($pmatrix as $row): 
$rowcounter = $rowcounter+1;
?>
<tr>
<td><?= $rowcounter ?></td>
<td style="font-size:13px;"><?= $row['PriceType'] ?></td> 
<td style="font-size:13px;"><?= $row['Component'] ?>&nbsp;</td>
<td align="left" style="font-size:13px;"><?= $row['Dimension1Name'] ?> <?= $row['Dimension1'] ?></td>
<td align="left" style="font-size:13px;"><?= $row['Dimension2Name'] ?> <?= $row['Dimension2'] ?></td>
<td style="font-size:13px;"><?php 
if (isset($row['SetComponent1'])) {
$compname=getCompname($this->AuxiliaryData,$row['SetComponent1']);
echo $compname;
}
?></td>
<td style="font-size:13px;">
<?php 
if (isset($row['SetComponent2'])) {
$compname=getCompname($this->AuxiliaryData,$row['SetComponent2']);
echo $compname;
}
?></td>
<td><input name="RGBP<?= $row['PRICE_MATRIX_ID'] ?>" type="text" id="RGBP<?= $row['PRICE_MATRIX_ID'] ?>" size="10" value='<?= $row['RetailGBP'] ?>' /></td>
<td><input name="RUSD<?= $row['PRICE_MATRIX_ID'] ?>" type="text" id="RUSD<?= $row['PRICE_MATRIX_ID'] ?>" size="10" value='<?= $row['RetailUSD'] ?>' /></td>
<td><input name="REUR<?= $row['PRICE_MATRIX_ID'] ?>" type="text" id="REUR<?= $row['PRICE_MATRIX_ID'] ?>" size="10" value='<?= $row['RetailEUR'] ?>' /></td>
<td><input name="WGBP<?= $row['PRICE_MATRIX_ID'] ?>" type="text" id="WGBP<?= $row['PRICE_MATRIX_ID'] ?>" size="10" value='<?= $row['WholesaleGDP'] ?>' /></td>
<td><input name="WUSD<?= $row['PRICE_MATRIX_ID'] ?>" type="text" id="WUSD<?= $row['PRICE_MATRIX_ID'] ?>" size="10" value='<?= $row['WholesaleUSD'] ?>' /></td>
<td><input name="WEUR<?= $row['PRICE_MATRIX_ID'] ?>" type="text" id="WEUR<?= $row['PRICE_MATRIX_ID'] ?>" size="10" value='<?= $row['WholesaleEUR'] ?>' /></td>
<td><input name="EXWR<?= $row['PRICE_MATRIX_ID'] ?>" type="text" id="EXWR<?= $row['PRICE_MATRIX_ID'] ?>" size="10" value='<?= $row['ExWorksRevenue'] ?>' /></td>
<td><input type="checkbox" id="DELE<?= $row['PRICE_MATRIX_ID'] ?>" name="DELE<?= $row['PRICE_MATRIX_ID'] ?>" /></td>
</tr>
<?php endforeach; ?>
</tbody>
</table>
<input type="hidden" name="comp" value="<?= $comp ?>" />
<input type="submit" id="pricematrixbutton" name="botright" value="Save" style="padding-top:30px; padding-bottom:30px;" onclick="changeFormAction('form1', '/php/PricingMatrix/edit');"/>
</form>
</div>


<script>

function changeFormAction(formId, newAction) {
	$('#' + formId).attr('action', newAction);
}
 
/* Initialise the table with the required column ordering data types */
$(document).ready(function () {
    $('#pricematrix').DataTable({
    	"paging": false,
        "order": [[ 0, "asc" ]],
        "fixedHeader": true
    });
});

function validateForm() {
	var action = $('#form1').attr('action');
	if (action == '/php/PricingMatrix/copy' && !confirm("Update wholesale from retail prices?")) {
		return false;
	}
	if (action == '/php/PricingMatrix/copyex' && !confirm("Copy data from wholesale to ex works?")) {
		return false;
	}

	var hasRowsToDelete = false;
	<?php foreach ($pmatrix as $row) { ?>
	if ($("#DELE<?= $row['PRICE_MATRIX_ID'] ?>").is(':checked')) {
		hasRowsToDelete = true;
	}
	<?php } ?>
	if (hasRowsToDelete && !confirm("Confirm deletion of selected rows")) {
		return false;
	}
	return true;
} 

</script>

<?php
function getCompname($auxhelper,$compid) {

    $sql = "Select Component from component where ComponentID=". $compid ."";
    $compname='';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				$compname=$rows['Component'];
	    	 endforeach;
    return $compname;
} 
?>