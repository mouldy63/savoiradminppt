<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class PriceListTable extends Table {
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('pricelist');
        $this->setPrimaryKey('PriceList');
    }
	
	public function getDefaultPriceListForLocation($locationids) {
    	$sql = "select PriceList from pricelist where DEFAULT_FOR_LOC_IDS like '%,".$locationids.",%'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    public function getPriceList() {
    	$sql = "select * from pricelist where retired='N'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
}
?>
