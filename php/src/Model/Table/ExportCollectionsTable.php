<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class ExportCollectionsTable extends Table {
    //public $name = 'CustomerService';

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('exportcollections');
        $this->setPrimaryKey('exportCollectionsID');
        //$this->belongsTo('location')->setForeignKey('idLocation')->setJoinType('LEFT')->setBindingKey('idlocation');
        //$this->belongsTo('location')->setForeignKey('collectionLocation')->setJoinType('LEFT')->setBindingKey('idlocation');
        //$this->belongsTo('SavoirUser')->setForeignKey('AddedBy')->setJoinType('LEFT')->setBindingKey('user_id');
        //$this->belongsTo('collectionStatus')->setForeignKey('collectionStatus')->setJoinType('LEFT')->setBindingKey('collectionStatusID');
        //$this->belongsTo('ShipperAddress')->setForeignKey('Shipper')->setJoinType('LEFT')->setBindingKey('shipper_ADDRESS_ID');
        //$this->belongsTo('ConsigneeAddress')->setForeignKey('Consignee')->setJoinType('LEFT')->setBindingKey('consignee_ADDRESS_ID');
        //$this->hasMany('ExportCollShowroom')->setForeignKey('exportCollectionID')->setJoinType('LEFT')->setBindingKey('exportCollectionsID');
        //$this->belongsTo('SavoirUser')->setForeignKey('noteaddedby')->setJoinType('LEFT')->setBindingKey('user_id');
    }
	
	public function getItemsForCommercialInvoice($pn, $cid) {
		$sql = "select l.componentid from exportlinks l, exportcollections e, exportcollshowrooms S, purchase P where l.purchase_no=" .$pn ." and l.linkscollectionid=S.exportCollshowroomsID and S.exportCollectionID=e.exportcollectionsid and P.purchase_no=l.purchase_no and e.exportcollectionsid=" .$cid . "";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
    
    public function getCollectionDate($pn, $compid) {
		$sql = "select e.CollectionDate from exportlinks l, exportcollections e, exportcollshowrooms S where l.purchase_no=" .$pn ." and l.linkscollectionid=S.exportCollshowroomsID and S.exportCollectionID=e.exportcollectionsid and l.componentID=" .$compid . "";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
    
    public function getExportDate($pn, $compid) {
        $sql = "Select C.CollectionDate from exportlinks E, ExportCollections C where E.linkscollectionid=C.exportcollectionsid and E.purchase_no=".$pn." and E.componentId= ".$compid;
        $myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getOrderCollectionDate($pn) {
		$sql = "select e.CollectionDate from exportlinks l, exportcollections e, exportcollshowrooms S where l.purchase_no=" .$pn ." and l.linkscollectionid=S.exportCollshowroomsID and S.exportCollectionID=e.exportcollectionsid order by e.Collectiondate desc";
		$myconn = ConnectionManager::get('default');
		$data=$myconn->execute($sql)->fetchAll('assoc');
		$collectiondate = '';
		foreach ($data as $row) {
			$collectiondate=$row['CollectionDate'];
			break;
		}
		return $collectiondate;
				
    }
    
    public function getCancelledExports($isSuperUser, $userLocation, $sortorder) {
    	if ($isSuperUser || $userLocation==27 || $userLocation==1) {
    	$sql = "SELECT * from exportcollections E, shipper_address S, collectionStatus C where E.Shipper=S.shipper_ADDRESS_ID AND C.collectionStatusID=E.collectionStatus AND E.collectionStatus=5";
    	} else {
    	$sql = "SELECT * from exportcollections E, shipper_address S, collectionStatus C, exportcollshowrooms T where  T.idLocation=" .$userLocation. " and T.exportCollectionID=E.exportCollectionsid and E.Shipper=S.shipper_ADDRESS_ID AND C.collectionStatusID=E.collectionStatus AND E.collectionStatus=5  ";
    	}
    	if ($sortorder !="") {
			$sql .= " order by " . $sortorder;
		} else {
		$sql .= " order by CollectionDate";
		}
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
    
    public function getDeliveredExports($isSuperUser, $userLocation, $sortorder, $oneyear) {
    	if ($userLocation==27 || $userLocation==1) {
    	$sql = "SELECT * from exportcollections E, shipper_address S, collectionStatus C where E.Shipper=S.shipper_ADDRESS_ID AND C.collectionStatusID=E.collectionStatus AND E.collectionStatus=4";
    	} else {
    	$sql = "SELECT * from exportcollections E, shipper_address S, collectionStatus C, exportcollshowrooms T where  T.idLocation=" .$userLocation. " and T.exportCollectionID=E.exportCollectionsid and E.Shipper=S.shipper_ADDRESS_ID AND C.collectionStatusID=E.collectionStatus AND E.collectionStatus=4  ";
    	}
    	if ($oneyear==12) {
    		$sql .= " AND E.CollectionDate > DATE_SUB(CURDATE(), INTERVAL 1 Year)";
    	}
    	if ($oneyear > 12) {
    		$sql .= " AND YEAR(E.CollectionDate) =".$oneyear;
    	}
    	if ($sortorder !="") {
			$sql .= " order by " . $sortorder;
		} else {
		$sql .= " order by CollectionDate desc";
		}
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
    
    public function getPlannedExports($isSuperUser, $isRegionalAdministrator, $userLocation, $userRegion, $sortorder) {
    	$sql = "SELECT ExportDeliveryTerms,termstext,exportCollectionsID,E.CollectionDate,shipperName,Consignee,TransportMode,DestinationPort,ContainerRef,collectionStatusName,AddedBy,UpdatedBy,UpdatedDate,";
    	$sql .= " (select adminheading from exportcollshowrooms t1, location t2 where t1.idLocation=t2.idlocation and t1.exportCollectionID=exportCollectionsID order by t2.idlocation limit 1) as firstshowroom";
    	$sql .= " from exportcollections E, shipper_address S, collectionstatus C";

    	if ($userLocation==27 || $userLocation==1) {
    	$sql .= " where E.Shipper=S.shipper_ADDRESS_ID AND C.collectionStatusID=E.collectionStatus AND E.collectionStatus<>4 and E.collectionStatus<>5";
    	} elseif ($userLocation==21) {
    	$sql .= " where E.exportCollectionsID in (select T.exportCollectionID from exportcollshowrooms T join location L on T.idLocation=L.idlocation and (T.idLocation=".$userLocation." or T.idLocation=30))";
    	$sql .= " and E.Shipper=S.shipper_ADDRESS_ID";
		$sql .= " AND C.collectionStatusID=E.collectionStatus";
		$sql .= " AND E.collectionStatus not in (4,5)";
    	} elseif ($isRegionalAdministrator) {
    	$sql .= " where E.exportCollectionsID in (select T.exportCollectionID from exportcollshowrooms T join location L on T.idLocation=L.idlocation and L.owning_region=" .$userRegion.")";
		$sql .= " and E.Shipper=S.shipper_ADDRESS_ID";
		$sql .= " AND C.collectionStatusID=E.collectionStatus";
		$sql .= " AND E.collectionStatus not in (4,5)";
    	} else {
    	$sql .= " where E.exportCollectionsID in (select T.exportCollectionID from exportcollshowrooms T join location L on T.idLocation=L.idlocation and T.idLocation=".$userLocation.")";
    	$sql .= " and E.Shipper=S.shipper_ADDRESS_ID";
		$sql .= " AND C.collectionStatusID=E.collectionStatus";
		$sql .= " AND E.collectionStatus not in (4,5)";
    	}
    	if ($sortorder !="") {
			$sql .= " order by " . $sortorder;
		} else {
		$sql .= " order by CollectionDate asc";
		}
		//debug ($sql);
		//die();
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
    
    public function getManifestCurrencies($cid) {
        $sql = "select distinct ordercurrency from purchase where purchase_no in (SELECT purchase_no from exportlinks E, exportCollShowrooms S where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=".$cid." AND orderConfirmed='y')";
        $myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql)->fetchAll('assoc');
		$currencies = [];
		foreach ($rs as $row) {
		    array_push($currencies, $row['ordercurrency']);
		}
		return $currencies;
    }
    
    public function getManifestPNs($cid) {
        $sql = "SELECT distinct purchase_no from exportlinks E, exportCollShowrooms S  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=".$cid." AND orderConfirmed='y'";
        $myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    
    public function getManifestPNComponentIds($pn, $cid) {
        $sql = "Select L.componentID from exportlinks L, exportcollections E, exportcollshowrooms S, purchase P where L.purchase_no=" .$pn. " and L.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID and P.purchase_no=L.purchase_no and E.exportCollectionsID=".$cid;
        $myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getCollectionData($cid) {
        $sql = "Select * from exportcollections where exportCollectionsID=".$cid." ";
        $myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getShipmentDetails($cid, $location) {
        $sql = "SELECT * from exportcollections E, location L, shipper_address S, collectionStatus C, exportCollShowrooms T where  T.idLocation=L.idlocation AND T.idLocation=".$location." and E.Shipper=S.shipper_ADDRESS_ID AND C.collectionStatusID=E.collectionStatus AND  T.exportCollectionID=".$cid." and E.exportCollectionsID=T.exportCollectionID order by E.CollectionDate";
        $myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getContainerDetails($cid) {
        //$sql = "select l.idlocation, ec.CollectionDate, dt.DeliveryTerms, ss.shipperName, ec.DestinationPort, ec.TransportMode, ec.ContainerRef, cs.collectionStatusName, ecs.ETAdate, p.purchase_no, c.surname, p.order_number, el.invoiceno, linkscollectionid, a.company, p.ordercurrency, p.customerreference, p.savoirmodel, p.basesavoirmodel, p.toppertype, p.headboardstyle, p.legstyle, p.legfinish, p.mattressrequired, p.mattresstype, p.mattressprice, p.baserequired, p.basetype, p.baseprice, p.upholsteryprice, p.basedrawersprice, p.basetrimprice, p.basefabricprice, p.topperrequired, p.topperprice, p.headboardrequired, p.headboardprice, p.headboardtrimprice, p.hbfabricprice, p.legsrequired, p.legprice, p.addlegprice, p.valancerequired, p.valanceprice, p.accessoriesrequired, p.accessoriestotalcost, l.location from exportcollections ec join exportcollshowrooms ecs on ec.exportcollectionsid = ecs.exportcollectionid join exportlinks el on el.linkscollectionid = ecs.exportcollshowroomsid join deliveryterms dt on dt.deliveryTermsID = ec.ExportDeliveryTerms join collectionstatus cs on cs.collectionstatusid = ec.collectionstatus join location l on l.idlocation = ecs.idlocation join shipper_address ss on ec.shipper = ss.shipper_address_id join purchase p on el.purchase_no = p.purchase_no join contact c on p.contact_no = c.contact_no join address a on a.code = c.code where ecs.exportcollectionid = ".$cid." and orderconfirmed = 'y'";
        
        
        
      $sql = "SELECT * from exportcollections E, location L, shipper_address S, collectionStatus C, exportCollShowrooms T, deliveryTerms dt where  T.idlocation=L.idlocation and E.Shipper=S.shipper_address_id AND C.collectionStatusID=E.collectionStatus AND dt.deliveryTermsID=E.ExportDeliveryTerms AND  T.exportCollectionID=".$cid." and E.exportcollectionsid=T.exportCollectionid order by CollectionDate";
        $myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

 public function getShipmentPurchaseNos($cid, $userlocation, $location) { 
 	$sql = "SELECT distinct E.purchase_no, C.surname, P.ORDER_NUMBER, E.InvoiceNo, linksCollectionid, A.company, P.ordercurrency, P.customerreference, P.savoirmodel, P.basesavoirmodel, P.toppertype, P.headboardstyle, P.legstyle, P.legfinish, P.mattressrequired, P.mattresstype, P.mattressprice, P.baserequired, P.basetype, P.baseprice, P.upholsteryprice, P.basedrawersprice, P.basetrimprice, P.basefabricprice, P.topperrequired, P.topperprice, P.headboardrequired, P.headboardprice, P.headboardtrimprice, P.hbfabricprice, P.legsrequired, P.legprice, P.addlegprice, P.valancerequired, P.valanceprice, P.valfabricprice, P.accessoriesrequired, P.accessoriestotalcost from exportlinks E, exportCollShowrooms S, Purchase P, contact C, address A where  E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=".$cid." AND ";
    if ($userlocation == 1 || $userlocation == 27 || $userlocation == 34) {
    	 $sql .= "S.idlocation=".$location." and ";
   		 } else {
    	$sql .= " S.idlocation=".$userlocation." AND ";
    	}
    	$sql .= "orderConfirmed='y' and P.contact_no=C.CONTACT_NO and A.CODE=C.CODE and E.purchase_no=P.PURCHASE_No";
        $myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
	}

	public function getExWorksDates($location) {
		if ($location==1 || $location==27) {
			$sql = "Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation order by E.collectiondate";
		} else {
			$sql = "Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation and C.idlocation=".$location." order by E.collectiondate";
		}
        
        $myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getShipmentDetailsForOrderNo($pno) {    
	  $sql = "SELECT X.exportCollectionID, X.idLocation FROM `exportlinks` EL, exportcollshowrooms X WHERE EL.LinksCollectionID=X.exportCollshowroomsID and EL.purchase_no=".$pno;   
	  $myconn = ConnectionManager::get('default');
	  return $myconn->execute($sql)->fetchAll('assoc');
    }

}
?>
