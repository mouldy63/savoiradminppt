<div id="giftlettercontainer" style="position:absolute; top:160px;">
<?php
echo "<p>".$address."</p><br>";
if (isset($salutation)) {
    echo "<p>".$salutation."</p>";
}
if ($letterdate != '') {
echo "<p>".$letterdate->format('l, j F Y')."</p><br><br><br><br>";
}
echo $letter;
?>
	




</div>