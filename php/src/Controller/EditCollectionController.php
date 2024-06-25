<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\Event\EventInterface;
use Cake\I18n\FrozenTime;
use \App\Controller\Component\UtilityComponent;

class EditCollectionController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
	}

	public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
    	$builder->addHelpers([
        	'AuxiliaryData', 'MyForm'
        ]);
    }
	
	public function index() {
		$this->viewBuilder()->setLayout('savoir');
		$shippers = TableRegistry::get('Shipper');
		$deliveryterms = TableRegistry::get('DeliveryTerms');
		$showrooms = TableRegistry::get('Location');
		$exportTable = TableRegistry::get('ExportCollections');
		$collectionstatus = TableRegistry::get('CollectionStatus');
		$consigneetable = TableRegistry::get('Consignee');
		$userTable = TableRegistry::get('SavoirUser');
		
		$activeshippers = $shippers->listShippers();
		$collectionstatus = $collectionstatus->getStatusList();
		$delterms = $deliveryterms->listDelTerms();
		$activeshowrooms = $showrooms->getActiveShowrooms();
		$consignees = $consigneetable->listConsignees();
		 
		$this->set('activeshippers', $activeshippers);
		$this->set('delterms', $delterms);
		$this->set('activeshowrooms', $activeshowrooms);
		$this->set('collectionstatus', $collectionstatus);
		$this->set('consignees', $consignees);
		$collectionDate='';
		$userid='';
		$username='';
		$updatedby='';
		$updateddate='';
		$params = $this->request->getParam('?');
		if (isset($params) && array_key_exists('collectionid', $params)) {
			$collectionID = $params['collectionid'];
			$collectionData = $exportTable->getCollectionData($collectionID);
			if (count($collectionData)>0) {
				$collectionDate = UtilityComponent::mysqlToUsStrDate($collectionData[0]['CollectionDate']);
				$shipper = $collectionData[0]['Shipper'];
				$transportmode = $collectionData[0]['TransportMode'];
				$containerref = $collectionData[0]['ContainerRef'];
				$deliveryterms = $collectionData[0]['ExportDeliveryTerms'];
				$termstext = $collectionData[0]['termstext'];
				$destport = $collectionData[0]['DestinationPort'];
				$status = $collectionData[0]['collectionStatus'];
				$consignee = $collectionData[0]['Consignee'];
				$delivertoconsignee = $collectionData[0]['DeliverToConsignee'];
				$userid = $collectionData[0]['AddedBy'];
				$updatedby = $collectionData[0]['UpdatedBy'];
				$updateddate = $collectionData[0]['UpdatedDate'];
			}
		}
		if ($userid != '') {
			$username = $userTable->get($userid)->username;
		}
		if ($updatedby != 0) {
			$updatedby = $userTable->get($updatedby)->username;
		}
		$this->set('username', $username);
		$this->set('updatedby', $updatedby);
		$this->set('updateddate', $updateddate);
		$this->set('collectiondate', $collectionDate);
		$this->set('shipper', $shipper);
		$this->set('transportmode', $transportmode);
		$this->set('containerref', $containerref);
		$this->set('deliveryterms', $deliveryterms);
		$this->set('termstext', $termstext);
		$this->set('destport', $destport);
		$this->set('collectionID', $collectionID);
		$this->set('status', $status);
		$this->set('consignee', $consignee);
		$this->set('delivertoconsignee', $delivertoconsignee);
	}
		
	public function edit() {
    	
    $this->viewBuilder()->setLayout('savoir');
	$exportTable = TableRegistry::get('ExportCollections');
	
	if ($this->request->is('post')) {
			$userId = $this->getCurrentUsersId();
			//$this->set('userId', $userId );
			$formData = $this->request->getData();
			$collectionid=$formData['collectionID'];			
			$exportcoll = $exportTable->find('all', array('conditions'=> array('exportCollectionsID' => $collectionid)));
    		$exportcoll = $exportcoll->toArray()[0];			

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
			if ($formData['status'] !='n') {
				$exportcoll->collectionStatus = $formData['status'];
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
			$exportcoll->UpdatedDate = new FrozenTime();
			$exportcoll->UpdatedBy = $userId;
			
			if ($exportTable->save($exportcoll)) {
				$collectionID = $exportcoll->exportCollectionsID;
			}
			$colShowTable = TableRegistry::get('ExportCollShowroom');
			
			//$colShowTable->deleteIDs($collectionid);
			
			foreach ($formData as $key=>$val) {
				$collshowroom=null;
				if (substr($key,0,2)==='YY' && $formData[$key] != '') {
					$lid=substr($key,2);
					$collshowroom = $colShowTable->find()->where(['exportCollectionID' => $collectionid, 'idLocation' => $lid])->first();
					if ($collshowroom == null) {
						$collshowroom = $colShowTable->newEntity([]);				
						$collshowroom->exportCollectionID = $collectionID;
						$collshowroom->idLocation = $lid;
					}
					$etadate=$this->_getSTRtoDateObject($formData[$key])->i18nFormat('yyyy-MM-dd');
					$collshowroom->ETAdate = $etadate;
				   
					if ($collshowroom != null) $colShowTable->save($collshowroom);
				}
	
			}
			$this->Flash->success("Collection amended");
			$this->redirect(array('controller' => 'EditCollection', 'action' => 'index?collectionid='.$collectionID));
		}
	}	
	
	public function remove() {
		$this->autoRender = false;
		$this->viewBuilder()->setLayout('ajax');
		if (!$this->request->is('get')) {
			echo json_encode(['success'=>false]);
			return;
		}
		
		$params = $this->request->getParam('?');
		$location=$params['locid'];
		$collectionid=$params['collectionid'];
		$colShowTable = TableRegistry::get('ExportCollShowroom');
		$response = $colShowTable->removeCollection($collectionid, $location);
		echo json_encode(['success' => true, 'data' => $response]);
	}
		
	private function _getSTRtoDateObject($str) {
		$time = FrozenTime::createFromFormat('d/m/Y', $str, 'Europe/London');
		return $time;
	}
		
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR","SAVOIRSTAFF");
	}

}

?>
