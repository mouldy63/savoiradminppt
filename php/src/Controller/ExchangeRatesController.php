<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class ExchangeRatesController extends SecureAppController {

    public function initialize() : void {
        parent::initialize();
        $this->loadModel('SaleFigureExchangeRate');
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
		$rates=[];
		for ($m=1; $m < 13; $m++) {
			$rates['USD'][$m] = $this->SaleFigureExchangeRate->getExchangeRate($year, $m, 'USD');
			$rates['EUR'][$m] = $this->SaleFigureExchangeRate->getExchangeRate($year, $m, 'EUR');
		}
		$this->set('rates', $rates);
		$this->set('year', $year);
    }
    
    public function edit()
    {
    	if (!$this->request->is('post')) {
			$this->Flash->error("Invalid call to edit");
			$this->redirect(array('controller' => 'ExchangeRates', 'action' => 'index'));
			return;
    	}
		$formData = $this->request->getData();
		//$jan=0;
		$year = $formData['year'];
		for ($i=1; $i < 13; $i++) {
			$usd  = $formData['USD'.$i];
			$excRateRs = $this->SaleFigureExchangeRate->find('all', array('conditions'=> array('year(time) =' => $year, 'month(time) =' => $i, 'currency_code' => 'USD')))->toArray();
    	 
			if (count($excRateRs) == 0) {
				$exchrate = $this->SaleFigureExchangeRate->newEntity([]);
				$exchrate->currency_code = 'USD';
				$exchrate->time = $year."-".$i."-15";
			} else {
				$exchrate = $excRateRs[0];
			}
			$exchrate->exchange_rate = floatval($usd);
			
			$this->SaleFigureExchangeRate->save($exchrate);
    	}
    	
    	for ($i=1; $i < 13; $i++) {
			$eur  = $formData['EUR'.$i];
			$excRateRs = $this->SaleFigureExchangeRate->find('all', array('conditions'=> array('year(time) =' => $year, 'month(time) =' => $i, 'currency_code' => 'EUR')))->toArray();
    	 
			if (count($excRateRs) == 0) {
				$exchrate = $this->SaleFigureExchangeRate->newEntity([]);
				$exchrate->currency_code = 'EUR';
				$exchrate->time = $year."-".$i."-15";
			} else {
				$exchrate = $excRateRs[0];
			}
			$exchrate->exchange_rate = floatval($eur);
			
			$this->SaleFigureExchangeRate->save($exchrate);
    	}
		
		$this->Flash->success("Exchange rates updated successfully");
		$this->redirect(array('controller' => 'ExchangeRates', 'action' => 'index?year='.$year.''));
		
    }
    
    protected function _getAllowedRoles(){
        return ["ADMINISTRATOR"];
    }
}