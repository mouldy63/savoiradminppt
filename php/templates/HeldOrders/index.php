<?php use Cake\Routing\Router; ?>
<div id="brochureform" class="brochure" style="background-color:#f3f2f2;">
<p><b>The following orders are on hold.</b></p>
<p><a href="javascript:selectAll()">Select All</a>&nbsp;|
    <a href="javascript:deselectAll()">Deselect All</a></p>
<p>Total: <?php echo count($heldorders); ?></p>
<form action="/php/HeldOrders/submitOrder" method="post" name="form1" id="form1">
<?php foreach ($heldorders as $row): ?>
<p><input type="checkbox" name="XX_<?=$row['PURCHASE_No'] ?>" id="XX_<?=$row['PURCHASE_No'] ?>"> 
<a href='/editcust.asp?val=<?=$row['CONTACT_NO'] ?>'>
<?php if ($row['title'] != '') {
echo $row['title'] ." ";
} ?>
<?php if ($row['first'] != '') {
echo $row['first'] ." ";
} ?>
<?php if ($row['surname'] != '') {
echo $row['surname'] .' ';
} ?>
<?php 
echo ' - Order No: ' .$row['ORDER_NUMBER'] .' ';
?>
<?php 
echo ' - Date: ' .date("d/m/Y h:i:s", strtotime($row['ORDER_DATE']));
?>
<?php if (!$this->Security->userHasRoleInList('NOPRICESUSER')) { 
echo ' - Value: ' .$this->MyForm->formatMoneyWithSymbol($row['total'], $row['ordercurrency']);
} ?>
</a>
</p>
<?php endforeach; ?>
<input type="submit" name="submit1" id="submit1" value="PLACE ORDERS">
</form>     
     

</div>
<script>
<!--

function selectAll() {

	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = true;
	        }
	    }
	}

}

function deselectAll() {

	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = false;
	        }
	    }
	}

}

//-->
</script>