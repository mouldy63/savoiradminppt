<div style="margin-top:30px;"><h1>Projects in <?=$fn?></h1></div>
<?= $this->Form->create(null, ['url' => '/PriceMatrixImport/save', 'onsubmit' => 'return validateForm()']) ?>
<input type="hidden" name="fn" value="<?=$fn?>" />
<table border="1">
<thead>
	<td>
		<strong>Select all or select<br/>individual rows to be imported</strong>&nbsp;<input type="checkbox" id='SELECTALL' name='SELECTALL'/>
	</td>
	<td><strong>Price Type</strong></td>
	<td><strong>Component</strong></td>
	<td><strong>Dimension 1 Name</strong></td>
	<td><strong>Dimension 1 Value</strong></td>
	<td><strong>Dimension 2 Name</strong></td>
	<td><strong>Dimension 2 Value</strong></td>
	<td><strong>Set Component 1</strong></td>
	<td><strong>Set Component 2</strong></td>
	<td><strong>Retail GBP</strong></td>
	<td><strong>Retail USD</strong></td>
	<td><strong>Retail EUR</strong></td>
	<td><strong>Wholesale GBP</strong></td>
	<td><strong>Wholesale USD</strong></td>
	<td><strong>Wholesale EUR</strong></td>
	<td><strong>Ex Works Revenue</strong></td>
	<td><strong>Problems</strong></td>
	<td><strong>Delete from DB</strong></td>
</thead>
<?php foreach ($fileContent as $row): ?>   
<?php
	$rowClass = 'message error';
	if (empty($row['errorMessages'])) {
		$rowClass = $row['isnew'] ? 'new-row' : 'existing-row';
	}
?>
<tr class="<?=$rowClass?>">
	<td>
		<?php if (empty($row['errorMessages'])) { ?>
			<input type="checkbox" name="KEY-<?= str_replace('.', '#', $row['key']) ?>" id="KEY-<?= $row['key'] ?>" class="pmid" <?=$row['isnew'] ? 'checked' : ''?> />
		<?php } else { ?>
			&nbsp;
		<?php } ?>
	</td>
	<td><?=$row['Price Type']?></td>
	<td><?=$row['Component']?></td>
	<td><?=$row['Dimension 1 Name']?></td>
	<td><?=$row['Dimension 1']?></td>
	<td><?=$row['Dimension 2 Name']?></td>
	<td><?=$row['Dimension 2']?></td>
	<td><?=$row['Set Component 1']?></td>
	<td><?=$row['Set Component 2']?></td>
	<td><?=$row['Retail GBP']?></td>
	<td><?=$row['Retail USD']?></td>
	<td><?=$row['Retail EUR']?></td>
	<td><?=$row['Wholesale GBP']?></td>
	<td><?=$row['Wholesale USD']?></td>
	<td><?=$row['Wholesale EUR']?></td>
	<td><?=$row['Ex Works Revenue']?></td>
	<td><?=$row['errorMessages']?></td>
	<td>
	<?php if (empty($row['errorMessages']) && !$row['isnew']) { ?>
		<input type="checkbox" name="DELETE-<?= str_replace('.', '#', $row['key']) ?>" id="DELETE-<?= $row['key'] ?>" class="did" />
	<?php } else { ?>
		&nbsp;
	<?php } ?>
</td>
</tr>
<?php endforeach; ?>
</table>
<div class="col-sm-12">
	<br/><input type="submit" id="pricematrixdisplaybutton" value="Add/Update Selected Projects" />
</div>
</form>
<script>
$("#SELECTALL").change(function() {
	var chkd = this.checked;
    $('.pmid').each(function(){
		this.checked = chkd;
	});
    if (chkd) {
        $('.did').each(function(){
    		this.checked = false;
    	});
    }
});

$(".pmid").change(function() {
	if (this.checked) {
		var delId = this.id.replace("KEY", "DELETE");
		$('#'+delId).prop('checked', false);
	}
});

$(".did").change(function() {
	if (this.checked) {
		var selId = this.id.replace("DELETE", "KEY");
		$('#'+selId).prop('checked', false);
	}
});

function validateForm() {
	var hasRowsToDelete = false;
	<?php foreach ($fileContent as $row) { ?>
	if ($("#DELETE-<?= $row['key'] ?>").is(':checked')) {
		hasRowsToDelete = true;
	}
	<?php } ?>
	if (hasRowsToDelete && !confirm("Confirm deletion of selected rows")) {
		return false;
	}
	return true;
} 
</script>