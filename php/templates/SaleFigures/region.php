<?php
use Cake\Core\Configure;
use Cake\Routing\Router;
?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('salefigures.css',array('inline' => false));?>
<?php echo $this->Html->css('salefigures-showroom.css',array('inline' => false));?>
<?php echo $this->Html->script('htmlToJS.js', array('inline' => false)); ?>

<?php 
function getMonth($monthKey){
	$key = (int)$monthKey;
	switch($key){
		case 1:
			return 'JAN';
			break;
		case 2:
			return 'FEB';
			break;
		case 3:
			return 'MAR';
			break;
		case 4:
			return 'APR';
			break;
		case 5:
			return 'MAY';
			break;
		case 6:
			return 'JUN';
			break;
		case 7:
			return 'JUL';
			break;
		case 8:
			return 'AUG';
			break;
		case 9:
			return 'SEP';
			break;
		case 10:
			return 'OCT';
			break;
		case 11:
			return 'NOV';
			break;
		case 12:
			return 'DEC';
			break;
	}
}

if($data == 'no'):
	echo "You don't have enough privilege to see this page.";
?>
<?php else:?>
<?php 
	$acl = $data['acl'];
	$allFigures = array_reverse($data['data'],true);
	$allTargets = $data['target'];
	$currentYear = (int)$data['requestyear'];
	$thisYear = (int)$data['thisyear'];
	$region = $data['region'];
	$showroomList = $data['showroomlist'];
	foreach($showroomList as $key=>$value){
		$zeroArray[$key]= 0;
	}
	switch($region){
		case 'uk':
			$titlecell = 'onetwotablecell';
			$title = 'UK';
			$totalcells = 14;
			break;
		case 'europe':
			$titlecell = 'tentablecell';
			$title = 'EUROPE';
			$totalcells = 12;
			break;
		case 'northamerica':
			$titlecell = 'eighttablecell';
			$title = 'NORTH AMERICA';
			$totalcells = 10;
			break;
		case 'asia':
			$titlecell = 'onefourtablecell';
			$title = 'ASIA';
			$totalcells = 16;
			break;
	}
	$previousYear = $currentYear-3<2010?2010:$currentYear-3;
	$nextYear = $currentYear+3>$thisYear?$thisYear:$currentYear+3;
?>

<div id="salefigureMenu">
	<ul>
		<li class="salefigureBigTile"><h3>Sale Figures</h3></li>
		<li class="salefigureMenuTile">
			 <a>WORLD</a>
			 <?php if($acl['issuperuser']):?>
			 <div class = "salefigure_submenu">
			 	<a href="<?php echo Router::url('/', true);?>saleFigures/world" class="table_world_request">Worldwide Sales</a>
			 </div>
			 <?php endif;?>
		</li>
		<li class="salefigureMenuTile">
			<a>UK</a>
			<div class = "salefigure_submenu">
			<?php if($acl['issuperuser']||$acl['region']=='uk'):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/region?reg=uk" class="table_region_request" data-region="uk">UK Sales</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='uk'||$acl['location']==3):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=3" class="table_showroom_request" data-region="3">Wigmore Street</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='uk'||$acl['location']==36):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=36" class="table_showroom_request" data-region="36">Chelsea Harbour</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='uk'||$acl['location']==4):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=4" class="table_showroom_request" data-region="4">Harrods</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='uk'||$acl['location']==27):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=27" class="table_showroom_request" data-region="27">Cardiff</a>
			<?php endif;?>
			</div>
		</li>
		<li class="salefigureMenuTile">
			<a>EUROPE</a>
			<div class = "salefigure_submenu">
			<?php if($acl['issuperuser']||$acl['region']=='eu'):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/region?reg=europe" class="table_region_request" data-region="eu">Europe Sales</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='eu'||$acl['location']==24):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=24" class="table_showroom_request" data-region="24">Dusseldorf</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='eu'||$acl['location']==17):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=17" class="table_showroom_request" data-region="17">Paris</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='eu'||$acl['location']==29):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=29" class="table_showroom_request" data-region="29">Paris 5eme</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='eu'||$acl['location']==25):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=25" class="table_showroom_request" data-region="25">St.Petersburg</a>
			<?php endif;?>
			</div>
		</li>
		<li class="salefigureMenuTile">
			<a>NORTH AMERICA</a>
			<div class = "salefigure_submenu">
			<?php if($acl['issuperuser']||$acl['region']=='us'):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/region?reg=northamerica" class="table_region_request" data-region="us">North America Sales</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='us'||$acl['location']==34):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=34" class="table_showroom_request" data-region="34">New York Uptown</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='us'||$acl['location']==8):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=8" class="table_showroom_request" data-region="8">New York Downtown</a>
			<?php endif;?>
			</div>
		</li>
		<li class="salefigureMenuTile">
			<a>ASIA</a>
			<div class = "salefigure_submenu">
			<?php if($acl['issuperuser']||$acl['region']=='asia'):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/region?reg=asia" class="table_region_request" data-region="asia">Asia Sales</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='asia'||$acl['location']==33):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=33" class="table_showroom_request" data-region="33">Hong Kong</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='asia'||$acl['location']==26):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=26" class="table_showroom_request" data-region="26">Beijing</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='asia'||$acl['location']==31):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=31" class="table_showroom_request" data-region="31">Seoul</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='asia'||$acl['location']==21):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=21" class="table_showroom_request" data-region="21">Shanghai</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='asia'||$acl['location']==28):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=28" class="table_showroom_request" data-region="28">Taipei</a>
			<?php endif;?>
			</div>
		</li>
	</ul>
</div>
<div id="tableControllPanel">
        <div class="salefigureMenuTile">
            <a id="enableTableEdit" data-current-status="disable" onclick="inputController(this);">EDIT TABLE</a>
        </div>
        <div class="salefigureMenuTile">
            <a id="exportTable" href="#">EXPORT TABLE</a>
        </div>
</div>
<?php endif;?>
<input id="thisyear" type="hidden" value="<?php echo $data['thisyear'];?>"/>
<div id="tableArea">
<table id="theTable">
<thead>
<tr>
	<th class = "tablecell emptycell bordercell"><a href="#" onclick="previousYearOnclick();return false;" id="previousyear" data-start-year="<?php echo $previousYear;?>"><img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/arrow-up.png" alt="previousYear" width="40" height="21"/></a></th>
	<th class = "tablecell emptycell bordercell"></th>
	<th class = "<?php echo $titlecell;?> topcell bottomcell rightcell">SAVOIR BEDS <?php echo $title;?></th>
</tr>
<tr>
	<th class = "tablecell emptycell leftcell"></th>
	<th class = "tablecell emptycell leftcell"></th>
<?php 
	foreach($allFigures[$currentYear][1] as $shKey=>$s):
?>
	<th class = "twotablecell bordercell nobottomcell"><?php echo $showroomList[$shKey];?></th>
<?php endforeach;?>
	<th class = "twotablecell leftcell bottomcell nobottomcell orangecell">Monthly Total</th>
	<th class = "twotablecell leftcell rightcell bottomcell nobottomcell lightgreencell">Yearly Total</th>
</tr>
<tr style="background-color:white;">
	<th class = "tablecell leftcell bottomcell">Year</th>
	<th class = "tablecell leftcell bottomcell">Month</th>
<?php 
	foreach($allFigures[$currentYear][1] as $shKey=>$s):
?>	
	<th class = "tablecell bordercell">Target</th>
	<th class = "tablecell bordercell">Actual</th>
<?php endforeach;?>	
	<th class = "tablecell bordercell orangecell">Target</th>
	<th class = "tablecell bordercell orangecell">Actual</th>
	<th class = "tablecell bordercell lightgreencell">Target</th>
	<th class = "tablecell bordercell lightgreencell">Actual</th>
</tr>
</thead>
<tbody id="datatable">
<?php
	$thisYear = date('Y');
	$thisMonth = date('m');
	foreach($allFigures as $yearKey=>$tempYearFigures){
		$tempYearTargets = $allTargets[$yearKey];
		$yearTotal = 0.00;
		$yearTargetTotal = 0.00;
		$yearShowroomTotal= $zeroArray;
		$yearShowroomTargetTotal= $zeroArray;
		$yearShowroomTotalToDate= $zeroArray;
		$yearShowroomTargetTotalToDate= $zeroArray;
		foreach($tempYearFigures as $monthKey=>$tempMonthFigures){
			$tempMonthTargets = $tempYearTargets[$monthKey];
			if($monthKey == 12):
?>
	<tr>
		<td class = "tablecell leftcell bottomcell"><?php echo $yearKey; ?></td>
		<td class = "tablecell bordercell"><?php echo getMonth($monthKey);?></td>
<?php
			else:
?>
	<tr>
		<td class = "tablecell emptycell leftcell"></td>
		<td class = "tablecell bordercell"><?php echo getMonth($monthKey);?></td>
<?php 
			endif;
			$monthTotal = 0.00;
			$monthTargetTotal = 0.00;
			foreach($tempMonthFigures as $showroomKey=>$showroomFigures){
				$monthTotal += $showroomFigures;
				$monthTargetTotal += $tempMonthTargets[$showroomKey]['amount'];
				$yearShowroomTotal[$showroomKey] += $tempMonthFigures[$showroomKey];
				$yearShowroomTargetTotal[$showroomKey] += $tempMonthTargets[$showroomKey]['amount'];
				if($yearKey == $thisYear){
					if($monthKey<=$thisMonth){
						$yearShowroomTotalToDate[$showroomKey] += $tempMonthFigures[$showroomKey];
						$yearShowroomTargetTotalToDate[$showroomKey] += $tempMonthTargets[$showroomKey]['amount'];
					}
				}
				else{
					$yearShowroomTotalToDate[$showroomKey] += $tempMonthFigures[$showroomKey];
					$yearShowroomTargetTotalToDate[$showroomKey] += $tempMonthTargets[$showroomKey]['amount'];
				}
				$differencePercent = 0;
				if($tempMonthTargets[$showroomKey]['amount'] != 0){
					$differencePercent = round(($tempMonthFigures[$showroomKey] - $tempMonthTargets[$showroomKey]['amount'])/$tempMonthTargets[$showroomKey]['amount'],2)*100;
				}
?>
		<td class = "tablecell bordercell"><input class="set_target disablebg" onchange="allTargetsData.changeTarget(
			<?php echo $yearKey;?>,<?php echo $monthKey;?>,<?php echo $showroomKey;?>,this);return false;" type="text" value="<?php echo $tempMonthTargets[$showroomKey]['amount'];?>" disabled/></td>
		<td class = "tablecell bordercell"><?php echo $tempMonthFigures[$showroomKey]; ?> (<?php echo $differencePercent.'%';?>)</td>

<?php
			}
			$yearTotal += $monthTotal;
			$yearTargetTotal += $monthTargetTotal;
?>
		<td class = "tablecell bordercell orangecell"><?php echo round($monthTargetTotal*100)/100;?></td>
		<td class = "tablecell bordercell orangecell"><?php echo round($monthTotal*100)/100;?></td>
<?php
			if($monthKey == 12){
?>
		<td class = "tablecell emptycell rightcell bottomcell lightgreencell"><?php echo round($yearTargetTotal*100)/100;?></td>
		<td class = "tablecell emptycell rightcell bottomcell lightgreencell"><?php echo round($yearTotal*100)/100;?></td>
	</tr>
<?php
			}
			else{
?>
		<td class = "tablecell emptycell rightcell lightgreencell"></td>
		<td class = "tablecell emptycell rightcell lightgreencell"></td>
	</tr>
<?php
			}
		}
?>		
	<tr style="background-color:lightblue;">
		<td class = "tablecell leftcell topbottomcell"> YTD</td>
		<td class = "tablecell leftcell topbottomcell"></td>
<?php foreach($showroomList as $sKey=>$v):?>
		<td class = "tablecell bordercell"><?php echo round($yearShowroomTargetTotalToDate[$sKey]*100)/100;?></td>
		<td class = "tablecell bordercell"><?php echo round($yearShowroomTotalToDate[$sKey]*100)/100;?></td>
<?php endforeach;?>
		<td class = "tablecell emptycell bordercell"></td>
		<td class = "tablecell emptycell bordercell"></td>
		<td class = "tablecell emptycell bordercell"></td>
		<td class = "tablecell emptycell bordercell"></td>
	</tr>
	<tr style="background-color:lightblue;">
		<td class = "tablecell leftcell topbottomcell">TOTAL</td>
		<td class = "tablecell leftcell topbottomcell"></td>
<?php foreach($showroomList as $ssKey=>$v):?>
		<td class = "tablecell bordercell"><?php echo round($yearShowroomTargetTotal[$ssKey]*100)/100;?></td>
		<td class = "tablecell bordercell"><?php echo round($yearShowroomTotal[$ssKey]*100)/100;?></td>
<?php endforeach;?>
		<td class = "tablecell emptycell bordercell"></td>
		<td class = "tablecell emptycell bordercell"></td>
		<td class = "tablecell emptycell bordercell"></td>
		<td class = "tablecell emptycell bordercell"></td>
	</tr>
<?php	
	}
?>
</tbody>
<tbody>
	<tr>
		<td class = "tablecell leftcell topbottomcell"><a href="#" onclick="nextYearOnclick();return false;" id="nextyear" data-start-year="<?php echo $nextYear;?>"><img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/arrow-down.png" alt="nextYear" width="40" height="21"/></a></td>
		<td class = "tablecell leftcell topbottomcell"></td>
		<td class = "<?php echo $titlecell;?> bordercell"></td>
	</tr>
</tbody>
</table>
</div>


<script type="text/javascript">
allTargetsData = {
	originalTarget:<?php echo json_encode($allTargets);?>,
	updatedTargets:<?php echo json_encode($allTargets);?>,
	realFigure: <?php echo json_encode($allFigures);?>,
	showroomList:<?php echo json_encode($showroomList);?>,
	zArray:<?php echo json_encode($zeroArray);?>,
	regionKey:"<?php echo $region;?>",
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
			this.updatedTargets[y][m][s]['amount']=value;
			this.updatedTargets[y][m][s]['changed']='y';
			if(!$(element).hasClass('changed')){
			}
			$(element).addClass('changed');
		}
		else{
			$(element).val('0');
			alert("please enter digits and don't use ','.");
		}
	},
	updateData: function(target,realSales){
		this.originalTarget = target;
		this.updatedTargets = target;
		this.realFigure = realSales;
	},
	saveToDB: function(){
		var thisObj = this;
		var previousyear = parseInt($('#previousyear').attr('data-start-year'));
		var nextyear = parseInt($('#nextyear').attr('data-start-year'));
		if(this.updatedTargets != -1){
			var sendbackData = JSON.stringify(this.updatedTargets);
			$.ajax({
				method:"post",
				data:{"type":"region","newtarget":sendbackData,"detail":"<?php echo $region;?>"},
				url:"<?php echo Router::url('/', true);?>saleFigures/updatetarget",
				success:function(data){
					var target = JSON.parse(data);
					//console.log(target);
					thisObj.updateData(target,thisObj.realFigure);
					thisObj.rebuildTable();
					$('#previousyear').attr('data-start-year',previousyear);
					$('#nextyear').attr('data-start-year',nextyear);
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
		var table = regionTableGenerator(this.realFigure,this.originalTarget);
		$('#tableArea').empty();
		$('#tableArea').append(table);
		adjustTable();
	}
};
function inputController(element){
        if($('#tableArea').is(':empty')){
            alert('There is no table!');
        }
        else{
            $('.set_target').each(function(){
                if(this.hasAttribute('disabled')){
                    $(this).removeAttr('disabled');
                    $(this).removeClass('disablebg');
                    $(element).html('LOCK & SAVE');
                }
                else{
                    $(this).attr('disabled','disabled');
                    $(this).addClass('disablebg');
                    $(element).html('EDIT TABLE');
                }
	        });
            var currentStatus = $(element).attr('data-current-status');
            if(currentStatus == 'disable'){
                $(element).attr('data-current-status','active');
            }
            else{
                if(allTargetsData.isTableChanged()){
                    allTargetsData.saveToDB();
                }
                $(element).attr('data-current-status','disable');
            }
        }
}
function previousYearOnclick(){
		var thisyear = parseInt($('#thisyear').val());
		var startyear = parseInt($('#previousyear').attr('data-start-year'));
		if(startyear >=2010){
			var previousYear = startyear-3;
			var nextYear = startyear+3;
			$.ajax({
				method:"post",
				data:{"startyear":startyear,"region":"<?php echo $region;?>"},
				url:"<?php echo Router::url('/', true);?>saleFigures/region",
				success:function(data){
					var rawData = JSON.parse(data);
					var requestYear = rawData.requestyear;
					var allFigures = rawData.data;
					var targets = rawData.target;
					allTargetsData.updateData(targets,allFigures);
					var table = regionTableGenerator(allFigures,targets);
					$('#tableArea').empty();
					$('#tableArea').append(table);
					$('#previousyear').attr('data-start-year',previousYear);
					$('#nextyear').attr('data-start-year',nextYear);
					adjustTable();
				}
			});
		}
		else{
			$('#previousyear').css('opacity','0.2');
			alert('This is the earliest records we have.');
		}
		return false;
}
function nextYearOnclick(){
		var thisyear = parseInt($('#thisyear').val());
		var startyear = parseInt($('#nextyear').attr('data-start-year'));
		if(startyear <= thisyear){
			var previousYear = (startyear-3);
			var nextYear = (startyear+3);
			$.ajax({
				method:"post",
				data:{"startyear":startyear,"region":"<?php echo $region;?>"},
				url:"<?php echo Router::url('/', true);?>saleFigures/region",
				success:function(data){
					var rawData = JSON.parse(data);
					var requestYear = rawData.requestyear;
					var allFigures = rawData.data;
					var targets = rawData.target;
					allTargetsData.updateData(targets,allFigures);
					var table = regionTableGenerator(allFigures,targets);
					$('#tableArea').empty();
					$('#tableArea').append(table);
					$('#previousyear').attr('data-start-year',previousYear);
					$('#nextyear').attr('data-start-year',nextYear);
					adjustTable();
				}
			});
		}
		else{
			$('#nextyear').css('opacity','0.2');
			alert('This is the latest records we have.');
		}
		return false;
}

function adjustTable(){
	var standardWidth = jQuery(window).width();
		standardWidth = Math.round((standardWidth-100)*0.85/<?php echo $totalcells;?>);
	var padding = 3;
	var border = 1;
		
		var twoCellWidth = standardWidth*2 + padding*2 + border;
		var fourCellWidth = twoCellWidth*2 + padding*2 + border;
		var sixCellWidth = twoCellWidth*3 + padding*4 + border*2;
		var eightCellWidth = fourCellWidth*2 + padding*2 + border;
		var tenCellWidth = twoCellWidth*5 + padding*8 + border*4;
		var onetwoCellWith = standardWidth*12 + padding*22 + border*9;
		var onefourCellWith = standardWidth*14 + padding*26 + border*11;
		var onesixCellWidth = eightCellWidth*2 + padding*2 + border;
		var threetwoCellWidth = onesixCellWidth*2 + padding*2 + border;
		
		var cellStyle = "max-width:"+standardWidth +"px;" + "min-width:"+standardWidth +"px;";
		var twocellStyle = "max-width:"+(twoCellWidth) +"px;" + "min-width:"+(twoCellWidth) +"px;";
		var fourcellStyle = "max-width:"+(fourCellWidth) +"px;" + "min-width:"+(fourCellWidth) +"px;";
		var sixcellStyle = "max-width:"+(sixCellWidth) +"px;" + "min-width:"+(sixCellWidth) +"px;";
		var eightcellStyle = "max-width:"+(eightCellWidth) +"px;" + "min-width:"+(eightCellWidth) +"px;";
		var tencellStyle = "max-width:"+(tenCellWidth) +"px;" + "min-width:"+(tenCellWidth) +"px;";
		var onetwocellStyle = "max-width:"+(onetwoCellWith) +"px;" + "min-width:"+(onetwoCellWith) +"px;";
		var onefourcellStyle = "max-width:"+(onefourCellWith) +"px;" + "min-width:"+(onefourCellWith) +"px;";
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
		$('.onetwotablecell').each(function(){
			var newStyle = onetwocellStyle;
			$(this).attr('style',newStyle);
		});
		$('.onefourtablecell').each(function(){
			var newStyle = onefourcellStyle;
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
	$('.salefigureMenuTile').hover(function(){
		var obj = $(this).find('.salefigure_submenu');
		$(obj).show();
	},
	function(){
		var obj = $(this).find('.salefigure_submenu');
		$(obj).hide();
	});
	$('#exportTable').click(function(){
	    if($('#tableArea').is(':empty')){
                    alert('There is no table!');
        }else{
		    var outputFile = 'file.csv'
            exportTableToCSV.apply(this, [$('#theTable'), outputFile]);
        }
	});
});
function regionTableGenerator(allFigures,allTargets){
	var str = "";
	var showroomlist = allTargetsData.showroomList;
	str += '<table id="theTable"><thead><tr><th class = "tablecell emptycell topcell leftcell">' +
			'<a href="#" onclick="previousYearOnclick();return false;" id="previousyear" data-start-year=""><img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/arrow-up.png" alt="previousYear" width="40" height="21"/></a></th>' + 
			'<th class = "tablecell emptycell topcell leftcell"></th>' +
			'<th class = "<?php echo $titlecell;?> bordercell nobottomcell">SAVOIR BEDS <?php echo $title;?></th></tr>' +	
			'<tr><th class = "tablecell emptycell bordercell"></th>' +
			'<th class = "tablecell emptycell bordercell"></th>';
	var sKey=0;
	for(sKey in showroomlist){	
		str += '<th class = "twotablecell bordercell nobottomcell">' + showroomlist[sKey] + '</th>';
	}
	str += '<th class = "twotablecell leftcell bottomcell nobottomcell orangecell">Monthly Total</th>' +
			'<th class = "twotablecell leftcell rightcell bottomcell nobottomcell lightgreencell">Yearly Total</th></tr>' +
			'<tr style="background-color:white;">' +
			'<th class = "tablecell leftcell bottomcell">Year</th>' +
			'<th class = "tablecell leftcell bottomcell">Month</th>';
	var sk = 0;
	for(sk in showroomlist){
		str += '<th class = "tablecell bordercell">Target</th>' +
				'<th class = "tablecell bordercell">Actual</th>';
	}
	str += '<th class = "tablecell bordercell orangecell">Target</th>' +
			'<th class = "tablecell bordercell orangecell">Actual</th>' +
			'<th class = "tablecell bordercell lightgreencell">Target</th>' +
			'<th class = "tablecell bordercell lightgreencell">Actual</th></tr></thead><tbody id="datatable">';
	var thisYear = new Date().getFullYear();
	var thisMonth = new Date().getMonth()+1;
	var yearKey=0;
	for(yearKey in allFigures){
		var monthKey;
		var tempYearFigures = allFigures[yearKey];
		var tempYearTargets = allTargets[yearKey];
		var yearTotal = 0.00;
		var yearTargetTotal = 0.00;
		var yearShowroomTotal=zeroGenerator(allTargetsData.regionKey);
		var yearShowroomTargetTotal=zeroGenerator(allTargetsData.regionKey);
		var yearShowroomTotalToDate=zeroGenerator(allTargetsData.regionKey);
		var yearShowroomTargetTotalToDate=zeroGenerator(allTargetsData.regionKey);
		for(monthKey in tempYearFigures){
			var tempMonthFigures = tempYearFigures[monthKey];
			var tempMonthTargets = tempYearTargets[monthKey];
			if(monthKey == 12){
				str += '<tr><td class = "tablecell leftcell bottomcell">' + yearKey + '</td>';
			}
			else{
				str += '<tr><td class = "tablecell emptycell leftcell"></td>';
			}
			var monthTotal = 0.00;
			var monthTargetTotal = 0.00;
			str += '<td class = "tablecell bordercell">' + getMonth(monthKey) + '</td>';
			for (showroomKey in tempMonthFigures){
				monthTotal += tempMonthFigures[showroomKey];
				monthTargetTotal += tempMonthTargets[showroomKey]['amount'];
				yearShowroomTotal[showroomKey] += tempMonthFigures[showroomKey];
				yearShowroomTargetTotal[showroomKey] += tempMonthTargets[showroomKey]['amount'];
				if(yearKey == thisYear){
					if(monthKey<=thisMonth){
						yearShowroomTotalToDate[showroomKey] += tempMonthFigures[showroomKey];
						yearShowroomTargetTotalToDate[showroomKey] += tempMonthTargets[showroomKey]['amount'];
					}
				}
				else{
					yearShowroomTotalToDate[showroomKey] += tempMonthFigures[showroomKey];
					yearShowroomTargetTotalToDate[showroomKey] += tempMonthTargets[showroomKey]['amount'];
				}
				var differencePercent = 0;
				if(tempMonthTargets[showroomKey]['amount'] != 0){
					differencePercent = Math.round((tempMonthFigures[showroomKey] - tempMonthTargets[showroomKey]['amount'])*100/tempMonthTargets[showroomKey]['amount']);
				}
				//console.log('this is key' + showroomKey);
				//console.log(zeroA[showroomKey]);
				str += '<td class = "tablecell bordercell">' +
						'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+','+showroomKey+',this);return false;" ' +
						'type="text" value="'+ tempMonthTargets[showroomKey]['amount'] +'" disabled/></td>';
				str += '<td class = "tablecell bordercell">' + tempMonthFigures[showroomKey] + ' (' + differencePercent + '%)' + '</td>';
			}
			yearTotal += monthTotal;
			yearTargetTotal += monthTargetTotal;
			str += '<td class = "tablecell bordercell orangecell">' + Math.round(monthTargetTotal*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell orangecell">' + Math.round(monthTotal*100)/100 + '</td>';
			if(monthKey == 12){
				str += '<td class = "tablecell emptycell rightcell bottomcell lightgreencell">'+ Math.round(yearTargetTotal*100)/100 +'</td>';
				str += '<td class = "tablecell emptycell rightcell bottomcell lightgreencell">' + Math.round(yearTotal*100)/100 + '</td></tr>';
			}
			else{
				str += '<td class = "tablecell emptycell rightcell lightgreencell"></td>';
				str += '<td class = "tablecell emptycell rightcell lightgreencell"></td></tr>';
			}
		}
		str += '<tr style="background-color:lightblue;"><td class = "tablecell leftcell topbottomcell"> YTD</td>';
		str += '<td class = "tablecell leftcell topbottomcell"></td>';
		var sk;
		for(sk in showroomlist){
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[sk]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[sk]*100)/100 + '</td>';
		
		}
		str += '<td class = "tablecell emptycell bordercell"></td>';
		str += '<td class = "tablecell emptycell bordercell"></td>';
		str += '<td class = "tablecell emptycell bordercell"></td>';
		str += '<td class = "tablecell emptycell bordercell"></td></tr>';	
		

		str += '<tr style="background-color:lightblue;"><td class = "tablecell leftcell topbottomcell"> TOTAL</td>';
		str += '<td class = "tablecell leftcell topbottomcell"></td>';
		var ssk;
		for(ssk in showroomlist){
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[ssk]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[ssk]*100)/100 + '</td>';
		}
		str += '<td class = "tablecell emptycell bordercell"></td>';
		str += '<td class = "tablecell emptycell bordercell"></td>';
		str += '<td class = "tablecell emptycell bordercell"></td>';
		str += '<td class = "tablecell emptycell bordercell"></td></tr>';	
	}
	str += '</tbody>';
		str += '<tbody><tr><td class = "tablecell leftcell topbottomcell">'+
		'<a href="#" onclick="nextYearOnclick();return false;" id="nextyear" data-start-year=""><img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/arrow-down.png" alt="nextYear" width="40" height="21"/></a></td>';
		str += '<td class = "tablecell leftcell topbottomcell"></td>' +
			'<td class = "<?php echo $titlecell;?> bordercell "></td></tr></tbody></table>';
	return str;
}

function getMonth(monthKey){
	var key = parseInt(monthKey);
	switch(key){
		case 1:
			return 'JAN';
			break;
		case 2:
			return 'FEB';
			break;
		case 3:
			return 'MAR';
			break;
		case 4:
			return 'APR';
			break;
		case 5:
			return 'MAY';
			break;
		case 6:
			return 'JUN';
			break;
		case 7:
			return 'JUL';
			break;
		case 8:
			return 'AUG';
			break;
		case 9:
			return 'SEP';
			break;
		case 10:
			return 'OCT';
			break;
		case 11:
			return 'NOV';
			break;
		case 12:
			return 'DEC';
			break;
	}
}
function zeroGenerator(regionName){
    switch(regionName){
    case 'uk':
        return {'3':0,'4':0,'36':0,'27':0};
        break;
    case 'europe':
        return {'24':0,'17':0,'29':0,'25':0};
        break;
    case 'northamerica':
        return {'34':0,'8':0};
        break;
    case 'asia':
        return {'33':0,'26':0,'31':0,'21':0,'28':0};
        break;
    }
}
</script>
