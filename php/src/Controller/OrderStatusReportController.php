<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;

class OrderStatusReportController extends SecureAppController {
	public function initialize() : void {
		parent::initialize();
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
		$showrooms = TableRegistry::get('Location');
		$orderstatus = TableRegistry::get('QcHistoryLatest');

		if ($this->request->is('post')) {
			$formData = $this->request->getData();
		} else {
			$formData = [];
		}
		$data = $this->_getData($formData);
		$this->set('formDefaults', $formData);

		if ($this->_isSuperuserOnly() || $this->_userHasRole("ADMINISTRATOR")) {
			$activeshowrooms = $showrooms->getActiveShowrooms();
		} else {
			$activeshowrooms = $showrooms->getActiveShowrooms($this->getCurrentUserRegionId());
		}
		$status = $orderstatus->getOrderStatus();
			
		$this->set('allorders', $data['allorders']);
		$this->set('recordcount', $data['recordcount']);
		$this->set('showrooms', $activeshowrooms);
		$this->set('orderstatus', $status);
			
		$this->set('orderstotal', $data['orderstotal']);
		$this->set('orderspayments', $data['orderspayments']);
		$this->set('ordersoutstanding', $data['ordersoutstanding']);
		$this->set('filtercounts', $data['filtercounts']);
		//debug($data['filtercounts']);
	}

	public function export() {
		$allData = $this->_getData($this->request->getData());
		$allOrders = $allData['allorders'];
		//debug($allOrders);
		$data = [];
		foreach ($allOrders as $row) {
			$datarow = [];
			$datarow['Surname'] = $row['surname'];
			$datarow['Company'] = $row['company'];
			$datarow['Showroom'] = $row['adminheading'];
			if (!empty($row['ORDER_DATE'])) {
				$datarow['Order Date'] = date("d/m/Y", strtotime(substr($row['ORDER_DATE'],0,10)));
			} else {
				$datarow['Order Date'] = '';
			}
			$datarow['Order'] = $row['order_number'];
			$datarow['Order Total'] = $row['total'];
			$datarow['Payments'] = $row['paymentstotal'];
			$datarow['Order Status'] = $row['QC_status'];
			if (!empty($row['bookeddeliverydate'])) {
				$datarow['Delivery Date'] = date("d/m/Y", strtotime(substr($row['bookeddeliverydate'],0,10)));
			} else {
				$datarow['Delivery Date'] = '';
			}
			if (!empty($row['productiondate'])) {
				$datarow['Production Date'] = date("d/m/Y", strtotime(substr($row['productiondate'],0,10)));
			} else {
				$datarow['Production Date'] = '';
			}
			if (empty($row['exworksdate']) || ($row['exworksdate']=='TBC') || ($row['exworksdate']=='Split' )) {
				$datarow['Ex-Works Date'] = $row['exworksdate'];
			} else {
				$datarow['Ex-Works Date'] = date("d/m/Y", strtotime(substr($row['exworksdate'],0,10)));
			}
			
			array_push($data, $datarow);
		}

		$header = ['Surname', 'Company', 'Showroom', 'Order Date', 'Order', 'Order Total', 'Payments', 'Order Status', 'Delivery Date', 'Production Date', 'Ex-Works Date'];

    	$this->setResponse($this->getResponse()->withDownload('OrderStatusReport.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $header
    	]);	
	}

	private function _getData($formData) {
		$purchase = TableRegistry::get('Purchase');

		$filterParams = [];
		$sortBy = [];
		if (sizeof($formData) > 0) {

			// a simple select
			if (isset($formData['paid'])) {
				if ($formData['paid'] == 'ob') {
					array_push($filterParams, ['outstanding', '>', '0']);
				} else if ($formData['paid'] == 'fp') {
					array_push($filterParams, ['outstanding', '=', '0']);
				}
			}
				
			// a multi select
			if (isset($formData['qcstatus'])) {
				array_push($filterParams, ['QC_StatusID', '=', $formData['qcstatus']]);
			}
				
			if (isset($formData['ordersource'])) {
				array_push($filterParams, ['idlocation', '=', $formData['ordersource']]);
			}

			if (isset($formData['deliverybooked'])) {
				if ($formData['deliverybooked'] == 'yes') {
					array_push($filterParams, ['bookeddeliverydate', 'is not', 'null']);
				} else if ($formData['deliverybooked'] == 'no') {
					array_push($filterParams, ['bookeddeliverydate', 'is', 'null']);
				}
			}
				
			// exworks
			if (isset($formData['exworks'])) {
				if ($formData['exworks'] == 'y') {
					array_push($filterParams, ['exworksdate', '>', 'DATE_ADD(CURDATE(), INTERVAL -28 DAY)']);
				}
			}
			if (!empty($formData['Edatefrom'])) {
				array_push($filterParams, ['exworksdate', '>=', $this->_toMysqlDate($formData['Edatefrom'])]);
			}
			if (!empty($formData['Edateto'])) {
				array_push($filterParams, ['exworksdate', '<=', $this->_toMysqlDate($formData['Edateto'])]);
			}
				
			// prod date
			if (isset($formData['production'])) {
				if ($formData['production'] == 'y') {
					array_push($filterParams, ['productiondate', '>', 'DATE_ADD(CURDATE(), INTERVAL -28 DAY)']);
				}
			}
			if (!empty($formData['Pdatefrom'])) {
				array_push($filterParams, ['productiondate', '>=', $this->_toMysqlDate($formData['Pdatefrom'])]);
			}
			if (!empty($formData['Pdateto'])) {
				array_push($filterParams, ['productiondate', '<=', $this->_toMysqlDate($formData['Pdateto'])]);
			}
				
			if (isset($formData['currency'])) {
				array_push($filterParams, ['ordercurrency', '=', $formData['currency']]);
			}
				
			if (!empty($formData['sortorder'])) {
				$sortBy = explode("|", $formData['sortorder']);
			}
		}

		$currentOrders = $purchase->getCurrentOrders($filterParams, $sortBy);
			
		$orderstotal=0;
		$orderspayments=0;
		$ordersoutstanding=0;
		$filterCounts['paid']['fp'] = 0;
		$filterCounts['paid']['ob'] = 0;
		$filterCounts['deliverybooked']['yes'] = 0;
		$filterCounts['deliverybooked']['no'] = 0;
		foreach ($currentOrders as $row) {
			$orderstotal=$orderstotal + $row['total'];
			$orderspayments=$orderspayments + $row['paymentstotal'];
			
			if ($row['Outstanding'] == 0) {
				$filterCounts['paid']['fp'] += 1;
			} else if ($row['Outstanding'] > 0) {
				$filterCounts['paid']['ob'] += 1;
			}
			
			if (!isset($filterCounts['QC_StatusID'][$row['QC_StatusID']])) {
				$filterCounts['QC_StatusID'][$row['QC_StatusID']] = 1;
			} else {
				$filterCounts['QC_StatusID'][$row['QC_StatusID']] += 1;
			}

			if (!isset($filterCounts['idlocation'][$row['idlocation']])) {
				$filterCounts['idlocation'][$row['idlocation']] = 1;
			} else {
				$filterCounts['idlocation'][$row['idlocation']] += 1;
			}

			if (!empty($row['bookeddeliverydate'])) {
				$filterCounts['deliverybooked']['yes'] += 1;
			} else {
				$filterCounts['deliverybooked']['no'] += 1;
			}

			if (!isset($filterCounts['currency'][$row['ordercurrency']])) {
				$filterCounts['currency'][$row['ordercurrency']] = 1;
			} else {
				$filterCounts['currency'][$row['ordercurrency']] += 1;
			}
		}
		$ordersoutstanding = $orderstotal - $orderspayments;

		$data = [
    		"allorders" => $currentOrders,
    		"recordcount" => count($currentOrders),
    		"orderstotal" => $orderstotal,
			"orderspayments" => $orderspayments,
			"ordersoutstanding" => $ordersoutstanding,
			"filtercounts" => $filterCounts
		];

		return $data;
	}

	private function _toMysqlDate($htmlDate) {
		// takes date string formatted dd/mm/yyyy - returns date string formatted yyyy-mm-dd
		$date = date_parse_from_format("d/m/Y", $htmlDate);
		//debug($date);
		$mySqlDate = $date['year'] . '-' . sprintf('%02d', $date['month']) . '-' . sprintf('%02d', $date['day']);
		//debug($mySqlDate);
		return $mySqlDate;
	}

	protected function _getAllowedRoles() {
		return array("ADMINISTRATOR","REGIONAL_ADMINISTRATOR");
	}
}

?>