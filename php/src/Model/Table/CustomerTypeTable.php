<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class CustomerTypeTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('customertype');
        $this->setPrimaryKey('customerTypeID');
    }
    public function getCustomerTypeList() {
    	$sql = "Select * from customertype Order by CustomerTypeID";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
}
?>
