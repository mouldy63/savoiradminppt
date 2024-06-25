<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class DeliveryTermsTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('deliveryterms');
        $this->setPrimaryKey('deliveryTermsID');
    }
    
    
    public function listDelTerms() {
    	$sql = "Select * from deliveryterms";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
}
?>