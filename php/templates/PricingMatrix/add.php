<?php use Cake\Routing\Router; ?>

<div class="brochure" style="background-color:#fff;">
<h1>Pricing Matrix</h1>
<p><a href="/php/PricingMatrix" style="color:red;">Return to Price Matrix</a></p>
<form action="/php/PricingMatrix/add" method="post" name="form1" id="form1">
<table id="myTable" class="display compact">
<thead>
<tr style='background-color:white;'>
<th>Component Name</th>
<th>Component Type</th>
<th>Dim 1 name</th>
<th>Dimension 1</th>
<th>Dim 2 name</th>
<th>Dimension 2</th>
<th>Set Component 1</th>
<th>Set Component 2</th>
<th>R GBP</th>
<th>R USD</th>
<th>R EUR</th>
<th>W GBP</th>
<th>W USD</th>
<th>W EUR</th>
<th>Ex Revenue 2014</th>

</tr>
</thead>


<tbody>

<tr>
<td><select name="pricetype" id="pricetype" onchange="enterDims();">
<option value="n">Choose Comp Name</option>
	<?php 
	foreach ($pmatrixType as $row): 
	?>
	<option value="<?= $row['PRICE_TYPE_ID'] ?>"><?= $row['NAME'] ?></option>
	<?php endforeach; ?>
							</select></td>
<td>
<select name="comp" id="comp">
<option value="n">Choose component</option>
<?php 
	foreach ($component as $row): 
	if ($row['displayName'] != "Whole Order") {
	?>
	<option value="<?= $row['id'] ?>"><?= $row['displayName'] ?></option>
	<?php }
	endforeach; ?>
	</select></td>
<td><div id='dim1'></div></td>
<td align="left"><input name="dim1" type="text" id="dim1" size="10" value='' /></td>
<td><div id='dim2'></div></td>
<td align="left"><input name="dim2" type="text" id="dim2" size="10" value='' /></td>
<td><select name="setcomp1" id="setcomp1">
<option value="n">Choose Comp 1</option>
<?php 
	foreach ($component as $row): 
	if ($row['displayName'] != "Whole Order") {
	?>
	<option value="<?= $row['id'] ?>"><?= $row['displayName'] ?></option>
	<?php }
	endforeach; ?>
	</select></td>
<td>
<select name="setcomp2" id="setcomp2">
<option value="n">Choose Comp 2</option>
<?php 
	foreach ($component as $row): 
	if ($row['displayName'] != "Whole Order") {
	?>
	<option value="<?= $row['id'] ?>"><?= $row['displayName'] ?></option>
	<?php }
	endforeach; ?>
	</select></td>
<td><input name="RGBP" type="text" id="RGBP" size="8" value='' />&nbsp;</td>
<td><input name="RUSD" type="text" id="RUSD" size="8" value='' />&nbsp;</td>
<td><input name="REUR" type="text" id="REUR" size="8" value='' />&nbsp;</td>
<td><input name="WGBP" type="text" id="WGBP" size="8" value='' />&nbsp;</td>
<td><input name="WUSD" type="text" id="WUSD" size="8" value='' />&nbsp;</td>
<td><input name="WEUR" type="text" id="WEUR" size="8" value='' />&nbsp;</td>
<td><input name="EXWR" type="text" id="EXWR" size="8" value='' />&nbsp;</td>

</tr>

</tbody>
</table>
<br><br>
<input type="submit" name="save" value="Add Price Matrix item" />
</form>
</div>

<script>

 
/* Initialise the table with the required column ordering data types */
$(document).ready(function () {
    $('#myTable').DataTable({
    	"paging": false,
    	"ordering": false,
    	"searching": false,
    	"info":     false
    });
});

$(document).ready(init());
function init()
{

    enterDims();
    document.getElementById('dim1').innerHTML='';
    document.getElementById('dim2').innerHTML='';
}
function enterDims() {

	var combo = document.getElementById('pricetype');
    var index = pricetype.options[pricetype.selectedIndex].value;
    if ((index > "0" && index < 8) || index == "88" || index=="86" || index=="87" || index=="127" || index=="128" || index=="35"){
        document.getElementById('dim1').innerHTML='Width';
        document.getElementById('dim2').innerHTML='Length';
    } else if (index == "28" || index == "89" || index=="90") {
    	document.getElementById('dim1').innerHTML='Leg Finish';
        document.getElementById('dim2').innerHTML='';
    
    } else if (index == "36") {
    	document.getElementById('dim1').innerHTML='Headboard Style';
        document.getElementById('dim2').innerHTML='';
    
    } else if (index == "56") {
    	document.getElementById('dim1').innerHTML='Drawer Config';
        document.getElementById('dim2').innerHTML='';
    
    } else if (index == "55") {
    	document.getElementById('dim1').innerHTML='Base Trim Option';
        document.getElementById('dim2').innerHTML='';
    
    } else {
        document.getElementById('dim1').innerHTML='';
        document.getElementById('dim2').innerHTML='';
    }		
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