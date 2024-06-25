<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Database\Connection;
use Cake\Datasource\ConnectionManager;

class OrderReportModelTable extends Table {
    
    private $myconn;
    private $getOrderQuerry;

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase');
        $this->setPrimaryKey('PURCHASE_No');
        
        $this->myconn = ConnectionManager::get('default');

        $this->getOrderQuerry="SELECT a.PURCHASE_No,a.ORDER_NUMBER,a.ORDER_DATE,a.totalexvat,a.ordercurrency,a.savoirmodel,".
                            "a.basesavoirmodel,a.toppertype,a.legstyle,a.headboardstyle, a.valancerequired, a.accessoriesrequired,a.customerreference,a.ordersource, ".
                            "b.surname, c.location FROM purchase AS a ".
                            "LEFT JOIN contact AS b ON a.contact_no=b.CONTACT_NO ".
                            "LEFT JOIN location AS c ON a.idlocation=c.idlocation ".
                            "WHERE a.PURCHASE_No=%d";
    }
    
    public function getOrderDetail($pId){
            $sql = sprintf($this->getOrderQuerry,(int)$pId);
            return $this->myconn->execute($sql)->fetchAll('assoc');
    }
}