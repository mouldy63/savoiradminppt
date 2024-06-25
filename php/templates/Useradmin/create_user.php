<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('userAdmin.css',array('inline' => false));?>
<?php echo $this->element('userAdminHead',array('page'=>'createnewuser'));
$showroom = $data['showroom'];
$roles = $data['roles'];
$user = null;
if(key_exists('user', $data)){
	$user = $data['user'];
}
?>

<div id="userdetail">
	<div>
		<h5>Create New User</h5>
	</div>

	<div class="detailarea">
		<form action="/php/useradmin/createUser" method="post">
		<table class="userdetailtable">
		<tbody>
			<tr>
				<td class="aliginright">Name: </td>
				<td><input class="subinput" type="text" name="name" value="" required/></td>
				<td class="aliginright">Super User: </td>
				<?php 
					$isSuper = '';
					$notSuper = '';
					if(!empty($user)){
						if($user['superuser']=='Y'){
							$isSuper = 'selected';
							$notSuper = '';
						}else{
							$isSuper = '';
							$notSuper = 'selected';
						}
					}
				?>
				<td><select class="subinput" name="superuser">
					<option value="Y" <?php echo $isSuper;?>>Yes</option>
					<option value="N" <?php echo $notSuper;?>>No</option>
				</select></td>
			</tr>
			<tr>
				<td class="aliginright">User Name: </td>
				<td><input class="subinput" type="text" name="username" value="" required/></td>
				<td class="aliginright">Password:</td>
				<td><input class="subinput password" type="text" name="password" value="" required/><button type="button" class="generatepass">Generate</button></td>
			</tr>
			<tr>
				<td class="aliginright">Email: </td>
				<td><input class="subinput" type="text" name="email" value="" required/></td>
				<td class="aliginright">Phone:</td>
				<td><input class="subinput" type="text" name="tel" value="" required/></td>
			</tr>
			<tr>
				<td class="aliginright">Region: </td>
				<td><select class="subinput" name="region">
					<?php
						$region_id = null; 
						if(!empty($user)){
							$region_id = $user['id_region'];
						}
					?>
					<?php foreach($data['region'] as $region):?>
						<?php if($region['id'] == $region_id):?>
							<option value="<?php echo $region['id'];?>" selected><?php echo $region['region'];?></option>
						<?php else: ?>
							<option value="<?php echo $region['id'];?>"><?php echo $region['region'];?></option>
						<?php endif;?>
						
					<?php endforeach;?>
				</select></td>
				<td class="aliginright">Location: </td>
				<td><select class="subinput" name="location">
					<?php
						$showroom_id = null; 
						if(!empty($user)){
							$showroom_id = $user['id_location'];
						}
					?>
					<?php foreach($data['showroom'] as $showroom):?>
						<?php if($showroom['id'] == $showroom_id):?>
							<option value="<?php echo $showroom['id'];?>" selected><?php echo $showroom['location'];?></option>
						<?php else: ?>
							<option value="<?php echo $showroom['id'];?>"><?php echo $showroom['location'];?></option>
						<?php endif;?>
					<?php endforeach;?>
				</select></td>
			</tr>
			<tr>
				<td class="aliginright">Made By: </td>
				<td><select class="subinput" name="madeby">
				<?php 
					$ismadeby = '';
					$notmadeby = '';
					if(!empty($user)){
						if($user['madeby'] == 'y'){
							$ismadeby = 'selected';
						}else{
							$notmadeby = 'selected';
						}
					}
				?>
					<option value="y" <?php echo $ismadeby; ?>>Yes</option>
					<option value="n" <?php echo $notmadeby; ?>>No</option>
				</select></td>
				<td class="aliginright">Picked By: </td>
				<td><select class="subinput" name="pickedby">
				<?php 
					$ispickedby = '';
					$notpickedby = '';
					if(!empty($user)){
						if($user['pickedby'] == 'y'){
							$ispickedby = 'selected';
						}else{
							$notpickedby = 'selected';
						}
					}
				?>
					<option value="y" <?php echo $ispickedby;?>>Yes</option>
					<option value="n" <?php echo $notpickedby;?>>No</option>
				</select></td>
			</tr>
		</tbody>
		</table>
		<fieldset name="roles">
			<legend>User Roles:</legend>
			<table class="userdetailtable">
				<?php
				$checkedRoles = array();
				if(!empty($user)){
					 $checkedRoles = $user['role_id'];
				}
				$i=1;
				foreach($roles as $role):?>
					<?php
							$isChecked = '';
							if(in_array((int)$role['id'], $checkedRoles)){
								$isChecked = 'checked';
							}
					?>
					<?php if($i ==1 || ($i-1)%4==0):?>
						<tr>
						<td><input class="subinput" type="checkbox" name="roles[]" value="<?php echo $role['id']?>" <?php echo $isChecked;?> required="required"/><label><?php echo $role['role']?></label></td>
					<?php else:?>
						<td><input class="subinput" type="checkbox" name="roles[]" value="<?php echo $role['id']?>" <?php echo $isChecked;?> required="required"/><label><?php echo $role['role']?></label></td>
					<?php endif;?>
					<?php if($i%4==0):?>
						</tr>
					<?php endif; $i++;?>
				<?php endforeach;?>
			</table>
		<fieldset>
		<div style="text-align:center;">
			<input type="submit" name="submit" value="Submit"/>
		</div>
		</form>
	</div>
</div>
<script type="text/javascript">
$(document).ready(function(){
	var requiredCheckboxes = $(':checkbox[required]');
	var isChecked = false;
	requiredCheckboxes.each(function(e){
			if($(this).is(':checked')){
				isChecked = true;
			}
	});
	if(!isChecked){
		requiredCheckboxes.change(function(){
	        if(requiredCheckboxes.is(':checked')) {
	            requiredCheckboxes.removeAttr('required');
	        }
	        else {
	            requiredCheckboxes.attr('required', 'required');
	        }
	    });
    }else{
    	requiredCheckboxes.removeAttr('required');
    }
    $('.generatepass').click(function(){
    	var pass = generateRandomString();
    	$('.password').val(pass);
    });
    $('.showpass').mousedown(function(){
    	$('.password').attr('type','text');
    });
    $('.showpass').mouseup(function(){
    	$('.password').attr('type','password');
    });
});
function generateRandomString(){
		var randString="";
		var charUniverse="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		for(var i=0; i<12; i++){
			var randInt=Math.floor(Math.random() * 62);
			var randChar=charUniverse[randInt];
			randString=randString + randChar;
		}
		return randString;
}
</script>