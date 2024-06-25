<?php
use Cake\Core\Configure;
use Cake\Routing\Router;
?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('salefigures.css',array('inline' => false));?>
<?php echo $this->Html->script('htmlToJS.js', array('inline' => false)); ?>


<script type="text/javascript">
allTargetsData = {
	originalTarget:-1,
	updatedTargets:-1,
	realFigure: -1,
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
		if(this.updatedTargets != -1){
			var sendbackData = JSON.stringify(this.updatedTargets);
			$.ajax({
				method:"post",
				data:{"type":"world","newtarget":sendbackData},
				url:"<?php echo Router::url('/', true);?>saleFigures/updatetarget",
				success:function(data){
					var target = JSON.parse(data);
					//console.log(data);
					thisObj.updateData(target,thisObj.realFigure);
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
				data:{"startyear":startyear},
				url:"<?php echo Router::url('/', true);?>saleFigures/world",
				success:function(data){
					var rawData = JSON.parse(data);
					var requestYear = rawData.requestyear;
					var allFigures = rawData.data;
					var targets = rawData.target;
					allTargetsData.updateData(targets,allFigures);
					var table = worldTableGenerator(allFigures,targets);
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
				data:{"startyear":startyear},
				url:"<?php echo Router::url('/', true);?>saleFigures/world",
				success:function(data){
					var rawData = JSON.parse(data);
					var requestYear = rawData.requestyear;
					var allFigures = rawData.data;
					var targets = rawData.target;
					allTargetsData.updateData(targets,allFigures);
					var table = worldTableGenerator(allFigures,targets);
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
		standardWidth = Math.round((standardWidth-100)*0.88/34);
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
	$('.table_world_request').click(function(){
		var startyear = parseInt($('#thisyear').val());
		var previousYear = startyear-3;
		$.ajax({
			method:"post",
			data:{"startyear":startyear},
			url:"<?php echo Router::url('/', true);?>saleFigures/world",
			success:function(data){
				var rawData = JSON.parse(data);
				var requestYear = rawData.requestyear;
				var allFigures = rawData.data;
				var targets = rawData.target;
				allTargetsData.updateData(targets,allFigures);
				//console.log(allTargetsData);
				var table = worldTableGenerator(allFigures,targets);
				$('#tableArea').empty();
				$('#tableArea').append(table);
				$('#previousyear').attr('data-start-year',previousYear);
				$('#nextyear').attr('data-start-year',startyear+1);
				adjustTable();
			}
		});
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
function worldTableGenerator(allFigures,allTargets){
	var str = "";
	str += '<table id="theTable"><thead><tr><th class = "tablecell emptycell topcell leftcell">' +
			'<a href="#" onclick="previousYearOnclick();" id="previousyear" data-start-year=""><img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/arrow-up.png" alt="previousYear" width="40" height="21"/></a></th>' + 
			'<th class = "tablecell emptycell topcell leftcell"></th>' +
			'<th class = "threetwotablecell bordercell nobottomcell">SAVOIR BEDS</th></tr>' +
			'<tr style="background-color:white;">' +
			'<th class = "tablecell emptycell leftcell"></th>' +
			'<th class = "tablecell emptycell leftcell"></th>' +
			'<th class = "eighttablecell bordercell nobottomcell">UK (GBP)</th>' +
			'<th class = "sixtablecell bordercell nobottomcell">EUROPE (EUR)</th>' +
			'<th class = "fourtablecell bordercell nobottomcell">NORTH AMERICA (USD)</th>' +
			'<th class = "tentablecell bordercell nobottomcell">ASIA (GBP)</th>' +
			'<th class = "twotablecell emptycell bordercell nobottomcell orangecell"></th>' +
			'<th class = "twotablecell emptycell bordercell nobottomcell lightgreencell"></th></tr>' +
			'<tr><th class = "tablecell emptycell leftcell"></th>' +
			'<th class = "tablecell emptycell leftcell"></th>' +
			'<th class = "twotablecell bordercell nobottomcell">Wigmore Street</th>' +
			'<th class = "twotablecell bordercell nobottomcell">Chelsea Harbour</th>' +
			'<th class = "twotablecell bordercell nobottomcell">Harrods</th>' +
			'<th class = "twotablecell bordercell nobottomcell">Cardiff</th>' +
			'<th class = "twotablecell bordercell nobottomcell">Dusseldorf</th>' +
			'<th class = "twotablecell bordercell nobottomcell">Paris</th>' +
			'<th class = "twotablecell bordercell nobottomcell">St. Petersburg</th>' +
			'<th class = "twotablecell bordercell nobottomcell">NY Uptown</th>' +
			'<th class = "twotablecell bordercell nobottomcell">NY Downtown</th>' +
			'<th class = "twotablecell bordercell nobottomcell">Hong Kong</th>' +
			'<th class = "twotablecell bordercell nobottomcell">Beijing</th>' +
			'<th class = "twotablecell bordercell nobottomcell">Seoul</th>' +
			'<th class = "twotablecell bordercell nobottomcell">Shanghai</th>' +
			'<th class = "twotablecell bordercell nobottomcell">Taipei</th>' +
			'<th class = "twotablecell leftcell bottomcell nobottomcell orangecell">Monthly Total</th>' +
			'<th class = "twotablecell leftcell rightcell bottomcell nobottomcell lightgreencell">Yearly Total</th></tr>' +
			'<tr style="background-color:white;">' +
			'<th class = "tablecell leftcell bottomcell">Year</th>' +
			'<th class = "tablecell leftcell bottomcell">Month</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell">Target</th>' +
			'<th class = "tablecell bordercell">Actual</th>' +
			'<th class = "tablecell bordercell orangecell">Target</th>' +
			'<th class = "tablecell bordercell orangecell">Actual</th>' +
			'<th class = "tablecell bordercell lightgreencell">Target</th>' +
			'<th class = "tablecell bordercell lightgreencell">Actual</th></tr></thead><tbody id="datatable">';
	var thisYear = new Date().getFullYear();
	var thisMonth = new Date().getMonth()+1;
	var yearKey;
	for(yearKey in allFigures){
		var monthKey;
		var tempYearFigures = allFigures[yearKey];
		var tempYearTargets = allTargets[yearKey];
		var yearTotal = 0.00;
		var yearTargetTotal = 0.00;
		var yearShowroomTotal={3:0,36:0,4:0,27:0,24:0,17:0,29:0,25:0,34:0,8:0,33:0,31:0,21:0,28:0,22:0,26:0};
		var yearShowroomTargetTotal={3:0,36:0,4:0,27:0,24:0,17:0,29:0,25:0,34:0,8:0,33:0,31:0,21:0,28:0,22:0,26:0};
		var yearShowroomTotalToDate={3:0,36:0,4:0,27:0,24:0,17:0,29:0,25:0,34:0,8:0,33:0,31:0,21:0,28:0,22:0,26:0};
		var yearShowroomTargetTotalToDate={3:0,36:0,4:0,27:0,24:0,17:0,29:0,25:0,34:0,8:0,33:0,31:0,21:0,28:0,22:0,26:0};
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
			}
			yearTotal += monthTotal;
			yearTargetTotal += monthTargetTotal;
			str += '<td class = "tablecell bordercell">' + getMonth(monthKey) + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',3,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[3]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[3] + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',36,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[36]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[36] + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',4,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[4]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[4] + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',27,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[27]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[27] + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',24,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[24]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[24] + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',17,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[17]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[17] + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',29,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[29]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[29] + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',25,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[25]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[25] + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',34,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[34]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[34] + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',8,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[8]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[8] + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',33,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[33]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[33] + '</td>';
			str += '<td class = "tablecell bordercell">';
			var beijingT = tempMonthTargets[22]['amount'] + tempMonthTargets[26]['amount'];
			str += '<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',26,this);return false;" ' +
			'type="text" value="'+ beijingT +'" disabled/></td>';
			var beijing = tempMonthFigures[22] + tempMonthFigures[26];
			str += '<td class = "tablecell bordercell">' + beijing + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',31,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[31]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[31] + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',21,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[21]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[21] + '</td>';
			str += '<td class = "tablecell bordercell">' +
			'<input class="set_target disablebg" onchange="allTargetsData.changeTarget('+yearKey+','+monthKey+',28,this);return false;" ' +
			'type="text" value="'+ tempMonthTargets[28]['amount'] +'" disabled/></td>';
			str += '<td class = "tablecell bordercell">' + tempMonthFigures[28] + '</td>';
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
		
		str += '<tr style="background-color:lightblue;"><td class = "tablecell leftcell topbottomcell"> TTD</td>';
		str += '<td class = "tablecell leftcell topbottomcell"></td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[3]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[3]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[36]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[36]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[4]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[4]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[27]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[27]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[24]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[24]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[17]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[17]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[29]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[29]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[25]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[25]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[34]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[34]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[8]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[8]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[33]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[33]*100)/100 + '</td>';
			var beijingT = yearShowroomTargetTotalToDate[22] + yearShowroomTargetTotalToDate[26];
			str += '<td class = "tablecell bordercell">' + Math.round(beijingT*100)/100 + '</td>';
			var beijing = yearShowroomTotalToDate[22] + yearShowroomTotalToDate[26];
			str += '<td class = "tablecell bordercell">' + Math.round(beijing*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[31]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[31]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[21]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[21]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotalToDate[28]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotalToDate[28]*100)/100 + '</td>';
			str += '<td class = "tablecell emptycell bordercell"></td>';
			str += '<td class = "tablecell emptycell bordercell"></td>';
			str += '<td class = "tablecell emptycell bordercell"></td>';
			str += '<td class = "tablecell emptycell bordercell"></td></tr>';	
		

		str += '<tr style="background-color:lightblue;"><td class = "tablecell leftcell topbottomcell"> TOTAL</td>';
		str += '<td class = "tablecell leftcell topbottomcell"></td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[3]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[3]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[36]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[36]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[4]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[4]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[27]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[27]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[24]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[24]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[17]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[17]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[29]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[29]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[25]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[25]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[34]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[34]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[8]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[8]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[33]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[33]*100)/100 + '</td>';
			var beijingT = yearShowroomTargetTotal[22] + yearShowroomTargetTotal[26];
			str += '<td class = "tablecell bordercell">' + Math.round(beijingT*100)/100 + '</td>';
			var beijing = yearShowroomTotal[22] + yearShowroomTotal[26];
			str += '<td class = "tablecell bordercell">' + Math.round(beijing*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[31]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[31]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[21]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[21]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTargetTotal[28]*100)/100 + '</td>';
			str += '<td class = "tablecell bordercell">' + Math.round(yearShowroomTotal[28]*100)/100 + '</td>';
			str += '<td class = "tablecell emptycell bordercell"></td>';
			str += '<td class = "tablecell emptycell bordercell"></td>';
			str += '<td class = "tablecell emptycell bordercell"></td>';
			str += '<td class = "tablecell emptycell bordercell"></td></tr>';	
	}
	str += '</tbody>';
		str += '<tbody><tr"><td class = "tablecell leftcell topbottomcell">'+
		'<a href="#" onclick="nextYearOnclick();return false;" id="nextyear" data-start-year=""><img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/arrow-down.png" alt="nextYear" width="40" height="21"/></a></td>';
		str += '<td class = "tablecell leftcell topbottomcell"></td>' +
			'<td class = "eighttablecell bordercell "></td>' +
			'<td class = "sixtablecell bordercell "></td>' +
			'<td class = "fourtablecell bordercell "></td>' +
			'<td class = "tentablecell bordercell "></td>' +
			'<td class = "twotablecell emptycell bordercell "></td>' +
			'<td class = "twotablecell emptycell bordercell "></td></tr></tbody></table>';
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
</script>
<?php 

if($data == 'no'):
	echo "You don't have enough privilege to see this page.";
?>
<?php else:?>
<?php $acl = $data['acl'];?>
<div id="salefigureMenu">
	<ul>
		<li class="salefigureBigTile"><h3>Sale Figures</h3></li>
		<li class="salefigureMenuTile">
			 <a>WORLD</a>
			 <?php if($acl['issuperuser']):?>
			 <div class = "salefigure_submenu">
			 	<a class="table_world_request">Worldwide Sales</a>
			 </div>
			 <?php endif;?>
		</li>
		<li class="salefigureMenuTile">
			<a>UK</a>
			<div class = "salefigure_submenu">
			<?php if($acl['issuperuser']||$acl['region']=='uk'):?>
				<a class="table_region_request" data-region="uk">UK Sales</a>
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
				<a class="table_region_request" data-region="eu">Europe Sales</a>
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
				<a class="table_region_request" data-region="us">North America Sales</a>
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
				<a class="table_region_request" data-region="asia">Asia Sales</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='asia'||$acl['location']==33):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=33" class="table_showroom_request" data-region="33">Hong Kong</a>
			<?php endif;?>
			<?php if($acl['issuperuser']||$acl['region']=='asia'||$acl['location']==22||$acl['location']==26):?>
				<a href="<?php echo Router::url('/', true);?>saleFigures/showroom?sh=22" class="table_showroom_request" data-region="22">Beijing</a>
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
<div id="tableArea"></div>