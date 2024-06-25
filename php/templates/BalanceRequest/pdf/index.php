<div id="lettercontainer" style="position:absolute; top:0px;">
<?php
  $date = new DateTime(); 

echo $header;
echo "<p>".$date->format('j F Y')."</p>";
echo $address;
?>
	
<p>We are pleased to confirm that we are in the final stages of production for your bed set, and your bed set is due to be completed soon.</p><p>The outstanding balance on your bed set is presented on the following page and I would be grateful if you can arrange for this payment to be made prior to delivery. To pay this final amount by card, please call our showroom on <?php echo $showroomtel ?>. Alternatively, you can arrange a bank transfer to the following account:</p>

<p>Please use this payment reference <?= $bankref ?><br>Bank Name: HSBC<br />Bank Address: 69 Park Royal Road, London, NW10 7JR<br />Account Name: Savoir Beds Ltd<br />Sort Code: 40-05-23<br />Account Number: 81321846<br />IBAN: GB24HBUK40052381321846<br />BIC: HBUKGB4B<br /></p>
<p>I look forward to hearing from you soon regarding the delivery. </p> <p>Kind regards,<br><br /><br /><br /><br /><?= $username ?><br /><?= $locationname ?></p>

<h6>&nbsp;</h6>

<?php echo $prodtable ?>



</div>