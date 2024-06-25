<?php $this->extend('/Orders/Component/common'); ?>
<?php echo $this->Html->script('orders/valance.js', array('inline' => false)); ?>
<?php $tabIndex = $compId*100; ?>
<div id="valance_div">
	<?= $this->Form->hidden('valance_fabricreq', ['val' => $this->MyForm->getDefaultValue($data, 'valance_fabricreq'), 'id' => 'valance_fabricreq']); ?>
	<div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
No. of Pleats:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding"><?= $this->Form->select('valance_pleats', $this->MyForm->getOptions($this, 'valance_pleats', $data), 
			['val' => $this->MyForm->getDefaultValue($data, 'valance_pleats'), 'id' => 'valance_pleats', 'tabindex' => $tabIndex++, 'class' => 'valance-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">
Fabric Company:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('valance_fabric_company', 
   			['val' => $this->MyForm->getDefaultValue($data, 'valance_fabric_company'), 'id' => 'valance_fabric_company', 'size' => '25', 'maxlength' => '50', 'tabindex' => $tabIndex++, 'class' => 'valance-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">
Fabric Design, Colour &amp; Code:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('valance_fabric_choice', 
            			['val' => $this->MyForm->getDefaultValue($data, 'valance_fabric_choice'), 'id' => 'valance_fabric_choice', 'size' => '50', 'maxlength' => '100', 'tabindex' => $tabIndex++, 'class' => 'valance-field']); ?>
</div></div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Fabric Options:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('valance_fabric_options', $this->MyForm->getOptions($this, 'valance_fabric_options', $data), 
        		['val' => $this->MyForm->getDefaultValue($data, 'valance_fabric_options'), 'id' => 'valance_fabric_options', 'tabindex' => $tabIndex++, 'class' => 'valance-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Fabric Direction:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('valance_fabric_direction', $this->MyForm->getOptions($this, 'valance_fabric_direction', $data), 
        		['val' => $this->MyForm->getDefaultValue($data, 'valance_fabric_direction'), 'id' => 'valance_fabric_direction', 'tabindex' => $tabIndex++, 'class' => 'valance-field']); ?>
</div></div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
Price Per Metre:&nbsp;<?=$this->OrderForm->getCurrencySymbol()?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('valance_fabric_cost', 
        			['val' => $this->MyForm->getDefaultValue($data, 'valance_fabric_cost'), 'id' => 'valance_fabric_cost', 'size' => '15',  'maxlength' => '20', 'tabindex' => $tabIndex++, 'class' => 'valance-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">
Fabric Quantity:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('valance_fabric_metres', 
        			['val' => $this->MyForm->getDefaultValue($data, 'valance_fabric_metres'), 'id' => 'valance_fabric_metres', 'size' => '15',  'maxlength' => '20', 'tabindex' => $tabIndex++, 'class' => 'valance-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">
        			Valance Fabric Price to be added
</div>

</div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
Valance Drop:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('valance_drop', 
        			['val' => $this->MyForm->getDefaultValue($data, 'valance_drop'), 'id' => 'valance_drop', 'size' => '15',  'maxlength' => '20', 'tabindex' => $tabIndex++, 'class' => 'valance-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">
Valance Width:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('valance_width', 
        			['val' => $this->MyForm->getDefaultValue($data, 'valance_width'), 'id' => 'valance_width', 'size' => '15',  'maxlength' => '20', 'tabindex' => $tabIndex++, 'class' => 'valance-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">
Valance Length:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('valance_length', 
        			['val' => $this->MyForm->getDefaultValue($data, 'valance_length'), 'id' => 'valance_length', 'size' => '15',  'maxlength' => '20', 'tabindex' => $tabIndex++, 'class' => 'valance-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">
Valance Special Instructions:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->textarea('valance_instructions', 
		['val' => $this->MyForm->getDefaultValue($data, 'valance_instructions'), 'id' => 'valance_instructions', 'cols' => '65', 'tabindex' => $tabIndex++, 'class' => 'indentleft valance-field']); ?>
		<br/>&nbsp;<b><span id="valance_instructions_counter"></span></b>
</div></div></div>
	<br/>
	<div><strong>Valance Price Summary</strong></div>
	<div id="valance_pricing">
	</div>

</div>
