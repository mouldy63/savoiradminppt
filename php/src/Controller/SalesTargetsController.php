<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;

class SalesTargetsController extends SecureAppController {

    public function initialize() : void {
        parent::initialize();
        $this->loadModel('Location');
        $this->loadModel('SaleFigureTarget');
    }
    
    public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
    	$builder->addHelpers([
        	'MyForm'
        ]);
    }
    
  public function index() {
		$this->viewBuilder()->setLayout('savoirdatatables');
		$now = date('d-m-Y');
		$currentyear = date("Y",strtotime($now));		
		$year=$currentyear;
		$params = $this->request->getParam('?');
		if ($params != '') {
			$year = $params['year'];
		}
		$showrooms = $this->Location->find('all', ['conditions'=> ['retire' => 'n', 'SavoirOwned' => 'y'], 'order' => ['location' => 'asc']]);
		$dealers = $this->Location->find('all', ['conditions'=> ['retire' => 'n', 'SavoirOwned' => 'n'], 'order' => ['location' => 'asc']]);
		
		$showroomTargets = [];
        foreach ($showrooms as $showroom) {
            $targetDataForYear = $this->SaleFigureTarget->getTargetDataForLocationAndYear($showroom['idlocation'], $year);
            $temp = [];
            $temp['name'] = $showroom['location'];
            $temp['currency'] = $showroom['currency'];
            $temp['idlocation'] = $showroom['idlocation'];
            $temp['targets'] = $targetDataForYear;
            $showroomTargets[$showroom['idlocation']] = $temp;
        }
        
        $dealerTargets = [];
        foreach ($dealers as $dealer) {
            $targetDataForYear = $this->SaleFigureTarget->getTargetDataForLocationAndYear($dealer['idlocation'], $year);
            $temp = [];
            $temp['name'] = $dealer['location'];
            $temp['currency'] = $dealer['currency'];
            $temp['idlocation'] = $dealer['idlocation'];
            $temp['targets'] = $targetDataForYear;
            $dealerTargets[$dealer['idlocation']] = $temp;
        }
		
		$this->set('showroomTargets', $showroomTargets);
		$this->set('dealerTargets', $dealerTargets);
		//debug($showroomTargets);
		//die;
		$this->set('showrooms', $showrooms);
		$this->set('dealers', $dealers);
		$this->set('year', $year);
    }
    
    public function edit()
    {
    if (!$this->request->is('post')) {
			$this->Flash->error("Invalid call to edit");
			$this->redirect(array('controller' => 'SalesTargets', 'action' => 'index'));
			return;
    	}
    	$formData = $this->request->getData();
    	$showrooms = $this->Location->find('all', ['conditions'=> ['retire' => 'n', 'SavoirOwned' => 'y'], 'order' => ['location' => 'asc']]);
		foreach ($showrooms as $showroom) {
		//$jan=0;
			$year = $formData['year'];
			$location=$showroom['idlocation'];
			for ($i=1; $i < 13; $i++) {
				$targetamount  = $formData["T_".$location."_".$i];
			//debug($targetamount);
			//die;
				$target = $this->SaleFigureTarget->find('all', array('conditions'=> array('year(target_date) =' => $year, 'month(target_date) =' => $i, 'idlocation' => $location)))->toArray();
		 
				if (count($target) == 0) {
					$settarget = $this->SaleFigureTarget->newEntity([]);
					$settarget->idlocation = $location;
					$settarget->target_amount = $targetamount;
					$settarget->target_date = $year."-".$i."-15";
				} else {
					$settarget = $target[0];
				}
				if (!isset($targetamount)) {
					$targetamount=0;
				};
				$settarget->target_amount = floatval($targetamount);
			
				$this->SaleFigureTarget->save($settarget);
			}  //end for
    	} //end for each
    	
    	$dealers = $this->Location->find('all', ['conditions'=> ['retire' => 'n', 'SavoirOwned' => 'n'], 'order' => ['location' => 'asc']]);
		foreach ($dealers as $dealer) {
		//$jan=0;
			$year = $formData['year'];
			$location=$dealer['idlocation'];
			for ($i=1; $i < 13; $i++) {
			$targetamount  = $formData["T_".$location."_".$i];
			//debug($targetamount);
			//die;
				$target = $this->SaleFigureTarget->find('all', array('conditions'=> array('year(target_date) =' => $year, 'month(target_date) =' => $i, 'idlocation' => $location)))->toArray();
		
				if (count($target) == 0) {
				
					$settarget = $this->SaleFigureTarget->newEntity([]);
					$settarget->idlocation = $location;
					$settarget->target_amount = $targetamount;
					$settarget->target_date = $year."-".$i."-15";
				} else {
					$settarget = $target[0];
				}
				if (!isset($targetamount)) {
					$targetamount=0;
				};
				$settarget->target_amount = floatval($targetamount);
			
				$this->SaleFigureTarget->save($settarget);
			}  // end for
		} //end for each
    	
    	$this->Flash->success("Exchange rates updated successfully");
		$this->redirect(array('controller' => 'SalesTargets', 'action' => 'index?year='.$year.''));
		
    }
    
    protected function _getAllowedRoles(){
        return ["ADMINISTRATOR"];
    }
    protected function _isSuperuserOnly(){
        return true;
    }
    
}