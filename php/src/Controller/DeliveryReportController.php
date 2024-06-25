<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\Event\EventInterface;

class DeliveryReportController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
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
		
		$showrooms = TableRegistry::get('Location');
		if ($this->_userHasRole("ADMINISTRATOR")) {
			$activeshowrooms = $showrooms->getActiveShowrooms();
		} else if ($this->_userHasRole("REGIONAL_ADMINISTRATOR")) {
			$activeshowrooms = $showrooms->getActiveShowrooms($this->getCurrentUserRegionId());
		} else if ($this->isSavoirOwned()) {
			$activeshowrooms = $showrooms->getActiveShowrooms($this->getCurrentUserRegionId(), $this->getCurrentUserLocationId());
		} else {
			throw Exception("User does not have correct role to use this page");
		}
		$this->set('activeshowrooms', $activeshowrooms);
		
		$formData = $this->request->getData();
		
		
		if ($this->request->is('post')) {
			$this->set('monthfrom', $this->_getSafeValueFromForm($formData, 'monthfrom'));
			$this->set('monthto', $this->_getSafeValueFromForm($formData, 'monthto'));
			$this->set('reporttype', $this->_getSafeValueFromForm($formData, 'reporttype'));
			$this->set('giftpack', $this->_getSafeValueFromForm($formData, 'giftpack'));
			$this->set('showroom', $this->_getSafeValueFromForm($formData, 'showroom'));
			$this->set('delcall', $this->_getSafeValueFromForm($formData, 'delcall'));
			$this->set('sortorder', $this->_getSafeValueFromForm($formData, 'sortorder'));
			$allData = $this->_getData($this->request->getData());
			$this->set('deliveryReport', $allData['deliveryReport']);	
			$this->set('notes', $allData['notes']);	
		} else {
			$this->set('monthfrom', '');
			$this->set('monthto', '');
			$this->set('reporttype', 'delivery');
			$this->set('giftpack', '');
			$this->set('showroom', '');
			$this->set('delcall', '');
			$this->set('sortorder', '');

		}
	}
	
	private function _getData($formData) {
		$deliveryReportTable = TableRegistry::get('DeliveryReport');
		$ordernoteTable = TableRegistry::get('OrderNote');
		$monthfrom = $formData['monthfrom'];
		$monthto = $formData['monthto'];
		$reporttype = $formData['reporttype'];
		$sortorder = $formData['sortorder'];
		if(isset($formData['giftpack'])) {
			$giftpack = "y";
		} else {
			$giftpack = "n";
		}
		if(isset($formData['delcall'])) {
			$delcall = "y";
		} else {
			$delcall = "n";
		}
		$showroom = $formData['showroom'];
		if ($this->_userHasRole("ADMINISTRATOR")) {
			$regionid = 0;
		} else if ($this->_userHasRole("REGIONAL_ADMINISTRATOR")) {
			$regionid = $this->getCurrentUserRegionId();
		} else if ($this->isSavoirOwned()) {
			$regionid = $this->getCurrentUserRegionId(); // rely on the $showroom param to restrict the report to just their showroom
		} else {
			throw Exception("User does not have correct role to use this page");
		}
		$deliveryReport = $deliveryReportTable->getDeliveryReport($reporttype, $giftpack, $showroom, $monthfrom, $monthto, $delcall, $sortorder, $regionid);
		$allData['deliveryReport'] = $deliveryReport;
		$notesData = [];
		foreach ($deliveryReport as $row) {
			$notes = $ordernoteTable->getOrderNotes($row["PURCHASE_No"]);
			$orderNotes = "";
			foreach ($notes as $note) {
				$orderNotes .= ' NOTE: ' . $note['notetext'];
				$orderNotes .= '          ';
			}
			$notesData[$row["PURCHASE_No"]] = $orderNotes;
		}
		
		$allData['notes'] = $notesData;
		
		return $allData;
		
	}
	
	public function export() {
		
		$ordernoteTable = TableRegistry::get('OrderNote');
		
		$allData = $this->_getData($this->request->getData());
		$deliveryReport = $allData['deliveryReport'];
		$data = [];
		
		$reporttype = $this->request->getData()['reporttype'];
		
		foreach ($deliveryReport as $row) {
			$pn=$row["PURCHASE_No"];
			$delconfirmed = ($row["DeliveryDateConfirmed"] == "y") ? "Yes" : "No";
			$notes = $ordernoteTable->getOrderNotes($pn);
			
			$a = [];
			array_push($a, $this->_getSafeValueFromRs($row, 'title'));
			array_push($a, $this->_getSafeValueFromRs($row, 'first'));
			array_push($a, $this->_getSafeValueFromRs($row, 'surname'));
			array_push($a, $this->_getSafeValueFromRs($row, 'tel'));
			array_push($a, $this->_getSafeValueFromRs($row, 'fax'));
			array_push($a, $this->_getSafeValueFromRs($row, 'company'));
			array_push($a, $this->_getSafeValueFromRs($row, 'customerreference'));
			array_push($a, $this->_getSafeValueFromRs($row, 'ORDER_NUMBER'));
			array_push($a, $this->_getFormattedDateFromRs($row, 'ORDER_DATE'));
			array_push($a, $this->_getSafeValueFromRs($row, 'adminheading'));
			array_push($a, $this->_getSafeMoneyValueFromRs($row, 'total'));
			array_push($a, $this->_getSafeMoneyValueFromRs($row, 'paymentstotal'));
			array_push($a, $this->_getSafeMoneyValueFromRs($row, 'balanceoutstanding'));
			
			if ($reporttype == 'delivery') {
				array_push($a, $this->_getFormattedDateFromRs($row, 'bookeddeliverydate'));
			} else {
				array_push($a, $this->_getFormattedDateFromRs($row, 'production_completion_date'));
			}

			array_push($a, $delconfirmed);
			
			if (!empty($row['deliverypostcode']) || !empty($row['deliveryadd1']) || !empty($row['deliverycounty']) || !empty($row['deliverycountry'])) {
				array_push($a, $this->_getSafeValueFromRs($row, 'deliveryadd1'));
				array_push($a, $this->_getSafeValueFromRs($row, 'deliveryadd2'));
				array_push($a, $this->_getSafeValueFromRs($row, 'deliveryadd3'));
				array_push($a, $this->_getSafeValueFromRs($row, 'deliverytown'));
				array_push($a, $this->_getSafeValueFromRs($row, 'deliverycounty'));
				array_push($a, $this->_getSafeValueFromRs($row, 'deliverypostcode'));
				array_push($a, $this->_getSafeValueFromRs($row, 'deliverycountry'));
			} else {
				array_push($a, $this->_getSafeValueFromRs($row, 'street1'));
				array_push($a, $this->_getSafeValueFromRs($row, 'street2'));
				array_push($a, $this->_getSafeValueFromRs($row, 'street3'));
				array_push($a, $this->_getSafeValueFromRs($row, 'town'));
				array_push($a, $this->_getSafeValueFromRs($row, 'county'));
				array_push($a, $this->_getSafeValueFromRs($row, 'postcode'));
				array_push($a, $this->_getSafeValueFromRs($row, 'country'));
			}
			array_push($a, $this->_getSafeValueFromRs($row, 'EMAIL_ADDRESS'));
			array_push($a, $allData['notes'][$pn]);
			
			array_push($data, $a);
		}
		
		$_header = [];
		array_push($_header, 'Customer Title');
		array_push($_header, 'Customer First Name');
		array_push($_header, 'Customer Surname');
		array_push($_header, 'Tel');
		array_push($_header, 'Fax');
		array_push($_header, 'Company');
		array_push($_header, 'Ref');
		array_push($_header, 'Order No');
		array_push($_header, 'Order Date');
		array_push($_header, 'Order Source');
		array_push($_header, 'Order Value');
		array_push($_header, 'Payments Total');
		array_push($_header, 'Balance Outstanding');
		if ($reporttype == 'delivery') {
			array_push($_header, 'Delivery Date');
		} else {
			array_push($_header, 'Production Date');
		}
		array_push($_header, 'Confirmed Delivery');
		array_push($_header, 'Delivery Add1');
		array_push($_header, 'Add2');
		array_push($_header, 'Add3');
		array_push($_header, 'Town');
		array_push($_header, 'County');
		array_push($_header, 'Postcode');
		array_push($_header, 'Country');
		array_push($_header, 'Email');
		array_push($_header, 'Order Notes');
		
    	$this->setResponse($this->getResponse()->withDownload('CustomerReadyNotInvoiced.csv'));
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
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR", "REGIONAL_ADMINISTRATOR"];
	}
    
	protected function _getAllowedRegions(){
        return [["London", "New York"], "OR"];
    }
}

?>
