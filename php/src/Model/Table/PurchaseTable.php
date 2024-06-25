<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class PurchaseTable extends AbstractPurchaseTable {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('PURCHASE_No');
        $this->hasOne('Contact')->setForeignKey('CONTACT_NO')->setJoinType('INNER')->setBindingKey('contact_no');
        $this->hasOne('Location')->setForeignKey('idlocation')->setJoinType('INNER')->setBindingKey('idlocation');
    }
}
?>
