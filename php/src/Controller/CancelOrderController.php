<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;
use Cake\I18n\FrozenTime;

class CancelOrderController extends SecureAppController {
    protected $orderFormMiscDataModel;
    
	public function initialize() : void {
		parent::initialize();
        
		$this->loadModel('Purchase');
        $this->loadModel('Contact');
        $this->loadModel('Address');
        $this->loadModel('Location');
        $this->loadModel('Order');
        $this->loadModel('Comreg');
        $this->loadModel('Payment');

        // the components
        $this->loadComponent('Flash');
    }

    public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
        $builder->addHelpers([
        ]);
    	
    }

	public function index() {
		$this->viewBuilder()->setLayout('savoirsig');
        
        $params = $this->request->getParam('?');
        if (isset($params['pn'])) {
            $pn = $params['pn'];
            $purchase=$this->Purchase->get($pn);
            $currencyCode = $purchase['ordercurrency'];
            $paymentmethods=$this->Payment->getPaymentMethods();
            $this->set('purchase', $purchase);
            $this->set('paymentmethods', $paymentmethods);
            
            $paymenttotal = $this->Payment->getPaymentSum($pn)[0]['paymenttotal'];
            if (!isset($paymenttotal)) {
                $paymenttotal = 0;
            }
            $this->set('paymenttotal', $paymenttotal);
            
        }
        $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $currencyCode]]);
	}
	
    public function cancelUpdate() {
        if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'Order', 'action' => 'index'));
			return;
    	}
        $formData = $this->request->getData();
        $pn=$formData['pn'];
        $purchase = $this->Purchase->get($pn);
        $contactno = $purchase['contact_no'];
        $salesusername = $this->getCurrentUserName();
        $customer='';
        $orderCount=$this->Order->getCustomerOrderCount($contactno);
        if ($orderCount < 2) {
            $customer='Prospect';
        }
        $purchase->cancelled = 'y';
        $purchase->cancelled_reason = $formData['reason'];
        if (isset($formData['refund']) && $formData['refund'] != '') {
            $balanceoutstanding=$purchase['balanceoutstanding']-$formData['refund'];
            $paymentstotal=$purchase['paymentstotal']-$formData['refund'];
            $purchase->balanceoutstanding = $balanceoutstanding;
            $purchase->paymentstotal = $paymentstotal;
        }
        $this->Purchase->save($purchase);

        if (isset($formData['refund']) && $formData['refund'] != '') {
            $paymentamount=$formData['refund'] * -1.0;
            $payment = $this->Payment->newEntity([]);
            $payment->paymentmethodid = $formData['refundmethod'];
            $payment->paymenttype = 'Refund';
            $payment->amount = $paymentamount;
            $payment->salesusername = $salesusername;
            $payment->purchase_no = $pn;
            $payment->placed = date("Y/m/d h:i:s");
            $payment->receiptno = $this->Comreg->getNextReceiptNumber();
            $this->Payment->save($payment);
        }

        if ($customer=='Prospect') {
            $addressInfo = $this->Address->find('all', ['conditions' => ['CODE IN' => $this->Address->Contact->find('list', ['fields' => ['CODE'],'conditions' => ['Contact_no' => $contactno]])]]);
            $addressInfo->STATUS='Prospect';
            $this->Address->save($addressInfo);
        }

        //check whether customer is VIP and cancel if now less than 19999 and not manually set
        $contactdetail = $this->Contact->get($contactno);
        $isvip=$contactdetail['isVIP'];
        $isvipmanuallyset=$contactdetail['isVIPmanuallyset'];
        if ($isvip=='y') {
            $totalspend=$this->Contact->getLifetimeSpendForCurrency($contactno,'GBP');
            if ($totalspend < 19999 && $isvipmanuallyset == 'n') {
                $contactdetail->isVIP = 'n';
                $this->Contact->save($contactdetail);
            }
        }
        
        $this->Flash->success("Order cancelled successfully");
		$this->redirect(['controller' => 'Order', '?' => ['pn' => $pn]]);
    }

    protected function _getAllowedRoles() {
		return ["ADMINISTRATOR","SALES"];
	}
}

?>