<?php
/**
 * @var \App\View\AppView $this
 * @var \App\Model\Entity\Purchase[]|\Cake\Collection\CollectionInterface $purchases
 */
?>
<?php use Cake\Routing\Router; ?>
<?php echo $this->Html->css('jquery.multiselect.css',array('inline' => false));?>

<script>
$(function() {
var year = new Date().getFullYear();
$( "#Pdatefrom" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#Pdatefrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#Pdateto" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#Pdateto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#Edatefrom" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#Edatefrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#Edateto" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#Edateto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});

</script>
<div class="container">
<h1>Order Status Report</h1>
<form action="/php/orderStatusReport" method="post" id="form1">
<input type="hidden" name="sortorder" id="sortorder" value="<?php $this->MyForm->setValue($formDefaults, 'sortorder'); ?>" />
<table width="100%" border="1" cellspacing="0" cellpadding="2" class="brochurecenter" style="margin-top:40px;" >

<tr><td valign="top">Fully Paid?<br>
<select name="paid" id="paid" class="paid active">
	<option value="all" <?php $this->MyForm->setSelected($formDefaults, 'paid', 'all'); ?> >-</option>
	<?php if (!$this->MyForm->isZeroCountFilterOption($filtercounts, 'paid', 'ob')) { ?>
		<option value="ob" <?php $this->MyForm->setSelected($formDefaults, 'paid', 'ob'); ?> class="group1" >Outstanding Balance</option>
	<?php } ?>
	<?php if (!$this->MyForm->isZeroCountFilterOption($filtercounts, 'paid', 'fp')) { ?>
		<option value="fp" <?php $this->MyForm->setSelected($formDefaults, 'paid', 'fp'); ?> class="group2" >Fully Paid</option>
	<?php } ?>
</select>

</td>
<td valign="top">
Order Status<br>
<select name="qcstatus[]" multiple="multiple" class="qcstatus active">
<?php foreach ($orderstatus as $row): ?>	
	<?php if (!$this->MyForm->isZeroCountFilterOption($filtercounts, 'QC_StatusID', $row['QC_statusID'])) { ?>
        <option value="<?php echo $row['QC_statusID'] ?>" <?php $this->MyForm->setSelected($formDefaults, 'qcstatus', $row['QC_statusID']); ?> ><?php echo $row['QC_status'] ?></option>
    <?php } ?>
<?php endforeach; ?>      
</select>
</td>
<td valign="top">
Order Source<br>
<select name="ordersource[]" multiple="multiple" class="showroom active">
<?php foreach ($showrooms as $row): ?>	
	<?php if (!$this->MyForm->isZeroCountFilterOption($filtercounts, 'idlocation', $row['idlocation'])) { ?>
        <option value="<?php echo $row['idlocation'] ?>" <?php $this->MyForm->setSelected($formDefaults, 'ordersource', $row['idlocation']); ?> ><?php echo $row['adminheading'] ?></option>
    <?php } ?>
 <?php endforeach; ?>      
    </select>
</td>
<td valign="top">
Delivery&nbsp;Booked?<br>
<select name="deliverybooked" id="deliverybooked">
	<option value="n" <?php $this->MyForm->setSelected($formDefaults, 'deliverybooked', 'n'); ?> >-</option>
	<?php if (!$this->MyForm->isZeroCountFilterOption($filtercounts, 'deliverybooked', 'yes')) { ?>
		<option value="yes" <?php $this->MyForm->setSelected($formDefaults, 'deliverybooked', 'yes'); ?> >YES</option>
	<?php } ?>
	<?php if (!$this->MyForm->isZeroCountFilterOption($filtercounts, 'deliverybooked', 'no')) { ?>
		<option value="no" <?php $this->MyForm->setSelected($formDefaults, 'deliverybooked', 'no'); ?> >NO</option>
	<?php } ?>
	
</select>
</td>
<td valign="top">
Ex Works Date<br><br>
<input name="exworks" type="checkbox" value="y" <?php $this->MyForm->setChecked($formDefaults, 'exworks', 'y'); ?>  /> From 28 days<br><br>

        Date From: <input type="text" name="Edatefrom" id="Edatefrom" value="<?php echo $this->MyForm->fmtDate($formDefaults, 'Edatefrom') ?>"/>
    Date To: <input type="text" name="Edateto" id="Edateto" value="<?php echo $this->MyForm->fmtDate($formDefaults, 'Edateto') ?>"/>

</td>
<td valign="top">
Production Date<br><br>
<input name="production" type="checkbox" value="y" <?php $this->MyForm->setChecked($formDefaults, 'production', 'y'); ?>   /> From 28 days<br><br>
    Date From: <input type="text" name="Pdatefrom" id="Pdatefrom" value="<?php echo $this->MyForm->fmtDate($formDefaults, 'Pdatefrom') ?>"/>
    Date To: <input type="text" name="Pdateto" id="Pdateto" value="<?php echo $this->MyForm->fmtDate($formDefaults, 'Pdateto') ?>"/>
</td>
<td valign="top">
Currency<br>
<select name="currency[]" multiple="multiple" class="currency active">
	<?php if (!$this->MyForm->isZeroCountFilterOption($filtercounts, 'currency', 'EUR')) { ?>
		<option value="EUR" <?php $this->MyForm->setSelected($formDefaults, 'currency', 'EUR'); ?> >EUR</option>
	<?php } ?>
	<?php if (!$this->MyForm->isZeroCountFilterOption($filtercounts, 'currency', 'GBP')) { ?>
        <option value="GBP" <?php $this->MyForm->setSelected($formDefaults, 'currency', 'GBP'); ?> >GBP</option>
	<?php } ?>
	<?php if (!$this->MyForm->isZeroCountFilterOption($filtercounts, 'currency', 'USD')) { ?>
        <option value="USD" <?php $this->MyForm->setSelected($formDefaults, 'currency', 'USD'); ?> >USD</option>
	<?php } ?>
    </select>
</td>
</tr>
</table>
<p align="center">
<input type="submit" value="Submit Filters" onclick="changeFormAction('form1', '/php/orderStatusReport');" style="color:#900; font-size:1.2em;" />
<input type="submit" value="Excel" onclick="changeFormAction('form1', '/php/orderStatusReport/export');" style="color:#900; font-size:1.2em;" />
<input onclick="window.location.assign('/php/orderStatusReport');" type="button" value="Reset" style="color:#900; font-size:1.2em;" /> 
</p>
</form>

<table width="100%" border="1" cellspacing="0" cellpadding="10" class="brochurecenter" style="margin-top:40px;" >
<tbody class="brochuretable">
		    <tr>
		      <td align="left">Summary</td>
		      <td align="right" style="padding-right:30px">Count:&nbsp;<?php echo $recordcount ?></td>
		      <td align="left" style="padding-right:30px">Orders:&nbsp;<?php echo number_format($orderstotal, 2) ?></td>
		      <td align="left" style="padding-right:30px">Payments:&nbsp;<?php echo number_format($orderspayments, 2) ?></td>
		      <td align="left" style="padding-right:30px">Remaining:&nbsp;<?php echo number_format($ordersoutstanding, 2) ?></td>
		      </tr>
</tbody>
</table>

<table width="100%" border="1" cellspacing="0" cellpadding="5" class="brochurecenter" style="margin-top:40px;" >
<tbody class="brochuretable">
		    <tr>
		      <td align="left">Surname<br/>
		      	<a href="#" onclick="sortby('surname|desc');"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a>
                <a href="#" onclick="sortby('surname|asc'); "><img src="/img/asc.gif"  alt="Ascending"  width="34" height="30" align="middle" border="0"></a>
              </td>
		      <td align="left">Company<br/>
		      	<a href="#" onclick="sortby('company|desc');"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a>
                <a href="#" onclick="sortby('company|asc'); "><img src="/img/asc.gif"  alt="Ascending"  width="34" height="30" align="middle" border="0"></a>
              </td>
		      <td align="left">Showroom<br/>
		      	<a href="#" onclick="sortby('adminheading|desc');"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a>
                <a href="#" onclick="sortby('adminheading|asc'); "><img src="/img/asc.gif"  alt="Ascending"  width="34" height="30" align="middle" border="0"></a>
              </td>
		      <td align="left">Order Date<br/>
		      	<a href="#" onclick="sortby('ORDER_DATE|desc');"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a>
                <a href="#" onclick="sortby('ORDER_DATE|asc'); "><img src="/img/asc.gif"  alt="Ascending"  width="34" height="30" align="middle" border="0"></a>
              </td>
		      <td align="left">Order<br/>
		      	<a href="#" onclick="sortby('order_number|desc');"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a>
                <a href="#" onclick="sortby('order_number|asc'); "><img src="/img/asc.gif"  alt="Ascending"  width="34" height="30" align="middle" border="0"></a>
              </td>
		      <td align="left">Order Total<br/>
		      	<a href="#" onclick="sortby('total|desc');"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a>
                <a href="#" onclick="sortby('total|asc'); "><img src="/img/asc.gif"  alt="Ascending"  width="34" height="30" align="middle" border="0"></a>
              </td>
		      <td align="left">Payments<br/>
		      	<a href="#" onclick="sortby('paymentstotal|desc');"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a>
                <a href="#" onclick="sortby('paymentstotal|asc'); "><img src="/img/asc.gif"  alt="Ascending"  width="34" height="30" align="middle" border="0"></a>
              </td>
		      <td align="left">Order Status<br/>
		      	<a href="#" onclick="sortby('QC_status|desc');"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a>
                <a href="#" onclick="sortby('QC_status|asc'); "><img src="/img/asc.gif"  alt="Ascending"  width="34" height="30" align="middle" border="0"></a>
              </td>
		      <td align="left">Delivery Date<br/>
		      	<a href="#" onclick="sortby('bookeddeliverydate|desc');"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a>
                <a href="#" onclick="sortby('bookeddeliverydate|asc'); "><img src="/img/asc.gif"  alt="Ascending"  width="34" height="30" align="middle" border="0"></a>
              </td>
		      <td align="left">Production Date<br/>
		      	<a href="#" onclick="sortby('productiondate|desc');"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a>
                <a href="#" onclick="sortby('productiondate|asc'); "><img src="/img/asc.gif"  alt="Ascending"  width="34" height="30" align="middle" border="0"></a>
              </td>
		      <td align="left">Ex-Works Date<br/>
		      	<a href="#" onclick="sortby('exworksdate|desc');"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a>
                <a href="#" onclick="sortby('exworksdate|asc'); "><img src="/img/asc.gif"  alt="Ascending"  width="34" height="30" align="middle" border="0"></a>
              </td>
	        </tr>
<?php foreach ($allorders as $row): ?>	        
	        <tr>
		      <td><?php echo $row['surname'] ?></td>
		      <td><?php echo $row['company'] ?></td>
		      <td><?php echo $row['adminheading'] ?></td>
		      <td><?php if (!empty($row['ORDER_DATE'])) 
		      echo date("d/m/Y", strtotime(substr($row['ORDER_DATE'],0,10))) ?>
		     </td>
		      <td><a href="/orderdetails.asp?pn=<?php echo $row['purchase_no'] ?>"><?php echo $row['order_number'] ?></a></td>
		      <td><?php echo $row['total'] ?></td>
		      <td><?php echo $row['paymentstotal'] ?></td>
		      <td><?php echo $row['QC_status'] ?></td>
		      <td><?php if (!empty($row['bookeddeliverydate'])) 
		      echo date("d/m/Y", strtotime(substr($row['bookeddeliverydate'],0,10))) ?></td>
		      <td><?php if (!empty($row['productiondate'])) 
		      echo date("d/m/Y", strtotime(substr($row['productiondate'],0,10))) ?></td>
		      <td><?php if (empty($row['exworksdate']) || $row['exworksdate']=='TBC' || $row['exworksdate']=='Split') {
		      echo  $row['exworksdate']; } else {
		      echo date("d/m/Y", strtotime(substr($row['exworksdate'],0,10))); } ?>
		     </td>
	        </tr>
 <?php endforeach; ?>
</tbody>
</table>
   
</div>
<?php echo $this->Html->script('jquery.multiselect.js', array('inline' => false)); ?>
<script>
 $(function () {
        $('select[multiple].active.showroom').multiselect({
            columns: 1,
            placeholder: 'Select Showroom',
            search: false,
            minWidth           : 300,
            selectAll: true
        });
        $('select[multiple].active.qcstatus').multiselect({
            columns: 1,
            placeholder: 'Order status',
            search: false,
            minWidth           : "300px",
            selectAll: true
        });
        $('select[multiple].active.currency').multiselect({
            columns: 1,
            placeholder: 'Currency',
            search: false,
            minWidth           : "300px",
            selectAll: true
        });
        $('select[multiple].active.exworks').multiselect({
            columns: 1,
            placeholder: 'Ex-Works Date',
            search: false,
            minWidth           : "300px",
            selectAll: true
        });
        $('select[multiple].active.production').multiselect({
            columns: 1,
            placeholder: 'Production Date',
            search: false,
            minWidth           : "300px",
            selectAll: true
        });

    });

	function changeFormAction(formId, newAction) {
		//console.log("New action = " + newAction);
		$('#' + formId).attr('action', newAction);
	}
	
	function sortby(sortVal) {
		//console.log("sortVal = " + sortVal);
		$("#sortorder").val(sortVal);
		$("#form1").submit();
	}  
</script>
<?php

function currencysymbol($cs) {
    $currensymboltodisplay = '&pound;';
    switch ($cs) {
    case "EUR":
        $currensymboltodisplay = '&#8364;';
        break;
    case "USD":
        $currensymboltodisplay = '&#36;';
        break;
    case "CZK":
        $currensymboltodisplay = '&#75;&#269;;';
        break;
		}
		echo $currensymboltodisplay;    
};




?>  