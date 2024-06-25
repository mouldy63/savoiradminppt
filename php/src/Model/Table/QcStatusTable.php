<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class QcStatusTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('qc_status');
        $this->setPrimaryKey('QC_statusID');
    }
}


?>