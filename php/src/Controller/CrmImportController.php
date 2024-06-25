<?php
namespace App\Controller;
use App\Controller\EmailServicesController;
use Cake\ORM\TableRegistry;
use Cake\Datasource\ConnectionManager;
use Cake\I18n\Time;
use \Exception;

class CrmImportController extends AbstractImportController {

	private $brHeader;
	private $sources;

	public function initialize() : void {
        parent::initialize();
        $this->path = $_SERVER['DOCUMENT_ROOT'] . '/../without';
        $this->brHeader = ['UPDATED?','contact_no','title','first','surname','company','street1','street2','street3','town','county','postcode','country','tel','fax','Channel','Price_list','source_site','acceptemail','acceptpost','email_address','status','customertype'];
        $this->loadModel('CustomerType');
	}
	
	public function import() {
		$this->autoRender = false;
		$this->viewBuilder()->setLayout('ajax');

		echo "Importing CRM data from " . $this->path;

		$files = $this->_getNewFiles('SavoirAdminCRM');

		foreach ($files as $file) {
			echo "<br/>Processing " . $file . '<br/>';
			
			// get file content
			$fileContent = $this->_parseFile($file);
			
			$conn = ConnectionManager::get('default');
	    	$conn->begin();
	    	$processedEntryIds = [];

			foreach ($fileContent as $row) {
				if ($row['UPDATED?'] == 'y') {
					$contactNo = $row['contact_no'];
					
					$contact = $this->Contact->get($contactNo);
					if (!$this->_updateContact($contact, $row)) {
						break;
					}

					$this->Contact->save($contact);
					
					$address = $this->Address->get($contact->CODE);
					if (!$this->_updateAddress($address, $row)) {
						break;
					}
					$this->Address->save($address);					
					
					echo '<br/>contact_no ' . $row['contact_no'] . ' processed successfully';
				} else {
					echo '<br/>contact_no ' . $row['contact_no'] . ' not marked for update';
				}
			}
			
    		$conn->commit();
    		echo '<br/><br/>' . $file . ' import suceeded<br/>';
    		
		}
		echo "<br/>All files processed";
	}
	
	private function _updateContact($contact, $row) {
		if ($row['acceptemail'] == 'y' || $row['acceptemail'] == 'Y') {
			$contact->acceptemail = 'y';
		} else {
			$contact->acceptemail = 'n';
		}
		if ($row['acceptpost'] == 'y' || $row['acceptpost'] == 'Y') {
			$contact->acceptpost = 'y';
		} else {
			$contact->acceptpost = 'n';
		}
		$contact->customerType = $this->_getCustomerTypeId($row['customertype']);
		
		if ($row['source_site'] == 'SB') {
			$contact->SOURCE_SITE = 'SB';
		} else if ($row['source_site'] == 'SH') {
			$contact->SOURCE_SITE = 'SH';
		}
		
		if ($row['surname'] != $contact->surname) {
			echo '<br>surname changed: "' . $contact->surname . '" has changed to "' . $row['surname'] . '"';
			return false;
		}

		$this->_updateIfSet($contact, $row, 'surname', 'surname');
		$this->_updateIfSet($contact, $row, 'title', 'title');
		$this->_updateIfSet($contact, $row, 'first', 'first');
		
		return true;
	}
	
	private function _updateAddress($address, $row) {

		if (!empty($row['Channel'])) {
			$address->CHANNEL = $row['Channel'];
		}
		$this->_updateIfSet($address, $row, 'company', 'company');
		$this->_updateIfSet($address, $row, 'country', 'country');
		$this->_updateIfSet($address, $row, 'county', 'county');
		
		if ($row['email_address'] != $address->EMAIL_ADDRESS) {
			echo '<br>email_address changed: "' . $address->EMAIL_ADDRESS . '" has changed to "' . $row['email_address'] . '"';
			return false;
		}
		
		if (!empty($row['email_address'])) {
			$address->EMAIL_ADDRESS = $row['email_address'];
		}
		$this->_updateIfSet($address, $row, 'fax', 'fax');
		$this->_updateIfSet($address, $row, 'postcode', 'postcode');
		if (!empty($row['Price_list'])) {
			$address->PRICE_LIST = $row['Price_list'];
		}
		if ($row['source_site'] == 'SB') {
			$address->SOURCE_SITE = 'SB';
		} else if ($row['source_site'] == 'SH') {
			$address->SOURCE_SITE = 'SH';
		}
		if (!empty($row['status'])) {
			$address->STATUS = $row['status'];
		}
		$this->_updateIfSet($address, $row, 'street1', 'street1');
		$this->_updateIfSet($address, $row, 'street2', 'street2');
		$this->_updateIfSet($address, $row, 'street3', 'street3');
		$this->_updateIfSet($address, $row, 'tel', 'tel');
		$this->_updateIfSet($address, $row, 'town', 'town');
		
		return true;
	}
	
	private function _updateIfSet($obj, $row, $srccol, $trgcol) {
		if (!empty($row[$srccol])) {
			$obj[$trgcol] = $row[$srccol];
		} else {
			$obj[$trgcol] = null;
		}
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
	

	protected function _getHeader() {
		return $this->brHeader;
	}
}
?>