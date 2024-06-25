<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class PaymentMethodTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('paymentmethod');
        $this->setPrimaryKey('paymentmethodid');
    }
	
}
?>

