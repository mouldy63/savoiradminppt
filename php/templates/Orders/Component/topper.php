<?php $this->extend('/Orders/Component/common'); ?>
<?php echo $this->Html->script('orders/topper.js', array('inline' => false)); ?>
<?php
	$topperWidthOptions = $this->MyForm->restrictOptions($this, $this->MyForm->getOptions($this, 'topper_width', $data), [1,23,27], [4], ['183cm']);
	$topperLengthOptions = $this->MyForm->restrictOptions($this, $this->MyForm->getOptions($this, 'topper_length', $data), [1,23,27], [4], ['213cm']);
?>
<?php $tabIndex = $compId*100; ?>
<div id="topper_div" style="margin-bottom:20px;">
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Topper Type:</div>
<div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('topper_type', $this->MyForm->getOptions($this, 'topper_type', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'topper_type'), 'empty' => '(choose one)', 'id' => 'topper_type', 'tabindex' => $tabIndex++, 'class' => 'topper-field']); ?>
</div>
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Topper Width:
</div>
<div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('topper_width', $topperWidthOptions, 
            		['val' => $this->MyForm->getDefaultValue($data, 'topper_width'), 'empty' => '(choose one)', 'id' => 'topper_width', 'tabindex' => $tabIndex++, 'class' => 'topper-field']); ?>
</div>
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Topper Length:
</div>
<div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('topper_length', $topperLengthOptions, 
            		['val' => $this->MyForm->getDefaultValue($data, 'topper_length'), 'empty' => '(choose one)', 'id' => 'topper_length', 'tabindex' => $tabIndex++, 'class' => 'topper-field']); ?>
</div>
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Ticking Options:
</div>
<div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('topper_tickingoptions', $this->MyForm->getOptions($this, 'topper_tickingoptions', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'topper_tickingoptions'), 'empty' => '(choose one)', 'id' => 'topper_tickingoptions', 'tabindex' => $tabIndex++, 'class' => 'topper-field']); ?>
</div>
</div>
<div class="row rowindent">

	<div id="id_topper_specialwidth1">
 		 <div class="col row-m-t col-sm-6 col-md-2 nopadding" id="id_topper_specialwidth1">
      Topper Special Width cms
      </div><div class="col row-m-t col-sm-6 col-md-2 nopadding" id="id_topper_specialwidth1">
	            	<?= $this->Form->text('topper_specialwidth1', 
            			['val' => $this->MyForm->getDefaultValue($data, 'topper_specialwidth1'), 'id' => 'topper_specialwidth1', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => 'topper-field']); ?>
 		</div>
    </div>

    <div id="id_topper_speciallength1">
        <div class="col row-m-t col-sm-6 col-md-2 nopadding" id="id_topper_speciallength1">
                Topper Special Length cms
	            </div> <div class="col row-m-t col-sm-6 col-md-2 nopadding" id="id_topper_speciallength1">
	            	<?= $this->Form->text('topper_speciallength1', 
            			['val' => $this->MyForm->getDefaultValue($data, 'topper_speciallength1'), 'id' => 'topper_speciallength1', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => 'topper-field']); ?>
        </div>
    </div>
</div>
<div class="row rowindent">
<p>Topper Special Instructions:</p>
	<div>
    <strong> 
		<?= $this->Form->textarea('topper_instructions', 
			['val' => $this->MyForm->getDefaultValue($data, 'topper_instructions'), 'id' => 'topper_instructions', 'cols' => '65', 'tabindex' => $tabIndex++, 'class' => 'indentleft topper-field']); ?>
			<br/>&nbsp;<b><span id="topper_instructions_counter"></span></b>
	</strong>
	</div>
	<br/><br/><br/><br/>
	<div><strong>Topper Price Summary</strong></div>
	<div id="topper_pricing">
	</div></div>

</div>

