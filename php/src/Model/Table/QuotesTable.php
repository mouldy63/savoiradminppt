<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;
use Cake\Core\App;

class QuotesTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('PURCHASE_No');
    }
		
	public function getQuotes($security) {
		
		$sql = "Select * from address A, contact C, Purchase P Where C.retire='n' AND A.code=C.code AND C.CONTACT_NO=P.contact_no AND P.quote='y'";
		if (!$security->isSuperuser()) {
			$sql .= " AND A.owning_region=" .$security->getCurrentUserRegionId();
			if ($security->getCurrentUserLocationId()<>1 && $security->getCurrentUserLocationId()<>27 && $security->_userHasRole('ADMINISTRATOR,REGIONAL_ADMINISTRATOR')) {
				$sql .= " AND P.idlocation=" .$security->getCurrentUserLocationId();
			}
			$sql .= " AND A.source_site='SB'";
			
		}
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getDeclinedQuotes($security) {
		$sql = "Select * from address A, contact C, Purchase P Where C.retire='n' AND A.code=C.code AND C.code=P.code AND P.quote='d'";
		if (!$security->isSuperuser()) {
			$sql .= " AND A.owning_region=" .$security->getCurrentUserRegionId();
			if ($security->getCurrentUserLocationId()<>1 && $security->getCurrentUserLocationId()<>27 && $security->_userHasRole('ADMINISTRATOR,REGIONAL_ADMINISTRATOR')) {
				$sql .= " AND P.idlocation=" .$security->getCurrentUserLocationId();
			}
			$sql .= " AND A.source_site='SB'";
		}
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	

}
?>
