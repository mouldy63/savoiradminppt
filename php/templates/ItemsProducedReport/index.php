<?php use Cake\Routing\Router; ?>

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

<div class="brochure">
<form action="/php/ItemsProducedReport/" method="post" name="form1" id="form1">
<input type="hidden" name="sortorder" id="sortorder" value="<?= $sortorder ?>" />
<p><b>Items Produced Report</b></p>
<p><b>Item Finished Date</b>
<p>from&nbsp;

<input name="monthfrom" type="text" id="monthfrom" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($monthfrom) ?>">
		      &nbsp;&nbsp;&nbsp;&nbsp;to&nbsp;
<input name="monthto" type="text" id="monthto" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($monthto) ?>">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;              </p>
<p><select name="showroom" id="showroom">
<option value="n"> Choose Showroom:  </option>
<option value="all"> All Showroom:  </option>
<?php foreach ($activeshowrooms as $row): ?> 
<?php $slct = ($row['idlocation'] == $showroom) ? "selected" : "";   ?>              
<option <?= $slct ?> value="<?= $row['idlocation'] ?>"><?= $row['adminheading'] ?></option>
<?php endforeach; ?>
</select></p>

<input type="submit" name="search" value="Search Database"  id="search" class="button" onclick="changeFormAction('form1', '/php/ItemsProducedReport/');"  />
<label>
<input name="csv" type="submit" class="button" id="csv" value="Produce CSV file"  onclick="changeFormAction('form1', '/php/ItemsProducedReport/export');">
</label>
</p>
</form>

<?php if (isset($itemsproduced)) { ?>
<table border='1' cellpadding='2px' style="font-size='8px'"><tr><td>Order No.</td><td>Customer Name</td><td>Order Type</td><td>Order Date</td><td>Delivery Date</td><td>Ex Works Date</td><td>Showroom</td><td>Item Completed</td><td>Specification</td><td>Made At</td><td>Issued Date</td><td>First Cut/<br>Prepped Date</td><td>Item Finished<br>Date</td><td>Production<br>Complete Date</td><td>VAT rate</td><td>Trade?</td><td>Item inc. VAT</td><td>Item exc. VAT</td><td>Discount Amount</td><td>Item Value Ex VAT Ex Discount</td><td>Currency</td><td>Special Instructions</td></tr>
<?php
foreach ($itemsproduced as $row): 
$madeat='';
if ($row['MadeAt']==1) {
	$madeat='Cardiff';
}
if ($row['MadeAt']==2) {
	$madeat='London';
}
if ($row['MadeAt']==3) {
	$madeat='Southern Drapes';
}
if ($row['bookeddeliverydate']==null) {
	$bookeddeliverydate='';
} else {
	$bookeddeliverydate=date("d-m-Y", strtotime($row['bookeddeliverydate']));
}
$specification='';
$cutdate='';
$vat='';
$incvat=0;
$excvat=0;
$baseprice=0;
$istrade;
$specialinstructions='';
$itemdiscount=0;
$itemdiscountnoVAT=0;
$difference=0;

$difference=$row['bedsettotal']-$row['subtotal'];
//if ($row['deliveryprice'] != '') {
//$difference=$difference-$row['deliveryprice'];
//debug($difference);
//}
$istrade=$row['istrade'];
if ($row['ComponentID']==1) {
	$specification=$row['savoirmodel'];
	if ($row['Cut'] > $row['springunitdate']) {
		$cutdate=$row['springunitdate'];
	} else {
		$cutdate=$row['Cut'];
	}
	if ($cutdate != '') {
		$cutdate=date("d-m-Y", strtotime($cutdate));
	}
	$incvat=$row['mattressprice'];
	if ($row['mattressinstructions'] != '') {
		$specialinstructions=$row['mattressinstructions'];
	} else {
		$specialinstructions='';
	}
	if ($difference > 0) {
		$itemdiscount=$row['mattressprice']/$row['bedsettotal'];
		$itemdiscount=$difference*$itemdiscount;
		$itemdiscountnoVAT=$row['mattressprice']-$itemdiscount;
		if ($istrade != 'y') {
			$itemdiscountnoVAT=$itemdiscountnoVAT/(1+$row['vatrate']/100);
		}
		$itemdiscount=number_format($itemdiscount,2);
		$itemdiscountnoVAT=number_format($itemdiscountnoVAT,2);
	}

} else if ($row['ComponentID']==3) {
	$specification=$row['basesavoirmodel'];
	if ($row['Cut'] > $row['Framed']) {
		$cutdate=$row['Framed'];
	} else {
		$cutdate=$row['Cut'];
	}
	if ($cutdate != '') {
		$cutdate=date("d-m-Y", strtotime($cutdate));
	}
	if ($row['upholsteryprice'] !='') {
		$baseprice=$row['baseprice']+$row['upholsteryprice'];
	}
	if ($row['basetrimprice'] !='') {
		$baseprice=$baseprice+$row['basetrimprice'];
	}
	if ($row['basedrawersprice'] !='') {
		$baseprice=$baseprice+$row['basedrawersprice'];
	}
	if ($row['basefabricprice'] !='') {
		$baseprice=$baseprice+$row['basefabricprice'];
	}
	if ($row['baseinstructions'] != '') {
		$specialinstructions=$row['baseinstructions'];
	}  else {
		$specialinstructions='';
	}	
	$incvat=$baseprice;
	if ($difference > 0) {
		$itemdiscount=$baseprice/$row['bedsettotal'];
		$itemdiscount=$difference*$itemdiscount;
		$itemdiscountnoVAT=$baseprice-$itemdiscount;
		if ($istrade != 'y') {
			$itemdiscountnoVAT=$itemdiscountnoVAT/(1+$row['vatrate']/100);
		}
		$itemdiscount=number_format($itemdiscount,2);
		$itemdiscountnoVAT=number_format($itemdiscountnoVAT,2);
	}

} else if ($row['ComponentID']==5) {
	$specification=$row['toppertype'];
	$cutdate=$row['Cut'];
	if ($cutdate != '') {
		$cutdate=date("d-m-Y", strtotime($cutdate));
	}
	$incvat=$row['topperprice'];
	if ($row['specialinstructionstopper'] != '') {
		$specialinstructions=$row['specialinstructionstopper'];
	} else {
		$specialinstructions='';
	}
	if ($difference > 0) {
		$itemdiscount=$row['topperprice']/$row['bedsettotal'];
		$itemdiscount=$difference*$itemdiscount;
		$itemdiscountnoVAT=$row['topperprice']-$itemdiscount;
		if ($istrade != 'y') {
			$itemdiscountnoVAT=$itemdiscountnoVAT/(1+$row['vatrate']/100);
		}
		$itemdiscount=number_format($itemdiscount,2);
		$itemdiscountnoVAT=number_format($itemdiscountnoVAT,2);
	}

} else if ($row['ComponentID']==7) {
	$specification=$row['legstyle'];
	$cutdate=$row['prepped'];
	if ($cutdate != '') {
		$cutdate=date("d-m-Y", strtotime($cutdate));
	}
	$incvat=$row['legprice'];
	if ($row['addlegprice'] !='') {
	 $incvat=$row['legprice']+$row['addlegprice'];
	}
	if ($row['specialinstructionslegs'] != '') {
		$specialinstructions=$row['specialinstructionslegs'];
	} else {
		$specialinstructions='';
	}
	if ($difference > 0) {
		$itemdiscount=$incvat/$row['bedsettotal'];
		$itemdiscount=$difference*$itemdiscount;
		$itemdiscountnoVAT=$incvat-$itemdiscount;
		if ($istrade != 'y') {
			$itemdiscountnoVAT=$itemdiscountnoVAT/(1+$row['vatrate']/100);
		}
		$itemdiscount=number_format($itemdiscount,2);
		$itemdiscountnoVAT=number_format($itemdiscountnoVAT,2);
	}

} else if ($row['ComponentID']==8) {
	$specification=$row['headboardstyle'];
	$cutdate=$row['Framed'];
	if ($cutdate != '') {
		$cutdate=date("d-m-Y", strtotime($cutdate));
	}
	$incvat=$row['headboardprice'];
	if ($row['hbfabricprice'] != '') {
		$incvat=$incvat+$row['hbfabricprice'];
	}
	if ($row['headboardtrimprice'] != '') {
		$incvat=$incvat+$row['headboardtrimprice'];
	}
	if ($row['specialinstructionsheadboard'] != '') {
		$specialinstructions=$row['specialinstructionsheadboard'];
	} else {
		$specialinstructions='';
	}
	if ($difference > 0) {
		$itemdiscount=$incvat/$row['bedsettotal'];
		$itemdiscount=$difference*$itemdiscount;
		$itemdiscountnoVAT=$incvat-$itemdiscount;
		if ($istrade != 'y') {
			$itemdiscountnoVAT=$itemdiscountnoVAT/(1+$row['vatrate']/100);
		}
		$itemdiscount=number_format($itemdiscount,2);
		$itemdiscountnoVAT=number_format($itemdiscountnoVAT,2);
	}
}

if ($row['istrade']=='y') {
	$excvat=$incvat;
	$incvat=$incvat*(1+$row['vatrate']/100);
	if ($incvat != 0) {
	$incvat=number_format($incvat, 2);
	}
	if ($excvat != 0) {
	$excvat=number_format($excvat, 2);
	}
} else {
	$excvat=$incvat/(1+$row['vatrate']/100);
	if ($incvat != 0) {
	$incvat=number_format($incvat, 2);
	}
	if ($excvat != 0) {
	$excvat=number_format($excvat, 2);
	}
}
$exportdate='';
$sql = "Select E.CollectionDate from exportlinks L, exportCollShowrooms S, exportcollections E where L.purchase_no=".$row['PURCHASE_No']." and L.linksCollectionID=S.exportCollshowroomsID and E.exportCollectionsID=S.exportCollectionID AND L.componentID=".$row['ComponentID'];
$rs = $this->AuxiliaryData->getDataArray($sql,[]);  
			 foreach ($rs as $rows):
				$exportdate=date("d-m-Y", strtotime($rows['CollectionDate']));
	    	 endforeach;


$issuedate='';
$sql="select IssuedDate from QC_history where Purchase_No=".$row['PURCHASE_No']." AND ComponentID=".$row['ComponentID']." order by QC_Date desc limit 1";
	$rs = $this->AuxiliaryData->getDataArray($sql,[]);
	foreach ($rs as $rows) {
		$issuedate=$rows['IssuedDate'];
	}
if ($issuedate != '') {
	$issuedate=date("d-m-Y", strtotime($issuedate));
}
$finished=$row['finished'];
if ($finished != '') {
	$finished=date("d-m-Y", strtotime($finished));
}
$productiondate=$row['production_completion_date'];
if ($productiondate != '') {
	$productiondate=date("d-m-Y", strtotime($productiondate));
}

?>

<tr><td><?= $row['ORDER_NUMBER']?></td><td><?= $row['surname']?></td><td><?= $row['orderSource']?></td><td style="white-space:nowrap;"><?= date("d-m-Y", strtotime($row['ORDER_DATE']))?></td><td style="white-space:nowrap;"><?= $bookeddeliverydate ?></td><td style="white-space:nowrap;"><?= $exportdate ?></td><td><?= $row['adminheading'] ?></td><td><?= $row['Component'] ?></td><td><?= $specification ?></td><td><?= $madeat ?></td><td style="white-space:nowrap;"><?= $issuedate ?></td><td style="white-space:nowrap;"><?= $cutdate ?></td><td style="white-space:nowrap;"><?= $finished ?></td><td><?= $productiondate ?></td><td><?= $row['vatrate'] ?></td><td><?= $row['istrade'] ?></td><td><?= $incvat ?></td><td><?= $excvat ?></td><td><?= $itemdiscount ?></td><td><?= $itemdiscountnoVAT ?></td><td><?= $row['ordercurrency'] ?></td><td><?= $specialinstructions ?></td></tr>

<?php
 endforeach;
 ?>
 </table>
 <?php 
 } ?>

</div>
<script>
function customReset() {
    $("#monthfrom").val("");
    $("#monthto").val("");
    return false;
}
$(document).ready(function(){
	$('#cancel').click(function(){
		$('.changeBack').each(function(index,element){
			var content = $(element).attr('data-orginal');
			$(element).val(content);
		});
		$('.changeBackOption').removeAttr('selected');
		$('.changeBackOption').each(function(index,element){
			var isSelected = $(element).attr('data-orginal');
			if(isSelected.length>0){
				var select = document.createAttribute("selected");
				element.setAttributeNode(select);
			}
		});
	});
});

function changeFormAction(formId, newAction) {
	$('#' + formId).attr('action', newAction);
}
function sortby(sortVal) {
	$("#sortorder").val(sortVal);
	$("#form1").submit();
} 
</script>