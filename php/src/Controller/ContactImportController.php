<?php
namespace App\Controller;
use App\Controller\EmailServicesController;
use Cake\ORM\TableRegistry;
use Cake\Datasource\ConnectionManager;
use Cake\I18n\Time;
use \Exception;
use \DateTime;

class ContactImportController extends AbstractImportController {

	private $oHeader;
	private $emailServices;

	public function initialize() : void {
        parent::initialize();
		$this->oHeader = ['first_name','last_name','company','email_address','country','accepts_email','status'];
	}
	
	public function import() {
		$this->autoRender = false;
		$this->viewBuilder()->setLayout('ajax');

		echo "Importing orders from " . $this->path;
		
		$files = $this->_getNewFiles('contact-import-');

		foreach ($files as $file) {
			echo "<br/>Processing " . $file;
			
			// get file content
			$fileContent = $this->_parseFile($file);
			//debug($fileContent);
			//die;
			
			$conn = ConnectionManager::get('default');
	    	$conn->begin();

			foreach ($fileContent as $row) {
				$this->_uploadContact($row, $file);
			}
			
    		$conn->commit();
    		echo '<br/>Contact import suceeded<br/>';
    		
		}
		echo "<br/><br/>All contacts imported";
	}
	
	private function _uploadContact($row, $filename) {
		
		echo '<br/><br/>row: ';
    	var_export($row);
    	
    	if ($this->_isEmptyRow($row)) {
    		echo '<br>Empty row, so skipping';
    		return;
    	}
    	
    	$now = $this->_getCurrentDateTimeStr();
    	
    	$idLocation = 37; // NY downtown 2
    	$idRegion = $this->_getRegionOfLocation($idLocation);
    	
    	$addressCode = $this->_addUpdateAddress($row, $idLocation, $idRegion, $now);
    	$contactNo = $this->_addUpdateContact($row, $idLocation, $idRegion, $addressCode, $now);
	}
	
	private function _addUpdateAddress($row, $idLocation, $idRegion, $now) {
    	$addressRs = $this->Address->find('all', array('conditions'=> array('email_address' => $row['email_address'])))->toArray();
		$addressCode = 0;
    	$priceList = "Net Retail";
    	$company = $row['company'];
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
    	$address->country = $row['country'];
    	$address->EMAIL_ADDRESS = $row['email_address'];
    	if ($isNewContact) {
    		$address->FIRST_CONTACT_DATE = $now;
	    	$address->INITIAL_CONTACT = 'MailChimp';
	    	$address->CHANNEL = 'Direct';
    		$address->source = 'Marketing';
    	}
	    $address->STATUS = $row['status'];
    	$address->OWNING_REGION = $idRegion;
    	$address->SOURCE_SITE = 'SB';
    	if (!empty($company)) {
    		$address->company = $company;
    		$address->CHANNEL = 'Trade';
    	}
    	$address->PRICE_LIST = $priceList;
    	$this->Address->save($address);
    	$addressCode = $address->CODE;
    	 
    	echo '<br/>address code=' . $addressCode;
		return $addressCode;
	}
	
	private function _addUpdateContact($row, $idLocation, $idRegion, $addressCode, $now) {
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
    	// ['first_name','last_name','company','email_address','country','accepts_email','status'];
    	$contact->first = $row['first_name'];
    	$contact->surname = $row['last_name'];
    	if ($newContact) {
    		$contact->dateadded = $now;
    	}
    	$contact->acceptemail = 'n';
    	if ($this->startsWith($row['accepts_email'], 'Y') || $this->startsWith($row['accepts_email'], 'y')) {
	    	$contact->acceptemail = 'y';
    	}
    	$contact->dateupdated = $now;
    	$contact->retire = 'n';
    	$contact->SOURCE_SITE = 'SB';
    	$contact->idlocation = $idLocation;
    	$contact->OWNING_REGION = $idRegion;
    	$this->Contact->save($contact);
    	$contactNo = $contact->CONTACT_NO;
    	 
    	echo '<br/>contactid=' . $contactNo;
    	return $contactNo;
	}
	
	protected function _getHeader() {
		return $this->oHeader;
	}
}
?>