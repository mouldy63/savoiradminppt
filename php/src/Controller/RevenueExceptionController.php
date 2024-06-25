<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class RevenueExceptionController extends SecureAppController{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}
	public function index() {
		$this->viewBuilder()->setLayout('savoir');
		$showrooms = TableRegistry::get('Location');
		
		$activeshowrooms = $showrooms->getActiveShowrooms();
		//debug($activeshowrooms);
		//die;
		$this->set('activeshowrooms', $activeshowrooms);
		$allData=Null;
		
		$formData = $this->request->getData();
		
		if ($this->request->is('post')) {
			$allData = $this->_getData($formData);
			//debug($formData);
			//die;
			
		}
		$this->set('monthfrom', $this->_getSafeValueFromForm($formData, 'monthfrom'));
		$this->set('monthto', $this->_getSafeValueFromForm($formData, 'monthto'));
		$this->set('showroom', $this->_getSafeValueFromForm($formData, 'showroom'));
		$this->set('allData', $allData);

	}
	private function _getData($formData) {
		$purchase = TableRegistry::get('Purchase');
		
		$showroom = $formData['showroom'];
		$monthfrom = $formData['monthfrom'];
		$monthto = $formData['monthto'];
		return $purchase->getRevenueException($showroom,$monthfrom,$monthto);
	}
	
	public function export() {

		$formData = $this->request->getData();
		$allData = $this->_getData($formData);
		$data = [];
		
		foreach ($allData as $row) {
		$afterVATRate = 1;
$tempDiscoutRate = 1; 
$totalafterdiscount=0;
$total=0;
$bedsettotal=0;
$discountPercent='';
$discount='';
$mattprice='';
$matt1='';
$matt2='';
$matt3='';
$matt4='';
$matt4v='';
$mattO='';
$DiscoutRate=1;
$baseprice='';
$base1='';
$base2='';
$base3='';
$base4='';
$base4v='';
$baseS='';
$baseO='';
$hw='';
$hca='';
$cw='';
$cfv='';
$topperprice='';
$headboardprice='';
$legprice='';
$accprice='';
$deliveryprice='';
$completedorders='No';
if (!empty($row['vatrate']) && $row['vatrate'] > 0) {
                $afterVATRate = (float) ((float) $row['vatrate'] + 100) / 100;
}
$bedsettotal=round((float) $row['bedsettotal'] / $afterVATRate, 2);
$totalafterdiscount=$bedsettotal;
if (!empty($row['discount'])) {
	if (strlen($row['discount']) > 0 && floatval($row['discount']) > 0.0) {
		if ($row['discounttype'] == 'currency') {
			$discount = round((float) $row['discount'] / $afterVATRate, 2);
			$DiscoutRate = 1 - (float) $row['discount'] / (float) $row['bedsettotal'];
			$discountPercent = (round((float) $row['discount'] / ((float) $row['bedsettotal']), 4) * 100);
		} else {
			$discount = round(((float) $row['bedsettotal'] * (float) $row['discount'] / 100) / $afterVATRate, 2);
			$DiscoutRate = 1 - (float) $row['discount'] / 100;
			$discountPercent = (float) $row['discount'];
		}
		$totalafterdiscount = $totalafterdiscount - $discount;
	}
}
 if ($row['mattressrequired'] == 'y') {
	$mattprice = round($row["mattr_sum"] / $afterVATRate, 2);
	$mattprice = round($mattprice * $DiscoutRate, 2);

	switch ($row["savoirmodel"]) {
		case 'No. 1':
			$matt1 = $mattprice;
			break;
		case 'No. 2':
			$matt2 = $mattprice;
			break;
		case 'No. 3':
			$matt3 = $mattprice;
			break;
		case 'No. 4':
			$matt4 = $mattprice;
			break;
		case 'No. 4v':
			$matt4v = $mattprice;
			break;
		default:
			$mattO = $mattprice;
	}
}
if ($row['baserequired'] == 'y') {
	$baseprice = round($row["base_sum"] / $afterVATRate, 2);
	$baseprice = round($baseprice * $DiscoutRate, 2);

	switch ($row["basesavoirmodel"]) {
		case 'No. 1':
			$base1 = $baseprice;
			break;
		case 'No. 2':
			$base2 = $baseprice;
			break;
		case 'No. 3':
			$base3 = $baseprice;
			break;
		case 'No. 4':
			$base4 = $baseprice;
			break;
		case 'No. 4v':
			$base4v = $baseprice;
			break;
		case 'Savoir Slim':
			$baseS = $baseprice;
			break;
		default:
			$baseO = $baseprice;
	}
}

if ($row['topperrequired'] == 'y') {
	$topperprice = round($row["topper_sum"] / $afterVATRate, 2);
	$topperprice = round($topperprice * $DiscoutRate, 2);

	switch ($row["toppertype"]) {
		case 'HW Topper':
			$hw = $baseprice;
			break;
		case 'HCa Topper':
			$hca = $baseprice;
			break;
		case 'CW Topper':
			$cw = $baseprice;
			break;
		case 'CFv Topper':
			$cfv = $baseprice;
			break;
	}
}
 if ($row['headboardrequired'] == 'y') {
	$headboardprice = round($row["hb_sum"] / $afterVATRate, 2);
	$headboardprice = round($headboardprice * $tempDiscoutRate, 2);
}
if ($row['legsrequired'] == 'y') {
	$legprice = round($row["leg_sum"] / $afterVATRate, 2);
	$legprice = round($legprice * $tempDiscoutRate, 2);
}
if ($row['accessoriesrequired'] == 'y') {
	$accprice = round($row["acce_sum"] / $afterVATRate, 2);
	$accprice = round($accprice * $tempDiscoutRate, 2);
}
if ($row['deliverycharge'] == 'y') {
	$deliveryprice = round($row["delivery_sum"] / $afterVATRate, 2);
	$deliveryprice = round($deliveryprice * $tempDiscoutRate, 2);
}
if ($row["completedorders"]=='y') {
	$completedorders = 'Yes';
}
if ($row['bookeddeliverydate']==null) {
$bookeddelivery=null;
} else {
$bookeddelivery=date('d-m-Y', strtotime($row['bookeddeliverydate']));
}
if ($row['ORDER_DATE']==null) {
$orderdate=null;
} else {
$orderdate=date('d-m-Y', strtotime($row['ORDER_DATE']));
}
if ($row['production_completion_date']==null) {
$productioncompletiondate=null;
} else {
$productioncompletiondate=date('d-m-Y', strtotime($row['production_completion_date']));
}
			$a = [$orderdate, $productioncompletiondate, $completedorders, $bookeddelivery, $row['ORDER_NUMBER'], $row['surname'], $row['company'], $row['adminheading'], $row['ordercurrency'], $discount, $discountPercent, $row['vat'], $row['vatrate'], $bedsettotal, $totalafterdiscount, $row['total'], $row['balanceoutstanding'], $row['payments'], $row['refunds'], $matt1, $matt2, $matt3, $matt4, $matt4v, $mattO, $base1, $base2, $base3, $base4, $base4v, $baseS, $baseO, $hw, $hca, $cw, $cfv, $headboardprice, $legprice, $accprice, $deliveryprice];
			array_push($data, $a);
		}
		
		$header = ['Order Date', 'Production Completion Date', 'Completed orders', 'Delivery Date', 'Order Number', 'Surname', 'Company', 'Showroom', 'Currency', 'Discount', 'Discountpercent', 'Vat',	'Vat rate', 'Total', 'Total after discount', 'Total inc VAT', 'Balance outstanding', 'Payments', 'Refunds', 'No1 mattress', 'No2 mattress', 'No3 mattress', 'No4 mattress', 'No4v mattress', 'Other mattress', 'No1 base', 'No2 base', 'No3 base', 'No4 base', 'No4v base', 'Savoir slim base', 'Other base', 'Hw topper', 'Hca topper', 'Cw topper', 'Cfv topper', 'Headboard', 'Leg', 'Accessories', 'Delivery'];

    	$this->setResponse($this->getResponse()->withDownload('RevenueException.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $header
    	]);
	}
	
	private function _getSafeValueFromForm($formData, $name) {
		$value = "";
		if (isset($formData[$name])) {
			$value = $formData[$name];
		}
		return $value;
	}
	
   protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR");
	}
}

?>