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
		$this->loadModel('ExportLinks');

		
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
		//debug($orders);
		//die;
        $noOfOrders=count($orders);
		$this->set('shipmentdetails', $shipmentdetails);
		$this->set('noOfOrders', $noOfOrders);
		$this->set('orders', $orders);
		$this->set('location', $location);
		$this->set('cid', $cid);
		$this->set('addedby', $addedby);
		$this->set('updatedby', $updatedby);
		$this->set('updateddate', $updateddate);
		


	}

	public function mergeinvoices() {
		if (!$this->request->is('post')) {
			$this->Flash->error("Invalid call to edit");
			$this->redirect(array('controller' => 'ShipmentDetails', 'action' => 'index'));
			return;
    	}
		$formData = $this->request->getData();
		$id=$formData['id'];
		$location=$formData['location'];
		foreach ($formData as $key=>$val) {
			//debug($key);
			if (substr($key,0,3)==='XX_') {
				$pn=substr($key,3);
				$exportCollShowroomsID=$this->ExportCollections->getExportCollShowroomsID($id, $location);
				
				$linksdata = $this->ExportLinks->find()->where(['purchase_no =' => $pn, 'LinksCollectionID' => $exportCollShowroomsID]);
				foreach ($linksdata as $row) {
					$row->MergedCI = $formData[$key];
					$this->ExportLinks->save($row);
				}
				
			}
		}
		
		$this->Flash->success("Invoices merged successfully");
		$this->redirect(['action' => 'index', '?' => ['location' => $location, 'id'=>$id]]);
	}

		
		
	
			
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR","SALES","REGIONAL_ADMINISTRATOR");
	}

}

?>
