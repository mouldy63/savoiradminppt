<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\Event\EventInterface;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class ContainerDetailsController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadModel('ExportCollections');
		$this->loadComponent('CommercialData');

		
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
		$userlocationid = $this->getCurrentUserLocationId();
        $noOfOrders=0;  
        $containerdetails=$this->ExportCollections->getContainerDetails($cid); 
		$this->set('containerdetails', $containerdetails);
		$this->set('cid', $cid);
		$this->set('userlocationid', $userlocationid);
		
		$weights = [];
		$volumes = [];
		foreach ($containerdetails as $pe) {
			$cid=$pe['exportCollectionsID'];
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
