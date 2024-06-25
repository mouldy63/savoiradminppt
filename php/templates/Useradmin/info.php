<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('userAdmin.css',array('inline' => false));?>
<?php 
echo $this->element('userAdminHead',array('page'=>'index'));
?>

<?php
	if($data['error_code'] == 1){
		$redirectURL = Router::url('/', true).'useradmin/createUser';
	}
	if($data['error_code'] == 2){
		$redirectURL = Router::url('/', true).'useradmin/userDetail';
	}
?>
<h3><?php echo $data['msg'] ;?></h3>
<script type="text/javascript">
	setTimeout(function(){ window.location = '<?php echo $redirectURL;?>';}, 3000);
	
</script>