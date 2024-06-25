<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class PlannedExportsController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadModel('ExportCollections');
		$this->loadComponent('CommercialData');
		$this->loadModel('Purchase');
	}
	
	public function index() {
		$this->viewBuilder()->setLayout('savoir');
		
		$sortorder="";
		if (null !== $this->request->getQuery('sortorder')) {
			$sortorder=$this->request->getQuery('sortorder');
		}

		$plannedExports=$this->ExportCollections->getPlannedExports($this->SavoirSecurity->isSuperuser(), $this->_userHasRole('REGIONAL_ADMINISTRATOR'), $this->getCurrentUserLocationId(), $this->getCurrentUserRegionId(), $sortorder);
		
		$weights = [];
		$volumes = [];
		foreach ($plannedExports as $pe) {
			$cid=$pe['exportCollectionsID'];
			$data = $this->CommercialData->getExportCollectionWeightAndVolume($cid);
			$weights[$cid] = $data['totalWeight'];
			$volumes[$cid] = $data['totalVolume'];
		}

		$this->set('plannedExports', $plannedExports);
		$this->set('weights', $weights);
		$this->set('volumes', $volumes);
		$this->set('CurrentUserLocationId', $this->getCurrentUserLocationId());
		$this->set('CurrentUserRegionId', $this->getCurrentUserRegionId());
	}

	public function ordersearch() {
		if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'PlannedExports', 'action' => 'index'));
			return;
    	}
		$formData = $this->request->getData();
		$orderno = $formData['orderno'];
		$pno=null;
		$query = $this->Purchase->find()->where(['ORDER_NUMBER' => $orderno]);
		foreach ($query as $row) {
			$purchase = $row;
			$pno = $purchase['PURCHASE_No'];
		}
		if ($pno==null) {
			$this->Flash->error("This order number is invalid ".$orderno);
			$this->redirect(['action' => 'index']);
			return;
		}
		$collectiondata=$this->ExportCollections->getShipmentDetailsForOrderNo($pno);
		foreach ($collectiondata as $row) {
			$collectiondata = $row;
		}
		$location='';
		$cid='';
		$url='';
		$msg='';
		$location=$row['idLocation'];
		$cid=$row['exportCollectionID'];
		$url="ShipmentDetails?location=".$location."&id=".$cid."";
		//debug($collectiondata);
		//die;
		if ($cid=='' || $location=='') {
			$this->Flash->error("A shipment can't be found for this order number ".$orderno);
			$this->redirect(['action' => 'index']);
			return;
		}
		$this->redirect(array('controller' => $url, 'action' => 'index'));
	}
			
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR","SALES","REGIONAL_ADMINISTRATOR");
	}

}

?>
