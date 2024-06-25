<div id='donotprint'><a href='javascript: history.go(-1)' onClick='return confirm("Remember to remove brochure requests when you have finished printing?"); ' id="donotprint">BACK</a></div> 
	
<?php  
if($this->Security->retrieveUserLocation()!=8) {
	$count=0;
	$xcount = -1;
	$ycount = 0;
	$y = 40;
}

if($this->Security->retrieveUserLocation()==8) {
	$count=0;
	$xcount = -1;
	$ycount = 0;
	$y = 140;
}

foreach ($contactArray as $contact):
$address = $addressArray[$count]; 

if($this->Security->retrieveUserLocation()!=8) {
	$xcount = $xcount+1;
	if ($xcount > 2) {
 	  	 $xcount = 0;
  	   if ($ycount < 6) {
   	    		$y = $y + 135;
   			} else {
     	 		$y = $y + 169;
    	 		$ycount = -1;
   			}
    		$ycount = $ycount+1;
	}
	if ($xcount == 0) {
	 	  $x = 12;
	 } else if ($xcount == 1) {
	    $x = 242;
	} else {
		$x = 480;
	}
}

if($this->Security->retrieveUserLocation()==8) {
	$xcount = $xcount + 1;
	if ($xcount > 1){
   	 	$xcount = 0;
    		if ($ycount < 3) {
       			$y = $y + 310;
   			} else {
      			$y = $y + 290;
     			$ycount = -1;
   		    }
    	    $ycount = $ycount + 1;
	}
	if ($xcount == 0) {
 	   $x = 100;
	} else {
	   $x = 450;
	}
}
?>
 
	<div style="display: block; width: 200px; position: absolute; left: <?= $x?>px; top: <?= $y?>px;">
	<?php 
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
	 echo "</div>";

$count += 1;

endforeach;
?>



