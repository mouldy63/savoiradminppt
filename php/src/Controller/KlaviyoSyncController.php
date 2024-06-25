<?php
namespace App\Controller;

use Cake\I18n\Time;
use Klaviyo\Client;
use KlaviyoAPI\KlaviyoAPI;
use Exception;
use \App\Controller\Component\UtilityComponent;

class KlaviyoSyncController extends AbstractImportController {

    private $client;
    private $publicKey;
    
	public function initialize() : void {
        parent::initialize();
        $this->loadModel('PendingMailchimpUpdates');
        $this->loadModel('CustomerType');
        $this->loadModel('QcHistoryLatest');
        $this->loadModel('QcHistory');
        $this->loadModel('Address');
        $this->loadModel('Contact');
        $this->client = new Client($this->_getComregVal("KLAVIYO_PRIVATE_KEY"));
        $this->publicKey = $this->_getComregVal("KLAVIYO_PUBLIC_KEY");
        $this->privateKey = $this->_getComregVal("KLAVIYO_PRIVATE_KEY");
	}
	
	public function getUnsubscribes() {
		$this->autoRender = false;
		
		$key = $this->request->getQuery('key');
		if ($key == null || $key != 'fPmaneidQslty') {
			http_response_code(404);
			exit;
		}
		
        $segmentId = $this->_getComregVal('KLAVIYO_UNSUBSCRIBE_SEGMENTID');  // 'Skywire - Unsubscribes'
		$klaviyo = new KlaviyoAPI($this->privateKey, $num_retries = 3, $wait_seconds = 3);
		$cursor = $this->_getComregVal('KLAVIYO_UNSUBSCRIBE_SEGMENT_CURSOR');
		$loop = 0;
		
		for ($n = 0; $n < 10; $n++) {
			echo '<br>old cursor = '.$cursor;
			error_log('old cursor = '.$cursor);
			$profileCount = 0;

			$profiles = $klaviyo->Segments->getSegmentProfiles($segmentId, null, null, $cursor, null);
			foreach($profiles['data'] as $profile) {
				$profileId = $profile['id'];
				$emailAddress = trim($profile['attributes']['email']);
				$this->unsubscribeContact($emailAddress);
				echo '<br>' . $emailAddress . ' unsubscribed from savoiradmin';
				$profileCount++;
			}

			$cursor = $this->_getNextPageCursor($profiles);
			echo '<br>new cursor = '.$cursor;
			error_log('new cursor = '.$cursor);
		}
		$this->_saveComregVal('KLAVIYO_UNSUBSCRIBE_SEGMENT_CURSOR', $cursor);
		
		echo "<br>$profileCount Klaviyo unsubscibes processed";
		error_log("$profileCount Klaviyo unsubscibes processed");
	}
	
	private function unsubscribeContact($emailAddress) {
		
		$rs = $this->Address->find('all', ['conditions'=> ['EMAIL_ADDRESS' => $emailAddress]])->toArray();
		if (count($rs) == 0) {
			echo '<br>WARNING: ' . $emailAddress . ' not found in savoiradmin';
			return;
		}
		foreach ($rs as $address) {
			$rs2 = $this->Contact->find('all', ['conditions'=> ['CODE' => $address['CODE']]]);
			foreach ($rs2 as $contact) {
				$contact['acceptemail'] = 'n';
				$contact['acceptpost'] = 'n';
				$this->Contact->save($contact);
				$this->PendingMailchimpUpdates->deleteLatestContactEntries($contact['CONTACT_NO']);
			}
		}
	}

	private function _getNextPageCursor($profiles) {
		$cursor = null;
		if (!array_key_exists('links', $profiles)) {
			return $cursor;
		}
		if (!array_key_exists('next', $profiles['links'])) {
			return $cursor;
		}

		$nextUrl = $profiles['links']['next'];
		if (empty($nextUrl)) {
			return $cursor;
		}
		$urlParts = parse_url($nextUrl);
		$bits = explode('=', $urlParts['query']);
		$i = 0;
		foreach($bits as $bit) {
			if ($bit == 'page%5Bcursor%5D') {
				$cursor = $bits[$i+1];
				break;
			}
			$i++;
		}
		return $cursor;
	}
	
	public function pushSubscriptionChanges() {
		$this->autoRender = false;
		
		$key = $this->request->getQuery('key');
		if ($key == null || $key != 'mGc3ZwBg') {
			http_response_code(404);
			exit;
		}

		$this->PendingMailchimpUpdates->deleteOrphanUpdates();

		$limit = $this->request->getQuery('limit');
		$email = $this->request->getQuery('email');
		$markInvalidProcessed = $this->request->getQuery('fix') == 'true';
		
		if ($email == null) {
			$contacts = $this->PendingMailchimpUpdates->getDistinctStatusChangedContacts($limit);
		} else {
			$contacts = $this->PendingMailchimpUpdates->getContactByEmail($email);
		}
		//debug($contacts);
		foreach ($contacts as $c) {
			$startTime = time();
			$contact = $this->Contact->getContact($c['CONTACT_NO'])[0];
			$this->printElapsedTime('fetch contact record', $startTime);
			
			$emailAddress = trim($c['EMAIL_ADDRESS']);
			if (!filter_var($emailAddress, FILTER_VALIDATE_EMAIL)) {
				if ($markInvalidProcessed) {
					echo '<br>emailAddress #'. $emailAddress. '# is invalid. Skipping and marking as processed.';
					$this->PendingMailchimpUpdates->markAsProcessedByEmail($emailAddress);
				} else {
					echo '<br>emailAddress #'. $emailAddress. '# is invalid.';
				}
				continue;
			}
			$this->printElapsedTime('marked invalid email address', $startTime);

			$acceptemail = ($c['acceptemail'] == 'y');
			$exists = $this->_profileExists($emailAddress);
			$this->printElapsedTime('checked profile exists', $startTime);
			echo '<br>emailAddress='. $emailAddress. ' acceptemail=' . $acceptemail . ' exists=' . $exists;
			if (!$exists) {
			    $this->_createNewProfile($emailAddress);
			    echo '<br>New profile added for ' . $emailAddress;
			}
			$this->printElapsedTime('created new profile if necessary', $startTime);
			
			$tryCount = 0;
			while ($tryCount < 5) {
				$tryCount++;
				$success = false;
				try {
			$this->_updateProfile($contact, $acceptemail);
					$success = true;
				} catch (Exception $e) {
					echo '<br>Trycount=' . $tryCount . ' Exception: ' . $e->getMessage();
					sleep(1);
				}
				if ($success) break;
			}
			echo '<br>Klaviyo profile updated for ' . $emailAddress;
			$this->printElapsedTime('updated profile', $startTime);
			
			if ($email == null) {
				$this->PendingMailchimpUpdates->markAsProcessed($c['CONTACT_NO']);
				echo '<br>' . $c['CONTACT_NO'] . ' marked as processed';
			}
			$this->printElapsedTime('marked as processed', $startTime);
			
		}
		
    	echo '<br>All outstanding updates sent to Klaviyo';
	}
	
	private function printElapsedTime($label, $startTime) {
		$elapsed = time() - $startTime;
		echo '<br>' . $label . ': elapsed=' . $elapsed;
	}
	
	private function _updateProfile($contact, $acceptemail) {
		$address = $this->Address->find('all', array('conditions'=> array('CODE' => $contact['CODE'])))->toArray()[0];

		// mobile
		$mobile = null;
		if (isset($contact['mobile']) && $contact['mobile'] != NULL) {
		    $mobile = $contact['mobile'];
		} else if (isset($address['tel']) && $address['tel'] != NULL) {
		    $mobile = $address['tel'];
		}
		
		// showrooms
		$owningShowroom = $this->Location->getCustomerShowroom($contact['CONTACT_NO']);
		$showroom = null;
		if (isset($contact['idlocation'])) {
			$showroom = $this->Location->get($contact['idlocation']);
		}
		
		// brochure request
		$brochureRequestType = $this->Communication->getBrochureRequestType($contact['CONTACT_NO']);
		if ($brochureRequestType == null) {
			$brochureRequestType = 'None';
		} else {
			$brochureRequestType = str_contains($brochureRequestType, 'email') ? 'Digital Brochure' : 'Post Brochure';
		}
		
		// source
		$source = $address['source'];
		if ($source == 'Other' && !empty($address['source_other'])) $source .= ' - ' . $address['source_other']; 
		
		// communication type
		$communicationType = $this->Communication->getCommunicationType($contact['CONTACT_NO']);
		
		// customer type
		$customerType = $contact['customerType'];
		if (empty($customerType) || $customerType < 1 || $customerType > 6) {
			$customerType = 6; // other
		}
		$customerType = $this->CustomerType->get($customerType)['customerType'];
		
		// accept post
		$acceptPost = ($contact['acceptemail'] == 'y') ? 'Yes' : 'No';
		
		// order numbers
		$orderNumbersArray = $this->Contact->getOrderNumbers($contact['CONTACT_NO']);
		$orderNumbers = (isset($orderNumbersArray) && count($orderNumbersArray) > 0) ? implode(',', $orderNumbersArray) : 'None';
		
		// latest order
		$latestOrder = $this->Contact->getLatestOrder($contact['CONTACT_NO']);
		$latestOrderValue = 'None';
		if ($latestOrder != null) {
			$latestOrderValue = (!empty($latestOrder['total'])) ? UtilityComponent::formatMoneyWithSymbol($latestOrder['total'], $latestOrder['ordercurrency']) : 'None';
		}
		
		// products purchased
		$productsPurchased = 'None';
		if ($latestOrder != null) {
			$temp = [];
			if ($latestOrder['mattressrequired']=='y') $temp[] = 'Mattress';
			if ($latestOrder['topperrequired']=='y') $temp[] = 'Topper';
			if ($latestOrder['baserequired']=='y') $temp[] = 'Base';
			if ($latestOrder['headboardrequired']=='y') $temp[] = 'Headboard';
			if ($latestOrder['valancerequired']=='y') $temp[] = 'Valance';
			if ($latestOrder['legsrequired']=='y') $temp[] = 'Legs';
			if ($latestOrder['accessoriesrequired']=='y') $temp[] = 'Accessories';
			$productsPurchased = implode(',', $temp);
		}
		
		// order status
		$orderStatus = 'None';
		if ($latestOrder != null) {
			$temp = $this->QcHistoryLatest->getOrderStatusName($latestOrder['PURCHASE_No']);
			if ($temp != null) $orderStatus = $temp;
		}

		// order confirmed date
		$orderConfirmedDate = 'None';
		if ($latestOrder != null) {
			$temp = $this->QcHistory->getOrderConfirmedDate($latestOrder['PURCHASE_No']);
			if ($temp != null) $orderConfirmedDate = $temp;
		}

		// mattress and base issued dates
		$mattressIssuedDate = 'None';
		$baseIssuedDate = 'None';
		if ($latestOrder != null) {
			$temp = $this->QcHistory->getIssueDate($latestOrder['PURCHASE_No'], 1);
			if ($temp != null && count($temp) > 0) {
				$mattressIssuedDate = $temp[0]['IssuedDate'];
			}

			$temp = $this->QcHistory->getIssueDate($latestOrder['PURCHASE_No'], 3);
			if ($temp != null && count($temp) > 0) {
				$baseIssuedDate = $temp[0]['IssuedDate'];
			}
		}

		// get the customer ID from Klaviyo
		$response = $this->client->Profiles->getProfileId(trim($address['EMAIL_ADDRESS']));
		$personId = $response['id'];
		echo '<br>EMAIL_ADDRESS = ' . $address['EMAIL_ADDRESS'] . ' personId = '. $personId;
		
		// Klaviyo properties
		$data = [];
		$this->_pushValToArray($data, '$email', trim($address['EMAIL_ADDRESS']));
        $this->_pushValToArray($data, '$first_name', $contact['first']);
		$this->_pushValToArray($data, '$last_name', $contact['surname']);
        $this->_pushValToArray($data, '$address1', $address['street1']);
		$this->_pushValToArray($data, '$address2', $address['street2']);
        $this->_pushValToArray($data, '$city', $address['town']);
		$this->_pushValToArray($data, '$region', $address['county']);
        $this->_pushValToArray($data, '$zip', $address['postcode']);
		$this->_pushValToArray($data, '$country', $address['country']);
        $this->_pushValToArray($data, '$organization', $address['company']);
		$this->_pushValToArray($data, '$title', $contact['title']);
        $this->_pushValToArray($data, '$phone_number', $address['tel']);
		
		// custom properties
        $this->_pushValToArray($data, 'Title', $contact['title']);
        $this->_pushValToArray($data, 'First Name', $contact['first']);
        $this->_pushValToArray($data, 'Last Name', $contact['surname']);
        $this->_pushValToArray($data, 'Email Address', trim($address['EMAIL_ADDRESS']));
        $this->_pushValToArray($data, 'Address', $address['street1']);
        $this->_pushValToArray($data, 'Address Line 2', $address['street2']);
        $this->_pushValToArray($data, 'Address Line 3', $address['street3']);
        $this->_pushValToArray($data, 'Town', $address['town']);
        $this->_pushValToArray($data, 'County', $address['county']);
        $this->_pushValToArray($data, 'Postcode', $address['postcode']);
        $this->_pushValToArray($data, 'Country', $address['country']);
        $this->_pushValToArray($data, 'Mobile', $mobile);
        $this->_pushValToArray($data, 'Company', $address['company']);
        $this->_pushValToArray($data, 'Brochure Type', $brochureRequestType);
        $this->_pushValToArray($data, 'Source', $source);
        $this->_pushValToArray($data, 'Type', $address['CHANNEL']);
        $this->_pushValToArray($data, 'Accepts Marketing', $acceptemail ? 'Yes' : 'No');
        $this->_pushValToArray($data, 'Accepts Postal Marketing', $acceptPost);
        $this->_pushValToArray($data, 'Owning Showroom', $owningShowroom['location']);
        $this->_pushValToArray($data, 'Showroom', $showroom['location']);
        $this->_pushValToArray($data, 'Status', isset($address['STATUS']) ? $address['STATUS'] : 'Unknown');
        $this->_pushValToArray($data, 'Customer Type', $customerType);
        $this->_pushValToArray($data, 'Order Number', $orderNumbers);
        $this->_pushValToArray($data, 'Last Order Date', $latestOrder ? $latestOrder['ORDER_DATE'] : 'None');
        $this->_pushValToArray($data, 'Last Order Value', $latestOrderValue);
        $this->_pushValToArray($data, 'Product Purchased', $productsPurchased);
        $this->_pushValToArray($data, 'Mattress Type', ($latestOrder && $latestOrder['mattressrequired']=='y') ? $latestOrder['savoirmodel'] : 'None');
        $this->_pushValToArray($data, 'Base Type', ($latestOrder && $latestOrder['baserequired']=='y') ? $latestOrder['basesavoirmodel'] : 'None');
        $this->_pushValToArray($data, 'Headboard', ($latestOrder && $latestOrder['headboardrequired']=='y') ? $latestOrder['headboardstyle'] : 'None');
        $this->_pushValToArray($data, 'Topper Type', ($latestOrder && $latestOrder['topperrequired']=='y') ? $latestOrder['toppertype'] : 'None');
        $this->_pushValToArray($data, 'Accessories', ($latestOrder && $latestOrder['accessoriesrequired']=='y') ? 'Yes' : 'None');
        $this->_pushValToArray($data, 'Order Status', $orderStatus);
        $this->_pushValToArray($data, 'Order Confirmed Date', $orderConfirmedDate);
        $this->_pushValToArray($data, 'Mattress Issued Date', $mattressIssuedDate);
        $this->_pushValToArray($data, 'Base Issued Date', $baseIssuedDate);
        $this->_pushValToArray($data, 'Order Delivery Date', $latestOrder ? $latestOrder['bookeddeliverydate'] : 'None');

        $this->_pushValToArray($data, 'Lifetime Spend (GBP)', 0);
        $this->_pushValToArray($data, 'Lifetime Spend (USD)', 0);
        $this->_pushValToArray($data, 'Lifetime Spend (EUR)', 0);
        $this->_pushValToArray($data, 'Lifetime AOV (GBP)', 0);
        $this->_pushValToArray($data, 'Lifetime AOV (USD)', 0);
        $this->_pushValToArray($data, 'Lifetime AOV (EUR)', 0);
		$lifetimeSpendArray = $this->Contact->getLifetimeSpendByCurrency($contact['CONTACT_NO']);
		foreach ($lifetimeSpendArray as $item) {
			$name = 'Lifetime Spend ('.$item['ordercurrency'].')';
	        $this->_pushValToArray($data, $name, $item['tot']);
			$name = 'Lifetime AOV ('.$item['ordercurrency'].')';
	        $this->_pushValToArray($data, $name, $item['tot']/$item['n']);
		}
        
		$result = $this->client->Profiles->updateProfile($personId, $data);
	}
	
	private function _pushValToArray(&$trgArray, $trgName, $val) {
		if (isset($val)) {
			$trgArray[$trgName] = $val;
		}
	}
	
	private function _profileExists($emailAddress) {
		
	    try {
	        $response = $this->client->Profiles->getProfileId($emailAddress);
	        $profile = $this->client->Profiles->getProfile($response['id']);
	    } catch (Exception $e) {
	        return false;
	    }
		return true;
	}
	
	private function _createNewProfile($emailAddress) {
	    $gclient = new \GuzzleHttp\Client();
	    $data = [
	        'form_params' => [
	            'data' => '{"token": "'. $this->publicKey .'","properties": {"$email":"'. $emailAddress .'"}}'
	        ],
	        'headers' => [
	            'accept' => 'text/html',
	            'content-type' => 'application/x-www-form-urlencoded',
	        ]
        ];
	    
	    $response = $gclient->request('POST', 'https://a.klaviyo.com/api/identify', $data);
	    $result = $response->getBody();
	    if (intval(strval($result)) == 0) {
	        throw new Exception('_createNewProfile failed for email ' . $emailAddress);
	    }
	}
	
	protected function _getHeader() {
		return "";
	}

}
?>