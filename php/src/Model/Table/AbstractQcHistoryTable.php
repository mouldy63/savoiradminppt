<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class AbstractQcHistoryTable extends Table {
    private $insertQuery;
    private $myconn;

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->insertQuery = "insert into qc_history (ComponentID,Purchase_No,QC_Date,UpdatedBy,IssuedDate,MadeAt,QtyToFollow,QC_StatusID)";
        $this->insertQuery .= " select ComponentID,Purchase_No,sysdate(),UpdatedBy,IssuedDate,MadeAt,QtyToFollow, %d as QC_StatusID";
        $this->insertQuery .= " from qc_history where QC_HistoryID=(select qc_historyid from qc_history where purchase_no=%d and componentid=0 order by qc_date desc LIMIT 1)";
        $this->myconn = ConnectionManager::get('default');
    }

    public function insertOrderStatusRow($pn, $qcStatusId) {
        $sql = sprintf($this->insertQuery, $qcStatusId, $pn);
        return $this->myconn->execute($sql);
    }
    
    public function getLeadTime($manufacturer) {
    	$sql = "Select count(*) as n from qc_history_latest Q, purchase P where P.PURCHASE_No=Q.Purchase_No and Q.MadeAt=".$manufacturer." and Q.finished is Null and (Q.QC_StatusID=2 or Q.QC_StatusID=20) AND  P.orderonhold<>'y' and P.code<>15919 and  (P.cancelled is Null or P.cancelled='n')";
		$myconn = ConnectionManager::get('default');
		$rs= $myconn->execute($sql)->fetchAll('assoc');
		return $rs[0]['n'];
		
    }
    
    public function getNoItemsWeek($manufacturer) {
    	$sql = "Select NoItemsWeek as n from manufacturedat WHERE ManufacturedAtID=" .$manufacturer;
		$myconn = ConnectionManager::get('default');
		$rs= $myconn->execute($sql)->fetchAll('assoc');
        return $rs[0]['n'];
    }

    public function insertQcHistoryRow($aCompId, $aPn, $aOrderStatusId, $aUpdatedBy) {
        // get the existing madeat value if there is one
        $myconn = ConnectionManager::get('default');
        $asql = "select MadeAt from " . $this->getTable() . " where componentid=" . $aCompId . " and purchase_no=" . $aPn . " order by QC_Date desc";
        $rs = $myconn->execute($asql)->fetchAll('assoc');
        $aMadeAtId = 0;
        if (count($rs) > 0) {
            $aMadeAtId = $rs[0]['MadeAt'];
            if (!isset($aMadeAtId)) $aMadeAtId = 0;
        }
        
        $aNewHistoryRowId = $this->copyHistoryRow($aPn, $aCompId);
        $asql = "update " . $this->getTable() . " set QC_StatusID=" . $aOrderStatusId . ", UpdatedBy=" . $aUpdatedBy . ", MadeAt=" . $aMadeAtId . " where qc_historyid=" . $aNewHistoryRowId;
        $myconn->execute($asql);
    }
    
    public function copyHistoryRow($apn, $acompId) {
        $myconn = ConnectionManager::get('default');
        $asql = "select qc_historyid from " . $this->getTable() . " where purchase_no=" . $apn . " and componentid=" . $acompId . " order by qc_date desc";
        $aqcHistoryId = 0;
        $rs = $myconn->execute($asql)->fetchAll('assoc');
        if (count($rs) == 0) {
            return 0;            
        }
        $aqcHistoryId = $rs[0]['qc_historyid'];
        
        $acols = $this->getTableColumns("qc_history", "QC_HistoryID");
        $asql = "insert into " . $this->getTable() . " (" . $acols . ") select " . $acols . " from " . $this->getTable() . " where QC_HistoryID=" . $aqcHistoryId;
        $myconn->execute($asql);
        
        $asql = "select max(qc_historyid) as m from " . $this->getTable();
        $rs = $myconn->execute($asql)->fetchAll('assoc');
        $anewQcHistoryId = 0;
        if (count($rs) != 0) {
            $anewQcHistoryId = $rs[0]['m'];
        }
        
        $asql = "update " . $this->getTable() . " set qc_date=NOW() where QC_HistoryID=" . $anewQcHistoryId;
        $myconn->execute($asql);
	    return $anewQcHistoryId;
    }
    
    public function getTableColumns($atableName, $aExcludeCol) {
        $myconn = ConnectionManager::get('default');
        $rs = $myconn->execute("select database() as db")->fetchAll('assoc');
        $aschema = $rs[0]['db'];
        
        $asql = "select column_name from information_schema.columns where table_schema = '" . $aschema . "' and table_name='" . $atableName . "' order by ordinal_position";
        $rs = $myconn->execute($asql)->fetchAll('assoc');
        
        $astr = "";
        foreach ($rs as $row) {
            if ($row["column_name"] <> $aExcludeCol) {
                if ($astr <> "") $astr = $astr . ",";
                $astr = $astr . $row["column_name"];
            }
        }
        return $astr;
    }
    
    public function setOrderStatusByMinComponentStatus($apn, $aUpdatedBy) {
        $myconn = ConnectionManager::get('default');
        $asql = "select distinct componentid from qc_history_latest where purchase_no=" . $apn . " and componentid <>0";
        //echo '<br>$asql=' . $asql;
        $rs = $myconn->execute($asql)->fetchAll('assoc');
        $aMinOrderComponentStatus = 999;
        foreach ($rs as $row) {
            $aCompId = $row["componentid"];
            $asql = "select qc_statusid from qc_history_latest where purchase_no=" . $apn . " and componentid=" . $aCompId . " order by qc_date desc";
            //echo '<br>$asql=' . $asql;
            $aCurrentComponentStatus = 999;
            $rs2 = $myconn->execute($asql)->fetchAll('assoc');
            //debug($rs2);
            if (count($rs2) != 0) {
                $aCurrentComponentStatus = $rs2[0]["qc_statusid"];
            }
            //echo '<br>$aCurrentComponentStatus=' . $aCurrentComponentStatus;
            
            if ($aCurrentComponentStatus < $aMinOrderComponentStatus) {
                $aMinOrderComponentStatus = $aCurrentComponentStatus;
            }
        }
        //echo '<br>$aMinOrderComponentStatus=' . $aMinOrderComponentStatus;
        
        $asql = "select qc_statusid from qc_history_latest where purchase_no=" . $apn . " and componentid=0 order by qc_date desc";
        //echo '<br>$asql=' . $asql;
        $aCurrentOrderStatus = 0;
        $rs = $myconn->execute($asql)->fetchAll('assoc');
        if (count($rs) != 0) {
            $aCurrentOrderStatus = $rs[0]["qc_statusid"];
        }
        //echo '<br>$aCurrentOrderStatus=' . $aCurrentOrderStatus;
        
        if ($aMinOrderComponentStatus > $aCurrentOrderStatus) {
            $aNewHistoryRowId = $this->copyHistoryRow($apn, 0);
            $asql = "update " . $this->getTable() . " set QC_StatusID=" . $aMinOrderComponentStatus . ", UpdatedBy=" . $aUpdatedBy . ", MadeAt=0 where qc_historyid=" . $aNewHistoryRowId;
            //echo '<br>$asql=' . $asql;
            $myconn->execute($asql);
        }
    }
    
     public function getIssueDate($pn, $compid) {
		$sql = "select IssuedDate from " . $this->getTable() . " where Purchase_No=".$pn." AND ComponentID=".$compid." order by QC_Date desc limit 1";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
    
	public function getOrderConfirmedDate($pn) {
    	$sql = "SELECT QC_Date FROM " . $this->getTable() . " where purchase_no=:pn and componentID=0 order by QC_Date desc limit 1";
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['pn' => $pn]);
		$date = null;
		foreach ($rs as $row) {
			$date = $row['QC_Date'];
		}
		return $date;
	}

    public function getLongestLeadTime() {
		$myconn = ConnectionManager::get('default');
	    
        $sql = "Select count(*) as n from qc_history_latest Q, purchase P where P.purchase_no=Q.purchase_no and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=2 or Q.QC_StatusID=20) AND  P.orderonhold<>'y' and  (P.cancelled is Null or P.cancelled='n')";
		$rs = $myconn->execute($sql)->fetchAll('assoc');
	    $nLondonItems = $rs[0]['n'];
	
        $sql = "Select count(*) as n from qc_history_latest Q, purchase P where P.purchase_no=Q.purchase_no and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=2 or Q.QC_StatusID=20) and P.code<>15919 AND  P.orderonhold<>'y'and (P.cancelled is Null or P.cancelled='n')";
		$rs = $myconn->execute($sql)->fetchAll('assoc');
	    $nCardiffItems = $rs[0]['n'];
	
	    $sql = "Select NoItemsWeek, manufacturedatid from manufacturedat";
		$rs = $myconn->execute($sql)->fetchAll('assoc');
        foreach ($rs as $row) {
            if ($row["manufacturedatid"] == 1) $cardiffNo = $row["NoItemsWeek"];
            if ($row["manufacturedatid"] == 2) $londonNo = $row["NoItemsWeek"];
        }
        $cardiffNo = round((floatval($nCardiffItems) / floatval($cardiffNo)) + 0.5);
        $londonNo = round((floatval($nLondonItems) / floatval($londonNo)) + 0.5);
        if ($cardiffNo > $londonNo) {
            $longestLeadTime = $cardiffNo;
        } else {
            $longestLeadTime = $londonNo;
        }
        
        return [
            'longestLeadTime' => $longestLeadTime,
            'cardiffNo' => $cardiffNo,
            'londonNo' => $londonNo
        ];
    }

    public function insertQcHistoryRowIfNone($orderTable, $compId, $pn, $updatedBy, $madeAt) {
		$myconn = ConnectionManager::get('default');
        $sql = "select * from " . $this->getTable() . " where componentid=:compId and purchase_no=:pn order by QC_Date desc";
		$rs = $myconn->execute($sql, ['compId' => $compId, 'pn' => $pn])->fetchAll('assoc');

        if (count($rs) > 0) {
            // already got one
            return;
        }
        $id = $orderTable->getNextPrimeKeyValForTable('qc_history', 1);
        $sql = "insert into " . $this->getTable() . " (QC_HistoryID,ComponentID,QC_StatusID,Purchase_No,QC_Date,UpdatedBy,MadeAt) values (:id,:compId,:orderStatusId,:pn,now(),:updatedBy,:madeatid)";
        $myconn->execute($sql, ['orderStatusId' => 0, 'updatedBy' => $updatedBy, 'madeatid' => $madeAt, 'compId' => $compId, 'pn' => $pn, 'id' => $id]);
    }

}
?>