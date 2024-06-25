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

		echo $this->Html->css(['//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css']);
		echo $this->fetch('meta');
		echo $this->fetch('css');
		echo $this->Html->script('//code.jquery.com/jquery-3.5.1.js');
		echo $this->Html->script('//code.jquery.com/ui/3.5.1/jquery-ui.js');
		echo $this->Html->css(['//cdn.datatables.net/1.13.1/css/jquery.dataTables.min.css']);
		echo $this->Html->script('//cdn.datatables.net/1.13.1/js/jquery.dataTables.js');
		echo $this->Html->script('//cdn.datatables.net/plug-ins/1.10.11/sorting/date-eu.js');
		echo $this->Html->script('https://cdn.datatables.net/fixedcolumns/4.2.1/js/dataTables.fixedColumns.min.js');
		echo $this->Html->script('https://cdn.datatables.net/fixedcolumns/4.2.1/css/fixedColumns.dataTables.min.css');
		echo $this->Html->script('https://cdn.datatables.net/fixedheader/3.3.1/js/dataTables.fixedHeader.min.js');
		echo $this->Html->script('//cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css');
		echo $this->Html->script('//cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/js/all.min.js');
		echo $this->Html->css(['screen']);
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
<body class="productionlist">
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
			<div class="container" style="margin:-25px auto 17px auto;padding:0 15px;">
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
