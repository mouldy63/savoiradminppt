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
else:
	$acl = $data['acl'];
	$figures = $data['data'];
	$target = $data['target'];
	$currentYear = (int)$data['thisyear'];
	$thisYear =  date('Y');
	$showroomId = (int)$data['showroomId'];
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
        <?php if($acl['issuperuser']):?>
        <div class="salefigureMenuTile">
            <a id="enableTableEdit" data-current-status="disable" onclick="inputController(this);">EDIT TABLE</a>
        </div>
        <?php endif;?>
        <div class="salefigureMenuTile">
            <a id="exportTable" href="#">EXPORT TABLE</a>
        </div>
</div>
<?php endif;?>
<input id="thisyear" type="hidden" value="<?php echo $data['thisyear'];?>"/>
<input id="showroomId" type="hidden" value="<?php echo $data['showroomId'];?>"/>
<div id="tableArea">
	<table id="theTable">
		<thead>
			<tr>
				<th class = "sixtablecell bordercell"><h2><?php echo $data['showroom']; ?></h2></th>
			</tr>
			<tr>
				<th class = "tablecell leftcell rightcell topcell emptycell"><a href="#" onclick="previousYearOnclick();return false;" id="previousyear" data-start-year="<?php echo $currentYear-1<2010?2010:$currentYear-1; ?>"><img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/arrow-up.png" alt="previousYear" width="40" height="21"/></a></th>
				<th class = "tablecell leftcell rightcell topcell emptycell"></th>
				<th class = "tablecell leftcell rightcell topcell emptycell"></th>
				<th class = "tablecell leftcell rightcell topcell emptycell"></th>
				<th class = "twotablecell bordercell">Difference</th>
			</tr>
			<tr>
				<th class = "tablecell bordercell">Year</th>
				<th class = "tablecell bordercell">Month</th>
				<th class = "tablecell bordercell">Target</th>
				<th class = "tablecell bordercell">Actual</th>
				<th class = "tablecell bordercell">GBP</th>
				<th class = "tablecell bordercell">PERCENTAGE</th>
			</tr>
		</thead>
		<tbody id="datatable">
		<?php
		    $tempTargetSum = 0;
		    $tempActualSum = 0;
		    $tempDifferenceSum = 0;
		    foreach($figures as $year=>$yearData):
				foreach($yearData as $month=>$monthData):
					foreach($monthData as $showroom=>$showroomData):
		?>
		<tr>
			<?php if($month ==12):?>
			<td class = "tablecell leftcell rightcell bottomcell"><?php echo $year;?></td>
			<?php else:?>
			<td class = "tablecell leftcell rightcell emptycell"></td>
			<?php endif;?>
			<td class = "tablecell bordercell"><?php echo getMonth($month);?></td>
			<?php
			    if($acl['issuperuser']){
			        $targetOutput = '<input class="set_target disablebg" onchange="allTargetsData.changeTarget('.$year.','.$month.','.$showroom.',this);return false;" type="text" value="'.$target[$year][$month][$showroom]["amount"].'" disabled/>';
			    }else{
			        $targetOutput = $target[$year][$month][$showroom]['amount'];
			    }
			?>
			<td class = "tablecell bordercell"><?php echo $targetOutput; ?></td>
			<td class = "tablecell bordercell"><?php echo $showroomData;?></td>
			<?php $difference = round(((float)$showroomData - (float)$target[$year][$month][$showroom]['amount']),2);
			      $tempTargetSum += (float)$target[$year][$month][$showroom]['amount'];
			      $tempActualSum += (float)$showroomData;
			      $tempDifferenceSum += (float)$difference;
			      if((float)$target[$year][$month][$showroom]['amount']==0){
			        $percentage = 0;
			      }else{
			        $percentage = round(($difference/(float)$target[$year][$month][$showroom]['amount'])*100,2);
			      }

			?>
			<td class = "tablecell bordercell"><?php echo $difference;?></td>
			<td class = "tablecell bordercell"><?php echo $percentage.'%';?></td>
		</tr>
		<?php endforeach;endforeach;endforeach;?>
			<tr style="background-color:lightblue;">
				<td class="tablecell bordercell"><a href="#" onclick="nextYearOnclick();return false;" id="nextyear" data-start-year="<?php echo $currentYear+1>$thisYear?$thisYear:$currentYear+1; ?>"><img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/arrow-down.png" alt="nextYear" width="40" height="21"/></a></td>
				<td class="tablecell bordercell">Total:</td>
				<td class = "tablecell bordercell"><?php echo round($tempTargetSum * 100)/100;?></td>
				<td class = "tablecell bordercell"><?php echo round($tempActualSum * 100)/100;?></td>
				<td class = "tablecell bordercell"><?php echo round($tempDifferenceSum * 100)/100;?></td>
				<td class = "tablecell bordercell"></td>
			</tr>
		</tbody>
	</table>
</div>


<script type="text/javascript">
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
			    var outputFile = 'world.csv'
	            exportTableToCSV.apply(this, [$('#theTable'), outputFile]);
	        }
		});
	});
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
	function adjustTable(){
	var standardWidth = jQuery(window).width();
		standardWidth = Math.round((standardWidth-100)*0.85/6);
	var padding = 3;
	var border = 1;
		
		var twoCellWidth = standardWidth*2 + padding*2 + border;
		var fourCellWidth = twoCellWidth*2 + padding*2 + border;
		var sixCellWidth = twoCellWidth*3 + padding*4 + border*2;
		var eightCellWidth = fourCellWidth*2 + padding*2 + border;
		var tenCellWidth = twoCellWidth*5 + padding*8 + border*4;
		var onesixCellWidth = eightCellWidth*2 + padding*2 + border;
		var threetwoCellWidth = onesixCellWidth*2 + padding*2 + border;
		
		var cellStyle = "max-width:"+standardWidth +"px;" + "min-width:"+standardWidth +"px;";
		var twocellStyle = "max-width:"+(twoCellWidth) +"px;" + "min-width:"+(twoCellWidth) +"px;";
		var fourcellStyle = "max-width:"+(fourCellWidth) +"px;" + "min-width:"+(fourCellWidth) +"px;";
		var sixcellStyle = "max-width:"+(sixCellWidth) +"px;" + "min-width:"+(sixCellWidth) +"px;";
		var eightcellStyle = "max-width:"+(eightCellWidth) +"px;" + "min-width:"+(eightCellWidth) +"px;";
		var tencellStyle = "max-width:"+(tenCellWidth) +"px;" + "min-width:"+(tenCellWidth) +"px;";
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
		$('.threetwotablecell').each(function(){
			var newStyle = threetwocellStyle;
			$(this).attr('style',newStyle);
		});		
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
	function previousYearOnclick(){
    		var thisyear = parseInt($('#thisyear').val());
    		var startyear = parseInt($('#previousyear').attr('data-start-year'));
    		if(startyear >=2010){
    			var previousYear = startyear-1;
    			var nextYear = startyear+1;
    			$.ajax({
    				method:"post",
    				data:{"startyear":startyear,"showroom":<?php echo $showroomId;?>},
    				url:"<?php echo Router::url('/', true);?>saleFigures/showroom",
    				success:function(data){

    					var rawData = JSON.parse(data);
    					//console.log(rawData);
    					var requestYear = rawData.requestyear;
    					var allFigures = rawData.data;
    					var targets = rawData.target;
    					allTargetsData.updateData(targets,allFigures);
    					var table = showroomTableGenerator(allFigures,targets);
    					$('#datatable').empty();
    					$('#datatable').append(table);
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
    			var previousYear = (startyear-1);
    			var nextYear = (startyear+1);
    			$.ajax({
    				method:"post",
    				data:{"startyear":startyear,"showroom":<?php echo $showroomId;?>},
    				url:"<?php echo Router::url('/', true);?>saleFigures/showroom",
    				success:function(data){
    					var rawData = JSON.parse(data);
    					var requestYear = rawData.requestyear;
    					var allFigures = rawData.data;
    					var targets = rawData.target;
    					allTargetsData.updateData(targets,allFigures);
    					var table = showroomTableGenerator(allFigures,targets);
    					$('#datatable').empty();
    					$('#datatable').append(table);
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
    var allTargetsData = {
    	originalTarget:<?php echo json_encode($target);?>,
    	updatedTargets:<?php echo json_encode($target);?>,
    	realFigure:<?php echo json_encode($figures);?>,
    	acl:<?php echo json_encode($acl);?>,
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
    		var showroomId = $("#showroomId").val();
    		var previousyear = parseInt($('#previousyear').attr('data-start-year'));
            var nextyear = parseInt($('#nextyear').attr('data-start-year'));
    		if(this.updatedTargets != -1){
    			var sendbackData = JSON.stringify(this.updatedTargets);
    			$.ajax({
    				method:"post",
    				data:{"newtarget":sendbackData,"type":"showroom","detail":<?php echo $showroomId;?>},
    				url:"<?php echo Router::url('/', true);?>saleFigures/updatetarget",
    				success:function(data){
    					var target = JSON.parse(data);
    					thisObj.updateData(target,thisObj.realFigure);
    					thisObj.rebuildTable();
    					$('#previousyear').attr('data-start-year',previousyear);
                        $('#nextyear').attr('data-start-year',nextyear);
    					alert("data has been saved successfully.");
    				}
    			});
    		}
    		else{
    			alert('No data to be saved.');
    		}
    	},
    	rebuildTable: function(){
    		//console.log(this.realFigure);
    		var table = showroomTableGenerator(this.realFigure,this.originalTarget);
    		$('#datatable').empty();
    		$('#datatable').append(table);
    		adjustTable();
    	}
    };

    function showroomTableGenerator(allFigures,allTargets){
    	var str = "";
    	var tempTargetSum = 0;
        var tempActualSum = 0;
        var tempDifferenceSum = 0;
        var yearKey;
        console.log(allTargets);
        for(yearKey in allFigures){
            var tempYearFigures = allFigures[yearKey];
            var tempYearTargets = allTargets[yearKey];
            var monthKey;
            for(monthKey in tempYearFigures){
                var tempMonthFigures = tempYearFigures[monthKey];
                var tempMonthTargets = tempYearTargets[monthKey];
                var showroomKey;
                for(showroomKey in tempMonthFigures){

               		str += '<tr>';
               	    if(monthKey ==12){
               			str += '<td class = "tablecell leftcell rightcell bottomcell">' + yearKey + '</td>';
               		}
               		else{
               			str += '<td class = "tablecell leftcell rightcell emptycell"></td>';
               		}
               		str += '<td class = "tablecell bordercell">' + getMonth(monthKey) + '</td>';
               		if(allTargetsData.acl['issuperuser']){
                    	str += '<td class = "tablecell bordercell"><input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+','+showroomKey+',this);return false;" type="text" value="' + allTargets[yearKey][monthKey][showroomKey]['amount'] + '" disabled/></td>';
                    }else{
                    	str += '<td class = "tablecell bordercell">' + allTargets[yearKey][monthKey][showroomKey]['amount'] + '</td>';
                    }
               		str += '<td class = "tablecell bordercell">' + tempMonthFigures[showroomKey] + '</td>';
               		var difference = Math.round((parseFloat(tempMonthFigures[showroomKey]) - parseFloat(allTargets[yearKey][monthKey][showroomKey]['amount']))*100)/100;
               	    tempTargetSum += parseFloat(allTargets[yearKey][monthKey][showroomKey]['amount']);
               		tempActualSum += parseFloat(tempMonthFigures[showroomKey]);
               		tempDifferenceSum += difference;
               		var percentage;
               	    if(parseFloat(allTargets[yearKey][monthKey][showroomKey]['amount'])==0){
               		    percentage = 0;
               		}else{
               			percentage = Math.round(difference/parseFloat(allTargets[yearKey][monthKey][showroomKey]['amount'])*100);
               		}
               		str += '<td class = "tablecell bordercell">'+ difference + '</td>';
               		str += '<td class = "tablecell bordercell">'+ percentage + '%' + '</td></tr>';
                }
            }
        }
        str += '<tr style="background-color:lightblue;">';
        str += '<td class="tablecell bordercell">' +
               '<a href="#" onclick="nextYearOnclick();return false;" id="nextyear" data-start-year=""><img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/arrow-down.png" alt="nextYear" width="40" height="21"/></a></td>';
        str += '<td class="tablecell bordercell">Total:</td>';
        str += '<td class = "tablecell bordercell">' + Math.round(tempTargetSum * 100)/100 + '</td>';
        str += '<td class = "tablecell bordercell">' + Math.round(tempActualSum * 100)/100 + '</td>';
        str += '<td class = "tablecell bordercell">' + Math.round(tempDifferenceSum * 100)/100 + '</td>';
        str += '<td class = "tablecell bordercell"></td></tr>';
        return str;
    }
</script>