<?php use Cake\Routing\Router; ?>

<script>
$(function() {
	var year = new Date().getFullYear();
<?php foreach ($activeshowrooms as $row): ?>
	$( "#YY<?= $row['idlocation'] ?>" ).datepicker({changeMonth: true, yearRange: "-21:+2", changeYear: true});
	$( "#YY<?= $row['idlocation'] ?>" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
<?php endforeach; ?>
	
	$( "#collectiondate" ).datepicker({
		changeMonth: true,
		yearRange: "-21:+2",
		changeYear: true
	});
	$( "#collectiondate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
	
	$( "#monthto" ).datepicker({
		changeMonth: true,
		yearRange: "-21:+2",
		changeYear: true
	});
	$( "#monthto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
	
});

</script>


<div id="brochureform" class="brochure">

	<form name="form1" method="post" action="/php/AddCollection/add" onSubmit="return FrontPage_Form1_Validator(this)">		      
	<div id="d1">
	<p>Collection created by: <?= $userId ?> </p>
    		
			  <h1>ADD NEW COLLECTION</h1>
		  <p>Collection Date:
		    <br>
			    <input name="collectiondate" type="text" id="collectiondate" size="40"  value="">
		      </p>

		      <p>Shipper / Freight Forwarder:<br>
		      <select name="shipper" id="shipper">
<option value="n">Shipper Address:  </option>
<?php foreach ($activeshippers as $row): ?>               
<option value="<?php echo $row['shipper_ADDRESS_ID'] ?>"><?php echo $row['shipperName'] ?></option>
<?php endforeach; ?>
</select>
			 </p> 
			 </p>
               <p>Transport Mode:<br>
			    <input name="transportmode" type="text" id="transportmode" size="40" maxlength="50">
			    <br>
			  </p>
			  <p>Container Ref:<br>
			    <input name="containerref" type="text" id="containerref" size="40" maxlength="20">
			  </p>
			  <p>Terms of Delivery:<br />
		      <select name="deliveryterms" id="deliveryterms">
<option value="n">Choose Delivery Terms:  </option>
<?php foreach ($delterms as $row): ?>               
<option value="<?php echo $row['deliveryTermsID'] ?>"><?php echo $row['DeliveryTerms']." (".$row['deliverydesc'].")" ?></option>
<?php endforeach; ?>
</select>
<br><textarea name="termstext" cols="40" rows="1" onKeyPress="return taLimit(this)" onKeyUp="return taCount(this,'myCounter')" ></textarea><br />&nbsp;<B><SPAN id=myCounter>50</SPAN></B>/50</p>
			 <p>Destination Port:<br>
			    <input name="destport" type="text" id="destport" size="40" maxlength="50">
			  </p>
     <div id="e2"> <p>Consignee Details:<br>
<select name="consignee" id="consignee">
<option value="n">Choose Consignee:  </option>
<?php foreach ($consignees as $row): 

?>               
<option value="<?php echo $row['consignee_ADDRESS_ID'] ?>" ><?php echo $row['consigneeName'] ?></option>
<?php endforeach; ?>
</select>
			 </p> 
</div>
<div id="e3"> <p><a href="/php/consignee" target="_blank"><font color='red'>Add New Consignee</font></a></p></div>   
<div class="clear" style="height:1px;"></div>
 <div  id="useconsig" class="clear">
<p><div class="adjustpara">Use Consignee Address as all delivery addresses on manifest? </div><label class="toggle">
    <input type="checkbox" name="consigneebutton" id="consigneebutton" >
    <span class="slider"></span>
    <span class="labels" data-on="Yes" data-off="No"></span>
  </label></p></div>    
		</div>
        <div id="d2">
        <h1>&nbsp;</h1>
        <p>Choose which showrooms can use this Collection</p>
        <p>
        <?php foreach ($activeshowrooms as $row): ?> 
         ETA Date: <input name="YY<?php echo $row['idlocation'] ?>" id="YY<?php echo $row['idlocation'] ?>" value="" type="text" size="10" maxlength="10">
            &nbsp; 
            
            
            <?php echo $row['adminheading'] ?> <br />  
       
        <?php endforeach; ?>
        </p>
        <input type="submit" id="submit" name="submit" value="Add Collection" />
        </div>
                

    
    
</form>
</div>
<script>
function customReset() {
    $("#collectiondate").val("");
    $("#collectiondate").val("");
    return false;
}
$(document).ready(function(){
	$('#cancel').click(function(){
		$('.changeBack').each(function(index,element){
			var content = $(element).attr('data-orginal');
			$(element).val(content);
		});
		$('.changeBackOption').removeAttr('selected');
		$('.changeBackOption').each(function(index,element){
			var isSelected = $(element).attr('data-orginal');
			if(isSelected.length>0){
				var select = document.createAttribute("selected");
				element.setAttributeNode(select);
			}
		});
	});
});
</script>
<script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{
 

   if (theForm.collectiondate.value == "")
  {
    alert("Please select a collection date");
    theForm.collectiondate.focus();
    return (false);
  }

   if (theForm.shipper.value == "n")
  {
    alert("Please select a shipper");
    theForm.shipper.focus();
    return (false);
  }
  if (theForm.deliveryterms.value == "n")
  {
    alert("Please select delivery terms");
    theForm.deliveryterms.focus();
    return (false);
  }

    return true;
} 


/**
 * DHTML textbox character counter script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
 */

maxL=50;
var bName = navigator.appName;
function taLimit(taObj) {
	if (taObj.value.length==maxL) return false;
	return true;
}

function taCount(taObj,Cnt) { 
	objCnt=createObject(Cnt);
	objVal=taObj.value;
	if (objVal.length>maxL) objVal=objVal.substring(0,maxL);
	if (objCnt) {
		if(bName == "Netscape"){	
			objCnt.textContent=maxL-objVal.length;}
		else{objCnt.innerText=maxL-objVal.length;}
	}
	return true;
}
function createObject(objId) {
	if (document.getElementById) return document.getElementById(objId);
	else if (document.layers) return eval("document." + objId);
	else if (document.all) return eval("document.all." + objId);
	else return eval("document." + objId);
}
</script>