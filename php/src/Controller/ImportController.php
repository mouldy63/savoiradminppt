<?php
namespace App\Controller;
use App\Controller\EmailServicesController;
use \Cake\Mailer\Email;
use \SoapClient;
use Cake\ORM\TableRegistry;
use Cake\Datasource\ConnectionManager;

class ImportController extends AppController {
	public $uses = false;
	public $autoRender = false;
	private $_client;
	private $_session;
	
	private function _openSoapCLient() {
		if (!class_exists('SoapClient')) {
			die ('no soap');
		}
		$url = $this->_getComregVal("SAVOIRBEDS_SOAPCLIENT_URL");
		echo '<br/>SOAP URL = ' . $url;
		$this->_client = new SoapClient($url);
		$this->_session = $this->_client->login($this->_getComregVal("SAVOIRBEDS_SOAPCLIENT_USER"), $this->_getComregVal("SAVOIRBEDS_SOAPCLIENT_PW"));
	}
	
    public function brochureRequests() {
        $this->viewBuilder()->setLayout('ajax');
    	$this->loadModel('Comreg');
    	$this->loadModel('Address');
    	$this->loadModel('Contact');
    	$this->loadModel('Communication');
    	$this->loadModel('Location');
    	$this->loadModel('PriceList');
    	$this->loadModel('PostcodeLocation');
    	
    	echo '<br/>Importing brochure requests<br/><br/>';
    	$comregRow = $this->Comreg->find('all', array('conditions'=> array('name' => "BROCHURE_LAST_FETCH_DATE")));
        $comregRow = $comregRow->toArray();
    	if (count($comregRow) != 1) {
    		$comregId = 999;
    		echo '<br/>lastFetchDate not set<br>';
    	} else {
	    	$lastFetchDate = $comregRow[0]['VALUE'];
                echo '<br/>lastFetchDate = ' . $lastFetchDate.'<br>';
	    	$endFetchDate = date('Y-m-d H:i:s');
	    	
	    	/*
	    	 * Database on Wordpress doesn't use summer saving time, so 1 hour has to be subtracted. 
	    	 */
	    	if(date('I')==1){
	    		$lastFetchDate = date('Y-m-d H:i:s',strtotime('-1 hours',strtotime($lastFetchDate)));
	    		$endFetchDate = date('Y-m-d H:i:s',strtotime('-1 hours',strtotime($endFetchDate)));
	    	}

	    	$this->rquest_time = $lastFetchDate;
    		//$lastFetchDate = '2017-07-14 15:30:00';
    		$comregId = $comregRow[0]['COMREG_ID'];
    	}
    	
    	$fetchDate = date('Y-m-d H:i:s');
    	echo '<br/>fetchDate = ' . $fetchDate . '. This is the date that will appear in x_brochure_request_transfer_records on the magento database<br>';
    	
    	$this->_openSoapCLient();
    	
    	$data = $this->_getLatestBrochureRequests($fetchDate);
    	$count = 0;
    	foreach ($data as $n => $row) {
    		$success = $this->_writeRequest($row, $fetchDate, true);
    		if (!$success) {
    			echo "<br/>Import Failed";
    			die;
    		}
    		$count++;
    	}
    	echo "<br/>Imported $count requests";
    	$this->_closeSoapClient();
    	
        $comreg = $this->Comreg->get($comregId);
        $comreg->VALUE = $fetchDate;
    	$this->Comreg->save($comreg);
    	
    	echo "<br/>Import Successful";
    }
    
    public function missedRequests(){
    	$this->loadModel('Comreg');
    	$this->loadModel('Address');
    	$this->loadModel('Contact');
    	$this->loadModel('Communication');
    	$this->loadModel('Location');
    	$this->loadModel('PostcodeLocation');
    	
    	if($this->request->is('post')||$this->request->is('ajax')){

    		if (!isset($_SERVER['HTTP_ORIGIN'])) {
			    // This is not cross-domain request
			    exit;
			}
			
			$wildcard = FALSE; // Set $wildcard to TRUE if you do not plan to check or limit the domains
			$credentials = FALSE; // Set $credentials to TRUE if expects credential requests (Cookies, Authentication, SSL certificates)
			$allowedOrigins = array('https://www.savoirbeds.co.uk');
			if (!in_array($_SERVER['HTTP_ORIGIN'], $allowedOrigins) && !$wildcard) {
			    // Origin is not allowed
			    exit;
			}
			$origin = $wildcard && !$credentials ? '*' : $_SERVER['HTTP_ORIGIN'];
			
			header("Access-Control-Allow-Origin: " . $origin);
			if ($credentials) {
			    header("Access-Control-Allow-Credentials: true");
			}
			header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
			header("Access-Control-Allow-Headers: Origin");
			header('P3P: CP="CAO PSA OUR"'); // Makes IE to support cookies
			
			// Handling the Preflight
			if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') { 
			    exit;
			}
			
			// Response
			header("Content-Type: application/json; charset=utf-8");
    		$requests = $this->request->getData()['bRequests'];
    		$requests = json_decode($requests,true);
    		$fetchDate = date('Y-m-d H:i:s');
    		
    		if(count($requests)>0){
    			foreach ($requests as $req){
    				$this->_writeRequest($req, $fetchDate, false);
    			}
    			echo json_encode(array('status' => 'y'));
    		}else{
    			echo json_encode(array('status' => 'n'));
    		}
    		
    		die();
    	}else{
    		echo var_dump(isset($_SERVER['HTTP_ORIGIN']));
    		die();
    	}
    }
    
    private function _writeRequest($row, $fetchDate, $echo) {

    	if ($echo) echo '<br/>'.var_export($row).'<br/>';

    	$conn = ConnectionManager::get('default');
    	$conn->begin();

    	// ADDRESS
    	$email = $row['your-email'];
    	$postcode = $row['postcode'];
    	$country = $row['country'];
    	$company = $row['company'];
    	$idLocation = 3; // Wigmore
    	$idRegion = 1; // London
    	if ($echo) echo '<br/>email='.$email.'<br/>';
    	if ($echo) echo '<br/>postcode,country='.$postcode.' '.$country.'<br/>';
    	if ($echo) echo '<br/>company='.$company.'<br/>';
    	if (!empty($country)) {
    		$idLocation = 0;
    		if (is_numeric($postcode)) {
    			$idLocation = $this->_getDefaultShowroomForNumericPostcode($this->_tweekPostcode($postcode, $country), $country);
    		}
    		if ($idLocation == 0) {
    			$idLocation = $this->_getDefaultShowroomForCountryOnly($country);
    		}
    		if ($idLocation == 0) {
    			$idLocation = 3; // default to Wigmore
    		}
    		$idRegion = $this->_getRegionOfLocation($idLocation);
    	}
    	if ($echo) echo '<br/>idLocation='.$idLocation.'<br/>';
    	if ($echo) echo '<br/>idRegion='.$idRegion.'<br/>';
    	 
    	$acceptemail = !empty($row['email-opt-out']) ? 'y' : 'n';
    	 
    	$addressRs = $this->Address->find('all', array('conditions'=> array('email_address' => $email)));
    	$addressRs = $addressRs->toArray();
    	$addressCode = 0;
    	$priceList = "";
    	if (!empty($company)) {
    		$priceList = "Trade";
    	} else {
    		$priceList = $this->_getPriceListForLocation($idLocation);
    	}
    	if ($echo) echo '<br/>priceList = ' . $priceList;
    	 
    	if (count($addressRs) == 0) {
    		if ($echo) echo '<br/>new address<br/>';
    		$address = $this->Address->newEntity([]);
    		$isNewContact = true;
    	} else {
    		if ($echo) echo '<br/>existing address so updating<br/>';
    		$address = $addressRs[0];
    		$isNewContact = false;
    	}
    	$address->street1 = $row['address1'];
    	$address->town = $row['town'];
    	$address->county = $row['County'];
    	$address->country = $row['country'];
    	$address->postcode = $row['postcode'];
    	$address->EMAIL_ADDRESS = $email;
    	$address->INITIAL_CONTACT = 'Website Brochure Request';
    	$address->CHANNEL = 'Direct';
    	$address->STATUS = 'Prospect';
    	if ($isNewContact) $address->FIRST_CONTACT_DATE = $row['Submitted Date'];
    	$address->SOURCE_SITE = 'SB';
    	$address->OWNING_REGION = $idRegion;
    	$address->source = $row['infoSource'];
    	if (!empty($company)) {
    		$address->company = $company;
    		$address->CHANNEL = 'Trade';
    	}
    	$address->PRICE_LIST = $priceList;
    	$this->Address->save($address);
    	$addressCode = $address->CODE;
    	 
    	if ($echo) echo '<br/>address code=' . $addressCode . '<br/>';

    	// CONTACT
    	$contactRs = $this->Contact->find('all', array('conditions'=> array('CODE' => $addressCode)));
    	$contactRs = $contactRs->toArray();
    	$contactNo = 0;
    	if (count($contactRs) == 0) {
    		if ($echo) echo '<br/>new contact<br/>';
    		$contact = $this->Contact->newEntity([]);
    		$newContact = true;
    	} else {
    		if ($echo) echo '<br/>existing contact so updating<br/>';
    		$contact = $contactRs[0];
    		$newContact = false;
    	}
    	$contact->CODE = $addressCode;
    	$contact->title = $row['title'];
    	$contact->first = $row['firstname'];
    	$contact->surname = $row['lastname'];
    	$contact->acceptemail = $acceptemail;
    	$contact->mobile = $row['your-phone'];
    	$contact->customerip = $row['Submitted From'];
    	if ($newContact) $contact->dateadded = $row['Submitted Date'];
    	$contact->dateupdated = $row['Submitted Date'];
    	$contact->retire = 'n';
    	$contact->BrochureRequestSent = 'n';
    	$contact->SOURCE_SITE = 'SB';
    	$contact->idlocation = $idLocation;
    	$contact->OWNING_REGION = $idRegion;
    	$this->Contact->save($contact);
    	$contactNo = $contact->CONTACT_NO;
    	 
    	if ($echo) echo '<br/>contactid=' . $contactNo . '<br/>';

    	// COMMUNICATION
    	$communication = $this->Communication->newEntity([]);
    	$communication->CODE = $addressCode;
    	$communication->Date = $row['Submitted Date'];
    	$communication->Type = 'Website Brochure Request';
    	$communication->person = $row['title'] . ' ' . $row['firstname'] . ' ' . $row['lastname'];
    	$communication->actioned = 'n';
    	$communication->SOURCE_SITE = 'SB';
    	$communication->staff = 'Website Request';
    	$communication->OWNING_REGION = $idRegion;
    	$this->Communication->save($communication);
    	 
    	$success = $this->_client->call($this->_session, 'contactdata.markBrochureRequest', array($row['key'], $fetchDate));
    	if ($success == 1) {
    		if ($echo) echo '<br/>markBrochureRequest suceeded';
    		$conn->commit();
    	} else {
    		if ($echo) echo '<br/>markBrochureRequest failed - rolling back';
    		$conn->rollback();
    		return false;
    	}


    	$this->_sendBrochureRequestNotification($row, $idLocation, $newContact);
    	if ($echo) echo '<br/>Communication id =' . $communication->Communication . '<br/>';
    	return true;
    }

    private function _getLatestBrochureRequests($fetchDate) {
    	// dummy value as no longer used
    	$lastFetchDate = '1970-01-01 00:00:00';
    	return $this->_client->call($this->_session, 'contactdata.brochureRequests', array($lastFetchDate, $fetchDate));
    }
    
    private function _getDefaultShowroomForNumericPostcode($postcode, $country) {
    	$rs = $this->PostcodeLocation->find('all', array('conditions'=> array('lower(COUNTRY) like' => mb_strtolower($country, 'UTF-8'), 'POSTCODE_RANGE_START <=' => $postcode,'POSTCODE_RANGE_END >=' => $postcode)));
        $rs = $rs->toArray();
    	$idLocation = 0;
    	if (count($rs) > 0) {
	    	$idLocation = $rs[0]['LOCATIONID'];
    	}
    	echo '<br>_getDefaultShowroomForNumericPostcode: idLocation='.$idLocation;
    	return $idLocation;
    }
    
    private function _getDefaultShowroomForCountryOnly($country) {
    	$rs = $this->PostcodeLocation->find('all', array('conditions'=> array('lower(COUNTRY) like' => strtolower($country))));
        $rs = $rs->toArray();
    	$idLocation = 0;
    	if (count($rs) > 0) {
	    	$idLocation = $rs[0]['LOCATIONID'];
    	}
    	return $idLocation;
    }
    
    private function _getRegionOfLocation($idLocation) {
    	$rs = $this->Location->find('all', array('conditions'=> array('idlocation' => $idLocation)));
        $rs = $rs->toArray();
    	$idRegion = $rs[0]['owning_region'];
    	return $idRegion;
    }
    
    private function _closeSoapClient() {
		$this->_client->endSession($this->_session);
    }
    
    private function _sendBrochureRequestNotification($row, $locationId, $isNew) {
    	$optin = !empty($row['email-opt-out']) ? "y" : "n";
    	$to = "brochurenotification@savoirbeds.co.uk";
    	$cc = "david@natalex.co.uk";
    	$from = "info@savoirbeds.co.uk";
    	$fromName = "Savoir Admin";
    	$subject = "New brochure request imported from savoirbeds.co.uk";
    	$content = "<h2>The details of the new brochure request are as follows</h2>";
    	$content .= "<br/>Email address: " . $row['your-email'];
    	$content .= "<br/>Name:";
    	if (!empty($row['title'])) $content .= ' ' . $row['title'];
    	if (!empty($row['firstname'])) $content .= ' ' . $row['firstname'];
    	if (!empty($row['lastname'])) $content .= ' ' . $row['lastname'];
    	$content .= "<br/>Address:";
    	if (!empty($row['address1'])) $content .= ' ' . $row['address1'];
    	if (!empty($row['town'])) $content .= ' ' . $row['town'];
    	if (!empty($row['County'])) $content .= ' ' . $row['County'];
    	if (!empty($row['country'])) $content .= ' ' . $row['country'];
    	if (!empty($row['postcode'])) $content .= ' ' . $row['postcode'];
    	if (!empty($row['your-phone'])) $content .= "<br/>Phone: " . $row['your-phone'];
    	if (!empty($row['company'])) $content .= "<br/>Company: " . $row['company'];
    	$content .= "<br/>Submitted Date: " . $row['Submitted Date'];
    	$content .= "<br/>Marketing email opt in: " . $optin;
    	$content .= "<br/>It has been assigned to showroom: " . $this->_getShowroomName($locationId);
    	if (!$isNew) {
	    	$content .= "<br/>This is an existing contact, so existing contact details have been updated, including changing assigned showroom if different from original.";
    	}
    	
    	$emailServices = new EmailServicesController;
    	$emailServices->generateBatchEmail($to, $cc, $from, $fromName, $subject, $content, 'html', null);
    }
    
    private function _getShowroomName($locationId) {
    	$rs = $this->Location->find('all', array('conditions'=> array('idlocation' => $locationId)));
        $rs = $rs->toArray();
    	return $rs[0]['location'];
    }
    
    public function testPriceListForLocation() {
    	$this->layout = 'ajax';
    	$this->loadModel('PriceList');
    	$priceList = $this->_getPriceListForLocation(34);
    	echo $priceList;
    }
    
	private function _getPriceListForLocation($idLocation) {
    	$rs = $this->PriceList->find('all', array('conditions'=> array('DEFAULT_FOR_LOC_IDS like' => '%,'.$idLocation.',%')));
    	$rs = $rs->toArray();
    	$priceList = "Retail";
    	if (count($rs) > 0) {
	    	$priceList = $rs[0]['PriceList'];
    	}
    	return $priceList;
	}

	private function _getComregVal($name) {
		$comregRow = $this->Comreg->find('all', array('conditions'=> array('name' => $name)));
    	$comregRow = $comregRow->toArray();
		return $comregRow[0]['VALUE'];
	}
	
	private function _tweekPostcode($postcode, $country) {
		$tweekedPostcode = $postcode;
		if (strtolower(trim($country)) == "russia") {
			$tweekedPostcode = substr($postcode, 0, 3);
		}
		return $tweekedPostcode;
	}
}
?>