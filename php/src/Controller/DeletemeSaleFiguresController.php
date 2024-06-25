<?php

namespace App\Controller;

use Cake\ORM\TableRegistry;

class SaleFiguresController extends SecureAppController {


    /*
     * ACL array determines which table can the user check. For details, please check function 
     * _accessControllListGenerator().
     */
    private $accessControll = array();

    /*
     * Real Sales Figure array for each year each showroom and each month.
     * The structure of this array is viewFigures[year][showroom]{[showroomName][figures]{[month]}} 
     */
    private $viewFigures = array();
    /*
     * Target array for each year each month and each showroom.
     * The structure of this array is Target[year][showroom][month]{[amount][id][changed]}
     */
    private $target = array();

    /*
     * This ii
     */
    private $exchangeRate = array();
    /*
     * Showroom code array. For details, please check function: _arrayGenerator. 
     * 
     * This array doesn't includes all of the showroom ids. This is because: we found for some showroom like Paris, Beijing 
     * and Seoul, there are more than one idlocation for each of them and this $showroomCodes is not only used to create
     * SQL query but also to generate array to send to front end and in front end, we only want one idlocation for each showroom
     * The other ids are added in function _arrayGenerator.
     */
    private $showroomCodes = [1, 48, 49, 50, 3, 4, 36, 27, 24, 17, 37, 34, 39, 99, 33, 26, 31, 35, 21, 28, 38, -1, 40, 45, 41, 47, 42, 43, 44, -2];

    /*
     * The reason why there are more than one $showroomCodes is that there are some showrooms closed in past years, so when
     * the user request that year figures, a different set of showroom code is needed.  
     * 
     */
    private $showroomCodesBefore2012 = [1, 3, 4, 36, 27, 24, 29, 34, 33, 26, 31, 21, 28, 23, 14, 13, -1];
    private $showroomCodesBefore2015 = [1, 3, 4, 36, 27, 24, 29, 34, 33, 26, 31, 21, 28, 23, 14, -1];
    private $showroomCodesBefore2016 = [1, 3, 4, 36, 27, 24, 29, 34, 33, 26, 31, 21, 28, 14, -1];
    private $saleFigureModel;
    private $saleFigureTarget;
    private $saleFigureExchangeRate;
    private $Purchase;

    public function initialize() : void {
        parent::initialize();
        $this->saleFigureModel = TableRegistry::get('SaleFigureModel');
        $this->saleFigureTarget = TableRegistry::get('SaleFigureTarget');
        $this->saleFigureExchangeRate = TableRegistry::get('SaleFigureExchangeRate');
        $this->Purchase = TableRegistry::get('Purchase');
		//$this->loadComponent('Cookie');
		$this->loadComponent('SaleFigureTest');
		$this->loadComponent('Utility');
		$this->loadComponent('SavoirSecurity');
    }

    public function index() {

        $this->_accessControllListGenerator(); //Create an ACL array to determine which table can the user check.

        if (!$this->accessControll['isvisible']) {
            $data = 'no';
        } else {
            $data['acl'] = $this->accessControll;
            $year = date('Y');
            $data['thisyear'] = $year;
        }

        $this->viewBuilder()->setLayout('fabricstatus');
        $this->set('data', $data);
    }

    /*
     * This is the controller for worldwide sale figures
     */

    public function world() {
        //ini_set('memory_limit', '256M');
        //set_time_limit(0);
        /* ===================================Check if the request is super user ==================================== */
        $this->_accessControllListGenerator();
        if (!$this->SavoirSecurity->isSuperuser()) { //This is page is only for super user
            $this->redirect(array('controller' => 'salefigures', 'action' => 'index'));
        } else {
            $data['acl'] = $this->accessControll;  //generate the access control array
        }
        /* ===================================Check if the request is ajax ==================================== */
        if ($this->request->is('ajax')) {            //This controller action also deals with the ajax request
            $year = (int) $this->request->getData()['startyear']; //Retrieve the requested year.

            if (empty($year) || strlen($year) <= 0) {
                $year = date('Y');
            }
        } else {
            $year = date('Y');      //If it is a GET request, then show current year records.
        }
        $data['thisyear'] = date('Y');    //Send current year to VIEW and saved to the hiddden input.

        /* ===================================Get the start year and retrieve data ==================================== */

        $data['requestyear'] = $year;    //send the requested year back to page to calculate #nextYear and #previousYear				
        //$startyear = $year -1;						//3 years records includes in one request. $startyear is used in the follow query.



        /*
         * The orders satisfied following requirements are retrieved:
         * 1. Completed Order;
         * 2. NOT a QUOTE order;
         * 3. NOT a HOLD order;
         * 4. NOT a CANCELLED order;
         * 5. Within the requested year.
         */
        /*
         *  Call SaleFigureTestComponent, to check if the test mode is on
         */
        $test = $this->SaleFigureTest->isTestOn();
        $testInfo = $test['testInfo'];
        if ($test['isTestOn'] == 'y') {
            $startTime = date('Y-m-d', strtotime($testInfo['startTime']));
            $endTime = date('Y-m-d', strtotime($testInfo['endTime'] . ' +1 day'));
            $data['test']['testInfo'] = $testInfo;
            $orders = $this->saleFigureModel->getWorldYearlyTestData($startTime, $endTime);
            $data['test']['isTestOn'] = 'y';
            $data['test']['testData'] = $orders;
        } else {
            $orders = $this->saleFigureModel->getWorldYearlyData($year);
            $data['test']['testInfo'] = $testInfo;
            $data['test']['isTestOn'] = 'n';
        }
        //echo var_dump($data['test']);
        //die();
        if (!empty($orders) && count($orders) > 0) {  //HERE
            $this->_worldArrayGenerator($orders, $year);     //Generate the world array
            $data['data'] = $this->viewFigures;    //$this->viewFigures is the private property for actrual figures.
        } else {
            $this->_initialArray('world', $year, 'actual');  //Return an empty array if no records found in the database.
            $data['data'] = $this->viewFigures;
        }

        $this->_exchangeRateArrayGenerator($year, 'world');
        $data['exchange_rate_array'] = $this->exchangeRate;
        //echo var_dump($this->exchangeRate);
        //die();

        $this->_targetArrayGenerator($year, 'world');   //Retrieve target data.
        $data['target'] = $this->target;
        if ($this->request->is('ajax')) {
            echo json_encode($data);      //Send the JSON data if the request is AJAX.
            die();
        } else {
            $this->viewBuilder()->setLayout('fabricstatus');
            $this->set('data', $data);      //Send array to VIEW.
        }
    }

    /*
     * This is the Controller for world monthly figures.
     */

    public function worldMonthlyFigures() {
        /* ===================================Check if the request is super user ==================================== */
        $this->_accessControllListGenerator();
        if (!$this->SavoirSecurity->isSuperuser()) { //This is page is only for super user
            $this->redirect(array('controller' => 'salefigures', 'action' => 'index'));
        } else {
            $data['acl'] = $this->accessControll;  //generate the access control array
        }
        /* ===================================Check if the request is ajax ==================================== */
        if ($this->request->is('ajax')) {            //This controller action also deals with the ajax request
            $year = (int) $this->request->getData()['startyear']; //Retrieve the requested year.
            $month = (int) $this->request->getData()['requestmonth'];
            if (empty($year) || strlen($year) <= 0) {
                $year = date('Y');
                $month = date('m');
            }
        } else {
            $year = date('Y');      //If it is a GET request, then show current year records.
            $month = date('m');
            //$month = 5;
        }
        $data['currentmonth'] = $month;
        $data['thisyear'] = date('Y');    //Send current year to VIEW and saved to the hiddden input.

        /* ===================================Get the start year and retrieve data ==================================== */

        $data['requestyear'] = $year;    //send the requested year back to page to calculate #nextYear and #previousYear
        //$startyear = $year -1;						//3 years records includes in one request. $startyear is used in the follow query.

        /*
         * The orders satisfied following requirements are retrieved:
         * 1. Completed Order;
         * 2. NOT a QUOTE order;
         * 3. NOT a HOLD order;
         * 4. NOT a CANCELLED order;
         * 5. Within the requested year and its previous year.
         */
        //$nextMonth = $month>9?$month:'0'.$month;
        //$orders = $this->saleFigureModel->getWorldMonthlyData($year);
        $test = $this->SaleFigureTest->isTestOn();
        $testInfo = $test['testInfo'];
        if ($test['isTestOn'] == 'y') {
            $startTime = date('Y-m-d', strtotime($testInfo['startTime']));
            $endTime = date('Y-m-d', strtotime($testInfo['endTime'] . ' +1 day'));
            $data['test']['testInfo'] = $testInfo;
            $orders = $this->saleFigureModel->getWorldMonthlyTestData($startTime, $endTime);
            $data['test']['isTestOn'] = 'y';
            $data['test']['testData'] = $orders;
        } else {
            $orders = $this->saleFigureModel->getWorldMonthlyData($year, $month);
            $data['test']['testInfo'] = $testInfo;
            $data['test']['isTestOn'] = 'n';
        }
        if (!empty($orders) && count($orders) > 0) { //HERE
            //$this->_worldmonthArrayGenerator($orders,$year);    	//Generate the world array
            $this->_worldmonthArrayGenerator($orders, $year);
            $data['data'] = $this->viewFigures;    //$this->viewFigures is the private property for actrual figures.
        } else {
            $this->_initialArray('worldmonth', $year, 'actual');  //Return an empty array if no records found in the database.
            $data['data'] = $this->viewFigures;
            die();
        }

        $this->_exchangeRateArrayGenerator($year, 'worldmonth');  //Retrieve exchange rate data.
        $data['exchange_rate_array'] = $this->exchangeRate;
		
        $this->_targetArrayGenerator($year, 'worldmonth');   //Retrieve target data.
        $data['target'] = $this->target;
        $tempMonthlyDetails = $this->saleFigureModel->getMonthlyFiguresDetails($year, $month);

        $tempMonthlyDetails = $this->_complateMonthlyDetailArray($tempMonthlyDetails);
        $data['monthly_figure_details'] = $this->_addCouponVirtualSales($tempMonthlyDetails);
        foreach ($data['monthly_figure_details'] as $key => $value) {
            $a = $this->_getShowroomName($key);
            $data['monthly_figure_details'][$key]['showroom_name'] = $a['location'];
            $data['monthly_figure_details'][$key]['currency'] = $a['currency'];
        }

        $sourceTotals = $this->saleFigureModel->totalOrderSource($orders, $year, $month);
        foreach ($sourceTotals as $idlocation => $values) { // sourceTotals element will be retrieved in the loop as $idlocation
            $data['monthly_figure_details'][$idlocation]['source_totals'] = $values;
        }

        if ($this->request->is('ajax')) {
            echo json_encode($data);      //Send the JSON data if the request is AJAX.
            die();
        } else {
            $this->viewBuilder()->setLayout('fabricstatus');
            $this->set('data', $data);      //Send array to VIEW.
        }
    }

    private function _complateMonthlyDetailArray($monthlyDetailArray) {
        foreach ($monthlyDetailArray as $showroomCode => $value) {
            $year = $value['year'];
            $month = $value['month'];
            $temp_ytd = 0;
            $temp_ly_ytd = 0;
            $temp_ytd_target = 0;
            for ($i = $month; $i >= 1; $i--) {
                $temp_ytd += $this->viewFigures[$year][$showroomCode]['figures'][$i];
                $temp_ly_ytd += $this->viewFigures[$year - 1][$showroomCode]['figures'][$i];
                $temp_ytd_target += $this->target[$year][$showroomCode][$i]['amount'];
            }

            $monthlyDetailArray[$showroomCode]['ly_amount'] = $this->viewFigures[$year - 1][$showroomCode]['figures'][$month];
            $monthlyDetailArray[$showroomCode]['target'] = $this->target[$year][$showroomCode][$month]['amount'];
            $monthlyDetailArray[$showroomCode]['ytd'] = $temp_ytd;
            $monthlyDetailArray[$showroomCode]['ly_ytd'] = $temp_ly_ytd;
            $monthlyDetailArray[$showroomCode]['ytd_target'] = $temp_ytd_target;
        }
        return $monthlyDetailArray;
    }

    private function _addCouponVirtualSales($monthlyDetailArray) {
    	foreach ($monthlyDetailArray as $showroomCode => $value) {
    		$sales = $this->saleFigureModel->getVirtualSalesForShowroom($showroomCode, $value['year'], $value['month'], $value['currency']);
    		$monthlyDetailArray[$showroomCode]['data']['Ecom']['amount'] = empty($sales[0]['amount']) ? 0.0 : $sales[0]['amount'];
    		$monthlyDetailArray[$showroomCode]['data']['Ecom']['quantities'] = $sales[0]['quantities'];
    		$monthlyDetailArray[$showroomCode]['data']['Ecom']['ly_quantities'] = $sales[1]['quantities'];
    	}
    	return $monthlyDetailArray;
    }

    /*
     * 
     */

    public function exchangeRates() {
        $this->_accessControllListGenerator();
        if (!$this->SavoirSecurity->isSuperuser()) { //This is page is only for super user
            $this->redirect(array('controller' => 'salefigures', 'action' => 'index'));
        } else {
            $data['acl'] = $this->accessControll;  //generate the access control array
        }
        /* ===================================Check if the request is ajax ==================================== */
        if ($this->request->is('ajax')) {            //This controller action also deals with the ajax request
            $year = (int) $this->request->getData()['startyear']; //Retrieve the requested year.
            if (empty($year) || strlen($year) <= 0) {
                $year = date('Y');
            }
        } else {
            $year = date('Y');      //If it is a GET request, then show current year records.
        }
        $data['thisyear'] = date('Y');    //Send current year to VIEW and saved to the hiddden input.

        /* ===================================Get the start year and retrieve data ==================================== */

        $data['requestyear'] = $year;
        $data['currency_code_array'] = $this->saleFigureExchangeRate->getCurrencyCodeArray();
        $this->_exchangeRateArrayGenerator($year, 'world', true);  //Retrieve exchange rate data.
        $data['exchange_rate_array'] = $this->exchangeRate;
        if ($this->request->is('ajax')) {
            echo json_encode($data);      //Send the JSON data if the request is AJAX.
            die();
        } else {
            $this->viewBuilder()->setLayout('fabricstatus');
            $this->set('data', $data);      //Send array to VIEW.
        }
    }

    /*
     * This function only accept AJAX request. it response to AJAX request from the function allTargetsData.saveToDB() in page 
     * world.ctp, region.ctp and showroom.ctp. 
     * The purpose of this function is to accept the sales target figures update array and update the database.  
     * The sent back array inludes three elements:
     * 1. Updated target array:
     * The structure of the array is Target[year][showroom][month]{[amount][id][changed]}
     */

    public function updatetarget() {
        $this->_accessControllListGenerator();
        if (!$this->SavoirSecurity->isSuperuser()) { //This is page is only for super user
            $this->redirect(array('controller' => 'salefigures', 'action' => 'index'));
        }
        if (!$this->request->is('ajax')) {
            $this->redirect(array('controller' => 'salefigures', 'action' => 'index'));
        }
        $rawData = $this->request->getData()['newtarget'];
        $type = $this->request->getData()['type'];
        $detail = $this->request->getData()['detail'];
        if (!empty($detail) && strlen($detail) > 0) {
            
        } else {
            $detail = '';
        }
        //$this->_initialArray('world',2017,'target');
        //$rawData = $this->target;
        $updateTargets = '';
        if (!empty($rawData) && strlen($rawData) > 0) {
            /*
             * the second parameter of json_decode has to be set to TRUE, or the
             * output data format is NOT ARRAY but std_Class, in which the value can only be retrieved
             * by foreach, not by ['key'].
             */
            $updateTargets = json_decode($rawData, true);
            //$updateTargets = $rawData;
            $yearArray = [];
            $i = 0;
            foreach ($updateTargets as $yearKey => $yearTempTargets) {
                $yearArray[$i] = (int) $yearKey;
                $i++;
                foreach ($yearTempTargets as $showroomKey => $showroomTempTarget) {
                    foreach ($showroomTempTarget as $monthKey => $monthTempTargets) {
                        if ($monthTempTargets['changed'] == 'y') {
                            $date = '';
                            if ($monthKey < 10) {
                                /*
                                 * The format of target_date in database is Date.
                                 * Since only the year and month are used, the date is set to yyyy-mm-15
                                 */
                                $date = $yearKey . '-0' . $monthKey . '-15';
                            } else {
                                $date = $yearKey . '-' . $monthKey . '-15';
                            }
                            //$updateTargets[$yearKey][$monthKey][$showroomKey]["test"] = $date;

                            /*
                             * In the target array if the 'id' is less than 0, the record is new and need to INSERT to db
                             * and if it is larger than 0, the record is already in db and UPDATE need to be used.
                             */
                            if ($monthTempTargets['id'] == '-1') {
                                $this->saleFigureTarget->insertData($showroomKey, (float) $monthTempTargets["amount"], $date);
                            } else {
                                $this->saleFigureTarget->updateData($showroomKey, (float) $monthTempTargets["amount"], $date, $monthTempTargets['id']);
                            }
                        }
                    }
                }
            }
        }
        if ($type == "world") {
            $this->_targetArrayGenerator(max($yearArray), 'world');
        }
        if ($type == "worldmonth") {
            $this->_targetArrayGenerator(max($yearArray), 'worldmonth', $detail);
        }
        if ($type == "region") {
            $this->_targetArrayGenerator(max($yearArray), 'region', $detail);
        }
        $returnTargets = $this->target;
        //echo var_dump($updateTargets);
        //die();
        $this->viewBuilder()->setLayout('ajax');
        $this->set('data', $returnTargets);
    }

    public function updateExchangeRate() {
        $this->_accessControllListGenerator();
        if (!$this->SavoirSecurity->isSuperuser()) { //This is page is only for super user
            $this->redirect(array('controller' => 'salefigures', 'action' => 'index'));
        }
        if (!$this->request->is('ajax')) {
            $this->redirect(array('controller' => 'salefigures', 'action' => 'index'));
        }
        $rawData = $this->request->getData()['newtarget'];
        $requestYear = $this->request->getData()['requestYear'];

        $updateTargets = '';
        if (!empty($rawData) && strlen($rawData) > 0) {
            /*
             * the second parameter of json_decode has to be set to TRUE, or the
             * output data format is NOT ARRAY but std_Class, in which the value can only be retrieved
             * by foreach, not by ['key'].
             */
            $updateTargets = json_decode($rawData, true);
            foreach ($updateTargets as $yearKey => $yearTempTargets) {
                foreach ($yearTempTargets as $monthKey => $monthTempTargets) {
                    foreach ($monthTempTargets as $countryCode => $countryTempTargets) {
                        if ($countryTempTargets['changed'] == 'y') {
                            $date = '';
                            if ($monthKey < 10) {
                                /*
                                 * The format of target_date in database is Date.
                                 * Since only the year and month are used, the date is set to yyyy-mm-15
                                 */
                                $date = $yearKey . '-0' . $monthKey . '-15';
                            } else {
                                $date = $yearKey . '-' . $monthKey . '-15';
                            }
                            //$updateTargets[$yearKey][$monthKey][$showroomKey]["test"] = $date;

                            /*
                             * In the target array if the 'id' is less than 0, the record is new and need to INSERT to db
                             * and if it is larger than 0, the record is already in db and UPDATE need to be used.
                             */
                            if ($countryTempTargets['id'] == '-1') {
                                $exchangeRateRow = $this->saleFigureExchangeRate->newEntity([]);
                                $exchangeRateRow->currency_code = $countryCode;
                                $exchangeRateRow->time = $date;
                                $exchangeRateRow->exchange_rate = $countryTempTargets['amount'];
                                $this->saleFigureExchangeRate->save($exchangeRateRow);
                            } else {
                                $exchangeRateRow = $this->saleFigureExchangeRate->get($countryTempTargets['id']);
                                $exchangeRateRow->currency_code = $countryCode;
                                $exchangeRateRow->time = $date;
                                $exchangeRateRow->exchange_rate = $countryTempTargets['amount'];
                                $this->saleFigureExchangeRate->save($exchangeRateRow);
                            }
                        }
                    }
                }
            }
        }
        $this->_exchangeRateArrayGenerator($requestYear, 'world', true);
        $data['exchange_rate_array'] = $this->exchangeRate;
        $data['currency_code_array'] = $this->saleFigureExchangeRate->getCurrencyCodeArray();
        echo json_encode($data);
        die();
    }

    public function test() {
        $this->_accessControllListGenerator();
        if (!$this->SavoirSecurity->isSuperuser()) { //This is page is only for super user
            $this->redirect(array('controller' => 'salefigures', 'action' => 'index'));
        }
        if (!$this->request->is('ajax')) {
            $this->redirect(array('controller' => 'salefigures', 'action' => 'index'));
        }
        $testStatus = $this->request->getData()['status'];
        $testId = $this->request->getData()['id'];
        $actionName = $this->request->getData()['action'];

        if ($testStatus == "off") {
            $this->saleFigureTest->id = (int) $testId;
            $this->saleFigureTest->save(array(
                "is_test_on" => 'n'
            ));
        } else {
            $this->saleFigureTest->id = (int) $testId;
            $startDate = $this->request->getData()['start'];
            $endDate = $this->request->getData()['end'];
            $this->saleFigureTest->save(array(
                "is_test_on" => 'y',
                "start_time" => date('Y-m-d', strtotime($startDate)),
                "end_time" => date('Y-m-d', strtotime($endDate)),
            ));
        }
        echo "redirect";
        die();
    }

    private function _targetArrayGenerator($year, $type, $detail = null) {
        if ($type == "world") {
            $this->_initialArray($type, $year, 'target');
        }
        if ($type == "worldmonth") {
            $this->_initialArray($type, $year, 'target');
        }
        if ($type == "region") {
            $this->_initialArray($type, $year, 'target', $detail);
        }

        /* INSERT EXAMPLE
          $idlocation = 3;
          $target_amount = 4321303;
          $target_date = '2012-03-15';
          $insertTestSQL = "INSERT INTO sale_figure_target (idlocation,target_amount,target_date) VALUES (".
          $idlocation.",".$target_amount.",'".$target_date."')";
          $insertTest = $this->Purchase->query($insertTestSQL);
          echo $insertTest;
          die();
         */
        //$startyear = $year -1;
        $startyear = $year;
        if ($type == "worldmonth") {
            $startyear = $year - 1; //For monthly records, 2 years records are needed.
        }
        $targets = $this->saleFigureTarget->getTargetData($year, $startyear);
        /*
          $superuserTargetQuery = "SELECT * FROM sale_figure_target AS a WHERE ".
          "a.target_date <= '".$year."-12-31' ".
          "AND a.target_date >= '".$startyear."-01-01' ";

          $targets = $this->Purchase->query($superuserTargetQuery);
         */
        if (!empty($targets) && count($targets) > 0) {
            $this->_arrayGenerator($targets, 'target');
        }
    }

    private function _getShowroomName($showroomId) {
        if ($showroomId == -1) {
            return array('location' => 'Berlin', 'currency' => 'GBP');
        }
        if ($showroomId == -2) {
            return array('location' => 'New/ Planned 5', 'currency' => 'GBP');
        }
        if ($showroomId == 1) {
            return array('location' => 'Head Office', 'currency' => 'GBP');
        }
        if ($showroomId == 26) {
            return array('location' => 'Beijing', 'currency' => 'GBP');
        }
        if ($showroomId == 21) {
            return array('location' => 'Shanghai', 'currency' => 'GBP');
        }
        if ($showroomId == 99) {
            return array('location' => 'Deducted Coupon Codes', 'currency' => 'GBP');
        }
        /*
          $showroomQuery = "SELECT location FROM location AS a WHERE idlocation=".$showroomId;
          $showroom = $this->Purchase->query($showroomQuery);
         */
        $showroom = $this->saleFigureModel->getShowroomName($showroomId);

        if ($showroomId == 13 || $showroomId == 14 || $showroomId == 23) {
            return array('location' => $showroom[0]['location'] . '(closed)', 'currency' => $showroom[0]['currency']);
        }
        return array('location' => $showroom[0]['location'], 'currency' => $showroom[0]['currency']);
    }

    private function _worldArrayGenerator($orders, $thisyear) {
        $this->_initialArray('world', $thisyear, 'actual');
        $this->_arrayGenerator($orders, 'actual');
    }

    private function _worldmonthArrayGenerator($orders, $thisyear) { //HERE
        //$this->log("_worldmonthArrayGenerator: orders=" . $this->Utility->varDumpToString($orders));
        $this->_initialArray('worldmonth', $thisyear, 'actual');
        //$this->log("_worldmonthArrayGenerator: viewFigures=" . $this->Utility->varDumpToString($this->viewFigures));
        $this->_arrayGenerator($orders, 'actual');
        //$this->log("_worldmonthArrayGenerator: viewFigures=" . $this->Utility->varDumpToString($this->viewFigures));
    }

    private function _exchangeRateArrayGenerator($year, $requestActionName, $update = false) {

        $currencyCodeArray = $this->saleFigureExchangeRate->getCurrencyCodeArray();
        if (!empty($currencyCodeArray) && count($currencyCodeArray) > 0) {
            if (!$update) {
                $this->_initialArray($requestActionName, $year, 'exchange', $currencyCodeArray);
            } else {
                $this->_initialArray($requestActionName, $year, 'exchange_update', $currencyCodeArray);
            }
        } else {
            if (!$update) {
                $this->_initialArray($requestActionName, $year, 'exchange');
            } else {
                $this->_initialArray($requestActionName, $year, 'exchange_update');
            }
        }

        $startyear = $year;
        if ($requestActionName == 'worldmonth') {
            $startyear = $year - 1;
        }

        $rates = $this->saleFigureExchangeRate->find('all', array('conditions' => array('time <=' => $year . "-12-31", 'time >=' => $startyear . "-01-01")))->toArray();
        //echo var_dump($rates);
        if (!empty($rates) && count($rates) > 0) {
            foreach ($rates as $rate) {
                $time = $rate['time'];
                $exchange_rate_year = $time->i18nFormat('yyyy');
                $exchange_rate_month = $time->i18nFormat('M');
                if (!$update) {
                    $this->exchangeRate[$exchange_rate_year][$exchange_rate_month][$rate['currency_code']] = (float) $rate['exchange_rate'];
                } else {
                    $this->exchangeRate[$exchange_rate_year][$exchange_rate_month][$rate['currency_code']]['amount'] = (float) $rate['exchange_rate'];
                    $this->exchangeRate[$exchange_rate_year][$exchange_rate_month][$rate['currency_code']]['id'] = $rate['exchange_rate_id'];
                }
            }
        }
    }

    private function _arrayGenerator($orders, $type) {

        foreach ($orders as $order) {
            //echo var_dump((int)$order['idlocation']);
            //die();
            switch ((int) $order['idlocation']) {
                case 1:    //Head Office;
                    $this->_calculateFigures(1, $order, $type);
                    break;
                case 3:    //Wgimore Street;
                    $this->_calculateFigures(3, $order, $type);
                    break;
                case 4:    //Harrods;
                    $this->_calculateFigures(4, $order, $type);
                    break;
                case 36:   //Chelsea Harbor;
                    $this->_calculateFigures(36, $order, $type);
                    break;
                case 27:   //Cardiff;
                    $this->_calculateFigures(27, $order, $type);
                    break;
                case 24:   //Dusseldorf;
                    $this->_calculateFigures(24, $order, $type);
                    break;
                case 17:   //Paris;
                    $this->_calculateFigures(17, $order, $type);
                    break;
                case 29:   //Paris;
                    $this->_calculateFigures(29, $order, $type);
                    break;
				case 37:   //NY Uptown;
                    $this->_calculateFigures(37, $order, $type);
                    break;
				case 34:   //NY Uptown;
                    $this->_calculateFigures(34, $order, $type);
                    break;
				case 39:   //Savoir US NEW LA
                    $this->_calculateFigures(39, $order, $type);
                    break;
                case 33:   //Hong Kong;
                    $this->_calculateFigures(33, $order, $type);
                    break;
                case 22:   //Beijing;
                    $this->_calculateFigures(22, $order, $type);
                    break;
                case 26:   //Beijing;
                    $this->_calculateFigures(26, $order, $type);
                    break;
                case 30:   //Beijing;
                    $this->_calculateFigures(30, $order, $type);
                    break;
                case 31:   //Seoul;
                    $this->_calculateFigures(31, $order, $type);
                    break;
                case 35:   //Seoul;
                    $this->_calculateFigures(35, $order, $type);
                    break;
                case 21:   //Shanghai;
                    $this->_calculateFigures(21, $order, $type);
                    break;
                case 28:   //Taiwan;
                    $this->_calculateFigures(28, $order, $type);
                    break;
                case 13:   //Praha; Before 2013
                    $this->_calculateFigures(13, $order, $type);
                    break;
                case 14:   //Berlin Postdam; Before 2016
                    $this->_calculateFigures(14, $order, $type);
                    break;
                case 23:   //Trade & Contract; Before 2015
                    $this->_calculateFigures(23, $order, $type);
                    break;
                case 38:   //Moscow
                    $this->_calculateFigures(38, $order, $type);
                    break;
				case 40:   //Moscow
                    $this->_calculateFigures(40, $order, $type);
                    break;
				case 45:   //Planned – Frankfurt
                    $this->_calculateFigures(45, $order, $type);
                    break;
				case 47:   //Pelini - Shanghai
                    $this->_calculateFigures(47, $order, $type);
                    break;
				case 41:   //Planned – Singapore
                    $this->_calculateFigures(41, $order, $type);
                    break;
				case 42:   //Planned – Wuxi
                    $this->_calculateFigures(42, $order, $type);
                    break;
				case 43:   //Planned – QingDao
                    $this->_calculateFigures(43, $order, $type);
                    break;
				case 44:   //Planned – Ghangzhou
                    $this->_calculateFigures(44, $order, $type);
                    break;
				case 48:   //UK-Ecomm
                    $this->_calculateFigures(48, $order, $type);
                    break;
				case 49:   //US-Ecomm
                    $this->_calculateFigures(49, $order, $type);
                    break;
				case 50:   //EUR-Ecomm
                    $this->_calculateFigures(50, $order, $type);
                    break;
				case 99:   // coupon code double accounting
                    $this->_calculateFigures(99, $order, $type);
                    break;
				
				
                case -2:   //New/Planned 5
                    $this->_calculateFigures(-2, $order, $type);
                    break;
                default:   //New/Planned 4
                    $this->_calculateFigures(-1, $order, $type);
                    break;
            }
        }
    }

    private function _calculateFigures($location, $order, $dataType) {
        if ($dataType == 'actual') {
            $year = (int) date('Y', strtotime($order["ORDER_DATE"]));
            $month = (int) date('m', strtotime($order["ORDER_DATE"]));
            if ($this->_includeOrderInFigures($order)) {
                if (array_key_exists($year, $this->viewFigures) && array_key_exists($location, $this->viewFigures[$year])) {
                    $this->viewFigures[$year][$location]['figures'][$month] += floatval($order['totalexvat']);
                }
            }
        } else {
            $year = (int) date('Y', strtotime($order["target_date"]));
            $month = (int) date('m', strtotime($order["target_date"]));
            if (array_key_exists($location, $this->target[$year])) {
                $this->target[$year][$location][$month]['amount'] = floatval($order['target_amount']);
                $this->target[$year][$location][$month]['id'] = $order['sale_figure_target_id'];
            }
        }
    }

    private function _includeOrderInFigures($order) {
        $savoirOwned = isset($order["SavoirOwned"]) && $order["SavoirOwned"] == 'y';
        $orderSource = $order["orderSource"];
        if ($savoirOwned) {
            $include = (substr($orderSource, 0, 6) == 'Client' || $orderSource == 'Customer' || $orderSource == 'Ecom' || $orderSource == 'CCDA' || empty($orderSource));
        } else {
            $include = (substr($orderSource, 0, 6) == 'Client' || $orderSource == 'Customer' || $orderSource == 'Floorstock' || $orderSource == 'Stock' || $orderSource == 'Ecom' || $orderSource == 'CCDA' || empty($orderSource));
        }
        return $include;
    }

    /*
     * This function is to generate a innitial array 
     */

    private function _initialArray($type, $thisyear, $dataType, $detail = null) {
        $returnArray = array();

        $useThisShroomCode = $this->showroomCodes;
        if ($thisyear == 2016) {
            $useThisShroomCode = $this->showroomCodesBefore2016;
        }
        if ($thisyear < 2016 && $thisyear > 2012) {
            $useThisShroomCode = $this->showroomCodesBefore2015;
        }
        if ($thisyear <= 2012) {
            $useThisShroomCode = $this->showroomCodesBefore2012;
        }

        if ($type == 'world' || $type == 'region') {
            $duration = 1;
        }
        if ($type == 'worldmonth') {
            $duration = 2;
        }
        if ($dataType == 'actual') {
            for ($i = $thisyear; $i > $thisyear - $duration; $i--) {
                foreach ($useThisShroomCode as $showroomCode) {
                    $tempYearArray = array();
                    //if($type == 'world'){
                    for ($j = 1; $j <= 12; $j++) {
                        $tempYearArray[$j] = 0;
                    }
                    $returnArray[$i][$showroomCode]['figures'] = $tempYearArray;
                    $tempShowroom = $this->_getShowroomName($showroomCode);
                    $returnArray[$i][$showroomCode]['showroomName'] = $tempShowroom['location'];
                    $returnArray[$i][$showroomCode]['currency'] = $tempShowroom['currency'];
                    //}
					
                }
            }
        } else if ($dataType == 'exchange') {
            for ($i = $thisyear; $i > $thisyear - $duration; $i--) {
                $tempYearArray = array();
                for ($j = 1; $j <= 12; $j++) {
                    if (!empty($detail) && count($detail) > 0) {
                        foreach ($detail as $rate) {
                            $tempYearArray[$j][$rate ["currency_code"]] = 1.0;
                        }
                    } else {
                        $tempYearArray[$j]['USD'] = 1.0;
                        $tempYearArray[$j]['EUR'] = 1.0;
                    }
                }
                $returnArray[$i] = $tempYearArray;
            }
        } else if ($dataType == 'exchange_update') {
            for ($i = $thisyear; $i > $thisyear - $duration; $i--) {
                $tempYearArray = array();
                for ($j = 1; $j <= 12; $j++) {
                    if (!empty($detail) && count($detail) > 0) {
                        foreach ($detail as $rate) {
                            $tempYearArray[$j][$rate ["currency_code"]]['amount'] = 1.0;
                            $tempYearArray[$j][$rate ["currency_code"]]['id'] = -1;
                            $tempYearArray[$j][$rate ["currency_code"]]['changed'] = 'n';
                        }
                    } else {
                        $tempYearArray[$j]['USD']['amount'] = 1.0;
                        $tempYearArray[$j]['USD']['id'] = -1;
                        $tempYearArray[$j]['USD']['changed'] = 'n';
                        $tempYearArray[$j]['EUR']['amount'] = 1.0;
                        $tempYearArray[$j]['EUR']['id'] = -1;
                        $tempYearArray[$j]['EUR']['changed'] = 'n';
                    }
                }
                $returnArray[$i] = $tempYearArray;
            }
        } else {
            for ($i = $thisyear; $i > $thisyear - $duration; $i--) {
                foreach ($useThisShroomCode as $showroomCode) {
                    $tempYearArray = array();
                    //if($type == 'world'){
                    for ($j = 1; $j <= 12; $j++) {
                        $tempYearArray[$j]['amount'] = 0;
                        $tempYearArray[$j]['id'] = -1;
                        $tempYearArray[$j]['changed'] = 'n';
                    }
                    $returnArray[$i][$showroomCode] = $tempYearArray;
                    //}
                }
            }
        }
        if ($dataType == 'actual') {
            $this->viewFigures = $returnArray;
        } else if ($dataType == 'exchange' || $dataType == 'exchange_update') {
            $this->exchangeRate = $returnArray;
			
        } else {
            $this->target = $returnArray;
        }
    }

    /* This function is to generate a ACL array for front-end to determine
     * Which table can be shown to the user. There are 4 parameters:
     * 1. $isSuperUser (true or false): super user can see all of the tables.
     * 
     * 2. $isVisible (true or false): This one determine if the user has the 
     * 	  privilege to see any tables. if 'false', they can only see the navbar.
     * 
     * 3. $region:  when $isVisible is true, this parameter determines if the use
     * 	  can see an area table like UK, Europe, US, Aisa or false. if it is false,
     * 	  that means the user can only see the showroom table.
     * 
     * 4. $location:  when $isVisible is true and $region is false, then the $location
     * 	  will store the showroom info.
     * 
     * This part is not finished yet, need more code on 3 and 4.
     */

    private function _accessControllListGenerator() {

        /*
         * Test Mode: Only Daryl Jeff, Shanoor, Alistair, Martin, Stephen, Ahmedur is allowed to see these pages
         */
        $userId = $this->SavoirSecurity->getCurrentUsersId();
        $idArray = [1, 2, 15, 16, 19, 208, 200, 161, 199, 197, 223, 225, 228, 248];
        if (in_array((int) $userId, $idArray)) {
            $this->accessControll['isvisible'] = true;
            $this->accessControll['region'] = "";
            $this->accessControll['location'] = "";
        } else {
            $this->accessControll['isvisible'] = false;
            $this->accessControll['region'] = "";
            $this->accessControll['location'] = "";
        }
        $this->accessControll['issuperuser'] = $this->SavoirSecurity->isSuperuser();
    }

    protected function _getAllowedRoles() {
        return array("ADMINISTRATOR", "REGIONAL_ADMINISTRATOR", "SALES");
    }

}

?>
