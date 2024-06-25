<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ComponentTypeTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('componenttype');
        $this->setPrimaryKey('componentTypeID');
    }
	
	public function getCompType($component) {
    	$sql = "Select * from componenttype where componentID= ".$component." and retired='n'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
}

?>