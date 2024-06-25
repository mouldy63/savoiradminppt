<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class CouponCodeMappingTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('coupon_code_mapping');
        $this->setPrimaryKey('cc_mapping_id');
    }
}
?>