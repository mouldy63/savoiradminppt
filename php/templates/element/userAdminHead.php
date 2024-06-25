<?php use Cake\Routing\Router; ?>
<div id="salefigureMenu">
	<ul>
		<!--<li class="salefigureBigTile"><h3>Manage Users</h3></li>-->
		<li class="salefigureMenuTile">
			 <a>Users Admin</a>
			 <div class = "salefigure_submenu">
			 	<a href="<?php echo Router::url('/', true);?>useradmin/index" class="table_world_request">Users List</a>
			 	<a href="<?php echo Router::url('/', true);?>useradmin/createUser" class="table_world_request">Create New User</a>
			 	<!--<a href="<?php echo Router::url('/', true);?>useradmin/editroles" class="table_world_request">EDIT ROLES</a>-->
			 </div>
		</li>
		<li class="salefigureMenuTile">
			 <a>Roles Admin</a>
			 <div class = "salefigure_submenu">
			 	<a href="<?php echo Router::url('/', true);?>useradmin/editAllUsersRoles" class="table_world_request">Edit Users Roles</a>
			 	<!--<a href="#" class="table_world_request">Edit Roles</a>-->
			 </div>
		</li>
	</ul>
	<?php if($page == 'index' || $page == 'alluserroll'): ?>
	<div id="rightNav">
		<?php 
			if($page == 'index'){
				$link = Router::url('/', true).'useradmin/index';
			}else{
				$link = Router::url('/', true).'useradmin/editAllUsersRoles';
			}
		?>
		<input type="text" name="search" id="keywords"/> <button id="search" data-link="<?php echo $link;?>">Search</button> <button id="search_reset" data-link="<?php echo $link;?>">Reset</button>
	</div>
	<?php endif;?>
</div>
<script type="text/javascript">
$(document).ready(function(){
	$('.salefigureMenuTile').hover(function(){
		var obj = $(this).find('.salefigure_submenu');
		$(obj).show();
	},
	function(){
		var obj = $(this).find('.salefigure_submenu');
		$(obj).hide();
	});
	$('#search_reset').click(function(){
		window.location = $(this).attr('data-link');
	});
});
</script>