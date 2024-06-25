<?php
namespace App\View\Helper;
use Cake\View\Helper;
use Cake\ORM\TableRegistry;

class OrderFuncsHelper extends Helper {
	
	private $auxiliaryDataModel;

	public function initialize(array $config) : void {
		$this->auxiliaryDataModel = TableRegistry::get('AuxiliaryData');
		$this->purchaseModel = TableRegistry::get('Purchase');
	}
	
	public function orderHasOverdueNote($pn) {
		$params = ['pn' => $pn, 'action' => 'To Do'];
		$sql = "select * from ordernote where purchase_no=:pn and followupdate is not null and followupdate < now() and action=:action";
		$rs = $this->auxiliaryDataModel->getData($sql, $params);
		return count($rs) > 0;
	}

	function getOrderComponentSummary($pn, $componentId) {
		return $this->purchaseModel->getOrderComponentSummary($pn, $componentId);
	}

}