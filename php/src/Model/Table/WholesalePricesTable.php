<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class WholesalePricesTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('wholesale_prices');
    }

    public function getCompWholesalePrice($pn, $compid) {
    	$myconn = ConnectionManager::get('default');
    	$sql = "select price FROM " . $this->getTable() . " where componentid=" .$compid ." and purchase_no=" .$pn ."";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getWholesalePriceReport($month, $year) {
    	$myconn = ConnectionManager::get('default');
    	$sql = "Select * FROM qc_history_latest Q, purchase P, address A, contact C, Location L, Component X where (P.cancelled is Null or P.cancelled='n') and P.code<>15919  AND C.retire='n' AND P.orderonhold<>'y' AND C.contact_no<>319256 AND C.contact_no<>24188 AND A.code=C.code AND C.contact_no=P.contact_no and P.idlocation=L.idlocation and Q.purchase_no=P.purchase_no and Q.componentid in (1, 3, 5, 7, 8, 0) and X.componentid=Q.componentid and Month(production_completion_date)=".$month." AND YEAR(production_completion_date)=".$year." order by order_number, Q.componentid desc";
    	//debug($sql);
    	//die;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function deleteRow($pn, $compId) {
    	$myconn = ConnectionManager::get('default');
    	$sql = "delete from " . $this->getTable() . " where purchase_no=:pn and componentID=:compid";
		$myconn = ConnectionManager::get('default');
		$myconn->execute($sql, ['pn' => $pn, 'compid' => $compId]);
    }
}
?>