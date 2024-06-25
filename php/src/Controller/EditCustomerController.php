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
		$this->loadModel('Contact');
		$this->loadModel('Contacttype');
		$this->loadModel('Correspondence');
		$this->loadModel('CountryList');
		$this->loadModel('CustomerType');
		$this->loadModel('Interestproducts');
		$this->loadModel('Interestproductslink');
		$this->loadModel('Location');
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
		$sources = $this->Source->getNonRetiredSources();
		$customertype = $this->CustomerType->getCustomerTypeList();
		$contacttypes = $this->Contacttype->getContactTypeList();
		$pricelist = $this->PriceList->getPriceList();
		$customer=$this->Contact->getContact($contactno)[0];
		$addressCode=$this->Address->get($customer['CODE'])['CODE'];
		$addressdetails=$this->Address->get($addressCode);
		$userRegion=$this->getCurrentUserRegionId();
		$userLocation=$this->getCurrentUserLocationId();
		$correspondenceList=$this->Correspondence->getCorrespondenceListforRegion($userRegion,$userLocation);
		$shippers=$this->Shipper->listShippers();
		$countries=$this->CountryList->getCountryList();
		$savoirowned=$this->isSavoirOwned();
		$visitlocations = $this->Location->getVisitLocations($userRegion);
		$allorders = $this->Purchase->getAllOrders($contactno);
		
	
		
		
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

		$custdetails='';
		$custdetails.='<b>';
		if ($customer['title'] != '') {
			$custdetails.=$customer['title'].' ';
		}
		if ($customer['first'] != '') {
			$custdetails.=$customer['first'].' ';
		}
		if ($customer['surname'] != '') {
			$custdetails.=$customer['surname'].' ';
		}
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
		
		$this->set('customer', $customer);
		$this->set('isVIP', $customer['isVIP']);
		$this->set('channels', $channels);
		$this->set('sources', $sources);
		$this->set('pricelist', $pricelist);
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
		
		$this->set('custdetails', $custdetails);
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
		
    	
    	//debug($this->request->getData());
		$formData = $this->request->getData();
		
		$contactno = $formData['contactno'];
	
		$contactdetails = $this->Contact->get($contactno);
		$addressdetails = $this->Address->get($contactdetails['CODE']);

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
    
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR,SALES");
	}

}

?>