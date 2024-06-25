<?php
namespace App\View\Helper;
use Cake\View\Helper;
use Cake\ORM\TableRegistry;

class AuxiliaryDataHelper extends Helper {
	
	private $auxiliaryDataModel;

	public function initialize(array $config) : void {
		$this->auxiliaryDataModel = TableRegistry::get('AuxiliaryData');
	}
	
	public function getData($sql, $params) {
		return $this->auxiliaryDataModel->getData($sql, $params);
	}

	public function getDataArray($sql, $params) {
		return $this->auxiliaryDataModel->getDataArray($sql, $params);
	}
}