<?php
namespace App\Controller;
require_once(ROOT . DS . 'vendor' . DS . "mailchimp-api-master" . DS . "src" . DS . "MailChimp.php");
require_once(ROOT . DS . 'vendor' . DS . "mailchimp-api-master" . DS . "src" . DS . "Webhook.php");
use App\Controller\EmailServicesController;
use \Cake\Mailer\Email;
use \SoapClient;
use Cake\ORM\TableRegistry;
use Cake\Datasource\ConnectionManager;
use DrewM\MailChimp\MailChimp;
use DrewM\MailChimp\Webhook;
use Cake\I18n\Time;
use Cake\Log\Log;

class MailchimpSyncController extends AbstractImportController {

	private $apikey;
	private $listId;
	private $mailChimp;
	
	public function initialize() : void {
        parent::initialize();
        $this->loadModel('PendingMailchimpUpdates');
        $this->loadModel('CustomerType');
        $this->loadModel('Status');
        $this->loadModel('Channel');
        $this->loadModel('CountryList');
        $this->apikey = $this->_getComregVal("MAILCHIMP_APIKEY");
        $this->listId = $this->_getComregVal("MAILCHIMP_MASTERLISTID");
        $this->mailChimp = new MailChimp($this->apikey);
	}
	
	public function webhookHandler() {

		$this->autoRender = false;

		//check if POST
		if (!$this->request->is('post') && !$this->request->is('put')) {
			Log::write('error', 'webhookHandler: Invalid request type');
			return;
		}
		
		// check the security token
		$token = null;
		if (isset($_GET['token'])) {
    		$token = $_GET['token'];
		}
		Log::write('debug', 'webhookHandler: token: ' . $token);
		if (empty($token) || $token != 'peru992') {
			Log::write('error', 'webhookHandler: Invalid security token');
			return;
		}
		
		parse_str(file_get_contents('php://input'), $result);
		Log::write('debug', 'webhookHandler: result=' . print_r($result, true));
		
		if (empty($result) or empty($result['type'])) {
			Log::write('error', 'webhookHandler: Invalid input');
			return;
		}
		Log::write('debug', 'webhookHandler: type: ' . $result['type']);
		
		$this->_updateCustomerFromMailChimp($result);
	}
	
	private function _updateCustomerFromMailChimp($result) {
		//Log::write('debug', '_updateCustomerFromMailChimp: result=' . print_r($result, true));
		$data = $result['data'];
		Log::write('debug', '_updateCustomerFromMailChimp: data=' . print_r($data, true));
		$emailAddress = $data['email'];
		Log::write('debug', '_updateCustomerFromMailChimp: emailAddress=' . $emailAddress);
		$address = $this->Address->find('all', ['conditions' => ['EMAIL_ADDRESS' => $emailAddress]])->toArray();
		//Log::write('debug', '_updateCustomerFromMailChimp: address=' . print_r($address, true));
		Log::write('debug', '_updateCustomerFromMailChimp: address size=' . count($address));
		
		if (count($address) == 0) {
			// create new customer
			$this->_createNewCustomer($result['type'], $data);
		} else {
			// update existing customer
			Log::write('debug', '_updateCustomerFromMailChimp: code=' . count($address[0]['CODE']));
			$contact = $this->Contact->find('all', ['conditions' => ['CODE' => $address[0]['CODE']]])->toArray();
			//Log::write('debug', '_updateCustomerFromMailChimp: contact=' . print_r($contact, true));
			$acceptEmail = $contact[0]['acceptemail'];
			Log::write('debug', '_updateCustomerFromMailChimp: acceptEmail=' . $acceptEmail);
			$newAcceptEmail = $acceptEmail;
			if ($result['type'] == 'subscribe') {
				$newAcceptEmail = 'y';
			} else if ($result['type'] == 'unsubscribe') {
				$newAcceptEmail = 'n';
			}
			Log::write('debug', '_updateCustomerFromMailChimp: newAcceptEmail=' . $newAcceptEmail);
			
			if ($newAcceptEmail != $acceptEmail) {
				$contactObj = $this->Contact->get($contact[0]['CONTACT_NO']);
				$contactObj->acceptemail = $newAcceptEmail;
				$this->Contact->save($contactObj);
			}
		}
	}
	
	private function _createNewCustomer($resultType, $data) {
		$merges = $data['merges'];
		Log::write('debug', '_createNewCustomer: merges=' . print_r($merges, true));
		$now = $this->_getCurrentDateTimeStr();
		
    	// ADDRESS
    	$idLocation = 1;
		$address = $this->Address->newEntity([]);
		if (array_key_exists('ADDRESS', $merges)) {
			$addrData = $merges['ADDRESS'];
			Log::write('debug', '_createNewCustomer: $addrData=' . print_r($addrData, true));
			$address->street1 = $this->getStringFromArray('addr1', $addrData);
			$address->street2 = $this->getStringFromArray('addr2', $addrData);
			$address->town = $this->getStringFromArray('city', $addrData);
			$address->county = $this->getStringFromArray('state', $addrData);
			$address->country = $this->getStringFromArray('country', $addrData);
			if (!empty($addrData['country'])) {
				$address->country = $this->CountryList->mapFromMailchimp($addrData['country']);
			}
			$address->postcode = $this->getStringFromArray('zip', $addrData);
			$idLocation = $this->_getShowroomFromCountryAndPostcode($address->country, $address->postcode);
			Log::write('debug', '_createNewCustomer: address=' . print_r($address, true));
		}
		$idRegion = $this->_getRegionOfLocation($idLocation);
    	$address->EMAIL_ADDRESS = $this->getStringFromArray('EMAIL', $merges);
    	$address->INITIAL_CONTACT = 'MailChimp';
    	$address->CHANNEL = $this->_getAddressChannel('Unknown');
    	$address->STATUS = $this->_getAddressStatus($merges['CUSTSTATUS']);
    	$address->FIRST_CONTACT_DATE = $this->getDateFromArray('1STPURDATE', $merges);
    	$address->SOURCE_SITE = 'SB';
    	$address->OWNING_REGION = $idRegion;
    	$address->source = 'Other';
    	$address->source_other = 'MailChimp';
    	if (array_key_exists('COMPANY', $merges) && !empty($merges['COMPANY'])) {
    		$address->company = $this->getStringFromArray('COMPANY', $merges);
    		$address->CHANNEL = 'Trade';
    		$address->PRICE_LIST = 'Trade';
    	} else {
    		$address->PRICE_LIST = $this->_getPriceListForLocation($idLocation);
    	}
    	$this->Address->save($address);
    	$addressCode = $address->CODE;
    	Log::write('debug', '_createNewCustomer: address=' . print_r($address, true));
    	 
    	// CONTACT
   		$contact = $this->Contact->newEntity([]);
    	$contact->CODE = $addressCode;
    	$contact->title = $this->getStringFromArray('TITLE', $merges);
    	$contact->first = $this->getStringFromArray('FNAME', $merges);
    	$contact->surname = $this->getStringFromArray('LNAME', $merges);
    	//$contact->acceptemail = ($this->getStringFromArray('ACPTEMAIL', $merges)=='Yes' ? 'y' : 'n');
    	$contact->acceptemail = ($resultType=='subscribe' ? 'y' : 'n');
    	$contact->mobile = $this->getStringFromArray('PHONE', $merges);
    	$contact->dateadded = $now;
    	$contact->dateupdated = $now;
    	$contact->retire = 'n';
    	$contact->BrochureRequestSent = 'n';
    	$contact->SOURCE_SITE = 'SB';
    	$contact->idlocation = $idLocation;
    	$contact->OWNING_REGION = $idRegion;
    	$contact->customerType = $this->_getCustomerTypeId($merges['CUSTTYPE']);
    	$this->Contact->save($contact);
    	$contactNo = $contact->CONTACT_NO;
    	Log::write('debug', '_createNewCustomer: contact=' . print_r($contact, true));
    	 
    	echo '<br/>contactid=' . $contactNo;
	}
	
	private function _getCustomerTypeId($suppliedCustType) {
		$rs = $this->CustomerType->find('all', ['conditions'=> ['customerType like' => trim($suppliedCustType)]]);
		$id = 0;
		foreach ($rs as $row) {
			$id = $row['customerTypeID'];
		}
		if ($id == 0) {
			$id = $this->_getCustomerTypeId('Other');
		}
		return $id;
	}

	private function _getAddressStatus($suppliedStatus) {
		$rs = $this->Status->find('all', ['conditions'=> ['Status like' => trim($suppliedStatus), 'retired' => 'n']]);
		$status = 'Prospect';
		foreach ($rs as $row) {
			$status = $row['Status'];
		}
		return $status;
	}
	
	private function _getAddressChannel($suppliedChannel) {
		$rs = $this->Channel->find('all', ['conditions'=> ['Channel like' => trim($suppliedChannel)]]);
		$channel = 'Unknown';
		foreach ($rs as $row) {
			$channel = $row['Channel'];
		}
		return $channel;
	}
	
	public function pushSubscriptionChanges() {
		$this->autoRender = false;
		$conn = ConnectionManager::get('default');
		
		$contacts = $this->PendingMailchimpUpdates->getStatusChangedContacts();
		debug($contacts);
		foreach ($contacts as $contact) {
			$conn->begin();
			$emailAddress = $contact['EMAIL_ADDRESS'];
			$acceptemail = ($contact['acceptemail'] == 'y');
			$status = $this->_getCurrentSubscriptionStatus($emailAddress);
			echo '<br>CurrentSubscriptionStatus:';
			echo '<br>emailAddress='. $emailAddress. ' acceptemail=' . $acceptemail . ' status=' . $status;
			
				if (!$status) {
					$this->_addNewMember($contact['CONTACT_NO']);
					echo '<br>_addNewMember called';
			} else {
				$this->_updateExistingMember($contact['CONTACT_NO'], $acceptemail);
				echo '<br>_updateExistingMember called';
			}
			
			$this->_markAsProcessed($contact);
			$conn->commit();
		}
		
    	echo '<br>All outstanding updates sent to Mailchimp';
	}
	
	private function _markAsProcessed($contact) {
		$pmu = $this->PendingMailchimpUpdates->get($contact['pmu_id']);
		//debug($pmu);
		$pmu->processed = Time::now();
		$this->PendingMailchimpUpdates->save($pmu);
	}
	
	private function _addNewMember($contactNo) {
		$contact = $this->Contact->getContact($contactNo);
		$address = $this->Address->find('all', array('conditions'=> array('CODE' => $contact[0]['CODE'])))->toArray()[0];
		$mergeFields = $this->_getMergeFields($contact[0], $address, true);
		debug($mergeFields);
		
		$result = $this->mailChimp->post("lists/" . $this->listId . "/members", [
					'email_address' => $contact[0]['EMAIL_ADDRESS'],
					'status'        => 'subscribed',
					'merge_fields'	=> $mergeFields
		]);
		debug($result);
	}
	
	private function _updateExistingMember($contactNo, $acceptemail) {
		$contact = $this->Contact->getContact($contactNo);
		$address = $this->Address->find('all', array('conditions'=> array('CODE' => $contact[0]['CODE'])))->toArray()[0];
		$mergeFields = $this->_getMergeFields($contact[0], $address, $acceptemail);
		$subscribedStatus = $acceptemail ? 'subscribed' : 'unsubscribed';

		$result = $this->mailChimp->patch("lists/" . $this->listId . "/members/".md5($contact[0]['EMAIL_ADDRESS']), [
				'status' => $subscribedStatus,
				'merge_fields' => $mergeFields
		]);
		echo '<br>' . $contactNo . ' ' . $subscribedStatus;
	}
	
	private function _getMergeFields($contact, $address, $acceptemail) {
		$showroom = $this->Location->getCustomerShowroom($contact['CONTACT_NO']);
		$firstPurchaseDate = $this->Purchase->getFirstPurchaseDate($contact['CONTACT_NO']);
		$latestPurchaseDate = $this->Purchase->getLatestPurchaseDate($contact['CONTACT_NO']);
		$hasPurchasedAccessories = $this->Purchase->hasPurchasedAccessories($contact['CONTACT_NO']);
		$hasPurchasedTopper = $this->Purchase->hasPurchasedTopper($contact['CONTACT_NO']);
		$latestTopperDeliveryDate = $this->Purchase->getLatestTopperDeliveryDate($contact['CONTACT_NO']);
		$hasPurchasedMattress = $this->Purchase->hasPurchasedMattress($contact['CONTACT_NO']);
		$latestMattressDeliveryDate = $this->Purchase->getLatestMattressDeliveryDate($contact['CONTACT_NO']);
		$communicationType = $this->Communication->getCommunicationType($contact['CONTACT_NO']);
		$exVatOrderTotal = $this->Purchase->getExVatOrderTotalForCustomer($contact['CONTACT_NO']);
		
		$addrCode = $address['country'];
		if (!empty($address['country'])) {
			$mcCode = $this->CountryList->mapToMailchimp($address['country']);
			if ($mcCode != null) {
				$addrCode = $mcCode;
			}
		}
		
		$mergeFields = [];
		$this->_pushValToArray($mergeFields, 'FNAME', $contact['first']);
		$this->_pushValToArray($mergeFields, 'LNAME', $contact['surname']);
		
		$this->_pushValToArray($mergeFields, 'PHONE', $address['tel']);
		$this->_pushValToArray($mergeFields, 'CUSTSTATUS', $address['STATUS']);
		$customerType = $contact['customerType'];
		if (empty($customerType) || $customerType < 1 || $customerType > 6) {
			$customerType = 6; // other
		}
		$this->_pushValToArrayWithLookup($mergeFields, 'CUSTTYPE', $customerType, $this->CustomerType, 'customerType');
		$this->_pushValToArray($mergeFields, 'TITLE', $contact['title']);
		$this->_pushValToArray($mergeFields, 'COMPANY', $address['company']);
		$this->_pushValToArray($mergeFields, 'CITY', $address['town']);
		$this->_pushValToArray($mergeFields, 'COUNTRY', $addrCode);
		$this->_pushValToArray($mergeFields, 'PRICELIST', $address['PRICE_LIST']);
		$this->_pushValToArray($mergeFields, 'SHOWROOM', $showroom['location']);
		if (isset($firstPurchaseDate) && !empty($firstPurchaseDate)) {
			$this->_pushValToArray($mergeFields, '1STPURDATE', $firstPurchaseDate);
		}
		if (isset($latestPurchaseDate) && !empty($latestPurchaseDate)) {
			$this->_pushValToArray($mergeFields, 'LSTPURDATE', $latestPurchaseDate);
		}
		$this->_pushValToArray($mergeFields, 'ACCESSORY', $hasPurchasedAccessories ? 'Yes' : 'No');
		$this->_pushValToArray($mergeFields, 'TOPPER', $hasPurchasedTopper ? 'Yes' : 'No');
		if (isset($latestTopperDeliveryDate) && !empty($latestTopperDeliveryDate)) {
			$this->_pushValToArray($mergeFields, 'TOPDELDATE', $latestTopperDeliveryDate);
		}
		$this->_pushValToArray($mergeFields, 'MATTRESS', $hasPurchasedMattress ? 'Yes' : 'No');
		if (isset($latestMattressDeliveryDate) && !empty($latestMattressDeliveryDate)) {
			$this->_pushValToArray($mergeFields, 'MATDELDATE', $latestMattressDeliveryDate);
		}
		$this->_pushValToArray($mergeFields, 'ACPTEMAIL', $acceptemail ? 'Yes' : 'No');
		$this->_pushValToArray($mergeFields, 'SOURCE', $communicationType);
		$this->_pushValToArray($mergeFields, 'VALEXVAT', $exVatOrderTotal);
		
		$addrArray = [];
		$this->_pushValToArray($addrArray, 'addr1', $address['street1']);
		$this->_pushValToArray($addrArray, 'addr2', $address['street2']);
		$this->_pushValToArray($addrArray, 'city', $address['town']);
		$this->_pushValToArray($addrArray, 'state', $address['county']);
		$this->_pushValToArray($addrArray, 'zip', $address['postcode']);
		$this->_pushValToArray($addrArray, 'country', $addrCode);
		$mergeFields['ADDRESS']	= $addrArray;
		
		debug($mergeFields);
		//die;
		return $mergeFields;
	}
	
	private function _pushValToArray(&$trgArray, $trgName, $val) {
		if (isset($val) && $val != NULL) {
			$trgArray[$trgName] = $val;
		}
	}
	
	private function _pushValToArrayWithLookup(&$trgArray, $trgName, $idVal, $table, $valCol) {
		if (isset($idVal) && $idVal != NULL) {
			$row = $table->get($idVal);
			$trgArray[$trgName] = $row[$valCol];
		}
	}
	
	private function _unsubscribeExistingMember($contactNo) {
		$contact = $this->Contact->getContact($contactNo);
		//debug($contact);

		$result = $this->mailChimp->patch("lists/" . $this->listId . "/members/".md5($contact[0]['EMAIL_ADDRESS']), [
				'status' => 'unsubscribed',
		]);
		echo '<br>' . $contactNo . ' unsubscribed';
	}
	
	private function _getCurrentSubscriptionStatus($emailAddress) {
		
		$member = $this->mailChimp->get('lists/' . $this->listId . '/members/'. md5($emailAddress));
		$error = $this->mailChimp->getLastError();
		if ($error) {
			return false;
		}
		return $member['status'];
	}
	
	protected function _getHeader() {
		return "";
	}

}
?>