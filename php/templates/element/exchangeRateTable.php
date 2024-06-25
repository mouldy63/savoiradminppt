$exchangeRate = $data['exchange_rate_array'];
$currency_code_array = $data['currency_code_array'];
$currentYear = (int)$data['requestyear'];
$thisYear = (int)$data['thisyear'];

<?php foreach($exchangeRate[$currentYear] as $monthKey=>$tempMonthRate):?>
	<tr>
		<td class = "tablecell bordercell"><?php echo getMonth($monthKey);?></td>
		<?php foreach($currency_code_array as $cCode):?>
		<td class = "tablecell bordercell">
		<input class="set_target disablebg" onchange="allTargetsData.changeTarget(
			<?php echo $currentYear;?>,<?php echo $monthKey;?>,this);return false;" type="text" value="<?php echo $tempMonthRate[$cCode['a']["currency_code"]]['amount']; ?>" disabled/></td>
		<?php endforeach;?>
	</tr>
<?php endforeach;?>