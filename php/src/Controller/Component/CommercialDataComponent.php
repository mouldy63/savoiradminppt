<?php
namespace App\Controller\Component;

use Cake\ORM\TableRegistry;

class CommercialDataComponent extends \Cake\Controller\Component {
	
	protected $components = ['ArrayHelper'];

	
	public function getExportCollectionWeightAndVolume($exportCollectionsId) {
		$exportCollectionsModel = TableRegistry::getTableLocator()->get('ExportCollections');
		$purchaseModel = TableRegistry::getTableLocator()->get('Purchase');
		$productionSizesModel = TableRegistry::getTableLocator()->get('ProductionSizes');
		
		$totalWeight = 0.0;
		$totalVolume = 0.0;

		$pns = $exportCollectionsModel->getManifestPNs($exportCollectionsId);
		foreach ($pns as $row) {
			$pn = $row['purchase_no'];
			$purchase = $purchaseModel->get($pn);
			$wrapid = $purchase['wrappingid'];
			$components = $exportCollectionsModel->getManifestPNComponentIds($pn, $exportCollectionsId);
			
			$mattressinc = 'n';
			$baseinc = 'n';
			$topperinc = 'n';
			$valanceinc = 'n';
			$legsinc = 'n';
			$hbinc = 'n';
			$accinc = 'n';
			
			foreach ($components as $row) {
				$compid = $row['componentID'];
				switch ($compid) {
				case 1:
					$mattressinc = 'y';
					break;
				case 3:
					$baseinc = 'y';
					break;
				case 5:
					$topperinc = 'y';
					break;
				case 6:
					$valanceinc = 'y';
					break;
				case 7:
					$legsinc = 'y';
					break;
				case 8:
					$hbinc = 'y';
					break;
				case 9:
					$accinc = 'y';
					break;
				}
			}
			
			$wholesale = 'n';
			$query = $productionSizesModel->find()->where(['Purchase_No' => $pn]);
			$psizes = null;
			foreach ($query as $row) {
				$psizes = $row;
			}	
			$exportData = $this->getExportData(null, $pn, $mattressinc, $baseinc, $topperinc, $valanceinc, $legsinc, $hbinc, $accinc, $purchase, $wrapid, $wholesale, $psizes);
			$totalWeight += $exportData['totalweight'];
			$totalVolume += $exportData['cubicmeters']/1000000;
		}
		return ['totalWeight' => $totalWeight, 'totalVolume' => $totalVolume];
	}

    // TODO remove $ctrl from calling args - no longer used
    public function getExportData($ctrl, $pn, $mattressinc, $baseinc, $topperinc, $valanceinc, $legsinc, $hbinc, $accinc, $purchase, $wrapid, $wholesale, $psizes) {
	    $componentdata = TableRegistry::get('Componentdata');
	    $shippingBox = TableRegistry::get('ShippingBox');
	    $wholesalePrices = TableRegistry::get('WholesalePrices');
	    $accessory = TableRegistry::get('Accessory');
	    $packagingData = TableRegistry::get('PackagingData');
	    
	    $exportData = [];
	    $exportData['itemno']=0;
	    $exportData['totalitems']=0;
	    $exportData['descofgoods']='';
	    $exportData['totalweight']=0;
	    $exportData['totalvalue']=0;
	    $exportData['cubicmeters']=0;
	    $exportData['mattressbox']=0;
	    $exportData['mattressdimensions']='';
	    $exportData['mattressprice']=0;
	    $exportData['mattresspriceUnit']='';
	    $exportData['topperpriceUnit']='';
	    $exportData['basepriceUnit']='';
	    $exportData['legpriceUnit']='';
	    $exportData['hbprice']='';
	    $exportData['legspackedwith']='';
	    $exportData['topper2']='';
	    $exportData['hb2']='';
	    $exportData['basedimensions2']='';
	    $exportData['mattressdimensions2']='';
	    $exportData['mattressweight2']='';
	    $exportData['mattressnetweight2']='';
	    $exportData['topperdimensions2']='';
	    $exportData['topperweight2']='';
	    $exportData['hbdimensions2']='';
	    $exportData['hbweight2']='';
	    $exportData['baseweight']='';
	    $exportData['baseweight2']='';
	    $exportData['valanceprice']='';
	    $exportData['hbweight']='';
	    $exportData['hbtariff']='';
	    $exportData['hbdepth']='';
	    $exportData['basebox']='';
	    $exportData['mattressdesc']='';
	    $exportData['mattresstariff']=0;
	    $exportData['mattressqty']=0;
	    $exportData['valancepackedwith']='';
	    $exportData['mattressweight']=0;
	    $exportData['mattressnetweight']=0;
	    $exportData['baseprice']=0;
	    $exportData['basedesc']='';
	    $exportData['basetariff']=0;
	    $exportData['baseweight2']=0;
	    $exportData['baseqty']=0;
	    $exportData['basedimensions']='';
	    $exportData['topperprice']=0;
	    $exportData['topperdesc']='';
	    $exportData['topperdimensions']='';
	    $exportData['toppertariff']=0;
	    $exportData['topperweight']=0;
	    $exportData['topperqty']=0;
	    $exportData['legprice']=0;
	    $exportData['legdesc']='';
	    $exportData['legdimensions']='';
	    $exportData['legtariff']=0;
	    $exportData['legweight']=0;
	    $exportData['legqty']=0;
	    $exportData['acc']='';
	    $exportData['packdata']='';
	    $exportData['hbdesc']='';
	    $exportData['hbdimensions']='';
	    $exportData['hbqty']='';
		$exportData['valancedesc']='';	
		$exportData['valancetariff']='';
		$exportData['valancedimensions']=''; 
		$exportData['valanceweight']='';
		$exportData['valanceqty']='';
		$exportData['topperNW']='';
		$exportData['matt1NW']=''; 
		$exportData['matt2NW']=''; 
		$exportData['baseNW']='';
		$exportData['base2NW']='';
		$exportData['legsNW']=''; 
		$exportData['hbNW']='';
		$exportData['accNW']='';
		$exportData['totalNW']=0;
			    
	    $wholesalePriceData='';
	    $base1width='';
	    $base2width='';
	    $base1length='';
	    $base2length='';
	    $mattress2='';
	    $base2='';
	    $boxinfo2='';
	    $acc2='y';
	    $packedwith='';
	    
	    
	    if ($mattressinc == 'y') {
	        $mattzip='n';
	        $comptariff = $componentdata->getComponentSpecs($purchase['savoirmodel'],1);
	        $exportData['mattresstariff'] = $this->ArrayHelper->getStr($comptariff, [0, 'TARIFFCODE']);
	        $exportData['mattressweight'] = $this->ArrayHelper->getFloat($comptariff, [0, 'WEIGHT']);
	        $mattressdepth = $this->ArrayHelper->getFloat($comptariff, [0, 'DEPTH']);
	        
	        $mattresstype = $purchase['mattresstype'];
	        if (substr($mattresstype, 0, 3)=='Zip') {
	            $mattzip='y';
	            if ($wrapid==1) {
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $exportData['mattressbox']=2;
	            }
	            if ($wrapid==2) {
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $exportData['mattressbox']=2;
	            }
	            if ($wrapid==4) {
	                
	                $exportData['itemno'] += 2;
	            } else {
	                $exportData['itemno'] += 1;
	            }
	        } else {
	            $exportData['itemno'] += 1;
	            
	        }
	        $exportData['mattressqty']=1;
	        $exportData['totalitems']=intval($exportData['totalitems'])+intval($exportData['mattressqty']);
	        
	        if (!empty($psizes['Matt1Width'])) {
	            $matt1width = $psizes['Matt1Width'];
	        } else {
	            $matt1width =str_replace("cm","",$purchase['mattresswidth']);
	        }
	        if (!empty($psizes['Matt1Length'])) {
	            $matt1length = $psizes['Matt1Length'];
	        } else {
	            $matt1length =str_replace("cm","",$purchase['mattresslength']);
	        }
	        if (!empty($psizes['Matt2Width'])) {
	            $matt2width = $psizes['Matt2Width'];
	        }
	        if (!empty($psizes['Matt2Length'])) {
	            $matt2length = $psizes['Matt2Length'];
	        }
	        if ($purchase['savoirmodel']=='n') {
	        	$exportData['mattressdesc']="PIN mattress 1 pc";
	        } else {
	        $exportData['mattressdesc']=$purchase['savoirmodel'] ." mattress 1 pc";
	        }
	        if ($wrapid==4) {
	            $exportData['packdata'] = $componentdata->getPackagingdata($pn,1);
	            $exportData['totalweight'] = $exportData['totalweight'] + $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg']);
	        }
	        
	        if ($wrapid==4) {
	        	$packwidth0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packwidth']);
	        	$packheight0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packheight']);
	        	$packdepth0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packdepth']);
	        	if ($packwidth0 > 0) {
	        		$exportData['mattressdimensions'] = $packwidth0 ."x" .$packheight0 ."x" .$packdepth0 ."cm";
	            } else {
	            	$exportData['mattressdimensions'] = 0;
	            }
	        	
	        	$CompPartNo = $this->ArrayHelper->getStr($exportData, ['packdata',1,'CompPartNo']);
	        	$boxQty = $this->ArrayHelper->getInt($exportData, ['packdata',0,'boxQty']);
	            if (!empty($CompPartNo)) {
		        	$packwidth1 = $this->ArrayHelper->getFloat($exportData, ['packdata',1,'packwidth']);
		        	$packheight1 = $this->ArrayHelper->getFloat($exportData, ['packdata',1,'packheight']);
		        	$packdepth1 = $this->ArrayHelper->getFloat($exportData, ['packdata',1,'packdepth']);

		        	$exportData['mattressdimensions2'] = $packedwith=$packwidth1 . "x" . $packheight1 ."x" . $packdepth1 ."cm";
	                $exportData['mattressbox']=2;
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $exportData['mattressweight']=$this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg']);
	                $exportData['mattressweight2']=$this->ArrayHelper->getFloat($exportData, ['packdata',1,'packkg']);
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['mattressweight2']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(($packwidth0*$packheight0*$packdepth0));
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(($packwidth1*$packheight1*$packdepth1));
	            } else if ($boxQty==2) {
	            	$Boxsize = $this->ArrayHelper->getStr($exportData, ['packdata',0,'Boxsize']);
					$boxinfo = $shippingBox->find()->where(['sName' => $Boxsize])->first();
					$boxweight = $boxinfo['Weight'];
					$exportData['matt2NW']=intval($this->ArrayHelper->getStr($exportData, ['packdata',0,'ProductWgt']));
					$exportData['totalNW'] += $exportData['matt2NW'];
					
	                $exportData['mattressbox']=2;
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $exportData['mattressweight']=$this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg'])/2;
	                
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(($packwidth0*$packheight0*$packdepth0));
	            } else {
	                $exportData['mattressbox']=1;
                	$exportData['mattressweight']=$this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg']);
	                
	            	$Boxsize = $this->ArrayHelper->getStr($exportData, ['packdata',0,'Boxsize']);
	                if (!empty($Boxsize)) {
	                	$boxinfo = $shippingBox->find()->where(['sName' => $Boxsize])->first();
	                	$boxweight = $boxinfo['Weight'];
	                	$exportData['matt1NW']=intval($this->ArrayHelper->getStr($exportData, ['packdata',0,'ProductWgt']));
	                	$exportData['totalNW'] +=$exportData['matt1NW'];
						
		                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(($packwidth0*$packheight0*$packdepth0));
	                } else {
	                	$boxweight = 0;
	                	//$exportData['matt1NW']=0;
	                	$exportData['cubicmeters'] =0;
	                }
					
					
	                if ($mattzip=='y') {
	                	if ($purchase['savoirmodel']=='n') {
	                		$exportData['mattressdesc']="PIN mattress 2 pc";
	                	} else {
	                    	$exportData['mattressdesc']=$purchase['savoirmodel'] ." mattress 2 pc";
	                    }
	                }
	            }
	            
	        } else if ($wrapid==3) {
	            $exportData['packdata'] = $componentdata->getPackagingdata($pn,1);
            	$exportData['totalweight'] = floatval($exportData['totalweight']) + $this->ArrayHelper->getFloat($exportData, ['packdata', 0, 'packkg']);
            	$CompPartNo = $this->ArrayHelper->getStr($exportData, ['packdata', 1, 'CompPartNo']);
				//debug($exportData);
	            if (!empty($CompPartNo)) {
	                $mattress2='y';
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + $this->ArrayHelper->getFloat($exportData, ['packdata', 1, 'packkg']);
	                $exportData['itemno'] += 1;
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	            }
	            $Boxsize = $this->ArrayHelper->getStr($exportData, ['packdata',0,'Boxsize']);
	            if (!empty($Boxsize)) {
	            	$boxinfo = $shippingBox->find()->where(['sName' => $Boxsize])->first();
	            }
	            if ($mattress2=='y') {
	            	$Boxsize1 = $this->ArrayHelper->getStr($exportData, ['packdata',1,'Boxsize']);
	            	if (!empty($Boxsize1)) {
		                $boxinfo2 = $shippingBox->find()->where(['sName' => $Boxsize1])->first();
		                $exportData['mattressdimensions2'] = floatval($boxinfo2['Width']) ."x" .floatval($boxinfo2['Length']) ."x" .floatval($boxinfo2['Depth']) ."cm";
		                $exportData['mattressweight2']=$this->ArrayHelper->getFloat($exportData, ['packdata', 1, 'packkg']);
		                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($boxinfo2['Width'])*floatval($boxinfo2['Length'])*floatval($boxinfo2['Depth']));
	                }
	            }
	            if (isset($boxinfo)) {
	            	$exportData['mattressdimensions'] = floatval($boxinfo['Width']) ."x" .floatval($boxinfo['Length']) ."x" .floatval($boxinfo['Depth']) ."cm";
	            }
	            $exportData['mattressweight']=$this->ArrayHelper->getFloat($exportData, ['packdata', 0, 'packkg']);
	            if (isset($boxinfo)) {
	            	$exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($boxinfo['Width'])*floatval($boxinfo['Length'])*floatval($boxinfo['Depth']));
	            }
	        } else {
	            
	            $exportData['mattressdimensions'] = $matt1width ."x" .$matt1length ."x" .(float)$mattressdepth ."cm";
	            
	            $exportData['mattressweight']=$this->ArrayHelper->getFloat($comptariff, [0,'WEIGHT']);

	            $exportData['mattressweight']=ceil(((floatval($matt1width)*floatval($matt1length))*$exportData['mattressweight']));
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($matt1width)*floatval($matt1length)*floatval($mattressdepth));
	            $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['mattressweight']);
	        }
	        if ($wrapid==3 || $wrapid==4) {
				//debug($boxinfo);
				//debug($mattress2);
	      	  if (isset($boxinfo)) {
	      		$Boxsize = $this->ArrayHelper->getStr($exportData, ['packdata',0,'Boxsize']);
				$boxinfo = $shippingBox->find()->where(['sName' => $Boxsize])->first();
				$boxweight = $boxinfo['Weight'];
				}
			}
			if ($wrapid==3) {
	      	  if (isset($boxinfo)) {
				$exportData['matt1NW']=intval($this->ArrayHelper->getStr($exportData, ['packdata',0,'ProductWgt']));
				$exportData['totalNW'] +=$exportData['matt1NW'];
				if ($mattress2=='y') {
				$exportData['matt2NW']=intval($this->ArrayHelper->getStr($exportData, ['packdata',1,'ProductWgt']));
				$exportData['totalNW'] +=$exportData['matt2NW'];
				}			
				
			}
			
	    }
	        
	        
	        $exportData['mattressprice']=$purchase['mattressprice'];
	        $mattresspricecalc = $this->getComponentPriceExVatAfterDiscount($exportData['mattressprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
	        
	        
	        if (empty($purchase['mattressprice'])) {
	            $mattresspricecalc=10;
	        }
	        if ($wholesale=='y') {
	            $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 1 );
	            if (count($wholesalePriceData) > 0) {
	                $mattresspricecalc=$this->ArrayHelper->getFloat($wholesalePriceData, [0, 'price']);
	            } else {
	            	$mattresspricecalc=0.00;
	            }
	        }

	        $exportData['totalvalue']=floatval($exportData['totalvalue'])+floatval($mattresspricecalc);
	        if ($mattzip=='y' && $wrapid==1) {
	            $mattresspricecalc=$mattresspricecalc/2;
	            $exportData['mattressbox']=2;
	        }
	        if ($mattress2=='y') {
	            $mattresspricecalc=$mattresspricecalc/2;
	            $exportData['mattressbox']=2;
	        }
	        
	        if ($mattzip=='y' && $wrapid==2) {
	        
	            if (substr($purchase['mattresswidth'], 0, 3)!='Spe') {
	                $exportData['mattressdimensions'] = $matt1width/2 ."x" .$matt1length ."x" .(float)$mattressdepth ."cm";
	                $exportData['mattressdimensions2'] = $matt1width/2 ."x" .$matt1length ."x" .(float)$mattressdepth ."cm";
	                $exportData['mattressweight']=ceil($exportData['mattressweight']/2);
	                $exportData['mattressweight2']=$exportData['mattressweight'];
	                $exportData['totalweight'] =floatval($exportData['mattressweight'])*2;
	                
	                
	            } else {
	                $exportData['mattressdimensions'] = $matt1width ."x" .$matt1length ."x" .(float)$mattressdepth ."cm";
	                $exportData['mattressdimensions2'] = $matt1width ."x" .$matt1length ."x" .(float)$mattressdepth ."cm";
	                $exportData['mattressweight']=ceil($exportData['mattressweight']);
	                $exportData['mattressweight2']=$exportData['mattressweight'];
	                $exportData['totalweight'] =$exportData['totalweight']+floatval($exportData['mattressweight']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($matt1width)*floatval($matt1length)*floatval($mattressdepth));
	            }
	            
	            $mattresspricecalc=$mattresspricecalc/2;
	        }
	        if ($mattzip=='y' && $wrapid==1) {
	            if (substr($purchase['mattresswidth'], 0, 3)!='Spe') {
	                $matt1width=$matt1width/2;
	                $exportData['mattressweight']=$exportData['mattressweight']/2;
	            }
	            $exportData['mattressdimensions2'] = $matt1width ."x" .$matt1length ."x" .(float)$mattressdepth ."cm";
	            $exportData['mattressdimensions'] = $matt1width ."x" .$matt1length ."x" .(float)$mattressdepth ."cm";
	            $exportData['mattressweight2']=$exportData['mattressweight'];
	        }
	        
	        if ($mattzip=='y' && $wrapid==1) {
	            if (substr($purchase['mattresswidth'], 0, 3)=='Spe') {
	                $matt1width=$matt1width;
	                $exportData['totalweight'] =$exportData['totalweight']+floatval($exportData['mattressweight']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($matt1width)*floatval($matt1length)*floatval($mattressdepth));
	            }
	            $exportData['mattressdimensions2'] = $matt1width ."x" .$matt1length ."x" .(float)$mattressdepth ."cm";
	            $exportData['mattressdimensions'] = $matt1width ."x" .$matt1length ."x" .(float)$mattressdepth ."cm";
	            $exportData['mattressweight2']=$exportData['mattressweight'];
	            
	            //$exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($matt1width)*floatval($matt1length)*floatval($mattressdepth));
	        }
	        if ($wrapid==2) {
				$exportData['matt1NW']=$exportData['mattressweight'];
				$exportData['totalNW'] +=$exportData['matt1NW'];
				if ($mattzip=='y') {
				$exportData['matt2NW']=$exportData['mattressweight2'];
				$exportData['totalNW'] +=$exportData['matt2NW'];
				}

	        }
	        if ($wrapid==1) {
				$exportData['matt1NW']=$exportData['mattressweight'];
				$exportData['totalNW'] +=$exportData['matt1NW'];
				if ($mattzip=='y') {
				$exportData['matt2NW']=$exportData['mattressweight2'];
				$exportData['totalNW'] +=$exportData['matt2NW'];
				}

	        }
	        
	        
	        $exportData['descofgoods'].="Mattress&nbsp;";
	        $boxQty0 = $this->ArrayHelper->getInt($exportData, ['packdata',0,'boxQty']);
	        $boxQty1 = $this->ArrayHelper->getInt($exportData, ['packdata',1,'boxQty']);
	        if ($wrapid==4 && ($boxQty0==2 || $boxQty1 > 0)) {
	            $mattresspricecalc = $mattresspricecalc/2;
				$exportData['matt1NW']=intval($this->ArrayHelper->getStr($exportData, ['packdata',0,'ProductWgt']))/2;
				$exportData['matt2NW']=intval($this->ArrayHelper->getStr($exportData, ['packdata',0,'ProductWgt']))/2;
				$exportData['mattressweight']=$this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg'])/2;
				$exportData['mattressweight2']=$this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg'])/2;
				$exportData['mattressdimensions2'] = $exportData['mattressdimensions'];
	        }
	        
	        $exportData['mattressprice'] = UtilityComponent::formatMoneyWithHtmlSymbol($mattresspricecalc, $purchase['ordercurrency']);
	        
	    }
	    
	    
	    if ($baseinc == 'y') {
	        $comptariff = $componentdata->getComponentSpecs($purchase['basesavoirmodel'],3);
	        if (count($comptariff)>0) {
	            $exportData['basetariff']=$this->ArrayHelper->getStr($comptariff, [0,'TARIFFCODE']);
	            $exportData['baseweight']=$this->ArrayHelper->getFloat($comptariff, [0,'WEIGHT']);
	            $basedepth=$this->ArrayHelper->getFloat($comptariff, [0,'DEPTH']);
	        } else {
	            $exportData['basetariff']=0;
	            $exportData['baseweight']=0;
	            $basedepth=0;
	        }
	        

	        
	        if (!empty($psizes['Base1Width'])) {
	            $base1width = $psizes['Base1Width'];
	        } else {
	            $base1width =str_replace("cm","",$purchase['basewidth']);
	        }
	        
	        if (!empty($psizes['Base1Length'])) {
	            $base1length = $psizes['Base1Length'];
	        } else {
	            $base1length =str_replace("cm","",$purchase['baselength']);
	        }
	        
	        if (!empty($psizes['Base2Width'])) {
	            $base2width = $psizes['Base2Width'];
	        }
	        if (!empty($psizes['Base2Length'])) {
	            $base2length = $psizes['Base2Length'];
	        }
	        //if base width / length in inches
	        if (substr($base1width, -2)=='in') {
	            $base1width =str_replace("in","",$base1width);
	            $base1width=floatval($base1width)*2.54;
	        }
	        if (substr($base2width, -2)=='in') {
	            $base2width =str_replace("in","",$base2width);
	            $base2width=floatval($base2width)*2.54;
	        }
	        if (substr($base1length, -2)=='in') {
	            $base1length =str_replace("in","",$base1length);
	            $base1length=floatval($base1length)*2.54;
	        }
	        if (substr($base2length, -2)=='in') {
	            $base2length =str_replace("in","",$base2length);
	            $base2length=floatval($base2length)*2.54;
	        }
	        
	        // 	        if ($pn == 79219) {
// 	            debug($exportData['totalitems']);
// 	        }
	        
	        if (substr($purchase['basetype'], 0, 3)=='Eas'  || substr($purchase['basetype'], 0, 3)=='Nor') {
	            $exportData['itemno'] += 2;
	            $exportData['baseqty']=1;
	            if ($wrapid==1) {
	                $exportData['baseqty']=2;
	            }
	            if ($wrapid==2) {
	                $exportData['baseqty']=2;
	                $base2='y';
	            }
	            
	            $exportData['basedimensions'] = $base1width ."x" .$base1length ."x" .(float)$basedepth ."cm";
	            $base2width=$base1width;
	        } else {
	            $exportData['itemno'] += 1;
	            $exportData['baseqty']=1;
	        }
	        
	        $exportData['totalitems']=intval($exportData['totalitems'])+intval($exportData['baseqty']);
// 	        if ($pn == 79219) {
// 	            debug($psizes);
// 	            die;
// 	        }
	        
	        //cope with North split dimensions for base 1
	        if (substr($purchase['basetype'], 0, 3)=='Nor' && empty($psizes['Base1Width']) && substr($purchase['basewidth'], 0, 3)!='Spe' && substr($purchase['basewidth'], 0, 1)!='n') {
	            $basewidthNor=$base1width;
	            $base1width=floatval($basewidthNor)/2;
	            $base2width=floatval($basewidthNor)/2;
	            $base2length=$base1length;
	            $exportData['basedimensions2'] = $base2width ."x" .$base2length ."x" .(float)$basedepth ."cm";
	            if ($wrapid==1) {
	                $base2='y';
	                
	                $exportData['basedimensions'] = $base1width ."x" .$base1length ."x" .(float)$basedepth ."cm";
	                $exportData['basedimensions2'] = $base2width ."x" .$base2length ."x" .(float)$basedepth ."cm";
	            }
	        }
	        
	        if (substr($purchase['basetype'], 0, 3)=='Eas' && empty($psizes['Base1Width']) && substr($purchase['basewidth'], 0, 3)!='Spe' && substr($purchase['basewidth'], 0, 1)!='n') {
	            $base2length=floatval($base1length)-130;
	            $base1length=130;
	            if ($wrapid==1) {
	                $base2='y';
	                //$exportData['totalitems']=intval($exportData['totalitems'])+1;
	            }
	        }
	        
	        if ($purchase['basesavoirmodel']=='n') {
	        	$exportData['basedesc']="PIN base 1 pc";
	        } else {
	        	$exportData['basedesc']=$purchase['basesavoirmodel'] ." base 1 pc";
	        }
	        if ($wrapid==4 && (substr($purchase['basetype'], 0, 3)=='Eas' || substr($purchase['basetype'], 0, 3)=='Nor')) {
	            $exportData['basedesc']=$purchase['basesavoirmodel'] ." base 2 pc";
	        }
	        if ($wrapid==3) {
	            $exportData['packdata'] = $componentdata->getPackagingdata($pn,3);
	            if (count($exportData['packdata']) > 0) {
	                $exportData['baseweight']=$this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg']);
	            } else {
	                $exportData['baseweight']=0;
	            }
	            
	        }
	        if ($wrapid==4) {
	            $exportData['packdata'] = $componentdata->getPackagingdata($pn,3);
	            $exportData['baseweight'] = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg']);
	           
	        }
	        if ($wrapid==4) {
	        	if (isset($exportData['packdata'][0]['packwidth'])) {
		        	$packwidth0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packwidth']);
		        	$packheight0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packheight']);
		        	$packdepth0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packdepth']);
	        		$exportData['basedimensions'] = $packedwith=$packwidth0 ."x" .$packheight0 ."x" .$packdepth0 ."cm";
	        		$exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+($packwidth0*$packheight0*$packdepth0);
	        	} else {
	        		$exportData['basedimensions'] = 0;
	        		$exportData['cubicmeters'] =0;
	        	}
	            
	        	$CompPartNo = $this->ArrayHelper->getStr($exportData, ['packdata',1,'CompPartNo']);
	            if (!empty($CompPartNo)) {
		        	$packwidth1 = $this->ArrayHelper->getFloat($exportData, ['packdata',1,'packwidth']);
		        	$packheight1 = $this->ArrayHelper->getFloat($exportData, ['packdata',1,'packheight']);
		        	$packdepth1 = $this->ArrayHelper->getFloat($exportData, ['packdata',1,'packdepth']);
		        	$exportData['basedimensions2'] = $packedwith=$packwidth1 . "x" . $packheight1 ."x" . $packdepth1 ."cm";
	                $base2='y';
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $exportData['baseweight']=$this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg']);
	                $exportData['baseweight2']=$this->ArrayHelper->getFloat($exportData, ['packdata',1,'packkg']);
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['baseweight2']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(($packwidth1*$packheight1*$packdepth1));
	            }
	        } else if ($wrapid==3) {
	            
	            if (count($exportData['packdata']) > 0) {
	            	$Boxsize = $this->ArrayHelper->getStr($exportData, ['packdata',0,'Boxsize']);
	                $boxinfo = $shippingBox->find()->where(['sName' => $Boxsize])->first();
	                $exportData['basedimensions'] = floatval($boxinfo['Width']) ."x" .floatval($boxinfo['Length']) ."x" .floatval($boxinfo['Depth']) ."cm";
	                $exportData['baseweight']=$this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg']);
	            } else {
	                $exportData['basedimensions'] = "";
	                $exportData['baseweight'] = 0;
	            }
	            
	        	$CompPartNo = $this->ArrayHelper->getStr($exportData, ['packdata',1,'CompPartNo']);
	            if (count($exportData['packdata']) > 1 && !empty($CompPartNo)) {
	                $base2='y';
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $Boxsize = $this->ArrayHelper->getStr($exportData, ['packdata',1,'Boxsize']);
	                $boxinfo2 = $shippingBox->find()->where(['sName' => $Boxsize])->first();
	                $exportData['baseweight2']=$this->ArrayHelper->getFloat($exportData, ['packdata',1,'packkg']);
	                
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['baseweight2']);
	                $exportData['basedimensions2'] = floatval($boxinfo2['Width']) ."x" .floatval($boxinfo2['Length']) ."x" .floatval($boxinfo2['Depth']) ."cm";
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($boxinfo2['Width'])*floatval($boxinfo2['Length'])*floatval($boxinfo2['Depth']));
	            }
	            if (isset($boxinfo)) {
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($boxinfo['Width'])*floatval($boxinfo['Length'])*floatval($boxinfo['Depth']));
	            }
	        } else {
	            $exportData['basedimensions'] = $base1width ."x" .$base1length ."x" .(float)$basedepth ."cm";
	            if (count($comptariff)>0) {
	                $exportData['baseweight']=$this->ArrayHelper->getFloat($comptariff, [0,'WEIGHT']);
	            } else {
	                $exportData['baseweight']=0;
	            }
	            $exportData['baseweight']=ceil(((floatval($base1width)*floatval($base1length))*$exportData['baseweight']));
	            
	            if ($base2=='y') {
	                $exportData['baseweight2']=$exportData['baseweight'];
	                $exportData['basedimensions2'] = $base2width ."x" .$base2length ."x" .(float)$basedepth ."cm";
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['baseweight2']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($base1width)*floatval($base1length)*floatval($basedepth));
	            }
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($base1width)*floatval($base1length)*floatval($basedepth));
	        }
	        
	        $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['baseweight']);
	        $exportData['baseprice']=floatval($purchase['baseprice'])+floatval($purchase['basetrimprice'])+floatval($purchase['upholsteryprice'])+floatval($purchase['basefabricprice'])+floatval($purchase['basedrawersprice']);
	        
	        $basepricecalc = $this->getComponentPriceExVatAfterDiscount($exportData['baseprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
	        if (empty($exportData['baseprice'])) {
	            $basepricecalc=10;
	        }
	        if ($wholesale=='y') {
	            $basepricecalc=0;
	            $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 3 );
	            if (count($wholesalePriceData) > 0) {
	                $basepricecalc=$this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	            }
	            $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 11 );
	            if (count($wholesalePriceData) > 0) {
	                $basepricecalc=$basepricecalc + $this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	            }
	            $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 12 );
	            if (count($wholesalePriceData) > 0) {
	                $basepricecalc=$basepricecalc + $this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	            }
	            $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 13 );
	            if (count($wholesalePriceData) > 0) {
	                $basepricecalc=$basepricecalc + $this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	            }
	            $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 14 );
	            if (count($wholesalePriceData) > 0) {
	                $basepricecalc=$basepricecalc + $this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	            }
	            $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 17 );
	            if (count($wholesalePriceData) > 0) {
	                $basepricecalc=$basepricecalc + $this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	            }
	        }
	        $exportData['totalvalue']=floatval($exportData['totalvalue'])+floatval($basepricecalc);
	        if ($exportData['baseqty']=='2' && $wrapid==1) {
	            //$basepricecalc=$basepricecalc/2;
	            $exportData['basebox']=2;
	        }
	        if ($base2=='y') {
	            $basepricecalc=$basepricecalc/2;
	            $exportData['basebox']=2;
	        }
	        if ($wrapid==3 || $wrapid==4) {
				$exportData['packdata'] = $componentdata->getPackagingdata($pn,3);
	            $boxweight = 0;
	            if (count($exportData['packdata']) > 0) {
	            	$Boxsize = $this->ArrayHelper->getStr($exportData, ['packdata',0,'Boxsize']);
	                $boxinfo = $shippingBox->find()->where(['sName' => $Boxsize])->first();
	                $boxweight = $boxinfo['Weight'];
	            }
				//debug($exportData['totalweight']);
				//die;
				$exportData['baseNW']=intval($this->ArrayHelper->getStr($exportData, ['packdata',0,'ProductWgt']));
				$exportData['base2NW']=intval($this->ArrayHelper->getStr($exportData, ['packdata',1,'ProductWgt']));
				$exportData['totalNW'] +=$exportData['baseNW'];
				$exportData['totalNW'] +=$exportData['base2NW'];
				
	        }
	        if ($wrapid==2 || $wrapid==1) {
				$exportData['baseNW']=$exportData['baseweight'];
				$exportData['totalNW'] +=$exportData['baseNW'];
				$exportData['base2NW']=$exportData['baseweight2'];
				$exportData['totalNW'] +=$exportData['base2NW'];
	        }
	        
	        $exportData['baseprice'] = UtilityComponent::formatMoneyWithHtmlSymbol($basepricecalc, $purchase['ordercurrency']);
	        
	        $exportData['descofgoods'].="Base&nbsp;";
	        
	        
	    }
	    
	    if ($topperinc == 'y') {
	        
	        $comptariff = $componentdata->getComponentSpecs($purchase['toppertype'],5);
	        if (count($comptariff)>0) {
	            $exportData['toppertariff']=$this->ArrayHelper->getStr($comptariff, [0,'TARIFFCODE']);
	            $exportData['topperweight']=$this->ArrayHelper->getFloat($comptariff, [0,'WEIGHT']);
	            $topperdepth=$this->ArrayHelper->getFloat($comptariff, [0,'DEPTH']);
	        } else {
	            $exportData['toppertariff']=0;
	            $exportData['topperweight']=0;
	            $topperdepth=0;
	        }
	        if ($wrapid==3 || $wrapid==4) {
	            $exportData['packdata'] = $componentdata->getPackagingdata($pn,5);
	            if ($exportData['packdata'] != null && count($exportData['packdata']) > 0) {
	                $exportData['topperweight']=$this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg']);
	                $topperdepth=$this->ArrayHelper->getFloat($exportData, ['packdata',0,'packdepth']);
	            } else {
	                $exportData['topperweight']=0;
	                $topperdepth=0;
	            }
	        }
	        $exportData['totalitems']=intval($exportData['totalitems'])+1;
	        $exportData['topperqty']=1;
	        if (!empty($psizes['topper1Width'])) {
	            $topper1width = $psizes['topper1Width'];
	        } else {
	            $topper1width =str_replace("cm","",$purchase['topperwidth']);
	        }
	        if (!empty($psizes['topper1Length'])) {
	            $topper1length = $psizes['topper1Length'];
	        } else {
	            $topper1length =str_replace("cm","",$purchase['topperlength']);
	        }
	        
	        if ($purchase['toppertype']=='n') {
	        	$exportData['topperdesc']="PIN 1 pc";
	        } else {
	        	$exportData['topperdesc']=$purchase['toppertype'] ." 1 pc";
	        }
	        if ($wrapid==4) {
	        	if (isset($exportData['packdata'][0]['packwidth'])) {
		        	$packwidth0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packwidth']);
		        	$packheight0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packheight']);
		        	$packdepth0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packdepth']);
	        		$exportData['topperdimensions'] = $packedwith=$packwidth0 ."x" .$packheight0 ."x" .$packdepth0 ."cm";
	            	$exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+($packwidth0*$packheight0*$packdepth0);
	        	} else {
	        		$exportData['topperdimensions'] =0;
	        		$exportData['cubicmeters'] =0;
	        	}
	            
	        	$CompPartNo = $this->ArrayHelper->getStr($exportData, ['packdata', 1, 'CompPartNo']);
	            if (!empty($CompPartNo)) {
		        	$packwidth1 = $this->ArrayHelper->getFloat($exportData, ['packdata',1,'packwidth']);
		        	$packheight1 = $this->ArrayHelper->getFloat($exportData, ['packdata',1,'packheight']);
		        	$packdepth1 = $this->ArrayHelper->getFloat($exportData, ['packdata',1,'packdepth']);
	                $exportData['topperdimensions2'] = $packedwith=$packwidth1 ."x" .$packheight1 ."x" .$packdepth1 ."cm";
	                $exportData['topper2']='y';
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $exportData['topperweight2']=$this->ArrayHelper->getFloat($exportData, ['packdata',1,'packkg']);
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['topperweight2']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+($packwidth1*$packheight1*$packdepth1);
	            }
	        } else if ($wrapid==3) {
	            if ($exportData['packdata'] != null && count($exportData['packdata']) > 0) {
	            	$Boxsize = $this->ArrayHelper->getStr($exportData, ['packdata',0,'Boxsize']);
	                $boxinfo = $shippingBox->find()->where(['sName' => $Boxsize])->first();
	                $exportData['topperdimensions'] = floatval($boxinfo['Width']) ."x" .floatval($boxinfo['Length']) ."x" .floatval($boxinfo['Depth']) ."cm";
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($boxinfo['Width'])*floatval($boxinfo['Length'])*floatval($boxinfo['Depth']));
	            } else {
	                $exportData['topperdimensions'] = 0;
	                $exportData['cubicmeters'] = 0;
	            }
	        } else {
	            $exportData['topperdimensions'] = $topper1width ."x" .$topper1length ."x" .(float)$topperdepth ."cm";
	            $exportData['topperweight'] = $this->ArrayHelper->getFloat($comptariff, [0,'WEIGHT']);
	            $exportData['topperweight']=ceil(((floatval($topper1width)*floatval($topper1length))*floatval($exportData['topperweight'])));
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($topper1width)*floatval($topper1length)*floatval($topperdepth));
	        }
	        if ($wrapid==3 || $wrapid==4) {
	            if ($exportData['packdata'] != null && count($exportData['packdata']) > 0) {
	            	$Boxsize = $this->ArrayHelper->getStr($exportData, ['packdata',0,'Boxsize']);
	                $boxinfo = $shippingBox->find()->where(['sName' => $Boxsize])->first();
	                $boxweight = $boxinfo['Weight'];
	                $exportData['topperNW']=intval($this->ArrayHelper->getStr($exportData, ['packdata',0,'ProductWgt']));
	                $exportData['totalNW'] +=$exportData['topperNW'];
					
	            } else {
	                $boxweight = 0;
	                $exportData['topperNW']=0;
	            }
				
	        }
	        if ($wrapid==2 || $wrapid==1) {
	                $exportData['topperNW']=$exportData['topperweight'];
	                $exportData['totalNW'] +=$exportData['topperNW'];
	        }
	        
	        $exportData['descofgoods'].="Topper&nbsp;";
	        $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['topperweight']);
	        
	        $topperpricecalc = $this->getComponentPriceExVatAfterDiscount($purchase['topperprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
	        if (empty($topperpricecalc)) {
	            $topperpricecalc=10;
	        }
	        if ($wholesale=='y') {
	            $topperpricecalc=0;
	            $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 5 );
	            if (count($wholesalePriceData) > 0) {
	                $topperpricecalc=$this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	            }
	        }
	        if ($exportData['topper2']=='y') {
	            $topperpricecalc=$topperpricecalc/2;
	        }
	        $exportData['topperprice'] = UtilityComponent::formatMoneyWithHtmlSymbol($topperpricecalc, $purchase['ordercurrency']);
	        $exportData['totalvalue']=$exportData['totalvalue']+$topperpricecalc;
	    }
	    
	    
	    $exportData['valancepackedwith']='';
	    if ($valanceinc == 'y') {
	        $packedwith='';
	        $exportData['valanceqty']='';
	        $exportData['valancepackedwith']='';
	        if ($wrapid==4 || $wrapid==3) {
	            $exportData['packdata'] = $componentdata->getPackagingdata($pn,6);
	            $packedwith=$this->ArrayHelper->getStr($exportData, ['packdata',0,'PackedWith']);
				$exportData['valanceNW']=intval($this->ArrayHelper->getStr($exportData, ['packdata',0,'ProductWgt']));
				$exportData['totalNW'] +=$exportData['valanceNW'];
	        }
	        if (!empty($packedwith) && $packedwith<>0) {
	            $exportData['valancepackedwith']=$packedwith;
	        } else {
	            $exportData['totalitems']=intval($exportData['totalitems'])+1;
	        }
			$exportData['valanceqty']=1;
	        $exportData['valancedesc']="Valance 1 pc";
	        $comptariff = $componentdata->getComponentSpecs('Valance',6);
	        $exportData['valancetariff']=$this->ArrayHelper->getStr($comptariff, [0,'TARIFFCODE']);
	        $exportData['valanceweight']=6;
			if ($wrapid==1 || $wrapid==2) {
				$exportData['valanceNW']=6;
			}
	        $valancewidth =str_replace("cm","", isset($purchase['valancewidth']) ? $purchase['valancewidth'] : '');
	        $valancelength =str_replace("cm","",isset($purchase['valancelength']) ? $purchase['valancelength'] : '');
	        $exportData['valancedimensions'] = $valancewidth ."x" .$valancelength ."cm";
	        if (empty($exportData['valancepackedwith'])) {
	            $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['valanceweight']);
	        }
	        $exportData['valanceprice'] =(floatval($purchase['valfabricprice'])+floatval($purchase['valanceprice']));
	        $valancepricecalc = $this->getComponentPriceExVatAfterDiscount($exportData['valanceprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
	        if (empty($valancepricecalc)) {
	            $valancepricecalc=10;
	        }
	        if ($wholesale=='y') {
	            $valancepricecalc=0;
	            $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 6 );
	            if (count($wholesalePriceData) > 0) {
	                $valancepricecalc=$this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	            }
	            $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 18 );
	            if (count($wholesalePriceData) > 0) {
	                $valancepricecalc=$valancepricecalc + $this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	            }
	        }
	        $exportData['valanceprice'] = UtilityComponent::formatMoneyWithHtmlSymbol($valancepricecalc, $purchase['ordercurrency']);
	        $exportData['totalvalue']=$exportData['totalvalue']+$valancepricecalc;
	        $exportData['descofgoods'].="Valance&nbsp;";
	    }
	    
	    if ($legsinc == 'y') {
	        $legboxdesc='(leg box)';
	        if ($wrapid==4 || $wrapid==3) {
	            $exportData['packdata'] = $componentdata->getPackagingdata($pn,7);
	            $packedwith=0;
	            $exportData['legweight']=0;
	            if (count($exportData['packdata']) > 0) {
	                $packedwith=$this->ArrayHelper->getStr($exportData, ['packdata',0,'PackedWith']);
	                $exportData['legweight']=$this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg']);
					$boxno=$this->ArrayHelper->getStr($exportData, ['packdata',0,'Boxsize']);
					$exportData['legsNW']=intval($this->ArrayHelper->getStr($exportData, ['packdata',0,'ProductWgt']));
					if ($boxno=="Double Leg Box" ) {
						$legboxdesc='(double leg box)';
					}
	            }
	        }
	        if (!empty($packedwith) && $packedwith<>0) {
	            $exportData['legspackedwith']=$packedwith;
	        } else {
	            $exportData['totalitems']=intval($exportData['totalitems'])+1;
	        }
	        $legnumber=(intval($purchase['LegQty']) + intval($purchase['AddLegQty']) + intval($purchase['headboardlegqty']));
	        $exportData['legqty']=1;
	        $comptariff = $componentdata->getComponentSpecs('Box of Legs',7);
	        $exportData['legdesc']="Legs (" .$legnumber .") and Fittings ".$legboxdesc."";
	        if ($wrapid==1 || $wrapid==2) {
	            $exportData['legweight']=floatval($legnumber)*27*$this->ArrayHelper->getFloat($comptariff, [0,'WEIGHT'])/1000;
	            $exportData['legweight']=ceil(($exportData['legweight']));
	        }
	        $exportData['legtariff']=$this->ArrayHelper->getStr($comptariff, [0,'TARIFFCODE']);
	        if ($wrapid==3) {
	            if (count($exportData['packdata']) > 0) {
	            	$Boxsize = $this->ArrayHelper->getStr($exportData, ['packdata',0,'Boxsize']);
	                $legbox=str_replace(' ', '', $Boxsize);
	                $boxinfo = $shippingBox->find()->where(['sName' => $legbox])->first();
	                if (isset($boxinfo['Width'])) {
	                	$exportData['legdimensions'] = floatval($boxinfo['Width']) ."x" .floatval($boxinfo['Height']) ."x" .floatval($boxinfo['Depth']) ."cm";
	                	$cubiccalc = floatval($boxinfo['Width'])*floatval($boxinfo['Height'])*floatval($boxinfo['Depth']);
	                } else {
	                	$exportData['legdimensions'] = 0;
	                	$cubiccalc = 0;	
	                }
	                
	            } else {
	                $exportData['legdimensions'] = "";
	                $cubiccalc = 0;
	            }
	        } else {
	            $exportData['legdimensions'] = "22x42x27cm";
	            $cubiccalc=22*42*27;
	        }
	        if (empty($exportData['legspackedwith'])) {
	            $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['legweight']);
	        }
	        $legpricecalc =(floatval($purchase['legprice'])+floatval($purchase['addlegprice']));
	        $legpricecalc = $this->getComponentPriceExVatAfterDiscount($legpricecalc, $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
	        if (empty($legpricecalc)) {
	            $legpricecalc=10;
	        }
	        
	        if ($wholesale=='y') {
	            $legpricecalc=0;
	            $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 7 );
	            if (count($wholesalePriceData) > 0) {
	                $legpricecalc=$this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	            }
	            $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 16 );
	            if (count($wholesalePriceData) > 0) {
	                $legpricecalc=$legpricecalc + $this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	            }
	        }
			
			if ($wrapid==1 || $wrapid==2) {
				$exportData['legsNW'] = ($legnumber)*350/1000;
				$exportData['legsNW'] = ceil($exportData['legsNW']);
			}
			$exportData['totalNW'] +=intval($exportData['legsNW']);
			
	        $exportData['legprice'] = UtilityComponent::formatMoneyWithHtmlSymbol($legpricecalc, $purchase['ordercurrency']);
	        $exportData['totalvalue']=(floatval($exportData['totalvalue'])+floatval($legpricecalc));
	        $exportData['descofgoods'].="Legs&nbsp;";
	        if (empty($exportData['legspackedwith'])) {
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($cubiccalc));
	        }
	        
	    }
	    
	    if ($hbinc == 'y') {
	       
	        
	        $exportData['totalitems']=intval($exportData['totalitems'])+1;
	        $comptariff = $componentdata->getComponentSpecs($purchase['headboardstyle'],8);
	        if (isset($comptariff[0]['TARIFFCODE'])) {
	            $exportData['hbtariff']=$this->ArrayHelper->getStr($comptariff, [0,'TARIFFCODE']);
	        }
	        if (isset($comptariff[0]['WEIGHT'])) {
	            $exportData['hbweight']=$this->ArrayHelper->getFloat($comptariff, [0,'WEIGHT']);
	        }
	        
	        if (isset($comptariff[0]['DEPTH'])) {
	            $exportData['hbdepth']=$this->ArrayHelper->getFloat($comptariff, [0,'DEPTH']);
	        }
	        
	       
	        $exportData['packdata'] = $componentdata->getPackagingdata($pn,8);
	        if (isset($purchase['headboardWidth'])) {
	        $hbwidth =str_replace("cm","",$purchase['headboardWidth']);
	        }
	        if (empty($hbwidth)) {
	            if ($mattressinc == 'y') {
	                $hbwidth=$matt1width;
	            }
	        }
	        if (empty($hbwidth)) {
	            if ($baseinc == 'y') {
	                $hbwidth=$base1width;
	            }
	        }
	        if ($hbwidth='') {
	           $hbwidth=0;
	        }
	        $exportData['hbqty']=1;
	        $hbheight = (int) filter_var($purchase['headboardheight'], FILTER_SANITIZE_NUMBER_INT);
	        if (substr($purchase['headboardheight'], 0, 3)!='Spe' && $purchase['headboardheight'] != 'TBC') {
	            $exportData['hbweight']=ceil((floatval($hbwidth)*floatval($exportData['hbweight'])));
	            }
	            if ($wrapid==2) {
	            	if ($purchase['headboardstyle']=='n') {
	            		$exportData['hbdesc']="PIN Headboard 1 pc";
	            	} else {
	                	$exportData['hbdesc']=$purchase['headboardstyle'] ." Headboard 1 pc";
	                }
	            }
	            if ($purchase['headboardstyle']=='n') {
	            		$exportData['hbdesc']="PIN Headboard 1 pc";
	            	} else {
	            		$exportData['hbdesc']=$purchase['headboardstyle'] ." Headboard 1 pc";
	            	}
	            if ($wrapid==1 || $wrapid==2 || $wrapid==4) {
	                $hbwidth = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packwidth']);
		        	$packheight0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packheight']);
		        	$packdepth0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packdepth']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+($hbwidth*$packheight0*$packdepth0);
	                $exportData['hbdimensions'] = $hbwidth ."x" .$packheight0 ."x" .$packdepth0 ."cm";
	            } else {
	                $exportData['hbdimensions'] = (float)$hbwidth ."x" .$hbheight ."x" .(float)$exportData['hbdepth'] ."cm";
	            }
	            if ($wrapid==3 || $wrapid==4 || $wrapid==2) {
	                $exportData['packdata'] = $componentdata->getPackagingdata($pn,8);
	                $exportData['hbweight'] = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packkg']);
	            }
	            if ($wrapid==4 || $wrapid==2) {
		        	$packwidth0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packwidth']);
		        	$packheight0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packheight']);
		        	$packdepth0 = $this->ArrayHelper->getFloat($exportData, ['packdata',0,'packdepth']);
	                $exportData['hbdimensions'] = $packedwith=$packwidth0 ."x" .$packheight0 ."x" .$packdepth0 ."cm";
	                
	            }
	            $Boxsize = $this->ArrayHelper->getStr($exportData, ['packdata',0,'Boxsize']);
	            if ($wrapid==3 && !empty($Boxsize)) {
	                $boxinfo = $shippingBox->find()->where(['sName' => $Boxsize])->first();
	                $exportData['hbdimensions'] = floatval($boxinfo['Width']) ."x" .floatval($boxinfo['Length']) ."x" .floatval($boxinfo['Depth']) ."cm";
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($boxinfo['Width'])*floatval($boxinfo['Length'])*floatval($boxinfo['Depth']));
	                
	            }
	            $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['hbweight']);
	            
	            $CompPartNo = $this->ArrayHelper->getStr($exportData, ['packdata', 1, 'CompPartNo']);
	            if ($wrapid==4 && !empty($CompPartNo)) {
		        	$packwidth1 = $this->ArrayHelper->getFloat($exportData, ['packdata',1,'packwidth']);
		        	$packheight1 = $this->ArrayHelper->getFloat($exportData, ['packdata',1,'packheight']);
		        	$packdepth1 = $this->ArrayHelper->getFloat($exportData, ['packdata',1,'packdepth']);
	                $exportData['hbdimensions2'] = $packedwith=$packwidth1 ."x" .$packheight1 ."x" .$packdepth1 ."cm";
	                $exportData['hb2']='y';
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $exportData['hbweight2']=$this->ArrayHelper->getFloat($exportData, ['packdata',1,'packkg']);
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['hbweight2']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+($packwidth1*$packheight1*$packdepth1);
	            }
	            $exportData['hbprice']=floatval($purchase['headboardprice'])+floatval($purchase['hbfabricprice'])+floatval($purchase['headboardtrimprice']);
	            $hbpricecalc = $this->getComponentPriceExVatAfterDiscount($exportData['hbprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
	            if (empty($hbpricecalc)) {
	                $hbpricecalc=10;
	            }
	            $CompPartNo = $this->ArrayHelper->getStr($exportData, ['packdata', 1, 'CompPartNo']);
	            if ($wrapid==4 && !empty($CompPartNo)) {
	                $hbpricecalc=$hbpricecalc/2;
	            }
	            $exportData['hbprice'] = UtilityComponent::formatMoneyWithHtmlSymbol($hbpricecalc, $purchase['ordercurrency']);
	            if ($wholesale=='y') {
	                $hbpricecalc=0;
	                $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 8 );
	                if (count($wholesalePriceData) > 0) {
	                    $hbpricecalc=$hbpricecalc + $this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	                }
	                $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 10 );
	                if (count($wholesalePriceData) > 0) {
	                    $hbpricecalc=$hbpricecalc + $this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	                }
	                $wholesalePriceData = $wholesalePrices->getCompWholesalePrice($pn, 15 );
	                if (count($wholesalePriceData) > 0) {
	                    $hbpricecalc=$hbpricecalc + $this->ArrayHelper->getFloat($wholesalePriceData, [0,'price']);
	                }
	                $exportData['hbprice'] = UtilityComponent::formatMoneyWithHtmlSymbol($hbpricecalc, $purchase['ordercurrency']);
	            }
	            if ($exportData['hbweight']=='') {
					$exportData['hbweight']=30;
					$exportData['totalweight'] =floatval($exportData['totalweight']) + 30;
				}
	            if ($wrapid==3 || $wrapid==4) {
	            	$boxweight = 0.0;
	            	$Boxsize = $this->ArrayHelper->getStr($exportData, ['packdata',0,'Boxsize']);
	            	if (!empty($Boxsize)) {
		            	$boxinfo = $shippingBox->find()->where(['sName' => $Boxsize])->first();
		            	$boxweight = $boxinfo['Weight'];
	            	}
	            	$exportData['hbNW']=intval($this->ArrayHelper->getStr($exportData, ['packdata',0,'ProductWgt']));
	            	$exportData['totalNW'] +=$exportData['hbNW'];
					
	      		}
	      		if ($wrapid==2 or $wrapid==1) {
	      			$exportData['hbNW']=floatval($exportData['hbweight']);
	      			$exportData['totalNW'] +=$exportData['hbNW'];
	      		}
	            $exportData['totalvalue']=floatval($exportData['totalvalue'])+floatval($hbpricecalc);
	            $exportData['descofgoods'].="Headboard<br>";
				
	            
	            
	    }
	    
	    
	    //echo '<br>$exportData['totalitems']=' . $exportData['totalitems'];
	    if ($accinc == 'y') {
	        $exportData['acc'] = $accessory->find()->where(['purchase_no' => $pn]);
	        // @TODO check $exportData['totalitems'] logic with MAd
	        if ($wrapid==3) {
	            $exportData['totalitems'] += $packagingData->getStandAloneAccessoriesCount($pn);
	        }
	        if ($wrapid==4) {
	        	if (isset($componentdata->getPackagingdata($pn,9)[0])) {
	            $exportData['packdata'] = $componentdata->getPackagingdata($pn,9)[0];
				
	            if ($exportData['packdata']['PackedWith'] == 0 || $exportData['packdata']['PackedWith']==NULL) {
	                $exportData['totalitems'] +=1;
	            }
	            }
	        }
			if ($wrapid==3 || $wrapid==4) {
				if (isset($componentdata->getPackagingdata($pn,9)[0])) {
					$exportData['packdata'] = $componentdata->getPackagingdata($pn,9)[0];
					if ($exportData['packdata']['PackedWith'] == 0 || $exportData['packdata']['PackedWith']==NULL) {
						$exportData['accNW']=intval($exportData['packdata']['ProductWgt']);
						$exportData['totalNW'] +=$exportData['accNW'];
						
					}
				}
			}
	        $CompPartNo = $this->ArrayHelper->getStr($exportData, ['packdata', 1, 'CompPartNo']);
	        if ($wrapid==4 && !empty($CompPartNo)) {
	            $exportData['totalitems'] +=1;
	            $acc2='y';
	        }
	        if ($wrapid==2) {
	            $exportData['totalitems'] += $packagingData->getStandAloneAccessoriesCount($pn);
	        }
	        if ($wrapid==1) {
	            $exportData['totalitems']=intval($exportData['totalitems'])+1;
	        }
	        
	    }
	    
	    return $exportData;
	}
    
	public function getComponentPriceExVatAfterDiscount($compprice, $discounttype, $discount, $bedsettotal, $istrade, $vatrate) {
		if ($discounttype=='percent') {
			if (!empty($discount)) {
				$compprice=$compprice * (1-(floatval($discount/100)));
			}
		}
		if ($discounttype=='currency') {
			if (!empty($discount) && !empty($bedsettotal) && $bedsettotal != 0) {
				$discountamt=(floatval($compprice)/floatval($bedsettotal))*floatval($discount);
				$compprice=(floatval($compprice)-floatval($discountamt));
				
			}
		}
		if ($istrade=='n' && !empty($vatrate)) {
			$compprice=(floatval($compprice)/(1+(floatval ($vatrate)/100)));
		}
		if (isset($compprice))	 {	
		$compprice=round($compprice,2,PHP_ROUND_HALF_UP);
		}
		return $compprice;
	}

}
