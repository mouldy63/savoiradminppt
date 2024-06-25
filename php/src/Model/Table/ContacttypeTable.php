<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ContacttypeTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('contacttype');
        $this->setPrimaryKey('ContactType');
    }
	
	public function getContactTypeList() {
    	$sql = "Select * from contacttype WHERE retired='n' Order by ContactType";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getContactTypeListAll() {
    	$sql = "Select * from contacttype Order by ContactType";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
}

?>