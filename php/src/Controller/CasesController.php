<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class CasesController extends SecureAppController
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
		$customerreference = $purchase['customerreference'];
		$this->set('ordernumber', $ordernumber);
		$this->set('orderdate', $orderdate);
		$this->set('customerreference', $customerreference);
		$salesname = $purchaseTable->getSalesContact($salesusername);
		$salesuseremail = $purchaseTable->getSalesEmail($salesusername);
		$this->set('salesname', $salesname);
		$this->set('salesuseremail', $salesuseremail);
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
			$query = $this->FireLabel->find()->where(['FireLabelID' => $purchase['FireLabelID']]);
			foreach ($query as $row) {
				$firelabel = $row;
			}
			$firelabelname = $firelabel['FireLabel'];
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
	$cuttingweekno='';	
	$arrayOfComps=[1, 3, 5];
	$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID IN' => $arrayOfComps, 'MadeAt' => 2]) -> order (['BCWExpected' => 'DESC']);
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
			$cuttingweekno=$weeknumber2 ."." .$dayofweeknumber;
		}
		
	}
	$this->set('bcwexpected', $bcwexpected);
	$this->set('finishedweekno', $finishedweekno);
	$this->set('cuttingweekno', $cuttingweekno);
	
		
	$query = $this->Location->find()->where(['idlocation' => $idlocation]);
		foreach ($query as $row) {
			$showroomaddress = '';
			$showroomaddress .= $row['adminheading'] .", ";
		}
		$this->set('showroomaddress', $showroomaddress);
		
		$mattressmadeat='';
		$mattressdetails='';
		$mattressdetails2='';
		$showbase='n';
		$mattressrequired='';
		$mattressmadeelsewhere='';
		$mattwidth1=0;
		$mattwidth2=0;
		$mattlength1=0;
		$mattlength2=0;
		
		if ($purchase['mattressrequired'] == 'y') {
			
			$QCLatest = TableRegistry::get('QCHistoryLatest');
			$query = $QCLatest->getQCmadeat(1,$pn);
			if (count($query)==0) {
				$mattressdetails='Mattress made in ';
				$mattressmadeelsewhere='y';
			}
				foreach ($query as $QCL) {
				$mattressmadeat=$QCL['id_location'];
				$mattressfactory=$QCL['ManufacturedAt'];
				$mattqty=1;
				$showmattress='n';
				$locid=$this->getCurrentUserLocationId();
				if ($locid==$mattressmadeat) {
					$showmattress='y';
					$mattressdetails='<b>MATTRESS: Machined by:.............................</b><br>';
					$mattressdetails.=$purchase['savoirmodel'].'<br>';
					$mattressdetails.='<b>TYPE:</b> ' .$purchase['mattresstype'].'<br>';
					if (substr($purchase['mattresswidth'], 0, 3) != 'Spe') {
						$mattwidth1=$purchase['mattresswidth'];
						$mattwidth1 = preg_replace("/[^0-9.]/", "", $purchase['mattresswidth'] );
						if (substr($purchase['mattresswidth'], -2)=='in') {
							$mattwidth1=$mattwidth1*2.54;
							}
 					}
					
					if (substr($purchase['mattresslength'], 0, 3) != 'Spe') {
						$mattlength1=$purchase['mattresslength'];
						$mattlength1 = preg_replace("/[^0-9.]/", "", $purchase['mattresslength'] );
						if (substr($purchase['mattresslength'], -2)=='in') {
							$mattlength1=$mattlength1*2.54;
							}
 					}
					if (substr($purchase['mattresstype'], 0, 3)=='Zip') {
						$mattqty=2;
						$mattwidth1=$mattwidth1/2;
						$mattwidth2=$mattwidth1;
						$mattlength2=$mattlength1;
						if ($purchase['savoirmodel']=='No. 1' || $purchase['savoirmodel']=='No. 2') 		{
						$mattwidth1=$mattwidth1-1;
						$mattwidth2=$mattwidth2-1;
							}
						} 

					if (substr($purchase['mattresswidth'], 0, 3) == 'Spe') {
						if (!empty($psizes['Matt1Width'])) {
							$mattwidth1=$psizes['Matt1Width'];
							if (($purchase['savoirmodel']=='No. 1' || $purchase['savoirmodel']=='No. 2') && substr($purchase['mattresstype'], 0, 3)=='Zip') {
								$mattwidth1=$mattwidth1-1;
							}
						}
					}
					
					if (substr($purchase['mattresslength'], 0, 3) == 'Spe') {
						if (!empty($psizes['Matt1Length'])) {
							$mattlength1=$psizes['Matt1Length'];
						}
					}
				    if (substr($purchase['mattresstype'], 0, 3)=='Zip' && substr($purchase['mattresswidth'], 0, 3) == 'Spe')  {
						if (!empty($psizes['Matt2Width'])) {
							$mattwidth2=$psizes['Matt2Width'];
							if ($purchase['savoirmodel']=='No. 1' || $purchase['savoirmodel']=='No. 2') {
								$mattwidth2=$mattwidth2-1;
							}
						}
					}
					if (substr($purchase['mattresstype'], 0, 3)=='Zip' && substr($purchase['mattresslength'], 0, 3) == 'Spe')  {
						if (!empty($psizes['Matt2Length'])) {
							$mattlength2=$psizes['Matt2Length'];
						}
					}
					$mattressdetails.='<b>Mattress 1:</b> '.$mattwidth1.' cm x '.$mattlength1.' cm';
					if ($mattqty==2) {
						$mattressdetails.='<br><b>Mattress 2:</b> '.$mattwidth2.' cm x '.$mattlength2.' cm';
						}
					$mattressdetails.='<br><br><b>Ticking Style: </b>'.$purchase['tickingoptions'];
					$mattressdetails.='<br><b>Support: </b>';
					$mattressdetails.='<br><b>Left: </b>'.$purchase['leftsupport'].'&nbsp;&nbsp;<b>Right: </b>'.$purchase['rightsupport'];
					$mattressdetails.='<br><b>Date Cut:.................................<br>Date Machined:...................... <br>Date Finished:........................ <br>Finished By:...........................<br><u>Cutter to Write Ticking Used</u><br>Ticking Batch Used:.............. <br>Ticking Batch Used:..............</b><br>';
					$mattressdetails2='<b>Vent Position:</b> '.$purchase['ventposition'];
					$mattressdetails2.='<br><b>Vent Finish:</b> '.$purchase['ventfinish'];
					$mattressinstructions='';
					if ($purchase['mattressinstructions'] != '') {
						$mattressinstructions=strtoupper($purchase['mattressinstructions']);
					}
					$mattressdetails2.='<br><b>Special Instructions:</b> '.$mattressinstructions;
					$mattressdetails2.='<br><br><b>Production Hours Used:<br><br>
	Cut.............. Machine.............. <br>Finish:..............</b>';

					} else {
						$mattressdetails='Mattress made in ' .$mattressfactory;
						$mattressdetails2='';
						}
				}
				
				
			} else {
				$mattressdetails="MATTRESS NOT REQUIRED";
				$mattressdetails2='';
				$mattressrequired='n';
				$mattressmadeelsewhere='y';
				}
		$this->set('mattressdetails', $mattressdetails);
		$this->set('mattressdetails2', $mattressdetails2);
		$this->set('mattressrequired', $mattressrequired);
		$this->set('mattressmadeelsewhere', $mattressmadeelsewhere);
			
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
			$QCLatest = TableRegistry::get('QCHistoryLatest');
			$query = $QCLatest->getQCmadeat(3,$pn);
			if (count($query)==0) {
				$basedetails='Base made in ';
				$basemadeelsewhere='y';
				}
				foreach ($query as $QCL) {
				$basemadeat=$QCL['id_location'];
				$basefactory=$QCL['ManufacturedAt'];
				$baseqty=1;
				$locid=$this->getCurrentUserLocationId();
				if ($locid==$basemadeat) {
					$showbase='y';
					if (substr($purchase['basetype'], 0, 3) == 'Nor' || substr($purchase['basetype'], 0, 3) == 'Eas') {
					$baseqty=2;
					}
					$basedetails .= "<b>Box:</b> " .$purchase['basesavoirmodel'] ."<br>";
					$basedetails .= "<b>Type:</b> " .$purchase['basetype'] ."<br>";
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
							$baselength1=$purchase['baselength'];
							$baselength = preg_replace("/[^0-9.]/", "", $purchase['baselength'] );
							$baselength1=130;
							$baselength2=$baselength-130;
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
					$basedetails .= "<b>Box 1:</b> " .$basewidth1 ." cm x ".$baselength1." cm<br>";
					if ($baseqty==2) {
						$basedetails .= "<b>Box 2:</b> " .$basewidth2 ." cm x ".$baselength2." cm<br>";
					}
					$basedetails .= "<br><b>Ticking:</b> " .$purchase['basetickingoptions'] ."<br>";
					$basedetails.='<b>Date Cut:.................................<br>Date Machined:...................... <br>Date Finished:........................ <br>Finished By:...........................<br><u>Fabric Cutter to Write Ticking<br>Batches Used Below</u><br>Ticking Batch Used:.............. <br>Ticking Batch Used:..............</b><br>';
					$baseinstructions='';
					if ($purchase['baseinstructions'] != '') {
					 	$baseinstructions=strtoupper($purchase['baseinstructions']);
					 }
					$basedetails2 = "<b>Special Instructions: </b>" .$baseinstructions."<br><br><b>Production Hours Used:</b><br><br><b>Cut.............. &nbsp; Machine.............. </b><br /> <b>Finish:..............</b><br><br>";
					if ($purchase['headboardrequired']=='y') {
						$basedetails2.= '<b>Headboard Style: </b>'.$purchase['headboardstyle'].'<br><br>';
						}
					if (substr($purchase['upholsteredbase'], 0, 3) == 'Yes') {
						$basedetails2.= '<b>Upholstered Base: </b>' .$purchase['upholsteredbase'].'<br><br>';
						}
					if ($purchase['basedrawers']=="Yes") {
						$basedetails2.= '<b>Drawers: </b>' .$purchase['basedrawerconfigID'].'<br>';
						$basedetails2.= '<b>Drawer Height: </b>' .$purchase['basedrawerheight'].'';
						}
									
					} else {
						$basedetails='Base made in ' .$basefactory;
						$basedetails2='';
						$basemadeelsewhere='y';
						}
				}
				
				
			} else {
				$basedetails="BOX NOT REQUIRED";
				$basedetails2='';
				$baserequired='n';
				
				}
	
			$this->set('basedetails', $basedetails);
			$this->set('basedetails2', $basedetails2);	
			$this->set('baserequired', $baserequired);
			$this->set('basemadeelsewhere', $basemadeelsewhere);
			
				
				
		$topperdetails='';
		$topperdetails2='';
		$showtopper='n';
		$topperrequired='';
		$toppermadeelsewhere='';
		
		if ($purchase['topperrequired'] == 'y') {
			$QCLatest = TableRegistry::get('QCHistoryLatest');
			$query = $QCLatest->getQCmadeat(5,$pn);
			if (count($query)==0) {
				$topperdetails='Topper made in ';
				$toppermadeelsewhere='y';
				}
				foreach ($query as $QCL) {
				$toppermadeat=$QCL['id_location'];
				$topperfactory=$QCL['ManufacturedAt'];
				$locid=$this->getCurrentUserLocationId();
				
				if ($locid==$toppermadeat) {
					$showtopper='y';
					$topperdetails = "<b>TOPPER</b><br>";
					$topperdetails .= "<b>Type:</b> " .$purchase['toppertype'] ."<br>";
					$toppersize='';
					if (!empty($psizes['topper1Width']) && substr($purchase['topperwidth'], 0, 3) == 'Spe') {
						$toppersize .= $psizes['topper1Width'] ."cm x ";
					} else {
						$toppersize .= $purchase['topperwidth'] ." x ";
					}
					if (!empty($psizes['topper1Length']) && substr($purchase['topperlength'], 0, 3) == 'Spe') {
						$toppersize .= $psizes['topper1Length'] ."cm. ";
					} else {
						$toppersize .= $purchase['topperlength'] .". ";
					}
					$topperdetails .= "<b>Size (w x l):</b> " .$toppersize ."<br>";
					$topperdetails .= "<br><b>Ticking Style:</b> " .$purchase['toppertickingoptions'] ."<br>";
					$topperdetails .="<b>Date Cut:.................................<br>Date Machined:......................<br>Date Finished:........................<br>Finished By:...........................<br><u>Cutter to Write Ticking Used<br>Batches Used Below</u><br>
Ticking Batch Used:..............<br>Ticking Batch Used:..............</b>";
					$topperinstructions='';
				    if ($purchase['specialinstructionstopper'] != '') {
				    	$topperinstructions=strtoupper($purchase['specialinstructionstopper']);
				    }
					$topperdetails2 = "<b>Special Instructions: </b>" .$topperinstructions ."<br><br>";
					
					$topperdetails2 .= "<b>Production Hours Used:<br><br>
Cut..............<br>Machine..............<br>Finish:..............<b>";
					
					
					} else {
						$topperdetails='Topper made in ' .$topperfactory;
						$topperdetails2='';
						$toppermadeelsewhere='y';
						}
				}
				
				
			} else {
				$topperdetails="TOPPER NOT REQUIRED";
				$topperdetails2='';
				$topperrequired='n';
				}
			
			$this->set('topperdetails', $topperdetails);
			$this->set('topperdetails2', $topperdetails2);
			$this->set('topperrequired', $topperrequired);
			$this->set('toppermadeelsewhere', $toppermadeelsewhere);
	
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
