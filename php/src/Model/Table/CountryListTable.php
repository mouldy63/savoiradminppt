<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class CountryListTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('countrylist');
        $this->setPrimaryKey('countryid');
    }
    
    public function mapToMailchimp($country) {
    	$rs = $this->find('all', ['conditions'=> ['country' => $country]]);
    	$mcCode = null;
    	foreach ($rs as $row) {
    		$mcCode = $row['mailchimp_code'];
    	}
    	return $mcCode;
    }
    
    public function mapFromMailchimp($mcCode) {
    	$rs = $this->find('all', ['conditions'=> ['mailchimp_code' => $mcCode]]);
    	$country = null;
    	foreach ($rs as $row) {
    		$country = $row['country'];
    	}
    	return $country;
    }
	
	public function getCountryList() {
    	$sql = "Select * from countrylist order by country asc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
	
}
?>
