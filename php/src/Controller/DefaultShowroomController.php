<?php
namespace App\Controller;

class DefaultShowroomController extends SecureAppController {
    public $uses = false;
    public $autoRender = false;
    
    public function initialize() : void {
        parent::initialize();
        $this->loadComponent('Paginator');
    }
    
    public function getDefaultShowroom() {
        $this->viewBuilder()->setLayout('ajax');
    	$this->loadModel('PostcodeLocation');
    	$this->loadModel('Location');

    	$http_origin = '';
    	if (isset($_SERVER['HTTP_ORIGIN'])) {
    	$http_origin = $_SERVER['HTTP_ORIGIN'];
		}

		if ($http_origin == "http://www.savoirbeds.co.uk" 
			|| $http_origin == "http://www.savoirbeds.fr" 
			|| $http_origin == "http://www.savoirbeds.ru"
			|| $http_origin == "http://www.savoirbeds.de"
			|| $http_origin == "http://www.savoirbeds.tw"
			|| $http_origin == "http://www.savoirbeds.hk"
			|| $http_origin == "http://www.savoirbeds.cn"
			|| $http_origin == "http://www.savoirbeds.kr"
			|| $http_origin == "http://www.savoirbeds.com"
			) {  
    		$this->response->header('Access-Control-Allow-Origin', $http_origin);
		}
    	
    	$postcode = $_REQUEST['postcode'];
    	$country = $_REQUEST['country'];
    	
    	$idLocation = 0;
    	if (is_numeric($postcode)) {
    		$idLocation = $this->_getDefaultShowroomForNumericPostcode($postcode, $country);
    	}
    	if ($idLocation == 0) {
    		$idLocation = $this->_getDefaultShowroomForCountryOnly($country);
    	}
    	if ($idLocation == 0) {
    		$idLocation = 3; // default to Wigmore
    	}
    	
    	$showroom = "";
    	if ($idLocation != 0) {
    		$showroom = $this->_getShowroomForId($idLocation);
    	}
    	
    	$this->response = $this->response->withStringBody($showroom);
    }
    
    private function _getDefaultShowroomForNumericPostcode($postcode, $country) {
    	$rs = $this->PostcodeLocation->find('all', array('conditions'=> array('lower(COUNTRY) like' => strtolower($country), 'POSTCODE_RANGE_START <=' => $postcode,'POSTCODE_RANGE_END >=' => $postcode)));
    	$idLocation = 0;
        $data = $rs->toArray();
    	if (count($data) > 0) {
	    	$idLocation = $data[0]['LOCATIONID'];
    	}
    	return $idLocation;
    }
    
    private function _getDefaultShowroomForCountryOnly($country) {
    	$rs = $this->PostcodeLocation->find('all', array('conditions'=> array('lower(COUNTRY) like' => strtolower($country))));
    	$idLocation = 0;
        $data = $rs->toArray();
    	if (count($data) > 0) {
	    	$idLocation = $data[0]['LOCATIONID'];
    	}
    	return $idLocation;
    }
    
    private function _getShowroomForId($idLocation) {
    	$rs = $this->Location->find('all', array('conditions'=> array('IDLOCATION' => $idLocation)));
        $data = $rs->toArray();
	return $data[0]['location'];
    }
    
    protected function _getAllowedRoles() {
    	return array("ADMINISTRATOR");
    }
}
?>