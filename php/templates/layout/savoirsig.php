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

		
		echo $this->Html->css(['//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css']);
		echo $this->Html->css(['//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css']);
		echo $this->Html->css(['//cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css']);
		echo $this->fetch('meta');
		echo $this->fetch('css');
		echo $this->Html->script('//code.jquery.com/jquery-3.6.0.js');
		echo $this->Html->script('//code.jquery.com/ui/1.13.2/jquery-ui.js');
		echo $this->Html->script('jquery.eComboBox.custom.js', array('inline' => false));
		echo $this->Html->script('price-matrix-funcs.js', array('inline' => false));
		//echo $this->Html->script('json2.min.js', array('inline' => false));

		echo $this->fetch('script');
	?>
	<!-- Bootstrap - Latest compiled and minified CSS -->
	
	<!-- Bootstrap - Optional theme -->
	
	<!-- Bootstrap - Latest compiled and minified JavaScript -->
	
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>	
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
	
<?php
		echo $this->Html->meta('icon');

		echo $this->Html->css(['screenbs']);
        echo $this->Html->css(['jquery.signaturepad.css']);
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
					$.get("<?php echo Router::url('/', true);?>header",function(data){
					var home = '<?php echo substr(Router::url('/', true),0,-4);?>';
					if(data.indexOf('User Name')>=0 && data.indexOf('Password')>=0){						
						window.location = home;
					}
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
    <?php
        echo $this->Html->script(['jquery.signaturepad.min.js']);
		echo $this->fetch('script');
	?>   
</body>
</html>
