<?php
foreach($users as $user):
?>
<tr class="userrow">
	<td class = "twotablecell username"><?php echo $user['username'];?></td>
	<?php foreach($roles as $role):?>
	<td class = "tablecell ">
		<?php 
			$isChecked = '';
			$orignalRole = '';
			if(in_array($role['role'],$user['roles'])){
				
				$isChecked = 'checked';
				$orignalRole = 'data-original="true"';
			}
		?>
		<input class="controlled" data-id="<?php echo $user['user_id'];?>" type="checkbox" name="roles[]" value="<?php echo $role['id'];?>" <?php echo $orignalRole;?> <?php echo $isChecked;?> disabled/>
	</td>
	<?php 
		endforeach;
	?>
	<td  class = "tablecell">
		<button class="edit" data-id="<?php echo $user['user_id'];?>" >Edit</button>
		<button class="SaveRolesChange hidebutton" data-id="<?php echo $user['user_id'];?>" >Save</button>
		<button class="CancelRolesChange hidebutton" data-id="<?php echo $user['user_id'];?>" >Cancel</button>
	</td>
</tr>
<?php 
endforeach;
?>