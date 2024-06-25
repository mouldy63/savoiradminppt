<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class PackagingDataController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
				
		$packagingTable = TableRegistry::get('Componentdata');
		$shippingBoxTable = TableRegistry::get('shippingbox');
		
		
		
		
		$packagingdata = $packagingTable->listComponentData();
		$smallbox = $shippingBoxTable->getSmallBoxData();
		$mediumbox = $shippingBoxTable->getMediumBoxData();
		$largebox = $shippingBoxTable->getLargeBoxData();
		$legbox = $shippingBoxTable->getLegBoxData();
		$woodcrate = $shippingBoxTable->getWoodCrateData();
		$internalcrate = $shippingBoxTable->getInternalCrateData();
		$additionalcrate = $shippingBoxTable->getAdditionalCrateData();
		$roundtonearest = $shippingBoxTable->getRoundToNearestData();
		$hcatopper = $shippingBoxTable->getHCAData();
		$statehcatopper = $shippingBoxTable->getStateHCAData();
		$hwtopper = $shippingBoxTable->getHWData();
		$cwtopper = $shippingBoxTable->getCWData();
		$expakmb = $shippingBoxTable->getExpakMBData();
		$expakt = $shippingBoxTable->getExpakTData();
		$expak1m = $shippingBoxTable->getExpak1MData();
		$expakh = $shippingBoxTable->getExpakHData();
		
		//debug($smallbox);
		//die;
		$this->set('packagingdata', $packagingdata);
		$this->set('smallbox', $smallbox[0]);
		$this->set('mediumbox', $mediumbox[0]);
		$this->set('largebox', $largebox[0]);
		$this->set('legbox', $legbox[0]);
		$this->set('woodcrate', $woodcrate[0]);
		$this->set('internalcrate', $internalcrate[0]);
		$this->set('additionalcrate', $additionalcrate[0]);
		$this->set('roundtonearest', $roundtonearest[0]);
		$this->set('hcatopper', $hcatopper[0]);
		$this->set('statehcatopper', $statehcatopper[0]);
		$this->set('hwtopper', $hwtopper[0]);
		$this->set('cwtopper', $cwtopper[0]);
		$this->set('expakmb', $expakmb[0]);
		$this->set('expakt', $expakt[0]);
		$this->set('expak1m', $expak1m[0]);
		$this->set('expakh', $expakh[0]);

	}
	public function edit()
    {
    	if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'PackagingData', 'action' => 'index'));
			return;
    	}
    	
    	$this->viewBuilder()->setLayout('savoir');
    	
    	//debug($this->request->getData());
		$formData = $this->request->getData();
		$shippingBoxTable = TableRegistry::get('shippingbox');
		$shippingboxid = $formData['shippingBoxID'];
		//debug($shippingboxid);
		//die();
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $shippingboxid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		//debug($shippingboxdata);
		//die();
		$shippingboxdata->Width = trim($formData['widthS']);
		$shippingboxdata->Length = trim($formData['lengthS']);
		$shippingboxdata->Weight = trim($formData['weightS']);
		$shippingboxdata->Depth = trim($formData['depthS']);
		$shippingboxdata->PackAllowanceWidth = trim($formData['packwidthS']);
		$shippingboxdata->PackAllowanceLength = trim($formData['packlengthS']);
		$shippingBoxTable->save($shippingboxdata);
		
		$mediumshippingboxid = $formData['mediumshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $mediumshippingboxid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->Width = trim($formData['widthM']);
		$shippingboxdata->Length = trim($formData['lengthM']);
		$shippingboxdata->Weight = trim($formData['weightM']);
		$shippingboxdata->Depth = trim($formData['depthM']);
		$shippingboxdata->PackAllowanceWidth = trim($formData['packwidthM']);
		$shippingboxdata->PackAllowanceLength = trim($formData['packlengthM']);
		$shippingBoxTable->save($shippingboxdata);
		
		$largeshippingboxid = $formData['largeshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $largeshippingboxid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->Width = trim($formData['widthL']);
		$shippingboxdata->Length = trim($formData['lengthL']);
		$shippingboxdata->Weight = trim($formData['weightL']);
		$shippingboxdata->Depth = trim($formData['depthL']);
		$shippingboxdata->PackAllowanceWidth = trim($formData['packwidthL']);
		$shippingboxdata->PackAllowanceLength = trim($formData['packlengthL']);
		$shippingBoxTable->save($shippingboxdata);
		
		$legshippingboxid = $formData['legshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $legshippingboxid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->Width = trim($formData['widthLB']);
		$shippingboxdata->Height = trim($formData['heightLB']);
		$shippingboxdata->Depth = trim($formData['depthLB']);
		$shippingBoxTable->save($shippingboxdata);
		
		$woodcrateshippingboxid = $formData['woodcrateshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $woodcrateshippingboxid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->Weight = trim($formData['woodencrates']);
		$shippingBoxTable->save($shippingboxdata);
		
		$internalcrateshippingboxid = $formData['internalcrateshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $internalcrateshippingboxid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->Allowance = trim($formData['internalcrate']);
		$shippingBoxTable->save($shippingboxdata);
		
		$additionalcrateshippingboxid = $formData['additionalcrateshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $additionalcrateshippingboxid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->Allowance = trim($formData['additionalcrate']);
		$shippingBoxTable->save($shippingboxdata);

		$roundtonearestid = $formData['roundcrateshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $roundtonearestid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->RoundToNearest = trim($formData['roundtonearest']);
		$shippingBoxTable->save($shippingboxdata);
		
		$hcatopperid = $formData['hcashippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $hcatopperid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->Allowance = trim($formData['hca']);
		$shippingBoxTable->save($shippingboxdata);
		
		$statehcatopperid = $formData['statehcashippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $statehcatopperid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->Allowance = trim($formData['statehca']);
		$shippingBoxTable->save($shippingboxdata);
		
		$hwtopperid = $formData['hwshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $hwtopperid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->Allowance = trim($formData['hw']);
		$shippingBoxTable->save($shippingboxdata);

		$cwtopperid = $formData['cwshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $cwtopperid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->Allowance = trim($formData['cw']);
		$shippingBoxTable->save($shippingboxdata);
		
		$expakmbid = $formData['expakmbshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $expakmbid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->InternalLength = trim($formData['internalLengthExpakMB']);
		$shippingboxdata->InternalWidth = trim($formData['internalWidthExpakMB']);
		$shippingboxdata->InternalHeight = trim($formData['internalHeightExpakMB']);
		$shippingboxdata->Length = trim($formData['lengthExpakMB']);
		$shippingboxdata->Width = trim($formData['widthExpakMB']);
		$shippingboxdata->Height = trim($formData['heightExpakMB']);
		$shippingboxdata->Weight = trim($formData['weightExpakMB']);
		$shippingBoxTable->save($shippingboxdata);
		
		$expaktid = $formData['expaktshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $expaktid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->InternalLength = trim($formData['internalLengthExpakT']);
		$shippingboxdata->InternalWidth = trim($formData['internalWidthExpakT']);
		$shippingboxdata->InternalHeight = trim($formData['internalHeightExpakT']);
		$shippingboxdata->Length = trim($formData['lengthExpakT']);
		$shippingboxdata->Width = trim($formData['widthExpakT']);
		$shippingboxdata->Height = trim($formData['heightExpakT']);
		$shippingboxdata->Weight = trim($formData['weightExpakT']);
		$shippingBoxTable->save($shippingboxdata);
		
		$expak1mid = $formData['expak1mshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $expak1mid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->InternalLength = trim($formData['internalLengthExpak1M']);
		$shippingboxdata->InternalWidth = trim($formData['internalWidthExpak1M']);
		$shippingboxdata->InternalHeight = trim($formData['internalHeightExpak1M']);
		$shippingboxdata->Length = trim($formData['lengthExpak1M']);
		$shippingboxdata->Width = trim($formData['widthExpak1M']);
		$shippingboxdata->Height = trim($formData['heightExpak1M']);
		$shippingboxdata->Weight = trim($formData['weightExpak1M']);
		$shippingBoxTable->save($shippingboxdata);
		
		$expakhid = $formData['expakhshippingBoxID'];
		$shippingboxdata = $shippingBoxTable->find('all', array('conditions'=> array('ShippingBoxID' => $expakhid)));
    	$shippingboxdata = $shippingboxdata->toArray()[0];
		$shippingboxdata->InternalLength = trim($formData['internalLengthExpakH']);
		$shippingboxdata->InternalWidth = trim($formData['internalWidthExpakH']);
		$shippingboxdata->InternalHeight = trim($formData['internalHeightExpakH']);
		$shippingboxdata->Length = trim($formData['lengthExpakH']);
		$shippingboxdata->Width = trim($formData['widthExpakH']);
		$shippingboxdata->Height = trim($formData['heightExpakH']);
		$shippingboxdata->Weight = trim($formData['weightExpakH']);
		$shippingBoxTable->save($shippingboxdata);


		$this->Flash->success("Shipping data amended successfully");
		$this->redirect(['action' => 'index', '?' => ['lid' => $shippingboxid]]);

	}
	
	public function add()
    {
		$this->viewBuilder()->setLayout('savoir');
		
			$componentdataTable = TableRegistry::get('Componentdata');
			$componentlist = $componentdataTable->getComponentList();
			$this->set('componentlist', $componentlist);
    }
	
	public function doadd()
    {
		$this->viewBuilder()->setLayout('savoir');
		if ($this->request->is('post')) {
			
			$formData = $this->request->getData();
			$componentdataTable = TableRegistry::get('Componentdata');
			$addcomponent = $componentdataTable->newEntity([]);
			$addcomponent->COMPONENTID = trim($formData['component']);
			$addcomponent->COMPONENTNAME = trim($formData['productname']);
			$addcomponent->WEIGHT = trim($formData['weight']);
			$addcomponent->TARIFFCODE = trim($formData['tariff']);
			$addcomponent->DEPTH = trim($formData['depth']);
			$componentdataTable->save($addcomponent);
			$this->Flash->success("Component added successfully");
			$this->redirect(array('controller' => 'packagingdata', 'action' => 'index'));
		}
	}
	
	
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR");
	}

}

?>