<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('userAdmin.css',array('inline' => false));?>


<h3 style="margin-top:30px">Please Enter your new password</h3>
        <ul>
			<li style="font-size: 15px;margin: 14px 35px;">The length of the Password should be more than 8.</li>
			<li style="font-size: 15px;margin: 14px 35px;">The Password has to include at least 1 lowercase letter, 1 uppercase letter and 1 digit.</li>
		</ul>

<form class="pure-form" method="post" action="/php/reset/reset">
    <fieldset>
        
        <input type="hidden" name="reset2" value="<?php echo $data['id'];?>"/>
        <input type="hidden" name="reset" value="<?php echo $data['user_id'];?>"/>
        <input type="password" name="pass" placeholder="Password" id="password" required>
        <input type="password" name="confirmpass" placeholder="Confirm Password" id="confirm_password" required>

        <input type="submit" class="pure-button pure-button-primary"/>
    </fieldset>
</form>
<script type="text/javascript">
var password = document.getElementById("password")
  , confirm_password = document.getElementById("confirm_password");

function validatePassword(){
  if(password.value != confirm_password.value) {
    confirm_password.setCustomValidity("Passwords Don't Match");
  } else {
  	var pass = isPassOk(confirm_password.value);
  	if(pass){
  		confirm_password.setCustomValidity('');
  	}else{
  		confirm_password.setCustomValidity("The length of the Password should be more than 8, and the Password has to include at least 1 lowercase letter, 1 uppercase letter and 1 digit.");
  	}
    
  }
}
function isPassOk(pass){
	if(pass.length<8){
		return false;
	}
	var isMatched = pass.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$/);
	return isMatched == null?false:true;
}
password.onchange = validatePassword;
confirm_password.onkeyup = validatePassword;

</script>