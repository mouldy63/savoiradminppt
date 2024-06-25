<br><br>

<p style="font-size:15px;"><b>Monthly Coupons Report for 
<?php
echo $month. "&nbsp;". $year;
?></b></p>
<table style='border-spacing: 5px; width:100%; border: 1px solid; padding:4px; font-size:12px; border-collapse: collapse; '>
<tr style='border-collapse: collapse; border:1px solid black; padding:6px;'>
<td style=" border: 1px solid #333; padding:6px;"><b>Client</b></td>
<td style=" border: 1px solid #333; padding:6px;"><b>Showroom</td>
<td align="right" style=" border: 1px solid #333; padding:6px;"><b>Sales amount (ex VAT)</b></td>
<td style=" border: 1px solid #333; padding:6px;"><b>Coupon code</b></td>
<td style=" border: 1px solid #333; padding:6px;"><b>Sales date</b></td>
<td style=" border: 1px solid #333; padding:6px;"><b>Summary</b></td>
</tr>
<?php foreach ($clientordersMonth as $row) {
	$showroom=''; 
	if (isset($row['virtual_idlocation'])) {
		$sql="select adminheading from location L where idlocation=" .$row["virtual_idlocation"];
		$rs = $this->AuxiliaryData->getDataArray($sql,[]);  
			foreach ($rs as $rows) {
				$showroom=$rows['adminheading'];
			} 
	}
	$summary='';
	if ($row['mattressrequired']=='y') {
		$summary.=$row['savoirmodel']." ";
	}
	if ($row['baserequired']=='y') {
		$summary.=$row['basesavoirmodel']." ";
	}
	if ($row['topperrequired']=='y') {
		$summary.=$row['toppertype']." ";
	}
	if ($row['valancerequired']=='y') {
		$summary.='Valance ';
	}
	$orderdate=date("d/m/Y", strtotime($row['ORDER_DATE']));

	?>
	<tr>
	<td style=" border: 1px solid #333; padding:6px;"><?= $row['surname'] ?></td>
	<td style=" border: 1px solid #333; padding:6px;"><?= $showroom ?></td>
	<td align="right" style=" border: 1px solid #333; padding:6px;"><?= $row['totalexvat'] ?></td>
	<td style=" border: 1px solid #333; padding:6px;"><?= $row['code'] ?></td>
	<td style=" border: 1px solid #333; padding:6px;"><?= $orderdate ?></td>
	<td style=" border: 1px solid #333; padding:6px;"><?= $summary ?></td>
	</tr>
<?php } ?>

</table>

