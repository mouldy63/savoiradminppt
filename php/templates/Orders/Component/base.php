<?php $this->extend('/Orders/Component/common'); ?>
<?php echo $this->Html->script('orders/base.js', array('inline' => false)); ?>
<?php
	$baseWidthOptions = $this->MyForm->restrictOptions($this, $this->MyForm->getOptions($this, 'base_width', $data), [1,23,27], [4], ['183cm']);
	$baseLengthOptions = $this->MyForm->restrictOptions($this, $this->MyForm->getOptions($this, 'base_length', $data), [1,23,27], [4], ['213cm']);
?>
<?php $tabIndex = $compId*100; ?>
<div id="base_div" style="margin-bottom:20px;">
	<?= $this->Form->hidden('base_fabricreq', ['val' => $this->MyForm->getDefaultValue($data, 'base_fabricreq'), 'id' => 'base_fabricreq']); ?>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Base Model:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">           	<?= $this->Form->select('base_model', $this->MyForm->getOptions($this, 'base_model', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'base_model'), 'empty' => '(choose one)', 'id' => 'base_model', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Base Type:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-3 nopadding">            	<?= $this->Form->select('base_type', $this->MyForm->getOptions($this, 'base_type', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'base_type'), 'empty' => '(choose one)', 'id' => 'base_type', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Base Width:&nbsp;
 </div><div class="col row-m-t col-sm-6 col-md-2 nopadding">           	<?= $this->Form->select('base_width', $baseWidthOptions, 
            		['val' => $this->MyForm->getDefaultValue($data, 'base_width'), 'empty' => '(choose one)', 'id' => 'base_width', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div>
</div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Base Length:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">            	<?= $this->Form->select('base_length', $baseLengthOptions, 
            		['val' => $this->MyForm->getDefaultValue($data, 'base_length'), 'empty' => '(choose one)', 'id' => 'base_length', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Height Spring:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-3 nopadding">            	<?= $this->Form->select('base_springheight', $this->MyForm->getOptions($this, 'base_springheight', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'base_springheight'), 'empty' => '(choose one)', 'id' => 'base_springheight', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding">
Ticking Options:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding">            	<?= $this->Form->select('base_tickingoptions', $this->MyForm->getOptions($this, 'base_tickingoptions', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'base_tickingoptions'), 'empty' => '(choose one)', 'id' => 'base_tickingoptions', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div></div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">Link Position:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('base_linkposition', $this->MyForm->getOptions($this, 'base_linkposition', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'base_linkposition'), 'empty' => '(choose one)', 'id' => 'base_linkposition', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-1 nopadding linkFinishClass">
Link Finish:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding linkFinishClass"><?= $this->Form->select('base_linkfinish', $this->MyForm->getOptions($this, 'base_linkfinish', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'base_linkfinish'), 'empty' => '(choose one)', 'id' => 'base_linkfinish', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div></div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Base Trim:&nbsp;
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('base_trimreq', $this->MyForm->getOptions($this, 'base_trimreq', $data), 
        		['val' => $this->MyForm->getDefaultValue($data, 'base_trimreq'), 'id' => 'base_trimreq', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div><div class="col row-m-t col-sm-6 col-md-6 nopadding" id="base_trim">	
		BASETRIM PLACEHOLDER
	</div>
</div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">Base Drawers:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('base_drawersreq', $this->MyForm->getOptions($this, 'base_drawersreq', $data), 
        		['val' => $this->MyForm->getDefaultValue($data, 'base_drawersreq'), 'id' => 'base_drawersreq', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div>
<div class="col row-m-t col-sm-6 col-md-6 nopadding" id="base_drawers">
		BASEDRAWERS PLACEHOLDER
</div></div>
<div class="row rowindent">
<div id="id_base_specialwidth1">
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
        Base 1 Special Width cms
        </div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('base_specialwidth1', 
            			['val' => $this->MyForm->getDefaultValue($data, 'base_specialwidth1'), 'id' => 'base_specialwidth1', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div></div>
<div id="id_base_specialwidth2">
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
 Base 2 Special Width cms
 </div><div class="col row-m-t col-sm-6 col-md-2 nopadding">
<?= $this->Form->text('base_specialwidth2', 
            			['val' => $this->MyForm->getDefaultValue($data, 'base_specialwidth2'), 'id' => 'base_specialwidth2', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
    </div></div></div>
<div class="row rowindent">
<div id="id_base_speciallength1">
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
Base 1 Special Length cms
</div>
<div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('base_speciallength1', 
            			['val' => $this->MyForm->getDefaultValue($data, 'base_speciallength1'), 'id' => 'base_speciallength1', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
    </div></div>
<div id="id_base_speciallength2">
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
Base 2 Special Length cms  </div>
<div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->text('base_speciallength2', 
            			['val' => $this->MyForm->getDefaultValue($data, 'base_speciallength2'), 'id' => 'base_speciallength2', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div></div></div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-12 nopadding">
Base Special Instructions:
</div><div class="col row-m-t col-sm-6 col-md-12 nopadding">
<strong> 
		<?= $this->Form->textarea('base_instructions', 
			['val' => $this->MyForm->getDefaultValue($data, 'base_instructions'), 'id' => 'base_instructions', 'cols' => '65', 'tabindex' => $tabIndex++, 'class' => 'indentleft base-field']); ?>
			<br/>&nbsp;<b><span id="base_instructions_counter"></span></b>
	</strong>
</div></div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
	Upholstered Base:
</div><div class="col row-m-t col-sm-6 col-md-2 nopadding"><?= $this->Form->select('base_upholsteryreq', $this->MyForm->getOptions($this, 'base_upholsteryreq', $data), 
        		['val' => $this->MyForm->getDefaultValue($data, 'base_upholsteryreq'), 'id' => 'base_upholsteryreq', 'tabindex' => $tabIndex++, 'class' => 'base-field']); ?>
</div></div>	
	<div id="base_fabric">
		FABRICBASE PLACEHOLDER
	</div>
	<div id="base_upholstery">
		UPHOLSTEREDBASE PLACEHOLDER
	</div>

<div class="row rowindent">	<div><strong>Base Price Summary</strong></div>
	<div id="base_pricing">
	</div>
	</div>

</div>
