<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;

class AwaitingOrdersController extends SecureAppController

{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
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
		
		$showrooms = TableRegistry::get('Location');
		if ($this->_userHasRole("ADMINISTRATOR") || $this->isSuperuser()) {
			$activeshowrooms = $showrooms->getActiveShowrooms();
			$showroom='all';
		} else {
			$activeshowrooms = $showrooms->getBuddyShowrooms($this->getCurrentUserLocationId());
			$showroom=$this->getCurrentUserLocationId();
		} 
		
		if ($this->_userHasRole("ADMINISTRATOR") || $this->isSuperuser() || $this->getCurrentUserRegionId()==1) {
			$showshowrooms='y';
		} else {
			$showshowrooms='n';
		}	
		if ($this->_userHasRole("MARKETINGMGR")) {
			$marketingmgr='y';
		} else {
			$marketingmgr='n';
		}	
		$this->set('activeshowrooms', $activeshowrooms);
		//debug($activeshowrooms);
		//die();
		$orders = TableRegistry::get('AwaitingOrders');
		$sortorder="";
		if (null !== $this->request->getQuery('sortorder')) {
			$sortorder=$this->request->getQuery('sortorder');
		}
		$showroom="";
		$formData = $this->request->getData();
		if (!empty($formData['showroom']) && $formData['showroom'] != 'n') {
				$showroom = $formData['showroom'];
		}
		//$showroom = $formData['showroom'];
		$awaitingorders = $orders->getAwaitingOrders($sortorder, $this, $showroom, 0, 'n', 'n');
		$awaitingorderstobeamended = $orders->getAwaitingOrders($sortorder, $this, $showroom, 4, '', '');
		$awaitingordersMktgFloor = $orders->getAwaitingOrders($sortorder, $this, $showroom, 0, '', 'y');
		//debug($awaitingorders);
		//die;
		$this->set('awaitingorders', $awaitingorders);
		$this->set('marketingmgr', $marketingmgr);
		$this->set('awaitingorderstobeamended', $awaitingorderstobeamended);
		$this->set('awaitingordersMktgFloor', $awaitingordersMktgFloor);
		$this->set('showshowrooms', $showshowrooms);
		//debug($awaitingordersMktgFloor);
		//die;
	}
	
	public function confirm() {
		
		$purchaseTable = TableRegistry::get('Purchase');
		$qchistory = TableRegistry::get('QCHistory');
		$exportlinksTable = TableRegistry::get('ExportLinks');
		$awaitingOrdersTable = TableRegistry::get('AwaitingOrders');
		$qchistorylatest = TableRegistry::get('QCHistoryLatest');
		$formData = $this->request->getData();
		$msg='';
		$failure='';
		$compStatus='';
		$userid=$this->getCurrentUsersId();
		foreach ($formData as $formfield => $value) {
			//echo "<br>" .$formfield;
			if (substr($formfield,0,11) == 'confirmcode') {
				$pn=substr($formfield,11);
				if (!empty($value)) {
									
					$purchase = $purchaseTable->get($pn);
					if ($value==$purchase['OrderConfirmationCode']) {
						$purchase->orderConfirmationStatus = 'y';
						if ($purchase['mattressrequired']=='y') {
							$compStatus = $qchistorylatest->getQCCompStatus(1, $pn)[0];
							if ($compStatus['QC_StatusID'] < 10) {
								$qchistory->insertQcHistoryRow(1, $pn, 2, $userid);
							}
						}
						if ($purchase['baserequired']=='y') {
							$compStatus = $qchistorylatest->getQCCompStatus(3, $pn)[0];
							if ($compStatus['QC_StatusID'] < 10) {
								$qchistory->insertQcHistoryRow(3, $pn, 2, $userid);
							}
						}
						if ($purchase['topperrequired']=='y') {
							$compStatus = $qchistorylatest->getQCCompStatus(5, $pn)[0];
							if ($compStatus['QC_StatusID'] < 10) {
								$qchistory->insertQcHistoryRow(5, $pn, 2, $userid);
							}
						}
						if ($purchase['valancerequired'] == 'y') {
							$compStatus = $qchistorylatest->getQCCompStatus(6, $pn)[0];
							if ($compStatus['QC_StatusID'] < 10) {
								$qchistory->insertQcHistoryRow(6, $pn, 2, $userid);
							}
						}
						if ($purchase['legsrequired'] == 'y') {
							$compStatus = $qchistorylatest->getQCCompStatus(7, $pn)[0];
							if ($compStatus['QC_StatusID'] < 10) {
								$qchistory->insertQcHistoryRow(7, $pn, 2, $userid);
							}
						}
						if ($purchase['headboardrequired'] == 'y') {
							$compStatus = $qchistorylatest->getQCCompStatus(8, $pn)[0];
							if ($compStatus['QC_StatusID'] < 10) {
								$qchistory->insertQcHistoryRow(8, $pn, 2, $userid);
							}
						}
						if ($purchase['accessoriesrequired'] == 'y') {
							$compStatus = $qchistorylatest->getQCCompStatus(9, $pn)[0];
							if ($compStatus['QC_StatusID'] < 10) {
								$qchistory->insertQcHistoryRow(9, $pn, 2, $userid);
							}
						}
						$purchaseTable->save($purchase);
						$msg='Order No. ' .$purchase['ORDER_NUMBER'] .' confirmed';
						$this->Flash->success($msg);
						$awaitingOrdersTable->convertExportLinks($pn);
						$qchistory->setOrderStatusByMinComponentStatus($pn, $userid);
						} else  { 
						$failure='Order No. ' .$purchase['ORDER_NUMBER'] .' code incorrect';
						$this->Flash->error($failure);
					}
					
				}
				
			}
		}
		$this->redirect(array('controller' => 'AwaitingOrders', 'action' => 'index'));
	}
	
	public function createConfirmCode() {
	    $this->autoRender = false;
	    $this->viewBuilder()->setLayout('ajax');
	    $pn = $this->request->getQuery('pn');
	    $awaitingOrdersTable = TableRegistry::get('AwaitingOrders');
	    $purchaseTable = TableRegistry::get('Purchase');
	    $purchase = $purchaseTable->get($pn);
	    //debug($purchase);
	    $code = $awaitingOrdersTable->getRandomConfirmationNumber();
	    debug($code);
	    $purchase->OrderConfirmationCode = $code;
	    //debug($purchase);
	    $purchaseTable->save($purchase);
	}
		
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR","SALES","REGIONAL_ADMINISTRATOR","MARKETINGMGR"];
	}
    
}

?>
