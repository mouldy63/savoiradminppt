<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ComponentTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('component');
        $this->setPrimaryKey('ComponentID');
    }

    public function getComponentWithChildren($compId) {
    	$sql = "select ComponentID, componentname from (";
		$sql .= "select ComponentID, componentname, seq from component where ParentComponentID=%u";
    	$sql .= " union";
    	$sql .= " select ComponentID, componentname, 99 as seq from component where ComponentID=%u";
    	$sql .= ") as t1 order by seq";
		$sql = sprintf($sql, $compId, $compId);
    	$myconn = ConnectionManager::get('default');
		$query = $myconn->execute($sql);
    	$list = [];
    	foreach ($query as $row) {
    		$list[$row['ComponentID']] = $row['componentname'];
    	}
    	return $list;
    }
    
    public function getComponentData() {
    	$query = $this->find();
        $query->order(['ComponentID' => 'ASC']);
    	
    	$names = [];
		foreach ($query as $row) {
			$names[$row['ComponentID']] = ['name' => $row['componentname'], 'id' => $row['ComponentID'], 'displayName' => $row['Component'], 'pricingType' => $row['pricing_type'], 'pricingData' => $row['pricing_data'], 'ParentComponentId' => $row['ParentComponentId']];
		}
		return $names;
    	
    }
}
?>