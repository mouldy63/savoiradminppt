<?= $header 
?>

<div id="WS1">
<table  border="0" cellspacing="0" cellpadding="3" >
  <tr>
    <td><div class=addresshdg>Client Details</div>
    <?= $customerdetails ?>
    </td>
  </tr>
</table>
</div>
<div id="WS2">
<table  border="0" cellspacing="0" cellpadding="3" >
  <tr>
    <td><div class=addresshdg>Delivery Address</div>
    <p class="addressbody" style="line-height:12px; font-size:10px; position:relative; top:-15px; left:10px;"><?= $deliveryaddress ?><br><?= $deliverynos ?></p>
    </td>
  </tr>
</table>
</div>
<div class="clear">&nbsp;</div>
<?php if ($accrequired=='y' && $accessoriesonly == 'y') {
 	echo $accdetails;?>
 <table width="48%" align="right" border="1" cellspacing="0" cellpadding="5" style="margin-top:20px;margin-right:-8px;"><tr><td>
<?php
 	echo $accitemsdelivered;
 	?>
 </td></tr>
 <?php
if ($specialinstructionsdelivery != '') { ?>
 <tr><td style="padding:10px; font-size:12px;">
 
 <b>DELIVERY INSTRUCTIONS:</b><br><br>
<?php
 	echo $specialinstructionsdelivery;
?>
</td></tr>
<?php } ?> 
 </table>
<?php
 	echo $footer;
} 

if ($accessoriesonly=='n' || $accessoriesonly=='x') { ?>
<div class="p2">
<br><br>
<table  border="0" cellspacing="0" cellpadding="3" width="90px" style="margin-top:-15px;" >
  <tr class="baytotals">
    <td align="left" width="45px"><b>TOTALS</b></td><td align="left" width="45px"><b>WRAP</b></td><td align="left" width="45px"><b>LOAD</b></td>
  </tr>
</table>

</div>
<div class="clear">&nbsp;</div>

<div>
<?php if ($mattressPicked=='y') { 
?>
<div class="p1">
<table  border="0" cellspacing="0" cellpadding="3" width="100%" >
  <tr>
    <td><div class=addresshdg>Mattress</div>
    <?= $mattressdetails ?>
    </td>
  </tr>
</table>
</div>
<div class="p2">
<table  border="0" cellspacing="0" cellpadding="3" width="90px" >
  <tr class="baytotals">
    <td align="left" width="45px"><b>QTY:&nbsp;<?= $mattresscount ?></b></td><td align="left" width="45px"><b><?= $wraptype ?></b></td><td align="left" width="45px"><span class='boxsmall2'>&nbsp;&nbsp;&nbsp;</span></td>
  </tr>
</table>
</div>
</div>
<div class="clear">&nbsp;</div>

<div>
<?php 
};
?>
<?php if ($basePicked=='y') { 
?>
<div class="p1">
<table  border="0" cellspacing="0" cellpadding="3" width="100%" >
  <tr>
    <td><div class=addresshdg>Base</div>
    <?= $basedetails ?>
    </td>
  </tr>
</table>
</div>
<div class="p2">
<table border="0" cellspacing="0" cellpadding="3" width="90px" >
  <tr class="baytotals">
    <td align="left" width="45px"><b>QTY: <?= $basecount ?></b></td><td align="left" width="45px"><b><?= $wraptype ?></b></td><td align="left" width="45px"><span class='boxsmall2'>&nbsp;&nbsp;&nbsp;</span></td>
  </tr>
</table>
</div>
</div>
<div class="clear">&nbsp;</div>
<?php
}; 
?>
<?php if ($topperPicked=='y') { 
?>
<div class="p1">
<table  border="0" cellspacing="0" cellpadding="3" width="100%" >
  <tr>
    <td><div class=addresshdg>Topper</div>
    <?= $topperdetails ?>
    </td>
  </tr>
</table>
</div>
<div class="p2">
<table border="0" cellspacing="0" cellpadding="3" width="90px" >
  <tr class="baytotals">
    <td align="left" width="45px"><b>QTY: <?= $toppercount ?></b></td><td align="left" width="45px"><b><?= $wraptype ?></b></td><td align="left" width="45px"><span class='boxsmall2'>&nbsp;&nbsp;&nbsp;</span></td>
  </tr>
</table>
</div>
</div>
<div class="clear">&nbsp;</div>
<?php
}; 
?>
<?php if ($legsPicked=='y') { 
?>
<div class="p1">
<table  border="0" cellspacing="0" cellpadding="3" width="100%" >
  <tr>
    <td><div class=addresshdg>Legs</div>
    <?= $legsdetails ?>
    </td>
  </tr>
</table>
</div>
<div class="p2">
<table border="0" cellspacing="0" cellpadding="3" width="90px" >
  <tr class="baytotals">
    <td align="left" width="45px"><b>QTY: <?= $legscount ?></b></td><td align="left" width="45px"><b><?= $wraptype ?></b></td><td align="left" width="45px"><span class='boxsmall2'>&nbsp;&nbsp;&nbsp;</span></td>
    </td>
  </tr>
</table>
</div>
</div>
<div class="clear">&nbsp;</div>
<?php
}; 
?>
<?php if ($valancePicked=='y') { 
?>
<div class="p1">
<table  border="0" cellspacing="0" cellpadding="3" width="100%" >
  <tr>
    <td><div class=addresshdg>Valance</div>
    <?= $valancedetails ?>
    </td>
  </tr>
</table>
</div>
<div class="p2">
<table border="0" cellspacing="0" cellpadding="3" width="90px" >
  <tr class="baytotals">
    <td align="left" width="45px"><b>QTY: <?= $valancecount ?></b></td><td align="left" width="45px"><b><?= $wraptype ?></b></td><td align="left" width="45px"><span class='boxsmall2'>&nbsp;&nbsp;&nbsp;</span></td>
  </tr>
</table>
</div>
</div>
<div class="clear">&nbsp;</div>
<?php
}; 
?>
<?php if ($hbPicked=='y') { 
?>
	<div class="p1">
	<table  border="0" cellspacing="0" cellpadding="3" width="100%" >
	  <tr>
   	 <td><div class=addresshdg>Headboard</div>
   	 <?= $hbdetails ?>
   	 </td>
  	</tr>
	</table>
	</div>
	<div class="p2">
	<table border="0" cellspacing="0" cellpadding="3" width="90px" >
	  <tr class="baytotals">
	    <td align="left" width="45px"><b>QTY: <?= $hbcount ?></b></td><td align="left" width="45px"><b><?= $wraptype ?></b></td><td align="left" width="45px"><span class='boxsmall2'>&nbsp;&nbsp;&nbsp;</span></td>
	  </tr>
	</table>
	</div>
	</div>
	<div class="clear">&nbsp;</div>


<?php
}; 
if ($tobedelivered != '') {
?>

<table width="48%" align="left" border="1" cellspacing="0" cellpadding="5" style="margin-top:20px;"><tr><td>
<?php
 	echo '<p style="font-size:12px"><b>Items to follow:</b></p><p>' .$tobedelivered .'</p>';
 	?>
 </td></tr></table>

 <?php
}
?>
<table width="48%" align="right" border="1" cellspacing="0" cellpadding="5" style="margin-top:20px;"><tr><td>
<?php
 	echo $itemsdelivered;
 	?>
 </td></tr>
<?php
if ($specialinstructionsdelivery != '') { ?>
 <tr><td style="padding:10px; font-size:12px;">
 
 <b>DELIVERY INSTRUCTIONS:</b><br><br>
<?php
 	echo $specialinstructionsdelivery;
?>
</td></tr>
<?php } ?> 	
</table>

 <div class="clear">&nbsp;</div>

<?php
 	echo $footer;
 	?>
<?php
}; 
//debug($accrequired."<br>".$accessoriesonly."<br>".$accexists);
//die;?> 	
<?php if ($accrequired=='y' && $accessoriesonly != 'y') {
    echo $pagebreak;
	echo $header2;
 	echo $accdetails;?>
 <table width="48%" align="right" border="1" cellspacing="0" cellpadding="5" style="margin-top:20px;margin-right:-8px;"><tr><td>
<?php
 	echo $accitemsdelivered;
 	?>
 </td></tr>
 <?php
if ($specialinstructionsdelivery != '') { ?>
 <tr><td style="padding:10px; font-size:12px;">
 
 <b>DELIVERY INSTRUCTIONS:</b><br><br>
<?php
 	echo $specialinstructionsdelivery;
?>
</td></tr>
<?php } ?> 	</table>
<?php
 	echo $footer;
}; 
?>
