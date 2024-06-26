<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class DeliveryAddressTable extends Table {
    //public $name = 'Contact';
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('delivery_address');
        $this->setPrimaryKey('DELIVERY_ADDRESS_ID');
    }

    public function getDeliveryAddresses($contactno) {
    	$sql = "Select * from delivery_address WHERE CONTACT_NO=".$contactno." order by ISDEFAULT desc, retire asc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
	
	
}
?>
