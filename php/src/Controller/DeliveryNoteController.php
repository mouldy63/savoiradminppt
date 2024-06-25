<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class DeliveryNoteController extends SecureAppController {

	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
		$this->loadComponent('QrCode');
		$this->loadModel('Purchase');
		$this->loadModel('Location');
		$this->loadModel('Contact');
		$this->loadModel('Address');
		$this->loadModel('Accessory');
		$this->loadModel('ProductionSizes');
		$this->loadModel('Wrappingtypes');
		$this->loadModel('Accessory');
		$this->loadModel('QcHistoryLatest');
		$this->loadModel('ExportLinks');
		$this->loadModel('PackagingData');
		$this->loadModel('PackagingData');
		
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
		
		$formData = $this->request->getData();
		$deltime='';
		$deliveredby='';
		$linkscollectionid='';
		$giftpack='';
		if(isset($formData['deltime'])) {
			$deltime = $formData['deltime'];
		}
		if(isset($formData['deliveredby'])) {
			$deliveredby = $formData['deliveredby'];
		}
		if(isset($formData['shipmentdate'])) {
			$linkscollectionid = $formData['shipmentdate'];
		}

	
		
		$purchase = $this->Purchase->get($pn);
		$purchase->deliveredby = $deliveredby;
		$purchase->delivery_Time = $deltime;
		$this->Purchase->save($purchase);
		
        $query = $this->Purchase->find()->where(['PURCHASE_No' => $pn]);
		$purchase = null;
        $ordernumber = null;
		$orderdate = null;
		$salesusername = null;
		foreach ($query as $row) {
			$purchase = $row;
			
		}
		
		if(isset($formData['giftpack'])) {
			$giftpack = $formData['giftpack'];
		}
		$orderaccessoryid='';
		$orderaccessoryTable = TableRegistry::get('Accessory');
		$orderaccessory = $orderaccessoryTable->find()->where(['purchase_No' => $pn, 'description' => 'Delivery Gift Pack']);
		if ($orderaccessory->count()>0) {
			foreach ($orderaccessory as $row) {
			$orderaccessoryid=$row['orderaccessory_id'];
			}
		}
		$packagingnew='';
		if ($giftpack=='y') {
			if ($orderaccessory->count()==0) {				
				$orderaccessorynew = $orderaccessoryTable->newEntity([]);
				$orderaccessorynew->description = 'Delivery Gift Pack';
				$orderaccessorynew->qty = '1';
				$orderaccessorynew->Status = '70';
				$orderaccessorynew->purchase_no = $pn;
				$orderaccessoryTable->save($orderaccessorynew);
				$orderaccessoryid=$orderaccessorynew->orderaccessory_id;
				
				$purchase = $this->Purchase->get($pn);
				$purchase->accessoriesrequired = 'y';
				$purchase->giftpackrequired = 'y';
				$this->Purchase->save($purchase);
				
				if ($purchase['wrappingid']==3) {
					$packagingnew = $PackagingDataTable->newEntity([]);
					$orderaccessorynew->description = 'Delivery Gift Pack';
					$PackagingDataTable->save($orderaccessorynew);
				}
				
			}
		}  else {
			if ($orderaccessory->count()>0) {
				foreach ($orderaccessory as $row) {
				$packaging = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'CompPartNo' => $orderaccessoryid]);
					foreach ($packaging as $row) {
						$this->PackagingData->delete($row);
					}
				}
				foreach ($orderaccessory as $row) {
					$orderaccessoryTable->delete($row);
				}
				$orderaccessory = $orderaccessoryTable->find()->where(['purchase_No' => $pn]);
				if ($orderaccessory->count()==0) {
					$purchase = $this->Purchase->get($pn);
					$purchase->accessoriesrequired = 'n';
					$purchase->giftpackrequired = 'n';
					$this->Purchase->save($purchase);
				}
				
			}
		}
		$collectiondate='';
		if ($linkscollectionid != '') {
			$exportCollTable = TableRegistry::get('ExportCollShowroom');
			$exportCollections = $exportCollTable->find()->where(['exportCollshowroomsID' => $linkscollectionid]);
			foreach ($exportCollections as $row) {
				$collectionID=$row['exportCollectionID'];
			}
			$exportTable = TableRegistry::get('ExportCollections');
			
			$exports = $exportTable->find()->where(['exportCollectionsID' => $collectionID]);
			foreach ($exports as $row) {
				$collectiondate=$row['CollectionDate'];
			}
		} else {
			if (isset($purchase['bookeddeliverydate'])) {
			$collectiondate=substr($purchase['bookeddeliverydate'],0,10);
			}
		}
		
		if ($linkscollectionid == '') {
			$deliverydate="Delivery Date: <b>" .$collectiondate ."</b>";
		}
		if ($linkscollectionid != '') {
			$deliverydate="Ex-Works Date: <b>" .$collectiondate ."</b>";
		}
		$ordernumber = $purchase['ORDER_NUMBER'];
		$specialinstructionsdelivery = $purchase['specialinstructionsdelivery'];
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
		$this->set('specialinstructionsdelivery', $specialinstructionsdelivery);
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
		
		$customerdetails = '<p style="line-height:14px; font-size:10px; position:relative; top:-15px; left:10px;"><b>Client:</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
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
		$customerdetails.="</p>";
		$this->set('customerdetails', $customerdetails);
		
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
		
		$this->set('customeraddress', $customeraddress);
		
		$deliveryaddress='';
		if ($purchase['deliveryadd1'] != '') {
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
		} else {
			$deliveryaddress = $customeraddress;
			
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
		}
		$this->set('showroomaddress', $showroomaddress);
		$this->set('showroomtel', $showroomtel);
		$pageheight=1;
		
		$header='';
		$header .= "<p class=toplinespace><img src='webroot\\img\\logo.jpg' width='255' height='42' style='position:absolute;right:1px;top:40px;' />";
		if (!empty($deliverydate)) {
			$header .= $deliverydate ."<br>Delivery Time: <b>" .$deltime ."</b><br>Delivered by: <b>" .$deliveredby ."</b>";
			}
		$header .= "</p><p class=deliverynote>Delivery Note<br><span class='pnorderno'>Order Number: " .$ordernumber ."</span></p><hr style=position:relative; top:-60px; margin-bottom:1px;><p class=pnshowroom>Showroom: " .$showroomaddress;
		if ($showroomtel != '') {
		$header .= "<br>" .$showroomtel;
		};
		$header .= "</p>";
		$header .= "<div><img src='" . $docroot . '/' . $this->QrCode->getOrderNumberImageUrl($ordernumber) . "' width='30px' height='30px'  style='position:absolute; top:100px;right:0px;'/></div>";
		
		$this->set('header', $header);
		
		$header2='';
		$header2 .= "<p class=toplinespace><img src='webroot\\img\\logo.jpg' width='255' height='42' style='position:absolute;right:1px;top:40px;' />";
		if (!empty($deliverydate)) {
			$header2 .= "<br><br>".$deliverydate ."<br>Delivery Time: <b>" .$deltime ."</b><br>Delivered by: <b>" .$deliveredby ."</b>";
			}
		$header2 .= "</p><p class=deliverynote>Delivery Note<br><span class='pnorderno'>Order Number: " .$ordernumber ."</span></p><hr style=position:relative; top:-60px; margin-bottom:1px;><p class=pnshowroom>Showroom: " .$showroomaddress;
		if ($showroomtel != '') {
		$header2 .= "<br>" .$showroomtel;
		};
		$header2 .= "</p>";
		$header2 .= "<div><img src='" . $docroot . '/' . $this->QrCode->getOrderNumberImageUrl($ordernumber) . "' width='30px' height='30px'  style='position:absolute; top:100px;right:0px;'/></div>";
		
		$this->set('header2', $header2);
		
		
		$tobedelivered='';
		$accessoriesonly='x';
		
		if ($purchase['mattressrequired'] == 'y' || $purchase['topperrequired'] == 'y' || $purchase['baserequired'] == 'y' || $purchase['headboardrequired'] == 'y' || $purchase['valancerequired'] == 'y' || $purchase['legsrequired'] == 'y') {
			$accessoriesonly='n';
		}
		if ($purchase['accessoriesrequired'] == 'y' && $accessoriesonly=='x') {
			$accessoriesonly='y';
		}
		$this->set('accessoriesonly', $accessoriesonly);
		$legqty=0;
		if ($purchase['legsrequired'] == 'y') {
			if (!empty($purchase['LegQty'])) {
						$legqty=intval($purchase['LegQty']);
					}
					if (!empty($purchase['AddLegQty'])) {
						$legqty=$legqty+intval($purchase['AddLegQty']);
					}
		}
		$legspackedwith='n';
		$valancepackedwith='n';
		$accpackedwith='n';
		
		if ($wraptype=='Crate') {
			$query = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 9]);
			foreach ($query as $Pdata) {
				$accpackedwith=$Pdata['PackedWith'];
				}
			}
		
		$query = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 7]);
		foreach ($query as $Pdata) {
			$legspackedwith=$Pdata['PackedWith'];
		}
		$query = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 6]);
		foreach ($query as $Pdata) {
			$valancepackedwith=$Pdata['PackedWith'];
		}
		$mattressStatus='';
		$mattressPicked='n';
		$mattressdetails='';
		$mattressbay='';
		$mattresscount=0;
		$itemcount=0;
		$itemsdelivered=0;
		$exportinclude='n';
		if ($purchase['mattressrequired'] == 'y') {
			if ($linkscollectionid != '') {
			$query = $this->ExportLinks->find()->where(['purchase_no' => $pn, 'componentID' => 1, 'LinksCollectionID' => $linkscollectionid]);
			if ($query->count()>0) {
				$exportinclude='y';	
				}
			}
			$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 1]);
				foreach ($query as $QCStatusRow) {
				$mattressStatus=$QCStatusRow['QC_StatusID'];
				if ($mattressStatus==60) {
					$mattressPicked='y';
					if ($purchase['bookeddeliverydate']=='' && $exportinclude=='n') {
						$mattressPicked='n';
						$tobedelivered.='Mattress<br>';
					}
				} else {
						if ($mattressStatus !=70 && $mattressStatus !=80) {
						$tobedelivered.='Mattress<br>';
						}
					}
				}
				if ($mattressPicked=='y') {
					$mattressdetails .= "<table width=100% border=0 cellspacing=0px cellpadding=3px>";
					$mattressdetails .= "<tr><td valign=top width=25%><b>Model:</b> " .$purchase['savoirmodel'] ."</td>";
					$mattressdetails .= "<td valign=top width=25%><b>Type:</b> " .$purchase['mattresstype'] ."</td>";
					$mattsize='';
					$mattsize1='';
					$mattsize2='';
					$mattlength1='';
					$mattwidhth1='';
					if (!empty($psizes['Matt1Width'])) {
						$mattsize1 = $psizes['Matt1Width'] ."cm x ";
					}
					if (!empty($psizes['Matt1Length'])) {
						$mattsize1 .= $psizes['Matt1Length'] ."cm. ";
					}
					if (!empty($psizes['Matt2Width'])) {
						$mattsize2 = $psizes['Matt2Width'] ."cm x ";
					}
					if (!empty($psizes['Matt2Length'])) {
						$mattsize2 .= $psizes['Matt2Length'] ."cm. ";
					} 
					if (substr($purchase['mattresswidth'], 0, 3) != 'Spe' && substr($purchase['mattresstype'], 0, 3)=='Zip') {
						$mattwidth1=$purchase['mattresswidth'];
						$mattwidth1 = preg_replace("/[^0-9.]/", "", $purchase['mattresswidth'] );
						if (substr($purchase['mattresswidth'], -2)=='in') {
							$mattwidth1=$mattwidth1*2.54;
							}
							$mattsize1=$mattwidth1/2 ."cm x ";
							$mattsize2=$mattsize1;
 					}
					if (substr($purchase['mattresslength'], 0, 3) != 'Spe' && substr($purchase['mattresstype'], 0, 3)=='Zip') {
						$mattlength1=$purchase['mattresslength'];
						$mattlength1 = preg_replace("/[^0-9.]/", "", $purchase['mattresslength'] );
						if (substr($purchase['mattresslength'], -2)=='in') {
							$mattlength1=$mattlength1*2.54;
							}
							$mattsize1 .= $mattlength1 ."cm";
							$mattsize2 .= $mattsize1;
 					}
					$mattressdetails .= "<td valign=top colspan=2 width=50%><b>Overall Size Required:</b> " .$purchase['mattresswidth'] .' x '.$purchase['mattresslength'] ."</td></tr>";
					if ($mattsize1 != '' || $mattsize2 !='') {
					$mattressdetails .= "<tr><td valign=top width=25%><b>Mattress:</b> " .$mattsize1 ."</td><td valign=top><b>Mattress:</b> " .$mattsize2 ."</td><td colspan=2 valign=top>&nbsp;</td></tr>";
					}
					$mattressdetails .= "<tr><td valign=top><b>LHS:</b> " .$purchase['leftsupport'] ."</td>";
					$mattressdetails .= "<td valign=top><b>RHS:</b> " .$purchase['rightsupport'] ."</td>";
					$mattressdetails .= "<td valign=top colspan=2><b>Ticking:</b> " .$purchase['tickingoptions'] ."</td>";
					$mattressdetails .= "</tr>";
					if ($legspackedwith=='1') {
						$mattressdetails .= "<tr><td colspan=4>Packed with Legs:</td></tr><tr>";
						$mattressdetails .= $this->_getLegs($purchase, $legqty);
						$mattressdetails .= "</tr>";
					}
					if ($valancepackedwith=='1') {
						$mattressdetails .= "<tr><td colspan=4>Packed with Valance:</td></tr><tr>";
						$mattressdetails .= $this->_getValance($purchase);
						$mattressdetails .= "</tr>";
					}
					if ($accpackedwith=='1') {
						$arrayOfIds=[70, 100, 120, 130];
						$arrayOfIds2=[70, 120, 100];
						$acc = $this->Accessory->find()->where(['purchase_no' => $pn, 'Status IN ' => $arrayOfIds, 'Status is not null']);
						$acctofollow = $this->Accessory->find()->where(['purchase_no' => $pn, 'OR' => ['Status NOT IN ' => $arrayOfIds2, 'Status is null']]);
						$mattressdetails .= "<tr><td colspan=4>Packed with Accessories</td></tr>";
						foreach ($acc as $accline) {
						$accqty=intval($accline['qty'])-intval($accline['QtyToFollow']);
						$mattressdetails .= "<tr><td>" .$accqty . 'x' .$accline['description'] ."</td>";
						$mattressdetails .= "<td>" .$accline['design'] ."</td>";
						$mattressdetails .= "<td>" .$accline['colour'] ."</td>";
						$mattressdetails .= "<td>" .$accline['size'] ."</td>";
						$mattressdetails .= "</tr>";
						}
					}
					if ($wraptype=='Box' && $purchase['accessoriesrequired']=='y') {
						
						$query = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 9, 'PackedWith' => 1]);
						if ($query->count()>0) {
							$mattressdetails .= "<tr><td colspan=4>Packed with Accessories:</td></tr>";
							
							foreach ($query as $Pdata) {
								$query2 = $orderaccessoryTable->find()->where(['orderaccessory_id' => $Pdata['CompPartNo']]);
								foreach ($query2 as $Adata) {
									$mattressdetails .= "<tr><td>" .$Adata['qty']." x ".$Adata['description'] ."</td>";
									if ($Adata['design'] != '') {
											$mattressdetails .= "<td><b>Design: </b>".$Adata['design'] ."</td>";
										} else {
											$mattressdetails .= "<td>&nbsp;</td>";
									}
									if ($Adata['colour'] != '') {
											$mattressdetails .= "<td><b>Colour: </b>".$Adata['colour'] ."</td>";
										} else {
											$mattressdetails .= "<td>&nbsp;</td>";
									}
									if ($Adata['size'] != '') {
											$mattressdetails .= "<td><b>Size: </b>".$Adata['size'] ."</td>";
										} else {
											$mattressdetails .= "<td>&nbsp;</td>";
									}
									$mattressdetails .= "</tr>";
								}
							}
						}
					}
					
					$mattressdetails .= "</table>";
					
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
					}
					$itemcount=$mattresscount;
					$this->set('mattressdetails', $mattressdetails);
					$this->set('mattresscount', $mattresscount);
					$this->set('mattressbay', $mattressbay);
					
		}

		$this->set('mattressPicked', $mattressPicked);
			
		$baseStatus='';
		$basePicked='n';
		$basedetails='';
		$basebay='';
		$basecount=0;
		$exportinclude='n';
		if ($purchase['baserequired'] == 'y') {
			if ($linkscollectionid != '') {
			$query = $this->ExportLinks->find()->where(['purchase_no' => $pn, 'componentID' => 3, 'LinksCollectionID' => $linkscollectionid]);
			if ($query->count()>0) {
				$exportinclude='y';	
				}
			}
			$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 3]);
				foreach ($query as $QCStatusRow) {
				$baseStatus=$QCStatusRow['QC_StatusID'];
				if ($baseStatus==60) {
					$basePicked='y';
					if ($purchase['bookeddeliverydate']=='' && $exportinclude=='n') {
						$basePicked='n';
						$tobedelivered.='Base<br>';
					}
				} else {
						if ($baseStatus !=70 && $baseStatus !=80) {
						$tobedelivered.='Base<br>';
						}
					}
				}
				
				if ($basePicked=='y') {
				$basedetails .= "<table width=100% border=0 cellspacing=0px cellpadding=3px>";
				$basedetails .= "<tr><td valign=top width=25%><b>Model:</b> " .$purchase['basesavoirmodel'] ."</td>";
				$basedetails .= "<td valign=top width=25%><b>Type:</b> " .$purchase['basetype'] ."</td>";
				$basesize1='';
				$basesize2='';
				$basewidth1='';
				$basewidth2='';
				$baselength1='';
				$baselength2='';
				if (!empty($psizes['Base1Width'])) {
					$basesize1 = $psizes['Base1Width'] ."cm x ";
				}
				if (!empty($psizes['Base1Length'])) {
					$basesize1 .= $psizes['Base1Length'] ."cm. ";
				}
				if (!empty($psizes['Base2Width'])) {
					$basesize2 = $psizes['Base2Width'] ."cm x ";
				}
				if (!empty($psizes['Base2Length'])) {
					$basesize2 .= $psizes['Base2Length'] ."cm. ";
				} 
				if ((substr($purchase['basetype'], 0, 3)=='Nor' || substr($purchase['basetype'], 0, 3)=='Eas') && substr($purchase['basewidth'], 0, 3)!='Spe' && $purchase['basewidth']!='n') {
					$basewidth1 = preg_replace("/[^0-9.]/", "", $purchase['basewidth'] );
						if (substr($purchase['basewidth'], -2)=='in') {
							$basewidth1=$basewidth1*2.54;
							}
						if (substr($purchase['basetype'], 0, 3)=='Nor') {
							$basesize1=$basewidth1/2 ."cm";
							$basesize2=$basesize1;
							}
						if (substr($purchase['basetype'], 0, 3)=='Eas') {
							$basesize2=$basewidth1;
							}
				}
				if ((substr($purchase['basetype'], 0, 3)=='Nor' || substr($purchase['basetype'], 0, 3)=='Eas') && substr($purchase['baselength'], 0, 3)!='Spe' && $purchase['baselength']!='n') {
					$baselength1 = preg_replace("/[^0-9.]/", "", $purchase['baselength'] );
						if (substr($purchase['baselength'], -2)=='in') {
							$baselength1=$baselength1*2.54;
							}
						if (substr($purchase['basetype'], 0, 3)=='Nor') {
							$basesize1 .= " x " .$baselength1/2 ."cm";
							$basesize2 .= " x " .$baselength1 ."cm";
							}
						if (substr($purchase['basetype'], 0, 3)=='Eas') {
							$basesize2 .= " x " .$basewidth1 ."cm";
							}
				}
				$basedetails .= "<td valign=top colspan=2 width=50%><b>Overall Size Required:</b> " .$purchase['basewidth'] . " x " .$purchase['baselength'] ."</td></tr>";
				if ($basesize1 != '' || $basesize2 != '') {
					$basedetails .= "<tr><td valign=top><b>Base:</b> " .$basesize1 ."</td>";
					$basedetails .= "<td valign=top><b>Base:</b> " .$basesize2 ."</td>";
					$basedetails .= "<td colspan=2 valign=top><b>Ticking:</b> " .$purchase['basetickingoptions'] ."</td></tr>";
					}
				if (substr($purchase['upholsteredbase'], 0, 3)=='Yes') {
					$basedetails .= "<tr><td valign=top colspan='3'><b>Upholstered Base</td><td><b>Ticking:</b> " .$purchase['basetickingoptions'] ."</td></tr>";
				} else {
					if ($basesize1 == '' && $basesize2 == '') {
					$basedetails .= "<tr><td valign=top colspan='4'><b>Ticking:</b> " .$purchase['basetickingoptions'] ."</td></tr>";
					}
				}
				if ($legspackedwith=='3') {
						$basedetails .= "<tr><td colspan=4>Packed with Legs:</td></tr><tr>";
						$basedetails .= $this->_getLegs($purchase, $legqty);
						$basedetails .= "</tr>";
					}
				if ($valancepackedwith=='3') {
						$basedetails .= "<tr><td colspan=4>Packed with Valance:</td></tr><tr>";
						$basedetails .= $this->_getValance($purchase);
						$basedetails .= "</tr>";
					}
				if ($accpackedwith=='3') {
						$arrayOfIds=[70, 100, 120, 130];
						$arrayOfIds2=[70, 120, 100];
						$acc = $this->Accessory->find()->where(['purchase_no' => $pn, 'Status IN ' => $arrayOfIds, 'Status is not null']);
						$acctofollow = $this->Accessory->find()->where(['purchase_no' => $pn, 'OR' => ['Status NOT IN ' => $arrayOfIds2, 'Status is null']]);
						$basedetails .= "<tr><td colspan=4>Packed with Accessories</td></tr>";
						foreach ($acc as $accline) {
						$accqty=intval($accline['qty'])-intval($accline['QtyToFollow']);
						$basedetails .= "<tr><td>" .$accqty . 'x' .$accline['description'] ."</td>";
						$basedetails .= "<td>" .$accline['design'] ."</td>";
						$basedetails .= "<td>" .$accline['colour'] ."</td>";
						$basedetails .= "<td>" .$accline['size'] ."</td>";
						$basedetails .= "</tr>";
						}
					}
				if ($wraptype=='Box' && $purchase['accessoriesrequired']=='y') {
						
						$query = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 9, 'PackedWith' => 3]);
						if ($query->count()>0) {
							$basedetails .= "<tr><td colspan=4>Packed with Accessories:</td></tr>";
							
							foreach ($query as $Pdata) {
								$query2 = $orderaccessoryTable->find()->where(['orderaccessory_id' => $Pdata['CompPartNo']]);
								foreach ($query2 as $Adata) {
									$basedetails .= "<tr><td>" .$Adata['qty']." x ".$Adata['description'] ."</td>";
									if ($Adata['design'] != '') {
											$basedetails .= "<td><b>Design: </b>".$Adata['design'] ."</td>";
										} else {
											$basedetails .= "<td>&nbsp;</td>";
									}
									if ($Adata['colour'] != '') {
											$basedetails .= "<td><b>Colour: </b>".$Adata['colour'] ."</td>";
										} else {
											$basedetails .= "<td>&nbsp;</td>";
									}
									if ($Adata['size'] != '') {
											$basedetails .= "<td><b>Size: </b>".$Adata['size'] ."</td>";
										} else {
											$basedetails .= "<td>&nbsp;</td>";
									}
									$basedetails .= "</tr>";
								}
							}
						}
					}
				$basedetails .= "</table>";
				
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
				}
				$itemcount=$basecount;
				$this->set('basedetails', $basedetails);
				$this->set('basecount', $basecount);
				$this->set('basebay', $basebay);
			}
					
		$this->set('basePicked', $basePicked);
			
		$topperStatus='';
		$topperPicked='n';
		$topperdetails='';
		$topperbay='';
		$toppercount=0;
		$exportinclude='n';
		if ($purchase['topperrequired'] == 'y') {
			if ($linkscollectionid != '') {
			$query = $this->ExportLinks->find()->where(['purchase_no' => $pn, 'componentID' => 5, 'LinksCollectionID' => $linkscollectionid]);
			if ($query->count()>0) {
				$exportinclude='y';	
				}
			}
			$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 5]);
				foreach ($query as $QCStatusRow) {
				$topperStatus=$QCStatusRow['QC_StatusID'];
				if ($topperStatus==60) {
					$topperPicked='y';
					if ($purchase['bookeddeliverydate']=='' && $exportinclude=='n') {
						$topperPicked='n';
						$tobedelivered.='Topper<br>';
					}
				} else {
						if ($topperStatus !=70 && $topperStatus !=80) {
						$tobedelivered.='Topper<br>';
						}
					}
				}
				if ($topperPicked=='y') {
					$topperdetails .= "<table width=100% border=0 cellspacing=0px cellpadding=3px>";
					$topperdetails .= "<tr><td valign=top width=25%><b>Model:</b> " .$purchase['toppertype'] ."</td>";
					$toppersize1='';
					$toppersize2='';
					if (!empty($psizes['topper1Width'])) {
						$toppersize1 .= $psizes['topper1Width'] ."cm x ";
					} else {
						$toppersize1 .= $purchase['topperwidth'] ." x ";
					}
					if (!empty($psizes['topper1Length'])) {
						$toppersize2 .= $psizes['topper1Length'] ."cm. ";
					} else {
						$toppersize2 .= $purchase['topperlength'] .". ";
					}
					$topperdetails .= "<td valign=top width=25%><b>Width:</b> " .$toppersize1 ."</td>";
					$topperdetails .= "<td valign=top width=25%><b>Length:</b> " .$toppersize2 ."</td>";
					$topperdetails .= "<td valign=top width=25%><b>Ticking:</b> " .$purchase['toppertickingoptions'] ."</td>";
					$topperdetails .= "</tr>";
					if ($legspackedwith=='5') {
						$topperdetails .= "<tr><td colspan=4>Packed with Legs:</td></tr><tr>";
						$topperdetails .= $this->_getLegs($purchase, $legqty);
						$topperdetails .= "</tr>";
					}
					if ($valancepackedwith=='5') {
						$topperdetails .= "<tr><td colspan=4>Packed with Valance:</td></tr><tr>";
						$topperdetails .= $this->_getValance($purchase);
						$topperdetails .= "</tr>";
					}
					if ($accpackedwith=='5') {
						$arrayOfIds=[70, 100, 120, 130];
						$arrayOfIds2=[70, 120, 100];
						$acc = $this->Accessory->find()->where(['purchase_no' => $pn, 'Status IN ' => $arrayOfIds, 'Status is not null']);
						$acctofollow = $this->Accessory->find()->where(['purchase_no' => $pn, 'OR' => ['Status NOT IN ' => $arrayOfIds2, 'Status is null']]);
						$topperdetails .= "<tr><td colspan=4>Packed with Accessories</td></tr>";
						foreach ($acc as $accline) {
						$accqty=intval($accline['qty'])-intval($accline['QtyToFollow']);
						$topperdetails .= "<tr><td>" .$accqty . 'x' .$accline['description'] ."</td>";
						$topperdetails .= "<td>" .$accline['design'] ."</td>";
						$topperdetails .= "<td>" .$accline['colour'] ."</td>";
						$topperdetails .= "<td>" .$accline['size'] ."</td>";
						$topperdetails .= "</tr>";
						}
					}
				
					
					
					if ($wraptype=='Box' && $purchase['accessoriesrequired']=='y') {
						
						$query = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 9, 'PackedWith' => 5]);
						if ($query->count()!='') {
							$topperdetails .= "<tr><td colspan=4>Packed with Accessories:</td></tr>";
							
							foreach ($query as $Pdata) {
								$query2 = $orderaccessoryTable->find()->where(['orderaccessory_id' => $Pdata['CompPartNo']]);
								foreach ($query2 as $Adata) {
									$topperdetails .= "<tr><td>" .$Adata['qty']." x ".$Adata['description'] ."</td>";
									if ($Adata['design'] != '') {
											$topperdetails .= "<td><b>Design: </b>".$Adata['design'] ."</td>";
										} else {
											$topperdetails .= "<td>&nbsp;</td>";
									}
									if ($Adata['colour'] != '') {
											$topperdetails .= "<td><b>Colour: </b>".$Adata['colour'] ."</td>";
										} else {
											$topperdetails .= "<td>&nbsp;</td>";
									}
									if ($Adata['size'] != '') {
											$topperdetails .= "<td><b>Size: </b>".$Adata['size'] ."</td>";
										} else {
											$topperdetails .= "<td>&nbsp;</td>";
									}
									$topperdetails .= "</tr>";
								}
							}
						}
					}
					
					$topperdetails .= "</table>";
					$itemsdelivered+=1;
					}
					$toppercount=1;
					$itemcount=1;
					
					$this->set('topperdetails', $topperdetails);
					$this->set('toppercount', $toppercount);
			}
		
		
		
		$legsStatus='';
		$legsPicked='n';
		$legsdetails='';
		$legsbay='';
		$legscount=0;
		$exportinclude='n';
		
		if ($purchase['legsrequired'] == 'y' && ($legspackedwith=='n' || $legspackedwith=='')) {
			
			
			if ($linkscollectionid != '') {
			$query = $this->ExportLinks->find()->where(['purchase_no' => $pn, 'componentID' => 7, 'LinksCollectionID' => $linkscollectionid]);
			if ($query->count()>0) {
				$exportinclude='y';	
				}
			}
			$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 7]);
				foreach ($query as $QCStatusRow) {
				$legsStatus=$QCStatusRow['QC_StatusID'];
				if ($legsStatus==60) {
					$legsPicked='y';
					if ($purchase['bookeddeliverydate']=='' && $exportinclude=='n') {
						$legsPicked='n';
						$tobedelivered.='Legs<br>';
					}
				} else {
						if ($legsStatus !=70 && $legsStatus !=80) {
						$tobedelivered.='Legs<br>';
						}
					}
				}
				if ($legsPicked=='y') {
					$legsdetails .= "<table width=100% border=0 cellspacing=0px cellpadding=3px><tr>";
					$legsdetails .= $this->_getLegs($purchase, $legqty);
					$legsdetails .= "</tr>";
					if ($valancepackedwith=='7') {
						$legsdetails .= "<tr><td colspan=4>Packed with Valance:</td></tr><tr>";
						$legsdetails .= $this->_getValance($purchase);
						$legsdetails .= "</tr>";
					}
					if ($accpackedwith=='7') {
						$arrayOfIds=[70, 100, 120, 130];
						$arrayOfIds2=[70, 120, 100];
						$acc = $this->Accessory->find()->where(['purchase_no' => $pn, 'Status IN ' => $arrayOfIds, 'Status is not null']);
						$acctofollow = $this->Accessory->find()->where(['purchase_no' => $pn, 'OR' => ['Status NOT IN ' => $arrayOfIds2, 'Status is null']]);
						$legsdetails .= "<tr><td colspan=4>Packed with Accessories</td></tr>";
						foreach ($acc as $accline) {
						$accqty=intval($accline['qty'])-intval($accline['QtyToFollow']);
						$legsdetails .= "<tr><td>" .$accqty . 'x' .$accline['description'] ."</td>";
						$legsdetails .= "<td>" .$accline['design'] ."</td>";
						$legsdetails .= "<td>" .$accline['colour'] ."</td>";
						$legsdetails .= "<td>" .$accline['size'] ."</td>";
						$legsdetails .= "</tr>";
						}
					}
					if ($wraptype=='Box' && $purchase['accessoriesrequired']=='y') {
						
						$query = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 9, 'PackedWith' => 7]);
						if ($query->count()>0) {
							$legsdetails .= "<tr><td colspan=4>Packed with Accessories:</td></tr>";
							
							foreach ($query as $Pdata) {
								$query2 = $orderaccessoryTable->find()->where(['orderaccessory_id' => $Pdata['CompPartNo']]);
								foreach ($query2 as $Adata) {
									$legsdetails .= "<tr><td>" .$Adata['qty']." x ".$Adata['description'] ."</td>";
									if ($Adata['design'] != '') {
											$legsdetails .= "<td><b>Design: </b>".$Adata['design'] ."</td>";
										} else {
											$legsdetails .= "<td>&nbsp;</td>";
									}
									if ($Adata['colour'] != '') {
											$legsdetails .= "<td><b>Colour: </b>".$Adata['colour'] ."</td>";
										} else {
											$legsdetails .= "<td>&nbsp;</td>";
									}
									if ($Adata['size'] != '') {
											$legsdetails .= "<td><b>Size: </b>".$Adata['size'] ."</td>";
										} else {
											$legsdetails .= "<td>&nbsp;</td>";
									}
									$legsdetails .= "</tr>";
								}
							}
						}
					}
					$legsdetails .= "</table>";
					$itemsdelivered+=1;
					}
					$legscount=1;
					$itemcount=1;
					
					$this->set('legsdetails', $legsdetails);
					$this->set('legscount', $legscount);
					
			}
		$this->set('legsPicked', $legsPicked);
		
		$valanceStatus='';
		$valancePicked='n';
		$valancedetails='';
		$valancebay='';
		$valancecount=0;
		$exportinclude='n';
		if ($purchase['valancerequired'] == 'y' && ($valancepackedwith=='n' || $valancepackedwith=='')) {
			if ($linkscollectionid != '') {
			$query = $this->ExportLinks->find()->where(['purchase_no' => $pn, 'componentID' => 6, 'LinksCollectionID' => $linkscollectionid]);
			if ($query->count()>0) {
				$exportinclude='y';	
				}
			}
			$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 6]);
				foreach ($query as $QCStatusRow) {
				$valanceStatus=$QCStatusRow['QC_StatusID'];
				if ($valanceStatus==60) {
					$valancePicked='y';
					if ($purchase['bookeddeliverydate']=='' && $exportinclude=='n') {
						$valancePicked='n';
						$tobedelivered.='Valance<br>';
					}
				} else {
						if ($valanceStatus !=70 && $valanceStatus !=80) {
						$tobedelivered.='Valance<br>';
						}
					}
				}
				if ($valancePicked=='y') {
					$valancedetails .= "<table width=100% border=0 cellspacing=0px cellpadding=3px><tr>";
					$valancedetails .= $this->_getValance($purchase);
					$valancedetails .= "</tr>";
					if ($legspackedwith=='6') {
						$valancedetails .= "<tr><td colspan=4>Packed with Legs:</td></tr><tr>";
						$valancedetails .= $this->_getLegs($purchase, $legqty);
						$valancedetails .= "</tr>";
					}
					if ($accpackedwith=='6') {
						$arrayOfIds=[70, 100, 120, 130];
						$arrayOfIds2=[70, 120, 100];
						$acc = $this->Accessory->find()->where(['purchase_no' => $pn, 'Status IN ' => $arrayOfIds, 'Status is not null']);
						$acctofollow = $this->Accessory->find()->where(['purchase_no' => $pn, 'OR' => ['Status NOT IN ' => $arrayOfIds2, 'Status is null']]);
						$legsdetails .= "<tr><td colspan=4>Packed with Accessories</td></tr>";
						foreach ($acc as $accline) {
						$accqty=intval($accline['qty'])-intval($accline['QtyToFollow']);
						$valancedetails .= "<tr><td>" .$accqty . 'x' .$accline['description'] ."</td>";
						$valancedetails .= "<td>" .$accline['design'] ."</td>";
						$valancedetails .= "<td>" .$accline['colour'] ."</td>";
						$valancedetails .= "<td>" .$accline['size'] ."</td>";
						$valancedetails .= "</tr>";
						}
					}
					
					if ($wraptype=='Box' && $purchase['accessoriesrequired']=='y') {
						
						$query = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 9, 'PackedWith' => 6]);
						if ($query->count()>0) {
							$valancedetails .= "<tr><td colspan=4>Packed with Accessories:</td></tr>";
							
							foreach ($query as $Pdata) {
								$query2 = $orderaccessoryTable->find()->where(['orderaccessory_id' => $Pdata['CompPartNo']]);
								foreach ($query2 as $Adata) {
									$valancedetails .= "<tr><td>" .$Adata['qty']." x ".$Adata['description'] ."</td>";
									if ($Adata['design'] != '') {
											$valancedetails .= "<td><b>Design: </b>".$Adata['design'] ."</td>";
										} else {
											$valancedetails .= "<td>&nbsp;</td>";
									}
									if ($Adata['colour'] != '') {
											$valancedetails .= "<td><b>Colour: </b>".$Adata['colour'] ."</td>";
										} else {
											$valancedetails .= "<td>&nbsp;</td>";
									}
									if ($Adata['size'] != '') {
											$valancedetails .= "<td><b>Size: </b>".$Adata['size'] ."</td>";
										} else {
											$valancedetails .= "<td>&nbsp;</td>";
									}
									$valancedetails .= "</tr>";
								}
							}
						}
					}
					
					$valancedetails .= "</table>";
					$itemsdelivered+=1;
					}
					$valancecount=1;
					$itemcount=1;
					
					$this->set('valancedetails', $valancedetails);
					$this->set('valancecount', $valancecount);
			}
		$this->set('valancePicked', $valancePicked);	
		
		$hbStatus='';
		$hbPicked='n';
		$hbdetails='';
		$hbbay='';
		$hbcount=0;
		$exportinclude='n';
		if ($purchase['headboardrequired'] == 'y') {
			if ($linkscollectionid != '') {
			$query = $this->ExportLinks->find()->where(['purchase_no' => $pn, 'componentID' => 8, 'LinksCollectionID' => $linkscollectionid]);
			if ($query->count()>0) {
				$exportinclude='y';	
				}
			}
			$query = $this->QcHistoryLatest->find()->where(['Purchase_No' => $pn, 'ComponentID' => 8]);
				foreach ($query as $QCStatusRow) {
				$hbStatus=$QCStatusRow['QC_StatusID'];
				if ($hbStatus==60) {
					$hbPicked='y';
					if ($purchase['bookeddeliverydate']=='' && $exportinclude=='n') {
						$hbPicked='n';
						$tobedelivered.='Headboard<br>';
					}
				} else {
						if ($hbStatus !=70 && $hbStatus !=80) {
						$tobedelivered.='Headboard<br>';
						}
					}
				}
				if ($hbPicked=='y') {
					$hbdetails .= "<table width=100% border=0 cellspacing=0px cellpadding=3px>";
					$hbdetails .= "<tr><td valign=top width=25%><b>Style:</b> " .$purchase['headboardstyle'] ."</td>";
					$hbdetails .= "<td colspan=2 valign=top width=50%><b>Height:</b> " .$purchase['headboardheight'] ."</td>";
					$hbdetails .= "<td valign=top width=25%><b>Leg Qty:</b> " .$purchase['headboardlegqty'] ."</td>";
					$hbdetails .= "</tr>";
					if ($legspackedwith=='8') {
						$hbdetails .= "<tr><td colspan=4>Packed with Legs:</td></tr><tr>";
						$hbdetails .= $this->_getLegs($purchase, $legqty);
						$hbdetails .= "</tr>";
					}
					if ($valancepackedwith=='8') {
						$hbdetails .= "<tr><td colspan=4>Packed with Valance:</td></tr><tr>";
						$hbdetails .= $this->_getValance($purchase);
						$hbdetails .= "</tr>";
					}
					if ($accpackedwith=='8') {
						$arrayOfIds=[70, 100, 120, 130];
						$arrayOfIds2=[70, 120, 100];
						$acc = $this->Accessory->find()->where(['purchase_no' => $pn, 'Status IN ' => $arrayOfIds, 'Status is not null']);
						$acctofollow = $this->Accessory->find()->where(['purchase_no' => $pn, 'OR' => ['Status NOT IN ' => $arrayOfIds2, 'Status is null']]);
						$legsdetails .= "<tr><td colspan=4>Packed with Accessories</td></tr>";
						foreach ($acc as $accline) {
						$accqty=intval($accline['qty'])-intval($accline['QtyToFollow']);
						$hbdetails .= "<tr><td>" .$accqty . 'x' .$accline['description'] ."</td>";
						$hbdetails .= "<td>" .$accline['design'] ."</td>";
						$hbdetails .= "<td>" .$accline['colour'] ."</td>";
						$hbdetails .= "<td>" .$accline['size'] ."</td>";
						$hbdetails .= "</tr>";
						}
					}
					if ($wraptype=='Box' && $purchase['accessoriesrequired']=='y') {
						
						$query = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 9, 'PackedWith' => 8]);
						if ($query->count()>0) {
							$hbdetails .= "<tr><td colspan=4>Packed with Accessories:</td></tr>";
							
							foreach ($query as $Pdata) {
								$query2 = $orderaccessoryTable->find()->where(['orderaccessory_id' => $Pdata['CompPartNo']]);
								foreach ($query2 as $Adata) {
									$hbdetails .= "<tr><td>" .$Adata['qty']." x ".$Adata['description'] ."</td>";
									if ($Adata['design'] != '') {
											$hbdetails .= "<td><b>Design: </b>".$Adata['design'] ."</td>";
										} else {
											$hbdetails .= "<td>&nbsp;</td>";
									}
									if ($Adata['colour'] != '') {
											$hbdetails .= "<td><b>Colour: </b>".$Adata['colour'] ."</td>";
										} else {
											$hbdetails .= "<td>&nbsp;</td>";
									}
									if ($Adata['size'] != '') {
											$hbdetails .= "<td><b>Size: </b>".$Adata['size'] ."</td>";
										} else {
											$hbdetails .= "<td>&nbsp;</td>";
									}
									$hbdetails .= "</tr>";
								}
							}
						}
					}
					$hbdetails .= "</table>";
					$itemsdelivered+=1;
					}
					$hbcount=1;
					$itemcount=1;
					
					$this->set('hbdetails', $hbdetails);
					$this->set('hbcount', $hbcount);
			}
		$this->set('hbPicked', $hbPicked);
		
		$this->set('tobedelivered', $tobedelivered);
		
		$itemsdelivered = '<p style=font-size:14px;text-align:right;margin-right:10px;><b>&nbsp;&nbsp;&nbsp;TOTAL ITEMS DELIVERED &nbsp;&nbsp;&nbsp;= &nbsp;&nbsp;&nbsp;' .$itemsdelivered .'</b></p>';
		$this->set('itemsdelivered', $itemsdelivered);
		
		//check accessories page 2 is needed 
		$accexists ='n';
		if ($purchase['accessoriesrequired']=='y') {
			$query = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 9]);
			foreach ($query as $Packdata) {
				if (($Packdata['PackedWith'] == null || $Packdata['PackedWith']==0) || ($wraptype == 'Crate' && ($Packdata['PackedWith'] == null || $Packdata['PackedWith']==0))) {
					$accexists ='y';}
			}
		}
		$this->set('accexists', $accexists);
		
		$accdetails='';
		$accrequired='n';
		$acccount=0;
		if ($purchase['accessoriesrequired']=='y') {
			$accrequired='y';
		}
		$this->set('accrequired', $accrequired);
		$arrayOfIds=[70, 100, 120, 130];
		$arrayOfIds2=[70, 120, 100];
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
					if ($wraptype=='Box') {
					$query = $this->PackagingData->find()->where(['Purchase_no' => $pn, 'ComponentID' => 9, 'CompPartNo' => $accline['orderaccessory_id']]);
						foreach ($query as $Packdata) {
							if ($Packdata['PackedWith'] == null || $Packdata['PackedWith']==0) {
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
					}
					if ($wraptype!='Box') {
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
				if ($legspackedwith=='9') {
						$accdetails .= "<tr><td colspan=5>Packed with Legs:</td></tr><tr>";
						$accdetails .= $this->_getLegs($purchase, $legqty);
						$accdetails .= "</tr><tr><td colspan=5></td></tr>";
					}
					if ($valancepackedwith=='9') {
						$accdetails .= "<tr><td colspan=5>Packed with Valance:</td></tr><tr>";
						$accdetails .= $this->_getValance($purchase);
						$accdetails .= "</tr><tr><td colspan=5></td></tr>";
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
		$this->set('topperPicked', $topperPicked);
		if ($accpackedwith != 'n' && $accpackedwith != 0) {
			$accitemsdelivered = '<p style=font-size:14px;><b>&nbsp;&nbsp;&nbsp;ACCESSORIES PACKED WITH ';
			if ($accpackedwith == 1) {
				$accitemsdelivered .= 'MATTRESS';
				}
			if ($accpackedwith == 3) {
				$accitemsdelivered .= 'BASE';
				}
			if ($accpackedwith == 5) {
				$accitemsdelivered .= 'TOPPER';
				}
			if ($accpackedwith == 6) {
				$accitemsdelivered .= 'VALANCE';
				}
			if ($accpackedwith == 7) {
				$accitemsdelivered .= 'LEGS';
				}
			if ($accpackedwith == 8) {
				$accitemsdelivered .= 'HEADBOARD';
				}
			$accitemsdelivered .= '</b></p>';
			} else {
		$accitemsdelivered = '<p style=font-size:14px;><b>&nbsp;&nbsp;&nbsp;TOTAL ACCESSORIES DELIVERED &nbsp;&nbsp;&nbsp;= &nbsp;&nbsp;&nbsp;' .$acccount .'</b></p>';
			}
		$this->set('accitemsdelivered', $accitemsdelivered);
		
		$signature = "<div class=colpayments><div class=ordersummaryhdg><b>Customer's Signature</b></div><div style=padding:5px; ><br>Print Name:<br><br>Company:<br><br><br><p>...........................................................&nbsp;Date:&nbsp;".date("d/m/Y")."</p></div>";
		$signature .= "</div>";
		
		$footer="<table width='100%' border='0' cellspacing='0' cellpadding='3' style='position:absolute; bottom:150px;'>";
		$footer.="<tr style='font-size:10px; line-height:13px;'><td>I have requested that this item should not be assembled or installed today. I understand that if I request assembly in the future that this will incur an assembly charge.</td><td>No claim in respect of any loss or damage to goods in transit or any shortage on delivery will be accepted unless the Customer shall have notified the Company in writing of such loss, damage or shortage within three days of delivery.</td></tr>";
		$footer.="<tr><td>".$signature."</td><td>".$signature."</td></tr></table>";
		$this->set('footer', $footer);
		$pagebreak='';
		$pagebreak="<h5></h5>";
		
		$this->set('pagebreak', $pagebreak);	
	
	}
	
	private function _getLegs($p, $lq) {
		$legs='';
		$legs .= "<td valign=top width=25%><b>Leg Style:</b> " .$p['legstyle'] ."</td>";
		$legs .= "<td valign=top width=25%><b>Leg Finish:</b> " .$p['legfinish'] ."</td>";
		$legs .= "<td valign=top width=25%><b>Leg Height:</b> " .$p['legheight'] ."</td>";
		$legs .= "<td valign=top width=25%><b>Leg Qty:</b> " .$lq ."</td>";
		if ($p['legstyle'] =='Castors') {
						$legs .= "</tr><tr><td valign=top><b>Floor Type:</b> " .$p['floortype'] ."</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>";
					}
		return $legs;
	}
	
	private function _getValance($p) {
		$valance='';
		$valance .= "<td valign=top width=25%><b>No. of Pleats:</b> " .$p['pleats'] ."</td>";
		$valance .= "<td valign=top width=25%><b>Width:</b> " .$p['valancewidth'] ."</td>";
		$valance .= "<td valign=top width=25%><b>Length:</b> " .$p['valancelength'] ."</td>";
		$valance .= "<td valign=top width=25%><b>Drop:</b> " .$p['valancedrop'] ."</td>";
		return $valance;
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
