<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class OrdersinproductionTable extends Table {
	private $months = array("January"=>"1", "February"=>"2", "March"=>"3", "April"=>"4", "May"=>"5", "June"=>"6", "July"=>"7", "August"=>"8", "September"=>"9", "October"=>"10", "November"=>"11", "December"=>"12");
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('PURCHASE_No');
        $this->hasOne('Contact')->setForeignKey('CONTACT_NO')->setJoinType('INNER')->setBindingKey('contact_no');
        $this->hasOne('Location')->setForeignKey('idlocation')->setJoinType('INNER')->setBindingKey('idlocation');
    }
	
	public function getOrdersInProduction($sortorder) {
		$sql = "Select * from address A, contact C, Purchase P, Location L Where (P.cancelled is null or P.cancelled <> 'y') AND C.retire='n' AND A.code=C.code AND C.contact_no=P.contact_no AND P.completedorders='n' AND P.orderConfirmationStatus='y' AND P.quote='n' AND P.idlocation=L.idlocation AND P.source_site='SB'"; 
		if ($sortorder !="") {
			$sql .= " order by " . $sortorder;
		} else {
		$sql .= " order by P.order_number asc";
		}
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
}
?>
