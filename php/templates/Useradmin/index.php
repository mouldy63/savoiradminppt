<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('userAdmin.css',array('inline' => false));?>

<?php 
	if(!$data):
		echo "You don't have enough privilege to see this page.";
	else:
		echo $this->element('userAdminHead',array('page'=>'index'));
?>
<input id="page" name="page" type="hidden" value="<?php echo $data['currentPage'];?>"/>
<input id="sort" name="page" type="hidden" value="name|asc"/>
<input id="searchkey" name="page" type="hidden" value=""/>
<input id="filter" name="page" type="hidden" value=""/>
<div id="tableArea" class="narrowarea">
	<table>
		<thead>
			<tr>
				<th class = "tablecell "><a href="#" onclick="sortUsers('name|asc','<?php echo Router::url('/', true).'useradmin/index';?>',this);return false;">FIRST NAME</a></th>
				<th class = "tablecell "><a href="#" onclick="sortUsers('lastname|asc','<?php echo Router::url('/', true).'useradmin/index';?>',this);return false;">SURNAME</a></th>
				<th class = "tablecell "><a href="#" onclick="sortUsers('login|asc','<?php echo Router::url('/', true).'useradmin/index';?>',this);return false;">LOGIN</a></th>
				<th class = "tablecell "><a href="#" onclick="sortUsers('location|asc','<?php echo Router::url('/', true).'useradmin/index';?>',this);return false;">LOCATION</a></th>
				<th class = "tablecell align-right" ><a href="#" onclick="sortUsers('lastlogin|asc','<?php echo Router::url('/', true).'useradmin/index';?>',this);return false;">LAST LOGIN</a></th>
				<th class = "tablecell align-right" ><a href="#" onclick="sortUsers('retire|asc','<?php echo Router::url('/', true).'useradmin/index';?>',this);return false;">ACTION</a></th>
			</tr>
		</thead>
		<tbody id="datatable">
<?php
		$users = $data['users'];
		echo $this->element('userAdminTable',array('users'=>$users));
?>
		</tbody>
	</table>
<div id="pageNum" data-link="<?php echo Router::url('/', true);?>useradmin/index">
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
<?php echo $this->Html->script('userAdmin.js', array('inline' => false)); ?>
<?php
	endif;
?>