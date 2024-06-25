<?php
/**
 * @var \App\View\AppView $this
 * @var \App\Model\Entity\Purchase[]|\Cake\Collection\CollectionInterface $purchases
 */
?>
<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->css('jquery.multiselect.css',array('inline' => false));?>

<script>
$(function() {
var year = new Date().getFullYear();
$( "#monthfrom" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#monthfrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#monthto" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#monthto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});


</script>
<?php 
	$monthNum=date("m");
?>

<div class="containerfull brochure">
<h1>Showroom Orders Report</h1>


<form action="/php/ShowroomOrdersReport" method="post" name="form1" id="form1" onSubmit="return resetMonthYear();">
<table border="0" align="center" cellpadding="5" cellspacing="2"><tr><td valign="top">Date of order start:<br>
<input name="monthfrom" type="text" id="monthfrom" size="10"  value="<?php echo $this->MyForm->fmtDateForDatePicker($monthfrom) ?>"></td>
<td valign="top">Date of order end:<br>
<input name="monthto" type="text" id="monthto" size="10"  value="<?php echo $this->MyForm->fmtDateForDatePicker($monthto) ?>"></td>
<td valign="top"><br><select name="showroom[]" multiple="multiple" class="showroom active"  id="showroom">
<option value="n">Current Showrooms:  </option>
<?php foreach ($activeshowrooms as $row): ?> 
<?php $slct = ($row['idlocation'] == $showroom) ? "selected" : "";   ?>              
<option <?= $slct ?> value="<?= $row['idlocation'] ?>"><?= $row['adminheading'] ?></option>
<?php endforeach; ?>
</select></td>
<td valign="top"><br><select name="ordersource[]" multiple="multiple" class="ordersource active"  id="ordersource">
<option value="n">Order Source:  </option>
<option value="n">All</option>
<?php foreach ($ordersources as $row): ?> 
<?php $slct = ($row['orderSource'] == $ordersource) ? "selected" : "";   ?>   
           
<option <?= $slct ?> value="<?= $row['orderSource'] ?>"><?= $row['orderSource'] ?></option>
<?php endforeach; ?>
</select></td>


</tr>
<tr><td colspan="4">
	<input type="submit" onclick="changeFormAction('form1', '/php/ShowroomOrdersReport');" name="search" value="Search" id="search" class="button" />
	<input name="excellist" onclick="changeFormAction('form1', '/php/ShowroomOrdersReport/export');" type="submit" class="button" id="excellist" value="Produce CSV file" />
	<input name="Reset" onclick="window.location='/php/ShowroomOrdersReport'; return false;" type="submit" class="button" id="button" value="Reset Form" /> 
</td></tr>
</table>

</form>

<?php if (isset($data['showroom_list'])) { ?>

	<table cellspacing="5" cellpadding="1" border="0" align="center">
	<tr>
	<td>&nbsp;</td>
	<?php foreach ($data['showroom_list'] as $showroom): ?> 
		<td bgcolor="#FFFFFF"><b><?= $showroom['adminheading'] ?></b></td>
	<?php endforeach; ?>
	<td bgcolor="#FFFFFF">TOTAL</td>
	</tr>

	<?php
	$salesData = $data['salesdata'];
	foreach ($salesData as $section): ?>
		<?php $sectiondata = $section['data'];
		if (sizeof($sectiondata) > 1) {
			?>
			<tr><td><strong><?= $section['title']; ?></strong></td></tr>
			<?php foreach ($sectiondata as $item): ?>
				<tr class="tablebd">
					<td><?= $item['title']; ?></td>
					<?php foreach ($data['showroom_list'] as $showroom): ?> 
						<?php if (isset($item['data'][$showroom['idlocation']])) { ?>
							<?php $link = "ShowroomOrdersReport/orderReport?idlocation=".$showroom['idlocation']."&key=".$item['key']."&monthfrom=".urlencode($monthfrom)."&monthto=".urlencode($monthto); ?>
							<td bgcolor="#FFFFFF"><a href="<?=$link?>" target="_blank"><?= $item['data'][$showroom['idlocation']] ?></a></td>
						<?php } else { ?>
							<td bgcolor="#FFFFFF">0</td>
						<?php } ?>
					<?php endforeach; ?>
					<?php if ($item['data'][0] > 0) { ?>
						<?php $link = "ShowroomOrdersReport/orderReport?idlocation=0&key=".$item['key']."&monthfrom=".urlencode($monthfrom)."&monthto=".urlencode($monthto); ?>
						<td bgcolor="#FFFFFF"><a href="<?=$link?>" target="_blank"><?= $item['data'][0] ?></a></td>
					<?php } else { ?>
						<td bgcolor="#FFFFFF">0</td>
					<?php } ?>
				</tr>
			<?php endforeach; ?>
			
			<?php
		} else {
			foreach ($sectiondata as $item): ?>
			<tr><td>&nbsp;</td></tr>
				<tr>
					<td><strong><?= $section['title']; ?></strong></td>
					<?php foreach ($data['showroom_list'] as $showroom): ?> 
						<?php if (isset($item['data'][$showroom['idlocation']])) { ?>
							<?php $link = "ShowroomOrdersReport/orderReport?idlocation=".$showroom['idlocation']."&key=".$item['key']."&monthfrom=".urlencode($monthfrom)."&monthto=".urlencode($monthto); ?>
							<td bgcolor="#FFFFFF"><a href="<?=$link?>" target="_blank"><?= $item['data'][$showroom['idlocation']] ?></a></td>
						<?php } else { ?>
							<td bgcolor="#FFFFFF">0</td>
						<?php } ?>
					<?php endforeach; ?>
					<?php if ($item['data'][0] > 0) { ?>
						<?php $link = "ShowroomOrdersReport/orderReport?idlocation=0&key=".$item['key']."&monthfrom=".urlencode($monthfrom)."&monthto=".urlencode($monthto); ?>
						<td bgcolor="#FFFFFF"><a href="<?=$link?>" target="_blank"><?= $item['data'][0] ?></a></td>
					<?php } else { ?>
						<td bgcolor="#FFFFFF">0</td>
					<?php } ?>
				</tr>
			<?php endforeach;
		}
	endforeach; ?>
	
	</table>
	</div>

<?php } ?>
<?php echo $this->Html->script('jquery.multiselect.js', array('inline' => false)); ?>
<script>
 $(function () {
        $('select[multiple].active.showroom').multiselect({
            columns: 1,
            placeholder: 'Showroom',
            search: false,
            minWidth           : "300px",
            selectAll: true
        });
        $('select[multiple].active.ordersource').multiselect({
            columns: 1,
            placeholder: 'Order Source',
            search: false,
            minWidth           : "300px",
            selectAll: true
        });
    });

	function changeFormAction(formId, newAction) {
		//console.log("New action = " + newAction);
		$('#' + formId).attr('action', newAction);
	}
	
	function sortby(sortVal) {
		//console.log("sortVal = " + sortVal);
		$("#sortorder").val(sortVal);
		$("#form1").submit();
	}  
</script>
<script>

function changeFormAction(formId, newAction) {
	//console.log("New action = " + newAction);
	$('#' + formId).attr('action', newAction);
}
	
function sortby(sortVal) {
	$("#sortorder").val(sortVal);
	$("#form1").submit();
}

function resetMonthYear() {
	if ($('#monthfrom').val() != '' && $('#monthto').val() != '') {
		$('#month').val('n');
		$('#year').val('n');
	}
	return true;
}
</script>
