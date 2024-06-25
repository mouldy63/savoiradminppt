<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;

class PricingMatrixController extends SecureAppController {
	public function initialize() : void {
		parent::initialize();
		set_time_limit(120);
		$this->loadModel('PriceMatrix');
    }
	
	public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
    	$builder->addHelpers([
        	'AuxiliaryData'
        ]);
    }
	
    public function index() {
		$this->viewBuilder()->setLayout('savoirdatatablesprodlist');
		
		$pmatrixTable = TableRegistry::get('PriceMatrix');
		
		$comp='';
		$params = $this->request->getParam('?');
		if ($params != '') {
			$comp = $params['comp'];
		}
		//debug($comp);
		//die;
		
		$pmatrix = $pmatrixTable->getFullTableForExportbyComp($comp);
		//debug($pmatrix);
		//die;
		$this->set('pmatrix', $pmatrix);
		$this->set('comp', $comp);
	}
	
	public function add() {
    
		$this->viewBuilder()->setLayout('savoirdatatables');
		$pmTypeTable = TableRegistry::get('PriceMatrixType');
		$compTable = TableRegistry::get('Component');
		$pmatrixType = $pmTypeTable->getCompTypeName($this);
		$component = $compTable->getComponentData($this);
		//debug($component);
		//die;
		$this->set('pmatrixType', $pmatrixType);
		$this->set('component', $component);
	
		if ($this->request->is('post')) {
			$formData = $this->request->getData();
			$pmdetails = $this->PriceMatrix->newEntity([]);
			

			if ($formData['pricetype'] !='n') {
				$pmdetails->PRICE_TYPE_ID = $formData['pricetype'];
			}
			if ($formData['comp'] !='n') {
				$pmdetails->COMPONENTID = $formData['comp'];
			}
			if ($formData['setcomp1'] !='n') {
				$pmdetails->COMPID_SET1 = $formData['setcomp1'];
			}
			if ($formData['setcomp2'] !='n') {
				$pmdetails->COMPID_SET2 = $formData['setcomp2'];
			}
			if ($formData['dim1'] !='') {
				$pmdetails->DIM1 = $formData['dim1'];
			}
			if ($formData['dim2'] !='') {
				$pmdetails->DIM2 = $formData['dim2'];
			}
			if ($formData['RGBP'] !='') {
				$pmdetails->GBP = $formData['RGBP'];
			}
			if ($formData['RGBP'] !='') {
				$pmdetails->GBP = $formData['RGBP'];
			}
			if ($formData['RUSD'] !='') {
				$pmdetails->USD = $formData['RUSD'];
			}
			if ($formData['REUR'] !='') {
				$pmdetails->EUR = $formData['REUR'];
			}
			if ($formData['WGBP'] !='') {
				$pmdetails->GBP_WHOLESALE = $formData['WGBP'];
			}
			if ($formData['WUSD'] !='') {
				$pmdetails->USD_WHOLESALE = $formData['WUSD'];
			}
			if ($formData['WEUR'] !='') {
				$pmdetails->EUR_WHOLESALE = $formData['WEUR'];
			}
			if ($formData['EXWR'] !='') {
				$pmdetails->EX_WORKS_REVENUE = $formData['EXWR'];
			}
			if ($this->PriceMatrix->save($pmdetails)) {
   				 //$projectid = $projectdetails->ID;
			}

			$this->Flash->success("New price matrix item added");
			$this->redirect(array('controller' => 'PricingMatrix', 'action' => 'index'));
		}
	}
	
	public function edit() {
    	if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'PricingMatrix', 'action' => 'index'));
			return;
    	}
    	
    	$this->viewBuilder()->setLayout('savoirdatatables');
    	
		$formData = $this->request->getData();
		$pmTable = TableRegistry::get('PriceMatrix');
		
		foreach ($formData as $key=>$val) {
			$stub = substr($key,0,4);
			if ($stub == 'RGBP') {
				$id=substr($key,4);
				$row = $pmTable->get($id);
				
				$itmVal = $formData['RGBP'.$id];
				if (!empty($itmVal)) {
					$row->GBP = floatval($itmVal);
				} else {
					$row->GBP = null;
				}
		
				$itmVal = $formData['RUSD'.$id];
				if (!empty($itmVal)) {
					$row->USD = floatval($itmVal);
				} else {
					$row->USD = null;
				}
		
				$itmVal = $formData['REUR'.$id];
				if (!empty($itmVal)) {
					$row->EUR = floatval($itmVal);
				} else {
					$row->EUR = null;
				}

				$itmVal = $formData['WGBP'.$id];
				if (!empty($itmVal)) {
					$row->GBP_WHOLESALE = floatval($itmVal);
				} else {
					$row->GBP_WHOLESALE = null;
				}
		
				$itmVal = $formData['WUSD'.$id];
				if (!empty($itmVal)) {
					$row->USD_WHOLESALE = floatval($itmVal);
				} else {
					$row->USD_WHOLESALE = null;
				}

				$itmVal = $formData['WEUR'.$id];
				if (!empty($itmVal)) {
					$row->EUR_WHOLESALE = floatval($itmVal);
				} else {
					$row->EUR_WHOLESALE = null;
				}

				if (isset($formData['EXWR'.$id])) {
					$itmVal = $formData['EXWR'.$id];
					if (!empty($itmVal)) {
						$row->EX_WORKS_REVENUE = floatval($itmVal);
					} else {
						$row->EX_WORKS_REVENUE = null;
					}
				}
				
				if (isset($formData['DELE'.$id])) {
					$pmTable->delete($row);
				} else {
					$pmTable->save($row);
				}
			}
		}
		$comp='';
		if (isset($formData['comp'])) {
			$comp = $formData['comp'];
		}
		$this->Flash->success("Pricing Matrix amended successfully");
		$this->redirect(array('controller' => 'PricingMatrix/index?comp='.$comp, 'action' => 'index'));
    }
    
    public function copy() {
    
    	$this->viewBuilder()->setLayout('savoirdatatables');
    	
		$formData = $this->request->getData();
		$pmTable = TableRegistry::get('PriceMatrix');
		foreach ($formData as $key=>$val) {
			$factor=$formData['adjustment'];
			$stub = substr($key,0,4);
			if ($stub == 'RGBP') {
				$id=substr($key,4);
				$row = $pmTable->get($id);

				$itmVal = $formData['RGBP'.$id];
				if (!empty($itmVal)) {
					$newval=floatval($itmVal)/floatval($factor);
					$row->GBP_WHOLESALE = floatval($newval);
				} else {
					$row->GBP_WHOLESALE = null;
				}
				
				$itmVal = $formData['RUSD'.$id];
				if (!empty($itmVal)) {
					$newval=floatval($itmVal)/floatval($factor);
					$row->USD_WHOLESALE = floatval($itmVal);
				} else {
					$row->USD_WHOLESALE = null;
				}
				
				$itmVal = $formData['REUR'.$id];
				if (!empty($itmVal)) {
					$newval=floatval($itmVal)/floatval($factor);
					$row->EUR_WHOLESALE = floatval($itmVal);
				} else {
					$row->EUR_WHOLESALE = null;
				}
		
				
					$pmTable->save($row);
			}
		}
		
		$this->Flash->success("Pricing Matrix retail rows copied to wholesale successfully");
		$this->redirect(array('controller' => 'PricingMatrix/', 'action' => 'index'));
	}
		
	public function copyex() {
    
    	$this->viewBuilder()->setLayout('savoirdatatables');
    	
		$formData = $this->request->getData();
		$pmTable = TableRegistry::get('PriceMatrix');
		foreach ($formData as $key=>$val) {
			$factor=$formData['adjustment'];
			$stub = substr($key,0,4);
			if ($stub == 'RGBP') {
				$id=substr($key,4);
				$row = $pmTable->get($id);

				$itmVal = $formData['WGBP'.$id];
				if (!empty($itmVal)) {
					$newval=floatval($itmVal);
					$row->EX_WORKS_REVENUE = floatval($newval);
				} else {
					$row->EX_WORKS_REVENUE = null;
				}
				$pmTable->save($row);
			}
		}
		
		$this->Flash->success("Pricing Matrix wholesale rows copied to ex works successfully");
		$this->redirect(array('controller' => 'PricingMatrix/', 'action' => 'index'));
	}
    
	
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR"];
	}
    
}

?>