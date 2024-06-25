<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class FramesController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('QrCode');
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
		$customerreference = $purchase['customerreference'];
		$this->set('ordernumber', $ordernumber);
		$this->set('orderdate', $orderdate);
		$this->set('customerreference', $customerreference);
		$salesname = $purchaseTable->getSalesContact($salesusername);
		$salesuseremail = $purchaseTable->getSalesEmail($salesusername);
		if ($purchase['specialinstructionslegs'] != '') {
			$legspecialinstructions = "<div style='border:solid; border: 1px solid #000;padding:5px;margin-top:15px;'><b>Leg Special Instructions: </b>" .$purchase['specialinstructionslegs'] ."</div>";
		} else {
			$legspecialinstructions = "";
		}
		$this->set('legspecialinstructions', $legspecialinstructions);
		$this->set('salesname', $salesname);
		$this->set('salesuseremail', $salesuseremail);
		$query = $this->Contact->find()->where(['CONTACT_NO' => $contact]);
		$contact = null;
		foreach ($query as $row) {
			$contact = $row;
		}
		$surname = $contact['surname'];
		$contactcode = $contact['CODE'];
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
		$query = $this->Address->find()->where(['CODE' => $contactcode]);
		$contact = null;
		foreach ($query as $row) {
			$address = $row;
		}
		$company = $address['company'];
		$qrdata=$ordernumber. ", ".$surname. ", ".$company;
	
		$qrcode="<img src='" . $docroot . '/' . $this->QrCode->getOrderNumberImageUrl($qrdata) . "' width='60px' height='60px'/>";
		$this->set('qrcode', $qrcode);
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
			$query = $this->FireLabel->find()->where(['FireLabelID' => $purchase['FireLabelID']]);
			foreach ($query as $row) {
				$firelabel = $row;
			}
			if ($query->count()==0) {
				$firelabelname="N/a";
			} else {
			$firelabelname = $firelabel['FireLabel'];
			}
		}
		
		$this->set('firelabelname', $firelabelname);
	
	$bcwexpected='';
	$finishedweekno='';
	$carpentryweekno='';	
	$arrayOfComps=[3];
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
	$this->set('bcwexpected', $bcwexpected);
	$this->set('finishedweekno', $finishedweekno);
	$this->set('carpentryweekno', $carpentryweekno);
	
		
	$query = $this->Location->find()->where(['idlocation' => $idlocation]);
		foreach ($query as $row) {
			$showroomaddress = '';
			$showroomaddress .= $row['adminheading'] .", ";
		}
		$this->set('showroomaddress', $showroomaddress);
		
		$basemadeat='';
		$basedetails='';
		$basedetails2='';
		$showbase='n';
		$basewidth='';
		$basewidth1='';
		$basewidth2='';
		$baselength='';
		$baselength1='';
		$baselength2='';
		$baserequired='';
		$basemadeelsewhere='';
		if ($purchase['baserequired'] == 'y') {
				$baseqty=1;
				if (substr($purchase['basetype'], 0, 3) == 'Nor' || substr($purchase['basetype'], 0, 3) == 'Eas') {
				$baseqty=2;
				}
				$basedetails .= "<b>Box:</b> <font size=16px>" .$purchase['basesavoirmodel'] ."</font><br><br>";
				$basedetails .= "<b>Box Type:</b> <font size=16px>" .$purchase['basetype'] ."</font><br><br>";
				$basesize='';
					if (substr($purchase['basewidth'], 0, 3) != 'Spe') {
						$basewidth1=$purchase['basewidth'];
						
						$basewidth1 = preg_replace("/[^0-9.]/", "", $purchase['basewidth'] );
						
						if (substr($purchase['basewidth'], -2)=='in') {
							$basewidth1=$basewidth1*2.54;
							}
						if (substr($purchase['basetype'], 0, 3)=='Nor') {
							$basewidth1=$basewidth1/2;
							$basewidth2=$basewidth1;
							}
						if (substr($purchase['basetype'], 0, 3)=='Eas') {
							$basewidth2=$basewidth1;
							}
 					}
					if (substr($purchase['baselength'], 0, 3) != 'Spe') {
						$baselength1=$purchase['baselength'];
						$baselength1 = preg_replace("/[^0-9.]/", "", $purchase['baselength'] );
						if (substr($purchase['baselength'], -2)=='in') {
							$baselength1=$baselength1*2.54;
							}
						if (substr($purchase['basetype'], 0, 3)=='Nor') {
							$baselength2=$baselength1;
							}
						if (substr($purchase['basetype'], 0, 3)=='Eas') {
							$baselength2=$baselength1-130;
							$baselength1=130;
							}
 					}
					if (substr($purchase['basewidth'], 0, 3) == 'Spe') {
						if (!empty($psizes['Base1Width'])) {
							$basewidth1 = $psizes['Base1Width'];
						}
						if ($baseqty==2) {
							if (!empty($psizes['Base2Width'])) {
							$basewidth2 = $psizes['Base2Width'];
							}
						}
					}
					if (substr($purchase['baselength'], 0, 3) == 'Spe') {
						if (!empty($psizes['Base1Length'])) {
							$baselength1 = $psizes['Base1Length'];
						}
						if ($baseqty==2) {
							if (!empty($psizes['Base2Length'])) {
							$baselength2 = $psizes['Base2Length'];
							}
						}
					}
					$basedetails .= "<b>Box W/L Box 1:</b> <font size=16px>" .$basewidth1 ." cm x ".$baselength1." cm</font><br><br>";
					if ($baseqty==2) {
						$basedetails .= "<b>Box W/L Box 2:</b> <font size=16px>" .$basewidth2 ." cm x ".$baselength2." cm</font><br><br>";
					}
					
					if (substr($purchase['baseheightspring'], 0, 6) == 'Non St') {
						$basedetails .= "<br><font size=16px>Non-Standard Base - Check Order Details</font><br><br>";
					}
					if (substr($purchase['baseheightspring'], 0, 6) == 'Standa') {
						$basedetails .= "<br><font size=16px>Standard ".$purchase['basesavoirmodel']. " Base</font><br><br>";
					}
	
					$basedetails .= "<br><b>Link Bar:</b> " .$purchase['linkfinish'] ." ".$purchase['linkposition']."<br>";
					$basedetails .= "<br><b>Ticking:</b> " .$purchase['basetickingoptions'] ."<br>";
					$basedetails .= "<br><b>Legs:</b> " .$purchase['legstyle'] ."<br>";
					if ($purchase['upholsteredbase']=='Yes' || $purchase['upholsteredbase']=='Yes, Com') {
						$basedetails .= "<b>Order Detail:</b> Upholstered Base<br>";
						}
					$basedetails.='<br><b>Start Date:</b>  ___________________<br><b>Start Time:</b>  ___________________<br><b>Spring to Roll:</b> <span style="margin-left:2px;">___________</span><span style="position:absolute; padding-left:10px;"><b>Your Time:</b> ______</span> <br><b>To cover:</b><span style="margin-left:35px;"> ___________</span><span style="position:absolute; padding-left:10px;"><b>Your Time:</b> ______</span><br>';
					
					$basedetails .= "<br><br><b>Wrapping Instructions:</b> " .$wraptype;
					$basedetails .= "<br><br><b>Fire Label:</b> " .$firelabelname;
					$basedetails .= "<br><br><b>Frame Made by: </b>.......................";
					$basedetails .= "<br><br><b>To be finished by: </b>.......................";
					$basedetails2 = "<b>Box Special Instructions: </b>" .$purchase['baseinstructions'];
					if ($purchase['upholsteredbase']=='Holly' || $purchase['upholsteredbase']=='Georgian' || $purchase['upholsteredbase']=='Georgian (Brass cap)' || $purchase['upholsteredbase']=='Georgian Upholstered' || $purchase['upholsteredbase']=='Penelope') {
						$basedetails2 .= "<br><br>Mortice corner block required as leg is " .$purchase['legstyle'];
						}	
					if ($purchase['basedrawers']=="Yes") {
						$basedetails2 .= "<br><br><b>Drawers:</b> " .$purchase['basedrawerconfigID'];
						$basedetails2 .= "<br><br><b>Height: </b>" .$purchase['basedrawerheight'];
					}
						
					if (!is_null($purchase['basetrim']) && $purchase['basetrim']!='') {
						$basedetails2 .= "<br><br><b>Base Trim: </b>" .$purchase['basetrim'];
						$basedetails2 .= "<br><br><b>Base Trim Colour: </b>" .$purchase['basetrimcolour'];
					}
 
									


				
				
			} else {
				$basedetails="BOX NOT REQUIRED";
				$basedetails2='';
				$baserequired='n';
				
			}
	
			$this->set('basedetails', $basedetails);
			$this->set('basedetails2', $basedetails2);	
			$this->set('baserequired', $baserequired);
			
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
