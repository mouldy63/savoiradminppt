<?php

namespace App\Controller\Component;

use Cake\ORM\TableRegistry;
use \DateTime;
use Cake\Datasource\ConnectionManager;

class OrderHelperComponent extends \Cake\Controller\Component {
	
	public function initialize($config): void {
        parent::initialize($config);
        $this->Purchase = TableRegistry::getTableLocator()->get('Purchase');
    }

    public function getMattressMadeAt($purchase) {
        $mattressMadeAt = 0;
        $mattressmodel = $purchase['savoirmodel'];
        if ($mattressmodel == 'No. 1' || $mattressmodel == 'No. 2' || $mattressmodel == 'State') {
            $mattressMadeAt=2;
        } else if ($mattressmodel == 'No. 3' || $mattressmodel == 'No. 4' || $mattressmodel == 'No. 4v' || $mattressmodel == 'No. 5') {
            $mattressMadeAt=1;
        }
        return $mattressMadeAt;
    }

    public function getBaseMadeAt($purchase) {
        $baseMadeAt = 0;
        $basemodel = $purchase['basesavoirmodel'];
        if ($basemodel == 'No. 1' || $basemodel == 'No. 2' || $basemodel == 'State' || $basemodel == 'Savoir Slim') {
            $baseMadeAt=2;
        } else if ($basemodel == 'No. 3' || $basemodel == 'No. 4' || $basemodel == 'No. 4v' || $basemodel == 'No. 5') {
            $baseMadeAt=1;
        }
        return $baseMadeAt;
    }

    public function getTopperMadeAt($purchase) {
        $topperMadeAt = 0;
        $toppertype = $purchase['toppertype'];
        if ($toppertype == 'HCa Topper' || $toppertype == 'State HCa Topper') {
            $topperMadeAt=2;
        } 
        if ($toppertype == 'CFv Topper') {
            $topperMadeAt=1;
        }
        if (($toppertype == 'HW Topper' || $toppertype == 'CW Topper') && $purchase['mattressrequired']=='y' && $purchase['savoirmodel'] != '' && $purchase['savoirmodel'] != 'n') {
            $topperMadeAt=$this->getMattressMadeAt($purchase);
        }
        if (($toppertype == 'HW Topper' || $toppertype == 'CW Topper') && $purchase['baserequired']=='y' && $purchase['basesavoirmodel'] != '' && $purchase['basesavoirmodel'] != 'n') {
            $topperMadeAt=$this->getBaseMadeAt($purchase);
        }
        if (($toppertype == 'HW Topper' || $toppertype == 'CW Topper') && ($purchase['mattressrequired']=='n' || ($purchase['savoirmodel'] == '' || $purchase['savoirmodel'] == 'n')) && ($purchase['baserequired']=='n' || ($purchase['basesavoirmodel'] == '' || $purchase['basesavoirmodel'] == 'n'))) {
            $topperMadeAt=1;
        }
        return $topperMadeAt;
    }

    public function getHBMadeAt($purchase) {
        $HBMadeAt = 0;
        $HBMadeAt = $purchase['headboardstyle'];
        if ($HBMadeAt == 'C1' || $HBMadeAt == 'C2' || $HBMadeAt == 'C4' || $HBMadeAt == 'C5' || $HBMadeAt == 'C6' || $HBMadeAt == 'CF1' || $HBMadeAt == 'CF2') {
            $HBMadeAt=1;
        } 
        if ($HBMadeAt == 1) {
            $basemadeat=$this->getBaseMadeAt($purchase);
            $mattressmadeat=$this->getBaseMadeAt($purchase);
            if ($purchase['baserequired']=='y' && $basemadeat != 0) {
                $HBMadeAt=$basemadeat;
            } else if ($purchase['mattressrequired']=='y' && $mattressmadeat != 0) {
                $HBMadeAt=$mattressmadeat;
            } else {
                $HBMadeAt=2;
            }
        }
        return $HBMadeAt;
    }

    public function recalculateTotals($purchaseTable, $locationTable, $pn) {
        $purchase = $purchaseTable->get($pn);
        $showroom = $locationTable->get($purchase->idlocation);
        $bedSetTotal = 0.0;

        if ($purchase->mattressrequired == 'y') {
            $bedSetTotal += isset($purchase->mattressprice) ? $purchase->mattressprice : 0.0;
        }

        if ($purchase->baserequired == 'y') {
            $bedSetTotal += isset($purchase->baseprice) ? $purchase->baseprice : 0.0;
            $bedSetTotal += isset($purchase->basetrimprice) ? $purchase->basetrimprice : 0.0;
            $bedSetTotal += isset($purchase->basedrawersprice) ? $purchase->basedrawersprice : 0.0;
            $bedSetTotal += isset($purchase->basefabricprice) ? $purchase->basefabricprice : 0.0;
            $bedSetTotal += isset($purchase->upholsteryprice) ? $purchase->upholsteryprice : 0.0;
        }

        if ($purchase->topperrequired == 'y') {
            $bedSetTotal += isset($purchase->topperprice) ? $purchase->topperprice : 0.0;
        }

        if ($purchase->valancerequired == 'y') {
            $bedSetTotal += isset($purchase->valanceprice) ? $purchase->valanceprice : 0.0;
        }

        if ($purchase->legsrequired == 'y') {
            $bedSetTotal += isset($purchase->legprice) ? $purchase->legprice : 0.0;
            $bedSetTotal += isset($purchase->addlegprice) ? $purchase->addlegprice : 0.0;
        }

        if ($purchase->headboardrequired == 'y') {
            $bedSetTotal += isset($purchase->headboardprice) ? $purchase->headboardprice : 0.0;
            $bedSetTotal += isset($purchase->headboardtrimprice) ? $purchase->headboardtrimprice : 0.0;
            $bedSetTotal += isset($purchase->hbfabricprice) ? $purchase->hbfabricprice : 0.0;
        }

        if ($purchase->accessoriesrequired == 'y') {
            $bedSetTotal += isset($purchase->accessoriestotalcost) ? $purchase->accessoriestotalcost : 0.0;
        }

        $percent = !isset($purchase->discounttype) || $purchase->discounttype == 'percent';
        $discount = isset($purchase->discount) ? floatval($purchase->discount) : 0.0;
        $subtotal = $bedSetTotal;

        if ($discount > 0.0) {
            if ($percent) {
                $subtotal = $bedSetTotal * ((100.0 - $discount) / 100.0);
            } else {
                $subtotal = $bedSetTotal - $discount;
            }
        }

        $tradeDiscountRate = isset($purchase->tradediscountrate) ? $purchase->tradediscountrate : 0.0;
        $deliveryCharge = isset($purchase->deliverycharge) && $purchase->deliverycharge == 'y';
        $deliveryPrice = ($deliveryCharge && isset($purchase->deliveryprice)) ? $purchase->deliveryprice : 0.0;
        $vatRate = isset($purchase->vatrate) ? $purchase->vatrate : 0.0;
        $delIncVat = isset($showroom->delivery_includes_vat) && $showroom->delivery_includes_vat == 'y';
        $total = $subtotal;
        $totalExVat = 0.0;
        $vat = 0.0;
        $tradeDiscount = 0.0;
        
        if ($purchase->istrade == 'y') {
            if ($tradeDiscountRate > 0) {
                $tradeDiscount = $total * $tradeDiscountRate / 100.0;
                $total = $total - $tradeDiscount;
            }
			if ($delIncVat) {
				$total = $total + $deliveryPrice;
				$totalExVat = $total;
				$vat = $totalExVat * $vatRate / 100.0;
				$total = $totalExVat + $vat;
			} else {
				$vat = $total * $vatRate / 100.0;
				$totalExVat = $total + $deliveryPrice;
				$total = $totalExVat + $vat;
			}
        } else {
			if ($delIncVat) {
            	$total = $total + $deliveryPrice;
            	$totalExVat = $total / (1 + $vatRate / 100.0);
            	$vat = $total - $totalExVat;
			} else {
				$totalExVat = $total / (1 + $vatRate / 100.0) + $deliveryPrice;
				$total = $total + $deliveryPrice;
				$vat = $total - $totalExVat;
			}
        }

        $paymentsTotal = isset($purchase->paymentstotal) ? $purchase->paymentstotal : 0.0;
                
        $purchase->bedsettotal = $bedSetTotal;
        $purchase->subtotal = $subtotal;
        $purchase->total = $total;
        $purchase->totalexvat = $totalExVat;
        $purchase->tradediscount = $tradeDiscount;
        $purchase->vat = $vat;
        $purchase->balanceoutstanding = $total - $paymentsTotal;
        $purchaseTable->save($purchase);
    }

    public function cleanUpPurchase($pn, $purchaseTable, $qcHistoryTable, $qcHistoryLatestTable, $compPriceDiscountTable, $wholesalePricesTable, $productionSizesTable, $accessoryTable) {
        $conn = ConnectionManager::get('default');
        $conn->begin();
        
        $purchase = $purchaseTable->get($pn);

        if ($purchase->mattressrequired == 'n' || $purchase->mattressrequired == null) {
            $purchase->savoirmodel = null;
            $purchase->mattresstype = null;
            $purchase->tickingoptions = null;
            $purchase->mattresswidth = null;
            $purchase->mattresslength = null;
            $purchase->leftsupport = null;
            $purchase->rightsupport = null;
            $purchase->leftsupport = null;
            $purchase->ventposition = null;
            $purchase->ventfinish = null;
            $purchase->mattressinstructions = null;
            $purchase->mattressprice = 0.0;
            $purchase->mattqty = 0;
            $purchase->mattress1length = null;
            $purchase->mattress1width = null;
            $purchase->mattress2length = null;
            $purchase->mattress2width = null;
            $purchase->mattunitprice = 0.0;
            $qcHistoryTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 1]);
            $qcHistoryLatestTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 1]);
            $compPriceDiscountTable->deleteAll(['purchase_no' => $pn, 'componentid' => 1]);
            $wholesalePricesTable->deleteAll(['purchase_no' => $pn, 'componentID' => 1]);
            $rs = $productionSizesTable->find('all', ['conditions' => ['Purchase_No' => $pn,]]);
            foreach ($rs as $row) {
                $row->Matt1Width = null;
                $row->Matt2Width = null;
                $row->Matt1Length = null;
                $row->Matt2Length = null;
                $productionSizesTable->save($row);
            }
        }

        if ($purchase->baserequired == 'n' || $purchase->baserequired == null) {
            $purchase->basesavoirmodel = null;
            $purchase->basetype = null;
            $purchase->basetickingoptions = null;
            $purchase->basewidth = null;
            $purchase->baselength = null;
            $purchase->baseinstructions = null;
            $purchase->baseprice = 0;
            $purchase->baseheightspring = null;
            $purchase->linkposition = null;
            $purchase->linkfinish = null;
            $purchase->basetrim = null;
            $purchase->basetrimcolour = null;
            $purchase->basetrimprice = 0;
            $purchase->basedrawerconfigID = null;
            $purchase->basedrawerheight = null; 
            $purchase->basedrawers = null; 
            $purchase->basedrawersprice = 0;  
            $purchase->upholsteredbase = null;
            $purchase->basefabricdirection = null;
            $purchase->basefabric = null;
            $purchase->basefabricchoice = null;
            $purchase->basefabricdesc = null;
            $purchase->basefabricprice = 0;
            $purchase->upholsteryprice = 0;
            $purchase->basefabriccost = 0;
            $purchase->basefabricmeters = 0;
            $qcHistoryTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 3]);
            $qcHistoryLatestTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 3]);
            $compPriceDiscountTable->deleteAll(['purchase_no' => $pn, 'componentid' => 3]);
            $wholesalePricesTable->deleteAll(['purchase_no' => $pn, 'componentID' => 3]);
            $rs = $productionSizesTable->find('all', ['conditions' => ['Purchase_No' => $pn,]]);
            foreach ($rs as $row) {
                $row->Base1Width = null;
                $row->Base2Width = null;
                $row->Base1Length = null;
                $row->Base2Length = null;
                $productionSizesTable->save($row);
            }
        }

        if ($purchase->topperrequired == 'n' || $purchase->topperrequired == null) {
            $purchase->toppertype = null;
            $purchase->toppertickingoptions = null;
            $purchase->topperwidth = null;
            $purchase->topperlength = null;
            $purchase->specialinstructionstopper = null;
            $purchase->topperprice = 0;

            $qcHistoryTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 5]);
            $qcHistoryLatestTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 5]);
            $compPriceDiscountTable->deleteAll(['purchase_no' => $pn, 'componentid' => 5]);
            $wholesalePricesTable->deleteAll(['purchase_no' => $pn, 'componentID' => 5]);
            $rs = $productionSizesTable->find('all', ['conditions' => ['Purchase_No' => $pn,]]);
            foreach ($rs as $row) {
                $row->topper1Width = null;
                $row->topper1Length = null;
                $productionSizesTable->save($row);
            }
        }

        if ($purchase->valancerequired == 'n' || $purchase->valancerequired == null) {
            $purchase->pleats = null;
            $purchase->valancefabricoptions = null;
            $purchase->valancefabricdirection = null;
            $purchase->valancefabric = null;
            $purchase->valancefabricchoice = null;
            $purchase->valfabricmeters = null;
            $purchase->valfabriccost = 0;
            $purchase->valfabricprice = 0;
            $purchase->valancedrop = null;
            $purchase->valancewidth = null;
            $purchase->valancelength = null;
            $purchase->specialinstructionsvalance = null;
            $purchase->valanceprice = 0;
        
            $qcHistoryTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 6]);
            $qcHistoryLatestTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 6]);
            $compPriceDiscountTable->deleteAll(['purchase_no' => $pn, 'componentid' => 6]);
            $wholesalePricesTable->deleteAll(['purchase_no' => $pn, 'componentID' => 6]);
        }

        if ($purchase->legsrequired == 'n' || $purchase->legsrequired == null) {
            $purchase->legstyle = null;
            $purchase->LegQty = null;
            $purchase->legfinish = null;
            $purchase->legheight = null;
            $purchase->addlegstyle = null;
            $purchase->AddLegQty = null;
            $purchase->addlegfinish = null;
            $purchase->specialinstructionslegs = null;
            $purchase->legprice = 0;
            $purchase->addlegprice = 0;
                
            $qcHistoryTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 7]);
            $qcHistoryLatestTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 7]);
            $compPriceDiscountTable->deleteAll(['purchase_no' => $pn, 'componentid' => 7]);
            $wholesalePricesTable->deleteAll(['purchase_no' => $pn, 'componentID' => 7]);
            $rs = $productionSizesTable->find('all', ['conditions' => ['Purchase_No' => $pn,]]);
            foreach ($rs as $row) {
                $row->legheight = null;
                $productionSizesTable->save($row);
            }
        }

        if ($purchase->headboardrequired == 'n' || $purchase->headboardrequired == null) {
            $purchase->headboardstyle = null;
            $purchase->headboardheight = null;
            $purchase->headboardWidth = null;
            $purchase->headboardfinish = null;
            $purchase->footboardheight = null;
            $purchase->footboardfinish = null;
            $purchase->headboardlegqty = null;
            $purchase->manhattantrim = null;
            $purchase->hbfabricoptions = null;
            $purchase->headboardfabric = null;
            $purchase->headboardfabricdirection = null;
            $purchase->hbfabricmeters = null;
            $purchase->hbfabriccost = 0;
            $purchase->headboardfabricchoice = null;
            $purchase->headboardfabricdesc = null;
            $purchase->specialinstructionsheadboard = null;
            $purchase->headboardprice = 0;
            $purchase->hbfabricprice = 0;
            $purchase->headboardtrimprice = 0;
                        
            $qcHistoryTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 8]);
            $qcHistoryLatestTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 8]);
            $compPriceDiscountTable->deleteAll(['purchase_no' => $pn, 'componentid' => 8]);
            $wholesalePricesTable->deleteAll(['purchase_no' => $pn, 'componentID' => 8]);
        }

        if ($purchase->accessoriesrequired == 'n' || $purchase->accessoriesrequired == null) {
            $purchase->accessoriestotalcost = 0;

            $qcHistoryTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 9]);
            $qcHistoryLatestTable->deleteAll(['Purchase_No' => $pn, 'ComponentID' => 9]);
            $compPriceDiscountTable->deleteAll(['purchase_no' => $pn, 'componentid' => 9]);
            $wholesalePricesTable->deleteAll(['purchase_no' => $pn, 'componentID' => 9]);
            $accessoryTable->deleteAll(['purchase_no' => $pn]);
        }

        $purchaseTable->save($purchase);
        $conn->commit();
    }

    public static function getNextPrimeKeyValForTable($tableName, $margin) {
        $conn = ConnectionManager::get('default');
        $sql = "SELECT auto_increment FROM information_schema.TABLES WHERE TABLE_NAME=:tableName";
        $rs = $conn->execute($sql, ['tableName' => $tableName]);
        $row = $rs->fetch('assoc');
        $keyFromRealTable = $row['auto_increment'] + $margin;

        $primeKeyCol = OrderHelperComponent::getPrimeKeyColOfTable($conn, $tableName);
        $sql = "SELECT max(".$primeKeyCol.") as max FROM temp_" . $tableName;
        $rs = $conn->execute($sql);
        $row = $rs->fetch('assoc');
        $keyFromTempTable = $row['max'] + 1;

        return max($keyFromRealTable, $keyFromTempTable);
    }
    
    public static function getPrimeKeyColOfTable($conn, $tableName) {
        $sql = "SELECT COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_NAME = :tableName AND CONSTRAINT_NAME = 'PRIMARY'";
        $rs = $conn->execute($sql, ['tableName' => $tableName]);
        $row = $rs->fetch('assoc');
        return $row['COLUMN_NAME'];
    }}
?>