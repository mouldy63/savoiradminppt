<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\Event\EventInterface;

class AddCollectionController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
	}

	public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
        $builder->addHelpers([
        	'MyForm'
        ]);
    }
	
	public function index() {
		$this->viewBuilder()->setLayout('savoir');
		
		$shippers = TableRegistry::get('Shipper');
		$deliveryterms = TableRegistry::get('DeliveryTerms');
		$showrooms = TableRegistry::get('Location');
		
		$activeshippers = $shippers->listShippers();
		$delterms = $deliveryterms->listDelTerms();
		$activeshowrooms = $showrooms->getActiveShowrooms();
		$this->set('activeshippers', $activeshippers);
		$this->set('delterms', $delterms);
		$this->set('activeshowrooms', $activeshowrooms);
		$formData = $this->request->getData();
		
		
		if ($this->request->is('post')) {
			$this->set('collectiondate', $this->_getSafeValueFromForm($formData, 'collectiondate'));
			$allData = $this->_getData($this->request->getData());
		} else {
			$this->set('collectiondate', '');
		}
		
        	
		}
		
	public function add() {
    	
    $this->viewBuilder()->setLayout('savoir');
	$exportTable = TableRegistry::get('ExportCollections');
	
	if ($this->request->is('post')) {
			$userId = $this->getCurrentUsersId();
			//$this->set('userId', $userId );
			$formData = $this->request->getData();
			$exportcoll = $this->ExportCollections->newEntity([]);
			

			if ($formData['collectiondate'] !='') {
				$exportcoll->Collectiondate = $formData['collectiondate'];
			}
			if ($formData['shipper'] !='n') {
				$exportcoll->Shipper = $formData['shipper'];
			}
			if ($formData['transportmode'] !='') {
				$exportcoll->TransportMode = $formData['transportmode'];
			}
			if ($formData['containerref'] !='') {
				$exportcoll->ContainerRef = $formData['containerref'];
			}
			if ($formData['deliveryterms'] !='n') {
				$exportcoll->ExportDeliveryTerms = $formData['deliveryterms'];
			}
			if ($formData['destport'] !='n') {
				$exportcoll->DestinationPort = $formData['destport'];
			}
			$exportcoll->collectionStatus = 1;
			$exportcoll->dateAdded = date();
			$exportcoll->AddedBy = $userId;
			
			if ($this->ExportCollections->save($exportcoll)) {
				$collectionID = $exportcoll->exportCollectionsID;
			}
			$colShowTable = TableRegistry::get('ExportCollShowroom');
			$collshowroomTable = $this->ExportCollShowroom->newEntity([]);
			foreach ($formData as $key=>$val) {
			//debug($key);
				if (substr($key,0,2)==='XX') {
					$lid=substr($key,2);
					$collshowroom->exportCollectionID = $collectionID;
					$collshowroom->idLocation = $key;
				}
				if (substr($key,0,2)==='YY') {
					$eid=substr($key,2);
					$collshowroom->exportCollectionID = $collectionID;
					$collshowroom->ETAdate = $eid;
				}
				$collshowroomTable->save($collshowroom);
			}

			$this->Flash->success("New collection added");
			$this->redirect(array('controller' => 'AddCollection', 'action' => 'index'));
		}
	}
			
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR","SAVOIRSTAFF");
	}

}

?>
