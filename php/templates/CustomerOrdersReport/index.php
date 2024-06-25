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

function resetMonthYear() {
	if ($('#monthfrom').val() != '' && $('#monthto').val() != '') {
		$('#month').val('n');
		$('#year').val('n');
	}
	return true;
}

</script>
<?php 
	$monthNum=date("m");
?>

<div id="brochureform" class="brochure">
<h1>Customer Order reports</h1>


<form action="/php/CustomerOrdersReport/export" method="post" name="form1" id="form1" onSubmit="return resetMonthYear();">

<p>Find customers (leave empty for all)</p>
<p>from&nbsp;

<input name="monthfrom" type="text" id="monthfrom" size="10"  value="<?= $monthfrom ?>">
		      &nbsp;&nbsp;&nbsp;&nbsp;to&nbsp;
<input name="monthto" type="text" id="monthto" size="10"  value="<?= $monthto ?>">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;              </p>
<p><strong>OR</strong> by Month <label>
<select name="month" id="month" >
<option value="n">Select Month</option>
<option value="<?= date("F", mktime(0, 0, 0, date("m"), 10)) ?>"><?= date("F", mktime(0, 0, 0, $monthNum, 10)) ?></option>
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
<option value="<?= date("Y") ?>"><?= date("Y") ?></option>
      <?php
for($i=1; $i<=11; ++$i){ 
$slct = ((int)$year == date("Y")-$i) ? "selected" : "";
?>
      <option <?= $slct ?> value="<?= date("Y")-$i ?>"><?= date("Y")-$i ?></option>
<?php
}?>
</select></label>
</h2>
</p>
<p>

Select Status: 
<select name="status" id="status">
<?php foreach ($statuslist as $row): ?>              
<option value="<?= $row['Status'] ?>"><?= $row['Status'] ?></option>
<?php endforeach; ?>
</select>
       
</p>
<input name="reset" type="reset" class="button" id="reset" value="Reset">&nbsp;&nbsp;&nbsp; <input name="submit" type="submit" class="button" id="submit" value="Produce CSV file">
    </form>

</div>
