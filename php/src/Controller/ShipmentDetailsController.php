<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\Event\EventInterface;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class ShipmentDetailsController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadModel('ExportCollections');

		
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
		
		$params = $this->request->getParam('?');
        $cid = $params['id'];
		$location = $params['location'];
		$userlocationid = $this->getCurrentUserLocationId();
        $noOfOrders=0;       		
        $shipmentdetails=$this->ExportCollections->getShipmentDetails($cid, $location);
        
        foreach ($shipmentdetails as $sd) {
        	$addedby=$sd['AddedBy'];
        	$updatedby=$sd['UpdatedBy'];
        	if (isset($sd['UpdatedBy'])) {
        		$updateddate=$sd['UpdatedDate'];
        	} else {
        		$updateddate='';
        	}
		}
        
        $orders=$this->ExportCollections->getShipmentPurchaseNos($cid, $userlocationid, $location);
        $noOfOrders=count($orders);
		$this->set('shipmentdetails', $shipmentdetails);
		$this->set('noOfOrders', $noOfOrders);
		$this->set('orders', $orders);
		$this->set('cid', $cid);
		$this->set('addedby', $addedby);
		$this->set('updatedby', $updatedby);
		$this->set('updateddate', $updateddate);
		


	}
		
		
	
			
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR","SALES","REGIONAL_ADMINISTRATOR");
	}

}

?>
