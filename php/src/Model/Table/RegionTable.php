<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class RegionTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('region');
        $this->setPrimaryKey('id_region');
    }
	
	public function getRegionCountryname($region) {
    	$sql = "Select country from region where id_region= ".$region."";
		$myconn = ConnectionManager::get('default');
		$row= $myconn->execute($sql)->fetchAll('assoc');
		return $row[0]['country'];
    }
	
}

?>