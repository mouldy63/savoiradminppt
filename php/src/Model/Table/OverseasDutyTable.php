<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class OverseasDutyTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('overseas_duty');
        $this->setPrimaryKey('overseas_dutyID');
    }
}
?>