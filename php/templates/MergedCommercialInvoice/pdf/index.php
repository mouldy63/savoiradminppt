<style>
        body { font-family: sans-serif; }
        
        /* Define the page footer with page numbering */
        @page {
            margin: 20mm;
            @bottom-center {
                content: "Page " counter(page) " of " counter(pages);
                font-size: 10px;
            }
        }
    </style>
<?= $header ?>
<table class="comminv" cellspacing="0px" cellpadding="3px">
  <tr>
    <td colspan="2" width="50%" valign="top"">Seller:<br>Savoir Beds Limited<br>1 Old Oak Lane<br>London NW10 6UD<br>UK</td>
    <td colspan="2" valign="top">Date: <?= $collectiondate ?><br><br>Invoice No: <br><?=$cinvono?></td>
    <td colspan="2" valign="top">Customer's Order No. Multiple <br></td>
  </tr>
  <tr>
    <td colspan="2" valign="top">Consignee:<br><?= $deliveryaddress ?></td>
    <td colspan="4" valign="top" width="65%">Buyer:<br><?= $customeraddress ?></td>
  </tr>
  <tr>
    <td valign="top" width="10%">Country of Origin: <b>UK</b>&nbsp;</td>
    <td valign="top">Country of Final Destination:<br><br><?= strtoupper ($destinationport) ?></td>
    <td colspan="4" valign="top">Country of Origin of Goods:<br><b>United Kingdom</b></td>
  </tr>
  <tr>
    <td colspan="2" valign="top" style="border-bottom-style: none !important;
border-bottom: none;">Terms & Conditions of Delivery and Payment:<br><br><?= $deliverytermstext ?></td>
    <td colspan="4" valign="top">Mode of Transport and Other Transport Information:<br><br><?= $shippercontact ?></td>
  </tr>
   <tr>
   <td colspan="2" valign="top" style="border-top-style: none !important;
border-top: none;"></td>
    <td colspan="4" valign="top">Currency of Sale: <?= $currency ?>
    
    </td>
  </tr>
  <tr>
  <td colspan="2" align="center"><b>Number of Packages<br><?=$marksnumbers?></b></td>
  <td align="center"><b>Total Gross Weight (kg)<br>
    <?=$totalweight?>
  </b></td>
  <td colspan="2" align="center"><b>Total Net Weight (kg)<br><?=$totalNW?></b></td>
  <td align="center"><b>Total Cube (M3)<br><?=$cubicmeters?></b></td>
</tr>

</table>
<?= $commercialinv ?>
<div>
<?= $footer ?>

</div>
