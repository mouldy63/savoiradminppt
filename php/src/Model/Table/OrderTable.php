<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class OrderTable extends AbstractOrderTable {
    
    public function initialize(array $config) : void {
        $this->setTable('purchase');
        $this->setPrimaryKey('purchase_no');
    }

}
?>