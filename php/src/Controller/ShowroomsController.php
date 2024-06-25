<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class ShowroomsController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
				
		$showrooms = TableRegistry::get('Location');
		
		$activeshowrooms = $showrooms->getActiveShowrooms();
		//debug($activeshowrooms);
		//die;
		$this->set('activeshowrooms', $activeshowrooms);


	}
	
	public function edit()
    {
    	if (!$this->request->is('post')) {
			$this->Flash->error("Invalid call to edit");
			$this->redirect(array('controller' => 'Showrooms', 'action' => 'index'));
			return;
    	}
    	
    	$this->viewBuilder()->setLayout('savoir');
    	
    	//debug($this->request->getData());
		//die;
		$formData = $this->request->getData();
		$locationTable = TableRegistry::get('Location');
		
		if (!empty($formData['submit1'])) {
			// get the row
			$idlocation = $formData['showroom'];
			$row = $locationTable->getShowroom($idlocation);
			if (count($row) == 0) {
				$this->Flash->error("Failed to retrieve data for idlocation=" . $idlocation . ". Maybe the SHOWROOMDATA isn't set up?");
				$this->redirect(array('controller' => 'Showrooms', 'action' => 'index'));
				return;
			}
			$this->set('row', $row[0]);
		} else {
			// save the row
			//debug($formData);
			//die;
			$idlocation = $formData['idlocation'];
			$location = $locationTable->get($idlocation);
			$location->add1 = trim($formData['add1']);
			$location->add2 = trim($formData['add2']);
			$location->add3 = trim($formData['add3']);
			$location->town = trim($formData['town']);
			$location->countystate = trim($formData['county']);
			$location->postcode = trim($formData['postcode']);
			$location->tel = trim($formData['tel']);
			$location->fax = trim($formData['fax']);
			$location->email = trim($formData['email']);
			$location->SavoirOwned = trim($formData['savoirowned']);
			$locationTable->save($location);
			$showroomdata = TableRegistry::get('Showroom');
			$showroom = $showroomdata->find()->where(['ShowroomLocationID =' => $idlocation])->first();
			//debug ($showroom);
			//die;
			$showroom->SageRef = trim($formData['sageref']);
			$showroom->BankAcName = trim($formData['bankacname']);
			$showroom->BankAcNo = trim($formData['bankacno']);
			$showroom->BankRoutingNo = trim($formData['bankroutingno']);
			$showroom->BankSortCode = trim($formData['banksortcode']);
			$showroom->BankName = trim($formData['bankname']);
			$showroom->BankAddress = trim($formData['bankaddress']);
			$showroom->IBAN = trim($formData['iban']);
			$showroom->TermsEnabled = trim($formData['termsvalid']);
			$showroom->SWIFT = trim($formData['swift']);
			$showroom->InvoiceNote1 = trim($formData['invoicenote1']);
			$showroom->InvoiceNote2 = trim($formData['invoicenote2']);
			$showroom->InvoiceNote3 = trim($formData['invoicenote3']);
			$showroom->InvoiceNote4 = trim($formData['invoicenote4']);
			$showroom->InvoiceNote5 = trim($formData['invoicenote5']);
			$showroom->InvoiceNote6 = trim($formData['invoicenote6']);
			$showroom->InvoiceCoName = trim($formData['invoiceconame']);
			$showroom->InvoiceAdd1 = trim($formData['invoiceadd1']);
			$showroom->InvoiceAdd2 = trim($formData['invoiceadd2']);
			$showroom->InvoiceAdd3 = trim($formData['invoiceadd3']);
			$showroom->InvoiceTown = trim($formData['invoicetown']);
			$showroom->InvoiceCountry = trim($formData['invoicecountry']);
			$showroom->InvoicePostcode = trim($formData['invoicepostcode']);
			$showroomdata->save($showroom);
			$this->Flash->success("Showroom amended successfully");
			$this->redirect(array('controller' => 'Showrooms', 'action' => 'index'));
		}
    }
    
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR");
	}

}

?>