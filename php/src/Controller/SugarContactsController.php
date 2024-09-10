<?php
namespace App\Controller;
use Cake\I18n\Time;
use Cake\I18n\FrozenTime;
use Exception;
use \App\Controller\Component\UtilityComponent;

class SugarContactsController extends AppController {

	public function initialize() : void {
        parent::initialize();
        $this->loadModel('Contact');
        $this->loadModel('Contacttype');
        $this->loadModel('Communication');
        $this->loadModel('CountryList');
        $this->loadModel('Customertype');
        $this->loadModel('Address');
        $this->loadModel('Location');
        $this->loadModel('Source');
        $this->loadModel('PriceList');
        $this->loadModel('Channel');
        $this->loadModel('SavoirUser');
        $this->loadComponent('JwtHelper');
        $this->loadComponent('Comreg');
        
    	$this->sources = $this->Source->getNonRetiredSources();
        $this->channels = $this->Channel->getChannelList();
        $this->contacttypes = $this->Contacttype->getContactTypeList();
        $this->customertypes = $this->Customertype->getCustomerTypeList();
        $this->usernames = $this->SavoirUser->checkUserName();
        $this->countries = $this->CountryList->getCountryList();
        
	}

    public function viewClasses(): array {
        return [JsonView::class];
    }

    public function index() {
        if (!$this->JwtHelper->validateSugarJwt($this->Comreg)) {
            $this->autoRender = false;
            $response = [
                "error" => "invalid_token",
                "error_description" => "The provided JWT is invalid or has expired"
            ];
            header('Content-Type: application/json');
            echo json_encode($response);
            $this->response = $this->response->withStatus(401);
            return;
        }
        
        $contact = $this->request->getData();
       
        if (array_key_exists("contact_no", $contact)) {
            $contactNo = $this->updateContact($contact);
        } else {
            $contactNo = $this->addContact($contact);
        }
        
        $message = 'Contact saved';
        $this->set([
            'message' => $message,
            'contact_no' => $contactNo,
        ]);
        $this->viewBuilder()->setOption('serialize', ['contact_no', 'message']);
    }

    private function addContact($contact) {
        $showroom = $this->Location->get($contact['Location ID']);
        if ($showroom == null) {
            throw new Exception('Invalid location ID ' . $contact['Location ID']);
        }
        $now = $this->_getCurrentDateTimeStr();
        $idRegion = $this->_getRegionOfLocation($showroom['idlocation']);
        $priceList = $this->_getPriceListForLocation($showroom['idlocation']);
       
        $address = $this->Address->find('all', array('conditions'=> array('email_address' => $contact['email'])))->toArray();
        if (count($address) > 0) {
            throw new Exception('Email address already exists: ' . $contact['email']);
        }
        $channel = $this->_getChannel($contact['channel']);
        $initialcontact = $this->_getContactType($contact['initial_contact']);
        $country = $this->_getCountry($contact['country']);
        $visitlocation=null;
        if (isset($contact['visit_location'])) {
            $visitlocation = $this->Location->get($contact['visit_location']);
        }

        $address = $this->Address->newEntity([]);
        $address->street1 = $contact['street1'];
        $address->street2 = $contact['street2'];
        $address->street3 = $contact['street3'];
    	$address->town = $contact['town'];
    	$address->county = $contact['county'];
    	$address->country = $country;
    	$address->postcode = $contact['postcode'];
    	$address->EMAIL_ADDRESS = $contact['email'];
    	$address->INITIAL_CONTACT = $initialcontact;
    	$address->CHANNEL = $channel;
    	$address->STATUS = 'Prospect';
    	$address->FIRST_CONTACT_DATE = $contact['first_contact_date'];
        $address->VISIT_DATE = $contact['visit_date'];
        $address->last_contact_date = $contact['last_contact_date'];
        $address->VISIT_LOCATION = !empty($visitlocation['idlocation']) ? $visitlocation['idlocation'] : null;
    	$address->SOURCE_SITE = 'SB';
    	$address->OWNING_REGION = $idRegion;
        $address->company = !empty($contact['company']) ? $contact['company'] : null;
        $address->tel = !empty($contact['tel']) ? $contact['tel'] : null;
        $address->fax = $contact['fax'];
        $address->PRICE_LIST = $priceList;
    	$address->source = $this->_getSource($contact['source']);
    	if ($address->source == "Other") {
    		$address->source_other = substr($contact['source'], 0, 255);
    	}
    	$this->Address->save($address);
    	$addressCode = $address->CODE;
        $customerTypeID = !empty($contact['customer_type']) ? $this->_getCustomerType($contact['customer_type']) : null;

        $contactN = $this->Contact->newEntity([]);
        $contactN->CODE = $addressCode;
        $contactN->title = $contact['title'];
        $contactN->first = $contact['firstname'];
        $contactN->surname = $contact['lastname'];
        $contactN->position = $contact['company_position'];
        $contactN->COMPANY_VAT_NO = !empty($contact['company_vat_no']) ? $contact['company_vat_no'] : null;
        $contactN->telwork = $contact['tel_work'];
        $contactN->mobile = $contact['mobile'];
        $contactN->customerType = $customerTypeID;
        $contactN->SOURCE_SITE = "SB";
        $contactN->OWNING_REGION = $idRegion;
        $contactN->idlocation = $showroom['idlocation'];
        $contactN->acceptemail = $contact['accept_email'];
        $contactN->acceptpost = $contact['accept_post'];
        $contactN->dateadded = $now;
        $this->Contact->save($contactN);

        $communication = $this->Communication->newEntity([]);
        $communication->CODE = $addressCode;
        $communication->Date = $now;
        $communication->Type = 'Contact added via SugarCRM';
        $communication->SOURCE_SITE = 'SB';
        $communication->OWNING_REGION = $idRegion;
        if ($contact['updated_by'] != '') {
            $communication->staff = strtolower($this->_getUsername($contact['updated_by']));
        }
        $contactname='';
        if ($contact['title'] != '') {
            $contactname=$contact['title'] ." ";
        };
        if ($contact['firstname'] != '') {
            $contactname.=$contact['firstname']." ";
        };
        if ($contact['lastname'] != '') {
            $contactname.=$contact['lastname']." ";
        };
        $communication->person = $contactname;
        $this->Communication->save($communication);

        return $contactN->CONTACT_NO;
    }


    private function updateContact($contact) {
        $showroom = $this->Location->get($contact['Location ID']);
        if ($showroom == null) {
            throw new Exception('Invalid location ID ' . $contact['Location ID']);
        }
        $contactcodeRS = $this->Contact->find('all', array('conditions'=> array('CONTACT_NO' => $contact['contact_no'])))->toArray();
        if (count($contactcodeRS) == 0) {
            throw new Exception('Contact number doesnt exists: ' . $contact['contact_no']);
        }
        $contactrow=$contactcodeRS[0];
        $addressRS = $this->Address->find('all', array('conditions'=> array('CODE' => $contactrow['CODE'])))->toArray();
        if (count($addressRS) == 0) {
            throw new Exception('Email address doesnt exist: ' . $contact['email']);
        } 
        $address = $addressRS[0];
        $now = $this->_getCurrentDateTimeStr();
        $idRegion = $this->_getRegionOfLocation($showroom['idlocation']);
        $priceList = $this->_getPriceListForLocation($showroom['idlocation']);
        $channel = $this->_getChannel($contact['channel']);
        $country = $this->_getCountry($contact['country']);
        $initialcontact = $this->_getContactType($contact['initial_contact']);
        $visitlocation=null;
        if (isset($contact['visit_location'])) {
            $visitlocation = $this->Location->get($contact['visit_location']);
        }

        $address->street1 = $contact['street1'];
        $address->street2 = $contact['street2'];
        $address->street3 = $contact['street3'];
    	$address->town = $contact['town'];
    	$address->county = $contact['county'];
    	$address->country = $country;
    	$address->postcode = $contact['postcode'];
    	$address->EMAIL_ADDRESS = $contact['email'];
    	$address->INITIAL_CONTACT = $initialcontact;
    	$address->CHANNEL = $channel;
    	$address->OWNING_REGION = $idRegion;
        $address->company = !empty($contact['company']) ? $contact['company'] : null;
        $address->tel = !empty($contact['tel']) ? $contact['tel'] : null;
        $address->fax = $contact['fax'];
        $address->PRICE_LIST = $priceList;
        $address->last_contact_date = $contact['last_contact_date'];
        $address->VISIT_LOCATION = !empty($visitlocation['idlocation']) ? $visitlocation['idlocation'] : null;
    	$address->source = $this->_getSource($contact['source']);
    	if ($address->source == "Other") {
    		$address->source_other = substr($contact['source'], 0, 255);
    	} else {
            $address->source_other = '';
        }
    	$this->Address->save($address);

        $contactRS = $this->Contact->find('all', array('conditions'=> array('CONTACT_NO' => $contact['contact_no'])))->toArray();
        if (count($contactRS) == 0) {
            throw new Exception('Contact doesnt exists: ' . $contact['contact_no']);
        } 
        $contactN = $contactRS[0];
        $customerTypeID = !empty($contact['customer_type']) ? $this->_getCustomerType($contact['customer_type']) : null;

        $contactN->title = $contact['title'];
        $contactN->first = $contact['firstname'];
        $contactN->surname = $contact['lastname'];
        $contactN->position = $contact['company_position'];
        $contactN->COMPANY_VAT_NO = !empty($contact['company_vat_no']) ? $contact['company_vat_no'] : null;
        $contactN->telwork = $contact['tel_work'];
        $contactN->mobile = $contact['mobile'];
        $contactN->customerType = $customerTypeID;
        $contactN->SOURCE_SITE = "SB";
        $contactN->OWNING_REGION = $idRegion;
        $contactN->idlocation = $showroom['idlocation'];
        $contactN->acceptemail = $contact['accept_email'];
        $contactN->acceptpost = $contact['accept_post'];
        $contactN->dateupdated = $now;
        $contactN->Updatedby = strtolower($this->_getUsername($contact['updated_by']));
        $this->Contact->save($contactN);

        //Contact added via SugarCRM

        return $contactN->CONTACT_NO;
    }
    

    protected function _getLocationForWpKey($wp_key) {
    	$rs = $this->Location->find('all', ['conditions'=> ['new_wp_key like' => '%'.$wp_key.'%', 'retire' => 'n', 'active' => 'y'], 'order' => ['SavoirOwned' => 'desc']]);
    	$idLocation = 0;
    	foreach ($rs as $row) {
    		$idLocation = $row['idlocation'];
    		break;
    	}
    	return $idLocation;
    }
    protected function _getSource($source) {
		if (!empty($source) && !in_array($source, $this->sources)) {
			$source = "Other";
		}
		//debug($source);
		return $source;
	}
    protected function _getContactType($contacttype) {
		$found=false;
        foreach ($this->contacttypes as $ct) {
            if (strcasecmp($contacttype, $ct['ContactType']) == 0) {
                $found=true;
                break;
            }
        }
		if (!$found) {
			throw new Exception('Incorrect initial contact type given ' . $contacttype);
		}
		return $contacttype;
	}
    protected function _getChannel($channel) {
        $found=false;
        foreach ($this->channels as $c) {
            if ($channel==$c['Channel']) {
                $found=true;
                break;
            }
        }
		if (!$found) {
			throw new Exception('Incorrect Channel given ' . $channel);
		}
		return $channel;
	}
    protected function _getCountry($country) {
        $found=false;
        foreach ($this->countries as $co) {
            if (strtolower($country)==strtolower($co['country'])) {
                $found=true;
                $country=$co['country'];
                break;
            }
        }
		if (!$found) {
			throw new Exception('Country name given is not in the database list of countries ' . $country);
		}
		return $country;
	}
    protected function _getCustomerType($customertype) {
        $found=false;
        $customerTypeID='';
        foreach ($this->customertypes as $custT) {
            if ($customertype==$custT['customerType']) {
                $customerTypeID=$custT['customerTypeID'];
                $found=true;
                break;
            }
        }
		if (!$found) {
			throw new Exception('Incorrect Customer Type given ' . $customertype);
		}
		return $customerTypeID;
	}
    protected function _getUsername($username) {
        $found=false;
        foreach ($this->usernames as $un) {
            if (strtolower($username)==strtolower($un['username'])){
                $found=true;
                break;
            }
        }
		if (!$found) {
			throw new Exception('Incorrect Username given ' . $username);
		}
		return $username;
	}
    protected function _getRegionOfLocation($idLocation) {
    	$rs = $this->Location->find('all', array('conditions'=> array('idlocation' => $idLocation)));
        $rs = $rs->toArray();
    	$idRegion = $rs[0]['owning_region'];
    	return $idRegion;
    }
    protected function _getCurrentDateTimeStr() {
		$now = Time::now();
		return $now->i18nFormat('yyyy-MM-dd HH:mm:ss');;
	}
    protected function _getPriceListForLocation($idLocation) {
    	$rs = $this->PriceList->find('all', array('conditions'=> array('DEFAULT_FOR_LOC_IDS like' => '%,'.$idLocation.',%')));
    	$rs = $rs->toArray();
    	$priceList = "Retail";
    	if (count($rs) > 0) {
	    	$priceList = $rs[0]['PriceList'];
    	}
    	return $priceList;
	}
}
?>