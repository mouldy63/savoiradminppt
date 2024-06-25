<?php
namespace App\Controller;
use App\Controller\EmailServicesController;
use Cake\ORM\TableRegistry;
use Cake\Datasource\ConnectionManager;
use Cake\I18n\Time;
use \Exception;

class PipedriveBrochureRequestImportController extends AbstractImportController {

	private $brHeader;
	private $sources;
	private $api_token = 'e767e0ff1cc9e5a0ca119a2d2e5286a515f1b73c';
	private $company_domain = 'savoir';
	private $dealFieldMap;

	public function initialize() : void {
        parent::initialize();
    	$this->loadModel('Source');
    	$this->sources = $this->Source->getNonRetiredSources();
	}
	
	public function import() {
		$this->autoRender = false;
		$this->viewBuilder()->setLayout('ajax');
		
		echo "Importing brochure requests from Pipedrive<br/>";
		
		$this->makeDealFieldMap();
		//debug($this->dealFieldMap);
		//die;
		$newRequestsFilterId = $this->getNewBrochureRequestsFilterId();

		$result = $this->callPipedrive('deals?filter_id='.$newRequestsFilterId.'&limit=1000000&');
		//debug($result);
		
		if (!$result['success'] || empty($result['data'])) {
		    exit('No new deals yet' . '<br>');
		}
		
		$n = 0;
		foreach ($result['data'] as $deal) {
		    echo '<br>deal ' . $n++;
		    $this->uploadBrochureRequest($deal);
		    $this->markDealAsRead($deal);
		    //break;
		}

		echo "<br/><br/>All brochure requests imported";
	}
	
	private function uploadBrochureRequest($deal) {
	    
	    $person = $this->getPerson($deal);
	    //debug($deal);
	    //debug($person);
	    //die;
	    
	    $now = $this->_getCurrentDateTimeStr();
	    $source = $deal[$this->dealFieldMap['Source']];
	    $isByPost = $source != 'Request a brochure (digital)';
	    
	    // ADDRESS
	    $email = $deal['person_id']['email'][0]['value'];
	    if (empty($email)) {
	        throw new Exception('No email address');
	    }
	    $postcode = $person['6bf729a891055d536fd5bf59fab1dd93bd767530_postal_code'];
	    $country = $person['6bf729a891055d536fd5bf59fab1dd93bd767530_country'];
	    $acceptemail = 'y'; // see email lfrom Daryl 26/1/2021
	    $showroom = $person['cb44cf74a071afab0a125b49382dba1bacc349a5'];
	    echo '<br/>email='.$email;
	    echo '<br/>$showroom='.$showroom;
	    echo '<br/>postcode,country='.$postcode.' '.$country;
	    echo '<br/>isByPost='.($isByPost?'Y':'N');
	    echo '<br/>acceptemail='.($acceptemail?'Y':'N');
	    if ($isByPost) {
	        if (empty($country)) {
	            throw new Exception('Country not set for postal brochure request');
	        }
	        $idLocation = $this->_getShowroomFromCountryAndPostcode($country, $postcode);
	    } else {
	        if (!$showroom) {
	            echo '<br/>No showroom provided for digital download, so defaulting to Wigmore';
	            $idLocation = 3;
	        } else {
	            $idLocation = $this->getShowroomFromPdKey($showroom);
	            if ($idLocation == 0) {
	                throw new Exception('No location found for showroom ' . $showroom);
	            }
	        }
	    }
	    $idRegion = $this->_getRegionOfLocation($idLocation);
	    echo '<br/>idLocation='.$idLocation.' '.$this->_getShowroomName($idLocation);
	    
	    $addressRs = $this->Address->find('all', array('conditions'=> array('email_address' => $email)))->toArray();
	    $priceList = $this->_getPriceListForLocation($idLocation);
	    echo '<br/>priceList = ' . $priceList;
	    
	    if (count($addressRs) == 0) {
	        echo '<br/>new address';
	        $address = $this->Address->newEntity([]);
	        $isNewContact = true;
	    } else {
	        echo '<br/>existing address so updating';
	        $address = $addressRs[0];
	        $isNewContact = false;
	    }
	    
	    $addr = $this->getAddress($person);
	    
	    $address->street1 = $addr['street1'];
	    $address->street2 = $addr['street2'];
	    $address->town = $addr['town'];
	    $address->county = $addr['county'];
	    $address->country = $addr['country'];
	    $address->postcode = $addr['postcode'];
	    $address->EMAIL_ADDRESS = $email;
	    $address->INITIAL_CONTACT = 'Website Brochure Request';
	    $address->CHANNEL = 'Direct';
	    $address->STATUS = 'Prospect';
	    if ($isNewContact) $address->FIRST_CONTACT_DATE = $now;
	    $address->SOURCE_SITE = 'SB';
	    $address->OWNING_REGION = $idRegion;
	    $address->source = 'Other';
	    $address->source_other = $deal[$this->dealFieldMap['How did you hear about us?']];
	    $address->PRICE_LIST = $priceList;
	    $this->Address->save($address);
	    $addressCode = $address->CODE;
	    echo '<br/>address code=' . $addressCode;
	    
	    // CONTACT
	    $contactRs = $this->Contact->find('all', array('conditions'=> array('CODE' => $addressCode)));
	    $contactRs = $contactRs->toArray();
	    $contactNo = 0;
	    if (count($contactRs) == 0) {
	        echo '<br/>new contact';
	        $contact = $this->Contact->newEntity([]);
	        $newContact = true;
	    } else {
	        echo '<br/>existing contact so updating';
	        $contact = $contactRs[0];
	        $newContact = false;
	    }
	    $contact->CODE = $addressCode;
	    $contact->first = $deal['person_name'];
	    $contact->surname = $deal['person_name'];
	    $contact->acceptemail = ($acceptemail ? 'y' : 'n');
	    $contact->mobile = $deal['person_id']['phone'][0]['value'];
	    if ($newContact) $contact->dateadded = $now;
	    $contact->dateupdated = $now;
	    $contact->retire = 'n';
	    $contact->BrochureRequestSent = 'n';
	    $contact->SOURCE_SITE = 'SB';
	    $contact->idlocation = $idLocation;
	    $contact->OWNING_REGION = $idRegion;
	    $this->Contact->save($contact);
	    $contactNo = $contact->CONTACT_NO;
	    
	    echo '<br/>contactid=' . $contactNo;
	    
	    // COMMUNICATION
	    $communication = $this->Communication->newEntity([]);
	    $communication->CODE = $addressCode;
	    $communication->Date = $now;
	    if ($isByPost) {
	        $communication->Type = 'Website Brochure Request';
	        $communication->actioned = 'n';
	    } else {
	        $communication->Type = 'Digital Brochure sent by email';
	        $communication->actioned = 'n';
	    }
	    $communication->person = $deal['person_name'];
	    $communication->SOURCE_SITE = 'SB';
	    $communication->staff = 'Website Request';
	    $communication->OWNING_REGION = $idRegion;
	    $this->Communication->save($communication);
	    
	    $this->sendBrochureRequestNotification($address, $contact, $idLocation, $newContact, $now, $acceptemail, $isByPost);
	    echo '<br/>Communication id =' . $communication->Communication;
	}
	
	private function getPerson($deal) {
	    $result = $this->callPipedrive('persons/'.$deal['person_id']['value'].'?');
	    if (!$result['success']) {
	        throw new Exception('Person lookup failed for person_id=' . $deal['person_id']['value']);
	    }
	    return $result['data'];
	}
	
	private function getAddress($person) {
	    $address = [];
	    $address['street1'] = null;
	    if (!empty($person['6bf729a891055d536fd5bf59fab1dd93bd767530_street_number'])) {
	        $address['street1'] = $person['6bf729a891055d536fd5bf59fab1dd93bd767530_street_number'] . ' ';
	    }
	    if (!empty($person['6bf729a891055d536fd5bf59fab1dd93bd767530_route'])) {
	        $address['street1'] .= $person['6bf729a891055d536fd5bf59fab1dd93bd767530_route'];
	    }
	    $address['street2'] = null;
	    if (!empty($person['6bf729a891055d536fd5bf59fab1dd93bd767530_sublocality'])) {
	        $address['street2'] = $person['6bf729a891055d536fd5bf59fab1dd93bd767530_sublocality'];
	    }
	    $address['town'] = null;
	    if (!empty($person['6bf729a891055d536fd5bf59fab1dd93bd767530_locality'])) {
	        $address['town'] = $person['6bf729a891055d536fd5bf59fab1dd93bd767530_locality'];
	    }
	    $address['county'] = null;
	    if (!empty($person['6bf729a891055d536fd5bf59fab1dd93bd767530_admin_area_level_1'])) {
	        $address['county'] = $person['6bf729a891055d536fd5bf59fab1dd93bd767530_admin_area_level_1'];
	    }
	    $address['country'] = null;
	    if (!empty($person['6bf729a891055d536fd5bf59fab1dd93bd767530_country'])) {
	        $address['country'] = $person['6bf729a891055d536fd5bf59fab1dd93bd767530_country'];
	    }
	    $address['postcode'] = null;
	    if (!empty($person['6bf729a891055d536fd5bf59fab1dd93bd767530_postal_code'])) {
	        $address['postcode'] = $person['6bf729a891055d536fd5bf59fab1dd93bd767530_postal_code'];
	    }
	    return $address;
	}
	
	private function markDealAsRead($deal) {
	    $data = array(
	        $this->dealFieldMap['Exported'] => true
	    );
	    $url = 'https://'.$this->company_domain.'.pipedrive.com/api/v1/deals/' . $deal['id'] . '?api_token=' . $this->api_token;
	    $ch = curl_init();
	    curl_setopt($ch, CURLOPT_URL, $url);
	    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
	    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
	    $output = curl_exec($ch);
	    curl_close($ch);
	    
	    $result = json_decode($output, true);
	    if (!$result['success'] || empty($result['data'])) {
	        exit('markDealAsRead failed' . '<br>');
	    }
	}
	
	private function makeDealFieldMap() {
	    $result = $this->callPipedrive('dealFields:(key,name)?start=0&');
	    if (empty($result['data'])) {
	        exit('Error: ' . $result['error'] . '<br>');
	    }
	    $this->dealFieldMap = [];
	    foreach ($result['data'] as $row) {
	        $this->dealFieldMap[$row['name']] = $row['key'];
	    }
	}
	
	private function callPipedrive($stub) {
	    $url = 'https://'.$this->company_domain.'.pipedrive.com/api/v1/'.$stub.'api_token=' . $this->api_token;
	    //debug($url);
	    $ch = curl_init();
	    curl_setopt($ch, CURLOPT_URL, $url);
	    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	    $output = curl_exec($ch);
	    curl_close($ch);
	    $result = json_decode($output, true);
	    return $result;
	}
	
	private function getNewBrochureRequestsFilterId() {
	    $result = $this->callPipedrive('filters?');
	    $id = null;
	    foreach ($result['data'] as $filter) {
	        if ($filter['name'] == 'NewBrochureRequests') {
	            $id = $filter['id'];
	            break;
	        }
	    }
	    return $id;
	}
	
	private function sendBrochureRequestNotification($address, $contact, $locationId, $isNew, $now, $acceptemail, $isByPost) {
	    $to = "brochurenotification@savoirbeds.co.uk";
	    $cc = "david@natalex.co.uk";
	    $from = "info@savoirbeds.co.uk";
	    $fromName = "Savoir Admin";
	    if ($isByPost) {
	        $subject = "New postal brochure request imported from savoirbeds.co.uk";
	        $content = "<h2>The details of the new postal brochure request are as follows</h2>";
	    } else {
	        $subject = "New digital download brochure request imported from savoirbeds.co.uk";
	        $content = "<h2>The details of the new digital download brochure request are as follows</h2>";
	    }
	    $content .= "<br/>Email address: " . $address->EMAIL_ADDRESS;
	    $content .= "<br/>Name:";
	    
	    if (!empty($contact->surname)) $content .= ' ' . $contact->surname;
	    $content .= "<br/>Address:";
	    if (!empty($address->street1)) $content .= ' ' . $address->street1;
	    if (!empty($address->town)) $content .= ' ' . $address->town;
	    if (!empty($address->county)) $content .= ' ' . $address->county;
	    if (!empty($address->country)) $content .= ' ' . $address->country;
	    if (!empty($address->postcode)) $content .= ' ' . $address->postcode;
	    if (!empty($contact->mobile)) $content .= "<br/>Phone: " . $contact->mobile;
	    $content .= "<br/>Submitted Date: " . $now;
	    $content .= "<br/>Marketing email opt in: " . ($acceptemail ? 'Y' : 'N');
	    $content .= "<br/>It has been assigned to showroom: " . $this->_getShowroomName($locationId);
	    $content .= "<br/>Brochure delivery method: " . ($isByPost ? 'Post' : 'Digital Download');
	    if (!$isNew) {
	        $content .= "<br/>This is an existing contact, so existing contact details have been updated, including changing assigned showroom if different from original.";
	    }
	    
	    $emailServices = new EmailServicesController;
	    $emailServices->generateBatchEmail($to, $cc, $from, $fromName, $subject, $content, 'html', null);
	}
	
	private function getShowroomFromPdKey($key) {
	    $rs = $this->Location->find('all', ['conditions'=> ['pipedrive_key' => $key]]);
	    $idLocation = 0;
	    foreach ($rs as $row) {
	        $idLocation = $row['idlocation'];
	        break;
	    }
	    return $idLocation;
	}
	
	protected function _getHeader() {
	    return null;
	}
}
?>