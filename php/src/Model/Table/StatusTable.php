<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class StatusTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('status');
        $this->setPrimaryKey('Status');
    }
	
	public function getStatusList() {
    	$sql = "Select * from status where retired='n' Order by seq, Status";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
}

?>