<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class PackagingDataTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('packagingdata');
        $this->setPrimaryKey('PackagingDataID');
    }

    public function getStandAloneAccessoriesCount($pn) {
    	$sql = "select count(*) as n from packagingdata where purchase_no=:pn and componentid=9 and (packedwith is null or packedwith = '0')";
    	$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['pn' => $pn]);
		$count = 0;
		foreach ($rs as $row) {
			$count = $row['n'];
		}
		return $count;
    }

    /**
     * Gets the data from the orderaccessory and packagingdata tables for each set of accessories for the order. A set is those that will be boxed together
     * i.e. a standalone accessory (packedwith not set), and those packed with it.
     */
    public function getAccessoriesSetsForBoxes($pn) {
    	$myconn = ConnectionManager::get('default');
    	$sql = "select * FROM packagingdata pd join orderaccessory oa on pd.comppartno=oa.orderaccessory_id and pd.componentid=9 and (pd.packedwith is null or pd.packedwith='0') and oa.purchase_no=:pn";
		$rs = $myconn->execute($sql, ['pn' => $pn]);
		$accessorySets = [];
		$n = 0;
		foreach ($rs as $row) {
			$rows = [];
			$m = 0;
			$rows[$m++] = $row;
	    	$sql = "select * FROM packagingdata pd join orderaccessory oa on pd.comppartno=oa.orderaccessory_id and pd.componentid=9 and pd.packedwith=:pw and oa.purchase_no=:pn";
			$rs2 = $myconn->execute($sql, ['pw' => '9-'.$row['orderaccessory_id'], 'pn' => $pn]);
			foreach ($rs2 as $row2) {
				$rows[$m++] = $row2;
			}
			
			$accessorySets[$n] = $rows;
			$n++;
		}
		return $accessorySets;
    }

    public function accessoryHasValancePackedWithIt($pn, $orderAccessoryId) {
    	$myconn = ConnectionManager::get('default');
    	$sql = "select 1 FROM packagingdata pd where pd.componentid=6 and pd.purchase_no=:pn and pd.packedwith=:pw";
		$rs = $myconn->execute($sql, ['pn' => $pn, 'pw' => '9-'.$orderAccessoryId]);
		return (count($rs) > 0);
    }
}
?>