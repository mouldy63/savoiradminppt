<?php
namespace App\Controller;

class VappFieldsController extends AppController {
    public $helpers = array('Html', 'Form');

	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Session');
		$this->loadModel('Purchase');
		$this->loadModel('Location');
		$this->loadModel('Contact');
		$this->loadModel('Address');
		$this->loadModel('ProductionSizes');
		$this->loadModel('Wrappingtypes');
		$this->loadModel('Accessory');
		$this->loadModel('QcHistoryLatest');
		$this->loadModel('BayContent');
		
	}
    
	public function index() {
        $this->viewBuilder()->setLayout('ajax');
    }


}
?>