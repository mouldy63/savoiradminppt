<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class bedoptionsTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('bedoptions');
        $this->setPrimaryKey('optionID');
    }
    public function getVentPosition() {
    	$sql = "Select * from bedoptions WHERE optionKey='Position'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    public function getOptionFinish() {
    	$sql = "Select * from bedoptions WHERE optionKey='Finish'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

    public function getBaseTrim() {
    	$sql = "Select * from bedoptions WHERE optionKey='trim'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

    public function getBaseTrimColour() {
    	$sql = "Select * from bedoptions WHERE optionKey='basetrimcolour'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

    public function getDrawerConfig() {
    	$sql = "Select * from drawerconfig";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

    public function getDrawerHeight() {
    	$sql = "Select * from drawerheight";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getUphBase() {
    	$sql = "Select * from  bedoptions WHERE optionKey='uphbase'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getBaseFabDirection() {
    	$sql = "Select * from  bedoptions WHERE optionKey='basefabdirection'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getLegs() {
    	$sql = "Select * from  bedoptions WHERE optionKey='legs'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getFloortype() {
    	$sql = "Select * from  bedoptions WHERE optionKey='floortype'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	public function getSupportleg() {
    	$sql = "Select * from  bedoptions WHERE optionKey='supportleg'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getHeadboards() {
    	$sql = "Select * from  bedoptions WHERE optionKey='headboard'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getHeadboardHeight() {
    	$sql = "Select * from  bedoptions WHERE optionKey='hbheight' order by seq asc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getFootboardHeight() {
    	$sql = "Select * from  bedoptions WHERE optionKey='footboardheight'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getFootboardFinish() {
    	$sql = "Select * from  bedoptions WHERE optionKey='footboardfinish'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getHbTrim() {
    	$sql = "Select * from  bedoptions WHERE optionKey='hbtrim'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getFabricOptions() {
    	$sql = "Select * from  bedoptions WHERE optionKey='fabricoptions'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getPleatNo() {
    	$sql = "Select * from  bedoptions WHERE optionKey='pleats'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
}
?>
