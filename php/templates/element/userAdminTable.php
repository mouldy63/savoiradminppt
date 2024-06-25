<?php use Cake\Routing\Router; ?>
<?php
foreach($users as $user):
?>
<tr class="userrow">
	<td class = "tablecell align-left">
		<a href="<?php echo Router::url('/', true);?>useradmin/userDetail?id=<?php echo $user["user_id"];?>"><?php echo $user["first_name"];?></a>
	</td>
	<td class = "tablecell align-left">
		<a href="<?php echo Router::url('/', true);?>useradmin/userDetail?id=<?php echo $user["user_id"];?>"><?php echo $user["last_name"]; ?></a>
	</td>
	<td class = "tablecell align-left">
		<a href="<?php echo Router::url('/', true);?>useradmin/userDetail?id=<?php echo $user["user_id"];?>"><?php echo $user["username"];?></a>
	</td>
	<td class = "tablecell align-left">
		<?php
		 	echo $user["location"];
		?>
	</td>
	<td class = "tablecell align-right" >
		<?php
		 	echo $user["last_login"];
		?>
	</td>
	<td class = "tablecell align-right" >
	<?php if($user["Retired"]=='y'):?>
	<a href="<?php echo Router::url('/', true);?>useradmin/editUser?id=<?php echo $user["user_id"];?>">RETIRED</a>
	<?php else:?>
	<a href="<?php echo Router::url('/', true);?>useradmin/editUser?id=<?php echo $user["user_id"];?>">EDIT</a>/<a href="#" data-link = "<?php echo Router::url('/', true);?>useradmin/retire?id=<?php echo $user["user_id"];?>&redp=1" class="retire">RETIRE</a>
	<?php endif;?>
	</td>
</tr>
<?php 
endforeach;
?>