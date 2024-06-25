<?php use App\Controller\Component\UtilityComponent; ?>
<?php echo $this->Html->script('orders/common.js', array('inline' => false)); ?>
<?php echo $this->Html->script('orders/compobj.js', array('inline' => false)); ?>
<script>
var jsComponentNames = {};
<?php foreach ($componentNames as $id => $name) { ?>
	jsComponentNames[<?=$id?>] = '<?=$name?>';
<?php } ?>

$(document).ready(function() {
	jspn = <?=$pn?>;
});

</script>
<?php echo $this->Html->script('orders/order.js', array('inline' => false)); ?>

<?php
	$vatData = $this->OrderForm->getVatRates($this->MyForm->getDefaultValue($data, 'order_vatrate'));
	$leadTimes = $this->OrderFormProduction->getLeadTimes();
	
	$deldate = $this->MyForm->getDefaultValue($data, 'order_deliverydate');
	if (!empty($deldate)) {
		//$deldate = $deldate->i18nFormat('yyyy-MM-dd');
		$deldate = substr($deldate, 0, 10);
	} else {
		$tempdate = strtotime('+'. $leadTimes['longest'] . ' week', time());
		$deldate = date("Y-m-d", $tempdate);
	}
	
	$approxDateOptions = $this->OrderFormProduction->makeApproxDateOptions($deldate);
	//debug($data);
	
	$defaultShipperId = $this->OrderForm->getDefaultShippingAddressId();
	$showNotes = $this->Security->retrieveUserRegion() == 1 || $this->Security->isSavoirOwned();
?>


<?php $tabIndex = 1; ?>
<?= $this->Form->create($data, ['name' => 'order_form', 'id' => 'order_form', 'url' =>  ['action' => 'save']]); ?>
<?= $this->Form->hidden('pn', ['val' => $pn, 'id' => 'pn']); ?>
<?= $this->Form->hidden('order_istrade', ['val' => $this->MyForm->safeArrayGet($data, ['defaults','order_istrade']), 'id' => 'order_istrade']); ?>
<div id="ordercontainer">
<div id="order">
<div class="container">
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
<b>General Order Details</b>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">Order Number:</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_number', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_number'), 'id' => 'order_number', 'size' => '30', 'disabled' => 'disabled', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
	Contact:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_salesusername', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_salesusername'), 'id' => 'order_salesusername', 'size' => '30', 'disabled' => 'disabled', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Order Date:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_orderdate',
		['val' => $this->MyForm->getDefaultFormattedDateValue($data, 'order_orderdate'), 'id' => 'order_orderdate', 'size' => '30', 'disabled' => 'disabled', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Customer Reference:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_reference', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_reference'), 'id' => 'order_reference', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
	<br>Order Currency:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
		<?= $this->Form->select('order_currency', $this->MyForm->getOptions($this, 'order_currency', $data), 
			['val' => $this->MyForm->getDefaultValue($data, 'order_currency'), 'id' => 'order_currency', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
VAT Rate:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
		<?= $this->Form->select('order_vatrate', $vatData['rates'], 
			['val' => $vatData['def'], 'id' => 'order_vatrate', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>

<div class="row">
<div class="col row-m-t col-sm-6 col-md-12">
<br/><b>Client Details</B>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
	Title:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_clientstitle', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_clientstitle'), 'id' => 'order_clientstitle', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
First Name:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_clientsfirst', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_clientsfirst'), 'id' => 'order_clientsfirst', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Surname:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_clientssurname', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_clientssurname'), 'id' => 'order_clientssurname', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Tel Home:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_clientstel', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_clientstel'), 'id' => 'order_clientstel', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Tel Work:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_clientstelwork', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_clientstelwork'), 'id' => 'order_clientstelwork', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Mobile:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_clientsmobile', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_clientsmobile'), 'id' => 'order_clientsmobile', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Email Address:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_clientsemail', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_clientsemail'), 'id' => 'order_clientsemail', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Company Name:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_companyname', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_companyname'), 'id' => 'order_companyname', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
</div>
<div class="col row-m-t col-sm-6 col-md-4">
	<b>Invoice Address</B>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">Line 1:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_invadd1', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_invadd1'), 'id' => 'order_invadd1', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Line 2:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_invadd2', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_invadd2'), 'id' => 'order_invadd2', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Line 3:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_invadd3', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_invadd3'), 'id' => 'order_invadd3', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Town:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_invtown', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_invtown'), 'id' => 'order_invtown', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
County:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_invcounty', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_invcounty'), 'id' => 'order_invcounty', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Postcode:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_invpostcode', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_invpostcode'), 'id' => 'order_invpostcode', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Country:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_invcountry', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_invcountry'), 'id' => 'order_invcountry', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
</div>
<div class="col row-m-t col-sm-6 col-md-4">
	<b>Delivery Address</B>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Line 1:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_deladd1', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_deladd1'), 'id' => 'order_deladd1', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Line 2:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_deladd2', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_deladd2'), 'id' => 'order_deladd2', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Line 3:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_deladd3', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_deladd3'), 'id' => 'order_deladd3', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Town:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_deltown', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_deltown'), 'id' => 'order_deltown', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
County:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_delcounty', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_delcounty'), 'id' => 'order_delcounty', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Postcode:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_delpostcode', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_delpostcode'), 'id' => 'order_delpostcode', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Country:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_delcountry', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_delcountry'), 'id' => 'order_delcountry', 'size' => '30', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-12 col-md-12">	
	<br>
	<b>Delivery Contact Details</B>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Contact Name:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
       	<?= $this->Form->text('order_deliverycontact', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_deliverycontact'), 'id' => 'order_deliverycontact', 'size' => '15', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Contact number 1:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
	<?= $this->Form->select('order_delphonetype1', $this->MyForm->getOptions($this, 'order_delphonetype1', $data), 
		['val' => $this->MyForm->getDefaultValue($data, 'order_delphonetype1'), 'id' => 'order_delphonetype1', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
   	<?= $this->Form->text('order_delphone1', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_delphone1'), 'id' => 'order_delphone1', 'size' => '15', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Contact number 2:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
	<?= $this->Form->select('order_delphonetype2', $this->MyForm->getOptions($this, 'order_delphonetype2', $data), 
		['val' => $this->MyForm->getDefaultValue($data, 'order_delphonetype2'), 'id' => 'order_delphonetype2', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
   	<?= $this->Form->text('order_delphone2', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_delphone2'), 'id' => 'order_delphone2', 'size' => '15', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Contact number 3:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
	<?= $this->Form->select('order_delphonetype3', $this->MyForm->getOptions($this, 'order_delphonetype3', $data), 
		['val' => $this->MyForm->getDefaultValue($data, 'order_delphonetype3'), 'id' => 'order_delphonetype3', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
   	<?= $this->Form->text('order_delphone3', 
		['val' => $this->MyForm->getDefaultValue($data, 'order_delphone3'), 'id' => 'order_delphone3', 'size' => '15', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-12 col-md-12">
<br>	<b>Production Details</B>
</div>
</div>
<!-- beg col 1 -->
<div class="row">
<div class="col row-m-t col-sm-12 col-md-4">
<div class="row">
<div class="col row-m-t col-sm-4 col-md-3">
Order Type:&nbsp;
</div>
<div class="col row-m-t col-sm-8 col-md-9">
	<?= $this->Form->select('order_ordertype', $this->MyForm->getOptions($this, 'order_ordertype', $data), 
		['val' => $this->MyForm->getDefaultValue($data, 'order_ordertype'), 'id' => 'order_ordertype', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-4 col-md-3">
Wrap Type:&nbsp;
</div>
<div class="col row-m-t col-sm-8 col-md-9">
	<?= $this->Form->select('order_wraptype', $this->MyForm->getOptions($this, 'order_wraptype', $data), 
		['val' => $this->MyForm->getDefaultValue($data, 'order_wraptype'), 'id' => 'order_wraptype', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>

<div class="row">
<div class="col row-m-t col-sm-4 col-md-3">
<?php if (!$this->OrderForm->hideField('order_shipper')) { ?>
Select Shipper:&nbsp;
</div>
<div class="col row-m-t col-sm-8 col-md-9">
		<?= $this->Form->select('order_shipper', $this->OrderForm->getShipperAddresses(), 
			['val' => $defaultShipperId, 'id' => 'order_shipper', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
	<?php } ?>
</div>
</div>
</div>
<!-- beg col 2 -->
<div class="col row-m-t col-sm-12 col-md-4">
<div class="row">
<div class="col row-m-t col-sm-6 col-md-4">
Approx. Delivery Date:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-8">
	<?= $this->Form->select('order_deliverydate', $approxDateOptions['vals'], 
		['val' => $approxDateOptions['def'], 'id' => 'order_deliverydate', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>


</div>
<!-- beg col 3 -->
<div class="col row-m-t col-sm-12 col-md-4">
<div class="row">
<div class="col row-m-t col-sm-6 col-md-6">
Acknowledgement Date:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-6">
   	<?= $this->Form->text('order_acknowdate', 
		['val' => $this->MyForm->getDefaultFormattedDateValue($data, 'order_acknowdate'), 'id' => 'order_acknowdate', 'size' => '8', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-6">
Acknowledgement Version:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-6">
	<?= $this->Form->select('order_acknowversion', $this->MyForm->getOptions($this, 'order_acknowversion', $data), 
		['val' => $this->MyForm->getDefaultValue($data, 'order_acknowversion'), 'id' => 'order_acknowversion', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-6">		
Production Date:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-6">
   	<?= $this->Form->text('order_productiondate', 
		['val' => $this->MyForm->getDefaultFormattedDateValue($data, 'order_productiondate'), 'id' => 'order_productiondate', 'size' => '8', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>
<div class="row">
<div class="col row-m-t col-sm-6 col-md-6">	
Booked Delivery Date:&nbsp;
</div>
<div class="col row-m-t col-sm-6 col-md-6">
   	<?= $this->Form->text('order_bookeddeliverydate', 
		['val' => $this->MyForm->getDefaultFormattedDateValue($data, 'order_bookeddeliverydate'), 'id' => 'order_bookeddeliverydate', 'size' => '8', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
</div>
</div>

</div>
</div>
<hr class="ordershr">
<div class="row">
<div class="col row-m-t col-sm-12 col-md-12">
	<?php if ($showNotes) { ?>
	<div class="row">
	<div class="col row-m-t col-sm-12 col-md-6">
		<span style="float:left"><b>Order Notes:</b></span>
		<?= $this->Form->textarea('order_notetext', 
			['id' => 'order_notetext', 'cols' => '50', 'rows' => '2', 'tabindex' => $tabIndex++, 'class' => 'indentleft order-field']); ?>
			<br/>&nbsp;<b><span id="order_notetext_counter"></span></b>
	   	</div>
		<div class="col row-m-t col-sm-6 col-md-3">
		Follow-up Date:<br><br>
<?= $this->Form->text('order_notefollowupdate', 
			['id' => 'order_notefollowupdate', 'size' => '15', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
			</div>
		<div class="col row-m-t col-sm-6 col-md-3">
		Status:<br><br>
		<?= $this->Form->select('order_noteaction', $this->MyForm->getOptions($this, 'order_noteaction', $data), 
			['id' => 'order_noteaction', 'tabindex' => $tabIndex++, 'class' => 'order-field']); ?>
		</div>
		</div>
<div class="row">
<div class="col row-m-t col-sm-12 col-md-12">
		<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
			<tr><td>Text</td><td>Status</td><td>Created By</td><td>Created</td><td> Type </td><td> Task Due Date</td><td> Completed</td></tr>
			<?php foreach ($orderNotes as $row) { ?>
				<tr>
					<td><?=htmlspecialchars($row['notetext'])?></td>
					<td><?=$row['action']?></td>
					<td><?=$row['username']?></td>
					<td><?php if (!empty($row['createddate'])) echo $row['createddate']->i18nFormat('dd/MM/yyyy')?></td>
					<td><?=$row['notetype']?></td>
					<td><?php if (!empty($row['followupdate'])) echo $row['followupdate']->i18nFormat('dd/MM/yyyy')?></td>
					<td><?php if (!empty($row['NoteCompletedDate'])) echo $row['NoteCompletedDate']->i18nFormat('dd/MM/yyyy')?></td>
			<?php } ?>
		</table>
		</div>
		</div>
	<?php } ?>
</div>	
</div>

<hr/>
<p class="purplebox">&nbsp;&nbsp;Mattress required:&nbsp;
<?= $this->Form->radio('order_mattressreq',
	[
		['value' => 'y', 'text' => 'Yes', 'id' => 'order_mattressreq_y', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
		['value' => 'n', 'text' => 'No', 'id' => 'order_mattressreq_n', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
	],
	['val' => $this->MyForm->getDefaultValue($data, 'order_mattressreq', 'n')]
); ?></p>
<div id="mattress"></div>


<p class="purplebox">&nbsp;&nbsp;Topper required:&nbsp;
<?= $this->Form->radio('order_topperreq',
	[
		['value' => 'y', 'text' => 'Yes ', 'id' => 'order_topperreq_y', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
		['value' => 'n', 'text' => 'No', 'id' => 'order_topperreq_n', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
	],
	['val' => $this->MyForm->getDefaultValue($data, 'order_topperreq', 'n')]
); ?></p>
<div id="topper"></div>


<p class="purplebox">&nbsp;&nbsp;Base required:&nbsp;
<?= $this->Form->radio('order_basereq',
	[
		['value' => 'y', 'text' => 'Yes ', 'id' => 'order_basereq_y', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
		['value' => 'n', 'text' => 'No', 'id' => 'order_basereq_n', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
	],
	['val' => $this->MyForm->getDefaultValue($data, 'order_basereq', 'n')]
); ?></p>
<div id="base"></div>


<p class="purplebox">&nbsp;&nbsp;Legs required:&nbsp;
<?= $this->Form->radio('order_legsreq',
	[
		['value' => 'y', 'text' => 'Yes ', 'id' => 'order_legsreq_y', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
		['value' => 'n', 'text' => 'No', 'id' => 'order_legsreq_n', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
	],
	['val' => $this->MyForm->getDefaultValue($data, 'order_legsreq', 'n')]
); ?></p>
<div id="legs"></div>


<p class="purplebox">&nbsp;&nbsp;Headboard required:&nbsp;
<?= $this->Form->radio('order_headboardreq',
	[
		['value' => 'y', 'text' => 'Yes ', 'id' => 'order_headboardreq_y', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
		['value' => 'n', 'text' => 'No', 'id' => 'order_headboardreq_n', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
	],
	['val' => $this->MyForm->getDefaultValue($data, 'order_headboardreq', 'n')]
); ?></p>
<div id="headboard"></div>


<p class="purplebox">&nbsp;&nbsp;Valance required:&nbsp;
<?= $this->Form->radio('order_valancereq',
	[
		['value' => 'y', 'text' => 'Yes ', 'id' => 'order_valancereq_y', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
		['value' => 'n', 'text' => 'No', 'id' => 'order_valancereq_n', 'class' => 'radiospace', 'tabindex' => $tabIndex++],
	],
	['val' => $this->MyForm->getDefaultValue($data, 'order_valancereq', 'n')]
); ?></p>
<div id="valance"></div>
<br>
<input type="submit" name="saveorder" value="Save Order" id="saveorder" class="button" tabindex="10000">
</div></div>
</form>
