<?php use Cake\Routing\Router; ?>

<div class="brochure" style="background-color:#fff;">
<h1>Production Orders

</h1>
<?php
$londonactive='';
 if ($factory==2 && $cwc != 'y') {
  $londonactive='greentextB';
}
$cardiffactive='';
 if ($factory==1 && $cwc != 'y') {
  $cardiffactive='greentextB';
}
$stockactive='';
 if ($factory==4) {
  $stockactive='greentextB';
}
$unassignedactive='';
 if ($factory==0) {
  $unassignedactive='greentextB';
}
$londonactiveCWC='';
 if ($factory==2 && $cwc == 'y') {
  $londonactiveCWC='greentextB';
}
$cardiffactiveCWC='';
 if ($factory==1 && $cwc == 'y') {
  $cardiffactiveCWC='greentextB';
}
$all='';
 if ($factory == '') {
  $all='greentextB';
}
 ?>
<p>Filter by:  <b><a style="padding-right:11px;padding-left:20px;" href="/php/ProductionList" class='<?= $all ?>'>All Orders</a>
 
<a style="padding-right:11px;padding-left:11px;" href="/php/ProductionList?factory=2" class='<?= $londonactive ?>'>London Orders</a> | 
<a style="padding-right:11px;padding-left:11px;" href="/php/ProductionList?factory=1" class='<?= $cardiffactive ?>'>Cardiff Orders</a> | 
<a style="padding-right:11px;padding-left:11px;" href="/php/ProductionList?factory=0" class='<?= $unassignedactive ?>'>Unassigned Orders</a> | 
<a style="padding-right:11px;padding-left:11px;" href="/php/ProductionList?cwc=y&factory=2" class='<?= $londonactiveCWC ?>'>London confirmed waiting to check</a> | 
<a style="padding-right:11px;padding-left:11px;" href="/php/ProductionList?cwc=y&factory=1" class='<?= $cardiffactiveCWC ?>'>Cardiff confirmed waiting to check</a> | 
<a href="/php/ProductionList/export?factory=<?= $factory ?>&cwc=<?= $cwc ?>">&nbsp;&nbsp;&nbsp;Download csv <i class="fa-solid fa-file-csv fa-3x"></i></a></b></p>
</a>
<p>No of records = <?= $total ?></p>
<div style="font-size:11px;">
<table id="myTable" class="display compact">
<thead>
<tr style='font-size:11px;background-color:white; z-index:4;'>
<th style='font-size:11px;background-color:white; z-index:2;'>&nbsp;</th>
<th style='font-size:11px;background-color:white; z-index:2;'>&nbsp;</th>
<th style='font-size:11px;background-color:white; z-index:2;'>&nbsp;</th>
<th style='font-size:11px;background-color:white; z-index:2;'>&nbsp;</th>
<th style='font-size:11px;background-color:white; z-index:2;'>&nbsp;</th>
<th colspan='3' style='font-size:11px;border-left: solid;border-right: solid;background-color:white; z-index:2;'>Mattress</th>
<th colspan='3' style='font-size:11px;border-right: solid;background-color:white; z-index:2;'>Base</th>
<th colspan='3' style='font-size:11px;border-right: solid;background-color:white; z-index:2;'>Topper</th>
<th colspan='3' style='font-size:11px;border-right: solid;background-color:white; z-index:2;'>Headboard</th>
<th colspan='3' style='font-size:11px;border-right: solid;background-color:white; z-index:2;'>Legs</th>
<th colspan='3' style='font-size:11px;border-right: solid;background-color:white; z-index:2;'>Valance</th>
<th colspan='2' style='font-size:11px;border-right: solid;background-color:white; z-index:2;'>&nbsp;</th>
</tr>
	<tr style='background-color:white; z-index:4;'>
		<th style='font-size:11px;background-color:white; z-index:4;'>Customer Name</th>
		<th style='font-size:11px;background-color:white; z-index:1;'>Company</th>
		<th style='font-size:11px;'>Order Source</th>
		<th style='font-size:11px;'>Order No.</th>
		<th style='font-size:11px;'>Order Date</th>
		<th style='font-size:11px;'>Req.</th>
		<th style='font-size:11px;'>Made At</th>
		<th style='font-size:11px;'>Order Status</th>
		<th style='font-size:11px;'>Req.</th>
		<th style='font-size:11px;'>Made At</th>
		<th style='font-size:11px;'>Order Status</th>
		<th style='font-size:11px;'>Req.</th>
		<th style='font-size:11px;'>Made At</th>
		<th style='font-size:11px;'>Order Status</th>
		<th style='font-size:11px;'>Req.</th>
		<th style='font-size:11px;'>Made At</th>
		<th style='font-size:11px;'>Order Status</th>
		<th style='font-size:11px;'>Req.</th>
		<th style='font-size:11px;'>Made At</th>
		<th style='font-size:11px;'>Order Status</th>
		<th style='font-size:11px;'>Req.</th>
		<th style='font-size:11px;'>Made At</th>
		<th style='font-size:11px;'>Order Status</th>
		<th style='font-size:11px;'>Production Date</th>
		<th style='font-size:11px;'>Booked Delivery Date</th>
		
	</tr>
</thead>
<tbody>
<?php foreach ($OrdersInProduction as $row): ?>
 <tr>
 <td style='background-color:white'>
<p>
<?php if ($row['title'] != '') {
echo $row['title'] ." ";
} ?>
<?php if ($row['first'] != '') {
echo $row['first'] ." ";
} ?>
<?php if ($row['surname'] != '') {
echo $row['surname'] .', ';
} ?>
</td>
<td>
<?php if ($row['company'] != '') {
echo $row['company'] .' ';
} ?>
</td>
<td>
<?php if ($row['adminheading'] != '') {
echo $row['adminheading'] .' ';
} ?>
</td>
<td>
<?php if ($row['ORDER_NUMBER'] != '') {
echo "<a href=/orderdetails.asp?pn=".$row['PURCHASE_No'].">".$row['ORDER_NUMBER']."</a> ";
} ?>
</td>
<td>
<?php if ($row['ORDER_DATE'] != '') {
$orderdate=date('d-m-Y',strtotime($row['ORDER_DATE']));

echo $orderdate .' ';
} ?>
</td>
<?php 
$madeatname='';
$madeatStatus='';
$bayno='';
$model='';
$statustxt='';
$bgstyle='';
if ($row['mattressrequired'] == 'y') {
	if ($row['savoirmodel'] != '') {
		$model=$row['savoirmodel'];
	}
	if ($row['matt_madeat'] != '') {
		$madeatname=getMadeAtName($this->AuxiliaryData,$row['matt_madeat']);
	}
	if ($row['matt_madeat']=='') {
		$madeatStatus='border: 1px red solid;';
	}
	$bayno = getItemBay($this->AuxiliaryData,1,$row['ORDER_NUMBER']);
	if ($row['matt_status'] != '') {
		$statustxt=getStatustxt($this->AuxiliaryData,$row['matt_status'])."<br>";
	}
	if ($bayno != '') {
		$statustxt .= $bayno;
	}
	if ($row['matt_status'] < 20) {
		$bgstyle='background-color:#FFA59D;';
	}
}

?>
<td style='border-left: solid;'>
<?php
echo $model .' ';
?>
</td>

<td style='<?= $madeatStatus ?>'>
<?php
echo $madeatname;
?>
</td>

<td style='border-right: solid;<?= $bgstyle ?>'><?= $statustxt ?>&nbsp;</td>

<?php 
$madeatname='';
$madeatStatus='';
$bayno='';
$model='';
$statustxt='';
$bgstyle='';
if ($row['baserequired'] == 'y') {
	if ($row['basesavoirmodel'] != '') {
		$model=$row['basesavoirmodel'];
	}
	if ($row['base_madeat'] != '') {
		$madeatname=getMadeAtName($this->AuxiliaryData,$row['base_madeat']);
	}
	if ($row['base_madeat']=='') {
		$madeatStatus='border: 1px red solid;';
	}
	$bayno = getItemBay($this->AuxiliaryData,3,$row['ORDER_NUMBER']);
	if ($row['base_status'] != '') {
		$statustxt=getStatustxt($this->AuxiliaryData,$row['base_status'])."<br>";
	}
	if ($bayno != '') {
		$statustxt .= $bayno;
	}
	if ($row['base_status'] < 20) {
		$bgstyle='background-color:#FFA59D;';
	}
}
?>
<td>
<?php
echo $model;
?>
</td>
<td style='<?= $madeatStatus ?>'>
<?php
echo $madeatname;
?>
</td>
<td style='border-right: solid;<?= $bgstyle ?>'><?= $statustxt ?>&nbsp;</td>

<?php 
$madeatname='';
$madeatStatus='';
$bayno='';
$model='';
$statustxt='';
$bgstyle='';
if ($row['topperrequired'] == 'y') {
	if ($row['toppertype'] != '') {
		$model=$row['toppertype'];
	}
	if ($row['topper_madeat'] != '') {
		$madeatname=getMadeAtName($this->AuxiliaryData,$row['topper_madeat']);
	}
	if ($row['topper_madeat']=='') {
		$madeatStatus='border: 1px red solid;';
	}
	$bayno = getItemBay($this->AuxiliaryData,5,$row['ORDER_NUMBER']);
	if ($row['topper_status'] != '') {
		$statustxt=getStatustxt($this->AuxiliaryData,$row['topper_status'])."<br>";
	}
	if ($bayno != '') {
		$statustxt .= $bayno;
	}
	if ($row['topper_status'] < 20) {
		$bgstyle='background-color:#FFA59D;';
	}
}

?>
<td>
<?php
echo $model;
?>
</td>
<td style='<?= $madeatStatus ?>'>
<?php
echo $madeatname;
?>
</td>
<td style='border-right: solid;<?= $bgstyle ?>'><?= $statustxt ?>&nbsp;</td>

<?php 
$madeatname='';
$madeatStatus='';
$bayno='';
$model='';
$statustxt='';
$bgstyle='';
if ($row['headboardrequired'] == 'y') {
	if ($row['headboardstyle'] != '') {
		$model=$row['headboardstyle'];
	}
	if ($row['headboard_madeat'] != '') {
		$madeatname=getMadeAtName($this->AuxiliaryData,$row['headboard_madeat']);
	}
	if ($row['headboard_madeat']=='') {
		$madeatStatus='border: 1px red solid;';
	}
	$bayno = getItemBay($this->AuxiliaryData,8,$row['ORDER_NUMBER']);
	if ($row['headboard_status'] != '') {
		$statustxt=getStatustxt($this->AuxiliaryData,$row['headboard_status'])."<br>";
	}
	if ($bayno != '') {
		$statustxt .= $bayno;
	}
	if ($row['headboard_status'] < 20) {
		$bgstyle='background-color:#FFA59D;';
	}
}

?>
<td>
<?php
echo $model;
?>
</td>
<td style='<?= $madeatStatus ?>'>
<?php
echo $madeatname;
?>
</td>
<td style='border-right: solid;<?= $bgstyle ?>'><?= $statustxt ?>&nbsp;</td>

<?php 
$madeatname='';
$madeatStatus='';
$bayno='';
$model='';
$statustxt='';
$bgstyle='';
if ($row['legstyle'] == 'y') {
	if ($row['legstyle'] != '') {
		$model=$row['legstyle'];
	}
	if ($row['legs_madeat'] != '') {
		$madeatname=getMadeAtName($this->AuxiliaryData,$row['legs_madeat']);
	}
	if ($row['legs_madeat']=='') {
		$madeatStatus='border: 1px red solid;';
	}
	$bayno = getItemBay($this->AuxiliaryData,7,$row['ORDER_NUMBER']);
	if ($row['headboard_status'] != '') {
		$statustxt=getStatustxt($this->AuxiliaryData,$row['legs_status'])."<br>";
	}
	if ($bayno != '') {
		$statustxt .= $bayno;
	}
	if ($row['legs_status'] < 20) {
		$bgstyle='background-color:#FFA59D;';
	}
}

?>
<td>
<?php
echo $model;
?>
</td>
<td style='<?= $madeatStatus ?>'>
<?php
echo $madeatname;
?>
</td>
<td style='border-right: solid;<?= $bgstyle ?>'><?= $statustxt ?>&nbsp;</td>

<?php 
$madeatname='';
$madeatStatus='';
$bayno='';
$model='';
$statustxt='';
$bgstyle='';
if ($row['valancefabricchoice'] == 'y') {
	if ($row['valancefabricchoice'] != '') {
		$model=$row['valancefabricchoice'];
	}
	if ($row['valance_madeat'] != '') {
		$madeatname=getMadeAtName($this->AuxiliaryData,$row['valance_madeat']);
	}
	if ($row['valance_madeat']=='') {
		$madeatStatus='border: 1px red solid;';
	}
	$bayno = getItemBay($this->AuxiliaryData,6,$row['ORDER_NUMBER']);
	if ($row['headboard_status'] != '') {
		$statustxt=getStatustxt($this->AuxiliaryData,$row['valance_status'])."<br>";
	}
	if ($bayno != '') {
		$statustxt .= $bayno;
	}
	if ($row['valance_status'] < 20) {
		$bgstyle='background-color:#FFA59D;';
	}
}

?>
<td>
<?php 
echo $model;
?>
</td>
<td style='<?= $madeatStatus ?>'>
<?php
echo $madeatname;
?>
</td>
<td style='border-right: solid;<?= $bgstyle ?>'><?= $statustxt ?>&nbsp;</td>
<td style='border-right: solid;'>
<?php 
$productiondate='';
if ($row['productiondate'] != '') {
$productiondate=date('d-m-Y',strtotime($row['productiondate']));
echo $productiondate .' ';
} ?></td>
<td style='border-right: solid;'>
<?php 
$bookeddeliverydate='';
if ($row['bookeddeliverydate'] != '') {
$bookeddeliverydate=date('d-m-Y',strtotime($row['bookeddeliverydate']));
echo $bookeddeliverydate .' ';
} ?></td>
</tr>
<?php endforeach; ?>     
</tbody>
</table>
</div>
</div>
<script>

$(document).ready( function () {
    $('#myTable').DataTable({
    //"scrollX":        "300px",
    //"scrollY":        true,
    //"scrollCollapse": true,
    "paging" : false,
    "order": [[ 3, "asc" ]], //or asc 
    "columnDefs": [
    {"targets":[4,23,24], "type":"date-eu"}],
    "fixedHeader": true,
    "fixedColumns" :   {
            left: 1
        }
    
    });
    var table = $('#myTable').DataTable();
$('#myTable').css( 'display', 'block' );
table.columns.adjust().draw();


});


</script>


<?php 
function getStatustxt($auxhelper,$compstatus) {

    $sql = "Select QC_status from qc_status where QC_StatusID=". $compstatus ."";
    $statustxt='';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				$statustxt=$rows['QC_status'];
	    	 endforeach;
    return $statustxt;
} 

function getMadeAtName($auxhelper,$madeat) {
    $sql = "Select * from manufacturedat where ManufacturedAtID=".$madeat."";
    $madeatname='';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				$madeatname=$rows['ManufacturedAt'];
	    	 endforeach;
    return $madeatname;
}

function getItemBay($auxhelper,$compid, $orderno) {
    $sql = "Select bay_name from bay_content B, bays X where B.componentId=". $compid ." and B.orderId = ". $orderno ." and B.bayNumber=X.bay_no";
    $bayno='';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				$bayno=$rows['bay_name'];
	    	 endforeach;
    return $bayno;
} ?>
