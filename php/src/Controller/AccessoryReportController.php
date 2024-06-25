<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\Event\EventInterface;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class AccessoryReportController extends SecureAppController
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
		
		$this->set('datefrom', $this->_getSafeValueFromForm($formData, '$datefrom'));
		$this->set('dateto', $this->_getSafeValueFromForm($formData, '$dateto'));
		$this->set('showroom', $this->_getSafeValueFromForm($formData, 'showroom'));
		
	}
	
	public function export() {
        $accessorytbl = TableRegistry::get('Accessory');
        $formData = $this->request->getData();
        $datefrom = $formData['datefrom'];
		$dateto = $formData['dateto'];
        $showroom = $formData['showroom'];
        $accpurchased=
        $accpurchased=$accessorytbl->getAccessoriesReport($datefrom, $dateto, $showroom);
        //debug($accpurchased);
        //die;
		$data = [];
		
		foreach ($accpurchased as $row) {
			$customername='';
			if ($row['title'] != ''){
				$customername.=$row['title'].' ';
			}
			if ($row['first'] != ''){
				$customername.=$row['first'].' ';
			}
			if ($row['surname'] != ''){
				$customername.=$row['surname'].' ';
			}
			$bookeddeldate='';
			if ($row['bookeddeliverydate'] != '') {
				$bookeddeldate= date("d/m/Y", strtotime(substr($row['bookeddeliverydate'],0,10)));
			}
			$orderdate='';
			if ($row['ORDER_DATE'] != '') {
				$orderdate= date("d/m/Y", strtotime(substr($row['ORDER_DATE'],0,10)));
			}
			$totexvatdisc='';
			if ($row['istrade']=='y') {
				$totexvatdisc=$row['bedsettotal']+(is_null($row['deliveryprice'])? 0 : $row['deliveryprice']);
			} else {
				$totexvatdisc=($row['bedsettotal']+(is_null($row['deliveryprice'])? 0 : $row['deliveryprice']))/(1+$row['vatrate']/100);
 			}
			$podate='';
			if ($row['PODate'] != '' && $row['PODate'] != '0000-00-00') {
				$podate= date("d/m/Y", strtotime(substr($row['PODate'],0,10)));
			}
			$etadate='';
			if ($row['ETA'] != '' && $row['ETA'] != '0000-00-00') {
				$etadate= date("d/m/Y", strtotime(substr($row['ETA'],0,10)));
			}
			$receiveddate='';
			if ($row['Received'] != '' && $row['Received'] != '0000-00-00') {
				$receiveddate= date("d/m/Y", strtotime(substr($row['Received'],0,10)));
			}
			$checkeddate='';
			if ($row['Checked'] != '' && $row['Checked'] != '0000-00-00') {
				//$checkeddate= date("d/m/Y", strtotime(substr($row['Checked'],0,10)));
				$checkeddate=$row['Checked'];
			}
			$delivereddate='';
			if ($row['Delivered'] != '' && $row['Delivered'] != '0000-00-00') {
				$delivereddate= date("d/m/Y", strtotime(substr($row['Delivered'],0,10)));
			}
			$unitpriceXvat=$row['unitprice'];
			if ($row['unitprice'] != '' && $row['unitprice'] > 0 && $row['istrade'] != 'y') {
				$unitpriceXvat=$row['unitprice']/(1+$row['vatrate']/100);
				$unitpriceXvat=number_format((float)$unitpriceXvat, 2, '.', '');
			}
		
			$a = [$row['company'], $customername, $row['deliveryadd1'], $row['deliveryadd2'], $row['deliveryadd3'], $row['deliverytown'], $row['deliverycounty'], $row['deliverypostcode'], $row['deliverycountry'], $bookeddeldate, $orderdate, $row['ORDER_NUMBER'], $row['ordercurrency'], $row['completedorders'], $totexvatdisc, $row['adminheading'], $row['description'], $row['design'], $row['colour'], $row['size'], $unitpriceXvat, $row['istrade'], $row['qty'], $row['Supplier'], $row['POnumber'], $podate, $etadate, $receiveddate, $checkeddate, $delivereddate, $row['QtyToFollow'], $row['SpecialInstructions']];
			array_push($data, $a);
		}
		
		$header = ['Company', 'Customer Name', 'Delivery Add1', 'Delivery Add2', 'Delivery Add3', 'Delivery Town', 'Delivery County', 'Delivery Postcode', 'Delivery Country', 'Order Delivery Date', 'Order Date', 'Order No', 'Order Currency', 'Order Completed', 'Total Order Value Ex VAT Ex Discount', 'Showroom', 'Accessory Item Description', 'Accessory Design & Detail', 'Accessory Colour', 'Accessory Size', 'Accessory Unit Price (Ex VAT)', 'Is Trade?', 'Accessory Quantity', 'Accessory Supplier', 'Accessory Purchase Order No', 'Accessory Purchase Order Date', 'Accessory ETA Date', 'Accessory Received Date', 'Accessory Checked & Picked Date', 'Accessory Delivered Date', 'Accessory Quantity To Follow', 'Accessory Special Instructions/ Details'];

    	$this->setResponse($this->getResponse()->withDownload('Accessories-Report.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $header
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