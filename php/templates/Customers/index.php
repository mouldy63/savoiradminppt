<?php
$this->set('title', 'Maintain Customers');
$this->start("css");
echo '<link rel="stylesheet" type="text/css" href="/php/css/cake.generic.css" />';
echo '<link rel="stylesheet" type="text/css" href="/php/css/mycustom.css" />';
$this->end();?>

<h1>Customers (<?php echo $this->Paginator->counter('page {{page}} of {{pages}}'); ?>)</h1>
<p>
	<?php echo $this->Paginator->first(' << ' . __('first'), array(), null, array('class' => 'first disabled')); ?>
	&nbsp;
	<?php echo $this->Paginator->prev(' < ' . __('previous'), array(), null, array('class' => 'prev disabled')); ?>
	&nbsp;
	<?php echo $this->Paginator->numbers();?>
	&nbsp;
	<?php echo $this->Paginator->next(' > ' . __('next'), array(), null, array('class' => 'next disabled')); ?>
	&nbsp;
	<?php echo $this->Paginator->last(' >> ' . __('last'), array(), null, array('class' => 'last disabled')); ?>
</p>
<table>
    <tr>
        <th>Title</th>
        <th>First Name</th>
        <th><?php echo $this->Paginator->sort('surname', 'Last Name'); ?></th>
        <th>Company</th>
        <th>Address Line 1</th>
        <th>Address Line 2</th>
        <th>Address Line 3</th>
        <th>City/Town</th>
        <th>County</th>
        <th>Postcode</th>
        <th>Country</th>
        <th>Email</th>
        <th>Status</th>
        <th>Accept Email</th>
        <th>Accept Post</th>
        <th>Actions</th>
    </tr>

    <?php foreach ($customers as $customer): ?>
    <?php
    	$rowId = $customer['CONTACT_NO'] . '-'. $customer['CODE'];
    ?>
    <tr>
    	<td><span id="title-<?php echo $rowId; ?>"><?php echo $customer['title']; ?></span></td>
        <td><span id="first-<?php echo $rowId; ?>"><?php echo $customer['first']; ?></span></td>
        <td><span id="surname-<?php echo $rowId; ?>"><?php echo $customer['surname']; ?></span></td>
        <td><span id="company-<?php echo $rowId; ?>"><?php echo $customer['addres']['company']; ?></span></td>
        <td><span id="street1-<?php echo $rowId; ?>"><?php echo $customer['addres']['street1']; ?></span></td>
        <td><span id="street2-<?php echo $rowId; ?>"><?php echo $customer['addres']['street2']; ?></span></td>
        <td><span id="street3-<?php echo $rowId; ?>"><?php echo $customer['addres']['street3']; ?></span></td>
        <td><span id="town-<?php echo $rowId; ?>"><?php echo $customer['addres']['town']; ?></span></td>
        <td><span id="county-<?php echo $rowId; ?>"><?php echo $customer['addres']['county']; ?></span></td>
        <td><span id="postcode-<?php echo $rowId; ?>"><?php echo $customer['addres']['postcode']; ?></span></td>
        <td><span id="country-<?php echo $rowId; ?>"><?php echo $customer['addres']['country']; ?></span></td>
        <td><span id="email_address-<?php echo $rowId; ?>"><?php echo $customer['addres']['EMAIL_ADDRESS']; ?></span></td>
        <td><span id="status-<?php echo $rowId; ?>"><?php echo $customer['addres']['STATUS']; ?></span></td>
        <td><span id="acceptemail-<?php echo $rowId; ?>"><?php echo $customer['acceptemail']; ?></span></td>
        <td><span id="acceptpost-<?php echo $rowId; ?>"><?php echo $customer['acceptpost']; ?></span></td>
        <td>
        	 <button type="button" id="edit-<?php echo $rowId; ?>" onclick="editRow('<?php echo $rowId; ?>');" >Edit</button> 
        	 <button type="button" id="save-<?php echo $rowId; ?>" onclick="saveRow('<?php echo $rowId; ?>');" style="display: none;">Save</button> 
        	 <button type="button" id="cancel-<?php echo $rowId; ?>" onclick="cancelRow('<?php echo $rowId; ?>');" style="display: none;">Cancel</button> 
        </td>
    </tr>
    <?php endforeach; ?>

</table>
<p>
	<?php echo $this->Paginator->first(' << ' . __('first'), array(), null, array('class' => 'first disabled')); ?>
	&nbsp;
	<?php echo $this->Paginator->prev(' < ' . __('previous'), array(), null, array('class' => 'prev disabled')); ?>
	&nbsp;
	<?php echo $this->Paginator->numbers();?>
	&nbsp;
	<?php echo $this->Paginator->next(' > ' . __('next'), array(), null, array('class' => 'next disabled')); ?>
	&nbsp;
	<?php echo $this->Paginator->last(' >> ' . __('last'), array(), null, array('class' => 'last disabled')); ?>
</p>

<script>
	function editRow(rowId) {
		$('#edit-'+rowId).hide();
		$('#save-'+rowId).show();
		$('#cancel-'+rowId).show();
		enableRowEdit(rowId);
	}
	
	function enableRowEdit(rowId) {
		enableCellEdit('title-'+rowId);
		enableCellEdit('first-'+rowId);
		enableCellEdit('surname-'+rowId);
		enableCellEdit('company-'+rowId);
		enableCellEdit('street1-'+rowId);
		enableCellEdit('street2-'+rowId);
		enableCellEdit('street3-'+rowId);
		enableCellEdit('town-'+rowId);
		enableCellEdit('county-'+rowId);
		enableCellEdit('postcode-'+rowId);
		enableCellEdit('country-'+rowId);
		enableCellEdit('email_address-'+rowId);
		enableCellEdit('status-'+rowId);
		enableCellEdit('acceptemail-'+rowId);
		enableCellEdit('acceptpost-'+rowId);
	}
	
	function enableCellEdit(cellId) {
		var val = $('#' + cellId).html();
		$('#' + cellId).html("<input type='text' name='input-" + cellId + "' id='input-" + cellId + "' value='" + val + "' />");
	}
	
	function saveRow(rowId) {
		var customer = {title: getCellValue('title-'+rowId)
						, first: getCellValue('first-'+rowId)
						, surname: getCellValue('surname-'+rowId)
						, company: getCellValue('company-'+rowId)
						, street1: getCellValue('street1-'+rowId)
						, street2: getCellValue('street2-'+rowId)
						, street3: getCellValue('street3-'+rowId)
						, town: getCellValue('town-'+rowId)
						, county: getCellValue('county-'+rowId)
						, postcode: getCellValue('postcode-'+rowId)
						, country: getCellValue('country-'+rowId)
						, email_address: getCellValue('email_address-'+rowId)
						, status: getCellValue('status-'+rowId)
						, acceptemail: getCellValue('acceptemail-'+rowId)
						, acceptpost: getCellValue('acceptpost-'+rowId)
						};
		var params = new Array();
		for (key in customer) {
    		params.push(key + '=' + encodeURIComponent(customer[key]));
		}
		console.log(params.join('&'));
		var url = "customers/saveCustomer/" + rowId + "/?" + params.join('&') + "&ts=" + (new Date()).getTime();
		console.log(url);
		$.get(url, function(result) {
			console.log("saveCustomer returned " + result);
			finishRowEdit(rowId);
		});
		
		$('#edit-'+rowId).show();
		$('#save-'+rowId).hide();
		$('#cancel-'+rowId).hide();
	}
	
	function getCellValue(cellId) {
		return $('#input-' + cellId).val();
	}
	
	function cancelRow(rowId) {
		finishRowEdit(rowId);
		$('#edit-'+rowId).show();
		$('#save-'+rowId).hide();
		$('#cancel-'+rowId).hide();
	}
	
	function finishRowEdit(rowId) {
		var url = "customers/getCustomer/" + rowId + "/&ts=" + (new Date()).getTime();
		$.getJSON(url, function(customer) {
			doFinishRowEdit(rowId, customer);
		});
	}

	function doFinishRowEdit(rowId, customer) {
		disableCellEdit('title-'+rowId, customer.title);
		disableCellEdit('first-'+rowId, customer.first);
		disableCellEdit('surname-'+rowId, customer.surname);
		disableCellEdit('company-'+rowId, customer.addres.company);
		disableCellEdit('street1-'+rowId, customer.addres.street1);
		disableCellEdit('street2-'+rowId, customer.addres.street2);
		disableCellEdit('street3-'+rowId, customer.addres.street3);
		disableCellEdit('town-'+rowId, customer.addres.town);
		disableCellEdit('county-'+rowId, customer.addres.county);
		disableCellEdit('postcode-'+rowId, customer.addres.postcode);
		disableCellEdit('country-'+rowId, customer.addres.country);
		disableCellEdit('email_address-'+rowId, customer.addres.EMAIL_ADDRESS);
		disableCellEdit('status-'+rowId, customer.addres.STATUS);
		disableCellEdit('acceptemail-'+rowId, customer.acceptemail);
		disableCellEdit('acceptpost-'+rowId, customer.acceptpost);
	}
	
	function disableCellEdit(cellId, val) {
		$('#' + cellId).html(val);
	}
</script>