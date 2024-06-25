<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class SavoirInvoiceController extends SecureAppController
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
		$this->loadModel('ExportLinks');
		$this->loadModel('ExportCollShowroom');
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
        
		$pn = $this->request->getQuery('pno');
		$invno = $this->request->getQuery('invno');
		
		//$invdate = $this->request->getQuery('winvoicedate');
		//$invdateobj=date_create_from_format("j/n/Y",$invdate);	
		
	
		$query = $this->ExportLinks->find()->where(['purchase_no' => $pn, 'InvoiceNo' => $invno]);
		$invoicemattress='n';
		$invoicebase='n';
		$invoicetopper='n';
		$invoicevalance='n';
		$invoicelegs='n';
		$invoicehb='n';		
		$invoiceacc='n';

		foreach ($query as $row) {
			$exportlinks = $row;
			if ($exportlinks['componentID']==1) {
			$invoicemattress='y';
			}
			if ($exportlinks['componentID']==3) {
			$invoicebase='y';
			}
			if ($exportlinks['componentID']==5) {
			$invoicetopper='y';
			}
			if ($exportlinks['componentID']==6) {
			$invoicevalance='y';
			}
			if ($exportlinks['componentID']==7) {
			$invoicelegs='y';
			}
			if ($exportlinks['componentID']==8) {
			$invoicehb='y';
			}
			if ($exportlinks['componentID']==9) {
			$invoiceacc='y';
			}
		}
		
		$invdate=$exportlinks['InvoiceDate'];
		$linkscollectionid=$exportlinks['LinksCollectionID'];
		
		$query = $this->ExportCollShowroom->find()->where(['exportCollshowroomsID' => $linkscollectionid]);
		foreach ($query as $row) {
			$exportshowroom = $row;
		}
		$showroomid=$exportshowroom['idLocation'];
			
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
		
		$query = $this->Showroom->find()->where(['ShowroomLocationID' => $showroomid]);
		$showroom = null;
		foreach ($query as $row) {
			$showroom = $row;
		}
		$showroomaddress='';
		if (isset($showroom['InvoiceCoName'])) {
				$showroomaddress .= $showroom['InvoiceCoName'] ."<br>";
			}
			if (isset($showroom['InvoiceAdd1'])) {
				$showroomaddress .= $showroom['InvoiceAdd1'] ."<br>";
			}
			if (isset($showroom['InvoiceAdd2'])) {
				$showroomaddress .= $showroom['InvoiceAdd2'] ."<br>";
			}
			if (isset($showroom['InvoiceAdd3'])) {
				$showroomaddress .= $showroom['InvoiceAdd3'] ."<br>";
			}
			if (isset($showroom['InvoiceTown'])) {
				$showroomaddress .= $showroom['InvoiceTown'] ."<br>";
			}
			if (isset($showroom['InvoiceCountry'])) {
				$showroomaddress .= $showroom['InvoiceCountry'] ."<br>";
			}
			if (isset($showroom['InvoicePostcode'])) {
				$showroomaddress .= $showroom['InvoicePostcode'] ."<br>";
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
	$query = $this->Location->find()->where(['idlocation' => $showroomid]);
		foreach ($query as $row) {
			$showroomhdg=$row['adminheading'];
		}
		$this->set('showroomaddress', $showroomaddress);
		$sageref='';
		if (isset($showroom['SageRef'])) {
			$sageref=$showroom['SageRef'];
		}
		
		$customerdetails = '';
		$customerdetails .= '<tr><td width=20%><b>Invoice:</b></td><td width=80%>'. $invno .'</td></tr>';
		$customerdetails .= '<tr><td><b>Tax Point:</b></td><td>'. $invdate .'</td></tr>';
		$customerdetails .= '<tr><td><b>Our Ref:</b></td><td>'. $ordernumber .'</td></tr>';
		$customerdetails .= '<tr><td><b>Account:</b></td><td>'. $sageref .'</td></tr>';
		$customerdetails .= '<tr><td><b>Your Order:</b></td><td>'. $custref .'</td></tr>';
		
		$this->set('customerdetails', $customerdetails);
		
		
	
		$pageheight=1;
		
		$header='';
		$header .= "<p align='center' class=toplinespace><img src='webroot/img/logo.jpg' width=255 height=42 style=position:relative;top:0px; />";
		
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
		if ($purchase['mattressrequired'] == 'y' && $invoicemattress=='y') {
				$mattressprice = floatval($purchase['mattressprice']);
				$invoicetotal += $mattressprice;

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
		if ($purchase['baserequired'] == 'y' && $invoicebase=='y') {
			$basesize='';
			if ($purchase['baseprice']!= '') {
				$baseprice = floatval($purchase['baseprice']);
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
						$uphbaseprice = floatval($purchase['upholsteryprice']);
						$invoicetotal += $uphbaseprice;
					
			$basedetails .= "<tr class='wholesalefont'><td valign=top>Upholstered Base<br /></td>";
			$basedetails .= "<td valign=top align='center'>&nbsp;</td>";
			$basedetails .= "<td valign=top align='center'>1</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($uphbaseprice, 2) ."</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($uphbaseprice, 2) ."</td></tr>";
			}
			
			if ($purchase['basetrim'] != 'n' && $purchase['basetrim'] != null) {
						$basetrimprice = floatval($purchase['basetrimprice']);
						$invoicetotal += $basetrimprice;
			$basedetails .= "<tr class='wholesalefont'><td valign=top>Base Trim<br /></td>";
			$basedetails .= "<td valign=top align='center'>&nbsp;</td>";
			$basedetails .= "<td valign=top align='center'>1</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($basetrimprice, 2) ."</td>";
			$basedetails .= "<td valign=top align='right'>" .number_format($basetrimprice, 2) ."</td></tr>";
			}
			
			if ($purchase['basedrawers'] == 'Yes') {
						$drawersprice = floatval($purchase['basedrawersprice']);
						$invoicetotal += $drawersprice;
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
						$fabricprice = floatval($purchase['basefabriccost']);
						if ($purchase['basefabricmeters'] != '') {
							$fabricpricetotal =  $fabricprice * $purchase['basefabricmeters'];
							$invoicetotal += $fabricpricetotal;
						} else {
							$fabricpricetotal =  $fabricprice;
							$invoicetotal += $fabricprice;
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
		if ($purchase['topperrequired'] == 'y' && $invoicetopper=='y') {
				$topperprice = floatval($purchase['topperprice']);
				$invoicetotal += $topperprice;
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
		$unitlegprice=0;
		$addlegprice=0;
		$unitaddlegprice=0;
		$totallegprice=0;
		$totaladdlegprice=0;
		if ($purchase['legsrequired'] == 'y' && $invoicelegs=='y') {
			if (!empty($purchase['LegQty'])) {
				$legqty=intval($purchase['LegQty']);
			}
			if (!empty($purchase['AddLegQty'])) {
				$addlegqty=intval($purchase['AddLegQty']);
			}
			$legprice = floatval($purchase['legprice']);
			$unitlegprice=$legprice/$legqty;
			$totallegprice=$legprice;
			$invoicetotal += $legprice;
				$addlegprice = floatval($purchase['addlegprice']);
				if ($addlegprice !=0) {
				$unitaddlegprice=$addlegprice/$addlegqty;
				$invoicetotal += $addlegprice;
				}
		
			$legsdetails .= "<tr class='wholesalefont'><td valign=top>" .$purchase['legstyle'] ." Legs<br />" .$purchase['legfinish'] ."</td>";			
			$legsdetails .= "<td valign=top>" .$purchase['legheight'] ."</td>";
			$legsdetails .= "<td valign=top align=center>" .$legqty ."</td>";
			$legsdetails .= "<td valign=top align='right'>" .number_format($unitlegprice, 2) ."</td>";
			$legsdetails .= "<td valign=top align='right'>" .number_format($totallegprice, 2) ."</td>";
			$legsdetails .= "</tr>";
			
			$legsdetails .= "<tr class='wholesalefont'><td valign=top>" .$purchase['addlegstyle'] ." Support Legs<br />" .$purchase['addlegfinish'] ."</td>";			
			$legsdetails .= "<td valign=top>&nbsp;</td>";
			$legsdetails .= "<td valign=top align=center>" .$addlegqty ."</td>";
			$legsdetails .= "<td valign=top align='right'>" .number_format($unitaddlegprice, 2) ."</td>";
			$legsdetails .= "<td valign=top align='right'>" .number_format($addlegprice, 2) ."</td>";
			$legsdetails .= "</tr>";
		}
		$this->set('legsdetails', $legsdetails);
		
		$valancedetails='';
		$valancefabricprice=0;
		$valanceprice=0;
		$valancesize='';
		$valancefabrictotalprice='';
		if ($purchase['valancerequired'] == 'y' && $invoicevalance=='y') {
				$valancefabricprice = floatval($purchase['valfabriccost']);
				if ($purchase['valfabricmeters'] != '' && $purchase['valfabricmeters'] != 0 && $purchase['valfabricmeters'] != null) {
					$valancefabrictotalprice = $valancefabricprice * $purchase['valfabricmeters'];
					$invoicetotal += $valancefabrictotalprice;
				} else {
					$invoicetotal += $valancefabricprice;
				}

				$valanceprice = floatval($purchase['valanceprice']);
				$invoicetotal += $valanceprice;
			
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
		$hbfabricprice=0;
		$hbfabrictotalprice=0;
		if ($purchase['headboardrequired'] == 'y' && $invoicehb=='y') {
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
			if ($hbwidth=='' && substr($purchase['basewidth'], 0, 4) == 'Spec') {
				$hbwidth=$psizes['Base1Width'];
				if ($psizes['Base2Width'] != null) {
					$hbwidth=$psizes['Base1Width'] + $psizes['Base2Width'];
				}
			}
			if ($hbwidth=='' && substr($purchase['mattresswidth'], 0, 4) == 'Spec') {
				$hbwidth=$psizes['Matt1Width'];
				if ($psizes['Matt2Width'] != null) {
					$hbwidth=$psizes['Matt1Width'] + $psizes['Matt2Width'];
				}
			}
			if ($hbwidth != '') {
				$hbwidth = $hbwidth ." cm wide";
			}
				
			if ($purchase['headboardtrimprice'] != '') {	
				$hbtrimprice = $purchase['headboardtrimprice'];
				$invoicetotal += $hbtrimprice;
			}
			
			if ($purchase['hbfabricprice'] != '' && $purchase['hbfabricprice'] !=0 && $purchase['hbfabricprice'] != null) {	
				$hbfabricprice = $purchase['hbfabriccost'];
				if ($purchase['hbfabricmeters'] !=0 && $purchase['hbfabricmeters'] != null && $purchase['hbfabricmeters'] !='') {
					$hbfabrictotalprice = $hbfabricprice * $purchase['hbfabricmeters'];
				} else {
					$hbfabrictotalprice=$hbfabricprice;
				}
				$invoicetotal += $hbfabrictotalprice;
			}
			
			$hbprice = floatval($purchase['headboardprice']);
			$invoicetotal += $hbprice;
	
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
		if ($purchase['accessoriesrequired'] == 'y' && $invoiceacc=='y') {
			$acc = $this->Accessory->find()->where(['purchase_no' => $pn]);	
				foreach ($acc as $accline) {
					$acctotal=0;
					$acctotal=$accline['unitprice'] * $accline['qty'];
					$accdetails .= "<tr class='wholesalefont'><td>" .$accline['description'] ." ".$accline['colour']."".$accline['design']."</td>";
					$accdetails .= "<td>" .$accline['size'] ."</td>";
					$accdetails .= "<td align=center>" .$accline['qty'] ."</td>";
					$accdetails .= "<td valign=top align='right'>" .number_format($accline['unitprice'], 2) ."</td>";
					$accdetails .= "<td valign=top align='right'>" .number_format($acctotal, 2) ."</td>";
					$accdetails .= "</tr>";
					$invoicetotal += $acctotal;
				}
			}
			
		$this->set('accdetails', $accdetails);
		$deliverycharge='';
		if ($purchase['deliverycharge']=='y') {
			$deliverycharge .= "<tr class='wholesalefont'><td valign=top>Delivery Charge</td><td>&nbsp;</td>";
			$deliveryprice=$purchase['deliveryprice'];
			$deliverycharge .= "<td valign=top align='center'>1</td>";
			$deliverycharge .= "<td valign=top align='right'>" .number_format($deliveryprice, 2) ."</td>";
			$deliverycharge .= "<td valign=top align='right'>" .number_format($deliveryprice, 2) ."</td>";
			$deliverycharge .= "</tr>";
			$invoicetotal += $deliveryprice;
		
		}
		$this->set('deliverycharge', $deliverycharge);
		$netinvoicetotal=0;
		$vat=0;
		if ($purchase['istrade']=='y') {
			$netinvoicetotal=$invoicetotal;
			$vat=$netinvoicetotal*($purchase['vatrate']/100);
			$invoicetotal=$netinvoicetotal+$vat;
		} else {
			
			$vat=$invoicetotal-$invoicetotal/(1+$purchase['vatrate']/100);
			$netinvoicetotal=$invoicetotal-$vat;
		}
		
		
		$this->set('vat', number_format($vat, 2));
				
		$setinvoicetotal=0;
		$setinvoicetotal=number_format($invoicetotal, 2);
		$setnetinvoicetotal=number_format($netinvoicetotal, 2);
		$this->set('setinvoicetotal', $setinvoicetotal);
		$this->set('setnetinvoicetotal', $setnetinvoicetotal);
		$this->set('currencysymbol', $currencysymbol);
		
		$footer='';
		$footer .= "<br><table width=100% border=0 cellspacing=0 cellpadding=2 class=wholesalefont><tr><td width=10% valign=top style='line-height:14px;'>Notes:</td><td align=left>";
		if (isset($showroom['InvoiceNote1'])) {
		$footer .= "1. " .$showroom['InvoiceNote1'] ."<br>";
		}
		if (isset($showroom['InvoiceNote2'])) {
			$footer .= "2. " .$showroom['InvoiceNote2'] ."<br>";
		}
		if (isset($showroom['InvoiceNote3'])) {
			$footer .= "3. " .$showroom['InvoiceNote3'] ."<br>";
		}
		if (isset($showroom['InvoiceNote4'])) {
			$footer .= "4. " .$showroom['InvoiceNote4'] ."<br>";
		}
		if (isset($showroom['InvoiceNote5'])) {
			$footer .= "5. " .$showroom['InvoiceNote5'] ."<br>";
		}
		if (isset($showroom['InvoiceNote6'])) {
			$footer .= "6. " .$showroom['InvoiceNote6'] ."<br>";
		}

		$footer .= "&nbsp;</td></tr>";

		$footer .= "</table><br><br><table width=100% border=0 cellspacing=0 cellpadding=1 class=wholesalefont><tr><td width=10% valign=top>Bank Details:</td>";
		if (isset($showroom['BankAcName'])) {
		$footer .= "<td align=left width=15%>Account Name:</td><td>" .$showroom['BankAcName'] ."</td></tr>";
		} else {
			$footer .= "<td>&nbsp;</td><td>&nbsp;</td></tr>";
		}
		if (isset($showroom['BankAcNo'])) {
		$footer .= "<tr><td>&nbsp;</td><td align=left width=10%>Account Number:</td><td>" .$showroom['BankAcNo'] ."</td></tr>";
		}
		if (isset($showroom['BankSortCode'])) {
		$footer .= "<tr><td>&nbsp;</td><td align=left width=10%>Sort Code:</td><td>" .$showroom['BankSortCode'] ."</td></tr>";
		}
		if (isset($showroom['BankRoutingNo'])) {
		$footer .= "<tr><td>&nbsp;</td><td align=left width=10%>Bank Routing No:</td><td>" .$showroom['BankRoutingNo'] ."</td></tr>";
		}
		if (isset($showroom['BankAddress'])) {
		$footer .= "<tr><td>&nbsp;</td><td align=left width=10%>Bank Address:</td><td>" .$showroom['BankAddress'] ."</td></tr>";
		}
		if (isset($showroom['IBAN'])) {
		$footer .= "<tr><td>&nbsp;</td><td align=left width=10%>IBAN:</td><td>" .$showroom['IBAN'] ."</td></tr>";
		}
		if (isset($showroom['SWIFT'])) {
		$footer .= "<tr><td>&nbsp;</td><td align=left width=10%>SWIFT:</td><td>" .$showroom['SWIFT'] ."</td></tr>";
		}
		$footer .= "<tr><td colspan='3'><br><p align=center><b>PAYMENT DUE</b><br>VAT Reg. No. GB 706 8175 27<br>Savoir Beds Limited, Registered in England No. 3395749<br>Registered Office: 1 Old Oak Lane, London NW10 6UD, UK. Email: accounts@savoirbeds.co.uk<br><br>All goods remain the property of Savoir Beds Ltd until payment is received in full.";
		$footer .= "</td></tr></table>";
		
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
