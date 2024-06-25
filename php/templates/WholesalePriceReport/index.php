<?php use Cake\Routing\Router; ?>
<script>
$(function() {
    $('#month').datepicker( {
        changeMonth: true,
		yearRange: "-21:+0",
        changeYear: true,
        showButtonPanel: true,
        dateFormat: 'MM yy',
        onClose: function(dateText, inst) { 
            $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1));
        }
    });
});
</script>
<style>
.hide {display:none;}
.ui-datepicker-calendar {
    display: none;
    }
</style>
<?php 
	$monthNum=date("m");
?>

<div id="brochureform" class="brochure">
<br><h1>Wholesale Price Report</h1>
<p>This report display all orders within the month, based on Production Completion Dates on orders.</p>


<form action="/php/WholesalePriceReport/export" method="post" name="form1" id="form1" onSubmit="return resetMonthYear();">


<p>

<input name="month" type="text" id="month" size="10"  value="<?= $month ?>">
             

<input name="submit" type="submit" class="button" id="submit" value="Run Report - Produce CSV">
<br><br></p>
    </form>

</div>
