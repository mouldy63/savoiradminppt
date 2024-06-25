<?php
namespace App\Controller;

use \App\Controller\Component\UtilityComponent;
use Cake\Event\EventInterface;
use \DateTime;

class CurrentOrdersController extends SecureAppController {

	private $colMapping = [
		0 => 'surname',
		1 => 'company',
		2 => 'ORDER_NUMBER',
		3 => 'customerreference',
		4 => 'deliverypostcode',
		5 => 'overduenotecount',
		6 => 'ORDER_DATE',
		7 => 'acknowdate',
		8 => 'adminheading',
		9 => 'total',
		10 => 'paymentstotal',
		11 => 'balanceoutstanding',
		12 => 'productiondate',
		13 => 'bookeddeliverydate',
		14 => 'overseasOrder'
	];

	public function initialize() : void {
		parent::initialize();
		set_time_limit(240);
		$this->loadModel('Location');
		$this->loadModel('CurrentOrders');
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
		
		if ($this->_userHasRole("ADMINISTRATOR") || $this->isSuperuser()) {
			$activeshowrooms = $this->Location->getActiveShowrooms();
			$showroom='all';
		} else {
			$activeshowrooms = $this->Location->getBuddyShowrooms($this->getCurrentUserLocationId());
			$showroom=$this->getCurrentUserLocationId();
		} 
		if ($this->_userHasRole("ADMINISTRATOR") || $this->isSuperuser() || $this->getCurrentUserRegionId()==1) {
			$showshowrooms='y';
		} else {
			$showshowrooms='n';
		}	
		$this->set('activeshowrooms', $activeshowrooms);
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
		$this->set('showshowrooms', $showshowrooms);

		$currentOrdersCount = $this->CurrentOrders->getCurrentOrdersCount($this, $showroom)[0]['count'];
		$this->set('currentOrdersCount', $currentOrdersCount);
	}

    public function page() {
		$this->autoRender = false;
		$query = $this->request->getQueryParams();
		$start = (int)$query['start'];
		$length = (int)$query['length'];
		$recordcount = isset($query['recordcount']) ? (int)$query['recordcount'] : 0;
		$orderCol = '';
		$orderDir = '';
		if (isset($query['order'][0]['column'])) {
			$orderCol = $this->colMapping[(int)$query['order'][0]['column']];
			$orderDir = $query['order'][0]['dir'];
		}
		// debug($this->request->getQueryParams());
		// debug($length);
		// debug($orderCol);
		// debug($orderDir);
		// die;

		if ($this->_userHasRole("ADMINISTRATOR") || $this->isSuperuser()) {
			$activeshowrooms = $this->Location->getActiveShowrooms();
			$showroom='all';
		} else {
			$activeshowrooms = $this->Location->getBuddyShowrooms($this->getCurrentUserLocationId());
			$showroom=$this->getCurrentUserLocationId();
		} 
		if ($this->_userHasRole("ADMINISTRATOR") || $this->isSuperuser() || $this->getCurrentUserRegionId()==1) {
			$showshowrooms='y';
		} else {
			$showshowrooms='n';
		}	
		$showroom="";

		$currentorders = $this->CurrentOrders->getCurrentOrders($this, $showroom, $start, $length, $orderCol, $orderDir);
		$dataArray = [];
		foreach ($currentorders as $row) {
			$r = [];
			$r[] = "<a href='/orderdetails.asp?pn=".$row['PURCHASE_No']."'>".$row['surname'].", ".$row['title']." ".$row['first']."</a>";
			$r[] = isset($row['company']) ? $row['company'] : '&nbsp;';
			$r[] = isset($row['ORDER_NUMBER']) ? $row['ORDER_NUMBER'] : '&nbsp;';
			$r[] = isset($row['customerreference']) ? $row['customerreference'] : '&nbsp;';
			$r[] = isset($row['deliverypostcode']) ? $row['deliverypostcode'] : '&nbsp;';
			$r[] = ($row['overduenotecount']>0) ? "<img src='/img/redflag.jpg' alt='Warning' align='middle' border='0'/>" : "&nbsp;"; 
			$r[] = isset($row['ORDER_DATE']) ? date("d/m/Y", strtotime(substr($row['ORDER_DATE'],0,10))) : '&nbsp;';
			$r[] = $this->acknowDateWarning($row) ? "<img src='/img/redflag.jpg' alt='Warning' align='middle' border='0'/>" : "&nbsp;";
			if ($showshowrooms=='y') {
				$r[] = isset($row['adminheading']) ? $row['adminheading'] : '&nbsp;';
			}
			$r[] = UtilityComponent::formatMoneyWithSymbol($row['total'], $row['ordercurrency']);
			$r[] = UtilityComponent::formatMoneyWithSymbol($row['paymentstotal'], $row['ordercurrency']);
			$r[] = UtilityComponent::formatMoneyWithSymbol($row['balanceoutstanding'], $row['ordercurrency']);
			$r[] = isset($row['productiondate']) ? date("d/m/Y", strtotime(substr($row['productiondate'],0,10))) : '&nbsp;';
			$r[] = isset($row['bookeddeliverydate']) ? date("d/m/Y", strtotime(substr($row['bookeddeliverydate'],0,10))) : '&nbsp;';
			if ($row['overseasOrder']=='y') {
				if ($row['lorrycount']>1) {
					$r[] = 'Split Shipment Dates';
				} else {
					if (!empty($row['CollectionDate'])) {
						$r[] = date("d/m/Y", strtotime(substr($row['CollectionDate'],0,10)));
					} else {
						$r[] = 'TBA';
					}
				}
			} else {
				$r[] = '&nbsp;';
			}		
			$dataArray[] = $r;
		}

		$draw = isset($_GET['draw']) ? intval($_GET['draw']) : 1;
		
		$response = [
			'draw' => $draw,
			'recordsTotal' => $recordcount,
			'recordsFiltered' => $recordcount,
			'data' => $dataArray,
		];
		$this->response = $this->response->withStringBody(json_encode($response, JSON_PRETTY_PRINT));
	}

	public function export() {
		
		if ($this->_userHasRole("ADMINISTRATOR") || $this->isSuperuser()) {
			$activeshowrooms = $this->Location->getActiveShowrooms();
			$showroom='all';
		} else {
			$activeshowrooms = $this->Location->getBuddyShowrooms($this->getCurrentUserLocationId());
			$showroom=$this->getCurrentUserLocationId();
		} 
		if ($this->_userHasRole("ADMINISTRATOR") || $this->isSuperuser() || $this->getCurrentUserRegionId()==1) {
			$showshowrooms='y';
		} else {
			$showshowrooms='n';
		}	
		
		$sortorder="";
		if (null !== $this->request->getQuery('sortorder')) {
			$sortorder=$this->request->getQuery('sortorder');
		}
		$showroom='';
		$formData = $this->request->getData();
		if (!empty($formData['showroom'])) {
				$showroom = $formData['showroom'];
		}
		$currentorders = $this->CurrentOrders->getCurrentOrders($sortorder, $this, $showroom);
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
			$overduenote = $orders->getHasOverdueNote($row['PURCHASE_No']);
			$notedate='';
			if ($overduenote) {
				$notedate='Warning';
				}
			if (is_null($row['productiondate']) || $row['productiondate']=='') {
				$proddate='';
				}
				else {
				
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

	private function acknowDateWarning($row) {
		$warning = false;
		if (!isset($row['acknowdate']) && isset($row['ORDER_DATE'])) {
			$orderDate = DateTime::createFromFormat('Y-m-d G:i:s', $row['ORDER_DATE']);
			$dDiff = $orderDate->diff(new DateTime());
			$warning = ($dDiff->d > 7);
		}
		return $warning;
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
