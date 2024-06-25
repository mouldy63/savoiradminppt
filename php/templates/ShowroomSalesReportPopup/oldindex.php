<?php use Cake\Routing\Router; ?>

<?php
$monthNames = [ 1 => 'January', 2 => 'Febuary', 3 => 'March', 4 => 'April', 5 => 'May', 6 => 'June', 7 => 'July', 8 => 'August', 9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December', ];
$thisYear = date('Y');
$thisMonth = date('m');
?>

<div>
	<form name="ShowroomSalesReportForm" id="ShowroomSalesReportForm">
		<h1 align="center">
			Select showroom sales report month:
		</h1>
		<div align="center">
		<?php if ($isAdminstrator) {
			?>
				Showroom:&nbsp;
				<select name="showroomid" id="showroomid">
					<?php foreach ($activeshowrooms as $row): ?> 
					<option value="<?= $row['idlocation'] ?>"><?= $row['adminheading'] ?></option>
					<?php endforeach; ?>
				</select>
			<?php
		} else {
			?>
				<input type="hidden" name="showroomid" id="showroomid" value="<?=$showroomid?>" />
			<?php
		}
		?>
			Month:&nbsp;
			<select name="requestmonth" id="requestmonth" >
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
			<select name="startyear" id="startyear" >
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
		$.post("/php/saleFigures/worldMonthlyFigures/", $('#ShowroomSalesReportForm').serialize(), function(data) {
			var rawData = JSON.parse(data);
			var allFigures = rawData.data;
			var targets = rawData.target;
			allTargetsData.updateData(targets, allFigures, rawData.exchange_rate_array, rawData.monthly_figure_details);
			printMonthlyReport($("#showroomid").val());
			setTimeout(function(){ self.close(); },1000);
		});
	});
	
	function printMonthlyReport(showroomId){
		var showroomCode = parseInt(showroomId);
		var url = '/fpdf/requests/print_response.php';
		var printData = JSON.stringify(allTargetsData.monthlyDetail[showroomCode]);
		//console.log("printData=" + printData);
		var printForm = document.createElement('form');
		printForm.action = '/fpdf/requests/print_response.php';
		printForm.id = 'printForm';
		printForm.target = '_blank';
		printForm.method = 'post';
		var inputData = document.createElement('input');
		inputData.name = "printData";
		inputData.value = printData;
		inputData.type = 'text';
		printForm.appendChild(inputData);
		document.body.appendChild(printForm);
		printForm.submit();
		var e = document.getElementById("printForm");
		e.parentNode.removeChild(e);
	}

	allTargetsData = {
		updateData: function(target,realSales,exchangeRate,monthlyDetail){
			this.originalTarget = target;
			this.updatedTargets = target;
			this.realFigure = realSales;
			this.exchangeRate = exchangeRate;
			this.monthlyDetail = monthlyDetail;
		},
	};
	
</script>