<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class TermsController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
				
		$showrooms = TableRegistry::get('Location');
		
		$activeshowrooms = $showrooms->getActiveShowrooms();
		//debug($activeshowrooms);
		//die;
		$this->set('activeshowrooms', $activeshowrooms);


	}
	
	public function edit()
    {
    	if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'Terms', 'action' => 'index'));
			return;
    	}
    	
    	$this->viewBuilder()->setLayout('savoir');
    	
    	//debug($this->request->getData());
		//die;
		$formData = $this->request->getData();
		$locationTable = TableRegistry::get('Location');
		
		if (!empty($formData['submit1'])) {
			// get the row
			$idlocation = $formData['showroom'];
			$row = $locationTable->get($idlocation);
			//debug($row);
			//die;
			$this->set('row', $row);
		} else {
			// save the row
			//debug($formData);
			//die;
			$idlocation = $formData['idlocation'];
			$location = $locationTable->get($idlocation);
			$location->terms = trim($formData['editor1']);
			$location->datetermsamended =  new DateTime('now');
			$location->termsamendedby = $this->SavoirSecurity->getCurrentUserName();
			$locationTable->save($location);
			$this->Flash->success("Terms amended successfully");
			$this->redirect(array('controller' => 'Terms', 'action' => 'index'));
		}
    }
    
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR");
	}

}

?>