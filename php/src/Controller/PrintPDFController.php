<?php
declare(strict_types=1);

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class PrintPDFController extends SecureAppController {
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
        
        $proto = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') ? 'https' : 'http';
        
        $params = $this->request->getParam('?');
        $pn = $params['val'];
		if (isset($params['aw'])) {
			$aw = $params['aw'];
		} else {
			$aw='n';
		}
		if (isset($params['tandc'])) {
			$tandc = $params['tandc'];
		} else {
			$tandc='';
		}
		
        $query = $this->Purchase->find()->where(['PURCHASE_No' => $pn]);
		$purchase = null;
        $ordernumber = null;
		$orderdate = null;
		$salesusername = null;
		foreach ($query as $row) {
			$purchase = $row;
			
		}
		$ordernumber = $purchase['ORDER_NUMBER'];
		$orderdate = $purchase['ORDER_DATE']->i18nFormat('dd/MM/yyyy');
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
		$payments = TableRegistry::get('Payment');
		$activepayments = $payments->getPayments($pn);
		
		$query = $this->Wrappingtypes->find()->where(['WrappingID' => $purchase['wrappingid']]);
		$wrap = null;
		foreach ($query as $row) {
			$wrap = $row;
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
			if (!empty($row['terms']) && ($purchase['OWNING_REGION']==1 || $purchase['idlocation']==24 || $purchase['idlocation']==17 || $purchase['idlocation']==34 || $purchase['idlocation']==37)) {
				$termstext=$row['terms'];
				$termstext=str_replace("<p>","<div style=font-size:8px;>",$termstext);
			} else {
				$termstext='';
			}
		}
		$this->set('showroomaddress', $showroomaddress);
		$this->set('showroomtel', $showroomtel);
		$this->set('termstext', $termstext);
		$pageheight=1;
		
		$header='';
		$header .= "<p class=toplinespace><img src='webroot/img/logo.jpg' width='255' height='42' style='position:absolute;right:1px;top:40px;' /><br><span class=orderno>Order Number: " .$ordernumber ."</span><br>Order Date: " .$orderdate ."<br>Savoir Contact: " .$salesname ."<br>Showroom: " .$showroomaddress;
		if ($showroomtel != '') {
		$header .= "<br>" .$showroomtel;
		};
		$header .= "</p><hr style=margin-top:1px; margin-bottom:1px;>";
		$header .= "<div><img src='webroot/img/" . $this->QrCode->getOrderNumberImageUrl($ordernumber) . "' width='30px' height='30px'  style='position:absolute; top:90px;right:0px;'/></div>";

		$this->set('header', $header);
		
		$accessoriesonly='';
		if ($purchase['mattressrequired'] == 'n' && $purchase['baserequired'] == 'n' && $purchase['topperrequired'] == 'n' && $purchase['legsrequired'] == 'n' && $purchase['valancerequired'] == 'n' && $purchase['headboardrequired'] == 'n' && $purchase['accessoriesrequired'] == 'y') {
			$accessoriesonly='y';
		} 
		$this->set('accessoriesonly', $accessoriesonly);
		
		$accessoriesadd='';
		if (($purchase['mattressrequired'] == 'y' || $purchase['baserequired'] == 'y' || $purchase['topperrequired'] == 'y' || $purchase['legsrequired'] == 'y' || $purchase['valancerequired'] == 'y' && $purchase['headboardrequired'] == 'y') && $purchase['accessoriesrequired'] == 'y') {
			$accessoriesadd='y';
		} 
		$this->set('accessoriesadd', $accessoriesadd);
		
		$mattressdetails = '';
		if ($purchase['mattressrequired'] == 'y') {
				$mattressdetails .= "<div class=comphdg><b>Mattress</b></div>";
				$mattressdetails .= "<table width=100% border=0 style=margin-left:3px; class=prodtable><tr><td valign=top>Model: <b>" .$purchase['savoirmodel'] ."</b></td>";
				$mattressdetails .= "<td valign=top>Type: <b>" .$purchase['mattresstype'] ."</b></td>";
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
				$mattressdetails .= "<td valign=top>Size (w x l): <b>" .$mattsize ."</b></td>";
				$mattressdetails .= "<td valign=top>Ticking: <b>" .$purchase['tickingoptions'] ."</b></td>";
				if (!$this->_userHasRole("NOPRICESUSER")) {				
				$mattressdetails .= "<td rowspan=2 valign=top><div class=price>Price:<br><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['mattressprice'], $purchase['ordercurrency']) ."</b></div></td></tr>";
				} else {
					$mattressdetails .= "<td valign=top>&nbsp;</td></tr>";
				}
				$mattressdetails .= "<tr><td valign=top>LHS: <b>" .$purchase['leftsupport'] ."</b></td>";
				$mattressdetails .= "<td valign=top>RHS: <b>" .$purchase['rightsupport'] ."</b></td>";
				$mattressdetails .= "<td valign=top>Vent Position: <b>" .$purchase['ventposition'] ."</b></td>";
				$mattressdetails .= "<td valign=top>Vent Finish: <b>" .$purchase['ventfinish'] ."</b></td>";
				$mattressdetails .= "</tr>";
				if (!empty($purchase['mattressinstructions'])) {
				$mattressdetails .= "<tr><td colspan=4><p class=box>" .$purchase['mattressinstructions'] ."</p></tr>";
				$pageheight +=1;
				}
				$mattressdetails .= "</table>";

		}
		$this->set('mattressdetails', $mattressdetails);
		
		$basedetails = '';
		if ($purchase['baserequired'] == 'y') {
				$pageheight +=1;
				$basedetails .= "<div class=comphdg><b>Base</b></div>";
				$basedetails .= "<table width=100% border=0 style=margin-left:3px; class=prodtable><tr><td valign=top>Model: <b>" .$purchase['basesavoirmodel'] ."</b></td>";
				$basedetails .= "<td valign=top>Type: <b>" .$purchase['basetype'] ."</b></td>";
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
				$basedetails .= "<td valign=top>Size (w x l): <b>" .$basesize ."</b></td>";
				$basedetails .= "<td valign=top>Ticking: <b>";
				if ($purchase['basetickingoptions'] == 'n') {
				$basedetails .= "<b>None</b></td>";
				} else {
					$basedetails .= $purchase['basetickingoptions'] ."</b></td>";
				}
				if (!$this->_userHasRole("NOPRICESUSER")) {	
				$basedetails .= "<td rowspan=4 valign=top><div class=price>Price:<br><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['baseprice'], $purchase['ordercurrency']) ."</b>";
				if ($purchase['basetrim'] != 'n' && !empty($purchase['basetrim'])) {
					   $basedetails .= "<br>+TRIM:<br><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['basetrimprice'], $purchase['ordercurrency']) ."</b>";
				} 
				} else {
				$basedetails .= "<td valign=top>&nbsp;";
				}
				$basedetails .= "</div></td></tr>";
				$basedetails .= "<tr><td valign=top>Link Position: <b>" .$purchase['linkposition'] ."</b></td>";
				$basedetails .= "<td valign=top>Link Finish: <b>" .$purchase['linkfinish'] ."</b></td>";
				$basedetails .= "<td valign=top>Upholstered Base: <b>";
				if ($purchase['upholsteredbase'] == 'n' || empty($purchase['upholsteredbase'])) {
					 $basedetails .= "None</b></td>";
				} else {
					$basedetails .= $purchase['upholsteredbase'] ."</b></td>";
					$pageheight +=1;
				};
				$basedetails .= "<td valign=top></td></tr>";
				if ($purchase['BaseDrawers']=='Yes') {
					$basedetails .= "<tr><td valign=top>Drawers: <b>" .$purchase['basedrawerconfigID'] ."</b></td>";
					$basedetails .= "<td valign=top>Drawer Height: <b>" .$purchase['basedrawerheight'] ."</b></td>";
					$basedetails .= "<td valign=top>Spring Height: <b>" .$purchase['baseheightspring'] ."</b></td>";
					$basedetails .= "<td valign=top></td>";
					$basedetails .= "</tr>";
				} else {
					$basedetails .= "<tr><td valign=top>Spring Height: <b>" .$purchase['baseheightspring'] ."</b></td>";
					$basedetails .= "<td valign=top></td>";
					$basedetails .= "<td valign=top></td>";
					$basedetails .= "<td valign=top></td>";
					$basedetails .= "</tr>";
				}
				if (!empty($purchase['baseinstructions'])) {
				$basedetails .= "<tr><td colspan=4><p class=box>" .$purchase['baseinstructions'] ."</p></tr>";
				$pageheight +=1;
				};
				if ($purchase['upholsteredbase'] != 'n' && !empty($purchase['upholsteredbase'])) {
					$pageheight +=1;

					$basedetails .= "<tr><td valign=top>Fabric Selection: <b>" .$purchase['basefabric'] ."</b></td>";
					$basedetails .= "<td valign=top>Direction: <b>" .$purchase['basefabricdirection'] ."</b></td>";
					$basedetails .= "<td valign=top>Description: <b>" .$purchase['basefabricchoice'] ."</b></td>";
					$upholsteryprice = (intval($purchase['upholsteryprice'])+intval($purchase['basefabricprice']));
					$basedetails .= "<td  colspan=2 valign=top><div class=price>Price:<br><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($upholsteryprice, $purchase['ordercurrency']) ."</b></div></td>"; 
					$basedetails .= "</tr>";
				};
				if (!empty($purchase['basefabricdesc'])) {
					$pageheight +=1;
					$basedetails .= "<tr><td colspan=4><p class=box>Base Fabric Instructions" .$purchase['basefabricdesc'] ."</p></tr>";
				};
				$basedetails .= "<tr style=line-height:3px;><td colspan=4> &nbsp;</td></tr></table>";
		}
		$this->set('basedetails', $basedetails);

		$legdetails = '';
		if ($purchase['legsrequired'] == 'y') {
				$pageheight +=1;
				$legdetails .= "<div class=comphdg><b>Legs</b></div>";
				$legdetails .= "<table width=100% border=0 style=margin-left:3px; class=prodtable><tr><td valign=top>Leg Style/Finish: <b>" .$purchase['legstyle'] ."</b></td>";
				$legdetails .= "<td valign=top>Leg Finish: <b>" .$purchase['legfinish'] ."</b></td>";
				if ($purchase['legheight'] == null) {
					$legdetails .= "<td valign=top>Leg Height: <b>Unknown</b></td>";
				} else if (substr($purchase['legheight'], 0, 4)=='Spec') {
					$legdetails .= "<td valign=top>Leg Height: <b>" .$psizes['legheight'] ."cm</b></td>";
				} else {
					$legdetails .= "<td valign=top>Leg Height: <b>" .$purchase['legheight'] ."</b></td>";
				}
				if (!$this->_userHasRole("NOPRICESUSER")) {	
				$legdetails .= "<td rowspan=2 valign=top><div class=price>Price:<br><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['legprice'], $purchase['ordercurrency']) ."</b></div></td></tr>";
				} else {
					$legdetails .= "<td valign=top>&nbsp;</td></tr>";
				}
				$legdetails .= "<tr>";
				if (!empty($purchase['floortype'])) {
				$legdetails .= "<td valign=top>Floor Type: <b>" .$purchase['floortype'] ."</b></td>";
				}
				$legdetails .= "<td valign=top>Standard Legs: <b>" .$purchase['LegQty'] ."</b></td>";
				$legdetails .= "<td valign=top>Additional Legs: <b>" .$purchase['AddLegQty'] ."</b></td>";
				$legdetails .= "<td valign=top>Legs total: <b>" .(intval($purchase['LegQty'])+intval($purchase['AddLegQty'])) ."</b></td></tr>";
				if (!empty($purchase['specialinstructionslegs'])) {
					$pageheight +=1;
					$legdetails .= "<tr><td colspan=4><p class=box>Leg Instructions: " .$purchase['specialinstructionslegs'] ."</p></tr>";
				};
				$legdetails .= "</table>";

		};
		$this->set('legdetails', $legdetails);
		
		$topperdetails = '';
		if ($purchase['topperrequired'] == 'y') {
			$pageheight +=1;
				$topperdetails .= "<div class=comphdg><b>Topper</b></div>";
				$topperdetails .= "<table width=100% border=0 style=margin-left:3px; class=prodtable ><tr><td valign=top>Model: <b>" .$purchase['toppertype'] ."</b></td>";
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
				$topperdetails .= "<td valign=top>Size (w x l): <b>" .$toppersize ."</b></td>";	
				$topperdetails .= "</td>";		
				$topperdetails .= "<td valign=top>Ticking: <b>" .$purchase['toppertickingoptions'] ."</b></td>";
				if (!$this->_userHasRole("NOPRICESUSER")) {	
				$topperdetails .= "<td rowspan=2 valign=top><div class=price>Price:<br><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['topperprice'], $purchase['ordercurrency']) ."</b></div></td></tr>";
				} else {
					$topperdetails .= "<td valign=top>&nbsp;</td></tr>";
				}
				
				if (!empty($purchase['specialinstructionstopper'])) {
					$pageheight +=1;
					$topperdetails .= "<tr><td colspan=3><p class=box>Topper Instructions: " .$purchase['specialinstructionstopper'] ."</p></tr>";
				};
				$topperdetails .= "</table>";

		};
		$this->set('topperdetails', $topperdetails);
		
		$valancedetails = '';
		if ($purchase['valancerequired'] == 'y') {
			$pageheight +=1;
				$valancedetails .= "<div class=comphdg><b>Valance</b></div>";
				$valancedetails .= "<table width=100% border=0 style=margin-left:3px; class=prodtable ><tr><td colspan=2>No. of Pleats: <b>" .$purchase['pleats'] ."</b></td>";
				$valancedetails .= "<td colspan=2>Direction: <b>" .$purchase['valancefabricdirection'] ."</td>";
				$valancedetails .= "<td valign=top>Ticking: <b>" .$purchase['toppertickingoptions'] ."cm</b></td>";
				if (!$this->_userHasRole("NOPRICESUSER")) {	
				$valancedetails .= "<td rowspan=2 valign=top><div class=price>Price:<br><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['valanceprice'], $purchase['ordercurrency']) ."</b></div></td></tr>";
				} else {
					$valancedetails .= "<td valign=top>&nbsp;</td></tr>";
				}
				
				$valancedetails .= "<tr><td colspan=2>Valance Drop: <b>" .$purchase['valancedrop'] ."</b></td>";
				$valancedetails .= "<td colspan=2>Valance Width: <b>" .$purchase['valancewidth'] ."</td>";
				$valancedetails .= "<td valign=top colspan=2>Valance Length: <b>" .$purchase['valancelength'] ."cm</b></td></tr>";
				
				$valancedetails .= "<tr><td colspan=2>Fabric Selection: <b>" .$purchase['valancefabric'] ."</b></td>";
				$valancedetails .= "<td colspan=2>Description: <b>" .$purchase['valancefabricchoice'] ."</td>";
				$valancedetails .= "<td colspan=2 valign=top>&nbsp;</td></tr>";
				
				if (!empty($purchase['specialinstructionsvalance'])) {
					$pageheight +=1;
				$valancedetails .= "<tr><td colspan=5><p class=box>Valance Instructions: " .$purchase['specialinstructionsvalance'] ."</p></tr>";
				};
				$valancedetails .= "</table>";

		};
		$this->set('valancedetails', $valancedetails);
		
		$hbdetails = '';
		if ($purchase['headboardrequired'] == 'y') {
			$pageheight +=1;
				$hbdetails .= "<div class=comphdg><b>Headboard</b></div>";
				$hbdetails .= "<table width=100% border=0 style=margin-left:3px; class=prodtable >";
				$hbdetails .= "<tr><td valign=top>Style: <b>" .$purchase['headboardstyle'] ."</b></td>";

				if ($purchase['headboardstyle'] == 'Gorrivan Headboard & Footboard') {
				$hbdetails .= "<td valign=top>Headboard Finish: <b>" .$purchase['headboardfinish'] ."</b></td>";
				$hbdetails .= "<td valign=top>Footboard Finish: <b>" .$purchase['footboardfinish'] ."</td>";
				
					if (!$this->_userHasRole("NOPRICESUSER")) {	
					$hbdetails .= "<td rowspan=2 ><div class=price>Price:<br><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['headboardprice'], $purchase['ordercurrency']) ."</b></div></td></tr>";
					} else {
						$hbdetails .= "<td valign=top>&nbsp;</td></tr>";
					}
				$hbdetails .= "<tr><td valign=top>Headboard Height: <b>" .$purchase['headboardheight'] ."</td>";
				$hbdetails .= "<td valign=top>Legs: <b>" .$purchase['headboardlegqty'] ."</b></td>";
				$hbdetails .= "<td valign=top colspan=2>Footboard Height: <b>" .$purchase['footboardheight'] ."</td>";
				$hbdetails .= "</tr>";
				} else {
				$hbdetails .= "<td valign=top>Finish: <b>" .$purchase['headboardfinish'] ."</b></td>";
				$hbdetails .= "<td valign=top>Height: <b>" .$purchase['headboardheight'] ."</td>";
					if (!$this->_userHasRole("NOPRICESUSER")) {	
					$hbdetails .= "<td rowspan=2 valign=top><div class=price>Price:<br><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['headboardprice'], $purchase['ordercurrency']) ."</b></div></td></tr>";
					} else {
						$hbdetails .= "<td valign=top>&nbsp;</td></tr>";
					}
				$hbdetails .= "<tr><td valign=top>Legs: <b>" .$purchase['headboardlegqty'] ."</td>";
				$hbdetails .= "<td colspan=2 valign=top>Fabric Options: <b>" .$purchase['hbfabricoptions'] ."</b></td>";
				$hbdetails .= "</tr>";
				}
				if (!empty($purchase['specialinstructionsheadboard'])) {
					$pageheight +=1;
				$hbdetails .= "<tr><td colspan=3><p class=box>Headboard Instructions: " .$purchase['specialinstructionsheadboard'] ."</p></tr>";
				};
				if ($purchase['headboardstyle'] == 'Gorrivan Headboard & Footboard') {
				$hbdetails .= "<tr><td valign=top>Fabric Options: <b>" .$purchase['hbfabricoptions'] ."</b></td>";
				$hbdetails .= "<td valign=top colspan=2>Fabric Selection: <b>" .$purchase['headboardfabric'] ."</td>";
				$hbdetails .= "<td valign=top>Direction: <b>" .$purchase['headboardfabricdirection'] ."</td>";
				$hbdetails .= "</tr>";	
				$hbdetails .= "<tr><td colspan=4>Description: <b>" .$purchase['headboardfabricchoice'] ."</b></td>";
				} else {
				$hbdetails .= "<tr><td valign=top>Fabric Selection: <b>" .$purchase['headboardfabric'] ."</td>";
				$hbdetails .= "<td valign=top>Description: <b>" .$purchase['headboardfabricchoice'] ."</b></td>";
				$hbdetails .= "<td valign=top>Direction: <b>" .$purchase['headboardfabricdirection'] ."</td>";
				};
				
				if (!$this->_userHasRole("NOPRICESUSER")) {	
					$hbdetails .= "<td rowspan=2 valign=top><div class=price>Price:<br><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['hbfabricprice'], $purchase['ordercurrency']) ."</b></div></td></tr>";
					} else {
						$hbdetails .= "<td valign=top>&nbsp;</td></tr>";
					}
				
				if (!empty($purchase['headboardfabricdesc'])) {
					$pageheight +=1;
				$hbdetails .= "<tr><td colspan=3><p class=box>Fabric Instructions: " .$purchase['headboardfabricdesc'] ."</p></tr>";
				};
				$hbdetails .= "</table>";

		};
		$this->set('hbdetails', $hbdetails);
		$this->set('pageheight', $pageheight);
		$ordersummary='';
		$ordersummary .= "<div class=c4> ";
		$ordersummary .= "<div class=ordersummaryhdg><b>Order Summary - Order No." .$purchase['ORDER_NUMBER'] ."</b></div>";
		$ordersummary .= "<table width=100% border=0 style=margin-left:3px; > ";
		if ($purchase['mattressrequired'] == 'y') {
		$ordersummary .= "<tr><td>Mattress</td>";
		if (!$this->_userHasRole("NOPRICESUSER")) {	
					$ordersummary .= "<td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['mattressprice'], $purchase['ordercurrency']) ."</b></td></tr>";
					} else {
						$ordersummary .= "<td valign=top>&nbsp;</td></tr>";
					}
		};
		$uphbasewording='';
		if ($purchase['baserequired'] == 'y') {
			if ($purchase['upholsteredbase']=='Yes') {
				$uphbasewording='Base Upholstery Charge, and Fabric';
			} else if ($purchase['upholsteredbase']=='Yes, Com') {
				$uphbasewording='Base and Upholstery Charge';
			}
		$ordersummary .= "<tr><td>Base</td>";
		if (!$this->_userHasRole("NOPRICESUSER")) {	
					$ordersummary .= "<td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['baseprice'], $purchase['ordercurrency']) ."</b></td></tr>";
					if (!empty($purchase['basetrim']) && $purchase['basetrim'] != 'n') {
						$ordersummary .= "<tr><td>Base Trim</td><td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['basetrimprice'], $purchase['ordercurrency']) ."</b></td></tr>";
					}
					if ($purchase['basedrawers'] != 'No') {
						$ordersummary .= "<tr><td>Base Drawers</td><td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['basedrawersprice'], $purchase['ordercurrency']) ."</b></td></tr>";
					}
					} else {
						$ordersummary .= "<td valign=top>&nbsp;</td></tr>";
						if (!empty($purchase['basetrim']) && $purchase['basetrim'] != 'n') {
						$ordersummary .= "<tr><td>Base Trim</td><td align=right valign=top><b></b></td></tr>";
						}
						if ($purchase['basedrawers'] != 'No') {
						$ordersummary .= "<tr><td>Base Drawers</td><td align=right valign=top><b></b></td></tr>";
						}
					}
		
		};
		
		if ($purchase['legsrequired'] == 'y') {
		$ordersummary .= "<tr><td>Legs</td>";
		if (!$this->_userHasRole("NOPRICESUSER")) {	
					$ordersummary .= "<td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol((intval($purchase['legprice'])+intval($purchase['addlegprice'])), $purchase['ordercurrency']) ."</b></td></tr>";					
					} else {
						$ordersummary .= "<td valign=top>&nbsp;</td></tr>";
					}
		};
		
		if ($purchase['topperrequired'] == 'y') {
		$ordersummary .= "<tr><td>Topper</td>";
		if (!$this->_userHasRole("NOPRICESUSER")) {	
					$ordersummary .= "<td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['topperprice'], $purchase['ordercurrency']) ."</b></td></tr>";					
					} else {
						$ordersummary .= "<td valign=top>&nbsp;</td></tr>";
					}
		};
		$upholsteryprice = intval($purchase['upholsteryprice'])+intval($purchase['basefabricprice'])+intval($purchase['valfabricprice'])+intval($purchase['valanceprice']);
		
		if (!empty($upholsteryprice)) {
			$ordersummary .= "<tr><td>".$uphbasewording."</td><td align=right><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($upholsteryprice, $purchase['ordercurrency']) ."</b></td></tr>";
		}
		$hbwording='';
		if ($purchase['headboardrequired'] == 'y') {
			$headboardcost=$purchase['headboardprice'];
			if ($purchase['hbfabricoptions']=='Savoir Supply') {
				$hbwording='Headboard, including Fabric';
			} else {
				$hbwording='Headboard';
			}
			if ($purchase['hbfabricprice'] != null) {
			$headboardcost=$purchase['headboardprice'] + $purchase['hbfabricprice'];
			
			$ordersummary .= "<tr><td>".$hbwording."</td>";
			} else {
			$ordersummary .= "<tr><td>".$hbwording."</td>";
			}
		if (!$this->_userHasRole("NOPRICESUSER")) {	
					$ordersummary .= "<td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($headboardcost, $purchase['ordercurrency']) ."</b></td></tr>";					
					} else {
						$ordersummary .= "<td valign=top>&nbsp;</td></tr>";
					}
		};
		
		
		if ($purchase['accessoriesrequired'] == 'y') {
			if ($accessoriesonly=='y') {
				$ordersummary .= "<tr><td>Accessories</td>";
			} else {
				$ordersummary .= "<tr><td>Accessories (see next page for details)</td>";
			}
		if (!$this->_userHasRole("NOPRICESUSER")) {	
					$ordersummary .= "<td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['accessoriestotalcost'], $purchase['ordercurrency']) ."</b></td></tr>";					
					} else {
						$ordersummary .= "<td valign=top>&nbsp;</td></tr>";
					}
		};
		
		if (!empty($purchase['discount']) && $purchase['discount']>0.00) {
		$ordersummary .= "<tr><td>Discount</td>";
		$discountamount=0;
		if (!$this->_userHasRole("NOPRICESUSER")) {
					$discountamount=0;
					if ($purchase['discounttype'] == 'percent') {
						$discountamount=((intval($purchase['bedsettotal']) * intval($purchase['discount']))/100);
					} else { 
					$discountamount = $purchase['discount'];
					}
					$ordersummary .= "<td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($discountamount, $purchase['ordercurrency']) ."</b></td></tr>";					
					} else {
						$ordersummary .= "<td valign=top>&nbsp;</td></tr>";
					}
		};
		
		if ($purchase['istrade'] == 'y' && $purchase['tradediscount']>0.00) {
		$ordersummary .= "<tr><td>Trade Discount</td>";
		if (!$this->_userHasRole("NOPRICESUSER")) {
					$ordersummary .= "<td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['tradediscount'], $purchase['ordercurrency']) ."</b></td></tr>";					
					} else {
						$ordersummary .= "<td valign=top>&nbsp;</td></tr>";
					}
		};
		
		if ($purchase['deliverycharge'] == 'y' && $purchase['deliveryprice']>0.00) {
		$ordersummary .= "<tr><td>Delivery Charge</td>";
		if (!$this->_userHasRole("NOPRICESUSER")) {
					$ordersummary .= "<td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['deliveryprice'], $purchase['ordercurrency']) ."</b></td></tr>";					
					} else {
						$ordersummary .= "<td valign=top>&nbsp;</td></tr>";
					}
		};
		
		if ($purchase['quote'] == 'y') {
			$ordertext="Quote";
		} else {
			$ordertext="Order";
		}
		if ($purchase['OWNING_REGION'] == '23' || $purchase['OWNING_REGION'] == '4') {
			$vatwording = "Sales Tax";
			$ordertotalincvat = "<b>" .$ordertext ." Total, Inc Sales Tax</b>";
			$ordertotalexvat = $ordertext ." Total, Ex Sales Tax";
		} else {
			$vatwording = "VAT";
			$ordertotalincvat = "<b>" .$ordertext ." Total, Inc VAT</b>";
			$ordertotalexvat = $ordertext ." Total Ex. VAT";
			
		}
		
		if (!empty($purchase['totalexvat'])) {
		$ordersummary .= "<tr><td>" .$ordertotalexvat ."</td>";
		if (!$this->_userHasRole("NOPRICESUSER")) {
					$ordersummary .= "<td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['totalexvat'], $purchase['ordercurrency']) ."</b></td></tr>";					
					} else {
						$ordersummary .= "<td valign=top>&nbsp;</td></tr>";
					}
		}
		
		if (!empty($purchase['vat']) && $purchase['vat']>0.00) {
		$ordersummary .= "<tr><td>" .$vatwording ."</td>";
		if (!$this->_userHasRole("NOPRICESUSER")) {
					$ordersummary .= "<td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['vat'], $purchase['ordercurrency']) ."</b></td></tr>";					
					} else {
						$ordersummary .= "<td valign=top>&nbsp;</td></tr>";
					}
		}
		
		if (!empty($purchase['total'])) {
		$ordersummary .= "<tr><td>" .$ordertotalincvat ."</td>";
		if (!$this->_userHasRole("NOPRICESUSER")) {
					$ordersummary .= "<td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['total'], $purchase['ordercurrency']) ."</b></td></tr>";					
					} else {
						$ordersummary .= "<td valign=top>&nbsp;</td></tr>";
					}
		}
		
		$ordersummary .= "</table > ";
		$ordersummary .= "</div>";
		
		$this->set('ordersummary', $ordersummary);
		
		$deliverydetails='';
		$deliverydetails .= "<div class=c4><div style=padding:5px; ><table width=auto border=0 style=margin-left:3px; ><tr><td width='90px'>";
	
		if ($purchase['idlocation'] != '34') {
			$deliverydetails .= "<b>DELIVERY&nbsp;DATE:</b></td><td>";
			if (!empty($purchase['bookeddeliverydate'])) {
				$deliverydetails .= substr($purchase['bookeddeliverydate']->i18nFormat('yyyy-MM-dd'),0,10);
			} else if (!empty($purchase['deliverydate'])) {
				$deldate=$purchase['deliverydate']->format('d');
				if ($deldate=="15") {
					$deliverydetails .= "Approx. middle of " .$purchase['deliverydate']->format('F');
				}
				if ($deldate=="5") {
					$deliverydetails .= "Approx. beginning of " .$purchase['deliverydate']->format('F');
				}
				if ($deldate=="25") {
					$deliverydetails .= "Approx. end of " .$purchase['deliverydate']->format('F');
				}
			}
		}
		if ($accessoriesonly=='y') {
		} else {
		$deliverydetails .= "</td></tr><tr><td>Dispose of old bed:</td><td><b>" .$purchase['oldbed'];
		$deliverydetails .= "</b></td></tr><tr><td>Access Check:</td><td><b>" .$purchase['accesscheck'];
		$deliverydetails .= "</b></td></tr><tr><td>Floor Type:</td><td><b>" .$purchase['floortype'];
		}
		$deliverydetails .= "</b></td></tr><tr><td>Packaging:</td><td><b>" .$wrap['pdfwrapname'];
		$deliverydetails .= "</b></td></tr></table></div></div>";
		if ($purchase['quote'] != 'y') {
			if ($aw == 'y') {
				$deliverydetails .= "<p style='margin-top:20px; margin-bottom:10px;font-size:15px;'>Confirmation Code: <span style='font-size:25px;'>" .$purchase['OrderConfirmationCode'];
				$deliverydetails .= "</span></p><p>Savoir Beds Ltd standard terms and conditions apply.  All goods remain the property of Savoir Beds Ltd until payment is received in full.</p>";
			} else {
				$deliverydetails .= "<p style=margin-bottom:0px;>I have read and understood the terms and conditions on the reverse of this order form and accept them in full.</p>";
			}
		}
		$this->set('deliverydetails', $deliverydetails);
		
		$paymentsdetails='';
		if ($purchase['quote'] != 'y' && !$this->_userHasRole("NOPRICESUSER")) {
			$paymentsdetails .= "<div class=colpayments><div class=comphdg><b>Payments</b></div>";
			$paymentsdetails .= "<table width=100% border=0 cellspacing=0 cellpadding=3 style=font-size:8px; class=smalllh>";
			$paymentsdetails .= "<tr><td><strong>Type</strong></td><td><strong>Method</strong></td><td><strong>Date</strong></td><td><strong>Receipt No.</strong></td><td align=right><strong>Amount</strong></td></tr>";
  		
			foreach ($activepayments as $payment) {
				$paymentsdetails .= "<tr><td>" .$payment['paymenttype'] ."</td>";
				$paymentsdetails .= "<td>" .$payment['paymentmethod'] ."</td>";
				$paymentsdetails .= "<td>" .$payment['placed'] ."</td>";
				$paymentsdetails .= "<td>" .$payment['receiptno'] ."</td>";
				$paymentsdetails .= "<td align=right>" .UtilityComponent::formatMoneyWithHtmlSymbol($payment['amount'], $purchase['ordercurrency']) ."</td>";
				$paymentsdetails .= "</tr>";
			}
			$paymentsdetails .= "<tr><td colspan=4>Outstanding Balance</td><td align=right valign=top><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($purchase['balanceoutstanding'], $purchase['ordercurrency']) ."</b></td></tr>";
			$paymentsdetails .= "</table></div> ";
		}
		$this->set('paymentsdetails', $paymentsdetails);
		
		$customersig='';
		if ($purchase['quote'] != 'y' && $aw != 'y') {
		$customersig .= "<div class=colpayments><div class=ordersummaryhdg><b>Customers Signature</b></div><div style=padding:5px; ><br><br><br><br><br><br><br><p>.....................................................................................&nbsp;Date:&nbsp;".date("d/m/Y")."</p></div>";
		$customersig .= "</div> </div>";
		}
		$this->set('customersig', $customersig);
		
		$pagebreak='';
		$pagebreak="<h5></h5>";
		
		$this->set('pagebreak', $pagebreak);
		
		
		
		$accdetails='';
		$acc = $this->Accessory->find()->where(['purchase_no' => $pn]);
		
		if ($purchase['accessoriesrequired'] == 'y') {
			$accdetails .= "<div class=c4><div class=comphdg><b>Accessories</b></div>";
			$accdetails .= "<table width=100% border=0 cellspacing=0 cellpadding=3 >";
			$accdetails .= "<tr><td>Item Description</td><td>Design</td><td>Colour</td><td>Size</td><td align=right>Qty</td>";
			if (!$this->_userHasRole("NOPRICESUSER")) {	
  			$accdetails .= "<td align=right>Unit Price</td><td align=right>Total</td>";
			}
			$accdetails .= "</tr>";
			foreach ($acc as $accline) {
				$accdetails .= "<tr><td><b>" .$accline['description'] ."</b></td>";
				$accdetails .= "<td><b>" .$accline['design'] ."</b></td>";
				$accdetails .= "<td><b>" .$accline['colour'] ."</b></td>";
				$accdetails .= "<td><b>" .$accline['size'] ."</b></td>";
				$accdetails .= "<td align=right><b>" .$accline['qty'] ."</b></td>";
				if (!$this->_userHasRole("NOPRICESUSER")) {	
				$accdetails .= "<td align=right><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($accline['unitprice'], $purchase['ordercurrency']) ."</b></td>";
				$acctotal=($accline['unitprice']) * ($accline['qty']);
				$accdetails .= "<td align=right><b>" .UtilityComponent::formatMoneyWithHtmlSymbol($acctotal, $purchase['ordercurrency']) ."</b></td>";
				}
				$accdetails .= "</tr>";
				//$accdetails .= "<tr><td colspan=7>&nbsp;</tr>";
			}
			$accdetails .= "</table></div> ";
		}
		$this->set('accdetails', $accdetails);
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
		return array("ADMINISTRATOR","SALES");
	}

}

?>
