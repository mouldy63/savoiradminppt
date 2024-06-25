<script>
	$(document).ready(function() {
		console.log("*** calling set<?=$compName?>OtherPriceAffectingFieldWatch");
		set<?=$compName?>OtherPriceAffectingFieldWatch();
		set<?=$compName?>PricingTablePriceAffectingFieldWatch();
	});

	// this is called by the price table when it loads
	function set<?=$compName?>PricingTablePriceAffectingFieldWatch() {
		<?php foreach($pricingTablePriceAffectingFieldList as $fieldname => $fieldIds) { ?>
			<?=$compName?>CompObj.registerPriceAffectingField('<?= $fieldname; ?>');
			<?php if (!is_array($fieldIds)) { ?>
				$("#<?= $fieldname; ?>").change(function() {
					<?=$compName?>CompObj.refreshPriceTable(<?= $compId; ?>, '<?= $fieldname; ?>', '<?= $fieldname; ?>', '<?= $compName; ?>');
				});
			<?php } else { 
				foreach($fieldIds as $id) {
					?>
						$("#<?= $id; ?>").change(function() {
							<?=$compName?>CompObj.refreshPriceTable(<?= $compId; ?>, '<?= $fieldname; ?>', '<?= $id; ?>', '<?= $compName; ?>');
						});
					<?php
				}
			} 
		} ?>
	}

	// so is this, but only on initial load
	function set<?=$compName?>OtherPriceAffectingFieldWatch() {
		//console.log("*** set<?=$compName?>OtherPriceAffectingFieldWatch called");
		<?php foreach($otherPriceAffectingFieldList as $fieldname => $fieldIds) { ?>
			<?=$compName?>CompObj.registerPriceAffectingField('<?= $fieldname; ?>');
			<?php if (!is_array($fieldIds)) { ?>
				//console.log("<?=$fieldname;?> change registered. Exists = " + $("#<?=$fieldname;?>").length);
				setCallRefreshPriceTableOnChange('<?=$fieldname;?>', '<?=$fieldname;?>', <?=$compName?>CompObj, <?=$compId;?>, '<?=$compName;?>');
			<?php } else { 
				foreach($fieldIds as $id) {
					?>
					//console.log("@@@ id=<?=$id;?> exists = " + $("#<?=$id;?>").length);
					setCallRefreshPriceTableOnChange('<?=$fieldname;?>', '<?=$id;?>', <?=$compName?>CompObj, <?=$compId;?>, '<?=$compName;?>');
					<?php
				}
			} 
		} ?>
	}
	
</script>
<?php $tabIndex = $compId*100+50;
$totalPrice = 0.0;
?>

<table width="98%" border="1" align="center" cellpadding="3" cellspacing="3" class="xview">
<?php foreach ($compList as $tempCompId => $tempCompName) {
	$pricingType = $this->OrderForm->getComponentPricingType($tempCompId);
	$compDisplayName = $this->OrderForm->getComponentDisplayName($tempCompId);
	if ($pricingType == 'calculate') { ?>
		<?php
			if (empty($data['defaults'][$tempCompName.'_listprice'])) {
				$data['defaults'][$tempCompName.'_listprice'] = $data['defaults'][$tempCompName.'_price'];
				$data['defaults'][$tempCompName.'_discounttype'] = 'percent';
				$data['defaults'][$tempCompName.'_discount'] = 0.0;
			}
		?>
		<?= $this->Form->hidden($tempCompName.'_listprice', 
			['val' => $this->MyForm->formatMoney($this->MyForm->getDefaultValue($data, $tempCompName.'_listprice')), 'id' => $tempCompName.'_listprice']); ?>
		<tr>
	        <td width="17%">
	        	Calculated Price: <?=$this->OrderForm->getCurrencySymbol()?><?= $this->MyForm->formatMoney($data['defaults'][$tempCompName.'_listprice']); ?>
    	    </td>
	        <td>Discount:&nbsp;
	        	<?= $this->Form->radio($tempCompName.'_discounttype',
	    			[
	        			['value' => 'percent', 'text' => '%', 'id' => $tempCompName.'_discounttype_percent', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
	        			['value' => 'currency', 'text' => 'Currency', 'id' => $tempCompName.'_discounttype_currency', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
	    			],
	    			['val' => $this->MyForm->getDefaultValue($data, $tempCompName.'_discounttype')]
				); ?>&nbsp;
	        	<?= $this->Form->text($tempCompName.'_discount', 
	    			['val' => $this->MyForm->getDefaultFormattedDoubleValue($data, $tempCompName.'_discount', 4), 'id' => $tempCompName.'_discount', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => $compName.'-field']); ?>
	        </td>
	        <td width="25%"><?=$compDisplayName?> <span class="cursym"><?=$this->OrderForm->getCurrencySymbol()?></span>
	            <?= $this->Form->text($tempCompName.'_price', 
	        			['val' => $this->MyForm->formatMoney($this->MyForm->getDefaultValue($data, $tempCompName.'_price')), 'id' => $tempCompName.'_price', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => $compName.'-field']); ?>
                <br/><?=$compDisplayName?> wholesale price <span class="cursym"><?=$this->OrderForm->getCurrencySymbol()?></span>
            	<?= $this->Form->text($tempCompName.'_wholesaleprice', 
        			['val' => $this->MyForm->formatMoney($this->MyForm->getDefaultValue($data, $tempCompName.'_wholesaleprice')), 'id' => $tempCompName.'_wholesaleprice', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => $compName.'-field']); ?>
	        </td>
		</tr>
		<?php $totalPrice += floatval($this->MyForm->getDefaultValue($data, $tempCompName.'_price')); ?>
	<?php } else if ($pricingType == 'matrix') { ?>
	
	<?php $showListPrice = (!empty($data['defaults'][$tempCompName.'_listprice']) && $data['defaults'][$tempCompName.'_listprice'] != -1.0); ?>
	<?= $this->Form->hidden($tempCompName.'_listprice', 
		['val' => $this->MyForm->formatMoney($this->MyForm->getDefaultValue($data, $tempCompName.'_listprice')), 'id' => $tempCompName.'_listprice']); ?>
	
	    <tr>
	       	<?php if ($showListPrice) { ?>
		        <td width="17%">
		        	List Price: <?=$this->OrderForm->getCurrencySymbol()?><?= $this->MyForm->formatMoney($data['defaults'][$tempCompName.'_listprice']); ?>
	    	    </td>
		        <td>Discount:&nbsp;
		        	<?= $this->Form->radio($tempCompName.'_discounttype',
		    			[
		        			['value' => 'percent', 'text' => ' %', 'id' => $tempCompName.'_discounttype_percent', 'tabindex' => $tabIndex++],
		        			['value' => 'currency', 'text' => ' Currency', 'id' => $tempCompName.'_discounttype_currency', 'tabindex' => $tabIndex++],
		    			],
		    			['val' => $this->MyForm->getDefaultValue($data, $tempCompName.'_discounttype')]
					); ?>&nbsp;
		        	<?= $this->Form->text($tempCompName.'_discount', 
		    			['val' => $this->MyForm->getDefaultFormattedDoubleValue($data, $tempCompName.'_discount', 4), 'id' => $tempCompName.'_discount', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => $compName.'-field']); ?>
		        </td>
	       	<?php } else { ?>
	       		<td colspan="2">&nbsp;</td>
	       	<?php } ?>
	
	        <td width="25%"><?=$compDisplayName?> <span class="cursym"><?=$this->OrderForm->getCurrencySymbol()?></span>
	            <?= $this->Form->text($tempCompName.'_price', 
	        			['val' => $this->MyForm->formatMoney($this->MyForm->getDefaultValue($data, $tempCompName.'_price')), 'id' => $tempCompName.'_price', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => $compName.'-field']); ?>
                <br/><?=$compDisplayName?> wholesale price <span class="cursym"><?=$this->OrderForm->getCurrencySymbol()?></span>
            	<?= $this->Form->text($tempCompName.'_wholesaleprice', 
        			['val' => $this->MyForm->formatMoney($this->MyForm->getDefaultValue($data, $tempCompName.'_wholesaleprice')), 'id' => $tempCompName.'_wholesaleprice', 'size' => '10', 'tabindex' => $tabIndex++, 'class' => $compName.'-field']); ?>
	        </td>
	    </tr>
	    <?php $totalPrice += floatval($this->MyForm->getDefaultValue($data, $tempCompName.'_price')); ?>
	    <?php } ?>
<?php } ?>
		<tr>
			<td colspan="2">&nbsp;</td>
			<td><?=$compDisplayName?> total price:&nbsp;<?=$this->OrderForm->getCurrencySymbol()?><input name="total<?=$tempCompName?>price" type="text" class="xview" id="total<?=$tempCompName?>price" size="10" readonly="true" value="<?=$this->MyForm->formatMoney($totalPrice)?>"></td>
		</tr>
</table>
