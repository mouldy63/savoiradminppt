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

		echo $this->fetch('meta');
		echo $this->fetch('css');
		echo $this->Html->script('//code.jquery.com/jquery-3.5.1.js');
		echo $this->Html->css(['//cdn.datatables.net/1.13.2/css/jquery.dataTables.min.css']);
		echo $this->Html->script('//cdn.datatables.net/1.13.2/js/jquery.dataTables.min.js');
		echo $this->Html->script('//cdn.datatables.net/plug-ins/1.10.11/sorting/date-eu.js');
        echo $this->Html->script('//cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js');
        echo $this->Html->script('//cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js');
        echo $this->Html->script('//cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js');
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
