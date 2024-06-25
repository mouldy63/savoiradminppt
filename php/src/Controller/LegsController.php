<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class LegsController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
    	$this->loadModel('Purchase');
		$this->loadModel('Location');
		$this->loadModel('FireLabel');
		$this->loadModel('Contact');
		$this->loadModel('Address');
		$this->loadModel('ProductionSizes');
		$this->loadModel('Wrappingtypes');
		$this->loadModel('Accessory');
		$this->loadModel('QcHistoryLatest');
		$this->loadModel('BayContent');
		
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
		$purchase = null;
        $ordernumber = null;
		$orderdate = null;
		$salesusername = null;
		foreach ($query as $row) {
			$purchase = $row;
			
		}
		$ordernumber = $purchase['ORDER_NUMBER'];
		$orderdate = substr($purchase['ORDER_DATE'],0,10);
		$salesusername = $purchase['salesusername'];
		$idlocation = $purchase['idlocation'];
		$contact = $purchase['contact_no'];
		$code = $purchase['CODE'];
		$legstyle = $purchase['legstyle'];
		$customerreference = $purchase['customerreference'];
		$this->set('ordernumber', $ordernumber);
		$this->set('orderdate', $orderdate);
		$this->set('customerreference', $customerreference);
		$salesname = $purchaseTable->getSalesContact($salesusername);
		$salesuseremail = $purchaseTable->getSalesEmail($salesusername);
		$this->set('salesname', $salesname);
		$this->set('salesuseremail', $salesuseremail);
		$this->set('legstyle', $legstyle);
		$query = $this->Contact->find()->where(['CONTACT_NO' => $contact]);
		$contact = null;
		foreach ($query as $row) {
			$contact = $row;
		}
		

		$query = $this->ProductionSizes->find()->where(['Purchase_No' => $pn]);
		$psizes = null;
		foreach ($query as $row) {
			$psizes = $row;
		}
	
		$query = $this->Wrappingtypes->find()->where(['WrappingID' => $purchase['wrappingid']]);
		$wrap = null;
		foreach ($query as $row) {
			$wrap = $row;
		}
		$wraptype = $wrap['Wrap'];
		$this->set('wraptype', $wraptype);
		
		$firelabelname='';
		if ($purchase['FireLabelID'] != '') {
			$query = $this->FireLabel->find()->where(['FireLabelID' => $purchase['FireLabelID']])->toArray();
			foreach ($query as $row) {
				$firelabel = $row;
			}
			if (count($query)==0) {
				$firelabelname="N/a";
			} else {
			$firelabelname = $firelabel['FireLabel'];
			}
		}
		
		$this->set('firelabelname', $firelabelname);
		
		$customername = '';
		if ($contact['title'] != '') {
			$customername .= $contact['title'] ." ";
		}
		if ($contact['first'] != '') {
			$customername .= $contact['first'] ." ";
		}
		if ($contact['surname'] != '') {
			$customername .= $contact['surname'] ."";
		}
		$this->set('customername', $customername);
		
	
	$bcwexpected='';
	$finishedweekno='';
	$carpentryweekno='';	
	$arrayOfComps=[7];
	$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID IN' => $arrayOfComps]);
	foreach ($query as $qclatest) {
	
		if (!is_null($qclatest['BCWExpected'])) {
			//debug($qclatest['BCWExpected']);
			$bcwExpected = new DateTime(str_replace('/', '-', $qclatest['BCWExpected']));
			$weeknumber = $bcwExpected->format("W");
			//debug($weeknumber);
			$bcwExpectedLessOneWeek = date_sub($bcwExpected, date_interval_create_from_date_string("1 week"));
			//debug($bcwExpectedLessOneWeek);
			$weeknumber2 = $bcwExpectedLessOneWeek->format("W");
			//debug($weeknumber2);
			$dayofweeknumber = $bcwExpectedLessOneWeek->format("w");
			//debug($dayofweeknumber);
			//die();
			$finishedweekno=$weeknumber ."." .$dayofweeknumber;
			$carpentryweekno=$weeknumber2 ."." .$dayofweeknumber;
		}
		
	}
	$userlocation=$this->getCurrentUserLocationId();
	if ($userlocation==27) {
		$finishedweekno='';
		$carpentryweekno='';
		}
	$this->set('bcwexpected', $bcwexpected);
	$this->set('finishedweekno', $finishedweekno);
	$this->set('carpentryweekno', $carpentryweekno);
	
	$legdetails='';
	$legheight='';
	$totalqty=0;
	$legimage='';
	if (!is_null($purchase['LegQty'])) {
		$totalqty=$totalqty+$purchase['LegQty'];
		}
	if (!is_null($purchase['AddLegQty'])) {
		$totalqty=$totalqty+$purchase['AddLegQty'];
		}
	$query = $this->Location->find()->where(['idlocation' => $idlocation]);
		foreach ($query as $row) {
			$showroomaddress = '';
			$showroomaddress .= $row['adminheading'] .", ";
		}
		$this->set('showroomaddress', $showroomaddress);
		
		if ($purchase['legsrequired'] == 'y') {
			if (!empty($psizes['legheight']) && substr($purchase['legheight'], 0, 3) == 'Spe') {
						$legheight .= $psizes['legheight'] ."cm";
					} else {
						$legheight .= $purchase['legheight'];
					}
					if ($legheight=='') {
						$legheight="Not provided";
					}
				$legdetails .= "Leg Height: " .$legheight ."<br><br>";
				$legdetails .= $purchase['legstyle'] ." x " .$purchase['LegQty'] ." Colour: " .$purchase['legfinish'] ."<br><br>";
				$legdetails .= $purchase['addlegstyle'] ." x " .$purchase['AddLegQty'] ." Colour: " .$purchase['addlegfinish'] ."<br><br>";
				$legdetails .= "Total Quantity: " .$totalqty ."<br><br>";
				if (!empty($purchase['specialinstructionslegs'])) {
					$legdetails .= "Special Instructions: " .$purchase['specialinstructionslegs'] ."<br><br>";
					}
				if (!empty($purchase['floortype'])) {
					$legdetails .= "Floor Type: " .$purchase['floortype'] ."<br><br>";
					}
				if ($purchase['legstyle']=="Wooden Tapered") {
				$legimage= "<img src='webroot/img/Wooden Tapered.gif'  />";
				}
				if ($purchase['legstyle']=="Metal") {
				$legimage= "<img src='webroot/img/Metal.gif'  />";
				}
				if ($purchase['legstyle']=="Castors") {
				$legimage= "<img src='webroot/img/Castors.gif'  />";
				}
				if ($purchase['legstyle']=="Manhattan") {
				$legimage= "<img src='webroot/img/Manhattan.gif'  />";
				}
				if ($purchase['legstyle']=="Georgian (Brass cap)" || $purchase['legstyle']=="Georgian (Chrome cap)") {
				$legimage= "<img src='webroot/img/Georgian (Brass Cap).gif'  />";
				}
				if ($purchase['legstyle']=="Penelope") {
				$legimage= "<img src='webroot/img/Penelope.gif'  />";
				}
				if ($purchase['legstyle']=="Cylindrical") {
				$legimage= "<img src='webroot/img/Cylindrical.gif'  />";
				}
				if ($purchase['legstyle']=="Georgian" || $purchase['legstyle']=="Georgian Upholstered") {
				$legimage= "<img src='webroot/img/Georgian.gif'  />";
				}
				if ($purchase['legstyle']=="Manhattan") {
				$legimage= "<img src='webroot/img/Manhattan.gif'  />";
				}
				if ($purchase['legstyle']=="Harlech Leg") {
				$legimage= "<img src='webroot/img/Harlech Leg.gif'  />";
				}
				if ($purchase['legstyle']=="Holly") {
				$legimage= "<img src='webroot/img/Holly.gif' />";
				}
				if ($purchase['legstyle']=="Ian Leg") {
				$legimage= "<img src='webroot/img/Ian Leg.gif'  />";
				}
				if ($purchase['legstyle']=="Block Leg") {
				$legimage= "<img src='webroot/img/Block Leg.gif' />";
				}

			$this->set('legdetails', $legdetails);
			$this->set('legimage', $legimage);
		}
			
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
