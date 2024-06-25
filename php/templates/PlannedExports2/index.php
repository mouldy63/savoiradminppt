<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure" style="background-color:#f3f2f2;">
<p align="right">
<?php if ($CurrentUserLocationId==1 || $CurrentUserLocationId==27) { ?>
<a href="/php/addcollection">ADD NEW COLLECTION</a><br />
<?php } ?>
    <a href="/php/SalesAdmin">SALES ADMIN</a></p>
<p><b>Planned Export Collections</b></p>


<table width="99%" border = "0" cellpadding = "6" cellspacing = "2" align="center">
<tbody>
		    <tr>
		      <td align="left">Showrooms<br>
		       <a href="#" onclick="sortby('firstshowroom desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('firstshowroom asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a> 
</td>
 <td align="left">Collection Date<br>
  <a href="#" onclick="sortby('collectionDate desc');"><img src="/img/desc.gif" alt="Descending" width="30" height="26" align="middle" border="0"></a>
			  <a href="#" onclick="sortby('collectionDate asc'); "><img src="/img/asc.gif" alt="Ascending" width="30" height="26" align="middle" border"0"></a> 
 <br>
</td>
<td>ETA Date</td>
<td>Shipper</td>
<td>Terms of Delivery</td>
<td>Transport Mode</td>
<td>Destination Port</td>
<td>Container Ref.</td>
<td>Qty. of Orders</td>
<td>Items</td>
<td>Status</td>
<?php if ($CurrentUserLocationId==1 || $CurrentUserLocationId==27) { ?>
<td>Action</td>
<?php } ?>
</tr>
<?php foreach ($plannedExports as $row): ?>
	 <tr>
	 <td>
	 
	 
		<?php if ($CurrentUserLocationId==1 || $CurrentUserLocationId==27) {
			$sql="select * from exportCollShowrooms E, location L where exportCollectionID=" .$row["exportCollectionsID"] ." and E.idLocation=L.idlocation";
		} else if ($CurrentUserLocationId==21) {
			$sql="select * from exportCollShowrooms E, location L where exportCollectionID=" .$row["exportCollectionsID"] ." and E.idLocation=L.idlocation and (E.idLocation=". $CurrentUserLocationId . " or E.idLocation=30) order by L.idlocation";	
		} else if ($this->Security->userHasRoleInList('REGIONAL_ADMINISTRATOR')) {
			$sql="select * from exportCollShowrooms E, location L where exportCollectionID=" .$row["exportCollectionsID"] ." and E.idLocation=L.idlocation and L.owning_region=". $CurrentUserRegionId ." order by L.idlocation";
		} else {
			$sql="select * from exportCollShowrooms E, location L where exportCollectionID=" .$row["exportCollectionsID"] ." and E.idLocation=L.idlocation and E.idlocation=" .$CurrentUserLocationId;
		}
		$showrooms = array();
		$rs = $this->AuxiliaryData->getDataArray($sql,[]);  
			 foreach ($rs as $rows):
				echo $rows['adminheading'] ."<br>";
				//debug($rows);
				array_push($showrooms, $rows['exportCollshowroomsID']);
	    	 endforeach; 
	    	 //debug($showrooms);
	    	 //die;
	    	 ?>
	 
	 </td>
	 <td valign='top'>
	 <?php if ($CurrentUserLocationId==1 || $CurrentUserLocationId==27) { ?>
	 <a href="/php/containerdetails?id=<?=$row["exportCollectionsID"]?>"><?php echo date("d/m/Y", strtotime(substr($row['CollectionDate'],0,10))) ?></a>
	 <?php } else { ?>
	 <?php echo date("d/m/Y", strtotime(substr($row['CollectionDate'],0,10))) ?>
	 <?php } ?>
	 </td>
	 <td valign='top'>
	 
	 <?php if ($CurrentUserLocationId==1 || $CurrentUserLocationId==27) {
			$sql="select E.ETAdate from exportCollShowrooms E, location L where exportCollectionID=" .$row["exportCollectionsID"] ." and E.idLocation=L.idlocation";
		} else if ($CurrentUserLocationId==21) {
			$sql="select * from exportCollShowrooms E, location L where exportCollectionID=" .$row["exportCollectionsID"] ." and E.idLocation=L.idlocation and (E.idLocation=". $CurrentUserLocationId . " or E.idLocation=30)";
		}else if ($this->Security->userHasRoleInList('REGIONAL_ADMINISTRATOR')) {
			$sql="select * from exportCollShowrooms E, location L where exportCollectionID=" .$row["exportCollectionsID"] ." and E.idLocation=L.idlocation and L.owning_region=". $CurrentUserRegionId;
		} else {
			$sql="select E.ETAdate from exportCollShowrooms E, location L where exportCollectionID=" .$row["exportCollectionsID"] ." and E.idLocation=L.idlocation and E.idlocation=" .$CurrentUserLocationId;
		}
		  	
		 $rs = $this->AuxiliaryData->getDataArray($sql,[]);
			 foreach ($rs as $rows):
			 	if (isset($rows['ETAdate'])) {
			 		echo date("d/m/Y", strtotime(substr($rows['ETAdate'],0,10))) ."<br>";
			 	} else {
			 		echo '';
			 	}
	    	 endforeach; ?></td>
	 <td valign='top'><?php echo $row['shipperName'] ?></td>	
	 <td valign='top'>
	 <?php
	   $deliveryterms='';
	   if ($row['ExportDeliveryTerms'] > 0) {
			$sql="select * from deliveryterms where deliveryTermsID=" .$row["ExportDeliveryTerms"];
		
			$rs = $this->AuxiliaryData->getDataArray($sql,[]);  
			 foreach ($rs as $rowx){
				$deliveryterms=$rowx['DeliveryTerms'] .'<br>';
	    	 } 
	    	 } ?>
	 <?php echo $deliveryterms ?>
	 <?php echo $row['termstext'] ?></td>
	 <td valign='top'><?php echo $row['TransportMode'] ?></td>
	 <td valign='top'><?php echo $row['DestinationPort'] ?></td>
	 <td valign='top'><?php echo $row['ContainerRef'] ?></td>
	 
	 
	 <td valign='top'>
	 
	 <?php
	 $pnarray = array();
		  	
	 if ($CurrentUserLocationId==1 || $CurrentUserLocationId==27) {
			$sql="SELECT distinct E.purchase_no from exportlinks E, exportCollShowrooms S  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" .$row["exportCollectionsID"] ." AND orderConfirmed='y'";
		}  
		else if ($CurrentUserLocationId==21) {
			$sql="SELECT distinct E.purchase_no from exportlinks E, exportCollShowrooms S, purchase P  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" .$row["exportCollectionsID"] ." AND P.PURCHASE_NO=E.purchase_no and (P.idlocation=" .$CurrentUserLocationId ." or P.idlocation=30) and orderConfirmed='y'";
		}	
		else if ($this->Security->userHasRoleInList('REGIONAL_ADMINISTRATOR')) {
			$sql="SELECT distinct E.purchase_no from exportlinks E, exportCollShowrooms S, Location L, purchase P  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" .$row["exportCollectionsID"] ." AND P.PURCHASE_NO=E.purchase_no and S.idLocation=L.idlocation and L.OWNING_REGION=" .$CurrentUserRegionId ." and orderConfirmed='y'";
		} else {
			$sql="SELECT distinct E.purchase_no from exportlinks E, exportCollShowrooms S, purchase P  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" .$row["exportCollectionsID"] ." AND P.PURCHASE_NO=E.purchase_no and P.idlocation=" .$CurrentUserLocationId ." and orderConfirmed='y'";
		}
		$rs = $this->AuxiliaryData->getDataArray($sql,[]);
		$pnrows=0;
		foreach ($rs as $rows):
		array_push($pnarray, $rows['purchase_no']);
		$pnrows=$pnrows+1;
	endforeach; 
		 
	 foreach ($showrooms as $showroom):

	  if ($CurrentUserLocationId==1 || $CurrentUserLocationId==27) {
			$sql="SELECT count(distinct (E.purchase_no)) as n, E.purchase_no, exportCollectionID, S.idLocation as x, L.adminheading as y from exportlinks E, exportCollShowrooms S, location L  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" .$row["exportCollectionsID"] ." AND orderConfirmed='y' and S.idLocation=L.idlocation and S.exportCollshowroomsID=" .$showroom ." group by S.idLocation";
		} else if ($CurrentUserLocationId==21) {
			$sql="SELECT count(distinct (E.purchase_no)) as n, E.purchase_no, exportCollectionID, S.idLocation as x, L.adminheading as y from exportlinks E, exportCollShowrooms S, location L , purchase P where E.LinksCollectionID=S.exportCollshowroomsID and P.PURCHASE_No=E.purchase_no and (P.idlocation=" .$CurrentUserLocationId ." or P.idlocation=30) and S.exportCollectionID=" .$row["exportCollectionsID"] ." AND orderConfirmed='y' and S.idLocation=L.idlocation and S.exportCollshowroomsID=" .$showroom ." group by S.idLocation";
		}
		 else if ($this->Security->userHasRoleInList('REGIONAL_ADMINISTRATOR')) {
			$sql="SELECT count(distinct (E.purchase_no)) as n, E.purchase_no, exportCollectionID, S.idLocation as x, L.adminheading as y from exportlinks E, exportCollShowrooms S, location L , purchase P where E.LinksCollectionID=S.exportCollshowroomsID and P.PURCHASE_No=E.purchase_no and L.OWNING_REGION=" .$CurrentUserRegionId ." and S.exportCollectionID=" .$row["exportCollectionsID"] ." AND orderConfirmed='y' and S.idLocation=L.idlocation and S.exportCollshowroomsID=" .$showroom ." group by S.idLocation";
		} else {
			$sql="SELECT count(distinct (E.purchase_no)) as n, E.purchase_no, exportCollectionID, S.idLocation as x, L.adminheading as y from exportlinks E, exportCollShowrooms S, location L , purchase P where E.LinksCollectionID=S.exportCollshowroomsID and P.PURCHASE_No=E.purchase_no and P.idlocation=" .$CurrentUserLocationId ." and S.exportCollectionID=" .$row["exportCollectionsID"] ." AND orderConfirmed='y' and S.idLocation=L.idlocation and S.exportCollshowroomsID=" .$showroom ." group by S.idLocation";
		}

		//debug($sql);
		//die();

	    	 		  	
	$rs = $this->AuxiliaryData->getDataArray($sql,[]);
	$nrows=0;
	
	foreach ($rs as $rows):
		echo "<a href='/php/shipmentdetails?location=". $rows["x"] ."&id=" .$row["exportCollectionsID"] ."'><br> ". $rows['n'] ." (". $rows['y'] .")</a></font><br /><br />";
		//array_push($pnarray, $rows['purchase_no']);
		$nrows=$nrows+1;
	endforeach; 
	if ($nrows==0) {
	 echo "0";
	}
	
endforeach; 
	
?>
</td>
<td valign='top'>
	 
	 
	 <?php 
foreach ($showrooms as $showroom):
$itemcount=0;
	foreach ($pnarray as $pno):
	 $sql="SELECT * from exportLinks L, exportcollshowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" .$row["exportCollectionsID"] ." and purchase_no=" . $pno ." and s.exportCollshowroomsID=" . $showroom . "";
	 //debug($sql); 
		$rs = $this->AuxiliaryData->getDataArray($sql,[]); 
		$itemcount = $itemcount+sizeof($rs);	
		$weight=0;
		$mattressinc='n';
		$baseinc='n';
		$topperinc='n';
		$valanceinc='n';
		$legsinc='n';
		$hbinc='n';
		$accinc='n';
			
			 foreach ($rs as $rows):
			 	if ($rows['componentID']==1) {
			 		$sql="Select mattresstype from purchase where purchase_no=".$pno;
			 		$rs = $this->AuxiliaryData->getDataArray($sql,[]); 
			 			foreach ($rs as $rs2):
			 			if (substr($rs2['mattresstype'], 0, 3)=='Zip') {
			 			$itemcount=$itemcount+1;
			 			}
			 			endforeach; 
			 	}
			 	if ($rows['componentID']==3) {
			 		$sql="Select basetype from purchase where purchase_no=".$pno;
			 		$rs = $this->AuxiliaryData->getDataArray($sql,[]); 
			 			foreach ($rs as $rs3):
			 			if (substr($rs3['basetype'], 0, 3)=='Eas' || substr($rs3['basetype'], 0, 3)=='Nor') {
			 			$itemcount=$itemcount+1;
			 			}
			 			endforeach; 
			 	}
			 	if ($rows['componentID']==1) {
			 		$mattressinc='y';
			 	}
			 	if ($rows['componentID']==3) {
			 		$baseinc='y';
			 	}
			 	if ($rows['componentID']==5) {
			 		$topperinc='y';
			 	}
			 	if ($rows['componentID']==6) {
			 		$valanceinc='y';
			 	}
			 	if ($rows['componentID']==7) {
			 		$legsinc='y';
			 	}
			 	if ($rows['componentID']==8) {
			 		$hbinc='y';
			 	}
			 	if ($rows['componentID']==9) {
			 		$accinc='y';
			 	}
				
	    	 endforeach; 
	    endforeach; 
	    echo $itemcount ."<br>";
endforeach; 
	?>
	 
	 </td>
	 <td><?php echo $row["collectionStatusName"] ?></td>
	 <?php if ($CurrentUserLocationId==1 || $CurrentUserLocationId==27) { ?>
	 <td><a href="/php/editcollection?collectionid=<?php echo $row["exportCollectionsID"] ?>">Edit</a></td><?php } ?>

	 </tr>
	 <tr><td colspan=9>
	 <? 
	 $username='';
	 $updatedby='';
	 $updateddate='';
	 $sql="select username from savoir_user where user_id=" .$row["AddedBy"];
	 
	 $rs = $this->AuxiliaryData->getDataArray($sql,[]);
			 foreach ($rs as $rows):
			 	if (isset($rows['username'])) {
			 		$username=$rows['username'];
			 	}
	    	 endforeach;
	    	 
	 if (isset($row["UpdatedBy"])) {
		 $sql="select * from savoir_user where user_id=" .$row["UpdatedBy"];
		 $rs = $this->AuxiliaryData->getDataArray($sql,[]);
		 
			 foreach ($rs as $rows):
			 	if (isset($rows['username'])) {
			 		$updatedby=$rows['username'];
			 	}
	    	 endforeach;
	    }
	    	  ?>
	    	 Collection created by: <?= $username ?>
	    	 <? if ($updatedby != '') {
	    	 	if (isset($row['UpdatedDate'])) {
	    	 		$updateddate=date("d/m/Y", strtotime(substr($row['UpdatedDate'],0,10)));
	    	 	}
	    	 	echo ' | Last updated on: '.$updateddate.' by '.$updatedby;
	    	 } ?>
	 <br>
	 <?php
	 echo "Total Gross Weight: " .$weights[$row["exportCollectionsID"]]."kg | Cubic (M3): " .$this->Number->precision($volumes[$row["exportCollectionsID"]],2);
	 ?>
	 
	 <hr></td></tr>
<?php endforeach; ?>
</tbody>
</table>            
     

</div>
<script>
function changeFormAction(formId, newAction) {
	$('#' + formId).attr('action', newAction);
}
function sortby(sortVal) {
	window.location.href = "/php/PlannedExports?sortorder=" + sortVal;
} 
</script>
