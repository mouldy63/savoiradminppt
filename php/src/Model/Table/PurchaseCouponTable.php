<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \App\Controller\Component\UtilityComponent;
use Cake\ORM\TableRegistry;

class PurchaseCouponTable extends Table {
	 private $myconn;
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase_coupon');
        $this->setPrimaryKey('purchase_coupon_id');
        $this->myconn = ConnectionManager::get('default');
    }
    
    public function getCouponInfoMonth($month, $year) {
        $sql = "select * from purchase p, purchase_coupon pc, contact c";
        $sql .= " where p.contact_no=c.CONTACT_NO AND p.PURCHASE_No=pc.purchase_no and YEAR(ORDER_DATE) = " . $year . " and MONTH(ORDER_DATE) = " . $month ."";
        $sql .= " and orderSource <> 'Test' and quote = 'n' and orderonhold = 'n' and (cancelled is null OR cancelled <> 'y')";
        return $this->myconn->execute($sql)->fetchAll('assoc');
    }
    
}
?>
