<?= $header ?>

<div id="c1">
<table  border="0" cellspacing="0" cellpadding="3" >
  <tr>
    <td><div class=addresshdg>Client Details</div>
    <p class="addressbody"><?= $customerdetails ?></p><br>
    
    </td>
  </tr>
</table>
</div>
<div id="c2">
<table  border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td><div class=addresshdg>Invoice Address</div>
    <p class="addressbody"><?= $customeraddress ?></p></td>
  </tr>
</table>
</div>
<div id="c3">
<table  border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td><div class=addresshdg>Delivery Address</div>
    <p class="addressbody"><?= $deliveryaddress ?></p></td>
  </tr>
</table>
</div>
<div class="clear">&nbsp;</div>
<?php if ($accessoriesonly=='') { ?>
	<?php if ($mattressdetails !='') { ?>
		<div class="c5">
		<?= $mattressdetails ?>
		</div>
	<?php } ?>
	<?php if ($basedetails !='') { ?>
		<div class="c4">
		<?= $basedetails ?>
		</div>
	<?php } ?>
	<?php if ($legdetails !='') { ?>
		<div class="c4">
		<?= $legdetails ?>
		</div>
	<?php } ?>
	<?php if ($topperdetails !='') { ?>
		<div class="c4">
		<?= $topperdetails ?>
		</div>
	<?php } ?>
	<?php if ($valancedetails !='') { ?>
		<div class="c4">
		<?= $valancedetails ?>
		</div>
	<?php } ?>
	<?php if ($hbdetails !='') { ?>
		<div class="c4">
		<?= $hbdetails ?>
		</div>
	<?php } ?>

	<?php if ($pageheight > 13) {
 		echo $pagebreak;
 		echo $header;
	} ?>
	<div style="position: absolute;  bottom: -30px; width: 100%; margin:0; padding:0;">
	<table width="100%" border="0" cellspacing="0" cellpadding="3">
  	<tr>
    	<td width="50%" valign="top"><?= $ordersummary ?></td>
    	<td width="50%" valign="top"><span  style="padding: 10px;"><?= $deliverydetails ?></span></td>
  	</tr>
  	<tr>
    	<td width="50%" valign="top"><?= $paymentsdetails ?></td><td width="50%" valign="top"><?= $customersig ?></td>
  	</tr>
	</table>
	</div>
<?php } ?>
<?php if (!empty($accessoriesadd)) {
	echo $pagebreak;
	echo $header;
 	echo $accdetails;
 	?>
 	<table width="50%" align="right" style="position:absolute; bottom:110px;"><tr><td>
<?php
 	echo $customersig;
 	?>
 	</td></tr></table>
<?php } 
if ($accessoriesonly=='y') { 
	echo $accdetails; ?>
	<div class="clear">&nbsp;</div>
	<div style="position: absolute;  bottom: -30px; width: 100%; margin:0; padding:0;">
	<table width="101%" border="0" cellspacing="0" cellpadding="3" style="position:relative; left:-3px; padding-right:1px;">
  	<tr>
    	<td width="50%" valign="top"><?= $ordersummary ?></td>
    	<td width="50%" valign="top"><span  style="padding: 10px;"><?= $deliverydetails ?></span></td>
  	</tr>
  	<tr>
    	<td width="50%" valign="top"><?= $paymentsdetails ?></td>
    	<td width="50%" valign="top"><?= $customersig ?></td>
  	</tr>
	</table></div>
<?php }
if (!empty($termstext)) {
	echo $pagebreak;
	echo $termstext;
} ?>
