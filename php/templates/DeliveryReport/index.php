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
<form action="/php/deliveryreport/" method="post" name="form1" id="form1">
<input type="hidden" name="sortorder" id="sortorder" value="<?= $sortorder ?>" />
<p>Delivery Report</p>
<p>Customer Report Type: <select name="reporttype" id="reporttype">

  <option <?php if ($reporttype =='delivery') { echo 'selected'; } ?> value="delivery">Delivery Dates</option>
  <option <?php if ($reporttype =='production') { echo 'selected'; } ?> value="production">Production Completion Dates</option>
</select></p>
<p>from&nbsp;

<input name="monthfrom" type="text" id="monthfrom" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($monthfrom) ?>">
		      &nbsp;&nbsp;&nbsp;&nbsp;to&nbsp;
<input name="monthto" type="text" id="monthto" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($monthto) ?>">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;              </p>
<p><select name="showroom" id="showroom">
<option value="n"> Choose Showroom:  </option>
<?php foreach ($activeshowrooms as $row): ?> 
<?php $slct = ($row['idlocation'] == $showroom) ? "selected" : "";   ?>              
<option <?= $slct ?> value="<?= $row['idlocation'] ?>"><?= $row['adminheading'] ?></option>
<?php endforeach; ?>
</select></p>
<p>Tick to only show deliveries with Received Gift Packs <input name = "giftpack" type = "checkbox" id = "giftpack" <?php if ($giftpack !='') { echo 'checked'; } ?>  value = "y" /></p>
<p>Include only records where a Post Delivery Call has been logged <input name = "delcall" type = "checkbox" id = "delcall"  <?php if ($delcall !='') { echo 'checked'; } ?>   value = "y" /></p>
<p>
<input type="submit" name="search" value="Search Database"  id="search" class="button" onclick="changeFormAction('form1', '/php/deliveryreport/');"  />
<label>
<input name="csv" type="submit" class="button" id="csv" value="Produce CSV file"  onclick="changeFormAction('form1', '/php/deliveryreport/export');">
</label>
</p>
</form>

<?php if (isset($deliveryReport)) {  ?>
<table width="100%" border = "0" cellpadding = "6" cellspacing = "2" style="background-color:white;margin-top:40px;" >
<tbody>
		    <tr>
		      <td width="251" align="left"><b>Customer Name</b><br>
		      <a href="#" onclick="sortby('surname desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('surname asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
		      <td width="151"><b>Company</b><br>
		      <a href="#" onclick="sortby('company desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('company asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
		      <td width="151"><b>Ref.</b></td>
		      <td width="151"><b>Order No.</b><br>
		      <a href="#" onclick="sortby('ORDER_NUMBER desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('ORDER_NUMBER asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
<td><b>Order Notes</b><br>
		     
</td>
		      <td width="151"><b>Order Source</b><br>
		      <a href="#" onclick="sortby('adminheading desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('adminheading asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
		      <td width="151"><b>Delivery Postcode</b></td>
		       <td width="151" align="right"><b>Order Value</b></td>
		      <td width="151" align="right"><b>Payments</b></td>
		      <td width="151" align="right"><b>Balance Outstanding</b></td>
		      <td width="151"><b>
		      <?php if($reporttype=='delivery') {?><b>Delivery Date</b><br>
		      <a href="#" onclick="sortby('bookeddeliverydate desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('bookeddeliverydate asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>

		      <?php } else { ?>Production Date</b><br>
		      <a href="#" onclick="sortby('production_completion_date desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('production_completion_date asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
<?php } ?></td>
	        </tr>
	       <?php foreach ($deliveryReport as $row): ?>
	        <tr>
		      <td  align="left"><a href="/edit-purchase.asp?order=<?=$row['PURCHASE_No'] ?>"><?= $row['surname'].', '.$row['title'].' '.$row['first'] ?></a></td>
		      <td  align="left" valign="top"><?= $row['company'] ?></td>
		      <td  align="left" valign="top"><?= $row['customerreference'] ?></td>
		      <td  align="left" valign="top"><?= $row['ORDER_NUMBER'] ?></td>
		      <td align="left" valign="top" width="350"><?= $notes[$row['PURCHASE_No']] ?></td>
		      <td  align="left" valign="top"><?= $row['adminheading'] ?></td>
		      <td  align="left" valign="top">
		      	<?php if (!empty($row['deliverypostcode'])) {
		      		echo $row['deliverypostcode'];
				} else {
		      		echo $row['postcode'];
				} ?>	      		
		      </td>
		      <td  align="right" valign="top"><?= $row['paymentstotal'] ?></td>
		      <td  align="right" valign="top"><?= $row['total'] ?></td>
		      <td  align="right" valign="top"><?= $row['balanceoutstanding'] ?></td>
		      <td  align="left" valign="top">
		       <?php if($reporttype=='delivery') { 
		        if ($row['bookeddeliverydate'] !== null) echo date("d/m/Y", strtotime(substr($row['bookeddeliverydate'],0,10))); 
		        } else {
		        if ($row['production_completion_date'] !== null) echo date("d/m/Y", strtotime(substr($row['production_completion_date'],0,10))); 
		        }?>
		     </td>
	        </tr>
	        <?php endforeach; ?>
	       
</tbody>
</table>            
<?php } ?>      

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