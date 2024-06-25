<?php echo $this->Html->css('fabricStatus.css',array('inline' => false));?>
<?php echo $this->Html->css('userAdmin.css',array('inline' => false));?>
<?php echo $data['msg'];

?>
<script type="text/javascript">
	setTimeout(function(){ window.location = '<?php echo $data['link'];?>'; }, 4000);
	
</script>