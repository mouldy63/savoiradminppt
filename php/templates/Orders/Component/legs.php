<?php $this->extend('/Orders/Component/common'); ?>
<?php echo $this->Html->script('orders/legs.js', array('inline' => false)); ?>
<?php $tabIndex = $compId*100; ?>
<div class="row rowindent"  id="legs_div">

	<?= $this->Form->hidden('legs_addreq', ['val' => $this->MyForm->getDefaultValue($data, 'legs_addreq'), 'id' => 'legs_addreq']); ?>
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Feature Leg:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('legs_style', $this->MyForm->getOptions($this, 'legs_style', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'legs_style'), 'empty' => '(choose one)', 'id' => 'legs_style', 'tabindex' => $tabIndex++, 'class' => 'legs-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Quantity Legs:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding"><?= $this->Form->select('legs_qty', $this->MyForm->getOptions($this, 'legs_qty', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'legs_qty'), 'id' => 'legs_qty', 'tabindex' => $tabIndex++, 'class' => 'legs-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Leg Finish:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('legs_finish', $this->MyForm->getOptions($this, 'legs_finish', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'legs_finish'), 'empty' => '(choose one)', 'id' => 'legs_finish', 'tabindex' => $tabIndex++, 'class' => 'legs-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Leg Height:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding"><?= $this->Form->select('legs_height', $this->MyForm->getOptions($this, 'legs_height', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'legs_height'), 'empty' => '(choose one)', 'id' => 'legs_height', 'tabindex' => $tabIndex++, 'class' => 'legs-field']); ?>
</div></div>
<div class="row rowindent"  id="legs_div">
<div class="col row-m-t col-sm-6 col-md-1 nopadding legs_floortype_class">
Floor Type:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding legs_floortype_class"><?= $this->Form->select('legs_floortype', $this->MyForm->getOptions($this, 'legs_floortype', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'legs_floortype'), 'empty' => '(choose one)', 'id' => 'legs_floortype', 'tabindex' => $tabIndex++, 'class' => 'legs-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding legs_specialheight_class">
Special Height:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding legs_specialheight_class"><?= $this->Form->text('legs_specialheight', 
           			['val' => $this->MyForm->getDefaultValue($data, 'legs_specialheight'), 'id' => 'legs_specialheight', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => 'legs-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Support Leg:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('legs_addstyle', $this->MyForm->getOptions($this, 'legs_addstyle', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'legs_addstyle'), 'empty' => '(choose one)', 'id' => 'legs_addstyle', 'tabindex' => $tabIndex++, 'class' => 'legs-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">Quantity Legs:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding"><?= $this->Form->select('legs_addqty', $this->MyForm->getOptions($this, 'legs_addqty', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'legs_addqty'), 'id' => 'legs_addqty', 'tabindex' => $tabIndex++, 'class' => 'legs-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">Leg Finish:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding"><?= $this->Form->select('legs_addfinish', $this->MyForm->getOptions($this, 'legs_addfinish', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'legs_addfinish'), 'empty' => '(choose one)', 'id' => 'legs_addfinish', 'tabindex' => $tabIndex++, 'class' => 'legs-field']); ?>
</div></div>
<div class="row rowindent"  id="legs_div">
<div class="col row-m-t col-sm-12 col-md-12 nopadding">Legs Special Instructions:<br>
    <strong> 
		<?= $this->Form->textarea('legs_specialinstructions', 
			['val' => $this->MyForm->getDefaultValue($data, 'legs_specialinstructions'), 'id' => 'legs_specialinstructions', 'cols' => '65', 'rows' => '2', 'tabindex' => $tabIndex++, 'class' => 'indentleft legs-field']); ?>
			<br/>&nbsp;<b><span id="legs_specialinstructions_counter"></span></b>

	
	<br/><br/><br/><br/>
	<div><strong>Legs Price Summary</strong></div>
	<div id="legs_pricing">
	</div>
</div>

