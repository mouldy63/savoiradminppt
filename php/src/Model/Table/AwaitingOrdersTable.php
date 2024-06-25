<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;
use Cake\Core\App;

class AwaitingOrdersTable extends Table {
	private $months = array("January"=>"1", "February"=>"2", "March"=>"3", "April"=>"4", "May"=>"5", "June"=>"6", "July"=>"7", "August"=>"8", "September"=>"9", "October"=>"10", "November"=>"11", "December"=>"12");
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('PURCHASE_No');
    }
		
	public function getAwaitingOrders($sortorder, $security, $showroom, $statusID, $orderconfirmationstatus, $mktFloor) {
		
		$sql = "select * from (";
		$sql .= "select P.ORDER_NUMBER,P.ORDER_DATE,P.customerreference,P.ordercurrency,P.orderSource,P.acknowdate,P.PURCHASE_No,C.surname,C.title,C.first,A.company,P.total,P.AmendedDate";
	if ($security->_userHasRole('ADMINISTRATOR')) {
		$sql .= ",L.adminheading";
	}
		$sql .= " , case when exists (Select 1 from qc_history_latest h where h.ComponentID=1 AND h.Purchase_No=P.PURCHASE_No) then (Select h.QC_StatusID from qc_history_latest h where h.ComponentID=1 AND h.Purchase_No=P.PURCHASE_No) else -1 end as mattress_status";
		$sql .= " , case when exists (Select 1 from qc_history_latest h where h.ComponentID=3 AND h.Purchase_No=P.PURCHASE_No) then (Select h.QC_StatusID from qc_history_latest h where h.ComponentID=3 AND h.Purchase_No=P.PURCHASE_No) else -1 end as base_status";
		$sql .= " , case when exists (Select 1 from qc_history_latest h where h.ComponentID=5 AND h.Purchase_No=P.PURCHASE_No) then (Select h.QC_StatusID from qc_history_latest h where h.ComponentID=5 AND h.Purchase_No=P.PURCHASE_No) else -1 end as topper_status";
		$sql .= " , case when exists (Select 1 from qc_history_latest h where h.ComponentID=6 AND h.Purchase_No=P.PURCHASE_No) then (Select h.QC_StatusID from qc_history_latest h where h.ComponentID=6 AND h.Purchase_No=P.PURCHASE_No) else -1 end as valance_status";
		$sql .= " , case when exists (Select 1 from qc_history_latest h where h.ComponentID=8 AND h.Purchase_No=P.PURCHASE_No) then (Select h.QC_StatusID from qc_history_latest h where h.ComponentID=8 AND h.Purchase_No=P.PURCHASE_No) else -1 end as headboard_status";
		$sql .= " , case when exists (Select 1 from qc_history_latest h where h.ComponentID=7 AND h.Purchase_No=P.PURCHASE_No) then (Select h.QC_StatusID from qc_history_latest h where h.ComponentID=7 AND h.Purchase_No=P.PURCHASE_No) else -1 end as legs_status";
		$sql .= " , case when exists (Select 1 from qc_history_latest h where h.ComponentID=9 AND h.Purchase_No=P.PURCHASE_No) then (Select h.QC_StatusID from qc_history_latest h where h.ComponentID=9 AND h.Purchase_No=P.PURCHASE_No) else -1 end as accessories_status";
		$sql .= " , case when exists (Select 1 from qc_history_latest h where h.ComponentID=0 AND h.Purchase_No=P.PURCHASE_No) then (Select h.QC_StatusID from qc_history_latest h where h.ComponentID=0 AND h.Purchase_No=P.PURCHASE_No) else -1 end as order_status";
		$sql .= " from address A, contact C, Purchase P";
		if ($security->_userHasRole('ADMINISTRATOR')) {
			$sql .= ", Location L";
		}
		$sql .= " Where (P.cancelled is null or P.cancelled <> 'y') AND C.retire='n' AND P.orderonhold<>'y'";
		if ($orderconfirmationstatus == 'n') {
		$sql .= " AND orderConfirmationStatus='n'";
		}
		if ($mktFloor=='n' && $statusID==0) {
			$sql .= " AND (P.orderSource <> 'Floorstock' AND P.orderSource <> 'Marketing') ";
		} else if ($statusID != 4){
			$sql .= " AND (P.orderSource = 'Floorstock' OR P.orderSource = 'Marketing') ";
		}
		$sql .= " AND A.CODE=C.CODE AND C.CONTACT_NO=P.contact_no AND P.completedorders='n' AND P.quote='n' ";
	
		if ($security->_userHasRole('ADMINISTRATOR')) {
			$sql .= " AND P.idlocation=L.idlocation ";
			if ($showroom != "0" && $showroom != "") {
				$sql .= " AND P.idlocation=" .$showroom;
			}
		} else {
			if ($security->_userHasRole('REGIONAL_ADMINISTRATOR')) {
				$sql .= " AND P.OWNING_REGION=" .$security->getCurrentUserRegionId();
			} else {
				$sql .= " AND P.OWNING_REGION=" .$security->getCurrentUserRegionId() ." and P.idlocation=" .$security->getCurrentUserLocationId();
			}
		}
		$sql .= " AND P.SOURCE_SITE='SB' ";
		
		
		$sql .= " ) as x";
		$sql .= " where x.mattress_status=".$statusID." or x.base_status=".$statusID." or x.topper_status=".$statusID." or x.valance_status=".$statusID." or x.headboard_status=".$statusID." or x.legs_status=".$statusID." or x.accessories_status=".$statusID." or x.order_status=".$statusID."";
		if (!empty($sortorder)) {
		$sql .= " order by " . $sortorder;
		} else {
			$sql .= " order by ORDER_NUMBER";
		}
		//$sql .= " order by P.ORDER_NUMBER asc";
		//debug($sql);
		//die();
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function convertExportLinks($pn) {
		
		$myconn = ConnectionManager::get('default');
		$sql = "Update exportlinks set orderConfirmed='y' Where purchase_no=" .$pn;
		$myconn->execute($sql);
    }
    
    public function getRandomConfirmationNumber() {
        $myconn = ConnectionManager::get('default');
        $confcode='';
		$characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
   		$charactersLength = strlen($characters);
   		$notnew=true;
   		while ($notnew) {
   			$confcode = '';
    		for ($i = 0; $i < 7; $i++) {
      		  $confcode .= $characters[rand(0, $charactersLength - 1)];
   			}
			$sql = "select OrderConfirmationCode from purchase where OrderConfirmationCode='" .$confcode."'";
			$result=$myconn->execute($sql)->fetchAll('assoc');
			$notnew=count($result)>0;
		}
		return $confcode;
	
    }
	
	

}
?>
