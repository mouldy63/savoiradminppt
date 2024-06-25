<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class OrderDataTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('order_data');
        $this->setPrimaryKey('odid');
        $this->belongsTo('ComponentField')->setForeignKey('fieldname')->setBindingKey('fieldname');
    }
    
    public function getOrderDataForComponent($pn, $compId) {
    	$sql = "select cf.fieldname,cf.fieldtype,cf.datatype,od.strvalue,od.intvalue,od.dblvalue,od.datetimevalue";
    	$sql .= " from component_field cf join order_data od on cf.fieldname=od.fieldname and od.PURCHASE_No=:pn and od.ComponentID=:compId";
    	$sql = sprintf($sql, $pn, $compId);
    	$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['pn' => $pn, 'compId' => $compId])->fetchAll('assoc');
		return $rs;
    }
	
    public function getOrderDataForComponentAndChildren($pn, $compId) {
    	$sql = "select cf.fieldname,cf.fieldtype,cf.datatype,od.strvalue,od.intvalue,od.dblvalue,od.datetimevalue";
    	$sql .= " from component_field cf join order_data od on cf.fieldname=od.fieldname and od.PURCHASE_No=:pn and od.ComponentID in (select ComponentID from component where ComponentID=:compId or ParentComponentId=:compId)";
    	$sql = sprintf($sql, $pn, $compId);
    	$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['pn' => $pn, 'compId' => $compId])->fetchAll('assoc');
		return $rs;
    }

    public function getOrderData($pn) {
    	$sql = "select cf.fieldname,cf.fieldtype,cf.datatype,cf.srccolumn,cf.srccolumntype,od.strvalue,od.intvalue,od.dblvalue,od.datetimevalue";
    	$sql .= " from component_field cf join order_data od on cf.fieldname=od.fieldname and od.PURCHASE_No=:pn";
    	$sql = sprintf($sql, $pn);
    	$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['pn' => $pn])->fetchAll('assoc');
		return $rs;
    }

    public function getKeyedOrderData($pn) {
		$rs = $this->getOrderData($pn);
		$data = [];
		foreach ($rs as $row) {
			$data[$row['fieldname']] = $row;
		}
		return $data;
    }
}

?>