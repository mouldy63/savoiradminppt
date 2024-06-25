<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class ContactListTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('contact');
        $this->setPrimaryKey('CONTACT_NO');      	
  
    }
		
    public function getContactReport($isSuperUser, $userRegion, $userSite, $userLocation, $monthfrom, $monthto, $month, $year, $status, $ny) {
		if ($monthfrom != '') {
			$DBmonthfrom = $this->convertDateToMysql($monthfrom);
			$DBmonthto = $this->convertDateToMysql($monthto);
		}
    	$sql = "SELECT C.alpha_name, e.location, C.title, C.first, C.surname, A.company, A.street1, A.street2, A.street3, A.town, A.county, A.postcode, A.country, A.tel, A.EMAIL_ADDRESS, A.STATUS, A.VISIT_DATE, A.source, A.CHANNEL, C.acceptemail, C.acceptpost, C.CONTACT_NO, A.FIRST_CONTACT_DATE from contact C, address A, location AS e where C.source_site='SB' AND c.code=a.code AND  C.idlocation=e.idlocation ";
		$sql .= " AND A.STATUS like '" .$status ."'";  
		if ($monthfrom != '') {
			$sql .= " and first_contact_date >= '".$DBmonthfrom."' and first_contact_date < '".$DBmonthto."'";
		}
		if ($month != 'n') {
			$sql .= " AND month(first_contact_date) = ".$month." AND year(first_contact_date) = ".$year."";
		}
		if (!$isSuperUser && $ny=='') {
			$sql .= " AND C.OWNING_REGION=" . $userRegion;
			$sql .= " AND C.idlocation='" . $userLocation . "'";
			$sql .= " AND C.SOURCE_SITE='" . $userSite . "'";
		}
		if ($ny=='y') {
			$sql .= " AND C.OWNING_REGION=4";
			$sql .= " AND (C.idlocation='34' OR C.idlocation='37' OR C.idlocation='8')";
			$sql .= " AND C.SOURCE_SITE='" . $userSite . "'";

		}
		$sql .= " order by surname";
		//debug($sql);
		//die;
    	
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
	private function convertDateToMysql($date) {
		$myDateTime = DateTime::createFromFormat('d/m/Y', $date);
		$date = $myDateTime->format('Y-m-d');
		return $date;
	}
	
	

}
?>
