<?php
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class ManufacturedAtTable extends Table {
    
    public function initialize(array $config) {
        parent::initialize($config);
        $this->setTable('manufacturedat');
        $this->setPrimaryKey('ManufacturedAtID');
    }
	
	public function getManufacturedAtData($manufacturedatid) {
    	$sql = "Select NoItemsWeek, WoodworkNoItems, CuttingRoomNoItems, ProductionFloorNoItems, SpringCompletionNoItems,LegCompletionNoItems, manufacturedatid from manufacturedat where manufacturedatid=" .$manufacturedatid;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getProdMattress($datefrom, $dateto, $madeat) {
    	$sql = "Select savoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=". $madeat ."  and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and P.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and P.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .=" group by P.savoirmodel";
		//debug($sql);
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = [];
		foreach ($data as $item) {
			$orderdata[$item['savoirmodel']]=$item['n'];
		}
		return $orderdata;
			
    }
	
	public function getItemMattress($datefrom, $dateto, $madeat) {
    	$sql = "Select savoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=". $madeat ."  and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and Q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and Q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .=" group by P.savoirmodel";
		//debug($sql);
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = [];
		foreach ($data as $item) {
			$orderdata[$item['savoirmodel']]=$item['n'];
		}
		return $orderdata;
			
    }
	
	public function getOBMattress($madeat) {
    	$sql = "Select savoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=". $madeat ." and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20)  group by P.savoirmodel";
		//debug($sql);
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = [];
		foreach ($data as $item) {
			$orderdata[$item['savoirmodel']]=$item['n'];
		}
		return $orderdata;
			
    }
	
	public function getProdBase($datefrom, $dateto, $madeat) {
    	$sql = "Select basesavoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=". $madeat ." and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and P.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and P.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .=" group by P.basesavoirmodel";
		//debug($sql);
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = [];
		foreach ($data as $item) {
			$orderdata[$item['basesavoirmodel']]=$item['n'];
		}
		return $orderdata;
			
    }

	public function getItemBase($datefrom, $dateto, $madeat) {
    	$sql = "Select basesavoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=". $madeat ." and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and Q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and Q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .=" group by P.basesavoirmodel";
		//debug($sql);
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = [];
		foreach ($data as $item) {
			$orderdata[$item['basesavoirmodel']]=$item['n'];
		}
		return $orderdata;
			
    }
	
	public function getOBBase($madeat) {
    	$sql = "Select basesavoirmodel, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=". $madeat ." and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919 group by P.basesavoirmodel";
		//debug($sql);
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = [];
		foreach ($data as $item) {
			$orderdata[$item['basesavoirmodel']]=$item['n'];
		}
		return $orderdata;
			
    }	

public function getProdTopper($datefrom, $dateto, $madeat) {
    	$sql = "Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and p.code<>15919 and q.madeat=". $madeat ." AND q.purchase_no In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))";
		if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .=" group by p.toppertype";
		//debug($sql);
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = [];
		foreach ($data as $item) {
			$orderdata[$item['toppertype']]=$item['n'];
		}
		return $orderdata;
			
    }
	
	public function getItemTopper($datefrom, $dateto, $madeat) {
    	$sql = "Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and p.code<>15919 and q.madeat=". $madeat ." AND q.purchase_no In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))";
		if (!empty($datefrom)) {
			$sql .= " and q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .=" group by p.toppertype";
		//debug($sql);
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = [];
		foreach ($data as $item) {
			$orderdata[$item['toppertype']]=$item['n'];
		}
		return $orderdata;
			
    }
		
	public function getOBTopper($madeat) {
    	$sql = "Select toppertype, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and q.componentid=5 and Q.madeat=". $madeat ." and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919 AND q.purchase_no In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by P.toppertype";
		//debug($sql);
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = [];
		foreach ($data as $item) {
			$orderdata[$item['toppertype']]=$item['n'];
		}
		return $orderdata;
			
    }
		
	public function getProdTopperOnly($datefrom, $dateto, $madeat) {
    	$sql = "Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and p.code<>15919 and q.madeat=". $madeat ." AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))";
		if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .=" group by p.toppertype";
		
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = [];
		foreach ($data as $item) {
			$orderdata[$item['toppertype']]=$item['n'];
		}
		return $orderdata;
			
    }
	
	public function getItemTopperOnly($datefrom, $dateto, $madeat) {
    	$sql = "Select p.toppertype, count(*) as n FROM qc_history_latest q, purchase p WHERE (p.cancelled is Null or p.cancelled='n') and  p.purchase_no=q.purchase_no and q.componentid=5 and p.code<>15919 and q.madeat=". $madeat ." AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3))";
		if (!empty($datefrom)) {
			$sql .= " and q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .=" group by p.toppertype";
		
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = [];
		foreach ($data as $item) {
			$orderdata[$item['toppertype']]=$item['n'];
		}
		return $orderdata;
			
    }
	
	public function getOBTopperOnly($madeat) {
    	$sql = "Select toppertype, count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and q.componentid=5 and Q.madeat=". $madeat ." and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919 AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) group by P.toppertype";
		//debug($sql);
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = [];
		foreach ($data as $item) {
			$orderdata[$item['toppertype']]=$item['n'];
		}
		return $orderdata;
			
    }

	public function getProdLegs($datefrom, $dateto, $madeat) {
    	$sql = "Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=". $madeat ."  and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = 0;
		foreach ($data as $item) {
			$orderdata=$item['n'];
		}
		return $orderdata;
			
    }
	
	public function getItemLegs($datefrom, $dateto, $madeat) {
    	$sql = "Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=". $madeat ."  and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = 0;
		foreach ($data as $item) {
			$orderdata=$item['n'];
		}
		return $orderdata;
			
    }

	
	public function getOBLegs($madeat) {
    	$sql = "Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=". $madeat ." and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919";
		//debug($sql);
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = 0;
		foreach ($data as $item) {
			$orderdata=$item['n'];
		}
		return $orderdata;
			
    }
	
	public function getProdHB($datefrom, $dateto, $madeat) {
    	$sql = "Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=". $madeat ."  and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = 0;
		foreach ($data as $item) {
			$orderdata=$item['n'];
		}
		return $orderdata;
			
    }
	
	public function getItemHB($datefrom, $dateto, $madeat) {
    	$sql = "Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=". $madeat ."  and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = 0;
		foreach ($data as $item) {
			$orderdata=$item['n'];
		}
		return $orderdata;
			
    }
	
	public function getOBHB($madeat) {
    	$sql = "Select count(*) as n from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=". $madeat ." and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919";
		//debug($sql);
	
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = 0;
		foreach ($data as $item) {
			$orderdata=$item['n'];
		}
		return $orderdata;
			
    }
	
	public function getMattressProdCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, mattresswidth as w, mattresslength as l, order_number, savoirmodel as n, mattressinstructions as x";
    	$sql .= " ps.Matt1Width as specialwidth1, ps.Matt2Width as specialwidth2, ps.Matt1Length as speciallength1, ps.Matt2Length as speciallength2 ";
    	$sql .= " from qc_history_latest Q join purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=". $madeat ." and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " left outer join productionsizes ps on P.purchase_no=ps.purchase_no";
		debug($sql);
		die;
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getMattressItemCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, mattresswidth as w, mattresslength as l, order_number, savoirmodel as n, mattressinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=". $madeat ." and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and Q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and Q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getMattressOBCSV($madeat) {
    	$sql = "Select P.purchase_no, mattresswidth as w, mattresslength as l, order_number, savoirmodel as n, mattressinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=". $madeat ." and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20)";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getBaseProdCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, mattresswidth as w, mattresslength as l, order_number, savoirmodel as n, mattressinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=". $madeat ." and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getBaseItemCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, mattresswidth as w, mattresslength as l, order_number, savoirmodel as n, mattressinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=". $madeat ." and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and Q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and Q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getBaseOBCSV($madeat) {
    	$sql = "Select P.purchase_no, mattresswidth as w, mattresslength as l, order_number, savoirmodel as n, mattressinstructions as x from qc_history_latest Q, purchase P where (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=". $madeat ." and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20)";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	
	private function convertDateToMysql($date) {
		$myDateTime = DateTime::createFromFormat('d/m/Y', $date);
		$date = $myDateTime->format('Y-m-d');
		return $date;
	}
	
	private function getSpecialSizes($datefrom, $dateto, $madeat) {
		
	}
}
?>
