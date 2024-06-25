<?php use Cake\Routing\Router; ?>


<div id="brochureform" class="brochure">
    
<form action="/php/AdvancedSearch/results" method="post"  name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	

	<div class="content brochure">
		<div class="one-col head-col">
			<p><strong><p>Enter a surname and / or customer reference or an order number below to search the database:</strong>:</p>
			<p>
				  <label for="surname" id="surname"><strong>Surname</strong>
				    <input onChange="resetFilter()" name="surname" type="text" id="surname" value="<?=$surname ?>" class="text" />
			      </label> 
				 &nbsp;&nbsp;&nbsp;
				  <label for="cref" id="cref"><strong>Customer Ref.</strong>
				    <input onChange="resetFilter()" name="cref" type="text" id="cref" value="<?=$cref ?>" class="text" />
			      </label>
		   &nbsp;<strong>Company</strong>&nbsp;
		   <input onChange="resetFilter()" name="company" type="text" id="company" value="<?= $company ?>"" class="text" />
		   &nbsp;
				  <label for="orderno" id="orderno"><strong>Order No.</strong>
				    <input name="orderno" type="text" class="text" id="orderno" onChange="resetFilter()" size="10" />
			      </label>
				  <input name="channel" type="hidden" value="<?= $channel ?>">
				  <input name="contacttype" type="hidden" value="<?= $contacttype ?>">
				  <input name="location" type="hidden" value="<?= $location ?>">
				  <input name="postcode" type="hidden" value="<?= $postcode ?>">
				  <input name="qresults" type="hidden" value="y">
				  <input type="submit" name="submit" value="Search"  id="submit" class="button" />
		    </p>
            <hr /><br />
            <p>Filter by:</p>
            <p><select name="filtertype" id="filtertype">
            <option value="">Choose a filter</option>
              <option value="A">Any Field</option>
              <option value="first">First Name</option>
              <option value="company">Company Name</option>
              <option value="add1">Address 1</option>
              <option value="add2">Address 2</option>
              <option value="add3">Address 3</option>
              <option value="email">Email</option>
              <option value="postcode">Post Code</option>
              <option value="city">City</option>
              <option value="custref">Customer Reference No</option>
              <option value="channel">Channel</option>
              <option value="type">Type of Contact</option>
              <option value="visited">Where Customer Visited</option>
              
            </select>
            &nbsp;&nbsp;&nbsp;<input name="filterkeyword" value="<?= $filterkeyword ?>" type="text" id="filterkeyword">
            &nbsp;&nbsp;&nbsp;<input type="submit" name="submit" value="Filter"  id="submit" class="button" />
            &nbsp;&nbsp;&nbsp;<input type="submit" name="submit" value="Reset Filter"  id="submit" class="button" />
      </p>
        </div>


		
		</div>
	
	<div class="clear"></div>

	      <input type="submit" name="submit" value="Search Database"  id="submit"  />
</form>
<form method="post" id="form2"  name="form2">
<div id="Accordion1" class="Accordion" tabindex="0">
<?php
$currentContactIds =[];
foreach ($liveorders as $row): 
?>

  <div class="AccordionPanel">
  	<a href="javascript:void(0)" class="stickleft" onclick="getPanelContent('<?= $row['CONTACT_NO'] ?>', 'true', '1', '<?= $cref ?>', '<?= $filtertype ?>', '<?= $filterkeyword ?>');" id="plus1-<?= $row['CONTACT_NO'] ?>"><img src="/images/plus.gif" ></a>
  	<a href="javascript:void(0)" class="stickleft" onclick="closePanel('<?= $row['CONTACT_NO'] ?>', '1');" id="minus1-<?= $row['CONTACT_NO'] ?>"><img src="/images/minus.gif" ></a>
    <div class="AccordionPanelTab"><?php
		if ($row['acceptpost']=='n') { 
		 echo "<input type='checkbox' disabled='disabled' name='XX_" .$row['CONTACT_NO']. "' id='XX_" .$row['CONTACT_NO']. "'>";
		} else {
		 echo "<input type='checkbox' name='XX_" .$row['CONTACT_NO']. "' id='XX_" .$row['CONTACT_NO']. "'>";
		}
		echo "<a href='/editcust.asp?val="  .$row['CONTACT_NO']."'>";
		if ($row['surname'] != '') {
			echo $row['surname'].", ";
		} 
		if ($row['title'] != '') {
			echo $row['title']." ";
		} 
		if ($row['first'] != '') {
			echo $row['first'].", ";
		}
		if ($row['company'] != '') {
			echo $row['company'].", ";
		} 
		if ($row['street1'] != '') {
			echo $row['street1'].", ";
		}
		if ($row['street2'] != '') {
			echo $row['street2'].", ";
		}
		if ($row['street3'] != '') {
			echo $row['street3'].", ";
		}
		if ($row['county'] != '') {
			echo $row['county'].", ";
		}  
		if ($row['postcode'] != '') {
			echo $row['postcode'].", ";
		} 
		if ($row['country'] != '') {
			echo $row['country'].", ";
		} 
		echo "</a>";
		if ($row['acceptpost'] == 'n') {
			echo "<font color='red'>NO MARKETING BY POST</font>";
		} 
		if ($row['acceptemail'] == 'n') {
			echo "<font color='red'>NO MARKETING BY EMAIL</font>";
		}
		if ($row['SOURCE_SITE'] == 'SH') {
			echo "<font color='red'><font color='red'>Simon Horn Contact</font></font>";
		}
		echo "<br />";
		?>
        </div><div class="Accordclear"></div>
    <div id="panel1-<?= $row['CONTACT_NO'] ?>" class="AccordionPanelContent"></div>
  
</div><div class="Accordclear"></div>
<?php
array_push($currentContactIds,$row['CONTACT_NO']);
endforeach;
?></div>




<div class=""greybg""><hr /><b>Customers with Completed Orders = </b><br / ><br / ></div>

<div id="Accordion2" class="Accordion" tabindex="0">
<?php
$completedContactIds =[];
foreach ($completedorders as $row): 
?>

  <div class="AccordionPanel">
  	<a href="javascript:void(0)" class="stickleft" onclick="getPanelContent('<?= $row['CONTACT_NO'] ?>', 'false', '2', '<?=$cref?>', '<?=$filtertype?>', '<?=$filterkeyword?>');" id="plus2-<?= $row['CONTACT_NO'] ?>"><img src="/images/plus.gif" ></a>
  	<a href="javascript:void(0)" class="stickleft" onclick="closePanel('<?= $row['CONTACT_NO'] ?>', '2');" id="minus2-<?= $row['CONTACT_NO'] ?>"><img src="/images/minus.gif" ></a>
    <div class="AccordionPanelTab">
		<?php
		if ($row['acceptpost']=='n') { 
		 echo "<input type='checkbox' disabled='disabled' name='XX_" .$row['CONTACT_NO']. "' id='XX_" .$row['CONTACT_NO']. "'>";
		} else {
		 echo "<input type='checkbox' name='XX_" .$row['CONTACT_NO']. "' id='XX_" .$row['CONTACT_NO']. "'>";
		}
		echo "<a href='/editcust.asp?val="  .$row['CONTACT_NO']."'>";
		if ($row['surname'] != '') {
			echo $row['surname'].", ";
		} 
		if ($row['title'] != '') {
			echo $row['title']." ";
		} 
		if ($row['first'] != '') {
			echo $row['first'].", ";
		}
		if ($row['company'] != '') {
			echo $row['company'].", ";
		} 
		if ($row['street1'] != '') {
			echo $row['street1'].", ";
		}
		if ($row['street2'] != '') {
			echo $row['street2'].", ";
		}
		if ($row['street3'] != '') {
			echo $row['street3'].", ";
		}
		if ($row['county'] != '') {
			echo $row['county'].", ";
		}  
		if ($row['postcode'] != '') {
			echo $row['postcode'].", ";
		} 
		if ($row['country'] != '') {
			echo $row['country'].", ";
		} 
		echo "</a>";
		if ($row['acceptpost'] == 'n') {
			echo "<font color='red'>NO MARKETING BY POST</font>";
		} 
		if ($row['acceptemail'] == 'n') {
			echo "<font color='red'>NO MARKETING BY EMAIL</font>";
		}
		if ($row['SOURCE_SITE'] == 'SH') {
			echo "<font color='red'><font color='red'>Simon Horn Contact</font></font>";
		}
		echo "<br />";
		?>
        </div><div class="Accordclear"></div>
    <div id="panel2-<?= $row['CONTACT_NO'] ?>" class="AccordionPanelContent"></div>
  </div><div class="Accordclear"></div><div class="Accordclear"></div>
<?php
array_push($completedContactIds,$row['CONTACT_NO']);
endforeach;
?>
</div>


<?php
//no orders customers (only display so long as no customer ref or filter have been provided)

if ($cref == '' && $filterkeyword == '') {
?>
	<div class=""greybg""><hr /><b>Customers with No Orders = </b><br / ><br / ></div>
	<div id="Accordion3" class="Accordion" tabindex="0">
<?php
foreach ($noorders as $row): 
?>
	  <div class="AccordionPanel">
	    <div class="AccordionPanelTab"><?php
		if ($row['acceptpost']=='n') { 
		 echo "<input type='checkbox' disabled='disabled' name='XX_" .$row['CONTACT_NO']. "' id='XX_" .$row['CONTACT_NO']. "'>";
		} else {
		 echo "<input type='checkbox' name='XX_" .$row['CONTACT_NO']. "' id='XX_" .$row['CONTACT_NO']. "'>";
		}
		echo "<a href='/editcust.asp?val="  .$row['CONTACT_NO']."'>";
		if ($row['surname'] != '') {
			echo $row['surname'].", ";
		} 
		if ($row['title'] != '') {
			echo $row['title']." ";
		} 
		if ($row['first'] != '') {
			echo $row['first'].", ";
		}
		if ($row['company'] != '') {
			echo $row['company'].", ";
		} 
		if ($row['street1'] != '') {
			echo $row['street1'].", ";
		}
		if ($row['street2'] != '') {
			echo $row['street2'].", ";
		}
		if ($row['street3'] != '') {
			echo $row['street3'].", ";
		}
		if ($row['county'] != '') {
			echo $row['county'].", ";
		}  
		if ($row['postcode'] != '') {
			echo $row['postcode'].", ";
		} 
		if ($row['country'] != '') {
			echo $row['country'].", ";
		} 
		echo "</a>";
		if ($row['acceptpost'] == 'n') {
			echo "<font color='red'>NO MARKETING BY POST</font>";
		} 
		if ($row['acceptemail'] == 'n') {
			echo "<font color='red'>NO MARKETING BY EMAIL</font>";
		}
		if ($row['SOURCE_SITE'] == 'SH') {
			echo "<font color='red'><font color='red'>Simon Horn Contact</font></font>";
		}
		echo "<br />";
		?>
	        </div>
	  </div><div class="Accordclear"></div>
	  
<?php
endforeach;
?><?php } ?>

<input name="nobrochurealert" type="hidden" id="nobrochurealert" value="n">
<br />

          <label>Choose letter to print
            <select name="corresid2" id="corresid2">
               <option value="n">None</option>
 <?php foreach ($letter as $row): ?>
                <option value='<?=$row['correspondenceid'] ?>'><?=$row['correspondencename'] ?></option>
				<?php endforeach; ?>
		        </select>
            </label>
          <br>
          <br>
 <input type="submit" name="submit1" id="submit1" value="Print Letters">&nbsp;
    </label>
    <input type="submit" name="submit2" id="submit2" value="Print Labels">&nbsp;
    <input type="submit" name="submit5" id="submit5" value="Print 3 x 7 Labels">&nbsp;
</p>
</form>
<p>&nbsp;</p>
</div>




</div>

<script language="JavaScript">
<!--

function resetFilter() {
		$('#filtertype').val("Any Field");
		$('#filterkeyword').val("");
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
function FrontPage_Form1_Validator(theForm)
{
 
	if (submitIndicator == "Print Letters" && theForm.corresid.value == "n")
  {
    alert("You need to choose a correspondence letter before submitting");
    theForm.corresid.focus();
    return (false);
  }

    return true;
}


function getPanelContent(contactno, current, panelId, cref, filterType, filterVal) {
	var divId = "panel" + panelId + "-" + contactno;
    var url = "/php/advancedsearch/getorderdetails?contactno=" + contactno + "&current=" + current + "&cref=" + encodeURIComponent(cref) + "&filtertype=" + encodeURIComponent(filterType) + "&filterval=" + encodeURIComponent(filterVal) + "&ts=" + (new Date()).getTime();
    //console.log(url);
    $('#' + divId).load(url);
	$('#' + divId).show("slow");
	swapOpenCloseButtons(contactno, panelId, false);
}
function closePanel(contactno, panelId) {
	var divId = "panel" + panelId + "-" + contactno;
	$('#' + divId).hide("slow");
	swapOpenCloseButtons(contactno, panelId, true);
}
function swapOpenCloseButtons(contactno, panelId, close) {
	var openBtnId = "plus" + panelId + "-" + contactno;
	var closeBtnId = "minus" + panelId + "-" + contactno;
	if (close) {
		$('#' + openBtnId).show();
		$('#' + closeBtnId).hide();
	} else {
		$('#' + openBtnId).hide();
		$('#' + closeBtnId).show();
	}
}
$("#submit1" ).click(function() {
   	$("#form2").attr('action', '/php/OutstandingBrochureRequests/print');
});

$("#submit2" ).click(function() {
   	$("#form2").attr('action', '/php/OutstandingBrochureRequests/printlabel1');
});

$("#submit5" ).click(function() {
   	$("#form2").attr('action', '/php/OutstandingBrochureRequests/printlabel3x7');
});

<?php 
foreach ($currentContactIds as $id) { ?>
	swapOpenCloseButtons('<?= $id ?>', '1', true);
<?php
}
?>
<?php 
foreach ($completedContactIds as $id) { ?>
	swapOpenCloseButtons('<?= $id ?>', '2', true);
<?php
}
?>

//-->
</script>  