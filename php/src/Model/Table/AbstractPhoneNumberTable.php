<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class AbstractPhoneNumberTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('phonenumber');
        $this->setPrimaryKey('phonenumber_id');
    }

	public function getNumbersForPurchase($pn) {
    	$query = $this->find('all', ['conditions'=> ['purchase_no' => $pn], 'order'=> ['seq' => 'asc']]);
    	$data = [];
    	foreach($query as $row) {
    		$data[$row['seq']] = $row;
    	}
    	return $data;
	}
	
	public function deleteNumbersForPurchase($pn) {
    	$myconn = ConnectionManager::get('default');
		$sql="DELETE from " . $this->getTable() . " where purchase_no=:pn";
		$myconn->execute($sql, ['pn' => $pn]);
	}

	public function getPhoneNoTypes() {
    	$myconn = ConnectionManager::get('default');
            $sql = "select typename from phonenumbertype where retired=0 order by seq";
        $myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

}
?>