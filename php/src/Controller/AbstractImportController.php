<?php
namespace App\Controller;
use App\Controller\EmailServicesController;
use Cake\ORM\TableRegistry;
use Cake\Datasource\ConnectionManager;
use Cake\I18n\Time;
use \Exception;

abstract class AbstractImportController extends AppController {

	protected $path;

	public function initialize() : void {
        parent::initialize();
		$this->path = $_SERVER['DOCUMENT_ROOT'] . '/../without';
    	$this->loadModel('Comreg');
    	$this->loadModel('Address');
    	$this->loadModel('Contact');
    	$this->loadModel('Communication');
    	$this->loadModel('Location');
    	$this->loadModel('PriceList');
    	$this->loadModel('PostcodeLocation');
    	$this->loadModel('Purchase');
	}
	
	protected function _isEmptyRow($row) {
		foreach ($row as $field) {
			if (isset($field) && $field != '') {
				return false;
			}
		}
		return true;
	}

	protected function _parseFile($file) {
		$row = 1;
		$content = [];
		if (($handle = fopen($this->path . '/' . $file, "r")) !== FALSE) {
			while (($data = fgetcsv($handle, 0, ",")) !== FALSE) {
				//debug($data);
				if ($row > 1) {
					$num = count($this->_getHeader());
					$numThisRow = count($data);
					if ($numThisRow < $num) {
					    echo '<br>skipping incomplete row:';
					    debug($row);
					    continue;
					}
					$r = [];
					for ($c=0; $c < $num; $c++) {
						$r[$this->_getHeader()[$c]] = $data[$c];
					}
					array_push($content, $r);
				}
				$row++;
			}
			fclose($handle);
		}
		//debug($content);
		return $content;
	}

	protected function _getNewFiles($startswith) {
		$files = [];
		foreach (scandir($this->path) as $file) {
			if ($this->startsWith($file, $startswith) && $this->endsWith($file, '.csv')) {
				array_push($files, $file);
			}
		}
		return $files;
	}
	
	protected function _getDefaultShowroomForNumericPostcode($postcode, $country) {
    	$rs = $this->PostcodeLocation->find('all', array('conditions'=> array('lower(COUNTRY) like' => mb_strtolower($country, 'UTF-8'), 'POSTCODE_RANGE_START <=' => $postcode,'POSTCODE_RANGE_END >=' => $postcode)));
        $rs = $rs->toArray();
    	$idLocation = 0;
    	if (count($rs) > 0) {
	    	$idLocation = $rs[0]['LOCATIONID'];
    	}
    	echo '<br>_getDefaultShowroomForNumericPostcode: idLocation='.$idLocation;
    	return $idLocation;
    }
    
    protected function _getDefaultShowroomForCountryOnly($country) {
    	$rs = $this->PostcodeLocation->find('all', array('conditions'=> array('lower(COUNTRY) like' => strtolower($country))));
        $rs = $rs->toArray();
    	$idLocation = 0;
    	if (count($rs) > 0) {
	    	$idLocation = $rs[0]['LOCATIONID'];
    	}
    	echo '<br>_getDefaultShowroomForCountryOnly: idLocation='.$idLocation;
    	return $idLocation;
    }
    
    protected function _getRegionOfLocation($idLocation) {
    	$rs = $this->Location->find('all', array('conditions'=> array('idlocation' => $idLocation)));
        $rs = $rs->toArray();
    	$idRegion = $rs[0]['owning_region'];
    	return $idRegion;
    }

    protected function _getPriceListForLocation($idLocation) {
    	$rs = $this->PriceList->find('all', array('conditions'=> array('DEFAULT_FOR_LOC_IDS like' => '%,'.$idLocation.',%')));
    	$rs = $rs->toArray();
    	$priceList = "Retail";
    	if (count($rs) > 0) {
	    	$priceList = $rs[0]['PriceList'];
    	}
    	return $priceList;
	}
	
	protected function _getCurrentDateTimeStr() {
		$now = Time::now();
		return $now->i18nFormat('yyyy-MM-dd HH:mm:ss');;
	}
	
	protected function _getShowroomFromCountryAndPostcode($country, $postcode) {
		$idLocation = 0;
		if (is_numeric($postcode)) {
			$idLocation = $this->_getDefaultShowroomForNumericPostcode($this->_tweekPostcode($postcode, $country), $country);
		}
		if ($idLocation == 0) {
			$idLocation = $this->_getDefaultShowroomForCountryOnly($country);
		}
		if ($idLocation == 0) {
			$idLocation = 3; // default to Wigmore
		}
		return $idLocation;
	}

	protected function _getShowroomForCurrency($currencyCode) {
		$idLocation = null;
		if ($currencyCode == 'USD') {
			$idLocation = $this->_getShowroomFromName('US-Ecomm');
		} else if ($currencyCode == 'EUR') {
			$idLocation = $this->_getShowroomFromName('EUR-Ecomm');
		} else {
			$idLocation = $this->_getShowroomFromName('UK-Ecomm');
		}
		return $idLocation;
	}
	
	protected function _getShowroomFromName($showroomName) {
    	$rs = $this->Location->find('all', ['conditions'=> ['location' => $showroomName]]);
        $rs = $rs->toArray();
    	return $rs[0]['idlocation'];
    }
	
    protected function _getShowroomName($locationId) {
    	$rs = $this->Location->find('all', ['conditions'=> ['idlocation' => $locationId]]);
        $rs = $rs->toArray();
    	return $rs[0]['location'];
    }

    protected function _getLocationForWpKey($wp_key) {
    	$rs = $this->Location->find('all', ['conditions'=> ['new_wp_key like' => '%'.$wp_key.'%', 'retire' => 'n', 'active' => 'y'], 'order' => ['SavoirOwned' => 'desc']]);
    	$idLocation = 0;
    	foreach ($rs as $row) {
    		$idLocation = $row['idlocation'];
    		break;
    	}
    	return $idLocation;
    }
    
    protected function _containsStr($needle, $haystack) {
    	// problem with stripos is if needle is position 0 it returns 0, which is false in php, so I put a dummy char at position 0
    	return stripos('@'.$haystack, $needle) != false;
    }
    
    private function _tweekPostcode($postcode, $country) {
		$tweekedPostcode = $postcode;
		if (strtolower(trim($country)) == "russia") {
			$tweekedPostcode = substr($postcode, 0, 3);
		}
		return $tweekedPostcode;
	}
	
	protected function _getComregVal($name) {
		$comregRow = $this->Comreg->find('all', array('conditions'=> array('name' => $name)));
    	$comregRow = $comregRow->toArray();
		return $comregRow[0]['VALUE'];
	}
	
	protected function _saveComregVal($name, $val) {
		$rs = $this->Comreg->find('all', array('conditions'=> array('name' => $name)));
		foreach ($rs as $row) {
			$row['VALUE'] = $val;
			$this->Comreg->save($row);
		}
	}

	protected function getStringFromArray($key, $arr) {
		if (array_key_exists($key, $arr) && !empty($arr[$key])) {
			$val = $arr[$key];
		} else {
			$val = '';
		}
		return $val;
	}
	
	protected function getDateFromArray($key, $arr) {
		if (array_key_exists($key, $arr) && !empty($arr[$key])) {
			$val = $arr[$key];
		} else {
			$now = Time::now();
			$val = $now->i18nFormat('yyyy-MM-dd');;
		}
		return $val;
	}
	
	protected abstract function _getHeader();
	
}
?>