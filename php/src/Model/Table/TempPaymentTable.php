<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class TempPaymentTable extends AbstractPaymentTable {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('temp_payment');
        $this->setPrimaryKey('paymentid');
    }

}
?>

