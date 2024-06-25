<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class CustomerServiceUploadTable extends Table {
    //public $name = 'CustomerService';

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('customerserviceuploads');
        $this->setPrimaryKey('csuip');
        //$this->belongsTo('SavoirUser')->setForeignKey('noteaddedby')->setJoinType('LEFT')->setBindingKey('user_id');
    }
}
?>