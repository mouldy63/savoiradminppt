<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class VappInputDataTable extends Table {
    //public $name = 'VappInputData';
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('vapp_input_data');
        $this->setPrimaryKey('vapp_input_data_id');
    }
}
?>