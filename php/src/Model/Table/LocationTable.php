<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class LocationTable extends Table {
    //public $name = 'Location';
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('location');
        $this->setPrimaryKey('idlocation');
    }
	
	public function getActiveShowrooms($userRegion = "", $showroomIds = "") {
		if (!empty($userRegion)) {
    		$sql = "select idlocation, adminheading from location where OWNING_REGION=" . $userRegion . " and retire='n'";
		} else {
			$sql = "select idlocation, adminheading from location where retire='n'";
   		}
   		if (!empty($showroomIds)) {
			$sql .= " and idlocation in (" . $showroomIds . ")";
   		}
		$sql .= " order by adminheading";
		//debug($sql);
		//die;
   		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getBuddyShowrooms($idlocation) {
    	$sql = "Select distinct(L.idlocation),L.adminheading from location L, Purchase P where P.idlocation=L.idlocation AND P.idlocation in (" . $this->makeBuddyLocationList($idlocation).") and L.retire<>'y' order by adminheading";
    
    	$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql)->fetchAll('assoc');
		return $rs;
    }
	
	public function getShowroom($idlocation) {
    	$sql = "select * from showroomdata S, location L where S.ShowroomLocationID=L.idlocation and L.idlocation=" .$idlocation;
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getSavoirOwned($security) {
    	$sql = "select SavoirOwned from location where idlocation=" .$security->getCurrentUserLocationId();
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql)->fetchAll('assoc');
		$savoirowned = null;
		if (count($rs) > 0) {
			$savoirowned = $rs[0]['SavoirOwned'];
		}
		return $savoirowned;
    }

    public function getOrderDataForComponent($pn, $compId) {
    	$sql = "select cf.fieldname,cf.fieldtype,cf.datatype,od.strvalue,od.intvalue,od.dblvalue,od.datetimevalue";
    	$sql .= " from component_field cf join order_data od on cf.fieldname=od.fieldname and od.PURCHASE_No=:pn and od.ComponentID=:compId";
    	$sql = sprintf($sql, $pn, $compId);
    	$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['pn' => $pn, 'compId' => $compId])->fetchAll('assoc');
		return $rs;
    }
    
    public function getCustomerShowroom($contactNo) {
		$myconn = ConnectionManager::get('default');
    	$sql = "select idlocation from purchase where contact_no=:cn and order_date is not null order by order_date desc limit 1";
		$rs = $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');
		$idLocation = 0;
		if (count($rs) > 0) {
			$idLocation = $rs[0]['idlocation'];
		}
		
		if ($idLocation == 0) {
    		$sql = "select idlocation from contact where contact_no=:cn";
			$rs = $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');
			if (count($rs) > 0) {
				$idLocation = $rs[0]['idlocation'];
			}
		}
		return $this->get($idLocation);
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
    
    function getFinalCountryDestination($idLocation) {
    	$sql = "SELECT * from location L, Region R where L.idlocation=".$idLocation." AND L.owning_region=R.id_region";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	function getSugarLocations() {
    	$sql = "SELECT L.adminheading, L.idlocation, R.id_region, R.name, R.country, L.retire from location L, Region R where L.owning_region=R.id_region and L.retire='n'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	function getVisitLocations($region) {
    	$sql = "Select * from location WHERE retire='n' AND owning_region =".$region;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    
}

?>