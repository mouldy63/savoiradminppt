<?php
namespace App\Controller;
use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;

class CommercialManifestController extends SecureAppController
{
    private $LINES_PER_PAGE = 75;
    
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
    	$this->loadModel('Purchase');
    	$this->loadComponent('CommercialData');
		$this->loadModel('Location');
		$this->loadModel('Contact');
		$this->loadModel('Consignee');
		$this->loadModel('Address');
		$this->loadModel('DeliveryAddress');
		$this->loadModel('ProductionSizes');
		$this->loadModel('Wrappingtypes');
		$this->loadModel('Accessory');
		$this->loadModel('ExportCollections');
		$this->loadModel('ExportCollShowroom');
		$this->loadModel('PhoneNumber');
		$this->loadModel('DeliveryTerms');
		$this->loadModel('OverseasDuty');
		$this->loadModel('Shipper');
		$this->loadModel('PackagingData');
		$this->loadModel('ShippingBox');
		$this->loadModel('WholesalePrices');
		
	}
	
	public function beforeRender(EventInterface $event) {
    parent::beforeRender($event);
    	$builder = $this->viewBuilder();
    }
	
	public function index() {
		$this->viewBuilder()->setLayout('manifest');
		$wholesaleprices = TableRegistry::get('WholesalePrices');
		$purchaseTable = TableRegistry::get('Purchase');
		$exportcomponents = TableRegistry::get('ExportCollections');
		$this->viewBuilder()->setOptions([
            'pdfConfig' => [
                'orientation' => 'portrait',
            ]
        ]);
		$docroot=$_SERVER['DOCUMENT_ROOT'];
        $this->set('docroot', $docroot);
        
        $params = $this->request->getParam('?');
	
		if (isset($params['cid'])) {
			$cid = $params['cid'];
		} else {
			$cid='';
		}
		$query = $this->ExportCollections->find()->where(['exportCollectionsID' => $cid]);
		$exportcollections = null;
		foreach ($query as $row) {
			$exportcollections = $row;
		}
		$sid=$exportcollections['Shipper'];
		$collectiondate='';
		$consignee='';
		$consigneeaddress='';
		$consignee=$exportcollections['Consignee'];
		$containerref=$exportcollections['ContainerRef'];
		$collectiondate=$exportcollections['CollectionDate'];
		$destinationport=$exportcollections['DestinationPort'];
		$deliveryterms=$exportcollections['ExportDeliveryTerms'];
		$transportmode=$exportcollections['TransportMode'];
		$deliverytermstxt=$exportcollections['termstext'];
		$delivertoconsignee=$exportcollections['DeliverToConsignee'];
		$this->set('destinationport', $destinationport);
		$this->set('deliveryterms', $deliveryterms);
		
		if ($consignee != '') {
			$query = $this->Consignee->find()->where(['consignee_ADDRESS_ID' => $consignee]);
			foreach ($query as $row) {
			$consigneeadd = $row;
			}
			if (!empty($consigneeadd['consigneeName'])) {
			$consigneeaddress .=$consigneeadd['consigneeName'] ."<br>";
			}
			if (!empty($consigneeadd['ADD1'])) {
				$consigneeaddress .=$consigneeadd['ADD1'] ."<br>";
			}
			if (!empty($consigneeadd['ADD2'])) {
				$consigneeaddress .=$consigneeadd['ADD2'] ."<br>";
			}
			if (!empty($consigneeadd['ADD3'])) {
				$consigneeaddress .=$consigneeadd['ADD3'] ."<br>";
			}
			if (!empty($consigneeadd['TOWN'])) {
				$consigneeaddress .=$consigneeadd['TOWN'] ."<br>";
			}
			if (!empty($consigneeadd['COUNTYSTATE'])) {
				$consigneeaddress .=$consigneeadd['COUNTYSTATE'] ."<br>";
			}
			if (!empty($consigneeadd['POSTCODE'])) {
				$consigneeaddress .=$consigneeadd['POSTCODE'] ."<br>";
			}
			if (!empty($consigneeadd['COUNTRY'])) {
				$consigneeaddress .=$consigneeadd['COUNTRY'] ."<br>";
			}
		}	
			
		$query = $this->ExportCollShowroom->find()->where(['exportCollectionID' => $cid])->order(['ETAdate' => 'DESC']);
		foreach ($query as $row) {
			$eta=$row['ETAdate'];
			break;
		}
		
		$purchase = null;
		$totalnoitems=0;
		
		$query = $this->Shipper->find()->where(['shipper_ADDRESS_ID' => $sid]);
		$shipper = null;
		foreach ($query as $row) {
			$shipper = $row;
		}
		$shippercontact='';
		if (!empty($shipper['shipperName'])) {
			$shippercontact .=$shipper['shipperName'] ."<br>";
		}
		if (!empty($shipper['ADD1'])) {
			$shippercontact .=$shipper['ADD1'] ."<br>";
		}
		if (!empty($shipper['ADD2'])) {
			$shippercontact .=$shipper['ADD2'] ."<br>";
		}
		if (!empty($shipper['ADD3'])) {
			$shippercontact .=$shipper['ADD3'] ."<br>";
		}
		if (!empty($shipper['TOWN'])) {
			$shippercontact .=$shipper['TOWN'] ."<br>";
		}
		if (!empty($shipper['COUNTYSTATE'])) {
			$shippercontact .=$shipper['COUNTYSTATE'] ."<br>";
		}
		if (!empty($shipper['POSTCODE'])) {
			$shippercontact .=$shipper['POSTCODE'] ."<br>";
		}
		if (!empty($shipper['COUNTRY'])) {
			$shippercontact .=$shipper['COUNTRY'] ."<br>";
		}
		if (!empty($shipper['CONTACT'])) {
			$shippercontact .=$shipper['CONTACT'] ."<br>";
		}
		if (!empty($shipper['PHONE'])) {
			$shippercontact .=$shipper['PHONE'] ."<br>";
		}
		
		$query = $this->DeliveryTerms->find()->where(['deliveryTermsID' => $deliveryterms]);
		$deliveryterms = null;
		foreach ($query as $row) {
			$deliveryterms = $row;
		}
		$deliverytermstext='';
		if ($deliveryterms != null) {
			$deliverytermstext=$deliveryterms['DeliveryTerms'];
		}
		$manifestcurrencies = implode(",", $this->ExportCollections->getManifestCurrencies($cid));
		
		if ($consigneeaddress=='') {
			$query = $this->ExportCollections->getManifestPNs($cid);
			$compareaddress1='';
			$compareaddress2='';
			$counter=1;
			$morethan1add=false;
			foreach ($query as $row) {
				if ($counter == 1) {
					$compareaddress1=$this->getConsigneeAddress($row['purchase_no']);
				}
				$compareaddress2=$this->getConsigneeAddress($row['purchase_no']);
				if ($compareaddress1 != $compareaddress2) {
					$morethan1add=true;
				}
				$counter += 1;
			}
			if ($morethan1add==false) {
				$compareaddress1.=$this->getDeliveryContact($row['purchase_no']);
				$consigneeaddress=$compareaddress1;
			}
			//debug($morethan1add);
			//die;
		}
		
		$headerTemplate = "<table width=100%><tr valign='top'><td align=left width=25%><p style='font-size:11px;'>Savoir Beds Limited<br>1 Old Oak Lane<br>London
NW10 6UD<br>UNITED KINGDOM</p></td><td width=50%><p align=center valign='top'><img src='webroot/img/logo-s.gif' /></p></td><td align='right' width=25%><p class='title'>Container Manifest<br><span class='hdrsmalltxt'>(Packing List)<br>Page <N> of <T></span></p></td></tr></table>";
		$headerTemplate .= "<table width=100% cellspacing='1' cellpadding='4' class='comminv'><tr valign='top'><td align=left width=25%>Consignee:<br>".$consigneeaddress."</td><td>Shipped By: <br>". $shippercontact ."</td><td>Container No. ".$containerref."<br><hr>Export Date: ".$collectiondate."<br><hr>Expected Arrival Date: ".$eta."</td></tr>";
		$headerTemplate .= "<tr><td colspan='2'>Terms & Conditions of Delivery and Payment: ".$deliverytermstext." ".$destinationport."</td><td>Mode of Transport: ".$transportmode."</td></tr>";
		$headerTemplate .= "<tr><td>Country of Origin: UK</td><td>Country of Origin of Goods: UK</td><td>Country of Final Destination: ".$destinationport."</td></tr></table>";
		$headerTemplate .= "<table border='1' width='100%' class='manifest'>";
		$headerTemplate .= "<tr><td width=30>Marks&nbsp;&&nbsp;No</td>";
		$headerTemplate .= "<td width=47>Kind of<br>Packages</td><td width=130>Description of Goods</td>";
		$headerTemplate .= "<td width=40>Dimensions</td>";
		$headerTemplate .= "<td width=40>NW(kg)</td>";
		$headerTemplate .= "<td width=40>GW(kg)</td>";
		$headerTemplate .= "<td width=80>Delivery Address</td></tr>";
		$headerLineCount = $this->getHtmlLineCount($headerTemplate);
		
		$footer="<table width=96% style='position:absolute; bottom:20;'><tr><td><p align=center style='font-size:10px;'>VAT Reg. No. GB 706 8175 27<br>Savoir Beds Limited is registered in England & Wales: No. 3395749.<br>Registered Office: 1 Old Oak Lane, London NW10 6UD, UK</p></td></tr></table>";
		$footerLineCount = $this->getHtmlLineCount($footer);
		
		$pageNo = 1;
		$body = str_replace('<N>', $pageNo, $headerTemplate);
		$manifesttable = '';
		
		$query = $this->ExportCollections->getManifestPNs($cid);
		foreach ($query as $row) {
			$collectionsPN = $row;
// 			if ($collectionsPN['purchase_no'] == 79219) { // order_number=83566
// 			    continue;
// 			}
			
		    $query = $this->Purchase->find()->where(['PURCHASE_No' => $collectionsPN['purchase_no']]);
			$purchase = null;
			foreach ($query as $row) {
				$purchase = $row;
			}
			
			$query = $this->Wrappingtypes->find()->where(['WrappingID' => $purchase['wrappingid']]);
			$wrap = null;
			foreach ($query as $row) {
				$wrap = $row;
			}
			$pdfwrapname=$wrap['pdfwrapname'];
			$wrapname=$wrap['wrapName'];
			$wrapid=$wrap['WrappingID'];
			
			$query = $this->ProductionSizes->find()->where(['Purchase_No' => $collectionsPN['purchase_no']]);
			$psizes = null;
			foreach ($query as $row) {
			    $psizes = $row;
			}
			
			$components = $exportcomponents->getItemsForCommercialInvoice($collectionsPN['purchase_no'],$cid);
				
			$mattressinc='n';
			$baseinc='n';
			$topperinc='n';
			$valanceinc='n';
			$legsinc='n';
			$hbinc='n';
			$accinc='n';
			$count=0;
			
			foreach ($components as $componentid) {
			    $compid = $componentid['componentid'];
			    $complast=0;
			    if ($compid==1) {
			        $mattressinc='y';
			        $complast=1;
			    }
			    if ($compid==3) {
			        $baseinc='y';
			        $complast=3;
			    }
			    if ($compid==5) {
			        $topperinc='y';
			        $complast=5;
			    }
			    if ($compid==6) {
			        $valanceinc='y';
			        $complast=6;
			    }
			    if ($compid==7) {
			        $legsinc='y';
			        $complast=7;
			    }
			    if ($compid==8) {
			        $hbinc='y';
			        $complast=8;
			    }
			    if ($compid==9) {
			        $accinc='y';
			        $complast=9;
			    }
			}
				
			$exportData = $this->CommercialData->getExportData($this, $collectionsPN['purchase_no'], $mattressinc, $baseinc, $topperinc, $valanceinc, $legsinc, $hbinc, $accinc, $purchase, $wrapid, 'y', $psizes);
				
				
			$count+=1;
			$compadd1='';
			$compadd2='';
			$daddress='';
			
			//check if base is pegboard
			$haspegboard='n';
			$packpegwith=0;
			$pegdesc = '';
			$componentfirst=0;
			$totalitemsinorder=$exportData['totalitems'];
			
			$linetotal=0;
			if ($baseinc=='y'){
			
				if (substr($exportData['basedesc'],0,8)=='Pegboard') {
					$haspegboard='y';
					$pegdesc = ' & pegboard 2 pc';
					
					if ($mattressinc=='y') {
				        $packpegwith=1;
					} else if ($topperinc=='y') {
						$packpegwith=5;
					} else if ($hbinc=='y') {
						$packpegwith=8;
				    } else {
				    $packpegwith=0;
				    }
				    if ($packpegwith != 0) {
						if ($exportData['basebox']=='2') {
							$totalitemsinorder = $totalitemsinorder-2;
						} else {
							$totalitemsinorder = $totalitemsinorder-1;
						}
					}
				}
			}
			
			$daddress=$this->getConsigneeAddress($collectionsPN['purchase_no']);
			$daddress.=$this->getDeliveryContact($collectionsPN['purchase_no']);
			$ordernoheader="<tr><td class='toprightborder' valign=top width=30 rowspan=".$totalitemsinorder.">".$purchase['ORDER_NUMBER']."<br>".$purchase['customerreference']."</td>";
			
			if ($delivertoconsignee=="y") {
				$daddress=$consigneeaddress;
			}
			
			
			if ($mattressinc=='y') {
			    $mattdesc=$exportData['mattressdesc'];
			    if ($packpegwith==1) {
			    	$mattdesc .= $pegdesc;
			    }
			    if ($exportData['valancepackedwith']==1) {
			        $mattdesc .= "<br>" .$exportData['valancedesc'];
			        $linetotal+=1;
			    }
			    if ($exportData['legspackedwith']==1) {
			        $mattdesc .= "<br>" .$exportData['legdesc'];
			        $linetotal+=1;
			    }
			    if ($exportData['legspackedwith']==9) {
			        $mattdesc .= "<br>" .$exportData['legdesc'];
			    }
			    if ($accinc == 'y' && $wrapid == 3) {
			        foreach ($exportData['acc'] as $accline) {
			            $accdesc = "";
			            $accqty = "";
			            
			            if (count($exportData['packdata'])>0) {
			                $packinfo = $this->PackagingData->find()->where(['CompPartNo' => $accline['orderaccessory_id']]);
			                $packinfo=$packinfo->first();
			                if ($packinfo['PackedWith']==1) {
			                    $accpackedwith = $this->Accessory->find()->where(['orderaccessory_id' => $packinfo['CompPartNo']]);
			                    $accpackedwith=$accpackedwith->first();
			                    $mattdesc .= "<br>" .$accpackedwith['description'];
			                    $linetotal+=1;
			                }
			            }
			        }
			    }
			    if ($accinc == 'y' && $wrapid == 4) {
			        foreach ($exportData['acc'] as $accline) {
			            $accdesc = "";
			            $accqty = "";
			            if (count($exportData['packdata'])>0) {
			                $packinfo = $this->PackagingData->find()->where(['Purchase_no' => $collectionsPN['purchase_no'], 'ComponentID' => 9]);
			                $packinfo=$packinfo->first();
			                if ($packinfo['PackedWith']==1) {
								$mattdesc .= "<br>" .$accline['description'] . $accdesc;
			                    $linetotal+=1;
			            
							}
						}
					}
			    }
			    if ($componentfirst==0) {
			        $componentfirst=1;
                }
                if ($componentfirst==1) {
			        //$borderstyle='topborder';
			    } else {
			        $borderstyle='noborder';
			    }
			    if ($complast==1) {
			        	$borderstyle='topbottom';
			        }
			    $component1='';
			    $component1 .= "<td  class='".$borderstyle."' width=47 valign='top'>".$count." of ".$totalitemsinorder." ".$wrap['pdfwrapname']."</td>";
			    $component1 .= "<td  class='".$borderstyle."' width=130 valign='top'>".$mattdesc."</td>";
			    $component1 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['mattressdimensions']."</td>";
			    $component1 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['matt1NW']."</td>";
			    $component1 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['mattressweight']."</td>";
			    
			    $count+=1;
			    $linetotal+=1;
			    
			    //2nd mattress
			    $component1_2 = '';
			    if ($exportData['mattressbox']=='2') {
			        if ($componentfirst==0) {
			            $componentfirst=1;
			        }
			        $borderstyle='noborder';
			        if ($complast==1) {
			        	$borderstyle='bottomline';
			        }
			        $component1_2 .= "<td class='".$borderstyle."' width=47 valign='top'>".$count." of ".$totalitemsinorder." ".$wrap['pdfwrapname']."</td>";
			        $component1_2 .= "<td  class='".$borderstyle."' width=130 valign='top'>".$exportData['mattressdesc']."</td>";
			        $component1_2 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['mattressdimensions']."</td>";
			        $component1_2 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['matt2NW']."</td>";
			        $component1_2 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['mattressweight2']."</td>";
			        
			        $count+=1;
			        $linetotal+=1;
			    }
			}
				
			if ($baseinc=='y' && $packpegwith==0) {
			
			    if ($exportData['basebox']==2) {
			        //debug($exportData);
			        //die;
			        $basedesc='';
			        $basedesc.=$exportData['basedesc'];
			        
			        if ($componentfirst==0) {
			            $componentfirst=3;
			        }
			        if ($componentfirst==3) {
			           // $borderstyle='topborder';
			        } else {
			            $borderstyle='noborder';
			        }
			        if ($complast==3) {
			        	$borderstyle='topbottom';
			        }
			        $component3='';
			        $component3 .= "<td  class='".$borderstyle."' width=47 valign='top'>".$count." of ".$totalitemsinorder." ".$wrap['pdfwrapname']."</td>";
			        $component3 .= "<td  class='".$borderstyle."' width=130 valign='top'>".$basedesc."</td>";
			        $component3 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['basedimensions2']."</td>";
			        $component3 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['base2NW']."</td>";
			        $component3 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['baseweight2']."</td>";
			        
			        
			        $count+=1;
			        $linetotal+=1;
			    }
			}
			//1st base
			if ($baseinc=='y' && $packpegwith==0) {
			
			    $basedesc='';
			    $basedesc.=$exportData['basedesc'];
			    if ($exportData['valancepackedwith']==3) {
			        $basedesc .= "<br>" .$exportData['valancedesc'];
			        $linetotal+=1;
			    }
			    if ($exportData['legspackedwith']==3) {
			        $basedesc .= "<br>" .$exportData['legdesc'];
			        $linetotal+=1;
			    }
			    if ($accinc == 'y' && $wrapid == 3) {
			        foreach ($exportData['acc'] as $accline) {
			            $accdesc = "";
			            $accqty = "";
			            
			            if (count($exportData['packdata'])>0) {
			                $packinfo = $this->PackagingData->find()->where(['CompPartNo' => $accline['orderaccessory_id']]);
			                $packinfo=$packinfo->first();
			                if ($packinfo['PackedWith']==3) {
			                    $accpackedwith = $this->Accessory->find()->where(['orderaccessory_id' => $packinfo['CompPartNo']]);
			                    $accpackedwith=$accpackedwith->first();
			                    $basedesc .= "<br>" .$accpackedwith['description'];
			                    $linetotal+=1;
			                }
			            }
			        }
			    }
			    if ($accinc == 'y' && $wrapid == 4) {
			        foreach ($exportData['acc'] as $accline) {
			            $accdesc = "";
			            $accqty = "";
			            if (count($exportData['packdata'])>0) {
			                $packinfo = $this->PackagingData->find()->where(['Purchase_no' => $collectionsPN['purchase_no'], 'ComponentID' => 9]);
			                $packinfo=$packinfo->first();
			                if ($packinfo['PackedWith']==3) {
								$basedesc .= "<br>" .$accline['description'] . $accdesc;
			                    $linetotal+=1;
			            
							}
						}
					}
			    }
			    if ($componentfirst==0) {
			        $componentfirst=4;
			    }
			    if ($componentfirst==4) {
			        $borderstyle='topborder';
			    } else {
			        $borderstyle='noborder';
			    }
			    
			    $component4='';
			    $component4 .= "<td  class='".$borderstyle."' width=47 valign='top'>".$count." of ".$totalitemsinorder." ".$wrap['pdfwrapname']."</td>";
			    $component4 .= "<td  class='".$borderstyle."' width=130 valign='top'>".$basedesc."</td>";
			    $component4 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['basedimensions']."</td>";
			    $component4 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['baseNW']."</td>";
			    $component4 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['baseweight']."</td>";
			    
			    
			    $count+=1;
			    $linetotal+=1;
			    
			    
			}
			if ($topperinc=='y') {
			    $topperdesc='';
			    $topperdesc.=$exportData['topperdesc'];
			    if ($packpegwith==5) {
			    	$topperdesc .= $pegdesc;
			    }
			    $topperweight=$exportData['topperweight'];
			    $toppercrate=$exportData['packdata'];
			    if ($exportData['valancepackedwith']==5) {
			        $topperdesc .= "<br>" .$exportData['valancedesc'];
			        $linetotal+=1;
			    }
			    if ($exportData['legspackedwith']==5) {
			        $topperdesc .= "<br>" .$exportData['legdesc'];
			        $linetotal+=1;
			    }
			    
			    if ($accinc == 'y' && $wrapid == 3) {
			        foreach ($exportData['acc'] as $accline) {
			            $accdesc = "";
			            $accqty = "";
			            
			            if (count($exportData['packdata'])>0) {
			                $packinfo = $this->PackagingData->find()->where(['CompPartNo' => $accline['orderaccessory_id']]);
			                $packinfo=$packinfo->first();
			                if ($packinfo['PackedWith']==5) {
			                    $accpackedwith = $this->Accessory->find()->where(['orderaccessory_id' => $packinfo['CompPartNo']]);
			                    $accpackedwith=$accpackedwith->first();
			                    $topperdesc .= "<br>" .$accpackedwith['description'];
			                    $linetotal+=1;
			                }
			            }
			        }
			    }
			    if ($accinc == 'y' && $wrapid == 4) {
			        foreach ($exportData['acc'] as $accline) {
			            $accdesc = "";
			            $accqty = "";
			            if (count($exportData['packdata'])>0) {
			                $packinfo = $this->PackagingData->find()->where(['Purchase_no' => $collectionsPN['purchase_no'], 'ComponentID' => 9]);
			                $packinfo=$packinfo->first();
			                if ($packinfo['PackedWith']==5) {
								$topperdesc .= "<br>" .$accline['description'] . $accdesc;
			                    $linetotal+=1;
			            
							}
						}
					}
			    }
			    
			    if ($componentfirst==0) {
			        $componentfirst=5;
			    }
			    if ($componentfirst==5) {
			        //$borderstyle='topborder';
			    } else {
			        $borderstyle='noborder';
			    }
			    if ($complast==5) {
			        	$borderstyle='topbottom';
			        }
			    
			    $component5='';
			    $component5 .= "<td  class='".$borderstyle."' width=47 class='noborder' valign='top'>".$count." of ".$totalitemsinorder." ".$wrap['pdfwrapname']."</td>";
			    $component5 .= "<td  class='".$borderstyle."' width=130  class='noborder' valign='top'>".$topperdesc."</td>";
			    $component5 .= "<td  class='".$borderstyle."' width=40  class='noborder' valign='top'>".$exportData['topperdimensions']."</td>";
			    $component5 .= "<td  class='".$borderstyle."' width=40  class='noborder' valign='top'>".$exportData['topperNW']."</td>";
			    $component5 .= "<td  class='".$borderstyle."' width=40  class='noborder' valign='top'>".$exportData['topperweight']."</td>";
			    
			    
			    $count+=1;
			    $linetotal+=1;
			    
			    
			    
			    
			}
			if ($valanceinc=='y' && $exportData['valancepackedwith'] =='') {
			    if ($componentfirst==0) {
			        $componentfirst=6;
			    }
			    if ($componentfirst==6) {
			        //$borderstyle='topborder';
			    } else {
			        $borderstyle='noborder';
			    }
			    if ($complast==6) {
			        	$borderstyle='topbottom';
			        }
			    $component6='';
			    $component6 .= "<td  class='".$borderstyle."' width=47 valign='top'>".$count." of ".$totalitemsinorder." ".$wrap['pdfwrapname']."</td>";
			    $component6 .= "<td  class='".$borderstyle."' width=130 valign='top'>".$exportData['valancedesc']."</td>";
			    $component6 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['valancedimensions']."</td>";
			    $component6 .= "<td  class='".$borderstyle."' width=40 valign='top'>NW(kg)</td>";
			    $component6 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['valanceweight']."</td>";
			    
			    
			    $count+=1;
			    $linetotal+=1;
			}
			if ($legsinc=='y' && $exportData['legspackedwith'] =='') {
			    if ($componentfirst==0) {
			        $componentfirst=7;
			    }
			    if ($componentfirst==7) {
			        //$borderstyle='topborder';
			    } else {
			        $borderstyle='noborder';
			    }
			    if ($complast==7) {
			        	$borderstyle='topbottom';
			        }
			    $legsdesc=$exportData['legdesc'];
			    if ($accinc == 'y' && $wrapid == 3) {
			        foreach ($exportData['acc'] as $accline) {
			            $accdesc = "";
			            $accqty = "";
			            
			            if (count($exportData['packdata'])>0) {
			                $packinfo = $this->PackagingData->find()->where(['CompPartNo' => $accline['orderaccessory_id']]);
			                $packinfo=$packinfo->first();
			                if ($packinfo['PackedWith']==7) {
			                    $accpackedwith = $this->Accessory->find()->where(['orderaccessory_id' => $packinfo['CompPartNo']]);
			                    $accpackedwith=$accpackedwith->first();
			                    $legsdesc .= "<br>" .$accpackedwith['description'];
			                    $linetotal+=1;
			                }
			            }
			        }
			    }
			    if ($accinc == 'y' && $wrapid == 4) {
			        foreach ($exportData['acc'] as $accline) {
			            $accdesc = "";
			            $accqty = "";
			            if (count($exportData['packdata'])>0) {
			                $packinfo = $this->PackagingData->find()->where(['Purchase_no' => $collectionsPN['purchase_no'], 'ComponentID' => 9]);
			                $packinfo=$packinfo->first();
			                if ($packinfo['PackedWith']==7) {
			                				            

								$legsdesc .= "<br>" .$accline['description'] . $accdesc;
			                    $linetotal+=1;
			            
							}
						}
					}
			    }
			    $component7='';
			    $component7 .= "<td  class='".$borderstyle."' width=47 valign='top'>".$count." of ".$totalitemsinorder." ".$wrap['pdfwrapname']."</td>";
			    $component7 .= "<td  class='".$borderstyle."' width=130 valign='top'>".$legsdesc."</td>";
			    $component7 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['legdimensions']."</td>";
			    $component7 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['legweight']."</td>";
			    $component7 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['legweight']."</td>";
			    
			    
			    $count+=1;
			    $linetotal+=1;
			    
			    
			}
			if ($hbinc=='y') {
			
				
			    if ($componentfirst==0) {
			        $componentfirst=8;
			    }
			    if ($componentfirst==8) {
			        //$borderstyle='topborder';
			    } else {
			        $borderstyle='noborder';
			    }
			    if ($complast==8) {
			        	$borderstyle='topbottom';
			        }
			    $hbdesc=$exportData['hbdesc'];
			    if ($packpegwith==8) {
			    	$hbdesc .= $pegdesc;
			    }
			    if ($exportData['valancepackedwith']==8) {
			        $hbdesc .= "<br>" .$exportData['valancedesc'];
			        $linetotal+=1;
			    }
			    if ($exportData['legspackedwith']==8) {
			        $hbdesc .= "<br>" .$exportData['legdesc'];
			        $linetotal+=1;
			    }
			    
			    if ($accinc == 'y' && $wrapid == 3) {
			        foreach ($exportData['acc'] as $accline) {
			            $accdesc = "";
			            $accqty = "";
			            
			            if (count($exportData['packdata'])>0) {
			                $packinfo = $this->PackagingData->find()->where(['CompPartNo' => $accline['orderaccessory_id']]);
			                $packinfo=$packinfo->first();
			                if ($packinfo['PackedWith']==8) {
			                    $accpackedwith = $this->Accessory->find()->where(['orderaccessory_id' => $packinfo['CompPartNo']]);
			                    $accpackedwith=$accpackedwith->first();
			                    $hbdesc .= "<br>" .$accpackedwith['description'];
			                    $linetotal+=1;
			                }
			            }
			        }
			    }
			    if ($accinc == 'y' && $wrapid == 4) {
			        foreach ($exportData['acc'] as $accline) {
			            $accdesc = "";
			            $accqty = "";
			            if (count($exportData['packdata'])>0) {
			                $packinfo = $this->PackagingData->find()->where(['Purchase_no' => $collectionsPN['purchase_no'], 'ComponentID' => 9]);
			                $packinfo=$packinfo->first();
			                if ($packinfo['PackedWith']==8) {
			                				            

								$hbdesc .= "<br>" .$accline['description'] . $accdesc;
			                    $linetotal+=1;
			            
							}
						}
					}
			    }
			    $component8='';
			    $component8 .= "<td  class='".$borderstyle."' width=47 valign='top'>".$count." of ".$totalitemsinorder." ".$wrap['pdfwrapname']."</td>";
			    $component8 .= "<td  class='".$borderstyle."' width=130 valign='top'>".$hbdesc."</td>";
			    $component8 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['hbdimensions']."</td>";
			    $component8 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['hbNW']."</td>";
			    $component8 .= "<td  class='".$borderstyle."' width=40 valign='top'>".$exportData['hbweight']."</td>";
			    
			    
			    $count+=1;
			    $linetotal+=1;
			}

			if ($accinc=='y') {
				$borderstyle='noborder';
			    if ($componentfirst==0) {
			        $componentfirst=9;
			        $borderstyle='topborder';
			    }
			    $component9=[];
			    if ($wrapid == 1) {
			        
			        $tmp = "<td class='".$borderstyle."' width=47 valign='top'>".$count." of ".$totalitemsinorder." ".$wrap['pdfwrapname']."</td>";
			        $tmp .= "<td  class='".$borderstyle."' width=130 valign='top'>Accessories</td>";
			        $tmp .= "<td  class='".$borderstyle."' width=40 valign='top'>-</td>";
			        $tmp .= "<td  class='".$borderstyle."' width=40 valign='top'>-</td>";
			        $tmp .= "<td  class='".$borderstyle."' width=40 valign='top'>-</td>";
			        array_push($component9, $tmp);
			        $count+=1;
			        $linetotal+=1;
			    } 
			    if ($wrapid == 3 || $wrapid == 2) {
			        $n = 0;
			        foreach ($exportData['acc'] as $accline) {
			            $packinfo = $this->PackagingData->find()->where(['CompPartNo' => $accline['orderaccessory_id']])->first();
			            if ($packinfo == null || $packinfo['PackedWith'] == null || $packinfo['PackedWith'] == 0) {
			                $n++;
			                if ($componentfirst==9 && $n == 1) {
			                    //$borderstyle='topborder';
			                } else {
			                    $borderstyle='noborder';
			                }
			                 if ($complast==9 && $n == 1) {
			        	$borderstyle='topbottom';
			        }
			                $tmp = "<td class='".$borderstyle."' width=47 valign='top'>".$count." of ".$totalitemsinorder." ".$wrap['pdfwrapname']."</td>";
			                $tmp .= "<td  class='".$borderstyle."' width=130 valign='top'>".$accline['description']."</td>";
			                $tmp .= "<td  class='".$borderstyle."' width=40 valign='top'>-</td>";
			                $tmp .= "<td  class='".$borderstyle."' width=40 valign='top'>-</td>";
			                $tmp .= "<td  class='".$borderstyle."' width=40 valign='top'>-</td>";
			                array_push($component9, $tmp);
			                $count+=1;
			                $linetotal+=1;
			            }
			        }
			    } 
			    if ($wrapid == 4) {
			    	$n = 0;
			        foreach ($exportData['acc'] as $accline) {
			            $packinfo = $this->PackagingData->find()->where(['Purchase_no' => $collectionsPN['purchase_no'], 'ComponentID' => 9])->first();
			            if ($packinfo == null || $packinfo['PackedWith'] == null || $packinfo['PackedWith'] == 0) {
			                $n++;
			                if ($componentfirst==9 && $n == 1) {
			                    //$borderstyle='topborder';
			                } else {
			                    $borderstyle='noborder';
			                }
			                if ($complast==9 && $n == 1) {
			        	$borderstyle='topbottom';
			        }
			                $tmp = "<td class='".$borderstyle."' width=47 valign='top'>".$count." of ".$totalitemsinorder." ".$wrap['pdfwrapname']."</td>";
			                $tmp .= "<td  class='".$borderstyle."' width=130 valign='top'>".$accline['description']."</td>";
			                $tmp .= "<td  class='".$borderstyle."' width=40 valign='top'>-</td>";
			                $tmp .= "<td  class='".$borderstyle."' width=40 valign='top'>-</td>";
			                $tmp .= "<td  class='".$borderstyle."' width=40 valign='top'>-</td>";
			                array_push($component9, $tmp);
			                $count+=1;
			                $linetotal+=1;
			            }
			        }
			    
			    }
			}
				
    		if ($mattressinc == 'y') {
    		    if ($componentfirst==1) {
    		        $manifesttable .= $ordernoheader;
    		        $manifesttable .= $component1;
    		        $totalnoitems=$totalnoitems+1;
    		        $manifesttable .= "<td class='topleftborder' width=80 valign=top rowspan=".$totalitemsinorder.">".$daddress."</td></tr>";
    		    } else {
    		        $totalnoitems=$totalnoitems+1;
    		        $manifesttable .= "<tr>";
    		        $manifesttable .= $component1;
    		        $manifesttable .="</tr>";
    		    }
    		    if ($component1_2 != '') {
    		        $totalnoitems=$totalnoitems+1;
    		        $manifesttable .= "<tr>";
    		        $manifesttable .= $component1_2;
    		        $manifesttable .="</tr>";
    		    }
    		}
				
    		if ($baseinc == 'y' && $exportData['basebox']==2  && $packpegwith==0) {
    			if ($componentfirst==3) {
    				$manifesttable .= $ordernoheader;
    				$manifesttable .= $component3;
    				$totalnoitems=$totalnoitems+1;
    				$manifesttable .= "<td  class='topleftborder' width=80 valign=top rowspan=".$totalitemsinorder.">".$daddress."</td></tr>";
    				} else {
    				$totalnoitems=$totalnoitems+1;
    				
    				$manifesttable .= "<tr>";
    				$manifesttable .= $component3;
    				$manifesttable .= "</tr>";
    			}
    		}
    		if ($baseinc == 'y' && $packpegwith==0) {
    			if ($componentfirst==4) {
    				$manifesttable .= $ordernoheader;
    				$manifesttable .= $component4;
    				$totalnoitems=$totalnoitems+1;
    				$manifesttable .= "<td  class='topleftborder' width=80 valign=top rowspan=".$totalitemsinorder.">".$daddress."</td></tr>";
    				} else {
    				$totalnoitems=$totalnoitems+1;
    				
    				$manifesttable .= "<tr>";
    				$manifesttable .= $component4;
    				$manifesttable .= "</tr>";
    			}
    		}
    		if ($topperinc=='y') {
    			if ($componentfirst==5) {
    				$manifesttable .= $ordernoheader;
    				$manifesttable .= $component5;
    				$totalnoitems=$totalnoitems+1;
    				$manifesttable .= "<td  class='topleftborder' width=80 valign=top rowspan=".$totalitemsinorder.">".$daddress."</td></tr>";
    				} else {
    				$totalnoitems=$totalnoitems+1;
    				$manifesttable .= "<tr>";
    				$manifesttable .= $component5;
    				$manifesttable .= "</tr>";
    			}
    		}
    		if ($valanceinc=='y' && $exportData['valancepackedwith'] !='5' && $exportData['valancepackedwith'] !='3' && $exportData['valancepackedwith'] !='1') {
    			if ($componentfirst==6) {
    				$manifesttable .= $ordernoheader;
    				$manifesttable .= $component6;
    				$totalnoitems=$totalnoitems+1;
    				$manifesttable .= "<td class='topleftborder' width=80 valign=top rowspan=".$totalitemsinorder.">".$daddress."</td></tr>";
    				} else {
    				$totalnoitems=$totalnoitems+1;
    				
    				$manifesttable .= "<tr>";
    				$manifesttable .= $component6;
    				$manifesttable .= "</tr>";
    			}
    		}
    		if ($legsinc=='y' && $exportData['legspackedwith'] !='5' && $exportData['legspackedwith'] !='3' && $exportData['legspackedwith'] !='1') {
    			if ($componentfirst==7) {
    				$manifesttable .= $ordernoheader;
    				$manifesttable .= $component7;
    				$totalnoitems=$totalnoitems+1;
    				$manifesttable .= "<td  class='topleftborder' width=80 valign=top rowspan=".$totalitemsinorder.">".$daddress."</td></tr>";
    				} else {
    				$totalnoitems=$totalnoitems+1;
    				$manifesttable .= "<tr>";
    				$manifesttable .= $component7;
    				$manifesttable .= "</tr>";
    			}
    		}
    		if ($hbinc=='y') {
    			if ($componentfirst==8) {
    				$manifesttable .= $ordernoheader;
    				$manifesttable .= $component8;
    				$totalnoitems=$totalnoitems+1;
    				$manifesttable .= "<td class='topleftborder' width=80 valign=top rowspan=".$totalitemsinorder.">".$daddress."</td></tr>";
    				} else {
    				$totalnoitems=$totalnoitems+1;
    				
    				$manifesttable .= "<tr>";
    				$manifesttable .= $component8;
    				$manifesttable .= "</tr>";
    			}
    		}
    	
    		if ($accinc=='y') {
    		    if ($componentfirst==9) {
    		        $manifesttable .= $ordernoheader;
    		        $n = 0;
    		        foreach ($component9 as $tmp) {
    		            $n++;
    		            if ($n == 1) {
    		                $manifesttable .= $tmp;
    		                $manifesttable .= "<td class='topleftborder' width=80 valign=top rowspan=".$totalitemsinorder.">".$daddress."</td></tr>";
    		            } else {
    		                $manifesttable .= "<tr>";
    		                $manifesttable .= $tmp;
    		                $manifesttable .= "</tr>";
    		            }
    		            $totalnoitems=$totalnoitems+1;
    		        }
    		    } else {
    		        foreach ($component9 as $tmp) {
    		            $totalnoitems=$totalnoitems+1;
    		            $manifesttable .= "<tr>";
    		            $manifesttable .= $tmp;
    		            $manifesttable .= "</tr>";
    		        }
    		    }
    		}
			
		
    		$lineCount = $this->getHtmlLineCount($manifesttable);
    		if (($headerLineCount+$lineCount+$footerLineCount) >= $this->LINES_PER_PAGE) {
    		    $body .= $manifesttable;
    		    $body .= $footer;
    		    $body .= "</table>";
    		    $body .= "<div style='page-break-before: always;'></div>";
    		    
    		    $pageNo++;
    		    $body .= str_replace('<N>', $pageNo, $headerTemplate);
    		    $manifesttable = '';
    		}
		}
		
		if ($manifesttable != '') { // if $manifesttable is empty it means the order entries happened to end at the bottom of a page, so the footer is already there
		    $body .= $manifesttable;
		    $body .= $footer;
		    $body .= "</table>";
		}
		
		$body = str_replace('<T>', $pageNo, $body);
		$body .= "<p align='right' style='padding-right:15px;'><b>Items Total: ".$totalnoitems."</b></p>";
		$this->set('body', $body);
		$this->set('totalnoitems', $totalnoitems);
	}
	
	private function getHtmlLineCount($html) {
	    if ($html == null || !isset($html) || $html == '') {
	        return 0;
	    }
	    $count = substr_count($html,"<table>")*2;
	    $count += substr_count($html,"<table ")*2;
	    $count += substr_count($html,"<th>");
	    $count += substr_count($html,"<th ");
	    $count += substr_count($html,"<tr>");
	    $count += substr_count($html,"<tr ");
	    $count += substr_count($html,"<br>");
	    $count += substr_count($html,"<br/>");
	    return $count;
	}
	
	public function _getComponentPriceExVatAfterDiscount($compprice, $discounttype, $discount, $bedsettotal, $istrade, $vatrate) {
	    if ($discounttype=='percent') {
	        if (!empty($discount)) {
	            $compprice=$compprice * (1-(floatval($discount/100)));
	        }
	    }
	    if ($discounttype=='currency') {
	        if (!empty($discount)) {
	            $discountamt=(floatval($compprice)/floatval($bedsettotal))*floatval($discount);
	            $compprice=(floatval($compprice)-floatval($discountamt));
	            
	        }
	    }
	    if ($istrade=='n' && !empty($vatrate)) {
	        $compprice=(floatval($compprice)/(1+(floatval ($vatrate)/100)));
	    }
	    $compprice=round($compprice,2,PHP_ROUND_HALF_UP);
	    return $compprice;
	}
	
	public function getConsigneeAddress($pno) {
	    $query = $this->Purchase->find()->where(['PURCHASE_No' => $pno]);
		$purchase = null;
		foreach ($query as $row) {
			$purchase = $row;
		}
			$deliveryAddress='';
			$compadd1='';
			$compadd2='';
			$daddress='';
			$deliveryAddressFound='n';
			if ($purchase['deliveryadd1'] != '') {
			    $deliveryAddress=$purchase['deliveryadd1']."<br>";
			    $compadd1=$purchase['deliveryadd1']."<br>";
			}
			if ($purchase['deliveryadd2'] != '') {
			    $deliveryAddress.=$purchase['deliveryadd2']."<br>";
			}
			if ($purchase['deliveryadd3'] != '') {
			    $deliveryAddress.=$purchase['deliveryadd3']."<br>";
			}
			if ($purchase['deliverytown'] != '') {
			    $deliveryAddress.=$purchase['deliverytown']."<br>";
			}
			if ($purchase['deliverycounty'] != '') {
			    $deliveryAddress.=$purchase['deliverycounty']."<br>";
			}
			if ($purchase['deliverypostcode'] != '') {
			    $deliveryAddress.=$purchase['deliverypostcode']."<br>";
			    $compadd1.=$purchase['deliverypostcode']."<br>";
			}
			if ($purchase['deliverycountry'] != '') {
			    $deliveryAddress.=$purchase['deliverycountry']."<br>";
			}
			$daddress=$deliveryAddress;
			$query = $this->DeliveryAddress->find()->where(['CONTACT_NO' => $pno]);
			$deladd = null;
			foreach ($query as $row) {
			    $deladd = $row;
			}
			if ($deladd !=null) {
			    if ($deladd['ADD1']!='') {
			        $compadd2=$deladd['ADD1']."<br>";
			    }
			    if ($deladd['POSTCODE']!='') {
			        $compadd2.=$deladd['POSTCODE']."<br>";
			    }
			    if (strcmp(strtolower($compadd1), strtolower($compadd2)) == 0) {
			        $daddress=$deladd['DELIVERY_NAME']."<br>".$daddress;
			        $deliveryAddressFound='y';
			    }
			}
			if ($deliveryAddressFound=='n') {
			    $query = $this->Address->find()->where(['CODE' => $purchase['CODE']]);
			    $deladd = null;
			    foreach ($query as $row) {
			        $address = $row;
			    }
			    if ($address['street1'] !='') {
			        $compadd2=$address['street1']."<br>";
			    }
			    if ($address['postcode'] !='') {
			        $compadd2.=$address['postcode']."<br>";
			    }
			    if (strcmp(strtolower($compadd1), strtolower($compadd2)) == 0) {
			        $query = $this->Contact->find()->where(['CONTACT_NO' => $purchase['contact_no']]);
			        foreach ($query as $row) {
			            $contactaddress = $row;
			        }
			        $daddress .=$contactaddress['title']." ".$contactaddress['first']." ".$contactaddress['surname']."<br>";
			    }			    
			}
			
	    return $daddress;
	}
	
	public function getDeliveryContact($pno) {
	    $query = $this->Purchase->find()->where(['PURCHASE_No' => $pno]);
		$purchase = null;
		foreach ($query as $row) {
			$purchase = $row;
		}
		$deliverycontact='';
			if ($purchase['deliveryContact'] != '') {
			    $deliverycontact=$purchase['deliveryContact']."<br>";
			}
			$phones='';
			$query = $this->PhoneNumber->find()->where(['purchase_no' => $pno]);
			foreach ($query as $row) {
			    $phonenos = $row;
			    $phones .= $phonenos['phonenumbertype']." ".$phonenos['number']."<br>";
			}
			if ($phones != '') {
			    $deliverycontact .= $phones;
			}
	    return $deliverycontact;
	}
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR");
	}

}

?>
