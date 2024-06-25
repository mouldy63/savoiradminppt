<?php
namespace App\Controller;
use App\Controller\EmailServicesController;
use Cake\ORM\TableRegistry;
use Cake\Datasource\ConnectionManager;
use Cake\I18n\Time;
use \Exception;

class BrochureRequestImportCustomController extends AbstractImportController {

	private $brHeader;
	private $sources;

	public function initialize() : void {
        parent::initialize();
        $this->path = $_SERVER['DOCUMENT_ROOT'] . '/../withoutcustom';
    	$this->loadModel('ImportBrochureRequestFiles');
    	$this->loadModel('Source');
    	$this->sources = $this->Source->getNonRetiredSources();
        $this->brHeader = ['deliverymethod', 'title', 'firstname', 'lastname', 'your-email', 'company', 'your-phone', 'showroom', 'address1', 'town', 'County', 'postcode', 'country', 'infoSource', 'signup', 'entryid'];
	}
	
	public function import() {
		$this->autoRender = false;
		$this->viewBuilder()->setLayout('ajax');

		echo "Importing brochure requests from " . $this->path;

		$files = $this->_getNewFiles('Request-Brochure-');

		foreach ($files as $file) {
			echo "<br/>Processing " . $file;
			
			// check if we've had this file before
			//if (!$this->_isFileNew($file)) {
			//	echo "<br/>Already processed " . $file;
			//	unlink($this->path . '/' . $file);
			//	continue;
			//}
			// get file content
			$fileContent = $this->_parseFile($file);
			
			$conn = ConnectionManager::get('default');
	    	$conn->begin();
	    	$processedEntryIds = [];

			foreach ($fileContent as $row) {
				echo '<br/>Entry ID = ' . $row['entryid'];
				if ($this->_isEntryIdNew($row['entryid'])) {
				$this->_uploadBrochureRequest($row, $file);
					array_push($processedEntryIds, $row['entryid']);
				} else {
					echo '<br/>Entry ' . $row['entryid'] . ' already processed';
				}
			}
			
			///$this->_markFileAsProcessed($file, $processedEntryIds);

    		$conn->commit();
    		echo '<br/>Brochure request import suceeded<br/>';
    		
    		// archive the file
			//rename($this->path . '/' . $file, $this->path . '/archive/' . $file);
		}
		echo "<br/><br/>All brochure requests imported";
	}
	
	private function _uploadBrochureRequest($row, $filename) {
		
		echo '<br/><br/>';
    	debug($row);
    	
    	if ($this->_isEmptyRow($row)) {
    		echo '<br>Empty row, so skipping';
    		return;
    	}
    	
    	$now = $this->_getCurrentDateTimeStr();
    	$deliveryTypeDetermined = $this->_containsStr('post', $row['deliverymethod']);
    	$deliveryTypeDetermined = $deliveryTypeDetermined || $this->_containsStr('Digital', $row['deliverymethod']);
    	$deliveryTypeDetermined = $deliveryTypeDetermined || $this->_containsStr('Download', $row['deliverymethod']);
    	$deliveryTypeDetermined = $deliveryTypeDetermined || $this->_containsStr('charger la version num', $row['deliverymethod']);
    	
    	if (!$deliveryTypeDetermined) {
    		if (empty($row['postcode']) && empty($row['address1']) && empty($row['town'])) {
    			// no address provided, so I think we can assume it's a digital download
    			$deliveryTypeDetermined = true;
    		}
    	}
    	
    	if (!$deliveryTypeDetermined) {
    		echo '<br>Unable to determine delivery method: ' . $row['deliverymethod'];
    		//die;
    	}
    	$isByPost = $this->_containsStr('post', $row['deliverymethod']);
    	
    	// ADDRESS
    	$email = $row['your-email'];
   		if (empty($email)) {
   			throw new Exception('No email address');
   		}
    	$postcode = $row['postcode'];
    	$country = $row['country'];
    	$company = $row['company'];
    	$acceptemail = $this->_containsStr('y', $row['signup']);
    	echo '<br/>email='.$email;
    	echo '<br/>postcode,country='.$postcode.' '.$country;
    	echo '<br/>company='.$company;
    	echo '<br/>isByPost='.($isByPost?'Y':'N');
    	echo '<br/>acceptemail='.($acceptemail?'Y':'N');
    	if ($isByPost) {
    		if (empty($country)) {
    			throw new Exception('Country not set for postal brochure request');
    		}
			$idLocation = $this->_getShowroomFromCountryAndPostcode($country, $postcode);
    	} else {
    		if (empty($row['showroom'])) {
    			echo '<br/>No showroom provided for digital download, so defaulting to Wigmore';
    			$idLocation = 3;
    		} else {
    		$idLocation = $this->_getLocationForWpKey($row['showroom']);
    		if ($idLocation == 0) {
    			throw new Exception('No location found for showroom ' . $row['showroom']);
    		}
    	}
    	}
    	$idRegion = $this->_getRegionOfLocation($idLocation);
    	echo '<br/>idLocation='.$idLocation.' '.$this->_getShowroomName($idLocation);
    	 
    	$addressRs = $this->Address->find('all', array('conditions'=> array('email_address' => $email)));
    	$addressRs = $addressRs->toArray();
    	$addressCode = 0;
    	$priceList = "";
    	if (!empty($company)) {
    		$priceList = "Trade";
    	} else {
    		$priceList = $this->_getPriceListForLocation($idLocation);
    	}
    	echo '<br/>priceList = ' . $priceList;
    	 
    	if (count($addressRs) == 0) {
    		echo '<br/>new address';
    		die;
    		$address = $this->Address->newEntity([]);
    		$isNewContact = true;
    	} else {
    		echo '<br/>existing address so updating';
    		$address = $addressRs[0];
    		$isNewContact = false;
    	}
    	//$address->street1 = $row['address1'];
    	//$address->town = $row['town'];
    	//$address->county = $row['County'];
    	//$address->country = $row['country'];
    	//$address->postcode = $row['postcode'];
    	//$address->EMAIL_ADDRESS = $email;
    	//$address->INITIAL_CONTACT = 'Website Brochure Request';
    	//$address->CHANNEL = 'Direct';
    	//$address->STATUS = 'Prospect';
    	//if ($isNewContact) $address->FIRST_CONTACT_DATE = $now;
    	//$address->SOURCE_SITE = 'SB';
    	//$address->OWNING_REGION = $idRegion;
    	$address->source = $this->_getSource($row);
    	if ($address->source == "Other") {
    		$address->source_other = $row['infoSource'];
    	}
    	//if (!empty($company)) {
    	//	$address->company = $company;
    	//	$address->CHANNEL = 'Trade';
    	//}
    	//$address->PRICE_LIST = $priceList;
    	debug($address);
    	$this->Address->save($address);
    	$addressCode = $address->CODE;
    	 
    	echo '<br/>address code=' . $addressCode;

		
	}

	private function _sendBrochureRequestNotification($row, $locationId, $isNew, $now, $acceptemail, $isByPost, $filename) {
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
    	$content .= "<br/>Submitted Date: " . $now;
    	$content .= "<br/>Marketing email opt in: " . ($acceptemail ? 'Y' : 'N');
    	$content .= "<br/>It has been assigned to showroom: " . $this->_getShowroomName($locationId);
    	$content .= "<br/>Brochure delivery method: " . ($isByPost ? 'Post' : 'Digital Download');
    	if (!$isNew) {
	    	$content .= "<br/>This is an existing contact, so existing contact details have been updated, including changing assigned showroom if different from original.";
    	}
    	if (!empty($filename)) {
	    	$content .= "<br/>This brochure request was loaded from " . $filename;
    	}
    	
    	$emailServices = new EmailServicesController;
    	$emailServices->generateBatchEmail($to, $cc, $from, $fromName, $subject, $content, 'html', null);
    }

    private function _isFileNew($filename) {
    	$rs = $this->ImportBrochureRequestFiles->find('all', ['conditions'=> ['filename' => $filename]]);
    	$isNew = true;
    	foreach ($rs as $row) {
    		$isNew = false;
    	}
    	return $isNew;
    }

    private function _isEntryIdNew($id) {
    	$term = ',' . $id . ',';
    	$rs = $this->ImportBrochureRequestFiles->find('all', ['conditions'=> ['ENTRYIDS like' => $term]]);
    	$isNew = true;
    	foreach ($rs as $row) {
    		$isNew = false;
    	}
    	return $isNew;
    }
    
    private function _markFileAsProcessed($filename, $processedEntryIds) {
    	$strEntryIds = ',';
    	foreach ($processedEntryIds as $id) {
    		$strEntryIds .= $id . ',';
    	}
    	$row = $this->ImportBrochureRequestFiles->newEntity([]);
    	$row->filename = $filename;
    	$row->ENTRYIDS = $strEntryIds;
    	$this->ImportBrochureRequestFiles->save($row);
    }

	protected function _getHeader() {
		return $this->brHeader;
	}
	
	protected function _getSource($row) {
		$source = $row['infoSource'];
		if (!empty($source) && !in_array($source, $this->sources)) {
			$source = "Other";
		}
		return $source;
	}
}
?>