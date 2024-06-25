<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;
use Cake\Core\App;

class CurrentOrdersTable extends Table {
	private $months = array("January"=>"1", "February"=>"2", "March"=>"3", "April"=>"4", "May"=>"5", "June"=>"6", "July"=>"7", "August"=>"8", "September"=>"9", "October"=>"10", "November"=>"11", "December"=>"12");
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('PURCHASE_No');
    }
		
	public function getCurrentOrdersCount($security, $showroom) {
		
		$sql = "Select count(*) as count from (";
		$sql .= "select PURCHASE_No,";
		$sql .= " (select min(ec.collectionStatus) as mincollectionstatus from exportlinks el, exportcollections ec where ec.exportCollectionsID=el.LinksCollectionID and el.purchase_no=P.PURCHASE_No) as mincollectionstatus";
		$sql .= " from address A, contact C, purchase P";
		if ($security->_userHasRole('ADMINISTRATOR') || $security->_userHasRole('SHOWROOM_VIEWER') || $security->getCurrentUserRegionId()==1) { 	
			$sql .= ", location L";
		}
		$sql .= " Where (P.cancelled IS NULL or P.cancelled <> 'y') AND C.retire='n' AND P.orderonhold<>'y' AND C.CONTACT_NO<>319256 AND C.CONTACT_NO<>24188 AND (P.ORDER_NUMBER IS NOT NULL AND P.ORDER_NUMBER != '') AND A.CODE=C.CODE AND C.CONTACT_NO=P.contact_no AND P.completedorders='n' AND P.quote='n' ";
		if ($security->_userHasRole('ADMINISTRATOR') || $security->_userHasRole('SHOWROOM_VIEWER') || $security->getCurrentUserRegionId()==1) { 	
			$sql .= " AND P.idlocation=L.idlocation ";
		} else if (!$security->isSuperuser() && !$security->_userHasRole('ADMINISTRATOR')) {
			if ($security->getCurrentUsersId()==170) {
				$sql .= " AND P.OWNING_REGION=".$security->getCurrentUserRegionId();
				$sql .= " AND P.idlocation in (3, 4, 5)";
				} else if ($security->_userHasRole('REGIONAL_ADMINISTRATOR')) {
					//REGION_ADMINISTRATOR can see all orders in their region
					$sql .= " AND P.OWNING_REGION=".$security->getCurrentUserRegionId();
				} else if ($security->getCurrentUserLocationId() != 1 && $security->getCurrentUserLocationId() != 27) {
				//'Bedworks & Cardiff
					$buddyLocationAndRegionList = $this->getBuddyLocationAndRegionList($security->getCurrentUserLocationId());
					$nLoc = 0;
					$pairs = explode(";",$buddyLocationAndRegionList);
					$sql .= " AND (";
					foreach ($pairs as $pair) {
						$nLoc = $nLoc + 1;
						if ($nLoc > 1) {
							$sql .= " OR ";
						}
						$locAndReg = explode(",",$pair);
						$sql .= " (P.idlocation=" .$locAndReg[0] . " AND P.OWNING_REGION=" .$locAndReg[1] . ")";
						
					}
					$sql .= ")";
				} else {
					$sql .= " AND P.OWNING_REGION=" .$security->getCurrentUserRegionId();
				}
			} 
			if ($security->getCurrentUserRegionId()==1 && !$security->isSuperuser() && !$security->_userHasRole('ADMINISTRATOR')) {
				$sql .= " AND P.idlocation in (".$this->makeBuddyLocationList($security->getCurrentUserLocationId()).") ";
			}
			if ($showroom!='all' && $showroom!='' && $showroom!='n') {
				$sql .= " and P.idlocation=".$showroom;
			}
			$sql .= " and P.SOURCE_SITE='SB' and P.orderSource <> 'Test'";
			$sql .= ") as x where (x.mincollectionstatus is null or x.mincollectionstatus<4) limit 20";
		// debug($sql);
		// die();
		
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getCurrentOrders($security, $showroom, $start, $length, $orderCol, $orderDir) {
		
		$sql = "Select * from (";
		$sql .= "select ORDER_NUMBER,ORDER_DATE,acknowdate,PURCHASE_No,surname,P.OWNING_REGION,P.customerreference,c.title,first,company,total,ordercurrency,paymentstotal,balanceoutstanding,vat,deliverypostcode,productiondate,bookeddeliverydate,overseasOrder,istrade,";
		if ($security->_userHasRole('ADMINISTRATOR') || $security->_userHasRole('SHOWROOM_VIEWER') || $security->getCurrentUserRegionId()==1) { 	
			$sql .= "adminheading,";
		}
		$sql .= " (select min(ec.collectionStatus) as mincollectionstatus from exportlinks el, exportcollections ec where ec.exportCollectionsID=el.LinksCollectionID and el.purchase_no=P.PURCHASE_No) as mincollectionstatus,";
		$sql .= " (SELECT count(distinct(L.exportCollectionID)) FROM exportlinks E, exportcollshowrooms L where E.linkscollectionid=L.exportCollshowroomsID and E.purchase_no=P.PURCHASE_No) as lorrycount,";
		$sql .= " (Select CollectionDate from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=P.PURCHASE_No and L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID limit 1) as CollectionDate,";
		$sql .= " (select count(*) as overduenotecount from ordernote odn where odn.purchase_no=P.PURCHASE_No and odn.followupdate is not null and odn.followupdate < now() and odn.action='To Do') as overduenotecount";
		$sql .= " from address A, contact C, purchase P";
		if ($security->_userHasRole('ADMINISTRATOR') || $security->_userHasRole('SHOWROOM_VIEWER') || $security->getCurrentUserRegionId()==1) { 	
			$sql .= ", location L";
		}
		$sql .= " Where (P.cancelled IS NULL or P.cancelled <> 'y') AND C.retire='n' AND P.orderonhold<>'y' AND C.CONTACT_NO<>319256 AND C.CONTACT_NO<>24188 AND (P.ORDER_NUMBER IS NOT NULL AND P.ORDER_NUMBER != '') AND A.CODE=C.CODE AND C.CONTACT_NO=P.contact_no AND P.completedorders='n' AND P.quote='n' ";
		if ($security->_userHasRole('ADMINISTRATOR') || $security->_userHasRole('SHOWROOM_VIEWER') || $security->getCurrentUserRegionId()==1) { 	
			$sql .= " AND P.idlocation=L.idlocation ";
		} else if (!$security->isSuperuser() && !$security->_userHasRole('ADMINISTRATOR')) {
			if ($security->getCurrentUsersId()==170) {
				$sql .= " AND P.OWNING_REGION=".$security->getCurrentUserRegionId();
				$sql .= " AND P.idlocation in (3, 4, 5)";
				} else if ($security->_userHasRole('REGIONAL_ADMINISTRATOR')) {
					//REGION_ADMINISTRATOR can see all orders in their region
					$sql .= " AND P.OWNING_REGION=".$security->getCurrentUserRegionId();
				} else if ($security->getCurrentUserLocationId() != 1 && $security->getCurrentUserLocationId() != 27) {
				//'Bedworks & Cardiff
					$buddyLocationAndRegionList = $this->getBuddyLocationAndRegionList($security->getCurrentUserLocationId());
					$nLoc = 0;
					$pairs = explode(";",$buddyLocationAndRegionList);
					$sql .= " AND (";
					foreach ($pairs as $pair) {
						$nLoc = $nLoc + 1;
						if ($nLoc > 1) {
							$sql .= " OR ";
						}
						$locAndReg = explode(",",$pair);
						$sql .= " (P.idlocation=" .$locAndReg[0] . " AND P.OWNING_REGION=" .$locAndReg[1] . ")";
						
					}
					$sql .= ")";
				} else {
					$sql .= " AND P.OWNING_REGION=" .$security->getCurrentUserRegionId();
				}
			} 
			if ($security->getCurrentUserRegionId()==1 && !$security->isSuperuser() && !$security->_userHasRole('ADMINISTRATOR')) {
				$sql .= " AND P.idlocation in (".$this->makeBuddyLocationList($security->getCurrentUserLocationId()).") ";
			}
			if ($showroom!='all' && $showroom!='' && $showroom!='n') {
				$sql .= " and P.idlocation=".$showroom;
			}
			$sql .= " and P.SOURCE_SITE='SB' and P.orderSource <> 'Test'";
			$sql .= " order by P.ORDER_NUMBER asc";
			$sql .= ") as x where (x.mincollectionstatus is null or x.mincollectionstatus<4) ";
			$sql .= " order by " . $orderCol . " " . $orderDir;
			$sql .= " limit " . $start . "," . $length;
		debug($sql);
		die();
		
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getHasOverdueNote($pn) {
    	$sql = "select * from ordernote where purchase_no=".$pn." and followupdate is not null and followupdate < now() and action='To Do'";
		$myconn = ConnectionManager::get('default');
		$rs=$myconn->execute($sql)->fetchAll('assoc');
		return count($rs)>0;
    }
	
	public function getExWorksDate($pn) {
		$lorrycount=0;
		$sql="select count(*) as lorrycount from (SELECT exportcollectionid FROM exportlinks E, exportcollshowrooms L where E.linkscollectionid=L.exportCollshowroomsID and purchase_no=".$pn." group by exportcollectionid)  as x";
		$myconn = ConnectionManager::get('default');
		$rs=$myconn->execute($sql)->fetchAll('assoc');
		foreach ($rs as $rows) {
			$lorrycount=$rows['lorrycount'];
		}
		$exworks='';
		if ($lorrycount>1) {
			$exworks= 'Split Shipment Dates';
		} else {
		   $sql2="Select * from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=".$pn." and L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID";
		   $myconn2 = ConnectionManager::get('default');
		   $rs2=$myconn2->execute($sql2)->fetchAll('assoc');

		   if (count($rs2)>0) {
			 $exworks= date("d/m/Y", strtotime(substr($rs2[0]['CollectionDate'],0,10)));
		   } else {
			 $exworks= 'TBA';
		   }
		   
		}
	return $exworks;

	}
	
	
	
    
    function getBuddyLocationAndRegionList($idLocation) {
    	
		$myconn = ConnectionManager::get('default');
    	$sql = "select buddy_location_ids from location where idlocation=:id";
		$rs = $myconn->execute($sql, ['id' => $idLocation])->fetchAll('assoc');
    	$list = strval($idLocation);
		foreach($rs as $row) {
			if ($row['buddy_location_ids']) {
				$list .= ',' . $row['buddy_location_ids'];
			}
		}
		
		$buddies = explode(',', $list);
		$n = 0;
		$buddyLocationAndRegionList = '';
		foreach($buddies as $bud) {
			$n++;
		    $sql = 'select owning_region from location where idlocation=:bud';
			$rs = $myconn->execute($sql, ['bud' => $bud])->fetchAll('assoc');
	    	if ($n > 1) $buddyLocationAndRegionList .= ';';
		    $buddyLocationAndRegionList .= $bud . ',' . $rs[0]['owning_region'];
	    	
		}
		
    	return $buddyLocationAndRegionList;
    }
    
    function getBuddyLocationIds($idLocation) {
		$myconn = ConnectionManager::get('default');
    	$sql = 'select buddy_location_ids from location where idlocation=:id';
		$rs = $myconn->execute($sql, ['id' => $idLocation])->fetchAll('assoc');
		return $rs[0]['buddy_location_ids'];
    }
    
    
    function makeBuddyLocationList($idLocation) {
		$makeBuddyLocationList = $this->getBuddyLocationIds($idLocation);
		if (!$makeBuddyLocationList) {
			$makeBuddyLocationList = $idLocation;
		} else {
			$makeBuddyLocationList = $idLocation . ',' . $makeBuddyLocationList;
		}
		return $makeBuddyLocationList;
    }

}
?>
