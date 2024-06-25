<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class ShowroomOrdersReportTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('purchase_no');      	
  
    }
    
    public function getShowroomOrdersReport($ordersource, $locationIds, $monthfrom, $monthto, $cancelledorders, $onhold, $quotes, $filter) {
    	$sql = "select p.idlocation, count(p.idlocation) as count";
    	$sql .= " from purchase p";
    	$sql .= " where p.idlocation in (" . implode(",", $locationIds) . ")";
    	if (!empty($monthfrom)) {
	    	$sql .= " and p.order_date >= '" . $this->convertDateToMysql($monthfrom) . "'";
    	}
    	if (!empty($monthto)) {
	    	$sql .= " and p.order_date <= '" . $this->convertDateToMysql($monthto) . "'";
    	}
		if (!empty($cancelledorders)) {
	    	$sql .= " and (p.cancelled is null or p.cancelled='n')";
    	}
		if (!empty($onhold)) {
	    	$sql .= " and (p.orderonhold is null or p.orderonhold='n')";
    	}
		if (!empty($quotes)) {
	    	$sql .= " and (p.quote is null or p.quote='n')";
    	}
    	if (!empty($ordersource)) {
	    	$sql .= " and p.orderSource in (" . $ordersource . ")";
    	}
    	$sql .= " and P.code<>15919";
    	if (!empty($filter)) {
		    $sql .= " and " . $filter;
    	}
    	$sql .= " group by p.idlocation";
    	//echo "<br>$sql";
		$myconn = ConnectionManager::get('default');
		$data = $myconn->execute($sql)->fetchAll('assoc');
		$results = [];
		$count = 0;
		foreach($data as $item) {
			$results[$item['idlocation']] = $item['count'];
			$count += $item['count'];
		}
		$results[0] = $count;
		return $results;
    }
    
    public function getShowroomOrdersReportPurchaseNos($ordersource, $locationId, $monthfrom, $monthto, $cancelledorders, $onhold, $quotes, $filter) {
    	$sql = "select p.purchase_no from purchase p where P.code<>15919";
    	$locationids='';
    	$ordersources='';
    	if (substr($locationId, -1)==',') {
    		$locationids=substr_replace($locationId ,"",-1);
    	} else {
    		$locationids=$locationId;
    	}
    	$ordersources=explode(',',$ordersource);
    	if ($locationId != 0) {
	    	$sql .= " and p.idlocation IN (".$locationids.")";
    	}
    	if (!empty($monthfrom)) {
	    	$sql .= " and p.order_date >= '" . $this->convertDateToMysql($monthfrom) . "'";
    	}
    	if (!empty($monthto)) {
	    	$sql .= " and p.order_date <= '" . $this->convertDateToMysql($monthto) . "'";
    	}
		if (!empty($cancelledorders)) {
	    	$sql .= " and (p.cancelled is null or p.cancelled='n')";
    	}
		if (!empty($onhold)) {
	    	$sql .= " and (p.orderonhold is null or p.orderonhold='n')";
    	}
		if (!empty($quotes)) {
	    	$sql .= " and (p.quote is null or p.quote='n')";
    	}
    	if (!empty($ordersource)) {
    		$sql .= " AND (";
    		$n = 0;
			foreach ($ordersources as $row):
				if ($n > 0) $sql .= " OR ";
				$sql .= " p.orderSource LIKE '" . $row . "'";
				$n++;
			endforeach;
			$sql.=")";
    	}
    	if (!empty($filter)) {
		    $sql .= " and " . $filter;
    	}
		$sql .= " order by p.purchase_no";
    	//echo "<br>$sql";
    	//die;
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql)->fetchAll('assoc');
		$nos = [];
		foreach($rs as $row) {
			array_push($nos, $row['purchase_no']);
		}
		return $nos;
    }
        
	private function convertDateToMysql($date) {
		$myDateTime = DateTime::createFromFormat('d/m/Y', $date);
		$date = $myDateTime->format('Y-m-d');
		return $date;
	}
}
?>
