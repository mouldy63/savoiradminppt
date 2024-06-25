<?php

namespace App\Controller;
use App\Controller\EmailServicesController;
use \Cake\Mailer\Email;
use \SoapClient;

class OrderStatusController extends AppController {
	public $uses = false;
	public $autoRender = false;
	
    public function fixOrderStatuses() {
        $this->viewBuilder()->setLayout('ajax');
    	$this->loadModel('Comreg');
        $this->loadModel('QcHistory');
        $this->loadModel('QcHistoryLatest');
        
    	echo '<p>Fixing Order Status</p>';
    	$comregRow = $this->Comreg->find('all', array('conditions'=> array('name' => "ORDER_STATUS_LAST_FIX_DATE")));
        $comregRow = $comregRow->toArray();
    	if (count($comregRow) != 1) {
    		echo '<br/>ORDER_STATUS_LAST_FIX_DATE not set<br>';
    		die;
    	}
    	$lastFixDate = $comregRow[0]['VALUE'];
    	$comregId = $comregRow[0]['COMREG_ID'];
        echo '<br/>lastFixDate = ' . $lastFixDate.'<br>';
        
        $changedOrders = $this->_getChangedOrders($lastFixDate);
        foreach ($changedOrders as $pn) {
        	echo '<br>pn=' .$pn;
        	$this->_fixOrderStatus($pn);
        }
	    	
        $comreg = $this->Comreg->get($comregId);
        $comreg->VALUE = date('Y-m-d H:i:s');;
    	$this->Comreg->save($comreg);
    	
    	echo "<br/>Success";
    }
    
    private function _fixOrderStatus($pn) {
    	$query = $this->QcHistoryLatest->find();
    	$query->select(['minstatus' => $query->func()->min('qc_statusID')]);
		$query->where(['Purchase_No' => $pn])->where(['ComponentID != ' => 0])->where(['ComponentID != ' => 9]);
   		$minStatus = $query->first()['minstatus'];
   		$currentStatus = $this->_getCurrentOrderStatus($pn);
   		echo '<br>currentStatus=' . $currentStatus . ' minStatus=' . $minStatus;
   		if ($minStatus != $currentStatus) {
	 		$this->QcHistory->insertOrderStatusRow($pn, $minStatus);
   		}
    }
    
    private function _getCurrentOrderStatus($pn) {
    	$query = $this->QcHistoryLatest->find();
    	$query->select(['qc_statusID']);
		$query->where(['Purchase_No' => $pn])->where(['ComponentID' => 0]);
		return $query->first()['qc_statusID'];
    }
    
    private function _getChangedOrders($lastFixDate) {
    	$query = $this->QcHistory->find();
		$query->select(['Purchase_No'])->distinct(['Purchase_No']);
		$query->where(['QC_date >= ' => $lastFixDate])->where(['ComponentID != ' => 0])->where(['ComponentID != ' => 9]);
		$query->order(['Purchase_No' => 'ASC']);
		$orders = array();
		foreach ($query as $row) {
    		array_push($orders, $row['Purchase_No']);
		}
		return $orders;
    }
    
}
?>