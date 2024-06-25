<?php use Cake\Routing\Router; ?>
<?php
function acknowDateWarning($row) {
	$warning = false;
	if (!isset($row['acknowdate']) && isset($row['ORDER_DATE'])) {
		$orderDate = DateTime::createFromFormat('Y-m-d G:i:s', $row['ORDER_DATE']);
		$now = new DateTime('now');
		$diff = ($now->getTimestamp() - $orderDate->getTimestamp()) / (60 * 60 * 24);
		$warning = ($diff > 7);
	}
	return $warning;
}
?>

<div id="brochureform" class="brochure" style="background-color:#f3f2f2;">
<p><b>Production Orders</b></p>
<p>Total: <?php echo count($ordersinproduction); ?></p>
<table width="100%" border = "0" cellpadding = "6" cellspacing = "2" >
<tbody>
		    <tr>
		      <td width="251" align="left"><b>Customer Name</b><br>
		      <a href="#" onclick="sortby('surname desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('surname asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
		      <td width="151"><b>Company</b><br>
		      <a href="#" onclick="sortby('company desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('company asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
		      <td width="151"><b>Order No.</b><br>
		      <a href="#" onclick="sortby('ORDER_NUMBER desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('ORDER_NUMBER asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
<td><b>Note Date</b><br>
		     
</td>
<td><b>Order Date</b><br>
		     
</td>
<td><b>Ackgt Date</b><br>
		     
</td>
		      <td width="151"><b>Showroom</b><br>
		      <a href="#" onclick="sortby('adminheading desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('adminheading asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
		       <td width="151" align="right"><b>Order Value</b></td>
		      <td width="151" align="right"><b>Payments Total</b></td>
		      <td width="151" align="right"><b>Balance Outstanding</b></td>
		      <td><b>Production Date</b><br>
		      <a href="#" onclick="sortby('production_completion_date desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('production_completion_date asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>
</td>
		      <td width="151"><b><b>Booked Delivery Date</b><br>
		      <a href="#" onclick="sortby('bookeddeliverydate desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('bookeddeliverydate asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a>

</td>
	        </tr>
	       <?php foreach ($ordersinproduction as $row): ?>
	        <tr>
		      <td width="251" align="left"><a href="/orderdetails.asp?pn=<?=$row['PURCHASE_No'] ?>"><?= $row['surname'].', '.$row['title'].' '.$row['first'] ?></a></td>
		      <td width="151" align="left"><?= $row['company'] ?></td>
		      <td width="151" align="left"><?= $row['ORDER_NUMBER'] ?></td>
		      <td>
		      	<?php if ($this->OrderFuncs->orderHasOverdueNote($row['PURCHASE_No'])) { ?> <img src="/img/redflag.jpg" alt="Warning" align="middle" border="0"> <?php } ?>
		      </td>
		      <td align="left"><?php if($row['ORDER_DATE'] !== null) { 
		       echo date("d/m/Y", strtotime(substr($row['ORDER_DATE'],0,10))); 
		        }?></td>
		      <td align="left"><?php if (acknowDateWarning($row)) { ?> <img src="/img/redflag.jpg" alt="Warning" align="middle" border="0"> <?php } ?></td>
		    
		      <td width="151" align="left"><?= $row['adminheading'] ?></td>
		       <td width="151" align="right"><?= $row['total'] ?></td>
		      <td width="151" align="right"><?= $row['paymentstotal'] ?></td>
		      <td width="151" align="right"><?= $row['balanceoutstanding'] ?></td>
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
	        </tr>
	        <?php endforeach; ?>
	       
</tbody>
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
	window.location.href = "/php/ordersinproduction?sortorder=" + sortVal;
} 
</script>