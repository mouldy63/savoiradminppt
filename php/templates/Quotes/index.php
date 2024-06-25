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
<br><br><h1>Quotes</h1>
<p>Current Quotes | <a href="/php/DeclinedQuotes">View Declined Quotes</a></p>
<p><a href="javascript:selectAll()">Select All</a>&nbsp;|
    <a href="javascript:deselectAll()">Deselect All</a></p>
<p>Total: <?php echo count($quotes); ?></p>
<form action="/php/Quotes/edit" method="post" name="form1" id="form1">
<?php foreach ($quotes as $row): ?>
<p><input type="checkbox" name="XX_<?=$row['PURCHASE_No'] ?>" id="XX_<?=$row['PURCHASE_No'] ?>"> 
<a href='/edit-purchase.asp?quote=y&order=<?=$row['PURCHASE_No'] ?>'>
<?php if ($row['title'] != '') {
echo $row['title'] ." ";
} ?>
<?php if ($row['first'] != '') {
echo $row['first'] ." ";
} ?>
<?php if ($row['surname'] != '') {
echo $row['surname'] .' ';
} ?>
<?php 
echo ' - Quote No: ' .$row['ORDER_NUMBER'] .' ';
?>
<?php 
echo ' - Quote Date: ' .date("d/m/Y h:i:s", strtotime($row['ORDER_DATE']));
?>
<?php if (!$this->Security->userHasRoleInList('NOPRICESUSER')) { 
echo ' - Value: ' .$this->MyForm->formatMoneyWithSymbol($row['total'], $row['ordercurrency']);
} ?>
<?php if (isset($row['reasonquotedelined'])) {
echo ' - Reason Declined: ' .$row['reasonquotedelined'] .' ';
} ?>
<?php if (isset($row['datequotedeclined'])) {
echo ' - Date Declined: ' .$row['datequotedeclined'] .' ';
} ?>
</a>
</p>
<?php endforeach; ?>
<p>Please provide date and reason for quotes selected above being declined - NOTE - reason / date will apply to all those selected.</p>
<p>
    <label>
      Date quote declined
      <br>
      <input name="datequotedeclined" type="text" id="datequotedeclined" size="15">
       </label>
      </p>
      <p>
      Reason quote declined<br>
      <input name="reasonquotedeclined" type="text" id="reasonquotedeclined" size="80" maxlength="255">
      </p>
      <p>
      <input type="submit" name="submit1" id="submit1" value="REMOVE QUOTES"> 
     </p> 
    </label>
    
  </p>
</form>     
     

</div>
<script>
<!--

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
