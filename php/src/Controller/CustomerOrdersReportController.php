<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;
use Cake\Event\EventInterface;

class CustomerOrdersReportController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');

		$statusTable = TableRegistry::get('Status');
		
		$statuslist = $statusTable->getStatusList();
		
		$this->set('statuslist', $statuslist);
		
		$formData = $this->request->getData();
		
		$this->set('monthfrom', $this->_getSafeValueFromForm($formData, 'monthfrom'));
		$this->set('monthto', $this->_getSafeValueFromForm($formData, 'monthto'));
		$this->set('month', $this->_getSafeValueFromForm($formData, 'month'));
		$this->set('year', $this->_getSafeValueFromForm($formData, 'year'));
		$this->set('status', $this->_getSafeValueFromForm($formData, 'status'));
		
	}
	
	public function export() {
		
		$allData = $this->_getData($this->request->getData());
		$customerOrders = $allData['customerOrders'];
		$data = [];
		
		foreach ($customerOrders as $row) {
			$a = [$row['alpha_name'],$row['location'],$row['title'],$row['first'],$row['surname'],$row['company'],$row['street1'],$row['street2'],$row['street3'],$row['town'],$row['county'],$row['postcode'],$row['country'],$row['tel'],$row['EMAIL_ADDRESS'],$row['CHANNEL'],$row['VISIT_DATE'],$row['lastorderdate'],$row['acceptemail'],$row['acceptpost'],$row['STATUS'],$row['FIRST_CONTACT_DATE']];
			array_push($data, $a);
		}
		$header = ['Original Alpha Name', 'Owning Showroom', 'Title', 'First Name', 'Surname', 'Company', 'Address 1', 'Address 2', 'Address 3', 'Town', 'County', 'Postcode', 'Country', 'Tel', 'Email', 'Channel', 'Visit Date', 'Last Order Date', 'Accept Email', 'Accept Post', 'Status', 'First Contact Date'];

    	$this->setResponse($this->getResponse()->withDownload('CustomerOrdersReport.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $header
    	]);
	}
	
	private function _getData($formData) {
		$purchase = TableRegistry::get('purchase');
		$monthfrom = $formData['monthfrom'];
		$monthto = $formData['monthto'];
		$year = $formData['year'];
		$month = $formData['month'];
		$status = $formData['status'];
		$customerOrders = $purchase->getCustomerOrders($this->SavoirSecurity->isSuperuser(), $this->getCurrentUserRegionId(), $this->getCurrentUserSite(), $this->getCurrentUserLocationId(), $monthfrom, $monthto, $month, $year, $status );
		$allData = [];
		$allData['customerOrders'] = $customerOrders;
		return $allData;
	}
	
	private function _buildAddress($addrRecord) {
		$address = "";
		if (!empty($addrRecord["Company"])) $address .= $addrRecord["Company"] . ", ";
		if (!empty($addrRecord["street1"])) $address .= $addrRecord["street1"] . ", ";
		if (!empty($addrRecord["street2"])) $address .= $addrRecord["street2"] . ", ";
		if (!empty($addrRecord["street3"])) $address .= $addrRecord["street3"] . ", ";
		if (!empty($addrRecord["town"])) $address .= $addrRecord["town"] . ", ";
		if (!empty($addrRecord["county"])) $address .= $addrRecord["county"] . ", ";
		if (!empty($addrRecord["postcode"])) $address .= $addrRecord["postcode"] . ", ";
		if (!empty($addrRecord["country"])) $address .= $addrRecord["country"];
		return $address;
	}

	private function _getSafeValueFromForm($formData, $name) {
		$value = "";
		if (isset($formData[$name])) {
			$value = $formData[$name];
		}
		return $value;
	}

	protected function _getAllowedRoles() {
		return array("ADMINISTRATOR,SALES");
	}
	protected function _getAllowedRegions(){
        return [["London"]];
	}
}

?>