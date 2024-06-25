<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class CorrespondenceTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('correspondence');
        $this->setPrimaryKey('correspondenceid');
    }
	
	public function selectCorrespondenceItem($isSuperuser,$userRegion,$userLocation) {
    	$sql = "Select * from correspondence C, location L WHERE C.owning_location=L.idlocation";
		if (!$isSuperuser) {
			$sql.= " AND superuseramendonly='n' AND C.owning_region=" .$userRegion;
			if ($userRegion != 1) {
				$sql.= " AND C.owning_location=" .$userLocation;
			}
		}
		//debug($sql);
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
	public function getCorrespondenceListforRegion($userRegion,$userLocation) {
    	$sql = "Select * from correspondence C WHERE C.owning_region=".$userRegion;
			if ($userRegion != 1) {
				$sql.= " AND C.owning_location=" .$userLocation;
			}
		//debug($sql);
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }	
}
?>
