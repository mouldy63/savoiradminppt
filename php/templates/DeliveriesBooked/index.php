<?php use Cake\Routing\Router; 
use Cake\I18n\FrozenTime;?>


<div class="containerwide">

  <div class="one-col head-col">
<table width="100%" border="0" cellpadding="0" cellspacing="0" id="bespoke">
<tr><td height="35" colspan="10" bgcolor="#999999">&nbsp;<br>  <strong>Production Date</strong><br>&nbsp;</td></tr>
<tr><td colspan="10"><hr></td></tr>
<?php 
$pweekno2='';
$itemstofinish=0;
$NoitemsNotFinished=0;
$weekCounter = 0;
foreach ($bookeddeliveries as $row):

$hasLondonItems = '';
$hasCardiffItems = '';


$compmadeat1=getMadeAt($this->AuxiliaryData,1,$row['PURCHASE_No']);
$compmadeat3=getMadeAt($this->AuxiliaryData,3,$row['PURCHASE_No']);
$compmadeat5=getMadeAt($this->AuxiliaryData,5,$row['PURCHASE_No']);
$compmadeat8=getMadeAt($this->AuxiliaryData,8,$row['PURCHASE_No']);
$compmadeat7=getMadeAt($this->AuxiliaryData,7,$row['PURCHASE_No']);
$finishedcomp1=isCompFinished($this->AuxiliaryData,1,$row['PURCHASE_No']);
$finishedcomp3=isCompFinished($this->AuxiliaryData,3,$row['PURCHASE_No']);
$finishedcomp5=isCompFinished($this->AuxiliaryData,5,$row['PURCHASE_No']);
$finishedcomp8=isCompFinished($this->AuxiliaryData,8,$row['PURCHASE_No']);
$finishedcomp7=isCompFinished($this->AuxiliaryData,7,$row['PURCHASE_No']);

if (($compmadeat1==1 && $finishedcomp1=="n") || ($compmadeat3==1 && $finishedcomp3=="n") || ($compmadeat5==1 && $finishedcomp5=="n") || ($compmadeat8==1 && $finishedcomp8=="n") || ($compmadeat7==1 && $finishedcomp7=="n")) {
	$hasCardiffItems='y';
}
if (($compmadeat1==2 && $finishedcomp1=="n") || ($compmadeat3==2 && $finishedcomp3=="n") || ($compmadeat5==2 && $finishedcomp5=="n") || ($compmadeat8==2 && $finishedcomp8=="n") || ($compmadeat7==2 && $finishedcomp7=="n")) {
	$hasLondonItems='y';
}

$ItemNotFinished='';
if ($finishedcomp1=="n" || $finishedcomp3=="n" || $finishedcomp5=="n" || $finishedcomp8=="n" || $finishedcomp7=="n") {
	$itemsNotFinished='y';
}


if (($hasCardiffItems=='y' && $factory==1) || ($hasLondonItems=='y' && $factory==2)) {


	$productiondate='';
	$realproductiondate=new FrozenTime($row['productiondate']);
	if ($factory==2) {
		if (isset($row['LondonProductionDate'])) {
			$productiondate=new FrozenTime($row['LondonProductionDate']);
		}
	} 
	if ($factory==1) {
		if (isset($row['CardiffProductionDate'])) {
			$productiondate=new FrozenTime($row['CardiffProductionDate']);
		}
	}
	//debug("proddate=".$productiondate);
	//debug("realproddate=".$realproductiondate);
	//die;
	$proddate = new FrozenTime($row['CardiffProductionDate']);
	$newDate = $proddate->subDays($getNoFloorItems);
	
	$dofweek=date('w', strtotime($realproductiondate));
	$startweek=7-$dofweek;
	$pnewweek = $realproductiondate->addDays($startweek);
	
	$pweekno= $productiondate->format("W");
	
	$daysToAdd = 7 - $productiondate->dayOfWeek;
	if ($daysToAdd == 0) $daysToAdd = 7;
	$strdate = $productiondate->addDays($daysToAdd);
	$enddate=$productiondate->addDays($daysToAdd);

	$enddate = $productiondate->subDays($productiondate->dayOfWeek);
	$realProdStartDate=$realproductiondate->subDays($realproductiondate->dayOfWeek);
	
	$realProdEndDate=$realproductiondate->subDays($realproductiondate->dayOfWeek);

	//debug("productiondate=".$productiondate);
	//debug("rproddate=".$realproductiondate);
	//debug("dow=".$dofweek);
	//debug("pnewweek=".$pnewweek);
	//debug("startweek=".$startweek);
	//debug("strdate=".$strdate);
	//debug("realProdStartDate=".$realProdStartDate);
	//debug("enddate=".$enddate);
	//debug("realProdEndDate=".$realProdEndDate);
	//debug("order=".$row['ORDER_NUMBER']);
	//die;
	if ($productiondate != '') {
		$productiondate=date_format($productiondate,"d/m/Y");
	}
	?>
	<?php if ($pweekno != $pweekno2) {
	?>
	<script>
		$(document).ready(function(){
			$("#td<?=$weekCounter?>").html("<?=$NoitemsNotFinished?> items to finish");
		});
	</script>
	<?php
		$weekCounter++;
	 ?>
	<tr>
		<td height="17" colspan="2" bgcolor="#999999"><span id='<?= $pweekno ?>'>Week No. <?= $pweekno ?></span></td><td id="td<?=$weekCounter?>" colspan="6" bgcolor="#999999" align="center"></td><td style="text-align:right" height="17" colspan="2" bgcolor="#999999">Production&nbsp;Date</td>
	</tr>
	<?php 
	$NoitemsNotFinished=0;
	} else { ?>
	<tr><td colspan="10"><hr></td></tr>
	<?php 
	}
	$pweekno2 = $pweekno;
	$custname='';
	if ($row['title'] != '') {
		$custname=$row['title']." ";
	} 
	if ($row['first'] != '') {
		$custname.=$row['first']." ";
	} 
	if ($row['surname'] != '') {
		$custname.=$row['surname']." ";
	} 
	$custname=substr($custname, 0, 25);
	?>
	
	<tr>
      <td valign="top"><a href="/orderdetails.asp?pn=<?=$row['PURCHASE_No']?>" target="_blank"><font size="+2"><?=$row['ORDER_NUMBER']?></font></a></td>
      <td valign="top" id="bespoke2" style="font-size:11px;padding-left:2px;"><?= $custname ?><br>
      <?=$row['company']?></td>
      <td valign="top"id="bespoke2" style="font-size:11px;"><?= $row['customerreference']?></td>
      <td valign="top"id="bespoke2" style="font-size:11px;"><?= $row['adminheading']?></td>
      <?php if ($row['mattressrequired']=='y' && $compmadeat1==$factory) { 
      ?>
      <?php
	if (getColourForEntry($this->AuxiliaryData, 1, $row['PURCHASE_No'], 'Cut')=='red' || getColourForEntry($this->AuxiliaryData, 1, $row['PURCHASE_No'], 'Machined')=='red' || getColourForEntry($this->AuxiliaryData, 1, $row['PURCHASE_No'], 'springunitdate')=='red' || getColourForEntry($this->AuxiliaryData, 1, $row['PURCHASE_No'], 'finished')=='red') {
	$NoitemsNotFinished +=1;
	}
	?>
      <td width="18%" valign="top"><span style="display:block;margin-bottom:-12px;margin-top:-5px;color:<?= getLockColourForStatus($this->AuxiliaryData,1,$row['PURCHASE_No']) ?>;"><?= $row['savoirmodel']?>&nbsp;Mattress</span><br>
      <font size="+3">
      
      <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 1, $row['PURCHASE_No'], 'Cut') ?>">&#9608;</span>
	  <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 1, $row['PURCHASE_No'], 'Machined') ?>">&#9608;</span>
      <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 1, $row['PURCHASE_No'], 'springunitdate') ?>">&#9608;</span>
      <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 1, $row['PURCHASE_No'], 'finished') ?>">&#9608;</span>
      </font></td>
     <?php } else {
     ?>
      <td width="1%" valign="top">&nbsp;</td>
     <?php

     }
     if ($row['baserequired']=='y' && $compmadeat3==$factory) { 
     ?>
      <?php
	if (getColourForEntry($this->AuxiliaryData, 3, $row['PURCHASE_No'], 'Cut')=='red' || getColourForEntry($this->AuxiliaryData, 3, $row['PURCHASE_No'], 'Machined')=='red' || getColourForEntry($this->AuxiliaryData, 3, $row['PURCHASE_No'], 'Framed')=='red' || getColourForEntry($this->AuxiliaryData, 3, $row['PURCHASE_No'], 'prepped')=='red' || getColourForEntry($this->AuxiliaryData, 3, $row['PURCHASE_No'], 'finished')=='red') {
	$NoitemsNotFinished +=1;
	}
	?>
           <td width="19%" valign="top"><span style="display:block;margin-bottom:-12px;margin-top:-5px;color:<?= getLockColourForStatus($this->AuxiliaryData,3,$row['PURCHASE_No']) ?>;"><?= $row['savoirmodel']?>&nbsp;Base</span><br>
      <font size="+3">
      <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 3, $row['PURCHASE_No'], 'Cut') ?>">&#9608;</span>
	  <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 3, $row['PURCHASE_No'], 'Machined') ?>">&#9608;</span>
       <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 3, $row['PURCHASE_No'], 'Framed') ?>">&#9608;</span>
	  <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 3, $row['PURCHASE_No'], 'prepped') ?>">&#9608;</span>
     <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 3, $row['PURCHASE_No'], 'finished') ?>">&#9608;</span>
      </font></td>
    <?php } else {
     ?>
      <td width="1%" valign="top">&nbsp;</td>
     <?php
     }
     if ($row['topperrequired']=='y' && $compmadeat5==$factory) { 
     ?>  
     <?php
	if (getColourForEntry($this->AuxiliaryData, 51, $row['PURCHASE_No'], 'Cut')=='red' || getColourForEntry($this->AuxiliaryData, 5, $row['PURCHASE_No'], 'Machined')=='red' ||  getColourForEntry($this->AuxiliaryData, 5, $row['PURCHASE_No'], 'finished')=='red') {
	$NoitemsNotFinished +=1;
	}
	?>
      <td width="12%" valign="top"><span style="display:block;margin-bottom:-12px;margin-top:-5px;color:<?= getLockColourForStatus($this->AuxiliaryData,5,$row['PURCHASE_No']) ?>;"><?= $row['toppertype']?></span><br><font size="+3">
       <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 5, $row['PURCHASE_No'], 'Cut') ?>">&#9608;</span>
	  <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 5, $row['PURCHASE_No'], 'Machined') ?>">&#9608;</span>
      <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 5, $row['PURCHASE_No'], 'finished') ?>">&#9608;</span>
      </font></td>
     <?php } else {
     ?>
      <td width="1%" valign="top">&nbsp;</td>
     <?php
     }
     if ($row['headboardrequired']=='y' && $compmadeat8==$factory) { 
     ?> 
      <?php
	if (getColourForEntry($this->AuxiliaryData, 8, $row['PURCHASE_No'], 'Framed')=='red' || getColourForEntry($this->AuxiliaryData, 8, $row['PURCHASE_No'], 'prepped')=='red' || getColourForEntry($this->AuxiliaryData, 8, $row['PURCHASE_No'], 'finished')=='red') {
	$NoitemsNotFinished +=1;
	}
	?>
      <td width="12%" valign="top"><span style="display:block;margin-bottom:-12px;margin-top:-5px;color:<?= getLockColourForStatus($this->AuxiliaryData,8,$row['PURCHASE_No']) ?>;"><?= $row['headboardstyle']?></span><br>
      <font size="+3">
       <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 8, $row['PURCHASE_No'], 'Framed') ?>">&#9608;</span>
	  <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 8, $row['PURCHASE_No'], 'prepped') ?>">&#9608;</span>
     <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 8, $row['PURCHASE_No'], 'finished') ?>">&#9608;</span>
      </font></td>
     <?php } else {
     ?>
      <td width="1%" valign="top">&nbsp;</td>
     <?php
     }
     if ($row['legsrequired']=='y' && $compmadeat7==$factory) { 
     ?>
      <?php
	if (getColourForEntry($this->AuxiliaryData, 7, $row['PURCHASE_No'], 'prepped')=='red' || getColourForEntry($this->AuxiliaryData, 7, $row['PURCHASE_No'], 'finished')=='red') {
	$NoitemsNotFinished +=1;
	}
	?> 
      <td width="7%" valign="top"><span style="display:block;margin-bottom:-12px;margin-top:-5px;color:<?= getLockColourForStatus($this->AuxiliaryData,7,$row['PURCHASE_No']) ?>;"><?= $row['legstyle']?></span><br><font size="+3">
       <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 7, $row['PURCHASE_No'], 'prepped') ?>">&#9608;</span>
     <span style="white-space: pre;color:<?= getColourForEntry($this->AuxiliaryData, 7, $row['PURCHASE_No'], 'finished') ?>">&#9608;</span>
      </font></td>
      <?php } else {
     ?>
      <td width="1%" valign="top">&nbsp;</td>
     <?php
     }
     ?>
      <td width="2%" valign="top"><?= $productiondate ?><td>
    </tr>
<?php
}
endforeach;
?>
</table>
</div>
</div>
<script>
$(document).ready(function(){
	$("#td<?=$weekCounter?>").html("<?=$NoitemsNotFinished?> to finish");
});
</script>

<?php
function getMadeAt($auxhelper,$compid, $pn) {
    $sql = "Select * from qc_history_latest where ComponentID=".$compid." AND Purchase_No =".$pn."";
    $madeat='';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				$madeat=$rows['MadeAt'];
	    	 endforeach;
    return $madeat;
}

function isCompFinished($auxhelper,$compid, $pn) {
    $sql = "Select finished from qc_history_latest where ComponentID=".$compid." AND Purchase_No =".$pn."";
    $isCompFinished='y';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				if ($rows['finished'] == null) {
					$isCompFinished='n';
				}
	    	 endforeach;
    return $isCompFinished;
}

function getLockColourForStatus($auxhelper,$compid, $pn) {

	$sql = "select QC_StatusID from qc_history_latest where purchase_no=".$pn." and componentid=".$compid."";
	$getLockColourForStatus='';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				$aStatus=$rows['QC_StatusID'];
	    	 endforeach;
	    	 
	if ($aStatus == 20) {
		$getLockColourForStatus = "red"; //In Production
	} elseif ($aStatus == 30) {
		$getLockColourForStatus = "orange"; // Order on Stock, Waiting QC
	} elseif ($aStatus == 40) {
		$getLockColourForStatus = "green"; // QC Checked
	} elseif ($aStatus == 50) {
		$getLockColourForStatus = "green"; // In Bay
	} elseif ($aStatus == 60) {
		$getLockColourForStatus = "green"; // Order Picked
	} elseif ($aStatus == 70) {
		$getLockColourForStatus = "grey"; // Delivered
	} else {
		$getLockColourForStatus = "white";
	}
	//debug("getLockColourForStatus=".$getLockColourForStatus);
	//    	 die;
	return $getLockColourForStatus;
}

function getColourForEntry($auxhelper,$compid, $pn, $afname) {
	$sql = "select * from QC_history_latest where componentid=".$compid." and purchase_no=".$pn."";
	$getColourForEntry = '';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				if ($rows[$afname]<>'') {
				$getColourForEntry = "green"; 
				} else {
				$getColourForEntry = "red"; 
				}
	    	 endforeach;
	return $getColourForEntry;

}





?>