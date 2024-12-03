<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class AdvancedSearchController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
		$this->loadModel('Address');
		$this->loadModel('Channel');
		$this->loadModel('Contacttype');
		$this->loadModel('Purchase');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
		$channellist=$this->Channel->getChannelListAll();
		$contacttype=$this->Contacttype->getContactTypeListAll();
		$showrooms = TableRegistry::get('Location');
		$showroom=$this->getCurrentUserLocationId();
		if ($this->isSuperuser()) {
			$activeshowrooms = $showrooms->getActiveShowrooms();
			$showroom='all';
		} else if ($this->_userHasRole("SAVOIRSTAFF")){
			$activeshowrooms = $showrooms->getActiveShowrooms($this->getCurrentUserRegionId());
		} else {
			$activeshowrooms = $showrooms->getActiveShowrooms('', $this->getCurrentUserLocationId());
		} 
		
		$this->set('channellist', $channellist);
		$this->set('contacttype', $contacttype);
		$this->set('activeshowrooms', $activeshowrooms);
	}
	
	public function results() {
		$this->viewBuilder()->setLayout('savoir');
		$customers = TableRegistry::get('Contact');
		$correspondence = TableRegistry::get('Correspondence');
		$showroom=$this->getCurrentUserLocationId();
		$filtertype='';
		$filterkeyword='';
		$contacttype='';
		$location='';
		$postcode='';
		$dpostcode='';
		$email='';
		$surname='';
		$formData = $this->request->getData();
		$surname=$formData['surname'];
		if (isset($formData['contacttype'])) {
			$contacttype=$formData['contacttype'];
		}
		if (isset($formData['location'])) {
			$location=$formData['location'];
		}
		if (isset($formData['channel'])) {
			$channel=$formData['channel'];
		}
		if (isset($formData['postcode'])) {
			$postcode=$formData['postcode'];
		}
		if (isset($formData['dpostcode'])) {
			$dpostcode=$formData['dpostcode'];
		}
		if (isset($formData['email'])) {
			$email=$formData['email'];
		}
		$company=$formData['company'];
		$cref=$formData['cref'];
		$orderno=$formData['orderno'];
		if (isset($formData['filtertype'])) {
		$filtertype=$formData['filtertype'];
		}
		if (isset($formData['filterkeyword'])) {
		$filterkeyword=$formData['filterkeyword'];
		}
		$liveorders='';
		$completedorders='';
		$customerssql='';
		
		
		if ($orderno != '') {
			$pn = $this->Purchase->find()->where(['ORDER_NUMBER =' => $orderno])->first()['PURCHASE_No'];
			
			return $this->redirect($_SERVER["HTTP_ORIGIN"].'/edit-purchase.asp?order='. $pn);
		}
		$letter=$correspondence->selectCorrespondenceItem($this->SavoirSecurity->isSuperuser(),$this->getCurrentUserRegionId(),$this->getCurrentUserLocationId());
        $this->set('letter', $letter);
		$liveorders=$customers->getCustomers($this, $surname, $cref, $postcode, $dpostcode, $email, $company, $channel, $contacttype, 'current', $filtertype, $filterkeyword, $this);
		$completedorders=$customers->getCustomers($this, $surname, $cref, $postcode, $dpostcode, $email, $company, $channel, $contacttype, 'completed', $filtertype, $filterkeyword, $this);
		$noorders=$customers->getCustomers($this, $surname, $cref, $postcode, $dpostcode, $email, $company, $channel, $contacttype, 'none', $filtertype, $filterkeyword, $this);
		//debug($noorders);
		//die;
		$this->set('surname', $surname);
		$this->set('contacttype', $contacttype);
		$this->set('location', $location);
		$this->set('channel', $channel);
		$this->set('company', $company);
		$this->set('postcode', $postcode);
		$this->set('email', $email);
		$this->set('cref', $cref);
		$this->set('orderno', $orderno);
		$this->set('filtertype', $filtertype);
		$this->set('filterkeyword', $filterkeyword);
		$this->set('liveorders', $liveorders);
		$this->set('completedorders', $completedorders);
		$this->set('noorders', $noorders);
		
	}
	
	public function getorderdetails() {
		
    	$this->autoRender = false;
        $this->viewBuilder()->setLayout('ajax');
        $customers = TableRegistry::get('Contact');
        
        $params = $this->request->getParam('?');
        $contactno = $params['contactno'];
        $current = $params['current'];
        $cref = $params['cref'];
        $filtertype = $params['filtertype'];
        $filterval = $params['filterval'];
        $customerorderdetails='';
        
        
        $customerorderdetails=$customers->getSearchOrderDetails($contactno, $current, $cref, $filtertype, $filterval);
        
        $ts = $params['ts'];
		$html='';
    	
    	foreach ($customerorderdetails as $row) {
    	$orderdetails='';
    	$orderdetails=$customers->getorderDesc($row['PURCHASE_No']);
    	$html = "<table border='0' cellpadding='3' width='95%'><tr><td><b>Order No</b></td><td><b>Order Date</b></td><td><b>Customer Ref.</b></td><td><b>Archive Information</b></td><td><b>Notes</b></td><td><b>Order Description</b></td></tr>";
		$html .= "<tr><td valign='top'><a href='/edit-purchase.asp?order=".$row['PURCHASE_No']."'>" .$row['ORDER_NUMBER']. "</a></td>";
		$html .= "<td valign='top'>".$row['ORDER_DATE']."</td>";
		$html .= "<td valign='top'>".$row['customerreference']."</td>";
		$html .= "<td valign='top'>".$row['BED']."</td>";
		$html .= "<td valign='top'>".$row['NOTES']."</td>";
		$html .= "<td valign='top'>".$orderdetails."</td></tr>";
		
		$html .= "</table>";
		}
    	$this->response = $this->response->withStringBody($html);
    	//echo $html;
   	}
	
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR", "SALES");
	}

}

?>