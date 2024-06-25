<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class PriceMatrixTypeTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('price_matrix_type');
        $this->setPrimaryKey('PRICE_TYPE_ID');
    }
    
     public function getCompTypeName($comp) {
		$sql = "select * from price_matrix_type";
		//debug($sql);
		//die;
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');	
    }
}
?>