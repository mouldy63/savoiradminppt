<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class RevenueTable extends Table {
    private $getRevenueQuery;
    private $getShowroomQuery;
    private $myconn;

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('PURCHASE_No');
        $this->myconn = ConnectionManager::get('default');
        
		$this->getRevenueQuery = "SELECT a.ORDER_DATE,a.ORDER_NUMBER,a.mattressrequired, a.topperrequired,a.valancerequired,a.baserequired,a.legsrequired,a.ordercurrency,a.vatrate, a.vat, a.total, a.completedorders, a.balanceoutstanding, a.purchase_no, ".
							"a.headboardrequired,a.accessoriesrequired, a.savoirmodel,a.basesavoirmodel,a.toppertype,a.deliverycharge,a.bedsettotal,a.discount,a.discounttype, a.ordercompletedDate, su.username, ".
							"COALESCE(a.topperprice,0) AS topper_sum, COALESCE(a.valanceprice,0) AS valance_sum, COALESCE(a.mattressprice,0) AS mattr_sum, ".
							"COALESCE(a.baseprice,0)+COALESCE(a.basetrimprice,0)+COALESCE(a.basedrawers,0)+COALESCE(a.basefabricprice,0)+ ".
							"COALESCE(a.upholsteryprice,0) AS base_sum, COALESCE(a.hbfabricprice,0)+COALESCE(a.headboardprice,0)+".
							"COALESCE(a.headboardtrimprice,0) AS hb_sum,COALESCE(a.legprice,0)+COALESCE(a.addlegprice,0) AS leg_sum,".
							"COALESCE(a.accessoriestotalcost,0) AS acce_sum,COALESCE(a.deliveryprice,0) AS delivery_sum,a.productiondate,a.production_completion_date,a.bookeddeliverydate,a.idlocation,a.companyname,".
							"b.surname,c.location,".
							"(select group_concat(p1.amount) from payment p1 where p1.purchase_no=a.purchase_no and p1.paymenttype!='Refund') as payments, ".
							"(select group_concat(p2.amount*-1) from payment p2 where p2.purchase_no=a.purchase_no and p2.paymenttype='Refund') as refunds, ".
                            "(Select CollectionDate from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=a.purchase_no and L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID limit 1) as CollectionDate, ".
                            "(SELECT count(distinct exportcollectionid) as lorrycount FROM exportlinks E, exportcollshowrooms L where E.linkscollectionid=L.exportCollshowroomsID and e.purchase_no=a.PURCHASE_No) as LorryCount ".
							"FROM purchase as a LEFT JOIN savoir_user AS su ON a.ordercompletedUser=su.user_id LEFT JOIN contact AS b ON a.contact_no=b.CONTACT_NO LEFT JOIN location AS c ".
							"on a.idlocation=c.idlocation WHERE a.quote != 'y' and (a.cancelled is null or a.cancelled = 'n') and a.ordersource != 'Test' and b.is_developer='n' AND b.contact_no<>319256 AND b.contact_no<>24188 and %s";
		$this->getShowroomQuery = "SELECT a.location,a.idlocation FROM location AS a WHERE retire<>'y' AND retire IS NOT NULL";
    }
	
	public function getRevenuesData($requirement){
		
		$whereClause = $this->_whereClauseCreator($requirement);

		$sql = sprintf($this->getRevenueQuery,$whereClause);
               $raw = $this->myconn->execute($sql)->fetchAll('assoc');
		$stantardArray = $this->_stantardArrayCreator($raw);
		return $stantardArray;
	}
	
	public function getRevenuesCSV($requirement){
		$stantardArray = $this->getRevenuesData($requirement);
		$csv = $this->_generateCSV($stantardArray);
		return $csv;
	}
	
	public function getShowroom(){
                $raw = $this->myconn->execute($this->getShowroomQuery)->fetchAll('assoc');
		$returnArray = array();
		foreach ($raw as $record){
			$temp['location'] = $record['location'];
			$temp['idlocation'] = $record['idlocation'];
			$returnArray[] = $temp;
		}
		return $returnArray;
	}
	private function _stantardArrayCreator($raw) {
        $returnArray = array();
        foreach ($raw as $r) {
            $temp['order date'] = date('Y-m-d', strtotime($r['ORDER_DATE']));
            if (!empty($r['production_completion_date'])) {
            $temp['production completion date'] = date('Y-m-d', strtotime($r['production_completion_date']));
            } else {
	            $temp['production completion date'] = '';
            }
            if (!empty($r['bookeddeliverydate'])) {
            $temp['delivery date'] = date('Y-m-d', strtotime($r['bookeddeliverydate']));
            } else {
	            $temp['delivery date'] = '';
            }
            if ($r['LorryCount'] == 1) {
                $temp['ex-works date'] = $r['CollectionDate'];
            } else if ($r['LorryCount'] > 1) {
                $temp['ex-works date'] = 'Split Shipment Dates';
            } else {
                $temp['ex-works date'] = 'TBA';
            }
            $temp['order number'] = $r['ORDER_NUMBER'];
            $temp['surname'] = utf8_encode($r['surname']);
            if (!empty($r['companyname'])) {
            $temp['company'] = utf8_encode($r['companyname']);
            } else {
            $temp['company'] = '';
            }
            
            $temp['showroom'] = $r['location'];
            $temp['currency'] = $r['ordercurrency'];
            $temp['discount'] = '';
             
            $temp['discountPercent'] = '';
            $afterVATRate = 1;
            $tempDiscoutRate = 1;

            if (!empty($r['vatrate']) && $r['vatrate'] > 0) {
                $afterVATRate = (float) ((float) $r['vatrate'] + 100) / 100;
            }

            $temp['vat'] = $r['vat'];
            $temp['vatrate'] = $r['vatrate'];
            
            $temp['total'] = round((float) $r['bedsettotal'] / $afterVATRate, 2);
            $temp['total After Discount'] = $temp['total'];
            

            if (!empty($r['discount'])) {
				if (strlen($r['discount']) > 0 && floatval($r['discount']) > 0.0) {
					if ($r['discounttype'] == 'currency') {
						$temp['discount'] = round((float) $r['discount'] / $afterVATRate, 2);
						$tempDiscoutRate = 1 - (float) $r['discount'] / (float) $r['bedsettotal'];
						$temp['discountPercent'] = (round((float) $r['discount'] / ((float) $r['bedsettotal']), 4) * 100);
					} else {
						$temp['discount'] = round(((float) $r['bedsettotal'] * (float) $r['discount'] / 100) / $afterVATRate, 2);
						$tempDiscoutRate = 1 - (float) $r['discount'] / 100;
						$temp['discountPercent'] = (float) $r['discount'];
					}
					$temp['total After Discount'] = $temp['total'] - $temp['discount'];
				}
			}
			$temp['total inc VAT'] = $r['total'];
			$temp['balance outstanding'] = $r['balanceoutstanding'];
			$temp['payments'] = $r['payments'];
			$temp['refunds'] = $r['refunds'];
            $temp['no1 mattress'] = '';
            $temp['no2 mattress'] = '';
            $temp['no3 mattress'] = '';
            $temp['no4 mattress'] = '';
            $temp['no4v mattress'] = '';
            $temp['no5 mattress'] = '';
            $temp['french mattress'] = '';
            $temp['state mattress'] = '';
            $temp['other mattress'] = '';
            if ($r['mattressrequired'] == 'y') {
                $mattr_sum = round($r["mattr_sum"] / $afterVATRate, 2);
                $mattr_sum = round($mattr_sum * $tempDiscoutRate, 2);

                switch ($r["savoirmodel"]) {
                    case 'No. 1':
                        $temp['no1 mattress'] = $mattr_sum;
                        break;
                    case 'No. 2':
                        $temp['no2 mattress'] = $mattr_sum;
                        break;
                    case 'No. 3':
                        $temp['no3 mattress'] = $mattr_sum;
                        break;
                    case 'No. 4':
                        $temp['no4 mattress'] = $mattr_sum;
                        break;
                    case 'No. 4v':
                        $temp['no4v mattress'] = $mattr_sum;
                        break;
                    case 'No. 5':
                        $temp['no5 mattress'] = $mattr_sum;
                        break;
                    case 'French Mattress':
                        $temp['french mattress'] = $mattr_sum;
                        break;
                    case 'State':
                        $temp['state mattress'] = $mattr_sum;
                        break;
                    default:
                        $temp['other mattress'] = $mattr_sum;
                }
            }
            $temp['no1 base'] = '';
            $temp['no2 base'] = '';
            $temp['no3 base'] = '';
            $temp['no4 base'] = '';
            $temp['no4v base'] = '';
            $temp['no5 base'] = '';
            $temp['savoir slim base'] = '';
            $temp['state base'] = '';
            $temp['surround base'] = '';
            $temp['pegboard'] = '';
            $temp['platform base'] = '';
            $temp['other base'] = '';
            if ($r['baserequired'] == 'y') {
                $base_sum = round($r["base_sum"] / $afterVATRate, 2);
                $base_sum = round($base_sum * $tempDiscoutRate, 2);
                switch ($r["basesavoirmodel"]) {
                    case 'No. 1':
                        $temp['no1 base'] = $base_sum;
                        break;
                    case 'No. 2':
                        $temp['no2 base'] = $base_sum;
                        break;
                    case 'No. 3':
                        $temp['no3 base'] = $base_sum;
                        break;
                    case 'No. 4':
                        $temp['no4 base'] = $base_sum;
                        break;
                    case 'No. 4v':
                        $temp['no4v base'] = $base_sum;
                        break;
                    case 'No. 5':
                        $temp['no5 base'] = $base_sum;
                        break;
                    case 'Savoir Slim':
                        $temp['savoir slim base'] = $base_sum;
                        break;
                    case 'State':
                        $temp['state base'] = $base_sum;
                        break;
                    case 'Surround':
                        $temp['surround base'] = $base_sum;
                        break;
                    case 'Pegboard':
                        $temp['pegboard'] = $base_sum;
                        break;
                    case 'Platform Base':
                        $temp['platform base'] = $base_sum;
                        break;
                    default:
                        $temp['other base'] = $base_sum;
                }
            }
            $temp['hw topper'] = '';
            $temp['hca topper'] = '';
            $temp['cw topper'] = '';
            $temp['cfv topper'] = '';
            if ($r['topperrequired'] == 'y') {
                $topper_sum = round($r["topper_sum"] / $afterVATRate, 2);
                $topper_sum = round($topper_sum * $tempDiscoutRate, 2);
                switch ($r["toppertype"]) {
                    case 'HW Topper':
                        $temp['hw topper'] = $topper_sum;
                        break;
                    case 'HCa Topper':
                        $temp['hca topper'] = $topper_sum;
                        break;
                    case 'CW Topper':
                        $temp['cw topper'] = $topper_sum;
                        break;
                    case 'CFv Topper':
                        $temp['cfv topper'] = $topper_sum;
                        break;
                }
            }
            $temp['valance'] = '';
            if ($r['valancerequired'] == 'y') {
                $temp['valance'] = round($r["valance_sum"] / $afterVATRate, 2);
                $temp['valance'] = round($temp['valance'] * $tempDiscoutRate, 2);
            }

            $temp['headboard'] = '';
            if ($r['headboardrequired'] == 'y') {
                $temp['headboard'] = round($r["hb_sum"] / $afterVATRate, 2);
                $temp['headboard'] = round($temp['headboard'] * $tempDiscoutRate, 2);
            }
            $temp['leg'] = '';
            if ($r['legsrequired'] == 'y') {
                $temp['leg'] = round($r["leg_sum"] / $afterVATRate, 2);
                $temp['leg'] = round($temp['leg'] * $tempDiscoutRate, 2);
            }
            $temp['accessories'] = '';
            if ($r['accessoriesrequired'] == 'y') {
                $temp['accessories'] = round($r["acce_sum"] / $afterVATRate, 2);
                $temp['accessories'] = round($temp['accessories'] * $tempDiscoutRate, 2);
            }
            $temp['delivery'] = '';
            if ($r['deliverycharge'] == 'y') {
                $temp['delivery'] = round($r["delivery_sum"] / $afterVATRate, 2);
                $temp['delivery'] = round($temp['delivery'] * $tempDiscoutRate, 2);
            }
            $temp['completed order'] = '';
            if ($r["completedorders"]=='y') {
            	$temp['completed order'] = 'Yes';
            } else {
            	$temp['completed order'] = 'No';
            }
            if (!empty($r['ordercompletedDate'])) {
            $temp['closed date/user'] = date('Y-m-d', strtotime($r['ordercompletedDate'])). " ";
            } else {
	            $temp['closed date/user'] = '';
            }
            if (!empty($r['username'])) {
            $temp['closed date/user'] .= $r['username'];
            }

            $returnArray[] = $temp;
        }
        return $returnArray;
    }

    private function _generateCSV($stantardArray){
		$str = '';
		$title = array();
		foreach ($stantardArray[0] as $key=>$value){
			$title[] = '"'.$key.'"';
		}
		
		$str .= implode(',', $title) . "\n";
		foreach ($stantardArray as $row):
			foreach ($row as &$cell):
				// Escape double quotation marks
				if (isset($cell) && $cell != '' && gettype($cell) == 'string') {
				$cell = '"' . preg_replace('/"/','""',$cell) . '"';
				}
			endforeach;
			$str .= implode(',', $row) . "\n";
		endforeach;
		return $str;
	}
	
	private function _whereClauseCreator($requirement){
		$whereClause = '';
		$daterange = '';
		$timeRange = '';
		$showroom = '';
		if($requirement['daterange'] =='production'){
			$daterange = ' a.production_completion_date ';
		}else if($requirement['daterange'] =='delivery'){
			$daterange = ' a.bookeddeliverydate ';
		}else if($requirement['daterange'] =='orderdate'){
			$daterange = ' a.ORDER_DATE ';
		}
		if(array_key_exists('month', $requirement)){
	
			$month = $requirement["month"]["month"];
			$year = $requirement["month"]["year"];
			$timeRange = " (YEAR($daterange)=$year AND MONTH($daterange)=$month) ";
	
		}else if(array_key_exists('day', $requirement)){
	
			$from = $requirement["day"]["from"];
			$to = $requirement["day"]["to"];
			$timeRange = " ($daterange BETWEEN '$from' AND '$to') ";
		}
		if($requirement["showroom"] == 0){
			$showroom = 1;
		}else{
			$s = (int) $requirement["showroom"];
			$showroom = "a.idlocation=$s";
		}
		$whereClause = "$timeRange AND $showroom";
		return $whereClause;
	}
}
?>
