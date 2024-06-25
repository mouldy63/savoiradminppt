<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class AuxiliaryDataTable extends Table {
	
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('xtemp');
        $this->setPrimaryKey('xtemp_id'); // just dummy values
    }
    
	public function getData($sql, $params) {
	    $myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, $params);
		return $rs;
    }
	
	public function getDataArray($sql, $params) {
	    $myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, $params)->fetchAll('assoc');
		return $rs;
    }
}
?>