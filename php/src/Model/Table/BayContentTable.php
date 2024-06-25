<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class BayContentTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('bay_content');
        $this->setPrimaryKey('bayContentId');
    }
	
}


?>