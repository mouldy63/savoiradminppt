<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class PickingNoteController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
		$this->loadComponent('QrCode');
		$this->loadModel('Purchase');
		$this->loadModel('Location');
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
		$this->set('ordernumber', $ordernumber);
		$this->set('orderdate', $orderdate);
		$salesname = $purchaseTable->getSalesContact($salesusername);
		$salesuseremail = $purchaseTable->getSalesEmail($salesusername);
		$this->set('salesname', $salesname);
		$this->set('salesuseremail', $salesuseremail);
		$query = $this->Contact->find()->where(['CONTACT_NO' => $contact]);
		$contact = null;
		foreach ($query as $row) {
			$contact = $row;
		}
		
		$query = $this->Address->find()->where(['CODE' => $code]);
		$address = null;
		foreach ($query as $row) {
			$address = $row;
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
		$wraptype = $wrap['pdfwrapname'];
		$this->set('wraptype', $wraptype);
		
		$customerdetails = '<b>Client:</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
		if ($contact['title'] != '') {
			$customerdetails .= $contact['title'] .", ";
		}
		if ($contact['first'] != '') {
			$customerdetails .= $contact['first'] .", ";
		}
		if ($contact['surname'] != '') {
			$customerdetails .= $contact['surname'] .",";
		}
		if ($address['company'] != '') {
				$customerdetails .= '<br><b>Company:</b>&nbsp;&nbsp;' .$address['company'] ."";
		}
		if ($address['tel'] != '') {
				$customerdetails .= "<br><b>Home Tel:</b>&nbsp;&nbsp;" .$address['tel'] ."";
		}
		if ($contact['telwork'] != '') {
				$customerdetails .= "<br><b>Work Tel:</b>&nbsp;&nbsp;&nbsp;" .$contact['telwork'] ."";
		}
		if ($contact['mobile'] != '') {
				$customerdetails .= "<br><b>Mobile:</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" .$contact['mobile'] ."";
		}
		if ($address['EMAIL_ADDRESS'] != '') {
				$customerdetails .= "<br><b>Email:</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" .$address['EMAIL_ADDRESS'] ."";
		}
		if ($purchase['customerreference'] != '') {
				$customerdetails .= "<br><b>Client Ref:</b>&nbsp;&nbsp;" .$purchase['customerreference'] ."";
		}
		$this->set('customerdetails', $customerdetails);
		
		$customeraddress='';
		$customeraddress .='<b>';
		if ($address['street1'] != '') {
				$customeraddress .= $address['street1'];
		}
		if ($address['street2'] != '') {
				$customeraddress .= "<br>" .$address['street2'];
		}
		if ($address['street3'] != '') {
				$customeraddress .= "<br>" .$address['street3'];
		}
		if ($address['town'] != '') {
				$customeraddress .= "<br>" .$address['town'];
		}
		if ($address['county'] != '') {
				$customeraddress .= "<br>" .$address['county'];
		}
		if ($address['postcode'] != '') {
				$customeraddress .= "<br>" .$address['postcode'];
		}
		if ($address['country'] != '') {
				$customeraddress .= "<br>" .$address['country'];
		}
		$customeraddress .= "</b>";
		
		$this->set('customeraddress', $customeraddress);
		
		$deliveryaddress='';
		$deliveryaddress .= '<b>';
		if ($purchase['deliveryadd1'] != '') {
				$deliveryaddress .= $purchase['deliveryadd1'];
		}
		if ($purchase['deliveryadd2'] != '') {
				$deliveryaddress .= "<br>" .$purchase['deliveryadd2'];
		}
		if ($purchase['deliveryadd3'] != '') {
				$deliveryaddress .= "<br>" .$purchase['deliveryadd3'];
		}
		if ($purchase['deliverytown'] != '') {
				$deliveryaddress .= "<br>" .$purchase['deliverytown'];
		}
		if ($purchase['deliverycounty'] != '') {
				$deliveryaddress .= "<br>" .$purchase['deliverycounty'];
		}
		if ($purchase['deliverypostcode'] != '') {
				$deliveryaddress .= "<br>" .$purchase['deliverypostcode'];
		}
		if ($purchase['deliverycountry'] != '') {
				$deliveryaddress .= "<br>" .$purchase['deliverycountry'];
		}
		$deliveryaddress .= "</b>";
		
		$this->set('deliveryaddress', $deliveryaddress);
		
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
		$this->set('showroomaddress', $showroomaddress);
		$this->set('showroomtel', $showroomtel);
		$pageheight=1;
		
		$header='';
		$header .= "<p class='toplinespace'><img src='webroot/img/logo.jpg' width='255' height='42' style='position:absolute;right:1px;top:40px;' />";
		if (!empty($purchase['bookeddeliverydate'])) {
			$header .= "<br>Delivery Date: " .substr($purchase['bookeddeliverydate'],0,10);
			}
		$header .= "</p><p class='pickingnote'>Picking Note<br><span class='pnorderno'>Order Number: " .$ordernumber ."</span></p><p class=pnshowroom>Showroom: " .$showroomaddress;
		if ($showroomtel != '') {
		$header .= "<br>" .$showroomtel;
		};
		$header .= "</p><hr style=margin-top:1px; margin-bottom:1px;>";
		$header .= "<div><img src='webroot/img/" . $this->QrCode->getOrderNumberImageUrl($ordernumber) . "' width='30px' height='30px'  style='position:absolute; top:90px;right:0px;'/></div>";
		$this->set('header', $header);
		$tobedelivered='';
		$accessoriesonly='x';
		
		if ($purchase['mattressrequired'] == 'y' || $purchase['topperrequired'] == 'y' || $purchase['baserequired'] == 'y' || $purchase['headboardrequired'] == 'y' || $purchase['valancerequired'] == 'y' || $purchase['legsrequired'] == 'y') {
			$accessoriesonly='n';
		}
		if ($purchase['accessoriesrequired'] == 'y' && $accessoriesonly=='x') {
			$accessoriesonly='y';
		}
		$this->set('accessoriesonly', $accessoriesonly);
		$mattressStatus='';
		$mattressPicked='n';
		$mattressdetails='';
		$mattressbay='';
		$mattresscount=0;
		$itemcount=0;
		$itemsdelivered=0;
		if ($purchase['mattressrequired'] == 'y') {
			$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 1]);
				foreach ($query as $QCStatusRow) {
				$mattressStatus=$QCStatusRow['QC_StatusID'];
				if (($mattressStatus > 0 && $mattressStatus < 50) || $mattressStatus==90) {
					$tobedelivered.='Mattress<br>';
					};
				if ($mattressStatus==50) {
					$query = $this->BayContent->find()->where(['orderId' => $ordernumber, 'componentId' => 1]);
					foreach ($query as $BayRow) {
					$mattressbay = $BayRow['bayNumber'];
						if ($mattressbay==40) {
							$mattressbay='Car';
						}	
						if ($mattressbay==42) {
							$mattressbay='NYW';
						}
						if ($mattressbay==43) {
							$mattressbay='NYU';
						}
						if ($mattressbay==43) {
							$mattressbay='NYD';
						}
					$mattressPicked='y';
					$mattressdetails .= "<table width=100% border=0 cellspacing=0px cellpadding=3px>";
					$mattressdetails .= "<tr><td valign=top><b>Model:</b> " .$purchase['savoirmodel'] ."</td>";
					$mattsize='';
					if (!empty($psizes['Matt1Width'])) {
						$mattsize .= $psizes['Matt1Width'] ."cm x ";
					} else {
						$mattsize .= $purchase['mattresswidth'] ." x ";
					}
					if (!empty($psizes['Matt1Length'])) {
						$mattsize .= $psizes['Matt1Length'] ."cm. ";
					} else {
						$mattsize .= $purchase['mattresslength'] .". ";
					}
					if (!empty($psizes['Matt2Width'])) {
						$mattsize .= $psizes['Matt2Width'] ."cm x ";
					}
					if (!empty($psizes['Matt2Length'])) {
						$mattsize .= $psizes['Matt2Length'] ."cm. ";
					} 
					$mattressdetails .= "<td colspan=2 valign=top><b>Size (w x l):</b> " .$mattsize ."</td>";
					$mattressdetails .= "<td valign=top><b>Ticking:</b> " .$purchase['tickingoptions'] ."</td>";
					$mattressdetails .= "</tr>";
					$mattressdetails .= "<tr><td valign=top><b>LHS:</b> " .$purchase['leftsupport'] ."</td>";
					$mattressdetails .= "<td valign=top><b>RHS:</b> " .$purchase['rightsupport'] ."</td>";
					$mattressdetails .= "<td valign=top><b>Vent Position:</b> " .$purchase['ventposition'] ."</td>";
					$mattressdetails .= "<td valign=top><b>Vent Finish:</b> " .$purchase['ventfinish'] ."</td>";
					$mattressdetails .= "</tr>";
					if (!empty($purchase['mattressinstructions'])) {
					$mattressdetails .= "<tr><td colspan=4><p class=box>" .$purchase['mattressinstructions'] ."</p></tr>";
					$pageheight +=1;
					}
					$mattressdetails .= "</table>";
					}
					if (substr($purchase['mattresstype'], 0, 3)=='Zip') {
						if ($wraptype=='Crate') {
							$mattresscount=1;
							$itemsdelivered+=1;
							} else {
							$mattresscount=2;
							$itemsdelivered+=2;
							}
					}
					else {
					$mattresscount=1;
					$itemsdelivered+=1;
					}
					$itemcount=$mattresscount;
					$this->set('mattressdetails', $mattressdetails);
					$this->set('mattresscount', $mattresscount);
					$this->set('mattressbay', $mattressbay);
					
					}
				}
			}
		$this->set('mattressPicked', $mattressPicked);
			
		$baseStatus='';
		$basePicked='n';
		$basedetails='';
		$basebay='';
		$basecount=0;
		if ($purchase['baserequired'] == 'y') {
			$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 3]);
				foreach ($query as $QCStatusRow) {
				$baseStatus=$QCStatusRow['QC_StatusID'];
				if (($baseStatus > 0 && $baseStatus < 50) || $baseStatus==90) {
					$tobedelivered.='Base<br>';
					};
				if ($baseStatus==50) {
					$query = $this->BayContent->find()->where(['orderId' => $ordernumber, 'componentId' => 3]);
					foreach ($query as $BayRow) {
					$basebay = $BayRow['bayNumber'];
						if ($basebay==40) {
							$basebay='Car';
						}	
						if ($basebay==42) {
							$basebay='NYW';
						}
						if ($basebay==43) {
							$basebay='NYU';
						}
						if ($basebay==43) {
							$basebay='NYD';
						}
					$basePicked='y';
					$basedetails .= "<table width=100% border=0 cellspacing=0px cellpadding=3px>";
					$basedetails .= "<tr><td valign=top><b>Model:</b> " .$purchase['basesavoirmodel'] ."</td>";
					$basesize='';
					if (!empty($psizes['Base1Width'])) {
						$basesize .= $psizes['Base1Width'] ."cm x ";
					} else {
						$basesize .= $purchase['basewidth'] ." x ";
					}
					if (!empty($psizes['Base1Length'])) {
						$basesize .= $psizes['Base1Length'] ."cm. ";
					} else {
						$basesize .= $purchase['baselength'] .". ";
					}
					if (!empty($psizes['Base2Width'])) {
						$basesize .= $psizes['Base2Width'] ."cm x ";
					}
					if (!empty($psizes['Base2Length'])) {
						$basesize .= $psizes['Base2Length'] ."cm. ";
					} 
					$basedetails .= "<td colspan=3 valign=top><b>Size (w x l):</b> " .$basesize ."</td>";
					
					$basedetails .= "</tr>";
					$basedetails .= "<tr><td valign=top><b>Link Position:</b> " .$purchase['linkposition'] ."</td>";
					$basedetails .= "<td valign=top><b>Link Finish:</b> " .$purchase['linkfinish'] ."</td>";
					$basedetails .= "<td valign=top><b>Ticking:</b> " .$purchase['basetickingoptions'] ."</td>";
					$basedetails .= "</tr>";
					$basedetails .= "<tr><td valign=top><b>Upholstered Base:</b> " .$purchase['upholsteredbase'] ."</td>";
					$basedetails .= "<td valign=top><b>Extended Base:</b> " .$purchase['extbase'] ."</td>";
					$basedetails .= "<td valign=top><b>Drawers:</b> " .$purchase['basedrawers'] ."</td>";
					$basedetails .= "</tr>";
					if (!empty($purchase['baseinstructions'])) {
					$basedetails .= "<tr><td colspan=4><p class=box>" .$purchase['baseinstructions'] ."</p></tr>";
					$pageheight +=1;
					}
					$basedetails .= "</table>";
					}
					if (substr($purchase['basetype'], 0, 3)=='Nor' || substr($purchase['basetype'], 0, 3)=='Eas') {
						if ($wraptype=='Crate') {
							$basecount=1;
							$itemsdelivered+=1;
							} else {
							$basecount=2;
							$itemsdelivered+=2;
							}
					}
					else {
					$basecount=1;
					$itemsdelivered+=1;
					}
					$itemcount=$basecount;
					$this->set('basedetails', $basedetails);
					$this->set('basecount', $basecount);
					$this->set('basebay', $basebay);
					
					}
				}
			}
		$this->set('basePicked', $basePicked);
			
		$topperStatus='';
		$topperPicked='n';
		$topperdetails='';
		$topperbay='';
		$toppercount=0;
		if ($purchase['topperrequired'] == 'y') {
			$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 5]);
				foreach ($query as $QCStatusRow) {
				$topperStatus=$QCStatusRow['QC_StatusID'];
				if (($topperStatus > 0 && $topperStatus < 50) || $topperStatus==90) {
					$tobedelivered.='Topper<br>';
					};
				if ($topperStatus==50) {
					$query = $this->BayContent->find()->where(['orderId' => $ordernumber, 'componentId' => 5]);
					foreach ($query as $BayRow) {
					$topperbay = $BayRow['bayNumber'];
						if ($topperbay==40) {
							$topperbay='Car';
						}	
						if ($topperbay==42) {
							$topperbay='NYW';
						}
						if ($topperbay==43) {
							$topperbay='NYU';
						}
						if ($topperbay==43) {
							$topperbay='NYD';
						}
					$topperPicked='y';
					$topperdetails .= "<table width=100% border=0 cellspacing=0px cellpadding=3px>";
					$topperdetails .= "<tr><td valign=top><b>Model:</b> " .$purchase['toppertype'] ."</td>";
					$toppersize='';
					if (!empty($psizes['topper1Width'])) {
						$toppersize .= $psizes['topper1Width'] ."cm x ";
					} else {
						$toppersize .= $purchase['topperwidth'] ." x ";
					}
					if (!empty($psizes['topper1Length'])) {
						$toppersize .= $psizes['topper1Length'] ."cm. ";
					} else {
						$toppersize .= $purchase['topperlength'] .". ";
					}
					$topperdetails .= "<td valign=top><b>Size (w x l):</b> " .$toppersize ."</td>";
					$topperdetails .= "<td valign=top><b>Ticking:</b> " .$purchase['toppertickingoptions'] ."</td>";
					$topperdetails .= "</tr>";
					if (!empty($purchase['specialinstructionstopper'])) {
					$topperdetails .= "<tr><td colspan=3><p class=box>" .$purchase['specialinstructionstopper'] ."</p></tr>";
					$pageheight +=1;
					}
					$topperdetails .= "</table>";
					}
					$toppercount=1;
					$itemcount=1;
					$itemsdelivered+=1;
					$this->set('topperdetails', $topperdetails);
					$this->set('toppercount', $toppercount);
					$this->set('topperbay', $topperbay);
					
					}
				}
			}
		$this->set('topperPicked', $topperPicked);
		
		
		$legsStatus='';
		$legsPicked='n';
		$legsdetails='';
		$legsbay='';
		$legscount=0;
		$legqty=0;
		if ($purchase['legsrequired'] == 'y') {
			$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 7]);
				foreach ($query as $QCStatusRow) {
				$legsStatus=$QCStatusRow['QC_StatusID'];
				if (($legsStatus > 0 && $legsStatus < 50) || $legsStatus==90) {
					$tobedelivered.='Legs<br>';
					};
				if ($legsStatus==50) {
					$query = $this->BayContent->find()->where(['orderId' => $ordernumber, 'componentId' => 7]);
					foreach ($query as $BayRow) {
					$legsbay = $BayRow['bayNumber'];
						if ($legsbay==40) {
							$legsbay='Car';
						}	
						if ($legsbay==42) {
							$legsbay='NYW';
						}
						if ($legsbay==43) {
							$legsbay='NYU';
						}
						if ($legsbay==43) {
							$legsbay='NYD';
						}
					$legsPicked='y';
					if (!empty($purchase['LegQty'])) {
						$legqty=intval($purchase['LegQty']);
					}
					if (!empty($purchase['AddLegQty'])) {
						$legqty=$legqty+intval($purchase['AddLegQty']);
					}
					$legsdetails .= "<table width=100% border=0 cellspacing=0px cellpadding=3px>";
					$legsdetails .= "<tr><td valign=top><b>Model:</b> " .$purchase['legstyle'] ."</td>";
					$legsdetails .= "<td valign=top><b>Leg Finish:</b> " .$purchase['legfinish'] ."</td>";
					$legsdetails .= "<td valign=top><b>Leg Height:</b> " .$purchase['legheight'] ."</td>";
					$legsdetails .= "<td valign=top><b>Leg Qty:</b> " .$legqty ."</td>";
					$legsdetails .= "</tr>";
					if (!empty($purchase['specialinstructionslegs'])) {
					$legsdetails .= "<tr><td colspan=4><p class=box>" .$purchase['specialinstructionslegs'] ."</p></tr>";
					$pageheight +=1;
					}
					$legsdetails .= "</table>";
					}
					$legscount=1;
					$itemcount=1;
					$itemsdelivered+=1;
					$this->set('legsdetails', $legsdetails);
					$this->set('legscount', $legscount);
					$this->set('legsbay', $legsbay);
					
					}
				}
			}
		$this->set('legsPicked', $legsPicked);
		
		$valanceStatus='';
		$valancePicked='n';
		$valancedetails='';
		$valancebay='';
		$valancecount=0;
		if ($purchase['valancerequired'] == 'y') {
			$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 6]);
				foreach ($query as $QCStatusRow) {
				$valanceStatus=$QCStatusRow['QC_StatusID'];
				if (($valanceStatus > 0 && $valanceStatus < 50) || $valanceStatus==90) {
					$tobedelivered.='Valance<br>';
					};
				if ($valanceStatus==50) {
					$query = $this->BayContent->find()->where(['orderId' => $ordernumber, 'componentId' => 6]);
					foreach ($query as $BayRow) {
					$valancebay = $BayRow['bayNumber'];
						if ($valancebay==40) {
							$valancebay='Car';
						}	
						if ($valancebay==42) {
							$valancebay='NYW';
						}
						if ($valancebay==43) {
							$valancebay='NYU';
						}
						if ($valancebay==43) {
							$valancebay='NYD';
						}
					$valancePicked='y';
					$valancedetails .= "<table width=100% border=0 cellspacing=0px cellpadding=3px>";
					$valancedetails .= "<tr><td colspan=2 valign=top><b>Fabric Selection:</b> " .$purchase['valancefabric'] ."</td>";
					$valancedetails .= "<td valign=top><b>No. of Pleats:</b> " .$purchase['pleats'] ."</td>";
					$valancedetails .= "</tr>";
					$valancedetails .= "<tr><td colspan=2 valign=top><b>Description:</b> " .$purchase['valancefabricchoice'] ."</td>";
					$valancedetails .= "<td valign=top><b>Direction:</b> " .$purchase['valancefabricdirection'] ."</td>";
					$valancedetails .= "</tr>";
					$valancedetails .= "<tr><td valign=top><b>Width:</b> " .$purchase['valancewidth'] ."</td>";
					$valancedetails .= "<td valign=top><b>Length:</b> " .$purchase['valancelength'] ."</td>";
					$valancedetails .= "<td valign=top><b>Drop:</b> " .$purchase['valancedrop'] ."</td>";
					$valancedetails .= "</tr>";
					if (!empty($purchase['specialinstructionsvalance'])) {
					$valancedetails .= "<tr><td colspan=4><p class=box>" .$purchase['specialinstructionsvalance'] ."</p></tr>";
					$pageheight +=1;
					}
					$valancedetails .= "</table>";
					}
					$valancecount=1;
					$itemcount=1;
					$itemsdelivered+=1;
					$this->set('valancedetails', $valancedetails);
					$this->set('valancecount', $valancecount);
					$this->set('valancebay', $valancebay);
					
					}
				}
			}
		$this->set('valancePicked', $valancePicked);	
		
		$hbStatus='';
		$hbPicked='n';
		$hbdetails='';
		$hbbay='';
		$hbcount=0;
		if ($purchase['headboardrequired'] == 'y') {
			$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 8]);
				foreach ($query as $QCStatusRow) {
				$hbStatus=$QCStatusRow['QC_StatusID'];
				if (($hbStatus > 0 && $hbStatus < 50) || $hbStatus==90) {
					$tobedelivered.='Headboard<br>';
					};
				if ($hbStatus==50) {
					$query = $this->BayContent->find()->where(['orderId' => $ordernumber, 'componentId' => 8]);
					foreach ($query as $BayRow) {
					$hbbay = $BayRow['bayNumber'];
						if ($hbbay==40) {
							$hbbay='Car';
						}	
						if ($hbbay==42) {
							$hbbay='NYW';
						}
						if ($hbbay==43) {
							$hbbay='NYU';
						}
						if ($hbbay==43) {
							$hbbay='NYD';
						}
					$hbPicked='y';
					$hbdetails .= "<table width=100% border=0 cellspacing=0px cellpadding=3px>";
					$hbdetails .= "<tr><td colspan=2 valign=top><b>Style:</b> " .$purchase['headboardstyle'] ."</td>";
					$hbdetails .= "<td valign=top><b>Finish:</b> " .$purchase['headboardfinish'] ."</td>";
					$hbdetails .= "<td valign=top><b>Height:</b> " .$purchase['headboardheight'] ."</td>";
					$hbdetails .= "</tr>";
					$hbdetails .= "<tr><td colspan=2 valign=top><b>Fabric Selection:</b> " .$purchase['headboardfabric'] ."</td>";
					$hbdetails .= "<td valign=top><b>Direction:</b> " .$purchase['headboardfabricdirection'] ."</td>";
					$hbdetails .= "</tr>";
					$hbdetails .= "<tr><td colspan=2 valign=top><b>Description:</b> " .$purchase['headboardfabricchoice'] ."</td>";
					$hbdetails .= "<td valign=top><b>Leg Qty:</b> " .$purchase['headboardlegqty'] ."</td>";
					$hbdetails .= "</tr>";
					if (!empty($purchase['specialinstructionshb'])) {
					$hbdetails .= "<tr><td colspan=4><p class=box>" .$purchase['specialinstructionsheadboard'] ."</p></tr>";
					$pageheight +=1;
					}
					$hbdetails .= "</table>";
					}
					$hbcount=1;
					$itemcount=1;
					$itemsdelivered+=1;
					$this->set('hbdetails', $hbdetails);
					$this->set('hbcount', $hbcount);
					$this->set('hbbay', $hbbay);
					
					}
				}
			}
		$this->set('hbPicked', $hbPicked);
		$this->set('tobedelivered', $tobedelivered);
		$itemsdelivered = '<p style=font-size:14px;text-align:right;margin-right:76px;><b>&nbsp;&nbsp;&nbsp;TOTAL BED ITEMS &nbsp;&nbsp;&nbsp;= &nbsp;&nbsp;&nbsp;' .$itemsdelivered .'</b></p>';
		$this->set('itemsdelivered', $itemsdelivered);
		
		$accdetails='';
		$accrequired='n';
		$acccount=0;
		if ($purchase['accessoriesrequired']=='y') {
			$accrequired='y';
		}
		$this->set('accrequired', $accrequired);
		$arrayOfIds=[110, 120, 130];
		$arrayOfIds2=[0,70,80,110, 120];
		$acc = $this->Accessory->find()->where(['purchase_no' => $pn, 'Status IN ' => $arrayOfIds, 'Status is not null']);
		$acctofollow = $this->Accessory->find()->where(['purchase_no' => $pn, 'OR' => ['Status NOT IN ' => $arrayOfIds2, 'Status is null']]);
		
		if ($purchase['accessoriesrequired'] == 'y') {
			$accdetails .= "<div class=c4><div class=comphdg><b>Accessories</b></div>";
			$accdetails .= "<table width=100% border=0 cellspacing=0 cellpadding=3 style=padding:10px;>";

			if ($acc->count()>0) {
			
			$accdetails .= "<tr style=font-size:12px;><td colspan=5>Accessories Delivered</td></tr>";
			
			$accqty=0;
			$accdetails .= "<tr style=font-size:12px;><td>Item Description<br>&nbsp;</td><td>Design</td><td>Colour</td><td>Size</td><td align=right>Qty</td></tr>";

				foreach ($acc as $accline) {
					$accqty=intval($accline['qty'])-intval($accline['QtyToFollow']);
					$acccount+=$accqty;
					$accdetails .= "<tr><td>" .$accline['description'] ."</td>";
					$accdetails .= "<td>" .$accline['design'] ."</td>";
					$accdetails .= "<td>" .$accline['colour'] ."</td>";
					$accdetails .= "<td>" .$accline['size'] ."</td>";
					$accdetails .= "<td align=right>" .$accqty ."</td>";
					$accdetails .= "</tr>";
					$accdetails .= "<tr><td colspan=5></td></tr>";
				}
			}
			
			if ($acctofollow->count()>0) {
				$accdetails .= "<tr style=font-size:12px;><td colspan=5>Accessories To Follow</td></tr>";
				$accdetails .= "<tr style=font-size:12px;><td>Item Description<br>&nbsp;</td><td>Design</td><td>Colour</td><td>Size</td><td align=right>Qty</td></tr>";
				$accqty=0;
				foreach ($acctofollow as $accline2) {
					$accqty=intval($accline2['qty'])-intval($accline2['QtyToFollow']);
					$accdetails .= "<tr><td>" .$accline2['description'] ."</td>";
					$accdetails .= "<td>" .$accline2['design'] ."</td>";
					$accdetails .= "<td>" .$accline2['colour'] ."</td>";
					$accdetails .= "<td>" .$accline2['size'] ."</td>";
					$accdetails .= "<td align=right>" .$accqty ."</td>";
					$accdetails .= "</tr>";
				}
			}
			$accdetails .= "</table></div> ";
		}
		$this->set('accdetails', $accdetails);
		
		$accitemsdelivered = '<p style=font-size:14px;><b>&nbsp;&nbsp;&nbsp;TOTAL ACCESSORIES DELIVERED &nbsp;&nbsp;&nbsp;= &nbsp;&nbsp;&nbsp;' .$acccount .'</b></p>';
		$this->set('accitemsdelivered', $accitemsdelivered);
		
		$signature = "<div class=colpayments><div class=ordersummaryhdg><b>Signature</b></div><div style=padding:5px; ><br><br><br><br><br><br><br><p>.....................................................................................&nbsp;Date:&nbsp;".date("d/m/Y")."</p></div>";
		$signature .= "</div>";
		
		$footer="<table width=100% border=0 cellspacing=0 cellpadding=3 style=position:absolute;bottom:110px;>";
		$footer.="<tr><td colspan=2><b>These items have been picked by:</b></td></tr>";
		$footer.="<tr><td>".$signature."</td><td>".$signature."</td></tr></table>";
		$this->set('footer', $footer);
		$pagebreak='';
		$pagebreak="<h5></h5>";
		
		$this->set('pagebreak', $pagebreak);	
	
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
