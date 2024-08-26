<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;


class TempBatchEmailTable extends AbstractBatchEmailTable {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('temp_batchemail');
        $this->setPrimaryKey('batchemail_id');
    }
}
?>