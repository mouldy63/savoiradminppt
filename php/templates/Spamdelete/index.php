<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure">
<form action="/php/spamdelete" method="post" name="form1" id="form1">
<p>The following entries have been retired and now need deleting or may have been deleted in error and need reactivating.</p>
<p class="b"> <a href="javascript:selectAll()">Select All</a>&nbsp;|
<a href="javascript:deselectAll()">Deselect All</a>&nbsp;</p>

<?php foreach ($spamContacts as $row): ?>
<p>
<input type="checkbox" name="XX_<?php echo $row['CODE'] ?>" id="XX_<?php echo $row['CODE'] ?>"><a href="/editcust.asp?val=<?php echo $row['CONTACT_NO'] ?>">
<?php if ($row['title'] !='' ) {
echo " " .$row['title']; 
}
if ($row['first'] !='' ) {
echo " " . $row['first'];
}
if ($row['surname'] !='' ) {
echo ", " . $row['surname'];
}
if ($row['company'] !='' ) {
echo ", " . $row['company'];
}
if ($row['street1'] !='' ) {
echo ", " . $row['street1'];
}
if ($row['street2'] !='' ) {
echo ", " . $row['street2'];
}
if ($row['street3'] !='' ) {
echo ", " . $row['street3'];
}
if ($row['town'] !='' ) {
echo ", " . $row['town'];
}
if ($row['county'] !='' ) {
echo ", " . $row['county'];
}
if ($row['postcode'] !='' ) {
echo ", " . $row['postcode'];
}
if ($row['country'] !='' ) {
echo ", " . $row['country'];
}
?>
</a></p>  

<?php endforeach; ?>    

<input type="submit" name="submit2" id="submit2" value="Re-activate" onClick="submitReactivate();">
<input type="submit" name="submit1" id="submit1" value="Delete Entries (spam)" onClick="submitDelete()">
</form> 
</div>
<script language="JavaScript">
<!--
function submitReactivate() {
	if (confirm('Are you sure you want to reactivate these brochure requests?')) {
	$('#form1').attr('action', '/php/spamdelete/reactivate');
	$('#form1').submit();
	}
}

function submitDelete() {
	if (confirm('Are you sure you want to DELETE these entries - all details for these customers will be removed?')) {
	$('#form1').attr('action', '/php/spamdelete/delete');
	$('#form1').submit();
	}
}

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

//-->
</script>