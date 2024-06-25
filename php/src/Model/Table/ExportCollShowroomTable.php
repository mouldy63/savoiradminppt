<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ExportCollShowroomTable extends Table {
    //public $name = 'CustomerService';

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('exportcollshowrooms');
        $this->setPrimaryKey('exportCollshowroomsID');
        $this->belongsTo('exportcollections')->setForeignKey('exportCollectionID')->setJoinType('LEFT')->setBindingKey('exportCollectionID');
        $this->belongsTo('location')->setForeignKey('idLocation')->setJoinType('LEFT')->setBindingKey('idlocation');
        $this->hasMany('ExportLinks')->setForeignKey('LinksCollectionID')->setJoinType('LEFT')->setBindingKey('exportCollshowroomsID');
    }
    
    public function removeCollection($cid, $location) {
    	$myconn = ConnectionManager::get('default');
    	$sql = "SELECT * from exportCollShowrooms where exportCollectionID=:cid and idlocation=:idlocation";
    	$rs = $myconn->execute($sql, ['cid' => $cid, 'idlocation' => $location]);
    	if ($rs->count() == 0) {
    		return ['count' => 0, 'items' => null];
    	};
    	
    	$row = $rs->fetchAssoc();
    	$sql2 = "SELECT P.ORDER_NUMBER, P.PURCHASE_No from exportLinks E, purchase P where E.purchase_no=P.purchase_no and Linkscollectionid=:Linkscollectionid group by E.purchase_no";
    	$rs2 = $myconn->execute($sql2, ['Linkscollectionid' => $row['exportCollshowroomsID']]);
    	if ($rs2->count() == 0) {
    		$sql="DELETE from exportCollShowrooms where exportCollectionID=:cid and idlocation=:idlocation";
    		$myconn->execute($sql, ['cid' => $cid, 'idlocation' => $location]);
    		return ['count' => count($pns), 'items' => null];
    	} 
    	
    	$pns = [];
    	foreach ($rs2 as $row) {
    		$pns[$row["PURCHASE_No"]] = $row["ORDER_NUMBER"];
    	}
    	return ['count' => count($pns), 'items' => $pns];
    }

}
?>