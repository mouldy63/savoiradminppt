<div><?= $header ?>
<div id="WS1">
<table valign="top" width="100%" border="0" cellspacing="0px" cellpadding="1px" style="padding:0px;position:relative;top:6px;" >
  <tr>
    <td>
    <p class="addressbody"><?= $showroomaddress ?></p>
    </td>
  </tr>
</table>
</div>
<div id="WS2">
<table valign="top" width="100%" border="0" cellspacing="0px" cellpadding="1px" style="padding:0px;position:relative;top:-6px;margin-left:5px;">
    <p class="addressbody"><?= $customerdetails ?></p>
  </table>  
</div>
<div class="clear"><br><br></div>
<p align="center" style="font-size:16px;font-weight:bold">INVOICE</p>

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

<?php if ($deliverycharge!='') {
echo $accdetails;
} ?>

</table>
<table width='99%' style='position:absolute; bottom:220;'><tr><td>
<table width='99%' cellspacing='0' border='1' cellpadding='2' class='wholesalefont'>
<tr><td width='70%'>Total Net:</td><td align='right'><?php echo $currencysymbol .$setnetinvoicetotal ?></td></tr>
<tr><td>VAT: </td><td align='right'><?php echo $currencysymbol .$vat ?></td></tr>
<tr><td>Gross Total: </td><td align='right'><?php echo $currencysymbol .$setinvoicetotal ?></td></tr></table>
<?php 

echo $footer;
?>
</td></tr></table>
</div>