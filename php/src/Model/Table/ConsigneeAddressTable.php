<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class ConsigneeAddressTable extends Table {
    //public $name = 'Contact';
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('consignee_address');
        $this->setPrimaryKey('consignee_ADDRESS_ID');
        //$this->hasOne('Address')->setForeignKey('CODE')->setJoinType('INNER')->setBindingKey('CODE');
    }
}
?>