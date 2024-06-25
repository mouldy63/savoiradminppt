<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class VatRateTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('vatrate');
        $this->setPrimaryKey('vatrate_id');
    }

    public function getVatRates($idlocation) {
    	$myconn = ConnectionManager::get('default');
    	$sql = "select * FROM vatrate where idlocation=" .$idlocation ." and retired='n' order by isdefault='y' desc, seq asc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
}

?>