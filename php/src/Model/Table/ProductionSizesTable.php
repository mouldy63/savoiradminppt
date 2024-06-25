<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class ProductionSizesTable extends AbstractProductionSizesTable {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('productionsizes');
        $this->setPrimaryKey('ProductionSizesID');
    }
    
}
?>