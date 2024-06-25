<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class TickingTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('ticking');
        $this->setPrimaryKey('tickingID');
    }
	
	public function getTicking() {
    	$sql = "Select * from ticking where retired='n'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
}

?>