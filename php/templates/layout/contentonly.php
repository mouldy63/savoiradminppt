<?php
use Cake\Core\Configure;
use Cake\Routing\Router;

?>
<!DOCTYPE html>
<html>
<head>
	<?php echo $this->Html->charset(); ?>
	<?php
		echo $this->Html->css(['screen']);
		echo $this->fetch('css');
	?>
</head>
<body>
	
			<?php echo $this->fetch('content'); ?>
		
</body>
</html>
