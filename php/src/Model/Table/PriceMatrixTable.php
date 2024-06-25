<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class PriceMatrixTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('price_matrix');
        $this->setPrimaryKey('PRICE_MATRIX_ID');
    }

    public function getMatrixPrice($compId, $priceTypeName, $dim1, $dim2, $dim3, $currency, $compIdSet1, $compIdSet2) {
		$wholesaleCol = $currency . "_wholesale";
		$sql = "select " . $currency . ", ex_works_revenue, " . $wholesaleCol . " from price_matrix_type t, price_matrix p";
	
		if (!empty($compIdSet1)) {
			$sql .= ", price_matrix_type t1";
		}
		
		if (!empty($compIdSet2)) {
			$sql .= ", price_matrix_type t2";
		}
		
		$sql .= " where t.price_type_id=p.price_type_id";
		$sql .= " and t.name='" . $priceTypeName . "' and p.componentid=" . $compId;
		
		if (!empty($compIdSet1)) {
			$sql .= " and p.compid_set1=" . $compIdSet1;
		} else {
			$sql .= " and p.compid_set1 is null";
		}
		
		if (!empty($compIdSet2)) {
			$sql .= " and p.compid_set2=" . $compIdSet2;
		} else {
			$sql .= " and p.compid_set2 is null";
		}
		
		if (!empty($dim1)) {
			$sql .= " and p.dim1='" . trim($dim1) . "'";
		} else {
			$sql .= " and p.dim1 is null";
		}
	
		if (!empty($dim2)) {
			$sql .= " and p.dim2='" . trim($dim2) . "'";
		} else {
			$sql .= " and p.dim2 is null";
		}
		
		if (!empty($dim3)) {
			$sql .= " and p.dim3='" . trim($dim3) . "'";
		} else {
			$sql .= " and p.dim3 is null";
		}
		
		//debug($sql);
		$myconn = ConnectionManager::get('default');
		$data = $myconn->execute($sql)->fetchAll('assoc');	
		//debug($data);
		
		$prices = [];
		if (isset($data) && count($data) > 0) {
			$prices['listPrice'] = $data[0][$currency];
			$prices['exWorksRevenue'] = $data[0]['ex_works_revenue'];
			$prices['wholesalePrice'] = $data[0][$currency . '_wholesale'];
		} else {
			$prices['listPrice'] = -1.00;
			$prices['exWorksRevenue'] = -1.00;
			$prices['wholesalePrice'] = -1.00;
		}
		
		return $prices;
    }
    
    public function getFullTableForExport() {
		$sql = "select t.name as PriceType, c.component as Component,";
		$sql .= " t.dim1_name as Dimension1Name, p.dim1 as Dimension1, t.dim2_name as Dimension2Name, p.dim2 as Dimension2,";
		$sql .= " c1.component as SetComponent1, c2.component as SetComponent2,";
		$sql .= " p.gbp as RetailGBP, p.usd as RetailUSD, p.eur as RetailEUR, p.gbp_wholesale as WholesaleGDP, p.usd_wholesale as WholesaleUSD, p.eur_wholesale as WholesaleEUR,";
		$sql .= " p.ex_works_revenue as ExWorksRevenue";
		$sql .= " from price_matrix_type t join price_matrix p on t.price_type_id=p.price_type_id";
		$sql .= " join component c on p.componentid=c.componentid";
		$sql .= " left join component c1 on p.compid_set1=c1.componentid";
		$sql .= " left join component c2 on p.compid_set2=c2.componentid";
		$sql .= " order by p.componentid, p.price_matrix_id";
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');	
    }
    
    public function getFullTableForExportbyComp($comp) {
		$sql = "select p.PRICE_MATRIX_ID, t.name as PriceType, c.component as Component,";
		$sql .= " t.dim1_name as Dimension1Name, p.dim1 as Dimension1, t.dim2_name as Dimension2Name, p.dim2 as Dimension2, t.dim3_name as Dimension3Name, p.dim3 as Dimension3,";
		$sql .= " p.compid_set1 as SetComponent1, p.compid_set2 as SetComponent2,";
		$sql .= " p.gbp as RetailGBP, p.usd as RetailUSD, p.eur as RetailEUR, p.gbp_wholesale as WholesaleGDP, p.usd_wholesale as WholesaleUSD, p.eur_wholesale as WholesaleEUR,";
		$sql .= " p.ex_works_revenue as ExWorksRevenue,";
		$sql .= " t.price_type_id, p.price_matrix_id, p.componentid";
		$sql .= " from price_matrix_type t join price_matrix p on t.price_type_id=p.price_type_id";
		$sql .= " join component c on p.componentid=c.componentid";
		if ($comp != '') {
			$sql .= " where p.componentid=" .$comp;
		}
		$sql .= " order by p.componentid, p.price_matrix_id";
		//debug($sql);
		//die;
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');	
    }
}
?>