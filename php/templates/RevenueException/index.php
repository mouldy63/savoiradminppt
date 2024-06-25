<?php echo $this->Html->css('savoir.css',array('inline' => false));?>
<?php echo $this->Html->css('revenue.css',array('inline' => false));?>
<?php echo $this->Html->script('revenue.js', array('inline' => false)); ?>
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


}

</script>
<div class="container">
<div class='clear'></div>
<div class="path" id="revenueException"><a href="">Revenue Exception Report</a></div>
<div class='clear'></div>
<form action="/php/RevenueException" method="post"  onSubmit="return FrontPage_Form1_Validator(this)" name="form1" id="form1">
	<div class="showroom-select" style="margin:20px 30px;">
	
		<b>Select Showroom:</b>
		<select class="select showroom" id="showroom" name="showroom">
			<option value="--">--</option>
			<option value="all">All</option>
			<?php foreach ($activeshowrooms as $row): ?> 
			
			<?php $slct = ($row['idlocation'] == $showroom) ? "selected" : "";   ?>              
			<option <?= $slct ?> value="<?= $row['idlocation'] ?>"><?= $row['adminheading'] ?></option>
			<?php endforeach;?>
		</select><br><br>
		<b>Order Date from&nbsp;</b>

<input name="monthfrom" type="text" id="monthfrom" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($monthfrom) ?>">
		      &nbsp;&nbsp;&nbsp;&nbsp;<b>to</b>&nbsp;
<input name="monthto" type="text" id="monthto" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($monthto) ?>">
</p>
	</div>

	<div class="clear"></div>

	<div class="action-area">
		<div class="path" id="clear-selection"><a href="#" >Clear</a></div> 
		<div class="path" id="show-table"><input onclick="changeFormAction('form1', '/php/RevenueException/');" id="submit1" type="submit"value="View Results"></div>
		<div class="path" id="get-csv"><input onclick="changeFormAction('form1', '/php/RevenueException/export');" id="submit2" type="submit"value="CSV"></div> 
		<div class="clear">
	</div>
</form>	
<?php if (isset($allData)) {  ?>  
<div id="table-area">
<table cellspacing="2" cellpadding="2" class="tablebd" style="overflow-x:auto;">
<tr style="font-weight:bold;"><td>&nbsp;order&nbsp;date&nbsp;</td><td>production completion date</td><td>completed orders</td><td>delivery&nbsp;date</td><td>order number</td><td>surname</td><td>company</td><td>showroom</td><td>currency</td><td>discount</td><td>discountpercent</td><td>vat</td><td>vat rate</td><td>total</td><td>total after discount</td><td>total inc VAT</td><td>balance outstanding</td><td>payments</td><td>refunds</td><td>no1 mattress</td><td>no2 mattress</td><td>no3 mattress</td><td>no4 mattress</td><td>no4v mattress</td><td>other mattress</td><td>no1 base</td><td>no2 base</td><td>no3 base</td><td>no4 base</td><td>no4v base</td><td>savoir slim base</td><td>other base</td><td>hw topper</td><td>hca topper</td><td>cw topper</td><td>cfv topper</td><td>headboard</td><td>leg</td><td>accessories</td><td>delivery</td></tr>

<?php foreach ($allData as $row):
$afterVATRate = 1;
$tempDiscoutRate = 1; 
$totalafterdiscount=0;
$total=0;
$bedsettotal=0;
$discountPercent='';
$discount='';
$mattprice='';
$matt1='';
$matt2='';
$matt3='';
$matt4='';
$matt4v='';
$mattO='';
$DiscoutRate=1;
$baseprice='';
$base1='';
$base2='';
$base3='';
$base4='';
$base4v='';
$baseS='';
$baseO='';
$hw='';
$hca='';
$cw='';
$cfv='';
$topperprice='';
$headboardprice='';
$legprice='';
$accprice='';
$deliveryprice='';
$completedorders='No';
if (!empty($row['vatrate']) && $row['vatrate'] > 0) {
                $afterVATRate = (float) ((float) $row['vatrate'] + 100) / 100;
}
$bedsettotal=round((float) $row['bedsettotal'] / $afterVATRate, 2);
$totalafterdiscount=$bedsettotal;
if (!empty($row['discount'])) {
	if (strlen($row['discount']) > 0 && floatval($row['discount']) > 0.0) {
		if ($row['discounttype'] == 'currency') {
			$discount = round((float) $row['discount'] / $afterVATRate, 2);
			$DiscoutRate = 1 - (float) $row['discount'] / (float) $row['bedsettotal'];
			$discountPercent = (round((float) $row['discount'] / ((float) $row['bedsettotal']), 4) * 100);
		} else {
			$discount = round(((float) $row['bedsettotal'] * (float) $row['discount'] / 100) / $afterVATRate, 2);
			$DiscoutRate = 1 - (float) $row['discount'] / 100;
			$discountPercent = (float) $row['discount'];
		}
		$totalafterdiscount = $totalafterdiscount - $discount;
	}
}
 if ($row['mattressrequired'] == 'y') {
	$mattprice = round($row["mattr_sum"] / $afterVATRate, 2);
	$mattprice = round($mattprice * $DiscoutRate, 2);

	switch ($row["savoirmodel"]) {
		case 'No. 1':
			$matt1 = $mattprice;
			break;
		case 'No. 2':
			$matt2 = $mattprice;
			break;
		case 'No. 3':
			$matt3 = $mattprice;
			break;
		case 'No. 4':
			$matt4 = $mattprice;
			break;
		case 'No. 4v':
			$matt4v = $mattprice;
			break;
		default:
			$mattO = $mattprice;
	}
}
if ($row['baserequired'] == 'y') {
	$baseprice = round($row["base_sum"] / $afterVATRate, 2);
	$baseprice = round($baseprice * $DiscoutRate, 2);

	switch ($row["basesavoirmodel"]) {
		case 'No. 1':
			$base1 = $baseprice;
			break;
		case 'No. 2':
			$base2 = $baseprice;
			break;
		case 'No. 3':
			$base3 = $baseprice;
			break;
		case 'No. 4':
			$base4 = $baseprice;
			break;
		case 'No. 4v':
			$base4v = $baseprice;
			break;
		case 'Savoir Slim':
			$baseS = $baseprice;
			break;
		default:
			$baseO = $baseprice;
	}
}

if ($row['topperrequired'] == 'y') {
	$topperprice = round($row["topper_sum"] / $afterVATRate, 2);
	$topperprice = round($topperprice * $DiscoutRate, 2);

	switch ($row["toppertype"]) {
		case 'HW Topper':
			$hw = $baseprice;
			break;
		case 'HCa Topper':
			$hca = $baseprice;
			break;
		case 'CW Topper':
			$cw = $baseprice;
			break;
		case 'CFv Topper':
			$cfv = $baseprice;
			break;
	}
}
 if ($row['headboardrequired'] == 'y') {
	$headboardprice = round($row["hb_sum"] / $afterVATRate, 2);
	$headboardprice = round($headboardprice * $tempDiscoutRate, 2);
}
if ($row['legsrequired'] == 'y') {
	$legprice = round($row["leg_sum"] / $afterVATRate, 2);
	$legprice = round($legprice * $tempDiscoutRate, 2);
}
if ($row['accessoriesrequired'] == 'y') {
	$accprice = round($row["acce_sum"] / $afterVATRate, 2);
	$accprice = round($accprice * $tempDiscoutRate, 2);
}
if ($row['deliverycharge'] == 'y') {
	$deliveryprice = round($row["delivery_sum"] / $afterVATRate, 2);
	$deliveryprice = round($deliveryprice * $tempDiscoutRate, 2);
}
if ($row["completedorders"]=='y') {
	$completedorders = 'Yes';
}
if ($row['bookeddeliverydate']==null) {
$bookeddelivery=null;
} else {
$bookeddelivery=date('d-m-Y', strtotime($row['bookeddeliverydate']));
}
if ($row['ORDER_DATE']==null) {
$orderdate=null;
} else {
$orderdate=date('d-m-Y', strtotime($row['ORDER_DATE']));
}
if ($row['production_completion_date']==null) {
$productioncompletiondate=null;
} else {
$productioncompletiondate=date('d-m-Y', strtotime($row['production_completion_date']));
}
?>
<tr class="userrow"><td><?= $orderdate ?></td><td><?= $productioncompletiondate ?></td><td><?= $completedorders ?></td><td><?= $bookeddelivery ?></td><td><?= "<a href='/orderdetails.asp?pn=".$row['PURCHASE_No']."' target='_blank'>".$row['ORDER_NUMBER']."</a>"?></td><td> <?=$row['surname']?></td><td><?=$row['company']?></td><td><?=$row['adminheading']?></td><td><?=$row['ordercurrency']?></td><td><?= $discount ?></td><td><?= $discountPercent ?></td><td><?=$row['vat']?></td><td><?=$row['vatrate']?></td><td><?= $bedsettotal ?></td><td><?= $totalafterdiscount ?></td><td><?=$row['total']?></td><td><?=$row['balanceoutstanding']?></td><td><?=$row['payments']?></td><td><?=$row['refunds']?></td><td><?= $matt1 ?></td><td><?= $matt2 ?></td><td><?= $matt3 ?></td><td><?= $matt4 ?></td><td><?= $matt4v ?></td><td><?= $mattO ?></td><td><?= $base1 ?></td><td><?= $base2 ?></td><td><?= $base3 ?></td><td><?= $base4 ?></td><td><?= $base4v ?></td><td><?= $baseS ?></td><td><?= $baseO ?></td><td><?= $hw ?></td><td><?= $hca ?></td><td><?= $cw ?></td><td><?= $cfv ?></td><td><?= $headboardprice ?></td><td><?= $legprice ?></td><td><?= $accprice ?></td><td><?= $deliveryprice ?></td></tr>
<?php endforeach; ?>
</table>
</div>
<?php } ?>
</div>
<script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{
 if (theForm.showroom.value == "--")
  {
    alert("Please enter a showroom");
    theForm.showroom.focus();
    return (false);
  } 
 if (theForm.monthfrom.value == "")
  {
    alert("Please enter date from");
    theForm.monthfrom.focus();
    return (false);
  }
   if (theForm.monthto.value == "")
  {
    alert("Please enter date to");
    theForm.monthto.focus();
    return (false);
  }

    

    return true;
} 
//-->
</script>
<script>
function changeFormAction(formId, newAction) {
	//console.log("New action = " + newAction);
	$('#' + formId).attr('action', newAction);
}
	
</script>
