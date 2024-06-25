<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class ManufacturedAtTable extends Table {
    
    public function initialize(array $config) : void {
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
	
	public function getTopperProdTotal ($datefrom, $dateto, $madeat) {
    	$sql = "Select count(*) as n FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentid=5  and Q.madeat=". $madeat ." and P.code<>15919 AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) ";
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
	
	public function getTopperItemTotal ($datefrom, $dateto, $madeat) {
    	$sql = "Select count(*) as n FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentid=5  and Q.madeat=". $madeat ." and P.code<>15919 AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) ";
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
	
	public function getTopperOBTotal ($datefrom, $dateto, $madeat) {
    	$sql = "Select count(*) as n FROM qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentid=5  and Q.madeat=". $madeat ." and Q.finished is null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919 AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) ";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		$orderdata = 0;
		foreach ($data as $item) {
			$orderdata=$item['n'];
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
    	$sql .= " , ps.Matt1Width as specialwidth1, ps.Matt2Width as specialwidth2, ps.Matt1Length as speciallength1, ps.Matt2Length as speciallength2 ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=". $madeat ." and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
		$sql .= " order by P.order_number";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getMattressItemCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, mattresswidth as w, mattresslength as l, order_number, savoirmodel as n, mattressinstructions as x";
    	$sql .= " , ps.Matt1Width as specialwidth1, ps.Matt2Width as specialwidth2, ps.Matt1Length as speciallength1, ps.Matt2Length as speciallength2 ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=". $madeat ." and P.code<>15919";
    	if (!empty($datefrom)) {
			$sql .= " and Q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and Q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getMattressOBCSV($madeat) {
    	$sql = "Select P.purchase_no, mattresswidth as w, mattresslength as l, order_number, savoirmodel as n, mattressinstructions as x";
    	$sql .= " , ps.Matt1Width as specialwidth1, ps.Matt2Width as specialwidth2, ps.Matt1Length as speciallength1, ps.Matt2Length as speciallength2 ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=1 and Q.madeat=". $madeat ." and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20)";
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
    	$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getBaseProdCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, basewidth as w, baselength as l, order_number, savoirmodel as n, baseinstructions as x";
    	$sql .= " , ps.Base1Width as specialwidth1, ps.Base2Width as specialwidth2, ps.Base1Length as speciallength1, ps.Base2Length as speciallength2 ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=". $madeat ." and P.code<>15919";
    	if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getBaseItemCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, basewidth as w, baselength as l, order_number, savoirmodel as n, baseinstructions as x";
    	$sql .= " , ps.Base1Width as specialwidth1, ps.Base2Width as specialwidth2, ps.Base1Length as speciallength1, ps.Base2Length as speciallength2 ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=". $madeat ." and P.code<>15919";
		if (!empty($datefrom)) {
			$sql .= " and Q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and Q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getBaseOBCSV($madeat) {
    	$sql = "Select P.purchase_no, basewidth as w, baselength as l, order_number, savoirmodel as n, baseinstructions as x";
    	$sql .= " , ps.Base1Width as specialwidth1, ps.Base2Width as specialwidth2, ps.Base1Length as speciallength1, ps.Base2Length as speciallength2 ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=3 and Q.madeat=". $madeat ." and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20)";
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
    	$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
		
	public function getTopperProdCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, topperwidth as w, topperlength as l, P.order_number, P.toppertype as n, specialinstructionstopper as x";
    	$sql .= " , ps.topper1Width as specialwidth1, ps.topper1Length as speciallength1 ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=5 and Q.madeat=". $madeat ." and P.code<>15919 AND q.purchase_no In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) ";
    	if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
		$sql .= " order by P.order_number";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getTopperItemCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, topperwidth as w, topperlength as l, P.order_number, P.toppertype as n, specialinstructionstopper as x";
    	$sql .= " , ps.topper1Width as specialwidth1, ps.topper1Length as speciallength1 ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=5 and Q.madeat=". $madeat ." and P.code<>15919 AND q.purchase_no In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) ";
    	if (!empty($datefrom)) {
			$sql .= " and Q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and Q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
		$sql .= " order by P.order_number";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
		
	public function getTopperOBCSV($madeat) {
    	$sql = "Select P.purchase_no, topperwidth as w, topperlength as l, P.order_number, P.toppertype as n, specialinstructionstopper as x";
    	$sql .= " , ps.topper1Width as specialwidth1, ps.topper1Length as speciallength1 ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=5 and Q.madeat=". $madeat ." and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no  In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) ";
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
    	$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getTopperOnlyProdCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, topperwidth as w, topperlength as l, P.order_number, P.toppertype as n, specialinstructionstopper as x";
    	$sql .= " , ps.topper1Width as specialwidth1, ps.topper1Length as speciallength1 ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=5 and Q.madeat=". $madeat ." and P.code<>15919 AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) ";
    	if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
		$sql .= " order by P.order_number";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getTopperOnlyItemCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, topperwidth as w, topperlength as l, P.order_number, P.toppertype as n, specialinstructionstopper as x";
    	$sql .= " , ps.topper1Width as specialwidth1, ps.topper1Length as speciallength1 ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=5 and Q.madeat=". $madeat ." and P.code<>15919 AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) ";
    	if (!empty($datefrom)) {
			$sql .= " and Q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and Q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
		$sql .= " order by P.order_number";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
		
	public function getTopperOnlyOBCSV($madeat) {
    	$sql = "Select P.purchase_no, topperwidth as w, topperlength as l, P.order_number, P.toppertype as n, specialinstructionstopper as x";
    	$sql .= " , ps.topper1Width as specialwidth1, ps.topper1Length as speciallength1 ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=5 and Q.madeat=". $madeat ." and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) AND q.purchase_no NOT In (SELECT purchase_no FROM qc_history_latest  WHERE (componentid=1 or componentid=3)) ";
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
    	$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getLegsProdCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, P.legheight as w, P.order_number, P.legstyle as n, P.legfinish as lf, P.specialinstructionslegs as x";
    	$sql .= " , ps.legheight as specialheight ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=". $madeat ." and P.code<>15919 ";
    	if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
		$sql .= " order by P.order_number";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getLegsItemCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, P.legheight as w, P.order_number, P.legstyle as n, P.legfinish as lf, P.specialinstructionslegs as x";
    	$sql .= " , ps.legheight as specialheight ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=". $madeat ." and P.code<>15919 ";
    	if (!empty($datefrom)) {
			$sql .= " and Q.finished >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and Q.finished <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
		$sql .= " order by P.order_number";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getLegsOBCSV($madeat) {
    	$sql = "Select P.purchase_no, P.legheight as w, P.order_number, P.legstyle as n, P.legfinish as lf, P.specialinstructionslegs as x";
    	$sql .= " , ps.legheight as specialheight ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=7 and Q.madeat=". $madeat ." and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919 ";
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no";
    	$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getHBProdCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, P.headboardwidth as w, P.headboardheight as l, P.order_number, P.headboardstyle as n, P.specialinstructionsheadboard as x";
    	$sql .= " from qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=". $madeat ." and P.code<>15919 ";
    	if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " order by P.order_number";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getHBItemCSV($datefrom, $dateto, $madeat) {
    	$sql = "Select P.purchase_no, P.headboardwidth as w, P.headboardheight as l, P.order_number, P.headboardstyle as n, P.specialinstructionsheadboard as x";
    	$sql .= " from qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=". $madeat ." and P.code<>15919 ";
    	if (!empty($datefrom)) {
			$sql .= " and p.production_completion_date >= '" . $this->convertDateToMysql($datefrom) . "' ";
		}
		if (!empty($dateto)) {
			$sql .= " and p.production_completion_date <= '" . $this->convertDateToMysql($dateto) . "'";
		}
		$sql .= " order by P.order_number";
		$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getHBOBCSV($madeat) {
    	$sql = "Select P.purchase_no, P.headboardwidth as w, P.headboardheight as l, P.order_number, P.headboardstyle as n, P.specialinstructionsheadboard as x";
    	$sql .= " from qc_history_latest Q, purchase P WHERE (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID=8 and Q.madeat=". $madeat ." and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919 ";
    	$myconn = ConnectionManager::get('default');
		$data= $myconn->execute($sql)->fetchAll('assoc');
		return $data;
			
    }
	
	public function getOBDetailCSV($madeat) {
    	$sql = "Select *, P.legheight as plh, ps.legheight as pslh ";
    	$sql .= " from qc_history_latest Q join purchase P on (P.cancelled is Null or P.cancelled='n') and  P.purchase_no=Q.purchase_no and Q.componentID<>0 and Q.madeat=". $madeat ." and P.code<>15919 and Q.finished is Null and (Q.QC_StatusID=0 or Q.QC_StatusID=2 or Q.QC_StatusID=4 or Q.QC_StatusID=20) and P.code<>15919 ";
		$sql .= " join component C on Q.componentID=C.ComponentID ";
		$sql .= " left join productionsizes ps on P.purchase_no=ps.purchase_no order by P.purchase_no asc";
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
