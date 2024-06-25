<?php use Cake\Routing\Router; ?>


<div id="brochureform" class="brochure">
<p>All customers from the database with the postcode entered are listed below.  If the customer exists already please click on the relevant customer.</p>
<p>If the customer does not exist please enter a new record by clicking here </p>  
<p><a href="/php/AddCustomer/addnew?basic=n&email=<?=urlencode($email) ?>&postcode=<?=urlencode($postcode1) ?>">NEW RECORD</a><<</p> 
<?php
if ($submit1 != '') {
 foreach ($custPostcode as $row):
 echo "<p><a href='/editcust.asp?val=".$row['CONTACT_NO']."'>"; 
 if ($row['title'] != '') {
 echo $row['title'] ." ";
 }
 if ($row['first'] != '') {
 echo $row['first'] ." ";
 }
 if ($row['surname'] != '') {
 echo $row['surname'] .", ";
 }
 if ($row['company'] != '') {
 echo $row['company'] .", ";
 }
 if ($row['street1'] != '') {
 echo $row['street1'] .", ";
 }
 if ($row['street2'] != '') {
 echo $row['street2'] .", ";
 }
 if ($row['street3'] != '') {
 echo $row['street3'] .", ";
 }
 if ($row['town'] != '') {
 echo $row['town'] .", ";
 }
 if ($row['county'] != '') {
 echo $row['county'] .", ";
 }
 if ($row['postcode'] != '') {
 echo $row['postcode'] .", ";
 }
 if ($row['country'] != '') {
 echo $row['country'] .", ";
 }
 echo "<a></p>";
 endforeach; 
}
if ($submit2 != '') {
 foreach ($custEmail as $row):
 echo "<p><a href='/editcust.asp?val=".$row['CONTACT_NO']."'>"; 
 if ($row['title'] != '') {
 echo $row['title'] ." ";
 }
 if ($row['first'] != '') {
 echo $row['first'] ." ";
 }
 if ($row['surname'] != '') {
 echo $row['surname'] .", ";
 }
 if ($row['company'] != '') {
 echo $row['company'] .", ";
 }
 if ($row['street1'] != '') {
 echo $row['street1'] .", ";
 }
 if ($row['street2'] != '') {
 echo $row['street2'] .", ";
 }
 if ($row['street3'] != '') {
 echo $row['street3'] .", ";
 }
 if ($row['town'] != '') {
 echo $row['town'] .", ";
 }
 if ($row['county'] != '') {
 echo $row['county'] .", ";
 }
 if ($row['postcode'] != '') {
 echo $row['postcode'] .", ";
 }
 if ($row['country'] != '') {
 echo $row['country'] .", ";
 }
 echo "<a></p>";
 endforeach; 
}?>
</div>
