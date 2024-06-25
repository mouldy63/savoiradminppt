<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class TempAccessoryTable extends AbstractAccessoryTable {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('temp_orderaccessory');
        $this->setPrimaryKey('orderaccessory_id');
    }

}
?>