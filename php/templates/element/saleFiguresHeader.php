<?php
use Cake\Core\Configure;
use Cake\Routing\Router;
?>
<div id="salefigureMenu">
	<ul>
		<li class="salefigureBigTile"><h3>Sale Figures</h3></li>
		<li class="salefigureMenuTile">
			 <a>WORLD</a>
			 <?php if($acl['issuperuser']):?>
			 <div class = "salefigure_submenu">
			 	<a href="<?php echo Router::url('/', true);?>saleFigures/world" class="table_world_request">Yearly Figures</a>
			 	<a href="<?php echo Router::url('/', true);?>saleFigures/worldMonthlyFigures" class="table_world_request">Monthly Figures</a>
			 </div>
			 <?php endif;?>
		</li>
		<li class="salefigureMenuTile">
			 <a>EXCHANGE RATES</a>
			 <?php if($acl['issuperuser']):?>
			 <div class = "salefigure_submenu">
			 	<a href="<?php echo Router::url('/', true);?>saleFigures/exchangeRates" class="table_world_request">Exchange Rates</a>

			 </div>
			 <?php endif;?>
		</li>

	</ul>
</div>