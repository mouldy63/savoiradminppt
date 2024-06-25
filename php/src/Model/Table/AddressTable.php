<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class AddressTable extends Table {
	private $months = array("January"=>"1", "February"=>"2", "March"=>"3", "April"=>"4", "May"=>"5", "June"=>"6", "July"=>"7", "August"=>"8", "September"=>"9", "October"=>"10", "November"=>"11", "December"=>"12");
	
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('address');
        $this->setPrimaryKey('CODE');
    }
    
    public function getSourceCounts($isSuperUser, $userRegion, $userSite, $monthfrom, $monthto, $strmonth, $stryear) {
    	$sql = "SELECT source, COUNT(*) as cnt FROM address where status like 'Prospect'";
		if (!empty($monthfrom) && !empty($monthto)) {
			$sql .= " and first_contact_date >= '" . $this->convertDateToMysql($monthfrom) . "' and first_contact_date <= '" . $this->convertDateToMysql($monthto) . "'";
		}
		if ($strmonth != "n") {
			$sql .= " AND month(first_contact_date) = " . $this->months[$strmonth] . " AND year(first_contact_date) = " . $stryear;
		}
		if (!$isSuperUser) {
			$sql .= " AND owning_region=" . $userRegion;
			$sql .= " AND source_site='" . $userSite . "'";
		}
		$sql .= " GROUP BY source";
		//debug($sql);
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getCurrentShowrooms() {
    	$sql = "SELECT * from location where retire='n' and active='y' order by adminheading asc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	public function getShowroomBrochureRequestCount($idLocation, $monthfrom, $monthto, $strmonth, $year) {
    	$sql = "SELECT count(distinct C.code) as cnt from communication C, Contact X where C.code=X.code and C.type like '%brochure request%' and X.idlocation='" . $idLocation . "'";
		if ($monthfrom != "n" && $monthfrom !="") {
			$sql .=  " and C.date >= '" . $this->convertDateToMysql($monthfrom) . "' and C.date <= '" . $this->convertDateToMysql($monthto) . "'";
		}
		if ($strmonth != "n") {
			$sql .= " AND month(C.date) = " . $this->months[$strmonth] . " AND year(C.date) = " . $year;
		}
		//debug($sql);
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc')[0]['cnt'];
    }
    
    public function getShowroomBrochuresSentCount($idLocation, $monthfrom, $monthto, $strmonth, $year) {
		$sql = "SELECT count(distinct C.code) as cnt from communication C, Contact X where X.BrochureRequestSent='y' and C.code=X.code and C.type like '%brochure request%' and X.idlocation='" . $idLocation . "'";
		if ($monthfrom != "n" && $monthfrom !="") {
			$sql .=  " and C.date >= '" . $this->convertDateToMysql($monthfrom) . "' and C.date <= '" . $this->convertDateToMysql($monthto) . "'";
		}
		if ($strmonth != "n") {
			$sql .= " AND month(C.date) = " . $this->months[$strmonth] . " AND year(C.date) = " . $year;
		}
		//debug($sql);
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc')[0]['cnt'];
    }
	
	public function getCustomersEmail($region, $idlocation, $email) {
    	$sql = "Select * from address A, contact C Where C.retire='n' AND A.CODE=C.CODE and A.EMAIL_ADDRESS like '".$email."'";
		if ($region != 1) {
			$sql .= " AND C.idlocation=" .$idlocation;
		}
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	private function convertDateToMysql($date) {
		if (empty($date) || strlen($date) == 0) {
			return '';
		}
		$myDateTime = DateTime::createFromFormat('d/m/Y', $date);
		$date = $myDateTime->format('Y-m-d');
		return $date;
	}
}
?>