<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;

class HeldOrdersController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		set_time_limit(120);
		$this->loadModel('Purchase');
		$this->loadModel('Location');
		$this->loadModel('Contact');
		$this->loadModel('Address');
		$this->loadModel('ProductionSizes');
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
		
		$ordersonhold = TableRegistry::get('HeldOrders');
		$heldorders = $ordersonhold->getHeldOrders($this);
		$this->set('heldorders', $heldorders);
		//debug($heldorders);
		//die();
		
	}
	
	public function submitOrder() {
		
		if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'HeldOrders', 'action' => 'index'));
			return;
    	}
    	
    	$formData = $this->request->getData();
		$recipientorders='';
		foreach ($formData as $key=>$val) {
			//debug($key);
			if (substr($key,0,3)==='XX_') {
				$pn=substr($key,3);
				$purchase = $this->Purchase->get($pn);
				$contact = $this->Contact->get($purchase->contact_no);
				$address = $this->Address->get($contact->CODE);
				$purchase->orderonhold = 'n';
				$recipientorders.= $pn." ";
				$this->Purchase->save($purchase);
				$orderno=$purchase['ORDER_NUMBER'];
				$client='';
				if ($contact['title'] != '') {
					$client .= $contact['title'];
				}
				if ($contact['first'] != '') {
					$client .= $contact['first'];
				}
				if ($contact['title'] != '') {
					$client .= $contact['surname'];
				}
				$company='';
				if ($address['company'] != '') {
					$company .= $address['company'];
				}
				$total=$purchase['total'];
				$orderdate=$purchase['ORDER_DATE'];
				
				
				$to='SavoirAdminNewOrder@savoirbeds.co.uk';
				$cc='';
				$from='noreply@savoirbeds.co.uk';
				$fromName='';
				$subject=$orderno.' - HELD ORDER CONFIRMED - '.$client;
				$content = "<html><body><font face='Arial, Helvetica, sans-serif'>This auto generated email has been sent to the distribution group called SavoirAdminNewOrder@savoirbeds.co.uk and confirms the following new order no. ".$orderno.".<br /><br /><b>Customer</b>: ";
				$content .= $client;
				if ($company != '') {
					$content .= "<BR>Company: ".$company;
				}
				$content .= "<BR>Order date: ".$orderdate;
				$content .= "<BR>Order Total: ".$total;
				$emailServices = new EmailServicesController;
				$emailServices->generateBatchEmail($to, $cc, $from, $fromName, $subject, $content, 'html', null);
			}
		}
		$this->Flash->success("Held order no ".$orderno." converted successfully");
		$this->redirect(array('controller' => 'HeldOrders', 'action' => 'index'));
		
	}
	
	
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR","SALES","REGIONAL_ADMINISTRATOR"];
	}
    
}

?>