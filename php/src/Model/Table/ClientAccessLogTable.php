<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class ClientAccessLogTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('clientaccesslog');
        $this->setPrimaryKey('clientaccesslog_id');
    }
}
?>