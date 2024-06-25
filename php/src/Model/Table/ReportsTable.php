<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ReportsTable extends Table {
    private $myconn;
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('PURCHASE_No');
        $this->myconn = ConnectionManager::get('default');

        $this->mattressTurnReportSql
		= "select c.title,c.first,c.surname,l.location,a.email_address,a.company,p.deliveryadd1,p.deliveryadd2,p.deliveryadd3,p.deliverytown,p.deliverypostcode,p.order_number,p.bookeddeliverydate"
		. ",p.savoirmodel,p.mattresswidth,p.mattresslength"
		. ",p.basesavoirmodel,p.basewidth,p.baselength"
		. ",p.toppertype,p.topperwidth,p.topperlength"
		. ",p.headboardstyle,p.legstyle"
		. ",p.totalexvat"
		. " from purchase p, contact c, address a, location l"
		. " where p.contact_no=c.contact_no"
		. " and c.code=a.code"
		. " and p.idlocation=l.idlocation"
		. "	and (p.mattressrequired='y' or p.topperrequired='y')"
		. "	and p.giftpackrequired='y'"
		. "	and p.bookeddeliverydate is not null"
		. "	and p.bookeddeliverydate <> ''"
		. "	and month(p.bookeddeliverydate)=%d"
		. "	and year(p.bookeddeliverydate)=%d";
    }
	
	private $mattressTurnReportSql;
	
	public function getMattressTurnReportData($month, $year) {
		$sql = sprintf($this->mattressTurnReportSql, $month, $year);
                return $this->myconn->execute($sql)->fetchAll('assoc');
	}
}
?>