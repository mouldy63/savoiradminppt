<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class ClientAccessTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('clientaccess');
        $this->setPrimaryKey('clientaccess_id');
    }
}
?>