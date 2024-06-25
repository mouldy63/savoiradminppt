<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;

class DeclinedQuotesController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		set_time_limit(120);
    }
	
	public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
    	$builder->addHelpers([
        	'OrderFuncs',
        	'AuxiliaryData'
        ]);
    }

    public function index() {
		$this->viewBuilder()->setLayout('savoir');
		
		$quotes = TableRegistry::get('Quotes');
		$declinedquotes = $quotes->getDeclinedQuotes($this);
		$this->set('declinedquotes', $declinedquotes);
		
	}
	
	public function edit()
    {
    	if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'Quotes', 'action' => 'index'));
			return;
    	}
    	
    	$this->viewBuilder()->setLayout('savoir');
    	
		$formData = $this->request->getData();
		$purchaseTable = TableRegistry::get('Purchase');
		foreach ($formData as $key=>$val) {
			//debug($key);
			if (substr($key,0,3)==='XX_') {
				$pn=substr($key,3);
				$purchase = $purchaseTable->get($pn);
				$purchase->quote = 'y';
				$datereinstated='';
				$datereinstated=date("Y-m-d H:i:s");
				$purchase->datereinstated = $datereinstated;
				$purchaseTable->save($purchase);
			}
		}
		$this->Flash->success("Quotes reinstated successfully");
		$this->redirect(array('controller' => 'DeclinedQuotes', 'action' => 'index'));
    }
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR","SALES","REGIONAL_ADMINISTRATOR"];
	}
    
}

?>