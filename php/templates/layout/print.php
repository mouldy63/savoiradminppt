<?php
use Cake\Core\Configure;
use Cake\Routing\Router;

?>
<!DOCTYPE html>
<html>
<head>
	<?php echo $this->Html->charset(); ?>
	<?php
		echo $this->Html->meta('icon');
		echo $this->Html->css(['printletter'],['media' => 'screen']);
		echo $this->Html->css(['printletter1'],['media' => 'print']);
		echo $this->Html->css(['//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css']);
		echo $this->fetch('meta');
		echo $this->fetch('css');
		echo $this->Html->script('//code.jquery.com/jquery-1.10.2.js');
		echo $this->Html->script('//code.jquery.com/ui/1.11.2/jquery-ui.js');
		echo $this->fetch('script');
	?>
</head>
<body onLoad="window.print();">
	
			<?php echo $this->fetch('content'); ?>
		
</body>
</html>
