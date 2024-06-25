<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class QcHistoryLatestTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('qc_history_latest');
        $this->setPrimaryKey('QC_History_latestID');
    }
	
	public function getOrderStatus() {
    	$sql = "select QC_status, QC_statusID from qc_status where retiredCoreProducts='n' order by QC_statusID";
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getQCCompStatus($compid, $pn) {
    	$sql = "Select * from qc_history_latest WHERE purchase_no=".$pn ." AND componentid=" .$compid ."";
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getQCmadeat($compid, $pn) {
    	$sql = "Select M.id_location, M.ManufacturedAt from qc_history_latest Q, manufacturedat M where Q.madeat=M.manufacturedatid AND Q.componentid=".$compid." AND purchase_no=".$pn ."";
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
     public function getItemsFinished($showroom, $monthfrom, $monthto, $sortorder) {
     $sql = "Select P.PURCHASE_No, P.ORDER_NUMBER, C.surname, P.orderSource, P.ORDER_DATE, P.bookeddeliverydate, T.Component, L.adminheading, Q.ComponentID, P.savoirmodel, P.basesavoirmodel, P.toppertype, P.legstyle, P.headboardstyle, Q.MadeAt, Q.Cut, Q.springunitdate, Q.Framed, Q.prepped, Q.finished, P.productiondate, P.vatrate, P.istrade, P.mattressprice, P.baseprice, P.topperprice, P.legprice, P.headboardprice, P.upholsteryprice, P.basetrimprice, P.basedrawersprice, P.basefabricprice, P.ordercurrency, P.mattressinstructions, P.baseinstructions, P.specialinstructionstopper, P.specialinstructionslegs, P.specialinstructionsheadboard, P.specialinstructionsvalance, P.total, P.bedsettotal, P.addlegprice, P.hbfabricprice, P.headboardtrimprice, P.deliveryprice, P.subtotal, P.production_completion_date";
$sql .= " from qc_history_latest Q";
$sql .= " JOIN Purchase P on Q.Purchase_No=P.PURCHASE_No";
$sql .= " JOIN Contact C on P.contact_no=C.CONTACT_NO";
$sql .= " JOIN Location L on L.idlocation=P.idlocation";
$sql .= " JOIN Component T ON Q.ComponentID=T.ComponentID";
$sql .= " WHERE Q.finished >='" .$monthfrom. "' AND Q.finished <= '" .$monthto. "' AND Q.ComponentID<>0";
$sql .= " AND P.ordersource <> 'Test'";
if ($showroom != 'all') {
$sql .= " AND L.idlocation=".$showroom;
}
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
     
	public function getOrderStatusName($pn) {
    	$sql = "select qs.QC_status from qc_history_latest ql join qc_status qs on ql.QC_statusID=qs.QC_statusID where ql.Purchase_No=:pn and ql.ComponentID=0";
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['pn' => $pn]);
		$status = null;
		foreach ($rs as $row) {
			$status = $row['QC_status'];
		}
		return $status;
	}

	public function getComponentStatus($pn, $compId) {
		$myconn = ConnectionManager::get('default');
		$sql = "select QC_StatusID from qc_history_latest where purchase_no=:pn and componentid=:compId";
		$rs = $myconn->execute($sql, ['pn' => $pn, 'compId' => $compId]);
		$status = null;
		foreach ($rs as $row) {
			$status = $row['QC_StatusID'];
		}
		return $status;
	}

	public function isComponentLocked($pn, $compId) {
		$status = $this->getComponentStatus($pn, $compId);
		$lockColour = "";
		if ($status == 20) {
			$lockColour = "red"; //In Production
		} else if ($status == 30) {
			$lockColour = "orange"; // Order on Stock, Waiting QC
		} else if ($status == 40) {
			$lockColour = "green"; // QC Checked
		} else if ($status == 50) {
			$lockColour = "green"; // In Bay
		} else if ($status == 60) {
			$lockColour = "green"; // Order Picked
		} else if ($status == 70) {
			$lockColour = "grey"; // Delivered
		}
		return [$status > 10, $lockColour];
	}

}


?>
