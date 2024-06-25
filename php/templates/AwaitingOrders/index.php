<?php use Cake\Routing\Router; ?>
<?php
function acknowDateWarning($row) {
	$warning = false;
	if (!isset($row['acknowdate']) && isset($row['ORDER_DATE'])) {
		$orderDate = DateTime::createFromFormat('Y-m-d G:i:s', $row['ORDER_DATE']);
		$dDiff = $orderDate->diff(new DateTime());
		$warning = ($dDiff->d > 7);
	}
	return $warning;
}
?>


<div id="brochureform" class="brochure" style="background-color:#f3f2f2;">
<p><b>Orders Awaiting Confirmation</b></p>
<p>Total: <?php echo count($awaitingorders); ?></p>
<form action="/php/AwaitingOrders/" method="post" name="form1" id="form1" style='align:right'>
<p><select name="showroom" id="showroom">
<option value="n"> Filter by Showroom:  </option>

<?php foreach ($activeshowrooms as $row): ?> 
<?php $slct = ($row['idlocation'] == $showroom) ? "selected" : "";   ?>              
<option <?= $slct ?> value="<?= $row['idlocation'] ?>"><?= $row['adminheading'] ?></option>
<?php endforeach; ?>
</select>&nbsp;<input type="submit" name="search" value="Filter"  id="search" class="button" onclick="changeFormAction('form1', '/php/AwaitingOrders/');"  />
</p>
</form>
<form action="/php/AwaitingOrders/Confirm" method="post" name="form2" id="form2" style='align:right'>

<input type="submit" id="delnote" name="confirm" id="confirm" value="Submit">  

<table width="100%" border = "0" cellpadding = "6" cellspacing = "2" >
<tbody>
		    <tr>
		      <td width="251" align="left"><b>Customer Name</b><br>
		      <a href="#" onclick="sortby('surname desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('surname asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
<td width="151"><b>Customer Ref.</b><br>
		      <a href="#" onclick="sortby('customerreference desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('customerreference asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
		      <td width="151"><b>Company</b><br>
		      <a href="#" onclick="sortby('company desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('company asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
		      <td width="151"><b>Order No.</b><br>
		      <a href="#" onclick="sortby('ORDER_NUMBER desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('ORDER_NUMBER asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
<?php if (!$this->Security->userHasRoleInList('NOPRICEUSER')) { ?>
<td width="151" align="right"><b>Order Total Price</b></td>
<?php } ?>
<td><b>Order Date</b><br>
		     
</td>
<td><b>Amended Date</b><br>
		     
</td>
		<?php if ($this->Security->userHasRoleInList('ADMINISTRATOR')) { 
           	if ($showshowrooms=='y') { ?>
		      <td width="151"><b>Showroom</b><br>
		      <a href="#" onclick="sortby('adminheading desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('adminheading asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
              </td>
        <?php } 
          }?>
        <?php if ($this->Security->userHasRoleInList('ADMINISTRATOR')) { ?>
			<td width="10">Confirm Multiple Orders<br>
   		<?php } ?>
  </td>
</tr>
<tr>
 <?php if ($this->Security->userHasRoleInList('ADMINISTRATOR')) { 
	if ($showshowrooms=='y') { ?>
		<td colspan='10'>
	<?php 
	} else { ?>
		<td colspan='9'>
	<?php 
	} 
	}?>
	<p style="position:relative; left:-12px; font-size:14px;"><b>Marketing & Floorstock Orders</b></p></td></tr>
<?php foreach ($awaitingordersMktgFloor as $row): ?>
	        <tr style="background-color:white;">
		      <td width="251" align="left"><a href="/edit-purchase.asp?order=<?=$row['PURCHASE_No'] ?>"><?= $row['surname'].', '.$row['title'].' '.$row['first'] ?></a></td>
		    <td width="151" align="left"><?= $row['customerreference'] ?></td>
		      <td width="151" align="left"><?= $row['company'] ?></td>
		      <td width="151" align="left"><?= $row['ORDER_NUMBER'] ?></td>
		      <?php if (!$this->Security->userHasRoleInList('NOPRICEUSER')) { ?>
		     <td width="151" align="right"><?= $this->MyForm->formatMoneyWithSymbol($row['total'], $row['ordercurrency']) ?></td>
		     <?php } ?>
		       <td width="151" align="left"><?php if($row['ORDER_DATE'] !== null) { 
		       echo date("d/m/Y", strtotime(substr($row['ORDER_DATE'],0,10))); 
		        }?></td>
		      <td align="left"><?php if($row['AmendedDate'] !== null) { 
		       echo date("d/m/Y", strtotime(substr($row['AmendedDate'],0,10))); 
		        }?></td>
		    <?php if ($this->Security->userHasRoleInList('ADMINISTRATOR')) { 
		    	 if ($showshowrooms=='y') { ?>
		      <td width="151" align="left"><?= $row['adminheading'] ?></td>
		    <?php } 
		    }?>
			<td width="9">
			<?php if ($marketingmgr=='y') { ?>
				<a href="/php/PrintPDF.pdf?aw=y&val=<?=$row['PURCHASE_No'] ?>" target="_blank" onClick="printConfirm(<?=$row['PURCHASE_No'] ?>); return false;" class="silverbutton">Print Confirmation</a>
			<?php } else { ?>
				Print Confirmation</a>
			<?php } ?></td>
			
				<td width="10"><input name="confirmcode<?=$row['PURCHASE_No'] ?>" id="confirmcode<?=$row['PURCHASE_No'] ?>" type="text">&nbsp;</td>

   		
	        </tr>
<?php endforeach; ?>
<tr>
 <?php if ($this->Security->userHasRoleInList('ADMINISTRATOR')) { 
	if ($showshowrooms=='y') { ?>
		<td colspan='10'>
	<?php 
	} else { ?>
		<td colspan='9'>
	<?php 
	} 
	}?>
	<p style="position:relative; left:-12px; font-size:14px;"><b>All Other Orders</b></p></td></tr>
<?php foreach ($awaitingorders as $row): ?>
	        <tr>
		      <td width="251" align="left"><a href="/edit-purchase.asp?order=<?=$row['PURCHASE_No'] ?>"><?= $row['surname'].', '.$row['title'].' '.$row['first'] ?></a></td>
		    <td width="151" align="left"><?= $row['customerreference'] ?></td>
		      <td width="151" align="left"><?= $row['company'] ?></td>
		      <td width="151" align="left"><?= $row['ORDER_NUMBER'] ?></td>
		      <?php if (!$this->Security->userHasRoleInList('NOPRICEUSER')) { ?>
		     <td width="151" align="right"><?= $this->MyForm->formatMoneyWithSymbol($row['total'], $row['ordercurrency']) ?></td>
		     <?php } ?>
		       <td width="151" align="left"><?php if($row['ORDER_DATE'] !== null) { 
		       echo date("d/m/Y", strtotime(substr($row['ORDER_DATE'],0,10))); 
		        }?></td>
		      <td align="left"><?php if($row['AmendedDate'] !== null) { 
		       echo date("d/m/Y", strtotime(substr($row['AmendedDate'],0,10))); 
		        }?></td>
		    <?php if ($this->Security->userHasRoleInList('ADMINISTRATOR')) { 
		    	 if ($showshowrooms=='y') { ?>
		      <td width="151" align="left"><?= $row['adminheading'] ?></td>
		    <?php } 
		    }?>
			<td width="9"><a href="/php/PrintPDF.pdf?aw=y&val=<?=$row['PURCHASE_No'] ?>" target="_blank" onClick="printConfirm(<?=$row['PURCHASE_No'] ?>); return false;" class="silverbutton">Print Confirmation</a></td>
			
				<td width="10"><input name="confirmcode<?=$row['PURCHASE_No'] ?>" id="confirmcode<?=$row['PURCHASE_No'] ?>" type="text">&nbsp;</td>

   		
	        </tr>
	        <?php endforeach; ?>
	       
</tbody>
</table> 
        
   </form>  
<?php if (count($awaitingorders) > 20) {?>
<p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
<?php }?>
<div class="clear"></div>
<p style="position:relative; left:-12px; font-size:14px;"><b>Showroom to Amend Orders:</b>&nbsp;Total = <?=count($awaitingorderstobeamended) ?></p>

<table width="100%" border = "0" cellpadding = "6" cellspacing = "2" >
<tbody>
<tr>
<td width="251" align="left"><b>Customer Name</b><br>
</td>
<td width="151"><b>Customer Ref.</b><br>
</td>
<td width="151"><b>Company</b><br>
</td>
<td width="151"><b>Order No.</b><br>
</td>
<?php if (!$this->Security->userHasRoleInList('NOPRICEUSER')) { ?>
<td width="151" align="right"><b>Order Total Price</b></td>
<?php } ?>
<td><b>Order Date</b><br>
</td>
<td><b>Amended Date</b><br>
</td>
		<?php if ($this->Security->userHasRoleInList('ADMINISTRATOR')) { 
           	if ($showshowrooms=='y') { ?>
		      <td width="151"><b>Showroom</b><br>
              </td>
        <?php } 
          }?>
  </td>
</tr>

<?php foreach ($awaitingorderstobeamended as $row): ?>
	        <tr>
		      <td width="251" align="left"><a href="/edit-purchase.asp?order=<?=$row['PURCHASE_No'] ?>"><?= $row['surname'].', '.$row['title'].' '.$row['first'] ?></a></td>
		    <td width="151" align="left"><?= $row['customerreference'] ?></td>
		      <td width="151" align="left"><?= $row['company'] ?></td>
		      <td width="151" align="left"><?= $row['ORDER_NUMBER'] ?></td>
		      <?php if (!$this->Security->userHasRoleInList('NOPRICEUSER')) { ?>
		     <td width="151" align="right"><?= $this->MyForm->formatMoneyWithSymbol($row['total'], $row['ordercurrency']) ?></td>
		     <?php } ?>
		       <td width="151" align="left"><?php if($row['ORDER_DATE'] !== null) { 
		       echo date("d/m/Y", strtotime(substr($row['ORDER_DATE'],0,10))); 
		        }?></td>
		      <td align="left"><?php if($row['AmendedDate'] !== null) { 
		       echo date("d/m/Y", strtotime(substr($row['AmendedDate'],0,10))); 
		        }?></td>
		    <?php if ($this->Security->userHasRoleInList('ADMINISTRATOR')) { 
		    	 if ($showshowrooms=='y') { ?>
		      <td width="151" align="left"><?= $row['adminheading'] ?></td>
		    <?php } 
		    }?>

	        </tr>
	        <?php endforeach; ?>
	        
</table>

</div>
<script>
function customReset() {
    $("#monthfrom").val("");
    $("#monthto").val("");
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

function changeFormAction(formId, newAction) {
	$('#' + formId).attr('action', newAction);
}
function sortby(sortVal) {
	window.location.href = "/php/AwaitingOrders?sortorder=" + sortVal;
} 

function printConfirm(pn){
	var url = "/php/AwaitingOrders/createConfirmCode?pn=" + pn + "&ts=" + (new Date()).getTime();
	$.get(url, function(data) {
		
		window.open("/php/PrintPDF.pdf?aw=y&val=" + pn, "_blank");

		<?php if (!$this->Security->userHasRoleInList('ADMINISTRATOR')) { ?>
	confirmDialog(pn);
		<?php } ?>
		
		<?//php if (!$this->Security->userHasRoleInList('ADMINISTRATOR')) { ?>
			$("#confirmcode"+pn).focus();
		<?//php } ?>
	});
}

function confirmDialog(pn) {
  $('<div></div>').appendTo('body')
    .html('<div><h6>Has the order confirmation been printed?</h6></div>')
    .dialog({
      modal: true,
      title: 'Print Confirmation',
      zIndex: 10000,
      autoOpen: true,
      width: 'auto',
      resizable: false,
      buttons: {
        Yes: function() {
        	//printConfirm(pn)
			$(this).dialog("close");
			$("#confirmcode"+pn).focus();
        },
        No: function() {
          $(this).dialog("close");
        }
      },
      close: function(event, ui) {
        $(this).remove();
      }
    });
};

</script>