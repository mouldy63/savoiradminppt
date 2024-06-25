<?php use Cake\Routing\Router; ?>

<style>

</style>

<script>
$(function() {
	var year = new Date().getFullYear();
<?php foreach ($activeshowrooms as $row): ?>
	$( "#YY<?= $row['idlocation'] ?>" ).datepicker({changeMonth: true, yearRange: "-21:+2", changeYear: true});
	$( "#YY<?= $row['idlocation'] ?>" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
	$("#YY<?= $row['idlocation'] ?>").attr('readonly', 'readonly');
<?php endforeach; ?>
	
	$( "#collectiondate" ).datepicker({
		changeMonth: true,
		yearRange: "-21:+2",
		changeYear: true
	});
	$( "#collectiondate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
	$("#collectiondate").attr('readonly', 'readonly');
	
	$( "#monthto" ).datepicker({
		changeMonth: true,
		yearRange: "-21:+2",
		changeYear: true
	});
	$( "#monthto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
	$("#monthto").attr('readonly', 'readonly');
	
});

function stopUncheck(checkboxid) {
  document.querySelector(checkboxid).onclick = (e)=>{
    e.preventDefault();
  }
}

</script>


<div id="brochureform" class="brochure">

<form name="form1" method="post" action="/php/EditCollection/edit" onSubmit="return FrontPage_Form1_Validator(this)">		      
<div id="d1">
    		
			  <h1>EDIT COLLECTION</h1>
			  <p>Created by : <?= $username ?>
			  <?php if ($updatedby != 0) {
			  	$updateddate=date("d/m/Y", strtotime(substr($updateddate,0,10)));
			  	 echo " | Last updated on: ".$updateddate." by ".$updatedby;
			  } ?> </p>
		  <p>Collection Date:
		    <br>
			    <input name="collectiondate" type="text" id="collectiondate" size="40"  value="<?= $collectiondate ?>">
			    <input name="collectionID" type="hidden" id="collectionID" size="40"  value="<?= $collectionID ?>">
		      </p>
		       <p>Shipper / Freight Forwarder:<br>
		      <select name="shipper" id="shipper">
<option value="n">Shipper Address:  </option>

<?php foreach ($activeshippers as $row): 
$slected='';
if ($row['shipper_ADDRESS_ID']==$shipper) {
	$slected='selected';
} else {
	$slected='';
}
?>               
<option value="<?php echo $row['shipper_ADDRESS_ID'] ?>" <?php echo $slected ?>><?php echo $row['shipperName'] ?></option>
<?php endforeach; ?>
</select>
			 </p> 
			 </p>
               <p>Transport Mode:<br>
			    <input name="transportmode" type="text" id="transportmode" size="40" maxlength="50" value='<?= $transportmode ?>'>
			    <br>
			  </p>
			  <p>Container Ref:<br>
			    <input name="containerref" type="text" id="containerref" size="40" maxlength="20" value='<?= $containerref ?>' >
			  </p>
			  <p>Terms & Conditions of Delivery Payment:<br />
		      <select name="deliveryterms" id="deliveryterms">
<option value="n">Choose Delivery Terms:  </option>
<?php foreach ($delterms as $row): 
$slected='';
if ($row['deliveryTermsID']==$deliveryterms) {
	$slected='selected';
} else {
	$slected='';
}
?>               
<option value="<?php echo $row['deliveryTermsID'] ?>" <?php echo $slected ?>><?php echo $row['DeliveryTerms']." (".$row['deliverydesc'].")" ?></option>
<?php endforeach; ?>
</select>
<br><textarea name="termstext" cols="40" rows="1" onKeyPress="return taLimit(this)" onKeyUp="return taCount(this,'myCounter')" ><?php echo $termstext ?></textarea><br />&nbsp;<B><SPAN id=myCounter>50</SPAN></B>/50</p>
			 <p>Country of Final Destination:<br>
			    <input name="destport" type="text" id="destport" size="40" maxlength="50" value='<?php echo $destport ?> '>
			  </p>
			  
 <p>Export Collection Status:<br>
<select name="status" id="status">
<option value="n">Status:  </option>
<?php foreach ($collectionstatus as $row): 
$slected='';
if ($row['collectionStatusID']==$status) {
	$slected='selected';
} else {
	$slected='';
}
?>               
<option value="<?php echo $row['collectionStatusID'] ?>" <?php echo $slected ?>><?php echo $row['collectionStatusName'] ?></option>
<?php endforeach; ?>
</select>
			 </p> 
			 
<div id="e2"> <p>Consignee Details:<br>
<select name="consignee" id="consignee">
<option value="n">Choose Consignee:  </option>
<?php foreach ($consignees as $row): 
$slected='';
if ($row['consignee_ADDRESS_ID']==$consignee) {
	$slected='selected';
} else {
	$slected='';
}
?>               
<option value="<?php echo $row['consignee_ADDRESS_ID'] ?>" <?php echo $slected ?>><?php echo $row['consigneeName'] ?></option>
<?php endforeach; ?>
</select>
			 </p> 
</div>
<div id="e3"> <p><a href="/php/consignee" target="_blank"><font color='red'>Add New Consignee</font></a></p></div>

<div class="clear" style="height:1px;"></div>


 <div  id="useconsig" class="clear">
            <?php 
            if ($delivertoconsignee=='y') { 
            $cheked="checked";
            } else  {
            $cheked="";
            }
            ?>
             <p><div class="adjustpara">Use Consignee Address as all delivery addresses on manifest? </div><label class="toggle">
    <input type="checkbox" name="consigneebutton" id="consigneebutton" <?php echo $cheked ?>>
    <span class="slider"></span>
    <span class="labels" data-on="Yes" data-off="No"></span>
  </label></p></div>
  
  
  <p><a href="/php/CommercialManifest.pdf?cid=<?= $collectionID ?>" target="_blank"><font color='red'>View Manifest Document</font></a></p>
			    <p><a href="/php/containerdetails?id=<?= $collectionID ?>" target="_blank"><font color='red'>View Export Collection</font></a></p>
  
</div>
		
        <div id="d2" style="margin-bottom:30px;">
        <h1>&nbsp;</h1>
        <p>Choose which showrooms can use this Collection</p>
        <p>
        <?php foreach ($activeshowrooms as $row): 
        list($etadate, $location)=getETAinfo($this->AuxiliaryData,$row['idlocation'],$collectionID);
        ?> 
         ETA Date: <input name="YY<?php echo $row['idlocation'] ?>" id="YY<?php echo $row['idlocation'] ?>" value="<?= $this->MyForm->mysqlToUsStrDate($etadate) ?>" type="text" size="10" maxlength="10">
            &nbsp; 
            <?php
            $chcked='';
			if ($row['idlocation']==$location) {
				$chcked='checked';
			} else {
				$chcked='';
			}
			?>
            <?php echo $row['adminheading'] ?> <?php 
            if ($chcked=='checked') { ?>
            <script> 
            stopUncheck('#XX<?=$row['idlocation']?>');
            </script> 
            <a href='' id="REMOVE_<?=$row['idlocation']?>_<?=$collectionID?>" class="RMV" data-name="<?=$row['adminheading']?>"><span style="color:red;">| Remove</span></a>
            <?php
             } ?><br />  
       
        <?php endforeach; ?>
        </p>
        <input style="padding-top:20px; padding-bottom:20px;" type="submit" id="botright" name="botright" value="Save Changes" />
        </div>
                

    
    
</form>
</div>

<div id="dialog" title="Remove Collections"></div>

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
	
	$(".RMV").click(function(evt) {
		evt.preventDefault();
		var id = evt.currentTarget.id;
		var arr = id.split('_');
		var idlocation = arr[1];
		var collectionID = arr[2];
		var showroomName = $("#" + evt.currentTarget.id).data("name");
		var url = "/php/EditCollection/remove/?locid=" + idlocation + "&collectionid=" + collectionID;
		
		$.get(url, 
				window.onload = function(data) {
					var resp = JSON.parse(data);
					if (!resp.success) {
						alert('Failed to remove showroom collections');
						return;
					}
					if (resp.data.count == 0) {
					location.reload();
						alert('No collections found for showroom');
						return;
					}
					if (resp.data.count > 0 && !resp.data.items) {
						alert('Collections for showroom removed');
						return;
					}
					var links = [];
					for (let pn in resp.data.items) {
						if (resp.data.items.hasOwnProperty(pn)) {
							var link = "<a href='/orderdetails.asp?pn=" + pn + "'  target='_blank'>" + resp.data.items[pn] + "</a>";
							links.push(link);
						}
					}
					var html = "<div>";
					html += "<p>The following orders are currently set up for " + showroomName + " showroom. These will need to be removed first before you can delete the location from the delivery. Click on the link to go to the order details page. <span style='color:red'>Once removed please refresh this page and you will be able to remove the collection</span></p>";
					html += "<div align='center'>" + links.join("<br/>") + "</div>";
					html += "</div>";
					$("#dialog").html(html);
					$("#dialog").dialog();
				}
		);
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
$(function () {
 $('#consignee').change(function () {
 	var value = $('#consignee').val();
   if (value=='n') {
   //$( "#consigneebutton" ).prop( "checked", false );
   $("#editconsig").hide();
   $("#useconsig").hide();
   } else {
   //$( "#consigneebutton" ).prop( "checked", true );
   $("#editconsig").show();
   $("#useconsig").show();
   }

  });
});

$(document).ready(function() {
	$consignee=$('#consignee').val();
	if ($consignee=='' || $consignee=='n') {
		$("#useconsig").hide();
	}
    $('#consigneebutton').click(function() {
		var chbox=$("input[type=checkbox][name=consigneebutton]:checked").val();
		var consig = $('#consignee').val();
		if (chbox != true ) {
		 //$("#consignee").val("n");
		} 
		if (chbox != true && consig=='n') {
			alert("Please select a consignee first");
			return false;
		}
		
    })
    
});




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
<?php 
function getETAinfo($auxhelper,$idlocation,$collectionID) {

    $sql = "SELECT * FROM `exportcollshowrooms` WHERE exportCollectionID=". $collectionID ." and idLocation=". $idlocation;
    $etadate='';
    $location='';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				$etadate=$rows['ETAdate'];
				$location=$rows['idLocation'];
				//debug($etadate);
				//die;
	    	 endforeach;
    return [$etadate, $location];
} 