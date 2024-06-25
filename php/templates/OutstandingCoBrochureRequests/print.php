<div id='donotprint'><a href='javascript: history.go(-1)' onClick='return confirm("Remember to remove brochure requests when you have finished printing and a follow update has been added for brochure request letters sent?"); ' id="donotprint">BACK</a></div>

<?php
  $date = new DateTime(); 
?>  
	
<?php  
$count=0;
foreach ($contactArray as $contact):
$address = $addressArray[$count]; 

if ($submit1 == 'y') {
	?>
	<div id="lettercontainer">
	<?php 
	echo '<p>';
	echo $date->format('j F Y') .'<br><br>';
	if ($contact['title'] != '') {
		echo ucwords(strtolower($contact['title'])) ." ";
	 }
	 if ($contact['first'] != '') {
		echo ucwords(strtolower($contact['first'])) ." ";
	 }
	 if ($contact['surname'] != '') {
		echo ucwords(strtolower($contact['surname'])) ." ";
	 }
	 echo '<br>';
	 if ($address['company'] != '') {
		echo $address['company'] ."<br>";
	 }
	 if ($address['street1'] != '') {
		echo $address['street1'] ."<br>";
	 }
	 if ($address['street2'] != '') {
		echo $address['street2'] ."<br>";
	 }
	 if ($address['street3'] != '') {
		echo $address['street3'] ."<br>";
	 }
	 if ($address['town'] != '') {
		echo $address['town'] ."<br>";
	 }
	 if ($address['county'] != '') {
		echo $address['county'] ."<br>";
	 }
	 if ($address['postcode'] != '') {
		echo $address['postcode'] ."<br>";
	 }
	 if ($address['country'] != '') {
		echo $address['country'] ."<br>";
	 }
	 echo '<br><br>';
	 echo $greeting .' ';
	 if ($contact['title'] != '') {
		echo ucwords(strtolower($contact['title'])) ." ";
	 }
	 if ($contact['surname'] != '') {
		echo ucwords(strtolower($contact['surname'])) ." ";
	 }
	 echo '</p>';
	 echo $correspondence;
	 echo "</div>";
}
$count += 1;
if ($count != $numContacts) {
 ?>
<div style="page-break-after:always">&nbsp;</div>
<?php } 
endforeach;
?>



