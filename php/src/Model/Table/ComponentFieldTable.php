<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ComponentFieldTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('component_field');
        $this->setPrimaryKey('fieldname');
        $this->hasMany('OrderData')->setForeignKey('fieldname')->setBindingKey('fieldname');
    }
    
	public function getRelatedSelectControlList($compId, $relationship) {
		// fetch the relationships where the child belongs to this compId - doesn't matter which component the parent belongs to
    	$sql = "select distinct fieldname_parent, fieldname_child from fieldoptrel";
		$sql .= " where fieldname_parent in (select fieldname from component_field where fieldtype='select')";
		$sql .= " and fieldname_child in (select fieldname from component_field where ComponentId=%u and fieldtype='select')";
		$sql .= " and reltype='%s'";
    	$sql = sprintf($sql, $compId, $relationship);
    	$myconn = ConnectionManager::get('default');
		$query = $myconn->execute($sql);
    	$list = [];
    	foreach ($query as $row) {
    		$list[$row['fieldname_child']] = $row['fieldname_parent'];
    	}
    	return $list;
	}

	public function getPriceAffectingFieldList($compId, $priceTableFields) {
		// fetch the relationships where the child belongs to this compId - doesn't matter which component the parent belongs to
		// include all order level price dependent fields so that when any component is enabled/disabled all the price tables are refreshed
    	$sql = "select cf.fieldname,cf.fieldtype,cf.extradata,c.componentname";
		$sql .= " from component_field cf join component c on c.ComponentId=cf.ComponentId";
    	$sql .= " and cf.pricing_field='y' and cf.pricing_table_field='%s'";
    	$sql .= " and cf.ComponentId in (select ComponentId from component where ParentComponentId=%u";
    	$sql .= " union select ComponentId from component where ComponentId=%u";
    	$sql .= " union select 0 from dual)";
    	$sql .= " order by cf.fieldname";
    	$sql = sprintf($sql, $priceTableFields, $compId, $compId);
    	$myconn = ConnectionManager::get('default');
	   	return $myconn->execute($sql)->fetchAll('assoc');
	}
}
?>