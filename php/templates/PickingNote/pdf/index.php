<?= $header ?>
<div id="c1">
<table  border="0" cellspacing="0" cellpadding="3" >
  <tr>
    <td><div class=addresshdg>Client Details</div>
    <p class="addressbody"><?= $customerdetails ?></p>
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
 </td></tr></table>
<?php
 	echo $footer;
} 

if ($accessoriesonly=='n' || $accessoriesonly=='x') { ?>
<div class="p2">
<table  border="0" cellspacing="0" cellpadding="3" width="130px" style="margin-top:-15px;" >
  <tr class="baytotals">
    <td align="left" width="45px"><b>TOTALS</b></td><td align="left" width="45px"><b>WRAP</b></td><td align="right" width="45px"><b>BAY</b></td>
    </td>
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
<table  border="0" cellspacing="0" cellpadding="3" width="130px" >
  <tr class="baytotals">
    <td align="left" width="45px"><div><b>QTY:&nbsp;<?= $mattresscount ?></b></td><td align="left" width="45px"><b><?= $wraptype ?></b></td><td align="right" width="45px"><b><?= $mattressbay ?></b></td></div>
    </td>
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
<table border="0" cellspacing="0" cellpadding="3" width="130px" >
  <tr class="baytotals">
    <td align="left" width="45px"><div><b>QTY: <?= $basecount ?></b></td><td align="left" width="45px"><b><?= $wraptype ?></b></td><td align="right" width="45px"><b><?= $basebay ?></b></td></div>
    </td>
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
<table border="0" cellspacing="0" cellpadding="3" width="130px" >
  <tr class="baytotals">
    <td align="left" width="45px"><div><b>QTY: <?= $toppercount ?></b></td><td align="left" width="45px"><b><?= $wraptype ?></b></td><td align="right" width="45px"><b><?= $topperbay ?></b></td></div>
    </td>
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
<table border="0" cellspacing="0" cellpadding="3" width="130px" >
  <tr class="baytotals">
    <td align="left" width="45px"><div><b>QTY: <?= $legscount ?></b></td><td align="left" width="45px"><b><?= $wraptype ?></b></td><td align="right" width="45px"><b><?= $legsbay ?></b></td></div>
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
<table border="0" cellspacing="0" cellpadding="3" width="130px" >
  <tr class="baytotals">
    <td align="left" width="45px"><div><b>QTY: <?= $valancecount ?></b></td><td align="left" width="45px"><b><?= $wraptype ?></b></td><td align="right" width="45px"><b><?= $valancebay ?></b></td></div>
    </td>
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
	<table border="0" cellspacing="0" cellpadding="3" width="130px" >
	  <tr class="baytotals">
	    <td align="left" width="45px"><div><b>QTY: <?= $hbcount ?></b></td><td align="left" width="45px"><b><?= $wraptype ?></b></td><td align="right" width="45px"><b><?= $hbbay ?></b></td></div>
	    </td>
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
 	echo '<p style="font-size:12px"><b>To be delivered:</b></p><p>' .$tobedelivered .'</p>';
 	?>
 </td></tr></table>
 <?php
}
?>
<table width="48%" align="right" border="1" cellspacing="0" cellpadding="5" style="margin-top:20px;"><tr><td>
<?php
 	echo $itemsdelivered;
 	?>
 </td></tr></table>
<?php
 	echo $footer;
 	?>
<?php
}; 
?> 	
<?php if ($accrequired=='y' && $accessoriesonly != 'y') {
    echo $pagebreak;
	echo $header;
 	echo $accdetails;?>
 <table width="48%" align="right" border="1" cellspacing="0" cellpadding="5" style="margin-top:20px;margin-right:-8px;"><tr><td>
<?php
 	echo $accitemsdelivered;
 	?>
 </td></tr></table>
<?php
 	echo $footer;
}; 
?>
