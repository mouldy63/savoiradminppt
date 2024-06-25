<?php
declare(strict_types=1);
namespace App\Model\Table;

use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class SaleFigureModelTable extends Table {

    // public $name = "getSaleFigures";
    private $worldYearlyFiguresQuery;
    private $showroomNameQuery;
    private $accessControlQuery;
    private $worldYearlyFiguresTestQuery;
    private $worldMonthlyFiguresTestQuery;
    private $showroomCodes = [1, 48, 49, 50, 3, 4, 36, 27, 24, 17, 37, 34, 39, 99, 33, 26, 31, 35, 21, 28, 38, 40, 41, 42, 43, 44, 45, 47, -1, -2];
    private $showroomCodesBefore2012 = [1, 3, 4, 36, 27, 24, 29, 34, 33, 26, 31, 21, 28, 23, 14, 13, -1];
    private $showroomCodesBefore2015 = [1, 3, 4, 36, 27, 24, 29, 34, 33, 26, 31, 21, 28, 23, 14, -1];
    private $showroomCodesBefore2016 = [1, 3, 4, 36, 27, 24, 29, 34, 33, 26, 31, 21, 28, 14, -1];
    private $showroomCodeTakenAccount = [1, 3, 4, 36, 27, 24, 17, 37, 34, 39];
    private $_monthlyFiguresDetails = null;
    private $_monthlyFigures = null;
    private $_monthlyOrderSourceTotals = null;
    private $myconn;

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('PURCHASE_No');
        $this->myconn = ConnectionManager::get('default');
        // the monthly figures!!! the 1st UNION adds in the ecom sales to the 'virtual' showroom's figures
        // the 2nd union adds in the double accounting deduction 'showroom' - idlocation=99
        $this->worldYearlyFiguresQuery = "SELECT a.PURCHASE_No,a.ORDER_NUMBER,a.idlocation,b.location,a.pinnacleBedRef,a.customerreference,a.basesavoirmodel," .
                "a.ORDER_DATE,a.totalexvat,a.ordercurrency,a.savoirmodel,a.topperrequired,a.accessoriesrequired,a.accessoriestotalcost,a.pinnacle,a.companyname,a.headboardstyle," .
                "a.deliverycharge,a.deliveryprice,a.baserequired,a.legsrequired,a.headboardrequired,a.valancerequired,a.toppertype,a.orderSource,b.SavoirOwned" .
                ", (select d.surname from contact d where d.code=a.code order by d.contact_no desc limit 1) as surname " .
        		", (select c.exchange_rate from sale_figure_exchange_rate c where YEAR(a.ORDER_DATE)=YEAR(c.time) AND MONTH(a.ORDER_DATE)=MONTH(c.time) AND a.ordercurrency=c.currency_code order by c.time desc limit 1) as exchange_rate " .
                "FROM purchase AS a " .
                "JOIN location AS b ON a.idlocation=b.idlocation " .
                "WHERE a.quote = 'n' " .
                "AND a.orderonhold = 'n' " .
                "AND a.ORDER_DATE <='%d-12-31' " .
                "AND a.ORDER_DATE >='%d-01-01' " .
                "AND (a.cancelled IS NULL OR a.cancelled <> 'y') " .
        		"UNION " .
        		"SELECT a.PURCHASE_No,a.ORDER_NUMBER,b.idlocation,b.location,a.pinnacleBedRef,a.customerreference,a.basesavoirmodel," .
                "a.ORDER_DATE,a.totalexvat,a.ordercurrency,a.savoirmodel,a.topperrequired,a.accessoriesrequired,a.accessoriestotalcost,a.pinnacle,a.companyname,a.headboardstyle," .
                "a.deliverycharge,a.deliveryprice,a.baserequired,a.legsrequired,a.headboardrequired,a.valancerequired,a.toppertype,'Ecom' as orderSource,b.SavoirOwned" .
                ", (select d.surname from contact d where d.code=a.code order by d.contact_no desc limit 1) as surname " .
        		", (select c.exchange_rate from sale_figure_exchange_rate c where YEAR(a.ORDER_DATE)=YEAR(c.time) AND MONTH(a.ORDER_DATE)=MONTH(c.time) AND a.ordercurrency=c.currency_code order by c.time desc limit 1) as exchange_rate " .
                "FROM purchase AS a " .
                "join purchase_coupon pc on a.PURCHASE_No=pc.purchase_no " .
                "JOIN location AS b ON pc.virtual_idlocation=b.idlocation " .
                "WHERE a.quote = 'n' " .
                "AND a.orderonhold = 'n' " .
                "AND a.ORDER_DATE <='%d-12-31' " .
                "AND a.ORDER_DATE >='%d-01-01' " .
                "AND (a.cancelled IS NULL OR a.cancelled <> 'y') " .
        		"UNION " .
        		"SELECT a.PURCHASE_No,a.ORDER_NUMBER, 99 as idlocation, 'Coupon Codes' as location,a.pinnacleBedRef,a.customerreference,a.basesavoirmodel, " .
        		"a.ORDER_DATE,-1*a.totalexvat as totalexvat,a.ordercurrency,a.savoirmodel,a.topperrequired,a.accessoriesrequired,a.accessoriestotalcost,a.pinnacle,a.companyname,a.headboardstyle, " .
        		"a.deliverycharge,a.deliveryprice,a.baserequired,a.legsrequired,a.headboardrequired,a.valancerequired,a.toppertype,'CCDA' as orderSource,b.SavoirOwned " .
        		", (select d.surname from contact d where d.code=a.code order by d.contact_no desc limit 1) as surname " .
        		", (select c.exchange_rate from sale_figure_exchange_rate c where YEAR(a.ORDER_DATE)=YEAR(c.time) AND MONTH(a.ORDER_DATE)=MONTH(c.time) AND a.ordercurrency=c.currency_code order by c.time desc limit 1) as exchange_rate " .
        		"FROM purchase AS a " .
        		"join purchase_coupon pc on a.PURCHASE_No=pc.purchase_no " .
        		"JOIN location AS b ON pc.virtual_idlocation=b.idlocation " .
        		"WHERE a.quote = 'n' " .
        		"AND a.orderonhold = 'n' " .
        		"AND a.ORDER_DATE <='%d-12-31' " .
        		"AND a.ORDER_DATE >='%d-01-01' " .
                "AND (a.cancelled IS NULL OR a.cancelled <> 'y') ";

        $this->worldYearlyFiguresTestQuery = "SELECT a.PURCHASE_No,a.ORDER_NUMBER,a.idlocation,b.location,c.exchange_rate," .
                "a.ORDER_DATE,a.totalexvat,a.ordercurrency,a.savoirmodel,a.topperrequired,a.accessoriesrequired,a.accessoriestotalcost,a.pinnacle," .
                "a.deliverycharge,a.deliveryprice,a.baserequired,a.legsrequired,a.headboardrequired,a.valancerequired,a.orderSource FROM purchase AS a " .
                "LEFT JOIN location AS b ON a.idlocation=b.idlocation " .
                "LEFT JOIN sale_figure_exchange_rate AS c ON YEAR(a.ORDER_DATE)=YEAR(c.time) AND MONTH(a.ORDER_DATE)=MONTH(c.time) AND a.ordercurrency=c.currency_code " .
                "WHERE a.quote = 'n' " .
                "AND a.orderonhold = 'n' " .
                "AND a.ORDER_DATE <='%s' " .
                "AND a.ORDER_DATE >='%s' " .
                "AND (a.cancelled IS NULL OR a.cancelled <> 'y') ";
        $this->worldMonthlyFiguresTestQuery = "SELECT a.PURCHASE_No,a.ORDER_NUMBER,a.idlocation,b.location,c.exchange_rate," .
                "a.ORDER_DATE,a.totalexvat,a.ordercurrency,a.savoirmodel,a.topperrequired,a.accessoriesrequired,a.accessoriestotalcost,a.pinnacle," .
                "a.deliverycharge,a.deliveryprice,a.baserequired,a.legsrequired,a.headboardrequired,a.valancerequired,a.orderSource FROM purchase AS a " .
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
        $sql = sprintf($this->worldYearlyFiguresQuery, $year, $year, $year, $year, $year, $year);
        return $this->myconn->execute($sql)->fetchAll('assoc');
    }

    public function getWorldMonthlyData($year, $month) {//
        if (empty($this->_monthlyFigures)) {
            $this->_requestMonthlyFiguresArrayGenerator($year, $month);
        }
        return $this->_monthlyFigures;
    }

    public function getMonthlyFiguresDetails($year, $month) {//
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
        return $this->_monthlyFigures;
    }

    private function _requestMonthlyFiguresArrayGenerator($year, $month, $aug = null) { //HERE
        if (empty($aug)) {
            $sql = sprintf($this->worldYearlyFiguresQuery, $year, $year - 1, $year, $year - 1, $year, $year - 1);
        } else {
            $sql = sprintf($this->worldMonthlyFiguresTestQuery, $endTime, $startTime, $lastYearEndTime, $lastYearStartTime);
        }

        $orders = $this->myconn->execute($sql)->fetchAll('assoc');
        $this->_monthlyFigures = $orders;
        $this->_initialArray($year, $month);

        $this->_groupOrdersBasedonShowroom($orders, $year, $month); //HERE
    }

    private function _initialArray($thisyear, $month) {
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
                'year' => (int) $thisyear,
                'month' => (int) $month,
                'order_detail' => array()
            );
        }
    }

    private function _groupOrdersBasedonShowroom($orders, $year, $month) {
        //$totalOrderSourceArray = $this->totalOrderSource($orders);
        //var_dump($totalOrderSourceArray);
        foreach ($orders as $order) {
            //echo var_dump((int)$order['idlocation']);
            //die();
            switch ((int) $order['idlocation']) {
                case 1:                //Head Office;
                    $this->_selectOrderBasedonYearMonth(1, $order, $year, $month);
                    break;
                case 3:                //Wgimore Street;
                    $this->_selectOrderBasedonYearMonth(3, $order, $year, $month);
                    break;
                case 4:                //Harrods;
                    $this->_selectOrderBasedonYearMonth(4, $order, $year, $month);
                    break;
                case 36:            //Chelsea Harbor;
                    $this->_selectOrderBasedonYearMonth(36, $order, $year, $month);
                    break;
                case 27:            //Cardiff;
                    $this->_selectOrderBasedonYearMonth(27, $order, $year, $month);
                    break;
                case 24:            //Dusseldorf;
                    $this->_selectOrderBasedonYearMonth(24, $order, $year, $month);
                    break;
                case 17:            //Paris;
                    $this->_selectOrderBasedonYearMonth(17, $order, $year, $month);
                    break;
                case 29:            //Paris;
                    $this->_selectOrderBasedonYearMonth(29, $order, $year, $month);
                    break;
                case 37:            //NY Downtown2;
                    $this->_selectOrderBasedonYearMonth(37, $order, $year, $month);
                    break;
                case 34:            //NY Uptown;
                    $this->_selectOrderBasedonYearMonth(34, $order, $year, $month);
                    break;
				case 39:            //NY Outreach;
                    $this->_selectOrderBasedonYearMonth(39, $order, $year, $month);
                    break;
                case 33:            //Hong Kong;
                    $this->_selectOrderBasedonYearMonth(33, $order, $year, $month);
                    break;
                case 22:            //Beijing;
                    $this->_selectOrderBasedonYearMonth(22, $order, $year, $month);
                    break;
                case 26:            //Beijing;
                    $this->_selectOrderBasedonYearMonth(26, $order, $year, $month);
                    break;
                case 30:            //Beijing;
                    $this->_selectOrderBasedonYearMonth(30, $order, $year, $month);
                    break;
                case 31:            //Seoul;
                    $this->_selectOrderBasedonYearMonth(31, $order, $year, $month);
                    break;
                case 35:            //Seoul;
                    $this->_selectOrderBasedonYearMonth(35, $order, $year, $month);
                    break;
                case 21:            //Shanghai;
                    $this->_selectOrderBasedonYearMonth(21, $order, $year, $month);
                    break;
                case 28:            //Taiwan;
                    $this->_selectOrderBasedonYearMonth(28, $order, $year, $month);
                    break;
                case 13:            //Praha; Before 2013
                    $this->_selectOrderBasedonYearMonth(13, $order, $year, $month);
                    break;
                case 14:            //Berlin Postdam; Before 2016
                    $this->_selectOrderBasedonYearMonth(14, $order, $year, $month);
                    break;
                case 23:            //Trade & Contract; Before 2015
                    $this->_selectOrderBasedonYearMonth(23, $order, $year, $month);
                    break;
                case 38:            //Moscow
                    $this->_selectOrderBasedonYearMonth(38, $order, $year, $month);
                    break;
				case 40:            //Berlin Head Office
                    $this->_selectOrderBasedonYearMonth(40, $order, $year, $month);
                    break;
				case 45:            //Planned – Frankfurt
                    $this->_selectOrderBasedonYearMonth(45, $order, $year, $month);
                    break;
				case 47:            //Pelini - Shanghai
                    $this->_selectOrderBasedonYearMonth(47, $order, $year, $month);
                    break;
				case 41:            //Planned – Singapore
                    $this->_selectOrderBasedonYearMonth(41, $order, $year, $month);
                    break;
				case 42:            //Planned – Wuxi
                    $this->_selectOrderBasedonYearMonth(42, $order, $year, $month);
                    break;
				case 43:            //Planned – QingDao
                    $this->_selectOrderBasedonYearMonth(43, $order, $year, $month);
                    break;
				case 44:            //Planned – Ghangzhou
                    $this->_selectOrderBasedonYearMonth(44, $order, $year, $month);
                    break;
				case 48:            //UK-Ecomm
                    $this->_selectOrderBasedonYearMonth(48, $order, $year, $month);
                    break;
				case 49:            //US-Ecomm
                    $this->_selectOrderBasedonYearMonth(49, $order, $year, $month);
                    break;
				case 50:            //EUR-Ecomm
                    $this->_selectOrderBasedonYearMonth(50, $order, $year, $month);
                    break;
				case 99:            // coupon code double accounting
                    $this->_selectOrderBasedonYearMonth(99, $order, $year, $month);
                    break;
				
                case -2:            //New/Planned 5
                    $this->_selectOrderBasedonYearMonth(-2, $order, $year, $month);
                    break;
                default:   //New/Planned 4
                    $this->_selectOrderBasedonYearMonth(-1, $order, $year, $month);
                    break;
            }
            //var_dump($order);
        }
    }

    private function _selectOrderBasedonYearMonth($showroom, $order, $year, $month) {
        $orderYear = (int) date('Y', strtotime($order["ORDER_DATE"]));
        $orderMonth = (int) date('m', strtotime($order["ORDER_DATE"]));
        if ($year == $orderYear && $month == $orderMonth) {
            $this->_calculateRequiredFigures($showroom, $order, false, $order['orderSource']);
        } else if ($year - 1 == $orderYear && $month == $orderMonth) {
            $this->_calculateRequiredFigures($showroom, $order, true, $order['orderSource']);
        }
    }

    //HERE is where the print response actual is created
    private function _calculateRequiredFigures($showroom_code, $order, $isLastYear, $orderSource) {
        if (array_key_exists($showroom_code, $this->_monthlyFiguresDetails)):
            if (!$isLastYear) {
                if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                    $this->_monthlyFiguresDetails[$showroom_code]['total'] += floatval($order['totalexvat']); /// HERE
                    $this->_monthlyFiguresDetails[$showroom_code]['total_quantities'] += 1;
                }
                if ($order["savoirmodel"] == "No. 1") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['no1']['amount'] += floatval($order['totalexvat']);
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['no1']['quantities'] += 1;
                    }
                    $this->_monthlyFiguresDetails[$showroom_code]['order_detail'][] = $this->_createOrderDetail($order, "No. 1");
                } else if ($order["savoirmodel"] == "No. 2") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['no2']['amount'] += floatval($order['totalexvat']);
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['no2']['quantities'] += 1;
                    }
                    $this->_monthlyFiguresDetails[$showroom_code]['order_detail'][] = $this->_createOrderDetail($order, "No. 2");
                } else if ($order["savoirmodel"] == "No. 3") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['no3']['amount'] += floatval($order['totalexvat']);
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['no3']['quantities'] += 1;
                    }
                    $this->_monthlyFiguresDetails[$showroom_code]['order_detail'][] = $this->_createOrderDetail($order, "No. 3");
                } else if ($order["savoirmodel"] == "No. 4") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['no4']['amount'] += floatval($order['totalexvat']);
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['no4']['quantities'] += 1;
                    }
                    $this->_monthlyFiguresDetails[$showroom_code]['order_detail'][] = $this->_createOrderDetail($order, "No. 4");
                } else if ($order["pinnacle"] == "y") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['pinnacle']['amount'] += floatval($order['totalexvat']);
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['pinnacle']['quantities'] += 1;
                    }
                    $this->_monthlyFiguresDetails[$showroom_code]['order_detail'][] = $this->_createOrderDetail($order, "Pinnacle");
                } else if ($order["baserequired"] == "y" || $order["legsrequired"] == "y" || $order["headboardrequired"] == "y" || $order["valancerequired"] == "y") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['extras']['amount'] += floatval($order['totalexvat']);
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['extras']['quantities'] += 1;
                    }
                    $this->_monthlyFiguresDetails[$showroom_code]['order_detail'][] = $this->_createOrderDetail($order, "Extra");
                } else if ($order["topperrequired"] == "y") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['toppers']['amount'] += floatval($order['totalexvat']);
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['toppers']['quantities'] += 1;
                    }
                    $this->_monthlyFiguresDetails[$showroom_code]['order_detail'][] = $this->_createOrderDetail($order, "Topper");
                } else if ($order["accessoriesrequired"] == 'y') {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['accessories']['amount'] += floatval($order['totalexvat']);
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['accessories']['quantities'] += 1;
                    }
                    $this->_monthlyFiguresDetails[$showroom_code]['order_detail'][] = $this->_createOrderDetail($order, "Accs");
                } else if ($order["deliverycharge"] == "y") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['delivery']['amount'] += floatval($order['totalexvat']);
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['delivery']['quantities'] += 1;
                    }
                    $this->_monthlyFiguresDetails[$showroom_code]['order_detail'][] = $this->_createOrderDetail($order, "Delivery");
                } else {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['extras']['amount'] += floatval($order['totalexvat']);
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['extras']['quantities'] += 1;
                    }
                    $this->_monthlyFiguresDetails[$showroom_code]['order_detail'][] = $this->_createOrderDetail($order, "Extra");
                }
            } else {
                if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                    $this->_monthlyFiguresDetails[$showroom_code]['ly_total_quantities'] += 1;
                }
                if ($order["savoirmodel"] == "No. 1") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['no1']['ly_quantities'] += 1;
                    }
                } else if ($order["savoirmodel"] == "No. 2") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['no2']['ly_quantities'] += 1;
                    }
                } else if ($order["savoirmodel"] == "No. 3") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['no3']['ly_quantities'] += 1;
                    }
                } else if ($order["savoirmodel"] == "No. 4") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['no4']['ly_quantities'] += 1;
                    }
                } else if ($order["pinnacle"] == "y") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['pinnacle']['ly_quantities'] += 1;
                    }
                } else if ($order["baserequired"] == "y" || $order["legsrequired"] == "y" || $order["headboardrequired"] == "y" || $order["valancerequired"] == "y") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['extras']['ly_quantities'] += 1;
                    }
                } else if ($order["topperrequired"] == "y") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['toppers']['ly_quantities'] += 1;
                    }
                } else if ($order["accessoriesrequired"] == 'y') {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['accessories']['ly_quantities'] += 1;
                    }
                } else if ($order["deliverycharge"] == "y") {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['delivery']['ly_quantities'] += 1;
                    }
                } else {
                    if ($this->_isThisOrderTakenAccount($showroom_code, $order)) {
                        $this->_monthlyFiguresDetails[$showroom_code]['data']['extras']['ly_quantities'] += 1;
                    }
                }
            }
        endif;
    }

    private function _isThisOrderTakenAccount($showroom_code, $order) {
        $isTestOrder = $order['orderSource'] == 'Test' ? true : false;
        $isMarketingOrder = $order['orderSource'] == 'Marketing' ? true : false;
        if ($isTestOrder) {
            return false;
        }
        if ($isMarketingOrder) {
            return false;
        }
        if ($order['orderSource'] == 'Ecom' || $order['orderSource'] == 'CCDA') { // CCDA - coupon code double accounting
        	return true;
        }

        $isCustomerOrder = $order['orderSource'] == 'Customer' ? true : false;
        $onlyCustomerOrderRequired = in_array($showroom_code, $this->showroomCodeTakenAccount);
        $isOrderSourceNull = empty($order['orderSource']) ? true : false;
        $isCustomerClientOrder = substr($order['orderSource'], 0, 6) == 'Client' ? true : false;
        
        if ($onlyCustomerOrderRequired) {
            if ($isCustomerOrder || $isOrderSourceNull || $isCustomerClientOrder) {
                return true;
            } else {
            	return false;
            }
        } else {
        	return true;
        }
    }

    private function _createOrderDetail($order, $cat) {
        $returnOrder = array(
            'order_no' => $order['ORDER_NUMBER'],
            'customer' => $order['surname'],
            'value' => $order['totalexvat'],
            'orderSource' => $order['orderSource'],
            'description' => $this->_createDescription($order),
            'company' => $order['companyname'],
            'ref' => $order['customerreference'],
            'cat' => $cat,
        	'orderDate' => date('d/m/Y', strtotime($order["ORDER_DATE"])),
        );
        return $returnOrder;
    }

    private function _createDescription($order) {
        $description = '';
        if ($order["savoirmodel"] && $order["savoirmodel"] != 'n') {
            $description .= 'Matt:' . $order["savoirmodel"] . ', ';
        }
        if ($order['toppertype'] && $order['toppertype'] != 'n') {
            $description .= str_replace('Topper', '', $order["toppertype"]) . ', ';
        }
        if ($order['basesavoirmodel']) {
            $description .= 'Base:' . $order["basesavoirmodel"] . ', ';
        }
        if ($order['headboardstyle']) {
            $description .= 'HB:' . $order["headboardstyle"] . ', ';
        }
        if ($order["accessoriesrequired"] == 'y') {
            $description .= 'Accs';
        }
        return $description;
    }

    public function totalOrderSource($orders, $year, $month) {
        $sourcesWeWant = array('Floorstock' => 'Floorstock', 'Stock' => 'Stock', 'Client' => 'Client', 'Client Retail' => 'Client', 'Client Trade' => 'Client', 'Client Contract' => 'Client', 'Customer' => 'Client', 'Marketing' => 'Marketing', 'Test' => 'Test', 'Ecom' => 'Ecom');
        $locations = array();

        //initialise
        foreach ($orders as $order) {
            $orderSource = $order['orderSource'];
            if (!isset($orderSource) || empty($orderSource)) {
            	$orderSource = "Other";
            }

            if (array_key_exists($orderSource, $sourcesWeWant)) {
                $idLocation = $order['idlocation'];
                foreach (array_values($sourcesWeWant) as $source) {
                    $totals[$idLocation][$source] = 0.0;
                }
            }
        }

        foreach ($orders as $order) {
            $idLocation = $order['idlocation'];
            $orderSource = $order['orderSource'];
            if (!isset($orderSource) || empty($orderSource)) {
            	$orderSource = "Other";
            }
            $orderYear = (int) date('Y', strtotime($order["ORDER_DATE"]));
            $orderMonth = (int) date('m', strtotime($order["ORDER_DATE"]));
            if ($year == $orderYear && $month == $orderMonth) {
                if (array_key_exists($orderSource, $sourcesWeWant)) {
                    $totals[$idLocation][$sourcesWeWant[$orderSource]] += floatval($order['totalexvat']);
                }
            }
        }

        return $totals;
    }
    
    public function getVirtualSalesForShowroom($idLocation, $year, $month, $currency) {
    	$sql = " SELECT sum(p.totalexvat) as amount ,count(*) as quantities, ". $year . " as year";
    	$sql .= " FROM purchase p join purchase_coupon pc on p.PURCHASE_No=pc.purchase_no";
    	$sql .= " where YEAR(p.ORDER_DATE)=". $year. " and MONTH(p.ORDER_DATE)=" . $month . " and pc.virtual_idlocation=" . $idLocation;
    	$sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled IS NULL OR p.cancelled <> 'y')";
    	if (!empty($currency)) {
	    	$sql .= " and p.ordercurrency='" . $currency. "'";
    	}
    	$sql .= " UNION";
    	$sql .= " SELECT sum(p.totalexvat) as amount ,count(*) as quantities, ". ($year-1) . " as year";
    	$sql .= " FROM purchase p join purchase_coupon pc on p.PURCHASE_No=pc.purchase_no";
    	$sql .= " where YEAR(p.ORDER_DATE)=". ($year-1) . " and MONTH(p.ORDER_DATE)=" . $month . " and pc.virtual_idlocation=" . $idLocation;
    	$sql .= " and p.quote = 'n' and p.orderonhold = 'n' and (p.cancelled IS NULL OR p.cancelled <> 'y')";
    	if (!empty($currency)) {
	    	$sql .= " and p.ordercurrency='" . $currency. "'";
    	}
    	return $this->myconn->execute($sql)->fetchAll('assoc');
    }

}

?>
