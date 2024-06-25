<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class OutstandingBrochureRequestsController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		set_time_limit(120);
		$this->loadModel('Communication');
		$this->loadModel('Correspondence');
    }
	
    public function index() {
		$this->viewBuilder()->setLayout('savoirdatatables');
		
		$contactTable = TableRegistry::get('Contact');
		$brochurerequests = $contactTable->getOutstandingRequests($this->SavoirSecurity->isSuperuser(), $this->getCurrentUserRegionId(), $this->getCurrentUserLocationId());
		
		//debug($brochurerequests);
		//die();
		
		$contactDates = [];
		$brochureRequestTypes = [];
		foreach ($brochurerequests as $row) {
			$contactDates[$row['CONTACT_NO']] = UtilityComponent::mysqlToDisplayStrDate2($row['FIRST_CONTACT_DATE']);
			$brochureRequestTypes[$row['CONTACT_NO']] = 'Postal';
			$query2 = $this->Communication->find()->where(['CODE' => $row['CODE'], 'Type like' => '%brochure%']) -> order (['Date' => 'DESC'])->toArray();
			if (count($query2)>0) {
					if (!is_null($query2[0]['Type']) && !empty($query2[0]['Type']) && $query2[0]['Type'] =='Digital Brochure sent by email') {
						$contactDates[$row['CONTACT_NO']] = date_format($query2[0]['Date'],"d/m/Y");
						$brochureRequestTypes[$row['CONTACT_NO']] = 'Digital';
				}
			}
			//echo '<br>' . $row['CONTACT_NO'];
		}
		//debug($brochureRequestTypes);
		//debug($contactDates);
		//die;
		
		$this->set('brochurerequests', $brochurerequests);
		$this->set('contactDates', $contactDates);
		$this->set('brochureRequestTypes', $brochureRequestTypes);
	}
	
	public function print() {
		if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'OutstandingBrochureRequests', 'action' => 'index'));
			return;
    	}
		$this->viewBuilder()->setLayout('print');
    	
    	//debug($this->request->getData());
		$formData = $this->request->getData();
		$submit1='';
		if (isset($formData['submit1'])) {
		$submit1 = 'y';
		}
		
		$this->set('submit1', $submit1);
		$contactTable = TableRegistry::get('Contact');
		$addressTable = TableRegistry::get('Address');
		$corresid=1;
		$greeting='';
		$correspondence='';

		if (isset($formData['corresid2']) && $formData['corresid2'] != 'n') {
			$corresQuery = $this->Correspondence->find()->where(['correspondenceid =' => $formData['corresid2']])->toArray();
		} else {
			$corresQuery = $this->Correspondence->find()->where(['correspondencename like' => 'Brochure Request', 'owning_location' => $this->getCurrentUserLocationId()])->toArray();
		}
		if (count($corresQuery) > 0) {
			$corresid = $corresQuery[0]['correspondenceid'];
			$greeting = $corresQuery[0]['greeting'];
			$correspondence = $corresQuery[0]['correspondence'];
		} 
		if (count($corresQuery) == 0) {
			$corresQuery = $this->Correspondence->find()->where(['correspondencename like' => 'Brochure Request', 'owning_region' => $this->getCurrentUserRegionId()])->toArray();	
			if (count($corresQuery) > 0) {
			$corresid = $corresQuery[0]['correspondenceid'];
			$greeting = $corresQuery[0]['greeting'];
			$correspondence = $corresQuery[0]['correspondence'];
			} else {
				$corresQuery = $this->Correspondence->find()->where(['correspondenceid ' => '1'])->toArray();
				$corresid = $corresQuery[0]['correspondenceid'];
				$greeting = $corresQuery[0]['greeting'];
				$correspondence = $corresQuery[0]['correspondence'];
			}
		}
		$this->set('greeting', $greeting);
		$this->set('correspondence', $correspondence);
		
		$contactArray = [];
		$addressArray = [];
	
		if (!empty($formData['submit1'])) {
		
			foreach ($formData as $key=>$val) {
				if (substr($key,0,3)==='XX_') {
					$contactno=substr($key,3);
					$contactdata = $contactTable->get($contactno);
					$addressdata = $addressTable->get($contactdata->CODE);
					array_push($contactArray,$contactdata);
					array_push($addressArray,$addressdata);
				}
			}
		}
		
		$this->set('contactArray', $contactArray);
		$this->set('addressArray', $addressArray);
		$numContacts = sizeof($contactArray);
		$this->set('numContacts', $numContacts);		
	}
	
	public function printlabel1() {
		if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'OutstandingBrochureRequests', 'action' => 'index'));
			return;
    	}
		$this->viewBuilder()->setLayout('print');
    	
    	//debug($this->request->getData());
		$formData = $this->request->getData();
		$submit2='';
		if (isset($formData['submit2'])) {
		$submit2 = 'y';
		}
		$this->set('submit2', $submit2);
		$contactTable = TableRegistry::get('Contact');
		$addressTable = TableRegistry::get('Address');
		
		$contactArray = [];
		$addressArray = [];
	
		if (!empty($formData['submit2'])) {
			
			foreach ($formData as $key=>$val) {
				if (substr($key,0,3)==='XX_') {
					$contactno=substr($key,3);
					$contactdata = $contactTable->get($contactno);
					$addressdata = $addressTable->get($contactdata->CODE);
					array_push($contactArray,$contactdata);
					array_push($addressArray,$addressdata);
				}
			}
		}
		
		$this->set('contactArray', $contactArray);
		$this->set('addressArray', $addressArray);
		$numContacts = sizeof($contactArray);
		$this->set('numContacts', $numContacts);		
	}
	
	public function printlabel3x7() {
		if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'OutstandingBrochureRequests', 'action' => 'index'));
			return;
    	}
		$this->viewBuilder()->setLayout('print');
    	
    	//debug($this->request->getData());
		$formData = $this->request->getData();
		$submit5='';
		if (isset($formData['submit5'])) {
		$submit5 = 'y';
		}
		$this->set('submit5', $submit5);
		$contactTable = TableRegistry::get('Contact');
		$addressTable = TableRegistry::get('Address');
		
		$contactArray = [];
		$addressArray = [];
	
		if (!empty($formData['submit5'])) {
			
			foreach ($formData as $key=>$val) {
				if (substr($key,0,3)==='XX_') {
					$contactno=substr($key,3);
					$contactdata = $contactTable->get($contactno);
					$addressdata = $addressTable->get($contactdata->CODE);
					array_push($contactArray,$contactdata);
					array_push($addressArray,$addressdata);
				}
			}
		}
		
		$this->set('contactArray', $contactArray);
		$this->set('addressArray', $addressArray);
		$numContacts = sizeof($contactArray);
		$this->set('numContacts', $numContacts);		
	}
	
	public function brochureRequestSent() {
		if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'OutstandingBrochureRequests', 'action' => 'index'));
			return;
    	}    	
		$formData = $this->request->getData();
		$contactTable = TableRegistry::get('Contact');
		
		if (!empty($formData['submit3'])) {
			
			foreach ($formData as $key=>$val) {
				if (substr($key,0,3)==='XX_') {
					$contactno=substr($key,3);
					$contactdata = $contactTable->get($contactno);
					$contactdata->BrochureRequestSent = 'y';
					$contactTable->save($contactdata);
					$customername='';
					if ($contactdata['title'] != '') {
						$customername=$contactdata['title'] .' ';
						}
					if ($contactdata['first'] != '') {
						$customername.=$contactdata['first'] .' ';
						}
					if ($contactdata['surname'] != '') {
						$customername.=$contactdata['surname'];
						}
					$communicationTable = TableRegistry::get('Communication');
					$communication = $communicationTable->newEntity([]);
					$communication->CODE = $contactdata['CODE'];
					$communication->Date = new DateTime('now');
					$reminderdate = new DateTime('now');
					$reminderdate->modify('+14 day');
					$communication->Next = $reminderdate;
					$communication->Type = 'Letter';
					$communication->notes = 'Brochure Request Follow-Up';
					$communication->commstatus = 'To Do';
					$communication->staff =  $this->SavoirSecurity->getCurrentUserName();
					$communication->OWNING_REGION =  $this->getCurrentUserRegionId();
					$communication->SOURCE_SITE = 'SB';
					$communication->person = $customername;
					$communicationTable->save($communication);
				}
			}
		}
		$this->Flash->success("Brochure Requests removed and followup alerts created");
		$this->redirect(array('controller' => 'OutstandingBrochureRequests', 'action' => 'index'));
	
	}
	
	public function brochureRequestupdate() {
		if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'OutstandingBrochureRequests', 'action' => 'index'));
			return;
    	}    	
		$formData = $this->request->getData();
		$contactTable = TableRegistry::get('Contact');
		
		if (!empty($formData['submit9'])) {
			
			foreach ($formData as $key=>$val) {
				if (substr($key,0,3)==='XX_') {
					$contactno=substr($key,3);
					$contactdata = $contactTable->get($contactno);
					$contactdata->BrochureRequestSent = 'y';
					$contactTable->save($contactdata);
					$customername='';
					if ($contactdata['title'] != '') {
						$customername=$contactdata['title'] .' ';
						}
					if ($contactdata['first'] != '') {
						$customername.=$contactdata['first'] .' ';
						}
					if ($contactdata['surname'] != '') {
						$customername.=$contactdata['surname'];
						}
					$communicationTable = TableRegistry::get('Communication');
					$communication = $communicationTable->newEntity([]);
					$communication->CODE = $contactdata['CODE'];
					$communication->Date = new DateTime('now');
					$reminderdate = new DateTime('now');
					$month=$reminderdate->format('F');
					$year=$reminderdate->format('Y');
					$reminderdate=$month ." ". $year;
					$communication->Next = Null;
					$communication->Type = 'Online admin brochure request removed';
					$communication->notes = 'Request cleared in '.$reminderdate.' to remove old requests';
					$communication->commstatus = 'Completed';
					$communication->staff =  $this->SavoirSecurity->getCurrentUserName();
					$communication->OWNING_REGION =  $this->getCurrentUserRegionId();
					$communication->SOURCE_SITE = 'SB';
					$communication->person = $customername;
					$communicationTable->save($communication);
				}
			}
		}
		$this->Flash->success("Old Brochure Requests removed by Admin");
		$this->redirect(array('controller' => 'OutstandingBrochureRequests', 'action' => 'index'));
	
	}
	
	
	
	
	
	
	
	public function delete() {
		if (!$this->request->is('post')) {
			$this->Flash->success("Invalid call to edit");
			$this->redirect(array('controller' => 'OutstandingBrochureRequests', 'action' => 'index'));
			return;
    	}    	
		$formData = $this->request->getData();
		$contactTable = TableRegistry::get('Contact');
		
		if (!empty($formData['submit4'])) {
			
			foreach ($formData as $key=>$val) {
				if (substr($key,0,3)==='XX_') {
					$contactno=substr($key,3);
					$contactdata = $contactTable->get($contactno);
					$contactdata->retire = 'y';
					$contactTable->save($contactdata);
					
				}
			}
		}
		$this->Flash->success("Spam brochure requests deleted");
		$this->redirect(array('controller' => 'OutstandingBrochureRequests', 'action' => 'index'));
	
	}
	
	public function export() {
		$formData = $this->request->getData();
		$contactTable = TableRegistry::get('Contact');
		$addressTable = TableRegistry::get('Address');
		if (!empty($formData['submit6'])) {
			$data = [];
			foreach ($formData as $key=>$val) {
				if (substr($key,0,3)==='XX_') {
					$contactno=substr($key,3);
					$contactdata = $contactTable->get($contactno);
					$addressdata = $addressTable->get($contactdata->CODE);
		
					$datarow = [];
					$datarow['Title'] = $contactdata['title'];
					$datarow['First Name'] = $contactdata['first'];
					$datarow['Surname'] = $contactdata['surname'];
					$datarow['Company'] = $addressdata['company'];
					$datarow['Position'] = $contactdata['position'];
					$datarow['Street1'] = $addressdata['street1'];
					$datarow['Street2'] = $addressdata['street2'];
					$datarow['Street3'] = $addressdata['street3'];
					$datarow['Town'] = $addressdata['town'];
					$datarow['County'] = $addressdata['county'];
					$datarow['Postcode'] = $addressdata['postcode'];
					$datarow['Country'] = $addressdata['country'];
					$datarow['Tel'] = $addressdata['tel'];
					$datarow['Fax'] = $addressdata['fax'];
					$datarow['Email'] = $addressdata['EMAIL_ADDRESS'];
					$query3 = $this->Communication->find()->where(['CODE' => $addressdata['CODE'], 'Type like' => '%brochure%']) -> order (['Date' => 'DESC'])->toArray();					
					if (count($query3)>0) {
							$datarow['Date of Request'] = $query3[0]['Date'];
					} else {
						$datarow['Date of Request'] = $addressdata['FIRST_CONTACT_DATE'];
					}
					array_push($data, $datarow);
				}
			}
		}

		$_header = ['Title', 'First Name', 'Surname', 'Company', 'Position', 'Street1' ,'Street2' ,'Street3' ,'Town', 'County', 'Postcode', 'Country', 'Tel', 'Fax', 'Email', 'Date of Request'];

		$this->setResponse($this->getResponse()->withDownload('OutstandingBrochureRequests.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $_header
    	]);
	}
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR","SALES","REGIONAL_ADMINISTRATOR"];
	}
    
}

?>
