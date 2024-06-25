<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class TempWholesalePricesTable extends AbstractWholesaleInvoicesTable {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('temp_wholesale_prices');
    }

}
?>