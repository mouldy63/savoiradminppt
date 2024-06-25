<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use Cake\ORM\TableRegistry;

class NewSalesFiguresTable extends Table {
    private $myconn;
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('PURCHASE_No');
        $this->myconn = ConnectionManager::get('default');
    }
    
    public function getShowroomMonthActual($idLocation, $month, $year, $isdealer) {
        $fromdate = $year . "-" . $month . "-01 00:00:00";
        $todate = $year . "-" . $month . "-" . cal_days_in_month(CAL_GREGORIAN, intval($month), intval($year)) . " 23:59:59";
        $ordersource='';
        return $this->getShowroomActuals($idLocation, $fromdate, $todate, $ordersource, $isdealer);
    }

    public function getMonthActualsForShowroomAndCurrency($idLocation, $month, $year, $isdealer, $currency) {
        $ordersource='';
        $res = $this->getMonthActualsForShowroom($idLocation, $month, $year, $ordersource, $isdealer);
        return $res[$currency];
    }

    public function getShowroomYearToDate($idLocation, $month, $year, $ordersource, $isdealer) {
        $fromdate = $year . "-01-01 00:00:00";
        $todate = $year . "-" . $month . "-" . cal_days_in_month(CAL_GREGORIAN, intval($month), intval($year)) . " 23:59:59";;
        return $this->getShowroomActuals($idLocation, $fromdate, $todate, $ordersource, $isdealer);
    }

    public function getYearToDateForShowroomAndCurrency($idLocation, $month, $year, $ordersource, $isdealer, $currency) {
    	$ytd = 0.0;
    	for ($m = 1; $m <= $month; $m++) {
    		$res = $this->getMonthActualsForShowroom($idLocation, $m, $year, $ordersource, $isdealer);
    		$ytd += $res[$currency];
    	}
        return $ytd;
    }

    public function getShowroomActuals($idLocation, $fromdate, $todate, $ordersource, $isdealer) {
        $sql = "select sum(p.totalexvat) as actual from purchase p";
        $sql .= " where p.idlocation=:idlocation and p.ORDER_DATE >= '" . $fromdate ."'";
        if ($isdealer=='y') {
        	$sql .= " and orderSource<>'Test'";
        } else {
        	$sql .= " and (orderSource<>'Marketing' and orderSource<>'Test' and orderSource<>'Stock' and orderSource<>'Floorstock')";
        }
        $sql .= " and p.ORDER_DATE <= '" . $todate ."'";
        if (isset($ordersource) && !empty($ordersource)) {
			if ($ordersource=='Client') {
			   $sql .= " and orderSource IN ('Client Retail', 'Client')";
			} else {
				$sql .= " and orderSource = '".$ordersource."'";
			}
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $actual = $this->myconn->execute($sql, ['idlocation' => $idLocation])->fetchAll('assoc')[0]['actual'];
        if ($actual === null) {
            $actual = 0;
        }
        
        $sql = "select sum(p.totalexvat) as actual from purchase p";
        $sql .= " join purchase_coupon pc on p.PURCHASE_No=pc.purchase_no";
        $sql .= " where pc.virtual_idlocation=:idlocation and p.ORDER_DATE >= '" . $fromdate . "' and p.ORDER_DATE <= '" . $todate ."'";
        if (isset($ordersource) && !empty($ordersource)) {
			if ($ordersource=='Client') {
			   $sql .= " and p.orderSource IN ('Client Retail', 'Client')";
			} else {
				$sql .= " and p.orderSource = '".$ordersource."'";
			}
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $virtActual = $this->myconn->execute($sql, ['idlocation' => $idLocation])->fetchAll('assoc')[0]['actual'];
        if ($virtActual === null) {
            $virtActual = 0;
        }
        return $actual + $virtActual;
    }

    public function getMonthActualsForShowroom($idLocation, $month, $year, $ordersource, $isdealer) {
        $sql = "select sum(p.totalexvat) as actual from purchase p";
        $sql .= " where p.idlocation=:idlocation and month(p.ORDER_DATE) = " . $month . " and year(p.ORDER_DATE) = " . $year;
        if ($isdealer=='y') {
        	$sql .= " and orderSource<>'Test'";
        } else {
        	$sql .= " and (orderSource<>'Marketing' and orderSource<>'Test' and orderSource<>'Stock' and orderSource<>'Floorstock')";
        }
        if (isset($ordersource) && !empty($ordersource)) {
			if ($ordersource=='Client') {
			   $sql .= " and orderSource IN ('Client Retail', 'Client')";
			} else {
				$sql .= " and orderSource = '".$ordersource."'";
			}
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $actual = $this->myconn->execute($sql, ['idlocation' => $idLocation])->fetchAll('assoc')[0]['actual'];
        if ($actual === null) {
            $actual = 0;
        }
        
        $sql = "select sum(p.totalexvat) as actual from purchase p";
        $sql .= " join purchase_coupon pc on p.PURCHASE_No=pc.purchase_no";
        $sql .= " where pc.virtual_idlocation=:idlocation";
        $sql .= " and month(p.ORDER_DATE) = " . $month . " and year(p.ORDER_DATE) = " . $year; 
        if (isset($ordersource) && !empty($ordersource)) {
			if ($ordersource=='Client') {
			   $sql .= " and p.orderSource IN ('Client Retail', 'Client')";
			} else {
				$sql .= " and p.orderSource = '".$ordersource."'";
			}
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $virtActual = $this->myconn->execute($sql, ['idlocation' => $idLocation])->fetchAll('assoc')[0]['actual'];
        if ($virtActual === null) {
            $virtActual = 0;
        }
        
		$saleFigureExchangeRate = TableRegistry::getTableLocator()->get('SaleFigureExchangeRate');
		$location = TableRegistry::getTableLocator()->get('Location');

        $showroomCurrencyCode = $location->get($idLocation)['currency'];
		$usdRate = $saleFigureExchangeRate->getExchangeRate($year, $month, 'USD');
		$eurRate = $saleFigureExchangeRate->getExchangeRate($year, $month, 'EUR');

        $resNative = $actual + $virtActual;
        if ($showroomCurrencyCode == 'GBP') {
            $resGBP = $resNative;
            $resUSD = $resNative * $usdRate;
            $resEUR = $resNative * $eurRate;
        } else if ($showroomCurrencyCode == 'USD') {
            $resGBP = $resNative / $usdRate;
            $resUSD = $resNative;
            $resEUR = $resNative / $usdRate * $eurRate;
        } else if ($showroomCurrencyCode == 'EUR') {
            $resGBP = $resNative / $eurRate;
            $resUSD = $resNative / $eurRate * $usdRate;
            $resEUR = $resNative;
        }
        
        return ['native' => $resNative, 'GBP' => $resGBP, 'USD' => $resUSD, 'EUR' => $resEUR];
    }

    public function getShowroomActualsPerOrdersource($idLocation, $month, $year, $ordersource) {
        $sql = "select sum(totalexvat) as actual from purchase";
        $sql .= " where idlocation=".$idLocation ." and YEAR(ORDER_DATE) = " . $year . " and MONTH(ORDER_DATE) = " . $month ."";
		if ($ordersource=='Client') {
		   $sql .= " and orderSource IN ('Client Retail', 'Client')";
		} else {
			$sql .= " and orderSource = '".$ordersource."'";
		}
        $sql .= " and quote = 'n' and orderonhold = 'n' and (cancelled is null OR cancelled <> 'y')";
        $actual = $this->myconn->execute($sql)->fetchAll('assoc')[0]['actual'];
        if ($actual === null) {
            $actual = 0;
        }
        return $actual;
    }
    
        public function getShowroomActualsEcom($idLocation, $month, $year) {
        $sql = "select sum(totalexvat) as actual from purchase p, purchase_coupon pc";
        $sql .= " where p.PURCHASE_No=pc.purchase_no and pc.virtual_idlocation=".$idLocation ." and YEAR(ORDER_DATE) = " . $year . " and MONTH(ORDER_DATE) = " . $month ."";
        $sql .= " and orderSource <> 'Test' and quote = 'n' and orderonhold = 'n' and (cancelled is null OR cancelled <> 'y')";
        $actual = $this->myconn->execute($sql)->fetchAll('assoc')[0]['actual'];
        if ($actual === null) {
            $actual = 0;
        }
        return $actual;
    }
    
    public function getShowroomOrdersPerOrdersource($idLocation, $month, $year, $ordersource) {
        $sql = "select p.ORDER_NUMBER, c.surname, p.ORDER_DATE, a.company, p.customerreference, p.totalexvat, p.mattressrequired, p.baserequired, p.topperrequired, p.valancerequired, p.legsrequired, p.headboardrequired, p.accessoriesrequired, p.savoirmodel, p.toppertype, p.deliverycharge, p.basesavoirmodel from purchase p, contact c, address a";
        $sql .= " where p.contact_no=c.CONTACT_NO and c.CODE=a.CODE and p.idlocation=".$idLocation ." and YEAR(p.ORDER_DATE) = " . $year . " and MONTH(p.ORDER_DATE) = " . $month ."";
		if ($ordersource=='Client') {
		   $sql .= " and p.orderSource IN ('Client Retail', 'Client')";
		} else {
			$sql .= " and p.orderSource = '".$ordersource."'";
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        return $this->myconn->execute($sql)->fetchAll('assoc');
    }
    
     public function getShowroomEcomOrders($idLocation, $month, $year) {
        $sql = "select p.ORDER_NUMBER, c.surname, p.ORDER_DATE, a.company, p.customerreference, p.totalexvat, p.mattressrequired, p.baserequired, p.topperrequired, p.valancerequired, p.legsrequired, p.headboardrequired, p.accessoriesrequired, p.savoirmodel, p.toppertype, p.deliverycharge, p.basesavoirmodel from purchase p, contact c, address a, purchase_coupon pc";
        $sql .= " where p.PURCHASE_No=pc.purchase_no and p.contact_no=c.CONTACT_NO and c.CODE=a.CODE and pc.virtual_idlocation=".$idLocation ." and YEAR(p.ORDER_DATE) = " . $year . " and MONTH(p.ORDER_DATE) = " . $month ."";
        $sql .= " and p.orderSource<>'Test' and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        return $this->myconn->execute($sql)->fetchAll('assoc');
    }
    
    
    public function getShowroomActualsPerModel($idLocation, $month, $year, $model, $ordersource) {
        $sql = "select sum(p.totalexvat) as actual from purchase p";
        $sql .= " where p.mattressrequired='y' and p.idlocation=".$idLocation ." and YEAR(p.ORDER_DATE) = " . $year . " and MONTH(p.ORDER_DATE) = " . $month ."";
		if ($ordersource=='Client') {
		   $sql .= " and orderSource IN ('Client Retail', 'Client')";
		} else {
			$sql .= " and orderSource = '".$ordersource."'";
		}
		if ($model=='No. 1') {
		   $sql .= " and (savoirmodel='No. 1' or savoirmodel='State')";
		} else if ($model=='No. 2'){
			$sql .= " and (savoirmodel='No. 2' or savoirmodel='French Mattress')";
		} else if ($model=='No. 3'){
			$sql .= " and savoirmodel = 'No. 3'";
		} else if ($model=='No. 4'){
			$sql .= " and (savoirmodel='No. 4' or savoirmodel='No. 4v')";
        } else if ($model=='No. 5'){
                $sql .= " and savoirmodel='No. 5'";
		} else  if ($model=='n') {
			$sql .= " and savoirmodel='".$model."'";
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $actual = $this->myconn->execute($sql)->fetchAll('assoc')[0]['actual'];
        if ($actual === null) {
            $actual = 0;
        }
        
        $sql = "select sum(p.totalexvat) as actual from purchase p";
        $sql .= " join purchase_coupon pc on p.PURCHASE_No=pc.purchase_no";
        $sql .= " where p.mattressrequired='y' and pc.virtual_idlocation=".$idLocation ." and YEAR(p.ORDER_DATE) = '" . $year . "' and MONTH(p.ORDER_DATE) = '" . $month ."'";
        if ($ordersource=='Client') {
		   $sql .= " and p.orderSource IN ('Client Retail', 'Client')";
		} else {
			$sql .= " and p.orderSource = '".$ordersource."'";
		}
		if ($model=='No. 1') {
		   $sql .= " and (p.savoirmodel='No. 1' or p.savoirmodel='State')";
		} else if ($model=='No. 2'){
			$sql .= " and (p.savoirmodel='No. 2' or p.savoirmodel='French Mattress')";
		} else if ($model=='No. 3'){
			$sql .= " and p.savoirmodel = 'No. 3'";
		} else if ($model=='No. 4'){
			$sql .= " and (p.savoirmodel='No. 4' or p.savoirmodel='No. 4v')";
        } else if ($model=='No. 5'){
                $sql .= " and p.savoirmodel='No. 5'";
		} else if ($model=='n') {
			$sql .= " and savoirmodel='".$model."'";
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $virtActual = $this->myconn->execute($sql)->fetchAll('assoc')[0]['actual'];
        if ($virtActual === null) {
            $virtActual = 0;
        }
        return $actual + $virtActual;
    }
    
    public function getExtraActuals($idLocation, $month, $year, $ordersource) {
        $sql = "select sum(p.totalexvat) as actual from purchase p";
        $sql .= " where p.mattressrequired='n' and (p.baserequired='y' OR p.legsrequired='y' OR p.headboardrequired='y' OR p.valancerequired='y') and p.idlocation=".$idLocation ." and YEAR(p.ORDER_DATE) = " . $year . " and MONTH(p.ORDER_DATE) = " . $month ."";
		if ($ordersource=='Client') {
		   $sql .= " and orderSource IN ('Client Retail', 'Client')";
		} else {
			$sql .= " and orderSource = '".$ordersource."'";
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $actual = $this->myconn->execute($sql)->fetchAll('assoc')[0]['actual'];
        if ($actual === null) {
            $actual = 0;
        }
        
        $sql = "select sum(p.totalexvat) as actual from purchase p";
        $sql .= " join purchase_coupon pc on p.PURCHASE_No=pc.purchase_no";
        $sql .= " where p.mattressrequired='n' and (p.baserequired='y' OR p.legsrequired='y' OR p.headboardrequired='y' OR p.valancerequired='y') and  pc.virtual_idlocation=".$idLocation ." and YEAR(p.ORDER_DATE) = '" . $year . "' and MONTH(p.ORDER_DATE) = '" . $month ."'";
        if ($ordersource=='Client') {
		   $sql .= " and p.orderSource IN ('Client Retail', 'Client')";
		} else {
			$sql .= " and p.orderSource = '".$ordersource."'";
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $virtActual = $this->myconn->execute($sql)->fetchAll('assoc')[0]['actual'];
        if ($virtActual === null) {
            $virtActual = 0;
        }
        return $actual + $virtActual;
    }

	public function getTopperActuals($idLocation, $month, $year, $ordersource) {
        $sql = "select sum(p.totalexvat) as actual from purchase p";
        $sql .= " where p.mattressrequired='n' and p.baserequired='n' and p.legsrequired='n' and p.headboardrequired='n' and p.valancerequired='n' and p.topperrequired='y' and p.idlocation=".$idLocation ." and YEAR(p.ORDER_DATE) = " . $year . " and MONTH(p.ORDER_DATE) = " . $month ."";
		if ($ordersource=='Client') {
		   $sql .= " and orderSource IN ('Client Retail', 'Client')";
		} else {
			$sql .= " and orderSource = '".$ordersource."'";
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $actual = $this->myconn->execute($sql)->fetchAll('assoc')[0]['actual'];
        if ($actual === null) {
            $actual = 0;
        }
        
        $sql = "select sum(p.totalexvat) as actual from purchase p";
        $sql .= " join purchase_coupon pc on p.PURCHASE_No=pc.purchase_no";
        $sql .= " where p.mattressrequired='n' and p.baserequired='n' and p.legsrequired='n' and p.headboardrequired='n' and p.valancerequired='n' and p.topperrequired='y' and pc.virtual_idlocation=".$idLocation ." and YEAR(p.ORDER_DATE) = '" . $year . "' and MONTH(p.ORDER_DATE) = '" . $month ."'";
        if ($ordersource=='Client') {
		   $sql .= " and p.orderSource IN ('Client Retail', 'Client')";
		} else {
			$sql .= " and p.orderSource = '".$ordersource."'";
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $virtActual = $this->myconn->execute($sql)->fetchAll('assoc')[0]['actual'];
        if ($virtActual === null) {
            $virtActual = 0;
        }
        return $actual + $virtActual;
    }
    
    	public function getAccActuals($idLocation, $month, $year, $ordersource) {
        $sql = "select sum(p.totalexvat) as actual from purchase p";
        $sql .= " where p.mattressrequired='n'  and p.baserequired='n' and p.legsrequired='n' and p.headboardrequired='n' and p.valancerequired='n' and p.topperrequired='n' and accessoriesrequired='y' and p.idlocation=".$idLocation ." and YEAR(p.ORDER_DATE) = " . $year . " and MONTH(p.ORDER_DATE) = " . $month ."";
		if ($ordersource=='Client') {
		   $sql .= " and orderSource IN ('Client Retail', 'Client')";
		} else {
			$sql .= " and orderSource = '".$ordersource."'";
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $actual = $this->myconn->execute($sql)->fetchAll('assoc')[0]['actual'];
        if ($actual === null) {
            $actual = 0;
        }
        
        $sql = "select sum(p.totalexvat) as actual from purchase p";
        $sql .= " join purchase_coupon pc on p.PURCHASE_No=pc.purchase_no";
        $sql .= " where p.mattressrequired='n'  and p.baserequired='n' and p.legsrequired='n' and p.headboardrequired='n' and p.valancerequired='n' and p.topperrequired='n' and accessoriesrequired='y' and pc.virtual_idlocation=".$idLocation ." and YEAR(p.ORDER_DATE) = '" . $year . "' and MONTH(p.ORDER_DATE) = '" . $month ."'";
        if ($ordersource=='Client') {
		   $sql .= " and p.orderSource IN ('Client Retail', 'Client')";
		} else {
			$sql .= " and p.orderSource = '".$ordersource."'";
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $virtActual = $this->myconn->execute($sql)->fetchAll('assoc')[0]['actual'];
        if ($virtActual === null) {
            $virtActual = 0;
        }
        return $actual + $virtActual;
    }
    
    
    public function getEcomActuals($idLocation, $month, $year, $ordersource) {        
        $sql = "select sum(p.totalexvat) as ecomvalue from purchase p";
        $sql .= " join purchase_coupon pc on p.PURCHASE_No=pc.purchase_no";
        $sql .= " where pc.virtual_idlocation=".$idLocation ." and YEAR(p.ORDER_DATE) = '" . $year . "' and MONTH(p.ORDER_DATE) = '" . $month ."'";
        if ($ordersource=='Client') {
		   $sql .= " and p.orderSource IN ('Client Retail', 'Client')";
		} else {
			$sql .= " and p.orderSource = '".$ordersource."'";
		}
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $ecomvalue = $this->myconn->execute($sql)->fetchAll('assoc')[0]['ecomvalue'];
        if ($ecomvalue === null) {
            $ecomvalue = 0;
        }
        return $ecomvalue;
    }
    
     public function getNoEcom($idLocation, $month, $year) {
        $sql = "SELECT COUNT(p.PURCHASE_No) as noecom FROM purchase p";
        $sql .= " join purchase_coupon pc on p.PURCHASE_No=pc.purchase_no";
        $sql .= " where pc.virtual_idlocation=".$idLocation ." and YEAR(p.ORDER_DATE) = '" . $year . "' and MONTH(p.ORDER_DATE) = '" . $month ."'";
		$sql .= " and (p.cancelled is null OR p.cancelled <> 'y') AND p.quote = 'n' and p.orderonhold = 'n' and p.orderSource <> 'Test' and p.orderSource <> 'Marketing' and p.orderSource <> 'Floorstock' and p.orderSource<> 'Stock'"; 
        $noecom = $this->myconn->execute($sql)->fetchAll('assoc')[0]['noecom'];
        if ($noecom === null) {
            $noecom = 0;
        }
        return $noecom;
    }
    
    
    
    
     public function getDeliveryCharges($idLocation, $month, $year, $ordersource) {
        $sql = "select sum(deliveryprice) as deliverytotal from purchase WHERE";
        $sql .= " mattressrequired='n' and baserequired='n' and topperrequired='n' and legsrequired='n' and valancerequired='n' and headboardrequired='n' and accessoriesrequired='n' and deliverycharge='y' and deliveryprice <> '' and idlocation=".$idLocation ." and YEAR(ORDER_DATE) = " . $year . " and MONTH(ORDER_DATE) = " . $month ."";
		if ($ordersource=='Client') {
		   $sql .= " and orderSource IN ('Client Retail', 'Client')";
		} else {
			$sql .= " and orderSource = '".$ordersource."'";
		}
        $sql .= " and quote = 'n' and orderonhold = 'n' and (cancelled is null OR cancelled <> 'y')";
        $deliverytotal = $this->myconn->execute($sql)->fetchAll('assoc')[0]['deliverytotal'];
        if ($deliverytotal === null) {
            $deliverytotal = 0;
        }
         return $deliverytotal;
    }
    
    public function getNoDeliveryCharges($idLocation, $month, $year) {
        $sql = "SELECT COUNT(PURCHASE_No) as noDelCharges FROM `purchase` WHERE ";
        $sql .= " mattressrequired='n' and baserequired='n' and topperrequired='n' and legsrequired='n' and valancerequired='n' and headboardrequired='n' and accessoriesrequired='n' and deliverycharge='y' and deliveryprice <> ''";
        $sql .= " AND MONTH(ORDER_DATE)=".$month." and YEAR(ORDER_DATE)=".$year." and idlocation=".$idLocation." and (cancelled is null OR cancelled <> 'y') AND quote = 'n' and orderonhold = 'n' and orderSource <> 'Test' and orderSource <> 'Marketing' and orderSource <> 'Floorstock' and orderSource<> 'Stock'";

        $noDelCharges = $this->myconn->execute($sql)->fetchAll('assoc')[0]['noDelCharges'];
        if ($noDelCharges === null) {
            $noDelCharges = 0;
        }
        return $noDelCharges;
    }

    
    public function getNoSold($idLocation, $month, $year, $dbcol, $model) {
        $sql = "SELECT COUNT(PURCHASE_No) as nosold FROM `purchase` WHERE ";
        if ($dbcol=='toppertype') {
           $sql .= "mattressrequired='n' and baserequired='n' and legsrequired='n' and headboardrequired='n' and valancerequired='n' and  topperrequired='y'";
        } else if ($dbcol=='extras') {
           $sql .= "mattressrequired='n' and (baserequired='y' OR legsrequired='y' OR headboardrequired='y' OR valancerequired='y' OR topperrequired='y')";
        } else if ($dbcol=='acc') {
           $sql .= "mattressrequired='n' and baserequired='n' and legsrequired='n' and headboardrequired='n' and valancerequired='n' and topperrequired='n' and accessoriesrequired='y'";
        } else {
   	       $sql .= $dbcol."='".$model."' and mattressrequired='y'";
        }
        $sql .= " AND MONTH(ORDER_DATE)=".$month." and YEAR(ORDER_DATE)=".$year." and idlocation=".$idLocation." and (cancelled is null OR cancelled <> 'y') AND quote = 'n' and orderonhold = 'n' and orderSource <> 'Test' and orderSource <> 'Marketing' and orderSource <> 'Floorstock' and orderSource<> 'Stock'";
        
        $nosold = $this->myconn->execute($sql)->fetchAll('assoc')[0]['nosold'];
        if ($nosold === null) {
            $nosold = 0;
        }
        return $nosold;
    }
    
    public function getDeductedCouponMonthActualByCurrency($month, $year, $dispcurr) {
        return $this->getDeductedCouponActuals($month, $year, $dispcurr);
    }

    public function getDeductedCouponYearToDateByCurrency($month, $year, $dispcurr) {
    	$actual = 0.0;
    	for ($m = 1; $m <= $month; $m++) {
    		$actual += $this->getDeductedCouponActuals($m, $year, $dispcurr);
    	}
        return $actual;
    }
    
    public function getDeductedCouponActuals($month, $year, $currency) {
        $sql = "select sum(p.totalexvat) as actual, p.ordercurrency from purchase p";
        $sql .= " join purchase_coupon pc on p.purchase_no=pc.purchase_no and virtual_idlocation is not null";
        $sql .= " where month(p.ORDER_DATE) = " . $month . " and year(p.ORDER_DATE) = " . $year;
        $sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled is null OR p.cancelled <> 'y')";
        $sql .= " group by p.ordercurrency";
        $rs = $this->myconn->execute($sql)->fetchAll('assoc');
        
		$saleFigureExchangeRate = TableRegistry::getTableLocator()->get('SaleFigureExchangeRate');
        $virtActual = 0.0;
        foreach ($rs as $row) {
        	if ($currency == $row['ordercurrency']) {
        		$virtActual += $row['actual'];
        	} else {
        		$dispRate = $saleFigureExchangeRate->getExchangeRate($year, $month, $currency);
        		$rowRate = $saleFigureExchangeRate->getExchangeRate($year, $month, $row['ordercurrency']);
        		$virtActual += $row['actual'] / $rowRate * $dispRate;
        	}
        }
        
        return $virtActual;
    }
}

?>
