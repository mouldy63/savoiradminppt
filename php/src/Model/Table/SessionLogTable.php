<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class SessionLogTable extends Table {
	//public $name = 'SessionLog';
	
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('sessionlog');
        $this->setPrimaryKey('sessionlog_id');
    }
}
?>