<?php
use Cake\Core\Configure;
use Cake\Routing\Router;
?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('salefigures.css',array('inline' => false));?>
<?php echo $this->Html->script('htmlToJS.js', array('inline' => false)); ?>


<script type="text/javascript">
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
	/*
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
	*/
});

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
<?php endif;?>
