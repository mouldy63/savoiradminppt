<?php
namespace App\Controller;
use Cake\ORM\TableRegistry;

class PackagingDataServicesController extends SecureAppController {
    
    public function initialize() : void {
        parent::initialize();
        $this->loadComponent('CommercialData');
        $this->loadModel('ProductionSizes');
        $this->loadModel('Purchase');
        $this->loadModel('Wrappingtypes');
    }    

    public function getProductWeight($pn, $compId, $itemNo) {
    	$this->autoRender = false;
    	
    	$wholesale = '';
    	$purchase = $this->Purchase->get($pn);
    	
    	$wrap = $this->Wrappingtypes->get($purchase['wrappingid']);
    	
		$query = $this->ProductionSizes->find()->where(['Purchase_No' => $pn]);
		$psizes = null;
		foreach ($query as $row) {
			$psizes = $row;
		}
		$mattzip='n';
		if (substr($purchase['mattresstype'], 0, 3)=='Zip') {
			$mattzip='y';
		}
		$basezip='n';
		if (substr($purchase['mattresstype'], 0, 3)=='Zip') {
			$mattzip='y';
		}
		
		$mattressinc = $purchase['mattressrequired'];
		$baseinc = $purchase['baserequired'];
		$topperinc = $purchase['topperrequired'];
		$valanceinc = $purchase['valancerequired'];
		$legsinc = $purchase['legsrequired'];
		$hbinc = $purchase['headboardrequired'];
		$accinc = $purchase['accessoriesrequired'];
		
		$exportData = $this->CommercialData->getExportData(null, $pn, $mattressinc, $baseinc, $topperinc, $valanceinc, $legsinc, $hbinc, $accinc, $purchase, $wrap['WrappingID'], $wholesale, $psizes);
    	$productWeight = 0.0;
    	if ($compId == 1) {
			//debug($exportData['matt1NW']);
			//debug($exportData['matt2NW']);
    		$productWeight = $exportData['matt1NW'];
    		if ($exportData['matt2NW'] > 0) {
        		$productWeight = $exportData['matt1NW'] + $exportData['matt2NW'];
    		}
    	} else if ($compId == 3) {
			if ($exportData['base2NW'] > 0) {
    			$productWeight = $exportData['baseNW'] + $exportData['base2NW'];
			} else {
				$productWeight = $exportData['baseNW'];
			}
    	} else if ($compId == 5) {
    		$productWeight = $exportData['topperNW'];
    	} else if ($compId == 6) {
    		$productWeight = $exportData['valanceweight'];
    	} else if ($compId == 7) {
    		$productWeight = $exportData['legsNW'];
    	} else if ($compId == 8) {
    		$productWeight = $exportData['hbNW'];
    	} else if ($compId == 9) {
    		$productWeight = 0.0;
    	}
    	
    	$this->response = $this->response->withStringBody($productWeight);
    }
    
    protected function _getAllowedRoles() {
    	return array("ADMINISTRATOR","SALES");
    }
}
?>