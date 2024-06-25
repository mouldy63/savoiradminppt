<?php
declare(strict_types=1);
namespace App\Model\Table;

use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class SaleFiguretestTable extends Table {

    public $name = "getSaleFigures";
    public $useTable = 'purchase';
    private $worldYearlyFiguresQuery;
    private $showroomNameQuery;
    private $accessControlQuery;
    private $worldYearlyFiguresTestQuery;
    private $worldMonthlyFiguresTestQuery;
    private $showroomCodes = [1, 3, 4, 36, 27, 24, 17, 37, 34, 39, 8, 25, 33, 26, 31, 21, 28, -1];
    private $showroomCodesBefore2012 = [1, 3, 4, 36, 27, 24, 29, 34, 8, 25, 33, 26, 31, 21, 28, 23, 14, 13, -1];
    private $showroomCodesBefore2015 = [1, 3, 4, 36, 27, 24, 29, 34, 8, 25, 33, 26, 31, 21, 28, 23, 14, -1];
    private $showroomCodesBefore2016 = [1, 3, 4, 36, 27, 24, 29, 34, 8, 25, 33, 26, 31, 21, 28, 14, -1];
    private $testCount = 0;
    private $ids = array();
    private $_monthlyFiguresDetails = null;
    private $_monthlyFigures = null;
    private $myconn;

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('sale_figure_test');
        $this->setPrimaryKey('sale_figure_test_id');
        $this->myconn = ConnectionManager::get('default');
        $this->worldYearlyFiguresQuery = "SELECT a.PURCHASE_No,a.ORDER_NUMBER,a.idlocation,b.location,c.exchange_rate," .
                "a.ORDER_DATE,a.totalexvat,a.ordercurrency,a.savoirmodel,a.topperrequired,a.accessoriesrequired,a.accessoriestotalcost,a.pinnacle," .
                "a.deliverycharge,a.deliveryprice,a.baserequired,a.legsrequired,a.headboardrequired,a.valancerequired FROM purchase AS a " .
                "LEFT JOIN location AS b ON a.idlocation=b.idlocation " .
                "LEFT JOIN sale_figure_exchange_rate AS c ON YEAR(a.ORDER_DATE)=YEAR(c.time) AND MONTH(a.ORDER_DATE)=MONTH(c.time) AND a.ordercurrency=c.currency_code " .
                "WHERE a.quote = 'n' " .
                "AND a.orderonhold = 'n' " .
                "AND a.ORDER_DATE <='%d-12-31' " .
                "AND a.ORDER_DATE >='%d-01-01' " .
                "AND (a.cancelled IS NULL OR a.cancelled <> 'y') ";

        $this->worldYearlyFiguresTestQuery = "SELECT a.PURCHASE_No,a.ORDER_NUMBER,a.idlocation,b.location,c.exchange_rate," .
                "a.ORDER_DATE,a.totalexvat,a.ordercurrency,a.savoirmodel,a.topperrequired,a.accessoriesrequired,a.accessoriestotalcost,a.pinnacle," .
                "a.deliverycharge,a.deliveryprice,a.baserequired,a.legsrequired,a.headboardrequired,a.valancerequired FROM purchase AS a " .
                "LEFT JOIN location AS b ON a.idlocation=b.idlocation " .
                "LEFT JOIN sale_figure_exchange_rate AS c ON YEAR(a.ORDER_DATE)=YEAR(c.time) AND MONTH(a.ORDER_DATE)=MONTH(c.time) AND a.ordercurrency=c.currency_code " .
                "WHERE a.quote = 'n' " .
                "AND a.orderonhold = 'n' " .
                "AND a.ORDER_DATE <='%s' " .
                "AND a.ORDER_DATE >='%s' " .
                "AND (a.cancelled IS NULL OR a.cancelled <> 'y') ";
        $this->worldMonthlyFiguresTestQuery = "SELECT a.PURCHASE_No,a.ORDER_NUMBER,a.idlocation,b.location,c.exchange_rate," .
                "a.ORDER_DATE,a.totalexvat,a.ordercurrency,a.savoirmodel,a.topperrequired,a.accessoriesrequired,a.accessoriestotalcost,a.pinnacle," .
                "a.deliverycharge,a.deliveryprice,a.baserequired,a.legsrequired,a.headboardrequired,a.valancerequired FROM purchase AS a " .
                "LEFT JOIN location AS b ON a.idlocation=b.idlocation " .
                "LEFT JOIN sale_figure_exchange_rate AS c ON YEAR(a.ORDER_DATE)=YEAR(c.time) AND MONTH(a.ORDER_DATE)=MONTH(c.time) AND a.ordercurrency=c.currency_code " .
                "WHERE a.quote = 'n' " .
                "AND a.orderonhold = 'n' " .
                "AND ((a.ORDER_DATE <='%s' AND a.ORDER_DATE >='%s') OR (a.ORDER_DATE <='%s' AND a.ORDER_DATE >='%s')) " .
                "AND (a.cancelled IS NULL OR a.cancelled <> 'y') ";

        $this->showroomNameQuery = "SELECT a.location, a.currency FROM location AS a WHERE idlocation=%d";

        $this->accessControlQuery = "SELECT a.*, b.* FROM savoir_user AS a " .
                "RIGHT JOIN savoir_userrole AS b ON a.user_id=b.user_id " .
                "WHERE a.Retired='n' AND a.user_id=%d";
    }

    public function getWorldYearlyData($year) {
        $sql = sprintf($this->worldYearlyFiguresQuery, $year, $year);
        return $this->myconn->execute($sql)->fetchAll('assoc');
    }

    public function getWorldMonthlyData($year, $month) {
        if (empty($this->_monthlyFigures)) {
            $this->_requestMonthlyFiguresArrayGenerator($year, $month);
        }
        return $this->_monthlyFigures;
    }

    public function getMonthlyFiguresDetails($year, $month) {
        if (empty($this->_monthlyFiguresDetails)) {
            $this->_requestMonthlyFiguresArrayGenerator($year, $month);
        }
        return $this->_monthlyFiguresDetails;
    }

    public function getShowroomName($showroomId) {
        $sql = sprintf($this->showroomNameQuery, $showroomId);
        return $this->myconn->execute($sql)->fetchAll('assoc');
    }

    public function getAccessControllData($id) {
        $sql = sprintf($this->accessControlQuery, $id);
        return $this->myconn->execute($sql)->fetchAll('assoc');
    }

    public function getWorldYearlyTestData($startTime, $endTime) {
        $sql = sprintf($this->worldYearlyFiguresTestQuery, $endTime, $startTime);
        return $this->myconn->execute($sql)->fetchAll('assoc');
    }

    public function getWorldMonthlyTestData($startTime, $endTime) {
        $lastYearStartTime = date('Y-m-d', strtotime($startTime . ' -1 year'));
        $lastYearEndTime = date('Y-m-d', strtotime($endTime . ' -1 year'));
        $aug = array(
            'endtime' => $endTime,
            'startTime' => $startTime,
            'lastYearEndTime' => $lastYearEndTime,
            'lastYearStartTime' => $lastYearStartTime
        );
        $this->_requestMonthlyFiguresArrayGenerator($year, $month, $aug);
        //$sql = sprintf($this->worldMonthlyFiguresTestQuery,$endTime,$startTime,$lastYearEndTime,$lastYearStartTime);
        return $this->_monthlyFigures;
    }

    private function _requestMonthlyFiguresArrayGenerator($year, $month, $aug = null) {
        if (empty($aug)) {
            $sql = sprintf($this->worldYearlyFiguresQuery, $year, $year - 1);
        } else {
            $sql = sprintf($this->worldMonthlyFiguresTestQuery, $endTime, $startTime, $lastYearEndTime, $lastYearStartTime);
        }

        //$orders = $this->query($sql, $year, $month);
        $orders = $this->myconn->execute($sql)->fetchAll('assoc');
        $this->_monthlyFigures = $orders;
        $this->_initialArray($year, $month);
        $this->_groupOrdersBasedonShowroom($orders, $year, 5);
        //die();
    }

    private function _initialArray($thisyear, $month) {
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

        foreach ($useThisShroomCode as $showroom_code) {
            $this->_monthlyFiguresDetails[$showroom_code] = array(
                'data' => array(
                    'no1' => array('amount' => 0, 'quantities' => 0, 'ly_quantities' => 0),
                    'no2' => array('amount' => 0, 'quantities' => 0, 'ly_quantities' => 0),
                    'no3' => array('amount' => 0, 'quantities' => 0, 'ly_quantities' => 0),
                    'no4' => array('amount' => 0, 'quantities' => 0, 'ly_quantities' => 0),
                    'pinnacle' => array('amount' => 0, 'quantities' => 0, 'ly_quantities' => 0),
                    'toppers' => array('amount' => 0, 'quantities' => 0, 'ly_quantities' => 0),
                    'extras' => array('amount' => 0, 'quantities' => 0, 'ly_quantities' => 0),
                    'accessories' => array('amount' => 0, 'quantities' => 0, 'ly_quantities' => 0),
                    'delivery' => array('amount' => 0, 'quantities' => 0, 'ly_quantities' => 0)
                ),
                'total' => 0,
                'ytd' => 0,
                'ly_ytd' => 0,
                'target' => 0,
                'total_quantities' => 0,
                'ly_total_quantities' => 0,
                'ly_amount' => 0,
                'ytd_target' => 0,
                'showroom_name' => '',
                'currency' => '',
                'year' => $thisyear,
                'month' => $month
            );
        }
    }

    private function _groupOrdersBasedonShowroom($orders, $year, $month) {
        foreach ($orders as $order) {
            //echo var_dump((int)$order['a']['idlocation']);
            //die();
            switch ((int) $order['a']['idlocation']) {
                case 1:    //Head Office;
                    $this->_selectOrderBasedonYearMonth(1, $order, $year, $month);
                    break;
                case 3:    //Wgimore Street;
                    $this->_selectOrderBasedonYearMonth(3, $order, $year, $month);
                    break;
                case 4:    //Harrods;
                    $this->_selectOrderBasedonYearMonth(4, $order, $year, $month);
                    break;
                case 36:   //Chelsea Harbor;
                    $this->_selectOrderBasedonYearMonth(36, $order, $year, $month);
                    break;
                case 27:   //Cardiff;
                    $this->_selectOrderBasedonYearMonth(27, $order, $year, $month);
                    break;
                case 24:   //Dusseldorf;
                    $this->_selectOrderBasedonYearMonth(24, $order, $year, $month);
                    break;
                case 17:   //Paris;
                    $this->_selectOrderBasedonYearMonth(29, $order, $year, $month);
                    break;
                case 29:   //Paris;
                    $this->_selectOrderBasedonYearMonth(29, $order, $year, $month);
                    break;
                case 25:   //St. Peterburg;
                    $this->_selectOrderBasedonYearMonth(25, $order, $year, $month);
                    break;
                case 37:   //NY Downtown2;
                    $this->_selectOrderBasedonYearMonth(37, $order, $year, $month);
                    break;
                case 34:   //NY Uptown;
                    $this->_selectOrderBasedonYearMonth(34, $order, $year, $month);
                    break;
				case 39:   //NY Outreach;
                    $this->_selectOrderBasedonYearMonth(39, $order, $year, $month);
                    break;
                case 8:    //NY downtown;
                    $this->_selectOrderBasedonYearMonth(8, $order, $year, $month);
                    break;
                case 33:   //Hong Kong;
                    $this->_selectOrderBasedonYearMonth(33, $order, $year, $month);
                    break;
                case 22:   //Beijing;
                    $this->_selectOrderBasedonYearMonth(26, $order, $year, $month);
                    break;
                case 26:   //Beijing;
                    $this->_selectOrderBasedonYearMonth(26, $order, $year, $month);
                    break;
                case 30:   //Beijing;
                    $this->_selectOrderBasedonYearMonth(26, $order, $year, $month);
                    break;
                case 31:   //Seoul;
                    $this->_selectOrderBasedonYearMonth(31, $order, $year, $month);
                    break;
                case 35:   //Seoul;
                    $this->_selectOrderBasedonYearMonth(31, $order, $year, $month);
                    break;
                case 21:   //Shanghai;
                    $this->_selectOrderBasedonYearMonth(21, $order, $year, $month);
                    break;
                case 28:   //Taiwan;
                    $this->_selectOrderBasedonYearMonth(28, $order, $year, $month);
                    break;
                case 13:   //Praha; Before 2013
                    $this->_selectOrderBasedonYearMonth(13, $order, $year, $month);
                    break;
                case 14:   //Berlin Postdam; Before 2016
                    $this->_selectOrderBasedonYearMonth(14, $order, $year, $month);
                    break;
                case 23:   //Trade & Contract; Before 2015
                    $this->_selectOrderBasedonYearMonth(23, $order, $year, $month);
                    break;
                default:
                    $this->_selectOrderBasedonYearMonth(-1, $order, $year, $month);
                    break;
            }
        }
    }

    private function _selectOrderBasedonYearMonth($showroom, $order, $year, $month) {
        $orderYear = (int) date('Y', strtotime($order['a']["ORDER_DATE"]));
        $orderMonth = (int) date('m', strtotime($order['a']["ORDER_DATE"]));
        if ($year == $orderYear && $month == $orderMonth) {
            if ($showroom == 39) {
                $this->testCount++;
                $this->ids[] = $order['a']["PURCHASE_No"];
                //echo $order['a']['PURCHASE_No']. ' , ',$order['a']['savoirmodel']. ' , ',$order['a']['accessoriestotalcost']. ' , '.$order['a']['totalexvat'];
                //echo '<br>';
            }

            $this->_calculateRequiredFigures($showroom, $order, false);
        } else if ($year - 1 == $orderYear && $month == $orderMonth) {
            $this->_calculateRequiredFigures($showroom, $order, true);
        }
    }

    private function _calculateRequiredFigures($showroom_code, $order, $isLastYear) {

        if (!$isLastYear) {

            $this->_monthlyFiguresDetails[$showroom_code]['total'] += floatval($order['a']['totalexvat']);
            $this->_monthlyFiguresDetails[$showroom_code]['total_quantities'] += 1;
            /*
              if($order['a']["accessoriesrequired"] == 'y'){
              $this->_monthlyFiguresDetails[$showroom_code]['accessories']['amount'] += floatval($order['a']['accessoriestotalcost']);
              $this->_monthlyFiguresDetails[$showroom_code]['accessories']['quantities'] += 1;
              }
             */
            if ($order['a']["savoirmodel"] == "No. 1") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['no1']['amount'] += floatval($order['a']['totalexvat']);
                $this->_monthlyFiguresDetails[$showroom_code]['data']['no1']['quantities'] += 1;
            } else if ($order['a']["savoirmodel"] == "No. 2") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['no2']['amount'] += floatval($order['a']['totalexvat']);
                $this->_monthlyFiguresDetails[$showroom_code]['data']['no2']['quantities'] += 1;
            } else if ($order['a']["savoirmodel"] == "No. 3") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['no3']['amount'] += floatval($order['a']['totalexvat']);
                $this->_monthlyFiguresDetails[$showroom_code]['data']['no3']['quantities'] += 1;
            } else if ($order['a']["savoirmodel"] == "No. 4") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['no4']['amount'] += floatval($order['a']['totalexvat']);
                $this->_monthlyFiguresDetails[$showroom_code]['data']['no4']['quantities'] += 1;
            } else if ($order['a']["pinnacle"] == "y") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['pinnacle']['amount'] += floatval($order['a']['totalexvat']);
                $this->_monthlyFiguresDetails[$showroom_code]['data']['pinnacle']['quantities'] += 1;
            } else if ($order['a']["baserequired"] == "y" || $order['a']["legsrequired"] == "y" || $order['a']["headboardrequired"] == "y" || $order['a']["valancerequired"] == "y") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['extras']['amount'] += floatval($order['a']['totalexvat']);
                $this->_monthlyFiguresDetails[$showroom_code]['data']['extras']['quantities'] += 1;
            } else if ($order['a']["topperrequired"] == "y") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['toppers']['amount'] += floatval($order['a']['totalexvat']);
                $this->_monthlyFiguresDetails[$showroom_code]['data']['toppers']['quantities'] += 1;
            } else if ($order['a']["accessoriesrequired"] == 'y') {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['accessories']['amount'] += floatval($order['a']['totalexvat']);
                $this->_monthlyFiguresDetails[$showroom_code]['data']['accessories']['quantities'] += 1;
            } else if ($order['a']["deliverycharge"] == "y") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['delivery']['amount'] += floatval($order['a']['totalexvat']);
                $this->_monthlyFiguresDetails[$showroom_code]['data']['delivery']['quantities'] += 1;
            } else {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['extras']['amount'] += floatval($order['a']['totalexvat']);
                $this->_monthlyFiguresDetails[$showroom_code]['data']['extras']['quantities'] += 1;
            }
        } else {
            $this->_monthlyFiguresDetails[$showroom_code]['ly_total_quantities'] += 1;
            if ($order['a']["savoirmodel"] == "No. 1") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['no1']['ly_quantities'] += 1;
            } else if ($order['a']["savoirmodel"] == "No. 2") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['no2']['ly_quantities'] += 1;
            } else if ($order['a']["savoirmodel"] == "No. 3") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['no3']['ly_quantities'] += 1;
            } else if ($order['a']["savoirmodel"] == "No. 4") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['no4']['ly_quantities'] += 1;
            } else if ($order['a']["pinnacle"] == "y") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['pinnacle']['ly_quantities'] += 1;
            } else if ($order['a']["baserequired"] == "y" || $order['a']["legsrequired"] == "y" || $order['a']["headboardrequired"] == "y" || $order['a']["valancerequired"] == "y") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['extras']['ly_quantities'] += 1;
            } else if ($order['a']["topperrequired"] == "y") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['toppers']['ly_quantities'] += 1;
            } else if ($order['a']["accessoriesrequired"] == 'y') {
                $this->_monthlyFiguresDetails[$showroom_code]['accessories']['ly_quantities'] += 1;
            } else if ($order['a']["deliverycharge"] == "y") {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['delivery']['ly_quantities'] += 1;
            } else {
                $this->_monthlyFiguresDetails[$showroom_code]['data']['extras']['ly_quantities'] += 1;
            }
        }
    }

}

?>