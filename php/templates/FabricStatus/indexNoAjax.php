<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>

<script type="text/javascript">
jQuery(document).ready(function(){
	tableAdjustment.resizeTable();
	jQuery('.filter-option').click(function(){
		jQuery('.filter-option').removeClass('filter-selected');
		jQuery(this).addClass('filter-selected');
	});
	jQuery('#fabricScreenTable').on( "mouseenter",'.fabricStatusCell',function(){
		var inforWindow = jQuery(this).find('.fabricStatusCellMoreInfo');
		var locX = 0;
		var locY = 0;
		jQuery(this).mousemove(function(e){
			locX = e.pageX + 50;
			locY = e.pageY + 50;
		});
		jQuery(inforWindow).css('left','50px');
		jQuery(inforWindow).css('top','30px');
		jQuery(inforWindow).show();
	});
	jQuery('#fabricScreenTable').on( "mouseleave",'.fabricStatusCell', function(){
		var inforWindow = jQuery(this).find('.fabricStatusCellMoreInfo');
		jQuery(inforWindow).removeAttr('style');
		jQuery(inforWindow).hide();
	});
});
jQuery(window).resize(function(){
	tableAdjustment.resizeTable();
});

var tableAdjustment = {
	data:<?php echo json_encode($msg)?>,
	filterParameter: -1,
	filteredData:-1,
	filterArray: function(parameter){
		this.filterParameter = parameter;
		this.filteredData = -1;
		var tempObj = [];
		var arr = this.data;
		if(parameter > 0){
			for(i=0;i<arr.length;i++){
				var tempRow = arr[i];
				if(tempRow["basefabric"]['fabricstatus']==parameter||
					tempRow["hbfabric"]['fabricstatus']==parameter||
					tempRow["salancefabric"]['fabricstatus']==parameter){
					tempObj.push(tempRow);
				}
			}
			this.filteredData = tempObj;
			this.refreshTable(tempObj);
			
		}
		else{
			this.refreshTable(arr);
		}
	},
	refreshTable:function(arr){
		jQuery('#tablebody').empty();	
		for(i=0;i<arr.length;i++){
			var content = this.createContent(arr[i]);
			jQuery('#tablebody').append(content);
		}
		this.resizeTable();
	},
	reOderArray:function(parameter,order){
		var arr = this.data;
		if(this.filterParameter>0){
			arr = this.filteredData;
		}
		for(i=0; i<arr.length-1;i++){
			if(arr[i][parameter] == null || arr[i][parameter].length == 0){
				arr[i][parameter]= '-1';
			}
			else{
				for(j=i+1;j<arr.length;j++){
					if(order == 'desc'){
						if(arr[i][parameter]<arr[j][parameter]){
							var temp = arr[i];
							arr[i] = arr[j];
							arr[j] = temp;
						}
					}
					else{
						if(arr[i][parameter]>arr[j][parameter]){
							var temp = arr[i];
							arr[i] = arr[j];
							arr[j] = temp;
						}
					}
				}
			}
		}
		this.refreshTable(arr);
	},
	
	createContent:function(row){
		var str = 	'<tr><td class="tablecell leftcell"'+
					'<a target="_blank" href="/editcust.asp?val=' + row["contact_no"] + '&tab=2#TabbedPanels1">' + row["customer"]+'</a></td>'+
					'<td class="tablecell">' + row["companyname"] + '</td>' +
					'<td class="tablecell">' + row["order_source"] + '</td>' +
					'<td class="tablecell">' + '<a target="_blank" href="/orderdetails.asp?pn='+ row["purchase_number"] +'">' + 
					row["order_number"] + '</a></td>' +
					'<td class="tablecell">' + row["order_date"] + '</td>' +
					'<td class="tablecell leftcell">' + row["basefabric"]["required"] + 
					'<br/><em style ="font-size:12px;font-weight:bold;">' + row["basefabric"]["qc_status_word"] + '</em></td>' +
					'<td class="tablecell">'+ row["basefabric"]['madeat'] + '</td>'; 
		var baseStyle='';
		var fabricStatusCell = '';
		switch(parseInt(row["basefabric"]['fabricstatus'])){
				  	case 7:
				  	baseStyle = 'greencell';
				  	break;
				  	case 5:
				  	baseStyle = 'greencell';
				  	break;
				  	case 8:
				  	baseStyle = 'transparentcell';
				  	break;
				  	case 4:
				  	baseStyle = 'yellowcell';
				  	break;
				  	case 3:
				  	baseStyle = 'redcell';
				  	break;
				  	default:
				  	baseStyle = '';
		}
		if(row["basefabric"]['fabricstatus'] == null || row["basefabric"]['fabricstatus'].length == 0){
			fabricStatusCell = '';
		}
		else{
			
			fabricStatusCell = 'fabricStatusCell';
		}
		str += '<td class="tablecell '+ fabricStatusCell + ' ' + baseStyle +'">' + row["basefabric"]['fabricstatus_word'];
		if(fabricStatusCell !=''){
			str += '<div class ="fabricStatusCellMoreInfo">' +
					'<p>Order Number: '+ row["order_number"] + '</p>' +
					'<p>Customer Surname: ' + row["basefabric"]['surname'] + '</p>';
		
			if (!(row["basefabric"]['supplier'] == null||row["basefabric"]['supplier'].length == 0)){
				str += '<p>Suplier: ' + row["basefabric"]['supplier'] + '</p>';
			}
			if (!(row["basefabric"]['ponumber'] == null||row["basefabric"]['ponumber'].length == 0)){
				str += '<p>Purchase Order No.: ' + row["basefabric"]['ponumber'] + '</p>';
			}
			if (!(row["basefabric"]['podate'] == null||row["basefabric"]['podate'].length == 0)){
				str += '<p>Purchase Date: ' + row["basefabric"]['podate'] + '</p>';
			}
			if (!(row["basefabric"]['expected'] == null||row["basefabric"]['expected'].length == 0)){
				str += '<p>Expected Date: ' + row["basefabric"]['expected'] + '</p>';
			}
			if (!(row["basefabric"]['received'] == null||row["basefabric"]['received'].length == 0)){
				str += '<p>Received Date: ' + row["basefabric"]['received'] + '</p>';
			}
			if (!(row["basefabric"]['cuttingsent'] == null||row["basefabric"]['cuttingsent'].length == 0)){
				str += '<p>Cutting Sent Date: ' + row["basefabric"]['cuttingsent'] + '</p>';
			}
			if (!(row["basefabric"]['confirm'] == null||row["basefabric"]['confirm'].length == 0)){
				str += '<p>Confirm Date: ' + row["basefabric"]['confirm'] + '</p>';
			}
			if (!(row["basefabric"]['tocardiff'] == null||row["basefabric"]['tocardiff'].length == 0)){
				str += '<p>Date to Cardiff: ' + row["basefabric"]['tocardiff'] + '</p>';
			}
			str += '</div>';
		}
		str += '</td>' +
				'<td class="tablecell leftcell">' + row["hbfabric"]['required'] +
				'<br/><em style ="font-size:12px;font-weight:bold;">' + row["hbfabric"]['qc_status_word'] + '</em></td>' +
				'<td class="tablecell">' + row["hbfabric"]['madeat'] + '</td>';
		var hbStyle = '';

		switch(parseInt(row["hbfabric"]['fabricstatus'])){
				  	case 7:
				  	hbStyle = 'greencell';
				  	break;
				  	case 5:
				  	hbStyle = 'greencell';
				  	break;
				  	case 8:
				  	hbStyle = 'transparentcell';
				  	break;
				  	case 4:
				  	hbStyle = 'yellowcell';
				  	break;
				  	case 3:
				  	hbStyle = 'redcell';
				  	break;
				  	default:
				  	hbStyle = '';
		}
		fabricStatusCell = '';
		if(row["hbfabric"]['fabricstatus'] == null || row["hbfabric"]['fabricstatus'].length == 0){
			fabricStatusCell = '';
		}
		else{
			fabricStatusCell = 'fabricStatusCell';
		}
		str += '<td class="tablecell ' + fabricStatusCell + ' ' + hbStyle + '">' + row["hbfabric"]['fabricstatus_word'];
		//console.log(fabricStatusCell);
		//console.log(fabricStatusCell !='');
		if(fabricStatusCell !=''){
			str += '<div class ="fabricStatusCellMoreInfo">' +
					'<p>Order Number: '+ row["order_number"] + '</p>' +
					'<p>Customer Surname: ' + row["hbfabric"]['surname'] + '</p>';
		
			if (!(row["hbfabric"]['supplier'] == null||row["hbfabric"]['supplier'].length == 0)){
				str += '<p>Suplier: ' + row["hbfabric"]['supplier'] + '</p>';
			}
			if (!(row["hbfabric"]['ponumber'] == null||row["hbfabric"]['ponumber'].length == 0)){
				str += '<p>Purchase Order No.: ' + row["hbfabric"]['ponumber'] + '</p>';
			}
			if (!(row["hbfabric"]['podate'] == null||row["hbfabric"]['podate'].length == 0)){
				str += '<p>Purchase Date: ' + row["hbfabric"]['podate'] + '</p>';
			}
			if (!(row["hbfabric"]['expected'] == null||row["hbfabric"]['expected'].length == 0)){
				str += '<p>Expected Date: ' + row["hbfabric"]['expected'] + '</p>';
			}
			if (!(row["hbfabric"]['received'] == null||row["hbfabric"]['received'].length == 0)){
				str += '<p>Received Date: ' + row["hbfabric"]['received'] + '</p>';
			}
			if (!(row["hbfabric"]['cuttingsent'] == null||row["hbfabric"]['cuttingsent'].length == 0)){
				str += '<p>Cutting Sent Date: ' + row["hbfabric"]['cuttingsent'] + '</p>';
			}
			if (!(row["hbfabric"]['confirm'] == null||row["hbfabric"]['confirm'].length == 0)){
				str += '<p>Confirm Date: ' + row["hbfabric"]['confirm'] + '</p>';
			}
			if (!(row["hbfabric"]['tocardiff'] == null||row["hbfabric"]['tocardiff'].length == 0)){
				str += '<p>Date to Cardiff: ' + row["hbfabric"]['tocardiff'] + '</p>';
			}
			str += '</div>';
		}
		str +=  '</td><td class="tablecell leftcell">' + row["salancefabric"]['required'] + 
				'<br/><em style ="font-size:12px;font-weight:bold;">' + row["salancefabric"]['qc_status_word'] + '</em></td>' +
				'<td class="tablecell">' + row["salancefabric"]['madeat'] + '</td>';
		var saStyle='';
		fabricStatusCell = ''
		switch(parseInt(row["salancefabric"]['fabricstatus'])){
				  	case 7:
				  	saStyle = 'greencell rightcell';
				  	break;
				  	case 5:
				  	saStyle = 'greencell rightcell';
				  	break;
				  	case 8:
				  	saStyle = 'style="transparentcell rightcell';
				  	break;
				  	case 4:
				  	saStyle = 'style="yellowcell rightcell';
				  	break;
				  	case 3:
				  	saStyle = 'style="redcell rightcell';
				  	break;
				  	default:
				  	saStyle = 'style="rightcell';
		}
		if(row["salancefabric"]['fabricstatus'] == null || row["salancefabric"]['fabricstatus'].length == 0){
			fabricStatusCell = '';
		}
		else{
			
			fabricStatusCell = 'fabricStatusCell';
		}
		str += '<td class="tablecell ' + fabricStatusCell + ' ' + saStyle + '">' + row["salancefabric"]['fabricstatus_word'];
		if(fabricStatusCell !=''){
			str += '<div class ="fabricStatusCellMoreInfo">' +
					'<p>Order Number: '+ row["order_number"] + '</p>' +
					'<p>Customer Surname: ' + row["salancefabric"]['surname'] + '</p>';
		
			if (!(row["salancefabric"]['supplier'] == null||row["salancefabric"]['supplier'].length == 0)){
				str += '<p>Suplier: ' + row["salancefabric"]['supplier'] + '</p>';
			}
			if (!(row["salancefabric"]['ponumber'] == null||row["salancefabric"]['ponumber'].length == 0)){
				str += '<p>Purchase Order No.: ' + row["salancefabric"]['ponumber'] + '</p>';
			}
			if (!(row["salancefabric"]['podate'] == null||row["salancefabric"]['podate'].length == 0)){
				str += '<p>Purchase Date: ' + row["salancefabric"]['podate'] + '</p>';
			}
			if (!(row["salancefabric"]['expected'] == null||row["salancefabric"]['expected'].length == 0)){
				str += '<p>Expected Date: ' + row["salancefabric"]['expected'] + '</p>';
			}
			if (!(row["salancefabric"]['received'] == null||row["salancefabric"]['received'].length == 0)){
				str += '<p>Received Date: ' + row["salancefabric"]['received'] + '</p>';
			}
			if (!(row["salancefabric"]['cuttingsent'] == null||row["salancefabric"]['cuttingsent'].length == 0)){
				str += '<p>Cutting Sent Date: ' + row["salancefabric"]['cuttingsent'] + '</p>';
			}
			if (!(row["salancefabric"]['confirm'] == null||row["salancefabric"]['confirm'].length == 0)){
				str += '<p>Confirm Date: ' + row["salancefabric"]['confirm'] + '</p>';
			}
			if (!(row["salancefabric"]['tocardiff'] == null||row["salancefabric"]['tocardiff'].length == 0)){
				str += '<p>Date to Cardiff: ' + row["salancefabric"]['tocardiff'] + '</p>';
			}
			str += '</div>';
		}
		str +=  '</td>' + 
				'<td class="tablecell">' + row["productiondate"] + '</td>' +
				'<td class="tablecell rightcell"' + row["bookeddeliverydate"] + '</td></tr>';
		for(i=0;i<5;i++){
			str +=  '<tr>' +
					'<td class="tablecell emptycell leftcell"></td>' +
					'<td class="tablecell emptycell"></td>' +
					'<td class="tablecell emptycell"></td>' +
					'<td class="tablecell emptycell"></td>' +
					'<td class="tablecell emptycell"></td>' +
					'<td class="tablecell emptycell leftcell"></td>' +
					'<td class="tablecell emptycell"></td>' +
					'<td class="tablecell emptycell"></td>' +
					'<td class="tablecell emptycell leftcell"></td>' +
					'<td class="tablecell emptycell"></td>' +
					'<td class="tablecell emptycell rightcell"></td>' +
					'<td class="tablecell emptycell"></td>' +
					'<td class="tablecell emptycell"></td>' +
					'<td class="tablecell emptycell"></td>' +
					'<td class="tablecell emptycell leftcell"></td>' +
					'<td class="tablecell emptycell rightcell"></td>' +
					'</tr>';
		}
		str +=  '<tr>' +
				'<td class="tablecell emptycell leftcell bottomcell"></td>' +
				'<td class="tablecell emptycell bottomcell"></td>' +
				'<td class="tablecell emptycell bottomcell"></td>' +
				'<td class="tablecell emptycell bottomcell"></td>' +
				'<td class="tablecell emptycell bottomcell"></td>' +
				'<td class="tablecell emptycell leftcell bottomcell"></td>' +
				'<td class="tablecell emptycell bottomcell"></td>' +
				'<td class="tablecell emptycell bottomcell"></td>' +
				'<td class="tablecell emptycell leftcell bottomcell"></td>' +
				'<td class="tablecell emptycell bottomcell"></td>' +
				'<td class="tablecell emptycell rightcell bottomcell"></td>' +
				'<td class="tablecell emptycell bottomcell"></td>' +
				'<td class="tablecell emptycell bottomcell"></td>' +
				'<td class="tablecell emptycell bottomcell"></td>' +
				'<td class="tablecell emptycell leftcell bottomcell"></td>' +
				'<td class="tablecell emptycell rightcell bottomcell"></td>' +
				'</tr>';
		//console.log(str.indexOf('null'));
		str = str.replace(/-1/g," ");
		str1 = str.replace(/null/g," ");
		str2 = str1.replace(/undefined/g," ");
		return str2;
	},
	
	resizeTable:function(){
		var standardWidth = jQuery(window).width();
		standardWidth = standardWidth*0.85/16;
		var cellStyle = "max-width:"+standardWidth +"px;" + "min-width:"+standardWidth +"px;";
		var threecellStyle = "max-width:"+(standardWidth*3) +"px;" + "min-width:"+(standardWidth*3) +"px;";
		var fivecellStyle = "max-width:"+(standardWidth*5+3) +"px;" + "min-width:"+(standardWidth*5+3) +"px;";
		jQuery('.tablecell').each(function(){
			var newStyle = cellStyle;
			var orignalStyle = jQuery(this).attr('style');
			newStyle += orignalStyle;
			jQuery(this).attr('style',newStyle);
		});
		jQuery('.threecell').each(function(){
			var newStyle = threecellStyle;
			var orignalStyle = jQuery(this).attr('style');
			newStyle += orignalStyle;
			jQuery(this).attr('style',newStyle);
		});
		jQuery('.fivecell').each(function(){
			var newStyle = fivecellStyle;
			var orignalStyle = jQuery(this).attr('style');
			newStyle += orignalStyle;
			jQuery(this).attr('style',newStyle);
		});
	}
}
</script>

<?php $this->Html->css('style');?>
<h3>Fabric Screen</h3>
<div id="navbuttom" style="text-align:right;">
<a href="/index.asp">Back to Main Menu</a>
<br/>
<a href='#'>Switch to Accessories Screen</a>
</div>
<div id ="filterSelection">
<p><span>Filter by: </span> 

<a href="#" class="filter-option" onclick="tableAdjustment.filterArray(1);return false;">TBC</a> 
&nbsp&nbsp&nbsp
<a href="#" class="filter-option" onclick="tableAdjustment.filterArray(3);return false;">Selected</a> 
&nbsp&nbsp&nbsp
<a href="#" class="filter-option" onclick="tableAdjustment.filterArray(4);return false;">On Order</a> 
&nbsp&nbsp&nbsp
<a href="#" class="filter-option" onclick="tableAdjustment.filterArray(7);return false;">Fabric Received</a> 
&nbsp&nbsp&nbsp
<a href="#" class="filter-option" onclick="tableAdjustment.filterArray(5);return false;">Not Approved, CFA Sent</a>
&nbsp&nbsp&nbsp
<a href="#" class="filter-option filter-selected" onclick="tableAdjustment.filterArray(-1);return false;">No Filter</a></p>
</div>
<table style="border-collapse: collapse;" id="fabricScreenTable">
<thead style="">
	<tr>
		<th class="tablecell nobottomcell leftcell topcell">
		</th>
		<th class="tablecell nobottomcell topcell">
		</th>
		<th class="tablecell nobottomcell topcell">
		</th>
		<th class="tablecell nobottomcell topcell">
		</th>
		<th class="tablecell nobottomcell topcell">
		</th>
		<th class="tablecell nobottomcell topcell leftcell">
		</th>
		<th class="tablecell nobottomcell topcell">
			BASE
		</th>
		<th class="tablecell nobottomcell topcell">
		</th>
		<th class="tablecell nobottomcell topcell leftcell">
		</th>
		<th class="tablecell nobottomcell topcell">
			HEADBOARD
		</th>
		<th class="tablecell nobottomcell topcell">
		</th>
		<th class="tablecell nobottomcell topcell leftcell">
		</th>
		<th class="tablecell nobottomcell topcell">
			VALANCE
		</th>
		<th class="tablecell rightcell nobottomcell topcell">
		</th>

		<th class="tablecell nobottomcell topcell" >
		</th>
		<th class="tablecell nobottomcell topcell">
		</th>
	</tr>
	<tr style="background-color:white;">
		<th class="tablecell nobottomcell leftcell">
			Customer
		</th>
		<th class="tablecell nobottomcell">
			Company
		</th>
		<th class="tablecell nobottomcell">
			Order Source
		</th>
		<th class="tablecell nobottomcell">
			Order Number
		</th>
		<th class="tablecell nobottomcell">
			Order Date
		</th>
		<th class="tablecell nobottomcell leftcell">
			Required
		</th>
		<th class="tablecell nobottomcell">
			Made At
		</th>
		<th class="tablecell nobottomcell">
			Fabric Status
		</th>
		<th class="tablecell nobottomcell leftcell">
			Required
		</th>
		<th class="tablecell nobottomcell">
			Made At
		</th>
		<th class="tablecell nobottomcell">
			Fabric Status
		</th>
		<th class="tablecell nobottomcell leftcell">
			Required
		</th>
		<th class="tablecell nobottomcell">
			Made At
		</th>
		<th class="tablecell nobottomcell rightcell">
			Fabric Status
		</th>
		<th class="tablecell nobottomcell">
			Production Date
		</th>
		<th class="tablecell nobottomcell rightcell">
			Booked Delivery Date
		</th>
	</tr>
	<tr>
		<th class="tablecell leftcell">
			<a href="#" onclick="tableAdjustment.reOderArray('customer','asce'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="">
			</a>
			<a href="#" onclick="tableAdjustment.reOderArray('customer','desc'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0">
			</a>
		</th>
		<th class="tablecell">
			<a href="#" onclick="tableAdjustment.reOderArray('companyname','asce'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="">
			</a>
			<a href="#" onclick="tableAdjustment.reOderArray('companyname','desc'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0">
			</a>
		</th>
		<th class="tablecell">
			<a href="#" onclick="tableAdjustment.reOderArray('order_source','asce'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="">
			</a>
			<a href="#" onclick="tableAdjustment.reOderArray('order_source','desc'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0">
			</a>
		</th>
		<th class="tablecell">
			<a href="#" onclick="tableAdjustment.reOderArray('order_number','asce'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="">
			</a>
			<a href="#" onclick="tableAdjustment.reOderArray('order_number','desc'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0">
			</a>
		</th>
		<th class="tablecell">
			<a href="#" onclick="tableAdjustment.reOderArray('order_date','asce'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="">
			</a>
			<a href="#" onclick="tableAdjustment.reOderArray('order_date','desc'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0">
			</a>
		</th>
		<th class="tablecell leftcell">
		</th>
		<th class="tablecell">
		</th>
		<th class="tablecell">
		</th>
		<th class="tablecell leftcell">
		</th>
		<th class="tablecell">
		</th>
		<th class="tablecell">
		</th>
		<th class="tablecell leftcell">
		</th>
		<th class="tablecell">
		</th>
		<th class="tablecell rightcell">
		</th>
		<th class="tablecell">
			<a href="#" onclick="tableAdjustment.reOderArray('productiondate','asce'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="">
			</a>
			<a href="#" onclick="tableAdjustment.reOderArray('productiondate','desc'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0">
			</a>
		</th>
		<th class="tablecell rightcell">
			<a href="#" onclick="tableAdjustment.reOderArray('bookeddeliverydate','asce'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="">
			</a>
			<a href="#" onclick="tableAdjustment.reOderArray('bookeddeliverydate','desc'); return false;" style="width:24px;float:left;">
			<img src="<?php echo str_replace('php/','',Router::url('/', true));?>img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0">
			</a>
		</th>
	</tr>
</thead>
<tbody id="tablebody">
<?php foreach($msg as $row):?>
	<tr>
		<td class="tablecell leftcell">
			<a target="_blank" href="/editcust.asp?val=<?php echo $row["contact_no"]?>&tab=2#TabbedPanels1"><?php echo $row["customer"];?></a>
		</td>
		<td class="tablecell">
			<?php echo $row["companyname"];?>
		</td>
		<td class="tablecell">
			<?php echo $row["order_source"];?>
		</td>
		<td class="tablecell">
			<a target="_blank" href="/orderdetails.asp?pn=<?php echo $row["purchase_number"];?>"><?php echo $row["order_number"];?></a>
		</td>
		<td class="tablecell">
			<?php echo $row["order_date"];?>
		</td>
		<td class="tablecell leftcell">
			<?php echo $row["basefabric"]['required'];?>
			<br/>
			<em style ="font-size:12px; font-weight:bold;"><?php echo $row["basefabric"]['qc_status_word'];?></em>
		</td>
		<td class="tablecell">
			<?php echo $row["basefabric"]['madeat'];?>
		</td>
		<?php 	$fabricStatusCell = '';
			switch($row["basefabric"]['fabricstatus']){
			  	case 7:
			  	$baseStyle = 'greencell';
			  	break;
			  	case 5:
			  	$baseStyle = 'greencell';
			  	break;
			  	case 8:
			  	$baseStyle = 'transparentcell';
			  	break;
			  	case 4:
			  	$baseStyle = 'yellowcell';
			  	break;
			  	case 3:
			  	$baseStyle = 'redcell';
			  	break;
			  	default:
			  	$baseStyle = '';
			  }
			  if(!empty($row["basefabric"]['fabricstatus'])&&$row["basefabric"]['fabricstatus']!=''){
			  	$fabricStatusCell = 'fabricStatusCell';
			  }
			  else{
			  	$fabricStatusCell = '';
			  }
		?>
		<td class="tablecell <?php echo $fabricStatusCell;?> <?php echo $baseStyle;?>">
			<?php echo $row["basefabric"]['fabricstatus_word'];?>
			<?php if($fabricStatusCell!=''):?>
				<div class ="fabricStatusCellMoreInfo">
					<p>Order Number: <?php echo $row["order_number"];?></p>
					<p>Customer Surname: <?php echo $row["basefabric"]['surname'];?></p>
					<?php if (!empty($row["basefabric"]['supplier'])&&$row["basefabric"]['supplier']!=''):?>
						<p>Suplier: <?php echo $row["basefabric"]['supplier'];?></p>
					<?php endif;?>
					<?php if (!empty($row["basefabric"]['ponumber'])&&$row["basefabric"]['ponumber']!=''):?>
						<p>Purchase Order No.: <?php echo $row["basefabric"]['ponumber'];?></p>
					<?php endif;?>
					<?php if (!empty($row["basefabric"]['podate'])&&$row["basefabric"]['podate']!=''):?>
						<p>Purchase Date: <?php echo $row["basefabric"]['podate'];?></p>
					<?php endif;?>
					<?php if (!empty($row["basefabric"]['expected'])&&$row["basefabric"]['expected']!=''):?>
						<p>Expected Date: <?php echo $row["basefabric"]['expected'];?></p>
					<?php endif;?>
					<?php if (!empty($row["basefabric"]['received'])&&$row["basefabric"]['received']!=''):?>
						<p>Received Date: <?php echo $row["basefabric"]['received'];?></p>
					<?php endif;?>
					<?php if (!empty($row["basefabric"]['cuttingsent'])&&$row["basefabric"]['cuttingsent']!=''):?>
						<p>Cutting Sent Date: <?php echo $row["basefabric"]['cuttingsent'];?></p>
					<?php endif;?>
					<?php if (!empty($row["basefabric"]['confirm'])&&$row["basefabric"]['confirm']!=''):?>
						<p>Confirm Date: <?php echo $row["basefabric"]['confirm'];?></p>
					<?php endif;?>
					<?php if (!empty($row["basefabric"]['tocardiff'])&&$row["basefabric"]['tocardiff']!=''):?>
						<p>Date to Cardiff: <?php echo $row["basefabric"]['tocardiff'];?></p>
					<?php endif;?>
				</div>
			<?php endif;?>
		</td>
		<td class="tablecell leftcell">
			<?php echo $row["hbfabric"]['required'];?>
			<br/>
			<em style ="font-size:12px;font-weight:bold;"><?php echo $row["hbfabric"]['qc_status_word'];?></em>
		</td>
		<td class="tablecell">
			<?php echo $row["hbfabric"]['madeat'];?>
		</td>
		<?php 	$fabricStatusCell = '';
				switch($row["hbfabric"]['fabricstatus']){
			  	case 7:
			  	$hbStyle = 'greencell';
			  	break;
			  	case 5:
			  	$hbStyle = 'greencell';
			  	break;
			  	case 8:
			  	$hbStyle = 'transparentcell';
			  	break;
			  	case 4:
			  	$hbStyle = 'yellowcell';
			  	break;
			  	case 3:
			  	$hbStyle = 'redcell';
			  	break;
			  	default:
			  	$hbStyle = '';
			  }
			  if(!empty($row["hbfabric"]['fabricstatus'])&&$row["hbfabric"]['fabricstatus']!=''){
			  	$fabricStatusCell = 'fabricStatusCell';
			  }
			  else{
			  	$fabricStatusCell = '';
			  }
		?>
		<td class="tablecell <?php echo $fabricStatusCell;?> <?php echo $hbStyle;?>">
			<?php echo $row["hbfabric"]['fabricstatus_word'];?>
			<?php if($fabricStatusCell!=''):?>
				<div class ="fabricStatusCellMoreInfo">
					<p>Order Number: <?php echo $row["order_number"];?></p>
					<p>Customer Surname: <?php echo $row["hbfabric"]['surname'];?></p>
					<?php if (!empty($row["hbfabric"]['supplier'])&&$row["hbfabric"]['supplier']!=''):?>
						<p>Suplier: <?php echo $row["hbfabric"]['supplier'];?></p>
					<?php endif;?>
					<?php if (!empty($row["hbfabric"]['ponumber'])&&$row["hbfabric"]['ponumber']!=''):?>
						<p>Purchase Order No.: <?php echo $row["hbfabric"]['ponumber'];?></p>
					<?php endif;?>
					<?php if (!empty($row["hbfabric"]['podate'])&&$row["hbfabric"]['podate']!=''):?>
						<p>Purchase Date: <?php echo $row["hbfabric"]['podate'];?></p>
					<?php endif;?>
					<?php if (!empty($row["hbfabric"]['expected'])&&$row["hbfabric"]['expected']!=''):?>
						<p>Expected Date: <?php echo $row["hbfabric"]['expected'];?></p>
					<?php endif;?>
					<?php if (!empty($row["hbfabric"]['received'])&&$row["hbfabric"]['received']!=''):?>
						<p>Received Date: <?php echo $row["hbfabric"]['received'];?></p>
					<?php endif;?>
					<?php if (!empty($row["hbfabric"]['cuttingsent'])&&$row["hbfabric"]['cuttingsent']!=''):?>
						<p>Cutting Sent Date: <?php echo $row["hbfabric"]['cuttingsent'];?></p>
					<?php endif;?>
					<?php if (!empty($row["hbfabric"]['confirm'])&&$row["hbfabric"]['confirm']!=''):?>
						<p>Confirm Date: <?php echo $row["hbfabric"]['confirm'];?></p>
					<?php endif;?>
					<?php if (!empty($row["hbfabric"]['tocardiff'])&&$row["hbfabric"]['tocardiff']!=''):?>
						<p>Date to Cardiff: <?php echo $row["hbfabric"]['tocardiff'];?></p>
					<?php endif;?>
				</div>
			<?php endif;?>
		</td>
		<td class="tablecell leftcell">
			<?php echo $row["salancefabric"]['required'];?>
			<br/>
			<em style ="font-size:12px;font-weight:bold;">
			<?php echo $row["salancefabric"]['qc_status_word'];?>
			</em>
		</td>
		<td class="tablecell">
			<?php echo $row["salancefabric"]['madeat'];?>
		</td>
		<?php $fabricStatusCell = ''; 
			switch($row["salancefabric"]['fabricstatus']){
			  	case 7:
			  	$saStyle = 'greencell rightcell';
			  	break;
			  	case 5:
			  	$saStyle = 'greencell rightcell';
			  	break;
			  	case 8:
			  	$saStyle = 'transparentcell rightcell';
			  	break;
			  	case 4:
			  	$saStyle = 'yellowcell rightcell';
			  	break;
			  	case 3:
			  	$saStyle = 'redcell rightcell';
			  	break;
			  	default:
			  	$saStyle = 'rightcell';
			  }
			  if(!empty($row["salancefabric"]['fabricstatus'])&&$row["salancefabric"]['fabricstatus']!=''){
			  	$fabricStatusCell = 'fabricStatusCell';
			  }
			  else{
			  	$fabricStatusCell = '';
			  }
		?>
		<td class="tablecell <?php echo $fabricStatusCell;?> <?php echo $saStyle;?>" >
			<?php echo $row["salancefabric"]['fabricstatus_word'];?>
			<?php if($fabricStatusCell!=''):?>
				<div class ="fabricStatusCellMoreInfo">
					<p>Order Number: <?php echo $row["order_number"];?></p>
					<p>Customer Surname: <?php echo $row["salancefabric"]['surname'];?></p>
					<?php if (!empty($row["salancefabric"]['supplier'])&&$row["salancefabric"]['supplier']!=''):?>
						<p>Suplier: <?php echo $row["salancefabric"]['supplier'];?></p>
					<?php endif;?>
					<?php if (!empty($row["salancefabric"]['ponumber'])&&$row["salancefabric"]['ponumber']!=''):?>
						<p>Purchase Order No.: <?php echo $row["salancefabric"]['ponumber'];?></p>
					<?php endif;?>
					<?php if (!empty($row["salancefabric"]['podate'])&&$row["salancefabric"]['podate']!=''):?>
						<p>Purchase Date: <?php echo $row["salancefabric"]['podate'];?></p>
					<?php endif;?>
					<?php if (!empty($row["salancefabric"]['expected'])&&$row["salancefabric"]['expected']!=''):?>
						<p>Expected Date: <?php echo $row["salancefabric"]['expected'];?></p>
					<?php endif;?>
					<?php if (!empty($row["salancefabric"]['received'])&&$row["salancefabric"]['received']!=''):?>
						<p>Received Date: <?php echo $row["salancefabric"]['received'];?></p>
					<?php endif;?>
					<?php if (!empty($row["salancefabric"]['cuttingsent'])&&$row["salancefabric"]['cuttingsent']!=''):?>
						<p>Cutting Sent Date: <?php echo $row["salancefabric"]['cuttingsent'];?></p>
					<?php endif;?>
					<?php if (!empty($row["salancefabric"]['confirm'])&&$row["salancefabric"]['confirm']!=''):?>
						<p>Confirm Date: <?php echo $row["salancefabric"]['confirm'];?></p>
					<?php endif;?>
					<?php if (!empty($row["salancefabric"]['tocardiff'])&&$row["salancefabric"]['tocardiff']!=''):?>
						<p>Date to Cardiff: <?php echo $row["salancefabric"]['tocardiff'];?></p>
					<?php endif;?>
				</div>
			<?php endif;?>
		</td>
		<td class="tablecell">
			<?php echo $row["productiondate"];?>
		</td>
		<td class="tablecell rightcell">
			<?php echo $row["bookeddeliverydate"];?>
		</td>
	</tr>
<?php endforeach;?>
<?php for($i=0;$i<5;$i++):?>
	<tr>
	<td class="tablecell emptycell leftcell"></td>
	<td class="tablecell emptycell"></td>
	<td class="tablecell emptycell"></td>
	<td class="tablecell emptycell"></td>
	<td class="tablecell emptycell"></td>
	<td class="tablecell emptycell leftcell"></td>
	<td class="tablecell emptycell"></td>
	<td class="tablecell emptycell"></td>
	<td class="tablecell emptycell leftcell"></td>
	<td class="tablecell emptycell"></td>
	<td class="tablecell emptycell rightcell"></td>
	<td class="tablecell emptycell"></td>
	<td class="tablecell emptycell"></td>
	<td class="tablecell emptycell"></td>
	<td class="tablecell emptycell leftcell"></td>
	<td class="tablecell emptycell rightcell"></td>
	</tr>
<?php endfor;?>
	<tr>
	<td class="tablecell emptycell leftcell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell leftcell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell leftcell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell rightcell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell leftcell bottomcell"></td>
	<td class="tablecell emptycell rightcell bottomcell"></td>
	</tr>
</tbody>
</table>