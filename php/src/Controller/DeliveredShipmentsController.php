<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class DeliveredShipmentsController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadModel('ExportCollections');
		$this->loadComponent('CommercialData');

		
	}
	
	public function index() {
		$this->viewBuilder()->setLayout('savoir');
		
		$sortorder="";
		if (null !== $this->request->getQuery('sortorder')) {
			$sortorder=$this->request->getQuery('sortorder');
		}
		$oneyear='12';
		$formData = $this->request->getData();
		if (!empty($formData['yeardel'])) {
				$oneyear= $formData['yeardel'];
		}
		$this->set('oneyear', $oneyear);
                		
        $deliveredExports=$this->ExportCollections->getDeliveredExports($this->SavoirSecurity->isSuperuser(), $this->getCurrentUserLocationId(), $sortorder, $oneyear);
        //debug($cancelledExports);
        //die();	
        $this->set('deliveredExports', $deliveredExports);
        $this->set('CurrentUserLocationId', $this->getCurrentUserLocationId());
        
        $weights = [];
		$volumes = [];
		foreach ($deliveredExports as $de) {
			$cid=$de['exportCollectionsID'];
			$data = $this->CommercialData->getExportCollectionWeightAndVolume($cid);
			$weights[$cid] = $data['totalWeight'];
			$volumes[$cid] = $data['totalVolume'];
		}

		$this->set('weights', $weights);
		$this->set('volumes', $volumes);
        	
		}
	
			
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR","SALES");
	}

}

?>
