<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class AddCustomerController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
	}
	
	public function postcodecheck() {
		$this->viewBuilder()->setLayout('savoir');
		$submit1="";
		$submit2="";
		$postcode="";
		$postcode1="";
		$custPostcode='';
		$email='';
		$custEmail='';
		$contactTable = TableRegistry::get('Contact');
		$addressTable = TableRegistry::get('Address');
		
		$formData = $this->request->getData();
		if ($this->request->getData('submit1') !== null && $this->request->getData('postcode') != '') {
			$postcode1=trim($this->request->getData('postcode'));
			$postcode=str_replace(" ","",$postcode1);
			$submit1 =$this->request->getData('submit1');
			$custPostcode = $contactTable->getPostcodeCustomers($this->getCurrentUserRegionId(), $this->getCurrentUserLocationId(), $postcode);
		}
		if ($this->request->getData('submit2') !== null && $this->request->getData('emailadd') != '') {
			$email=$this->request->getData('emailadd');
			$submit2 =$this->request->getData('submit2');
			$custEmail = $addressTable->getCustomersEmail($this->getCurrentUserRegionId(), $this->getCurrentUserLocationId(), $email);
		}
		
		$this->set('postcode1', $postcode1);
		$this->set('email', $email);
		$this->set('custPostcode', $custPostcode);
		$this->set('custEmail', $custEmail);
		$this->set('submit1', $submit1);
		$this->set('submit2', $submit2);
	}
	
	public function addnew()
    {
		$this->viewBuilder()->setLayout('savoir');
		$countryListTable = TableRegistry::get('CountryList');
		$regionTable = TableRegistry::get('Region');
		$locationTable = TableRegistry::get('Location');
		$channelTable = TableRegistry::get('Channel');
		$interestproductsTable = TableRegistry::get('Interestproducts');
		$contacttypeTable = TableRegistry::get('Contacttype');
		$statusTable = TableRegistry::get('Status');
		$country = $regionTable->getRegionCountryname($this->getCurrentUserRegionId());
		$this->set('country', $country);
		$countrylist = $countryListTable->getCountryList();
		$custPostcode='';
		$email='';
		$custPostcode = $this->request->getQuery('postcode');
		$email = $this->request->getQuery('email');
		$activeshowrooms=$locationTable->getActiveShowrooms($this->getCurrentUserRegionId(),'');
		$activechannels=$channelTable->getChannelList();
		$status=$statusTable->getStatusList();
		$interestproducts=$interestproductsTable->getinterestproductsList();
		$contacttype=$contacttypeTable->getContactTypeList();
		$this->set('activeshowrooms', $activeshowrooms);
		$this->set('activechannels', $activechannels);
		$this->set('status', $status);
		$this->set('interestproducts', $interestproducts);
		$this->set('contacttype', $contacttype);
		$this->set('countrylist', $countrylist);
		$this->set('custPostcode', $custPostcode);
		$this->set('email', $email);
	
	}
	
	public function doadd()
    {
		$this->viewBuilder()->setLayout('savoir');
		if ($this->request->is('post')) {
			$pricelistTable = TableRegistry::get('PriceList');
			$pricelistRS=$pricelistTable->getDefaultPriceListForLocation($this->getCurrentUserLocationId());
			$pricelist='';
			$submit='';
			$submit2='';
			$primekeycode='';
			foreach ($pricelistRS as $row) {
				$pricelist=$row['PriceList'];
			}
			if ($pricelist=='') {
				$pricelist='Retail';
			}
	
			$formData = $this->request->getData();
			if (isset($formData['submit'])) {
			$submit=trim($formData['submit']);
			}
			if (isset($formData['submit2'])) {
			$submit2=trim($formData['submit2']);
			}
			$addressTable = TableRegistry::get('Address');
			$addcomponent = $addressTable->newEntity([]);
			$addcomponent->EMAIL_ADDRESS = trim($formData['email']);
			$addcomponent->street1 = trim($formData['address1']);
			$addcomponent->street2 = trim($formData['address2']);
			$addcomponent->street3 = trim($formData['address3']);
			$addcomponent->town = trim($formData['town']);
			$addcomponent->county = trim($formData['county']);
			$addcomponent->postcode = trim($formData['postcode']);
			$addcomponent->country = trim($formData['country']);
			$addcomponent->tel = trim($formData['tel']);
			$addcomponent->fax = trim($formData['fax']);
			$addcomponent->company = trim($formData['company']);
			if (isset($formData['source'])) {
			$addcomponent->source = trim($formData['source']);
			}
			$addcomponent->source_other = trim($formData['other']);
			$addcomponent->CHANNEL = trim($formData['channel']);
			$addcomponent->INITIAL_CONTACT = trim($formData['type']);
			$addcomponent->STATUS = trim($formData['status']);
			if ($formData['visitdate'] != '') {
			$addcomponent->VISIT_DATE = UtilityComponent::makeMysqlDateStringFromDisplayString($formData['visitdate']);
			}
			if (trim($formData['location']) != 'n') {
				$addcomponent->VISIT_LOCATION = trim($formData['location']);
				}
			$addcomponent->FIRST_CONTACT_DATE = date("Ymd");
			$addcomponent->OWNING_REGION = $this->getCurrentUserRegionId();
			$addcomponent->SOURCE_SITE = 'SB';
			$addcomponent->PRICE_LIST = $pricelist;
			$addressTable->save($addcomponent);
			if ($addressTable->save($addcomponent)) {
   				 $primekeycode= $addcomponent->CODE;
			}
			
			$contactTable = TableRegistry::get('Contact');
			$addcontact = $addressTable->newEntity([]);
			$addcontact->CODE = $primekeycode;
			$addcontact->dateadded = date("Ymd");
			$addcontact->title = trim($formData['title']);
			$addcontact->first = trim($formData['name']);
			$addcontact->surname = trim($formData['surname']);
			$addcontact->position = trim($formData['position']);
			if (isset($formData['emailsallowed']) && $formData['emailsallowed']=='y') {
				$addcontact->acceptemail = 'y';
			} else {
				$addcontact->acceptemail = 'n';	
			}
			if (isset($formData['post']) && $formData['post']=='y') {
				$addcontact->acceptpost = 'y';
			} else {
				$addcontact->acceptpost = 'n';	
			}
			$addcontact->OWNING_REGION = $this->getCurrentUserRegionId();
			$addcontact->idlocation = $this->getCurrentUserLocationId();
			$addcontact->retire = 'n';
			$addcontact->Updatedby = $this->SavoirSecurity->getCurrentUserName();
			$addcontact->SOURCE_SITE = 'SB';
			if (isset($formData['submit2'])) {
				$addcontact->BrochureRequestSent = null;
			}
			$contactTable->save($addcontact);
			if ($contactTable->save($addcontact)) {
   				 $contactcode= $addcontact->CONTACT_NO;
			}
			
			$interestproductslinkTable = TableRegistry::get('Interestproductslink');
			foreach ($formData as $formfield => $value) {
				$parts=explode("_",$formfield);
				if ($parts[0]=="XX") {
					$addinterestlink = $addressTable->newEntity([]);
					$productid=intval($parts[1]);
					$addinterestlink->product_id = $productid;
					$addinterestlink->contact_no = $contactcode;
					$interestproductslinkTable->save($addinterestlink);
				}
			
			}
			
			if (isset($formData['submit']) || trim($formData['comments']) != '') {
			$communicationTable = TableRegistry::get('Communication');
			$newcommunication = $addressTable->newEntity([]);
			$newcommunication->CODE = $primekeycode;
			if (isset($formData['submit'])) {
					$newcommunication->Type = 'Brochure Request (Admin)';
			}
			if ($formData['surname'] != '') {
					$newcommunication->person = trim($formData['title']) .' '.trim($formData['surname']);
			}
			$newcommunication->notes = trim($formData['comments']);
			$newcommunication->OWNING_REGION = $this->getCurrentUserRegionId();
			$newcommunication->SOURCE_SITE = 'SB';
			$newcommunication->Date = date("Ymd");
			$communicationTable->save($newcommunication);
			}
			
			return $this->redirect($_SERVER["HTTP_ORIGIN"].'/editcust.asp?val='. $contactcode);
			
		}
	}
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR", "SALES");
	}

}

?>