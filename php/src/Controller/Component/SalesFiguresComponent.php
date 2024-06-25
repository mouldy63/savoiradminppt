<?php

namespace App\Controller\Component;

use Cake\ORM\TableRegistry;
use \DateTime;

class SalesFiguresComponent extends \Cake\Controller\Component {
	
	public function initialize($config): void {
        parent::initialize($config);
        $this->Location = TableRegistry::getTableLocator()->get('Location');
        $this->NewSalesFigures = TableRegistry::getTableLocator()->get('NewSalesFigures');
        $this->SaleFigureTarget = TableRegistry::getTableLocator()->get('SaleFigureTarget');
        $this->SaleFigureExchangeRate = TableRegistry::getTableLocator()->get('SaleFigureExchangeRate');
    }

    public function fetchMonthlyData($month, $year, $dispcurr) {
        $dateObj = DateTime::createFromFormat('!m', $month);
        $monthName = $dateObj->format('F');
        $temp = $this->getMonthlyData($month, $year, $monthName, $dispcurr);
        return $temp[0];
    }

	public function getMonthlyData($month, $year, $monthName, $dispcurr) {
    	if ($dispcurr == 'native') {
	        $exchangeRate['GBP'] = 1.0;
	        $exchangeRate['USD'] = $this->SaleFigureExchangeRate->getExchangeRate($year, $month, 'USD');
	        $exchangeRate['EUR'] = $this->SaleFigureExchangeRate->getExchangeRate($year, $month, 'EUR');
	        $lastYearExchangeRate['GBP'] = 1.0;
	        $lastYearExchangeRate['USD'] = $this->SaleFigureExchangeRate->getExchangeRate($year-1, $month, 'USD');
	        $lastYearExchangeRate['EUR'] = $this->SaleFigureExchangeRate->getExchangeRate($year-1, $month, 'EUR');
    	} else {
            $exchangeRate['GBP'] = 1.0;
            $exchangeRate['USD'] = 1.0;
            $exchangeRate['EUR'] = 1.0;
            $lastYearExchangeRate['GBP'] = 1.0;
            $lastYearExchangeRate['USD'] = 1.0;
            $lastYearExchangeRate['EUR'] = 1.0;
    	}
        
        $dateHeader = $monthName . ' ' . $year;
        
        $data = [];
        $metadata = [];
        $a = [$dateHeader, 'Month Actual', 'Month Target', 'Prior Year('.$monthName.')', 'Prior Year To Date('.($year-1).')', 'Year to Date Target', 'Year to Date Actual', 'Year to Date VS Prior Year to Date in Sales Currency', 'Year to Date VS Prior Year to Date in %', 'Year to Date Actual VS Year to Date Target in Sales Currency', 'Year to Date Actual VS Year to Date Target in %'];
        array_push($data, $a);
        array_push($metadata, 0);
        
        $showrooms = $this->Location->find('all', ['conditions'=> ['retire' => 'n'], 'order' => ['SavoirOwned' => 'desc', 'location' => 'asc']]);
        
        $monthActualTotal = 0.0;
        $monthTargetTotal = 0.0;
        $lastYearMonthActualTotal = 0.0;
        $lastYearToDateTotal = 0.0;
        $yearToDateTargetTotal = 0.0;
        $yearToDateActualTotal = 0.0;
        $ytdMinusLastYtdTotal = 0.0;
        $ytdActualVsYtdTargetTotal = 0.0;

        $monthActualTotalTotal = 0.0;
        $monthTargetTotalTotal = 0.0;
        $lastYearMonthActualTotalTotal = 0.0;
        $lastYearToDateTotalTotal = 0.0;
        $yearToDateTargetTotalTotal = 0.0;
        $yearToDateActualTotalTotal = 0.0;
        $ytdMinusLastYtdTotalTotal = 0.0;
        $ytdActualVsYtdTargetTotalTotal = 0.0;
        
        $doingOwnedShowrooms = true;
        array_push($data, ['Savoir Owned']);
        array_push($metadata, 0);
        
        foreach ($showrooms as $showroom) {
        	$totalsCurrency = 'GBP';
        	$itemsCurrency = $showroom['currency'];
            if ($dispcurr != "native") {
            	$totalsCurrency = $dispcurr;
            	$itemsCurrency = $dispcurr;
            }
			$isdealer='n';
			if ($showroom['SavoirOwned'] == 'n') {
				$isdealer='y';
			}
            if ($doingOwnedShowrooms && $showroom['SavoirOwned'] == 'n') {
                $doingOwnedShowrooms = false;
                // dump the interim data
                // coupon double accounting
                $monthActual = -1*$this->NewSalesFigures->getDeductedCouponMonthActualByCurrency($month, $year, $dispcurr == 'native' ? 'GBP' : $dispcurr);
                $monthTarget = 0.0;
                $lastYearMonthActual = -1*$this->NewSalesFigures->getDeductedCouponMonthActualByCurrency($month, $year-1, $dispcurr == 'native' ? 'GBP' : $dispcurr);
                $lastYearToDate = -1*$this->NewSalesFigures->getDeductedCouponYearToDateByCurrency($month, $year-1, $dispcurr == 'native' ? 'GBP' : $dispcurr);
                $yearToDateTarget = 0.0;
                $yearToDateActual = -1*$this->NewSalesFigures->getDeductedCouponYearToDateByCurrency($month, $year, $dispcurr == 'native' ? 'GBP' : $dispcurr);
                
                $ytdMinusLastYtd = $yearToDateActual - $lastYearToDate;
                $ytdMinusLastYtdPc = 0.0;
                if ($lastYearToDate != 0) {
                    $ytdMinusLastYtdPc = 100.0 * $ytdMinusLastYtd / $lastYearToDate;
                }
                $ytdActualVsYtdTarget = $yearToDateActual - $yearToDateTarget;
                $ytdActualVsYtdTargetPc = 0.0;
                if ($yearToDateTarget != 0.0) {
                    $ytdActualVsYtdTargetPc = 100.0 * $ytdActualVsYtdTarget / $yearToDateTarget;
                }
                
                $monthActualTotal += $monthActual;
                $monthTargetTotal += $monthTarget;
                $lastYearMonthActualTotal += $lastYearMonthActual;
                $lastYearToDateTotal += $lastYearToDate;
                $yearToDateTargetTotal += $yearToDateTarget;
                $yearToDateActualTotal += $yearToDateActual;
                $ytdMinusLastYtdTotal += $ytdMinusLastYtd;
                $ytdActualVsYtdTargetTotal += $ytdActualVsYtdTarget;
                
                $a = [];
                array_push($a, 'Deducted Coupon Codes (' . $totalsCurrency . ')');
                array_push($a, number_format((float)$monthActual, 2, '.', ','));
                array_push($a, number_format((float)$monthTarget, 2, '.', ','));
                array_push($a, number_format((float)$lastYearMonthActual, 2, '.', ','));
                array_push($a, number_format((float)$lastYearToDate, 2, '.', ','));
                array_push($a, number_format((float)$yearToDateTarget, 2, '.', ','));
                array_push($a, number_format((float)$yearToDateActual, 2, '.', ','));
                array_push($a, number_format((float)$ytdMinusLastYtd, 2, '.', ','));
                array_push($a, number_format((float)$ytdMinusLastYtdPc, 0, '.', ',') . '%');
                array_push($a, number_format((float)$ytdActualVsYtdTarget, 2, '.', ','));
                array_push($a, number_format((float)$ytdActualVsYtdTargetPc, 0, '.', ',') . '%');
                array_push($data, $a);
                array_push($metadata, 999);
                $a = [];
                array_push($a, 'Owned Subtotal (' . $totalsCurrency . ')');
                array_push($a, number_format((float)$monthActualTotal, 2, '.', ','));
                array_push($a, number_format((float)$monthTargetTotal, 2, '.', ','));
                array_push($a, number_format((float)$lastYearMonthActualTotal, 2, '.', ','));
                array_push($a, number_format((float)$lastYearToDateTotal, 2, '.', ','));
                array_push($a, number_format((float)$yearToDateTargetTotal, 2, '.', ','));
                array_push($a, number_format((float)$yearToDateActualTotal, 2, '.', ','));
                array_push($a, number_format((float)$ytdMinusLastYtdTotal, 2, '.', ','));
                array_push($a, ' ');
                array_push($a, number_format((float)$ytdActualVsYtdTargetTotal, 2, '.', ','));
                array_push($a, ' ');
                array_push($data, $a);
                array_push($metadata, 0);
                
                $monthActualTotalTotal = $monthActualTotal;
                $monthTargetTotalTotal = $monthTargetTotal;
                $lastYearMonthActualTotalTotal = $lastYearMonthActualTotal;
                $lastYearToDateTotalTotal = $lastYearToDateTotal;
                $yearToDateTargetTotalTotal = $yearToDateTargetTotal;
                $yearToDateActualTotalTotal = $yearToDateActualTotal;
                $ytdMinusLastYtdTotalTotal = $ytdMinusLastYtdTotal;
                $ytdActualVsYtdTargetTotalTotal = $ytdActualVsYtdTargetTotal;
                
                $monthActualTotal = 0.0;
                $monthTargetTotal = 0.0;
                $lastYearMonthActualTotal = 0.0;
                $lastYearToDateTotal = 0.0;
                $yearToDateTargetTotal = 0.0;
                $yearToDateActualTotal = 0.0;
                $ytdMinusLastYtdTotal = 0.0;
                $ytdActualVsYtdTargetTotal = 0.0;
            
                array_push($data, [' ']);
                array_push($metadata, 0);
                array_push($data, ['Dealers']);
                array_push($metadata, 0);
            }
            
            $monthActual = $this->NewSalesFigures->getMonthActualsForShowroomAndCurrency($showroom['idlocation'], $month, $year, $isdealer, $dispcurr);
            $monthTarget = $this->SaleFigureTarget->getMonthTargetForShowroomAndCurrency($year, $month, $showroom['idlocation'], $dispcurr);
            $lastYearMonthActual = $this->NewSalesFigures->getMonthActualsForShowroomAndCurrency($showroom['idlocation'], $month, $year-1, $isdealer, $dispcurr);
            $lastYearToDate = $this->NewSalesFigures->getYearToDateForShowroomAndCurrency($showroom['idlocation'], $month, $year-1, '', $isdealer, $dispcurr);
            $yearToDateTarget = $this->SaleFigureTarget->getYtdTargetForShowroomAndCurrency($showroom['idlocation'], $month, $year, $dispcurr);
            $yearToDateActual = $this->NewSalesFigures->getYearToDateForShowroomAndCurrency($showroom['idlocation'], $month, $year, '', $isdealer, $dispcurr);
            $ytdMinusLastYtd = $yearToDateActual - $lastYearToDate;
            $ytdMinusLastYtdPc = 0.0;
            if ($lastYearToDate != 0) {
                $ytdMinusLastYtdPc = 100.0 * $ytdMinusLastYtd / $lastYearToDate;
            }
            $ytdActualVsYtdTarget = $yearToDateActual - $yearToDateTarget;
            $ytdActualVsYtdTargetPc = 0.0;
            if ($yearToDateTarget != 0.0) {
                $ytdActualVsYtdTargetPc = 100.0 * $ytdActualVsYtdTarget / $yearToDateTarget;
            }
            
            $name = $showroom['location'].' (' . $itemsCurrency . ')';
            $a = [];
            array_push($a, $name);
            array_push($a, number_format((float)$monthActual, 2, '.', ','));
            array_push($a, number_format((float)$monthTarget, 2, '.', ','));
            array_push($a, number_format((float)$lastYearMonthActual, 2, '.', ','));
            array_push($a, number_format((float)$lastYearToDate, 2, '.', ','));
            array_push($a, number_format((float)$yearToDateTarget, 2, '.', ','));
            array_push($a, number_format((float)$yearToDateActual, 2, '.', ','));
            array_push($a, number_format((float)$ytdMinusLastYtd, 2, '.', ','));
            array_push($a, number_format((float)$ytdMinusLastYtdPc, 0, '.', ',') . '%');
            array_push($a, number_format((float)$ytdActualVsYtdTarget, 2, '.', ','));
            array_push($a, number_format((float)$ytdActualVsYtdTargetPc, 0, '.', ',') . '%');
            array_push($data, $a);
            array_push($metadata, $showroom['idlocation']);
            
            $monthActualTotal += $monthActual / $exchangeRate[$showroom['currency']];
            $monthTargetTotal += $monthTarget / $exchangeRate[$showroom['currency']];
            $lastYearMonthActualTotal += $lastYearMonthActual / $lastYearExchangeRate[$showroom['currency']];
            $lastYearToDateTotal += $lastYearToDate / $lastYearExchangeRate[$showroom['currency']];
            $yearToDateTargetTotal += $yearToDateTarget / $exchangeRate[$showroom['currency']];
            $yearToDateActualTotal += $yearToDateActual / $exchangeRate[$showroom['currency']];
            $ytdMinusLastYtdTotal += $ytdMinusLastYtd / $exchangeRate[$showroom['currency']];
            $ytdActualVsYtdTargetTotal += $ytdActualVsYtdTarget / $exchangeRate[$showroom['currency']];
        }
 
        $a = [];
        array_push($a, 'Dealer Subtotal (' . $totalsCurrency . ')');
        array_push($a, number_format((float)$monthActualTotal, 2, '.', ','));
        array_push($a, number_format((float)$monthTargetTotal, 2, '.', ','));
        array_push($a, number_format((float)$lastYearMonthActualTotal, 2, '.', ','));
        array_push($a, number_format((float)$lastYearToDateTotal, 2, '.', ','));
        array_push($a, number_format((float)$yearToDateTargetTotal, 2, '.', ','));
        array_push($a, number_format((float)$yearToDateActualTotal, 2, '.', ','));
        array_push($a, number_format((float)$ytdMinusLastYtdTotal, 2, '.', ','));
        array_push($a, ' ');
        array_push($a, number_format((float)$ytdActualVsYtdTargetTotal, 2, '.', ','));
        array_push($a, ' ');
        array_push($data, $a);
        array_push($metadata, 0);
        
        $monthActualTotalTotal += $monthActualTotal;
        $monthTargetTotalTotal += $monthTargetTotal;
        $lastYearMonthActualTotalTotal += $lastYearMonthActualTotal;
        $lastYearToDateTotalTotal += $lastYearToDateTotal;
        $yearToDateTargetTotalTotal += $yearToDateTargetTotal;
        $yearToDateActualTotalTotal += $yearToDateActualTotal;
        $ytdMinusLastYtdTotalTotal += $ytdMinusLastYtdTotal;
        $ytdActualVsYtdTargetTotalTotal += $ytdActualVsYtdTargetTotal;
        
        array_push($data, [' ']);
        array_push($metadata, 0);
        $a = [];
        array_push($a, 'TOTAL (' . $totalsCurrency . ')');
        array_push($a, number_format((float)$monthActualTotalTotal, 2, '.', ','));
        array_push($a, number_format((float)$monthTargetTotalTotal, 2, '.', ','));
        array_push($a, number_format((float)$lastYearMonthActualTotalTotal, 2, '.', ','));
        array_push($a, number_format((float)$lastYearToDateTotalTotal, 2, '.', ','));
        array_push($a, number_format((float)$yearToDateTargetTotalTotal, 2, '.', ','));
        array_push($a, number_format((float)$yearToDateActualTotalTotal, 2, '.', ','));
        array_push($a, number_format((float)$ytdMinusLastYtdTotalTotal, 2, '.', ','));
        array_push($a, ' ');
        array_push($a, number_format((float)$ytdActualVsYtdTargetTotalTotal, 2, '.', ','));
        array_push($a, ' ');
        array_push($data, $a);
        array_push($metadata, 0);
        
        // make sure all rows have 11 cols
        $newData = [];
        foreach ($data as $row) {
        	$colCount = count($row);
        	for ($n = 0; $n < 11-$colCount; $n++) {
        		array_push($row, ' ');
        	}
        	array_push($newData, $row);
        }
        
        return [$newData, $metadata];
    }
	
    public function getYearlyData($month, $year, $dispcurr) {
    	if ($dispcurr == 'native') {
	        $exchangeRate['GBP'] = 1.0;
	        $exchangeRate['USD'] = $this->SaleFigureExchangeRate->getExchangeRate($year, $month, 'USD');
	        $exchangeRate['EUR'] = $this->SaleFigureExchangeRate->getExchangeRate($year, $month, 'EUR');
    	} else {
            $exchangeRate['GBP'] = 1.0;
            $exchangeRate['USD'] = 1.0;
            $exchangeRate['EUR'] = 1.0;
    	}

        $dateHeader = $year;
        
        $data = [];
        $metadata = [];
        $a = [$dateHeader, 'YTD Target', 'YTD Actual', 'Jan Target', 'Jan Actual', 'Feb Target', 'Feb Actual', 'Mar Target', 'Mar Actual', 'Apr Target', 'Apr Actual', 'May Target', 'May Actual', 'Jun Target', 'Jun Actual', 'Jly Target', 'Jly Actual', 'Aug Target', 'Aug Actual', 'Sep Target', 'Sep Actual', 'Oct Target', 'Oct Actual', 'Nov Target', 'Nov Actual', 'Dec Target', 'Dec Actual'];
        array_push($data, $a);
        array_push($metadata, 0);
        
        $showrooms = $this->Location->find('all', ['conditions'=> ['retire' => 'n'], 'order' => ['SavoirOwned' => 'desc', 'location' => 'asc']]);
        
        $doingOwnedShowrooms = true;
        array_push($data, ['Savoir Owned']);
        array_push($metadata, 0);
        
        $yearToDateTargetTotal = 0.0;
        $yearToDateActualTotal = 0.0;
        $monthTargetTotals = [];
        $monthActualTotals = [];
        for ($m = 1; $m < 13; $m++) {
            $monthTargetTotals[$m] = 0.0;
            $monthActualTotals[$m] = 0.0;
        }
        
        foreach ($showrooms as $showroom) {
            $totalsCurrency = 'GBP';
            $itemsCurrency = $showroom['currency'];
            if ($dispcurr != "native") {
            	$totalsCurrency = $dispcurr;
            	$itemsCurrency = $dispcurr;
            }
			$isdealer='n';
			if ($showroom['SavoirOwned'] == 'n') {
				$isdealer='y';
			}
            if ($doingOwnedShowrooms && $showroom['SavoirOwned'] == 'n') {
                $doingOwnedShowrooms = false;
            
                array_push($data, [' ']);
                array_push($metadata, 0);
                array_push($data, ['Dealers']);
                array_push($metadata, 0);
            }
            
            $name = $showroom['location'].' (' . $itemsCurrency . ')';
            $a = [];
            array_push($a, $name);
            
            $yearToDateTarget = $this->SaleFigureTarget->getYtdTargetForShowroomAndCurrency($showroom['idlocation'], $month, $year, $dispcurr);
            $yearToDateActual = $this->NewSalesFigures->getYearToDateForShowroomAndCurrency($showroom['idlocation'], $month, $year, '', $isdealer, $dispcurr);
            array_push($a, number_format((float)$yearToDateTarget, 2, '.', ','));
            array_push($a, number_format((float)$yearToDateActual, 2, '.', ','));
            
            for ($m = 1; $m < 13; $m++) {
                $monthTarget = $this->SaleFigureTarget->getMonthTargetForShowroomAndCurrency($year, sprintf('%02d', $m), $showroom['idlocation'], $dispcurr);
                $monthActual = $this->NewSalesFigures->getMonthActualsForShowroomAndCurrency($showroom['idlocation'], sprintf('%02d', $m), $year, $isdealer, $dispcurr);
                array_push($a, number_format((float)$monthTarget, 2, '.', ','));
                array_push($a, number_format((float)$monthActual, 2, '.', ','));
            
                $monthTargetTotals[$m] += $monthTarget;
                $monthActualTotals[$m] += $monthActual;
            }
            array_push($data, $a);
            array_push($metadata, $showroom['idlocation']);
        
            $yearToDateTargetTotal += $yearToDateTarget / $exchangeRate[$showroom['currency']];
            $yearToDateActualTotal += $yearToDateActual / $exchangeRate[$showroom['currency']];
        }
        
        array_push($data, [' ']);
        array_push($metadata, 0);
        $a = [];
        array_push($a, 'TOTAL (' . $totalsCurrency . ')');
        array_push($a, number_format((float)$yearToDateTargetTotal, 2, '.', ','));
        array_push($a, number_format((float)$yearToDateActualTotal, 2, '.', ','));
        for ($m = 1; $m < 13; $m++) {
            array_push($a, number_format((float)$monthTargetTotals[$m], 2, '.', ','));
            array_push($a, number_format((float)$monthActualTotals[$m], 2, '.', ','));
        }
        array_push($data, $a);
        array_push($metadata, 0);
        
        // make sure all rows have 27 cols
        $newData = [];
        foreach ($data as $row) {
        	$colCount = count($row);
        	for ($n = 0; $n < 27-$colCount; $n++) {
        		array_push($row, ' ');
        	}
        	array_push($newData, $row);
        }
        
        return [$newData, $metadata];
    }
    
}

?>