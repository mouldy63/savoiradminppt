<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ShipperTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('shipper_address');
        $this->setPrimaryKey('shipper_ADDRESS_ID');
    }
	
	public function listShippers() {
    	$sql = "Select * from shipper_address order by shipperName asc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
	public function getShipper($shipperid) {
    	$sql = "Select * from shipper_address where shipper_ADDRESS_ID=" .$shipperid;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }	
	
}
?>
