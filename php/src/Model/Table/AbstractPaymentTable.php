<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class AbstractPaymentTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
    }

    public function getPaymentMethods() {
    	$sql = "Select * from paymentmethod";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getPayments($pn) {
    	$sql = "Select * from " . $this->getTable() . " p, paymentmethod m where p.paymentmethodid=m.paymentmethodid and p.purchase_no=" .$pn;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

    public function getPendingInvoices($pn) {
    	$sql = "Select * from pending_invoicenos where purchase_no=" .$pn;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

    public function getFinalInvoiceNo($pn) {
    	$sql = "Select * from final_invoicenos where purchase_no=" .$pn;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

    public function getPaymentSum($pn) {
    	$sql = "SELECT SUM(amount) as paymenttotal from " . $this->getTable() . " where purchase_no=" .$pn;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	
}
?>

