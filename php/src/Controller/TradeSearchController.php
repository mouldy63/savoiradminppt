<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class TradeSearchController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');

		$this->locationTable = TableRegistry::get('Location');
				
		$formData = $this->request->getData();
		
		$activeshowrooms = $this->locationTable->getActiveShowrooms();
		$this->set('activeshowrooms', $activeshowrooms);
		
		if ($this->request->is('post')) {
			$formData = $this->request->getData();
		} else {
			$formData = [];
		}
		
		if ($this->request->is('post')) {
			$this->set('datefrom', $this->_getSafeValueFromForm($formData, 'datefrom'));
			$this->set('dateto', $this->_getSafeValueFromForm($formData, 'dateto'));
			$this->set('showroom', $this->_getSafeValueFromForm($formData, 'showroom'));
			$this->set('sortorder', $this->_getSafeValueFromForm($formData, 'sortorder'));
		} else {
			$this->set('datefrom', '');
			$this->set('dateto', '');
			$this->set('showroom', '');
			$this->set('sortorder', '');
		}
		
		if ($this->request->is('post')) {
			$tradeSearch = $this->_getData($formData);
			$this->set('tradeSearch', $tradeSearch);
			$this->set('sortorder', '');
			//debug($tradeSearch);
		} 
	}
	
	public function export() {
		$tradeSearch = $this->_getData($this->request->getData());
		$data = [];
		
		foreach ($tradeSearch as $row) {
			$total = UtilityComponent::formatMoneyWithSymbol($row['total'], $row['ordercurrency']);
			$paymentstotal = UtilityComponent::formatMoneyWithSymbol($row['paymentstotal'], $row['ordercurrency']);
			$balanceoutstanding = UtilityComponent::formatMoneyWithSymbol($row['balanceoutstanding'], $row['ordercurrency']);
			$a = [$row['ORDER_DATE'], $row['surname']. " " .$row['first']. " " .$row['title'], $row['company'], $row['ORDER_NUMBER'], $row['adminheading'], $total, $paymentstotal, $balanceoutstanding];
			array_push($data, $a);
		}
		
		$header = ['Order Date', 'Customer Name', 'Company Name', 'Order No.', 'Order Source', 'Order Value', 'Total Payments to Date', 'Total Outstanding'];

    	$this->setResponse($this->getResponse()->withDownload('TradeSearch.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $header
    	]);		
	}

	
	private function _getData($formData) {
		$tradeSearchTable = TableRegistry::get('tradeSearch');
		$datefrom = $formData['datefrom'];
		$dateto = $formData['dateto'];
		if (isset($formData['sortorder'])) {
		$sortorder = $formData['sortorder'];
		} else {
		$sortorder = '';
		}
		$tradeSearch = $tradeSearchTable->getTradeSearchReport($this->SavoirSecurity->isSuperuser(), $this->getCurrentUserLocationId(), $datefrom, $dateto, $sortorder);
		return $tradeSearch;
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
		protected function _getAllowedRegions(){
        return [["London"]];
    }

}

?>