<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class AbstractAccessoryTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
    }

    public function getAccessories($pn) {
    	$sql = "Select * from orderaccessory WHERE purchase_no=" . $pn;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

    public function getAccessoriesReport($dateFrom, $dateTo, $showroom) {
    	$sql = "Select A.company, P.ORDER_NUMBER, C.title, C.first, C.surname, P.deliveryadd1, P.deliveryadd2, P.deliveryadd3, P.deliverytown, P.deliverycounty, P.deliverypostcode, P.deliverycountry, P.bookeddeliverydate, P.istrade, P.bedsettotal, P.deliveryprice, P.vatrate, P.ORDER_DATE, P.ordercurrency, P.discount, P.completedorders, P.totalexvat, L.adminheading, O.description, O.design, O.colour, O.size, O.unitprice, O.qty, O.Supplier, POnumber, PODate, O.ETA, O.Received, O.Checked, O.Delivered, O.QtyToFollow, O.SpecialInstructions  from purchase P";
        $sql .= " join Contact C on P.contact_no=C.CONTACT_NO";
        $sql .= " join Address A on A.CODE=C.CODE";
        $sql .= " join Location L on P.idlocation=L.idlocation";
        $sql .= " left join orderaccessory O on P.PURCHASE_No=O.purchase_no";
        $sql .= " WHERE accessoriesrequired='y' and (P.cancelled is null or P.cancelled = 'n') and (P.quote is Null or P.quote='n') and P.orderSource <> 'Test' and C.contact_no<>319256 AND C.contact_no<>24188 and is_developer='n'";
        if ($dateFrom !=''){
            $sql .= " and ORDER_DATE >= '" . $this->convertDateToMysql($dateFrom) . "' ";
        }
        if ($dateTo !=''){
            $sql .= " and ORDER_DATE  < DATE_ADD('" . $this->convertDateToMysql($dateTo) . "', INTERVAL 1 DAY)";
        }
        if ($showroom !='n'){
            $sql .= " and P.idlocation=".$showroom;
        }
       //debug($sql);
       //die();
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