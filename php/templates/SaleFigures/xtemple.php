<?php
namespace app\View\SaleFigures;
use Cake\Core\Configure;
use Cake\Routing\Router;

echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('salefigures.css',array('inline' => false));?>
<?php echo $this->Html->css('salefigures-showroom.css',array('inline' => false));?>
<?php echo $this->Html->script('htmlToJS.js', array('inline' => false)); ?>

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

if($data == 'no'):
	echo "You don't have enough privilege to see this page.";
?>
<?php else:?>
<?php 
	$acl = $data['acl'];
	$currentYear = (int)$data['requestyear'];
	$thisYear = (int)$data['thisyear'];
	$thisMonth = (int)date('m');
	$currentMonth = (int)$data['currentmonth'];
	$allFiguresForJS = $data['data'];
	$allTargetsForJS = $data['target'];
	$exchangeRate = $data['exchange_rate_array'];
	$allFigures[$currentYear] = $data['data'][$currentYear];
	$allFiguresLastYear = $data['data'][$currentYear-1];
	arsort($allFigures);
	$allTargets[$currentYear] = $data['target'][$currentYear];
	$allTargetsLastYear = $data['target'][$currentYear-1];
	echo $this->element('saleFiguresHeader', array("acl"=>$acl));
	echo $this->element('saleFiguresControllPannel');
?>


<input id="thisyear" type="hidden" value="<?php echo $data['thisyear'];?>"/>
<div id="tableArea">
<table id="theTable">
<thead>
<tr>
	<th class = "twotablecell emptycell bordercell submitArea"><button id='refreshTable' style="display:none;" onclick="submitChanges(this);return false;">REFRESH TABLE</button></th>
	<th class = "tentablecell bordercell">SAVOIR BEDS</th>
</tr>
<tr style="background-color:white;">
	<th class = "twotablecell bordercell"><select id="changeYear" onchange="changeTime(this);return false;";>
	<?php for($ii=$thisYear;$ii>=2012;$ii--):?>
		<?php if( $ii==$currentYear):?>
			<option value="<?php echo $ii;?>" selected><?php echo $ii;?></option>
		<?php else:?>
			<option value="<?php echo $ii;?>"><?php echo $ii;?></option>
		<?php endif;?>
	<?php endfor;?>
	</select>
	<select id="changeMonth" data-changed="n" onchange="changeTime(this);return false;";>
	<?php 
		if($thisYear == $currentYear){
			$endMonth = (int)date('m');;
		}
		else{
			$endMonth = 1;
		}
		for($ii=1;$ii<=12;$ii++):?>
		<?php if( $ii==$endMonth):?>
			<option value="<?php echo $ii;?>" selected><?php echo getMonth($ii);?></option>
		<?php else:?>
			<option value="<?php echo $ii;?>"><?php echo getMonth($ii);?></option>
		<?php endif;?>
	<?php endfor;?>
	</select>
	</th>
	<th class = "tablecell bordercell">Month Actual</th>
	<th class = "tablecell bordercell">Month Target</th>
	<th class = "tablecell bordercell">Prior Year<br>(<span id="showMonth"><?php echo getMonth((int)$currentMonth);?></span>)</th>
	<th class = "tablecell bordercell">Prior Year To Date<br>(<span id="showYear"><?php echo $currentYear-1;?></span>)</th>
	<th class = "tablecell bordercell">Year to Date Target</th>
	<th class = "tablecell bordercell">Year to Date Actual</th>
	<th class = "tablecell bordercell">Year to Date VS Prior Year to Date in &#163;</th>
	<th class = "tablecell bordercell">Year to Date VS Prior Year to Date in %</th>
	<th class = "tablecell bordercell">Year to Date Actual VS Year to Date Target in &#163;</th>
	<th class = "tablecell bordercell">Year to Date Actual VS Year to Date Target in %</th>
</tr>
</thead>
<tbody id="datatable">
<tr><td class = "twotablecell emptycell bordercell">Savoir Owned</td>
<?php for($ii=1;$ii<=10;$ii++):?>
<td class = "tablecell bordercell"></td>
<?php endfor;?>
</tr>
<?php
	$thisYear = date('Y');
	$thisMonth = date('m');
	$totalArrayKey = 1;
	foreach($allFigures as $yearKey=>$tempYearFigures):
		$tempYearTargets = $allTargets[$yearKey];
		
		$totalArray=array_fill(1,10,0);
		foreach($tempYearFigures as $showroomKey=>$showroomFigures):
			$showroomTargets = $tempYearTargets[$showroomKey];
?>
	<tr>
		<td class = "twotablecell bordercell"><?php echo $showroomFigures['showroomName']?> (<span class="native_currency_code" data-currency-code="<?php echo $showroomFigures['currency'];?>"><?php echo $showroomFigures['currency'];?></span>)</td>
<?php
            $isGBP = true;
            $currencyStatus = '';
            $temRate = 1;
            if($showroomFigures['currency']!='GBP'){
            	$isGBP = false;
            	$currencyStatus = 'nativecurrency';
            }
			$thisyearYTD = 0;
			$lastyearYTD = 0;
			$thisyearTargetYTD = 0;
			$thisyearYTDGBP = 0;
            $lastyearYTDGBP = 0;
            $thisyearTargetYTDGBP = 0;
			foreach($showroomFigures['figures'] as $monthKey=>$tempMonthFigures):

				if($monthKey<=$currentMonth){
				    if(!$isGBP){
				        $temRate = $exchangeRate[$yearKey][$monthKey][$showroomFigures['currency']];
				        $temRateLastYear = $exchangeRate[$yearKey-1][$monthKey][$showroomFigures['currency']];
				        $thisyearYTDGBP += $tempMonthFigures/$temRate;
                        $lastyearYTDGBP += $allFiguresLastYear[$showroomKey]['figures'][$monthKey]/$temRateLastYear;
                        $thisyearTargetYTDGBP += $showroomTargets[$monthKey]['amount']/$temRate;
				    }
                    $thisyearYTD += $tempMonthFigures;
                    $lastyearYTD += $allFiguresLastYear[$showroomKey]['figures'][$monthKey];
                    $thisyearTargetYTD += $showroomTargets[$monthKey]['amount'];

				}
			endforeach;
			if(!$isGBP){
			    $totalArray[1] += $showroomFigures['figures'][$currentMonth]/$exchangeRate[$yearKey][$currentMonth][$showroomFigures['currency']];
                $totalArray[2] += $showroomTargets[$currentMonth]['amount']/$exchangeRate[$yearKey][$currentMonth][$showroomFigures['currency']];
                $totalArray[3] += $allFiguresLastYear[$showroomKey]['figures'][$currentMonth]/$exchangeRate[$yearKey-1][$currentMonth][$showroomFigures['currency']];
                $totalArray[4] += $lastyearYTDGBP;
                $totalArray[5] += $thisyearTargetYTDGBP;
                $totalArray[6] += $thisyearYTDGBP;
                $totalArray[7] += ($thisyearYTDGBP - $lastyearYTDGBP);
                $totalArray[9] += ($thisyearYTDGBP - $thisyearTargetYTDGBP);
			}
			else{
                $totalArray[1] += $showroomFigures['figures'][$currentMonth];
                $totalArray[2] += $showroomTargets[$currentMonth]['amount'];
                $totalArray[3] += $allFiguresLastYear[$showroomKey]['figures'][$currentMonth];
                $totalArray[4] += $lastyearYTD;
                $totalArray[5] += $thisyearTargetYTD;
                $totalArray[6] += $thisyearYTD;
                $totalArray[7] += ($thisyearYTD - $lastyearYTD);
                $totalArray[9] += ($thisyearYTD - $thisyearTargetYTD);
			}
			
			
?>
		<td class = "tablecell bordercell <?php echo $currencyStatus;?>" 
			<?php if(!$isGBP):?> 
			data-currency-array="-1,
			<?php echo $showroomFigures['figures'][$currentMonth]/$exchangeRate[$yearKey][$currentMonth][$showroomFigures['currency']];?>,
			<?php echo $showroomFigures['figures'][$currentMonth];?>"
			<?php endif;?>><?php echo number_format($showroomFigures['figures'][$currentMonth],2,'.',','); ?></td>
		<td class = "tablecell bordercell <?php echo $currencyStatus;?>" 
			<?php if(!$isGBP):?> 
			data-currency-array="-1,
			<?php echo $showroomTargets[$currentMonth]['amount']/$exchangeRate[$yearKey][$currentMonth][$showroomFigures['currency']];?>,
			<?php echo $showroomTargets[$currentMonth]['amount'];?>"
			<?php endif;?>><input class="set_target disablebg" onchange="allTargetsData.changeTarget(
			<?php echo $yearKey;?>,<?php echo $currentMonth;?>,<?php echo $showroomKey;?>,this);return false;" type="text" value="<?php echo number_format($showroomTargets[$currentMonth]['amount'],0,'.',',');?>" disabled/></td>
		<td class = "tablecell bordercell <?php echo $currencyStatus;?>" 
			<?php if(!$isGBP):?>
			data-currency-array="-1,
			<?php echo $allFiguresLastYear[$showroomKey]['figures'][$currentMonth]/$exchangeRate[$yearKey-1][$currentMonth][$showroomFigures['currency']]?>,
			<?php echo $allFiguresLastYear[$showroomKey]['figures'][$currentMonth];?>"
			<?php endif;?>><?php echo number_format($allFiguresLastYear[$showroomKey]['figures'][$currentMonth],2,'.',','); ?></td>
		<td class = "tablecell bordercell <?php echo $currencyStatus;?>" 
			<?php if(!$isGBP):?>
			data-currency-array="-1,<?php echo $lastyearYTDGBP;?>,<?php echo $lastyearYTD;?>"
			<?php endif;?>><?php echo number_format($lastyearYTD,2,'.',','); ?></td>
		<td class = "tablecell bordercell <?php echo $currencyStatus;?>" 
			<?php if(!$isGBP):?>
			data-currency-array="-1,<?php echo $thisyearTargetYTDGBP;?>,<?php echo $thisyearTargetYTD;?>"
			<?php endif;?>><?php echo number_format($thisyearTargetYTD,0,'.',','); ?></td>
		<td class = "tablecell bordercell <?php echo $currencyStatus;?>" 
			<?php if(!$isGBP):?>
			data-currency-array="-1,<?php echo $thisyearYTDGBP;?>,<?php echo $thisyearYTD;?>"
			<?php endif;?>><?php echo number_format($thisyearYTD,2,'.',','); ?></td>
		<td class = "tablecell bordercell <?php echo $currencyStatus;?>" 
			<?php if(!$isGBP):?>
			data-currency-array="-1,<?php echo $thisyearYTDGBP-$lastyearYTDGBP;?>,<?php echo $thisyearYTD-$lastyearYTD;?>"
			<?php endif;?>><?php echo number_format($thisyearYTD-$lastyearYTD,2,'.',','); ?></td>
		<td class = "tablecell bordercell"><?php echo $lastyearYTD==0?0:round((($thisyearYTD-$lastyearYTD)/$lastyearYTD)*100).'%'; ?></td>
		<td class = "tablecell bordercell <?php echo $currencyStatus;?>" 
			<?php if(!$isGBP):?>
			data-currency-array="-1,<?php echo $thisyearYTDGBP-$thisyearTargetYTDGBP;?>,<?php echo $thisyearYTD-$thisyearTargetYTD;?>"
			<?php endif;?>><?php echo number_format($thisyearYTD-$thisyearTargetYTD,2,'.',','); ?></td>
		<td class = "tablecell bordercell"><?php echo $thisyearTargetYTD==0?0:round((($thisyearYTD-$thisyearTargetYTD)/$thisyearTargetYTD)*100).'%'; ?></td>
	</tr>
<?php
		$totalArrayKey++;
		if($showroomKey == 34):
?>
		<tr><td class = "twotablecell emptycell bordercell"></td>
	<?php for($ii=1;$ii<=10;$ii++):?>
		<td class = "tablecell bordercell"></td>
	<?php endfor;?>
		</tr>
		<tr><td class = "twotablecell emptycell bordercell">Dealers</td>
	<?php for($ii=1;$ii<=10;$ii++):?>
		<td class = "tablecell bordercell"></td>
	<?php endfor;?>
		</tr>
<?php
		endif;
		endforeach;
	endforeach;
?>
<tr><th class = "twotablecell emptycell bordercell"></th>
	<?php for($ii=1;$ii<=10;$ii++):?>
		<td class = "tablecell bordercell"></td>
	<?php endfor;?>
		</tr>
<tr>
	<td class = "twotablecell bordercell">TOTAL (GBP):</td>
<?php
	for($ii=1;$ii<=10;$ii++):
		if($ii==8||$ii==10):
?>
	<td class = "tablecell bordercell"></td>		
<?php 	else:?>
	<td class = "tablecell bordercell"><?php echo number_format($totalArray[$ii],0,'.',',');?></td>

<?php
		endif;	
	endfor;
?>	
</tr>
</tbody>

</table>
</div>


<script type="text/javascript">
allTargetsData = {
	originalTarget:<?php echo json_encode($allTargetsForJS);?>,
	updatedTargets:<?php echo json_encode($allTargetsForJS);?>,
	realFigure: <?php echo json_encode($allFiguresForJS);?>,
	exchangeRate: <?php echo json_encode($exchangeRate);?>,
	isTableChanged: function(){
		if(this.updatedTargets == -1){
			return false;
		}
		else{
			for (var k in this.updatedTargets) {
		        var tempYear = this.updatedTargets[k];
		        for(var t in tempYear){
		        	var tempMonth = tempYear[t];
		        	for(var s in tempMonth){
		        		var tempShowroom = tempMonth[s];
		        		if(tempShowroom['changed'] == 'y'){
		        			return true;
		        		}
		        	}
		        }
		    }
		    
		    return false;
		}
	},
	inputValidation: function(str){
		if (str.match(/(?:\d*\.)?\d+/)) {
			if (str.match(/[a-zA-Z_+-,!@#$%^&*();\\/|<>"']+/)){
				return false;
			}
			else{
		    	return true;
		    }
		}
		else{
			return false;
		}
	},
	changeTarget: function(year,month,showroom,element){
		var y = parseInt(year);
		var m = parseInt(month);
		var s = parseInt(showroom);
		var value = $(element).val();
		if(this.inputValidation(value)){
			this.updatedTargets[y][s][m]['amount']=value;
			this.updatedTargets[y][s][m]['changed']='y';
			if(!$(element).hasClass('changed')){
			}
			$(element).addClass('changed');
		}
		else{
			$(element).val('0');
			alert("please enter digits and don't		}
	},
	updateData: function(target,realSales,exchangeRate){
		this.originalTarget = target;
		this.updatedTargets = target;
		this.realFigure = realSales;
		this.exchangeRate = exchangeRate;
	},
	saveToDB: function(){
		var thisObj = this;
		var requestYear = $('#changeYear').val();
		//console.log(this.updatedTargets);
		if(this.updatedTargets != -1){
			var sendbackData = JSON.stringify(this.updatedTargets);
			$.ajax({
				method:"post",
				data:{"type":"world","newtarget":sendbackData,"detail":""},
				url:"<?php echo Router::url('/', true);?>saleFigures/updatetarget",
				success:function(data){
					var target = JSON.parse(data);
					//console.log(target);
					//return;
					thisObj.updateData(target,thisObj.realFigure,thisObj.exchangeRate);
					thisObj.rebuildTable();
					alert("data has been saved successfully.");
				},
				error:function(e){
				    alert('Data cannot be uploaded');
				    console.log(e);
				}
			});
		}
		else{
			alert('No data to be saved.');
		}
	},
	rebuildTable: function(){
		//console.log(this.realFigure);
		var table = worldTableGenerator(this.realFigure,this.originalTarget);
		$('#datatable').empty();
		$('#datatable').append(table);
		adjustTable();
	}
};

function changeTime(element){
	if(!$('#refreshTable').is(':visible')){
		$('#refreshTable').show();
	}
}
function submitChanges(element){
	var requestYear = $('#changeYear').val();
	var requestMonth = parseInt($('#changeMonth').val());
	$.ajax({
				method:"post",
				data:{"startyear":requestYear,"requestmonth":requestMonth},
				url:"<?php echo Router::url('/', true);?>saleFigures/worldMonthlyFigures",
				success:function(data){
					var rawData = JSON.parse(data);
					var allFigures = rawData.data;
					var targets = rawData.target;
					allTargetsData.updateData(targets,allFigures,rawData.exchange_rate_array);
					var table = worldTableGenerator(allFigures,targets);
					$('#datatable').empty();
					$('#datatable').append(table);
					adjustTable();
					$('#enableTableEdit').html('EDIT TABLE');
					$('#enableTableEdit').attr('data-current-status','disable');
					$('#showMonth').empty();
					$('#showMonth').append(getMonth(parseInt(requestMonth)));
					$('#showYear').empty();
					$('#showYear').append(requestYear-1);
					$('#refreshTable').hide();
					alert('This is records in '+ requestYear + ' ' + getMonth(requestMonth));
				}
			});
}


function adjustTable(){
	var standardWidth = jQuery(window).width();
		standardWidth = Math.round((standardWidth-50)*0.9/12);
	var padding = 3;
	var border = 1;
		
		var twoCellWidth = standardWidth*2 + padding*2 + border;
		var fourCellWidth = twoCellWidth*2 + padding*2 + border;
		var sixCellWidth = twoCellWidth*3 + padding*4 + border*2;
		var eightCellWidth = fourCellWidth*2 + padding*2 + border;
		var tenCellWidth = twoCellWidth*5 + padding*8 + border*4;
		var onesixCellWidth = eightCellWidth*2 + padding*2 + border;
		var twofourCellWidth = standardWidth*24 + padding*46 + border*21;
		var threetwoCellWidth = onesixCellWidth*2 + padding*2 + border;
		
		var cellStyle = "max-width:"+standardWidth +"px;" + "min-width:"+standardWidth +"px;";
		var twocellStyle = "max-width:"+(twoCellWidth) +"px;" + "min-width:"+(twoCellWidth) +"px;";
		var fourcellStyle = "max-width:"+(fourCellWidth) +"px;" + "min-width:"+(fourCellWidth) +"px;";
		var sixcellStyle = "max-width:"+(sixCellWidth) +"px;" + "min-width:"+(sixCellWidth) +"px;";
		var eightcellStyle = "max-width:"+(eightCellWidth) +"px;" + "min-width:"+(eightCellWidth) +"px;";
		var tencellStyle = "max-width:"+(tenCellWidth) +"px;" + "min-width:"+(tenCellWidth) +"px;";
		var twofourcellStyle = "max-width:"+(twofourCellWidth) +"px;" + "min-width:"+(twofourCellWidth) +"px;";
		var threetwocellStyle = "max-width:"+(threetwoCellWidth) +"px;" + "min-width:"+(threetwoCellWidth) +"px;";
		
		$('.tablecell').each(function(){
			var newStyle = cellStyle;
			$(this).attr('style',newStyle);
		});
		$('.twotablecell').each(function(){
			var newStyle = twocellStyle;
			$(this).attr('style',newStyle);
		});
		$('.fourtablecell').each(function(){
			var newStyle = fourcellStyle;
			$(this).attr('style',newStyle);
		});
		$('.sixtablecell').each(function(){
			var newStyle = sixcellStyle;
			$(this).attr('style',newStyle);
		});
		$('.eighttablecell').each(function(){
			var newStyle = eightcellStyle;
			$(this).attr('style',newStyle);
		});
		$('.tentablecell').each(function(){
			var newStyle = tencellStyle;
			$(this).attr('style',newStyle);
		});
		$('.twofourtablecell').each(function(){
			var newStyle = twofourcellStyle;
			$(this).attr('style',newStyle);
		});
		$('.threetwotablecell').each(function(){
			var newStyle = threetwocellStyle;
			$(this).attr('style',newStyle);
		});		
}
$(window).resize(function(){
	adjustTable();
});
$(document).ready(function(){
	adjustTable();
});
function worldTableGenerator(allRowFigures,allRowTargets){
	var str = "";
	var thisYear = new Date().getFullYear();
	var thisMonth = new Date().getMonth()+1;
	var requestYear = parseInt($('#changeYear').val());
	var requestMonth = parseInt($('#changeMonth').val());
	var allFigures={},allTargets={};
	allFigures[requestYear] = allRowFigures[requestYear];
	var allFiguresLastYear = allRowFigures[requestYear-1];
	allTargets[requestYear] = allRowTargets[requestYear];
	str += '<tr><td class = "twotablecell emptycell bordercell">Savoir Owned</td>'
	for(var ii=1;ii<=10;ii++){
		str += '<td class = "tablecell bordercell"></td>';
	}
	str += '</tr>';
	var showroomSBCode = [1,3,4,36,27,24,29,34];
	var totalArray={1:0,2:0,3:0,4:0,5:0,6:0,7:0,8:0,9:0,10:0};
	var yearKey;
	var exchangeRate = allTargetsData.exchangeRate;
	for(var yearKey in allFigures){
		var tempYearFigures = allFigures[yearKey];
		var tempYearTargets = allTargets[yearKey];
		var  str1='', str2='', str3='';
		for(var showroomKey in tempYearFigures){
			var showroomFigures = tempYearFigures[showroomKey];
			var showroomTargets = tempYearTargets[showroomKey];
			var tempStr='';
			tempStr += '<tr><td class = "twotablecell bordercell">' + showroomFigures['showroomName'] + ' (<span class="native_currency_code" data-currency-code="' + showroomFigures['currency'] + '">' + showroomFigures['currency'] + '</span>)' + '</td>';
			isGBP = true;
            currencyStatus = '';
            temRate = 1;
            if(showroomFigures['currency']!='GBP'){
            	isGBP = false;
            	currencyStatus = 'nativecurrency';
            }
			var thisyearYTD = 0;
			var thisyearTargetYTD = 0;
			var lastyearYTD = 0;
			var thisyearYTDGBP = 0;
            var lastyearYTDGBP = 0;
            var thisyearTargetYTDGBP = 0;
			for(var monthKey in showroomFigures['figures']){
				var tempMonthFigures = showroomFigures['figures'][monthKey];
				if(monthKey<=requestMonth){
					if(!isGBP){
				        temRate = exchangeRate[yearKey][monthKey][showroomFigures['currency']];
				        temRateLastYear = exchangeRate[yearKey-1][monthKey][showroomFigures['currency']];
				        thisyearYTDGBP += tempMonthFigures/temRate;
                        lastyearYTDGBP += allFiguresLastYear[showroomKey]['figures'][monthKey]/temRateLastYear;
                        thisyearTargetYTDGBP += showroomTargets[monthKey]['amount']/temRate;
				    }
					thisyearYTD += showroomFigures['figures'][monthKey];
			 		thisyearTargetYTD += showroomTargets[monthKey]['amount'];
			 		lastyearYTD += allFiguresLastYear[showroomKey]['figures'][monthKey]; 
				}
			}
			if(!isGBP){
			    totalArray[1] += showroomFigures['figures'][requestMonth]/exchangeRate[yearKey][requestMonth][showroomFigures['currency']];
                totalArray[2] += showroomTargets[requestMonth]['amount']/exchangeRate[yearKey][requestMonth][showroomFigures['currency']];
                totalArray[3] += allFiguresLastYear[showroomKey]['figures'][requestMonth]/exchangeRate[yearKey-1][requestMonth][showroomFigures['currency']];
                totalArray[4] += lastyearYTDGBP;
                totalArray[5] += thisyearTargetYTDGBP;
                totalArray[6] += thisyearYTDGBP;
                totalArray[7] += (thisyearYTDGBP - lastyearYTDGBP);
                totalArray[9] += (thisyearYTDGBP - thisyearTargetYTDGBP);
			}
			else{
				totalArray[1] += showroomFigures['figures'][requestMonth];
				totalArray[2] += showroomTargets[requestMonth]['amount'];
				totalArray[3] += allFiguresLastYear[showroomKey]['figures'][requestMonth];
				totalArray[4] += lastyearYTD;
				totalArray[5] += thisyearTargetYTD;
				totalArray[6] += thisyearYTD;
				totalArray[7] += (thisyearYTD - lastyearYTD);
				totalArray[9] += (thisyearYTD - thisyearTargetYTD);
			}
			
			var dataArrayStr = '';
			if(!isGBP){ 
				var tempV = showroomFigures['figures'][requestMonth]/exchangeRate[yearKey][requestMonth][showroomFigures['currency']];
				dataArrayStr = 'data-currency-array="-1,' + tempV + ',' + showroomFigures['figures'][requestMonth] + '"';
			}
			tempStr += '<td class = "tablecell bordercell ' + currencyStatus + '" ' + dataArrayStr + '>' + addComma(showroomFigures['figures'][requestMonth].toFixed(2)) + '</td>';
			
			dataArrayStr = '';
			if(!isGBP){ 
				var tempV = showroomTargets[requestMonth]['amount']/exchangeRate[yearKey][requestMonth][showroomFigures['currency']];
				dataArrayStr = 'data-currency-array="-1,' + tempV + ',' + showroomTargets[requestMonth]['amount'] + '"';
			}
			tempStr += '<td class = "tablecell bordercell ' + currencyStatus + '" ' + dataArrayStr + '><input class="set_target disablebg" onchange="allTargetsData.changeTarget(' +
				yearKey+','+requestMonth+','+showroomKey+',this);return false;" type="text" value="'+showroomTargets[requestMonth]['amount'].toLocaleString() + '" disabled/></td>';
			
			dataArrayStr = '';
			if(!isGBP){ 
				var tempV = allFiguresLastYear[showroomKey]['figures'][requestMonth]/exchangeRate[yearKey-1][requestMonth][showroomFigures['currency']];
				dataArrayStr = 'data-currency-array="-1,' + tempV + ',' + allFiguresLastYear[showroomKey]['figures'][requestMonth] + '"';
			}
			tempStr += '<td class = "tablecell bordercell ' + currencyStatus + '" ' + dataArrayStr + '>' + addComma(allFiguresLastYear[showroomKey]['figures'][requestMonth].toFixed(2)) + '</td>';
			
			dataArrayStr = '';
			if(!isGBP){ 
				dataArrayStr = 'data-currency-array="-1,' + lastyearYTDGBP + ',' + lastyearYTD + '"';
			}
			tempStr += '<td class = "tablecell bordercell ' + currencyStatus + '" ' + dataArrayStr + '>' + addComma(lastyearYTD.toFixed(2)) + '</td>';
			
			dataArrayStr = '';
			if(!isGBP){ 
				dataArrayStr = 'data-currency-array="-1,' + thisyearTargetYTDGBP + ',' + thisyearTargetYTD + '"';
			}
			tempStr += '<td class = "tablecell bordercell ' + currencyStatus + '" ' + dataArrayStr + '>' + thisyearTargetYTD.toLocaleString() + '</td>';
			
			dataArrayStr = '';
			if(!isGBP){ 
				dataArrayStr = 'data-currency-array="-1,' + thisyearYTDGBP + ',' + thisyearYTD + '"';
			}
			tempStr += '<td class = "tablecell bordercell ' + currencyStatus + '" ' + dataArrayStr + '>' + addComma(thisyearYTD.toFixed(2)) + '</td>';
			
			dataArrayStr = '';
			if(!isGBP){ 
				var tepV1 = thisyearYTDGBP-lastyearYTDGBP;
				var tepV2 = thisyearYTD-lastyearYTD;
				dataArrayStr = 'data-currency-array="-1,' + tepV1 + ',' + tepV2 + '"';
			}
			tempStr += '<td class = "tablecell bordercell ' + currencyStatus + '" ' + dataArrayStr + '>' + addComma((thisyearYTD-lastyearYTD).toFixed(2)) + '</td>';
			
			var temp = lastyearYTD==0?0:Math.round(((thisyearYTD-lastyearYTD)/lastyearYTD)*100);
			tempStr += '<td class = "tablecell bordercell">' + temp + '%' + '</td>';			
			
			dataArrayStr = '';
			if(!isGBP){ 
				var tepV1 = thisyearYTDGBP-thisyearTargetYTDGBP;
				var tepV2 = thisyearYTD-thisyearTargetYTD;
				dataArrayStr = 'data-currency-array="-1,' + tepV1 + ',' + tepV2 + '"';
			}
			tempStr += '<td class = "tablecell bordercell ' + currencyStatus + '" ' + dataArrayStr + '>' + addComma((thisyearYTD-thisyearTargetYTD).toFixed(2)) + '</td>';
			
			var temp1 = thisyearTargetYTD==0?0:Math.round(((thisyearYTD-thisyearTargetYTD)/thisyearTargetYTD)*100);
			tempStr += '<td class = "tablecell bordercell">' + temp1 + '%' + '</td>';
			tempStr += '</tr>';
			
			if(showroomSBCode.indexOf(parseInt(showroomKey))>=0){
				str1 += tempStr;
			}
			else if(showroomKey == 13||showroomKey == 14||showroomKey == 23){
				str3 += tempStr;
			}
			else{
				str2 += tempStr;
			}
		}
		str += str1;
		str += '<tr><td class = "twotablecell emptycell bordercell"></td>';
		for(var ii=1;ii<=10;ii++){
			str += '<td class = "tablecell bordercell"></td>';
		}
		str += '</tr>';
		str += '<tr><td class = "twotablecell emptycell bordercell">Dealers</td>';
		for(var ii=1;ii<=10;ii++){
			str += '<td class = "tablecell bordercell"></td>';
		}
		str += '</tr>';
		str += str2 + str3;
		
	}
	str += '<tr><td class = "twotablecell emptycell bordercell"></td>';
	for(var ii=1;ii<=10;ii++){
		str += '<td class = "tablecell bordercell"></td>';
	}
	str += '</tr>';
	str += '<tr>';
	str += '<td class = "twotablecell bordercell">TOTAL (GBP):</td>';
	for(var ii=1;ii<=10;ii++){
		if(ii==8||ii==10){
			str += '<td class = "tablecell bordercell"></td>';
		}
		else{
			str += '<td class = "tablecell bordercell">' + addComma(totalArray[ii].toFixed(2)) + '</td>';
		}
	}
	str += '</tr>';
	return str;
}
function addComma(digit){
	var s = digit.toString();
	var p = s.indexOf('.');
	x = s.split('.');
  	x1 = x[0];
  	x2 = x.length > 1 ? '.' + x[1] : '';
  	var rgx = /(\d+)(\d{3})/;
  	while (rgx.test(x1)) {
    	x1 = x1.replace(rgx, '$1' + ',' + '$2');
  	}
  	return x1 + x2;
}
function getMonth(monthKey){
	var key = parseInt(monthKey);
	switch(key){
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
</script>
<?php endif;?>