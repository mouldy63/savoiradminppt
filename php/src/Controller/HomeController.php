<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;

class HomeController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		set_time_limit(120);
		$this->loadModel('Purchase');
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
		$this->viewBuilder()->setLayout('savoirspryassets');
		
		$communications = TableRegistry::get('Communication');
		$location = TableRegistry::get('Location');
		$ordernote = TableRegistry::get('OrderNote');
		$getidlocation = $this->getCurrentUserLocationId();
		$savoirowned = $location->getSavoirowned($this);
		$username = $this->SavoirSecurity->getCurrentUserName();
		$outstandingbalances = $communications->getOutstandingBalances($this);
		$totaloutstandingbalance = $communications->getTotalOutstandingBalance($this);
		$outstandingtasks= $ordernote->getOutstandingTasks($this, $username);
		$customernotes= $ordernote->getCustomerNotes($this, $username);

		$this->set('outstandingbalances', $outstandingbalances);
		$this->set('totaloutstandingbalance', $totaloutstandingbalance);
		$this->set('getidlocation', $getidlocation);
		$this->set('savoirowned', $savoirowned);
		$this->set('outstandingtasks', $outstandingtasks);
		$this->set('customernotes', $customernotes);
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
		//$this->Flash->success("Quotes amended successfully");
		//$this->redirect(array('controller' => 'Quotes', 'action' => 'index'));
    }
    
    public function closeordernote()
    {
    $ordernote = TableRegistry::get('OrderNote');
    $ordernoteID=$this->request->getQuery('close');
    $commstatus = 'Completed';
    $username = $this->SavoirSecurity->getCurrentUserName();
    
    $ordernote->closeOrderNote($ordernoteID,$username);
    $this->Flash->success($ordernoteID." successfully closed");
	$this->redirect(array('controller' => 'Home', 'action' => 'index'));
    }
    
    public function changetaskdate()
    {
    $communications = TableRegistry::get('Communication');
    $communicationID=$this->request->getQuery('correschange');
    $taskdate=$this->request->getQuery('dtdate');
    
    $communications->changeTaskDate($communicationID,$taskdate);
    $this->Flash->success("Customer note date successfully changed");
	$this->redirect(array('controller' => 'Home', 'action' => 'index'));
    }
    
    public function changenotedate()
    {
    $ordernote = TableRegistry::get('OrderNote');
    $purchaseTable = TableRegistry::get('Purchase');
    $ordernoteID=$this->request->getQuery('dtchange');
    $pn=$this->request->getQuery('pn');
    $notedate=$this->request->getQuery('dtdate');
    $query = $this->Purchase->find()->where(['PURCHASE_No' => $pn]);
		foreach ($query as $row) {
			$purchase = $row;
		}
		$ordernumber = $purchase['ORDER_NUMBER'];

    $ordernote->changeNoteDate($ordernoteID,$notedate);
    $this->Flash->success($ordernumber." order note date successfully changed");
	$this->redirect(array('controller' => 'Home', 'action' => 'index'));
    }
    
    
    public function closecustomernote()
	{
	$communications = TableRegistry::get('Communication');
	$communicationID=$this->request->getQuery('corrclose');
	$response=$this->request->getQuery('name');
	$staff = $this->SavoirSecurity->getCurrentUserName();
	
	$communications->closecustomernote($communicationID,$staff,$response);
	$this->Flash->success($communicationID." successfully closed");
	$this->redirect(array('controller' => 'Home', 'action' => 'index'));
	}
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR","SALES","REGIONAL_ADMINISTRATOR","WEBSITEADMIN"];
	}
    
}

?>