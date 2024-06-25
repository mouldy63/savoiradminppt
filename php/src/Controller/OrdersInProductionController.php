<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;
use Cake\Event\EventInterface;

class OrdersInProductionController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
    }
	
	public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
    	$builder->addHelpers([
        	'OrderFuncs'
        ]);
    }

    public function index() {
		$this->viewBuilder()->setLayout('savoir');
		
		$orders = TableRegistry::get('Ordersinproduction');
		$sortorder="";
		if (null !== $this->request->getQuery('sortorder')) {
			$sortorder=$this->request->getQuery('sortorder');
		}
		$ordersinproduction = $orders->getOrdersInProduction($sortorder);
		//debug($ordersinproduction);
		//die;
		$this->set('ordersinproduction', $ordersinproduction);
		
	}
	

	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR"];
	}
    
}

?>