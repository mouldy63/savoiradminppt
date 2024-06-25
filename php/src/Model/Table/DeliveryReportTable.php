<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class DeliveryReportTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('PURCHASE_No');      	
  
    }
		
    public function getDeliveryReport($reporttype, $giftpack, $showroom, $monthfrom, $monthto, $delcall, $sortorder) {
		$DBmonthfrom = $this->convertDateToMysql($monthfrom);
		$DBmonthto = $this->convertDateToMysql($monthto);
    	$sql = "Select * from address A, contact C, purchase P, Location L";
		if ($delcall=='y') {
			$sql .= ", communication cn";
		}
    	//$sql .= ", Location L";
    	$sql .= " Where P.idlocation=L.idlocation and (P.cancelled is null or P.cancelled <> 'y') AND C.retire='n' AND P.orderonhold<>'y' AND A.CODE=C.CODE AND C.contact_no=P.contact_no AND P.quote='n' ";
		//$sql .=" AND C.contact_no<>319256 AND C.contact_no<>24188"; 
		if ($delcall=='y') {
			$sql .= " AND C.CODE=cn.CODE";  
		}
		if ($reporttype == 'delivery') {
			$sql .= " and P.bookeddeliverydate is not null and P.bookeddeliverydate<>'' ";
			if ($monthfrom != '') {
			$sql .= " AND P.bookeddeliverydate > DATE_ADD('" .$DBmonthfrom ."', INTERVAL -1 DAY)"; 
			}
			if ($monthto != '') {
			$sql .= " AND P.bookeddeliverydate < DATE_ADD('" .$DBmonthto ."', INTERVAL 1 DAY)";
			}
		}
		if ($reporttype == 'production') {
			$sql .= " and P.production_completion_date is not null and P.production_completion_date<>'' ";
			if ($monthfrom != '') {
			$sql .= " AND P.production_completion_date > DATE_ADD('" .$DBmonthfrom ."', INTERVAL -1 DAY)";
			}
			if ($monthto != '') {
			$sql .= " AND P.production_completion_date < DATE_ADD('" .$DBmonthto ."', INTERVAL 1 DAY)";
			}
		}
		if ($giftpack == "y") {
			$sql .=  " AND P.giftpackrequired = 'y'";
		}
		if ($showroom != "n") {
			$sql .=  " AND L.idlocation = " .$showroom;
		}
		if ($delcall=='y') {
			$sql .= " AND cn.Type='Post Delivery Call'";
		}
		if ($sortorder !="") {
			$sql .= " order by " . $sortorder;
		}
		//debug($sql);
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
	private function convertDateToMysql($date) {
		$myDateTime = DateTime::createFromFormat('d/m/Y', $date);
		$date = $myDateTime->format('Y-m-d');
		return $date;
	}
	
	

}
?>
