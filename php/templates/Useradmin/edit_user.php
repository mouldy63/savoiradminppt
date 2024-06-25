<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('userAdmin.css',array('inline' => false));?>
<?php echo $this->element('userAdminHead',array('page'=>'edituser'));
	$user = $data['user'];
?>
<div id="userdetail">
	<div>
		<h5><?php echo empty($user['name'])?$user['username']:$user['name'].': '.$user['username'];?></h5>
	</div>
	<?php echo $this->element('userAdminUserControl',array('page'=>'edit_user','user'=>$user)); ?>
	<div class="lastlogin">
		<p>Last Logged in: <?php echo $user['last_login'];?></p>
		<?php echo $user['Retired']=='y'?'<p>Type: <b style="color:red;">Retired</b></p>':'<p>Type: <b>Current Employee</b></p>';?>
	</div>
	<div class="clear"></div>
	<div class="detailarea">
		<form action="/php/useradmin/editUser" method="post">
		<input type="hidden" name="user_id" value="<?php echo $user['user_id']?>"/>
		<table class="userdetailtable">
		<tbody>
			<tr>
				<td class="aliginright">Name: </td>
				<td><input class="subinput changeBack" type="text" name="name" data-orginal="<?php echo $user['name'];?>" value="<?php echo $user['name'];?>"/></td>
				<td class="aliginright">Super User: </td>
				<td><select class="subinput" name="superuser">
					<?php 
					if($user['superuser']=='Y'){
						$isSuper = 'selected';
						$notSuper = '';
					}else{
						$notSuper = 'selected';
						$isSuper = '';
					}?>
					<option class="changeBackOption" value="Y" data-orginal="<?php echo $isSuper;?>" <?php echo $isSuper;?>>Yes</option>
					<option class="changeBackOption" value="N" data-orginal="<?php echo $notSuper;?>" <?php echo $notSuper;?>>No</option>
				</select></td>
			</tr>
			<tr>
				<td class="aliginright">User Name: </td>
				<td><input class="subinput changeBack" data-orginal="<?php echo $user['username'];?>" type="text" name="username" value="<?php echo $user['username'];?>"/></td>
				<td class="aliginright">Phone:</td>
				<td><input class="subinput changeBack" data-orginal="<?php echo $user['tel'];?>" type="text" name="tel" value="<?php echo $user['tel'];?>"/></td>
			</tr>
			<tr>
				<td class="aliginright">
					Email: </td>
				<td><input class="subinput changeBack" data-orginal="<?php echo $user['email'];?>" type="text" name="email" value="<?php echo $user['email'];?>"/></td>
				<td>
				</td>
				<td>
				</td>
			</tr>
			<tr>
				<td class="aliginright">Region: </td>
				<td><select class="subinput" name="region">
					<?php foreach($data['region'] as $region):?>
						<?php if($user['id_region'] == $region['id']):?>
							<option class="changeBackOption" value="<?php echo $region['id'];?>" data-orginal="selected" selected><?php echo $region['region'];?></option>
						<?php else:?>
							<option class="changeBackOption" value="<?php echo $region['id'];?>" data-orginal=""><?php echo $region['region'];?></option>
						<?php endif;?>
					<?php endforeach;?>
				</select></td>
				<td class="aliginright">Location: </td>
				<td><select class="subinput" name="location">
					<?php foreach($data['showroom'] as $showroom):?>
						<?php if($user['id_location'] == $showroom['id']):?>
							<option class="changeBackOption" value="<?php echo $showroom['id'];?>" data-orginal="selected" selected><?php echo $showroom['location'];?></option>
						<?php else:?>
							<option class="changeBackOption" value="<?php echo $showroom['id'];?>" data-orginal=""><?php echo $showroom['location'];?></option>
						<?php endif;?>
					<?php endforeach;?>
				</select></td>
			</tr>
			<tr>
				<td class="aliginright">Made By: </td>
				<td><select class="subinput" name="madeby">
					<?php 
					if($user['madeby']=='y'){
						$ismadeby = 'selected';
						$notmadeby = '';
					}else{
						$notmadeby = 'selected';
						$ismadeby = '';
					}?>
					<option class="changeBackOption" data-orginal="<?php echo $ismadeby;?>" value="y" <?php echo $ismadeby;?>>Yes</option>
					<option class="changeBackOption" data-orginal="<?php echo $notmadeby;?>" value="n" <?php echo $notmadeby;?>>No</option>
				</select></td>
				<td class="aliginright">Picked By: </td>
				<td><select class="subinput" name="pickedby">
					<?php 
					if($user['pickedby']=='y'){
						$ispickedby = 'selected';
						$notpickedby = '';
					}else{
						$notpickedby = 'selected';
						$ispickedby = '';
					}?>
					<option class="changeBackOption" data-orginal="<?php echo $ispickedby;?>" value="y" <?php echo $ispickedby;?>>Yes</option>
					<option class="changeBackOption" data-orginal="<?php echo $notpickedby;?>" value="n" <?php echo $notpickedby;?>>No</option>
				</select></td>
			</tr>
			<tr>
				<td>
				</td>
				<td>
					Created By: <?php echo $data['create'];?>
				</td>
				<td>
				</td>
				<td >
					Modified By: <?php echo $data['modify'];?>
				</td>
			</tr>
		</tbody>
		</table>
		<div style="text-align:center;">
			<input type="submit" name="submit" value="Save"/>
			<input id="cancel" type="button" name="cancel" value="Cancel" />
		</div>
		</form>
	</div>
</div>
<script type="text/javascript">
$(document).ready(function(){
	$('#cancel').click(function(){
		$('.changeBack').each(function(index,element){
			var content = $(element).attr('data-orginal');
			$(element).val(content);
		});
		$('.changeBackOption').removeAttr('selected');
		$('.changeBackOption').each(function(index,element){
			var isSelected = $(element).attr('data-orginal');
			if(isSelected.length>0){
				var select = document.createAttribute("selected");
				element.setAttributeNode(select);
			}
		});
	});
});
</script>