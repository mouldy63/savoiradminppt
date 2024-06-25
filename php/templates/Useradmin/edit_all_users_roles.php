<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('userAdmin.css',array('inline' => false));?>
<?php echo $this->Html->script('userAdminAllUsersRoles.js', array('inline' => false)); ?>
<?php 
	echo $this->element('userAdminHead',array('page'=>'alluserroll'));
?>
<input id="page" name="page" type="hidden" value="<?php echo $data['currentPage'];?>"/>
<input id="sort" name="page" type="hidden" value="name|asc"/>
<input id="searchkey" name="page" type="hidden" value=""/>
<input id="filter" name="page" type="hidden" value=""/>
<?php 
$roles = $data['roles'];
$totalColumn = count($roles);
?>
<!--
<div class="narrowarea">
	<button class="editController">Enable Edit</button>
</div>
-->
<div id="tableArea">
	<table id="allUserRoleTable">
		<thead>
			<tr>
				<th class = "twotablecell ">User Name</th>
				<?php foreach($roles as $r):?>
					<th class = "tablecell " data-role-id="<?php echo $r['id']?>"><?php echo $r['role']?></th>
				<?php endforeach;?>
			</tr>
		</thead>
		<tbody id="datatable">
<?php
		$users = $data['users'];
		echo $this->element('userAdminAllUserRoleTable',array('users'=>$users,'roles'=>$roles));
?>
		</tbody>
	</table>
<div id="pageNum" data-link="<?php echo Router::url('/', true);?>useradmin/editAllUsersRoles">
	<?php 
	$totalPages = (int)$data['totalPage'];
	for($i=1;$i<=$totalPages;$i++):
		if($i == $data['currentPage']):
	?>
		<a href="#" class="pageNumber strong"><?php echo $i;?></a>	
		<?php
		else:
		?>
		<a href="#" class="pageNumber"><?php echo $i;?></a>
	<?php
		endif;
	endfor;
	?>
</div>
</div>
