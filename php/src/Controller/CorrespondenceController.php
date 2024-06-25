<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class CorrespondenceController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
				
		$correspondenceTable = TableRegistry::get('Correspondence');
		
		$correspondence = $correspondenceTable->selectCorrespondenceItem($this->SavoirSecurity->isSuperuser(),$this->getCurrentUserRegionId(),$this->getCurrentUserLocationId());
		$this->set('correspondence', $correspondence);

	}
	
	public function add()
    {
		$this->viewBuilder()->setLayout('savoir');
		if ($this->request->is('post')) {
			$formData = $this->request->getData();
			$correspondenceTable = TableRegistry::get('Correspondence');
			$correspondence = $correspondenceTable->newEntity([]);
			$correspondence->owning_region = $this->getCurrentUserRegionId();
			$correspondence->owning_location = $this->getCurrentUserLocationId();
			$correspondence->source_site = $this->getCurrentUserSite();
			$correspondence->dateentered = new DateTime('now');
			$correspondence->correspondencename = trim($formData['correspondencename']);
			$correspondence->correspondence = trim($formData['editor1']);
			if (!empty(trim($formData['greeting']))) {
				$correspondence->greeting = trim($formData['greeting']);
			}
			$correspondenceTable->save($correspondence);
			$this->Flash->success("Correspondence created successfully");
			$this->redirect(array('controller' => 'Correspondence', 'action' => 'index'));
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
    	
		$formData = $this->request->getData();
		$correspondenceTable = TableRegistry::get('Correspondence');
		
		if (!empty($formData['submit1'])) {
			// get the row
			$correspondenceid = $formData['correspondence'];
			$row = $correspondenceTable->get($correspondenceid);
			$this->set('row', $row);
		} else {
			// save the row
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