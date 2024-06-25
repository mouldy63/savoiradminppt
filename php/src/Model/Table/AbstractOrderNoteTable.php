<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use Cake\I18n\Time;
use \DateTime;

class AbstractOrderNoteTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
    }
	
	public function getOrderNotes($pn) {

		$sql = "select * from " . $this->getTable() . " where purchase_no=:purchase_no order by createddate desc";
	    $myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['purchase_no' => $pn]);
		$notes = [];
		foreach ($rs as $row) {
			$note['ordernote_id'] = $this->_getSafeValueFromRs($row, 'ordernote_id');
			$note['createddate'] = $this->_getSafeValueFromRs($row, 'createddate');
			$note['notetext'] = $this->_getSafeValueFromRs($row, 'notetext');
			$note['username'] = $this->_getSafeValueFromRs($row, 'username');
			$note['action'] = $this->_getSafeValueFromRs($row, 'action');
			$note['followupdate'] = $this->_getSafeValueFromRs($row, 'followupdate');
			$note['notetype'] = $this->_getSafeValueFromRs($row, 'notetype');
			$note['NoteCompletedDate'] = $this->_getSafeValueFromRs($row, 'NoteCompletedDate');
			$note['NoteCompletedBy'] = $this->_getSafeValueFromRs($row, 'NoteCompletedBy');
			array_push($notes, $note);
		}
		return $notes;	
    }
    
    public function getOutstandingTasks($security, $username) {

		$sql = "Select O.ordernote_id, O.followupdate, A.company, P.ORDER_NUMBER, P.quote, O.purchase_no, A.CODE, A.tel, C.surname, C.title, C.first, C.CONTACT_NO, A.EMAIL_ADDRESS, C.telwork, C.mobile, O.username,O.notetext from ordernote O, purchase P, Contact C, Address A, savoir_user U WHERE O.purchase_no=P.PURCHASE_No and P.contact_no=C.CONTACT_NO and U.username=O.username and O.action='To Do'";
		if ($security->getCurrentUserLocationId()==1 || $security->getCurrentUserLocationId()==27) {
		$sql .= " AND O.username='".$username."'";
		} else {
		$sql .= " AND P.idlocation='" .$security->getCurrentUserLocationId(). "' and (U.id_location<>27 and U.id_location<>1)";
		}
		$sql .= " AND C.CODE=A.CODE order by O.followupdate asc";
		//debug($sql);
		//die();
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
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
	
	public function getCustomerNotes($security, $username) {

		$sql = "Select O.Communication, O.Next, A.company, O.CODE, O.Response, A.CODE, A.tel, C.surname, C.title, C.first, A.EMAIL_ADDRESS, C.telwork, C.mobile, O.staff, O.notes, C.Contact_no from communication O, Contact C, Address A, savoir_user U WHERE O.CODE=C.CODE and O.staff=U.username and commstatus='To Do'";
		if ($security->getCurrentUserLocationId()==1 || $security->getCurrentUserLocationId()==27) {
		$sql .= " and O.staff='".$username."'";
		} else {
		$sql .= " AND C.idlocation='" .$security->getCurrentUserLocationId(). "' and (U.id_location<>27 and U.id_location<>1)";
		}
		$sql .= " AND C.CODE=A.CODE order by O.next asc";
		//debug($sql);
		//die();
		
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function changeNoteDate($ordernoteid,$notedate) {
	
		$customernotes = $this->find('all', ['conditions'=> ['ordernote_id' => $ordernoteid]]);
        foreach ($customernotes as $customernote) {
            $customernote['followupdate']=$this->convertDateToMysql($notedate);
            $this->save($customernote);
        }  
    }

	public function closeOrderNote($ordernoteid,$username) {
		$ordernotes = $this->find('all', ['conditions'=> ['ordernote_id' => $ordernoteid]]);
		$now = Time::now();
		$now = $now->i18nFormat('yyyy-MM-dd HH:mm:ss');;
        foreach ($ordernotes as $ordernote) {
            $ordernote['action']='Completed';
            $ordernote['NoteCompletedBy']=$username;
            $ordernote['NoteCompletedDate']=$now;
            $this->save($ordernote);
        }
 	}
  


}
?>