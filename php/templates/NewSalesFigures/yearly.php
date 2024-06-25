<?php
$now = date('d-m-Y');
$currentyear = date("Y",strtotime($now));
?>
<div>
<form name="form1" method="post" action="yearly" style='margin-top:15px; padding-top:15px; padding-bottom:15px;'>
	<div>Year&nbsp;
		<select name='year'>
			<?php for ($i = $currentyear; $i > $currentyear-5; $i--) { ?>
			<option value='<?=$i?>' <?php if ($year == $i) echo 'selected';?> ><?=$i?></option>
			<?php } ?>
		</select>
		Display&nbsp;Currency&nbsp;
		<select name='dispcurr'>
			<option value='native' <?php if ($dispcurr == 'native') echo 'selected';?> >Native</option>
			<option value='GBP' <?php if ($dispcurr == 'GBP') echo 'selected';?> >GBP</option>
			<option value='USD' <?php if ($dispcurr == 'USD') echo 'selected';?> >USD</option>
			<option value='EUR' <?php if ($dispcurr == 'EUR') echo 'selected';?> >EUR</option>
		</select><br><br>
		&nbsp;<input type="submit" name="submit" value="Submit">
		&nbsp;<button type="button" onclick="exportCsv();">Export CSV</button>
		&nbsp;<button type="button" onclick="swapToMonthly();">Monthly</button>
		<?php if ($this->Security->isSuperuser()) { ?>)
		&nbsp;<button type="button" onclick="swapToExchangeRates();">Exchange Rates</button>
		&nbsp;<button type="button" onclick="swapToSalesTargets();">Sales Targets</button>
		<?php } ?>
	</div>
</form>
</div>
<table style='border-collapse: collapse; border-spacing: 3px;  padding:2px; font-size:12px;' id="myTable" class="stripe">
<?php
	$row = $data[0];
?>
<thead>
<tr style="border: 1px solid black; border-collapse: collapse;">
	<?php
	$cellcount = 0;
	foreach ($row as $cell) {
	?>
		<th style="border: 1px solid black; border-collapse: collapse; text-align:right;; background-color:white;">
		<?php if ($cellcount == 0){?><b><?php }?>
		&nbsp;<?=$cell?>
		<?php if ($cellcount == 0){?></b><?php }?>
		</th>
	<?php 
	   $cellcount++;
	}
	?>
</tr>
</thead>
<tbody>
<?php
for ($n = 1; $n < count($data); $n++) {
	$row = $data[$n];
?>
	<tr style="border: 1px solid black; border-collapse: collapse;">
	<?php
	$cellcount = 0;
	foreach ($row as $cell) {
	?>
		<td style="border: 1px solid black; border-collapse: collapse; text-align:right; background-color:white;">
		<?php if ($cellcount == 0){?><b><?php }?>
		&nbsp;<?=$cell?>
		<?php if ($cellcount == 0){?></b><?php }?>
		</td>
	<?php 
	   $cellcount++;
	}
	?>
	</tr>
<?php
}
?>
</tbody>
</table>

<script>
$(document).ready( function () {
    $('#myTable').DataTable({
    "paging" : false,
    "autoWidth": false,
    "searchable": false,
    "ordering": false,
    scrollY:        800,
        scrollX:        300,
        scrollCollapse: true,
        paging:         false,
        fixedColumns:   true
    });
} );

	function exportCsv() {
		window.location = '/php/NewSalesFigures/exportYearlyData?month=<?=$month?>&year=<?=$year?>&dispcurr=<?=$dispcurr?>';
	}
	function swapToMonthly() {
		window.location = '/php/NewSalesFigures/Monthly?year=<?=$year?>';
	}
	function swapToExchangeRates() {
		window.location = '/php/exchangeRates?year=<?=$year?>';
	}
	function swapToSalesTargets() {
		window.location = '/php/SalesTargets?year=<?=$year?>';
	}
	
</script>
