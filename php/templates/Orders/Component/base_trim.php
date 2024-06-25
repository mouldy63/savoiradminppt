<?php $this->extend('/Orders/Component/common'); ?>
<?php $tabIndex = $compId*100; ?>
<div class="col row-m-t col-sm-6 col-md-2 nopadding" id="base_trim" id="base_trim_div">
		Base Trim Colour:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding" id="base_trim" id="base_trim_div"><?= $this->Form->select('base_trim_colour', $this->MyForm->getOptions($this, 'base_trim_colour', $data), 
        		['val' => $this->MyForm->getDefaultValue($data, 'base_trim_colour'), 'id' => 'base_trim_colour', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>

</div>

