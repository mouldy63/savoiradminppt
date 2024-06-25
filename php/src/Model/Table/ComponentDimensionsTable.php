<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ComponentDimensionsTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('componentdimensions');
        $this->setPrimaryKey('componentdimID');
    }
	
	public function getCompWidths($region) {
    	$sql = "Select * from componentdimensions where compwidth='y' and retired='n'";
        if ($region != 4 && $region != 23 && $region != 27) {
            $sql .= " and region1=0"; 
        }
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

    public function getCompLengths($region) {
    	$sql = "Select * from componentdimensions where complength='y' and retired='n'";
        if ($region != 4 && $region != 23 && $region != 27) {
            $sql .= " and region1=0"; 
        }
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
}

?>