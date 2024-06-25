<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class StaffPicklistController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
		$userTable = TableRegistry::get('SavoirUser');
		$savoirusers = $userTable->getProductionUsers();
		$this->set('savoirusers', $savoirusers);

	}
	public function add() {
		$this->viewBuilder()->setLayout('savoir');
		$userTable = TableRegistry::get('SavoirUser');
		$username=$this->request->getData()["newname"];
		$updateuser = $userTable->addUser($username);
		$this->Flash->success("New member of production team added");
		$this->redirect(array('controller' => 'StaffPicklist', 'action' => 'index'));

	}
	public function edit() {
		$this->viewBuilder()->setLayout('savoir');
		$userTable = TableRegistry::get('SavoirUser');
		$userid= $this->request->getQuery('userid');
		$userinfo = $userTable->get($userid);
		$this->set('userinfo', $userinfo);
			
	}
	public function doedit() {
		$formData = $this->request->getData();
		$userTable = TableRegistry::get('SavoirUser');
		$userid=$this->request->getData()["userid"];
		$userinfo = $userTable->get($userid);
			$userinfo->name = trim($formData['namestr']);
			if (isset($formData['pick'])) {
				$userinfo->PickedBy = 'y';
			} else {
			$userinfo->PickedBy = 'n';
			}
			if (isset($formData['made'])) {
			$userinfo->MadeBy = 'y';
			} else {
			$userinfo->MadeBy = 'n';
			}
			$userinfo->id_location = trim($formData['factory']);
			$userTable->save($userinfo);
			$this->Flash->success("User amended successfully");
			$this->redirect(array('controller' => 'StaffPicklist', 'action' => 'index'));


	}
	public function retire() {
		$this->viewBuilder()->setLayout('savoir');
		$userTable = TableRegistry::get('SavoirUser');
		$id= $this->request->getQuery('userid');
		$updateuser = $userTable->retireUser($id);
		$this->Flash->success("The entry has been retired");
		$this->redirect(array('controller' => 'StaffPicklist', 'action' => 'index'));

	}
	public function unretire() {
		$this->viewBuilder()->setLayout('savoir');
		$userTable = TableRegistry::get('SavoirUser');
		$id= $this->request->getQuery('userid');
		$updateuser = $userTable->unretireUser($id);
		$this->Flash->success("The entry has been un-retired");
		$this->redirect(array('controller' => 'StaffPicklist', 'action' => 'index'));

	}
	    
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR");
	}

}

?>