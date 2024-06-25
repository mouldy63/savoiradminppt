<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class InterestproductsTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('interestproducts');
        $this->setPrimaryKey('id');
    }
	
	public function getinterestproductsList() {
    	$sql = "Select * from interestproducts WHERE SOURCE_SITE='SB'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
}

?>