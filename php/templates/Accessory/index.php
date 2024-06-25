<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->css('fabricStatus.css', array('inline' => false));?>

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
			var i;
			for(i=0;i<arr.length;i++){
				var tempAccessories = arr[i]['accessories'];
				var isWantedOne = false;
				var j;
				for(j=0;j<tempAccessories.length;j++){
					if(tempAccessories[j]['status_id']==parameter){
						isWantedOne = true;
						break;
					}
				}
				if(isWantedOne){
					tempObj.push(arr[i]);
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
		var k;
		for(k=0;k<arr.length;k++){
			var content = this.createContent(arr[k]);
			jQuery('#tablebody').append(content);
		}
		var contentEnd = '';
		var i;
		for(i=0;i<5;i++){
			contentEnd += '<tr>' +
			'<td class="tablecell emptycell leftcell"></td>' +
			'<td class="tablecell emptycell"></td>' +
			'<td class="tablecell emptycell"></td>' +
			'<td class="tablecell emptycell"></td>' +
			'<td class="tablecell emptycell"></td>' +
			'<td class="emptycell eight-tablecell leftcell rightcell"></td>' +
			'<td class="tablecell emptycell"></td>' +
			'<td class="tablecell emptycell rightcell"></td>' +
			'</tr>';
		}
			contentEnd += '<tr>' +
			'<td class="tablecell emptycell leftcell bottomcell"></td>' +
			'<td class="tablecell emptycell bottomcell"></td>' +
			'<td class="tablecell emptycell bottomcell"></td>' +
			'<td class="tablecell emptycell bottomcell"></td>' +
			'<td class="tablecell emptycell bottomcell"></td>' +
			'<td class="eight-tablecell emptycell leftcell rightcell bottomcell"></td>' +
			'<td class="tablecell emptycell bottomcell"></td>' +
			'<td class="tablecell emptycell rightcell bottomcell"></td>' +
			'</tr>';
		jQuery('#tablebody').append(contentEnd);
		this.resizeTable();
	},
	reOderArray:function(parameter,order){
		var arr = this.data;
		if(this.filterParameter>0){
			arr = this.filteredData;
		}
		var i;
		for(i=0; i<arr.length-1;i++){
			if(arr[i][parameter] == null || arr[i][parameter].length == 0){
				arr[i][parameter]= '-1';
			}
			else{
				var j;
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
	createSubtable:function(data){
		var str = '';
		str += '<table class="inner-table">';
				var itemNo = 1;
				var i;
				for(i=0;i<data.length;i++){
						str += '<tr><td class="tablecell centertext nobottomcell">' +
								'Item No.' + itemNo + '</td>' +
							'<td class="tablecell nobottomcell">' + data[i]['description'] + '</td>' +
							'<td class="tablecell nobottomcell">' + data[i]['design'] + '</td>' +
							'<td class="tablecell centertext nobottomcell">' + data[i]['colour'] + '</td>' +
							'<td class="tablecell centertext nobottomcell">' + data[i]['size'] + '</td>' +
							'<td class="tablecell centertext nobottomcell">' + data[i]['unit'] + '</td>';
						var statusBg = '';
						switch(data[i]['status_id']){
							case '100':
								statusBg = 'redcell';
								break;
							case '10':
								statusBg = 'yellowcell';
								break;
							case '120':
								statusBg = 'greencell';
								break;
							case '70':
								statusBg = 'transparentcell';
								break;
							case '110':
								statusBg = 'greencell';
								break;
							default:
								statusBg = 'transparentcell';
							}
						str += '<td class="tablecell centertext nobottomcell ' + statusBg + '">' + data[i]['status_word'] + '</td>' +
								'<td class="tablecell nobottomcell centertext">' + data[i]['qty'] + '</td></tr>';
					itemNo++;
				}
				str += '</table>';
				return str;
	},
	createContent:function(row){
		var str = '<tr><td class="tablecell leftcell">' +
					'<a target="_blank" href="/editcust.asp?val=' + row["contact_no"]+'&tab=2#TabbedPanels1">'+row["customer"]+'</a></td>'+
					'<td class="tablecell">' + row["companyname"] + '</td>' +
					'<td class="tablecell">' + row["order_source"] + '</td>' +
					'<td class="tablecell">' +
					'<a target="_blank" href="/orderdetails.asp?pn=' + row["purchase_number"] + '">' + row["order_number"] + '</a><br><br>';
		if(row["mattressrequired"]=='y'){
				str += '<p>Mattress: <br>' + row["mattresswidth"] +' x ' + row["mattresslength"] + '</p>';
		}
		if(row["baserequired"]=='y'){
				str += '<p>Base: <br>' + row["basewidth"] + ' x ' + row["baselength"] + '</p>';
		}
		if(row["topperrequired"]=='y'){
				str += '<p>Topper: <br>' + row["topperwidth"] + ' x ' + row["topperlength"] + '</p>';
		}
		str += '</td>' +
					'<td class="tablecell">' + row["order_date"] + '<br><br>Amended on:<br>' + row["amended_date"] + '</td>' +
					'<td class="eight-tablecell leftcell rightcell">';
			if(row["accessory_quantity"]>0){
				str += this.createSubtable(row["accessories"]);
			}
		str += '</td><td class="tablecell">' + row["productiondate"] + '</td>';
		str += '<td class="tablecell rightcell">' + row["bookeddeliverydate"] + '</td></tr>';
		str = str.replace(/-1/g," ");
		str1 = str.replace(/null/g," ");
		str2 = str1.replace(/undefined/g," ");
		return str2;
	},
	
	resizeTable:function(){
		var standardWidth = jQuery(window).width();
		standardWidth = (standardWidth-100)*0.85/15;
		var cellStyle = "max-width:"+standardWidth +"px;" + "min-width:"+standardWidth +"px;";
		var eightCellStyle = "max-width:"+(standardWidth*8+12*8) +"px;" + "min-width:"+(standardWidth*8+12*8) +"px;";
		jQuery('.tablecell').each(function(){
			var newStyle = cellStyle;
			jQuery(this).attr('style',newStyle);
		});
		jQuery('.eight-tablecell').each(function(){
			var newStyle = eightCellStyle;
			jQuery(this).attr('style',newStyle);
		});
	}
}
</script>

<h3>Accessories Screen</h3>
<div id="navbuttom" style="text-align:right;">
<a href="/index.asp">Back to Main Menu</a>
<br/>
<a href='/php/fabricstatus'>Switch to Fabric Screen</a>
</div>
<div id ="filterSelection">
<p><span>Filter by: </span> 

<a href="#" class="filter-option" onclick="tableAdjustment.filterArray(100);return false;">Selected</a> 
&nbsp&nbsp&nbsp
<a href="#" class="filter-option" onclick="tableAdjustment.filterArray(10);return false;">On Order</a> 
&nbsp&nbsp&nbsp
<a href="#" class="filter-option" onclick="tableAdjustment.filterArray(110);return false;">In Stock</a> 
&nbsp&nbsp&nbsp
<a href="#" class="filter-option" onclick="tableAdjustment.filterArray(120);return false;">Allocated & Picked For Delivery</a>
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
		<th class="eight-tablecell nobottomcell topcell leftcell rightcell  centertext">
			ACCESSORIES
		</th>
		<th class="tablecell nobottomcell topcell" >
		</th>
		<th class="tablecell nobottomcell topcell rightcell">
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
		<th class="eight-tablecell nobottomcell leftcell rightcell">
			<table class="inner-table">
				<tr>
					<td class="tablecell nobottomcell centertext">
						Item No.
					</td>
					<td class="tablecell nobottomcell centertext">
						Item Description
					</td>
					<td class="tablecell nobottomcell centertext">
						Design&Details
					</td>
					<td class="tablecell nobottomcell centertext">
						Colour
					</td>
					<td class="tablecell nobottomcell centertext">
						Size
					</td>
					<td class="tablecell nobottomcell centertext">
						Unit Price
					</td>
					<td class="tablecell nobottomcell centertext">
						Status
					</td>
					<td class="tablecell nobottomcell centertext">
						Qty
					</td>
				</tr>
			</table>
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
		<th class="eight-tablecell leftcell rightcell">
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
			<br><br>
			<?php if($row["mattressrequired"]=='y'):?>
				<p>Mattress: <br> <?php echo $row["mattresswidth"]?> x <?php echo $row["mattresslength"]; ?> </p>
			<?php endif;?>
			<?php if($row["baserequired"]=='y'):?>
				<p>Base: <br> <?php echo $row["basewidth"]?> x <?php echo $row["baselength"]; ?> </p>
			<?php endif;?>
			<?php if($row["topperrequired"]=='y'):?>
				<p>Topper: <br> <?php echo $row["topperwidth"]?> x <?php echo $row["topperlength"]; ?> </p>
			<?php endif;?>
		</td>
		<td class="tablecell">
			<?php echo $row["order_date"];?>
			<br><br>
			Amended on:
			<br>
			<?php echo $row["amended_date"];?>
		</td>
		<td class="eight-tablecell leftcell rightcell">
			<?php if($row["accessory_quantity"]>0):?>
				<table class="inner-table">
					<?php $itemNo = 1;?>
					<?php foreach($row["accessories"] as $accessory):?>
						<tr>
							<td class="tablecell centertext nobottomcell">
								<?php echo 'Item No.'.$itemNo;?>
							</td>
							<td class="tablecell nobottomcell">
								<?php echo $accessory['description'];?>
							</td>
							<td class="tablecell nobottomcell">
								<?php echo $accessory['design'];?>
							</td>
							<td class="tablecell centertext nobottomcell">
								<?php echo $accessory['colour'];?>
							</td>
							<td class="tablecell centertext nobottomcell">
								<?php echo $accessory['size'];?>
							</td>
							<td class="tablecell centertext nobottomcell">
								<?php echo $accessory['unit'];?>
							</td>
							<?php
								$statusBg = '';
								switch($accessory['status_id']){
									case '100':
										$statusBg = 'redcell';
										break;
									case '10':
										$statusBg = 'yellowcell';
										break;
									case '120':
										$statusBg = 'greencell';
										break;
									case '70':
										$statusBg = 'transparentcell';
										break;
									case '110':
										$statusBg = 'greencell';
										break;
									default:
										$statusBg = 'transparentcell';
								}
							?>
							<td class="tablecell centertext nobottomcell <?php echo $statusBg;?>">
								<?php echo $accessory['status_word'];?>
							</td>
							<td class="tablecell nobottomcell centertext">
								<?php echo $accessory['qty'];?>
							</td>
							
						</tr>
					<?php $itemNo++;?>
					<?php endforeach;?>
				</table>
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
	<td class="emptycell eight-tablecell leftcell rightcell"></td>
	<td class="tablecell emptycell"></td>
	<td class="tablecell emptycell rightcell"></td>
	</tr>
<?php endfor;?>
	<tr>
	<td class="tablecell emptycell leftcell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="eight-tablecell emptycell leftcell rightcell bottomcell"></td>
	<td class="tablecell emptycell bottomcell"></td>
	<td class="tablecell emptycell rightcell bottomcell"></td>
	</tr>
</tbody>
</table>