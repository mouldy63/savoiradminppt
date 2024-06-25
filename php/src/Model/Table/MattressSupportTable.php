<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class MattressSupportTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('mattresssupport');
        $this->setPrimaryKey('supportID');
    }
	
    public function getSupport() {
            $sql = "Select * from mattresssupport where  retired='n'";
            $myconn = ConnectionManager::get('default');
            return $myconn->execute($sql)->fetchAll('assoc');
    }	
}

?>