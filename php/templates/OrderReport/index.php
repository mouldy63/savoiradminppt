<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('salefigures.css',array('inline' => false));?>
<?php echo $this->Html->css('salefigures-showroom.css',array('inline' => false));?>
<?php echo $this->Html->script('htmlToJS.js', array('inline' => false)); ?>
<div id="controlArea" style="background:;">
	<a id="exportTable" href="#" style="background-color: #ccc;margin-left: 35px;padding: 10px;">EXPORT TABLE</a>
</div>
<div id="tableArea">
<?php 
//echo var_dump($data);
//die();
if(empty($data)):
	echo "There is no records to show.";
else:
?>
<table id="theTable">
	<thead>
		<tr>
			<th class="tablecell bordercell">Order Number</th>
			<th class="tablecell bordercell">Customer Name</th>
			<th class="tablecell bordercell">Order Date</th>
			<th class="tablecell bordercell">Showroom</th>
			<th class="tablecell bordercell">Customer Reference</th>
			<th class="tablecell bordercell">Order Total</th>
			<th class="tablecell bordercell">Currency</th>
			<th class="tablecell bordercell">Mattress</th>
			<th class="tablecell bordercell">Base</th>
			<th class="tablecell bordercell">Topper</th>
			<th class="tablecell bordercell">Legs</th>
			<th class="tablecell bordercell">Headboard</th>
			<th class="tablecell bordercell">Valance</th>
			<th class="tablecell bordercell">Accessories</th>
			<th class="tablecell bordercell">Order Source</th>
		</tr>
	</thead>
	<tbody style="height:500px;">
		<?php foreach($data as $d): ?>
			<tr>
				<td class="tablecell bordercell"><a href="/orderdetails.asp?pn=<?php echo $d[0]['PURCHASE_No'];?>" target="_blank"><?php echo $d[0]['ORDER_NUMBER']?></a></td>
				<td class="tablecell bordercell"><?php echo $d[0]['surname']?></td>
				<td class="tablecell bordercell"><?php echo date('d/m/Y',strtotime($d[0]['ORDER_DATE'])); ?></td>
				<td class="tablecell bordercell"><?php echo $d[0]['location']?></td>
				<td class="tablecell bordercell"><?php echo $d[0]['customerreference']?></td>
				<td class="tablecell bordercell"><?php echo $d[0]['totalexvat']?></td>
				<td class="tablecell bordercell"><?php echo $d[0]['ordercurrency']?></td>
				<td class="tablecell bordercell"><?php echo $d[0]['savoirmodel']?></td>
				<td class="tablecell bordercell"><?php echo $d[0]['basesavoirmodel']?></td>
				<td class="tablecell bordercell"><?php echo $d[0]['toppertype']?></td>
				<td class="tablecell bordercell"><?php echo $d[0]['legstyle']?></td>
				<td class="tablecell bordercell"><?php echo $d[0]['headboardstyle']?></td>
				<td class="tablecell bordercell"><?php echo $d[0]['valancerequired']?></td>
				<td class="tablecell bordercell"><?php echo $d[0]['accessoriesrequired']?></td>
				<td class="tablecell bordercell"><?php echo $d[0]['ordersource']?></td>
			</tr>
		<?php endforeach;?>
	</tbody>
</table>
<?php	
endif;
?>
</div>


<script type="text/javascript">
function adjustTable(){
	var standardWidth = jQuery(window).width();
		standardWidth = Math.round((standardWidth-100)*0.9/14);
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
	$('#exportTable').click(function(){
	    if($('#tableArea').is(':empty')){
                    alert('There is no table!');
        }else{
		    var outputFile = 'orders.csv'
            exportTableToCSV.apply(this, [$('#theTable'), outputFile]);
        }
	});
});

</script>