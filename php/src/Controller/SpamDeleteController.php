<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;

class SpamDeleteController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
				
		$contacts = TableRegistry::get('Contact');
		$retiredContacts = $contacts->getRetiredContacts();
		$this->set('spamContacts', $retiredContacts);

	}
	
	public function delete() {
		$this->viewBuilder()->setLayout('savoir');
		$contacts = TableRegistry::get('Contact');
		$formData = $this->request->getData();
		foreach ($formData as $formfield => $value) {
			echo "<br>" .$formfield;
			$parts=explode("_",$formfield);
			if ($parts[0]=="XX") {
				$code=$parts[1];
				$contacts->deleteContacts($code);
				}
		}
		$this->Flash->success("The entries were deleted");
		$this->redirect(array('controller' => 'spamDelete', 'action' => 'index'));

	}
	
	public function reactivate() {
		$this->viewBuilder()->setLayout('savoir');
		$contacts = TableRegistry::get('Contact');
		$formData = $this->request->getData();
		foreach ($formData as $formfield => $value) {
			echo "<br>" .$formfield;
			$parts=explode("_",$formfield);
			if ($parts[0]=="XX") {
				$code=$parts[1];
				$contacts->reactivateContacts($code);
				}
		}
		$this->Flash->success("The entries were reactivated and removed from this list");
		$this->redirect(array('controller' => 'spamDelete', 'action' => 'index'));
	}

	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR");
	}
    
	protected function _getAllowedRegions(){
        return array("London");
    }

    protected function _isSuperuserOnly(){
        return true;
    }
}

?>