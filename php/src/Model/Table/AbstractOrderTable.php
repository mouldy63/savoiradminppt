<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;
use Cake\ORM\TableRegistry;

class AbstractOrderTable extends Table {

    private $purchaseBaseFabricChangeFields = ['basefabric', 'basefabricdirection', 'basefabricchoice', 'basefabricprice', 'basefabricmeters', 'basefabriccost', 'basefabricdesc'];
    private $purchaseLegsFabricChangeFields = ['specialinstructionslegs'];
    private $purchaseHBFabricChangeFields = ['headboardfabricchoice', 'headboardfabricdirection', 'headboardfabric', 'hbfabricprice', 'hbfabricmeters', 'hbfabriccost', 'headboardfabricdesc'];
    private $purchaseValanceFabricChangeFields = ['pleats', 'valfabriccost', 'valfabricmeters', 'valfabricprice', 'valancefabric', 'specialinstructionsvalance', 'valancefabricchoice', 'valancefabricdirection', 'valancewidth', 'valancelength', 'valancedrop', 'valancefabricoptions'];
    private $purchaseChangeFields = ['pleats', 'valfabriccost', 'valfabricmeters', 'valfabricprice', 'valancefabric', 'specialinstructionsvalance', 'valancefabricchoice', 'valancefabricdirection', 'valancewidth', 'valancelength', 'valancedrop', 'valancefabricoptions'];
    
    public function initialize(array $config) : void {
    }

	public function getOrderType($userregion) {
    	$conn = ConnectionManager::get('default');
        if ($userregion==1) {
            $sql = "select * FROM ordertype";
        } else {
    	    $sql = "select * FROM ordertype where UKOnly='n'";
        }
        $conn = ConnectionManager::get('default');
		return $conn->execute($sql)->fetchAll('assoc');
    }

    public function isTradeCustomer($contactno) {
    	$conn = ConnectionManager::get('default');
        $sql = "select a.PRICE_LIST from contact c, address a where a.CODE=c.CODE and c.CONTACT_NO=".$contactno;
        $conn = ConnectionManager::get('default');
		$row = $conn->execute($sql)->fetchAll('assoc')[0];
        $priceList='';
        if (isset($row['PRICE_LIST']) && !empty($row['PRICE_LIST'])) {
            $priceList = strtolower($row['PRICE_LIST']);
        }
        $isTrade = false;
        if ($priceList=='trade' || $priceList=='savoy' || $priceList=='contract' || $priceList =='wholesale' ||$priceList=='net retail') {
            $isTrade = true;
        }
        return $isTrade;
    }

    public function getBedModel($compid) {
    	$conn = ConnectionManager::get('default');
        
        $sql = "Select * from Bedmodel where UKonly='n' and retired='n'";
        if ($compid==1) {
            $sql .= " and baseonly='n'";
        }
        $sql .= " order by priority asc";
        $conn = ConnectionManager::get('default');
		return $conn->execute($sql)->fetchAll('assoc');
    }

    public function getCustomerOrderCount($contactno) {
    	$conn = ConnectionManager::get('default');
        $sql = "select count(purchase_no) as x from purchase where (quote='n' or quote is null) and (cancelled='n' or cancelled is null) and contact_no=".$contactno;
        $conn = ConnectionManager::get('default');
		return $conn->execute($sql)->fetchAll('assoc')[0]['x'];
    }

    public function getLinkPosition() {
    	$conn = ConnectionManager::get('default');
        
        $sql = "Select * from linkposition where retired='n'";
        $conn = ConnectionManager::get('default');
		return $conn->execute($sql)->fetchAll('assoc');
    }

    public function getHeightSpring() {
    	$conn = ConnectionManager::get('default');
        $sql = "Select * from baseheightspring";
		return $conn->execute($sql)->fetchAll('assoc');
    }

    public function getPendingInvoices($pn) {
    	$conn = ConnectionManager::get('default');
        $sql = "Select * from pending_invoicenos where purchase_no=".$pn;
		return $conn->execute($sql)->fetchAll('assoc');
    }

    public function orderhasexports($pn) {
    	$conn = ConnectionManager::get('default');
        $sql = "Select distinct(E.CollectionDate),E.exportcollectionsID from exportcollections E, exportLinks L, exportCollShowrooms S where (L.invoiceNo IS NOT NULL and L.invoiceNo<>'') and L.purchase_no=".$pn." and L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID";
		return $conn->execute($sql)->fetchAll('assoc');
    }

    public function getOrderExportInvoiceData($pn) {
    	$conn = ConnectionManager::get('default');
        $sql = "Select distinct(E.CollectionDate),E.exportcollectionsID from exportcollections E, exportLinks L, exportCollShowrooms S where (L.invoiceNo IS NOT NULL and L.invoiceNo<>'') and L.purchase_no=".$pn." and L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID";
		$rows = $conn->execute($sql)->fetchAll('assoc');
        debug($rows);
        foreach ($rows as $row) {
            $sql = "Select L.componentid, L.invoiceNo, L.invoicedate, E.exportCollectionsID from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=".$pn." and E.collectiondate='" . $row['CollectionDate'] . "' AND L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID";
            $invRows = $conn->execute($sql)->fetchAll('assoc');
            debug($invRows);
            foreach ($invRows as $invRow) {
            }
        }
        die;
    }

    public function orderhasexportsNoInvoices($pn) {
    	$conn = ConnectionManager::get('default');
        $sql = "Select distinct(E.CollectionDate),E.exportcollectionsID from exportcollections E, exportLinks L, exportCollShowrooms S where (L.invoiceNo IS NULL or L.invoiceNo='') and L.purchase_no=".$pn." and L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID";
		return $conn->execute($sql)->fetchAll('assoc');
    }

    public function copyRealPurchaseToTempTables($pn) {
        $conn = ConnectionManager::get('default');
        $conn->begin();
        $this->clearTempTablesForPurchase($conn, $pn);

        $sql = "insert into temp_purchase select * from purchase where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "insert into temp_wholesale_prices select * from wholesale_prices where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "insert into temp_qc_history select * from qc_history where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "insert into temp_productionsizes select * from productionsizes where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "insert into temp_phonenumber select * from phonenumber where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "insert into temp_ordernote select * from ordernote where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "insert into temp_comp_price_discount select * from comp_price_discount where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "insert into temp_orderaccessory select * from orderaccessory where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "insert into temp_payment select * from payment where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "insert into temp_batchemail select * from batchemail where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "insert into temp_exportlinks select * from exportlinks where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);

        $conn->commit();
    }

    public function moveTempTablesToRealPurchase($pn, $currentUsersId, $purchaseHistoryTable, $isNewOrder) {
        if (!$isNewOrder) {
            $purchaseTable = TableRegistry::getTableLocator()->get('Purchase');
            $oldPurchase = $purchaseTable->get($pn)->toArray();
            $productionSizesTable = TableRegistry::getTableLocator()->get('ProductionSizes');
            $oldProductionSizes = $productionSizesTable->find('all')->where(['purchase_no' => $pn])->toArray();
            $orderAccessoryTable = TableRegistry::getTableLocator()->get('Accessory');
            $oldAccessories = $orderAccessoryTable->find('all')->where(['purchase_no' => $pn])->toArray();
        }

        $conn = ConnectionManager::get('default');
        $conn->begin();
        $this->clearRealTablesForPurchase($conn, $pn);
        $this->copyTempTableToReal($conn, 'purchase', $pn);
        $this->copyTempTableToReal($conn, 'wholesale_prices', $pn);
        $this->copyTempTableToReal($conn, 'qc_history', $pn);
        $this->copyTempTableToReal($conn,'productionsizes', $pn);
        $this->copyTempTableToReal($conn, 'phonenumber', $pn);
        $this->copyTempTableToReal($conn, 'ordernote', $pn);
        $this->copyTempTableToReal($conn, 'comp_price_discount', $pn);
        $this->copyTempTableToReal($conn, 'orderaccessory', $pn);
        $this->copyTempTableToReal($conn, 'payment', $pn);
        $this->copyTempTableToReal($conn, 'batchemail', $pn);
        $this->copyTempTableToReal($conn, 'exportlinks', $pn);
        $this->clearTempTablesForPurchase($conn, $pn);
        $this->applyStampToPurchase($conn, $pn, $currentUsersId);
        $this->copyPurchaseToHistory($conn, $pn, $currentUsersId, $purchaseHistoryTable);
        $conn->commit();
        
        $oldRecords=[];
        if (!$isNewOrder) {
            $oldRecords['purchase']=$oldPurchase;
            $oldRecords['productionSizes']=$oldProductionSizes;
            $oldRecords['accessories']=$oldAccessories;
        }
        return $oldRecords;
    }


    private function copyPurchaseToHistory($conn, $pn, $currentUsersId, $purchaseHistoryTable) {
        $history = $purchaseHistoryTable->newEntity([]);
        $history->purchase_no = $pn;
        $history->updatedby = $currentUsersId;
        $data = [];

        $rs = $conn->execute("select * from purchase where purchase_no=:pn", ['pn' => $pn]);
        $data['purchase'] = $rs->fetch('assoc');

        $rs = $conn->execute("select * from wholesale_prices where purchase_no=:pn", ['pn' => $pn]);
        $data['wholesale_prices'] = $rs->fetch('assoc');

        $rs = $conn->execute("select * from qc_history where purchase_no=:pn", ['pn' => $pn]);
        $data['qc_history'] = $rs->fetch('assoc');

        $rs = $conn->execute("select * from productionsizes where purchase_no=:pn", ['pn' => $pn]);
        $data['productionsizes'] = $rs->fetch('assoc');

        $rs = $conn->execute("select * from phonenumber where purchase_no=:pn", ['pn' => $pn]);
        $data['phonenumber'] = $rs->fetch('assoc');

        $rs = $conn->execute("select * from ordernote where purchase_no=:pn", ['pn' => $pn]);
        $data['ordernote'] = $rs->fetch('assoc');

        $rs = $conn->execute("select * from comp_price_discount where purchase_no=:pn", ['pn' => $pn]);
        $data['comp_price_discount'] = $rs->fetch('assoc');

        $rs = $conn->execute("select * from orderaccessory where purchase_no=:pn", ['pn' => $pn]);
        $data['orderaccessory'] = $rs->fetch('assoc');

        $rs = $conn->execute("select * from payment where purchase_no=:pn", ['pn' => $pn]);
        $data['payment'] = $rs->fetch('assoc');

        $history->data = json_encode($data);
        $purchaseHistoryTable->save($history);
    }

    private function clearTempTablesForPurchase($conn, $pn) {
        $sql = "delete from temp_exportlinks where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from temp_batchemail where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from temp_payment where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from temp_orderaccessory where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from temp_comp_price_discount where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from temp_ordernote where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from temp_phonenumber where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from temp_productionsizes where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from temp_qc_history where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from temp_wholesale_prices where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from temp_purchase where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
    }

    private function clearRealTablesForPurchase($conn, $pn) {
        $sql = "delete from exportlinks where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from batchemail where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from payment where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from orderaccessory where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from comp_price_discount where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from ordernote where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from phonenumber where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from productionsizes where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from qc_history where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from wholesale_prices where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
        $sql = "delete from purchase where purchase_no=:pn";
        $conn->execute($sql, ['pn' => $pn]);
    }

    private function copyTempTableToReal($conn, $tableName, $pn) {
        $sql = "select * from " . $tableName . " where purchase_no=" . $pn;
        $rs = $conn->execute($sql);

        if ($rs->rowCount() == 0) {
            // no existing row, so a simple insert
            $sql = "insert into " . $tableName . " select * from temp_" . $tableName . " where purchase_no=" . $pn;
            $conn->execute($sql);
            return; 
        } else {
            throw new \Exception("Update not implemented");
        }

        // it's an update, which is harder
        $colnames = $this->getTableColumns($conn, $tableName);
        $sql1 = "";
        foreach ($colnames as $col) {
            if ($sql1 != "") $sql1 .= ",";
            $sql1 .= " trg." . $col . "=src." . $col;
        }
        $sql = "update " . $tableName . " trg join temp_" . $tableName . " src on trg.purchase_no=src.purchase_no set";
        $sql .= $sql1;
        $sql .= " where src.purchase_no=" . $pn;
        $conn->execute($sql);
    }

    private function getTableColumns($conn, $tableName) {
        $sql = "select column_name from information_schema.columns where table_name=:tablename order by ordinal_position";
        $columns = [];
        $rs = $conn->execute($sql, ['tablename' => $tableName]);
        foreach ($rs as $row) {
            $columns[] = $row['column_name'];
        }
        return $columns;
    }

    private function applyStampToPurchase($conn, $pn, $currentUsersId) {
        $stamp = $currentUsersId . " " . time();
        $sql = "update purchase set stamp=:stamp where purchase_no=:pn";
        $conn->execute($sql, ['stamp' => $stamp, 'pn' => $pn]);
    }

    public function getPurchaseStampFromRealTable($pn) {
        $conn = ConnectionManager::get('default');
        $sql = "select stamp from purchase where purchase_no=:pn";
        $rs = $conn->execute($sql, ['pn' => $pn]);
        $row = $rs->fetch('assoc');
        return isset($row['stamp']) ? $row['stamp'] : null;
    }

    public function getNextPrimeKeyValForTable($tableName, $margin) {
        $conn = ConnectionManager::get('default');
        $sql = "SELECT auto_increment FROM information_schema.TABLES WHERE TABLE_NAME=:tableName";
        $rs = $conn->execute($sql, ['tableName' => $tableName]);
        $row = $rs->fetch('assoc');
        $keyFromRealTable = $row['auto_increment']; // + $margin;

        $primeKeyCol = $this->getPrimeKeyColOfTable($tableName);
        $sql = "SELECT max(".$primeKeyCol.") as max FROM temp_" . $tableName;
        $rs = $conn->execute($sql);
        $row = $rs->fetch('assoc');
        $keyFromTempTable = $row['max'] + 1;

        return max($keyFromRealTable, $keyFromTempTable);
    }

    public function getPrimeKeyColOfTable($tableName) {
        $conn = ConnectionManager::get('default');
        $sql = "SELECT COLUMN_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_NAME = :tableName AND CONSTRAINT_NAME = 'PRIMARY'";
        $rs = $conn->execute($sql, ['tableName' => $tableName]);
        $row = $rs->fetch('assoc');
        return $row['COLUMN_NAME'];
    }
}
?>