<tr><td class = "twotablecell emptycell bordercell">Savoir Owned</td>
<?php for($ii=1;$ii<=10;$ii++):?>
<td class = "tablecell bordercell"></td>
<?php endfor;?>
</tr>
<?php
	$thisYear = date('Y');
	$thisMonth = date('m');
	$totalArrayKey = 1;
	foreach($allFigures as $yearKey=>$tempYearFigures):
		$tempYearTargets = $allTargets[$yearKey];
		
		$totalArray=array_fill(1,10,0);
		foreach($tempYearFigures as $showroomKey=>$showroomFigures):
			$showroomTargets = $tempYearTargets[$showroomKey];
?>
	<tr>
		<td class = "twotablecell bordercell"><?php echo $showroomFigures['showroomName'];?></td>
<?php 
			$thisyearYTD = 0;
			$thisyearTargetYTD = 0;
			$lastyearYTD = 0;
			foreach($showroomFigures['figures'] as $monthKey=>$tempMonthFigures):
				if($monthKey<=$currentMonth){
					$thisyearYTD += $tempMonthFigures;
			 		$thisyearTargetYTD += $showroomTargets[$monthKey]['amount'];
			 		$lastyearYTD += $allFiguresLastYear[$showroomKey]['figures'][$monthKey]; 
				}
			endforeach;
			$totalArray[1] += $showroomFigures['figures'][$currentMonth];
			$totalArray[2] += $showroomTargets[$currentMonth]['amount'];
			$totalArray[3] += $allFiguresLastYear[$showroomKey]['figures'][$currentMonth];
			$totalArray[4] += $lastyearYTD;
			$totalArray[5] += $thisyearTargetYTD;
			$totalArray[6] += $thisyearYTD;
			$totalArray[7] += ($thisyearYTD - $lastyearYTD);
			$totalArray[9] += ($thisyearYTD - $thisyearTargetYTD);
?>
		<td class = "tablecell bordercell"><?php echo number_format($showroomFigures['figures'][$currentMonth],2,'.',','); ?></td>
		<td class = "tablecell bordercell"><input class="set_target disablebg" onchange="allTargetsData.changeTarget(
			<?php echo $yearKey;?>,<?php echo $monthKey;?>,<?php echo $showroomKey;?>,this);return false;" type="text" value="<?php echo number_format($showroomTargets[$currentMonth]['amount'],0,'.',',');?>" disabled/></td>
		<td class = "tablecell bordercell"><?php echo number_format($allFiguresLastYear[$showroomKey]['figures'][$currentMonth],2,'.',','); ?></td>
		<td class = "tablecell bordercell"><?php echo number_format($lastyearYTD,2,'.',','); ?></td>
		<td class = "tablecell bordercell"><?php echo number_format($thisyearTargetYTD,2,'.',','); ?></td>
		<td class = "tablecell bordercell"><?php echo number_format($thisyearYTD,2,'.',','); ?></td>
		<td class = "tablecell bordercell"><?php echo number_format($thisyearYTD-$lastyearYTD,2,'.',','); ?></td>
		<td class = "tablecell bordercell"><?php echo $lastyearYTD==0?0:round((($thisyearYTD-$lastyearYTD)/$lastyearYTD)*100).'%'; ?></td>
		<td class = "tablecell bordercell"><?php echo number_format($thisyearYTD-$thisyearTargetYTD,2,'.',','); ?></td>
		<td class = "tablecell bordercell"><?php echo $thisyearTargetYTD==0?0:round((($thisyearYTD-$thisyearTargetYTD)/$thisyearTargetYTD)*100).'%'; ?></td>
	</tr>
<?php
		$totalArrayKey++;
		if($showroomKey == 34):
?>
		<tr><td class = "twotablecell emptycell bordercell"></td>
	<?php for($ii=1;$ii<=10;$ii++):?>
		<td class = "tablecell bordercell"></td>
	<?php endfor;?>
		</tr>
		<tr><td class = "twotablecell emptycell bordercell">Dealers</td>
	<?php for($ii=1;$ii<=10;$ii++):?>
		<td class = "tablecell bordercell"></td>
	<?php endfor;?>
		</tr>
<?php
		endif;
		endforeach;
	endforeach;
?>
<tr><th class = "twotablecell emptycell bordercell"></th>
	<?php for($ii=1;$ii<=10;$ii++):?>
		<td class = "tablecell bordercell"></td>
	<?php endfor;?>
		</tr>
<tr>
	<td class = "twotablecell bordercell">TOTAL:</td>
<?php
	for($ii=1;$ii<=10;$ii++):
		if($ii==8||$ii==10):
?>
	<td class = "tablecell bordercell"></td>		
<?php 	else:?>
	<td class = "tablecell bordercell"><?php echo number_format($totalArray[$ii],0,'.',',');?></td>

<?php
		endif;	
	endfor;
?>	
</tr>