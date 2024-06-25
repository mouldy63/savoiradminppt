<?php
namespace App\Controller;
use App\Controller\EmailServicesController;
use Cake\ORM\TableRegistry;
use Cake\Datasource\ConnectionManager;
use Cake\I18n\Time;
use \Exception;

class BrochureRequestImportController extends AbstractImportController {

	private $brHeader;
	private $sources;

	public function initialize() : void {
        parent::initialize();
    	$this->loadModel('ImportBrochureRequestFiles');
    	$this->loadModel('Source');
    	$this->sources = $this->Source->getNonRetiredSources();
    	$this->brHeader = [];
    	$this->brHeader['deliverymethod'] = ['Delivery method'];
    	$this->brHeader['title'] = ['Title','Anrede'];
    	$this->brHeader['firstname'] = ['First Name','Vorname'];
    	$this->brHeader['lastname'] = ['Last Name','Nachname'];
    	$this->brHeader['your-email'] = ['Email', 'E-Mail'];
    	$this->brHeader['company'] = ['Company','Firma'];
    	$this->brHeader['interior-designer'] = ['I am an Interior Designer','I am an Interior Designer (Checked)'];
    	$this->brHeader['your-phone'] = ['Phone Number','Telefonnummer'];
    	$this->brHeader['showroom'] = ['Choose your Showroom', 'Select Showroom', 'Showroom auswählen'];
    	$this->brHeader['address1'] = ['Street address'];
    	$this->brHeader['town'] = ['Town/City'];
    	$this->brHeader['County'] = ['County/State'];
    	$this->brHeader['postcode'] = ['Post code/Zip code','Post/Zip code'];
    	$this->brHeader['country'] = ['Country', 'Land'];
    	$this->brHeader['infoSource'] = ['How did you hear about us?', 'Wie haben Sie von uns erfahren?'];
    	$this->brHeader['signup'] = ['Sign up for Savoir news', 'Sign up for Savoir news (Sign up for Savoir news)', 'Abonnieren Sie den Newsletter von Savoir'];
    	$this->brHeader['entryid'] = ['Entry Id', 'Eintrags-ID'];
    	$this->brHeader['entrydate'] = ['Entry Date', 'Datum des Eintrags'];
    	$this->path = $_SERVER['DOCUMENT_ROOT'] . '/../without';
	}
	
	public function import() {
		$this->autoRender = false;
		$this->viewBuilder()->setLayout('ajax');

		echo "Importing brochure requests from " . $this->path;

		$files = $this->_getNewFiles('Request-Brochure-');

		foreach ($files as $file) {
			echo "<br/>Processing " . $file;
			
			// check if we've had this file before
			if (!$this->_isFileNew($file)) {
				echo "<br/>Already processed " . $file;
				unlink($this->path . '/' . $file);
				continue;
			}
			// get file content
			$fileContent = $this->parseBrochureFile($file);
			
			$conn = ConnectionManager::get('default');
	    	$conn->begin();
	    	$processedEntryIds = [];

			foreach ($fileContent as $row) {
            	if (!array_key_exists('entryid', $row)) {
            		// some files don't even have the entryId, so fake it
            		$row['entryid'] = random_int(100000, 999999);
            	}
				echo '<br/>Entry ID = ' . $row['entryid'];
				if (!array_key_exists("entryid", $row) || empty($row['entryid'])) {
					throw new Exception('No entry ID');
				}
				if ($this->_isEntryIdNew($row['entryid'])) {
					$this->_uploadBrochureRequest($row, $file);
					array_push($processedEntryIds, $row['entryid']);
				} else {
					echo '<br/>Entry ' . $row['entryid'] . ' already processed';
				}
			}
			
			$this->_markFileAsProcessed($file, $processedEntryIds);

    		$conn->commit();
    		echo '<br/>Brochure request import suceeded<br/>';
    		
    		// archive the file
			rename($this->path . '/' . $file, $this->path . '/archive/' . $file);
		}
		echo "<br/><br/>All brochure requests imported";
	}
	
	private function parseBrochureFile($file) {
	    $row = 1;
	    $content = [];
	    $header = $this->_getHeader();
	    $headerMapping = null;
	    $rowLen = null;
	    if (($handle = fopen($this->path . '/' . $file, "r")) !== FALSE) {
	        while (($data = fgetcsv($handle, 0, ",")) !== FALSE) {
	        	if ($row == 1) {
	                $rowLen = count($data);
	        		$headerMapping = $this->_getColumnMappings($data, $header);
	        	} else {
	                $r = [];
	                for ($c=0; $c < $rowLen; $c++) {
	                	if (array_key_exists($c, $headerMapping)) { // not all columns are used
		                	$r[$headerMapping[$c]] = $data[$c];
	                	}
	                }
	                array_push($content, $r);
	            }
	            $row++;
	        }
	        fclose($handle);
	    }
	    debug($headerMapping);
	    debug($content);
	    return $content;
	}
	
	private function _getColumnMappings($data, $header) {
		$rowLen = count($data);
		$headerMapping = [];
		for ($c=0; $c < $rowLen; $c++) {
			$foundColname = preg_replace('/[[:^print:]]/', '', str_replace('"', '', trim($data[$c])));
			if ($c == 0 && $foundColname == '') {
				$foundColname = 'Delivery method';
			}
			foreach($header as $colid => $colnames) {
    			foreach($colnames as $colname) {
    				if (strcasecmp($foundColname, $colname) === 0) {
    					$headerMapping[$c] = $colid;
    					break;
    				}
    			}
			}
		}
		return $headerMapping;
	}
	
	private function _debugString($str) {
		$str = preg_replace('/[[:^print:]]/', '', $str);
		echo '<br>' . $str . ':';
		foreach (str_split($str) as $char) {
		    echo ' ' . ord($char);
		}
	}
	
	private function _uploadBrochureRequest($row, $filename) {
		
		echo '<br/><br/>';
    	debug($row);
    	
    	if ($this->_isEmptyRow($row)) {
    		echo '<br>Empty row, so skipping';
    		return;
    	}
    	
    	$now = $this->_getCurrentDateTimeStr();
    	
    	// ADDRESS
    	$email = $row['your-email'];
   		if (empty($email)) {
   			throw new Exception('No email address');
   		}
    	$postcode = $row['postcode'];
    	$country = $row['country'];
    	$company = array_key_exists('company', $row) ? $row['company'] : '';
    	$isInteriorDesigner = array_key_exists("interior-designer", $row) && !empty($row['interior-designer']);
    	$acceptemail = 'y'; // see email from Daryl 26/1/2021
    	echo '<br/>email='.$email;
    	echo '<br/>postcode,country='.$postcode.' '.$country;
    	echo '<br/>company='.$company;
    	echo '<br/>acceptemail='.($acceptemail?'Y':'N');
    	echo '<br/>isInteriorDesigner='.$isInteriorDesigner;
		if (empty($row['showroom'])) {
			echo '<br/>No showroom provided for digital download, so defaulting to Wigmore';
			$idLocation = 3;
		} else {
			$idLocation = $this->_getLocationForWpKey($row['showroom']);
			if ($idLocation == 0) {
				throw new Exception('No location found for showroom ' . $row['showroom']);
			}
		}

    	$idRegion = $this->_getRegionOfLocation($idLocation);
    	echo '<br/>idLocation='.$idLocation.' '.$this->_getShowroomName($idLocation);
    	 
    	$addressRs = $this->Address->find('all', array('conditions'=> array('email_address' => $email)));
    	$addressRs = $addressRs->toArray();
    	$addressCode = 0;
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
    	$address->street1 = $row['address1'];
    	$address->town = $row['town'];
    	$address->county = $row['County'];
    	$address->country = $row['country'];
    	$address->postcode = $row['postcode'];
    	$address->EMAIL_ADDRESS = $email;
    	$address->INITIAL_CONTACT = 'Website Brochure Request';
    	$address->CHANNEL = 'Direct';
    	$address->STATUS = 'Prospect';
    	if ($isNewContact) $address->FIRST_CONTACT_DATE = $now;
    	$address->SOURCE_SITE = 'SB';
    	$address->OWNING_REGION = $idRegion;
    	$address->source = $this->_getSource($row);
    	if ($address->source == "Other") {
    		$address->source_other = substr($row['infoSource'], 0, 255);
    	}
    	if (!empty($company)) {
    		$address->company = $company;
    	}
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
    	$contact->title = $row['title'];
    	$contact->first = $row['firstname'];
    	$contact->surname = $row['lastname'];
    	$contact->acceptemail = ($acceptemail ? 'y' : 'n');
    	$contact->mobile = $row['your-phone'];
    	if ($newContact) $contact->dateadded = $now;
    	$contact->dateupdated = $now;
    	$contact->retire = 'n';
    	$contact->BrochureRequestSent = 'n';
    	$contact->SOURCE_SITE = 'SB';
    	$contact->idlocation = $idLocation;
    	$contact->OWNING_REGION = $idRegion;
    	$contact->customerType = $isInteriorDesigner ? 2 : 1;
    	$this->Contact->save($contact);
    	$contactNo = $contact->CONTACT_NO;
    	 
    	echo '<br/>contactid=' . $contactNo;

    	// COMMUNICATION
    	$communication = $this->Communication->newEntity([]);
    	$communication->CODE = $addressCode;
    	$communication->Date = $now;
		$communication->Type = 'Digital Brochure sent by email';
		$communication->actioned = 'n';
		$communication->person = $row['title'] . ' ' . $row['firstname'] . ' ' . $row['lastname'];
    	$communication->SOURCE_SITE = 'SB';
    	$communication->staff = 'Website Request';
    	$communication->OWNING_REGION = $idRegion;
    	$this->Communication->save($communication);
    	 
    	$this->_sendBrochureRequestNotification($row, $idLocation, $newContact, $now, $acceptemail, $filename);
    	echo '<br/>Communication id =' . $communication->Communication;
		
	}
	
	private function _sendBrochureRequestNotification($row, $locationId, $isNew, $now, $acceptemail, $filename) {
    	$to = "david@natalex.co.uk";
    	$cc = "";
    	$from = "info@savoirbeds.co.uk";
    	$fromName = "Savoir Admin";
		$subject = "New digital download brochure request imported from savoirbeds.co.uk";
		$content = "<h2>The details of the new digital download brochure request are as follows</h2>";
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
    	$content .= "<br/>Brochure delivery method: Digital Download";
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
    	$term = '%,' . $id . ',%';
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
		$source = array_key_exists('infoSource', $row) ? $row['infoSource'] : '';
		//debug($source);
		if (!empty($source) && !in_array($source, $this->sources)) {
			$source = 'Other';
		}
		//debug($source);
		return $source;
	}
}
?>
