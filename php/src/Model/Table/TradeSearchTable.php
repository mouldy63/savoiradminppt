<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;
use \DateInterval;

class TradeSearchTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('purchase_no');      	
  
    }
    
    public function getTradeSearchReport($isSuperUser, $locationId, $datefrom, $dateto, $sortorder) {
    	$sql = "Select * from address A, contact C, purchase P, Location L Where L.idlocation=P.idlocation and C.retire='n' AND A.CODE=C.CODE AND C.CODE<>218766 AND C.CODE<>213190 AND C.CONTACT_NO=P.contact_no AND P.quote='n' and P.salesusername<>'dave' AND P.salesusername<>'maddy'";
    	if (!$isSuperUser && $locationId != 1 && $locationId !=27) {
			$sql .= " AND P.idlocation=" .$locationId;
		}
		$sql .= " AND A.SOURCE_SITE='SB' ";
		if ($datefrom !='' && $dateto != '') {
			$sql .= " AND P.ORDER_DATE >= '" . $this->convertDateToMysql($datefrom) . "' AND P.ORDER_DATE <= '" . $this->convertDateToMysql($dateto, 1) . "'";
		}
		if ($sortorder !="") {
			$sql .= " order by " . $sortorder;
		}
		$myconn = ConnectionManager::get('default');
		$data = $myconn->execute($sql)->fetchAll('assoc');
		return $data;
    }
    
	private function convertDateToMysql($date, $daysToAdd = 0) {
		$myDateTime = DateTime::createFromFormat('d/m/Y', $date);
		if ($daysToAdd > 0) {
			$myDateTime->add(new DateInterval('P'.$daysToAdd.'D'));
		}
		$date = $myDateTime->format('Y-m-d');
		return $date;
	}
}
?>
