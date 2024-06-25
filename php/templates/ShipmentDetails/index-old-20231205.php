<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure" style="background-color:#ffffff;">
<h1><br>Shipment Details</h1>
<?php 
$addedby=getUsername($this->AuxiliaryData,$addedby);
$updatedbytext='';
if ($updatedby != 0) {
	$updatedbytext=getUsername($this->AuxiliaryData,$updatedby);
	$updatedbytext=" |  Last updated on: ".date("d/m/Y", strtotime($updateddate))." by " .getUsername($this->AuxiliaryData,$updatedby);
}
?>
<p>Created by : <?= $addedby ?><?= $updatedbytext ?></p>

<table width="99%" border = "0" cellpadding = "6" cellspacing = "2" align="center">
<tbody>
<tr>
<td align="left">Country
</td>
 <td align="left">Collection Date
</td>
<td>ETA Date</td>
<td>Shipper</td>
<td>Transport Mode</td>
<td>Container Ref.</td>
<td>Qty. of Orders</td>
<td>Status</td>
<td>Manifest</td>
</tr>
<tr><td colspan="9"><hr></tr>
<?php foreach ($shipmentdetails as $row): 

$sid='';
$sid=$row['shipper_ADDRESS_ID'];
$lid='';
$lid=$row['idLocation'];
?>
<tr>
<td align="left"><?= $row['location'] ?></td>
 <td align="left"><?= date("d/m/Y", strtotime($row['CollectionDate'])) ?>
</td>
<td><?= date("d/m/Y", strtotime($row['ETAdate'])) ?></td>
<td><?= $row['shipperName'] ?></td>
<td><?= $row['TransportMode'] ?></td>
<td><?= $row['ContainerRef'] ?></td>
<td><?= $noOfOrders ?></td>
<td><?= $row['collectionStatusName'] ?></td>
<td><a href="/php/commercialmanifest.pdf?sid=<?= $row['shipper_ADDRESS_ID'] ?>&cid=<?= $row['exportCollectionsID'] ?>&loc=<?= $row['idLocation'] ?>&eta=<?= date("d/m/Y", strtotime($row['ETAdate'])) ?>" target="_blank">Print</a></td>
</tr>
<?php endforeach; ?>
<tr><td colspan="9"><hr></tr>
</tbody>
</table>            
<h1>Order Details</h1>
<table width="99%" border = "0" cellpadding = "6" cellspacing = "1" align="center">
<tbody>
<tr>
 <td valign="bottom"><b>Surname</b></td>
    <td valign="bottom"><b>Order</b></td>
    <td valign="bottom"><b>Invoice No.</b></td>
    <td valign="bottom"><b>Company Name</b></td>
    <td valign="bottom"><b>Customer Ref.</b></td>
    <td valign="bottom"><b>Mat spec</b></td>
    <td valign="bottom"><b>Base Spec</b></td>
    <td valign="bottom"><b>Topper Spec</b></td>
    <td valign="bottom"><b>Headboards Spec</b></td>
    <td valign="bottom"><b>Legs</b></td>
    <td valign="bottom"><b>Leg Colour</b></td>
    <td valign="bottom"><b>Valance</b></td>
    <td valign="bottom"><b>Accessories</b></td>
   
    <td align="right" valign="bottom"><b>Total<br />Export<br />Value</b></td>
  
     <td align="right" valign="bottom"><b>Items</b></td>
      <td valign="bottom" align="right"><b>Commercial Invoice</b></td>
      <td valign="bottom" align="right"><b>Wholesale Invoice No</b></td>
</tr>
<?php 
$grandtotal=0;
foreach ($orders as $row): ?>
<tr>
 <td valign="top"><?= $row['surname'] ?></td>
    <td valign="top"><a href="/orderdetails.asp?pn=<? $row['purchase_no'] ?>"><?= $row['ORDER_NUMBER'] ?></a></td>
    <td valign="top"><?= $row['InvoiceNo'] ?></td>
    <td valign="top"><?= $row['company'] ?></td>
    <td valign="top"><?= $row['customerreference'] ?></td>
    <?php 
    	$mattstatus='';
    	$mattincluded='';
    	$baseincluded='';
    	$topperincluded='';
    	$hbincluded='';
    	$legsincluded='';
    	$legfinish='';
    	$totalitems=0;
    	$exporttotal=0;
    	
		
		$mattstatus='';
		if ($row['mattressrequired']=='y') {
			$mattstatus=getCompinfo($this->AuxiliaryData,$row['purchase_no'],1);
			list($xcollectiondate, $xlocation, $xcid)=getisCompIncluded($this->AuxiliaryData,$cid,$row['purchase_no'],1);
			if ($xcollectiondate != '') {
				if ($xcid!=$cid) {
					$mattincluded="<a href='/php/shipmentdetails?location=".$xlocation."&id=".$xcid."'>".date("d/m/Y", strtotime($xcollectiondate))."</a>";
					$mattstatus='';
				} else {
					$mattincluded=$row['savoirmodel'];
					$totalitems+=1;
					$exporttotal+=$row['mattressprice'];
					if (substr($row['mattresstype'], 0, 3) == 'Zip') {
						$totalitems+=1;
					}
				}
			}
		}
		$basestatus='';
		if ($row['baserequired']=='y') {
			$basestatus=getCompinfo($this->AuxiliaryData,$row['purchase_no'],3); 
			list($xcollectiondate, $xlocation, $xcid)=getisCompIncluded($this->AuxiliaryData,$cid,$row['purchase_no'],3);
			if ($xcollectiondate != '') {
				if ($xcid!=$cid) {
					$baseincluded="<a href='/php/shipmentdetails?location=".$xlocation."&id=".$xcid."'>".date("d/m/Y", strtotime($xcollectiondate))."</a>";
					$basestatus='';
				} else {
					$baseincluded=$row['basesavoirmodel'];
					$totalitems+=1;
					$exporttotal += $row['baseprice']+$row['upholsteryprice']+$row['basedrawersprice']+$row['basetrimprice']+$row['basefabricprice'];
					if (substr($row['basetype'], 0, 3) == 'Eas' || substr($row['basetype'], 0, 3) == 'Nor') {
						$totalitems+=1;
					}
				}
			}
		}
    	$topperstatus='';
		if ($row['topperrequired']=='y') {
			$topperstatus=getCompinfo($this->AuxiliaryData,$row['purchase_no'],5); 
			list($xcollectiondate, $xlocation, $xcid)=getisCompIncluded($this->AuxiliaryData,$cid,$row['purchase_no'],5);
			if ($xcollectiondate != '') {
				if ($xcid!=$cid) {
					$topperincluded="<a href='/php/shipmentdetails?location=".$xlocation."&id=".$xcid."'>".date("d/m/Y", strtotime($xcollectiondate))."</a>";
					$topperstatus='';
				} else {
					$topperincluded=$row['toppertype'];
					$totalitems+=1;
					$exporttotal += $row['topperprice'];
				}
			}
		}
    	$hbstatus='';
    	if ($row['headboardrequired']=='y') {
			$hbstatus=getCompinfo($this->AuxiliaryData,$row['purchase_no'],8);
			list($xcollectiondate, $xlocation, $xcid)=getisCompIncluded($this->AuxiliaryData,$cid,$row['purchase_no'],8);
			if ($xcollectiondate != '') {
				if ($xcid!=$cid) {
					$hbincluded="<a href='/php/shipmentdetails?location=".$xlocation."&id=".$xcid."'>".date("d/m/Y", strtotime($xcollectiondate))."</a>";
					$hbstatus='';
				} else {
						$hbincluded=$row['headboardstyle'];
						$totalitems+=1;
						$exporttotal += $row['headboardprice'] + $row['hbfabricprice'] + $row['headboardtrimprice'];
				}
			}
			
		}
    	$legstatus='';
    	if ($row['legsrequired']=='y') {
			$legstatus=getCompinfo($this->AuxiliaryData,$row['purchase_no'],7);
			list($xcollectiondate, $xlocation, $xcid)=getisCompIncluded($this->AuxiliaryData,$cid,$row['purchase_no'],7);
			if ($xcollectiondate != '') {
				if ($xcid!=$cid) {
					$legsincluded="<a href='/php/shipmentdetails?location=".$xlocation."&id=".$xcid."'>".date("d/m/Y", strtotime($xcollectiondate))."</a>";
					$legfinish=$legsincluded;
					$legstatus='';
				} else {
					$legsincluded=$row['legstyle'];
					$legfinish=$row['legfinish'];
					$totalitems+=1;
					$exporttotal += $row['legprice'];
				}
			}
			
		}
    ?>
    <td valign="top"><span style="color:<?=$mattstatus?>;"><?= $mattincluded ?></span></td>
    <td valign="top"><span style="color:<?=$basestatus?>;"><?= $baseincluded ?></span></td>
    <td valign="top"><span style="color:<?=$topperstatus?>;"><?= $topperincluded ?></span></td>
    <td valign="top"><span style="color:<?=$hbstatus?>;"><?= $hbincluded ?></span></td>
    <td valign="top"><span style="color:<?=$legstatus?>;"><?= $legsincluded ?></span></td>
    <td valign="top"><span style="color:<?=$legstatus?>;"><?= $legfinish ?></span></td>
    <?php 
    $valancerequired='';
    $accreq='';
    
    if ($row['valancerequired']=='y') {
		list($xcollectiondate, $xlocation, $xcid)=getisCompIncluded($this->AuxiliaryData,$cid,$row['purchase_no'],6);
			if ($xcollectiondate != '') {
				if ($xcid!=$cid) {
					$valancerequired="<a href='/php/shipmentdetails?location=".$xlocation."&id=".$xcid."'>".date("d/m/Y", strtotime($xcollectiondate))."</a>";
				} else {
					$valancerequired="y";
					$totalitems+=1;
					$exporttotal += $row['valanceprice'];
				}
			}
		}
		
	if ($row['accessoriesrequired']=='y') {
		list($xcollectiondate, $xlocation, $xcid)=getisCompIncluded($this->AuxiliaryData,$cid,$row['purchase_no'],9);
			if ($xcollectiondate != '') {
				if ($xcid!=$cid) {
					$accreq="<a href='/php/shipmentdetails?location=".$xlocation."&id=".$xcid."'>".date("d/m/Y", strtotime($xcollectiondate))."</a>";
				} else {
					$accreq="y";
					$totalitems+=1;
					$exporttotal += $row['accessoriestotalcost'];
				}
			}
		}
    	
   $grandtotal+=$exporttotal;
    
    ?>
    <td valign="top"><?= $valancerequired ?></td>
    <td valign="top"><?= $accreq ?></td>
    <td align="right" valign="top"><?php echo $this->MyForm->formatMoneyWithSymbol($exporttotal , $row['ordercurrency']) ?></td>
  
     <td align="right" valign="top"><?= $totalitems ?></td>
      <td valign="top" align="right"><a href="/php/CommercialInvoice.pdf?wholesale=n&sid=<?= $sid ?>&items=<?= $totalitems ?>&loc=<?= $lid ?>&cid=<?= $cid ?>&pno=<?= $row['purchase_no'] ?>">Retail</a>|<a href="/php/CommercialInvoice.pdf?wholesale=y&sid=<?= $sid ?>&items=<?= $totalitems ?>&loc=<?= $lid ?>&cid=<?= $cid ?>&pno=<?= $row['purchase_no'] ?>">Wholesale</a></td>
      <td  valign="top" align="right">
      <?php
      echo getWholesaleNo($this->AuxiliaryData,$row['purchase_no']);
     ?></td>
</tr>
<tr><td colspan='13'></td><td></td><td colspan='3'></td></tr>
<?php endforeach; ?>
<tr><td colspan='13'></td><td align='right'><hr><br><?= $this->MyForm->formatMoneyWithSymbol($grandtotal , $row['ordercurrency']) ?></td><td colspan='3'></td></tr>
<tr>
<td colspan="16"><hr>        
        &nbsp;&nbsp;Key<br>        <img src="/images/colour-key.gif" width="229" height="151" alt=""></td>
</tr>
</tbody>
</table>            
  

</div>

<?php 
function getCompinfo($auxhelper,$pn,$compid) {

    $sql = "select Q.QC_StatusID from qc_history_latest Q where Purchase_No=".$pn." and ComponentID=".$compid." order by qc_date desc";
    $compstatus=0;
    $colour='';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				$compstatus=$rows['QC_StatusID'];
				//debug($etadate);
				//die;
	    	 endforeach;
	if ($compstatus==20) {
		$colour="red";
	} elseif ($compstatus==30) {
		$colour="orange";
	} elseif ($compstatus==40 ||$compstatus==50 || $compstatus==60) {
		$colour="green";
	}
	 elseif ($compstatus==70) {
		$colour="grey";
	}
	//debug($colour);
    //die;
    return $colour;
   
} 


function getisCompIncluded($auxhelper,$cid,$pn,$compid) {

    $sql = "select * from exportlinks L, exportcollshowrooms S, exportcollections E where  S.exportCollectionID=E.exportCollectionsID and L.LinksCollectionID=S.exportCollshowroomsID and purchase_no=".$pn." and componentid=".$compid;
    $xlocation='';
    $xcollectiondate='';
    $xcid='';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				$xcollectiondate=$rows['CollectionDate'];
				$xlocation=$rows['idLocation'];
				$xcid=$rows['exportCollectionID'];
	    	 endforeach;
	
	//debug($etadate);
    //die;

    return [$xcollectiondate, $xlocation, $xcid];
   
} 
function getWholesaleNo($auxhelper,$pn) {

    $sql = "Select * from wholesale_invoices where purchase_no=".$pn;
    $wholesaleno='<font color="red">Missing</font>';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				$wholesaleno=$rows['wholesale_inv_no'];
	    	 endforeach;
	
	//debug($etadate);
    //die;

    return $wholesaleno;
   
} 

function getUsername($auxhelper,$userid) {

    $sql = "Select * from savoir_user where user_id=".$userid;
    $useradded='';
	$rs = $auxhelper->getDataArray($sql,[]);
			 foreach ($rs as $rows):
				$useradded=$rows['username'];
	    	 endforeach;
	

    return $useradded;
   
} 



?>


<script>
function changeFormAction(formId, newAction) {
	$('#' + formId).attr('action', newAction);
}
function sortby(sortVal) {
	window.location.href = "/php/PlannedExports?sortorder=" + sortVal;
} 
</script>







