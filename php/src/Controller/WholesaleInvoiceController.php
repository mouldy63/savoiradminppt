<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class WholesaleInvoiceController extends SecureAppController
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
		$this->loadModel('Showroom');
		
	}
	
	public function index() {
		$purchaseTable = TableRegistry::get('Purchase');
		$wholesaleprices = TableRegistry::get('WholesalePrices');
        $this->viewBuilder()->setOptions([
            'pdfConfig' => [
                'orientation' => 'portrait',
            ]
        ]);
		$docroot=$_SERVER['DOCUMENT_ROOT'];
        $this->set('docroot', $docroot);
        
		$pn = $this->request->getQuery('pn');
		$invno = $this->request->getQuery('winvoiceno');
		$invdate = $this->request->getQuery('winvoicedate');
		$invdateobj=date_create_from_format("j/n/Y",$invdate);

		$wholesaleinvoiceTable = TableRegistry::get('WholesaleInvoices');
		$wholesaleinvoice = $wholesaleinvoiceTable->find()->where(['purchase_No' => $pn]);
		if ($wholesaleinvoice->count()==0) {				
				$wholesaleinvoicenew = $wholesaleinvoiceTable->newEntity([]);
				$wholesaleinvoicenew->wholesale_inv_no = $invno;
				$wholesaleinvoicenew->wholesale_inv_date = $invdateobj;
				$wholesaleinvoicenew->purchase_no = $pn;
				$wholesaleinvoiceTable->save($wholesaleinvoicenew);
		} else {
			$updatewholesalerow = $wholesaleinvoiceTable->get($pn);
			$updatewholesalerow->wholesale_inv_no = $invno;
			$updatewholesalerow->wholesale_inv_date = $invdateobj;
			$wholesaleinvoiceTable->save($updatewholesalerow);
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
		$orderdate = substr($purchase['ORDER_DATE'],0,10);
		$salesusername = $purchase['salesusername'];
		$idlocation = $purchase['idlocation'];
		$custref = $purchase['customerreference'];
		$contact = $purchase['contact_no'];
		$code = $purchase['CODE'];
		$currency = $purchase['ordercurrency'];
		$currencysymbol='';
		if ($currency=='GBP') {
			$currencysymbol='&pound;';
		}
		if ($currency=='USD') {
			$currencysymbol='&#36;';
		}
		if ($currency=='EUR') {
			$currencysymbol='&#8364;';
		}
		$this->set('ordernumber', $ordernumber);
		$this->set('orderdate', $orderdate);
		$this->set('currency', $currency);
		$this->set('currencysymbol', $currencysymbol);
		$query = $this->Contact->find()->where(['CONTACT_NO' => $contact]);
		$contact = null;
		foreach ($query as $row) {
			$contact = $row;
		}
		
		$query = $this->Showroom->find()->where(['ShowroomLocationID' => $idlocation]);
		$showroom = null;
		foreach ($query as $row) {
			$showroom = $row;
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
	
	$showroomhdg='';
	$query = $this->Location->find()->where(['idlocation' => $idlocation]);
		foreach ($query as $row) {
			$showroomaddress = '';
			$showroomtel='';
			if ($row['add1'] != '') {
				$showroomaddress .= $row['add1'] ."<br>";
			}
			if ($row['add2'] != '') {
				$showroomaddress .= $row['add2'] ."<br>";
			}
			if ($row['add3'] != '') {
				$showroomaddress .= $row['add3'] ."<br>";
			}
			if ($row['town'] != '') {
				$showroomaddress .= $row['town'] ."<br>";
			}
			if ($row['countystate'] != '') {
				$showroomaddress .= $row['countystate'] ."<br>";
			}
			if ($row['postcode'] != '') {
				$showroomaddress .= $row['postcode'] ."<br>";
			}
			$showroomhdg=$row['adminheading'];
		}
		$this->set('showroomaddress', $showroomaddress);
		
		$customerdetails = '<table width=100% border=0 cellspacing=0px cellpadding=1px style=padding:5px;>';
		$customerdetails .= '<tr><td width=20%><b>Invoice:</b></td><td width=80%>'. $invno .'</td></tr>';
		$customerdetails .= '<tr><td><b>Tax Point:</b></td><td>'. $invdate .'</td></tr>';
		$customerdetails .= '<tr><td><b>Our Ref:</b></td><td>'. $ordernumber .'</td></tr>';
		$customerdetails .= '<tr><td><b>Account:</b></td><td>'. $showroom['SageRef'] .'</td></tr>';
		$customerdetails .= '<tr><td><b>Your Order:</b></td><td>'. $custref .'</td></tr>';
		$customerdetails .= '<tr><td><b>Customer:</b></td><td>'. $contact['surname'] .'</td></tr>';
		$customerdetails .= '<tr><td><b>Showroom:</b></td><td>'. $showroomhdg .'</td></tr>';

		$customerdetails .= '</table>';
		
		$this->set('customerdetails', $customerdetails);
		
		
	
		$pageheight=1;
		
		$header='';
		$header .= "<p align='center' class='toplinespace'><img src='webroot/img/logo.jpg' width=255 height=42 style=position:relative;top:0px; />";
		
		$header .= "</p><p align='center'>1 Old Oak Lane London, NW10 6UD, UK<br>Telephone: +44 (0)20 8838 4838 Facsimile: +44 (0)20 8838 6660";
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
		
		
		$mattressdetails='';
		$invoicetotal=0;
		$mattressprice=0;
		if ($purchase['mattressrequired'] == 'y') {
				$getmattressprice = $wholesaleprices->getCompWholesalePrice($pn, 1 );
					if (count($getmattressprice) > 0) {
						$mattressprice = floatval($getmattressprice[0]['price']);
						$invoicetotal += $mattressprice;
					}
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
				$mattressdetails .= "<tr class='wholesalefont'><td valign=top>" .$purchase['savoirmodel'] ." Mattress";
				if ($purchase['tickingoptions'] != 'n') {
					$mattressdetails .= ", Ticking:</b> " .$purchase['tickingoptions'];
				}
				if ($purchase['mattresstype'] != 'n' && $purchase['mattresstype'] != null) {
					$mattressdetails .= ", Ticking:</b> " .$purchase['mattresstype'];
				}
				$mattressdetails .= "<br />Left Support: " .$purchase['leftsupport'] ." Right Support: " .$purchase['rightsupport'] ."</td>";
				$mattressdetails .= "<td valign=top>" .$mattsize ."</td>";
				$mattressdetails .= "<td valign=top align='center'>1</td>";
				$mattressdetails .= "<td valign=top align='right'>" .number_format($mattressprice, 2) ."</td>";
				$mattressdetails .= "<td valign=top align='right'>" .number_format($mattressprice, 2) ."</td></tr>";
				
			}
			$this->set('mattressdetails', $mattressdetails);
		
			
		$basedetails='';
		$baseprice=0;
		$uphbaseprice=0;
		$basetrimprice=0;
		$drawersprice=0;
		if ($purchase['baserequired'] == 'y') {
			$basesize='';
			$getbaseprice = $wholesaleprices->getCompWholesalePrice($pn, 3 );
			if (count($getbaseprice) > 0) {
				$baseprice = floatval($getbaseprice[0]['price']);
				$invoicetotal += $baseprice;
			}
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
			$basedetails .= "<tr class='wholesalefont'><td valign=top>" .$purchase['basesavoirmodel'] ." Base";
			if ($purchase['basetickingoptions'] != 'n') {
				$basedetails .= ", " .$purchase['basetickingoptions'];
			}
			if ($purchase['basetype'] != 'n') {
				$basedetails .= ", " .$purchase['basetype'];
			}
			$basedetails .= "</td><td valign=top>" .$basesize ."</td>";
			$basedetails .= "<td valign=top align='center'>1</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($baseprice, 2) ."</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($baseprice, 2) ."</td></tr>";
			if (substr($purchase['upholsteredbase'], 0, 3) == 'Yes') {
				$getuphbaseprice = $wholesaleprices->getCompWholesalePrice($pn, 12 );
					if (count($getuphbaseprice) > 0) {
						$uphbaseprice = floatval($getuphbaseprice[0]['price']);
						$invoicetotal += $uphbaseprice;
					}
			$basedetails .= "<tr class='wholesalefont'><td valign=top>Upholstered Base<br /></td>";
			$basedetails .= "<td valign=top align='center'>&nbsp;</td>";
			$basedetails .= "<td valign=top align='center'>1</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($uphbaseprice, 2) ."</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($uphbaseprice, 2) ."</td></tr>";
			}
			
			if ($purchase['basetrim'] != 'n' && $purchase['basetrim'] != null) {
				$getbasetrim = $wholesaleprices->getCompWholesalePrice($pn, 11 );
					if (count($getbasetrim) > 0) {
						$basetrimprice = floatval($getbasetrim[0]['price']);
						$invoicetotal += $basetrimprice;
					}
			$basedetails .= "<tr class='wholesalefont'><td valign=top>Base Trim<br /></td>";
			$basedetails .= "<td valign=top align='center'>&nbsp;</td>";
			$basedetails .= "<td valign=top align='center'>1</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($basetrimprice, 2) ."</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($basetrimprice, 2) ."</td></tr>";
			}
			
			if ($purchase['basedrawers'] == 'Yes') {
				$getdrawersprice = $wholesaleprices->getCompWholesalePrice($pn, 13 );
					if (count($getdrawersprice) > 0) {
						$drawersprice = floatval($getdrawersprice[0]['price']);
						$invoicetotal += $drawersprice;
					}
			$basedetails .= "<tr class='wholesalefont'><td valign=top>Drawers<br /></td>";
			$basedetails .= "<td valign=top align='center'>&nbsp;</td>";
			$basedetails .= "<td valign=top align='center'>1</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($drawersprice, 2) ."</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($drawersprice, 2) ."</td></tr>";
			}
			$basefabricmeters=0;
			$fabricpricetotal=0;
			$basefabricmeters=0;
			if (substr($purchase['upholsteredbase'], 0, 3) == 'Yes') {
				$getfabricprice = $wholesaleprices->getCompWholesalePrice($pn, 17 );
					if (count($getfabricprice) > 0) {
						$fabricprice = floatval($getfabricprice[0]['price']);
						if ($purchase['basefabricmeters'] != '') {
							$fabricpricetotal =  $fabricprice * $purchase['basefabricmeters'];
							$invoicetotal += $fabricpricetotal;
						} else {
							$fabricpricetotal =  $fabricprice;
							$invoicetotal += $fabricprice;
						}
						
					}
			$basedetails .= "<tr class='wholesalefont'><td valign=top>Base Fabric " .$purchase['basefabric'] ."<br>" .$purchase['basefabricchoice'];		
			$basedetails .= "<td valign=top align='left'>Meters</td>";	
			$basedetails .= "<td valign=top align='center'>".$purchase['basefabricmeters']."</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($fabricprice, 2) ."</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($fabricpricetotal, 2) ."</td></tr>";
			}
		}
		$this->set('basedetails', $basedetails);
			
		$topperdetails='';
		$topperprice=0;
		if ($purchase['topperrequired'] == 'y') {
			$gettopperprice = $wholesaleprices->getCompWholesalePrice($pn, 5 );
			if (count($gettopperprice) > 0) {
				$topperprice = floatval($gettopperprice[0]['price']);
				$invoicetotal += $topperprice;
			}
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
			$topperdetails .= "<tr class='wholesalefont'><td valign=top>" .$purchase['toppertype'];
			if ($purchase['toppertickingoptions'] != 'n') {
					$topperdetails .= "<br />" .$purchase['toppertickingoptions'];
			}
			$topperdetails .= "</td><td valign=top>" .$toppersize ."</td>";
			$topperdetails .= "<td valign=top align='center'>1</td>";
			$topperdetails .= "<td valign=top align='right'>" .number_format($topperprice, 2) ."</td>";
			$topperdetails .= "<td valign=top align='right'>" .number_format($topperprice, 2) ."</td>";
			$topperdetails .= "</tr>";
		}
		$this->set('topperdetails', $topperdetails);
		
		
		$legsdetails='';
		$legqty=0;
		$addlegqty=0;
		$legprice=0;
		$addlegprice=0;
		$totallegprice=0;
		$totaladdlegprice=0;
		if ($purchase['legsrequired'] == 'y') {
			if (!empty($purchase['LegQty'])) {
				$legqty=intval($purchase['LegQty']);
			}
			if (!empty($purchase['AddLegQty'])) {
				$addlegqty=intval($purchase['AddLegQty']);
			}
			$getlegprice = $wholesaleprices->getCompWholesalePrice($pn, 7 );
			if (count($getlegprice) > 0) {
				$legprice = floatval($getlegprice[0]['price']);
				$totallegprice=$legprice * $legqty;
				$invoicetotal += $legprice * $legqty;
			}
			$getsupportlegprice = $wholesaleprices->getCompWholesalePrice($pn, 16 );
			if (count($getsupportlegprice) > 0) {
				$addlegprice = floatval($getsupportlegprice[0]['price']);
				$totaladdlegprice=$addlegprice * $addlegqty;
				$invoicetotal += $addlegprice * $addlegqty;
			}
		
			$legsdetails .= "<tr class='wholesalefont'><td valign=top>" .$purchase['legstyle'] ." Legs<br />" .$purchase['legfinish'] ."</td>";			
			$legsdetails .= "<td valign=top>" .$purchase['legheight'] ."</td>";
			$legsdetails .= "<td valign=top align=center>" .$legqty ."</td>";
			$legsdetails .= "<td valign=top align='right'>" .number_format($legprice, 2) ."</td>";
			$legsdetails .= "<td valign=top align='right'>" .number_format($totallegprice, 2) ."</td>";
			$legsdetails .= "</tr>";
			
			$legsdetails .= "<tr class='wholesalefont'><td valign=top>" .$purchase['addlegstyle'] ." Support Legs<br />" .$purchase['addlegfinish'] ."</td>";			
			$legsdetails .= "<td valign=top>&nbsp;</td>";
			$legsdetails .= "<td valign=top align=center>" .$addlegqty ."</td>";
			$legsdetails .= "<td valign=top align='right'>" .number_format($addlegprice, 2) ."</td>";
			$legsdetails .= "<td valign=top align='right'>" .number_format($totaladdlegprice, 2) ."</td>";
			$legsdetails .= "</tr>";
		}
		$this->set('legsdetails', $legsdetails);
		
		$valancedetails='';
		$valancefabricprice=0;
		$valanceprice=0;
		$valancesize='';
		$valancefabrictotalprice='';
		if ($purchase['valancerequired'] == 'y') {
			$getvalancefabricprice = $wholesaleprices->getCompWholesalePrice($pn, 18 );
			if (count($getvalancefabricprice) > 0) {
				$valancefabricprice = floatval($getvalancefabricprice[0]['price']);
				if ($purchase['valfabricmeters'] != '' && $purchase['valfabricmeters'] != 0 && $purchase['valfabricmeters'] != null) {
					$valancefabrictotalprice = $valancefabricprice * $purchase['valfabricmeters'];
					$invoicetotal += $valancefabrictotalprice;
				} else {
					$invoicetotal += $valancefabricprice;
				}
			}
			$getvalanceprice = $wholesaleprices->getCompWholesalePrice($pn, 6 );
			if (count($getvalanceprice) > 0) {
				$valanceprice = floatval($getvalanceprice[0]['price']);
				$invoicetotal += $valanceprice;
			}
			
			if ($purchase['valancedrop'] !='') {
				$valancesize = $purchase['valancedrop'] ." x ";
			}
			if ($purchase['valancewidth'] !='') {
				$valancesize .= $purchase['valancewidth'] ." x ";
			}
			if ($purchase['valancelength'] !='') {
				$valancesize .= $purchase['valancelength'] ."cm";
			}
			$valancedetails .= "<tr class='wholesalefont'><td valign=top>Valance</td>";
			$valancedetails .= "<td valign=top>Size: " .$valancesize ."</td>";
			$valancedetails .= "<td valign=top align=center>1</td>";
			$valancedetails .= "<td valign=top align='right'>" .number_format($valanceprice, 2) ."</td>";
			$valancedetails .= "<td valign=top align='right'>" .number_format($valanceprice, 2) ."</td>";
			$valancedetails .= "</tr>";
			
			if ($valancefabricprice != 0) {
				$valancedetails .= "<tr class='wholesalefont'><td valign=top>Valance Fabric: " .$purchase['valancefabricchoice']. "</td>";
				$valancedetails .= "<td valign=top>Meters</td>";
				$valancedetails .= "<td valign=top align=center>".$purchase['valfabricmeters']."</td>";
				$valancedetails .= "<td valign=top align='right'>" .number_format($valancefabricprice, 2) ."</td>";
				$valancedetails .= "<td valign=top align='right'>" .number_format($valancefabrictotalprice, 2) ."</td>";
				$valancedetails .= "</tr>";
			}
		}
		$this->set('valancedetails', $valancedetails);
		
		$hbdetails='';
		$hbwidth='';
		$hbtrimprice='';
		$hbprice='';
		$hbfabricprice='';
		$hbfabrictotalpric='';
		if ($purchase['headboardrequired'] == 'y') {
			if ($purchase['headboardWidth'] !='' && $purchase['headboardWidth'] !='n') {
				$hbwidth=$purchase['headboardWidth'];
			}
			
			if ($hbwidth=='') {
				if ($purchase['basewidth'] != '' && $purchase['basewidth'] != 'n' && substr($purchase['basewidth'], 0, 4) != 'Spec') {
					$hbwidth=preg_replace("/[^0-9.]/", "", $purchase['basewidth']);
				}
			}
			if ($hbwidth=='') {
				if ($purchase['mattresswidth'] != '' && $purchase['mattresswidth'] != 'n' && substr($purchase['mattresswidth'], 0, 4) != 'Spec') {
					$hbwidth=preg_replace("/[^0-9.]/", "", $purchase['basewidth']);
				}
			}
			if ($purchase['baserequired']=='y') {
				if ($hbwidth=='' && substr($purchase['basewidth'], 0, 4) == 'Spec') {
					$hbwidth=$psizes['Base1Width'];
					if ($psizes['Base2Width'] != null) {
						$hbwidth=$psizes['Base1Width'] + $psizes['Base2Width'];
					}
				}
			}
			if ($purchase['mattressrequired']=='y') {
				if ($hbwidth=='' && substr($purchase['mattresswidth'], 0, 4) == 'Spec') {
					$hbwidth=$psizes['Matt1Width'];
					if ($psizes['Matt2Width'] != null) {
						$hbwidth=$psizes['Matt1Width'] + $psizes['Matt2Width'];
					}
				}
			}
			if ($hbwidth != '') {
				$hbwidth = $hbwidth ." cm wide";
			}
			$gethbtrimprice = $wholesaleprices->getCompWholesalePrice($pn, 10 );
			if (count($gethbtrimprice) > 0) {
				$hbtrimprice = floatval($gethbtrimprice[0]['price']);
				$invoicetotal += $hbtrimprice;
			}
			$gethbfabricprice = $wholesaleprices->getCompWholesalePrice($pn, 15 );
			if (count($gethbfabricprice) > 0) {
				$hbfabricprice = floatval($gethbfabricprice[0]['price']);
				if ($purchase['hbfabricmeters'] !=0 && $purchase['hbfabricmeters'] != null && $purchase['hbfabricmeters'] !='') {
					$hbfabrictotalprice = $hbfabricprice * $purchase['hbfabricmeters'];
				} else {
					$hbfabrictotalprice=$hbfabricprice;
				}
				$invoicetotal += $hbfabrictotalprice;
			}
			$gethbprice = $wholesaleprices->getCompWholesalePrice($pn, 8 );
			if (count($gethbprice) > 0) {
				$hbprice = floatval($gethbprice[0]['price']);
				$invoicetotal += $hbprice;
			}
	
			$hbdetails .= "<tr class='wholesalefont'><td valign=top>" .$purchase['headboardstyle'] ." Headboard</td>";
			$hbdetails .= "<td valign=top>". $hbwidth ."</td>";
			$hbdetails .= "<td valign=top align=center>1</td>";
			$hbdetails .= "<td valign=top align='right'>" .number_format($hbprice, 2) ."</td>";
			$hbdetails .= "<td valign=top align='right'>" .number_format($hbprice, 2) ."</td>";
			$hbdetails .= "</tr>";
			if ($purchase['hbfabricoptions'] !='' && $purchase['hbfabricoptions'] !='TBC' && $purchase['hbfabricoptions'] !=null) {
				$hbdetails .= "<tr class='wholesalefont'><td valign=top>Headboard Fabric " .$purchase['headboardfabric'] ."<br>".$purchase['headboardfabricchoice']."</td>";
				$hbdetails .= "<td valign=top>Meters</td>";
				$hbdetails .= "<td valign=top align=center>".$purchase['hbfabricmeters']."</td>";
				$hbdetails .= "<td valign=top align='right'>" .number_format($hbfabricprice, 2) ."</td>";
				$hbdetails .= "<td valign=top align='right'>" .number_format($hbfabrictotalprice, 2) ."</td>";
				$hbdetails .= "</tr>";
			}
			if ($purchase['manhattantrim'] !='' && $purchase['manhattantrim'] !='--') {
				$hbdetails .= "<tr class='wholesalefont'><td valign=top>Headboard Trim " .$purchase['manhattantrim'] ."<br>".$purchase['headboardfabricchoice']."</td>";
				$hbdetails .= "<td valign=top>&nbsp</td>";
				$hbdetails .= "<td valign=top align=center>1</td>";
				$hbdetails .= "<td valign=top align='right'>" .number_format($hbtrimprice, 2) ."</td>";
				$hbdetails .= "<td valign=top align='right'>" .number_format($hbtrimprice, 2) ."</td>";
				$hbdetails .= "</tr>";
			}
			
		}	
		$this->set('hbdetails', $hbdetails);	
		
		$accdetails='';
		$acctotal='';
		$accqty='';	
		if ($purchase['accessoriesrequired'] == 'y') {
			$acc = $this->Accessory->find()->where(['purchase_no' => $pn]);	
				foreach ($acc as $accline) {
					$acctotal=0;
					$acctotal=$accline['wholesalePrice'] * $accline['qty'];
					$accdetails .= "<tr class='wholesalefont'><td>" .$accline['description'] ." ".$accline['colour']."".$accline['design']."</td>";
					$accdetails .= "<td>" .$accline['size'] ."</td>";
					$accdetails .= "<td align=center>" .$accline['qty'] ."</td>";
					$accdetails .= "<td valign=top align='right'>" .number_format($accline['wholesalePrice'], 2) ."</td>";
					$accdetails .= "<td valign=top align='right'>" .number_format($acctotal, 2) ."</td>";
					$accdetails .= "</tr>";
					$invoicetotal += $acctotal;
				}
			}
			
		$this->set('accdetails', $accdetails);
		
		$setinvoicetotal=0;
		$setinvoicetotal=number_format($invoicetotal, 2);
		$this->set('setinvoicetotal', $setinvoicetotal);
		$this->set('currencysymbol', $currencysymbol);
		
		$footer='';
		$footer .= "<br><table width=100% border=0 cellspacing=0 cellpadding=2 class=wholesalefont><tr><td width=10% valign=top style='line-height:14px;'>Notes:</td>";
		if ($showroom['InvoiceNote1'] != '') {
		$footer .= "<td align=left>1. " .$showroom['InvoiceNote1'] ."<br>";
		} else {
			$footer .= "<td>&nbsp;</td></tr>";
		}
		if ($showroom['InvoiceNote2'] != '') {
			$footer .= "2. " .$showroom['InvoiceNote2'] ."<br>";
		}
		if ($showroom['InvoiceNote3'] != '') {
			$footer .= "3. " .$showroom['InvoiceNote3'] ."<br>";
		}
		if ($showroom['InvoiceNote4'] != '') {
			$footer .= "4. " .$showroom['InvoiceNote4'] ."<br>";
		}
		if ($showroom['InvoiceNote5'] != '') {
			$footer .= "5. " .$showroom['InvoiceNote5'] ."<br>";
		}
		if ($showroom['InvoiceNote6'] != '') {
			$footer .= "6. " .$showroom['InvoiceNote6'] ."<br>";
		}
		if ($showroom['PaymentTerms'] != '' && $showroom['TermsEnabled'] == 'y') {
			$invdatepublish='';
			$invdatepublish=date_add($invdateobj, date_interval_create_from_date_string($showroom['PaymentTerms'] .' days'));
			$weekday = date('N', $invdatepublish->getTimestamp());
			if ($weekday==6) {
				$invdatepublish=date_add($invdatepublish, date_interval_create_from_date_string('2 days'));
			};
			if ($weekday==7) {
				$invdatepublish=date_add($invdatepublish, date_interval_create_from_date_string('1 days'));
			};
			 
			$footer .= "7. Payment due on: " .date_format($invdatepublish,"d/m/Y") ."<br>";
		}
		$footer .= "</td></tr></table><br><br><table width=100% border=0 cellspacing=0 cellpadding=1 class=wholesalefont><tr><td width=10% valign=top>Bank Details:</td>";
		if ($showroom['BankAcName'] != '') {
		$footer .= "<td align=left width=15%>Account Name:</td><td>" .$showroom['BankAcName'] ."</td></tr>";
		} else {
			$footer .= "<td>&nbsp;</td><td>&nbsp;</td></tr>";
		}
		if ($showroom['BankAcNo'] != '') {
		$footer .= "<tr><td>&nbsp;</td><td align=left width=10%>Account Number:</td><td>" .$showroom['BankAcNo'] ."</td></tr>";
		}
		if ($showroom['BankSortCode'] != '') {
		$footer .= "<tr><td>&nbsp;</td><td align=left width=10%>Sort Code:</td><td>" .$showroom['BankSortCode'] ."</td></tr>";
		}
		if ($showroom['BankRoutingNo'] != '') {
		$footer .= "<tr><td>&nbsp;</td><td align=left width=10%>Bank Routing No:</td><td>" .$showroom['BankRoutingNo'] ."</td></tr>";
		}
		if ($showroom['BankAddress'] != '') {
		$footer .= "<tr><td>&nbsp;</td><td align=left width=10%>Bank Address:</td><td>" .$showroom['BankAddress'] ."</td></tr>";
		}
		if ($showroom['IBAN'] != '') {
		$footer .= "<tr><td>&nbsp;</td><td align=left width=10%>IBAN:</td><td>" .$showroom['IBAN'] ."</td></tr>";
		}
		if ($showroom['SWIFT'] != '') {
		$footer .= "<tr><td>&nbsp;</td><td align=left width=10%>SWIFT:</td><td>" .$showroom['SWIFT'] ."</td></tr>";
		}
		$footer .= "</table>";
		$footer .= "<br><p align=center><b>PAYMENT DUE</b><br>VAT Reg. No. GB 706 8175 27<br>Savoir Beds Limited, Registered in England No. 3395749<br>Registered Office: 1 Old Oak Lane, London NW10 6UD, UK. Email: accounts@savoirbeds.co.uk<br><br>All goods remain the property of Savoir Beds Ltd until payment is received in full.";
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
