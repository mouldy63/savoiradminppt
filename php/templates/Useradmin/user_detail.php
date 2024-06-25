<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('userAdmin.css',array('inline' => false));?>
<?php echo $this->element('userAdminHead',array('page'=>'userdetail'));
	$user = $data['user'];
?>
<div id="userdetail">
	<div>
		<h5><?php echo empty($user['name'])?$user['username']:$user['name'].': '.$user['username'];?></h5>
	</div>
	<?php echo $this->element('userAdminUserControl',array('page'=>'user_detail','user'=>$user)); ?>
	<div class="lastlogin">
		<p>Last Logged in: <?php echo $user['last_login'];?></p>
		<?php echo $user['Retired']=='y'?'<p>Type: <b style="color:red;">Retired</b></p>':'<p>Type: <b>Current Employee</b></p>';?>
	</div>
	<div class="clear"></div>
	<div class="detailarea">
		<table class="userdetailtable">
		<tbody>
			<tr>
				<td class="aliginright fixwidth">
					Name: 
				</td>
				<td class="fixwidth">
					<?php echo $user['name'];?>
				</td>
				<td class="aliginright fixwidth">
					Super User: 
				</td>
				<td class="fixwidth">
					<?php echo $user['superuser']=='Y'?'Yes':'No';?>
				</td>
				
			</tr>
			<tr>
				<td class="aliginright fixwidth">
					User Name: 
				</td>
				<td class="fixwidth">
					<?php echo $user['username'];?>
				</td>
				<td class="aliginright fixwidth">
					Roles: 
				</td>
				<td class="fixwidth">
					<?php echo implode(",",$user['roles']);?>
				</td>
			</tr>
			<tr>
				<td class="aliginright fixwidth">
					Region:
				</td>
				<td class="fixwidth">
					<?php echo $user['region'];?>
				</td>
				<td class="aliginright fixwidth">
					Location:
				</td>
				<td class="fixwidth"> 
					<?php echo $user['location'];?>
				</td>
			</tr>
			<tr>
				<td class="aliginright fixwidth">
					Phone:
				</td>
				<td class="fixwidth">
					<?php echo $user['tel'];?>
				</td>
				
				<td class="aliginright fixwidth">
					Email:
				</td>
				<td class="fixwidth">
					<?php echo $user['email'];?>
				</td>
			</tr>
			<tr>
				<td class="aliginright fixwidth">
					Made By:
				</td>
				<td class="fixwidth">
					<?php echo $user['madeby']=='y'?'Yes':'No';?>
				</td>
				
				<td class="aliginright fixwidth">
					Picked By:
				</td>
				<td class="fixwidth">
					<?php echo $user['pickedby']=='y'?'Yes':'No';?>
				</td>
			</tr>
			<tr>
				<td class="aliginright fixwidth">
					Created By:
				</td>
				<td class="fixwidth">
					<?php echo $data['create'];?>
				</td>
				<td class="aliginright fixwidth">
					Modified By:
				</td>
				<td class="fixwidth">
					<?php echo $data['modify'];?>
				</td>
			</tr>
		</tbody>
		</table>
	</div>
</div>
