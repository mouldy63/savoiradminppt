<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class CommercialInvoiceController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
		$this->loadComponent('CommercialData');
		$this->loadModel('Purchase');
		$this->loadModel('Location');
		$this->loadModel('Contact');
		$this->loadModel('Address');
		$this->loadModel('ProductionSizes');
		$this->loadModel('Wrappingtypes');
		$this->loadModel('Accessory');
		$this->loadModel('ExportCollections');
		$this->loadModel('PhoneNumber');
		$this->loadModel('DeliveryTerms');
		$this->loadModel('OverseasDuty');
		$this->loadModel('Shipper');
		$this->loadModel('PackagingData');
		$this->loadModel('ShippingBox');
		$this->loadModel('WholesalePrices');
		
	}
	
	public function index() {
		$wholesaleprices = TableRegistry::get('WholesalePrices');
		$purchaseTable = TableRegistry::get('Purchase');
		$this->viewBuilder()->setLayout('manifest');
        $this->viewBuilder()->setOptions([
            'pdfConfig' => [
                'orientation' => 'portrait',
            ]
        ]);
		$docroot=$_SERVER['DOCUMENT_ROOT'];
        $this->set('docroot', $docroot);
        
        $params = $this->request->getParam('?');
        $pn = $params['pno'];
		if (isset($params['sid'])) {
			$sid = $params['sid'];
		} else {
			$sid='n';
		}
		if (isset($params['wholesale'])) {
			$wholesale = $params['wholesale'];
		} else {
			$wholesale='';
		}
		if (isset($params['items'])) {
			$items = $params['items'];
		} else {
			$items='';
		}
		if (isset($params['loc'])) {
			$loc = $params['loc'];
		} else {
			$loc='';
		}
		if (isset($params['cid'])) {
			$cid = $params['cid'];
		} else {
			$cid='';
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
		$contact = $purchase['contact_no'];
		$customerreference = $purchase['customerreference'];
		$deliverycontact = $purchase['deliveryContact'];
		$currency = $purchase['ordercurrency'];
		$code = $purchase['CODE'];
		$this->set('ordernumber', $ordernumber);
		$this->set('orderdate', $orderdate);
		$this->set('customerreference', $customerreference);
		$this->set('deliverycontact', $deliverycontact);
		$salesname = $purchaseTable->getSalesContact($salesusername);
		$salesuseremail = $purchaseTable->getSalesEmail($salesusername);
		$this->set('salesname', $salesname);
		$this->set('salesuseremail', $salesuseremail);
		$this->set('currency', $currency);
		
		$query = $this->Wrappingtypes->find()->where(['WrappingID' => $purchase['wrappingid']]);
		$wrap = null;
		foreach ($query as $row) {
			$wrap = $row;
		}
		$pdfwrapname=$wrap['pdfwrapname'];
		$wrapname=$wrap['wrapName'];
		$wrapid=$wrap['WrappingID'];
		
		$wraptext=$wrap['CommercialText'];
		$this->set('wraptext', $wraptext);
				
		$exportcomponents = TableRegistry::get('ExportCollections');
		$components = $exportcomponents->getItemsForCommercialInvoice($pn,$cid);
		
		$mattressinc='n';
		$baseinc='n';
		$topperinc='n';
		$valanceinc='n';
		$legsinc='n';
		$hbinc='n';
		$accinc='n';
		foreach ($components as $componentid) {
				$compid = $componentid['componentid'];
				if ($compid==1) {
					$mattressinc='y';
				}
				if ($compid==3) {
					$baseinc='y';
				}
				if ($compid==5) {
					$topperinc='y';
				}
				if ($compid==6) {
					$valanceinc='y';
				}
				if ($compid==7) {
					$legsinc='y';
				}
				if ($compid==8) {
					$hbinc='y';
				}
				if ($compid==9) {
					$accinc='y';
				}
			}
		$totalNW=0;
		$query = $this->ExportCollections->find()->where(['exportCollectionsID' => $cid]);
		$exportcollections = null;
		foreach ($query as $row) {
			$exportcollections = $row;
		}
		$collectiondate='';
		$sid=$exportcollections['Shipper'];
		$collectiondate=$exportcollections['CollectionDate'];
		$collectiondate=$collectiondate->format('d/m/Y');
		$destinationport=$exportcollections['DestinationPort'];
		$deliveryterms=$exportcollections['ExportDeliveryTerms'];
		$deliverytermstxt=$exportcollections['termstext'];
		$this->set('collectiondate', $collectiondate);
		$this->set('destinationport', $destinationport);
		$this->set('deliveryterms', $deliveryterms);
		
		$query = $this->DeliveryTerms->find()->where(['deliveryTermsID' => $deliveryterms]);
		$deliveryterms = null;
		foreach ($query as $row) {
			$deliveryterms = $row;
		}
		$deliverytermstext='';
		if ($deliveryterms != null) {
		
			$deliverytermstext=$deliveryterms['DeliveryTerms'];
			if (!empty($deliverytermstext)) {
				$deliverytermstext .= "<br>" .$deliverytermstxt;
			}
		}
		
		$query = $this->Shipper->find()->where(['shipper_ADDRESS_ID' => $sid]);
		$shipper = null;
		foreach ($query as $row) {
			$shipper = $row;
		}
		$shippercontact='';
		$shippercontact .=$shipper['CONTACT'] ." - ";
		$shippercontact .=$shipper['shipperName'] ." ";
		$shippercontact .=$shipper['PHONE'] ." ";
		$this->set('shippercontact', $shippercontact);
		
		$overseasterms = null;
		if (isset($purchase['overseasduty'])) {
			$query = $this->OverseasDuty->find()->where(['overseas_dutyID' => $purchase['overseasduty']]);
			foreach ($query as $row) {
				$overseasterms = $row;
			}
		}
		if ($overseasterms != null) {
			$overseastext=$overseasterms['Terms'];
			if (!empty($overseastext)) {
				$deliverytermstext .= "<br>" .$overseastext;
			}
		}
		$this->set('deliverytermstext', $deliverytermstext);
		
		$phonedetails='';
		$phoneno = $this->PhoneNumber->find()->where(['purchase_no' => $pn])->order(['seq' => 'ASC']);
		foreach ($phoneno as $contact1) {
				$phonedetails .= $contact1['phonenumbertype'] .": Tel: ";
				$phonedetails .= $contact1['number'] ."<br>";
			}
		
		
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
				$phonedetails .= "<br>Email: ";
				$phonedetails .= $address['EMAIL_ADDRESS'];
		}
		if ($contact['mobile'] != '') {
				$phonedetails .= "<br>Mobile: ";
				$phonedetails .= $contact['mobile'];
		}
		if ($purchase['customerreference'] != '') {
				$customerdetails .= "<br>Client Ref:&nbsp;&nbsp;<b>" .$purchase['customerreference'] ."</b>";
		}
		$this->set('customerdetails', $customerdetails);
		$this->set('phonedetails', $phonedetails);
		
		$customeraddress='';
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
		
		$emailaddress= $address['EMAIL_ADDRESS'];
		$this->set('emailaddress', $emailaddress);
		$this->set('customeraddress', $customeraddress);
		$deliveryaddress='';
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
		$header .= "<p align=center><img src='webroot/img/logo-s.gif' width='255' height='40' style='margin-top:40px;' /><br><b>Commercial Invoice</b></p>";
		

		$this->set('header', $header);
		
		$exportData = $this->CommercialData->getExportData(null, $pn, $mattressinc, $baseinc, $topperinc, $valanceinc, $legsinc, $hbinc, $accinc, $purchase, $wrapid, $wholesale, $psizes, $cid);
		
		//echo '<br>$exportData['totalitems']=' . $exportData['totalitems'];
		//die;
		
		
		$commercialinv ="<table class=comminv cellspacing=0px cellpadding=3px><tr><td colspan=2 valign=top>Number & Kind of Packages</td><td valign=top>Dimensions</td><td valign=top>Harmonized<br>Tariff Code</td><td valign=top>Gross Weight<br>(kg)</td><td valign=top>Net Weight<br>(kg)</td><td valign=top>Qty</td><td valign=top>Unit Price</td><td valign=top>Amount</td></tr>";
		$count=0;
		if ($mattressinc == 'y') {
		$mattresspriceUnit=$exportData['mattressprice'];
		
		if ($mattressinc == 'y' && $exportData['mattressbox']=='2') {
		$commercialinv .="<tr><td width=10%>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td><td width=40%>" .$exportData['mattressdesc'] ."</td><td>" .$exportData['mattressdimensions2'] ."</td><td>" .$exportData['mattresstariff'] ."</td><td valign=top>" .$exportData['mattressweight2'] ."</td><td valign=top>" .$exportData['matt2NW'] ."</td><td align=center>" .$exportData['mattressqty'] ."</td><td align=right>" .$mattresspriceUnit ."</td><td align=right>" .$exportData['mattressprice'] ."</td></tr>";
		}
		}
		if ($mattressinc == 'y') {
			if ($exportData['valancepackedwith']==1) {
				$exportData['mattressdesc'] .= "<br>" .$exportData['valancedesc'];
				$exportData['mattresstariff'] .= "<br>" .$exportData['valancetariff'];
				$exportData['mattressqty'] .= "<br>1";
				$mattresspriceUnit .= "<br>" .$exportData['valanceprice'];
				$exportData['mattressprice'] .= "<br>" .$exportData['valanceprice'];
			}
			if ($exportData['legspackedwith']==1) {
				$exportData['mattressdesc'] .= "<br>" .$exportData['legdesc'];
				$exportData['mattresstariff'] .= "<br>" .$exportData['legtariff'];
				$exportData['mattressqty'] .= "<br>1";
				$mattresspriceUnit .= "<br>" .$exportData['legprice'];
				$exportData['mattressprice'] .= "<br>" .$exportData['legprice'];
			}
			if ($accinc == 'y' && $wrapid == 3) {
				foreach ($exportData['acc'] as $accline) {
					$accdesc = "";
					$acctariff = "";
					$accqty = "";
					$accprice = "";
					
					if (count($exportData['packdata'])>0) {
						$packinfo = $this->PackagingData->find()->where(['CompPartNo' => $accline['orderaccessory_id']]);
						$packinfo=$packinfo->first();
						if ($packinfo['PackedWith']==1) {
							$accpackedwith = $this->Accessory->find()->where(['orderaccessory_id' => $packinfo['CompPartNo']]);							
							$accpackedwith=$accpackedwith->first();	
							$exportData['mattressdesc'] .= "<br>" .$accpackedwith['description'];
							$exportData['mattresstariff'] .= "<br>" .$packinfo['packtariffcode'];
							$exportData['mattressqty'] .= "<br>".(intval($accpackedwith['qty'])-intval($accpackedwith['QtyToFollow']));
							$accpricecalc = $this->_getComponentPriceExVatAfterDiscount($accpackedwith['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
							if ($wholesale=='y') {
								$accpricecalc = $accpackedwith['wholesalePrice'];
							}
							$mattresspriceUnit .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
							$accpricecalc = $accpricecalc * (intval($accpackedwith['qty'])-intval($accpackedwith['QtyToFollow']));
							$exportData['mattressprice'] .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
							$exportData['totalvalue']=floatval($exportData['totalvalue'])+($accpricecalc);
						}
					}
				}
				
				if ($accinc == 'y' && $wrapid == 4) {
					$accdesc = "";
					$acctariff = "";
					$accqty = "";
					$accprice = "";
					foreach ($exportData['acc'] as $accline) {
						$exportData['mattressdesc'] .= "<br>" .$accline['description'] . $accdesc;
						$exportData['mattresstariff'] .= "<br>" .$accline['tariffCode'];
						$exportData['mattressqty'] .= "<br>".(intval($accline['qty'])-intval($accline['QtyToFollow']));
						$accpricecalc = $this->_getComponentPriceExVatAfterDiscount($accline['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );	
						if ($wholesale=='y') {
							$accpricecalc = $accline['wholesalePrice'];
						}
						if ($accpricecalc==0) {
							$accpricecalc=10;
							}
						$mattresspriceUnit .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
						$accpricecalc = $accpricecalc * (intval($accline['qty'])-intval($accline['QtyToFollow']));
						
						$exportData['mattressprice'] .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
						$exportData['totalvalue']=floatval($exportData['totalvalue'])+($accpricecalc);
					}
			
			
				}
			
				
			}
			
		$commercialinv .="<tr><td width=10% valign=top>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td><td width=40% valign=top>" .$exportData['mattressdesc'] ."</td><td valign=top>" .$exportData['mattressdimensions'] ."</td><td valign=top>" .$exportData['mattresstariff'] ."</td><td valign=top>" .$exportData['mattressweight'] ."</td><td valign=top>" .$exportData['matt1NW'] ."</td><td align=center valign=top>" .$exportData['mattressqty'] ."</td><td align=right valign=top>" .$mattresspriceUnit ."</td><td align=right valign=top>" .$exportData['mattressprice'] ."</td></tr>";
		}
		
		if ($baseinc == 'y') {
			$basepriceUnit=$exportData['baseprice'];
			
			if ($exportData['basebox']==2) {
			$commercialinv .="<tr><td valign=top>" .($count+=1) ." aof " .$exportData['totalitems'] . " " .$wrapname ."</td><td valign=top>" .$exportData['basedesc'] ."</td><td valign=top>" .$exportData['basedimensions2'] ."</td><td valign=top>" .$exportData['basetariff'] ."</td><td valign=top>" .$exportData['baseweight2'] ."</td><td valign=top>" .$exportData['base2NW'] ."</td><td align=center valign=top>" .$exportData['baseqty'] ."</td><td align=right valign=top>" .$basepriceUnit ."</td><td align=right valign=top>" .$exportData['baseprice'] ."</td></tr>";
		}
		if ($exportData['boxQty']==2) {
			$commercialinv .="<tr><td valign=top>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td><td valign=top>" .$exportData['basedesc'] ."</td><td valign=top>" .$exportData['basedimensions'] ."</td><td valign=top>" .$exportData['basetariff'] ."</td><td valign=top>" .$exportData['baseweight2'] ."</td><td valign=top>" .$exportData['baseNW'] ."</td><td align=center valign=top>" .$exportData['baseqty'] ."</td><td align=right valign=top>" .$basepriceUnit ."</td><td align=right valign=top>" .$exportData['baseprice'] ."</td></tr>";
		}
		
			if ($exportData['valancepackedwith']==3) {
				$exportData['basedesc'] .= "<br>" .$exportData['valancedesc'];
				$exportData['basetariff'] .= "<br>" .$exportData['valancetariff'];
				$exportData['baseqty'] .= "<br>1";
				$basepriceUnit .= "<br>" .$exportData['valanceprice'];
				$exportData['baseprice'] .= "<br>" .$exportData['valanceprice'];
			}
			if ($exportData['legspackedwith']==3) {
				$exportData['basedesc'] .= "<br>" .$exportData['legdesc'];
				$exportData['basetariff'] .= "<br>" .$exportData['legtariff'];
				$exportData['baseqty'] .= "<br>1";
				$basepriceUnit .= "<br>" .$exportData['legprice'];
				$exportData['baseprice'] .= "<br>" .$exportData['legprice'];
			}
			
			if ($accinc == 'y' && $wrapid == 3) {
				foreach ($exportData['acc'] as $accline) {
					$accdesc = "";
					$acctariff = "";
					$accqty = "";
					$accprice = "";
					
					if (count($exportData['packdata'])>0) {
						$packinfo = $this->PackagingData->find()->where(['CompPartNo' => $accline['orderaccessory_id']]);
						$packinfo=$packinfo->first();
						if ($packinfo['PackedWith']==3) {
							$accpackedwith = $this->Accessory->find()->where(['orderaccessory_id' => $packinfo['CompPartNo']]);							
							$accpackedwith=$accpackedwith->first();	
							$exportData['basedesc'] .= "<br>" .$accpackedwith['description'];
							$exportData['basetariff'] .= "<br>" .$packinfo['packtariffcode'];
							$exportData['baseqty'] .= "<br>".(intval($accpackedwith['qty'])-intval($accpackedwith['QtyToFollow']));
							$accpricecalc = $this->_getComponentPriceExVatAfterDiscount($accpackedwith['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );	
							if ($wholesale=='y') {
								$accpricecalc = $accpackedwith['wholesalePrice'];
							}						
							$basepriceUnit .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
							$accpricecalc = $accpricecalc * (intval($accpackedwith['qty'])-intval($accpackedwith['QtyToFollow']));
							$exportData['baseprice'] .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
							$exportData['totalvalue']=floatval($exportData['totalvalue'])+($accpricecalc);
						}
					}
				}
				
				if ($accinc == 'y' && $wrapid == 4) {
					$accdesc = "";
					$acctariff = "";
					$accqty = "";
					$accprice = "";
					foreach ($exportData['acc'] as $accline) {
						$exportData['basedesc'] .= "<br>" .$accline['description'] . $accdesc;
						$exportData['basetariff'] .= "<br>" .$accline['tariffCode'];
						$exportData['baseqty'] .= "<br>".(intval($accline['qty'])-intval($accline['QtyToFollow']));
						$accpricecalc = $this->_getComponentPriceExVatAfterDiscount($accline['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );	
						if ($wholesale=='y') {
							$accpricecalc = $accline['wholesalePrice'];
						}
						if ($accpricecalc==0) {
							$accpricecalc=10;
							}
						$basepriceUnit .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
						$accpricecalc = $accpricecalc * (intval($accline['qty'])-intval($accline['QtyToFollow']));
						
						$exportData['baseprice'] .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
						$exportData['totalvalue']=floatval($exportData['totalvalue'])+($accpricecalc);
					}
			
			
				}
			}
			
		if ($exportData['baseboxQty']==2 && $wrapid == 4) {

			$commercialinv .="<tr><td valign=top>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td><td valign=top>" .$exportData['basedesc'] ."</td><td valign=top>" .$exportData['basedimensions'] ."</td><td valign=top>" .$exportData['basetariff'] ."</td><td valign=top>" .$exportData['baseweight'] ."</td><td valign=top>" .$exportData['baseNW'] ."</td><td align=center valign=top>" .$exportData['baseqty'] ."</td><td align=right valign=top>" .$basepriceUnit ."</td><td align=right valign=top>" .$exportData['baseprice'] ."</td></tr>";

			} else {
			$commercialinv .="<tr><td valign=top>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td><td valign=top>" .$exportData['basedesc'] ."</td><td valign=top>" .$exportData['basedimensions'] ."</td><td valign=top>" .$exportData['basetariff'] ."</td><td valign=top>" .$exportData['baseweight'] ."</td><td valign=top>" .$exportData['baseNW'] ."</td><td align=center valign=top>" .$exportData['baseqty'] ."</td><td align=right valign=top>" .$basepriceUnit ."</td><td align=right valign=top>" .$exportData['baseprice'] ."</td></tr>";
			}
		}
		
		if ($topperinc == 'y') {
			if ($exportData['topper2']=='y') {
				$commercialinv .="<tr><td valign=top>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td><td valign=top>" .$exportData['topperdesc'] ."</td><td valign=top>" .$exportData['topperdimensions2'] ."</td><td valign=top>" .$exportData['toppertariff'] ."</td><td valign=top>" .$exportData['topperweight2'] ."</td><td align=center valign=top>" .$exportData['topperqty'] ."</td><td align=right valign=top>" .$topperpriceUnit ."</td><td align=right valign=top>" .$exportData['topperprice'] ."</td></tr>";}
			$topperpriceUnit=$exportData['topperprice'];
			if ($exportData['valancepackedwith']==5) {
				$exportData['topperdesc'] .= "<br>" .$exportData['valancedesc'];
				$exportData['toppertariff'] .= "<br>" .$exportData['valancetariff'];
				$exportData['topperqty'] .= "<br>1";
				$topperpriceUnit .= "<br>" .$exportData['valanceprice'];
				$exportData['topperprice'] .= "<br>" .$exportData['valanceprice'];
			}
			if ($exportData['legspackedwith']==5) {
				$exportData['topperdesc'] .= "<br>" .$exportData['legdesc'];
				$exportData['toppertariff'] .= "<br>" .$exportData['legtariff'];
				$exportData['topperqty'] .= "<br>1";
				$topperpriceUnit .= "<br>" .$exportData['legprice'];
				$exportData['topperprice'] .= "<br>" .$exportData['legprice'];
			}
			
			if ($accinc == 'y' && $wrapid == 3) {
				foreach ($exportData['acc'] as $accline) {
					$accdesc = "";
					$acctariff = "";
					$accqty = "";
					$accprice = "";
					
					if (count($exportData['packdata'])>0) {
						$packinfo = $this->PackagingData->find()->where(['CompPartNo' => $accline['orderaccessory_id']]);
						$packinfo=$packinfo->first();
						if ($packinfo['PackedWith']==5) {
							$accpackedwith = $this->Accessory->find()->where(['orderaccessory_id' => $packinfo['CompPartNo']]);							
							$accpackedwith=$accpackedwith->first();	
							$exportData['topperdesc'] .= "<br>" .$accpackedwith['description'];
							$exportData['toppertariff'] .= "<br>" .$packinfo['packtariffcode'];
							$exportData['topperqty'] .= "<br>".(intval($accpackedwith['qty'])-intval($accpackedwith['QtyToFollow']));
							$accpricecalc = $this->_getComponentPriceExVatAfterDiscount($accpackedwith['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );	
							if ($wholesale=='y') {
								$accpricecalc = $accpackedwith['wholesalePrice'];
							}						
							$topperpriceUnit .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
							$accpricecalc = $accpricecalc * (intval($accpackedwith['qty'])-intval($accpackedwith['QtyToFollow']));
							$exportData['topperprice'] .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
							$exportData['totalvalue']=floatval($exportData['totalvalue'])+($accpricecalc);
						}
					}
				}
			}
	
				if ($accinc == 'y' && $wrapid == 4) {
					$accdesc = "";
					$acctariff = "";
					$accqty = "";
					$accprice = "";
					$packinfo = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 5]);
					$packinfo=$packinfo->first();
					if ($packinfo['PackedWith']==5) {
					foreach ($exportData['acc'] as $accline) {
						$exportData['topperdesc'] .= "<br>" .$accline['description'] . $accdesc;
						$exportData['toppertariff'] .= "<br>" .$accline['tariffCode'];
						$exportData['topperqty'] .= "<br>".(intval($accline['qty'])-intval($accline['QtyToFollow']));
						$accpricecalc = $this->_getComponentPriceExVatAfterDiscount($accline['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );	
						if ($wholesale=='y') {
							$accpricecalc = $accline['wholesalePrice'];
						}
						if ($accpricecalc==0) {
							$accpricecalc=10;
							}
						$topperpriceUnit .="<br>" .number_format((float)$accpricecalc, 2, '.', '');
						$accpricecalc = $accpricecalc * (intval($accline['qty'])-intval($accline['QtyToFollow']));
						
						$exportData['topperprice'] .="<br>" .number_format((float)$accpricecalc, 2, '.', '');
						$exportData['totalvalue']=floatval($exportData['totalvalue'])+($accpricecalc);
					}
					}
			
			
				}
			
		$commercialinv .="<tr><td valign=top>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td><td valign=top>" .$exportData['topperdesc'] ."</td><td valign=top>" .$exportData['topperdimensions'] ."</td><td valign=top>" .$exportData['toppertariff'] ."</td><td valign=top>" .$exportData['topperweight'] ."</td><td valign=top>".$exportData['topperNW']."</td><td align=center>" .$exportData['topperqty'] ."</td><td align=right valign=top>" .$topperpriceUnit ."</td><td align=right valign=top>" .$exportData['topperprice'] ."</td></tr>";
		}
		
		if ($legsinc == 'y' && $exportData['legspackedwith']=='') {
			$legpriceUnit=$exportData['legprice'];
			if ($exportData['valancepackedwith']==7) {
				$exportData['legdesc'] .= "<br>" .$exportData['valancedesc'];
				$exportData['legtariff'] .= "<br>" .$exportData['valancetariff'];
				$exportData['legqty'] .= "<br>1";
				$legpriceUnit .= "<br>" .$exportData['valanceprice'];
				$exportData['legprice'] .= "<br>" .$exportData['valanceprice'];
			}
			if ($accinc == 'y' && $wrapid == 3) {
				foreach ($exportData['acc'] as $accline) {
					$accdesc = "";
					$acctariff = "";
					$accqty = "";
					$accprice = "";
					
					if (count($exportData['packdata'])>0) {
						$packinfo = $this->PackagingData->find()->where(['CompPartNo' => $accline['orderaccessory_id']]);
						$packinfo=$packinfo->first();
						if ($packinfo['PackedWith']==7) {
							$accpackedwith = $this->Accessory->find()->where(['orderaccessory_id' => $packinfo['CompPartNo']]);							
							$accpackedwith=$accpackedwith->first();	
							$exportData['legdesc'] .= "<br>" .$accpackedwith['description'];
							$exportData['legtariff'] .= "<br>" .$packinfo['packtariffcode'];
							$exportData['legqty'] .= "<br>".(intval($accpackedwith['qty'])-intval($accpackedwith['QtyToFollow']));
							$accpricecalc = $this->_getComponentPriceExVatAfterDiscount($accpackedwith['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );	
							if ($wholesale=='y') {
								$accpricecalc = $accpackedwith['wholesalePrice'];
							}						
							$legpriceUnit .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
							$accpricecalc = $accpricecalc * (intval($accpackedwith['qty'])-intval($accpackedwith['QtyToFollow']));
							$exportData['legprice'] .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
							$exportData['totalvalue']=floatval($exportData['totalvalue'])+($accpricecalc);
						}
					}
				}
				
				if ($accinc == 'y' && $wrapid == 4) {
					$accdesc = "";
					$acctariff = "";
					$accqty = "";
					$accprice = "";
					
					foreach ($exportData['acc'] as $accline) {
						$exportData['legdesc'] .= "<br>" .$accline['description'] . $accdesc;
						$exportData['legtariff'] .= "<br>" .$accline['tariffCode'];
						$exportData['legqty'] .= "<br>".(intval($accline['qty'])-intval($accline['QtyToFollow']));
						$accpricecalc = $this->_getComponentPriceExVatAfterDiscount($accline['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );	
						if ($wholesale=='y') {
							$accpricecalc = $accline['wholesalePrice'];
						}
						if ($accpricecalc==0) {
							$accpricecalc=10;
							}
						$legpriceUnit .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
						$accpricecalc = $accpricecalc * (intval($accline['qty'])-intval($accline['QtyToFollow']));
						
						$exportData['legprice'] .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
						$exportData['totalvalue']=floatval($exportData['totalvalue'])+($accpricecalc);
					}
			
			
				}
			}
		$commercialinv .="<tr><td valign=top>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td><td valign=top>" .$exportData['legdesc'] ."</td><td valign=top>" .$exportData['legdimensions'] ."</td><td>" .$exportData['legtariff'] ."</td><td valign=top>" .$exportData['legweight'] ."</td><td>".$exportData['legsNW']."</td><td align=center valign=top>" .$exportData['legqty'] ."</td><td align=right valign=top>" .$legpriceUnit ."</td><td align=right valign=top>" .$exportData['legprice'] ."</td></tr>";
		}
		
		if ($hbinc == 'y') {
		
			$hbpriceUnit=$exportData['hbprice'];
			if ($exportData['hb2']=='y') {
			$commercialinv .="<tr><td valign=top>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td><td valign=top>" .$exportData['hbdesc'] ."</td><td valign=top>" .$exportData['hbdimensions2'] ."</td><td valign=top>" .$exportData['hbtariff'] ."</td><td valign=top>" .$exportData['hbweight2'] ."</td><td align=center valign=top>" .$exportData['hbqty'] ."</td><td align=right valign=top>" .$hbpriceUnit ."</td><td align=right valign=top>" .$exportData['hbprice'] ."</td></tr>";
			}

			if ($accinc == 'y' && $wrapid == 3) {
				foreach ($exportData['acc'] as $accline) {
					$accdesc = "";
					$acctariff = "";
					$accqty = "";
					$accprice = "";
					
					if (count($exportData['packdata'])>0) {
						$packinfo = $this->PackagingData->find()->where(['CompPartNo' => $accline['orderaccessory_id']]);
						$packinfo=$packinfo->first();
						if ($packinfo['PackedWith']==8) {
							
							$accpackedwith = $this->Accessory->find()->where(['orderaccessory_id' => $packinfo['CompPartNo']]);							
							$accpackedwith=$accpackedwith->first();	
							$exportData['hbdesc'] .= "<br>" .$accpackedwith['description'];
							$exportData['hbtariff'] .= "<br>" .$packinfo['packtariffcode'];
							$exportData['hbqty'] .= "<br>".(intval($accpackedwith['qty'])-intval($accpackedwith['QtyToFollow']));
							$accpricecalc = $this->_getComponentPriceExVatAfterDiscount($accpackedwith['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );	
							if ($wholesale=='y') {
								$accpricecalc = $accpackedwith['wholesalePrice'];
							}						
							$hbpriceUnit .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
							$accpricecalc = $accpricecalc * (intval($accpackedwith['qty'])-intval($accpackedwith['QtyToFollow']));
							$exportData['hbprice'] .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
							$exportData['totalvalue']=floatval($exportData['totalvalue'])+($accpricecalc);
						}
					}
				}
				}
				
				
				if ($accinc == 'y' && $wrapid == 4) {
					$accdesc = "";
					$acctariff = "";
					$accqty = "";
					$accprice = "";
					
					$packinfo = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 9]);
					$packinfo=$packinfo->first();

					if ($packinfo['PackedWith']==8) {
					

					foreach ($exportData['acc'] as $accline) {
						$exportData['hbdesc'] .= "<br>" .$accline['description'] . $accdesc;
						$exportData['hbtariff'] .= "<br>" .$accline['tariffCode'];
						$exportData['hbqty'] .= "<br>".(intval($accline['qty'])-intval($accline['QtyToFollow']));
						$accpricecalc = $this->_getComponentPriceExVatAfterDiscount($accline['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );	
						if ($wholesale=='y') {
							$accpricecalc = $accline['wholesalePrice'];
						}
						if ($accpricecalc==0) {
							$accpricecalc=10;
							}
						$hbpriceUnit .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
						$accpricecalc = $accpricecalc * (intval($accline['qty'])-intval($accline['QtyToFollow']));
						
						$exportData['hbprice'] .="<br>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']);
						$exportData['totalvalue']=floatval($exportData['totalvalue'])+($accpricecalc);
					}
			
			}
			
			}
		$commercialinv .="<tr><td valign=top>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td><td valign=top>". $exportData['hbdesc'] ."</td><td valign=top>" .$exportData['hbdimensions'] ."</td><td valign=top>" .$exportData['hbtariff'] ."</td><td valign=top>" .$exportData['hbweight'] ."</td><td>".$exportData['hbNW']."</td><td align=center valign=top>" .$exportData['hbqty'] ."</td><td align=right valign=top>" .$hbpriceUnit ."</td><td align=right valign=top>" .$exportData['hbprice'] ."</td></tr>";
		}
		
		if ($valanceinc == 'y' && $exportData['valancepackedwith']=='') {
		$commercialinv .="<tr><td>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td><td>Valance 1 pc</td><td>" .$exportData['valancedimensions'] ."</td><td>" .$exportData['valancetariff'] ."</td><td>" .$exportData['valanceweight'] ."</td><td>".$exportData['valanceNW']."</td><td align=center>" .$exportData['valanceqty'] ."</td><td align=right>" .$exportData['valanceprice'] ."</td><td align=right>" .$exportData['valanceprice'] ."</td></tr>";
		}
		
		if ($accinc == 'y' && $wrapid == 1) {
			$accdesc = "";
			$acctariff = "";
			$accqty = "";
			$accprice = "";
			$rowcount=1;
			
			foreach ($exportData['acc'] as $accline) {
			$itempackedwithsomethingelse='n';
				if ($rowcount == 1) {
					$commercialinv .="<tr class=comminv2><td valign=top>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td>";
					} else {
						$commercialinv .="<tr class=comminv2><td valign=top></td>";
						}
				
				
				$commercialinv .="<td valign=top>" .$accline['description'] . $accdesc ."</td>";
				$packinfo='';
				
				$commercialinv .="<td valign=top>" .$accline['size'] ."</td>";
				$commercialinv .="<td valign=top>" .$accline['tariffCode'] ."</td>";
				$commercialinv .="<td valign=top>0</td>";
				$commercialinv .="<td valign=top>0</td>";
				$commercialinv .="<td align=center valign=top>" .(intval($accline['qty'])-intval($accline['QtyToFollow'])) . $accqty ."</td>";
				$accpricecalc = $this->_getComponentPriceExVatAfterDiscount($accline['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
				if ($wholesale=='y') {
					$accpricecalc = $accline['wholesalePrice'];
				}
				if (empty($accpricecalc)) {
							$accpricecalc=10;
							$totalprice=10;
				}
				
				$totalprice=$accline['qty']*$accpricecalc;
				$commercialinv .="<td align=right valign=top>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']) . $accprice ."</td>";
				$commercialinv .="<td align=right valign=top>" .UtilityComponent::formatMoneyWithHtmlSymbol($totalprice, $purchase['ordercurrency']) . $accprice ."</td></tr>";
				$rowcount += 1;
				$exportData['totalvalue']=floatval($exportData['totalvalue'])+($totalprice);
			}
		}

		if ($accinc == 'y' && $wrapid == 2) {
			$accessorySets = $this->PackagingData->getAccessoriesSetsForBoxes($pn);
			foreach ($accessorySets as $set) {
				$accdesc = [];
				$acctariff = [];
				$accqty = [];
				$packagingsize = [];
				$packweight = 0.0;
				$accpriceFormatted = [];
				$totalpriceFormatted = [];
				$n = 0;
				foreach ($set as $row) {
					
					$accdesc[$n] = $row['description'];
					$acctariff[$n] = $row['tariffCode'];
					$accqty[$n] = intval($row['qty']) - intval($row['QtyToFollow']);
					$packagingsize[$n] = "";
					if (!empty($row['packwidth']) && !empty($row['packheight']) && !empty($row['packdepth']) && $row['PackedWith']==0) {
						$packagingsize[$n] = round($row['packwidth']) ."x". round($row['packheight']) ."x". round($row['packdepth']) ."cm";
						$exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(round($row['packwidth'])*round($row['packheight'])*round($row['packdepth']));
					}
					if (!empty($row['packkg']) && $row['PackedWith']==0) {
						$packweight += floatval($row['packkg']);
					}
					$accprice = $this->_getComponentPriceExVatAfterDiscount($row['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate']);
					if ($accprice == 0) $accprice = 10.0;
					if ($wholesale=='y') {
						$accprice = $row['wholesalePrice'];
					}
					$totalprice = $accprice * $accqty[$n];
					$exportData['totalvalue'] += $totalprice;
					$accpriceFormatted[$n] = UtilityComponent::formatMoneyWithHtmlSymbol($accprice, $purchase['ordercurrency']);
					$totalpriceFormatted[$n] = UtilityComponent::formatMoneyWithHtmlSymbol($totalprice, $purchase['ordercurrency']);
					
					$n++;
					
					if ($this->PackagingData->accessoryHasValancePackedWithIt($pn, $row['orderaccessory_id'])) {
						$accdesc[$n] = $exportData['valancedesc'];
						$acctariff[$n] =$exportData['valancetariff'];
						$accqty[$n] = 1;
						$packagingsize[$n] = "";
						$accpriceFormatted[$n] = $exportData['valanceprice'];
						$totalpriceFormatted[$n] = $exportData['valanceprice'];
						$n++;
					}
				}
				$exportData['totalweight'] += $packweight;
				//die;

				$commercialinv .="<tr><td valign=top>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td>";
				$commercialinv .="<td valign=top>" . implode("<br/>", $accdesc) ."</td>";
				$commercialinv .="<td valign=top>" . implode("<br/>", $packagingsize) ."</td>";
				$commercialinv .="<td valign=top>" . implode("<br/>", $acctariff) ."</td>";
				$commercialinv .="<td valign=top>" . $packweight ."</td>";
				$commercialinv .="<td valign=top>" . $packweight ."</td>";
				$exportData['totalNW'] += $packweight;
				$commercialinv .="<td align=center valign=top>" . implode("<br/>", $accqty) ."</td>";
				$commercialinv .="<td align=right valign=top>" . implode("<br/>", $accpriceFormatted) ."</td>";
				$commercialinv .="<td align=right valign=top>" . implode("<br/>", $totalpriceFormatted) ."</td></tr>";
			}
		}
		
		if ($accinc == 'y' && $wrapid == 3) {
			$accessorySets = $this->PackagingData->getAccessoriesSetsForBoxes($pn);
			foreach ($accessorySets as $set) {
				$accdesc = [];
				$acctariff = [];
				$accqty = [];
				$packagingsize = [];
				$packweight = 0.0;
				$accpriceFormatted = [];
				$totalpriceFormatted = [];
				$netwgtString='';
				$n = 0;
				foreach ($set as $row) {
					
					$accdesc[$n] = $row['description'];
					$acctariff[$n] = $row['tariffCode'];
					$accqty[$n] = intval($row['qty']) - intval($row['QtyToFollow']);
					$packagingsize[$n] = "";
					if (!empty($row['packwidth']) && !empty($row['packheight']) && !empty($row['packdepth']) && $row['PackedWith']==0) {
						$export['accNW']=(float)$exportData['packdata']['ProductWgt'];
						$packagingsize[$n] = round($row['packwidth']) ."x". round($row['packheight']) ."x". round($row['packdepth']) ."cm";
						$exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(round($row['packwidth'])*round($row['packheight'])*round($row['packdepth']));
					}

					if (!empty($row['packkg']) && $row['PackedWith']!=0) {
						$packweight += floatval($row['packkg']);
						$netwgtString .= floatval($row['packkg']).'<br>';
					}
					if (!empty($row['packkg']) && $row['PackedWith']==0) {
						$packweight += floatval($row['packkg']);
						$netwgtString .= floatval($row['packkg']).'<br>';
					}

					
					$accprice = $this->_getComponentPriceExVatAfterDiscount($row['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate']);
					if ($accprice == 0) $accprice = 10.0;
					if ($wholesale=='y') {
						$accprice = $row['wholesalePrice'];
					}
					$totalprice = $accprice * $accqty[$n];
					$exportData['totalvalue'] += $totalprice;
					$accpriceFormatted[$n] = UtilityComponent::formatMoneyWithHtmlSymbol($accprice, $purchase['ordercurrency']);
					$totalpriceFormatted[$n] = UtilityComponent::formatMoneyWithHtmlSymbol($totalprice, $purchase['ordercurrency']);
					
					$n++;
					
					if ($this->PackagingData->accessoryHasValancePackedWithIt($pn, $row['orderaccessory_id'])) {
						$accdesc[$n] = $exportData['valancedesc'];
						$acctariff[$n] = $exportData['valancetariff'];
						$accqty[$n] = 1;
						$packagingsize[$n] = "";
						$accpriceFormatted[$n] = $exportData['valanceprice'];
						$totalpriceFormatted[$n] = $exportData['valanceprice'];
						$n++;
					}
				}
				$exportData['totalNW'] += $packweight;
				$exportData['totalweight'] += $packweight;
				$totalNW+= $packweight;
				//die;

				$commercialinv .="<tr><td valign=top>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td>";
				$commercialinv .="<td valign=top>" . implode("<br/>", $accdesc) ."</td>";
				$commercialinv .="<td valign=top>" . implode("<br/>", $packagingsize) ."</td>";
				$commercialinv .="<td valign=top>" . implode("<br/>", $acctariff) ."</td>";
				$commercialinv .="<td valign=top>" . $packweight ."</td>";
				$commercialinv .="<td valign=top>" . $netwgtString ."</td>";
				$commercialinv .="<td align=center valign=top>" . implode("<br/>", $accqty) ."</td>";
				$commercialinv .="<td align=right valign=top>" . implode("<br/>", $accpriceFormatted) ."</td>";
				$commercialinv .="<td align=right valign=top>" . implode("<br/>", $totalpriceFormatted) ."</td></tr>";
			}
		}
			
		
		    $componentdata = TableRegistry::get('Componentdata');
            if ($accinc == 'y' && $wrapid==4) {
				$exportData['packdata'] = $componentdata->getPackagingdata($pn,9)[0];
				if ($exportData['packdata']['PackedWith']==0 || $exportData['packdata']['PackedWith']==NULL) {
					$packagingsize=(float)$exportData['packdata']['packwidth'] ."x". (float)$exportData['packdata']['packheight'] ."x". (float)$exportData['packdata']['packdepth'] ."cm";
					$exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($exportData['packdata']['packwidth'])*floatval($exportData['packdata']['packheight'])*floatval($exportData['packdata']['packdepth']));
					$packweight=floatval($exportData['packdata']['packkg']);
					$exportData['accNW']=(float)$exportData['packdata']['ProductWgt'];
					$exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($packweight);
					$rowcount=1;
					foreach ($exportData['acc'] as $accline) {
						if ($rowcount==1) {
							$commercialinv .="<tr class=comminv2><td>" .($count+=1) ." of " .$exportData['totalitems'] . " " .$wrapname ."</td>";
						} else {
							$commercialinv .="<tr class=comminv2><td>&nbsp;</td>";
						}
					$commercialinv .="<td>" .$accline['description'] ."</td>";
					$packtariffcode=$accline['tariffcode'];
					if ($rowcount==1) {
						$commercialinv .="<td>" .$packagingsize ."</td>";
					} else {
						$commercialinv .="<td>&nbsp;</td>";
					}
					$commercialinv .="<td>" .$accline['tariffCode'] ."</td>";
					if ($rowcount==1) {
						$commercialinv .="<td>" .$packweight ."</td>";
					} else {
						$commercialinv .="<td>&nbsp;</td>";
					}
					if ($rowcount==1) {
						$commercialinv .="<td>" .$exportData['accNW'] ."</td>";
					} else {
						$commercialinv .="<td>&nbsp;</td>";
					}
					$commercialinv .="<td align=center>" .(intval($accline['qty'])-intval($accline['QtyToFollow'])) ."</td>";
					$accpricecalc = $this->_getComponentPriceExVatAfterDiscount($accline['unitprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
					
					if (empty($accpricecalc)) {
								$accpricecalc=10;
								$totalprice=10;
					}
					if ($wholesale=='y') {
							$accpricecalc = $accline['wholesalePrice'];
						}
					$totalprice=$accline['qty']*$accpricecalc;
					$commercialinv .="<td align=right>" .UtilityComponent::formatMoneyWithHtmlSymbol($accpricecalc, $purchase['ordercurrency']) ."</td>";
					$commercialinv .="<td align=right>" .UtilityComponent::formatMoneyWithHtmlSymbol($totalprice, $purchase['ordercurrency']) ."</td></tr>";
					$exportData['totalvalue']=floatval($exportData['totalvalue'])+($totalprice);
					$rowcount += 1;
					} 
			}
		}
	
		
		
		$commercialinv .="<tr><td colspan=8 align=right>VALUE</td><td align=right>" .UtilityComponent::formatMoneyWithHtmlSymbol($exportData['totalvalue'], $purchase['ordercurrency']) ."</td></tr></table>";
		$invoicedate=$collectiondate;
		
		$footer="<table style='position:relative; bottom:0;'><tr><td><p align=left style='font-size:10px;'><br />IT IS HEREBY CERTIFIED that this invoice shows the actual price of the goods described, that no other invoice has been or will be issued and that all particulars are true and correct.The exporter of the products covered by this document (EORI GB706817527000) declares that, except where otherwise clearly indicated, these goods are of United Kingdom preferential origin. Savoir Beds Limited, 1 Old Oak Lane, London, NW10 6UD, United Kingdom<br /><br>These goods are of United Kingdom preferential origin.<br><img src='webroot/img/commercialinv-sig.gif' width='120' height='77' style='margin-top:40px;' /><br>Signature of Authorised Person<br>".$invoicedate."</p><p align=center style='font-size:10px;'>VAT Reg No. GB 706 8175 27<br>EORI Number: GB706817527000<br>Savoir Beds Limited, registered in England: No. 3395749.<br>Registered Address: 1 Old Oak Lane, London NW10 6UD, UK</p></td></tr></table>";
		
		
		$this->set('footer', $footer);
		$this->set('commercialinv', $commercialinv);
		$marksnumbers=$exportData['totalitems'];
		$this->set('marksnumbers', $marksnumbers);
		$this->set('descofgoods', $exportData['descofgoods']);
		$this->set('totalweight', $exportData['totalweight']);
		$this->set('totalNW', $exportData['totalNW']);
		$exportData['cubicmeters']=round((floatval($exportData['cubicmeters'])/1000000), 2, PHP_ROUND_HALF_UP);
		$this->set('cubicmeters', $exportData['cubicmeters']);
		

	}
	
	
	public function _getComponentPriceExVatAfterDiscount($compprice, $discounttype, $discount, $bedsettotal, $istrade, $vatrate) {
		return $this->CommercialData->getComponentPriceExVatAfterDiscount($compprice, $discounttype, $discount, $bedsettotal, $istrade, $vatrate);
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
