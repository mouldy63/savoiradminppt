<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\Event\EventInterface;
use \DateTime;
use Cake\I18n\FrozenTime;

class ItemsProducedReportController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadModel('QcHistoryLatest');
	}

	public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
        $builder->addHelpers([
        	'MyForm'
        ]);
    }
	
	public function index() {
		$this->viewBuilder()->setLayout('savoir');
		$qcHistoryLatestTable = TableRegistry::get('QcHistoryLatest');
		$showrooms = TableRegistry::get('Location');
		if ($this->_userHasRole("ADMINISTRATOR")) {
			$activeshowrooms = $showrooms->getActiveShowrooms();
		} else if ($this->_userHasRole("REGIONAL_ADMINISTRATOR")) {
			$activeshowrooms = $showrooms->getActiveShowrooms($this->getCurrentUserRegionId());
		} else {
			throw Exception("User does not have correct role to use this page");
		}
		$this->set('activeshowrooms', $activeshowrooms);
		
		$formData = $this->request->getData();
		
		
		if ($this->request->is('post')) {
			$this->set('monthfrom', $this->_getSafeValueFromForm($formData, 'monthfrom'));
			$this->set('monthto', $this->_getSafeValueFromForm($formData, 'monthto'));
			$this->set('showroom', $this->_getSafeValueFromForm($formData, 'showroom'));
			$this->set('sortorder', $this->_getSafeValueFromForm($formData, 'sortorder'));
			$allData = $this->_getData($this->request->getData());
			$this->set('itemsproduced', $allData['itemsproduced']);	
		} else {
			$this->set('monthfrom', '');
			$this->set('monthto', '');
			$this->set('showroom', '');
			$this->set('sortorder', '');

		}
	}
	
	private function _getData($formData) {
		
		$qcHistoryLatestTable = TableRegistry::get('QcHistoryLatest');
		
		$monthfrom = $this->_getSTRtoDateObject($formData['monthfrom'])->i18nFormat('yyyy-MM-dd');
		$monthto = $this->_getSTRtoDateObject($formData['monthto'])->i18nFormat('yyyy-MM-dd');
		$sortorder = $formData['sortorder'];
		
		$showroom = $formData['showroom'];
		
		$itemsproduced = $this->QcHistoryLatest->getItemsFinished($showroom, $monthfrom, $monthto, $sortorder);
		$allData['itemsproduced'] = $itemsproduced;
		//debug($allData['itemsproduced']);
		//die();
		return $allData;
		
		
	}
	
	public function export() {
		
		$qcHistoryLatestTable = TableRegistry::get('QcHistoryLatest');
		$showrooms = TableRegistry::get('Location');
		$exporttable = TableRegistry::get('ExportCollections');
		$qchistory = TableRegistry::get('QcHistory');
		
		$allData = $this->_getData($this->request->getData());
		$itemsproduced = $allData['itemsproduced'];
		$data = [];
		//debug($itemsproduced);
		//die;
				
		foreach ($itemsproduced as $row) {
		
		$pn=$row["PURCHASE_No"];
		$compid=$row["ComponentID"];
		$exportdate='';
		$query=$exporttable->getCollectionDate($pn, $compid);
		foreach ($query as $row1) {
				$exportdate=date("d-m-Y", strtotime($row1['CollectionDate']));
	    }
	    if (!isset($row['bookeddeliverydate'])) {
			$bookeddeliverydate='';
		} else {
			$bookeddeliverydate=date("d-m-Y", strtotime($row['bookeddeliverydate']));
		}
	    
	    $incvat=0;
$excvat=0;
$baseprice=0;
$istrade;
$specialinstructions='';
$itemdiscount=0;
$itemdiscountnoVAT=0;
$difference=0;
$madeat='';
$difference=$row['bedsettotal']-$row['total'];
$istrade=$row['istrade'];
if ($row['ComponentID']==1) {
	$specification=$row['savoirmodel'];
	if ($row['Cut'] > $row['springunitdate']) {
		$cutdate=$row['springunitdate'];
	} else {
		$cutdate=$row['Cut'];
	}
	if ($cutdate != '') {
		$cutdate=date("d-m-Y", strtotime($cutdate));
	}
	$incvat=$row['mattressprice'];
	if ($row['mattressinstructions'] != '') {
		$specialinstructions=$row['mattressinstructions'];
	} else {
		$specialinstructions='';
	}
	if ($difference > 0) {
		$itemdiscount=$row['mattressprice']/$row['bedsettotal'];
		$itemdiscount=$difference*$itemdiscount;
		$itemdiscountnoVAT=$row['mattressprice']-$itemdiscount;
		if ($istrade != 'y') {
			$itemdiscountnoVAT=$itemdiscountnoVAT/(1+$row['vatrate']/100);
		}
		$itemdiscount=number_format($itemdiscount,2);
		$itemdiscountnoVAT=number_format($itemdiscountnoVAT,2);
	}

} else if ($row['ComponentID']==3) {
	$specification=$row['basesavoirmodel'];
	if ($row['Cut'] > $row['Framed']) {
		$cutdate=$row['Framed'];
	} else {
		$cutdate=$row['Cut'];
	}
	if ($cutdate != '') {
		$cutdate=date("d-m-Y", strtotime($cutdate));
	}
	if ($row['upholsteryprice'] !='') {
		$baseprice=$row['baseprice']+$row['upholsteryprice'];
	}
	if ($row['basetrimprice'] !='') {
		$baseprice=$baseprice+$row['basetrimprice'];
	}
	if ($row['basedrawersprice'] !='') {
		$baseprice=$baseprice+$row['basedrawersprice'];
	}
	if ($row['basefabricprice'] !='') {
		$baseprice=$baseprice+$row['basefabricprice'];
	}
	if ($row['baseinstructions'] != '') {
		$specialinstructions=$row['baseinstructions'];
	}  else {
		$specialinstructions='';
	}	
	$incvat=$baseprice;
	if ($difference > 0) {
		$itemdiscount=$baseprice/$row['bedsettotal'];
		$itemdiscount=$difference*$itemdiscount;
		$itemdiscountnoVAT=$baseprice-$itemdiscount;
		if ($istrade != 'y') {
			$itemdiscountnoVAT=$itemdiscountnoVAT/(1+$row['vatrate']/100);
		}
		$itemdiscount=number_format($itemdiscount,2);
		$itemdiscountnoVAT=number_format($itemdiscountnoVAT,2);
	}

} else if ($row['ComponentID']==5) {
	$specification=$row['toppertype'];
	$cutdate=$row['Cut'];
	if ($cutdate != '') {
		$cutdate=date("d-m-Y", strtotime($cutdate));
	}
	$incvat=$row['topperprice'];
	if ($row['specialinstructionstopper'] != '') {
		$specialinstructions=$row['specialinstructionstopper'];
	} else {
		$specialinstructions='';
	}
	if ($difference > 0) {
		$itemdiscount=$row['topperprice']/$row['bedsettotal'];
		$itemdiscount=$difference*$itemdiscount;
		$itemdiscountnoVAT=$row['topperprice']-$itemdiscount;
		if ($istrade != 'y') {
			$itemdiscountnoVAT=$itemdiscountnoVAT/(1+$row['vatrate']/100);
		}
		$itemdiscount=number_format($itemdiscount,2);
		$itemdiscountnoVAT=number_format($itemdiscountnoVAT,2);
	}

} else if ($row['ComponentID']==7) {
	$specification=$row['legstyle'];
	$cutdate=$row['prepped'];
	if ($cutdate != '') {
		$cutdate=date("d-m-Y", strtotime($cutdate));
	}
	$incvat=$row['legprice'];
	if ($row['addlegprice'] !='') {
	 $incvat=$row['legprice']+$row['addlegprice'];
	}
	if ($row['specialinstructionslegs'] != '') {
		$specialinstructions=$row['specialinstructionslegs'];
	} else {
		$specialinstructions='';
	}
	if ($difference > 0) {
		$itemdiscount=$incvat/$row['bedsettotal'];
		$itemdiscount=$difference*$itemdiscount;
		$itemdiscountnoVAT=$incvat-$itemdiscount;
		if ($istrade != 'y') {
			$itemdiscountnoVAT=$itemdiscountnoVAT/(1+$row['vatrate']/100);
		}
		$itemdiscount=number_format($itemdiscount,2);
		$itemdiscountnoVAT=number_format($itemdiscountnoVAT,2);
	}

} else if ($row['ComponentID']==8) {
	$specification=$row['headboardstyle'];
	$cutdate=$row['Framed'];
	if ($cutdate != '') {
		$cutdate=date("d-m-Y", strtotime($cutdate));
	}
	$incvat=$row['headboardprice'];
	if ($row['hbfabricprice'] != '') {
		$incvat=$incvat+$row['hbfabricprice'];
	}
	if ($row['headboardtrimprice'] != '') {
		$incvat=$incvat+$row['headboardtrimprice'];
	}
	if ($row['specialinstructionsheadboard'] != '') {
		$specialinstructions=$row['specialinstructionsheadboard'];
	} else {
		$specialinstructions='';
	}
	if ($difference > 0) {
		$itemdiscount=$incvat/$row['bedsettotal'];
		$itemdiscount=$difference*$itemdiscount;
		$itemdiscountnoVAT=$incvat-$itemdiscount;
		if ($istrade != 'y') {
			$itemdiscountnoVAT=$itemdiscountnoVAT/(1+$row['vatrate']/100);
		}
		$itemdiscount=number_format($itemdiscount,2);
		$itemdiscountnoVAT=number_format($itemdiscountnoVAT,2);
	}
}

if ($row['MadeAt']==1) {
	$madeat='Cardiff';
}
if ($row['MadeAt']==2) {
	$madeat='London';
}
if ($row['MadeAt']==3) {
	$madeat='Southern Drapes';
}

$issuedate='';
$query=$qchistory->getIssueDate($pn, $compid);
foreach ($query as $row1) {
			if (isset($row1['IssuedDate'])) {
				$issuedate=date("d-m-Y", strtotime($row1['IssuedDate']));
				}
	    }
$finished=$row['finished'];
if ($finished != '') {
	$finished=date("d-m-Y", strtotime($finished));
}
$productiondate=$row['production_completion_date'];
if ($productiondate != '') {
	$productiondate=date("d-m-Y", strtotime($productiondate));
}

if ($row['istrade']=='y') {
	$excvat=$incvat;
	$incvat=$incvat*(1+$row['vatrate']/100);
	if ($incvat != 0) {
	$incvat=number_format($incvat, 2);
	}
	if ($excvat != 0) {
	$excvat=number_format($excvat, 2);
	}
} else {
	$excvat=$incvat/(1+$row['vatrate']/100);
	if ($incvat != 0) {
	$incvat=number_format($incvat, 2);
	}
	if ($excvat != 0) {
	$excvat=number_format($excvat, 2);
	}
} 
	    	 
			
			$a = [];
			array_push($a, $this->_getSafeValueFromRs($row, 'ORDER_NUMBER'));
			array_push($a, $this->_getSafeValueFromRs($row, 'surname'));
			array_push($a, $this->_getSafeValueFromRs($row, 'orderSource'));
			array_push($a, $this->_getFormattedDateFromRs($row, 'ORDER_DATE'));
			array_push($a, $bookeddeliverydate);
			array_push($a, $exportdate);
			array_push($a, $this->_getSafeValueFromRs($row, 'adminheading'));
			array_push($a, $this->_getSafeValueFromRs($row, 'Component'));
			array_push($a, $specification);
			array_push($a, $madeat);
			array_push($a, $issuedate);
			array_push($a, $cutdate);
			array_push($a, $finished);
			array_push($a, $productiondate);
			array_push($a, $this->_getSafeValueFromRs($row, 'vatrate'));
			array_push($a, $this->_getSafeValueFromRs($row, 'istrade'));
			array_push($a, $incvat);
			array_push($a, $excvat);
			array_push($a, $itemdiscount);
			array_push($a, $itemdiscountnoVAT);
			array_push($a, $this->_getSafeValueFromRs($row, 'ordercurrency'));
			array_push($a, $specialinstructions);
			array_push($data, $a);
		}
		
		$_header = [];
		array_push($_header, 'Order Number');
		array_push($_header, 'Customer Name');
		array_push($_header, 'Order Type');
		array_push($_header, 'Order Date');
		array_push($_header, 'Delivery Date');
		array_push($_header, 'Ex Works Date');
		array_push($_header, 'Showroom');
		array_push($_header, 'Item Completed');
		array_push($_header, 'Specification');
		array_push($_header, 'Made At');
		array_push($_header, 'Issued Date');
		array_push($_header, 'First Cut/Prepped Date');
		array_push($_header, 'Item Finished Date');
		array_push($_header, 'Production Complete Date');
		array_push($_header, 'VAT rate');
		array_push($_header, 'Trade?');
		array_push($_header, 'Item inc. VAT');
		array_push($_header, 'Item exc. VAT');
		array_push($_header, 'Discount Amount');
		array_push($_header, 'Item Value Ex VAT Ex Discount');
		array_push($_header, 'Special Instructions');		
    	$this->setResponse($this->getResponse()->withDownload('ItemsProducedReport.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $_header
    	]);
	}

	function formatMoney($val) {
		if (empty($val)) $val = 0.0;
		return number_format($val, 2, '.', '');
	}
	
	private function _getSafeValueFromForm($formData, $name) {
		$value = "";
		if (isset($formData[$name])) {
			$value = $formData[$name];
		}
		return $value;
	}

	private function _getSafeValueFromRs($row, $name) {
		$value = "";
		if (isset($row[$name])) {
			$value = $row[$name];
		}
		return $value;
	}
	
	private function _getSafeMoneyValueFromRs($row, $name) {
		return !empty($row[$name]) ? $row[$name] : 0.0;;
	}
	
	private function _getFormattedDateFromRs($row, $name) {
		$date = "";
		if (isset($row[$name])) {
			$date = date("d/m/Y", strtotime(substr($row[$name],0,10)));
		}
		return $date;
	}
	
	private function _getSTRtoDateObject($str) {
		$time = FrozenTime::createFromFormat(
		'd/m/Y',
		$str,
		'Europe/London'
	);
	return $time;
	}
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR"];
	}
    
}

?>