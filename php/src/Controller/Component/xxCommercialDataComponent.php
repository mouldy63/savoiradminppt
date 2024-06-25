<?php
namespace App\Controller\Component;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;

class CommercialDataComponent extends \Cake\Controller\Component {

    public function getExportData($ctrl, $pn, $mattressinc, $baseinc, $topperinc, $valanceinc, $legsinc, $hbinc, $accinc, $purchase, $wrapid, $wholesale) {
	    $componentdata = TableRegistry::get('Componentdata');
	    
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
	        $exportData['mattresstariff']=$comptariff[0]['TARIFFCODE'];
	        $exportData['mattressweight']=$comptariff[0]['WEIGHT'];
	        $mattressdepth=$comptariff[0]['DEPTH'];
	        
	        if (substr($purchase['mattresstype'], 0, 3)=='Zip') {
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
	        $exportData['mattressdesc']=$purchase['savoirmodel'] ." mattress 1 pc";
	        
	        if ($wrapid==4) {
	            $packdata = $componentdata->getPackagingdata($pn,1);
	            $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($packdata[0]['packkg']);
	        }
	        
	        if ($wrapid==4) {
	            $exportData['mattressdimensions'] = $packedwith=floatval($packdata[0]['packwidth']) ."x" .floatval($packdata[0]['packheight']) ."x" .floatval($packdata[0]['packdepth']) ."cm";
	            if (isset ($packdata[1]['CompPartNo'])) {
	                $exportData['mattressdimensions2'] = $packedwith=floatval($packdata[1]['packwidth']) ."x" .floatval($packdata[1]['packheight']) ."x" .floatval($packdata[1]['packdepth']) ."cm";
	                $exportData['mattressbox']=2;
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $exportData['mattressweight']=floatval(($packdata[0]['packkg']));
	                $exportData['mattressweight2']=floatval(($packdata[1]['packkg']));
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['mattressweight2']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+((floatval($packdata[0]['packwidth'])*floatval($packdata[0]['packheight'])*floatval($packdata[0]['packdepth'])));
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+((floatval($packdata[1]['packwidth'])*floatval($packdata[1]['packheight'])*floatval($packdata[1]['packdepth'])));
	            } else if ($packdata[0]['boxQty']==2) {
	                $exportData['mattressbox']=2;
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $exportData['mattressweight']=floatval(($packdata[0]['packkg'])/2);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+((floatval($packdata[0]['packwidth'])*floatval($packdata[0]['packheight'])*floatval($packdata[0]['packdepth'])*2));
	            } else {
	                $exportData['mattressbox']=1;
	                $exportData['mattressweight']=floatval($packdata[0]['packkg']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($packdata[0]['packwidth'])*floatval($packdata[0]['packheight'])*floatval($packdata[0]['packdepth']));
	                if ($mattzip=='y') {
	                    $exportData['mattressdesc']=$purchase['savoirmodel'] ." mattress 2 pc";
	                }
	            }
	            
	        } else if ($wrapid==3) {
	            $packdata = $componentdata->getPackagingdata($pn,1);
	            $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($packdata[0]['packkg']);
	            if (isset($packdata[1]['CompPartNo'])) {
	                $mattress2='y';
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($packdata[1]['packkg']);
	                $exportData['itemno'] += 1;
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	            }
	            $boxinfo = $ctrl->ShippingBox->find()->where(['sName' => $packdata[0]['Boxsize']])->first();
	            if ($mattress2=='y') {
	                $boxinfo2 = $ctrl->ShippingBox->find()->where(['sName' => $packdata[1]['Boxsize']])->first();
	                $exportData['mattressdimensions2'] = floatval($boxinfo2['Width']) ."x" .floatval($boxinfo2['Length']) ."x" .floatval($boxinfo2['Depth']) ."cm";
	                $exportData['mattressweight2']=floatval($packdata[1]['packkg']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($boxinfo2['Width'])*floatval($boxinfo2['Length'])*floatval($boxinfo2['Depth']));
	            }
	            $exportData['mattressdimensions'] = floatval($boxinfo['Width']) ."x" .floatval($boxinfo['Length']) ."x" .floatval($boxinfo['Depth']) ."cm";
	            $exportData['mattressweight']=floatval($packdata[0]['packkg']);
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($boxinfo['Width'])*floatval($boxinfo['Length'])*floatval($boxinfo['Depth']));
	        } else {
	            
	            $exportData['mattressdimensions'] = $matt1width ."x" .$matt1length ."x" .(float)$mattressdepth ."cm";
	            $exportData['mattressweight']=$comptariff[0]['WEIGHT'];
	            $exportData['mattressweight']=ceil(((floatval($matt1width)*floatval($matt1length))*$exportData['mattressweight']));
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($matt1width)*floatval($matt1length)*floatval($mattressdepth));
	            $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['mattressweight']);
	        }
	        
	        $exportData['mattressprice']=$purchase['mattressprice'];
	        $mattresspricecalc = $ctrl->_getComponentPriceExVatAfterDiscount($exportData['mattressprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
	        
	        
	        if (empty($purchase['mattressprice'])) {
	            $mattresspricecalc=10;
	        }
	        if ($wholesale=='y') {
	            $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 1 );
	            if (count($wholesalePriceData) > 0) {
	                $mattresspricecalc=floatval($wholesalePriceData[0]['price']);
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
	        
	        $exportData['descofgoods'].="Mattress&nbsp;";
	        if ($wrapid==4 && ($packdata[0]['boxQty']==2 || isset($packdata[1]['boxQty']))) {
	            $mattresspricecalc = $mattresspricecalc/2;
	        }
	        
	        $exportData['mattressprice'] = UtilityComponent::formatMoneyWithHtmlSymbol($mattresspricecalc, $purchase['ordercurrency']);
	        
	    }
	    
	    
	    if ($baseinc == 'y') {
	        $comptariff = $componentdata->getComponentSpecs($purchase['basesavoirmodel'],3);
	        $exportData['basetariff']=$comptariff[0]['TARIFFCODE'];
	        $exportData['baseweight']=$comptariff[0]['WEIGHT'];
	        $basedepth=$comptariff[0]['DEPTH'];
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
	        } else {
	            $exportData['itemno'] += 1;
	            $exportData['baseqty']=1;
	        }
	        
	        $exportData['totalitems']=intval($exportData['totalitems'])+intval($exportData['baseqty']);
	        
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
	        
	        //cope with North split dimensions for base 1
	        if (substr($purchase['basetype'], 0, 3)=='Nor' && empty($psizes['Base1Width']) && substr($purchase['basewidth'], 0, 3)!='Spe' && substr($purchase['basewidth'], 0, 1)!='n') {
	            $base1width=floatval($base1width)/2;
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
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	            }
	        }
	        
	        $exportData['basedesc']=$purchase['basesavoirmodel'] ." base 1 pc";
	        if ($wrapid==3) {
	            $packdata = $componentdata->getPackagingdata($pn,3);
	            $exportData['baseweight']=floatval($packdata[0]['packkg']);
	        }
	        if ($wrapid==4) {
	            $packdata = $componentdata->getPackagingdata($pn,3);
	            $exportData['baseweight']=floatval($packdata[0]['packkg']);
	        }
	        if ($wrapid==4) {
	            $exportData['basedimensions'] = $packedwith=floatval($packdata[0]['packwidth']) ."x" .floatval($packdata[0]['packheight']) ."x" .floatval($packdata[0]['packdepth']) ."cm";
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($packdata[0]['packwidth'])*floatval($packdata[0]['packheight'])*$packdata[0]['packdepth']);
	            if (isset ($packdata[1]['CompPartNo'])) {
	                $exportData['basedimensions2'] = $packedwith=floatval($packdata[1]['packwidth']) ."x" .floatval($packdata[1]['packheight']) ."x" .floatval($packdata[1]['packdepth']) ."cm";
	                $base2='y';
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $exportData['baseweight']=floatval(($packdata[0]['packkg']));
	                $exportData['baseweight2']=floatval(($packdata[1]['packkg']));
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['baseweight2']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+((floatval($packdata[1]['packwidth'])*floatval($packdata[1]['packheight'])*floatval($packdata[1]['packdepth'])));
	            }
	        } else if ($wrapid==3) {
	            
	            $boxinfo = $ctrl->ShippingBox->find()->where(['sName' => $packdata[0]['Boxsize']])->first();
	            $exportData['basedimensions'] = floatval($boxinfo['Width']) ."x" .floatval($boxinfo['Length']) ."x" .floatval($boxinfo['Depth']) ."cm";
	            
	            $exportData['baseweight']=floatval($packdata[0]['packkg']);
	            if (isset ($packdata[1]['CompPartNo'])) {
	                $base2='y';
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $boxinfo2 = $ctrl->ShippingBox->find()->where(['sName' => $packdata[1]['Boxsize']])->first();
	                $exportData['baseweight2']=floatval($packdata[1]['packkg']);
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['baseweight2']);
	                $exportData['basedimensions2'] = floatval($boxinfo2['Width']) ."x" .floatval($boxinfo2['Length']) ."x" .floatval($boxinfo2['Depth']) ."cm";
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($boxinfo2['Width'])*floatval($boxinfo2['Length'])*floatval($boxinfo2['Depth']));
	            }
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($boxinfo['Width'])*floatval($boxinfo['Length'])*floatval($boxinfo['Depth']));
	            
	        } else {
	            $exportData['basedimensions'] = $base1width ."x" .$base1length ."x" .(float)$basedepth ."cm";
	            $exportData['baseweight']=$comptariff[0]['WEIGHT'];
	            $exportData['baseweight']=ceil(((floatval($base1width)*floatval($base1length))*$exportData['baseweight']));
	            
	            if ($base2=='y') {
	                $exportData['baseweight2']=$exportData['baseweight'];
	                $exportData['basedimensions2'] = $base1width ."x" .$base1length ."x" .(float)$basedepth ."cm";
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['baseweight2']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($base1width)*floatval($base1length)*floatval($basedepth));
	            }
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($base1width)*floatval($base1length)*floatval($basedepth));
	        }
	        
	        $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['baseweight']);
	        $exportData['baseprice']=floatval($purchase['baseprice'])+floatval($purchase['basetrimprice'])+floatval($purchase['upholsteryprice'])+floatval($purchase['basefabricprice'])+floatval($purchase['basedrawersprice']);
	        
	        $basepricecalc = $ctrl->_getComponentPriceExVatAfterDiscount($exportData['baseprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
	        if (empty($exportData['baseprice'])) {
	            $basepricecalc=10;
	        }
	        if ($wholesale=='y') {
	            $basepricecalc=0;
	            $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 3 );
	            if (count($wholesalePriceData) > 0) {
	                $basepricecalc=floatval($wholesalePriceData[0]['price']);
	            }
	            $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 11 );
	            if (count($wholesalePriceData) > 0) {
	                $basepricecalc=$basepricecalc + floatval($wholesalePriceData[0]['price']);
	            }
	            $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 12 );
	            if (count($wholesalePriceData) > 0) {
	                $basepricecalc=$basepricecalc + floatval($wholesalePriceData[0]['price']);
	            }
	            $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 13 );
	            if (count($wholesalePriceData) > 0) {
	                $basepricecalc=$basepricecalc + floatval($wholesalePriceData[0]['price']);
	            }
	            $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 14 );
	            if (count($wholesalePriceData) > 0) {
	                $basepricecalc=$basepricecalc + floatval($wholesalePriceData[0]['price']);
	            }
	            $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 17 );
	            if (count($wholesalePriceData) > 0) {
	                $basepricecalc=$basepricecalc + floatval($wholesalePriceData[0]['price']);
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
	        
	        $exportData['baseprice'] = UtilityComponent::formatMoneyWithHtmlSymbol($basepricecalc, $purchase['ordercurrency']);
	        
	        $exportData['descofgoods'].="Base&nbsp;";
	        
	        
	    }
	    
	    if ($topperinc == 'y') {
	        
	        $comptariff = $componentdata->getComponentSpecs($purchase['toppertype'],5);
	        if (count($comptariff)>0) {
	            $exportData['toppertariff']=$comptariff[0]['TARIFFCODE'];
	            $exportData['topperweight']=$comptariff[0]['WEIGHT'];
	            $topperdepth=$comptariff[0]['DEPTH'];
	        } else {
	            $exportData['toppertariff']=0;
	            $exportData['topperweight']=0;
	            $topperdepth=0;
	        }
	        if ($wrapid==3 || $wrapid==4) {
	            $packdata = $componentdata->getPackagingdata($pn,5);
	            $exportData['topperweight']=floatval($packdata[0]['packkg']);
	            $topperdepth=$packdata[0]['packdepth'];
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
	        
	        $exportData['topperdesc']=$purchase['toppertype'] ." 1 pc";
	        
	        if ($wrapid==4) {
	            $exportData['topperdimensions'] = $packedwith=floatval($packdata[0]['packwidth']) ."x" .floatval($packdata[0]['packheight']) ."x" .floatval($packdata[0]['packdepth']) ."cm";
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($packdata[0]['packwidth'])*floatval($packdata[0]['packheight'])*floatval($packdata[0]['packdepth']));
	            if (isset ($packdata[1]['CompPartNo'])) {
	                $exportData['topperdimensions2'] = $packedwith=floatval($packdata[1]['packwidth']) ."x" .floatval($packdata[1]['packheight']) ."x" .floatval($packdata[1]['packdepth']) ."cm";
	                $exportData['topper2']='y';
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $exportData['topperweight2']=floatval(($packdata[1]['packkg']));
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['topperweight2']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+((floatval($packdata[1]['packwidth'])*floatval($packdata[1]['packheight'])*floatval($packdata[1]['packdepth'])));
	            }
	        } else if ($wrapid==3) {
	            $boxinfo = $ctrl->ShippingBox->find()->where(['sName' => $packdata[0]['Boxsize']])->first();
	            $exportData['topperdimensions'] = floatval($boxinfo['Width']) ."x" .floatval($boxinfo['Length']) ."x" .floatval($boxinfo['Depth']) ."cm";
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($boxinfo['Width'])*floatval($boxinfo['Length'])*floatval($boxinfo['Depth']));
	        } else {
	            $exportData['topperdimensions'] = $topper1width ."x" .$topper1length ."x" .(float)$topperdepth ."cm";
	            $exportData['topperweight']=$comptariff[0]['WEIGHT'];
	            $exportData['topperweight']=ceil(((floatval($topper1width)*floatval($topper1length))*floatval($exportData['topperweight'])));
	            $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($topper1width)*floatval($topper1length)*floatval($topperdepth));
	        }
	        
	        $exportData['descofgoods'].="Topper&nbsp;";
	        $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['topperweight']);
	        
	        $topperpricecalc = $ctrl->_getComponentPriceExVatAfterDiscount($purchase['topperprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
	        if (empty($topperpricecalc)) {
	            $topperpricecalc=10;
	        }
	        if ($wholesale=='y') {
	            $topperpricecalc=0;
	            $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 5 );
	            if (count($wholesalePriceData) > 0) {
	                $topperpricecalc=floatval($wholesalePriceData[0]['price']);
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
	        $valanceqty='';
	        $exportData['valancepackedwith']='';
	        if ($wrapid==4 || $wrapid==3) {
	            $packdata = $componentdata->getPackagingdata($pn,6);
	            $packedwith=$packdata[0]['PackedWith'];
	        }
	        if (!empty($packedwith) && $packedwith<>0) {
	            $exportData['valancepackedwith']=$packedwith;
	        } else {
	            $exportData['totalitems']=intval($exportData['totalitems'])+1;
	        }
	        $valanceqty=1;
	        $valancedesc="Valance 1 pc";
	        $comptariff = $componentdata->getComponentSpecs('Valance',6);
	        $valancetariff=$comptariff[0]['TARIFFCODE'];
	        $valanceweight=6;
	        $valancewidth =str_replace("cm","",$purchase['valancewidth']);
	        $valancelength =str_replace("cm","",$purchase['valancelength']);
	        $valancedimensions = $valancewidth ."x" .$valancelength ."cm";
	        if (empty($exportData['valancepackedwith'])) {
	            $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($valanceweight);
	        }
	        $exportData['valanceprice'] =(floatval($purchase['valfabricprice'])+floatval($purchase['valanceprice']));
	        $valancepricecalc = $ctrl->_getComponentPriceExVatAfterDiscount($exportData['valanceprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
	        if (empty($valancepricecalc)) {
	            $valancepricecalc=10;
	        }
	        if ($wholesale=='y') {
	            $valancepricecalc=0;
	            $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 6 );
	            if (count($wholesalePriceData) > 0) {
	                $valancepricecalc=floatval($wholesalePriceData[0]['price']);
	            }
	            $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 18 );
	            if (count($wholesalePriceData) > 0) {
	                $valancepricecalc=$valancepricecalc + floatval($wholesalePriceData[0]['price']);
	            }
	        }
	        $exportData['valanceprice'] = UtilityComponent::formatMoneyWithHtmlSymbol($valancepricecalc, $purchase['ordercurrency']);
	        $exportData['totalvalue']=$exportData['totalvalue']+$valancepricecalc;
	        $exportData['descofgoods'].="Valance&nbsp;";
	    }
	    
	    if ($legsinc == 'y') {
	        
	        if ($wrapid==4 || $wrapid==3) {
	            $packdata = $componentdata->getPackagingdata($pn,7);
	            $packedwith=$packdata[0]['PackedWith'];
	            $exportData['legweight']=floatval($packdata[0]['packkg']);
	        }
	        if (!empty($packedwith) && $packedwith<>0) {
	            $exportData['legspackedwith']=$packedwith;
	        } else {
	            $exportData['totalitems']=intval($exportData['totalitems'])+1;
	        }
	        $legnumber=(intval($purchase['LegQty']) + intval($purchase['AddLegQty']) + intval($purchase['headboardlegqty']));
	        $exportData['legqty']=1;
	        $comptariff = $componentdata->getComponentSpecs('Box of Legs',7);
	        $exportData['legdesc']="Legs (" .$legnumber .") and Fittings 1 box";
	        if ($wrapid==1 || $wrapid==2) {
	            $exportData['legweight']=floatval($legnumber)*27*((floatval($comptariff[0]['WEIGHT']))/1000);
	            $exportData['legweight']=ceil(($exportData['legweight']));
	        }
	        $exportData['legtariff']=$comptariff[0]['TARIFFCODE'];
	        if ($wrapid==3) {
	            $legbox=str_replace(' ', '', $packdata[0]['Boxsize']);
	            $boxinfo = $ctrl->ShippingBox->find()->where(['sName' => $legbox])->first();
	            $exportData['legdimensions'] = floatval($boxinfo['Width']) ."x" .floatval($boxinfo['Height']) ."x" .floatval($boxinfo['Depth']) ."cm";
	            $cubiccalc = floatval($boxinfo['Width'])*floatval($boxinfo['Height'])*floatval($boxinfo['Depth']);
	        } else {
	            $exportData['legdimensions'] = "22x42x27cm";
	            $cubiccalc=22*42*27;
	        }
	        if (empty($exportData['legspackedwith'])) {
	            $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['legweight']);
	        }
	        $legpricecalc =(floatval($purchase['legprice'])+floatval($purchase['addlegprice']));
	        $legpricecalc = $ctrl->_getComponentPriceExVatAfterDiscount($legpricecalc, $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
	        if (empty($legpricecalc)) {
	            $legpricecalc=10;
	        }
	        
	        if ($wholesale=='y') {
	            $legpricecalc=0;
	            $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 7 );
	            if (count($wholesalePriceData) > 0) {
	                $legpricecalc=floatval($wholesalePriceData[0]['price']);
	            }
	            $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 16 );
	            if (count($wholesalePriceData) > 0) {
	                $legpricecalc=$legpricecalc + floatval($wholesalePriceData[0]['price']);
	            }
	        }
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
	            $exportData['hbtariff']=$comptariff[0]['TARIFFCODE'];
	        }
	        if (isset($comptariff[0]['WEIGHT'])) {
	            $exportData['hbweight']=$comptariff[0]['WEIGHT'];
	        }
	        if (isset($comptariff[0]['DEPTH'])) {
	            $exportData['hbdepth']=$comptariff[0]['DEPTH'];
	        }
	        $packdata = $componentdata->getPackagingdata($pn,8);
	        $hbwidth =str_replace("cm","",$purchase['headboardWidth']);
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
	        $hbqty=1;
	        $hbheight = (int) filter_var($purchase['headboardheight'], FILTER_SANITIZE_NUMBER_INT);
	        if (substr($purchase['headboardheight'], 0, 3)!='Spe') {
	            $exportData['hbweight']=ceil((floatval($hbwidth)*floatval($exportData['hbweight'])));
	            }
	            if ($wrapid==2) {
	                $hbdesc=$purchase['headboardstyle'] ." Headboard 1 pc";
	            }
	            $hbdesc=$purchase['headboardstyle'] ." Headboard 1 pc";
	            if ($wrapid==1 || $wrapid==2 || $wrapid==4) {
	                $hbwidth=$packdata[0]['packwidth'];
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($hbwidth)*floatval($packdata[0]['packheight'])*floatval($packdata[0]['packdepth']));
	                $hbdimensions = (float)$hbwidth ."x" .(float)$packdata[0]['packheight'] ."x" .(float)$packdata[0]['packdepth'] ."cm";
	            } else {
	                $hbdimensions = (float)$hbwidth ."x" .$hbheight ."x" .(float)$exportData['hbdepth'] ."cm";
	            }
	            if ($wrapid==3 || $wrapid==4 || $wrapid==2) {
	                $packdata = $componentdata->getPackagingdata($pn,8);
	                $exportData['hbweight']=floatval($packdata[0]['packkg']);
	            }
	            if ($wrapid==4 || $wrapid==2) {
	                $hbdimensions = $packedwith=floatval($packdata[0]['packwidth']) ."x" .floatval($packdata[0]['packheight']) ."x" .floatval($packdata[0]['packdepth']) ."cm";
	                
	            }
	            if ($wrapid==3) {
	                $boxinfo = $ctrl->ShippingBox->find()->where(['sName' => $packdata[0]['Boxsize']])->first();
	                $hbdimensions = floatval($boxinfo['Width']) ."x" .floatval($boxinfo['Length']) ."x" .floatval($boxinfo['Depth']) ."cm";
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+(floatval($boxinfo['Width'])*floatval($boxinfo['Length'])*floatval($boxinfo['Depth']));
	                
	            }
	            $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['hbweight']);
	            if ($wrapid==4 && isset ($packdata[1]['CompPartNo'])) {
	                $exportData['hbdimensions2'] = $packedwith=floatval($packdata[1]['packwidth']) ."x" .floatval($packdata[1]['packheight']) ."x" .floatval($packdata[1]['packdepth']) ."cm";
	                $exportData['hb2']='y';
	                $exportData['totalitems']=intval($exportData['totalitems'])+1;
	                $exportData['hbweight2']=floatval(($packdata[1]['packkg']));
	                $exportData['totalweight'] =floatval($exportData['totalweight']) + floatval($exportData['hbweight2']);
	                $exportData['cubicmeters'] =floatval($exportData['cubicmeters'])+((floatval($packdata[1]['packwidth'])*floatval($packdata[1]['packheight'])*floatval($packdata[1]['packdepth'])));
	            }
	            $exportData['hbprice']=floatval($purchase['headboardprice'])+floatval($purchase['hbfabricprice'])+floatval($purchase['headboardtrimprice']);
	            $hbpricecalc = $ctrl->_getComponentPriceExVatAfterDiscount($exportData['hbprice'], $purchase['discounttype'], $purchase['discount'], $purchase['bedsettotal'], $purchase['istrade'], $purchase['vatrate'] );
	            if (empty($hbpricecalc)) {
	                $hbpricecalc=10;
	            }
	            if ($wrapid==4 && isset ($packdata[1]['CompPartNo'])) {
	                $hbpricecalc=$hbpricecalc/2;
	            }
	            $exportData['hbprice'] = UtilityComponent::formatMoneyWithHtmlSymbol($hbpricecalc, $purchase['ordercurrency']);
	            if ($wholesale=='y') {
	                $hbpricecalc=0;
	                $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 8 );
	                if (count($wholesalePriceData) > 0) {
	                    $hbpricecalc=$hbpricecalc + floatval($wholesalePriceData[0]['price']);
	                }
	                $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 10 );
	                if (count($wholesalePriceData) > 0) {
	                    $hbpricecalc=$hbpricecalc + floatval($wholesalePriceData[0]['price']);
	                }
	                $wholesalePriceData = $ctrl->WholesalePrices->getCompWholesalePrice($pn, 15 );
	                if (count($wholesalePriceData) > 0) {
	                    $hbpricecalc=$hbpricecalc + floatval($wholesalePriceData[0]['price']);
	                }
	                $exportData['hbprice'] = UtilityComponent::formatMoneyWithHtmlSymbol($hbpricecalc, $purchase['ordercurrency']);
	            }
	            $exportData['totalvalue']=floatval($exportData['totalvalue'])+floatval($hbpricecalc);
	            $exportData['descofgoods'].="Headboard<br>";
	            
	    }
	    
	    
	    //echo '<br>$exportData['totalitems']=' . $exportData['totalitems'];
	    if ($accinc == 'y') {
	        $exportData['acc'] = $ctrl->Accessory->find()->where(['purchase_no' => $pn]);
	        // @TODO check $exportData['totalitems'] logic with MAd
	        if ($wrapid==3) {
	            $exportData['totalitems'] += $ctrl->PackagingData->getStandAloneAccessoriesCount($pn);
	        }
	        if ($wrapid==4) {
	            $packdata = $componentdata->getPackagingdata($pn,9)[0];
	            if ($packdata['PackedWith'] == 0 || $packdata['PackedWith']==NULL) {
	                $exportData['totalitems'] +=1;
	            }
	        }
	        if ($wrapid==4 && isset ($packdata[1]['CompPartNo'])) {
	            $exportData['totalitems'] +=1;
	            $acc2='y';
	        }
	        if ($wrapid==2) {
	            $exportData['totalitems'] += $ctrl->PackagingData->getStandAloneAccessoriesCount($pn);
	        }
	        if ($wrapid==1) {
	            $exportData['totalitems']=intval($exportData['totalitems'])+1;
	        }
	        
	    }
	    
	    return $exportData;
	}
	
}
