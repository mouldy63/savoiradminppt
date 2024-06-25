<?php use Cake\Routing\Router; ?>

<?php 
	$monthNum=date("m");
?>

<div id="brochureform" class="brochure">
<h1><br>Customer Ready Not Invoiced Reports</h1>


<form action="/php/CustomerReadyNotInvoiced" method="post" name="form1" id="form1">
<br>
<p>Month <label>
<select name="month" id="month" >
<option value="n">Select Month</option>
<?php
		$monthname = date("F", mktime(0, 0, 0, $monthNum, 10));
		$slct = ($month == $monthname) ? "selected" : ""; 
	?>
	<option <?= $slct ?> value="<?= $monthname ?>" ><?= $monthname ?></option>
	<?php
		for($i=1; $i<=11; ++$i){ 
		$monthname=date('F', mktime(0, 0, 0, $monthNum-$i, 1));
		$slct = ($month == $monthname) ? "selected" : "";
	?>
	<option <?= $slct ?> value="<?= $monthname ?>"><?= $monthname ?></option>
<?php
}?>
</select>
</label>
Year
<label><select name="year" id="year">
<option value="n">Select Year</option>
      <?php
for($i=0; $i<=11; ++$i){ 
$slct = ((int)$year == date("Y")-$i) ? "selected" : "";
?>
      <option <?= $slct ?> value="<?= date("Y")-$i ?>"><?= date("Y")-$i ?></option>
<?php
}?>
</select></label>
</h2>
&nbsp;&nbsp;<input name="submit2" onclick="changeFormAction('form1', '/php/CustomerReadyNotInvoiced');" type="submit" value="Produce Report"  id="search" class="button" />
 &nbsp;&nbsp;&nbsp; 
<input name="reset"  onclick="window.location='/php/CustomerReadyNotInvoiced'; return false;" type="reset" class="button" id="button" value="Reset" />

  </p>  </form>
<?php if (isset($customerNotInvoiced)) {  ?>     
<table id="postable" width="100%" border="1" cellspacing="0" cellpadding="1" class="tablebd display compact">
<thead>
  <tr class="tablebd">
    <th align="left" valign="top"><strong>Customer Name</strong></th>
    <th align="left" valign="top"><strong>Company Name</strong></th>
    <th align="left" valign="top"><strong>Order No.</strong></th>
    <th align="left" valign="top"><strong>Showroom</strong></th>
    <th align="left" valign="top"><strong>Production Completion Date</strong></th>
    <th align="left" valign="top"><strong>Delivery Date</strong></th>
    <th align="left" valign="top"><strong>Item</strong></th>
    <th align="left" valign="top"><strong>Model</strong></th>
    <th align="left" valign="top"><strong>Type</strong></th>
    <th align="left" valign="top"><strong>Width</strong></th>
    <th align="left" valign="top"><strong>Length</strong></th>
    <th align="left" valign="top"><strong>Made At</strong></th>
    <th align="left" valign="top"><strong>Exworks Date</strong></th>
  </tr>
</thead>
  <?php foreach ($customerNotInvoiced as $row): 
    if ($row['mattressrequired']=='y') { ?>
      <tr class="tablebd">
      <td><a href="/editcust.asp?val=<?= $row['CONTACT_NO'] ?>"><?= $row['surname'] ?> <?= $row['first'] ?> <?= $row['title'] ?></a>&nbsp;</td>
      <td><?= $row['company'] ?>&nbsp;</td>
      <td><a href="/orderdetails.asp?pn=<?= $row['PURCHASE_No'] ?>"><?= $row['ORDER_NUMBER'] ?></a>&nbsp;</td>
      <td><?= $row['adminheading'] ?>&nbsp;</td>
      <td><?php if ($row['production_completion_date'] !== null) echo date("d/m/Y", strtotime(substr($row['production_completion_date'],0,10))); ?>&nbsp;</td>
      <td><?php if ($row['deldate'] !== null) echo date("d/m/Y", strtotime(substr($row['deldate'],0,10))); ?>
      &nbsp;</td>
      <td>
      Mattress</td>
      <td><?= $row['savoirmodel'] ?>&nbsp;</td>
      <td><?= $row['mattresstype'] ?>&nbsp;</td>
      <td><?= $row['mattresswidth'] ?>&nbsp;</td>
      <td><?= $row['mattresslength'] ?>&nbsp;</td>    
      <td><?= getMadeAt($this, $row['PURCHASE_No'], 1)?>&nbsp;</td>
      <td><?= getExworksDate($this, $row['PURCHASE_No'], 1)?>&nbsp;</td>
      </tr>
    <?php } ?>

    <?php if ($row['baserequired']=='y') { ?>
    <tr class="tablebd">
    <td><a href="/editcust.asp?val=<?= $row['CONTACT_NO'] ?>"><?= $row['surname'] ?> <?= $row['first'] ?> <?= $row['title'] ?></a>&nbsp;</td>
    <td><?= $row['company'] ?>&nbsp;</td>
    <td><a href="/orderdetails.asp?pn=<?= $row['PURCHASE_No'] ?>"><?= $row['ORDER_NUMBER'] ?></a>&nbsp;</td>
    <td><?= $row['adminheading'] ?>&nbsp;</td>
    <td><?php if ($row['production_completion_date'] !== null) echo date("d/m/Y", strtotime(substr($row['production_completion_date'],0,10))); ?>&nbsp;</td>
    <td><?php if ($row['deldate'] !== null) echo date("d/m/Y", strtotime(substr($row['deldate'],0,10))); ?>
    &nbsp;</td>
    <td>
    Base</td>
    <td><?= $row['basesavoirmodel'] ?>&nbsp;</td>
    <td><?= $row['basetype'] ?>&nbsp;</td>
    <td><?= $row['basewidth'] ?>&nbsp;</td>
    <td><?= $row['baselength'] ?>&nbsp;</td>    
    <td><?= getMadeAt($this, $row['PURCHASE_No'], 3)?>&nbsp;</td>
    <td><?= getExworksDate($this, $row['PURCHASE_No'], 3)?>&nbsp;</td>
  </tr>
 <?php } ?>

 <?php if ($row['topperrequired']=='y') { ?>
    <tr class="tablebd">
    <td><a href="/editcust.asp?val=<?= $row['CONTACT_NO'] ?>"><?= $row['surname'] ?> <?= $row['first'] ?> <?= $row['title'] ?></a>&nbsp;</td>
    <td><?= $row['company'] ?>&nbsp;</td>
    <td><a href="/orderdetails.asp?pn=<?= $row['PURCHASE_No'] ?>"><?= $row['ORDER_NUMBER'] ?></a>&nbsp;</td>
    <td><?= $row['adminheading'] ?>&nbsp;</td>
    <td><?php if ($row['production_completion_date'] !== null) echo date("d/m/Y", strtotime(substr($row['production_completion_date'],0,10))); ?>&nbsp;</td>
    <td><?php if ($row['deldate'] !== null) echo date("d/m/Y", strtotime(substr($row['deldate'],0,10))); ?>
    &nbsp;</td>
    <td>
    Topper</td>
    <td><?= $row['toppertype'] ?>&nbsp;</td>
    <td>&nbsp;</td>
    <td><?= $row['topperwidth'] ?>&nbsp;</td>
    <td><?= $row['topperlength'] ?>&nbsp;</td>    
    <td><?= getMadeAt($this, $row['PURCHASE_No'], 5)?>&nbsp;</td>
    <td><?= getExworksDate($this, $row['PURCHASE_No'], 5)?>&nbsp;</td>
  </tr>
 <?php } ?>

 <?php if ($row['legsrequired']=='y') { ?>
    <tr class="tablebd">
    <td><a href="/editcust.asp?val=<?= $row['CONTACT_NO'] ?>"><?= $row['surname'] ?> <?= $row['first'] ?> <?= $row['title'] ?></a>&nbsp;</td>
    <td><?= $row['company'] ?>&nbsp;</td>
    <td><a href="/orderdetails.asp?pn=<?= $row['PURCHASE_No'] ?>"><?= $row['ORDER_NUMBER'] ?></a>&nbsp;</td>
    <td><?= $row['adminheading'] ?>&nbsp;</td>
    <td><?php if ($row['production_completion_date'] !== null) echo date("d/m/Y", strtotime(substr($row['production_completion_date'],0,10))); ?>&nbsp;</td>
    <td><?php if ($row['deldate'] !== null) echo date("d/m/Y", strtotime(substr($row['deldate'],0,10))); ?>
    &nbsp;</td>
    <td>
    Legs</td>
    <td><?= $row['legstyle'] ?>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>    
    <td><?= getMadeAt($this, $row['PURCHASE_No'], 7)?>&nbsp;</td>
    <td><?= getExworksDate($this, $row['PURCHASE_No'], 7)?>&nbsp;</td>
  </tr>
 <?php } ?>

 <?php if ($row['headboardrequired']=='y') { ?>
    <tr class="tablebd">
    <td><a href="/editcust.asp?val=<?= $row['CONTACT_NO'] ?>"><?= $row['surname'] ?> <?= $row['first'] ?> <?= $row['title'] ?></a>&nbsp;</td>
    <td><?= $row['company'] ?>&nbsp;</td>
    <td><a href="/orderdetails.asp?pn=<?= $row['PURCHASE_No'] ?>"><?= $row['ORDER_NUMBER'] ?></a>&nbsp;</td>
    <td><?= $row['adminheading'] ?>&nbsp;</td>
    <td><?php if ($row['production_completion_date'] !== null) echo date("d/m/Y", strtotime(substr($row['production_completion_date'],0,10))); ?>&nbsp;</td>
    <td><?php if ($row['deldate'] !== null) echo date("d/m/Y", strtotime(substr($row['deldate'],0,10))); ?>
    &nbsp;</td>
    <td>
    Headboard</td>
    <td><?= $row['headboardstyle'] ?>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>    
    <td><?= getMadeAt($this, $row['PURCHASE_No'], 8)?>&nbsp;</td>
    <td><?= getExworksDate($this, $row['PURCHASE_No'], 8)?>&nbsp;</td>
  </tr>
 <?php } ?>

 <?php if ($row['valancerequired']=='y') { ?>
    <tr class="tablebd">
    <td><a href="/editcust.asp?val=<?= $row['CONTACT_NO'] ?>"><?= $row['surname'] ?> <?= $row['first'] ?> <?= $row['title'] ?></a>&nbsp;</td>
    <td><?= $row['company'] ?>&nbsp;</td>
    <td><a href="/orderdetails.asp?pn=<?= $row['PURCHASE_No'] ?>"><?= $row['ORDER_NUMBER'] ?></a>&nbsp;</td>
    <td><?= $row['adminheading'] ?>&nbsp;</td>
    <td><?php if ($row['production_completion_date'] !== null) echo date("d/m/Y", strtotime(substr($row['production_completion_date'],0,10))); ?>&nbsp;</td>
    <td><?php if ($row['deldate'] !== null) echo date("d/m/Y", strtotime(substr($row['deldate'],0,10))); ?>
    &nbsp;</td>
    <td>
    Valance</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>    
    <td><?= getMadeAt($this, $row['PURCHASE_No'], 6)?>&nbsp;</td>
    <td><?= getExworksDate($this, $row['PURCHASE_No'], 6)?>&nbsp;</td>
  </tr>
 <?php } ?>

 <?php if ($row['accessoriesrequired']=='y') { 
  $sql="SELECT * from orderaccessory WHERE purchase_no=". $row['PURCHASE_No'];
  $rs = $this->AuxiliaryData->getDataArray($sql,[]);  
    foreach ($rs as $rows) { ?>
      <tr class="tablebd">
      <td><a href="/editcust.asp?val=<?= $row['CONTACT_NO'] ?>"><?= $row['surname'] ?> <?= $row['first'] ?> <?= $row['title'] ?></a>&nbsp;</td>
      <td><?= $row['company'] ?>&nbsp;</td>
      <td><a href="/orderdetails.asp?pn=<?= $row['PURCHASE_No'] ?>"><?= $row['ORDER_NUMBER'] ?></a>&nbsp;</td>
      <td><?= $row['adminheading'] ?>&nbsp;</td>
      <td><?php if ($row['production_completion_date'] !== null) echo date("d/m/Y", strtotime(substr($row['production_completion_date'],0,10))); ?>&nbsp;</td>
      <td><?php if ($row['deldate'] !== null) echo date("d/m/Y", strtotime(substr($row['deldate'],0,10))); ?>
      &nbsp;</td>
      <td>
      Accessories</td>
      <td><?=$rows['description']?>&nbsp;</td>
      <td><?=$rows['size']?>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>    
      <td>&nbsp;</td>
      <td><?= getExworksDate($this, $row['PURCHASE_No'], 9)?>&nbsp;</td>
      </tr>
 <?php    }
  } 
 ?>


<?php endforeach; ?>
	      </table>

<?php } ?> 
</div>
<script>
$(document).ready(function () {
    $('#postable').DataTable({
      "columnDefs" : [{"targets":[12], "type":"date-eu"}],
	  "order": [2, 'asc'],
    "paging": false,
    "responsive": false,
    "autowidth": true,
	dom: 'Blfrtip',
          buttons: [{ extend: 'excelHtml5', text: 'Download CSV' }]
    });
});

function changeFormAction(formId, newAction) {
	//console.log("New action = " + newAction);
	$('#' + formId).attr('action', newAction);
}
</script>

<?php 
function getMadeAt($that, $pn, $compid) {
$sql="SELECT ManufacturedAt from qc_history_latest Q left join manufacturedat M on Q.MadeAt=M.ManufacturedAtID WHERE ComponentID=".$compid." and Purchase_No=". $pn;
    $madeat='';
		$rs = $that->AuxiliaryData->getDataArray($sql,[]);  
			foreach ($rs as $rows) {
				$madeat=$rows['ManufacturedAt'];
      }
      return $madeat;
} 
function getExworksDate($that, $pn, $compid) {
    $exworksdate='';
		$sql="Select CollectionDate from exportlinks L, exportCollShowrooms S, exportcollections E where L.purchase_no=".$pn." and L.linksCollectionID=S.exportCollshowroomsID and E.exportCollectionsID=S.exportCollectionID AND L.componentID=".$compid;
		$rs = $that->AuxiliaryData->getDataArray($sql,[]); 
		foreach ($rs as $rows) {
			$exworksdate=date("d/m/Y", strtotime(substr($rows['CollectionDate'],0,10)));
		}
		return $exworksdate;
  }?>