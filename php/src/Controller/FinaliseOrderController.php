<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;
use Cake\I18n\FrozenTime;
use \App\Controller\EmailServicesController;

class FinaliseOrderController extends SecureAppController {
    protected $orderFormMiscDataModel;
    
	public function initialize() : void {
		parent::initialize();
		set_time_limit(120);
        
        // the temp tables (that hang off purchase_no)
        $this->loadModel('TempAccessory');
		$this->loadModel('TempPurchase');
        $this->loadModel('TempCompPriceDiscount');
        $this->loadModel('TempProductionSizes');
        $this->loadModel('TempQcHistory');
        $this->loadModel('TempWholesalePrices');
        $this->loadModel('TempPayment');
        
        // the other tables
        $this->loadModel('Address');
        $this->loadModel('Contact');
        $this->loadModel('Location');
        $this->loadModel('VatRate');
        $this->loadModel('Order');
        $this->loadModel('OrderType');
        $this->loadModel('Comreg');
        $this->loadModel('OrderNote');
        $this->loadModel('Payment');
        $this->loadModel('PaymentMethod');
        $this->loadModel('PhoneNumber');
        $this->loadModel('PriceList');
        $this->loadModel('PurchaseHistory');
        $this->loadModel('QcHistoryLatest');
        $this->loadModel('SavoirUser');

        // the components
        $this->loadComponent('Flash');
        $this->loadComponent('OrderHelper');
        $this->loadComponent('OrderEmailHelper');
    }

    public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
        $builder->addHelpers([
        ]);
    	
    }

	public function index() {
		$this->viewBuilder()->setLayout('savoirsig');
        $idlocation=$this->getCurrentUserLocationId();
        $userregion=$this->getCurrentUserRegionId();
        $vatrates=$this->VatRate->getVatRates($idlocation);
        $locationinfo=$this->Location->get($idlocation);
        $paymentmethods=$this->Payment->getPaymentMethods();
        $this->set('priceMatrixEnabled', $this->isPriceMatrixEnabled() ? 'y' : 'n');
        $this->set('vatrates', $vatrates);
        $this->set('userregion', $userregion);
        $this->set('paymentmethods', $paymentmethods);
      
        $pn='';
        $terms='';
        if ($userregion==1 || $idlocation==24 || $idlocation==17 || $idlocation==34 || $idlocation==37) {
            $terms=$locationinfo['terms'];
        }
        $vatWording=null;
        if ($idlocation==34 || $idlocation==39) {
            $OrderTotalExVAT="Sub Total";
            $vatWording='NY Tax';
        } else {
            $vatWording='VAT';
            $OrderTotalExVAT="Order Total, Ex VAT";
        }
        
        $params = $this->request->getParam('?');
        $pn = $params['pn'];
        $purchase=$this->TempPurchase->get($pn);
        $contact_no = $purchase['contact_no'];
        $currencyCode = $purchase['ordercurrency'];
        //$orderno = $purchase['ORDER_NUMBER'];
        $this->set('terms', $terms);
        $this->set('purchase', $purchase);
        $this->set('orderno', 'TBA');
        $this->set('converttoorder', (isset($params['converttoorder']) && $params['converttoorder']=='y'));
            
        $contactdetails=$this->Contact->getContact($contact_no)[0];
        $custname='';
        if ($contactdetails['title'] != '') {
            $custname=$contactdetails['title'].' ';
        }
        if ($contactdetails['first'] != '') {
            $custname.=$contactdetails['first'].' ';
        }
        if ($contactdetails['surname'] != '') {
            $custname.=$contactdetails['surname'].' ';
        }
       
        $this->set('custname', $custname);
        $this->set('vatWording', $vatWording);
        $this->set('OrderTotalExVAT', $OrderTotalExVAT);
        $this->set('contact_no', $contact_no);
        $this->set('deliveryIncludesVat', $locationinfo['delivery_includes_vat']=='y');
        $this->set('hidePaymentType', ($idlocation == 8)); // hide payment type for showroom New York
        $this->set('tradeDiscountRate', isset($contactdetails['tradediscountrate']) ? $contactdetails['tradediscountrate'] : 0.0);

        $totalDiscount = 0;
        $totalListPrice = 0;
        if ($purchase['mattressrequired']=='y') {
            $dcObj = $this->TempCompPriceDiscount->getDiscount($pn, 1, "");
            if ($dcObj['standardPrice'] > 0) $totalDiscount += ($dcObj['standardPrice']-$dcObj['price']);
            $totalListPrice += $dcObj['standardPrice'];
            $this->set('mattressDiscount', $dcObj);
        }
        if ($purchase['topperrequired']=='y') {
            $dcObj = $this->TempCompPriceDiscount->getDiscount($pn, 5, "");
            if ($dcObj['standardPrice'] > 0) $totalDiscount += ($dcObj['standardPrice']-$dcObj['price']);
            $totalListPrice += $dcObj['standardPrice'];
            $this->set('topperDiscount', $dcObj);
        }
        if ($purchase['legsrequired']=='y') {
            $dcObj = $this->TempCompPriceDiscount->getDiscount($pn, 7, "");
            if ($dcObj['standardPrice'] > 0) $totalDiscount += ($dcObj['standardPrice']-$dcObj['price']);
            $totalListPrice += $dcObj['standardPrice'];
            $this->set('legsDiscount', $dcObj);

            $dcObj = $this->TempCompPriceDiscount->getDiscount($pn, 16, "");
            if ($dcObj['standardPrice'] > 0) $totalDiscount += ($dcObj['standardPrice']-$dcObj['price']);
            $totalListPrice += $dcObj['standardPrice'];
            $this->set('addLegsDiscount', $dcObj);
        }
        if ($purchase['baserequired']=='y') {
            $dcObj = $this->TempCompPriceDiscount->getDiscount($pn, 3, "");
            if ($dcObj['standardPrice'] > 0) $totalDiscount += ($dcObj['standardPrice']-$dcObj['price']);
            $totalListPrice += $dcObj['standardPrice'];
            $this->set('baseDiscount', $dcObj);
            
            $dcObj = $this->TempCompPriceDiscount->getDiscount($pn, 17, "");
            if ($dcObj['standardPrice'] > 0) $totalDiscount += ($dcObj['standardPrice']-$dcObj['price']);
            $totalListPrice += $dcObj['standardPrice'];
            $this->set('baseFabricDiscount', $dcObj);
            
            $dcObj = $this->TempCompPriceDiscount->getDiscount($pn, 12, "");
            if ($dcObj['standardPrice'] > 0) $totalDiscount += ($dcObj['standardPrice']-$dcObj['price']);
            $totalListPrice += $dcObj['standardPrice'];
            $this->set('baseUpholsteryDiscount', $dcObj);
            
            $dcObj = $this->TempCompPriceDiscount->getDiscount($pn, 11, "");
            if ($dcObj['standardPrice'] > 0) $totalDiscount += ($dcObj['standardPrice']-$dcObj['price']);
            $totalListPrice += $dcObj['standardPrice'];
            $this->set('baseTrimDiscount', $dcObj);
            
            $dcObj = $this->TempCompPriceDiscount->getDiscount($pn, 13, "");
            if ($dcObj['standardPrice'] > 0) $totalDiscount += ($dcObj['standardPrice']-$dcObj['price']);
            $totalListPrice += $dcObj['standardPrice'];
            $this->set('baseDrawersDiscount', $dcObj);
        }
        if ($purchase['headboardrequired']=='y') {
            $dcObj = $this->TempCompPriceDiscount->getDiscount($pn, 8, "");
            if ($dcObj['standardPrice'] > 0) $totalDiscount += ($dcObj['standardPrice']-$dcObj['price']);
            $totalListPrice += $dcObj['standardPrice'];
            $this->set('headboardDiscount', $dcObj);

            $dcObj = $this->TempCompPriceDiscount->getDiscount($pn, 10, "");
            if ($dcObj['standardPrice'] > 0) $totalDiscount += ($dcObj['standardPrice']-$dcObj['price']);
            $totalListPrice += $dcObj['standardPrice'];
            $this->set('headboardTrimDiscount', $dcObj);
        }

        $this->set('totalDiscount', $totalDiscount);
        $this->set('totalListPrice', $totalListPrice);

        $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $currencyCode]]);
	}
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR","SALES"];
	}

  
    public function finaliseupdate() {
        if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'Order', 'action' => 'index'));
			return;
    	}
        
        $formData = $this->request->getData();
        //debug($formData);
        //die;
        $pn = $formData['pn'];
        $purchase = $this->TempPurchase->get($pn);
        $idlocation = $this->getCurrentUserLocationId();
        
        $contact = $this->Contact->get($purchase['contact_no']);
        if ($idlocation==37) {
            $pricelist='Net Retail';
        } else {
            $pricelist=$this->Address->get($contact['CODE'])['PRICE_LIST'];
        }
        $purchase->signature = trim($formData['output']);
        if (!isset($purchase['ORDER_NUMBER'])) {
            $purchase['ORDER_NUMBER'] = $this->Comreg->getNextOrderNumber();
        }
        $deposit=trim($formData['deposit']);
        $purchase->quote = 'n';
        if (isset($formData['holdorder'])) {
            $purchase->orderonhold = 'y';
        }
        
        if (!empty($formData['dcresult'])) {
            $purchase['discount'] = $formData['dcresult'];
            $purchase['discounttype'] = $formData['dc'];
        }
        if ($purchase['istrade']=='y') {
            $purchase['tradediscountrate'] = $formData['tradediscountrate'];
            $purchase['tradediscount'] = $formData['tradediscount'];
        }

        // if deposit paid send email to accounts:
        if ($deposit != '') {
            $deposit = floatval($deposit);
            $payment = $this->TempPayment->newEntity([]);
            $payment->paymentmethodid = $formData['paymentmethod'];
            if ($deposit < $purchase['total']) {
                $payment->paymenttype = 'Deposit';
            } else {
                $payment->paymenttype = 'Full Payment';
            }
            $payment->amount = $deposit;
            $payment->salesusername = $this->getCurrentUserName();
            $payment->purchase_no = $pn;
            $payment->placed = date("Y/m/d h:i:s");
            $payment->receiptno = $this->Comreg->getNextReceiptNumber();
            $this->TempPayment->save($payment);
        }
            
        $purchase->paymentstotal = $this->TempPayment->getPaymentSum($pn)[0]['paymenttotal'];

        $this->TempPurchase->save($purchase);
        


        // recalculate totals
        $this->OrderHelper->recalculateTotals($this->TempPurchase, $this->Location, $pn);

        // delete any orphan rows or data as a result of components having been removed
        $this->OrderHelper->cleanUpPurchase($pn, $this->TempPurchase, $this->TempQcHistory, $this->QcHistoryLatest, $this->TempCompPriceDiscount, $this->TempWholesalePrices, $this->TempProductionSizes, $this->TempAccessory, $this->TempPayment);

        // move the data to the real tables
        $this->Order->moveTempTablesToRealPurchase($pn, $this->getCurrentUsersId(), $this->PurchaseHistory);

        // emails
        $this->OrderEmailHelper->sendNewOrderToSales($pn, $this->getCurrentUserName(), $this->getCurrentUserRegionId(), $this->getCurrentUserLocationId());
        $this->OrderEmailHelper->sendOrderToBedworks($pn, $this->getCurrentUserName(), $this->getCurrentUserRegionId(), $this->getCurrentUserLocationId());
        if ($deposit != '') {
            $this->OrderEmailHelper->sendDepositEmailToAccounts($pn, $this->PaymentMethod->get($formData['paymentmethod'])['paymentmethod'], $deposit, $pricelist, $payment->receiptno, $this->getCurrentUserLocationId());
        }

        $this->Flash->success("Order saved successfully");
		$this->redirect(['controller' => 'Order', '?' => ['pn' => $pn]]);
       
    }

    private function isPriceMatrixEnabled() {
		// check its enabled globally
        $priceMatrixEnabled = $this->Comreg->isFeatureEnabled('PRICE_MATRIX');
        if ($priceMatrixEnabled) {
			// is enabled globally, so check it's enabled for the current showroom
            $locationdata = $this->Location->get($this->getCurrentUserLocationId());
            if ($locationdata['price_matrix_enabled'] == 'y') $priceMatrixEnabled = true;
        }
		return $priceMatrixEnabled;        
    }

}

?>