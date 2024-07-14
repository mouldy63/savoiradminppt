<?php
namespace App\Controller;

use Cake\I18n\Time;
use Exception;
use \App\Controller\Component\UtilityComponent;

class KlaviyoSyncController extends AbstractImportController {

	public function initialize() : void {
        parent::initialize();
        $this->loadModel('PendingMailchimpUpdates');
        $this->loadModel('CustomerType');
        $this->loadModel('QcHistoryLatest');
        $this->loadModel('QcHistory');
        $this->loadModel('Address');
        $this->loadModel('Contact');
        $this->privateKey = $this->_getComregVal("KLAVIYO_PRIVATE_KEY");
	}
	
	public function getUnsubscribes() {
		$this->autoRender = false;
		
		$key = $this->request->getQuery('key');
		if ($key == null || $key != 'fPmaneidQslty') {
			http_response_code(404);
			exit;
		}

		$rooturl = 'https://a.klaviyo.com/api/segments/' . $this->_getComregVal('KLAVIYO_UNSUBSCRIBE_SEGMENTID') . '/profiles/?page[size]=20';
		$cursor = $this->_getComregVal('KLAVIYO_UNSUBSCRIBE_SEGMENT_CURSOR');

		for ($n = 0; $n < 10; $n++) {
			echo '<br>old cursor = '.$cursor;
			error_log('old cursor = '.$cursor);
			$profileCount = 0;

			$url = $rooturl;
			if (!empty($cursor)) {
				$url .= '&page[cursor]=' . $cursor;
			}
			$response = $this->getGuzzleClient()->request('GET', $url, [
				'headers' => [
					'Authorization' => 'Klaviyo-API-Key ' . $this->privateKey,
					'accept' => 'application/json',
					'revision' => '2024-06-15',
				],
			]);
			$body = json_decode($response->getBody(), true);
			foreach($body['data'] as $profile) {
				$emailAddress = trim($profile['attributes']['email']);
				$this->unsubscribeContact($emailAddress);
				echo '<br>' . $emailAddress . ' unsubscribed from savoiradmin';
				$profileCount++;
			}

			$cursor = $this->_getNextPageCursor($body);
			echo '<br>new cursor = '.$cursor;
			error_log('new cursor = '.$cursor);
			if (!$cursor) {
				break;
			}
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

	private function _getNextPageCursor($body) {
		$cursor = null;
		if (isset($body['links']) && isset($body['links']['next'])) {
			$nextUrl = $body['links']['next'];
			$queryString = parse_url($nextUrl, PHP_URL_QUERY);
			if ($queryString) {
				parse_str($queryString, $queryParams);
				if (isset($queryParams['page']) && isset($queryParams['page']['cursor'])) {
					$cursor = $queryParams['page']['cursor'];
				}
			}
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
			echo '<br>emailAddress='. $emailAddress. ' acceptemail=' . $acceptemail;
			
			$tryCount = 0;
			while ($tryCount < 5) {
				$tryCount++;
				$success = false;
				try {
					$this->sendProfile($contact, $acceptemail);
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
	
	private function sendProfile($contact, $acceptemail) {
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

		echo '<br>EMAIL_ADDRESS = ' . $address['EMAIL_ADDRESS'];

		$data = [];
		$data['type'] = 'profile';

		$attributes = [];
		$this->_pushValToArray($attributes, 'email', trim($address['EMAIL_ADDRESS']));
		$this->_pushValToArray($attributes, 'first_name', $contact['first']);
		$this->_pushValToArray($attributes, 'last_name', $contact['surname']);
		$this->_pushValToArray($attributes, 'organization', $address['company']);
		$this->_pushValToArray($attributes, 'title', $contact['title']);

		$location = [];
        $this->_pushValToArray($location, 'zip', $address['postcode']);
        $this->_pushValToArray($location, 'address2', $address['street2']);
        $this->_pushValToArray($location, 'address1', $address['street1']);
        $this->_pushValToArray($location, 'region', $address['county']);
        $this->_pushValToArray($location, 'city', $address['town']);
        $this->_pushValToArray($location, 'country', $address['country']);
		$attributes['location'] = $location;
		
		// custom properties
		$properties = [];
        $this->_pushValToArray($properties, 'Title', $contact['title']);
        $this->_pushValToArray($properties, 'First Name', $contact['first']);
        $this->_pushValToArray($properties, 'Last Name', $contact['surname']);
        $this->_pushValToArray($properties, 'Email Address', trim($address['EMAIL_ADDRESS']));
        $this->_pushValToArray($properties, 'Address', $address['street1']);
        $this->_pushValToArray($properties, 'Address Line 2', $address['street2']);
        $this->_pushValToArray($properties, 'Address Line 3', $address['street3']);
        $this->_pushValToArray($properties, 'Town', $address['town']);
        $this->_pushValToArray($properties, 'County', $address['county']);
        $this->_pushValToArray($properties, 'Postcode', $address['postcode']);
        $this->_pushValToArray($properties, 'Country', $address['country']);
        $this->_pushValToArray($properties, 'Mobile', $mobile);
        $this->_pushValToArray($properties, 'Company', $address['company']);
        $this->_pushValToArray($properties, 'Brochure Type', $brochureRequestType);
        $this->_pushValToArray($properties, 'Source', $source);
        $this->_pushValToArray($properties, 'Type', $address['CHANNEL']);
        $this->_pushValToArray($properties, 'Accepts Marketing', $acceptemail ? 'Yes' : 'No');
        $this->_pushValToArray($properties, 'Accepts Postal Marketing', $acceptPost);
        $this->_pushValToArray($properties, 'Owning Showroom', $owningShowroom['location']);
        $this->_pushValToArray($properties, 'Showroom', $showroom['location']);
        $this->_pushValToArray($properties, 'Status', isset($address['STATUS']) ? $address['STATUS'] : 'Unknown');
        $this->_pushValToArray($properties, 'Customer Type', $customerType);
        $this->_pushValToArray($properties, 'Order Number', $orderNumbers);
        $this->_pushValToArray($properties, 'Last Order Date', $latestOrder ? $latestOrder['ORDER_DATE'] : 'None');
        $this->_pushValToArray($properties, 'Last Order Value', $latestOrderValue);
        $this->_pushValToArray($properties, 'Product Purchased', $productsPurchased);
        $this->_pushValToArray($properties, 'Mattress Type', ($latestOrder && $latestOrder['mattressrequired']=='y') ? $latestOrder['savoirmodel'] : 'None');
        $this->_pushValToArray($properties, 'Base Type', ($latestOrder && $latestOrder['baserequired']=='y') ? $latestOrder['basesavoirmodel'] : 'None');
        $this->_pushValToArray($properties, 'Headboard', ($latestOrder && $latestOrder['headboardrequired']=='y') ? $latestOrder['headboardstyle'] : 'None');
        $this->_pushValToArray($properties, 'Topper Type', ($latestOrder && $latestOrder['topperrequired']=='y') ? $latestOrder['toppertype'] : 'None');
        $this->_pushValToArray($properties, 'Accessories', ($latestOrder && $latestOrder['accessoriesrequired']=='y') ? 'Yes' : 'None');
        $this->_pushValToArray($properties, 'Order Status', $orderStatus);
        $this->_pushValToArray($properties, 'Order Confirmed Date', $orderConfirmedDate);
        $this->_pushValToArray($properties, 'Mattress Issued Date', $mattressIssuedDate);
        $this->_pushValToArray($properties, 'Base Issued Date', $baseIssuedDate);
        $this->_pushValToArray($properties, 'Order Delivery Date', $latestOrder ? $latestOrder['bookeddeliverydate'] : 'None');

        $this->_pushValToArray($properties, 'Lifetime Spend (GBP)', 0);
        $this->_pushValToArray($properties, 'Lifetime Spend (USD)', 0);
        $this->_pushValToArray($properties, 'Lifetime Spend (EUR)', 0);
        $this->_pushValToArray($properties, 'Lifetime AOV (GBP)', 0);
        $this->_pushValToArray($properties, 'Lifetime AOV (USD)', 0);
        $this->_pushValToArray($properties, 'Lifetime AOV (EUR)', 0);
		$lifetimeSpendArray = $this->Contact->getLifetimeSpendByCurrency($contact['CONTACT_NO']);
		foreach ($lifetimeSpendArray as $item) {
			$name = 'Lifetime Spend ('.$item['ordercurrency'].')';
	        $this->_pushValToArray($properties, $name, $item['tot']);
			$name = 'Lifetime AOV ('.$item['ordercurrency'].')';
	        $this->_pushValToArray($properties, $name, $item['tot']/$item['n']);
		}
		$attributes['properties'] = $properties;
		$data['attributes'] = $attributes;
		$payload['data'] = $data;
		echo '<br>' . json_encode($payload);

		$response = $this->getGuzzleClient()->request('POST', 'https://a.klaviyo.com/api/profile-import/', [
			'body' => json_encode($payload),
			'headers' => [
			  'Authorization' => 'Klaviyo-API-Key ' . $this->privateKey,
			  'accept' => 'application/json',
			  'content-type' => 'application/json',
			  'revision' => '2024-06-15',
			],
		]);

		if ($response->getStatusCode() != 200 && $response->getStatusCode() != 201) {
			debug($response);
			throw new Exception('sendProfile returned code ' . $response->getStatusCode());
		}
	}
	
	private function _pushValToArray(&$trgArray, $trgName, $val) {
		if (isset($val)) {
			$trgArray[$trgName] = $val;
		}
	}
	
	protected function _getHeader() {
		return "";
	}

	private function getGuzzleClient() {
		return new \GuzzleHttp\Client();
	}

}
?>