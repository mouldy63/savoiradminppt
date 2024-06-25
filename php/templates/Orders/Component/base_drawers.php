<?php $this->extend('/Orders/Component/common'); ?>
<?php $tabIndex = $compId*100; ?>
<div class="col row-m-t col-sm-6 col-md-2 nopadding" id="base_drawers_div">
		Drawer Height:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding" id="base_drawers_div"><?= $this->Form->select('base_drawers_height', $this->MyForm->getOptions($this, 'base_drawers_height', $data), 
        		['val' => $this->MyForm->getDefaultValue($data, 'base_drawers_height'), 'id' => 'base_drawers_height', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div>

