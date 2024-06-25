<script>
	var <?=$compName?>CompObj;
	$(document).ready(function() {
		<?=$compName?>CompObj = new CompObj(<?=$pn;?>);
	
		// DEFAULTABLE CONTROLS START
		<?php foreach($defaultableSelectControlList as $child => $parent) { ?>
			// add the pair to the observer/observed pair list
			<?=$compName?>CompObj.addObserverPairToList("<?= $parent; ?>", "<?= $child; ?>");

			// observe the parents of the defaultable controls
			$("#<?= $parent; ?>").change(function() {
				<?=$compName?>CompObj.observedControlChanged("<?= $parent; ?>", "<?= $child; ?>");
			});
		<?php } ?>
		// DEFAULTABLE CONTROLS END
		
		// DEPENDENT CONTROLS START
		<?php foreach($dependentSelectControlList as $child => $parent) { ?>
			// add the pair to the observer/observed pair list
			<?=$compName?>CompObj.addObserverPairToList("<?= $parent; ?>", "<?= $child; ?>");
			
			// observe the parents of the dependent controls
			$("#<?= $parent; ?>").off("change.dependent");
			$("#<?= $parent; ?>").on("change.dependent", function() {
				<?=$compName?>CompObj.observedControlChanged("<?= $parent; ?>", "<?= $child; ?>");
			});
			
			// set the values for dependent controls
			<?=$compName?>CompObj.getNewObserverValue("<?= $parent; ?>", "<?= $child; ?>", "common.ctp");
		<?php } ?>
		// DEPENDENT CONTROLS END
		
		// load the pricing table
		<?php if ($isTopLevelComp) { ?>
			var url = "component/pricingTable?pn=<?= $pn; ?>&compId=<?= $compId; ?>";
			console.log("common.ctp loading <?= $compName ?> pricing table");
	    	$('#<?= $compName ?>_pricing').load(url);
    	<?php } ?>
	});
	
</script>

<?= $this->fetch('content') ?>
