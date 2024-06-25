<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class TempPurchaseTable extends AbstractPurchaseTable {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('temp_purchase');
        $this->setPrimaryKey('PURCHASE_No');
    }
}
?>
