<?= $header ?>
<table class="comminv" cellspacing="0px" cellpadding="3px">
  <tr>
    <td colspan="2" width="50%" valign="top"">Seller:<br>Savoir Beds Limited<br>1 Old Oak Lane<br>London NW10 6UD<br>UK</td>
    <td valign="top">Date: <?= $collectiondate ?><br><br>Invoice No: <br>C.INV-<?= $ordernumber ?></td>
    <td colspan="2" valign="top">Customer's Order No. <?= $ordernumber ?><br><br>Other References:<br><?= $customerreference ?></td>
  </tr>
  <tr>
    <td colspan="2" valign="top">Consignee:<br><?= $deliveryaddress ?><br><?= $phonedetails ?><br>Contact Name: <?= $deliverycontact ?></td>
    <td colspan="3" valign="top" width="65%">Buyer:<br><?= $customeraddress ?></td>
  </tr>
  <tr>
    <td valign="top" width="10%">Country of Origin:<br><br>UK&nbsp;</td>
    <td valign="top">Country of Final Destination:<br><br><?= strtoupper ($destinationport) ?></td>
    <td colspan="3" valign="top">Country of Origin of Goods: <br><br>United Kingdom</td>
  </tr>
  <tr>
    <td colspan="2" valign="top" style="border-bottom-style: none !important;
border-bottom: none;">Terms & Conditions of Delivery and Payment:<br><br><?= $deliverytermstext ?></td>
    <td colspan="3" valign="top">Mode of Transport and Other Transport Information:<br><br><?= $shippercontact ?></td>
  </tr>
   <tr>
   <td colspan="2" valign="top" style="border-top-style: none !important;
border-top: none;"></td>
    <td colspan="3" valign="top">Currency of Sale: <?= $currency ?>
    
    </td>
  </tr>
  <tr>
    <td valign="top" width="5%">Marks & Numbers:<br><br><?= $marksnumbers ?> Packages marked with <?= $ordernumber ?></td>
    <td valign="top" width="40%">Description of Goods:<br><br><?= $descofgoods ?><br><?= $wraptext ?></td>
    <td valign="top">Total number of packages: <br><?= $marksnumbers ?></td>
    <td valign="top">Gross Weight (kg):<br><?= $totalweight ?></td>
    <td valign="top">Cube (M3):<br><?= $this->Number->precision($cubicmeters, 2) ?></td>
  </tr>
</table>
<?= $commercialinv ?>

<div>
<?= $footer ?>
</div>
