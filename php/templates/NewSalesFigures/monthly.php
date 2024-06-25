<?php
$now = date('d-m-Y');
$currentyear = date("Y",strtotime($now));
?>
<div>
<form name="form1" method="post" action="monthly">

	<div style='margin-top:15px; padding-top:15px; padding-bottom:15px;'>Month:&nbsp;
		<select name='month'>
			<option value='01' <?php if ($month == '01') echo 'selected';?> >January</option>
			<option value='02' <?php if ($month == '02') echo 'selected';?> >February</option>
			<option value='03' <?php if ($month == '03') echo 'selected';?> >March</option>
			<option value='04' <?php if ($month == '04') echo 'selected';?> >April</option>
			<option value='05' <?php if ($month == '05') echo 'selected';?> >May</option>
			<option value='06' <?php if ($month == '06') echo 'selected';?> >June</option>
			<option value='07' <?php if ($month == '07') echo 'selected';?> >July</option>
			<option value='08' <?php if ($month == '08') echo 'selected';?> >August</option>
			<option value='09' <?php if ($month == '09') echo 'selected';?> >September</option>
			<option value='10' <?php if ($month == '10') echo 'selected';?> >October</option>
			<option value='11' <?php if ($month == '11') echo 'selected';?> >November</option>
			<option value='12' <?php if ($month == '12') echo 'selected';?> >December</option>
		</select>
		Year&nbsp;
		<select name='year'>
		<?php 
		$yeartostartfrom=$currentyear-2012;
		?>
			<?php for ($i = $currentyear; $i > $currentyear-$yeartostartfrom; $i--) { ?>
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
		&nbsp;<button type="button" onclick="swapToYearly();">Yearly</button>
		<?php if ($this->Security->isSuperuser()) { ?>
		&nbsp;<button type="button" onclick="swapToExchangeRates();">Exchange Rates</button>
		&nbsp;<button type="button" onclick="swapToSalesTargets();">Sales Targets</button>
		<?php } ?>
		
	</div>
</form>
</div>
<table style='border-collapse: collapse; border-spacing: 5px;  padding:4px; font-size:12px;' id="myTable" class="stripe">
<thead>
<?php
    $rowcount = 0;
    foreach ($data as $row) {
    if ($rowcount == 0) { ?>
    	<tr style='border-spacing: 3px; border: 1px solid; padding:2px; font-size:12px;'>
	<?php
	if ($metadata[$rowcount] > 0) {
	    ?><th width="230px" align="right"><button type="button" onclick="printShowroom(<?=$metadata[$rowcount]?>, '<?=$month?>', '<?=$year?>');">Print <i class="fa fa-print"></i></button></th><?php
	} else {
	    ?><?php
	}
	$cellcount = 0;
	foreach ($row as $cell) {
	?>
		<th align='right' style='border: 1px solid; padding:3px;'>
		<?php if ($rowcount == 0 || $cellcount == 0){?><b><?php }?>
		<?=$cell?>
		<?php if ($rowcount == 0 || $cellcount == 0){?></b><?php }?>
		</th>
	<?php 
	   $cellcount++;
	}
	?>
	</thead>
	</tr>
<?php
    } else { // $rowcount > 0
?>
	<tr style='border-spacing: 3px; border: 1px solid; padding:2px; font-size:10px;'>
	<?php
	
	$cellcount = 0;
	foreach ($row as $cell) {
		?>
			<td align='right' style='border: 1px solid; padding:3px; white-space: nowrap;' width="100px">
				<?php if ($cellcount == 0){?><b><?php } ?>
					<?= $cell?>
				<?php
				if ($cellcount==0 && $metadata[$rowcount] > 0) { ?>
					&nbsp;<button style="float:right;" type="button" onclick="printShowroom(<?=$metadata[$rowcount]?>, '<?=$month?>', '<?=$year?>');"><i class="fa fa-print"></i></button>
				<?php } ?>
				<?php if ($cellcount == 0){?></b><?php } ?>
			</td>
		<?php 
		
	   $cellcount++;
	}

	?>
	</tr>
<?php }
        $rowcount++;
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
    "ordering": false
    });
} );


	function exportCsv() {
		window.location = '/php/NewSalesFigures/exportMonthlyData?month=<?=$month?>&year=<?=$year?>&dispcurr=<?=$dispcurr?>';
	}
	
	function printShowroom(idlocation, month, year) {
		if (idlocation == 999) {
			window.open('/php/NewSalesFigures/coupons.pdf?month=' + month +'&year=' + year, '_blank');
		} else {
		window.open('/php/NewSalesFigures/showroom.pdf?location=' + idlocation + '&month=' + month +'&year=' + year, '_blank');
		}
	}
	
	function swapToYearly() {
		window.location = '/php/NewSalesFigures/Yearly?year=<?=$year?>';
	}
	function swapToExchangeRates() {
		window.location = '/php/exchangeRates?year=<?=$year?>';
	}
	
	function swapToSalesTargets() {
		window.location = '/php/SalesTargets?year=<?=$year?>';
	}
	
</script>
