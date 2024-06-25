<br><br>
<?php
echo $month. "&nbsp;". $year. "&nbsp;". $location;
?>
<p>Monthly Sales Status Report</p>
<table style='border-spacing: 5px; width:100%; border: 1px solid; padding:4px; font-size:12px;'>
<tr><td colspan='8'>Sales-New Orders(ex VAT)</td><td colspan='3'><b>Actual: <?= $currency ?><?= number_format($actualformonthYear,2) ?></b></td></tr>
<tr>
<td></td>
<td></td>
<td align="right">Retail</td>
<td align="right">Trade</td>
<td align="right">Contract</td>
<td align="right">No. Sold</td>
<td align="right">No. Last Year</td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr>
<td>No.1</td>
<td><?= $currency ?></td>
<td align="right"><?= number_format($actualforNo1R,2) ?></td>
<td align="right"><?= number_format($actualforNo1T,2) ?></td>
<td align="right"><?= number_format($actualforNo1C,2) ?></td>
<td align="right"><?= $no1bed ?></td>
<td align="right"><?= $no1bedprevyr ?></td>
<td></td>
<td>Target:</td>
<td align="right"><?= $currency ?><?= number_format($targetDataForMonth,2) ?></td>
<td align="right"><?= round($performanceToTarget) ?>%</td>
</tr>
<tr>
<td>No.2</td>
<td><?= $currency ?></td>
<td align="right"><?= number_format($actualforNo2R,2) ?></td>
<td align="right"><?= number_format($actualforNo2T,2) ?></td>
<td align="right"><?= number_format($actualforNo2C,2) ?></td>
<td align="right"><?= $no2bed ?></td>
<td align="right"><?= $no2bedprevyr ?></td>
<td></td>
<td>Month last Yr:</td>
<td align="right"><?= $currency ?><?= number_format($actualformonthLastYear,2) ?></td>
<td align="right"><?= round($performanceToLastYear) ?>%</td>
</tr>
<tr>
<td>No.3</td>
<td><?= $currency ?></td>
<td align="right"><?= number_format($actualforNo3R,2) ?></td>
<td align="right"><?= number_format($actualforNo3T,2) ?></td>
<td align="right"><?= number_format($actualforNo3C,2) ?></td>
<td align="right"><?= $no3bed ?></td>
<td align="right"><?= $no3bedprevyr ?></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr>
<td>No.4</td>
<td><?= $currency ?></td>
<td align="right"><?= number_format($actualforNo4R,2) ?></td>
<td align="right"><?= number_format($actualforNo4T,2) ?></td>
<td align="right"><?= number_format($actualforNo4C,2) ?></td>
<td align="right"><?= $no4bed ?></td>
<td align="right"><?= $no4bedprevyr ?></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr>
<td>No.5</td>
<td><?= $currency ?></td>
<td align="right"><?= number_format($actualforNo5R,2) ?></td>
<td align="right"><?= number_format($actualforNo5T,2) ?></td>
<td align="right"><?= number_format($actualforNo5C,2) ?></td>
<td align="right"><?= $no5bed ?></td>
<td align="right"><?= $no5bedprevyr ?></td>
<td></td>
<td></td>
<td align="right">Actual</td>
<td></td>
</tr>
<tr>
<td>Other/Pinnacle</td>
<td><?= $currency ?></td>
<td align="right"><?= number_format($actualforNonR,2) ?></td>
<td align="right"><?= number_format($actualforNonT,2) ?></td>
<td align="right"><?= number_format($actualforNonC,2) ?></td>
<td align="right"><?= $nonbed ?></td>
<td align="right"><?= $nonbedprevyr ?></td>
<td></td>
<td>YTD Retail</td>
<td align="right"><?= number_format($YTDactualRetail,2) ?></td>
<td></td>
</tr>

<tr>
<td>Toppers</td>
<td><?= $currency ?></td>
<td align="right"><?= number_format($actualToppersR,2) ?></td>
<td align="right"><?= number_format($actualToppersT,2) ?></td>
<td align="right"><?= number_format($actualToppersC,2) ?></td>
<td align="right"><?= $noToppers ?></td>
<td align="right"><?= $noToppersprevyr ?></td>
<td></td>
<td>YTD Trade</td>
<td align="right"><?= number_format($YTDactualTrade,2) ?></td>
<td></td>
</tr>

<tr>
<td>Extras</td>
<td><?= $currency ?></td>
<td align="right"><?= number_format($actualforExtrasR,2) ?></td>
<td align="right"><?= number_format($actualforExtrasT,2) ?></td>
<td align="right"><?= number_format($actualforExtrasC,2) ?></td>
<td align="right"><?= $noextras ?></td>
<td align="right"><?= $noextrasprevyr ?></td>
<td></td>
<td>YTD Contract</td>
<td align="right"><?= number_format($YTDactualContract,2) ?></td>
<td></td>
</tr>

<tr>
<td>Accessories</td>
<td><?= $currency ?></td>
<td align="right"><?= number_format($actualAccR,2) ?></td>
<td align="right"><?= number_format($actualAccT,2) ?></td>
<td align="right"><?= number_format($actualAccC,2) ?></td>
<td align="right"><?= $noAcc ?></td>
<td align="right"><?= $noAccprevyr ?></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>

<tr>
<td>Delivery</td>
<td><?= $currency ?></td>
<td align="right"><?= number_format($deliveryR,2) ?></td>
<td align="right"><?= number_format($deliveryT,2) ?></td>
<td align="right"><?= number_format($deliveryC,2) ?></td>
<td align="right"><?= $noDelCharges ?></td>
<td align="right"><?= $noDelChargesPrevYr ?></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>

<tr>
<td>Ecom</td>
<td><?= $currency ?></td>
<td align="right"><?= number_format($ecomR,2) ?></td>
<td align="right"><?= number_format($ecomT,2) ?></td>
<td align="right"><?= number_format($ecomC,2) ?></td>
<td align="right"><?= $noEcom ?></td>
<td align="right"><?= $noEcomPrevYr ?></td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr>
<td style='padding-top:15px;'><b>Total</b></td>
<td style='padding-top:15px;'><?= $currency ?></td>
<td style='padding-top:15px;' align="right"><?= number_format($actualforOrderSourceR,2) ?></td>
<td style='padding-top:15px;' align="right"><?= number_format($actualforOrderSourceT,2) ?></td>
<td style='padding-top:15px;' align="right"><?= number_format($actualforOrderSourceC,2) ?></td>
<td style='padding-top:15px;' align="right"><?= $noEcom ?></td>
<td style='padding-top:15px;' align="right"><?= $noEcomPrevYr ?></td>
<td style='padding-top:15px;'></td>
<td style='padding-top:15px;'>YTD Total:</td>
<td style='padding-top:15px;' align="right"><?= number_format($YTDDateActual,2) ?></td>
<td style='padding-top:15px;'></td>
</tr>
<tr>
<td colspan='8'></td>
<td>YTD Target:</td>
<td align="right"><?= number_format($YTDTargetForYear,2) ?></td>
<td align="right"><?= round($YTDperformanceToTarget) ?>%</td>
</tr>
<tr>
<td colspan='8'></td>
<td>YTD Pr Yr:</td>
<td align="right"><?= number_format($YTDActualForPrevYear,2) ?></td>
<td align="right"><?= round($YTDperformanceToLastYear) ?>%</td>
</tr>

</table>

<?php echo $clientorders ?>
<?php 
$totallines=0;
if (($clientorders_rowcount) > 40) {
	echo "<h5>&nbsp;</h5>";
	$totallines=0;
}
if ($tradeorders_rowcount <> 0) { 
	$totallines=$clientorders_rowcount+$tradeorders_rowcount; 
	if ($totallines > 38) {
		echo "<h5>&nbsp;</h5>";
		$totallines=0;
	}
}
?>
<?php echo $tradeorders ?>
<?php 
if ($contractorders_rowcount <> 0) {
	$totallines=$totallines+$contractorders_rowcount+6;
	if ($totallines > 38) {
		echo "<h5>&nbsp;</h5><p>&nbsp;</p>";
		$totallines=0;
	}
}
?>
<?php echo $contractorders ?>
<?php 
$totallines=$totallines+$stockorders_rowcount+6; 

if ($totallines > 28) {
	echo "<h5>&nbsp;</h5>";
	$totallines=0;
}
?>
<?php echo $stockorders ?>
<?php 
if ($floorstockorders_rowcount <> 0) { 
	$totallines=$totallines+$floorstockorders_rowcount+6; 
	if ($totallines > 28) {
		echo "<h5>&nbsp;</h5>";
		$totallines=0;
	}
}

?>
<?php echo $floorstockorders ?>
<?php 
if ($marketingorders_rowcount <> 0) { 
	$totallines=$totallines+$marketingorders_rowcount+6; 
	if ($totallines > 28) {
		echo "<h5>&nbsp;</h5>";
		$totallines=0;
	}
}
?>
<?php echo $marketingorders ?>
<?php 
if ($ecomorders_rowcount <> 0) { 
	$totallines=$totallines+$ecomorders_rowcount+6; 
	if ($totallines > 28) {
		echo "<h5>&nbsp;</h5><p>&nbsp;</p>";
		$totallines=0;
	}
}

?>
<?php echo $ecomorders ?>
<?php 
if ($testorders_rowcount <> 0) {
	$totallines=$totallines+$testorders_rowcount+6; 
	if ($totallines > 28) {
		echo "<h5>&nbsp;</h5>";
		$totallines=0;
	}
}
?>
<?php echo $testorders ?>
