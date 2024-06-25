<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class PaymentTable extends AbstractPaymentTable {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('payment');
        $this->setPrimaryKey('paymentid');
    }

}
?>

