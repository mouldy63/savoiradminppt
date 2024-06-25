<div><?= $header ?>
<div id="WS1">
<table  border="0" cellspacing="0" cellpadding="3" >
  <tr>
    <td>
    <p class="addressbody"><?= $showroomaddress ?></p>
    </td>
  </tr>
</table>
</div>
<div id="WS2">

    <p class="addressbody"><?= $customerdetails ?></p>
    
</div>
<div class="clear">&nbsp;</div>
<p align="center" style="font-size:16px;font-weight:bold">WHOLESALE INVOICE</p>

<table width="100%" border="0" cellspacing="0" cellpadding="1">
<tr style="font-size:12px;">
<td width="40%"><b>Bed Model</b></td>
<td width="18%"><b>Size</b></td>
<td align="center"><b>Quantity</b></td>
<td align="right"><b>Unit Price/<?=$currency?> <?=$currencysymbol?></b></td>
<td align="right"><b>Price/<?=$currency?> <?=$currencysymbol?></b></td>
</tr>
<?php if ($mattressdetails!='') {
echo $mattressdetails;
} ?>

<?php if ($topperdetails!='') {
echo $topperdetails;
} ?>

<?php if ($legsdetails!='') {
echo $legsdetails;
} ?>

<?php if ($basedetails!='') {
echo $basedetails;
} ?>

<?php if ($hbdetails!='') {
echo $hbdetails;
} ?>

<?php if ($valancedetails!='') {
echo $valancedetails;
} ?>

<?php if ($accdetails!='') {
echo $accdetails;
} ?>

</table>
<table width='100%' style='position:absolute; bottom:220;'><tr><td>
<table width='100%' cellspacing='0' border='1' cellpadding='2' class='wholesalefont'>
<tr><td width='80%'>Total Net:</td><td align='right'><?php echo $currencysymbol .$setinvoicetotal ?></td></tr>
<tr><td>VAT: </td><td align='right'><?php echo $currencysymbol ?>0.00</td></tr>
<tr><td>Gross Total: </td><td align='right'><?php echo $currencysymbol .$setinvoicetotal ?></td></tr></table>
<?php 

echo $footer;
?>
</td></tr></table>
</div>