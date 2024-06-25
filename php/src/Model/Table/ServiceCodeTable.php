<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class ServiceCodeTable extends Table {
    //public $name = 'Contact';
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('service_code');
        $this->setPrimaryKey('servicecodeID');
        
    }
}
?>