<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class CompPriceDiscountTable extends AbstractCompPriceDiscountTable {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('comp_price_discount');
        $this->setPrimaryKey('comp_price_discount_id');
    }
    
}
?>