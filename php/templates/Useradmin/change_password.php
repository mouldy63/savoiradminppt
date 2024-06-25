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
	<?php echo $this->element('userAdminUserControl',array('page'=>'change_pass','user'=>$user)); ?>
	<div class="lastlogin">
		<p>Last Logged in: <?php echo $user['last_login'];?></p>
		<?php echo $user['Retired']=='y'?'<p>Type: <b style="color:red;">Retired</b></p>':'<p>Type: <b>Current Employee</b></p>';?>
	</div>
	<div class="clear"></div>
	<div class="narrowarea">
		<div class="tag">
			<div class="tag1 tagitem">
				Send Reset Link	
			</div>
			<!--
			<div class="tag2 tagitem">
				Create New Password
			</div>
			-->
		</div>
		<div class="clear"></div>
		<div class="taginfo">
			<div class="tag1info taginfoitem">
				Send to: <br><input class="resetinput resetemail" type="email" required value="<?php echo $user['email'];?>" /><br><br>
			 	<button data-reset="<?php echo $user['user_id'];?>" id="redirectsubmit">Send the Link</button>
			</div>
			<div class="tag2info taginfoitem">
				Send to: <br><input class="resetinput resetpassemail" type="email" required value="<?php echo $user['email'];?>" /><br><br>
				Password: <br><input class="resetinput resetpass" type="text" required value="" /> <button id="passwordgenerate">Generate</button><br><br>
			 	<button data-reset="<?php echo $user['user_id'];?>" id="passwordsubmit">Send the Password</button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(document).ready(function(){
	setTimeout(function() {
        $('.tag1').trigger('click');
    },10);
	$('.tag1').on('click',function(){
		$('.tagitem').removeAttr('style');
		$(this).attr('style','background-color:lightgrey;');
		$('.taginfoitem').hide();
		$('.tag1info').show();
	});
	$('.tag2').click(function(){
		$('.tagitem').removeAttr('style');
		$(this).attr('style','background-color:lightgrey;');
		$('.taginfoitem').hide();
		$('.tag2info').show();
	});
	$('#passwordgenerate').click(function(){
		var newPass = generateRandomString();
		$('.resetpass').val(newPass);
	});
	$('#redirectsubmit').click(function(){
		var email = $('.resetemail').val();
		var reset = $(this).attr('data-reset');
		if(email===null || email.length<=0){
			alert("Email cannot be empty");
		}else{
			$.ajax({
			 method:'post',
			 url:'<?php echo Router::url('/', true);?>useradmin/changePassword',
			 data:{'choice':'link',
			 		'email':email,
			 		'reset':reset
			 		},
			 success:function(data){
			 	console.log(data);
			 	if(data == 'y'){
			 		alert("Password reset link has been sent to the user!");
			 	}
			 },
			 error:function(e){
			 }
			});
		}
	});
	$('#passwordsubmit').click(function(){
		var email = $('.resetpassemail').val();
		var reset = $(this).attr('data-reset');
		var p = $('.resetpass').val();
		var isemailempty = email===null || email.length<=0;
		var ispempty = p===null || p.length<=0;
		if(isemailempty||ispempty){
			alert("password or email cannot be empty");
		}else{
			$.ajax({
			 method:'post',
			 url:'<?php echo Router::url('/', true);?>useradmin/changePassword',
			 data:{'choice':'pass',
			 		'email':email,
			 		'user_id':'<?php echo $user['user_id']; ?>',
			 		'p':p,
			 		'reset':reset
			 		},
			 success:function(data){
			 	if(data == 'y'){
			 		alert("Password has been updated successfully!");
			 	}
			 },
			 error:function(e){
			 }
			});
		}
	});
});
function generateRandomString(){
		var randString="";
		var charUniverse="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$,;*)}]";
		for(var i=0; i<12; i++){
			var randInt=Math.floor(Math.random() * 68);
			var randChar=charUniverse[randInt];
			randString=randString + randChar;
		}
		return randString;
	}
</script>