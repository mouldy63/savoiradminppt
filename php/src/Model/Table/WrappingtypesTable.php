<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class WrappingtypesTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('wrappingtypes');
        $this->setPrimaryKey('WrappingID');
    }
    public function getWrappingTypes() {
    	$myconn = ConnectionManager::get('default');
    	$sql = "select * FROM wrappingtypes  order by wrappingID asc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
}
?>