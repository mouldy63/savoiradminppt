<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class AbstractWholesaleInvoicesTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
    }

    public function getWholesaleInvoiceData($pn) {

		$sql = "select * from wholesale_invoices where purchase_no=".$pn;
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