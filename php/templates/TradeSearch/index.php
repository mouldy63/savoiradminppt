<?php use Cake\Routing\Router; ?>

<script>
$(function() {
	var year = new Date().getFullYear();
	
	$( "#datefrom" ).datepicker({
		changeMonth: true,
		yearRange: "-21:+0",
		changeYear: true
	});
	$( "#datefrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
	
	$( "#dateto" ).datepicker({
		changeMonth: true,
		yearRange: "-21:+0",
		changeYear: true
	});
	$( "#dateto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});

</script>

<div id="brochureform" class="brochure">
<form action="/php/tradesearch/" method="post" name="form1" id="form1">
<input type="hidden" name="sortorder" id="sortorder" value="<?= $sortorder ?>" />
<p>Trade Report - Search Orders</p>

<p>Order date from&nbsp;

<input name="datefrom" type="text" id="datefrom" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($datefrom) ?>">
		      &nbsp;&nbsp;&nbsp;&nbsp;Order date to&nbsp;
<input name="dateto" type="text" id="dateto" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($dateto) ?>">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;              </p>
<p><select name="showroom" id="showroom">
<option value="n"> Choose Showroom:  </option>
<?php foreach ($activeshowrooms as $row): ?> 
<?php $slct = ($row['idlocation'] == $showroom) ? "selected" : "";   ?>              
<option <?= $slct ?> value="<?= $row['idlocation'] ?>"><?= $row['adminheading'] ?></option>
<?php endforeach; ?>
</select></p>
<p>
<input type="submit" name="search" value="Search Database"  id="search" class="button" onclick="changeFormAction('form1', '/php/tradesearch/');"  />
<label>
<input name="csv" type="submit" class="button" id="csv" value="Produce CSV file"  onclick="changeFormAction('form1', '/php/tradesearch/export');">
</label>
</p>
</form>
<?php 
if (isset($tradeSearch)) {  ?>
<table border = "0" cellpadding = "6" cellspacing = "2" style="background-color:white;margin-top:40px;" >
<tbody class="brochuretable">
		    <tr>
		      <td width="251" align="left"><b>Order Date</b><br>
		      <a href="#" onclick="sortby('ORDER_DATE desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('ORDER_DATE asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
		     </td>
		      <td width="151"><b>Customer Name</b><br>
		      <a href="#" onclick="sortby('surname desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('surname asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
		      <td width="151"><b>Company</b><br>
		      <a href="#" onclick="sortby('company desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('company asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
		      <td width="151"><b>Order No.</b><br>
		      <a href="#" onclick="sortby('ORDER_NUMBER desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('ORDER_NUMBER asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
		      <td width="151"><b>Order Source</b></td>
		      <td width="151"><b>Order Value</b></td>
		      <td width="151" align="right"><b>Total Payments to Date</b></td>
		      <td width="151" align="right"><b>Total Outstanding</b></td>
		      <td width="151"><b>
		     </b></td>
	        </tr>
	       <?php foreach ($tradeSearch as $row): ?>
	        <tr>
		      <td width="251" align="left"><?= $row['ORDER_DATE'] ?></td>
		      <td width="151" align="left"><?= $row['surname'] ?></td>
		      <td width="151" align="left"><?= $row['company'] ?></td>
		      <td width="151" align="left"><?= $row['ORDER_NUMBER'] ?></td>
		      <td width="151" align="left"><?= $row['adminheading'] ?></td>
		       <td width="151" align="left"><?= $this->MyForm->formatMoneyWithSymbol($row['total'], $row['ordercurrency']) ?></td>
		      <td width="151" align="right"><?= $this->MyForm->formatMoneyWithSymbol($row['paymentstotal'], $row['ordercurrency']) ?></td>
		      <td width="151" align="right"><?= $this->MyForm->formatMoneyWithSymbol($row['balanceoutstanding'], $row['ordercurrency']) ?></td>
		      <td width="151" align="left">
		     </td>
	        </tr>
	        <?php endforeach; ?>
	       
</tbody>
</table>            
<?php } ?>      

</div>
<script>
function customReset() {
    $("#datefrom").val("");
    $("#dateto").val("");
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
	//console.log("New action = " + newAction);
	$('#' + formId).attr('action', newAction);
}
function sortby(sortVal) {
	console.log(sortVal);
	$("#sortorder").val(sortVal);
	console.log($("#sortorder").val());
	$("#form1").submit();
} 
</script>