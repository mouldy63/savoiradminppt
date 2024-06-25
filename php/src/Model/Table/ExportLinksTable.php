<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class ExportLinksTable extends Table {
    //public $name = 'CustomerService';

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('exportlinks');
        $this->setPrimaryKey('exportLinksID');
        $this->belongsTo('ExportCollShowroom')->setForeignKey('LinksCollectionID')->setJoinType('LEFT')->setBindingKey('exportCollshowroomsID');
        $this->belongsTo('Purchase')->setForeignKey('purchase_no')->setJoinType('LEFT')->setBindingKey('purchase_No');
        //$this->belongsTo('location')->setForeignKey('idLocation')->setJoinType('LEFT')->setBindingKey('idlocation');
    }
}
?>