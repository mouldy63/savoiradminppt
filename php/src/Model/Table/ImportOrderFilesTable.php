<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;


class ImportOrderFilesTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('import_order_files');
        $this->setPrimaryKey('ibrf_id');
    }
}
?>