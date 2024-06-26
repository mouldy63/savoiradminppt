<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class AbstractPurchaseTable extends Table {
    //public $name = 'Purchase';
	protected $months = array("January"=>"1", "February"=>"2", "March"=>"3", "April"=>"4", "May"=>"5", "June"=>"6", "July"=>"7", "August"=>"8", "September"=>"9", "October"=>"10", "November"=>"11", "December"=>"12");
    
    public function initialize(array $config) : void {
        parent::initialize($config);
    }
	
	public function getCustomerOrders($isSuperUser, $userRegion, $userSite, $userLocation, $monthfrom, $monthto, $month, $year, $status) {
		$sql = "SELECT C.alpha_name, e.location, C.title, C.first, C.surname, A.company, A.street1, A.street2, A.street3, A.town, A.county, A.postcode, A.country, A.tel, A.EMAIL_ADDRESS, A.CHANNEL, A.VISIT_DATE, C.acceptemail, C.acceptpost, A.STATUS, A.FIRST_CONTACT_DATE"; 
		$sql .= ", (select p.order_date from purchase p where p.source_site='SB' AND p.contact_no=c.contact_no order by order_date desc limit 1) as lastorderdate";
		$sql .= " from contact C, address A, location AS e";
		$sql .= " where C.source_site='SB' AND C.CODE=A.CODE AND  C.idlocation=e.idlocation";
		if ($status !="") {
			$sql .= " AND A.STATUS = '" . $status . "'";
		};
		if ($monthfrom != "n" && $monthfrom !="") {
			$sql .=  " and A.FIRST_CONTACT_DATE >= '" . $this->convertDateToMysql($monthfrom) . "' and A.FIRST_CONTACT_DATE <= '" . $this->convertDateToMysql($monthto) . "'";
		}
		if ($month != "n" && $month !="") {
			$sql .= " AND month(A.FIRST_CONTACT_DATE) = " . $this->months[$month] . " AND year(A.FIRST_CONTACT_DATE) = " . $year;
		}
		if (!$isSuperUser) {
			$sql .= " AND C.OWNING_REGION=" . $userRegion;
			$sql .= " AND C.idlocation='" . $userLocation . "'";
			$sql .= " AND C.SOURCE_SITE='" . $userSite . "'";
		}
		$sql .= " order BY c.surname";
		
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getCurrentOrders($filterParams, $sortBy) {
    	$sql = "select * from (";
    	$sql .= " SELECT P.order_number, P.ordercurrency, P.purchase_no, P.total, P.paymentstotal, P.bookeddeliverydate, P.productiondate, C.surname, A.company, L.adminheading, P.ORDER_DATE, QS.QC_status, QS.QC_StatusID, P.total-P.paymentstotal as Outstanding, L.idlocation";
    	$sql .= " , CASE";
    	$sql .= " WHEN ordcollcnt.n = 0 THEN 'TBC'";
    	$sql .= " WHEN ordcollcnt.n > 1 THEN 'Split'";
    	$sql .= " ELSE ordcollcnt.collectiondate";
    	$sql .= " END as exworksdate";
    	$sql .= " from purchase P";
    	$sql .= " join Contact C on P.contact_no=C.CONTACT_NO and (P.cancelled is Null or P.cancelled='n') and (P.quote is Null or P.quote='n') and (completedorders='n' or completedorders is Null) and ordersource<>'Test' and C.contact_no<>319256 AND C.contact_no<>24188";
    	$sql .= " join Address A on C.code=A.code";
    	$sql .= " join Location L on P.idlocation=L.idlocation";
    	$sql .= " join qc_history_latest Q on P.purchase_no=Q.purchase_no and Q.ComponentID=0";
    	$sql .= " join qc_status QS on Q.QC_StatusID=QS.QC_StatusID";
    	$sql .= " left join (select count(*) as n, purchase_no, collectiondate from ordercollections group by purchase_no) as ordcollcnt on ordcollcnt.purchase_no=Q.purchase_no";
    	$sql .= " ) as X";
    	
    	$n = 0;
    	foreach ($filterParams as $param) {
    		if ($n == 0) {
    			$sql .= " where ";
    		} else {
    			$sql .= " and ";
    		}
    		$fieldName = $param[0];
    		$operator = $param[1];
    		$val = $param[2];
    		
    		if (is_array($val)) {
    			$sql .= $fieldName . " in (";
    			$m = 0;
    			foreach ($val as $v) {
    				if ($m > 0) $sql .= ",";
	    			if ($v == "null" || is_numeric($v)) {
		    			$sql .= $v;
	    			} else {
	    				$sql .= "'" . $v . "'";
	    			}
    				$m++;
       			}
    			$sql .= ")";
    		} else {
    			if ($val == "null" || is_numeric($val)) {
	    			$sql .= $fieldName . " " . $operator . " " . $val;
    			} else {
    				$sql .= $fieldName . " " . $operator . " '" . $val . "'";
    			}
	   		}
    		$n++;
    	}
    	
    	if (sizeof($sortBy) > 0) {
    		$sql .= " order by " . $sortBy[0] . " " . $sortBy[1];
    	}
		//debug($sql);
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getcustomerNotInvoiced($month, $year, $deldate, $bcwwarehouse) {
    	$sql = "select * from purchase p join location l on p.idlocation=l.idlocation";
    	$sql .= " join contact c on c.contact_no=p.contact_no";
    	$sql .= " join address a on a.code=c.code";
    	$sql .= "  join (select purchase_no as qc_purchase_no, max(deliverydate) as deldate from qc_history_latest where (madeat=1 or madeat=2) and componentid not in (0,9) group by purchase_no) qc on p.purchase_no=qc.qc_purchase_no";
		$sql .= " left join (select purchase_no as qc1_purchase_no, max(bcwwarehouse) as bcwwarehouse1 from qc_history_latest where madeat=1 and componentid not in (0,9) group by purchase_no) qc1 on p.purchase_no=qc1.qc1_purchase_no";
    	$sql .= " left join (select purchase_no as qc2_purchase_no, max(bcwwarehouse) as bcwwarehouse2 from qc_history_latest where madeat=2 and componentid not in (0,9) group by purchase_no) qc2 on p.purchase_no=qc2.qc2_purchase_no";
    	$sql .= " where (p.cancelled = 'n' or p.cancelled is null)";
    	$sql .= " and year(p.production_completion_date)=" . $year;
    	$sql .= " and month(p.production_completion_date)=" .  $month;
    	$sql .= " and (qc.deldate is null or qc.deldate > '" . $deldate ."')";
    	$sql .= " and (qc1.qc1_purchase_no is null or (qc1.bcwwarehouse1 is not null and qc1.bcwwarehouse1 < '" .$bcwwarehouse ."'))";
    	//debug($sql);
    	//die;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function getAllOrders($contactno) {
    	$sql = "select * from purchase where contact_no=".$contactno." ORDER by ORDER_DATE desc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	function getOrderComponentSummary($pn, $componentId) {
		$myconn = ConnectionManager::get('default');
		$names = $this->getColNamesForComponent($componentId);
		if (!isset($names)) {
			return "";
		}
		$sql = "select ".implode(",", array_keys($names))." from purchase where purchase_no=$pn";
		$row = $myconn->execute($sql)->fetchAll('assoc')[0];
		$summary = "";
		foreach ($names as $key => $value) {
			$adaptedValue = $this->adaptComponentValue($key, $row[$key], $componentId, $pn);
			$summary .=$adaptedValue." ";
		}
		return $summary;
	}
	
	function getColNamesForComponent($componentId) {
		if ($componentId == 1) {
			// mattress
			$names = array(
				"savoirmodel" => "Model",
				"mattresstype" => "Type",
				"mattresswidth" => "Width",
				"mattresslength" => "Length",
				"leftsupport" => "Left Support",
				"rightsupport" => "Right Support",
				"tickingoptions" => "Ticking Options"
			);
		} else if ($componentId == 3) {
			// base
			$names = array(
				"basesavoirmodel" => "Model",
				"basetype" => "Type",
				"basewidth" => "Width",
				"baselength" => "Length",
				"basefabric" => "Fabric",
				"basefabricdirection" => "Fabric Direction"
				);
		} else if ($componentId == 5) {
			// topper
			$names = array(
				"toppertype" => "Type",
				"topperwidth" => "Width",
				"topperlength" => "Length",
				"toppertickingoptions" => "Ticking Options"
			);
		} else if ($componentId == 8) {
			// headboard
			$names = array(
				"headboardstyle" => "Style",
				"headboardfabric" => "Fabric",
				"headboardheight" => "Height",
				"headboardfinish" => "Finish",
				"headboardfabricdirection" => "Fabric Direction"
			); 
		} else if ($componentId == 6) {
			// valance
			$names = array(
				"valancefabric" => "Fabric",
				"valancefabricchoice" => "Selection",
				"valancefabricDirection" => "Fabric Direction",
				"valancewidth" => "Width",
				"valancelength" => "Length",
				"valancedrop" => "Drop"
			);
		} else if ($componentId == 7) {
			// legs
			$names = array(
				"legstyle" => "Style",
				"legfinish" => "Finish",
				"legheight" => "Height"
			);
		}
		
		return $names;
	}
	
	function adaptComponentValue($key, $oldValue, $componentId, $pn) {
		$myconn = ConnectionManager::get('default');
		$newValue = $oldValue;
		if ($componentId == 1) {
			// mattress
			if ($key == "mattresswidth" && $oldValue == "Special Width") {
				$query = "SELECT matt1width,matt2width FROM  productionsizes where purchase_no=$pn";
				$rs = $myconn->execute($query)->fetchAll('assoc');
				foreach ($results as $row) {
					$newValue = $row["matt1width"] . "cm";
					if (isset($row["matt2width"])) {
						$newValue .= " &amp; " . $row["matt2width"] . "cm";
					}
				}
			}
		} else if ($componentId == 3) {
			// base
			if ($key == "basewidth" && $oldValue == "Special Width") {
				$query = "SELECT base1width,base2width FROM  productionsizes where purchase_no=$pn";
				$rs = $myconn->execute($query)->fetchAll('assoc');
				foreach ($results as $row) {
					$newValue = $row["base1width"] . "cm";
					if (isset($row["base2width"])) {
						$newValue .= " &amp; " . $row["base2width"] . "cm";
					}
				}
			}
		} else if ($componentId == 5) {
			// topper
			if ($key == "topperwidth" && $oldValue == "Special Width") {
				$query = "SELECT topper1width FROM  productionsizes where purchase_no=$pn";
				$rs = $myconn->execute($query)->fetchAll('assoc');
				foreach ($results as $row) {
					$newValue = $row["topper1width"] . "cm";
				}
			}
		}
		
		return $newValue;
	}
	
	public function getSalesContact($username) {
		$sql = "Select name from savoir_user WHERE username like '" .$username . "'";
		
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc')[0]['name'];
		
    }
	
	public function getSalesEmail($username) {
		$sql = "Select adminemail from savoir_user WHERE username like '" .$username . "'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc')[0]['adminemail'];
    }
	
	public function getFirstPurchaseDate($contactNo) {
		$sql = "select date(min(order_date)) as orderdate from purchase where contact_no=:cn and (quote is null or quote='n') and (cancelled is null or cancelled <> 'y') and ordersource not in ('Marketing','Stock','Floorstock') and ordersource is not null";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc')[0]['orderdate'];
    }
    
	public function getLatestPurchaseDate($contactNo) {
		$sql = "select date(max(order_date)) as orderdate from purchase where contact_no=:cn and (quote is null or quote='n') and (cancelled is null or cancelled <> 'y') and ordersource not in ('Marketing','Stock','Floorstock') and ordersource is not null";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc')[0]['orderdate'];
    }
    
	public function hasPurchasedAccessories($contactNo) {
		$sql = "select accessoriesrequired from purchase where contact_no=:cn and (quote is null or quote='n') and (cancelled is null or cancelled <> 'y') and ordersource not in ('Marketing','Stock','Floorstock') and ordersource is not null and accessoriesrequired='y'";
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');
		return count($rs)>0;
    }
    
	public function hasPurchasedTopper($contactNo) {
		$sql = "select topperrequired from purchase where contact_no=:cn and (quote is null or quote='n') and (cancelled is null or cancelled <> 'y') and ordersource not in ('Marketing','Stock','Floorstock') and ordersource is not null and topperrequired='y'";
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');
		return count($rs)>0;
    }
    
	public function getLatestTopperDeliveryDate($contactNo) {
		$sql = "select date(max(q.deliverydate)) as deldate from purchase p join qc_history_latest q on p.purchase_no=q.purchase_no and q.componentid=5 and p.contact_no=:cn and (p.quote is null or p.quote='n') and (p.cancelled is null or p.cancelled <> 'y') and p.ordersource not in ('Marketing','Stock','Floorstock') and p.ordersource is not null and p.topperrequired='y'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc')[0]['deldate'];
    }
    
	public function hasPurchasedMattress($contactNo) {
		$sql = "select mattressrequired from purchase where contact_no=:cn and (quote is null or quote='n') and (cancelled is null or cancelled <> 'y') and ordersource not in ('Marketing','Stock','Floorstock') and ordersource is not null and mattressrequired='y'";
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');
		return count($rs)>0;
    }
    
	public function getLatestMattressDeliveryDate($contactNo) {
		$sql = "select date(max(q.deliverydate)) as deldate from purchase p join qc_history_latest q on p.purchase_no=q.purchase_no and q.componentid=1 and p.contact_no=:cn and (p.quote is null or p.quote='n') and (p.cancelled is null or p.cancelled <> 'y') and p.ordersource not in ('Marketing','Stock','Floorstock') and p.ordersource is not null and p.mattressrequired='y'"; 
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc')[0]['deldate'];
    }
    
	public function getExVatOrderTotalForCustomer($contactNo) {
		$sql = "select sum(totalexvat) as t,ordercurrency from purchase where contact_no=:cn and quote='n' and (cancelled is null or cancelled='n') and ordersource not in ('Marketing','Stock','Floorstock','Test') group by ordercurrency"; 
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');
		$maxTotal = 0.0;
		foreach ($rs as $row) {
			if ($row['t'] > $maxTotal) {
				$maxTotal = $row['t'];
			}
		}
		return $maxTotal;
    }
    
    public function getRevenueException($showroom,$monthfrom,$monthto) {
		$sql = "Select P.ORDER_DATE, P.ORDER_NUMBER, P.PURCHASE_No, P.bookeddeliverydate, P.production_completion_date, C.surname, A.company, L.adminheading, P.ordercurrency, P.discount, P.vatrate, P.vat, P.total, P.bedsettotal, P.discounttype, P.balanceoutstanding, P.mattressrequired, P.savoirmodel, P.mattressprice, P.baserequired, P.basesavoirmodel, P.baseprice, P.topperrequired, P.toppertype, P.topperprice, P.headboardrequired, P.headboardprice, P.legprice, P.legsrequired, P.accessoriesrequired, P.accessoriestotalcost, P.deliverycharge, P.completedorders, ";
		$sql .= "COALESCE(P.topperprice,0) AS topper_sum, COALESCE(P.mattressprice,0) AS mattr_sum, ";
		$sql .= "COALESCE(P.baseprice,0)+COALESCE(P.basetrimprice,0)+COALESCE(P.basedrawers,0)+COALESCE(P.basefabricprice,0)+ ";
		$sql .= "COALESCE(P.upholsteryprice,0) AS base_sum, COALESCE(P.hbfabricprice,0)+COALESCE(P.headboardprice,0)+";
		$sql .= "COALESCE(P.headboardtrimprice,0) AS hb_sum,COALESCE(P.legprice,0)+COALESCE(P.addlegprice,0) AS leg_sum,";
		$sql .= "COALESCE(P.accessoriestotalcost,0) AS acce_sum,COALESCE(P.deliveryprice,0) AS delivery_sum,";
		$sql .= "(select group_concat(p1.amount) from payment p1 where p1.purchase_no=P.PURCHASE_No and p1.paymenttype!='Refund') as payments, ";
		$sql .= "(select group_concat(p2.amount*-1) from payment p2 where p2.purchase_no=P.PURCHASE_No and p2.paymenttype='Refund') as refunds ";
		$sql .= " from purchase P ";
		$sql .= " join Contact C on P.contact_no=C.CONTACT_NO and (P.cancelled is Null or P.cancelled='n') and C.is_developer='n' and (P.quote is Null or P.quote='n') and ordersource<>'Test' and C.contact_no<>319256 AND C.contact_no<>24188";
    	$sql .= " join Address A on C.code=A.code";
    	$sql .= " join Location L on P.idlocation=L.idlocation";
    	$sql .= " WHERE ORDER_DATE >='" . $this->convertDateToMysql($monthfrom) . "' and ORDER_DATE <='" . $this->convertDateToMysql($monthto) . "' and completedorders='y'";
    	if ($showroom=='all') {
    	$sql .= " and P.bookeddeliverydate is Null AND P.balanceoutstanding=0";
    	} else {
    	$sql .= " and P.idlocation=".$showroom." and P.bookeddeliverydate is Null AND P.balanceoutstanding=0";
		}

		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getOrderSource() {
		$sql = "SELECT orderSource from Purchase group by orderSource";
		
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getOrdersToBeDelivered() {
    	
$sql = <<<ENDSQL
select t1.*,
((t1.itemprice
* (case when t1.discounttype='percent' and t1.discount is not null then (1 - t1.discount/100) else 1.0 end)
- (case when t1.discounttype='currency' and t1.discount is not null then t1.discount/t1.bedsettotal*t1.itemprice else 0.0 end))
/ (case when t1.istrade='n' and t1.vatrate is not null and t1.vatrate>0.0 then (t1.vatrate/100+1) else 1 end)) as itempriceexvatexdiscount,
(t1.itemprice / (case when t1.istrade='n' and t1.vatrate is not null and t1.vatrate>0.0 then (t1.vatrate/100+1) else 1 end)) as itempriceexvat
from (
select p.purchase_no, co.componentname as itemtype,
pd.boxsize as boxtype,
qc.bcwexpected as plannedproddate, 
(case when p.companyname is not null then p.companyname else a.company end) as companyname,
concat(c.title, ' ', c.first, ' ', c.surname) as customername,
p.deliveryadd1, p.deliveryadd2, p.deliverytown, p.deliverypostcode, p.deliverycountry,
qc.deliverydate,
pd.packwidth as width, pd.packheight as height, pd.packdepth as depth,
ec.collectiondate as exworksdate,
(case
    when pd.componentid=1 then ifnull(mattressprice, 0.0)
    when pd.componentid=3 then (ifnull(baseprice, 0.0) + ifnull(basetrimprice, 0.0) + ifnull(upholsteryprice, 0.0) + ifnull(basefabricprice, 0.0) + ifnull(basedrawersprice, 0.0))
    when pd.componentid=5 then ifnull(topperprice, 0.0)
    when pd.componentid=6 then (ifnull(valanceprice,0.0) + ifnull(valfabricprice, 0.0))
    when pd.componentid=7 then (ifnull(legprice, 0.0) + ifnull(addlegprice, 0.0))
    when pd.componentid=8 then (ifnull(headboardprice, 0.0) + ifnull(hbfabricprice, 0.0) + ifnull(headboardtrimprice, 0.0))
    when pd.componentid=9 then ifnull(oa.unitprice*oa.qty, 0.0)
    else 0.0
END) as itemprice,
bays.bay_name as bay,
(select qc_status from qc_status where qc_status.qc_statusid=qc.qc_statusid) as itemstatus,
(case when qc.madeat=1 then 'Cardiff' when qc.madeat=2 then 'London' else 'Unknown' end) as madeat,
p.order_date as orderdate,
p.order_number as ordernumber,
l.location as showroom,
(case
    when pd.componentid=1 then p.mattressinstructions
    when pd.componentid=3 then p.baseinstructions
    when pd.componentid=5 then p.specialinstructionstopper
    when pd.componentid=6 then p.specialinstructionsvalance
    when pd.componentid=7 then p.specialinstructionslegs
    when pd.componentid=8 then p.specialinstructionsheadboard
    when pd.componentid=9 then ''
    else ''
END) as specialinstructions,
(case
    when pd.componentid=1 then ifnull(p.savoirmodel, '')
    when pd.componentid=3 then ifnull(p.basesavoirmodel, '')
    when pd.componentid=5 then ifnull(p.toppertype, '')
    when pd.componentid=6 then ''
    when pd.componentid=7 then ifnull(p.legstyle, '')
    when pd.componentid=8 then ifnull(p.headboardstyle, '')
    when pd.componentid=9 then ''
    else ''
END) as compname,
(ifnull(pd.packwidth,0.0) * ifnull(pd.packheight,0.0) * ifnull(pd.packdepth,0.0)) as totalcube,
oa.description as accessorydescription,
oa.checked as accessorycheckeddate,
W.pdfwrapname as wraptype,
p.discounttype, p.discount, p.istrade, p.vatrate, p.bedsettotal, p.balanceoutstanding,
(case
    when p.istrade='y' then p.subtotal
    else p.subtotal / (1 + p.vatrate/100)
END) as subtot_exvat_exdel,
(case
    when p.discount > 0 then p.bedsettotal-p.subtotal
END) as orderdiscount,
(case
    when p.discount > 0 then p.discounttype
END) as orderdiscounttype,
(case
    when p.istrade='y' then p.bedsettotal+ifnull(p.deliveryprice, 0.0)
    else (p.bedsettotal+ifnull(p.deliveryprice, 0.0)) / (1 + p.vatrate/100)
END) as ordtot_exvat_exdiscount
from purchase p
join qc_history_latest qc on p.purchase_no=qc.purchase_no and qc.ComponentID != 0
join Contact C on P.contact_no=C.CONTACT_NO
join Address A on C.code=A.code
join Location L on P.idlocation=L.idlocation
join component co on co.componentid=qc.ComponentID
left join packagingdata pd on pd.purchase_no=p.purchase_no and pd.componentid=qc.ComponentID
left join Wrappingtypes W on P.wrappingid=W.WrappingID
left join exportlinks el on el.purchase_no=p.purchase_no and el.componentid=qc.ComponentID
left join exportcollshowrooms ecs on el.linksCollectionID=ecs.exportCollshowroomsID
left join exportcollections ec on ec.exportCollectionsID=ecs.exportCollectionID
left join orderaccessory oa on oa.purchase_no=p.purchase_no and qc.ComponentID=9 and (oa.orderaccessory_id=pd.CompPartNo or pd.CompPartNo is null)
left join bay_content bc on p.purchase_no=bc.orderid and qc.ComponentID=bc.componentid
left join bays on bays.bay_no=bc.baynumber
where 
(P.cancelled is Null or P.cancelled='n') and C.is_developer='n' and (P.quote is Null or P.quote='n') and ordersource<>'Test' and P.completedorders='n' and C.contact_no<>319256 AND C.contact_no<>24188 and P.completedorders='n'
) as t1
ENDSQL;
		//debug($sql);
		//die;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
   
    
    public function getComponentPriceXVat($compid, $pn, $incextras) {
		$purchase = $this->get($pn);
		
		$totalcompprice=0;
		
		if ($compid==1) {
			$totalcompprice += $purchase['mattressprice'];
		}
		if ($compid==3) {
			
			$totalcompprice += $purchase['baseprice'];
			$totalcompprice += $purchase['basetrimprice'];
			$totalcompprice += $purchase['basedrawersprice'];
			if ($incextras) {
			$totalcompprice += $purchase['basefabricprice'];
			$totalcompprice += $purchase['upholsteryprice'];
			}			
		}
		if ($compid==31) {
			$totalcompprice += $purchase['upholsteryprice'];
		}
		if ($compid==99) {
			if ($purchase['baserequired']=='y') {
				$totalcompprice += $purchase['basefabricprice'];
			}
			if ($purchase['headboardrequired']=='y') {
				$totalcompprice += $purchase['hbfabricprice'];
			}
			if ($purchase['accessoriesrequired']=='y') {
				$totalcompprice += $purchase['accessoriestotalcost'];
			}
			if ($purchase['deliverycharge']=='y') {
				$totalcompprice += $purchase['deliveryprice'];
			}
		}
		if ($compid==5) {
			$totalcompprice += $purchase['topperprice'];
		}
		if ($compid==6) {
			$totalcompprice += $purchase['valanceprice'];
		}
		if ($compid==7) {
			$totalcompprice += $purchase['legprice'];
			$totalcompprice += $purchase['addlegprice'];
		}
		if ($compid==8) {
			$totalcompprice += $purchase['headboardprice'];
			$totalcompprice += $purchase['headboardtrimprice'];
			if ($incextras) {
			$totalcompprice += $purchase['hbfabricprice'];
			}
		}
		if ($compid==9) {
			$totalcompprice += $purchase['accessoriestotalcost'];
		}
		
    	if ($purchase['istrade']=='y') {
			$totalcompprice =$totalcompprice/(1+$purchase['vatrate']/100);
		}
		$totalcompprice = number_format($totalcompprice,2);
		return $totalcompprice;
		//debug($totalcompprice);	
    }
    
    public function getOrdersAmendedFrom($fromDateTime) {
		$sql = <<<ENDSQL
		select P.ORDER_NUMBER, P.PURCHASE_No, P.ORDER_DATE, P.deliverydate, 
		CASE WHEN P.AmendedDate>QC.QC_Date THEN P.AmendedDate ELSE QC.QC_Date END as AmendedDate, 
		P.contact_no, A.street1, A.street2, A.street3, A.town, A.county, A.country, A.postcode, P.deliveryadd1, P.deliveryadd2, P.deliveryadd3, P.deliverytown, P.deliverycounty, P.deliverypostcode, P.deliverycountry, O.ordertype, P.totalexvat, P.vat, P.ordercurrency, L.idlocation, QS.QC_status from purchase p 
		join Location L on P.idlocation=L.idlocation
		join Contact C on P.contact_no=C.CONTACT_NO
		join Address A on C.code=A.code
		left join Ordertype O on P.ordertype = O.ordertypeID
		left join QC_history_latest QC on P.PURCHASE_No = QC.Purchase_No and QC.ComponentID=0
		left join QC_status QS on QC.QC_StatusID = QS.QC_statusID
		where (p.AmendedDate >= :fromDateTime or QC.QC_Date >= :fromDateTime) and (P.quote is Null or P.quote='n') and ordersource<>'Test'
		order by p.AmendedDate asc
		ENDSQL;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql, ['fromDateTime' => $fromDateTime])->fetchAll('assoc');
    }
    
    private function convertDateToMysql($date) {
		$myDateTime = DateTime::createFromFormat('d/m/Y', $date);
		$date = $myDateTime->format('Y-m-d');
		return $date;
	}
}
?>
