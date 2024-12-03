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

class ProductionController extends SecureAppController {
    protected $orderFormMiscDataModel;
    
	public function initialize() : void {
		parent::initialize();
		set_time_limit(120);

        $this->loadModel('Accessory');
        $this->loadModel('CompPriceDiscount');
        $this->loadModel('OrderNote');
        $this->loadModel('PhoneNumber');
        $this->loadModel('ProductionSizes');
		$this->loadModel('Purchase');
        $this->loadModel('QcHistory');
        $this->loadModel('WholesalePrices');
        $this->loadModel('Order');
        $this->loadModel('Payment');
        $this->loadModel('ExportLinks');

        // the other tables
		$this->loadModel('Contact');
        $this->loadModel('CountryList');
        $this->loadModel('Address');
        $this->loadModel('BedOptions');
        $this->loadModel('ComponentDimensions');
        $this->loadModel('ComponentType');
        $this->loadModel('Componentdata');
        $this->loadModel('ExportCollections');
        $this->loadModel('Location');
        $this->loadModel('MattressSupport');
        $this->loadModel('OrderFormMiscData');
        $this->loadModel('Payment');
        $this->loadModel('PhoneNumber');
        $this->loadModel('Production');
        $this->loadModel('ProductionSizes');
        $this->loadModel('Ticking');
        $this->loadModel('VatRate');
        $this->loadModel('Wrappingtypes');
        $this->loadModel('QcHistoryLatest');

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
        $ordertype=$this->Order->getOrderType($userregion);
        $wrappingtypes=$this->Wrappingtypes->getWrappingTypes();
        $vatrates=$this->VatRate->getVatRates($idlocation);
        $countrylist=$this->CountryList->getCountryList();
        $plannedexports=$this->ExportCollections->getExWorksDates($idlocation);
        $phonenoTypes=$this->PhoneNumber->getPhoneNoTypes();
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

        $params = $this->request->getParam('?');
        $currencyCode = 'GBP';
        $purchase = null;
        $phoneNumbers = null;
        $nextorder='';
        $prevorder='';
        $commercialInvoiceDetails='';
        if (isset($params['pn'])) {
            $pn = $params['pn'];
        
            $purchase=$this->Purchase->get($pn);
            $contact_no = $purchase['contact_no'];
            $orderdate=$purchase['ORDER_DATE'];
            $customerreference=$purchase['customerreference'];
            $ordernotes=$this->OrderNote->getOrderNotes($pn);
            $phoneNumbers = $this->PhoneNumber->getNumbersForPurchase($pn);
            $nextorder=$this->Production->getNextOrderNo($pn);
            $prevorder=$this->Production->getPrevOrderNo($pn);
            $currencyCode = $purchase['ordercurrency'];
            $shipmentcount=0;
            $prodCollectionData='';
            if (empty($purchase['bookeddeliverydate']) || $purchase['bookeddeliverydate']=='') {
                $prodCollectionData=$this->ExportCollections->getProductionCollectionInfo($pn);
                $shipmentcount=count($prodCollectionData);
            }
            //debug($prodCollectionData);
            //debug($shipmentcount);

	
            
            $this->set('purchase', $purchase);
            $this->set('pn', $pn);
            $this->set('contact_no', $contact_no);
            $this->set('nextorder', $nextorder);
            $this->set('prevorder', $prevorder);
            $this->set('prodCollectionData', $prodCollectionData);
            $this->set('shipmentcount', $shipmentcount);
            $contactdetails=$this->Contact->getContact($contact_no)[0];
            $isVIP=$contactdetails['isVIP'];
            
            $commercialInvoiceDetails=$this->ExportCollections->getCommercialInvoiceInfo($pn);
            
        }
        $this->set('partOneFormData', $this->makePartOneFormData($contactdetails, $purchase));
      
        $this->set('ordernotes', $ordernotes);
        $this->set('isVIP', $isVIP);
        $this->set('commercialInvoiceDetails', $commercialInvoiceDetails);
        $this->set('overseas', $overseas);
        $this->set('ordersource', $ordersource);
        $this->set('quote', $quote);
        $this->set('contact_no', $contact_no);
        $this->set('correspondence', $correspondence);
        $this->set('orderdate', $orderdate);
        $this->set('customerreference', $customerreference);
        $this->set('contactdetails', $contactdetails);
        $this->set('isTrade', $this->Order->isTradeCustomer($contact_no) ? 'y' : 'n');
        $this->set('phoneNumbers', $phoneNumbers);

        $leadTimes = $this->QcHistory->getLongestLeadTime();
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

    public function customerOrders() {
        $pn = $this->request->getQuery('pn');
        $contact_no = $this->request->getQuery('contact_no');
        $allorders=$this->Contact->getAllOrders($contact_no, $pn);
        $this->set('allorders', $allorders);
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
        $isTrade = $this->Order->isTradeCustomer($contact_no);

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
            $purchaserow = $this->Purchase->get($pn);
            $purchaserow->AmendedDate = date("d/m/Y h:i:s");
        }
       
        $purchaserow->completedorders = 'n';
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
        if (isset($formData['productiondate']) && !empty($formData['productiondate'])) {
            $purchaserow->productiondate = FrozenDate::createFromFormat('d/m/Y', $formData['productiondate']);
        }
        $purchaserow->wrappingid = $formData['wrappingtype'];
        $purchaserow->shipperID = $formData['wrappingtype'];
        $purchaserow->ordertype = $formData['ordertype'];
        $purchaserow->customerreference = trim($formData['customerref']);

        if (isset($formData['complete']) && $formData['complete']=='y')  {
            $purchaserow->ordercompletedUser = $this->getCurrentUsersId();
            $purchaserow->ordercompletedDate = date("d/m/Y h:i:s");
            $purchaserow->completedorders = 'y';
        }
    

        $this->Purchase->save($purchaserow);
        $pn=$purchaserow->PURCHASE_No;
        $quote=$purchaserow->quote;
        $this->PhoneNumber->deleteNumbersForPurchase($pn);
        if (trim($formData['delContact1']) != '') {
            $contactPhoneDetails = $this->PhoneNumber->newEntity([]);
            $contactPhoneDetails->phonenumber_id = $this->Order->getNextPrimeKeyValForTable('phonenumber', 1);
            $contactPhoneDetails->phonenumbertype =  $formData['delphonetype1'];
            $contactPhoneDetails->purchase_no =  $pn;
            $contactPhoneDetails->number =  trim($formData['delContact1']);
            $contactPhoneDetails->seq =  1;
            $this->PhoneNumber->save($contactPhoneDetails);
        }
        if (trim($formData['delContact2']) != '') {
            $contactPhoneDetails = $this->PhoneNumber->newEntity([]);
            $contactPhoneDetails->phonenumber_id = $this->Order->getNextPrimeKeyValForTable('phonenumber', 1);
            $contactPhoneDetails->phonenumbertype =  $formData['delphonetype2'];
            $contactPhoneDetails->purchase_no =  $pn;
            $contactPhoneDetails->number =  trim($formData['delContact2']);
            $contactPhoneDetails->seq =  2;
            $this->PhoneNumber->save($contactPhoneDetails);
        }
        if (trim($formData['delContact3']) != '') {
            $contactPhoneDetails = $this->PhoneNumber->newEntity([]);
            $contactPhoneDetails->phonenumber_id = $this->Order->getNextPrimeKeyValForTable('phonenumber', 1);
            $contactPhoneDetails->phonenumbertype =  $formData['delphonetype3'];
            $contactPhoneDetails->purchase_no =  $pn;
            $contactPhoneDetails->number =  trim($formData['delContact3']);
            $contactPhoneDetails->seq =  3;
            $this->PhoneNumber->save($contactPhoneDetails);
        }

        if (trim($formData['ordernote_notetext']) != '') {
            $ordernote = $this->OrderNote->newEntity([]);
            $ordernote->ordernote_id = $this->Order->getNextPrimeKeyValForTable('ordernote', 1);
            $ordernote->createddate =  date("Y-m-d H:i:s");
            $ordernote->notetext =  trim($formData['ordernote_notetext']);
            $ordernote->purchase_no =  $pn;
            $ordernote->username = $username;
            $ordernote->notetype = 'MANUAL';
            if ($formData['ordernote_followupdate'] != '') {
                
                $ordernote->followupdate =FrozenTime::createFromFormat('d/m/Y', $formData['ordernote_followupdate']);
            }
            $ordernote->action =  $formData['ordernote_action'];
            
            $this->OrderNote->save($ordernote);
        }

        $ordernotes=$this->OrderNote->getOrderNotes($pn);
        $clientlinen='n';
        foreach ($ordernotes as $ordernote) {
            if ($ordernote['notetext']=='Contact customer to discuss linen requirements, check production or booked delivery date.') {
                $clientlinen='y';
            }
        }
        if (isset($pn)) {
            $ordernoteid='';
            foreach ($formData as $fieldName => $fieldValue) {
                $ordernotes='';
                if (substr($fieldName, 0, 17)=='Note_followupdate') {
                    $ordernoteid=substr($fieldName, 17);
                    if ($fieldValue != '') {
                        $ordernotes = $this->OrderNote->find()->where(['ordernote_id' => $ordernoteid])->first();
                        
                        $ordernotes->followupdate =FrozenTime::createFromFormat('d/m/Y', $fieldValue);
                        $this->OrderNote->save($ordernotes);
                    }
                };
            
            }
            $ordernoteid='';
            foreach ($formData as $fieldName => $fieldValue) {
                $ordernotes='';
                if (substr($fieldName, 0, 13)=='notecompleted') {
                    $ordernoteid=substr($fieldName, 13);
                    $ordernotes = $this->OrderNote->find()->where(['ordernote_id' => $ordernoteid])->first();
                    if ($fieldValue != '') {
                        $ordernotes->followupdate =null;
                        $ordernotes->action ='Completed';
                        $ordernotes->NoteCompletedDate =date("Y/m/d h:i:s");
                        $ordernotes->NoteCompletedBy =$username;
                    }
                    $this->OrderNote->save($ordernotes);
                };
            }
        }

        if (isset($pn)) {
            if ($clientlinen=='n' && !isset($purchase['bookeddeliverydate']) && !isset($purchase['productiondate']) && (isset($formData['bookeddeliverydate']) || isset($formData['productiondate'])))
            {
                $ordernote = $this->OrderNote->newEntity([]);
                $ordernote->ordernote_id = $this->Order->getNextPrimeKeyValForTable('ordernote', 1);
                $ordernote->createddate =  date("Y-m-d H:i:s");
                $ordernote->notetext =  'Contact customer to discuss linen requirements, check production or booked delivery date.';
                $ordernote->purchase_no =  $pn;
                $ordernote->username = $username;
                $ordernote->notetype = 'AUTO';
                if ($formData['ordernote_followupdate'] != '') {
                    
                    $ordernote->followupdate =FrozenTime::createFromFormat('d/m/Y', $formData['ordernote_followupdate']);
                }
                $ordernote->action =  'Action Required';
                
                $this->OrderNote->save($ordernote);
                
            } 
        }

        if (isset($pn)) {
            $this->QcHistory->insertQcHistoryRowIfNone($this->Order, 0, $pn, $userId, 0);
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

    public function searchproduction() {
    	
    	if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'Order', 'action' => 'index'));
			return;
    	}
        $formData = $this->request->getData();
        if (isset($formData['orderno'])) {
            $orderno = $formData['orderno'];
            $purchase = $this->Purchase->find()->where(['ORDER_NUMBER' => $orderno])->toArray()[0];
            $pn=$purchase['PURCHASE_No'];
            return $this->redirect(['controller' => 'Production', 'action' => 'index', '?' => ['pn' => $pn]]);
        }
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

    public function mattress() {
        $pn = $this->request->getQuery('pn');
        $purchase=$this->Purchase->get($pn);
        $this->viewBuilder()->addHelpers(['OrderForm' => ['currencyCode' => $purchase['ordercurrency']]]);
        $springs=$this->Production->getSpringProdNo($pn);
        $mattcut='';
        $mattressIssuedDate='';
        $mattmachined='';
        $mattressstatus='';
        $springunitdate='';
        $mattbcwexpected='';
        $mattbcwwarehouse='';
        $deliverymethodMatt='';
        $mattdeldate='';
        $mattfinished='';
        $tickingbatchno='';
        $madeby='';
        $jobflagMatt='';
        $qcHistoryData= $this->QcHistory->getQCCompData(1, $pn);
        if (count($qcHistoryData)>0) {
            $qcHistoryRow=$qcHistoryData[0];
        
            $mattressIssuedDate=$qcHistoryRow['IssuedDate'];
            if (isset($qcHistoryRow['Cut'])) {
                $mattcut=FrozenTime::parse($qcHistoryRow['Cut'])->format('m/d/Y');
            }
            if (isset($qcHistoryRow['Machined'])) {
                $mattmachined=FrozenTime::parse($qcHistoryRow['Machined'])->format('m/d/Y');
            }
            $mattressstatus=$qcHistoryRow['QC_StatusID'];
            if (isset($qcHistoryRow['springunitdate'])) {
                $springunitdate=FrozenTime::parse($qcHistoryRow['springunitdate'])->format('m/d/Y');
            }
            if (isset($qcHistoryRow['finished'])) {
                $mattfinished=FrozenTime::parse($qcHistoryRow['finished'])->format('m/d/Y');
            }
            $mattbcwexpected=$qcHistoryRow['BCWExpected'];
            $mattbcwwarehouse=$qcHistoryRow['BCWWarehouse'];
            $deliverymethodMatt=$qcHistoryRow['DeliveryMethod'];
            $mattdeldate=$qcHistoryRow['DeliveryDate'];
            $tickingbatchno=$qcHistoryRow['tickingBatchNo'];
            $madeby=$qcHistoryRow['MadeBy'];
            $jobflagMatt=$qcHistoryRow['JobFlag'];
        }
        $mattMadeatID='n';
        $query=$this->QcHistoryLatest->getQCmadeat(1, $pn);
        if (count($query)==0) {
            $mattMadeat='';
        } else {
            $mattMadeat=$query[0]['ManufacturedAt'];
            $mattMadeatID=$query[0]['ManufacturedAtID'];
        }
        $madebyUsers=$this->Production->getMadeByUsers($mattMadeatID);
       
        
        $this->set('madebyUsers', $madebyUsers);
        $this->set('mattcut', $mattcut);
        $this->set('mattmachined', $mattmachined);
        $this->set('deliverymethodMatt', $deliverymethodMatt);
        $this->set('mattressIssuedDate', $mattressIssuedDate);
        $this->set('mattressstatus', $mattressstatus);
        $this->set('springunitdate', $springunitdate);
        $this->set('mattbcwexpected', $mattbcwexpected);
        $this->set('mattbcwwarehouse', $mattbcwwarehouse);
        $this->set('mattdeldate', $mattdeldate);
        $this->set('mattfinished', $mattfinished);
        $this->set('tickingbatchno', $tickingbatchno);
        $this->set('madeby', $madeby);
        $this->set('jobflagMatt', $jobflagMatt);



        $this->set('purchase', $purchase);
        $this->set('mattMadeat', $mattMadeat);
        [$isComponentLocked, $lockColour] = $this->QcHistoryLatest->isComponentLocked($pn, 1);
        if (!$isComponentLocked && ($purchase['cancelled'] == 'y' || $purchase['completedorders'] == 'y')) {
            $isComponentLocked = true;
        }
        $prodsizes = $this->ProductionSizes->find()->where(['Purchase_No' => $pn])->first();
        if (!isset($prodsizes)) {
            $prodsizes = ['Matt1Width' => '', 'Matt1Length' => '', 'Matt2Width' => '', 'Matt2Length' => ''];
        }
        
        $zippedpair='n';
        $mattwidthdivided='';
        $mattlengthdivided='';
        $this->set('isComponentLocked', $isComponentLocked ? 'true' : 'false');
        $this->set('lockColour', $lockColour);
        if ($purchase['mattresstype']=='Zipped Pair' && $purchase['mattresswidth'] != 'Special (as instructions)' && $purchase['mattresswidth'] != 'Special Width') {
            $zippedpair='y';
            if (substr($purchase['mattresswidth'], -2)=='in') {
                $mattwidthdivided = substr($purchase['$mattresswidth'], 0, -2);
                $mattwidthdivided = float($mattwidthdivided * 2.54) / 2;
            }
            if (substr($purchase['mattresslength'], -2)=='in') {
                $mattlengthdivided = substr($purchase['$mattresslength'], 0, -2);
                $mattlengthdivided = float($mattlengthdivided);
            }
            if (substr($purchase['mattresswidth'], -2)=='cm') {
                $mattwidthdivided = substr($purchase['mattresswidth'], 0, -2);
                $mattwidthdivided = $mattwidthdivided/2;
            }
            if (substr($purchase['mattresslength'], -2)=='cm') {
                $mattlengthdivided = substr($purchase['mattresslength'], 0, -2);
            }
        } else {
            $mattwidthdivided = $purchase['mattresswidth'];
            $mattlengthdivided = $purchase['mattresslength'];
            $zippedpair='n';
            if (substr($purchase['mattresswidth'], -2)=='in') {
                $mattwidthdivided = (substr($purchase['mattresswidth'], 0, -2) * 2.54);
            }
            if (substr($purchase['mattresslength'], -2)=='in') {
                $mattlengthdivided = (substr($purchase['mattresslength'], 0, -2) * 2.54);
            }
        }
        
        $this->set('zippedpair', $zippedpair);
        $this->set('springs', $springs);
        $this->set('mattwidthdivided', $mattwidthdivided);
        $this->set('mattlengthdivided', $mattlengthdivided);
        $this->set('prodsizes', $prodsizes);

    }

    public function saveMattress() {
        $this->autoRender = false;
        if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'Production', 'action' => 'index'));
			return;
    	}
        $formData = $this->request->getData();
        $pn = $formData['pn'];
        $QCHistory = $this->QcHistory->find()->where(['Purchase_no' => $pn, 'ComponentID' => 1])->order(['QC_Date' => 'DESC'])->first();
       
        if ($formData['mattressmadeat']!='n') {
         $QCHistory->MadeAt = trim($formData['mattressmadeat']);
        }
        if (!empty($formData['mattcut'])) {
            $QCHistory->Cut = FrozenTime::createFromFormat('d/m/Y', $formData['mattcut']);
        }
        if (!empty($formData['mattmachined'])) {
            $QCHistory->Machined = FrozenTime::createFromFormat('d/m/Y', $formData['mattmachined']);
        }
       
        if (!empty($formData['tickingbatchno'])) {
            $QCHistory->tickingBatchNo = trim($formData['tickingbatchno']);
        }
        if (!empty($formData['springunitdate'])) {
            $QCHistory->springunitdate = FrozenTime::createFromFormat('d/m/Y', $formData['springunitdate']);
        }
        if ($formData['mattmadeby']!='n') {
            $QCHistory->MadeBy = trim($formData['mattmadeby']);
        } else {
            $QCHistory->MadeBy = null;
        }
        if (!empty($formData['mattfinished'])) {
            $QCHistory->finished = FrozenTime::createFromFormat('d/m/Y', $formData['mattfinished']);
        }
        
        $this->QcHistory->save($QCHistory); 
        $componentsToReload = [1]; // include itself
        $this->response = $this->response->withType('application/json');
        $this->response = $this->response->withStringBody(json_encode($componentsToReload));
        return $this->response;
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

