<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class PriceMatrixMappingTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('price_matrix_mapping');
        $this->setPrimaryKey('pricematrixmappingid');
    }

    public function getMappingData($compId) {
        $query = $this->find();
        $query = $query->where(['ComponentID' => $compId]);
        $row = $query->first();
        return $row->toArray();
    }
}
?>