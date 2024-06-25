<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;


class ImportBrochureRequestFilesTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('import_brochure_request_files');
        $this->setPrimaryKey('ibrf_id');
    }
}
?>