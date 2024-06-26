<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;
use Cake\Event\EventInterface;
use Cake\I18n\FrozenTime;
use Cake\I18n\FrozenDate;

class EditCustomerController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
		$this->loadModel('Address');
		$this->loadModel('Channel');
		$this->loadModel('Communication');
		$this->loadModel('Contact');
		$this->loadModel('Contacttype');
		$this->loadModel('Correspondence');
		$this->loadModel('CountryList');
		$this->loadModel('CustomerType');
		$this->loadModel('DeliveryAddress');
		$this->loadModel('Interestproducts');
		$this->loadModel('Interestproductslink');
		$this->loadModel('Location');
		$this->loadModel('PhoneNumber');
        $this->loadModel('PriceList');
		$this->loadModel('Purchase');
		$this->loadModel('Shipper');
		$this->loadModel('Source');
		$this->loadModel('Status');
	}

	public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
    	$builder->addHelpers([
        	'OrderFuncs'
        ]);
    }

	public function index() {
		$this->viewBuilder()->setLayout('savoirbsTabbed');
		$params = $this->request->getParam('?');		
		if (isset($params['val'])) {
            $contactno = $params['val'];
		}
		$interestprods=$this->Interestproducts->getinterestproductsList();
		$status=$this->Status->getStatusList();
		$interestprodlinks = $this->Interestproductslink->find('all', array('conditions'=> array('contact_no' => $contactno)))->toArray();
		$channels = $this->Channel->getChannelList();
		$deliveryaddresses = $this->DeliveryAddress->getDeliveryAddresses($contactno);
		$sources = $this->Source->getNonRetiredSources();
		$customertype = $this->CustomerType->getCustomerTypeList();
		$contacttypes = $this->Contacttype->getContactTypeList();
		$pricelist = $this->PriceList->getPriceList();
		$customer=$this->Contact->getContact($contactno)[0];
		$addressCode=$this->Address->get($customer['CODE'])['CODE'];
		$communications=$this->Communication->getCustomerNotes($customer['CODE']);
		$commscount=count($communications);
		$addressdetails=$this->Address->get($addressCode);
		$userRegion=$this->getCurrentUserRegionId();
		$userLocation=$this->getCurrentUserLocationId();
		$correspondenceList=$this->Correspondence->getCorrespondenceListforRegion($userRegion,$userLocation);
		$shippers=$this->Shipper->listShippers();
		$countries=$this->CountryList->getCountryList();
		$savoirowned=$this->isSavoirOwned();
		$visitlocations = $this->Location->getVisitLocations($userRegion);
		$allorders = $this->Purchase->getAllOrders($contactno);
		$allordercount=count($allorders);
		$phonenotypes = $this->PhoneNumber->getPhoneNoTypes();
		$additionalcontact1 = $this->Contact->find()->where(['parent_contact_no' => $contactno,'AdditionalContactSeq' => 1])->first();
		if (!isset($additionalcontact1)) {
			$additionalcontact1['title']='';
			$additionalcontact1['first']='';
			$additionalcontact1['surname']='';
			$additionalcontact1['telwork']='';
			$additionalcontact1['mobile']='';
			$additionalcontact1['AdditionalContactEmail']='';
			$additionalcontact1['position']='';
		}
		$additionalcontact2 = $this->Contact->find()->where(['parent_contact_no' => $contactno,'AdditionalContactSeq' => 2])->first();
		if (!isset($additionalcontact2)) {
			$additionalcontact2['title']='';
			$additionalcontact2['first']='';
			$additionalcontact2['surname']='';
			$additionalcontact2['telwork']='';
			$additionalcontact2['mobile']='';
			$additionalcontact2['AdditionalContactEmail']='';
			$additionalcontact2['position']='';
		}
		
		
		
		$allowedshowrooms='';
		if ($userRegion==1 || $userRegion==17 || $userRegion==19 || 
		$userLocation==8 || $userLocation==14 || $userLocation==17 || $userLocation==24 || $userLocation==25 || 
		$userLocation==31 || $userLocation==33 ||$userLocation==34 || $userLocation==35 || $userLocation==37 || $userLocation==38 || $userLocation==39 || $userLocation==40 || $userLocation==41 || $userLocation==51) {
			$allowedshowrooms='y';
		}
		$allowedquote='';
		if ($userRegion==1 || $userLocation==17 || $userLocation==24 || $userLocation==34 || $userLocation==37 || $userLocation==39) {
			$allowedquote='y';
		}
		$custname='';
		if ($customer['title'] != '') {
			$custname.=$customer['title'].' ';
		}
		if ($customer['first'] != '') {
			$custname.=$customer['first'].' ';
		}
		if ($customer['surname'] != '') {
			$custname.=$customer['surname'].' ';
		}
		$custdetails='';
		$custdetails.='<b>';
			$custdetails.=$custname;
		
		if ($addressdetails['street1'] != '') {
			$custdetails.=$addressdetails['street1'].' ';
		}
		if ($addressdetails['postcode'] != '') {
			$custdetails.=$addressdetails['postcode'].' ';
		}
		$custdetails.='&nbsp;&nbsp;&nbsp;&nbsp';
		if ($addressdetails['tel'] != '') {
			$custdetails.=$addressdetails['tel'].' ';
		}
		$custdetails.='&nbsp;&nbsp;&nbsp;&nbsp';
		if ($customer['acceptemail'] == 'y') {
			$custdetails.=' Email: <a href="mailto:'.$addressdetails['EMAIL_ADDRESS'].'">'.$addressdetails['EMAIL_ADDRESS'].'</a> ';
		}
		if ($customer['acceptpost'] == 'n') {
			$custdetails.='   <font color="red">NO MARKETING BY POST</font>';
		}
		if ($customer['acceptemail'] == 'n') {
			$custdetails.='   <font color="red">NO MARKETING BY EMAIL</font>';
		}
		$custdetails.='</b>';
		
		$showVipBox=false;
		$isVipCandidate=false;
		if ($customer['customerType']==1 && $customer['acceptemail']=='y' && ($customer['idlocation']==3 || $customer['idlocation']==4 || $customer['idlocation']==36 || $customer['idlocation']==48)) {
			$showVipBox=true;
			if ($customer['isVIPmanuallyset']=='n') {
				$totalspend=$this->Contact->getLifetimeSpendForCurrency($contactno,'GBP');
				if ($totalspend > 19998) {
					$isVipCandidate=true;
				}
			}
		}
		$username = $this->getCurrentUserName();
		$today = FrozenTime::now();
        
		$this->set('today', $today);
		$this->set('username', $username);
		$this->set('customer', $customer);
		$this->set('communications', $communications);
		$this->set('commscount', $commscount);
		$this->set('isVIP', $customer['isVIP']);
		$this->set('channels', $channels);
		$this->set('sources', $sources);
		$this->set('pricelist', $pricelist);
		$this->set('phonenotypes', $phonenotypes);
		$this->set('savoirowned', $savoirowned);
		$this->set('contacttypes', $contacttypes);
		$this->set('customertype', $customertype);
		$this->set('interestprods', $interestprods);
		$this->set('interestprodlinks', $interestprodlinks);
		$this->set('isVipCandidate', $isVipCandidate);
		$this->set('showVipBox', $showVipBox);
		$this->set('userRegion', $userRegion);
		$this->set('userLocation', $userLocation);
		$this->set('allowedshowrooms', $allowedshowrooms);
		$this->set('allowedquote', $allowedquote);
		$this->set('addressdetails', $addressdetails);
		$this->set('visitlocations', $visitlocations);
		$this->set('allorders', $allorders);
		$this->set('allordercount', $allordercount);
		$this->set('deliveryaddresses', $deliveryaddresses);
		$this->set('additionalcontact1', $additionalcontact1);
		$this->set('additionalcontact2', $additionalcontact2);
		
		
		$this->set('custdetails', $custdetails);
		$this->set('custname', $custname);
		$this->set('correspondenceList', $correspondenceList);
		$this->set('shippers', $shippers);
		$this->set('countries', $countries);
		$this->set('status', $status);
	}
	
	public function edit()
    {
    	if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'EditCustomer', 'action' => 'index'));
			return;
    	}
    	
    	$this->viewBuilder()->setLayout('savoirbsTabbed');
		
    	$today = new DateTime();
        $formattedDate = $today->format('d/m/Y');
    	//debug($this->request->getData());
		$formData = $this->request->getData();
		
		$contactno = $formData['contactno'];
		$code = $formData['code'];
	
		$contactdetails = $this->Contact->get($contactno);
		$addressdetails = $this->Address->get($contactdetails['CODE']);

		$additionalcontacts = $this->Contact->find()->where(['parent_contact_no' => $contactno])->toArray();
		if (count($additionalcontacts)>0) {
			foreach ($additionalcontacts as $row) {
				$this->Contact->delete($row);
			   }
		} 
		if (trim($formData['addcontact1surname']) != '') {
			$row = $this->Contact->newEntity([]);
			$row->parent_contact_no = trim($formData['contactno']);
			$row->AdditionalContactSeq = 1;
			$row->title = trim($formData['addcontact1title']);
			$row->first = trim($formData['addcontact1name']);
			$row->surname = trim($formData['addcontact1surname']);
			$row->telwork = trim($formData['addcontact1tel']);
			$row->mobile = trim($formData['addcontact1mobile']);
			$row->AdditionalContactEmail = trim($formData['addcontact1email']);
			$row->position = trim($formData['addcontact1pos']);
			$this->Contact->save($row);

		}
		if (trim($formData['addcontact2surname']) != '') {
			$row = $this->Contact->newEntity([]);
			$row->parent_contact_no = trim($formData['contactno']);
			$row->AdditionalContactSeq = 2;
			$row->title = trim($formData['addcontact2title']);
			$row->first = trim($formData['addcontact2name']);
			$row->surname = trim($formData['addcontact2surname']);
			$row->telwork = trim($formData['addcontact2tel']);
			$row->mobile = trim($formData['addcontact2mobile']);
			$row->AdditionalContactEmail = trim($formData['addcontact2email']);
			$row->position = trim($formData['addcontact2pos']);
			$this->Contact->save($row);

		}
	

		$commdetailsarray = $this->Communication->find('all', array('conditions'=> array('CODE' => $code)))->toArray();
		if (count($commdetailsarray)>0) {
			foreach ($commdetailsarray as $row) {
				$commid=$row['Communication'];
				$currentactivedate='';
				$currentcommstatus='';
				$commstatus=null;
				if (!empty($row['Next'])) {
					$currentactivedate=substr($row['Next'],0,10);
				}
				if (isset($formData['commstatusActive_'.$commid])) {
					$commstatus=$formData['commstatusActive_'.$commid];
				}
				if (isset($row['commstatus'])) {
					$currentcommstatus=$row['commstatus'];
				}
				
				if (!empty($formData['nextactive_'.$commid])) {
					$formactivedate=$formData['nextactive_'.$commid];
					if ($currentactivedate!=$formactivedate && (empty($formData['responseactive_'.$commid]) || $formData['responseactive_'.$commid]=='')) {
						$row->Response = '(Follow up date changed) '.$this->getCurrentUserName().' - '.$formattedDate.'<br><br>'.$row['Response'];
					}
					$row->Next = FrozenDate::createFromFormat('d/m/Y', $formData['nextactive_'.$commid]);
				}
				if (isset($formData['notesactive_'.$commid]) && $formData['notesactive_'.$commid] !='' && ($row['notes'] != $formData['notesactive_'.$commid])) {
					$row->notes = $formData['notesactive_'.$commid];
					$row->Response = $row['Response'].'<br />'.$this->getCurrentUserName().' - '.$formattedDate.'<br />'.$row['Response'];
				}
				if (isset($formData['responseactive_'.$commid]) && $formData['responseactive_'.$commid] !='') {
					$row->Response = $formData['responseactive_'.$commid].'<br />'.$this->getCurrentUserName().' - '.$formattedDate.'<br />'.$row['Response'];
					$row->notes = $formData['responseactive_'.$commid];
					
				}
				if (isset($commstatus) && $commstatus != $currentcommstatus) {
					$row->commstatus = $commstatus;
					if ($commstatus=='Completed' || $commstatus=='Cancelled') {
						$row->completedDate=FrozenDate::now();
						$row->commCompletedBy=$this->getCurrentUserName();
					}
				}
				$this->Communication->save($row);
				
			}

		}

		$deliverydetailsarray = $this->DeliveryAddress->find('all', array('conditions'=> array('CONTACT_NO' => $contactno)))->toArray();
		
		if (count($deliverydetailsarray)>0) {
			foreach ($deliverydetailsarray as $row) {
				$deliveryaddid=$row['DELIVERY_ADDRESS_ID'];
				
					$row->DELIVERY_NAME = trim($formData['deliveryname_'.$deliveryaddid]);
					$row->ADD1 = trim($formData['deliveryadd1_'.$deliveryaddid]);
					$row->ADD2 = trim($formData['deliveryadd2_'.$deliveryaddid]);
					$row->ADD3 = trim($formData['deliveryadd3_'.$deliveryaddid]);
					$row->TOWN = trim($formData['deliverytown_'.$deliveryaddid]);
					$row->COUNTYSTATE = trim($formData['deliverycounty_'.$deliveryaddid]);
					$row->POSTCODE = trim($formData['deliverypostcode_'.$deliveryaddid]);
					$row->COUNTRY = trim($formData['deliverycountry_'.$deliveryaddid]);
					$row->CONTACT = trim($formData['deliverycontact1_'.$deliveryaddid]);
					$row->PHONE = trim($formData['deliverytel1_'.$deliveryaddid]);
					$row->CONTACTTYPE1 = trim($formData['deliveryphonetype1_'.$deliveryaddid]);
					$row->CONTACT2 = trim($formData['deliverycontact2_'.$deliveryaddid]);
					$row->PHONE2 = trim($formData['deliverytel2_'.$deliveryaddid]);
					$row->CONTACTTYPE2 = trim($formData['deliveryphonetype2_'.$deliveryaddid]);
					$row->CONTACT3 = trim($formData['deliverycontact3_'.$deliveryaddid]);
					$row->PHONE3 = trim($formData['deliverytel3_'.$deliveryaddid]);
					$row->CONTACTTYPE3 = trim($formData['deliveryphonetype3_'.$deliveryaddid]);
					if (isset($formData['deliveryretire_'.$deliveryaddid]) && $formData['deliveryretire_'.$deliveryaddid]=='y') {
						$row->retire = 'y';
					} else {
						$row->retire = 'n';
					}
					if (isset($formData['maindeliveryaddress']) && $formData['maindeliveryaddress']==$deliveryaddid) {
						$row->ISDEFAULT = 'y';
						$row->retire = 'n';
					} else {
						$row->ISDEFAULT = 'n';
					}

				$this->DeliveryAddress->save($row);
				
			}

		}
		if ($formData['commnote'] != '' || $formData['commnextdate']!='') {
			$row = $this->Communication->newEntity([]);
			$row->CODE = trim($formData['code']);
			$row->Date = FrozenTime::now();
			if (trim($formData['commstatus']) != 'n') {
				$row->commstatus = trim($formData['commstatus']);
			}
			if (trim($formData['commperson']) != 'n') {
				$row->person = trim($formData['commperson']);
			}
			if (trim($formData['commnextdate']) != '') {
				$row->Next = FrozenDate::createFromFormat('d/m/Y', $formData['commnextdate']);
			}
			$row->staff = $this->getCurrentUserName();
			$row->notes = trim($formData['commnote']);
			$row->SOURCE_SITE = 'SB';
			$row->OWNING_REGION = trim($formData['owningregion']);
			$this->Communication->save($row);
		}

		if ($formData['deliveryname'] != '' || $formData['deliveryadd1']!='') {
			$row = $this->DeliveryAddress->newEntity([]);
			$row->CONTACT_NO = $contactno;
			$row->DELIVERY_NAME = trim($formData['deliveryname']);
			$row->ADD1 = trim($formData['deliveryadd1']);
			$row->ADD2 = trim($formData['deliveryadd2']);
			$row->ADD3 = trim($formData['deliveryadd3']);
			$row->TOWN = trim($formData['deliverytown']);
			$row->COUNTYSTATE = trim($formData['deliverycounty']);
			$row->POSTCODE = trim($formData['deliverypostcode']);
			$row->COUNTRY = trim($formData['deliverycountry']);
			$row->CONTACT = trim($formData['deliverycontact1']);
			$row->PHONE = trim($formData['deliverytel1']);
			$row->CONTACTTYPE1 = trim($formData['deliveryphonetype1']);
			$row->CONTACT2 = trim($formData['deliverycontact2']);
			$row->PHONE2 = trim($formData['deliverytel2']);
			$row->CONTACTTYPE2 = trim($formData['deliveryphonetype2']);
			$row->CONTACT3 = trim($formData['deliverycontact3']);
			$row->PHONE3 = trim($formData['deliverytel3']);
			$row->CONTACTTYPE3 = trim($formData['deliveryphonetype3']);
			if (count($deliverydetailsarray)==0) {
				$row->ISDEFAULT = 'y';
			} else {
				$row->ISDEFAULT = 'n';
			}
			$this->DeliveryAddress->save($row);
		}
	

		$contactdetails->title = trim($formData['title']);
		$contactdetails->first = trim($formData['first']);
		$contactdetails->surname = trim($formData['surname']);
		$contactdetails->PreferredShipper = trim($formData['preferredshipper']);
		$contactdetails->telwork = trim($formData['telwork']);
		$contactdetails->mobile = trim($formData['mobile']);
		$contactdetails->position = trim($formData['companyposition']);
		$contactdetails->COMPANY_VAT_NO = trim($formData['companyvat']);
		if (isset($formData['acceptemail']) && $formData['acceptemail']=='y') {
			$contactdetails->acceptemail = 'y';
		} else {
			$contactdetails->acceptemail = 'n';
			$contactdetails->isVIP = 'n';
			$contactdetails->isVIPmanuallyset = 'n';
		}
		if (isset($formData['acceptpost']) && $formData['acceptpost']=='y') {
			$contactdetails->acceptpost = 'y';
		} else {
			$contactdetails->acceptpost = 'n';
		}
		if (!isset($formData['tradediscountrate']) || $formData['tradediscountrate'] =='') {

		}
		if ($formData['tradediscountrate'] === "" || !is_numeric($formData['tradediscountrate'])) {
			$tradeDiscountRate = 0;
		} else {
			$tradeDiscountRate = intval($formData['tradediscountrate']);
		}
		$contactdetails->tradediscountrate = $tradeDiscountRate;
	


		$reqVip ='n';
		if (isset($formData['vip']) && $formData['vip']=='y' && isset($formData['acceptemail'])) {
			$reqVip='y';
		}
		if ($contactdetails['isVIP'] != $reqVip) {
			$contactdetails->isVIPmanuallyset = 'y';
		}
		$contactdetails->isVIP = $reqVip;
		if ($formData['customertype'] != 'n') {
			$contactdetails->customerType = $formData['customertype'];
		} else {
			$contactdetails->customerType = null;
		}
		
		$this->Contact->save($contactdetails);

		$addressdetails->street1 = trim($formData['address1']);
		$addressdetails->street2 = trim($formData['address2']);
		$addressdetails->street3 = trim($formData['address3']);
		$addressdetails->town = trim($formData['town']);
		$addressdetails->county = trim($formData['county']);
		$addressdetails->postcode = trim($formData['postcode']);
		$addressdetails->country = trim($formData['country']);
		$addressdetails->tel = trim($formData['telhome']);
		$addressdetails->fax = trim($formData['fax']);
		$addressdetails->company = trim($formData['company']);
		if ($formData['pricelist'] != '') {
			$addressdetails->PRICE_LIST = trim($formData['pricelist']);
		} else {
			$addressdetails->PRICE_LIST = null;
		}
		if (isset($formData['initialcontactdate'])) {
			$addressdetails->FIRST_CONTACT_DATE = FrozenDate::createFromFormat('d/m/Y', $formData['initialcontactdate']);
		} else {
			$addressdetails->FIRST_CONTACT_DATE = null;
		}
		if (isset($formData['visitdate'])) {
			$addressdetails->VISIT_DATE = FrozenDate::createFromFormat('d/m/Y', $formData['visitdate']);
		} else {
			$addressdetails->VISIT_DATE = null;
		}
		if (isset($formData['lastcontactdate'])) {
			$addressdetails->last_contact_date = FrozenDate::createFromFormat('d/m/Y', $formData['lastcontactdate']);
		} else {
			$addressdetails->last_contact_date = null;
		}
		if ($formData['inintialcontact'] != 'n') {
			$addressdetails->INITIAL_CONTACT = $formData['inintialcontact'];
		} else {
			$addressdetails->INITIAL_CONTACT = null;
		}
		if ($formData['source'] != 'n') {
			$addressdetails->source = $formData['source'];
		} else {
			$addressdetails->source = null;
		}
		if (isset($formData['other'])) {
			$addressdetails->source_other = $formData['other'];
		} else {
			$addressdetails->source_other = null;
		}
		if (isset($formData['wrongaddress']) && $formData['wrongaddress']=='y') {
			$addressdetails->wrongaddress = 'y';
		} else {
			$addressdetails->wrongaddress = 'n';
		}
		if (isset($formData['status'])) {
			$addressdetails->STATUS = $formData['status'];
		}
		if ($formData['channel'] != 'n') {
			$addressdetails->CHANNEL = $formData['channel'];
		} else {
			$addressdetails->CHANNEL = 'n';
		}
		if ($formData['visitlocation'] != 'n') {
			$addressdetails->VISIT_LOCATION = $formData['visitlocation'];
		} else {
			$addressdetails->VISIT_LOCATION = 'n';
		}
		$this->Address->save($addressdetails);

		$interestproductslinkTable = TableRegistry::get('Interestproductslink');
		$productlink = $this->Interestproductslink->find('all', array('conditions'=> array('contact_no' => $contactno)));
		foreach ($productlink as $row) {
		 $interestproductslinkTable->delete($row);
		}

		$interestproductslinkTable = TableRegistry::get('Interestproductslink');
			foreach ($formData as $formfield => $value) {
				$parts=explode("_",$formfield);
				if ($parts[0]=="XX") {
					$productlink = $interestproductslinkTable->newEntity([]);
					$prodid=intval($parts[1]);
					$productlink->product_id = $prodid;
					$productlink->contact_no = $contactno;
					$interestproductslinkTable->save($productlink);
			}

		}

		$this->Flash->success("Contact amended successfully");
		$this->redirect(['action' => 'index', '?' => ['val' => $contactno]]);
    }

	public function reopenorder()
    {
    	
    	$this->viewBuilder()->setLayout('savoirbsTabbed');
		$params = $this->request->getParam('?');		
		if (isset($params['val'])) {
            $pn = $params['val'];
			$contactno=$params['contactno'];
		}
		if (isset($pn)) {
            $purchaserow = $this->Purchase->get($pn);
    		$purchaserow->completedorders = 'n';
		}
		$this->Purchase->save($purchaserow);
		$this->Flash->success("Order has been reopened");
		$this->redirect(['action' => 'index', '?' => ['val' => $contactno]]);
	}
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR,SALES");
	}

}

?>