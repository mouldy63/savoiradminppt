<?php
/**
 * @var \App\View\AppView $this
 * 
 */
?>
<?php

use Cake\Routing\Router; ?>
<?php echo $this->Html->css('bootstrap.min.css', array('inline' => false)); ?>
<?php echo $this->Html->css('fabricStatus.css', array('inline' => false)); ?>
<?php echo $this->Html->css('userAdmin.css', array('inline' => false)); ?>
<?php echo $this->Html->css('style.css', array('inline' => false)); ?>
<?php echo $this->Html->script('popper.min.js', array('inline' => false)); ?>
<?php echo $this->Html->script('bootstrap.min.js', array('inline' => false)); ?>
<div class="container">
    <div class="border">
	<div class="row">
        <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 col-xl-12">
            <table class="table mx-auto" style="width:70%;">
                <tbody>
                    <tr valign="top">
                    <td width="647" class="maintext" border="0">
                    <p>
                        
                    </p>
                    <p>SALES ADMINISTRATION </p>
                    <p><a href="<?=Router::url('/', true)?>sales-detail/planned-exports">Planned Export Collections</a></p>
                    <p><a href="<?=Router::url('/', true)?>sales-detail/delivered-exports">Delivered Shipments</a></p>
                    
                    <p><a href="<?=Router::url('/', true)?>sales-detail/cancelled-exports">Cancelled Shipments</a></p>

                    </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
	</div>
</div>