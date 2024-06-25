<?php $this->extend('/Orders/Component/common'); ?>
<?php echo $this->Html->script('orders/mattress.js', array('inline' => false)); ?>
<?php $tabIndex = $compId*100; ?>
<div id="mattress_div" style="margin-bottom:20px;">
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Savoir Model:
</div>
<div class="col row-m-t col-sm-6 col-md-3 nopadding">
            	<?= $this->Form->select('mattress_model', $this->MyForm->getOptions($this, 'mattress_model', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'mattress_model'), 'empty' => '(choose one)', 'id' => 'mattress_model', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
</div>
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Mattress Type:
</div>
<div class="col row-m-t col-sm-6 col-md-3 nopadding">
            	<?= $this->Form->select('mattress_type', $this->MyForm->getOptions($this, 'mattress_type', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'mattress_type'), 'empty' => '(choose one)', 'id' => 'mattress_type', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
</div>
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Ticking Options
</div>
<div class="col row-m-t col-sm-6 col-md-3 nopadding">
<?= $this->Form->select('mattress_tickingoptions', $this->MyForm->getOptions($this, 'mattress_tickingoptions', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'mattress_tickingoptions'), 'empty' => '(choose one)', 'id' => 'mattress_tickingoptions', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
</div>
</div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Mattress Width:</div>
<div class="col row-m-t col-sm-6 col-md-3 nopadding">
<?= $this->Form->select('mattress_width', $this->MyForm->getOptions($this, 'mattress_width', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'mattress_width'), 'empty' => '(choose one)', 'id' => 'mattress_width', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
</div>
<div class="col row-m-t col-sm-6 col-md-1 nopadding">
Mattress Length:</div>
<div class="col row-m-t col-sm-6 col-md-3 nopadding"><?= $this->Form->select('mattress_length', $this->MyForm->getOptions($this, 'mattress_length', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'mattress_length'), 'empty' => '(choose one)', 'id' => 'mattress_length', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
</div>
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
</div>
<div class="col row-m-t col-sm-6 col-md-2 nopadding">
</div>
</div>
<div class="clear"></div>
<div class="row rowindent">
	<div id="id_mattress_specialwidth1">
		<div class="col row-m-t col-sm-6 col-md-3 nopadding">
		Mattress 1 Special Width cms
		</div>
		<div class="col row-m-t col-sm-6 col-md-3 nopadding">
	            	<?= $this->Form->text('mattress_specialwidth1', 
            			['val' => $this->MyForm->getDefaultValue($data, 'mattress_specialwidth1'), 'id' => 'mattress_specialwidth1', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
		</div>
	</div>
	<div id="id_mattress_specialwidth2">
		<div class="col row-m-t col-sm-6 col-md-3 nopadding">Mattress 2 Special Width cms
		</div>
		<div class="col row-m-t col-sm-6 col-md-3 nopadding">
	            	<?= $this->Form->text('mattress_specialwidth2', 
            			['val' => $this->MyForm->getDefaultValue($data, 'mattress_specialwidth2'), 'id' => 'mattress_specialwidth2', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
     	</div>
   </div>


	<div id="id_mattress_speciallength1">
		<div class="col row-m-t col-sm-6 col-md-3 nopadding">
Mattress 1 Special Length cms
		</div>
		<div class="col row-m-t col-sm-6 col-md-3 nopadding">
<?= $this->Form->text('mattress_speciallength1', 
            			['val' => $this->MyForm->getDefaultValue($data, 'mattress_speciallength1'), 'id' => 'mattress_speciallength1', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
        </div>
	</div>

	<div id="id_mattress_speciallength2">
        <div class="col row-m-t col-sm-6 col-md-3 nopadding">
        Mattress 2 Special Length cms</td>
		</div>
		<div class="col row-m-t col-sm-6 col-md-3 nopadding">
	            	<?= $this->Form->text('mattress_speciallength2', 
            			['val' => $this->MyForm->getDefaultValue($data, 'mattress_speciallength2'), 'id' => 'mattress_speciallength2', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
       </div>
    </div>
</div>
    <div class="clear"></div>
<div class="row rowindent">
<div class="col row-m-t col-sm-12 col-md-12 nopadding">
    <p>Support (as viewed from the foot looking toward the head end):</p>
</div>
</div>
<div class="row rowindent">
<div class="col row-m-t col-sm-6 col-md-3 nopadding">Left Support:

           	<?= $this->Form->select('mattress_leftsupport', $this->MyForm->getOptions($this, 'mattress_leftsupport', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'mattress_leftsupport'), 'empty' => '(choose one)', 'id' => 'mattress_leftsupport', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
</div> <div class="col row-m-t col-sm-6 col-md-3 nopadding">
Right Support:
<?= $this->Form->select('mattress_rightsupport', $this->MyForm->getOptions($this, 'mattress_rightsupport', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'mattress_rightsupport'), 'empty' => '(choose one)', 'id' => 'mattress_rightsupport', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
</div> <div class="col row-m-t col-sm-6 col-md-3 nopadding">
Vent Position:<?= $this->Form->select('mattress_ventposition', $this->MyForm->getOptions($this, 'mattress_ventposition', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'mattress_ventposition'), 'empty' => '(choose one)', 'id' => 'mattress_ventposition', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
</div> <div class="col row-m-t col-sm-6 col-md-3 nopadding">
Vent Finish:
<?= $this->Form->select('mattress_ventfinish', $this->MyForm->getOptions($this, 'mattress_ventfinish', $data), 
            		['val' => $this->MyForm->getDefaultValue($data, 'mattress_ventfinish'), 'empty' => '(choose one)', 'id' => 'mattress_ventfinish', 'tabindex' => $tabIndex++, 'class' => 'mattress-field']); ?>
</div></div>
<div class="row rowindent">
<div class="col row-m-t col-sm-12 col-md-12 nopadding">
    <p>Mattress Special Instructions:</p>
	<div>
    <strong> 
		<?= $this->Form->textarea('mattress_instructions', 
			['val' => $this->MyForm->getDefaultValue($data, 'mattress_instructions'), 'id' => 'mattress_instructions', 'cols' => '65', 'tabindex' => $tabIndex++, 'class' => 'indentleft mattress-field']); ?>
			<br/>&nbsp;<b><span id="mattress_instructions_counter"></span></b>
	</strong>
	</div></div>
<div class="col row-m-t col-sm-12 col-md-12 nopadding">
	<strong>Mattress Price Summary</strong>
	<div id="mattress_pricing">
	</div>
</div>
</div>
