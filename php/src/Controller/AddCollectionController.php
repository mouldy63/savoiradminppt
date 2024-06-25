<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\Event\EventInterface;
use Cake\I18n\FrozenTime;

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
		$consigneetable = TableRegistry::get('Consignee');
		
		$activeshippers = $shippers->listShippers();
		$delterms = $deliveryterms->listDelTerms();
		$activeshowrooms = $showrooms->getActiveShowrooms();
		$consignees = $consigneetable->listConsignees();
		$this->set('activeshippers', $activeshippers);
		$this->set('delterms', $delterms);
		$this->set('activeshowrooms', $activeshowrooms);
		$this->set('consignees', $consignees);
		$userId = $this->getCurrentUserName();
		$this->set('userId', $userId);
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
			$exportcoll = $exportTable->newEntity([]);
			

			if ($formData['collectiondate'] !='') {
$colldate=$this->_getSTRtoDateObject($formData['collectiondate'])->i18nFormat('yyyy-MM-dd');
			$exportcoll->CollectionDate = $colldate;
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
			if ($formData['termstext'] !='n') {
				$exportcoll->termstext = $formData['termstext'];
			}
			if ($formData['consignee'] !='n') {
				$exportcoll->Consignee = $formData['consignee'];
			} else {
				$exportcoll->Consignee = null;
				$exportcoll->DeliverToConsignee = 'n';
			
			}
			if (isset($formData['consigneebutton'])) {
				$exportcoll->DeliverToConsignee = 'y';
			} else {
				$exportcoll->DeliverToConsignee = 'n';
			}
			$exportcoll->collectionStatus = 1;
			$exportcoll->dateAdded = new FrozenTime();
			$exportcoll->AddedBy = $userId;
			
			if ($exportTable->save($exportcoll)) {
				$collectionID = $exportcoll->exportCollectionsID;
			}
			$colShowTable = TableRegistry::get('ExportCollShowroom');
			
			foreach ($formData as $key=>$val) {
				$collshowroom=null;
				if (substr($key,0,2)==='YY') {
					$collshowroom = $colShowTable->newEntity([]);
					$lid=substr($key,2);
					if (substr($key,0,2)==='YY') {
				   	   if ($formData[$key] != '') {					
						   $etadate=$this->_getSTRtoDateObject($formData[$key])->i18nFormat('yyyy-MM-dd');
						   $collshowroom->exportCollectionID = $collectionID;
						   $collshowroom->ETAdate = $etadate;
						   $collshowroom->idLocation = $lid;
						}
					}
					
				   
					if ($collshowroom != null) $colShowTable->save($collshowroom);
				}
				
			}

			$this->Flash->success("New collection added");
			$this->redirect(array('controller' => 'AddCollection', 'action' => 'index'));
		}
	}	
	
		
	private function _getSTRtoDateObject($str) {
		$time = FrozenTime::createFromFormat(
		'd/m/Y',
		$str,
		'Europe/London'
	);
	return $time;
	}
		
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR","SAVOIRSTAFF");
	}

}

?>
