<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;

class CurrentOrdersController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		set_time_limit(240);
    }
	
	public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
        $builder->addHelpers([
        	'OrderFuncs',
        	'AuxiliaryData'
        ]);
    }

    public function index() {
		$this->viewBuilder()->setLayout('savoirdatatables');

		$slowMode = $this->request->getQuery('slow') == 'y';
		
		$showrooms = TableRegistry::get('Location');
		if ($this->_userHasRole("ADMINISTRATOR") || $this->isSuperuser()) {
			$activeshowrooms = $showrooms->getActiveShowrooms();
			$showroom='all';
		} else {
			$activeshowrooms = $showrooms->getBuddyShowrooms($this->getCurrentUserLocationId());
			$showroom=$this->getCurrentUserLocationId();
		} 
		if ($this->_userHasRole("ADMINISTRATOR") || $this->isSuperuser() || $this->getCurrentUserRegionId()==1) {
			$showshowrooms='y';
		} else {
			$showshowrooms='n';
		}	
		$this->set('activeshowrooms', $activeshowrooms);
		//debug($activeshowrooms);
		//die();
		$orders = TableRegistry::get('CurrentOrders');
		$sortorder="";
		if (null !== $this->request->getQuery('sortorder')) {
			$sortorder=$this->request->getQuery('sortorder');
		}
		$showroom="";
		$formData = $this->request->getData();
		if (!empty($formData['showroom'])) {
				$showroom = $formData['showroom'];
		}
		if ($this->request->is('post')) {
			$this->set('showroom', $this->_getSafeValueFromForm($formData, 'showroom'));
		} else {
			$this->set('showroom', '');
		}
		//$showroom = $formData['showroom'];
		//debug($showroom);
		//die;
		if ($slowMode) {
			$currentorders = $orders->getCurrentOrdersSlow($sortorder, $this, $showroom);
			$this->viewBuilder()->setTemplate('indexslow');
		} else {
			$currentorders = $orders->getCurrentOrders($sortorder, $this, $showroom);
		}
		//debug($ordersinproduction);
		//die;
		$this->set('currentorders', $currentorders);
		$this->set('showshowrooms', $showshowrooms);

	}

	public function export() {
		
		$showrooms = TableRegistry::get('Location');
		if ($this->_userHasRole("ADMINISTRATOR") || $this->isSuperuser()) {
			$activeshowrooms = $showrooms->getActiveShowrooms();
			$showroom='all';
		} else {
			$activeshowrooms = $showrooms->getBuddyShowrooms($this->getCurrentUserLocationId());
			$showroom=$this->getCurrentUserLocationId();
		} 
		if ($this->_userHasRole("ADMINISTRATOR") || $this->isSuperuser() || $this->getCurrentUserRegionId()==1) {
			$showshowrooms='y';
		} else {
			$showshowrooms='n';
		}	
		
		$orders = TableRegistry::get('CurrentOrders');
		$sortorder="";
		if (null !== $this->request->getQuery('sortorder')) {
			$sortorder=$this->request->getQuery('sortorder');
		}
		$showroom='';
		$formData = $this->request->getData();
		if (!empty($formData['showroom'])) {
				$showroom = $formData['showroom'];
		}
		$currentorders = $orders->getCurrentOrders($sortorder, $this, $showroom);
		$data = [];
		foreach ($currentorders as $row) {
			$ackdatewarning='';
			$ackdate='';
			$proddate='';
			if ((is_null($row['acknowdate']) || empty($row['acknowdate'])) && $row['ORDER_DATE'] != '') {
				$now = time(); // or your date as well
				$orderdate = strtotime($row['ORDER_DATE']);
				$datediff = $now - $orderdate;
				$interval = round($datediff / (60 * 60 * 24));
				if ($interval>7) {
					$ackdatewarning='y';
					$ackdate='Warning';
				}
			}
			$orderdate = date("d/m/Y", strtotime($row['ORDER_DATE']));
			if (!empty($row['acknowdate']) && $ackdatewarning=='') {
					$ackdate=date("d/m/Y", strtotime($row['acknowdate']));
			}
			$notedate='';
			if ($row['overduenotecount']>0) {
				$notedate='Warning';
			}
			if (is_null($row['productiondate']) || $row['productiondate']=='') {
				$proddate='';
			} else {
				$proddate=date("d/m/Y", strtotime($row['productiondate']));
			}
			$total = UtilityComponent::formatMoneyWithSymbol($row['total'], $row['ordercurrency']);
			$paymentstotal = UtilityComponent::formatMoneyWithSymbol($row['paymentstotal'], $row['ordercurrency']);
			$balanceoutstanding = UtilityComponent::formatMoneyWithSymbol($row['balanceoutstanding'], $row['ordercurrency']);
			
			$exworksdate='';
			if ($row['overseasOrder']=='y') {
				$exworksdate=$orders->getExWorksDate($row['PURCHASE_No']);
			}  
			$adminheading ='';
			if ($this->_userHasRole('ADMINISTRATOR') || $this->_userHasRole('SHOWROOM_VIEWER') || $this->getCurrentUserRegionId()==1) {
				$adminheading = $row['adminheading'];
			}
			$orderdate= date("d/m/Y h:i:s A", strtotime($row['ORDER_DATE']));
			if ($this->_userHasRole('ADMINISTRATOR') || $this->_userHasRole('SHOWROOM_VIEWER') || $this->getCurrentUserRegionId()==1) {
				$a = [$row['surname'] .', '.$row['title'] .' '.$row['first'],$row['company'],$row['ORDER_NUMBER'],$row['deliverypostcode'],$notedate,$orderdate,$ackdate,$adminheading,$total,$paymentstotal,$balanceoutstanding,$proddate,$row['bookeddeliverydate'],$exworksdate];
			} else {
				$a = [$row['surname'] .', '.$row['title'] .' '.$row['first'],$row['company'],$row['ORDER_NUMBER'],$row['deliverypostcode'],$notedate,$orderdate,$ackdate,$total,$paymentstotal,$balanceoutstanding,$proddate,$row['bookeddeliverydate'],$exworksdate];
			}
			array_push($data, $a);
		}
		if ($this->_userHasRole('ADMINISTRATOR') || $this->_userHasRole('SHOWROOM_VIEWER') || $this->getCurrentUserRegionId()==1) {
			$header = ['Customer Name', 'Company', 'Order No', 'Delivery Postcode', 'Note Date','Order Date', 'Ackgt Date', 'Order Source', 'Order Value', 'Payments Total', 'Balance Outstanding', 'Production Date', 'Booked Delivery date','Ex-Works Date'];
		} else {
			$header = ['Customer Name', 'Company', 'Order No', 'Delivery Postcode', 'Note Date','Order Date', 'Ackgt Date', 'Order Value', 'Payments Total', 'Balance Outstanding', 'Production Date', 'Booked Delivery date','Ex-Works Date'];	
		}

		$this->setResponse($this->getResponse()->withDownload('CurrentOrders.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $header,
            'bom' => true
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
		return ["ADMINISTRATOR","SALES","REGIONAL_ADMINISTRATOR"];
	}
    
}

?>
