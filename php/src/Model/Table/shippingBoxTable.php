<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ShippingBoxTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('shippingbox');
        $this->setPrimaryKey('ShippingBoxID');
    }
	
	public function getSmallBoxData() {
    	$sql = "Select * from shippingbox where sName='Small'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getMediumBoxData() {
    	$sql = "Select * from shippingbox where sName='Medium'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getLargeBoxData() {
    	$sql = "Select * from shippingbox where sName='Large'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getLegBoxData() {
    	$sql = "Select * from shippingbox where sName='LegBox'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getWoodCrateData() {
    	$sql = "Select * from shippingbox where sName='WoodenCrates'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getInternalCrateData() {
    	$sql = "Select * from shippingbox where sName='InternalCrate'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getAdditionalCrateData() {
    	$sql = "Select * from shippingbox where sName='AdditionalCrate'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getRoundToNearestData() {
    	$sql = "Select * from shippingbox where sName='RoundCrate'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getHCAData() {
    	$sql = "Select * from shippingbox where sName='HCaTopper'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getStateHCAData() {
    	$sql = "Select * from shippingbox where sName='StateHCaTopper'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getHWData() {
    	$sql = "Select * from shippingbox where sName='HWTopper'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getCWData() {
    	$sql = "Select * from shippingbox where sName='CWTopper'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getExpakMBData() {
    	$sql = "Select * from shippingbox where sName='Expak MB'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getExpakTData() {
    	$sql = "Select * from shippingbox where sName='Expak T'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getExpak1MData() {
    	$sql = "Select * from shippingbox where sName='Expak 1M'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getExpakHData() {
    	$sql = "Select * from shippingbox where sName='Expak H'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
		
	
}
?>
