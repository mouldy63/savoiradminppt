<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ExportLinksTable extends AbstractExportLinksTable {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('exportlinks');
        $this->setPrimaryKey('exportLinksID');
        $this->belongsTo('ExportCollShowroom')->setForeignKey('LinksCollectionID')->setJoinType('LEFT')->setBindingKey('exportCollshowroomsID');
        $this->belongsTo('Purchase')->setForeignKey('purchase_no')->setJoinType('LEFT')->setBindingKey('purchase_No');
    }

}
?>