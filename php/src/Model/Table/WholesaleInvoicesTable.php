<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class WholesaleInvoicesTable extends AbstractWholesaleInvoicesTable {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('wholesale_invoices');
    }

}

?>