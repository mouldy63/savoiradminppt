<?php $this->extend('/Orders/Component/common'); ?>
<?php $tabIndex = $compId*100; ?>
<div class="row rowindent" id="base_fabric_div">
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
Fabric Company:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('base_fabric_company', 
        			['val' => $this->MyForm->getDefaultValue($data, 'base_fabric_company'), 'id' => 'base_fabric_company', 'size' => '25',  'maxlength' => '50', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">
Fabric Design, Colour & Code:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-6 nopadding"><?= $this->Form->text('base_fabric_choice', 
        			['val' => $this->MyForm->getDefaultValue($data, 'base_fabric_choice'), 'id' => 'base_fabric_choice', 'size' => '50',  'maxlength' => '100', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div></div>
<div class="row rowindent" id="base_fabric_div">
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
		Base Fabric Direction:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('base_fabric_direction', $this->MyForm->getOptions($this, 'base_fabric_direction', $data), 
        		['val' => $this->MyForm->getDefaultValue($data, 'base_fabric_direction'), 'id' => 'base_fabric_direction', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div>
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
Price Per Metre:&nbsp;<?=$this->OrderForm->getCurrencySymbol()?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('base_fabric_cost', 
        			['val' => $this->MyForm->getDefaultValue($data, 'base_fabric_cost'), 'id' => 'base_fabric_cost', 'size' => '15',  'maxlength' => '20', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">
Fabric Quantity:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">	<?= $this->Form->text('base_fabric_metres', 
        			['val' => $this->MyForm->getDefaultValue($data, 'base_fabric_metres'), 'id' => 'base_fabric_metres', 'size' => '15',  'maxlength' => '20', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div></div>
<div class="row rowindent" id="base_fabric_div">
<div class="col row-m-t col-sm-12 col-md-12 nopadding">
Fabric Special Instructions:&nbsp;
<br><?= $this->Form->text('base_fabric_instructions', 
        			['val' => $this->MyForm->getDefaultValue($data, 'base_fabric_instructions'), 'id' => 'base_fabric_instructions', 'size' => '85',  'maxlength' => '250', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
				&nbsp;<b><span id="base_fabric_instructions_counter"></span></b>
</div></div>
<script>
	$(document).ready(function() {
		registerTextareaUsageCounter('base_fabric_instructions', 'base_fabric_instructions_counter', 250);
	});
</script>