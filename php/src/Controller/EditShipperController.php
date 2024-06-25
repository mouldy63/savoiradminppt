<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class EditShipperController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
				
		$shipperTable = TableRegistry::get('Shipper');
		$shipperid = $this->request->getQuery('lid');
		$shipper_address = $shipperTable->getShipper($shipperid);

		$this->set('shipper_address', $shipper_address[0]);

	}
	
	public function edit()
    {
    	if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'EditShipper', 'action' => 'index'));
			return;
    	}
    	
    	$this->viewBuilder()->setLayout('savoir');
    	
    	//debug($this->request->getData());
		$formData = $this->request->getData();
		$shipperTable = TableRegistry::get('Shipper');
	
		$shipperid = $formData['shipperid'];
		$shipper = $shipperTable->find('all', array('conditions'=> array('shipper_ADDRESS_ID' => $shipperid)));
    	$shipper = $shipper->toArray()[0];
		$shipper->shipperName = trim($formData['shippername']);
		$shipper->ADD1 = trim($formData['add1']);
		$shipper->ADD2 = trim($formData['add2']);
		$shipper->ADD3 = trim($formData['add3']);
		$shipper->TOWN = trim($formData['town']);
		$shipper->COUNTYSTATE = trim($formData['county']);
		$shipper->POSTCODE = trim($formData['postcode']);
		$shipper->COUNTRY = trim($formData['country']);
		$shipper->CONTACT = trim($formData['contact']);
		$shipper->PHONE = trim($formData['tel']);
		$shipperTable->save($shipper);
		$this->Flash->success("Shipper amended successfully");
		$this->redirect(['action' => 'index', '?' => ['lid' => $shipperid]]);
    }
    
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR,SALES");
	}

}

?>