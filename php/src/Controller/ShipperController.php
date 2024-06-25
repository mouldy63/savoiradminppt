<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class ShipperController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
				
		$shipperTable = TableRegistry::get('Shipper');
		
		$shipper_address = $shipperTable->listShippers();
		//debug($correspondence);
		//die;
		$this->set('shipper_address', $shipper_address);

	}
	
	public function add()
    {
		$this->viewBuilder()->setLayout('savoir');
		if ($this->request->is('post')) {
			$formData = $this->request->getData();
			$shipperTable = TableRegistry::get('Shipper');
			$shipper_address = $shipperTable->newEntity([]);
			$shipper_address->shipperName = trim($formData['shippername']);
			$shipper_address->ADD1 = trim($formData['add1']);
			$shipper_address->ADD2 = trim($formData['add2']);
			$shipper_address->ADD3 = trim($formData['add3']);
			$shipper_address->TOWN = trim($formData['town']);
			$shipper_address->COUNTYSTATE = trim($formData['county']);
			$shipper_address->POSTCODE = trim($formData['postcode']);
			$shipper_address->COUNTRY = trim($formData['country']);
			$shipper_address->CONTACT = trim($formData['contact']);
			$shipper_address->PHONE = trim($formData['tel']);
			$shipperTable->save($shipper_address);
			$this->Flash->success("Shipper added successfully");
			$this->redirect(array('controller' => 'Shipper', 'action' => 'index'));
		}
    }
	
	public function edit()
    {
    	if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'Correspondence', 'action' => 'index'));
			return;
    	}
    	
    	$this->viewBuilder()->setLayout('savoir');
    	
    	//debug($this->request->getData());
		$formData = $this->request->getData();
		$correspondenceTable = TableRegistry::get('Correspondence');
		
		if (!empty($formData['submit1'])) {
			// get the row
			$correspondenceid = $formData['correspondence'];
			$row = $correspondenceTable->get($correspondenceid);
			$this->set('row', $row);
		} else {
			// save the row
			debug($formData);
			$correspondenceid = $formData['correspondenceid'];
			$correspondence = $correspondenceTable->get($correspondenceid);
			$correspondence->owning_region = $this->getCurrentUserRegionId();
			$correspondence->owning_location = $this->getCurrentUserLocationId();
			$correspondence->source_site = $this->getCurrentUserSite();
			$correspondence->dateentered = new DateTime('now');
			$correspondence->correspondencename = trim($formData['correspondencename']);
			$correspondence->correspondence = trim($formData['editor1']);
			$correspondence->correspondence2 = trim($formData['editor2']);
			if (!empty(trim($formData['greeting']))) {
				$correspondence->greeting = trim($formData['greeting']);
			}
			$correspondenceTable->save($correspondence);
			$this->Flash->success("Correspondence amended successfully");
			$this->redirect(array('controller' => 'Correspondence', 'action' => 'index'));
		}
    }
    
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR,SALES");
	}

}

?>