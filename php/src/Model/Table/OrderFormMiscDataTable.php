<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class OrderFormMiscDataTable extends Table {

	public function getShipperAddresses(&$defAddressId) {
		$sql = "select shipper_ADDRESS_ID,shipperName,TOWN,ISDEFAULT from shipper_address order by shippername desc";
		$myconn = ConnectionManager::get('default');
		$query = $myconn->execute($sql);
		$list = [];
		foreach ($query as $row) {
			if ($row['ISDEFAULT'] == 'y') $defAddressId = $row['shipper_ADDRESS_ID'];
			$list[$row['shipper_ADDRESS_ID']] = $row['shipperName'] . ', ' . $row['TOWN'];
		}
		return $list;
	}

	public function getVatRates($idLocation) {
		$sql = "select * from vatrate where retired='n' and idlocation=:idLocation and retired='n' order by seq desc";
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['idLocation' => $idLocation])->fetchAll('assoc');

		if (count($rs) == 0) {
			$rs = $myconn->execute($sql, ['idLocation' => 1])->fetchAll('assoc');
		}
		$list = [];
		$default = "";
		foreach ($rs as $row) {
			$list[(string)(float)$row['vatrate']] = number_format($row['vatrate'], 3) . "%";
			if ($row['isdefault'] == 'y') {
				$default = (string)(float)$row['vatrate'];
			}
		}
		return ['rates' => $list, 'def' => $default];
	}

	public function getLeadTimes() {
		$myconn = ConnectionManager::get('default');
		$sql = "Select count(*) as n from qc_history_latest Q, purchase P where P.purchase_no=Q.purchase_no and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=2 or Q.QC_StatusID=20) AND  P.orderonhold<>'y' and  (P.cancelled is Null or P.cancelled='n')";
		$rs = $myconn->execute($sql)->fetchAll('assoc');
		//debug($rs);
		$londonitems = $rs[0]["n"];
		//echo '<br>londonitems = ' . $londonitems;

		$sql = "Select count(*) as n from qc_history_latest Q, purchase P where P.purchase_no=Q.purchase_no and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=2 or Q.QC_StatusID=20) and P.code<>15919 AND  P.orderonhold<>'y'and (P.cancelled is Null or P.cancelled='n')";
		$rs = $myconn->execute($sql)->fetchAll('assoc');
		//debug($rs);
		$cardiffitems = $rs[0]["n"];
		//echo '<br>cardiffitems = ' . $cardiffitems;

		$sql = "Select NoItemsWeek, manufacturedatid from manufacturedat";
		$rs = $myconn->execute($sql)->fetchAll('assoc');
		//debug($rs);
		foreach ($rs as $row) {
			if ($row["manufacturedatid"] == 1) $cardiffNo = $row["NoItemsWeek"];
			if ($row["manufacturedatid"] == 2) $londonNo = $row["NoItemsWeek"];
		}
		//echo '<br>londonNo = ' . $londonNo;
		//echo '<br>cardiffNo = ' . $cardiffNo;

		$cardiffNo = round(floatval($cardiffitems)/floatval($cardiffNo)+0.5);
		$londonNo = round(floatval($londonitems)/floatval($londonNo)+0.5);
		if ($cardiffNo > $londonNo) {
			$longestLeadTime = $cardiffNo;
		} else {
			$longestLeadTime = $londonNo;
		}
		//echo '<br>londonNo = ' . $londonNo;
		//echo '<br>cardiffNo = ' . $cardiffNo;
		//echo '<br>longestLeadTime = ' . $longestLeadTime;
		return ['longest' => $longestLeadTime, 'london' => $londonNo, 'cardiff' => $cardiffNo];
	}

	public function getOrderShippingAddress($pn) {
		$sql = "select * from purchase_shipper where purchase_no=:pn";
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['pn' => $pn])->fetchAll('assoc');
		$data = [];
		if (count($rs) > 0) {
			$data = $rs[0];
		}
		return $data;
	}
}
?>