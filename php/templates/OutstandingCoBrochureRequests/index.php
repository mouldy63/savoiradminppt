<?php use Cake\Routing\Router; ?>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#datequotedeclined" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#datequotedeclined" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});

</script>
<div id="brochureform" class="brochure" style="background-color:#f3f2f2;">
<h1>Outstanding Brochure Requests</h1>
<p>The following company brochure requests need processing:</p>
<p><a href="javascript:selectAll()">Select All</a>&nbsp;|
    <a href="javascript:deselectAll()">Deselect All</a></p>
<p>Total: <?php echo count($brochurerequests); ?></p>
<form action="/php/OutstandingCoBrochureRequests/print" method="post" name="form1" id="form1">
<?php foreach ($brochurerequests as $row): ?>
<p><input type="checkbox" name="XX_<?=$row['CONTACT_NO'] ?>" id="XX_<?=$row['CONTACT_NO'] ?>"> 
<a href='/editcust.asp?val=<?=$row['CONTACT_NO']?>'>
<?php if ($row['title'] != '') {
echo $row['title'] ." ";
} ?>
<?php if ($row['first'] != '') {
echo $row['first'] ." ";
} ?>
<?php if ($row['surname'] != '') {
echo $row['surname'] .', ';
} ?>
<?php if ($row['company'] != '') {
echo $row['company'] .' ';
} ?>
<?php if ($row['street1'] != '') {
echo $row['street1'] .' ';
} ?>
<?php if ($row['street2'] != '') {
echo $row['street2'] .' ';
} ?>
<?php if ($row['street3'] != '') {
echo $row['street3'] .' ';
} ?>
<?php if ($row['town'] != '') {
echo $row['town'] .' ';
} ?>
<?php if ($row['county'] != '') {
echo $row['county'] .' ';
} ?>
<?php if ($row['postcode'] != '') {
echo $row['postcode'] .' ';
} ?>
<?php if ($row['country'] != '') {
echo $row['country'] .' ';
} ?>
<?php if($this->Security->retrieveUserLocation()==1) {?>
<font color=red>Showroom: <?=$row['location']?>, </font>
<?php } ?>
<?php 
 echo $contactDates[$row['CONTACT_NO']];
 echo '<font color="blue"> Type: ' .$brochureRequestTypes[$row['CONTACT_NO']] .'</font>';
 
?>



</a>

</p>
<?php endforeach; ?>
<label>
      &nbsp;&nbsp; <input name="corresid" type="hidden" value="1">
      <input type="submit" name="submit1" id="submit1" value="Print Letters">
    </label>
    <input type="submit" name="submit2" id="submit2" value="Print Labels">
    <?php if($this->Security->retrieveUserLocation()==8) {?>
   <input type="submit" name="submit5" id="submit5" value="Print 2 x 3 Labels">
   <?php } else { ?>
   <input type="submit" name="submit5" id="submit5" value="Print 3 x 7 Labels">
   <?php } ?>
   <input type="submit" name="submit3" id="submit3" value="Remove Brochure Requests" onClick="return confirm('Have you printed the labels and the letters? Clicking OK below will now remove these brochure requests from the queue?'); ">
   <input type="submit" name="submit6" id="submit6" value="Download CSV file">
    
    <p><strong>Please use back button on your browser once you have finished printing. REMEMBER - once you are happy you have printed the labels and letters return and remove brochure request(s) from the list above. <font color="#FF0000">NB: A follow update has been added for brochure request letters which you have queued for printing - if printing has failed you will need to remove / adjust the follow-up date</font></strong></p>
<P>  <input type="submit" name="submit4" id="submit4" value="Delete Entries (SPAM ONLY)" onClick="return confirm('Are you sure you want to DELETE these brochure requests?'); "></p>

</form>     
     

</div>
<script>

$("#submit2" ).click(function() {
   	$("#form1").attr('action', '/php/OutstandingCoBrochureRequests/printlabel1');
});

$("#submit3" ).click(function() {
   	$("#form1").attr('action', '/php/OutstandingCoBrochureRequests/brochureRequestSent');
});

$("#submit4" ).click(function() {
   	$("#form1").attr('action', '/php/OutstandingCoBrochureRequests/delete');
});

$("#submit5" ).click(function() {
   	$("#form1").attr('action', '/php/OutstandingCoBrochureRequests/printlabel3x7');
});

$("#submit6" ).click(function() {
   	$("#form1").attr('action', '/php/OutstandingCoBrochureRequests/export');
});



function selectAll() {
	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = true;
	        }
	    }
	}
}

function deselectAll() {
	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = false;
	        }
	    }
	}
}
</script>