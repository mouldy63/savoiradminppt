<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class CancelledExportsController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadModel('ExportCollections');

		
	}
	
	public function index() {
		$this->viewBuilder()->setLayout('savoir');
		
		$sortorder="";
		if (null !== $this->request->getQuery('sortorder')) {
			$sortorder=$this->request->getQuery('sortorder');
		}
                		
        $cancelledExports=$this->ExportCollections->getCancelledExports($this->SavoirSecurity->isSuperuser(), $this->getCurrentUserLocationId(), $sortorder);
        //debug($cancelledExports);
        //die();	
        $this->set('cancelledExports', $cancelledExports);
        $this->set('CurrentUserLocationId', $this->getCurrentUserLocationId());
        	
		}
	
			
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR","SALES");
	}

}

?>
