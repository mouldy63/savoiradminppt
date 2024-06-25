<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \App\Controller\Component\OrderHelperComponent;

class AbstractCompPriceDiscountTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
    }

    public function getDiscount($pn, $compId, $defaultPrice) {
	    return $this->doGetDiscount($pn, $compId, $defaultPrice, "");
    }

    public function doGetDiscount($pn, $compId, $defaultPrice, $orderAccessoryId) {
        $discount = [];
        $discount['pn'] = $pn;
        $discount['componentId'] = $compId;
        
        $sql = "select * from " . $this->getTable() . " where purchase_no=" . $pn . " and componentid=" . $compId;
        if (!empty($orderAccessoryId)) {
            $sql .= " and orderaccessory_id=" . $orderAccessoryId;
        }
        $myconn = ConnectionManager::get('default');
        $rs = $myconn->execute($sql)->fetchAll('assoc');
        if (count($rs) > 0) {
            $discount['compPriceDiscountId'] = $rs[0]["comp_price_discount_id"];
            $discount['discountType'] = $rs[0]["discounttype"];
            $discount['standardPrice'] = $rs[0]["standard_price"];
            $discount['discount'] = $rs[0]["discount"];
            $discount['price'] = $rs[0]["price"];
            if (!empty($orderAccessoryId)) {
                $discount['orderAccessoryId'] = $rs[0]["orderaccessory_id"];
            }
        } else {
            $discount['compPriceDiscountId'] = 0;
            $discount['discountType'] = "percent";
            $discount['standardPrice'] = 0.0;
            $discount['discount'] = 0.0;
            if (!empty($defaultPrice)) {
                $discount['price'] = $defaultPrice;
            } else {
                $discount['price'] = 0.0;
            }
        }
        return $discount;
    }

    public function upsertDiscount($pn, $compId, $type, $listPrice, $price) {
	    $this->doUpsertDiscount($pn, $compId, $type, $listPrice, $price, "");
    }

    public function doUpsertDiscount($pn, $compId, $type, $listPrice, $price, $orderAccessoryId) {
    	$discount = 0.0;
	    if ($price == "") $price = 0.0;
        if ($listPrice > 0.0) {
            if ($type == "percent") {
                $discount = 100.0 * (1.0 - $price / $listPrice);
            } else {
                $discount = $listPrice - $price;
            }
        }
        
        $conditions = ['purchase_no' => $pn, 'componentid' => $compId];
        if (!empty($orderAccessoryId)) {
            $conditions['orderaccessory_id'] = $orderAccessoryId;
        }
    	$rs = $this->find('all', ['conditions'=> $conditions])->toArray();
        $row = null;
    	if (count($rs) == 0) {
    		$row = $this->newEntity([]);
            $row->comp_price_discount_id = OrderHelperComponent::getNextPrimeKeyValForTable('comp_price_discount', 1);
    	} else {
    		$row = $rs[0];
    	}
        $row->componentid = $compId;
        $row->discounttype = $type;
        $row->standard_price = $listPrice;
        $row->discount = $discount;
        $row->price = $price;
        $row->purchase_no = $pn;
        if (!empty($orderAccessoryId)) {
            $row->orderaccessory_id = $orderAccessoryId;
        }
        $this->save($row);
    }

    public function deleteDiscount($pn, $compId) {
        $this->doDeleteDiscount($pn, $compId, "");
    }

    public function doDeleteDiscount($pn, $compId, $orderAccessoryId) {
        $sql = "delete from " . $this->getTable() . " where purchase_no=" . $pn . " and componentid=" . $compId;
        if (!empty($orderAccessoryId)) {
            $sql .=  " and orderaccessory_id=" . $orderAccessoryId;
        }
        $myconn = ConnectionManager::get('default');
        $myconn->execute($sql);
    }

}
?>