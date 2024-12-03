<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\Datasource\ConnectionManager;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;
use Cake\I18n\FrozenTime;
use Cake\I18n\FrozenDate;

class OrderController extends SecureAppController {
    protected $orderFormMiscDataModel;
    
	public function initialize() : void {
		parent::initialize();
		set_time_limit(120);

        // the temp tables (that hang off purchase_no)
        $this->loadModel('TempAccessory');
        $this->loadModel('TempCompPriceDiscount');
        $this->loadModel('TempOrderNote');
        $this->loadModel('TempPhoneNumber');
        $this->loadModel('TempProductionSizes');
		$this->loadModel('TempPurchase');
        $this->loadModel('TempQcHistory');
        $this->loadModel('TempWholesalePrices');
        $this->loadModel('TempOrder');
        $this->loadModel('TempPayment');
        $this->loadModel('TempExportLinks');

        // the other tables
		$this->loadModel('Contact');
        $this->loadModel('Address');
        $this->loadModel('Accessory');
        $this->loadModel('BedOptions');
        $this->loadModel('ComponentDimensions');
        $this->loadModel('ComponentType');
        $this->loadModel('Componentdata');
        $this->loadModel('Comreg');
        $this->loadModel('CountryList');
        $this->loadModel('ExportCollections');
        $this->loadModel('Location');
        $this->loadModel('MattressSupport');
        $this->loadModel('OrderFormMiscData');
        $this->loadModel('Payment');
        $this->loadModel('PhoneNumber');
        $this->loadModel('ProductionSizes');
        $this->loadModel('Ticking');
        $this->loadModel('VatRate');
        $this->loadModel('WholesaleInvoices');
        $this->loadModel('Wrappingtypes');
        $this->loadModel('QcHistoryLatest');
        $this->loadModel('PurchaseHistory');

        // the components
        $this->loadComponent('Flash');
        $this->loadComponent('OrderHelper');
        $this->loadComponent('OrderEmailHelper');
    }

    public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	
    	$leadTimes = $this->OrderFormMiscData->getLeadTimes();
    	$builder = $this->viewBuilder();
        $builder->addHelpers([
        	'OrderFormProduction' => ['leadTimes' => $leadTimes],
            'MyForm',
            'AuxiliaryData'
        ]);
    }

	public function index() {
		$this->viewBuilder()->setLayout('savoirbs');
        if ($this->_userHasRole("NOPRICESUSER")) {
            $this->set('viewPrices', false);
        } else {
            $this->set('viewPrices', true);
        }

        $idlocation=$this->getCurrentUserLocationId();
        $userregion=$this->getCurrentUserRegionId();
        $ordertype=$this->TempOrder->getOrderType($userregion);
        $wrappingtypes=$this->Wrappingtypes->getWrappingTypes();
        $vatrates=$this->VatRate->getVatRates($idlocation);
        $countrylist=$this->CountryList->getCountryList();
        $plannedexports=$this->ExportCollections->getExWorksDates($idlocation);
        $phonenoTypes=$this->TempPhoneNumber->getPhoneNoTypes();
        $locationdata=$this->Location->get($idlocation);
        if ($this->_userHasRole("ADMINISTRATOR")) {
            $isAdministrator='y';
        } else {
            $isAdministrator='n';
        }
        $this->set('isAdministrator', $isAdministrator);
        $this->set('vatrates', $vatrates);
        $this->set('ordertype', $ordertype);
        $this->set('wrappingtypes', $wrappingtypes);
        $this->set('countrylist', $countrylist);
        $this->set('plannedexports', $plannedexports);
        $this->set('phonenoTypes', $phonenoTypes);
        $this->set('userregion', $userregion);
        
        $currencylist = [$locationdata['currency']];
        if (isset($locationdata['alternatecurrencies'])) {
        	$currencylist = array_merge ($currencylist,explode(',',$locationdata['alternatecurrencies']));
        }
        if ($locationdata['wholesaleEnabled']=='y') {
        	$wholesaleenabled='y';
        } else {
            $wholesaleenabled='n';
        }
        if ($locationdata['SavoirOwned']=='y') {
        	$savoirowned='y';
        } else {
            $savoirowned='n';
        }

        $this->set('currencylist', $currencylist);
      
        $pn='';
        $overseas='';
        $ordersource='';
        $quote='';
        $contact_no='';
        $correspondence='';
        $orderdate='';
        $ordernotes='';
        $vatWording='VAT Rate';
        if ($idlocation==34) {
            $vatWording='NY Tax';
        }
        $this->set('wholesaleenabled', $wholesaleenabled);
        $this->set('savoirowned', $savoirowned);
        $this->set('vatWording', $vatWording);

        $wholesaledata['wholesale_inv_no'] = '';
        $wholesaledata['wholesale_inv_date'] = '';

        $params = $this->request->getParam('?');
        $currencyCode = 'GBP';
        $purchase = null;
        $phoneNumbers = null;
        if (isset($params['pn'])) {
            $pn = $params['pn'];
            $open = (isset($params['open']) && $params['open'] == 'y');
            if (!$open) {
                // We have a purchase_no, but open is not set, so we're not in the middle of editing,
                // so copy the real purchase to the temp tables, where we will edit it.
                $this->TempOrder->copyRealPurchaseToTempTables($pn);
                $this->set('ordercopiedtotemptables', 'y');
            }

            $purchase=$this->TempPurchase->get($pn);
            $overseas = $purchase['overseas'];
            $ordersource = $purchase['orderSource'];
            $quote = $purchase['quote'];
            $contact_no = $purchase['contact_no'];
            $orderdate=$purchase['ORDER_DATE'];
            $customerreference=$purchase['customerreference'];
            $ordernotes=$this->TempOrderNote->getOrderNotes($pn);
            $phoneNumbers = $this->TempPhoneNumber->getNumbersForPurchase($pn);
            
            $wholesaledataArray = $this->WholesaleInvoices->getWholesaleInvoiceData($pn);
            if (count($wholesaledataArray) > 0) {
                $wholesaledata = $wholesaledataArray[0];
            }

            $currencyCode = $purchase['ordercurrency'];
            $this->set('purchase', $purchase);
            $this->set('pn', $pn);
            $this->set('contact_no', $contact_no);
            $this->set('wholesaledata', $wholesaledata);
            
        } else {
            if (isset($params['overseas'])) {
                $overseas = $params['overseas'];
            }
            if (isset($params['correspondence'])) {
                $correspondence = $params['correspondence'];
            }
            if (isset($params['ordersource'])) {
                $ordersource = $params['ordersource'];
            }
            if (isset($params['quote'])) {
                $quote = $params['quote'];
            }
            $customerreference='';
            $contact_no = $params['contact_no'];
            $orderdate = date("d/m/Y h:i:s");

            $this->set('pn', 0); // a dummy value for loadMattress etc functions
            $this->set('contact_no', $contact_no);
        }
        $contactdetails=$this->Contact->getContact($contact_no);

        $this->set('partOneFormData', $this->makePartOneFormData($contactdetails[0], $purchase));
      
        $this->set('ordernotes', $ordernotes);
        $this->set('overseas', $overseas);
        $this->set('ordersource', $ordersource);
        $this->set('quote', $quote);
        $this->set('contact_no', $contact_no);
        $this->set('correspondence', $correspondence);
        $this->set('orderdate', $orderdate);
        $this->set('customerreference', $customerreference);
        $this->set('contactdetails', $contactdetails[0]);
        $this->set('priceMatrixEnabled', $this->isPriceMatrixEnabled() ? 'y' : 'n');
        $this->set('isTrade', $this->TempOrder->isTradeCustomer($contact_no) ? 'y' : 'n');
        $this->set('wholesaledata', $wholesaledata);
        $this->set('phoneNumbers', $phoneNumbers);

        $leadTimes = $this->TempQcHistory->getLongestLeadTime();
        $latestDeliveryDate = $this->getRoundedApproxDateString($leadTimes["longestLeadTime"]);
        $cardiffDeliveryDate = $this->getRoundedApproxDateString($leadTimes["cardiffNo"]);
        $londonDeliveryDate = $this->getRoundedApproxDateString($leadTimes["londonNo"]);
        // debug($leadTimes);
        // debug($latestDeliveryDate);
        // debug($cardiffDeliveryDate);
        // debug($londonDeliveryDate);
        // die;
        $this->set('latestDeliveryDate', $latestDeliveryDate);
        $this->set('cardiffDeliveryDate', $cardiffDeliveryDate);
        $this->set('londonDeliveryDate', $londonDeliveryDate);

        $isComponentLocked=false;
        if (isset($params['pn'])) {
            if ($purchase['cancelled'] == 'y' || $purchase['completedorders'] == 'y') {
                $isComponentLocked = true;
            }
            $this->set('isComponentLocked', $isComponentLocked ? 'true' : 'false');
        }
        $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $currencyCode], 'MyForm']);
	}

    public function addPartOne() {
        if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'Order', 'action' => 'index'));
			return;
    	}

        if ($this->request->is('ajax')) {
            $this->autoRender = false;
        } else {
            $this->viewBuilder()->setLayout('savoirbs');
        }
		
        $idlocation=$this->getCurrentUserLocationId();
        $userregion=$this->getCurrentUserRegionId();
        $username=$this->getCurrentUserName();
        $userId=$this->getCurrentUsersId();
		$formData = $this->request->getData();
        $contact_no = $formData['contact_no'];
        $isTrade = $this->TempOrder->isTradeCustomer($contact_no);

        $pn = null;
        if (isset($formData['pn'])) {
            $pn=$formData['pn'];
        }

        $contactdetails = $this->Contact->get($contact_no);
        
        $codeno=$contactdetails['CODE'];

        $addressdetails = $this->Address->find('all', array('conditions'=> array('CODE' => $codeno)));
        $addressdetails = $addressdetails->toArray()[0];
        $addressdetails->street1 = trim($formData['add1']);
        $addressdetails->street2 = trim($formData['add2']);
        $addressdetails->street3 = trim($formData['add3']);
        $addressdetails->town = trim($formData['town']);
        $addressdetails->county = trim($formData['county']);
        $addressdetails->postcode = trim($formData['postcode']);
        $addressdetails->country = trim($formData['country']);
        $addressdetails->company = trim($formData['company']);
        $this->Address->save($addressdetails);

        //$orderno = null;
        if (isset($pn)) {
            $purchaserow = $this->TempPurchase->get($pn);
            //$purchaserow->ORDER_DATE = FrozenTime::createFromFormat('d/m/Y H:i:s', $formData['orderdate']);
            $purchaserow->AmendedDate = FrozenTime::now();
            //$orderno = $purchaserow->ORDER_NUMBER;
        } else {
            $purchaserow = $this->TempPurchase->newEntity([]);
            $purchaserow->PURCHASE_No = $this->TempOrder->getNextPrimeKeyValForTable('purchase', 1);
            $purchaserow->ORDER_DATE = FrozenTime::createFromFormat('d/m/Y H:i:s', $formData['orderdate']);
            $purchaserow->AmendedDate = FrozenTime::createFromFormat('d/m/Y H:i:s', $formData['orderdate']);
        }

        


        // if (!isset($orderno)) {
        //     $orderno=$this->Comreg->getNextOrderNumber();
        // }
        
        //$purchaserow->ORDER_NUMBER = $orderno;
        $purchaserow->CODE = $codeno;
        $purchaserow->SOURCE_SITE = 'SB';
        $purchaserow->completedorders = 'n';
        $purchaserow->orderConfirmationStatus = 'n';
        $purchaserow->orderSource = $formData['ordersource'];
        $purchaserow->OWNING_REGION = $userregion;
        $purchaserow->idlocation = $idlocation;
        $purchaserow->salesusername = $username;
        $purchaserow->customerreference = trim($formData['customerref']);
        if (!empty($formData['bookeddeldate'])) {
            $purchaserow->bookeddeliverydate = FrozenTime::createFromFormat('d/m/Y', $formData['bookeddeldate']);
        }
        if (!empty($formData['deldate'])) {
            $purchaserow->deliverydate=FrozenDate::createFromFormat('Y-m-d', $formData['deldate']);
        }
        $purchaserow->deliveryadd1 = trim($formData['deladd1']);
        $purchaserow->deliveryadd2 = trim($formData['deladd2']);
        $purchaserow->deliveryadd3 = trim($formData['deladd3']);
        $purchaserow->deliverytown = trim($formData['deltown']);
        $purchaserow->deliverycounty = trim($formData['delcounty']);
        $purchaserow->deliverypostcode = trim($formData['delpostcode']);
        $purchaserow->deliverycountry = trim($formData['delcountry']);
        $purchaserow->deliverycontact = trim($formData['delContact1']);
        $purchaserow->companyname = trim($formData['company']);
        $purchaserow->vatrate = $formData['vatrates'];
        $purchaserow->contact_no = trim($formData['contact_no']);
        $purchaserow->ordercurrency = trim($formData['currency']);
        $purchaserow->istrade = $isTrade ? 'y' : 'n';
        if (isset($formData['productiondate']) && !empty($formData['productiondate'])) {
            $purchaserow->productiondate = FrozenDate::createFromFormat('d/m/Y', $formData['productiondate']);
        }
        $purchaserow->wrappingid = $formData['wrappingtype'];
        $purchaserow->shipperID = $formData['wrappingtype'];
        $purchaserow->ordertype = $formData['ordertype'];
        $purchaserow->overseas = $formData['overseas'];
        $purchaserow->quote = $formData['quote'];
        $purchaserow->customerreference = trim($formData['customerref']);

        if (isset($formData['complete']) && $formData['complete']=='y')  {
            $purchaserow->ordercompletedUser = $this->getCurrentUsersId();
            $purchaserow->ordercompletedDate = FrozenTime::now();
            $purchaserow->completedorders = 'y';
        }
    

        $this->TempPurchase->save($purchaserow);
        $pn=$purchaserow->PURCHASE_No;
        $quote=$purchaserow->quote;
        $this->TempPhoneNumber->deleteNumbersForPurchase($pn);
        if (trim($formData['delContact1']) != '') {
            $contactPhoneDetails = $this->TempPhoneNumber->newEntity([]);
            $contactPhoneDetails->phonenumber_id = $this->TempOrder->getNextPrimeKeyValForTable('phonenumber', 1);
            $contactPhoneDetails->phonenumbertype =  $formData['delphonetype1'];
            $contactPhoneDetails->purchase_no =  $pn;
            $contactPhoneDetails->number =  trim($formData['delContact1']);
            $contactPhoneDetails->seq =  1;
            $this->TempPhoneNumber->save($contactPhoneDetails);
        }
        if (trim($formData['delContact2']) != '') {
            $contactPhoneDetails = $this->TempPhoneNumber->newEntity([]);
            $contactPhoneDetails->phonenumber_id = $this->TempOrder->getNextPrimeKeyValForTable('phonenumber', 1);
            $contactPhoneDetails->phonenumbertype =  $formData['delphonetype2'];
            $contactPhoneDetails->purchase_no =  $pn;
            $contactPhoneDetails->number =  trim($formData['delContact2']);
            $contactPhoneDetails->seq =  2;
            $this->TempPhoneNumber->save($contactPhoneDetails);
        }
        if (trim($formData['delContact3']) != '') {
            $contactPhoneDetails = $this->TempPhoneNumber->newEntity([]);
            $contactPhoneDetails->phonenumber_id = $this->TempOrder->getNextPrimeKeyValForTable('phonenumber', 1);
            $contactPhoneDetails->phonenumbertype =  $formData['delphonetype3'];
            $contactPhoneDetails->purchase_no =  $pn;
            $contactPhoneDetails->number =  trim($formData['delContact3']);
            $contactPhoneDetails->seq =  3;
            $this->TempPhoneNumber->save($contactPhoneDetails);
        }

        if (trim($formData['ordernote_notetext']) != '') {
            $ordernote = $this->TempOrderNote->newEntity([]);
            $ordernote->ordernote_id = $this->TempOrder->getNextPrimeKeyValForTable('ordernote', 1);
            $ordernote->createddate =  date("Y-m-d H:i:s");
            $ordernote->notetext =  trim($formData['ordernote_notetext']);
            $ordernote->purchase_no =  $pn;
            $ordernote->username = $username;
            $ordernote->notetype = 'MANUAL';
            if ($formData['ordernote_followupdate'] != '') {
                
                $ordernote->followupdate =FrozenTime::createFromFormat('d/m/Y', $formData['ordernote_followupdate']);
            }
            $ordernote->action =  $formData['ordernote_action'];
            
            $this->TempOrderNote->save($ordernote);
        }

        

        if (isset($pn)) {
            $ordernoteid='';
            foreach ($formData as $fieldName => $fieldValue) {
                $ordernotes='';
                if (substr($fieldName, 0, 17)=='Note_followupdate') {
                    $ordernoteid=substr($fieldName, 17);
                    $ordernotes = $this->TempOrderNote->find()->where(['ordernote_id' => $ordernoteid])->first();
                    $ordernotes->followupdate =FrozenTime::createFromFormat('d/m/Y', $fieldValue);
                    $this->TempOrderNote->save($ordernotes);
                };
            
            }
            $ordernoteid='';
            foreach ($formData as $fieldName => $fieldValue) {
                $ordernotes='';
                if (substr($fieldName, 0, 13)=='notecompleted') {
                    $ordernoteid=substr($fieldName, 13);
                    $ordernotes = $this->TempOrderNote->find()->where(['ordernote_id' => $ordernoteid])->first();
                    if ($fieldValue != '') {
                        $ordernotes->followupdate =null;
                        $ordernotes->action ='Completed';
                        $ordernotes->NoteCompletedDate =date("Y/m/d h:i:s");
                        $ordernotes->NoteCompletedBy =$username;
                    }
                    $this->TempOrderNote->save($ordernotes);
                };
            }
        }

        if (isset($pn)) {
            if (!isset($purchase['bookeddeliverydate']) && !isset($purchase['productiondate']) && (isset($formData['bookeddeliverydate']) || isset($formData['productiondate'])))
            {
                $ordernote = $this->TempOrderNote->newEntity([]);
                $ordernote->ordernote_id = $this->TempOrder->getNextPrimeKeyValForTable('ordernote', 1);
                $ordernote->createddate =  date("Y-m-d H:i:s");
                $ordernote->notetext =  'Contact customer to discuss linen requirements, check production or booked delivery date.';
                $ordernote->purchase_no =  $pn;
                $ordernote->username = $username;
                $ordernote->notetype = 'AUTO';
                if ($formData['ordernote_followupdate'] != '') {
                    
                    $ordernote->followupdate =FrozenTime::createFromFormat('d/m/Y', $formData['ordernote_followupdate']);
                }
                $ordernote->action =  'Action Required';
                
                $this->TempOrderNote->save($ordernote);
                
            } 
        }

        if (isset($pn)) {
            $this->TempQcHistory->insertQcHistoryRowIfNone($this->TempOrder, 0, $pn, $userId, 0);
        }

        if ($this->request->is('ajax')) {
            return;
        }

        if (isset($pn) && $quote != 'y') {
            $this->Flash->success("Order details updated successfully");
        } else if (isset($pn) && $quote == 'y') {
            $this->Flash->success("Quote details updated successfully");
        } else {
            $this->Flash->success("New order details added successfully");
        }
        
		$this->redirect(['action' => 'index', '?' => ['pn' => $pn, 'open' => 'y']]);
	}

    public function customerOrders() {
        $pn = $this->request->getQuery('pn');
        $contact_no = $this->request->getQuery('contact_no');
        $allorders=$this->Contact->getAllOrders($contact_no, $pn);
        $this->set('allorders', $allorders);
    }
    
    public function mattress() {
        $pn = $this->request->getQuery('pn');
        $purchase=$this->TempPurchase->get($pn);
        $mattresswholesaleprice='';
        $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 1])->first();
        if (isset($wholesaledata)) {
            $mattresswholesaleprice=$wholesaledata['price'];
        }
        $comptypes=$this->ComponentType->getCompType(1);
        $ticking=$this->Ticking->getTicking();
        $bedmodels=$this->TempOrder->getBedModel(1); 
        $support=$this->MattressSupport->getSupport();
        $ventpos=$this->BedOptions->getVentPosition();
        $ventfinish=$this->BedOptions->getOptionFinish();
        $mattressstatus=$this->TempPurchase->getComponentStatus($pn, 1);
        $prodsizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();
        if (!isset($prodsizes)) {
            $prodsizes = ['Matt1Width' => '', 'Matt1Length' => ''];
        }
        
        $userregion=$this->getCurrentUserRegionId();
        $compwidths=$this->ComponentDimensions->getCompWidths($userregion);
        $complengths=$this->ComponentDimensions->getCompLengths($userregion);
        $this->set('prodsizes', $prodsizes);
        $this->set('ventpos', $ventpos);
        $this->set('ventfinish', $ventfinish);
        $this->set('ticking', $ticking);
        $this->set('support', $support);
        $this->set('compwidths', $compwidths);
        $this->set('complengths', $complengths);
        $this->set('comptypes', $comptypes);
        $this->set('bedmodels', $bedmodels);
        $this->set('userregion', $userregion);
        $this->set('purchase', $purchase);
        $this->set('mattresswholesaleprice', $mattresswholesaleprice);
        $this->set('mattressDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 1, ""));
        [$isComponentLocked, $lockColour] = $this->QcHistoryLatest->isComponentLocked($pn, 1);
        if (!$isComponentLocked && ($purchase['cancelled'] == 'y' || $purchase['completedorders'] == 'y')) {
            $isComponentLocked = true;
        }
        $this->set('isComponentLocked', $isComponentLocked ? 'true' : 'false');
        $this->set('lockColour', $lockColour);

        $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $purchase['ordercurrency']]]);
    }

    
    public function saveMattress() {
        $this->autoRender = false;
        if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'Order', 'action' => 'index'));
			return;
    	}

        $userId = $this->getCurrentUsersId();
        $reloadBase = false;
        $reloadTopper = false;

        $formData = $this->request->getData();
        $pn = $formData['pn'];
        $purchase = $this->TempPurchase->get($pn);

        // base dependencies
        if ($purchase->baserequired == 'y') {
            if ($purchase->savoirmodel != trim($formData['savoirmodel'])) {
                $purchase->basesavoirmodel = trim($formData['savoirmodel']);
                if (trim($formData['savoirmodel'])=='No. 4v') {
                    $purchase->baseinstructions.='Vegan Bed - Vegan materials to be used';
                } else {
                    //$basinstr=trim($formData['baseinstructions']);
                    //$basinstrnew=str_replace('Vegan Bed - Vegan materials to be used', '',$basinstr);
                    //$purchase->baseinstructions=$basinstrnew;
                }
                // TODO - reset or default the necessary fields on the base remove vegan text and not show tickingchoices for base
                $reloadBase = true;
            }
            if ($purchase->tickingoptions != trim($formData['tickingoptions'])) {
                $purchase->basetickingoptions = trim($formData['tickingoptions']);
                $reloadBase = true;
            }
            if ($purchase->ventfinish != trim($formData['ventfinish'])) {
                $purchase->linkfinish = trim($formData['ventfinish']);
                $reloadBase = true;
            }
        }

        // topper dependencies
        if ($purchase->topperrequired == 'y') {
            if ($purchase->tickingoptions != trim($formData['tickingoptions'])) {
                $purchase->toppertickingoptions = trim($formData['tickingoptions']);
                $reloadTopper = true;
            }
        }

        // save form data
        $purchase->mattressrequired = 'y';
        $purchase->savoirmodel = trim($formData['savoirmodel']);
        $purchase->mattresstype = trim($formData['mattresstype']);
        $purchase->tickingoptions = trim($formData['tickingoptions']);
        $purchase->mattresswidth = trim($formData['mattresswidth']);
        $purchase->mattresslength = trim($formData['mattresslength']);
        $purchase->leftsupport = trim($formData['leftsupport']);
        $purchase->rightsupport = trim($formData['rightsupport']);
        $purchase->leftsupport = trim($formData['leftsupport']);
        $purchase->ventposition = trim($formData['ventposition']);
        $purchase->ventfinish = trim($formData['ventfinish']);
        $purchase->mattressinstructions = trim($formData['mattressinstructions']);
        $purchase->mattressprice = trim($formData['mattressprice']);
        $this->TempPurchase->save($purchase);
        $this->TempCompPriceDiscount->upsertDiscount($pn, 1, $formData['mattressdiscounttype'], $formData['mattresslistprice'], $formData['mattressprice']);

        if (isset($pn)) {
            $this->TempQcHistory->insertQcHistoryRowIfNone($this->TempOrder, 1, $pn, $userId, $this->OrderHelper->getMattressMadeAt($purchase));
        }

        if ($formData['mattresswidth']!='Special Width' || $formData['mattresslength']!='Special Length') {
            $prodsizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();
	        if (isset($prodsizes)) {
                $prodsizes->Matt1Width = null;
                $prodsizes->Matt2Width = null;
                $prodsizes->Matt1Length = null;
                $prodsizes->Matt2Length = null;
                $this->TempProductionSizes->save($prodsizes); 
            }
        }
        if ($formData['mattresswidth']=='Special Width' || $formData['mattresslength']=='Special Length') {
            $prodsizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();
	        if (!isset($prodsizes)) {
                $prodsizes = $this->TempProductionSizes->newEntity([]);
                $prodsizes->ProductionSizesID = $this->TempOrder->getNextPrimeKeyValForTable('productionsizes', 1);
                $prodsizes->Purchase_No = $pn;
	        } else {
                $prodsizes->Matt1Width = null;
                $prodsizes->Matt2Width = null;
                $prodsizes->Matt1Length = null;
                $prodsizes->Matt2Length = null;
            }
            if ($formData['mattresswidth']=='Special Width') {   
                if ($formData['matt1width'] != '') {
                    $prodsizes->Matt1Width = trim($formData['matt1width']);
                } else {
                    $prodsizes->Matt1Width = null;
                }
                if ($formData['matt2width'] != '') {
                    $prodsizes->Matt2Width = trim($formData['matt2width']);
                } else {
                    $prodsizes->Matt2Width = null;
                }
            }
            if ($formData['mattresslength']=='Special Length') {   
                if ($formData['matt1length'] != '') {
                    $prodsizes->Matt1Length = trim($formData['matt1length']);
                } else {
                    $prodsizes->Matt1Length = null;
                }
                if ($formData['matt2length'] != '') {
                    $prodsizes->Matt2Length = trim($formData['matt2length']);
                } else {
                    $prodsizes->Matt2Length = null;
                }
            }
            $this->TempProductionSizes->save($prodsizes); 
        }

        $this->saveWholesalePrice($formData['wmattressprice'], $pn, 1);
        $this->OrderHelper->recalculateTotals($this->TempPurchase, $this->Location, $pn);

        $componentsToReload = [1]; // include itself
        if ($reloadBase) {
            array_push($componentsToReload, 3);
        }
        if ($reloadTopper) {
            array_push($componentsToReload, 5);
        }
        $this->response = $this->response->withType('application/json');
        $this->response = $this->response->withStringBody(json_encode($componentsToReload));
        return $this->response;
    }

    public function removeMattress() {
        $this->autoRender = false;
        $pn = $this->request->getQuery('pn');
        $purchase = $this->TempPurchase->get($pn);
        $purchase->mattressrequired = 'n';
        $this->TempPurchase->save($purchase);
        $this->TempCompPriceDiscount->deleteDiscount($pn, 1);
    }
//mattress ends
//topper begins
    public function topper() {
        $pn = $this->request->getQuery('pn');
        $purchase=$this->TempPurchase->get($pn);
        $topperwholesaleprice='';
        $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 5])->first();
        if (isset($wholesaledata)) {
            $topperwholesaleprice=$wholesaledata['price'];
        }
        $toppernames=$this->Componentdata->getModelNames(5);
        $ticking=$this->Ticking->getTicking();
        $prodsizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();
        if (!isset($prodsizes)) {
            $prodsizes = ['topper1Width' => '', 'topper1Length' => ''];
        }

        $selectedTicking='';
        if (isset($purchase['tickingoptions'])) {
            $selectedTicking=$purchase['tickingoptions'];
        }
        if (isset($purchase['basetickingoptions'])) {
            $selectedTicking=$purchase['basetickingoptions'];
        }
        if (isset($purchase['toppertickingoptions'])) {
            $selectedTicking=$purchase['toppertickingoptions'];
        }
        
        $userregion=$this->getCurrentUserRegionId();
        $compwidths=$this->ComponentDimensions->getCompWidths($userregion);
        $complengths=$this->ComponentDimensions->getCompLengths($userregion);
        $this->set('prodsizes', $prodsizes);
        $this->set('ticking', $ticking);
        $this->set('selectedTicking', $selectedTicking);
        $this->set('compwidths', $compwidths);
        $this->set('complengths', $complengths);
        $this->set('toppernames', $toppernames);
        $this->set('topperwholesaleprice', $topperwholesaleprice);
        $this->set('userregion', $userregion);
        $this->set('purchase', $purchase);
        $this->set('topperDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 5, ""));
        [$isComponentLocked, $lockColour] = $this->QcHistoryLatest->isComponentLocked($pn, 5);
        if (!$isComponentLocked && ($purchase['cancelled'] == 'y' || $purchase['completedorders'] == 'y')) {
            $isComponentLocked = true;
        }
        $this->set('isComponentLocked', $isComponentLocked ? 'true' : 'false');
        $this->set('lockColour', $lockColour);

        $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $purchase['ordercurrency']]]);
    }

    public function saveTopper() {
        $this->autoRender = false;
        if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'Order', 'action' => 'index'));
			return;
    	}
        $userId=$this->getCurrentUsersId();
        $formData = $this->request->getData();
        $pn = $formData['pn'];
        $purchase = $this->TempPurchase->get($pn);
        $purchase->topperrequired = 'y';
        $purchase->toppertype = trim($formData['toppertype']);
        $purchase->toppertickingoptions = trim($formData['toppertickingoptions']);
        $purchase->topperwidth = trim($formData['topperwidth']);
        $purchase->topperlength = trim($formData['topperlength']);
        $purchase->specialinstructionstopper = trim($formData['specialinstructionstopper']);
        $purchase->topperprice = trim($formData['topperprice']);
        $this->TempPurchase->save($purchase);
        $this->TempCompPriceDiscount->upsertDiscount($pn, 5, $formData['topperdiscounttype'], $formData['topperlistprice'], $formData['topperprice']);

        if (isset($pn)) {
            $this->TempQcHistory->insertQcHistoryRowIfNone($this->TempOrder, 5, $pn, $userId, $this->OrderHelper->getTopperMadeAt($purchase));
        }

        if ($formData['topperwidth']!='Special Width' || $formData['topperlength']!='Special Length') {
            $prodsizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();
            if (isset($prodsizes)) {
                $prodsizes->topper1Width = null;
                $prodsizes->topper1Length = null;
                $this->TempProductionSizes->save($prodsizes); 
            }
        }
        if ($formData['topperwidth']=='Special Width' || $formData['topperlength']=='Special Length') {
            $prodsizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();
	        if (!isset($prodsizes)) {
                $prodsizes = $this->TempProductionSizes->newEntity([]);
                $prodsizes->ProductionSizesID = $this->TempOrder->getNextPrimeKeyValForTable('productionsizes', 1);
                $prodsizes->Purchase_No = $pn;
	        } else {
                $prodsizes->topper1Width = null;
                $prodsizes->topper1Length = null;
            }
            if ($formData['topperwidth']=='Special Width') {   
                if ($formData['topper1width'] != '') {
                    $prodsizes->topper1Width = trim($formData['topper1width']);
                } else {
                    $prodsizes->topper1Width = null;
                }
            }
            
            if ($formData['topperlength']=='Special Length') { 
                 
                if ($formData['topper1length'] != '') {
                    $prodsizes->topper1Length = trim($formData['topper1length']);
                } else {
                    $prodsizes->topper1Length = null;
                }
            }
            $this->TempProductionSizes->save($prodsizes); 
        }

        $this->saveWholesalePrice($formData['wtopperprice'], $pn, 5);
        $this->OrderHelper->recalculateTotals($this->TempPurchase, $this->Location, $pn);

        $componentsToReload = [5]; // include itself
        $this->response = $this->response->withType('application/json');
        $this->response = $this->response->withStringBody(json_encode($componentsToReload));
        return $this->response;
    }
    
    public function removeTopper() {
        $this->autoRender = false;
        $pn = $this->request->getQuery('pn');
        $purchase = $this->TempPurchase->get($pn);
        $purchase->topperrequired = 'n';
        $this->TempPurchase->save($purchase);
        $this->TempCompPriceDiscount->deleteDiscount($pn, 5);
    }

  //topper ends  
  //base begins
  public function base() {
    $pn = $this->request->getQuery('pn');
    $purchase=$this->TempPurchase->get($pn);

    // if base just added & base model not the same as mattress model, fix it
    if ($purchase->baserequired != 'y' && $purchase->basesavoirmodel != $purchase->savoirmodel) {
        $purchase->basesavoirmodel = $purchase->savoirmodel;
        $this->TempPurchase->save($purchase);
    }
    $basePoNo='';
    $qchData=$this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 3])->first();
    if (isset($qchData)) {
        $basePoNo=$qchData['PONumber'];
    }
    $basewholesaleprice='';
    $basetrimwholesaleprice='';
    $baseuphwholesaleprice='';
    $basefabricwholesaleprice='';
    $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 3])->first();
        if (isset($wholesaledata)) {
            $basewholesaleprice=$wholesaledata['price'];
        }
    $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 11])->first();
    if (isset($wholesaledata)) {
        $basetrimwholesaleprice=$wholesaledata['price'];
    }
    $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 12])->first();
    if (isset($wholesaledata)) {
        $baseuphwholesaleprice=$wholesaledata['price'];
    }
    $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 17])->first();
    if (isset($wholesaledata)) {
        $basefabricwholesaleprice=$wholesaledata['price'];
    }
    
    $comptypes=$this->ComponentType->getCompType(3);
    $ticking=$this->Ticking->getTicking();
    $bedmodels=$this->TempOrder->getBedModel(3); 
    $linkposition=$this->TempOrder->getLinkPosition();
    $linkfinish=$this->BedOptions->getOptionFinish();
    $heightspring=$this->TempOrder->getHeightSpring();
    $basetrim=$this->BedOptions->getBaseTrim();
    $basetrimcolour=$this->BedOptions->getBaseTrimColour();
    $drawers=$this->BedOptions->getDrawerConfig();
    $drawerheight=$this->BedOptions->getDrawerHeight();
    $uphbase=$this->BedOptions->getUphBase();
    $basefabdirection=$this->BedOptions->getBaseFabDirection();
    $prodsizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();
    if (!isset($prodsizes)) {
        $prodsizes = ['Base1Width' => '', 'Base1Length' => ''];
    }
    $selectedTicking='';
    if (isset($purchase['tickingoptions'])) {
        $selectedTicking=$purchase['tickingoptions'];
    }
    if (isset($purchase['toppertickingoptions'])) {
        $selectedTicking=$purchase['toppertickingoptions'];
    }
    if (isset($purchase['basetickingoptions'])) {
        $selectedTicking=$purchase['basetickingoptions'];
    }
    
    $userregion=$this->getCurrentUserRegionId();
    $compwidths=$this->ComponentDimensions->getCompWidths($userregion);
    $complengths=$this->ComponentDimensions->getCompLengths($userregion);
    $this->set('uphbase', $uphbase);
    $this->set('basefabdirection', $basefabdirection);
    $this->set('basetrim', $basetrim);
    $this->set('drawers', $drawers);
    $this->set('drawerheight', $drawerheight);
    $this->set('basetrimcolour', $basetrimcolour);
    $this->set('heightspring', $heightspring);
    $this->set('linkfinish', $linkfinish);
    $this->set('selectedTicking', $selectedTicking);
    $this->set('prodsizes', $prodsizes);
    $this->set('ticking', $ticking);
    $this->set('linkposition', $linkposition);
    $this->set('compwidths', $compwidths);
    $this->set('complengths', $complengths);
    $this->set('comptypes', $comptypes);
    $this->set('bedmodels', $bedmodels);
    $this->set('userregion', $userregion);
    $this->set('purchase', $purchase);
    $this->set('basewholesaleprice', $basewholesaleprice);
    $this->set('basetrimwholesaleprice', $basetrimwholesaleprice);
    $this->set('baseuphwholesaleprice', $baseuphwholesaleprice);
    $this->set('basefabricwholesaleprice', $basefabricwholesaleprice);
    $this->set('baseDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 3, ""));
    $this->set('baseFabricDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 17, ""));
    $this->set('baseUpholsteryDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 12, ""));
    $this->set('baseTrimDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 11, ""));
    $this->set('baseDrawersDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 13, ""));
    $this->set('basePoNo', $basePoNo);
    [$isComponentLocked, $lockColour] = $this->QcHistoryLatest->isComponentLocked($pn, 3);
    if (!$isComponentLocked && ($purchase['cancelled'] == 'y' || $purchase['completedorders'] == 'y')) {
        $isComponentLocked = true;
    }
    $this->set('isComponentLocked', $isComponentLocked ? 'true' : 'false');
    $this->set('lockColour', $lockColour);

    $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $purchase['ordercurrency']]]);
}


public function saveBase() {
    $this->autoRender = false;
    if (!$this->request->is('post')) {
        $this->Flash->success("Invalid call to edit");
        $this->redirect(array('controller' => 'Order', 'action' => 'index'));
        return;
    }
    $userId=$this->getCurrentUsersId();
    $formData = $this->request->getData();
    $pn = $formData['pn'];
    $purchase = $this->TempPurchase->get($pn);
    $purchase->baserequired = 'y';
    $purchase->basesavoirmodel = trim($formData['basesavoirmodel']);
    $purchase->basetype = trim($formData['basetype']);
    $purchase->basetickingoptions = trim($formData['basetickingoptions']);
    $purchase->basewidth = trim($formData['basewidth']);
    $purchase->baselength = trim($formData['baselength']);
    $purchase->baseinstructions = trim($formData['baseinstructions']);
    if (trim($formData['baseprice']=='')) {
        $purchase->baseprice = 0;
    } else {
        $purchase->baseprice = trim($formData['baseprice']);
    }
    $purchase->baseheightspring = trim($formData['spring']);
    $purchase->linkposition = trim($formData['linkposition']);
    if (trim($formData['linkposition'])== 'No Link Required') {
        $purchase->linkfinish = 'n';
    } else {
    $purchase->linkfinish = trim($formData['linkfinish']);
    }
    $purchase->basetrim = trim($formData['basetrim']);
    $purchase->basetrimcolour = trim($formData['basetrimcolour']);
    if (trim($formData['basetrim'])=='n') {
        $purchase->basetrimcolour = '';
        $purchase->basetrimprice = 0;
    } else {
        $purchase->basetrimprice = trim($formData['basetrimprice']);
    }
    $purchase->basedrawerconfigID = trim($formData['drawerconfig']);
    if ($formData['drawerconfig'] != 'n') {
        $purchase->basedrawerheight = trim($formData['drawerheight']); 
        $purchase->basedrawers = "Yes";  
        $purchase->basedrawersprice =  trim($formData['basedrawersprice']); 
    } else {
        $purchase->basedrawerheight = 'n'; 
        $purchase->basedrawers = "No"; 
        $purchase->basedrawersprice =  0;  
    }
    $purchase->upholsteredbase = trim($formData['upholsteredbase']);
    if ($formData['upholsteredbase'] != 'n' && $formData['upholsteredbase'] != 'TBC') {
        $purchase->basefabricdirection = trim($formData['basefabricdirection']);
        $purchase->basefabric = trim($formData['basefabric']);
        $purchase->basefabricchoice = trim($formData['basefabricchoice']);
        $purchase->basefabricdesc = trim($formData['basefabricdesc']);
        if (trim($formData['basefabricprice']=='')) {
            $purchase->basefabricprice = 0;
        } else {
            $purchase->basefabricprice = trim($formData['basefabricprice']);
        }
        if (trim($formData['upholsteryprice']=='')) {
            $purchase->upholsteryprice = 0;
        } else {
            $purchase->upholsteryprice = trim($formData['upholsteryprice']);
        }
        if (trim($formData['basefabriccost']=='')) {
            $purchase->basefabriccost = 0;
        } else {
            $purchase->basefabriccost = trim($formData['basefabriccost']);
        }
        if (trim($formData['basefabricmeters']=='')) {
            $purchase->basefabricmeters = 0;
        } else {
            $purchase->basefabricmeters = trim($formData['basefabricmeters']);
        }
    } else {
        $purchase->basefabricdirection = null;
        $purchase->basefabric = null;
        $purchase->basefabricchoice = null;
        $purchase->basefabricdesc = null;
        $purchase->basefabriccost = null;
        $purchase->basefabricmeters = null;
    }
    
    $this->TempPurchase->save($purchase);

    $this->saveWholesalePrice($formData['wbaseprice'], $pn, 3);

    $this->saveWholesalePrice($formData['wbasetrimprice'], $pn, 11);

    $this->saveWholesalePrice($formData['wbaseuphprice'], $pn, 12);

    $this->saveWholesalePrice($formData['wbasefabricprice'], $pn, 17);

    $this->TempCompPriceDiscount->upsertDiscount($pn, 3, $formData['basediscounttype'], $formData['baselistprice'], $formData['baseprice']);
    $this->TempCompPriceDiscount->upsertDiscount($pn, 17, $formData['basefabricdiscounttype'], $formData['basefabriclistprice'], $formData['basefabricprice']);
    $this->TempCompPriceDiscount->upsertDiscount($pn, 12, $formData['upholsterydiscounttype'], $formData['upholsterylistprice'], $formData['upholsteryprice']);
    $this->TempCompPriceDiscount->upsertDiscount($pn, 11, $formData['basetrimdiscounttype'], $formData['basetrimlistprice'], $formData['basetrimprice']);
    $this->TempCompPriceDiscount->upsertDiscount($pn, 13, $formData['basedrawersdiscounttype'], $formData['basedrawerslistprice'], $formData['basedrawersprice']);

    if (isset($pn)) {
        $this->TempQcHistory->insertQcHistoryRowIfNone($this->TempOrder, 3, $pn, $userId, $this->OrderHelper->getBaseMadeAt($purchase));
    }

    if ($formData['basewidth']!='Special Width' || $formData['baselength']!='Special Length') {
        $prodsizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();
        if (isset($prodsizes)) {
            $prodsizes->Base1Width = null;
            $prodsizes->Base2Width = null;
            $prodsizes->Base1Length = null;
            $prodsizes->Base2Length = null;
            $this->TempProductionSizes->save($prodsizes); 
        }
    }
    if ($formData['basewidth']=='Special Width' || $formData['baselength']=='Special Length') {
        $prodsizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();
        if (!isset($prodsizes)) {
            $prodsizes = $this->TempProductionSizes->newEntity([]);
            $prodsizes->ProductionSizesID = $this->TempOrder->getNextPrimeKeyValForTable('productionsizes', 1);
            $prodsizes->Purchase_No = $pn;
        } else {
            $prodsizes->Base1Width = null;
            $prodsizes->Base2Width = null;
            $prodsizes->Base1Length = null;
            $prodsizes->Base2Length = null;
        }
        if ($formData['basewidth']=='Special Width') {   
            if ($formData['base1width'] != '') {
                $prodsizes->Base1Width = trim($formData['base1width']);
            } else {
                $prodsizes->Base1Width = null;
            }
            if ($formData['base2width'] != '') {
                $prodsizes->Base2Width = trim($formData['base2width']);
            } else {
                $prodsizes->Base2Width = null;
            }
        }
        if ($formData['baselength']=='Special Length') {   
            if ($formData['base1length'] != '') {
                $prodsizes->Base1Length = trim($formData['base1length']);
            } else {
                $prodsizes->Base1Length = null;
            }
            if ($formData['base2length'] != '') {
                $prodsizes->Base2Length = trim($formData['base2length']);
            } else {
                $prodsizes->Base2Length = null;
            }
        }
        
        $this->TempProductionSizes->save($prodsizes); 
    }
    $this->OrderHelper->recalculateTotals($this->TempPurchase, $this->Location, $pn);

    $componentsToReload = [3]; // include itself
    $this->response = $this->response->withType('application/json');
    $this->response = $this->response->withStringBody(json_encode($componentsToReload));
    return $this->response;
}

public function removeBase() {
    $this->autoRender = false;
    $pn = $this->request->getQuery('pn');
    $purchase = $this->TempPurchase->get($pn);
    $purchase->baserequired = 'n';
    $this->TempPurchase->save($purchase);
    $this->TempCompPriceDiscount->deleteDiscount($pn, 3);
}
//base ends
//legs begins
public function legs() {
    $pn = $this->request->getQuery('pn');
    $purchase=$this->TempPurchase->get($pn);    
    $userregion=$this->getCurrentUserRegionId();
    $legs=$this->BedOptions->getLegs();
    $floortype=$this->BedOptions->getFloortype();
    $supportleg=$this->BedOptions->getSupportleg();

    $prodsizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();
    if (!isset($prodsizes)) {
        $prodsizes = ['legheight' => ''];
    }
    $legswholesaleprice='';
        $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 7])->first();
        if (isset($wholesaledata)) {
            $legswholesaleprice=$wholesaledata['price'];
        }
    $supportlegswholesaleprice='';
        $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 16])->first();
        if (isset($wholesaledata)) {
            $supportlegswholesaleprice=$wholesaledata['price'];
        }

    $this->set('userregion', $userregion);
    $this->set('purchase', $purchase);
    $this->set('legs', $legs);
    $this->set('floortype', $floortype);
    $this->set('supportleg', $supportleg);
    $this->set('prodsizes', $prodsizes);
    $this->set('legswholesaleprice', $legswholesaleprice);
    $this->set('supportlegswholesaleprice', $supportlegswholesaleprice);
    $this->set('legsDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 7, ""));
    $this->set('addLegsDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 16, ""));
    [$isComponentLocked, $lockColour] = $this->QcHistoryLatest->isComponentLocked($pn, 7);
    if (!$isComponentLocked && ($purchase['cancelled'] == 'y' || $purchase['completedorders'] == 'y')) {
        $isComponentLocked = true;
    }
    $this->set('isComponentLocked', $isComponentLocked ? 'true' : 'false');
    $this->set('lockColour', $lockColour);

    $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $purchase['ordercurrency']]]);
}

public function saveLegs() {
    $this->autoRender = false;
    if (!$this->request->is('post')) {
        $this->Flash->success("Invalid call to edit");
        $this->redirect(array('controller' => 'Order', 'action' => 'index'));
        return;
    }
    $userId=$this->getCurrentUsersId();
    $formData = $this->request->getData();
    $pn = $formData['pn'];
    $purchase = $this->TempPurchase->get($pn);
    $purchase->legsrequired = 'y';
    $purchase->legstyle = trim($formData['legstyle']);
    $purchase->LegQty = trim($formData['legqty']);
    $purchase->legfinish = trim($formData['legfinish']);
    $purchase->legheight = trim($formData['legheight']);
    $purchase->floortype = trim($formData['floortype']);
    $purchase->addlegstyle = trim($formData['addlegstyle']);
    $purchase->AddLegQty = trim($formData['addlegqty']);
    $purchase->addlegfinish = trim($formData['addlegfinish']);
    $purchase->specialinstructionslegs = trim($formData['legsinstructions']);
    $purchase->legprice = trim($formData['legprice']);
    $purchase->addlegprice = trim($formData['addlegsprice']);
    $this->TempPurchase->save($purchase);
    $this->TempCompPriceDiscount->upsertDiscount($pn, 7, $formData['legsdiscounttype'], $formData['legslistprice'], $formData['legprice']);
    $this->TempCompPriceDiscount->upsertDiscount($pn, 16, $formData['addlegsdiscounttype'], $formData['addlegslistprice'], $formData['addlegsprice']);

    if (isset($pn)) {
        $this->TempQcHistory->insertQcHistoryRowIfNone($this->TempOrder, 7, $pn, $userId, 2);
    }

    if ($formData['legheight']!='Special Height') {
        $prodsizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();
        if (isset($prodsizes)) {
            $prodsizes->legheight = null;
            $this->TempProductionSizes->save($prodsizes); 
        }
    }
    if ($formData['legheight']=='Special Height') {
        $prodsizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();
        if (!isset($prodsizes)) {
            $prodsizes = $this->TempProductionSizes->newEntity([]);
            $prodsizes->ProductionSizesID = $this->TempOrder->getNextPrimeKeyValForTable('productionsizes', 1);
            $prodsizes->Purchase_No = $pn;
        }
        $prodsizes->legheight = trim($formData['speciallegheight']);
        $this->TempProductionSizes->save($prodsizes); 
    }

    $this->saveWholesalePrice($formData['wlegprice'], $pn, 7);
    $this->saveWholesalePrice($formData['wsupportlegprice'], $pn, 16);
    $this->OrderHelper->recalculateTotals($this->TempPurchase, $this->Location, $pn);

    $componentsToReload = [7]; // include itself
    $this->response = $this->response->withType('application/json');
    $this->response = $this->response->withStringBody(json_encode($componentsToReload));
    return $this->response;
}

public function removeLegs() {
    $this->autoRender = false;
    $pn = $this->request->getQuery('pn');
    $purchase = $this->TempPurchase->get($pn);
    $purchase->legsrequired = 'n';
    $this->TempPurchase->save($purchase);
    $this->TempCompPriceDiscount->deleteDiscount($pn, 7);
}

//legs end 

//headboard begins
public function headboard() {
    $pn = $this->request->getQuery('pn');
    $purchase=$this->TempPurchase->get($pn);    
    $userregion=$this->getCurrentUserRegionId();
    $headboards=$this->BedOptions->getHeadboards();

    $hbwholesaleprice='';
        $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 8])->first();
        if (isset($wholesaledata)) {
            $hbwholesaleprice=$wholesaledata['price'];
        }
    $hbtrimwholesaleprice='';
        $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 10])->first();
        if (isset($wholesaledata)) {
            $hbtrimwholesaleprice=$wholesaledata['price'];
        }
    $hbfabricwholesaleprice='';
        $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 15])->first();
        if (isset($wholesaledata)) {
            $hbfabricwholesaleprice=$wholesaledata['price'];
        }
    $hbPoNo='';
    $qchData=$this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 8])->first();
    if (isset($qchData)) {
        $hbPoNo=$qchData['PONumber'];
    }

    $headboardheights=$this->BedOptions->getHeadboardHeight();
    $footboardheights=$this->BedOptions->getFootboardHeight();
    $footboardfinish=$this->BedOptions->getFootboardFinish();
    $fabricoptions=$this->BedOptions->getFabricOptions();
    $compwidths=$this->ComponentDimensions->getCompWidths($userregion);
    $hbfabdirection=$this->BedOptions->getBaseFabDirection();
    $hbtrim=$this->BedOptions->getHbTrim();
    $this->set('hbwholesaleprice', $hbwholesaleprice);
    $this->set('hbtrimwholesaleprice', $hbtrimwholesaleprice);
    $this->set('hbfabricwholesaleprice', $hbfabricwholesaleprice);
    $this->set('userregion', $userregion);
    $this->set('purchase', $purchase);
    $this->set('compwidths', $compwidths);
    $this->set('headboards', $headboards);
    $this->set('headboardheights', $headboardheights);
    $this->set('footboardheights', $footboardheights);
    $this->set('footboardfinish', $footboardfinish);
    $this->set('fabricoptions', $fabricoptions);
    $this->set('hbfabdirection', $hbfabdirection);
    $this->set('hbtrim', $hbtrim);
    $this->set('hbPoNo', $hbPoNo);
    $this->set('headboardDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 8, ""));
    $this->set('headboardTrimDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 10, ""));
    [$isComponentLocked, $lockColour] = $this->QcHistoryLatest->isComponentLocked($pn, 8);
    if (!$isComponentLocked && ($purchase['cancelled'] == 'y' || $purchase['completedorders'] == 'y')) {
        $isComponentLocked = true;
    }
    $this->set('isComponentLocked', $isComponentLocked ? 'true' : 'false');
    $this->set('lockColour', $lockColour);

    $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $purchase['ordercurrency']]]);
}

public function saveHeadboard() {
    $this->autoRender = false;
    if (!$this->request->is('post')) {
        $this->Flash->success("Invalid call to edit");
        $this->redirect(array('controller' => 'Order', 'action' => 'index'));
        return;
    }
    $userId=$this->getCurrentUsersId();
    $formData = $this->request->getData();
    $pn = $formData['pn'];
    $purchase = $this->TempPurchase->get($pn);
    $purchase->headboardrequired = 'y';
    $purchase->headboardstyle = trim($formData['headboardstyle']);
    $purchase->headboardheight = trim($formData['headboardheight']);
    $purchase->headboardWidth = trim($formData['hbwidth']);
    $purchase->headboardfinish = trim($formData['headboardfinish']);
    if (trim($formData['headboardstyle']) == 'Gorrivan Headboard & Footboard') {
        $purchase->footboardheight = trim($formData['footboardheight']);
        $purchase->footboardfinish = trim($formData['footboardfinish']);
    } else {
        $purchase->footboardheight = null;
        $purchase->footboardfinish = null;
    }
    $purchase->headboardlegqty = trim($formData['hblegqty']);
    $validValues = array("Manhattan Holly (Buttoned)", "Holly", "Hatti", "Harlech (CF2)", "Lotti (CF4)", "Leo (CF5)", "Winston (Stitched)", "C2", "C4", "C5", "CF2", "CF4", "CF5");
    if (in_array($formData['headboardstyle'], $validValues)) {
        $purchase->manhattantrim = trim($formData['manhattantrim']);
    } else {
        $purchase->manhattantrim = null;
    }
    $purchase->hbfabricoptions = trim($formData['hbfabricoptions']);
    $purchase->headboardfabric = trim($formData['headboardfabric']);
    $purchase->headboardfabricdirection = trim($formData['hbfabricdirection']);
    $purchase->hbfabricmeters = trim($formData['hbfabricmeters']);
    $purchase->hbfabriccost = trim($formData['hbfabriccost']);
    $purchase->headboardfabricchoice = trim($formData['headboardfabricchoice']);
    $purchase->headboardfabricdesc = trim($formData['headboardfabricdesc']);
    $purchase->specialinstructionsheadboard = trim($formData['specialinstructionsheadboard']);
    $purchase->headboardprice = trim($formData['headboardprice']);
    $purchase->hbfabricprice = trim($formData['hbfabricprice']);
    $purchase->headboardtrimprice = trim($formData['headboardtrimprice']);
    $this->TempPurchase->save($purchase);
    $this->TempCompPriceDiscount->upsertDiscount($pn, 8, $formData['headboarddiscounttype'], $formData['headboardlistprice'], $formData['headboardprice']);
    $this->TempCompPriceDiscount->upsertDiscount($pn, 10, $formData['headboardtrimdiscounttype'], $formData['headboardtrimlistprice'], $formData['headboardtrimprice']);

    if (isset($pn)) {
        $this->TempQcHistory->insertQcHistoryRowIfNone($this->TempOrder, 8, $pn, $userId, $this->OrderHelper->getHBMadeAt($purchase));
    }

    $this->saveWholesalePrice($formData['whbprice'], $pn, 8);
    $this->saveWholesalePrice($formData['whbfabricprice'], $pn, 15);
    $this->saveWholesalePrice($formData['whbtrimprice'], $pn, 10);
    $this->OrderHelper->recalculateTotals($this->TempPurchase, $this->Location, $pn);

    $componentsToReload = [8]; // include itself
    $this->response = $this->response->withType('application/json');
    $this->response = $this->response->withStringBody(json_encode($componentsToReload));
    return $this->response;
}

public function removeHeadboard() {
    $this->autoRender = false;
    $pn = $this->request->getQuery('pn');
    $purchase = $this->TempPurchase->get($pn);
    $purchase->headboardrequired = 'n';
    $this->TempPurchase->save($purchase);
    $this->TempCompPriceDiscount->deleteDiscount($pn, 8);
}

//headboard end 


//valance begins
public function valance() {
    $pn = $this->request->getQuery('pn');
    $purchase=$this->TempPurchase->get($pn);    
    $valancewholesaleprice='';
        $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 6])->first();
        if (isset($wholesaledata)) {
            $valancewholesaleprice=$wholesaledata['price'];
        }
    $valancefabricwholesaleprice='';
        $wholesaledata=$this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => 18])->first();
        if (isset($wholesaledata)) {
            $valancefabricwholesaleprice=$wholesaledata['price'];
        }
    $valancePoNo='';
    $qchData=$this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 6])->first();
    if (isset($qchData)) {
        $valancePoNo=$qchData['PONumber'];
    }
    $userregion=$this->getCurrentUserRegionId();
    $pleatno=$this->BedOptions->getPleatNo();
    $fabricoptions=$this->BedOptions->getFabricOptions();
    $valancefabdirection=$this->BedOptions->getBaseFabDirection();
    $this->set('valancewholesaleprice', $valancewholesaleprice);
    $this->set('valancefabricwholesaleprice', $valancefabricwholesaleprice);
    $this->set('userregion', $userregion);
    $this->set('purchase', $purchase);
    $this->set('pleatno', $pleatno);
    $this->set('fabricoptions', $fabricoptions);
    $this->set('valancefabdirection', $valancefabdirection);
    $this->set('valancePoNo', $valancePoNo);
    $this->set('valanceDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 6, ""));
    [$isComponentLocked, $lockColour] = $this->QcHistoryLatest->isComponentLocked($pn, 6);
    if (!$isComponentLocked && ($purchase['cancelled'] == 'y' || $purchase['completedorders'] == 'y')) {
        $isComponentLocked = true;
    }
    $this->set('isComponentLocked', $isComponentLocked ? 'true' : 'false');
    $this->set('lockColour', $lockColour);

    $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $purchase['ordercurrency']]]);
}

public function saveValance() {
    $this->autoRender = false;
    if (!$this->request->is('post')) {
        $this->Flash->success("Invalid call to edit");
        $this->redirect(array('controller' => 'Order', 'action' => 'index'));
        return;
    }
    $userId=$this->getCurrentUsersId();
    $formData = $this->request->getData();
    $pn = $formData['pn'];
    $purchase = $this->TempPurchase->get($pn);
    $purchase->valancerequired = 'y';
    $purchase->pleats = trim($formData['pleats']);
    $purchase->valancefabricoptions = trim($formData['valancefabricoptions']);
    $purchase->valancefabricdirection = trim($formData['valancefabricdirection']);
    $purchase->valancefabric = trim($formData['valancefabric']);
    $purchase->valancefabricchoice = trim($formData['valancefabricchoice']);
    $purchase->valfabricmeters = trim($formData['valfabricmeters']);
    $purchase->valfabriccost = trim($formData['valfabriccost']);
    $purchase->valfabricprice = trim($formData['valfabricprice']);
    $purchase->valancedrop = trim($formData['valancedrop']);
    $purchase->valancewidth = trim($formData['valancewidth']);
    $purchase->valancelength = trim($formData['valancelength']);
    $purchase->specialinstructionsvalance = trim($formData['specialinstructionsvalance']);
    if (empty($formData['valanceprice'])) {
        $purchase->valanceprice = 0;
    } else {
        $purchase->valanceprice = trim($formData['valanceprice']);
    }
    $this->TempPurchase->save($purchase);
    // no discounts on valances
    //$this->TempCompPriceDiscount->upsertDiscount($pn, 6, $formData['valancediscounttype'], $formData['valancelistprice'], $formData['valanceprice']);

    if (isset($pn)) {
        $this->TempQcHistory->insertQcHistoryRowIfNone($this->TempOrder, 6, $pn, $userId, 2);
    }

    $this->saveWholesalePrice($formData['wvalanceprice'], $pn, 6);
    $this->saveWholesalePrice($formData['wvalancefabricprice'], $pn, 18);
    $this->OrderHelper->recalculateTotals($this->TempPurchase, $this->Location, $pn);

    $componentsToReload = [6]; // include itself
    $this->response = $this->response->withType('application/json');
    $this->response = $this->response->withStringBody(json_encode($componentsToReload));
    return $this->response;
}

public function removeValance() {
    $this->autoRender = false;
    $pn = $this->request->getQuery('pn');
    $purchase = $this->TempPurchase->get($pn);
    $purchase->valancerequired = 'n';
    $this->TempPurchase->save($purchase);
    $this->TempCompPriceDiscount->deleteDiscount($pn, 6);
}

//valance end 

//acc begins
public function accessories() {
    $pn = $this->request->getQuery('pn');
    $purchase=$this->TempPurchase->get($pn); 
    $accessories=$this->TempAccessory->getAccessories($pn);
    $userregion=$this->getCurrentUserRegionId();
    $this->set('userregion', $userregion);
    $this->set('purchase', $purchase);
    $this->set('accessories', $accessories);
    [$isComponentLocked, $lockColour] = $this->QcHistoryLatest->isComponentLocked($pn, 9);
    if (!$isComponentLocked && ($purchase['cancelled'] == 'y' || $purchase['completedorders'] == 'y')) {
        $isComponentLocked = true;
    }
    $this->set('isComponentLocked', $isComponentLocked ? 'true' : 'false');
    $this->set('lockColour', $lockColour);

    $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $purchase['ordercurrency']]]);
}

public function saveAccessories() {
    $this->autoRender = false;
    if (!$this->request->is('post')) {
        $this->Flash->success("Invalid call to edit");
        $this->redirect(array('controller' => 'Order', 'action' => 'index'));
        return;
    }
    $userId=$this->getCurrentUsersId();
    $formData = $this->request->getData();
    $pn = $formData['pn'];
    $total=0;       
    for ($i = 1; $i <= 21; $i++) {
        if (isset($formData['acc_delete'.$i]) && $formData['acc_delete'.$i] != '') {
            $accs = $this->TempAccessory->get($formData['accid'.$i]);
            $this->TempAccessory->delete($accs);
            continue;
        }
        $qty=0;
        $price=0;
        if ($formData['acc_desc'.$i] != '') {
            
            if ($formData['accid'.$i] != '') {
                $accs = $this->TempAccessory->get($formData['accid'.$i]);
            } else {
                $accs = $this->TempAccessory->newEntity([]);
                $accs->orderaccessory_id = $this->TempOrder->getNextPrimeKeyValForTable('orderaccessory', 1);
            }
            if ($formData['acc_wholesalePrice'.$i] != '') {
                $accs->wholesalePrice = $formData['acc_wholesalePrice'.$i];
            }
            $accs->description = $formData['acc_desc'.$i];
            $accs->design = $formData['acc_design'.$i];
            $accs->colour = $formData['acc_colour'.$i];
            $accs->size = $formData['acc_size'.$i];
            $accs->unitprice = $formData['acc_unitprice'.$i];
            $accs->qty = $formData['acc_qty'.$i];
            $qty=floatval($formData['acc_qty'.$i]);
            $price=floatval($formData['acc_unitprice'.$i]);
            $subtotal =$qty * $price;
            $total += $subtotal;
            $accs->purchase_no = $pn;
            
            $this->TempAccessory->save($accs);
        }
    }

    $purchase = $this->TempPurchase->get($pn);
    $purchase->accessoriesrequired = 'y';
    $purchase->accessoriestotalcost = $total;
    $this->TempPurchase->save($purchase);
        
    if (isset($pn)) {
        $this->TempQcHistory->insertQcHistoryRowIfNone($this->TempOrder, 9, $pn, $userId, 0);
    }  
    $this->OrderHelper->recalculateTotals($this->TempPurchase, $this->Location, $pn);
        
    $componentsToReload = [9]; // include itself
    $this->response = $this->response->withType('application/json');
    $this->response = $this->response->withStringBody(json_encode($componentsToReload));
    return $this->response;
}

public function removeAccessories() {
    $this->autoRender = false;
    $pn = $this->request->getQuery('pn');
    $purchase = $this->TempPurchase->get($pn);
    $purchase->accessoriesrequired = 'n';
    $this->TempPurchase->save($purchase);
}

//acc end 


//delivery begins
public function delivery() {
    $pn = $this->request->getQuery('pn');
    $purchase=$this->TempPurchase->get($pn);    
    $userregion=$this->getCurrentUserRegionId();
    $this->set('userregion', $userregion);
    $this->set('purchase', $purchase);
    $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $purchase['ordercurrency']]]);
}

public function saveDelivery() {
    $this->autoRender = false;
    if (!$this->request->is('post')) {
        $this->Flash->success("Invalid call to edit");
        $this->redirect(array('controller' => 'Order', 'action' => 'index'));
        return;
    }
    $formData = $this->request->getData();
    $pn = $formData['pn'];
    $purchase = $this->TempPurchase->get($pn);
    $purchase->deliverycharge = 'y';
    $purchase->deliveryprice = isset($formData['deliveryprice']) ? $formData['deliveryprice'] : 0;
    $purchase->accesscheck = $formData['accesscheck'];
    $purchase->specialinstructionsdelivery = $formData['specialinstructionsdelivery'];
    $purchase->oldbed = $formData['disposal'];
    $this->TempPurchase->save($purchase);
    $this->OrderHelper->recalculateTotals($this->TempPurchase, $this->Location, $pn);
 }

public function removeDelivery() {
    $this->autoRender = false;
    $pn = $this->request->getQuery('pn');
    $purchase = $this->TempPurchase->get($pn);
    $purchase->deliverycharge = 'n';
    $this->TempPurchase->save($purchase);
}

//delivery end

//order summary begins
public function ordersummary() {
    $pn = $this->request->getQuery('pn');
    $purchase=$this->TempPurchase->get($pn);    
    $userregion=$this->getCurrentUserRegionId();
    $locationinfo=$this->Location->get($this->getCurrentUserLocationId());
    $OrderTotalExVAT="Order Total, Ex VAT";
    $VATWording="VAT";
    $VATRatewording="VAT Rate";
    if ($userregion==23 || $userregion==4) {
        $OrderTotalExVAT="Sub Total";
        $VATWording="Sales Tax";
        $VATRatewording="Sales Tax";
    } 
    $paymentsTotal=0;
    $paymentsTotal = $this->TempPayment->getPaymentSum($pn)[0]['paymenttotal'];
    $notinvoiced= $purchase['total']-$paymentsTotal;
    $paymentsfororder='';
    $paymentsfororder=$this->TempPayment->getPayments($pn);
    $pendinginvoices='';
    $pendinginvoices=$this->TempPayment->getPendingInvoices($pn);
    $mattressinc='';
    $topperinc='';
    $legsinc='';
    $baseinc='';
    $hbinc='';
    $valanceinc='';
    $accinc='';
    if ($purchase['mattressrequired']=='y') {
        $mattressinc='y';
        $this->set('mattressDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 1, ""));
    }
    if ($purchase['topperrequired']=='y') {
        $topperinc='y';
        $this->set('topperDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 5, ""));
    }
    if ($purchase['legsrequired']=='y') {
        $legsinc='y';
        $this->set('legsDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 7, ""));
        $this->set('addLegsDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 16, ""));
    }
    if ($purchase['baserequired']=='y') {
        $baseinc='y';
        $this->set('baseDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 3, ""));
        $this->set('baseFabricDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 17, ""));
        $this->set('baseUpholsteryDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 12, ""));
        $this->set('baseTrimDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 11, ""));
        $this->set('baseDrawersDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 13, ""));
    }
    if ($purchase['headboardrequired']=='y') {
        $hbinc='y';
        $this->set('headboardDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 8, ""));
        $this->set('headboardTrimDiscount', $this->TempCompPriceDiscount->getDiscount($pn, 10, ""));
    }
    if ($purchase['valancerequired']=='y') {
        $valanceinc='y';
    }
    if ($purchase['accessoriesrequired']=='y') {
        $accinc='y';
    }
    $this->set('paymentsTotal', $paymentsTotal);
    $this->set('paymentsfororder', $paymentsfororder);
    $this->set('pendinginvoices', $pendinginvoices);
    $this->set('notinvoiced', $notinvoiced);
    $this->set('OrderTotalExVAT', $OrderTotalExVAT);
    $this->set('VATWording', $VATWording);
    $this->set('VATRatewording', $VATRatewording);
    $this->set('mattressinc', $mattressinc);
    $this->set('topperinc', $topperinc);
    $this->set('legsinc', $legsinc);
    $this->set('baseinc', $baseinc);
    $this->set('hbinc', $hbinc);
    $this->set('accinc', $accinc);
    $this->set('valanceinc', $valanceinc);
    $this->set('userregion', $userregion);
    $this->set('purchase', $purchase);
    $this->set('deliveryIncludesVat', $locationinfo['delivery_includes_vat']=='y');
    $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $purchase['ordercurrency']]]);
}

public function saveOrdersummary() {
    $this->autoRender = false;
    if (!$this->request->is('post')) {
        $this->Flash->success("Invalid call to edit");
        $this->redirect(array('controller' => 'Order', 'action' => 'index'));
        return;
    }
    
    $formData = $this->request->getData();
    foreach ($formData as $key => $value) {
        // Check if the key matches the radio button pattern
        if (strpos($key, 'invono_') !== false) {
            $paymentid = str_replace('invono_', '', $key);
            
            $paymentupdate = $this->TempPayment->find()->where(['paymentid' => $paymentid])->first();
            $paymentupdate->invoice_number=$formData['invono_'.$paymentid];
            $this->TempPayment->save($paymentupdate);
        }               
    }

    $pn = $formData['pn'];
    $purchase = $this->TempPurchase->get($pn);
    $purchase['discounttype'] = $formData['dc'];
    $purchase['discount'] = $formData['dcresult'];
    $this->TempPurchase->save($purchase);
    $this->OrderHelper->recalculateTotals($this->TempPurchase, $this->Location, $pn);

    $componentsToReload = [98]; // include itself
    $this->response = $this->response->withType('application/json');
    $this->response = $this->response->withStringBody(json_encode($componentsToReload));
    return $this->response;
 }
//order summary ends

//order payments begins
public function orderpayments() {
    $pn = $this->request->getQuery('pn');
    $purchase=$this->TempPurchase->get($pn); 
    $paymentmethods=$this->TempPayment->getPaymentMethods();
    $userregion=$this->getCurrentUserRegionId();
    $userlocation=$this->getCurrentUserLocationId();
    $orderhasexportsnoinvoices=$this->TempOrder->orderhasexportsNoInvoices($pn);
    $orderhasexports=$this->TempOrder->orderhasexports($pn); //here invoices have been allocated
    $noofinvoices=count($orderhasexportsnoinvoices);

    $pendinginvoices='';
    $pendinginvoices=$this->TempOrder->getPendingInvoices($pn);
    $finalinvoiceno='';
    $finalinvoiceno=$this->TempPayment->getFinalInvoiceNo($pn);
    if ($purchase['quote']=='y') {
        $quote='y';
    } else {
        $quote='n';
    }
    
    $this->set('paymentmethods', $paymentmethods);
    $this->set('pendinginvoices', $pendinginvoices);
    $this->set('finalinvoiceno', $finalinvoiceno);
    $this->set('orderhasexportsnoinvoices', $orderhasexportsnoinvoices);
    $this->set('orderhasexports', $orderhasexports);
    
    $this->set('noofinvoices', $noofinvoices);
    $this->set('userregion', $userregion);
    $this->set('userlocation', $userlocation);
    $this->set('quote', $quote);
    $this->set('purchase', $purchase);
    $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $purchase['ordercurrency']]]);
}

public function saveOrderpayments() {
    $this->autoRender = false;

    $formData = $this->request->getData();

    if ($formData['additionalpayment'] == '' && $formData['refund'] == '') {
        return;
    }

    $pn = $formData['pn'];
    $purchase = $this->TempPurchase->get($pn);
    $paymentsForOrder = $this->TempPayment->getPayments($pn);
    $salesusername = $this->getCurrentUserName();
    $additionalPaymentEmailReq=false;
    
    if ($formData['additionalpayment'] != '') {
        $oldPaymentsTotal = $this->TempPayment->getPaymentSum($pn)[0]['paymenttotal'];
        $paymentamount = floatval($formData['additionalpayment']);
        $newPaymentsTotal = $oldPaymentsTotal + $paymentamount;
        $newbalanceoutstanding = $purchase->total - $newPaymentsTotal;
        if ($newbalanceoutstanding >= 0) {
            $payment = $this->TempPayment->newEntity([]);
            $payment->paymentid  = $this->TempOrder->getNextPrimeKeyValForTable('payment', 1);
            $payment->paymentmethodid = $formData['paymentmethod'];
            if ($newbalanceoutstanding == 0 && count($paymentsForOrder) == 0) {
                $payment->paymenttype = 'Full Payment';
            } else if ($newbalanceoutstanding == 0) {
                $payment->paymenttype = 'Final Payment';
            } else if (count($paymentsForOrder) == 0) {
                $payment->paymenttype = 'Deposit';
            } else {
                $payment->paymenttype = 'Additional Payment';  
            }
            $payment->amount = $paymentamount;
            $payment->salesusername = $salesusername;
            $payment->purchase_no = $pn;
            $payment->invoice_number = $formData['invoiceno'];
            if ($formData['invoicedate'] != '') {
                $payment->invoicedate = FrozenTime::createFromFormat('d/m/Y', $formData['invoicedate']);
            }
            if ($formData['creditdetails'] != '') {
                $payment->creditdetails = $formData['creditdetails'];
            }
            $payment->placed = date("Y/m/d h:i:s");
            $payment->receiptno = $this->Comreg->getNextReceiptNumber();
            $this->TempPayment->save($payment);
            $paymentid=$payment['paymentid'];
            $this->OrderEmailHelper->sendAdditionalPaymentEmail(true, $pn, $this->getCurrentUserName(), $this->getCurrentUserRegionId(), $this->getCurrentUserLocationId(), $paymentid);
        }

    }

    if (isset($formData['exportchoice'])) {
        $exportcollectionsID = $formData['exportchoice'];
        $exportLinks = $this->TempExportLinks->getExportLinksForExportcollectionsID($exportcollectionsID, $pn);
        foreach ($exportLinks as $links) {
            $exportLink = $this->TempExportLinks->get($links['exportLinksID']);
            $exportLink->InvoiceNo=$formData['invoiceno'];
            $exportLink->InvoiceDate=FrozenDate::createFromFormat('d/m/Y', $formData['invoicedate']);
            $this->TempExportLinks->save($exportLink);
        }
    }

    if ($formData['refund'] != '') {
        $refundamount = floatval($formData['refund']);
        $oldPaymentsTotal = $this->TempPayment->getPaymentSum($pn)[0]['paymenttotal'];
        $newPaymentsTotal = $oldPaymentsTotal - $refundamount;
        if ($newPaymentsTotal >= 0) {
            $payment = $this->TempPayment->newEntity([]);
            $payment->paymentid  = $this->TempOrder->getNextPrimeKeyValForTable('payment', 1);
            $payment->paymentmethodid = $formData['refundmethod'];
            $payment->paymenttype = 'Refund';
            $payment->amount = $refundamount * -1.0;
            $payment->salesusername = $salesusername;
            $payment->purchase_no = $pn;
            $payment->invoice_number = $formData['invoiceno'];
            if ($formData['invoicedate'] != '') {
                $payment->invoicedate = FrozenTime::createFromFormat('d/m/Y', $formData['invoicedate']);
            }
            if ($formData['creditdetails'] != '') {
                $payment->creditdetails = $formData['creditdetails'];
            }
            $payment->placed = date("Y/m/d h:i:s");
            $payment->receiptno = $this->Comreg->getNextReceiptNumber();
            $this->TempPayment->save($payment);
            $paymentid=$payment['paymentid'];
            $this->OrderEmailHelper->sendRefundEmail(true, $pn, $this->getCurrentUserName(), $this->getCurrentUserRegionId(), $this->getCurrentUserLocationId(), $paymentid);
           
            
        }
        
    }

    $purchase->paymentstotal = $this->TempPayment->getPaymentSum($pn)[0]['paymenttotal'];
    $purchase->balanceoutstanding = $purchase->total - $purchase->paymentstotal;
    $this->TempPurchase->save($purchase);
    $this->OrderHelper->recalculateTotals($this->TempPurchase, $this->Location, $pn);
    
    $componentsToReload = [97, 98]; // self & order summary
    $this->response = $this->response->withType('application/json');
    $this->response = $this->response->withStringBody(json_encode($componentsToReload));
    return $this->response;

}
//order payments ends

    public function updateOrder() {
        $this->autoRender = false;
        $pn = $this->request->getQuery('pn');

        // recalculate totals
        $this->OrderHelper->recalculateTotals($this->TempPurchase, $this->Location, $pn);

        // delete any orphan rows or data as a result of components having been removed
        $this->OrderHelper->cleanUpPurchase($pn, $this->TempPurchase, $this->TempQcHistory, $this->QcHistoryLatest, $this->TempCompPriceDiscount, $this->TempWholesalePrices, $this->TempProductionSizes, $this->TempAccessory);

        // move the data to the real tables
        $oldRecords=$this->TempOrder->moveTempTablesToRealPurchase($pn, $this->getCurrentUsersId(), $this->PurchaseHistory, false);
    
        // send the order changes emails
        $realPurchaseTable = TableRegistry::getTableLocator()->get('Purchase');
        $purchase = $realPurchaseTable->get($pn);
        $oldPurchase = $oldRecords['purchase'];
        $realAccesoriesTable = TableRegistry::getTableLocator()->get('Accessory');
        $accessories = $realAccesoriesTable->find('all')->where(['purchase_no' => $pn])->toArray();
        $this->OrderEmailHelper->sendFabricAccEmail($purchase, $oldPurchase, $accessories, $oldRecords['accessories'], $this->getCurrentUserName(), $this->getCurrentUserRegionId(), $this->getCurrentUserLocationId());
        $significantChanges = $this->OrderEmailHelper->sendPurchaseChangedEmail($purchase->toArray(), $oldPurchase, $this->getCurrentUserName(), $this->getCurrentUserRegionId(), $this->getCurrentUserLocationId());
        if ($significantChanges) {
            $purchase['orderConfirmationStatus'] = 'n';
            $realPurchaseTable->save($purchase);
        }

        $this->removeUnwantedPackagingData($pn, $oldPurchase, $purchase, $oldRecords['productionSizes']);
        
        //$this->OrderEmailHelper->sendOrderToBedworks($pn, $this->getCurrentUserName(), $this->getCurrentUserRegionId(), $this->getCurrentUserLocationId());

        $this->redirect(['controller' => 'Order', 'action' => 'index', '?' => ['pn' => $pn]]);
    }

    private function removeUnwantedPackagingData($pn, $oldPurchase, $purchase, $oldProductionSizes) {
        $realProductionSizesTable = TableRegistry::getTableLocator()->get('ProductionSizes');
        $packagingDataTable = TableRegistry::getTableLocator()->get('PackagingData');
        $productionSizes = $this->TempProductionSizes->find()->where(['Purchase_No' => $pn])->first();

        if ($this->notEqual($productionSizes, 'Matt1Width', $oldProductionSizes, 'Matt1Width') || $this->notEqual($productionSizes, 'Matt1Length', $oldProductionSizes, 'Matt1Length') || $this->notEqual($productionSizes, 'Matt2Width', $oldProductionSizes, 'Matt2Width') || $this->notEqual($productionSizes, 'Matt2Length', $oldProductionSizes, 'Matt2Length')) {
            $packagingDataTable->deletePackagingDataForComponent($pn, 1);   
        }
        if ($this->notEqual($oldPurchase, 'mattresswidth', $purchase, 'mattresswidth') || $this->notEqual($oldPurchase, 'mattresslength', $purchase, 'mattresslength') || $this->notEqual($oldPurchase, 'savoirmodel', $purchase, 'savoirmodel') || $this->notEqual($oldPurchase, 'mattresstype', $purchase, 'mattresstype')) {
            $packagingDataTable->deletePackagingDataForComponent($pn, 1);
        }
        if ($this->notEqual($productionSizes, 'Base1Width', $oldProductionSizes, 'Base1Width') || $this->notEqual($productionSizes, 'Base1Length', $oldProductionSizes, 'Base1Length') || $this->notEqual($productionSizes, 'Base2Width', $oldProductionSizes, 'Base2Width') || $this->notEqual($productionSizes, 'Base2Length', $oldProductionSizes, 'Base2Length')) {
            $packagingDataTable->deletePackagingDataForComponent($pn, 3);   
        }
        if ($this->notEqual($oldPurchase, 'basewidth', $purchase, 'basewidth') || $this->notEqual($oldPurchase, 'baselength', $purchase, 'baselength') || $this->notEqual($oldPurchase, 'basesavoirmodel', $purchase, 'basesavoirmodel') || $this->notEqual($oldPurchase, 'basetype', $purchase, 'basetype')) {
            $packagingDataTable->deletePackagingDataForComponent($pn, 3);
        }
        if ($this->notEqual($productionSizes, 'topper1Width', $oldProductionSizes, 'topper1Width') || $this->notEqual($productionSizes, 'topper1Length', $oldProductionSizes, 'topper1Length')) {
            $packagingDataTable->deletePackagingDataForComponent($pn, 5);   
        }
        if ($this->notEqual($oldPurchase, 'topperwidth', $purchase, 'topperwidth') || $this->notEqual($oldPurchase, 'topperlength', $purchase, 'topperlength') || $this->notEqual($oldPurchase, 'toppertype', $purchase, 'toppertype')) {
            $packagingDataTable->deletePackagingDataForComponent($pn, 5);
        }
        if ($this->notEqual($productionSizes, 'legheight', $oldProductionSizes, 'legheight')) {
            $packagingDataTable->deletePackagingDataForComponent($pn, 7);   
        }
        if ($this->notEqual($oldPurchase, 'legheight', $purchase, 'legheight')) {
            $packagingDataTable->deletePackagingDataForComponent($pn, 7);
        }
        if ($this->notEqual($oldPurchase, 'headboardstyle', $purchase, 'headboardstyle') ||  $this->notEqual($oldPurchase, 'headboardWidth', $purchase, 'headboardWidth')) {
            $packagingDataTable->deletePackagingDataForComponent($pn, 8);
        }
    }

    private function notEqual($obj1, $key1, $obj2, $key2) {
        $val1 = null;
        $val2 = null;
        if (isset($obj1) && isset($obj1[$key1])) {
            $val1 = $obj1[$key1];
        }
        //debug($obj2);
        //debug($key2);
        if (isset($obj2) && isset($obj2[$key2])) {
            $val2 = $obj2[$key2];
        }
        return $val1 != $val2;
    }

    public function checkPurchaseStamp() {
        $this->autoRender = false;
        $pn = $this->request->getQuery('pn');
        $storedStamp = $this->TempOrder->getPurchaseStampFromRealTable($pn);
        $stamp = $this->request->getQuery('stamp');
        $response = null;
        if (empty($storedStamp) || $storedStamp == $stamp) {
            $response = ['valid' => true];
        } else {
            $values = explode(" ", $storedStamp);
            $user = TableRegistry::getTableLocator()->get("SavoirUser")->get($values[0]);
            $modificationDate = date('H:i:s d/m/Y', $values[1]);
            $msg = "The order was modified by " . $user['username'] . " at " . $modificationDate . ". Click OK to overwrite the changes.";
            $response = ['valid' => false, 'msg' => $msg];
        }
        $this->response = $this->response->withType('application/json');
        $this->response = $this->response->withStringBody(json_encode($response));
        return $this->response;
    }

    
    public function duplicateOrder() {
        // wrap in a transaction
		$conn = ConnectionManager::get('default');
		$conn->begin();
        
        $pn = $this->request->getQuery('order');
        $ordersource = $this->request->getQuery('ordersource');
        $purchaseTable = TableRegistry::get('Purchase');
        $QCHistoryTable = TableRegistry::get('QcHistory');
        //$accessoryTable = TableRegistry::get('Accessory');
        $sourceorder=$purchaseTable->get($pn);
        $contactno=$sourceorder['contact_no'];
        $origOrderNo=$sourceorder['ORDER_NUMBER'];
        $fieldsToCopy = array('CODE','accessoriesrequired','accessoriestotalcost','AccountCode','addlegfinish','addlegprice','AddLegQty','addlegstyle','alpha_name','AmendedDate','balanceoutstanding','base2length','base2width','basedepth','basedrawerconfigID','basedrawerheight','basedrawers','basedrawersprice','basefabric','basefabricchoice','basefabriccost','basefabricdesc','basefabricdirection', 'basefabricmeters','basefabricprice','baseheightspring','baseinstructions','baselength','baseprice','baseqty','baserequired','basesavoirmodel','basetickingoptions','basetrim','basetrimcolour', 'basetrimprice','basetype','baseunitprice','basewidth','BED','bedsettotal','companyname','completedorders','contact_no','deliveryadd1','deliveryadd2','deliveryadd3','deliveryContact', 'deliverycountry','deliverycounty','deliveryinstructions','deliverypostcode','deliveryprice','deliverytown','discount','discounttype','drawerprice','drawerqty','drawertotal','extbase','floortype','footboardfinish','footboardheight','hbfabriccost','hbfabricmeters','hbfabricoptions','hbfabricprice','hblegheight','hbqty','hbunitprice','headboardfabric','headboardfabricchoice','headboardfabricdesc','headboardfabricdirection','headboardfinish','headboardheight','headboardlegqty','headboardprice','headboardrequired','headboardstyle','headboardtrimprice','headboardUnitPrice','headboardWidth','idlocation','istrade','leftsupport','legfinish','legheight','legposition','legprice','LegQty','legShape','legsrequired','legstyle','legUnitPrice','linkfinish','linkposition','manhattantrim','mattqty','mattr','mattress1length','mattress1width','mattress2length','mattress2width','mattressinstructions','mattresslength','mattressprice','mattressrequired','mattresstype','mattresswidth','mattunitprice','optcounter','ORDER_DATE','ORDER_NUMBER','ordercompletedDate','ordercompletedUser','orderConfirmationStatus','ordercurrency','orderonhold','orderSource','ordertype','overseasduty','overseasOrder','OWNING_REGION','paymentstotal','pinnacle','pinnacleAddItemsRequired','pinnacleBedRef','pleats','quote','rightsupport','salesusername','savoirmodel','shipperID','SOURCE_SITE','specialinstructionsdelivery','specialinstructionsheadboard','specialinstructionslegs','specialinstructionstopper','specialinstructionsvalance','stamp','subtotal','tickingoptions','topperlength','topperprice','topperrequired','toppertickingoptions','toppertype','topperwidth','total','totalexvat','tradediscount','tradediscountrate','upholsteredbase','upholsteryprice','UphUnitPrice','valancedrop','valancefabric','valancefabricchoice','valancefabricdesc','valancefabricdirection','valancefabricoptions','valancefabricstatusid','valancelength','valanceprice','valancerequired','valancewidth','valfabriccost','valfabricmeters','valfabricprice','vat','vatrate','ventfinish','ventposition','version','wholesaleInv');
        
        $newPurchaseRow = $purchaseTable->newEntity([]);
        
        foreach ($fieldsToCopy as $field) {
            if (isset($sourceorder[$field])) {
                $newPurchaseRow[$field] = $sourceorder[$field];
            }
        }
        $newPurchaseRow['ORDER_NUMBER']=$this->Comreg->getNextOrderNumber();
        $newPurchaseRow['completedorders']='n';
        $newPurchaseRow['orderConfirmationStatus']='n';
        $newPurchaseRow['orderonhold']='n';
        $newPurchaseRow['ORDER_DATE']=date("Y/m/d h:i:s");
        $newPurchaseRow['AmendedDate']=date("Y/m/d h:i:s");
        $newPurchaseRow['orderSource']=$ordersource;
        $newPurchaseRow['copied_from_pn']=$pn; 
      
        $purchaseTable->save($newPurchaseRow);
        $newpn=$newPurchaseRow['PURCHASE_No'];
        $newOrderNo=$newPurchaseRow['ORDER_NUMBER'];
        //add history rows
        $newHistoryRow = $QCHistoryTable->newEntity([]);
        $newHistoryRow['ComponentID']=0;
        $newHistoryRow['QC_StatusID']=0;
        $newHistoryRow['Purchase_No']=$newpn;
        $newHistoryRow['QC_Date']=date("Y/m/d h:i:s");
        $newHistoryRow['UpdatedBy']=$this->getCurrentUsersId();
        $QCHistoryTable->save($newHistoryRow);

        if ($sourceorder['mattressrequired']=='y') {
            $newHistoryRow = $QCHistoryTable->newEntity([]);
            $newHistoryRow['ComponentID']=1;
            $newHistoryRow['QC_StatusID']=0;
            $newHistoryRow['Purchase_No']=$newpn;
            $newHistoryRow['QC_Date']=date("Y/m/d h:i:s");
            $newHistoryRow['UpdatedBy']=$this->getCurrentUsersId();
            $newHistoryRow['MadeAt']=$this->OrderHelper->getMattressMadeAt($sourceorder);
            $QCHistoryTable->save($newHistoryRow);
        }
        if ($sourceorder['baserequired']=='y') {
            $newHistoryRow = $QCHistoryTable->newEntity([]);
            $newHistoryRow['ComponentID']=3;
            $newHistoryRow['QC_StatusID']=0;
            $newHistoryRow['Purchase_No']=$newpn;
            $newHistoryRow['QC_Date']=date("Y/m/d h:i:s");
            $newHistoryRow['UpdatedBy']=$this->getCurrentUsersId();
            $newHistoryRow['MadeAt']=$this->OrderHelper->getBaseMadeAt($sourceorder);
            $QCHistoryTable->save($newHistoryRow);
        }
        if ($sourceorder['topperrequired']=='y') {
            $newHistoryRow = $QCHistoryTable->newEntity([]);
            $newHistoryRow['ComponentID']=5;
            $newHistoryRow['QC_StatusID']=0;
            $newHistoryRow['Purchase_No']=$newpn;
            $newHistoryRow['QC_Date']=date("Y/m/d h:i:s");
            $newHistoryRow['UpdatedBy']=$this->getCurrentUsersId();
            $newHistoryRow['MadeAt']=$this->OrderHelper->getTopperMadeAt($sourceorder);
            $QCHistoryTable->save($newHistoryRow);
        }
        if ($sourceorder['valancerequired']=='y') {
            $newHistoryRow = $QCHistoryTable->newEntity([]);
            $newHistoryRow['ComponentID']=6;
            $newHistoryRow['QC_StatusID']=0;
            $newHistoryRow['Purchase_No']=$newpn;
            $newHistoryRow['QC_Date']=date("Y/m/d h:i:s");
            $newHistoryRow['UpdatedBy']=$this->getCurrentUsersId();
            $newHistoryRow['MadeAt']=2;
            $QCHistoryTable->save($newHistoryRow);
        }
        if ($sourceorder['legsrequired']=='y') {
            $newHistoryRow = $QCHistoryTable->newEntity([]);
            $newHistoryRow['ComponentID']=7;
            $newHistoryRow['QC_StatusID']=0;
            $newHistoryRow['Purchase_No']=$newpn;
            $newHistoryRow['QC_Date']=date("Y/m/d h:i:s");
            $newHistoryRow['UpdatedBy']=$this->getCurrentUsersId();
            $newHistoryRow['MadeAt']=2;
            $QCHistoryTable->save($newHistoryRow);
        }
        if ($sourceorder['headboardrequired']=='y') {
            $newHistoryRow = $QCHistoryTable->newEntity([]);
            $newHistoryRow['ComponentID']=8;
            $newHistoryRow['QC_StatusID']=0;
            $newHistoryRow['Purchase_No']=$newpn;
            $newHistoryRow['QC_Date']=date("Y/m/d h:i:s");
            $newHistoryRow['UpdatedBy']=$this->getCurrentUsersId();
            $newHistoryRow['MadeAt']=$this->OrderHelper->getHBMadeAt($sourceorder);
            $QCHistoryTable->save($newHistoryRow);
        }
        if ($sourceorder['accessoriesrequired']=='y') {
            $newHistoryRow = $QCHistoryTable->newEntity([]);
            $newHistoryRow['ComponentID']=9;
            $newHistoryRow['QC_StatusID']=0;
            $newHistoryRow['Purchase_No']=$newpn;
            $newHistoryRow['QC_Date']=date("Y/m/d h:i:s");
            $newHistoryRow['UpdatedBy']=$this->getCurrentUsersId();
            $QCHistoryTable->save($newHistoryRow);
//debug($pn);
//die;
            $accrow=$this->Accessory->getAccessories($pn);
            foreach ($accrow as $row) {
                $accfieldsToCopy = array('colour','description','design','productcode','purchase_no','qty','QtyToFollow','size','SpecialInstructions','Supplier','tariffCode','unitprice','wholesalePrice');

                $newAccRow = $this->Accessory->newEntity([]);
                foreach ($accfieldsToCopy as $field) {
                    if (isset($row[$field])) {
                        $newAccRow[$field] = $row[$field];
                    }
                }
                $newAccRow['purchase_no']=$newpn;
                $this->Accessory->save($newAccRow);
            }
        }

        $phonenos=$this->PhoneNumber->getNumbersForPurchase($pn);
        if (isset($phonenos)) {
            foreach ($phonenos as $phonerow) {
                $phonefieldsToCopy = array('phonenumbertype','number','seq');

                $newPhoneRow = $this->PhoneNumber->newEntity([]);
                foreach ($phonefieldsToCopy as $field) {
                    if (isset($phonerow[$field])) {
                        $newPhoneRow[$field] = $phonerow[$field];
                    }
                }
                $newPhoneRow['purchase_no']=$newpn;
                $this->PhoneNumber->save($newPhoneRow);
            }

        }

        $prodsizes=$this->ProductionSizes->find()->where(['Purchase_No' => $pn])->first();
        
        if (isset($prodsizes)) {
         
                $prodfieldsToCopy = array('Matt1Width','Matt2Width','Matt1Length','Matt2Length','Base1Width','Base2Width','Base1Length','Base2Length','topper1Width','topper1Length','legheight');

                $newProdRow = $this->ProductionSizes->newEntity([]);
                foreach ($prodfieldsToCopy as $field) {
                    if (isset($prodsizes[$field])) {
                        $newProdRow[$field] = $prodsizes[$field];
                    }
                }
                $newProdRow['Purchase_No']=$newpn;
                $this->ProductionSizes->save($newProdRow);

        }
        $conn->commit();
        $this->Flash->success("Order No ".$newOrderNo." created. You are now editing the new order.");
        $this->redirect(['controller' => 'Order', 'action' => 'index', '?' => ['pn' => $newpn]]);
    }
    
    private function makePartOneFormData($contactdetails, $purchase) {
        $formData = [];

        if (isset($purchase)) {
            // values for existing orders
            $formData['vatrate'] = $purchase['vatrate'];
            $formData['wrappingtype'] = $purchase['wrappingid'];
            $formData['ordertype'] = $purchase['ordertype'];
            $formData['currency'] = $purchase['ordercurrency'];
            $formData['deladd1'] = $purchase['deliveryadd1'];
            $formData['deladd2'] = $purchase['deliveryadd2'];
            $formData['deladd3'] = $purchase['deliveryadd3'];
            $formData['deladdtown'] = $purchase['deliverytown'];
            $formData['deladdcounty'] = $purchase['deliverycounty'];
            $formData['deladdpostcode'] = $purchase['deliverypostcode'];
            $formData['deladdcountry'] = $purchase['deliverycountry'];
        } else {
            // default values for new orders
            $formData['vatrate'] = ''; // no need for a default for new orders, as VatRateTable.getVatRates puts the default rate first
            $formData['wrappingtype'] = 1;
            $formData['ordertype'] = ''; // default not needed for new orders
            $formData['currency'] = ''; // default not needed as main showroom currency will always be first in the select box
            $formData['deladd1'] = $contactdetails['street1'];
            $formData['deladd2'] = $contactdetails['street2'];
            $formData['deladd3'] = $contactdetails['street3'];
            $formData['deladdtown'] = $contactdetails['town'];
            $formData['deladdcounty'] = $contactdetails['county'];
            $formData['deladdpostcode'] = $contactdetails['postcode'];
            $formData['deladdcountry'] = $contactdetails['country'];
        }
        return $formData;
    }

    protected function _getAllowedRoles() {
        return ["ADMINISTRATOR","SALES"];
    }

    private function saveWholesalePrice($price, $pn, $compId) {
        $wholesalerow = $this->TempWholesalePrices->find()->where(['purchase_no' => $pn, 'componentID' => $compId])->first();
        if (!empty($price) && floatval(trim($price)) != 0) {
            if (!isset($wholesalerow)) {
                $wholesalerow = $this->TempWholesalePrices->newEntity([]);
                $wholesalerow->price = floatval(trim($price));
                $wholesalerow->purchase_no = $pn;
                $wholesalerow->componentID = $compId;
            } else {
                $wholesalerow->price = floatval(trim($price));
            }
            $this->TempWholesalePrices->save($wholesalerow);
        } else {
            $this->TempWholesalePrices->deleteRow($pn, $compId);
        }
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

    private function getRoundedApproxDateString($aLeadTime) {
        $aDate = date("Y-m-d");
        if ($aLeadTime !== "") {
            $aDate = date("Y-m-d", strtotime($aLeadTime . " weeks", strtotime($aDate)));
        }
        list($aYear, $aMonth, $aDay) = explode('-', $aDate);
        $rounded = $this->roundApproxDate($aDay, $aMonth, $aYear);
        return sprintf("%04d", $rounded[2]) . "-" . sprintf("%02d", $rounded[1]) . "-" . sprintf("%02d", $rounded[0]);
    }

    private function roundApproxDate($aDay, $aMonth, $aYear) {
        if ($aDay <= 5) {
            $aDay = 5;
        } elseif ($aDay <= 15) {
            $aDay = 15;
        } elseif ($aDay <= 25) {
            $aDay = 25;
        } else {
            $aDay = 5;
            if ($aMonth < 12) {
                $aMonth++;
            } else {
                $aMonth = 1;
                $aYear++;
            }
        }
        return [$aDay, $aMonth, $aYear];
    }
}

?>