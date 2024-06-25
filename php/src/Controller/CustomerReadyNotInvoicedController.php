<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;
use Cake\Event\EventInterface;

class CustomerReadyNotInvoicedController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
    	$builder->addHelpers([
        	'AuxiliaryData', 'MyForm'
        ]);
    }

	public function index() {
		$this->viewBuilder()->setLayout('savoirdatatablescsv');

		$statusTable = TableRegistry::get('purchase');
				
		$formData = $this->request->getData();
		
		if ($this->request->is('post')) {
			$allData = $this->_getData($formData);
			$customerNotInvoiced = $allData['customerNotInvoiced'];
			if (!empty($customerNotInvoiced)) {
				$this->set('customerNotInvoiced', $customerNotInvoiced);
			}
		}
		
		$this->set('month', $this->_getSafeValueFromForm($formData, 'month'));
		$this->set('year', $this->_getSafeValueFromForm($formData, 'year'));
		
	}
	
		public function export() {
		
		$allData = $this->_getData($this->request->getData());
		$customerNotInvoiced = $allData['customerNotInvoiced'];
		$data = [];
		
		
		foreach ($customerNotInvoiced as $row) {
		$prodcompdate='';
		if ($row['production_completion_date'] != '') {
		   $prodcompdate=date("d/m/Y", strtotime(substr($row['production_completion_date'],0,10)));
		} 
		$deldate='';
		if ($row['deldate'] != '') {
		   $deldate=date("d/m/Y", strtotime(substr($row['deldate'],0,10)));
		}
		
			$a = [$row['surname']. " " .$row['first']. " " .$row['title'], $row['company'], $row['ORDER_NUMBER'], $row['adminheading'], $prodcompdate, $deldate];
			array_push($data, $a);
		}
		
		$header = ['Customer Name', 'Company Name', 'Order No.', 'Showroom', 'Production Completion Date', 'Delivery Date'];
		
    	$this->setResponse($this->getResponse()->withDownload('CustomerReadyNotInvoiced.csv'));
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
		$year = $formData['year'];
		$month = $formData['month'];
		$month=date('m', strtotime($month));
		$a_date = $year ."-" . $month ."-1";
		$deldate=date("Y-m-t", strtotime($a_date));
		$tmpdate = $year ."-" . $month ."-1";
		$bcwwarehouse = date('Y-m-d', strtotime("+1 months", strtotime($tmpdate)));
		$customerNotInvoiced = $purchase->getcustomerNotInvoiced($month, $year, $deldate, $bcwwarehouse);
		$allData = [];
		$allData['customerNotInvoiced'] = $customerNotInvoiced;
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
		protected function _getAllowedRegions(){
        return [["London"]];
    }

}

?>
