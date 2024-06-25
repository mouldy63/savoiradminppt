<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ComponentdataTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('componentdata');
        $this->setPrimaryKey('COMPONENTDATA_ID');
    }
	
	public function listComponentData() {
    	$sql = "Select C.COMPONENTNAME, X.component, C.WEIGHT, C.TARIFFCODE, C.DEPTH, C.COMPONENTDATA_ID from componentdata C, component X where C.COMPONENTID=X.ComponentID order by X.componentid asc, C.componentname asc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getComponentdata($componentdataid) {
    	$sql = "Select C.COMPONENTNAME, X.Component, C.WEIGHT, C.TARIFFCODE, C.DEPTH, C.COMPONENTDATA_ID from componentdata C, component X where C.COMPONENTID=X.ComponentID and COMPONENTDATA_ID=" .$componentdataid;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
	
	public function getComponentSpecs($componentname, $compid) {
    	$sql = "Select* from componentdata where COMPONENTID=" .$compid ." and COMPONENTNAME like '" .$componentname ."'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
	
	public function getAccPackedwithdata($pn, $compartno) {
		$sql = "Select oa.description, pd.packtariffcode, oa.qty, oa.QtyToFollow, oa.unitprice";
		$sql .= " from packagingdata pd join orderaccessory oa on pd.CompPartNo=oa.orderaccessory_id and pd.ComponentID=9 and pd.Purchase_no=75953 and pd.PackedWith like '9-6422'";
		$sql .= " union";
		$sql .= " Select 'Valance' as description, cd.tariffcode as packtariffcode, 1 as qty, 0 as QtyToFollow, p.valanceprice as unitprice";
		$sql .= " from packagingdata pd join purchase p on pd.Purchase_no=p.Purchase_no and pd.ComponentID!=9 and pd.Purchase_no=75953 and pd.PackedWith like '9-6422'";
		$sql .= " join componentdata cd on cd.ComponentID=pd.ComponentID";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getPackagingdata($pn, $compid) {
    	$sql = "Select * from packagingdata where Purchase_no=" .$pn ." and ComponentID like '" .$compid ."'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
	
	public function getSmallBoxData() {
    	$sql = "Select * from shippingbox where sName='Small'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getComponentList() {
    	$sql = "Select * from component order by componentid asc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }

	public function getModelNames($compid) {
    	$sql = "Select * from componentdata where COMPONENTID=".$compid;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

		
	
}
?>
