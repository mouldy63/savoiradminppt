<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class CustomerServiceNotesTable extends Table {
    //public $name = 'CustomerService';

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('customerservicenotes');
        $this->setPrimaryKey('csnotesid');
        $this->belongsTo('SavoirUser')->setForeignKey('noteaddedby')->setJoinType('LEFT')->setBindingKey('user_id');
    }
}
?>