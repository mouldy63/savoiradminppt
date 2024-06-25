<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;
use Cake\Core\App;

class ProductionListTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('PURCHASE_No');
  
    }
	
	public function getOrdersInProduction($cwc, $factory) {
		$sql = "select * from ("; 
		$sql .= "select PURCHASE_No,ORDER_NUMBER,orderSource,totalexvat,ordercurrency,paymentstotal,vatrate,c.first,c.surname,c.title,a.street1,a.street2,a.street3,a.town,a.county,a.postcode,a.country,a.PRICE_LIST";
		$sql .= ",company,adminheading,ORDER_DATE,productiondate,bookeddeliverydate,deliveryadd1,deliveryadd2,deliveryadd3,deliverytown,deliverycounty,deliverypostcode,deliverycountry";
		$sql .= ",mattressrequired,legsrequired,baserequired,headboardrequired,topperrequired,valancerequired";
		$sql .= ",basesavoirmodel,savoirmodel,headboardstyle,legstyle,toppertype,valancefabric,valancefabricchoice";
		$sql .= " , (Select MadeAt from qc_history_latest h where h.ComponentID=1 AND h.Purchase_No=P.PURCHASE_No and h.MadeAt is not null and h.MadeAt<> 0) as matt_madeat";
		$sql .= " , (Select MadeAt from qc_history_latest h where h.ComponentID=3 AND h.Purchase_No=P.PURCHASE_No and h.MadeAt is not null and h.MadeAt<> 0) as base_madeat";
		$sql .= " , (Select MadeAt from qc_history_latest h where h.ComponentID=5 AND h.Purchase_No=P.PURCHASE_No and h.MadeAt is not null and h.MadeAt<> 0) as topper_madeat";
		$sql .= " , (Select MadeAt from qc_history_latest h where h.ComponentID=6 AND h.Purchase_No=P.PURCHASE_No and h.MadeAt is not null and h.MadeAt<> 0) as valance_madeat";
		$sql .= " , (Select MadeAt from qc_history_latest h where h.ComponentID=8 AND h.Purchase_No=P.PURCHASE_No and h.MadeAt is not null and h.MadeAt<> 0) as headboard_madeat";
		$sql .= " , (Select MadeAt from qc_history_latest h where h.ComponentID=7 AND h.Purchase_No=P.PURCHASE_No and h.MadeAt is not null and h.MadeAt<> 0) as legs_madeat";
		$sql .= " , (Select QC_StatusID from qc_history_latest h where h.ComponentID=1 AND h.Purchase_No=P.PURCHASE_No) as matt_status";
		$sql .= " , (Select QC_StatusID from qc_history_latest h where h.ComponentID=3 AND h.Purchase_No=P.PURCHASE_No) as base_status";
		$sql .= " , (Select QC_StatusID from qc_history_latest h where h.ComponentID=5 AND h.Purchase_No=P.PURCHASE_No) as topper_status";
		$sql .= " , (Select QC_StatusID from qc_history_latest h where h.ComponentID=6 AND h.Purchase_No=P.PURCHASE_No) as valance_status";
		$sql .= " , (Select QC_StatusID from qc_history_latest h where h.ComponentID=8 AND h.Purchase_No=P.PURCHASE_No) as headboard_status";
		$sql .= " , (Select QC_StatusID from qc_history_latest h where h.ComponentID=7 AND h.Purchase_No=P.PURCHASE_No) as legs_status";
		$sql .= " , (Select QC_StatusID from qc_history_latest h where h.ComponentID=0 AND h.Purchase_No=P.PURCHASE_No) as order_status";
		
		$sql .= " from address A, contact C, Purchase P";
		$sql .= ", Location L";
		$sql .= " Where P.PURCHASE_No IN (SELECT Distinct Purchase_No FROM qc_history_latest) and (P.cancelled is null or P.cancelled <> 'y') AND A.CODE=C.CODE AND C.CONTACT_NO=P.contact_no AND P.completedorders='n' AND (P.quote='n' or P.quote is null) AND  P.orderonhold<>'y' ";
		$sql .= " AND P.idlocation=L.idlocation ";
		$sql .= " AND P.SOURCE_SITE='SB' ";
		//' order status must be 'awaiting confirmation', 'on order', 'in production', 'order on hold', 'part delivered'
		$sql .= ") as x";
		if ($cwc=='y') {
			$sql .= " where ((x.matt_madeat=".$factory." or x.matt_madeat is null) and x.matt_status=2)";
			$sql .= " or ((x.base_madeat=".$factory." or x.base_madeat is null) and x.base_status=2)";
			$sql .= " or ((x.topper_madeat=".$factory." or x.topper_madeat is null) and x.topper_status=2)";
			$sql .= " or ((x.headboard_madeat=".$factory." or x.headboard_madeat is null) and x.headboard_status=2)";
			$sql .= " or ((x.legs_madeat=".$factory." or x.legs_madeat is null) and x.legs_status=2)";
			$sql .= " or ((x.valance_madeat=".$factory." or x.valance_madeat is null) and x.valance_status=2)";
		} else {
			$sql .= " where x.order_status in (0,2,4,10,20,90,130)";
			if ($factory != -1 && $factory != '') {
				if ($factory == 0) {
				//unassigned
					$sql .= " and ((mattressrequired='y' and (x.matt_madeat is null OR x.matt_madeat=0)) OR (baserequired='y' and (x.base_madeat is null OR x.base_madeat=0)) OR (topperrequired='y' and (x.topper_madeat is null OR x.topper_madeat=0)) OR (headboardrequired='y' and (x.headboard_madeat is null OR x.headboard_madeat=0)) OR (legsrequired='y' and (x.legs_madeat is null OR x.legs_madeat=0)) OR (valancerequired='y' and (x.valance_madeat is null OR x.valance_madeat=0)))";
				} else {
					$sql .= " and (x.matt_madeat=".$factory." OR x.base_madeat=".$factory." OR x.topper_madeat=".$factory." OR x.headboard_madeat=".$factory." OR x.legs_madeat=".$factory." OR x.valance_madeat=".$factory.")";
				}
			
			}
			
		
		} //cwc
		$sql .= " order by CAST(ORDER_NUMBER as decimal) asc";
		//debug($sql);
		//die;
				
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
    
    public function getBookedDeliveries($factory) {
		$sql = "select c.first,c.surname,c.title, A.company, P.customerreference, P.productiondate, P.PURCHASE_No, P.ORDER_NUMBER, P.CardiffProductionDate, P.LondonProductionDate, L.adminheading, P.savoirmodel, P.basesavoirmodel, P.toppertype, P.headboardstyle, P.legstyle, P.headboardrequired, P.mattressrequired, P.baserequired, P.topperrequired, P.legsrequired from address A, contact C, Purchase P, Location L Where P.CODE=A.CODE AND C.CONTACT_NO=P.contact_no AND P.completedorders='n' AND P.quote='n' and P.orderonhold<>'y' and (P.cancelled is Null or P.cancelled='n') AND P.productiondate<>'' AND P.".$factory."<>'' AND P.SOURCE_SITE='SB' and P.idlocation=L.idlocation order by P.".$factory." asc, P.ORDER_NUMBER asc ";
				
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
    
    public function getProductionFloorItems($factory) {
		$sql = "Select ProductionFloorNoItems from manufacturedat where ManufacturedAtId=".$factory;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc')[0]['ProductionFloorNoItems'];
		
    }  

}
?>