<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;
use Cake\Event\EventInterface;

class BrochureFollowUpController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');

		$showrooms = TableRegistry::get('Location');
		$activeshowrooms = $showrooms->getActiveShowrooms();
		$this->set('activeshowrooms', $activeshowrooms);
		
		$formData = $this->request->getData();
		
		if ($this->request->is('post')) {
			$allData = $this->_getData($formData);
			//debug($allData);
			$brochurefollowups = $allData['brochurefollowups'];
			$users = $allData['users'];
			$customerOrdersAndValues = $allData['customerOrdersAndValues'];
			$customerAddresses = $allData['customerAddresses'];

			if (!empty($brochurefollowups)) {
				$this->set('brochurefollowups', $brochurefollowups);
			}
			if (!empty($users)) {
				$this->set('users', $users);
			}
			if (!empty($customerOrdersAndValues)) {
				$this->set('customerOrdersAndValues', $customerOrdersAndValues);
			}
			if (!empty($customerAddresses)) {
				$this->set('customerAddresses', $customerAddresses);
			}
			if (!empty($customerAddresses)) {
				$this->set('customerAddresses', $customerAddresses);
			}
		}
		
		$this->set('monthfrom', $this->_getSafeValueFromForm($formData, 'monthfrom'));
		$this->set('monthto', $this->_getSafeValueFromForm($formData, 'monthto'));
		$this->set('month', $this->_getSafeValueFromForm($formData, 'month'));
		$this->set('year', $this->_getSafeValueFromForm($formData, 'year'));
		$this->set('showroom', $this->_getSafeValueFromForm($formData, 'showroom'));
		$this->set('user', $this->_getSafeValueFromForm($formData, 'user'));
		$this->set('sortorder', $this->_getSafeValueFromForm($formData, 'sortorder'));
		$this->set('commstatus', $this->_getSafeValueFromForm($formData, 'commstatus'));
		
	}
	
	public function export() {
		
		$allData = $this->_getData($this->request->getData());
		$brochurefollowups = $allData['brochurefollowups'];
		$customerOrdersAndValues = $allData['customerOrdersAndValues'];
		$customerAddresses = $allData['customerAddresses'];
		$data = [];
		
		foreach ($brochurefollowups as $row) {
			$date = date("d/m/Y", strtotime(substr($row['Date'],0,10)));
			$person = $row['person'] . ', ' . $this->_buildAddress($customerAddresses[$row['Communication']]);
			$followUpDate = "";
			if ($row['commstatus']=="To Do") {
				$followUpDate = date("d/m/Y", strtotime(substr($row['Next'],0,10)));
			}
			if (isset($row['Response'])) {
				$responseNotes = str_replace('<br />', ' ', $row['Response']);
			} else {
				$responseNotes = '';
			}
			$orderDetails = "";
			foreach ($customerOrdersAndValues[$row['Communication']] as $custOrdValRow) {
				
				$orderDetails .= date("d/m/Y", strtotime(substr($custOrdValRow["order_date"],0,10))) . " " . $custOrdValRow["order_number"] . " " . $custOrdValRow["total"] . "\n";
			}
			$a = [$date, $person, $followUpDate, $responseNotes, $row['commstatus'], $row['location'], $orderDetails];
			array_push($data, $a);
		}
		
		$header = ['Date of Brochure Request', 'Contact Name (Customer Address)', 'Follow Up Date', 'Response Notes', 'Status', 'Showroom', 'Order Date/Number & Value'];

    	$this->setResponse($this->getResponse()->withDownload('BrochureFollowUp.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $header
    	]);
	}
	
	private function _getData($formData) {
		$communication = TableRegistry::get('Communication');
		
		$monthfrom = $formData['monthfrom'];
		$monthto = $formData['monthto'];
		$year = $formData['year'];
		$month = $formData['month'];
		$showroom = $formData['showroom'];
		$sortorder = $formData['sortorder'];
		$user = $this->_getSafeValueFromForm($formData, 'user');
		$commstatus = $this->_getSafeValueFromForm($formData, 'commstatus');
		$brochurefollowups = $communication->getBrochureFollowUps($monthfrom, $monthto, $month, $year, $showroom, $user, $commstatus, $sortorder );
		$customerOrdersAndValues = [];
		$customerAddresses = [];
		foreach ($brochurefollowups as $followup) {
			$ordersAndValues = $communication->getCustomerOrdersAndValues($followup['CONTACT_NO'], $followup['Date']);
			$customerOrdersAndValues[$followup['Communication']] = $ordersAndValues;
			$addr = $communication->getCustomerAddress($followup['CODE']);
			$customerAddresses[$followup['Communication']] = $addr[0];
		}
		
		$usersTable = TableRegistry::get('SavoirUser');
		$users = $usersTable->find()->where(['Retired' => 'n'])->order(['username' => 'ASC'])->toArray();
		
		$allData = [];
		$allData['brochurefollowups'] = $brochurefollowups;
		$allData['users'] = $users;
		$allData['customerOrdersAndValues'] = $customerOrdersAndValues;
		$allData['customerAddresses'] = $customerAddresses;
		return $allData;
	}
	
	private function _buildAddress($addrRecord) {
		$address = "";
		if (!empty($addrRecord["company"])) $address .= $addrRecord["company"] . ", ";
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
		return array("ADMINISTRATOR");
	}
}

?>