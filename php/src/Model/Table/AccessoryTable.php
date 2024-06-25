<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class AccessoryTable extends AbstractAccessoryTable {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('orderaccessory');
        $this->setPrimaryKey('orderaccessory_id');
    }

}
?>