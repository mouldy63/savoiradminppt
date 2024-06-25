<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;

class QuotesController extends SecureAppController
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
		
		$ordersquotes = TableRegistry::get('Quotes');
		$quotes = $ordersquotes->getQuotes($this);
		$this->set('quotes', $quotes);
		//debug($heldorders);
		//die();
		
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
				$purchase->quote = 'd';
				$datedeclined='';
				if (!empty(trim($formData['datequotedeclined']))) {
					$datedeclined=UtilityComponent::makeMysqlDateStringFromDisplayString($formData['datequotedeclined']);
					$purchase->datequotedeclined = $datedeclined;
				}
				if (!empty(trim($formData['reasonquotedeclined']))) {
					$purchase->reasonquotedeclined = trim($formData['reasonquotedeclined']);
				}
				$purchaseTable->save($purchase);
			}
		}
		$this->Flash->success("Quotes amended successfully");
		$this->redirect(array('controller' => 'Quotes', 'action' => 'index'));
    }
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR","SALES","REGIONAL_ADMINISTRATOR"];
	}
    
}

?>