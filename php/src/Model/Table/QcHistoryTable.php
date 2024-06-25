<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class QcHistoryTable extends AbstractQcHistoryTable {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('qc_history');
        $this->setPrimaryKey('QC_HistoryID');
        $this->belongsTo('QcStatus')->setForeignKey('QC_StatusID')->setJoinType('LEFT')->setBindingKey('QC_statusID');
    }

}
?>