<?php
$disableArray = ['edit_user'=>'','user_detail'=>'','edit_roles'=>'','change_pass'=>''];
$disableArray[$page] = 'disabled';
?>
<div class="userdetailbuttons">
		<button class="userdetailbutton" id="userDetail" data-id="<?php echo $user['user_id'];?>" <?php echo $disableArray['user_detail'];?>>User Details</button>
		<button class="userdetailbutton" id="editUsrRole" data-id="<?php echo $user['user_id'];?>" <?php echo $disableArray['edit_roles'];?>>Edit User Permissions</button>
		<button class="userdetailbutton" id="editUsrDetail" data-id="<?php echo $user['user_id'];?>" <?php echo $disableArray['edit_user'];?>>Edit User Details</button>
		<button class="userdetailbutton" id="replicate" data-id="<?php echo $user['user_id'];?>">Duplicate</button>
		<button class="userdetailbutton" id="changepass" data-id="<?php echo $user['user_id'];?>" <?php echo $disableArray['change_pass'];?>>Reset Password</button>
		<?php if($user['Retired']=='y'):?>
			<button class="userdetailbutton" id="retired" data-id="<?php echo $user['user_id'];?>">Un-Retire</button>
		<?php else:?>
			<button class="userdetailbutton" id="retire" data-id="<?php echo $user['user_id'];?>">Retire</button>
		<?php endif;?>
</div>
<script type="text/javascript">
$(document).ready(function(){
	$('#changepass').click(function(){
		var id = $(this).attr('data-id');
		window.location='/php/useradmin/changePassword?id='+id;
	});
	$('#retire').click(function(){
		var id = $(this).attr('data-id');
		window.location='/php/useradmin/retire?id='+id+'&redp=2';
	});
	$('#retired').click(function(){
		var id = $(this).attr('data-id');
		window.location='/php/useradmin/active?id='+id;
	});
	$('#userDetail').click(function(){
		var id = $(this).attr('data-id');
		window.location='/php/useradmin/userDetail?id='+id;
	});
	$('#editUsrDetail').click(function(){
		var id = $(this).attr('data-id');
		window.location='/php/useradmin/editUser?id='+id;
	});
	$('#editUsrRole').click(function(){
		var id = $(this).attr('data-id');
		window.location='/php/useradmin/editRoles?id='+id;
	});
	$('#replicate').click(function(){
		var id = $(this).attr('data-id');
		window.location='/php/useradmin/createUser?id='+id;
	});
});
</script>