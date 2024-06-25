<?php $this->extend('/Orders/Component/common'); ?>
<?php echo $this->Html->script('orders/headboard.js', array('inline' => false)); ?>
<?php
	$widthOptions = $this->MyForm->restrictOptions($this, $this->MyForm->getOptions($this, 'headboard_width', $data), [1,23,27], [4], ['183cm']);
?>
<?php $tabIndex = $compId*100; ?>
<div id="headboard_div">
	<?= $this->Form->hidden('headboard_trimreq', ['val' => $this->MyForm->getDefaultValue($data, 'headboard_trimreq'), 'id' => 'headboard_trimreq']); ?>
	<?= $this->Form->hidden('headboard_fabricreq', ['val' => $this->MyForm->getDefaultValue($data, 'headboard_fabricreq'), 'id' => 'headboard_fabricreq']); ?>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Headboard Style:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-4 nopadding"><?= $this->Form->select('headboard_style', $this->MyForm->getOptions($this, 'headboard_style', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'headboard_style'), 'id' => 'headboard_style', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Headboard Height:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-3 nopadding"><?= $this->Form->select('headboard_height', $this->MyForm->getOptions($this, 'headboard_height', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'headboard_height'), 'empty' => '(choose one)', 'id' => 'headboard_height', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Headboard Width:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('headboard_width', $widthOptions, 
            		['val' => $this->MyForm->getDefaultValue($data, 'headboard_width'), 'empty' => '(choose one)', 'id' => 'headboard_width', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div></div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Headboard Finish:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('headboard_finish', $this->MyForm->getOptions($this, 'headboard_finish', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'headboard_finish'), 'empty' => '(choose one)', 'id' => 'headboard_finish', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Supporting Leg Qty:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding"><?= $this->Form->select('headboard_legs', $this->MyForm->getOptions($this, 'headboard_legs', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'headboard_legs'), 'id' => 'headboard_legs', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div>
<div class="col row-m-t col-sm-6 col-md-1 nopadding headboardTrimClass">
Wooden Headboard Trim:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding headboardTrimClass"><?= $this->Form->select('headboard_manhattantrim', $this->MyForm->getOptions($this, 'headboard_manhattantrim', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'headboard_manhattantrim'), 'id' => 'headboard_manhattantrim', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div></div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding footboardClass">
Footboard Height:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-3 nopadding footboardClass"><?= $this->Form->select('headboard_footboardheight', $this->MyForm->getOptions($this, 'headboard_footboardheight', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'headboard_footboardheight'), 'id' => 'headboard_footboardheight', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding footboardClass">
Footboard Finish:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding footboardClass"><?= $this->Form->select('headboard_footboardfinish', $this->MyForm->getOptions($this, 'headboard_footboardfinish', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'headboard_footboardfinish'), 'id' => 'headboard_footboardfinish', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div></div>
<div class="row rowindent" id="headboard_fabric_div">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
			Fabric Options:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('headboard_fabric_options', $this->MyForm->getOptions($this, 'headboard_fabric_options', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'headboard_fabric_options'), 'empty' => '(choose one)', 'id' => 'headboard_fabric_options', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Fabric Company:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('headboard_fabric_company', 
            			['val' => $this->MyForm->getDefaultValue($data, 'headboard_fabric_company'), 'id' => 'headboard_fabric_company', 'size' => '25', 'maxlength' => '50', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Fabric Direction:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('headboard_fabric_direction', $this->MyForm->getOptions($this, 'headboard_fabric_direction', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'headboard_fabric_direction'), 'empty' => '(choose one)', 'id' => 'headboard_fabric_direction', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div></div>
<div class="row rowindent" id="headboard_fabric_div">
<div class="col row-m-t col-sm-6 col-md-4 nopadding">
Fabric Description (Design, Colour &amp; Code):&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-8 nopadding"><?= $this->Form->text('headboard_fabric_choice', 
            			['val' => $this->MyForm->getDefaultValue($data, 'headboard_fabric_choice'), 'id' => 'headboard_fabric_choice', 'size' => '50', 'maxlength' => '100', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div></div>
<div class="row rowindent" id="headboard_fabric_div">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
			Price Per Metre:&nbsp;<?=$this->OrderForm->getCurrencySymbol()?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('headboard_fabric_cost', 
	        			['val' => $this->MyForm->getDefaultValue($data, 'headboard_fabric_cost'), 'id' => 'headboard_fabric_cost', 'size' => '15',  'maxlength' => '20', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Fabric Quantity:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding"><?= $this->Form->text('headboard_fabric_metres', 
	        			['val' => $this->MyForm->getDefaultValue($data, 'headboard_fabric_metres'), 'id' => 'headboard_fabric_metres', 'size' => '15',  'maxlength' => '20', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
</div></div>
<div class="row rowindent" id="headboard_fabric_div">
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
Fabric Special Instructions:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-10 nopadding"><?= $this->Form->text('headboard_fabric_desc',
	        		['val' => $this->MyForm->getDefaultValue($data, 'headboard_fabric_desc'), 'id' => 'headboard_fabric_desc', 'size' => '100%',  'maxlength' => '250', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
	        		<br/>&nbsp;<b><span id="headboard_fabric_desc_counter"></span></b>
</div></div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
Headboard Special Instructions:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-10 nopadding"><?= $this->Form->textarea('headboard_instructions', 
					['val' => $this->MyForm->getDefaultValue($data, 'headboard_instructions'), 'id' => 'headboard_instructions', 'cols' => '65', 'tabindex' => $tabIndex++, 'class' => 'headboard-field']); ?>
					<br/>&nbsp;<b><span id="headboard_instructions_counter"></span></b>
</div><div>
	
	<div id="headboard_trim"></div>
	<div id="headboard_fabric"></div>

	<div><strong>Headboard Price Summary</strong></div>
	<div id="headboard_pricing">
	</div>

</div>
