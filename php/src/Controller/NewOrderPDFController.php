<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class NewOrderPDFController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
    	$this->loadModel('Purchase');
		$this->loadModel('Location');
		$this->loadModel('Contact');
		$this->loadModel('Address');

		
	}
	
	public function index() {
		$purchaseTable = TableRegistry::get('Purchase');
        $this->viewBuilder()->setOptions([
            'pdfConfig' => [
                'orientation' => 'portrait',
            ]
        ]);
		$docroot=$_SERVER['DOCUMENT_ROOT'];
        $this->set('docroot', $docroot);
        
        $params = $this->request->getParam('?');
        $pn = $params['pn'];
		
        $query = $this->Purchase->find()->where(['PURCHASE_No' => $pn]);
        $ordernumber = null;
		$orderdate = null;
		$salesusername = null;
		foreach ($query as $row) {
			$purchase = $row;
			
		}
		$salesusername = $purchase['salesusername'];
		$salesname = $purchaseTable->getSalesContact($salesusername);
		$orderdate = $purchase['ORDER_DATE']->i18nFormat('dd/MM/yyyy');
		$idlocation = $purchase['idlocation'];
		$contact = $purchase['contact_no'];
		$salesuseremail = $purchaseTable->getSalesEmail($salesusername);
		$code = $purchase['CODE'];
		
		$query = $this->Location->find()->where(['idlocation' => $idlocation]);
		foreach ($query as $row) {
			$showroomaddress = '';
			$showroomtel='';
			if ($row['add1'] != '') {
				$showroomaddress .= $row['add1'] .", ";
			}
			if ($row['add2'] != '') {
				$showroomaddress .= $row['add2'] .", ";
			}
			if ($row['add3'] != '') {
				$showroomaddress .= $row['add3'] .", ";
			}
			if ($row['town'] != '') {
				$showroomaddress .= $row['town'] .", ";
			}
			if ($row['countystate'] != '') {
				$showroomaddress .= $row['countystate'] .", ";
			}
			if ($row['postcode'] != '') {
				$showroomaddress .= $row['postcode'];
			}
			if ($row['tel'] != '') {
				$showroomtel = "Tel: " .$row['tel'];
			}
			if ($showroomtel != '' && $salesuseremail != '') {
				$showroomtel .= "  Email: " .$salesuseremail;
			}
		}
	
		$header='';
		$header .= "<table><tr><td width='75%'><p class=toplinespace><img src='webroot/img/logo.jpg' width='255' height='42' style='position:relative;left:1px;top:40px;' /></td><td width='25%'>Order Number: " .$ordernumber ."<br><br>Order Date: " .$orderdate ."<br><br>Savoir Contact: " .$salesname;
		$header .= "</td></tr></table>";
		$this->set('header', $header);
		$showroom = '';
		$showroom = "Showroom: " .$showroomaddress;
		$showroom .= "<hr><div class='clear'></div>";
		$this->set('showroom', $showroom);
		$content = '';
		
		
		
		$query = $this->Address->find()->where(['CODE' => $code]);
		$address = null;
		foreach ($query as $row) {
			$address = $row;
		}
		
		$query = $this->Contact->find()->where(['CONTACT_NO' => $contact]);
		$contact = null;
		foreach ($query as $row) {
			$contact = $row;
		}
		
		$customerdetails = 'Client: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>';
		if ($contact['title'] != '') {
			$customerdetails .= $contact['title'] .", ";
		}
		if ($contact['first'] != '') {
			$customerdetails .= $contact['first'] .", ";
		}
		if ($contact['surname'] != '') {
			$customerdetails .= $contact['surname'] .",</b> ";
		}
		if ($address['company'] != '') {
				$customerdetails .= '<br>Company:&nbsp;&nbsp;<b>' .$address['company'] ."</b>";
		}
		if ($address['tel'] != '') {
				$customerdetails .= "<br>Home Tel:&nbsp;&nbsp;<b>" .$address['tel'] ."</b>";
		}
		if ($contact['telwork'] != '') {
				$customerdetails .= "<br>Work Tel:&nbsp;&nbsp;&nbsp;<b>" .$contact['telwork'] ."</b>";
		}
		if ($contact['mobile'] != '') {
				$customerdetails .= "<br>Mobile:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>" .$contact['mobile'] ."</b>";
		}
		if ($address['EMAIL_ADDRESS'] != '') {
				$customerdetails .= "<br>Email:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>" .$address['EMAIL_ADDRESS'] ."</b>";
		}
		if ($purchase['customerreference'] != '') {
				$customerdetails .= "<br>Client Ref:&nbsp;&nbsp;<b>" .$purchase['customerreference'] ."</b>";
		}
		$content .=  $customerdetails;
		$this->set('content', $content);
		
	}
	
	private function _getFormattedDateFromRs($row, $name) {
		$date = "";
		if (isset($row[$name])) {
			$date = date("d/m/Y", strtotime(substr($row[$name],0,10)));
		}
		return $date;
	}
	
	private function _getSafeValueFromForm($formData, $name) {
		$value = "";
		if (isset($formData[$name])) {
			$value = $formData[$name];
		}
		return $value;
	}
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR");
	}

}

?>
