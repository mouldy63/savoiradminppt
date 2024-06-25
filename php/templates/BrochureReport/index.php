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
<form action="/php/brochurereport/" method="post" name="form1" id="form1">
<p align="center">Find no. of brochure requests from prospect status between dates</p>
<p align="center">From: <input type="text" name="monthfrom" id="monthfrom" value="<?php echo $monthfrom ?>"/>&nbsp;&nbsp;&nbsp; To: <input type="text" name="monthto" id="monthto" value="<?php echo $monthto ?>"/><p>
	<p align="center">Or by month: <select name="strmonth" id="strmonth">
      <option value="n">Select Month</option>
      <option value="<?php echo date("F", mktime(0, 0, 0, date("m"), 10)) ?>"><?php echo date("F", mktime(0, 0, 0, $monthNum, 10)) ?></option>
      <?php
for($i=1; $i<=11; ++$i){ 
$monthname=date('F', mktime(0, 0, 0, $monthNum-$i, 1));
$slct = ($strmonth == $monthname) ? "selected" : "";
?>
      <option <?php echo $slct ?> value="<?php echo $monthname ?>"><?php echo $monthname ?></option>
<?php
}?>
				</select>&nbsp;&nbsp;&nbsp;Year <select name="year" id="year">
      <option value="<?php echo date("Y") ?>"><?php echo date("Y") ?></option>
      <?php
for($i=1; $i<=11; ++$i){ 
$slct = ((int)$year == date("Y")-$i) ? "selected" : "";
?>
      <option <?php echo $slct ?> value="<?php echo date("Y")-$i ?>"><?php echo date("Y")-$i ?></option>
<?php
}?>
				</select>
				</p>
<p align="center">
<input type="submit" name="submit" value="Search Database"  id="submit" class="button" />
              <label>
                <input name="csv" type="submit" class="button" id="csv" value="Produce CSV file" onClick="return produceCsv();">
              </label>
              <label>
<input name="Reset" type="reset" class="button" id="button" value="Reset Form" onClick="return customReset();" >
</label>
            </p>
<table width="416" border="1" cellspacing="0" cellpadding="2" class="brochurecenter" style="margin-top:40px;" >
<tbody class="brochuretable">
		    <tr>
		      <td width="251" align="left">Showroom</td>
		      <td width="151">Total Requested Brochures</td>
		      <td width="151">Brochures Sent</td>
		      <td width="151">Brochures Remaining</td>
	        </tr>
	       <?php foreach ($currentShowrooms as $row): ?>
	        <tr>
		      <td width="251" align="left"><?php echo $row['adminheading'] ?></td>
		      <td width="151" align="center"><?php echo $row['request_count'] ?></td>
		      <td width="151" align="center"><?php echo $row['brochures_sent_count'] ?></td>
		      <td width="151" align="center"><?php echo $row['brochures_remaining_count'] ?></td>
	        </tr>
	        <?php endforeach; ?>
	        <tr>
		      <td width="251" align="left">TOTALS</td>
		      <td width="151" align="center"><?php echo $totalbrochurereq ?></td>
		      <td width="151" align="center"><?php echo $totalbrochuresent ?></td>
		      <td width="151" align="center"><?php echo $totalbrochurerem ?></td>
	        </tr>
</tbody>
</table>            
      <p>&nbsp;</p>      
<table width="416" border="1" cellspacing="0" cellpadding="2" class="brochurecenter" >
	<tr>
	  <td width="251" class="redtext" align="left">Marketing Source</td>
	  <td width="151" class="redtext">No. of Brochures per Source</td>
	</tr>
	<?php foreach ($sourceCounts as $row): ?>
		<tr>
			<td><?php echo $row['source'] ? $row['source'] : 'Not supplied' ?></td>
			<td><?php echo $row['cnt'] ?></td>
		</tr>
	<?php endforeach; ?>
	
</table>
</div>
<script>
function customReset() {
    $("#monthfrom").val("");
    $("#monthto").val("");
    $("#strmonth option[value='n']").prop('selected', true);
    $("#year option[value='2018']").prop('selected', true);
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

function produceCsv() {
	$('#form1').attr('action', '/php/brochurereport/export');
	$('#form1').submit();
}
</script>