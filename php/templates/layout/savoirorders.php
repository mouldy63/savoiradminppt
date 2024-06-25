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

$description = __d('cake_dev', 'Savoir Admin - Orders');
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

		echo $this->Html->css(['screen-orders']);
		echo $this->Html->css(['//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css']);
		echo $this->fetch('meta');
		echo $this->fetch('css');
		echo $this->Html->script('//code.jquery.com/jquery-1.10.2.js');
		echo $this->Html->script('//code.jquery.com/ui/1.11.2/jquery-ui.js');
		echo $this->fetch('script');
	?>
	<!-- Bootstrap - Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
	<!-- Bootstrap - Optional theme -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">
	<!-- Bootstrap - Latest compiled and minified JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
<?php
		echo $this->Html->meta('icon');

		echo $this->Html->css(['scroders']);
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
			<!--<a href="/index.asp" style="float:left;"><img src="/images/logo-s.gif" border="0"></a>-->
			
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
