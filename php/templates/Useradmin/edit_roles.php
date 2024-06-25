<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('userAdmin.css',array('inline' => false));?>
<?php echo $this->Html->css('jquery-ui.min.css',array('inline' => false));?>
<?php echo $this->Html->script('jquery-ui.min.js', array('inline' => false)); ?>
<?php echo $this->element('userAdminHead',array('page'=>'editroles'));?>
<?php $user = $data['user']; $roles = $data['roles'];?>
<input type="hidden" id="userId" value="<?php echo $user['user_id'];?>"/>
<div id="userdetail">
	<div>
		<h5><?php echo empty($user['name'])?$user['username']:$user['name'].': '.$user['username'];?></h5>
	</div>
	<?php echo $this->element('userAdminUserControl',array('page'=>'edit_roles','user'=>$user)); ?>
	<div class="multiinfoarea">
	<div class="lastlogin">
		<p>Last Logged in: <?php echo $user['last_login'];?></p>
		<?php echo $user['Retired']=='y'?'<p>Type: <b style="color:red;">Retired</b></p>':'<p>Type: <b>Current Employee</b></p>';?>
	</div>
	<div class-"clear"></div>
	</div>
	<div class="narrowarea">
		<div style="text=align:left;">
			<h3>Instruction</h3>
			<p style="font-size:13px;">Add Permissions: Please drag the permission from "Available Permissions" area and drop it in the "Current Permissions" area, then press the button "Submit."</p>
			<p style="font-size:13px;">Delete Permissions: Please drag the permission from "Current Permissions" area and drop it in the "Available Permissions" area, then press the button "Submit.</p>
			<p style="font-size:13px;">Or you can press the "-" and "+" on the side of the permission button.
		</div>
		<div class="currentrole">
			<div class="title">
				<h5>Current Permissions</h5>
			</div>
			<div class="currentroleArea droppable">
				<ul class="currentrolelist">
				<?php 
				$ii=0;

				foreach($user['role_id'] as $role_id):
					$role_name = $user['roles'][$ii];
					$ii++;
					$description = '';
					foreach($roles as $role){
						if($role['id']==$role_id){
							$description = $role['description'];
						}
					}
				?>
					<li class="roleblock draggable" data-id="<?php echo $role_id;?>">
						<div>
							<div class="role-title"><?php echo $role_name;?></div>
							<div class="role-control"><a href="#" class="action" onclick="changePermission(this);return false;">-</a></div>
							<div class="clear"></div>
						</div>
						<div class="role-description"><?php echo $description;?></div>
					</li>
				<?php endforeach;?>
				</ul>
			</div>
		</div>
		<div class="availablerole">
			<div class="title">
				<h5>Available Permissions</h5>
			</div>
			<div class="availableroleArea droppable">
				<ul class="availablerolelist ">
				<?php foreach($data['roles'] as $roles):?>
						<?php if(!in_array($roles['id'], $user['role_id'])):?>
							<li class="roleblock draggable" data-id="<?php echo $roles['id'];?>">
								<div>
									<div class="role-title"><?php echo $roles['role'];?></div>
									<div class="role-control"><a href="#" class="action" onclick="changePermission(this);return false;">+</a></div>
									<div class="clear"></div>
								</div>
								<div class="role-description"><?php echo $roles['description'];?></div>
							</li>
						<?php endif;?>
				<?php endforeach;?>
				</ul>
			</div>
		</div>
		<div class="clear"></div>
		<div class="controlarea ">
			<button class="submit">Submit</button>
		</div>
	</div>
</div>
<script type="text/javascript">
$(document).ready(function(){
	$('.draggable').draggable({
		revert: "invalid",
      	containment: "document",
      	helper: "clone",
      	cursor: "move",
      	drag: function() {
      		$('.droppable').attr('style','background-color:lightyellow;');
      		$('.role-description').hide();
      	},
      	stop: function() {
      		$('.droppable').removeAttr('style');
      	}
    });

	$('.currentroleArea.droppable').droppable({
    	accept: ".draggable",
    	drop:function(event,ui){
    		addRole(ui.draggable);
    	}
    });
    $('.availableroleArea.droppable').droppable({
    	accept: ".draggable",
    	drop:function(event,ui){
    		deleteRole(ui.draggable);
    	}
    });
    $('.roleblock.draggable').hover(function(){
    	$(this).find('.role-description').show();
    },function(){
    	$(this).find('.role-description').hide();
    });
    
    $('.role-control a').hover(function(){
    	$('.role-description').hide();
    },function(){
    	$('.role-description').removeAttr('style');
    });
    
    $('.controlarea .submit').click(function(){
    	var roles = $('.currentrolelist').find('.roleblock');
    	if(roles.length>0){
    		var ids=[];
    		var id = $('#userId').val();
    		for(var i=0;i<roles.length;i++){
    			ids[i] = $(roles[i]).attr('data-id');
    		}
    		var strids = JSON.stringify(ids);
    		$.ajax({
    			method:'post',
    			url:'/php/useradmin/editRoles',
    			data:{'id':id,
    					'role_ids':strids
    				},
    			success:function(data){
    				if(data=='y'){
    					window.location = '/php/useradmin/userDetail?id=' + id + '&msgno=2';
    				}
    			},
    			error:function(e){
    				alert('Transmission not successful, please try again!');
    			}
    		});
    	}
    	else{
   			alert('User has to have at least one role.'); 	
    	}
    });
});
function deleteRole(item){
	$('.availablerolelist').append(item);
	$(item).find('.action').html('+');
	//item.remove();
}
function addRole(item){
	$('.currentrolelist').append(item);
	$(item).find('.action').html('-');
	//item.remove();
}
function changePermission(element){
	var actionString = $(element).html();
	var action;
	if(actionString =='-'){
		action = 'delete';
	}else{
		action = 'add';
	}
	var e = $(element).parent().parent().parent();
	if(action =='add'){
		addRole(e);
	}else{
		deleteRole(e);
	}
}
</script>