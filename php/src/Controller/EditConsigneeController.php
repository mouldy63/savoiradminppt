<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class EditConsigneeController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
				
		$consigneeTable = TableRegistry::get('Consignee');
		
		$consigneeid = $this->request->getQuery('lid');
		$consignee_address = $consigneeTable->getConsignee($consigneeid);
		

		$this->set('consignee_address', $consignee_address[0]);

	}
	
	public function edit()
    {
    	if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'EditConsignee', 'action' => 'index'));
			return;
    	}
    	
    	$this->viewBuilder()->setLayout('savoir');
    	
    	//debug($this->request->getData());
		$formData = $this->request->getData();
		$consigneeTable = TableRegistry::get('Consignee');
	
		$consigneeid = $formData['consigneeid'];
		$consignee = $consigneeTable->find('all', array('conditions'=> array('consignee_ADDRESS_ID' => $consigneeid)));
    	$consignee = $consignee->toArray()[0];
		$consignee->consigneeName = trim($formData['consigneename']);
		$consignee->ADD1 = trim($formData['add1']);
		$consignee->ADD2 = trim($formData['add2']);
		$consignee->ADD3 = trim($formData['add3']);
		$consignee->TOWN = trim($formData['town']);
		$consignee->COUNTYSTATE = trim($formData['county']);
		$consignee->POSTCODE = trim($formData['postcode']);
		$consignee->COUNTRY = trim($formData['country']);
		$consignee->CONTACT = trim($formData['contact']);
		$consignee->PHONE = trim($formData['tel']);
		$consigneeTable->save($consignee);
		$this->Flash->success("Consignee amended successfully");
		$this->redirect(['action' => 'index', '?' => ['lid' => $consigneeid]]);
    }
    
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR,SALES");
	}

}

?>