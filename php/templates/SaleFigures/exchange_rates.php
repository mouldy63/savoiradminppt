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
	$acl = $data['acl'];
	$exchangeRate = $data['exchange_rate_array'];
	$currency_code_array = $data['currency_code_array'];
	$currentYear = (int)$data['requestyear'];
	$thisYear = (int)$data['thisyear'];
	echo $this->element('saleFiguresHeader', array("acl"=>$acl));
	echo $this->element('saleFiguresControllPannel',array("isExchangeRateTable"=>true));
?>
<input id="thisyear" type="hidden" value="<?php echo $data['thisyear'];?>"/>
<div id="tableArea" style="float:left">
<table id="theTable">
<thead>
	<tr>
		<th class = "tablecell bordercell">
		<select id="changeYear" onchange="changeYear(this);return false;";>
			<?php for($ii=$thisYear;$ii>=2012;$ii--):?>
				<?php if( $ii==$currentYear):?>
					<option value="<?php echo $ii;?>" selected><?php echo $ii;?></option>
				<?php else:?>
					<option value="<?php echo $ii;?>"><?php echo $ii;?></option>
				<?php endif;?>
			<?php endfor;?>
		</select></th>
		<?php foreach($currency_code_array as $currency_code):?>
			<th class = "tablecell bordercell"><?php echo $currency_code["currency_code"];?></th>
		<?php endforeach; ?>
	</tr>
</thead>
<tbody id="datatable">
<?php foreach($exchangeRate[$currentYear] as $monthKey=>$tempMonthRate):?>
	<tr>
		<td class = "tablecell bordercell"><?php echo getMonth($monthKey);?></td>
		<?php foreach($currency_code_array as $cCode):?>
		<td class = "tablecell bordercell">
		<input class="set_target disablebg" onchange="allTargetsData.changeTarget(
			<?php echo $currentYear;?>,<?php echo $monthKey;?>,'<?php echo $cCode["currency_code"];?>',this);return false;" type="text" value="<?php echo $tempMonthRate[$cCode["currency_code"]]['amount']; ?>" disabled/></td>
		<?php endforeach;?>
	</tr>
<?php endforeach;?>
</tbody>
</table>
</div>
<div class="clear"></div>

<script type="text/javascript">
$(window).resize(function(){
	adjustTable();
});
$(document).ready(function(){
	adjustTable();
});

allTargetsData = {
	originalTarget:<?php echo json_encode($exchangeRate);?>,
	updatedTargets:<?php echo json_encode($exchangeRate);?>,
	isTableChanged: function(){
		if(this.updatedTargets == -1){
			return false;
		}
		else{
			for (var k in this.updatedTargets) {
		        var tempYear = this.updatedTargets[k];
		        for(var t in tempYear){
		        	var tempMonth = tempYear[t];
		        	var usd = tempMonth['USD'];
		        	var eur = tempMonth['EUR'];
	        		if((usd && usd['changed'] == 'y') || (eur && eur['changed'] == 'y')){
		        				return true;
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
	changeTarget: function(year,month,countryCode,element){
		var y = parseInt(year);
		var m = parseInt(month);
		var value = $(element).val();
		if(this.inputValidation(value)){
			this.updatedTargets[y][m][countryCode]['amount']=value;
			this.updatedTargets[y][m][countryCode]['changed']='y';
			if(!$(element).hasClass('changed')){
			}
			$(element).addClass('changed');
		}
		else{
			$(element).val('0');
			alert("please enter digits and don't use ','.");
		}
	},
	updateData: function(target){
		this.originalTarget = target;
		this.updatedTargets = target;
	},
	saveToDB: function(){
		var thisObj = this;
		var requestYear = $('#changeYear').val();
		console.log(this.updatedTargets);
		if(this.updatedTargets != -1){
			var sendbackData = JSON.stringify(this.updatedTargets);
			$.ajax({
				method:"post",
				data:{"requestYear":requestYear,"newtarget":sendbackData},
				url:"<?php echo Router::url('/', true);?>saleFigures/updateExchangeRate",
				success:function(data){
					var target = JSON.parse(data);
					thisObj.updateData(target);
					thisObj.rebuildTable(target, requestYear);
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
	rebuildTable: function(target, requestYear){
		var table = worldTableGenerator(target.exchange_rate_array, target.currency_code_array, requestYear);
		$('#datatable').empty();
		$('#datatable').append(table);
		adjustTable();
	}
};

function changeYear(element){
	var requestYear = $(element).val();
	$.ajax({
				method:"post",
				data:{"startyear":requestYear},
				url:"<?php echo Router::url('/', true);?>saleFigures/exchangeRates",
				success:function(data){
					var rawData = JSON.parse(data);
					var requestYear = rawData.requestyear;
					var exchangeRate = rawData.exchange_rate_array;
					var currencyRateArray = rawData.currency_code_array;
					allTargetsData.updateData(exchangeRate);
					var table = worldTableGenerator(exchangeRate,currencyRateArray,requestYear);
					$('#datatable').empty();
					$('#datatable').append(table);
					adjustTable();
					$('#enableTableEdit').html('EDIT TABLE');
					$('#enableTableEdit').attr('data-current-status','disable');
					alert('This is records in '+ requestYear);
				}
			});
}
function worldTableGenerator(exchangeRate,currencyRateArray,requestYear){
	var str="";
	for(var monthKey in exchangeRate[requestYear]){
		tempMonthRate = exchangeRate[requestYear][monthKey];
		
		str += '<tr>';
		str += '<td class = "tablecell bordercell">' + getMonth(monthKey) + '</td>';
		for(c in currencyRateArray){
			var ccode = "'" + currencyRateArray[c]["currency_code"] + "'";
			str += '<td class = "tablecell bordercell">';
			str += '<input class="set_target disablebg" onchange="allTargetsData.changeTarget(';
			str += requestYear + ',' + monthKey + ',' + ccode + ',this);return false;" type="text" value="';
			str += tempMonthRate[currencyRateArray[c]["currency_code"]]['amount'] + '" disabled/></td>';
		}
		str += '</tr>';
	}
	return str;
}
function adjustTable(){
	var standardWidth = jQuery(window).width();
		standardWidth = Math.round((standardWidth-100)*0.9/6);
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