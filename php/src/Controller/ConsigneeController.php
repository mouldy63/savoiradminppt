<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class ConsigneeController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
				
		$consigneeTable = TableRegistry::get('Consignee');
		
		$consignee_address = $consigneeTable->listConsignees();
		$this->set('consignee_address', $consignee_address);

	}
	
	public function add()
    {
		$this->viewBuilder()->setLayout('savoir');
		if ($this->request->is('post')) {
			$formData = $this->request->getData();
			$consigneeTable = TableRegistry::get('Consignee');
			$consignee_address = $consigneeTable->newEntity([]);
			$consignee_address->consigneeName = trim($formData['consigneename']);
			$consignee_address->ADD1 = trim($formData['add1']);
			$consignee_address->ADD2 = trim($formData['add2']);
			$consignee_address->ADD3 = trim($formData['add3']);
			$consignee_address->TOWN = trim($formData['town']);
			$consignee_address->COUNTYSTATE = trim($formData['county']);
			$consignee_address->POSTCODE = trim($formData['postcode']);
			$consignee_address->COUNTRY = trim($formData['country']);
			$consignee_address->CONTACT = trim($formData['contact']);
			$consignee_address->PHONE = trim($formData['tel']);
			$consigneeTable->save($consignee_address);
			$this->Flash->success("Consignee added successfully");
			$this->redirect(array('controller' => 'Consignee', 'action' => 'index'));
		}
    }
	
	
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR,SALES");
	}

}

?>