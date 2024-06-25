<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class TempProductionSizesTable extends AbstractProductionSizesTable {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('temp_productionsizes');
        $this->setPrimaryKey('ProductionSizesID');
    }

}
?>