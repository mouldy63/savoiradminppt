<?php use Cake\Routing\Router; ?>

<?php
$monthNames = [ 1 => 'January', 2 => 'Febuary', 3 => 'March', 4 => 'April', 5 => 'May', 6 => 'June', 7 => 'July', 8 => 'August', 9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December', ];
$thisYear = date('Y');
$thisMonth = date('m');
?>

<div>
	<form style="margin-top:30px; padding-top:30px;" name="ShowroomSalesReportForm" id="ShowroomSalesReportForm">
		<h1 align="center">
			Select showroom sales report month:
		</h1>
		<div align="center">
			Showroom:&nbsp;
			<select name="showroomid" id="showroomid">
				<?php foreach ($activeshowrooms as $row) {
					$selected = "";
					if ($i == $thisMonth) $selected = "selected";
				?>
				<option value="<?= $row['idlocation'] ?>" <?=$selected?> ><?= $row['adminheading'] ?></option>
				<?php } ?>
			</select>
			Month:&nbsp;
			<select name="month" id="month" >
				<?php
					for ($i = 1; $i < 13; $i++) {
						$selected = "";
						if ($i == $thisMonth) $selected = "selected";
						echo "<option value='".$i."' ".$selected." >".$monthNames[$i]."</option>";
					}
				?>
			</select>
			&nbsp;
			Year:&nbsp;
			<select name="year" id="year" >
				<?php
					for ($i = $thisYear; $i > $thisYear-8; $i--) {
						echo "<option value='".$i."'>".$i."</option>";
					}
				?>
			</select>
			&nbsp;
			<input type="submit" name="SubmitShowroomSalesReportForm" />
		</div>
	</form>
</div>

<script>
	$("#ShowroomSalesReportForm").submit(function(event) {
  		event.preventDefault();
  		var showroomid=$("#showroomid").val();
  		var year=$("#year").val();
  		var month=$("#month").val();
  		window.open('/php/NewSalesFigures/showroom.pdf?location='+showroomid+'&month='+month+'&year='+year, '_blank');
		
	});
	
	
	
</script>