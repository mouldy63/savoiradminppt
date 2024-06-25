<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;


class CollectionStatusTable extends Table {
    //public $name = 'CustomerService';

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('collectionStatus');
        $this->setPrimaryKey('collectionStatusID');
        
        //$this->belongsTo('SavoirUser')->setForeignKey('noteaddedby')->setJoinType('LEFT')->setBindingKey('user_id');
    }
    
    
    public function getStatusList() {
    	$sql = "Select * from collectionstatus";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
}
?>