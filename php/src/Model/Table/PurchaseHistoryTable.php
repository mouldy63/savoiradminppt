<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class PurchaseHistoryTable extends Table {
    
    public function initialize(array $config) : void {
        $this->setTable('purchase_history');
        $this->setPrimaryKey('purchasehistoryid');
    }

}
?>