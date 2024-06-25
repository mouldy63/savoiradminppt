<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('revenue.css',array('inline' => false));?>
<?php echo $this->Html->script('revenue.js', array('inline' => false)); ?>
<?php
	function getMonth($monthKey){
		$key = (int)$monthKey;
		switch($key){
			case 1:
				return 'JANUARY';
				break;
			case 2:
				return 'FEBRUARY';
				break;
			case 3:
				return 'MARCH';
				break;
			case 4:
				return 'APRIL';
				break;
			case 5:
				return 'MAY';
				break;
			case 6:
				return 'JUNE';
				break;
			case 7:
				return 'JULY';
				break;
			case 8:
				return 'AUGUST';
				break;
			case 9:
				return 'SEPTEMBER';
				break;
			case 10:
				return 'OCTOBER';
				break;
			case 11:
				return 'NOVEMBER';
				break;
			case 12:
				return 'DECEMBER';
				break;
		}
	}	
	echo $this->element('revenueHeader',array('page'=>'index'));
	$years = $data['years'];
	$showroom = $data['showroom'];
?>
<div id="control-area">
	<div>
		<div class="time-select-area">
			<input type="hidden" id="time-format-selection" value="day"/>
			<div class="day-select">
			<label>From:</label> <input type="date" class="day-selection from-date"/> <label>To:</label> <input type="date" class="day-selection to-date"/><br> 
			</div>
			<div style="margin:20px 0px;">OR <a href="#" id="enable-month-format">SELECT BY MONTH AND YEAR</a></div>
			<div class="month-select">
				Month: <select class="select select-month">
					<option value="-1">--</option>
					<?php 
						for($ii=1;$ii<=12;$ii++):?>
						<option value="<?php echo $ii?>"><?php echo ucwords(strtolower(getMonth($ii)));?></option>
					<?php endfor;?>
				</select>
				Year: <select class="select select-year">
					<option value="-1">--</option>
					<?php foreach($years as $year):?>
						<option value="<?php echo $year?>"><?php echo $year;?></option>
					<?php endforeach;?>
				</select>
			</div>
		</div>
		<div class="location-select-area">
			<div class="date-type-select">
				Select Date Range:
				<select class="select select-date-range">
					<option value="-1">--</option>
					<option value="orderdate">Order Date</option>
					<option value="production">Production Completion Date</option>
					<option value="delivery">Delivery Date</option>
				</select>
			</div>
			<div class="showroom-select" style="margin:20px 0px;">
				Select Showroom:
				<select class="select select-showroom">
					<option value="-1">--</option>
					<option value="0">All</option>
					<?php foreach($showroom as $s):?>
						<option value="<?php echo $s['idlocation']?>"><?php echo $s['location'];?></option>
					<?php endforeach;?>
				</select>
			</div>
		</div>
		<div class="clear"></div>
	</div>
	<div class="action-area">
		<div class="path" id="clear-selection"><a href="#" >Clear</a></div> 
		<div class="path" id="show-table"><a href="#">View Results</a></div>
		<div class="path" id="get-csv"><a href="#">CSV File</a></div> 
		<div class="clear">
	</div>
	
</div>
<div id="table-area">
</div>
