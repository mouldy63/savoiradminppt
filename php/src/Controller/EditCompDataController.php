<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class EditCompDataController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
				
		$componentdataTable = TableRegistry::get('Componentdata');
		$compdataid = $this->request->getQuery('lid');
		$componentdata = $componentdataTable->getComponentdata($compdataid);

		$this->set('componentdata', $componentdata[0]);

	}
	
	public function edit()
    {
    	if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'EditCompData', 'action' => 'index'));
			return;
    	}
    	
    	$this->viewBuilder()->setLayout('savoir');
    	
    	//debug($this->request->getData());
		$formData = $this->request->getData();
		$componentdataTable = TableRegistry::get('Componentdata');
		$componentid = $formData['componentid'];
		$componentdata = $componentdataTable->find('all', array('conditions'=> array('COMPONENTDATA_ID' => $componentid)));
    	$componentdata = $componentdata->toArray()[0];
		$componentdata->COMPONENTNAME = trim($formData['compname']);
		$componentdata->WEIGHT = trim($formData['compweight']);
		$componentdata->TARIFFCODE = trim($formData['comptariff']);
		$componentdata->DEPTH = trim($formData['compdepth']);
		$componentdataTable->save($componentdata);
		$this->Flash->success("Component data amended successfully");
		$this->redirect(['action' => 'index', '?' => ['lid' => $componentid]]);
    }
	
	
    
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR,SALES");
	}

}

?>