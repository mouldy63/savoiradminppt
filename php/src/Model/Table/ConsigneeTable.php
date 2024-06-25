<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ConsigneeTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('consignee_address');
        $this->setPrimaryKey('consignee_ADDRESS_ID');
    }
	
	public function listConsignees() {
    	$sql = "Select * from consignee_address order by consigneeName asc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
	public function getConsignee($consigneeid) {
    	$sql = "Select * from consignee_address where consignee_ADDRESS_ID=" .$consigneeid;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }	
	
}
?>
