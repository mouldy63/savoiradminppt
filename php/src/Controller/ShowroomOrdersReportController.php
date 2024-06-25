<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class ShowroomOrdersReportController extends SecureAppController {

	private $locationTable;
	private $purchaseTable;
	private $showroomOrdersReportTable;
	private $filters;

	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
		$this->locationTable = TableRegistry::get('Location');
		$this->purchaseTable = TableRegistry::get('Purchase');
		$this->showroomOrdersReportTable = TableRegistry::get('ShowroomOrdersReport');

		$this->filters = [];
		$this->filters['totals'] = '';
		$this->filters['mattress-no1'] = "mattressrequired='y' and savoirmodel='No. 1'";
		$this->filters['mattress-no2'] = "mattressrequired='y' and savoirmodel='No. 2'";
		$this->filters['mattress-no3'] = "mattressrequired='y' and savoirmodel='No. 3'";
		$this->filters['mattress-no4'] = "mattressrequired='y' and savoirmodel='No. 4'";
		$this->filters['mattress-no5'] = "mattressrequired='y' and savoirmodel='No. 5'";
		$this->filters['mattress-fm'] = "mattressrequired='y' and savoirmodel='French Mattress'";
		$this->filters['mattress-state'] = "mattressrequired='y' and savoirmodel='State'";
		$this->filters['mattress-other'] = "mattressrequired='y' and savoirmodel!='No. 1' and savoirmodel!='No. 2' and savoirmodel!='No. 3' and savoirmodel!='No. 4' and savoirmodel!='No. 5' and savoirmodel!='French Mattress' and savoirmodel!='State'";
		$this->filters['base-no1'] = "baserequired='y' and basesavoirmodel='No. 1'";
		$this->filters['base-no2'] = "baserequired='y' and basesavoirmodel='No. 2'";
		$this->filters['base-no3'] = "baserequired='y' and basesavoirmodel='No. 3'";
		$this->filters['base-no4'] = "baserequired='y' and basesavoirmodel='No. 4'";
		$this->filters['base-no5'] = "baserequired='y' and basesavoirmodel='No. 5'";
		$this->filters['base-pegboard'] = "baserequired='y' and basesavoirmodel='Pegboard'";
		$this->filters['base-platformbase'] = "baserequired='y' and basesavoirmodel='Platform Base'";
		$this->filters['base-savoirslim'] = "baserequired='y' and basesavoirmodel='Savoir Slim'";
		$this->filters['base-state'] = "baserequired='y' and basesavoirmodel='State'";
		$this->filters['base-other'] = "baserequired='y' and basesavoirmodel!='No. 1' and basesavoirmodel!='No. 2' and basesavoirmodel!='No. 3' and basesavoirmodel!='No. 4' and basesavoirmodel!='No. 5' and basesavoirmodel!='Pegboard' and basesavoirmodel!='Platform Base' and basesavoirmodel!='Savoir Slim' and basesavoirmodel!='State'";
		$this->filters['topper-linked-hca'] = "(mattressrequired='y' or baserequired='y') and topperrequired='y' and toppertype='HCa Topper'";
		$this->filters['topper-linked-hw'] = "(mattressrequired='y' or baserequired='y') and topperrequired='y' and toppertype='HW Topper'";
		$this->filters['topper-linked-cw'] = "(mattressrequired='y' or baserequired='y') and topperrequired='y' and toppertype='CW Topper'";
		$this->filters['topper-linked-other'] = "(mattressrequired='y' or baserequired='y') and topperrequired='y' and toppertype!='HCa Topper' and toppertype!='HW Topper' and toppertype!='CW Topper'";
		$this->filters['topper-hca'] = "mattressrequired='n' and baserequired='n' and topperrequired='y' and toppertype='HCa Topper'";
		$this->filters['topper-hw'] = "mattressrequired='n' and baserequired='n' and topperrequired='y' and toppertype='HW Topper'";
		$this->filters['topper-cw'] = "mattressrequired='n' and baserequired='n' and topperrequired='y' and toppertype='CW Topper'";
		$this->filters['legs'] = "legsrequired='y'";
		$this->filters['headboard'] = "headboardrequired='y'";
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');

		$activeshowrooms = $this->locationTable->getActiveShowrooms();
		$ordersources = $this->purchaseTable->getOrderSource();
		$this->set('activeshowrooms', $activeshowrooms);
		$this->set('ordersources', $ordersources);

		if ($this->request->is('post')) {
			$formData = $this->request->getData();
		} else {
			$formData = [];
		}

		if ($this->request->is('post')) {
			$this->set('monthfrom', $this->_getSafeValueFromForm($formData, 'monthfrom'));
			$this->set('monthto', $this->_getSafeValueFromForm($formData, 'monthto'));

			$selectedShowrooms = $this->_getSafeValueFromForm($formData, 'showroom');
			if (empty($selectedShowrooms)) $selectedShowrooms = [];
			$this->set('showroom', $selectedShowrooms);
			
			$selectedSources = $this->_getSafeValueFromForm($formData, 'ordersource');
			if (empty($selectedSources)) $selectedSources = [];
			$this->set('ordersource', $selectedSources);
			//debug($this->_getSafeValueFromForm($formData, 'ordersource'));
			//die;
			$cancelledorders = $this->_getSafeValueFromForm($formData, 'cancelled');
			$onhold = $this->_getSafeValueFromForm($formData, 'onhold');
			$quotes = $this->_getSafeValueFromForm($formData, 'quotes');
			$this->set('cancelledorders', $cancelledorders);
			$this->set('onhold', $onhold);
			$this->set('quotes', $quotes);

		} else {
			$this->set('monthfrom', '');
			$this->set('monthto', '');
			$this->set('showroom', []);
			$this->set('ordersource', []);
			$this->set('cancelledorders', '');
			$this->set('onhold', '');
			$this->set('quotes', '');
		}

		if ($this->request->is('post')) {
			$allData = $this->_getData($formData);
			$this->set('data', $allData);
		}
	}

	public function orderReport() {
		$this->autoRender = false;
		$idlocations = $this->request->getQuery('idlocation');
		$key = $this->request->getQuery('key');
		$monthfrom = $this->request->getQuery('monthfrom');
		$monthto = $this->request->getQuery('monthto');
		$ordersource = $this->request->getQuery('ordersource');
		$cancelledorders = $this->request->getQuery('cancelled');
		$onhold = $this->request->getQuery('onhold');
		$quotes = $this->request->getQuery('quotes');
		$filter = $this->filters[$key];
		$nos = $this->showroomOrdersReportTable->getShowroomOrdersReportPurchaseNos($ordersource, $idlocations, $monthfrom, $monthto, $cancelledorders, $onhold, $quotes, $filter);
		$this->redirect(['controller' => 'OrderReport', '?' => ['ids' => implode(',', $nos)]]);
	}

	private function _getData($formData) {
		$monthfrom = $formData['monthfrom'];
		$monthto = $formData['monthto'];
		$cancelledorders='';
		$onhold='';
		$quotes='';
		$cancelledorders = $this->_getSafeValueFromForm($formData, 'cancelled');
		$onhold = $this->_getSafeValueFromForm($formData, 'onhold');
		$quotes = $this->_getSafeValueFromForm($formData, 'quotes');
		$ordersource = $this->_getSafeValueFromForm($formData, 'ordersource');
		$strOrdersource = '';
		if ($ordersource != '' && count($ordersource) > 0 && !in_array('n', $ordersource)) {
		    $strOrdersource = "'" . implode("','", $ordersource) . "'";
		}
		//debug($strOrdersource);
		//die;
		
		$showroomIds = $this->_getSafeValueFromForm($formData, 'showroom');
		$strShowroomIds = '';
		if ($showroomIds != '' && count($showroomIds) > 0 && !in_array('n', $showroomIds)) {
		    $strShowroomIds = implode(",", $showroomIds);
		}
		$showroomList = $this->locationTable->getActiveShowrooms("", $strShowroomIds);
		$allData['showroom_list'] = $showroomList;
		$locationIds = [];
		foreach($showroomList as $showroom) {
			array_push($locationIds, $showroom['idlocation']);
		}

		$salesData = [];

		// totals
		$rowparams = [];
		array_push($rowparams, ['title' => 'Total', 'filter' => $this->filters['totals'], 'key' => 'totals']);
		$section = $this->buildSection('Showroom Total Orders', $rowparams, $locationIds, $monthfrom, $monthto, $cancelledorders, $onhold, $quotes, $strOrdersource);
		array_push($salesData, $section);

		// mattresses
		$rowparams = [];
		array_push($rowparams, ['title' => 'No. 1', 'filter' => $this->filters['mattress-no1'], 'key' => 'mattress-no1']);
		array_push($rowparams, ['title' => 'No. 2', 'filter' => $this->filters['mattress-no2'], 'key' => 'mattress-no2']);
		array_push($rowparams, ['title' => 'No. 3', 'filter' => $this->filters['mattress-no3'], 'key' => 'mattress-no3']);
		array_push($rowparams, ['title' => 'No. 4', 'filter' => $this->filters['mattress-no4'], 'key' => 'mattress-no4']);
		array_push($rowparams, ['title' => 'No. 5', 'filter' => $this->filters['mattress-no5'], 'key' => 'mattress-no5']);
		array_push($rowparams, ['title' => 'French Mattress', 'filter' => $this->filters['mattress-fm'], 'key' => 'mattress-fm']);
		array_push($rowparams, ['title' => 'State', 'filter' => $this->filters['mattress-state'], 'key' => 'mattress-state']);
		array_push($rowparams, ['title' => 'Other', 'filter' => $this->filters['mattress-other'], 'key' => 'mattress-other']);
		$section = $this->buildSection('Mattresses', $rowparams, $locationIds, $monthfrom, $monthto, $cancelledorders, $onhold, $quotes, $strOrdersource);
		array_push($salesData, $section);

		// bases
		$rowparams = [];
		array_push($rowparams, ['title' => 'No. 1', 'filter' => $this->filters['base-no1'], 'key' => 'base-no1']);
		array_push($rowparams, ['title' => 'No. 2', 'filter' => $this->filters['base-no2'], 'key' => 'base-no2']);
		array_push($rowparams, ['title' => 'No. 3', 'filter' => $this->filters['base-no3'], 'key' => 'base-no3']);
		array_push($rowparams, ['title' => 'No. 4', 'filter' => $this->filters['base-no4'], 'key' => 'base-no4']);
		array_push($rowparams, ['title' => 'No. 5', 'filter' => $this->filters['base-no5'], 'key' => 'base-no5']);
		array_push($rowparams, ['title' => 'Pegboard', 'filter' => $this->filters['base-pegboard'], 'key' => 'base-pegboard']);
		array_push($rowparams, ['title' => 'Platform', 'filter' => $this->filters['base-platformbase'], 'key' => 'base-platformbase']);
		array_push($rowparams, ['title' => 'Savoir Slim', 'filter' => $this->filters['base-savoirslim'], 'key' => 'base-savoirslim']);
		array_push($rowparams, ['title' => 'State', 'filter' => $this->filters['base-state'], 'key' => 'base-state']);
		array_push($rowparams, ['title' => 'Other', 'filter' => $this->filters['base-other'], 'key' => 'base-other']);
		$section = $this->buildSection('Box Springs', $rowparams, $locationIds, $monthfrom, $monthto, $cancelledorders, $onhold, $quotes, $strOrdersource);
		array_push($salesData, $section);

		// toppers linked with mattress or base
		$rowparams = [];
		array_push($rowparams, ['title' => 'HCA', 'filter' => $this->filters['topper-linked-hca'], 'key' => 'topper-linked-hca']);
		array_push($rowparams, ['title' => 'HW', 'filter' => $this->filters['topper-linked-hw'], 'key' => 'topper-linked-hw']);
		array_push($rowparams, ['title' => 'CW', 'filter' => $this->filters['topper-linked-cw'], 'key' => 'topper-linked-cw']);
		array_push($rowparams, ['title' => 'Other', 'filter' => $this->filters['topper-linked-other'], 'key' => 'topper-linked-other']);
		$section = $this->buildSection('Toppers Linked with mattress or base', $rowparams, $locationIds, $monthfrom, $monthto, $cancelledorders, $onhold, $quotes, $strOrdersource);
		array_push($salesData, $section);

		// toppers only
		$rowparams = [];
		array_push($rowparams, ['title' => 'HCA', 'filter' => $this->filters['topper-hca'], 'key' => 'topper-hca']);
		array_push($rowparams, ['title' => 'HW', 'filter' => $this->filters['topper-hw'], 'key' => 'topper-hw']);
		array_push($rowparams, ['title' => 'CW', 'filter' => $this->filters['topper-cw'], 'key' => 'topper-cw']);
		$section = $this->buildSection('Toppers only (no base or mattress)', $rowparams, $locationIds, $monthfrom, $monthto, $cancelledorders, $onhold, $quotes, $strOrdersource);
		array_push($salesData, $section);

		// legs
		$rowparams = [];
		array_push($rowparams, ['title' => 'Legs', 'filter' => $this->filters['legs'], 'key' => 'legs']);
		$section = $this->buildSection('Legs', $rowparams, $locationIds, $monthfrom, $monthto, $cancelledorders, $onhold, $quotes, $strOrdersource);
		array_push($salesData, $section);

		// headboards
		$rowparams = [];
		array_push($rowparams, ['title' => 'Headboards', 'filter' => $this->filters['headboard'], 'key' => 'headboard']);
		$section = $this->buildSection('Headboards', $rowparams, $locationIds, $monthfrom, $monthto, $cancelledorders, $onhold, $quotes, $strOrdersource);
		array_push($salesData, $section);

		// end
		$allData['salesdata'] = $salesData;
		return $allData;
	}

	private function buildSection($title, $rowparams, $locationIds, $monthfrom, $monthto, $cancelledorders, $onhold, $quotes, $strOrdersource) {
		$section = [];
		$section['title'] = $title;
		$sectionData = [];

		foreach($rowparams as $rowparam) {
			$row = [];
			$row['key'] = $rowparam['key'];
			$row['title'] = $rowparam['title'];
			$row['data'] = $this->showroomOrdersReportTable->getShowroomOrdersReport($strOrdersource, $locationIds, $monthfrom, $monthto, $cancelledorders, $onhold, $quotes, $rowparam['filter']);
			array_push($sectionData, $row);
		}

		$section['data'] = $sectionData;

		return $section;
	}

	public function export() {
		$allData = $this->_getData($this->request->getData());

		$_header = [];
		array_push($_header, '');
		foreach ($allData['showroom_list'] as $showroom) {
			array_push($_header, $showroom['adminheading']);
		}
		array_push($_header, 'TOTAL');

		$data = [];

		$salesData = $allData['salesdata'];
		foreach ($salesData as $section) {
			$sectiondata = $section['data'];
			if (sizeof($sectiondata) > 1) {
				array_push($data, [$section['title']]);
				foreach ($sectiondata as $item) {
					$a = [];
					array_push($a, $item['title']);
					foreach ($allData['showroom_list'] as $showroom) {
						if (isset($item['data'][$showroom['idlocation']])) {
							array_push($a, $item['data'][$showroom['idlocation']]);
						} else {
							array_push($a, '0');
						}
					}
					if ($item['data'][0] > 0) {
						array_push($a, $item['data'][0]);
					} else {
						array_push($a, '0');
					}
					array_push($data, $a);
				}
				
			} else {
				$a = [];
				foreach ($sectiondata as $item) {
					array_push($a, $section['title']);
					foreach ($allData['showroom_list'] as $showroom) {
						if (isset($item['data'][$showroom['idlocation']])) {
							array_push($a, $item['data'][$showroom['idlocation']]);
						} else {
							array_push($a, '0');
						}
					}
					if ($item['data'][0] > 0) {
						array_push($a, $item['data'][0]);
					} else {
						array_push($a, '0');
					}
				}
				array_push($data, $a);
			}
		}

    	$this->setResponse($this->getResponse()->withDownload('showroomreport.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $_header
    	]);		
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
