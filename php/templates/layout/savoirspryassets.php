<?php
/**
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       app.View.Layouts
 * @since         CakePHP(tm) v 0.10.0.1076
 * @license       http://www.opensource.org/licenses/mit-license.php MIT License
 */
use Cake\Core\Configure;
use Cake\Routing\Router;

$description = __d('cake_dev', 'Savoir Admin');
$cakeVersion = __d('cake_dev', 'CakePHP {0}', Configure::version())
?>
<!DOCTYPE html>
<html>
<head>
	<?php echo $this->Html->charset(); ?>
	<title>
		Savoir Admin
	</title>
	<?php
		echo $this->Html->meta('icon');

		echo $this->Html->css(['screen']);
		echo $this->Html->css(['jquery-confirm']);
		echo $this->Html->css(['SpryCollapsiblePanel2']);
		echo $this->Html->css(['homepage']);
		echo $this->Html->css(['//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css']);
		echo $this->Html->css(['//cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.0.3/jquery-confirm.min.css']);
		echo $this->fetch('meta');
		echo $this->fetch('css');
		echo $this->Html->script('SpryCollapsiblePanel.js');
		echo $this->Html->script('//code.jquery.com/jquery-3.3.1.js');
		echo $this->Html->script('//code.jquery.com/ui/1.11.2/jquery-ui.js');
		echo $this->Html->script('//cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.0.3/jquery-confirm.min.js');
		echo $this->Html->script('jquery.powertip.js');
		echo $this->Html->css(['jquery.powertip.css']);
		echo $this->fetch('script');

	?>
	<script type="text/javascript">
	    function keepSessionAlive() {
	        $.post("<?php echo Router::url('/', true);?>keepAlive/keepalive");
	    }
	    $(document).ready(doKeepSessionAlive());
	    
	    function doKeepSessionAlive() {
	    	window.setInterval("keepSessionAlive()", 60000);
	    }
	</script>
	<script>
$(function() {
var year = new Date().getFullYear();
$( "#monthfrom" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#monthfrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#monthto" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#monthto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});
	
</script>
<style>
#powerTip {
    max-width: 300px;
    padding: 10px;
    position: absolute;
	white-space:normal;
    z-index: 2147483647;}
    </style>
</head>
<body>
	<div id="container">
		<script>
			$(document).ready(function(){
				$.get("/getUserRoles.asp?ts="+Date.now(),function(roles){
					if (roles.trim().length === 0) {
						window.location = "/index.asp"; // force asp login
					}
				});
				$.get("<?php echo Router::url('/', true);?>header",function(data){
					jQuery('#header').empty();
					jQuery('#header').append(data);
				});
			});
		</script>
		<div id="header">
		</div>
		<div id="content">
			<div class="container" style="margin:-35px auto 17px auto;padding:0 15px;">
				<div class="row">
					<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 col-xl-12">
			<?php echo $this->Flash->render(); ?>
					</div>
				</div>
			</div>
			<?php echo $this->fetch('content'); ?>
		</div>
	</div>
</body>
</html>
