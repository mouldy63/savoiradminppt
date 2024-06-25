<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use Cake\I18n\Time;
use \DateTime;


class CommunicationTable extends Table {
    //public $name = 'Communication';
	private $months = array("January"=>"1", "February"=>"2", "March"=>"3", "April"=>"4", "May"=>"5", "June"=>"6", "July"=>"7", "August"=>"8", "September"=>"9", "October"=>"10", "November"=>"11", "December"=>"12");
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('communication');
        $this->setPrimaryKey('Communication');
    }
	
	public function getBrochureFollowUps($monthfrom, $monthto, $month, $year, $showroom, $user, $commstatus, $sortorder) {
    	$sql = "Select CONTACT_NO,Date,C.CODE,person,commstatus,Next,Response,location,Communication,staff from communication X, contact C, Location L WHERE X.code=C.Code and C.idlocation=L.idlocation and (X.type like '%brochure request%' or X.notes like '%brochure request%') ";
		if ($monthfrom != "n" && $monthfrom !="") {
			$sql .=  " and X.date >= '" . $this->convertDateToMysql($monthfrom) . "' and X.date <= '" . $this->convertDateToMysql($monthto) . "'";
		}
		if ($month != "n" && $month !="") {
			$sql .= " AND month(X.date) = " . $this->months[$month] . " AND year(X.date) = " . $year;
		}
		if ($showroom != "n" && $showroom !="") {
			$sql .= " AND C.idlocation = " . $showroom;
		}
		if ($user != "n" && $user !="") {
			$sql .= " AND (X.staff = '" . $user . "' OR X.Response like '%" . $user . "%')";
		}
		if ($commstatus != "n" && $commstatus !="") {
			$sql .= " AND X.commstatus = '" . $commstatus . "'";
		}
		if ($sortorder !="") {
			$sql .= " order by " . $sortorder . "";
		}
		//echo("<p>" . $sql . "</p>");
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getCustomerOrdersAndValues($contactno, $contactdate) {
    	$sql = "select purchase_no, order_date, order_number, total, ordercurrency from purchase where order_date > '" . $contactdate . "' and (cancelled<>'y' or cancelled is null) AND contact_no=" . $contactno . " order by order_date asc";
		//echo("<p>" . $sql . "</p>");
    	$myconn = ConnectionManager::get('default');
    	return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getCustomerAddress($code) {
		$sql = "select * from address where code=" . $code;
		$myconn = ConnectionManager::get('default');
    	return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getCustomerNotes($code) {

		$sql = "select * from communication where code=:code order by date desc";
	    $myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['code' => $code]);
		$notes = [];
		foreach ($rs as $row) {
			$note['commDate'] = $this->_getSafeValueFromRs($row, 'date');
			$note['commType'] = $this->_getSafeValueFromRs($row, 'type');
			$note['person'] = $this->_getSafeValueFromRs($row, 'person');
			$note['notes'] = $this->_getSafeValueFromRs($row, 'notes');
			$note['actionnext'] = $this->_getSafeValueFromRs($row, 'next');
			$note['actionresponse'] = $this->_getSafeValueFromRs($row, 'response');
			$note['staff'] = $this->_getSafeValueFromRs($row, 'staff');
			array_push($notes, $note);
		}
		return $notes;	
    }
    
	public function getCommunicationType($contactNo) {
		$sql = "select cm.type from contact c join communication cm on c.code=cm.code and c.contact_no=:cn and cm.type is not null and cm.type != '' order by dateupdated desc limit 1"; 
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');
		$type = null;
		if (count($rs) > 0) {
			$type = $rs[0]['type'];
		}
		return $type;
    }
    
	public function getBrochureRequestType($contactNo) {
		$sql = "select cm.type from contact c join communication cm on c.code=cm.code and c.contact_no=:cn and cm.type like '%Brochure%' order by dateupdated desc limit 1 "; 
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['cn' => $contactNo])->fetchAll('assoc');
		$type = null;
		if (count($rs) > 0) {
			$type = $rs[0]['type'];
		}
		return $type;
    }

	public function getOutstandingBalances($security) {
		$sql = "Select * from purchase P, contact C WHERE P.contact_no=C.CONTACT_NO";
		$sql .= " and (C.CONTACT_NO<>319256 and C.CONTACT_NO<>24188 and C.retire<>'y')";
		$sql .= " and P.idlocation=" .$security->getCurrentUserLocationId() ." and (P.cancelled is null or P.cancelled <>'y')  and P.orderonhold<>'y' and P.completedorders='n' AND P.bookeddeliverydate is not NULL and P.balanceoutstanding > 0 order by P.bookeddeliverydate asc"; 
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getTotalOutstandingBalance($security) {
		$sql = "Select SUM(P.balanceoutstanding) as n from purchase P, contact C WHERE P.contact_no=C.CONTACT_NO";
		$sql .= " and (C.CONTACT_NO<>319256 and C.CONTACT_NO<>24188 and C.retire<>'y')";
		$sql .= " and P.idlocation=" .$security->getCurrentUserLocationId() ." and (P.cancelled is null or P.cancelled <>'y')  and P.orderonhold<>'y' and P.completedorders='n' AND P.bookeddeliverydate is not NULL and P.balanceoutstanding > 0 order by P.bookeddeliverydate asc"; 
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql)->fetchAll('assoc');
		$type = null;
		if (count($rs) > 0) {
			$total = $rs[0]['n'];
		}
		return $total;
    }
    
    public function closecustomernote($communicationID,$staff,$name) {
	
	$customernotes = $this->find('all', ['conditions'=> ['Communication' => $communicationID]]);
	$now = Time::now();
	$now = $now->i18nFormat('yyyy-MM-dd HH:mm:ss');;
        foreach ($customernotes as $customernote) {
            $customernote['commstatus']='Completed';
            $customernote['staff']=$staff;
            $customernote['commCompletedBy']=$staff;
            $customernote['completedDate']=$now;
            $appendnote=$customernote['Response'];
            $customernote['Response']=$name.'<br />'.$staff.'<br />'.$now.'<br /><br />'.$appendnote;
            //debug($customernote);
            //die();
            $this->save($customernote);
        }  
    }
    
    public function changeTaskDate($communicationID,$taskdate) {
	
	$customernotes = $this->find('all', ['conditions'=> ['Communication' => $communicationID]]);
        foreach ($customernotes as $customernote) {
            $customernote['Next']=$this->convertDateToMysql($taskdate);
            $this->save($customernote);
        }  
    }
    
	private function convertDateToMysql($date) {
		$myDateTime = DateTime::createFromFormat('d/m/Y', $date);
		$date = $myDateTime->format('Y-m-d');
		return $date;
	}

	private function _getSafeValueFromRs($row, $name) {
		$value = "";
		if (isset($row[$name])) {
			$value = $row[$name];
		}
		return $value;
	}
}
?>