<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;

class ProductionListController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		set_time_limit(120);
		$this->loadModel('Purchase');
		$this->loadModel('QcHistoryLatest');
    }
    
    public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
    	$builder->addHelpers([
        	'AuxiliaryData'
        ]);
    }
	
    public function index() {
		$this->viewBuilder()->setLayout('savoirdatatablesprodlist');
		
		$ProductionListTable = TableRegistry::get('ProductionList');
		$cwc='';
		$factory='';
		$params = $this->request->getParam('?');
		if ($params != '') {
			$factory = $params['factory'];
			if (isset($params['cwc']) && $params['cwc']=='y') {
			$cwc='y';
			} else {
			$cwc='n';
			}
		}
		$OrdersInProduction = $ProductionListTable->getOrdersInProduction($cwc, $factory);
		$total = count($OrdersInProduction);
		//debug($OrdersInProduction);
		//die;		
		$this->set('OrdersInProduction', $OrdersInProduction);
		$this->set('total',$total);
		$this->set('factory',$factory);
		$this->set('cwc',$cwc);
	}
	
	public function export() {
		
		$ProductionListTable = TableRegistry::get('ProductionList');
		$ManufacturedAtTable = TableRegistry::get('ManufacturedAt');
		$ExportCollectionsTable = TableRegistry::get('ExportCollections');
		$cwc='n';
		$factory='';
		$params = $this->request->getParam('?');
		if ($params != '') {
			$factory = $params['factory'];
			if (isset($params['cwc']) && $params['cwc']=='y') {
			$cwc='y';
			} else {
			$cwc='n';
			}
		}
		
		$ProdCSV = $ProductionListTable->getOrdersInProduction($cwc, $factory);
		
		$data = [];
		
		foreach ($ProdCSV as $row) {
		$custname='';
		if (isset($row['surname'])) {
			$custname .= $row['surname'] . ", ";
		}
		if (isset($row['title'])) {
			$custname .= $row['title'] . " ";
		}
		if (isset($row['first'])) {
			$custname .= $row['first'] . " ";
		}
		$orderdate='';
		$productiondate='';
		$bookeddeliverydate='';
		$mattmadeat = '';
		$mattstatus='';
		$basemadeat = '';
		$basestatus='';
		$toppermadeat = '';
		$topperstatus='';
		$hbmadeat = '';
		$hbstatus='';
		$legsmadeat = '';
		$legstatus='';
		$orderstatus='';
		if (isset($row['ORDER_DATE'])) {
			$orderdate=date('d-m-Y',strtotime($row['ORDER_DATE']));
		}
		if (isset($row['productiondate'])) {
			$productiondate=date('d-m-Y',strtotime($row['productiondate']));
		}
		if (isset($row['bookeddeliverydate'])) {
			$bookeddeliverydate=date('d-m-Y',strtotime($row['bookeddeliverydate']));
		}
		
		if (isset($row['matt_madeat']) && $row['mattressrequired']=='y') {
			$mattmadeat = $ManufacturedAtTable->getItemMadeAt($row['matt_madeat']);
		}
		if (isset($row['base_madeat']) && $row['baserequired']=='y') {
			$basemadeat = $ManufacturedAtTable->getItemMadeAt($row['base_madeat']);
		}
		if (isset($row['topper_madeat']) && $row['topperrequired']=='y') {
			$toppermadeat = $ManufacturedAtTable->getItemMadeAt($row['topper_madeat']);
		}
		if (isset($row['headboard_madeat']) && $row['headboardrequired']=='y') {
			$hbmadeat = $ManufacturedAtTable->getItemMadeAt($row['headboard_madeat']);
		}
		if (isset($row['legs_madeat']) && $row['legsrequired']=='y') {
			$legsmadeat = $ManufacturedAtTable->getItemMadeAt($row['legs_madeat']);
		}
		
		
		if (isset($row['matt_status']) && $row['mattressrequired']=='y') {
			$mattstatus = $ManufacturedAtTable->getItemStatus($row['matt_status']);
		}
		if (isset($row['base_status']) && $row['baserequired']=='y') {
			$basestatus = $ManufacturedAtTable->getItemStatus($row['base_status']);
		}
		if (isset($row['topper_status']) && $row['topperrequired']=='y') {
			$topperstatus = $ManufacturedAtTable->getItemStatus($row['topper_status']);
		}
		if (isset($row['headboard_status']) && $row['headboardrequired']=='y') {
			$hbstatus = $ManufacturedAtTable->getItemStatus($row['headboard_status']);
		}
		if (isset($row['legs_status']) && $row['legsrequired']=='y') {
			$legstatus = $ManufacturedAtTable->getItemStatus($row['legs_status']);
		}
		if (isset($row['order_status'])) {
			$orderstatus = $ManufacturedAtTable->getItemStatus($row['order_status']);
		}
		$collectiondate='';
		$collectiondate = $ExportCollectionsTable->getOrderCollectionDate($row['PURCHASE_No']);
		
		
			$a = [$custname,$row['company'],$row['street1'],$row['street2'],$row['street3'],$row['town'],$row['county'],$row['postcode'],$row['country'],$row['ORDER_NUMBER'],$orderdate,$row['adminheading'],$row['savoirmodel'], $mattmadeat, $mattstatus,$row['basesavoirmodel'], $basemadeat, $basestatus,$row['toppertype'], $toppermadeat, $topperstatus,$row['headboardstyle'], $hbmadeat, $hbstatus,$row['legstyle'], $legsmadeat, $legstatus, $productiondate, $bookeddeliverydate, $row['totalexvat'], $row['ordercurrency'], $orderstatus, $collectiondate, $row['PRICE_LIST'], $row['paymentstotal'], $row['vatrate'], $row['orderSource']];
			array_push($data, $a);
		}
		$header = ['Customer Name', 'Company', 'Address 1', 'Address 2', 'Address 3', 'Town', 'County', 'Postcode', 'Country', 'Order No', 'Order Date', 'Showroom', 'Mattress Required', 'Mattress Made At', 'Mattress Order Status', 'Base Required', 'Base Made At', 'Base Order Status', 'Topper Required', 'Topper Made At', 'Topper Order Status', 'Headboard Required', 'Headboard Made At', 'Headboard Order Status', 'Legs Required', 'Legs Made At', 'Legs Order Status', 'Production Date', 'Booked Delivery Date', 'Total Ex VAT', 'Order Currency', 'Order Status', 'Ex-Works Date', 'Price List', 'Payments Total', 'VAT Rate', 'Order Source'];

    	$this->setResponse($this->getResponse()->withDownload('ProductionList.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $header
    	]);
	}
	
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR"];
	}
    
}

?>
