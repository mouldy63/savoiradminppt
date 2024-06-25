<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;
use Cake\Event\EventInterface;

class ItemStatusReportController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
	}
	
	public function export() {
		$purchaseTable = TableRegistry::get('Purchase');
		$customerOrders = $purchaseTable->getOrdersToBeDelivered();
		$data = [];
		
		foreach ($customerOrders as $row) {
		//debug($row);
		//die;
		$plannedproddate='';
		if (isset($row['plannedproddate'])) {
			$plannedproddate=date("d/m/Y", strtotime($row['plannedproddate']));
		}
		$deliverydate='';
		if (isset($row['deliverydate'])) {
			$deliverydate=date("d/m/Y", strtotime($row['deliverydate']));
		}
		$exworksdate='';
		if (isset($row['exworksdate'])) {
			$exworksdate=date("d/m/Y", strtotime($row['exworksdate']));
		}
		$orderdate='';
		if (isset($row['orderdate'])) {
			$orderdate=date("d/m/Y", strtotime($row['orderdate']));
		}
		$accessorycheckeddate='';
		if (isset($row['accessorycheckeddate'])) {
			$accessorycheckeddate=date("d/m/Y", strtotime($row['accessorycheckeddate']));
		}
		
		$itempriceexvat='';
		if (isset($row['itempriceexvat'])) {
			$itempriceexvat=number_format((float)$row['itempriceexvat'], 2, '.', '');
		}
		$itempriceexvatexdiscount='';
		if (isset($row['itempriceexvatexdiscount'])) {
			$itempriceexvat=number_format((float)$row['itempriceexvatexdiscount'], 2, '.', '');
		}
		
		
		
		
		
			$a = [$row['boxtype'], $plannedproddate, $row['companyname'], $row['customername'], $row['deliveryadd1'], $row['deliveryadd2'], $row['deliverytown'], $row['deliverypostcode'], $row['deliverycountry'], $deliverydate, $row['depth'], $row['height'], $row['width'], $exworksdate, $itempriceexvat, $itempriceexvatexdiscount, $row['balanceoutstanding'], $row['subtot_exvat_exdel'], $row['orderdiscount'], $row['orderdiscounttype'], $row['ordtot_exvat_exdiscount'], $row['bay'], $row['itemstatus'], $row['compname'], $row['itemtype'], $row['madeat'], $orderdate, $row['ordernumber'], $row['showroom'], $row['specialinstructions'], $row['totalcube'], $row['accessorydescription'], $accessorycheckeddate, $row['wraptype']];
			array_push($data, $a);
		}
		$header = ['Box/Crate Type of the item', 'Planned Prod date of the item', 'Company', 'Customer Name', 'Delivery Add 1', 'Delivery Add 2', 'Delivery Add Town', 'Delivery Add Postcode', 'Delivery Add Country', 'Delivery Date', 'Dim-Depth', 'Dim-Height', 'Dim-Length', 'Ex-works Date for Item', 'Item exc. VAT', 'Item Value Ex VAT Ex Discount', 'Outstanding Balance of order Inc VAT', 'Order Sub Total excluding VAT and Excluding Delivery charges', 'Discount', 'Discount Type', 'Total Order Value Ex VAT Ex Discount', 'Item Location / Bay No', 'Item Status', 'Model/Name', 'Item Type', 'Made At', 'Order Date', 'Order No', 'Showroom', 'Special Instructions for the Item', 'Total cube of the item', 'Accessory Desc', 'Accessory Checked & Picked Date', 'Wrap Type'];

    	$this->setResponse($this->getResponse()->withDownload('ItemStatusReport.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $header
    	]);
	}
	


	protected function _getAllowedRoles() {
		return array("ADMINISTRATOR");
	}
	protected function _getAllowedRegions(){
        return [["London"]];
	}
}

?>
