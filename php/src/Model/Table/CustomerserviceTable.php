<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;


class CustomerserviceTable extends Table
{

    /**
     * Initialize method
     *
     * @param array $config The configuration for the Table.
     * @return void
     */
    public function initialize(array $config) : void {
        parent::initialize($config);

        $this->setTable('customerservice');
        $this->setDisplayField('CSID');
        $this->setPrimaryKey('CSID');
        $this->hasMany('CustomerServiceNotes', ['order'=>'dateadded desc'])->setForeignKey('csid')->setJoinType('LEFT')->setBindingKey('CSID');
        $this->belongsTo('Purchase')->setForeignKey('orderno')->setJoinType('LEFT')->setBindingKey('ORDER_NUMBER');
        $this->hasOne('ServiceCode')->setForeignKey('ServiceCodeID')->setJoinType('LEFT')->setBindingKey('ServiceCode');
        $this->hasMany('CustomerServiceUpload')->setForeignKey('csid')->setJoinType('LEFT')->setBindingKey('CSID');
        $this->belongsTo('SavoirUser')->setForeignKey('completedBy')->setJoinType('LEFT')->setBindingKey('user_id');
    }
    
    public function getOpenCases($security) {
		
		$sql = "Select * from customerservice C, Location L where csclosed='n' and C.IDLocation=L.idlocation";
		if ($security->getCurrentUserRegionId()==4){
			$sql .= " AND C.IDregion=" .$security->getCurrentUserRegionId();
		} else if ($security->isSuperuser() || $security->getCurrentUserLocationId()==1 || $security->getCurrentUserLocationId()==27) {
		} else {
			$sql .= " AND C.IDregion=" .$security->getCurrentUserRegionId()." AND C.IDlocation=" .$security->getCurrentUserLocationId();
		}
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getClosedCases($security, $regionid, $locationid, $datefrom, $dateto) {
		
		$sql = "select * from customerservice C";
		$sql .= " join Location L on C.IDLocation=L.idlocation";
		$sql .= " join Purchase P on C.OrderNo=P.ORDER_NUMBER";
		$sql .= " left join service_code sc on c.ServiceCode = sc.servicecodeID";
		$sql .= " where C.csclosed='y' and C.OrderNo != 0";
		if (!empty($datefrom)) {
			$sql .= " and dataentrydate >= '".$this->convertDateToMysql($datefrom)."'";
		}
		if (!empty($dateto)) {
			$sql .= " and datecaseclosed < DATE_ADD('" . $this->convertDateToMysql($dateto) . "', INTERVAL 1 DAY)";
		}
		if ($security->getCurrentUserRegionId()==4){
			$sql .= " AND C.IDregion=" .$security->getCurrentUserRegionId();
		} else if ($security->isSuperuser() || $security->getCurrentUserLocationId()==1 || $security->getCurrentUserLocationId()==27) {
		} else {
			$sql .= " AND C.IDregion=" .$security->getCurrentUserRegionId()." AND C.IDlocation=" .$security->getCurrentUserLocationId();
		}
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getResponseNotes($csid) {
		
		$sql = "select * from customerservicenotes where csid=".$csid;
		//debug($sql);
		//die;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

    public function generateNumber()
    {
        $lastData = $this->find('all', [
                    'conditions' => ['Customerservice.CSNumber LIKE' => date('ym-') . '%'],
                    'order' => ['Customerservice.CSNumber' => 'DESC']
                ])->first();
        $number = 1;
        //var_dump ($lastData->CSNumber);

        if ($lastData !== null) {
            $tmp = str_replace(date('ym-'), '', $lastData->CSNumber);
            $number = ($tmp + 1);
        }
        return date('ym-') . str_pad(strval($number), 3, '0', STR_PAD_LEFT);
    }
    
    private function convertDateToMysql($date) {
    	//debug($date);
		$myDateTime = DateTime::createFromFormat('d/m/Y', $date);
		$date = $myDateTime->format('Y-m-d');
		return $date;
	}

}
