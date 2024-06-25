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
<p><b>Current Orders</b></p>
<p>Total: <?php echo count($currentorders); ?></p>
<form action="/php/CurrentOrders/" method="post" name="form1" id="form1">
<p><select name="showroom" id="showroom">
<option value="n"> Choose Showroom:  </option>
<?php foreach ($activeshowrooms as $row): ?> 
<?php $slct = ($row['idlocation'] == $showroom) ? "selected" : "";   ?>              
<option <?= $slct ?> value="<?= $row['idlocation'] ?>"><?= $row['adminheading'] ?></option>
<?php endforeach; ?>
</select>&nbsp;<input type="submit" name="search" value="Filter"  id="search" class="button" onclick="changeFormAction('form1', '/php/CurrentOrders/');"  />
<input name="csv" type="submit" class="button" id="csv" value="Produce CSV file"  onclick="changeFormAction('form1', '/php/CurrentOrders/export');">


</p>
</form>
</div>
<table width="100%" border = "0" cellpadding = "6" cellspacing = "2" id="myTable" class="display" >
 <thead>
        <tr>
		      <th width="251" align="left"><b>Customer Name</b><br>
</th>
		      <th width="151"><b>Company</b><br>
</th>
		      <th width="151"><b>Order No.</b><br>
</th>
<th width="151"><b>Customer Ref.</b><br>
</th>
  <th width="151"><b>Delivery Postcode</b><br>
</th>
<th><b>Note Date</b><br>
		     
</th>
<th><b>Order Date</b><br>
		     
</th>
<th><b>Ackgt Date</b><br>
		     
</th>
          <?php if ($showshowrooms=='y') { ?>
		      <th width="151"><b>Showroom</b><br>
              </th>
          <?php } ?>
		       <th width="151" align="right"><b>Order Value</b></th>
		      <th width="151" align="right"><b>Payments Total</b></th>
		      <th width="151" align="right"><b>Balance Outstanding</b></th>
		      <th><b>Production Date</b><br>
</th>
		      <th width="151"><b><b>Booked Delivery Date</b><br>

</th>
<th width="151"><b><b>Ex-works Date</b><br>
</th>
</tr>
</thead>
    <tbody>
	       <?php foreach ($currentorders as $row): ?>
	        <tr>
		      <td width="251" align="left"><a href="/orderdetails.asp?pn=<?=$row['PURCHASE_No'] ?>"><?= $row['surname'].', '.$row['title'].' '.$row['first'] ?></a></td>
		      <td width="151" align="left"><?= $row['company'] ?></td>
		      <td width="151" align="left"><?= $row['ORDER_NUMBER'] ?></td>
		      <td width="151" align="left"><?= $row['customerreference'] ?></td>
		       <td width="151" align="left"><?= $row['deliverypostcode'] ?></td>
		      <td>
		      	<?php if ($row['overduenotecount']>0) { ?> <img src="/img/redflag.jpg" alt="Warning" align="middle" border="0"> <?php } ?>
		      </td>
		      <td align="left"><?php if($row['ORDER_DATE'] !== null) { 
		       echo date("d/m/Y", strtotime(substr($row['ORDER_DATE'],0,10))); 
		        }?></td>
		      <td align="left"><?php if (acknowDateWarning($row)) { ?> <img src="/img/redflag.jpg" alt="Warning" align="middle" border="0"> <?php } ?></td>
		    <?php if ($showshowrooms=='y') { ?>
		      <td width="151" align="left"><?= $row['adminheading'] ?></td>
		    <?php } ?>
		       <td width="151" align="right"><?= $this->MyForm->formatMoneyWithSymbol($row['total'], $row['ordercurrency']) ?></td>
		      <td width="151" align="right"><?= $this->MyForm->formatMoneyWithSymbol($row['paymentstotal'], $row['ordercurrency']) ?></td>
		      <td width="151" align="right"><?= $this->MyForm->formatMoneyWithSymbol($row['balanceoutstanding'], $row['ordercurrency']) ?></td>
		      <td width="151" align="left">
		       <?php if($row['productiondate'] !== null) { 
		       echo date("d/m/Y", strtotime(substr($row['productiondate'],0,10))); 
		        }?>
		     </td>
		      <td width="151" align="left">
		       <?php  
		        if($row['bookeddeliverydate'] !== null) {
		        echo date("d/m/Y", strtotime(substr($row['bookeddeliverydate'],0,10))); 
		     }?>
		     </td>
		     <td>
		     <?php 
if ($row['overseasOrder']=='y') {
	if ($row['lorrycount']>1) {
	  	echo 'Split Shipment Dates';
    } else {
       if (!empty($row['CollectionDate'])) {
         echo date("d/m/Y", strtotime(substr($row['CollectionDate'],0,10)));
       } else {
         echo 'TBA';
       }
    }
} ?> 
		     </td>
	        </tr>
	        <?php endforeach; ?>
	       
</tbody>
</table>            
     

</div>
<script>

$(document).ready( function () {
	$('#myTable').DataTable({
    "paging" : false,
    "columnDefs" : [{"targets":[5, 6, 12, 13], "type":"date-eu"}],
    order: [[2, 'asc']],
});
} );


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
	window.location.href = "/php/CurrentOrders?sortorder=" + sortVal;
} 
</script>