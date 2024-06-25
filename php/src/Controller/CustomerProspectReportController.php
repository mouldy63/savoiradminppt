<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;
use Cake\Event\EventInterface;

class CustomerProspectReportController extends SecureAppController {
	private $auxiliaryDataModel;
	
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
		$this->auxiliaryDataModel = TableRegistry::get('AuxiliaryData');
	}

	public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
        $builder->addHelpers([
        	'AuxiliaryData'
        ]);
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
	
	public function ny() {
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
		$customerProspects = $allData['customerProspects'];
		$data = [];
		
		foreach ($customerProspects as $row) {
			$sql = "Select order_date from purchase where contact_no=:contact_no order by order_date desc";
			$rs = $this->auxiliaryDataModel->getData($sql, ['contact_no' => $row['CONTACT_NO']]);
			$lastOrderDate = '';
			foreach ($rs as $row1) {
				$lastOrderDate = date("d/m/Y", strtotime(substr($row1['order_date'],0,10)));
				break;
			}
			$a = [$row['alpha_name'],$row['location'],$row['title'],$row['first'],$row['surname'],$row['company'],$row['street1'],$row['street2'],$row['street3'],$row['town'],$row['county'],$row['postcode'],$row['country'],$row['tel'],$row['EMAIL_ADDRESS'],$row['STATUS'],$row['VISIT_DATE'],$row['source'],$row['CHANNEL'],$lastOrderDate,$row['acceptemail'],$row['acceptpost'],date("d/m/Y", strtotime(substr($row['FIRST_CONTACT_DATE'],0,10)))];
			array_push($data, $a);
		}
		$header = ['Original Alpha Name', 'Owning Showroom', 'Title', 'First Name', 'Surname', 'Company', 'Address 1', 'Address 2', 'Address 3', 'Town', 'County', 'Postcode', 'Country', 'Tel', 'Email', 'Status', 'Visit Date', 'Source', 'Channel', 'Last Order Date', 'Accept Email', 'Accept Post', 'First Contact Date'];
		
		
    	$this->setResponse($this->getResponse()->withDownload('CustomerProspectsReport.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $header
    	]);
	}
	
	private function _getData($formData) {
		$purchase = TableRegistry::get('ContactList');
		$monthfrom = $formData['monthfrom'];
		$monthto = $formData['monthto'];
		$ny="";
		if (isset($formData['ny'])) {
			$ny = $formData['ny'];
		}
		$year = $formData['year'];
		$month = $formData['month'];
		$status = $formData['status'];
		$customerProspects = $purchase->getContactReport($this->SavoirSecurity->isSuperuser(), $this->getCurrentUserRegionId(), $this->getCurrentUserSite(), $this->getCurrentUserLocationId(), $monthfrom, $monthto, $month, $year, $status, $ny );
		$allData = [];
		$allData['customerProspects'] = $customerProspects;
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
    	if ($this->request->getParam('action') == 'ny') {
            return ["REGIONAL_ADMINISTRATOR"];
    	}
    	if ($this->getCurrentUsersId() == 209) {
            return ["ADMINISTRATOR"];
    	}
        return [];
    }
}

?>