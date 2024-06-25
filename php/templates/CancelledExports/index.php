<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure" style="background-color:#f3f2f2;">
<p align="right">
<?php if ($CurrentUserLocationId==1 || $CurrentUserLocationId==27) { ?>
<a href="/add-collection.asp">ADD NEW COLLECTION</a><br />
<?php } ?>
    <a href="/php/SalesAdmin">SALES ADMIN</a></p>
<p><b>Cancelled Shipments</b></p>


<table width="99%" border = "0" cellpadding = "6" cellspacing = "2" align="center">
<tbody>
		    <tr>
		      <td align="left">Showrooms<br>
</td>
 <td align="left">Collection Date<br>
  <a href="#" onclick="sortby('collectionDate desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('collectionDate asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a> 
 <br>
</td>
<td>ETA Date</td>
<td>Shipper</td>
<td>Transport Mode</td>
<td>Container Ref.</td>
<td>Qty. of Orders</td>
<td>Items</td>
<td>Status</td>
</tr>
<?php foreach ($cancelledExports as $row): ?>
	 <tr>
	 <td>
		<?php if ($CurrentUserLocationId==1 || $CurrentUserLocationId==27) {
			$sql="select L.adminheading from exportCollShowrooms E, location L where exportCollectionID=" .$row["exportCollectionsID"] ." and E.idLocation=L.idlocation";
		} else {
			$sql="select L.adminheading from exportCollShowrooms E, location L where exportCollectionID=" .$row["exportCollectionsID"] ." and E.idLocation=L.idlocation and E.idlocation=" .$CurrentUserLocationId;
		}
		$rs = $this->AuxiliaryData->getDataArray($sql,[]);  
			 foreach ($rs as $rows):
				echo $rows['adminheading'] ."<br>";
	    	 endforeach; ?>
	 
	 </td>
	 <td><?php echo date("d/m/Y", strtotime(substr($row['CollectionDate'],0,10))) ?></td>
	 <td><?php if ($CurrentUserLocationId==1 || $CurrentUserLocationId==27) {
			$sql="select E.ETAdate from exportCollShowrooms E, location L where exportCollectionID=" .$row["exportCollectionsID"] ." and E.idLocation=L.idlocation";
		} else {
			$sql="select E.ETAdate from exportCollShowrooms E, location L where exportCollectionID=" .$row["exportCollectionsID"] ." and E.idLocation=L.idlocation and E.idlocation=" .$CurrentUserLocationId;
		}
		 $rs = $this->AuxiliaryData->getDataArray($sql,[]);
			 foreach ($rs as $rows):
			 	if (isset($rows['ETAdate'])) {
					echo date("d/m/Y", strtotime(substr($rows['ETAdate'],0,10))) ."<br>";
				}
	    	 endforeach; ?></td>
	 <td><?php echo $row['shipperName'] ?></td>
	 <td><?php echo $row['TransportMode'] ?></td>
	 <td><?php echo $row['ContainerRef'] ?></td>
	 <td><?php if ($CurrentUserLocationId==1 || $CurrentUserLocationId==27) {
			$sql="SELECT count(distinct (E.purchase_no)) as n, exportCollectionID, S.idLocation as x, L.adminheading as y from exportlinks E, exportCollShowrooms S, location L  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" .$row["exportCollectionsID"] ." AND orderConfirmed='y' and S.idLocation=L.idlocation group by S.idlocation";
		} else {
			$sql="SELECT count(distinct (E.purchase_no)) as n, exportCollectionID, S.idLocation as x, L.adminheading as y from exportlinks E, exportCollShowrooms S, location L , purchase P where E.LinksCollectionID=S.exportCollshowroomsID and P.PURCHASE_No=E.purchase_no and P.idlocation=" .$CurrentUserLocationId ." and S.exportCollectionID=" .$row["exportCollectionsID"] ." AND orderConfirmed='y' and S.idLocation=L.idlocation group by S.idlocation";
		}
	$rs = $this->AuxiliaryData->getDataArray($sql,[]);
	$nrows=0;
	foreach ($rs as $rows):
		echo "<a href='/shipment-details.asp?location=". $rows["x"] ."&id=" .$row["exportCollectionsID"] ."'>". $rows['n'] ." (". $rows['y'] .")</a><br />";
		$nrows=$nrows+1;
	endforeach; 
	if ($nrows==0) {
	 echo "0";
	}
	?>
	 </td>
	 <td>
	 
	 
	 <?php $sql="SELECT count(E.purchase_no) as n, exportCollectionID, S.idLocation, L.adminheading from exportlinks E, exportCollShowrooms S, location L  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" .$row["exportCollectionsID"] ." AND E.orderConfirmed='y' and S.idLocation=L.idlocation group by idlocation";
		$rs = $this->AuxiliaryData->getDataArray($sql,[]);  
			 foreach ($rs as $rows):
				echo $rows['n'] ."<br>";
	    	 endforeach; ?>
	 
	 </td>
	 <td>Cancelled</td>
	 </tr>
	 <tr><td colspan=9><hr></td></tr>
<?php endforeach; ?>
</tbody>
</table>            
     

</div>
<script>
function changeFormAction(formId, newAction) {
	$('#' + formId).attr('action', newAction);
}
function sortby(sortVal) {
	window.location.href = "/php/CancelledExports?sortorder=" + sortVal;
} 
</script>
