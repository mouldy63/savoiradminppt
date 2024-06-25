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
<h1><br>
Accessory Report</h1>


<form action="/php/AccessoryReport/export" method="post" name="form1" id="form1">

<p>from&nbsp;

<input name="datefrom" type="text" id="datefrom" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($datefrom) ?>">
		      &nbsp;&nbsp;&nbsp;&nbsp;to&nbsp;
<input name="dateto" type="text" id="dateto" size="10"  value="<?= $this->MyForm->fmtDateForDatePicker($dateto) ?>">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;              </p>

<select name="showroom" id="showroom" style="margin-left:15px;">
<option value="n"> All Showrooms  </option>
<?php foreach ($activeshowrooms as $row): ?> 
<?php $slct = ($row['idlocation'] == $showroom) ? "selected" : "";   ?>              
<option <?= $slct ?> value="<?= $row['idlocation'] ?>"><?= $row['adminheading'] ?></option>
<?php endforeach; ?>
</select>

      
<br><br><p>
<input name="submit" onclick="changeFormAction('form1', '/php/AccessoryReport/export');" type="submit" class="button" id="excellist" value="Produce CSV file" />
<input name="Reset" onclick="window.location('/php/AccessoryReport/); return false;" type="submit" class="button" id="button" value="Reset Form" /> 

</p>
    </form>


</div>

<script>
function changeFormAction(formId, newAction) {
	//console.log("New action = " + newAction);
	$('#' + formId).attr('action', newAction);
}
	

</script>