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
<?php 
	$monthNum=date("m");
?>

<div id="brochureform" class="brochure">
<h1>Brochure Follow Ups</h1>


<form action="/php/BrochureFollowUp/" method="post" name="form1" id="form1">
<input type="hidden" name="sortorder" id="sortorder" value="<?= $sortorder ?>" />
<p>Generate Brochure Follow Report:</p>
<p>from&nbsp;

<input name="monthfrom" type="text" id="monthfrom" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($monthfrom) ?>">
		      &nbsp;&nbsp;&nbsp;&nbsp;to&nbsp;
<input name="monthto" type="text" id="monthto" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($monthto) ?>">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;              </p>
<p><strong>OR</strong> by Month <label>
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
	<?php } ?>
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
</p>
<p>
<?php if (isset($brochurefollowups)) {  ?>  

<select id="user" name="user">
<option value="n"> Select User:  </option>
	<?php foreach ($users as $usr):  ?> 
	<?php $slct = ($usr['username'] == $user) ? "selected" : "";   ?> 
		<option <?= $slct ?> value="<?= $usr['username']; ?>"><?= $usr['name']; ?></option>
	<?php endforeach; ?>
</select>
<?php } ?>
<select name="showroom" id="showroom">
<option value="n"> Choose Showroom:  </option>
<?php foreach ($activeshowrooms as $row): ?> 
<?php $slct = ($row['idlocation'] == $showroom) ? "selected" : "";   ?>              
<option <?= $slct ?> value="<?= $row['idlocation'] ?>"><?= $row['adminheading'] ?></option>
<?php endforeach; ?>
</select>

<?php if (isset($brochurefollowups)) {  ?>
<select name="commstatus" size="1" class="formtext" id="commstatus">
 
<option value="n">Select Status:</option>
<option <?php $slct = ('To Do' == $commstatus) ? "selected" : "";   ?><?= $slct ?> value="To Do">To Do</option>
<option <?php $slct = ('Completed' == $commstatus) ? "selected" : "";   ?><?= $slct ?> value="Completed">Completed</option>
<option <?php $slct = ('Cancelled' == $commstatus) ? "selected" : "";   ?><?= $slct ?> value="Cancelled">Cancelled</option>
          
</select>
 <?php } ?>         
<br><br>
<input type="submit" onclick="changeFormAction('form1', '/php/BrochureFollowUp');" name="search" value="Search Database"  id="search" class="button" />
<input name="excellist" onclick="changeFormAction('form1', '/php/BrochureFollowUp/export');" type="submit" class="button" id="excellist" value="Produce CSV file" />
<input name="Reset" onclick="window.location('/php/BrochureFollowUp/); return false;" type="submit" class="button" id="button" value="Reset Form" /> 

</p>
    </form>
<?php if (isset($brochurefollowups)) {  ?>  


<table cellspacing="2" cellpadding="2" class="tablebd">
<tr class="tablebd">
<td valign="bottom"><b>Date of Brochure&nbsp;Request</b><br>
<a href="#" onclick="sortby('date desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
<a href="#" onclick="sortby('date asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
<td valign="bottom"><b>Contact Name<br>(Customer Address)</b><br>
<a href="#" onclick="sortby('surname desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
<a href="#" onclick="sortby('surname asc');"><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle"border></a>
</td>
<td valign="bottom"><b>Follow&nbsp;Up&nbsp;Date</b><br>
<a href="#" onclick="sortby('Next desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0">
<a href="#" onclick="sortby('Next asc');"><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle"border></a></td>
<td valign="bottom"><b>Response Notes</b><br><img src="/images/trans30x26.gif" width="30" height="26" align="middle" border="0"></td>
<td valign="bottom"><b>Status</b><br><img src="/images/trans30x26.gif" width="30" height="26" align="middle" border="0"></td>
<td valign="bottom"><b>Showroom&nbsp;&nbsp;&nbsp;</b><br>
<a href="#" onclick="sortby('location desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
<a href="#" onclick="sortby('location asc');"><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle"border></a></td>
              <td valign="bottom"><b>Order Date/Number & Value</b><br><img src="/images/trans30x26.gif" width="30" height="26" align="middle" border="0"></td>
</tr>
<?php foreach ($brochurefollowups as $row): ?>
<tr>
	<td valign="top"><a href="/editcust.asp?tab=4&val=<?= $row['CONTACT_NO'] ?>"><?= date("d/m/Y", strtotime(substr($row['Date'],0,10))) ?></a></td>
	<td valign="top"><a href="/editcust.asp?tab=4&val=<?= $row['CONTACT_NO'] ?>"><?= $row['person'] ?>
		<br/><?= buildAddress($customerAddresses[$row['Communication']]); ?></a>
	</td>
	<td valign="top"><a href="/editcust.asp?tab=4&val=<?= $row['CONTACT_NO'] ?>"><?php if($row['commstatus']=="To Do") {
	echo date("d/m/Y", strtotime(substr($row['Next'],0,10)));
	}
	?></a></td>
	<td valign="top"><a href="/editcust.asp?tab=4&val=<?= $row['CONTACT_NO'] ?>"><?= $row['Response'] ?></td></a>
	<td valign="top"><a href="/editcust.asp?tab=4&val=<?= $row['CONTACT_NO'] ?>"><?= $row['commstatus'] ?></td></a>
	<td valign="top"><a href="/editcust.asp?tab=4&val=<?= $row['CONTACT_NO'] ?>"><?= $row['location'] ?></td></a>
	<td valign="top"><a href="/editcust.asp?tab=4&val=<?= $row['CONTACT_NO'] ?>">
		<?php foreach ($customerOrdersAndValues[$row['Communication']] as $custOrdValRow): ?>
			<a href="/editcust.asp?tab=4&val=<?= $row['CONTACT_NO'] ?>"><?= date("d/m/Y", strtotime($custOrdValRow['order_date'])) ?><?= "</a>&nbsp;<a href='/edit-purchase.asp?order=" . $custOrdValRow["purchase_no"] . "'>" . $custOrdValRow["order_number"] . "</a>&nbsp;" . $custOrdValRow["total"] . "<br/>"; ?>
		</a><?php endforeach; ?>
	</td>
</tr>
<?php endforeach; ?>


	      </table>

<?php } ?>
</div>

<?php
	function buildAddress($addrRecord) {
		$address = "";
		if (!empty($addrRecord["company"])) $address .= $addrRecord["company"] . "<br/>";
		if (!empty($addrRecord["street1"])) $address .= $addrRecord["street1"] . "<br/>";
		if (!empty($addrRecord["street2"])) $address .= $addrRecord["street2"] . "<br/>";
		if (!empty($addrRecord["street3"])) $address .= $addrRecord["street3"] . "<br/>";
		if (!empty($addrRecord["town"])) $address .= $addrRecord["town"] . "<br/>";
		if (!empty($addrRecord["county"])) $address .= $addrRecord["county"] . "<br/>";
		if (!empty($addrRecord["postcode"])) $address .= $addrRecord["postcode"] . "<br/>";
		if (!empty($addrRecord["country"])) $address .= $addrRecord["country"] . "<br/>";
		return $address;
	}
?>
<script>
function changeFormAction(formId, newAction) {
	//console.log("New action = " + newAction);
	$('#' + formId).attr('action', newAction);
}
	
function sortby(sortVal) {
	$("#sortorder").val(sortVal);
	$("#form1").submit();
} 
</script>
