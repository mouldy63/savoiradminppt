<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;
use Cake\Core\App;




class ContactTable extends Table {
    //public $name = 'Contact';
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('contact');
        $this->setPrimaryKey('CONTACT_NO');
        $this->hasOne('Address')->setForeignKey('CODE')->setJoinType('INNER')->setBindingKey('CODE');
    }
	
	public function getRetiredContacts() {
    	$sql = "Select C.CODE, C.CONTACT_NO, C.title, C.first, C.surname, A.company, A.street1, A.street2, A.street3, A.town, A.county, A.postcode, A.country from address A, contact C Where C.retire='y' AND A.code=C.code";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function deleteContacts($code) {
		$myconn = ConnectionManager::get('default');
		$sql = "DELETE from interestproductslink Where contact_no IN (Select CONTACT_NO from contact WHERE code=" .$code .")";
		$myconn->execute($sql);
    	$sql = "DELETE from contact WHERE code=" .$code;
		$myconn->execute($sql);
		$sql = "DELETE from address WHERE code=" .$code;
		$myconn->execute($sql);
		$sql = "DELETE from communication WHERE code=" .$code;
		$myconn->execute($sql);
    }
	
	public function reactivateContacts($code) {
		$myconn = ConnectionManager::get('default');
		$sql = "Update contact set retire='n' Where code=" .$code;
		$myconn->execute($sql);
    }
	
    public function getContact($contactNo) {
    	$sql = "select * from contact c join address a on c.code=a.code and c.contact_no=:cn";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');
    	
    }
	
	public function getOutstandingRequests($isSuperUser, $region, $idlocation) {
    	$sql = "Select C.title, C.first, C.surname, A.company, A.street1, A.street2, A.street3, A.town, A.county, A.country, A.postcode, A.FIRST_CONTACT_DATE, C.OWNING_REGION, C.idlocation, C.SOURCE_SITE, C.OWNING_REGION, C.CODE, C.CONTACT_NO, L.location from address A, contact C, location L Where C.idlocation=L.idlocation and C.retire='n' AND A.CODE=C.code AND C.BrochureRequestSent='n'";
		if (!$isSuperUser && $idlocation != 1) {
			$sql .= " AND C.OWNING_REGION=" .$region;
			$sql .= " AND C.idlocation=" .$idlocation;
			$sql .= " AND C.SOURCE_SITE='SB'";
		}
		$sql .= " order by A.FIRST_CONTACT_DATE asc";

		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getOutstandingCoRequests($isSuperUser, $region, $idlocation) {
    	$sql = "Select C.title, C.first, C.surname, A.company, A.street1, A.street2, A.street3, A.town, A.county, A.country, A.postcode, A.FIRST_CONTACT_DATE, C.OWNING_REGION, C.idlocation, C.SOURCE_SITE, C.OWNING_REGION, C.CODE, C.CONTACT_NO, L.location from address A, contact C, location L Where C.idlocation=L.idlocation and A.company is not null and C.retire='n' AND A.CODE=C.code AND C.BrochureRequestSent='n'";

		if (!$isSuperUser) {
			$sql .= " AND C.OWNING_REGION=" .$region;
			$sql .= " AND C.idlocation=" .$idlocation;
			$sql .= " AND C.SOURCE_SITE='SB'";
		}
		$sql .= " order by A.FIRST_CONTACT_DATE asc";
		//Debug($sql);
		//die;

		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getPostcodeCustomers($region, $idlocation, $postcode) {
    	$sql = "Select * from address A, contact C Where C.retire='n' AND A.CODE=C.CODE and TRIM(REPLACE(A.postcode,' ','')) like '".str_replace(" ","",$postcode)."'";
		if ($region != 1) {
			$sql .= " AND C.idlocation=" .$idlocation;
		}
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getLifetimeSpendByCurrency($contactNo) {
    	$sql = "select sum(total) as tot, ordercurrency, count(p.PURCHASE_No) as n from purchase p"
    			. "			where p.contact_no=:cn"
    			. "         and (p.cancelled is null or p.cancelled <> 'y') and (P.quote is Null or P.quote='n') and p.orderonhold<>'y' and ordersource<>'Test'"
    			. "			group by p.ordercurrency";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');
    }

	public function getLifetimeSpendForCurrency($contactNo,$currency) {
		$results=$this->getLifetimeSpendByCurrency($contactNo);
		$spend=0;
    	foreach ($results as $row) {
			if ($row['ordercurrency']==$currency) {
				$spend=$row['tot'];
				break;
			}
		}
		return $spend;
    }

	public function getOrderNumbers($contactNo) {
		$sql = "select distinct order_number from purchase p where p.contact_no=:cn"
				. " and (p.cancelled is null or p.cancelled <> 'y') and (P.quote is Null or P.quote='n') and p.orderonhold<>'y' and ordersource<>'Test'";
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['cn' => $contactNo]);
		$orders = [];
		foreach ($rs as $row) {
			array_push($orders, $row['order_number']);
		}
		return $orders;
    }
	
	public function getLatestOrder($contactNo) {
    	$sql = "select * from purchase p where p.contact_no=:cn"
    			. " and (p.cancelled is null or p.cancelled <> 'y') and (P.quote is Null or P.quote='n') and p.orderonhold<>'y' and ordersource<>'Test'"
    			. " order by order_date desc limit 1";
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['cn' => $contactNo]);
		$order = null;
		foreach ($rs as $row) {
			$order = $row;
		}
		return $order;
    }
    
    public function getCustomers($ctrl, $surname, $cref, $postcode, $dpostcode, $email, $company, $channel, $contacttype, $orderType, $filtertype, $filterval, $security) {
    	$sql = "select * from (";
    	$sql .= $this->getCustomersSql($ctrl, $surname, $cref, $postcode, $dpostcode, $email, $company, $channel, $contacttype, $orderType, $filtertype, $filterval, $security);
    	if (!empty($dpostcode)) {
    		// also search for the delivery postcode as though its an invoice postcode
    		$sql .= " union " . $this->getCustomersSql($ctrl, $surname, $cref, $dpostcode, $email, '', $company, $channel, $contacttype, $orderType, $filtertype, $filterval, $security);
    	}
    	$sql .= " ) t1 order by t1.surname asc, t1.first asc";
    	//debug($sql);
    	//die;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

    private function getCustomersSql($ctrl, $surname, $cref, $postcode, $dpostcode, $email, $company, $channel, $contacttype, $orderType, $filtertype, $filterval, $security) {
    	$sql = "select CC.CODE,CC.CONTACT_NO,CC.surname,CC.title,CC.first,AA.company,AA.EMAIL_ADDRESS,AA.street1,AA.street2,AA.street3,AA.county,AA.postcode,AA.country,CC.acceptpost,CC.acceptemail,CC.SOURCE_SITE";
    	$sql .= " from contact CC";
    	$sql .= " join address AA on CC.code=AA.code";
    	$sql .= "  where CC.contact_no in (";
    	$sql .= $this->getContactFilterSql($ctrl, $orderType, $cref, $surname, $postcode, $dpostcode, $email, $company, $channel, $contacttype, $filtertype, $filterval, $security);
    	$sql .= ")";
    	return $sql;
    }
    
    private function getContactFilterSql($ctrl, $orderType, $cref, $surname, $postcode, $dpostcode, $email, $company, $channel, $contacttype, $filtertype, $filterval, $security) {
    	$aBuddyLocationAndRegionList='';  
    	$aPair = '';
    	$aLocAndReg = '';
    	$anLoc = '';
    	$aPairs = '';
    	$sql = "select distinct c.CONTACT_NO from contact c join address a on c.CODE=a.CODE and c.retire='n' and c.is_developer='n'";
    	if (!$ctrl->_userHasRole('ADMINISTRATOR')) {
    		if ($security->getCurrentUserRegionId() != 1) {
    			$aBuddyLocationAndRegionList = $this->getBuddyLocationAndRegionList($security->getCurrentUserLocationId());
    			$nLoc = 0;
    			$pairs = explode(";",$aBuddyLocationAndRegionList);
    			$sql .= " AND (";
    			foreach ($pairs as $pair) {
    				$nLoc = $nLoc + 1;
    				if ($nLoc > 1) {
    					$sql .= " OR ";
    				}
    				$locAndReg = explode(",",$pair);
    				$sql .= " (c.idlocation=" .$locAndReg[0] . " AND c.OWNING_REGION=" .$locAndReg[1] . ")";

    			}
    			$sql .= ")";
    		} else {
    			$sql .= " and c.OWNING_REGION=1";
    		}
    	}
    	if ($surname != '') {
    		$sql .= " and C.surname like '%".$surname."%'";
    	}
    	if (!empty($postcode)) {
    		$sql .= " and replace(A.postcode, ' ', '') like '%".str_replace(" ","",$postcode)."%'";
    	}
    	if (!empty($email)) {
    		$sql .= " and A.EMAIL_ADDRESS like '%".$email."%'";
    	}
    	if ($company != '') {
    		$sql .= " and A.company like '%".$company."%'";
    	}
    	if ($company != '') {
    		$sql .= " and A.company like '%".$company."%'";
    	}
    	if ($ctrl->getCurrentUserRegionId() == 1) {
    		if ($channel != '') {
    			$sql .= " and A.channel = '".$channel."'";
    		}
    		if ($contacttype != '') {
    			$sql .= " and A.initial_contact = '".$contacttype."'";
    		}
    	}
    	//debug($orderType);
    	if ($orderType == 'current') {
    		//customers with current orders
    		$sql .= " and exists(select 1 from purchase p where p.contact_no=c.CONTACT_NO and p.completedorders='n' and (p.cancelled is null or p.cancelled = 'n')";
    		if ($cref != '') {
    			$sql .= " and p.customerreference like '%".$cref."%'";
    		}
    		$sql .= ")";
    	} else if ($orderType == 'completed'){
    		//customers with completed orders
    		$sql .= " and exists(select 1 from purchase p where p.contact_no=c.CONTACT_NO and p.completedorders='y' and (p.cancelled is null or p.cancelled = 'n')";
    		if ($cref != '') {
    			$sql .= " and p.customerreference like '%".$cref."%'";
    		}
    		$sql .= ")";
    	} else if ($orderType == 'none'){
    		//customers with no orders
    		$sql .= " and not exists(select 1 from purchase p where p.contact_no=c.CONTACT_NO and (p.cancelled is null or p.cancelled = 'n')";
    		if ($cref != '') {
    			$sql .= " and p.customerreference like '%".$cref."%'";
    		}
    		$sql .= ")";
    	}

    	if ($filtertype != '') {
    		if ($filtertype == 'first') {
    			$sql .= " and C.first like '%".$filterval."%'";
    		}
    		if ($filtertype == 'company') {
    			$sql .= " and A.company like '%".$filterval."%'";
    		}
    		if ($filtertype == 'add1') {
    			$sql .= " and A.street1 like '%".$filterval."%'";
    		}
    		if ($filtertype == 'add2') {
    			$sql .= " and A.street2 like '%".$filterval."%'";
    		}
    		if ($filtertype == 'add3') {
    			$sql .= " and A.street3 like '%".$filterval."%'";
    		}
    		if ($filtertype == 'email') {
    			$sql .= " and A.EMAIL_ADDRESS like '%".$filterval."%'";
    		}
    		if ($filtertype == 'postcode') {
    			$sql .= " and A.postcode like '%".$filterval."%'";
    		}
    		if ($filtertype == 'city') {
    			$sql .= " and A.town like '%".$filterval."%'";
    		}
    		if ($filtertype == 'channel') {
    			$sql .= " and A.channel like '%".$filterval."%'";
    		}
    		if ($filtertype == 'type') {
    			$sql .= " and A.type like '%".$filterval."%'";
    		}
    		if ($filtertype == 'visited') {
    			$sql .= " and A.visit_location like '%".$filterval."%'";
    		}
    		if ($filtertype == 'A') {
    			$sql .= " and (C.first like '%".$filterval."%'";
    			$sql .= " or A.street1 like '%".$filterval."%'";
    			$sql .= " or A.street2 like '%".$filterval."%'";
    			$sql .= " or A.street3 like '%".$filterval."%'";
    			$sql .= " or A.email_address like '%".$filterval."%'";
    			$sql .= " or A.postcode like '%".$filterval."%'";
    			$sql .= " or A.town like '%".$filterval."%'";
    			$sql .= " or A.channel like '%".$filterval."%'";
    			$sql .= " or A.type like '%".$filterval."%'";
    			$sql .= " or A.visit_location like '%".$filterval."%')";
    		}

    	}

    	if ($orderType != 'none' && ($filtertype == 'company' || $filtertype == 'custref' || $filtertype == 'A' || !empty($dpostcode))) {
    		$sql .= " join purchase pp on c.contact_no=pp.contact_no";
    		if ($filtertype == 'company') {
    			$sql .= "  and pp.companyname like '%".$filterval."%'";
    		}
    		if ($filtertype == 'custref') {
    			$sql .= "  and pp.customerreference like '%".$filterval."%'";
    		}
    		if ($filtertype == 'A') {
    			$sql .= "  and (pp.companyname like '%".$filterval."%'";
    			$sql .= "  or pp.customerreference like '%".$filterval."%')";
    		}
    		if (!empty($dpostcode)) {
        		$sql .= " and replace(pp.deliverypostcode, ' ', '') like '%".str_replace(" ","",$dpostcode)."%'";
    		}
    	}

//    	debug($sql);
//    	die;
    	return $sql;

    }
    
    function getBuddyLocationAndRegionList($idLocation) {
    	
		$myconn = ConnectionManager::get('default');
    	$sql = "select buddy_location_ids from location where idlocation=:id";
		$rs = $myconn->execute($sql, ['id' => $idLocation])->fetchAll('assoc');
    	$list = strval($idLocation);
		foreach($rs as $row) {
			if ($row['buddy_location_ids']) {
				$list .= ',' . $row['buddy_location_ids'];
			}
		}
		
		$buddies = explode(',', $list);
		$n = 0;
		$buddyLocationAndRegionList = '';
		foreach($buddies as $bud) {
			$n++;
		    $sql = 'select owning_region from location where idlocation=:bud';
			$rs = $myconn->execute($sql, ['bud' => $bud])->fetchAll('assoc');
	    	if ($n > 1) $buddyLocationAndRegionList .= ';';
		    $buddyLocationAndRegionList .= $bud . ',' . $rs[0]['owning_region'];
	    	
		}
		
    	return $buddyLocationAndRegionList;
    }
    
    public function getSearchOrderDetails($contactno, $current, $cref, $filtertype, $filterval) {
    	$sql = "select p.PURCHASE_No,p.ORDER_NUMBER,p.ORDER_DATE,p.customerreference,p.BED,p.NOTES from purchase p where (P.cancelled is null or P.cancelled = 'n') and p.contact_no=" .$contactno;
		if ($current == 'true') {
			$sql .= " and p.completedorders='n'";
		}
		if ($current == 'false') {
			$sql .= " and p.completedorders='y'";
		}
		
		if (!empty($cref)) {
			$sql .= " and p.customerreference like '%".$cref."%'";
		}
		if (!empty($filtertype)) {
			if (($filtertype == 'company' || $filtertype == 'custref' || $filtertype == 'A') && isset($filterval)) {
				if ($filtertype == 'company') {
				$sql .= " and p.companyname like '%".$filterval."%'";
				}
				if ($filtertype == 'custref') {
				$sql .= " and p.customerreference like '%".$filterval."%'";
				}
				if ($filtertype == 'A') {
				$sql .= " and (p.companyname like '%".$filterval."%' ||  or p.customerreference like '%".$filterval."%'";
				}
			}
		}
		$sql .= " group by p.PURCHASE_No";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    function getorderDesc($pn) {
    	$sql = "select * from purchase where purchase_no=" .$pn;
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql)->fetchAll('assoc');
		$orderdetails='';
		foreach($rs as $row) {
			if ($row['mattressrequired']=='y') {
				$orderdetails .= "<br/>Mattress: ".$row['savoirmodel']." (";
				if ($row['mattress1width'] != "") {
					$orderdetails .= $row['mattress1width'].",".$row['mattress2width'];
				} else {
					$orderdetails .= $row['mattresswidth'];
				}
				if ($row['mattress1length'] != '') {
					$orderdetails .= "x".$row['mattress1length'].",".$row['mattress2length'];
				} else {
					$orderdetails .= "x".$row['mattresslength'];
				}
				$orderdetails .= ")";
			}
			if ($row['topperrequired']=='y') {
				$orderdetails .= "<br>".$row['toppertype'];
				if ($row['topperwidth'] != '') {
					$orderdetails .= " (".$row['topperwidth']."x".$row['topperlength'].")";
				}
			}
			if ($row['baserequired']=='y') {
				$orderdetails .= "<br>Base: ".$row['basesavoirmodel'];
				$orderdetails .= " (".$row['basewidth'];
				if ($row['base2width'] != '') {
					$orderdetails .= ",".$row['base2width'];
				}
				$orderdetails .= "x".$row['base2length'];
				if ($row['base2length'] != '') {
					$orderdetails .= ",".$row['base2length'];
				}
				$orderdetails .= ")";
			}
			if ($row['legsrequired']=='y') {
				$orderdetails .= "<br>".$row['legstyle'];
			}
			if ($row['headboardrequired']=='y') {
				$orderdetails .= "<br>".$row['headboardstyle'];
			}
			if ($row['valancerequired']=='y') {
				$orderdetails .= "<br>Valance";
			}
			if ($row['accessoriesrequired']=='y') {
				$orderdetails .= "<br>Accessories";
			}
		}
		return $orderdetails;
		
    }

	function getAllOrders($contactno, $pn) {
		$sql = "select p.PURCHASE_No,p.mattressrequired, p.savoirmodel, p.mattresswidth, p.mattress1width, p.mattress2width, p.mattresslength, p.mattress1length, p.mattress2length, p.topperrequired, p.toppertype, p.topperwidth, p.topperlength, p.baserequired, p.basesavoirmodel, p.basewidth, p.base2width, p.baselength, p.base2length, p.legsrequired, p.legstyle, p.headboardrequired, p.headboardstyle, p.valancerequired, p.accessoriesrequired, p.ORDER_NUMBER,p.ORDER_DATE,p.customerreference,p.BED,p.NOTES,p.salesusername,p.idlocation,l.location,p.orderonhold,p.quote,p.cancelled " ;
		$sql .= "from purchase p, location l where ";
		$sql .= "p.idlocation=l.idlocation and p.contact_no=".$contactno." and (p.quote='n' or p.quote is null) and (p.cancelled='n' or p.cancelled is null) and p.completedorders='n' and P.PURCHASE_No <> ".$pn." group by p.purchase_no";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
	}
	
	
	
	public function getCustomerOrdersTotal($contactNo) {
		$sql = "select sum(total) as tot,sum(totalexvat) as totexvat,ordercurrency from purchase where (cancelled<>'y' or cancelled is null) AND (quote<>'y' or quote is null) AND orderSource<>'Test' AND contact_no=:cn group by ordercurrency";
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');
		
        $overallTotals = [];
        foreach ($rs as $result) {
			$line['ordercurrency'] = $result['ordercurrency'];
			$line['total'] = isset($result['tot']) ? $result['tot'] : 0;
			$line['totExVat'] = isset($result['totexvat']) ? $result['totexvat'] : 0;
            $overallTotals[] = $line;
        }
		$totals['overall'] = $overallTotals;

		$sql = "select sum(total) as tot,sum(totalexvat) as totexvat,ordercurrency from purchase where (cancelled<>'y' or cancelled is null) AND (quote<>'y' or quote is null) AND orderSource<>'Test' AND contact_no=:cn and year(ORDER_DATE) = year(now()) group by ordercurrency";
		$rs = $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');

		$yearTotals = [];
        foreach ($rs as $result) {
			$line['ordercurrency'] = $result['ordercurrency'];
			$line['total'] = isset($result['tot']) ? $result['tot'] : 0;
			$line['totExVat'] = isset($result['totexvat']) ? $result['totexvat'] : 0;
            $yearTotals[] = $line;
        }
		$totals['year'] = $yearTotals;

		$sql = "select count(*) as totalorders from purchase where (cancelled<>'y' or cancelled is null) AND (quote<>'y' or quote is null) AND orderSource<>'Test' AND contact_no=:cn";
		$rs = $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');
		$totals['totalorders'] = $rs[0]['totalorders'];

		return $totals;
	}
}
?>
