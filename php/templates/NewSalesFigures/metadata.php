<?php
$now = date('d-m-Y');
$currentyear = date("Y",strtotime($now));
?>
<div>Year&nbsp;
	<select name='year' id='year' onchange="selectYear();">
		<?php for ($i = $currentyear+1; $i > $currentyear-4; $i--) { ?>
		<option value='<?=$i?>' <?php if ($year == $i) echo 'selected';?> ><?=$i?></option>
		<?php } ?>
	</select>
</div>
<form name="form1" method="post" action="savemetadata">
<input name="year" type="hidden" value="<?=$year?>" />
<table>
	<tr>
		<td>&nbsp;</td>
		<td>January</td>
		<td>February</td>
		<td>March</td>
		<td>April</td>
		<td>May</td>
		<td>June</td>
		<td>July</td>
		<td>August</td>
		<td>September</td>
		<td>October</td>
		<td>November</td>
		<td>December</td>
	</tr>
	<tr>
		<td>USD Exchange Rate</td>
		<?php for ($i = 1; $i < 13; $i++) {
			$val = 1.00;
			if (array_key_exists($i, $usdRates)) {
			    $val = $usdRates[$i];
			}
			?>
			<td><input name="usdRate<?=$i?>" type="text" value="<?=number_format((float)$val, 2, '.', '')?>" /></td>
		<?php } ?>
	</tr>
	<tr>
		<td>EUR Exchange Rate</td>
		<?php for ($i = 1; $i < 13; $i++) {
			$val = 1.00;
			if (array_key_exists($i, $eurRates)) {
			    $val = $eurRates[$i];
			}
			?>
			<td><input name="eurRate<?=$i?>" type="text" value="<?=number_format((float)$val, 2, '.', '')?>" /></td>
		<?php } ?>
	</tr>
	<?php foreach ($showroomTargets as $idlocation => $data) {?>
		<tr>
			<td><?=$data['name']?></td>
			<?php
			for ($i = 1; $i < 13; $i++) {
			    $val = 0.00;
			    if (array_key_exists($i, $data['targets'])) {
			        $val = $data['targets'][$i]['target_amount'];
			    }
			?>
			<td><input name="target-<?=$data['idlocation']?>-<?=$i?>" type="text" value="<?=number_format((float)$val, 2, '.', '')?>" /></td>
			<?php } ?>
		</tr>
	<?php } ?>
</table>
<input type="submit" name="submit" value="Submit">
</form>
<script>
	function selectYear() {
		var year = $('#year').find(":selected").text();
		window.location = '/php/NewSalesFigures/metadata?year=' + year;;
	}
</script>