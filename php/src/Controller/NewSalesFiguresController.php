<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class NewSalesFiguresController extends SecureAppController {

    public function initialize() : void {
        parent::initialize();
        $this->loadModel('Location');
        $this->loadModel('NewSalesFigures');
        $this->loadModel('SaleFigureTarget');
        $this->loadModel('SaleFigureExchangeRate');
        $this->loadModel('PurchaseCoupon');
        
    }
    
    public function monthly() {
        $this->viewBuilder()->setLayout('savoirdatatables');
        
        $now = date('d-m-Y');
        $month = date("m",strtotime($now));
        $year = date("Y",strtotime($now));
        $dispcurr = 'native';
        
        if ($this->request->is('post')) {
            $formData = $this->request->getData();
            $month = $formData['month'];
            $year = $formData['year'];
            $dispcurr = $formData['dispcurr'];
        } else if ($this->request->getQuery('year')) {
            $year = $this->request->getQuery('year');
        }
        
        $dateObj = DateTime::createFromFormat('!m', $month);
        $monthName = $dateObj->format('F');
        
        $temp = $this->getMonthlyData($month, $year, $monthName, $dispcurr);
        $data = $temp[0];
        $metadata = $temp[1];
        $this->set('data', $data);
        $this->set('metadata', $metadata);
        $this->set('month', $month);
        $this->set('year', $year);
        $this->set('dispcurr', $dispcurr);
    }
    
    public function yearly() {
        $this->viewBuilder()->setLayout('savoirdatatables');
        
        $now = date('d-m-Y');
        $month = date("m",strtotime($now));
        $year = date("Y",strtotime($now));
        $dispcurr = 'native';
        
        if ($this->request->is('post')) {
            $formData = $this->request->getData();
            $year = $formData['year'];
            $dispcurr = $formData['dispcurr'];
        } else if ($this->request->getQuery('year')) {
            $year = $this->request->getQuery('year');
        }
        
        $temp = $this->getYearlyData($month, $year, $dispcurr);
        $data = $temp[0];
        $metadata = $temp[1];
        $this->set('data', $data);
        $this->set('metadata', $metadata);
        $this->set('month', $month);
        $this->set('year', $year);
        $this->set('dispcurr', $dispcurr);
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
    
    public function exportMonthlyData() {
        $month = $this->request->getQuery('month');
        $year = $this->request->getQuery('year');
        $dispcurr = $this->request->getQuery('dispcurr');
        
        $dateObj = DateTime::createFromFormat('!m', $month);
        $monthName = $dateObj->format('F');
        
        $temp = $this->getMonthlyData($month, $year, $monthName, $dispcurr);
        $data = $temp[0];
        $metadata = $temp[1];
        
        $filename = 'MonthlySalesFigures-'.$monthName.'-'.$year.'.csv';
        $this->setResponse($this->getResponse()->withDownload($filename));
        $this->set(compact('data'));
        $this->viewBuilder()
        ->setClassName('CsvView.Csv')
        ->setOptions([
            'serialize' => 'data'
        ]);
    }
    
    public function exportYearlyData() {
        $month = $this->request->getQuery('month');
        $year = $this->request->getQuery('year');
        $dispcurr = $this->request->getQuery('dispcurr');
        
        $temp = $this->getYearlyData($month, $year, $dispcurr);
        $data = $temp[0];
        $metadata = $temp[1];
        
        $filename = 'YearlySalesFigures-'.$year.'.csv';
        $this->setResponse($this->getResponse()->withDownload($filename));
        $this->set(compact('data'));
        $this->viewBuilder()
        ->setClassName('CsvView.Csv')
        ->setOptions([
            'serialize' => 'data'
        ]);
    }
    
    public function metadata() {
        $this->viewBuilder()->setLayout('savoir');
        
        $now = date('d-m-Y');
        $year = date("Y",strtotime($now));
        
        if ($this->request->getQuery('year')) {
            $year = $this->request->getQuery('year');
        }
        
        $usdRates = $this->SaleFigureExchangeRate->getRatesForYear($year, 'USD');
        $eurRates = $this->SaleFigureExchangeRate->getRatesForYear($year, 'EUR');
        $showrooms = $this->Location->find('all', ['conditions'=> ['retire' => 'n'], 'order' => ['SavoirOwned' => 'desc', 'location' => 'asc']]);
        
        $showroomTargets = [];
        foreach ($showrooms as $showroom) {
            $targetDataForYear = $this->SaleFigureTarget->getTargetDataForLocationAndYear($showroom['idlocation'], $year);
            $temp = [];
            $temp['name'] = $showroom['location'];
            $temp['idlocation'] = $showroom['idlocation'];
            $temp['targets'] = $targetDataForYear;
            $showroomTargets[$showroom['idlocation']] = $temp;
        }
        //debug($showroomTargets);
        //die;
        
        $this->set('year', $year);
        $this->set('usdRates', $usdRates);
        $this->set('eurRates', $eurRates);
        $this->set('showroomTargets', $showroomTargets);
    }
    
    public function savemetadata() {
        $this->viewBuilder()->setLayout('savoir');
        if (!$this->request->is('post')) {
           throw new Error('Invalid request type'); 
        }
        
        $formData = $this->request->getData();
        $year = $formData['year'];
        
        for ($i = 1; $i < 13; $i++) {
            $usdRate = $formData['usdRate' . $i];
            $this->_upsertExchangeRate($year, $i, 'USD', $usdRate);
            $eurRate = $formData['eurRate' . $i];
            $this->_upsertExchangeRate($year, $i, 'EUR', $eurRate);
        }
        
        //debug($formData);
        foreach($formData as $key => $val) {
            if (substr($key, 0, 7) == 'target-') {
                $arr = explode('-', $key);
                $this->_upsertTarget($year, $arr[2], $arr[1], $val);
            }
        }
        
        $this->Flash->success("Rates and targets successfully updated");
        $this->redirect(['action' => 'metadata', '?' => ['year' => $year]]);
    }
    
    public function showroom() {
    	$this->viewBuilder()->setOptions([
            'pdfConfig' => [
                'orientation' => 'portrait',
            ]
        ]);
		$docroot=$_SERVER['DOCUMENT_ROOT'];
        $this->set('docroot', $docroot);
        $currency='';
        $totalrowcount=0;
        $proto = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') ? 'https' : 'http';
        $isdealer='';
        $params = $this->request->getParam('?');
			if (isset($params['location'])) {
				$location=$params['location'];
				$query = $this->Location->find()->where(['idlocation' => $location]);
				foreach ($query as $row) {
					$loc = $row;
					
				}
				$location=$loc["adminheading"];
				$idlocation=$loc["idlocation"];
				
				if ($loc['SavoirOwned']=='y') {
					$isdealer='n';
				} else {
					$isdealer='y';
				}
				$currency=UtilityComponent::formatcurrencyHtmlSymbol($loc['currency']); 
			} else {
				$location='';
			}
			if (isset($params['month'])) {
				$month=$params['month'];
				$month = date("F", mktime(0, 0, 0, $month, 10));
				$monthno=$params['month'];
			} else {
				$month='';
			}
			if (isset($params['year'])) {
				$year=$params['year'];
			} else {
				$year='';
			}
			$prevyear=$year-1;
			$noFrench=0;
			$noState=0;
			$noVegan=0;
			$noFrenchprevyr=0;
			$noStateprevyr=0;
			$noVeganprevyr=0;
			$no1bed=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $year, 'savoirmodel', 'No. 1');
			$no2bed=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $year, 'savoirmodel', 'No. 2');
			$no3bed=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $year, 'savoirmodel', 'No. 3');
			$no4bed=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $year, 'savoirmodel', 'No. 4');
            $no5bed=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $year, 'savoirmodel', 'No. 5');
			$nonbed=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $year, 'savoirmodel', 'n');
			
			$noFrench=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $year, 'savoirmodel', 'French Mattress');
			$noState=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $year, 'savoirmodel', 'State');
			$noVegan=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $year, 'savoirmodel', 'No. 4v');
			$no1bed=$no1bed+$noState;
			$no2bed=$no2bed+$noFrench;
			$no4bed=$no4bed+$noVegan;
			
			$no1bedprevyr=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $prevyear, 'savoirmodel', 'No. 1');
			$no2bedprevyr=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $prevyear, 'savoirmodel', 'No. 2');
			$no3bedprevyr=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $prevyear, 'savoirmodel', 'No. 3');
			$no4bedprevyr=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $prevyear, 'savoirmodel', 'No. 4');
            $no5bedprevyr=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $prevyear, 'savoirmodel', 'No. 5');
			$nonbedprevyr=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $prevyear, 'savoirmodel', 'n');
	
			$noextras=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $year, 'extras', '');
			$noextrasprevyr=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $prevyear, 'extras', '');
			
			$noFrenchprevyr=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $prevyear, 'savoirmodel', 'French Mattress');
			$noStateprevyr=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $prevyear, 'savoirmodel', 'State');
			$no1bedprevyr=$no1bedprevyr+$noFrenchprevyr+$noStateprevyr;
			$noVeganprevyr=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $prevyear, 'savoirmodel', 'No. 4v');
			$no4bedprevyr=$no4bedprevyr+$noVeganprevyr;
			
			$noToppers=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $year, 'toppertype', '');
			$noToppersprevyr=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $prevyear, 'toppertype', '');

			$noAcc=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $year, 'acc', '');
			$noAccprevyr=$this->NewSalesFigures->getNoSold($idlocation, $monthno, $prevyear, 'acc', '');
			
			$noDelCharges=$this->NewSalesFigures->getNoDeliveryCharges($idlocation, $monthno, $year);
			$noDelChargesPrevYr=$this->NewSalesFigures->getNoDeliveryCharges($idlocation, $monthno, $prevyear);

			$noEcom=$this->NewSalesFigures->getNoEcom($idlocation, $monthno, $year);
			$noEcomPrevYr=$this->NewSalesFigures->getNoEcom($idlocation, $monthno, $prevyear);

			$targetDataForMonth = $this->SaleFigureTarget->getShowroomMonthTarget($year, $monthno, $idlocation);
			$targetDataForMonthLastYr = $this->SaleFigureTarget->getShowroomMonthTarget($prevyear, $monthno, $idlocation);
			$actualformonthYear=$this->NewSalesFigures->getShowroomMonthActual($idlocation, $monthno, $year, $isdealer);
			$actualformonthLastYear=$this->NewSalesFigures->getShowroomMonthActual($idlocation, $monthno, $prevyear, $isdealer);
			
			$actualforOrderSourceR=$this->NewSalesFigures->getShowroomActualsPerOrdersource($idlocation, $monthno, $year, 'Client');
			$actualforOrderSourceT=$this->NewSalesFigures->getShowroomActualsPerOrdersource($idlocation, $monthno, $year, 'Client Trade');
			$actualforOrderSourceC=$this->NewSalesFigures->getShowroomActualsPerOrdersource($idlocation, $monthno, $year, 'Client Contract');
			$actualforOrderSourceStock=$this->NewSalesFigures->getShowroomActualsPerOrdersource($idlocation, $monthno, $year, 'Stock');
			$actualforOrderSourceFloorstock=$this->NewSalesFigures->getShowroomActualsPerOrdersource($idlocation, $monthno, $year, 'Floorstock');
			$actualforOrderSourceMarketing=$this->NewSalesFigures->getShowroomActualsPerOrdersource($idlocation, $monthno, $year, 'Marketing');
			$actualforOrderSourceEcom=$this->NewSalesFigures->getShowroomActualsEcom($idlocation, $monthno, $year);
			$actualforOrderSourceTest=$this->NewSalesFigures->getShowroomActualsPerOrdersource($idlocation, $monthno, $year, 'Test');
			
			$this->addorderlist($currency, $actualforOrderSourceR, $idlocation, $monthno, $year, 'Client', 'Client Retail', 'clientorders');
			$this->addorderlist($currency, $actualforOrderSourceT, $idlocation, $monthno, $year, 'Client Trade', 'Client Trade', 'tradeorders');
			$this->addorderlist($currency, $actualforOrderSourceC, $idlocation, $monthno, $year, 'Client Contract', 'Client Contract', 'contractorders');
			$this->addorderlist($currency, $actualforOrderSourceStock, $idlocation, $monthno, $year, 'Stock', 'Stock', 'stockorders');
			$this->addorderlist($currency, $actualforOrderSourceFloorstock, $idlocation, $monthno, $year, 'Floorstock', 'Floorstock', 'floorstockorders');
			$this->addorderlist($currency, $actualforOrderSourceMarketing, $idlocation, $monthno, $year, 'Marketing', 'Marketing', 'marketingorders');
			$this->addorderlist($currency, $actualforOrderSourceEcom, $idlocation, $monthno, $year, '', 'E-Commerce', 'ecomorders');
			$this->addorderlist($currency, $actualforOrderSourceTest, $idlocation, $monthno, $year, 'Test', 'Test', 'testorders');

			$actualforNo1R=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 1', 'Client');
			$actualforNo1T=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 1', 'Client Trade');
			$actualforNo1C=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 1', 'Client Contract');

			$actualforNo2R=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 2', 'Client');
			$actualforNo2T=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 2', 'Client Trade');
			$actualforNo2C=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 2', 'Client Contract');
			
			$actualforNo3R=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 3', 'Client');
			$actualforNo3T=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 3', 'Client Trade');
			$actualforNo3C=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 3', 'Client Contract');

			$actualforNo4R=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 4', 'Client');
			$actualforNo4T=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 4', 'Client Trade');
			$actualforNo4C=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 4', 'Client Contract');

            $actualforNo5R=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 5', 'Client');
			$actualforNo5T=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 5', 'Client Trade');
			$actualforNo5C=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'No. 5', 'Client Contract');
 

			$actualforNonR=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'n', 'Client');
			$actualforNonT=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'n', 'Client Trade');
			$actualforNonC=$this->NewSalesFigures->getShowroomActualsPerModel($idlocation, $monthno, $year, 'n', 'Client Contract');

			$actualforExtrasR=$this->NewSalesFigures->getExtraActuals($idlocation, $monthno, $year, 'Client');
			$actualforExtrasT=$this->NewSalesFigures->getExtraActuals($idlocation, $monthno, $year, 'Client Trade');
			$actualforExtrasC=$this->NewSalesFigures->getExtraActuals($idlocation, $monthno, $year, 'Client Contract');

			
			$actualToppersR=$this->NewSalesFigures->getTopperActuals($idlocation, $monthno, $year, 'Client');
			$actualToppersT=$this->NewSalesFigures->getTopperActuals($idlocation, $monthno, $year, 'Client Trade');
			$actualToppersC=$this->NewSalesFigures->getTopperActuals($idlocation, $monthno, $year, 'Client Contract');

			$actualAccR=$this->NewSalesFigures->getAccActuals($idlocation, $monthno, $year, 'Client');
			$actualAccT=$this->NewSalesFigures->getAccActuals($idlocation, $monthno, $year, 'Client Trade');
			$actualAccC=$this->NewSalesFigures->getAccActuals($idlocation, $monthno, $year, 'Client Contract');
			
			$now = date('d-m-Y');

			$YTDactualRetail=$this->NewSalesFigures->getShowroomYearToDate($idlocation, $monthno, $year, 'Client', $isdealer);
			$YTDactualTrade=$this->NewSalesFigures->getShowroomYearToDate($idlocation, $monthno, $year, 'Client Trade', $isdealer);
			$YTDactualContract=$this->NewSalesFigures->getShowroomYearToDate($idlocation, $monthno, $year, 'Client Contract', $isdealer);
			$YTDDateActual = $this->NewSalesFigures->getShowroomYearToDate($idlocation, $monthno, $year, '', $isdealer);
			$YTDActualForPrevYear = $this->NewSalesFigures->getShowroomYearToDate($idlocation, $monthno, $prevyear, '', $isdealer);
			$YTDTargetForYear = $this->SaleFigureTarget->getShowroomYtdTarget($idlocation, $monthno, $year);

			$deliveryR=$this->NewSalesFigures->getDeliveryCharges($idlocation, $monthno, $year, 'Client');
			$deliveryT=$this->NewSalesFigures->getDeliveryCharges($idlocation, $monthno, $year, 'Client Trade');
			$deliveryC=$this->NewSalesFigures->getDeliveryCharges($idlocation, $monthno, $year, 'Client Contract');
			
			$ecomR=$this->NewSalesFigures->getEcomActuals($idlocation, $monthno, $year, 'Client');
			$ecomT=$this->NewSalesFigures->getEcomActuals($idlocation, $monthno, $year, 'Client Trade');
			$ecomC=$this->NewSalesFigures->getEcomActuals($idlocation, $monthno, $year, 'Client Contract');

			$performanceToTarget=0;
			$performanceToLastYear=0;
			if ($actualformonthYear=='') {
				$actualformonthYear=0;
				}
			if ($targetDataForMonth=='') {
				$targetDataForMonth=0;
				}
			if ($actualformonthLastYear=='') {
				$actualformonthLastYear=0;
				}
			if ($YTDDateActual=='') {
				$YTDDateActual=0;
				}
			if ($YTDTargetForYear=='') {
				$YTDTargetForYear=0;
				}
			if ($YTDActualForPrevYear=='') {
				$YTDActualForPrevYear=0;
				}	
			if ($targetDataForMonth==0){
				$performanceToTarget=0;
			} else {
			$performanceToTarget=($actualformonthYear-$targetDataForMonth)/$targetDataForMonth * 100;
			}
			if ($actualformonthLastYear==0){
				$performanceToLastYear=0;
			} else {
			$performanceToLastYear=($actualformonthYear-$actualformonthLastYear)/$actualformonthLastYear * 100;
			}
			$YTDpeformanceToTarget=0;
			$YTDperformanceToLastYear=0;
			if ($YTDTargetForYear==0){
				$YTDperformanceToTarget=0;
			} else {
			$YTDperformanceToTarget=($YTDDateActual-$YTDTargetForYear)/$YTDTargetForYear * 100;
			}
			if ($YTDActualForPrevYear==0){
				$YTDperformanceToLastYear=0;
			} else {
			$YTDperformanceToLastYear=($YTDDateActual-$YTDActualForPrevYear)/$YTDActualForPrevYear * 100;
			}

			$this->set('year', $year);
			$this->set('month', $month);
			$this->set('location', $location);
			$this->set('currency', $currency);
			$this->set('targetDataForMonth', $targetDataForMonth);
			$this->set('actualforNo1R', $actualforNo1R);
			$this->set('actualforNo1T', $actualforNo1T);
			$this->set('actualforNo1C', $actualforNo1C);
			$this->set('actualforNo2R', $actualforNo2R);
			$this->set('actualforNo2T', $actualforNo2T);
			$this->set('actualforNo2C', $actualforNo2C);
			$this->set('actualforNo3R', $actualforNo3R);
			$this->set('actualforNo3T', $actualforNo3T);
			$this->set('actualforNo3C', $actualforNo3C);
			$this->set('actualforNo4R', $actualforNo4R);
			$this->set('actualforNo4T', $actualforNo4T);
			$this->set('actualforNo4C', $actualforNo4C);
            $this->set('actualforNo5R', $actualforNo5R);
			$this->set('actualforNo5T', $actualforNo5T);
			$this->set('actualforNo5C', $actualforNo5C);
			$this->set('actualforNonR', $actualforNonR);
			$this->set('actualforNonT', $actualforNonT);
			$this->set('actualforNonC', $actualforNonC);
			$this->set('actualforExtrasR', $actualforExtrasR);
			$this->set('actualforExtrasT', $actualforExtrasT);
			$this->set('actualforExtrasC', $actualforExtrasC);

			$this->set('actualforOrderSourceR', $actualforOrderSourceR);
			$this->set('actualforOrderSourceT', $actualforOrderSourceT);
			$this->set('actualforOrderSourceC', $actualforOrderSourceC);
			
			$this->set('deliveryR', $deliveryR);
			$this->set('deliveryT', $deliveryT);
			$this->set('deliveryC', $deliveryC);
			
			$this->set('ecomR', $ecomR);
			$this->set('ecomT', $ecomT);
			$this->set('ecomC', $ecomC);
			
			$this->set('noDelCharges', $noDelCharges);
			$this->set('noDelChargesPrevYr', $noDelChargesPrevYr);
			$this->set('noEcom', $noEcom);
			$this->set('noEcomPrevYr', $noEcomPrevYr);

			$this->set('noToppers', $noToppers);
			$this->set('noToppersprevyr', $noToppersprevyr);
			$this->set('noAcc', $noAcc);
			$this->set('noAccprevyr', $noAccprevyr);
			$this->set('noextras', $noextras);
			$this->set('noextrasprevyr', $noextrasprevyr);
			
			$this->set('actualToppersR', $actualToppersR);
			$this->set('actualToppersT', $actualToppersT);
			$this->set('actualToppersC', $actualToppersC);

			$this->set('actualAccR', $actualAccR);
			$this->set('actualAccT', $actualAccT);
			$this->set('actualAccC', $actualAccC);
			
			$this->set('YTDactualRetail', $YTDactualRetail);
			$this->set('YTDactualTrade', $YTDactualTrade);
			$this->set('YTDactualContract', $YTDactualContract);
			$this->set('YTDDateActual', $YTDDateActual);
			$this->set('YTDTargetForYear', $YTDTargetForYear);
			$this->set('YTDActualForPrevYear', $YTDActualForPrevYear);
			
			$this->set('performanceToTarget', $performanceToTarget);
			$this->set('performanceToLastYear', $performanceToLastYear);
			$this->set('YTDperformanceToTarget', $YTDperformanceToTarget);
			$this->set('YTDperformanceToLastYear', $YTDperformanceToLastYear);
			
			
			$this->set('actualformonthLastYear', $actualformonthLastYear);
			$this->set('actualformonthYear', $actualformonthYear);
			$this->set('no1bed', $no1bed);
			$this->set('no2bed', $no2bed);
			$this->set('no3bed', $no3bed);
			$this->set('no4bed', $no4bed);
            $this->set('no5bed', $no5bed);
			$this->set('nonbed', $nonbed);
			$this->set('no1bedprevyr', $no1bedprevyr);
			$this->set('no2bedprevyr', $no2bedprevyr);
			$this->set('no3bedprevyr', $no3bedprevyr);
			$this->set('no4bedprevyr', $no4bedprevyr);
            $this->set('no5bedprevyr', $no5bedprevyr);
			$this->set('nonbedprevyr', $nonbedprevyr);
			
		//debug($location);
		//debug($month);
		//debug($year);
    }
    
    private function addorderlist($currency, $actualforordersource, $idlocation, $monthno, $year, $ordersource, $heading, $setname) {
    	$rowcount=0;
        $tableheader="<table  style='border-spacing: 5px; width:100%; border: 1px solid; padding:4px; font-size:10px;'>";
		$rowheader="<tr><td>Order No</td><td>Customer</td><td>Order Date</td><td>Company</td><td>Customer Ref</td><td></td><td align='right'>Value</td><td>Cat</td><td>Description</td></tr>";
        $clientorders='';
        	if ($setname=="ecomorders") {
        		$clientordersMonth=$this->NewSalesFigures->getShowroomEcomOrders($idlocation, $monthno, $year);
        	} else {
				$clientordersMonth=$this->NewSalesFigures->getShowroomOrdersPerOrdersource($idlocation, $monthno, $year, $ordersource);
			}
			if (count($clientordersMonth) > 0) {
			$clientorders="<br><p style='font-size:12px;'><b>List of ".$heading." Orders</b></p>";
			$clientorders.=$tableheader;
			$clientorders.=$rowheader;
			foreach ($clientordersMonth as $row) {
			//set up categories
				$cat='';
				$desc='';
				
				if ($row['mattressrequired']=='y' and $row['savoirmodel'] != 'n') {
					$cat=$row['savoirmodel'];
					$desc="Matt:".$row['savoirmodel'];
				} else if ($row["mattressrequired"] == "y" && $row["savoirmodel"] == "n") {
					$cat="Other";
					$desc="Matt:".$row['savoirmodel'];
				} else if ($row["baserequired"] == "y" || $row["legsrequired"] == "y" || $row["headboardrequired"] == "y" || $row["valancerequired"] == "y") {
					$cat="Extras";
					$desc="Base:".$row['basesavoirmodel'];
				} else if ($row["topperrequired"] == "y") {
					$cat=substr($row["toppertype"],0,3);
				} else if ($row["accessoriesrequired"] == "y") {
					$cat="Acc";
				} else if ($row["deliverycharge"] == "y") {
					$cat="Delivery";
				} else {
					$cat="Extras";
				}
				$rowcount=$rowcount+1;
				$orderdate='';
				if (isset($row['ORDER_DATE'])) {
					$orderdate=date("d/m/Y", strtotime($row['ORDER_DATE']));
				}
                $totexvat=isset($row['totalexvat']) ? $row['totalexvat'] : 0;
				$clientorders.="<tr><td>".$row['ORDER_NUMBER']."</td><td>".$row['surname']."</td><td>".$orderdate."</td><td>".$row['company']."</td><td>".$row['customerreference']."</td><td>".$currency."</td><td align='right'>".number_format($totexvat,2)."</td><td>".$cat."</td><td>".$desc."</td></tr>";
			}
			$clientorders.="<tr><td colspan=5>TOTAL</td><td>".$currency."</td><td align='right'>".number_format($actualforordersource,2)."</td><td></td><td></td>/tr>";
			$clientorders.="</table>";
			//$totalrowcount=$totalrowcount + $rowcount;
			}
			$this->set($setname, $clientorders);
			$this->set($setname.'_rowcount', $rowcount);
    }
    
    private function _upsertExchangeRate($year, $month, $currency, $rate) {
        $datetime = new DateTime();
        $datetime->setDate($year, $month, 15);
        $datetime->setTime(0, 0, 0);
        $rs = $this->SaleFigureExchangeRate->find('all', ['conditions'=> ['currency_code' => $currency, 'time' => $datetime]]);
        $entity = null;
        foreach ($rs as $row) {
            $entity = $row;
        }
        if ($entity === null) {
            $entity = $this->SaleFigureExchangeRate->newEntity([]);
            $entity['currency_code'] = $currency;
            $entity['time'] = $datetime;
        }
        $entity['exchange_rate'] = $rate;
        $this->SaleFigureExchangeRate->save($entity);
    }
    
    private function _upsertTarget($year, $month, $idlocation, $target) {
        $datetime = new DateTime();
        $datetime->setDate($year, $month, 15);
        $datetime->setTime(0, 0, 0);
        $rs = $this->SaleFigureTarget->find('all', ['conditions'=> ['idlocation' => $idlocation, 'target_date' => $datetime]]);
        $entity = null;
        foreach ($rs as $row) {
            $entity = $row;
        }
        if ($entity === null) {
            $entity = $this->SaleFigureTarget->newEntity([]);
            $entity['idlocation'] = $idlocation;
            $entity['target_date'] = $datetime;
        }
        $entity['target_amount'] = $target;
        $this->SaleFigureTarget->save($entity);
    }
    
    public function coupons() {
    	$this->viewBuilder()->setOptions([
            'pdfConfig' => [
                'orientation' => 'portrait',
            ]
        ]);
		$docroot=$_SERVER['DOCUMENT_ROOT'];
        $this->set('docroot', $docroot);
        $currency='';
        $totalrowcount=0;
        $proto = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') ? 'https' : 'http';
        $isdealer='';
        $params = $this->request->getParam('?');
			
			if (isset($params['month'])) {
				$month=$params['month'];
				$month = date("F", mktime(0, 0, 0, $month, 10));
				$monthno=$params['month'];
			} else {
				$month='';
			}
			if (isset($params['year'])) {
				$year=$params['year'];
			} else {
				$year='';
			}
		 $clientordersMonth=$this->PurchaseCoupon->getCouponInfoMonth($monthno, $year);
		 $this->set('year', $year);
		 $this->set('month', $month);
		 
		 $this->set('clientordersMonth', $clientordersMonth);
		 
	}
    
    
    
    // not called for superusers as they have all roles
    protected function _getAllowedRoles() {
    	if ($this->request->getParam('action') == 'showroom') {
    		// unless they are a superuser, the user can only see the showroom pdf for their own showroom
    		$requestedLocation = $this->request->getQuery('location');
    		if ($this->getCurrentUserLocationId() != $requestedLocation && $this->getCurrentUserLocationId() != 1) {
    			return null;
    		}
            return ["ALL"];
    	} else if ($this->getCurrentUserLocationId() != 1) {
    		// only bedworks can see the monthly & yearly screens
    		return null;
    	}
        return ["ADMINISTRATOR"];
    }

}
