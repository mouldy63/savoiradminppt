<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class CustomerReadyNotInvoicedController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');

		$statusTable = TableRegistry::get('purchase');
				
		$formData = $this->request->getData();
		
		$this->set('month', $this->_getSafeValueFromForm($formData, 'month'));
		$this->set('year', $this->_getSafeValueFromForm($formData, 'year'));
		
	}
	
	public function export() {
		
		
	}
	
	private function _getData($formData) {
		$purchase = TableRegistry::get('purchase');
		$year = $formData['year'];
		$month = $formData['month'];
		$customerNotInvoiced = $purchase->customerNotInvoiced($this->SavoirSecurity->isSuperuser(), $this->getCurrentUserRegionId(), $this->getCurrentUserSite(), $this->getCurrentUserLocationId(), $monthfrom, $monthto, $month, $year, $status );
		$allData = [];
		$allData['customerReadyNoInv'] = $customerNotInvoiced;
		return $allData;
	}
	
	private function _getSafeValueFromForm($formData, $name) {
		$value = "";
		if (isset($formData[$name])) {
			$value = $formData[$name];
		}
		return $value;
	}

	protected function _getAllowedRoles() {
		return array("ADMINISTRATOR");
	}
}

?>