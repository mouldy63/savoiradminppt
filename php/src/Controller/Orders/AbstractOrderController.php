<?php
namespace App\Controller\Orders;
use App\Controller\SecureAppController;
use Cake\ORM\TableRegistry;
use Cake\Event\EventInterface;
use \Exception;

class AbstractOrderController extends SecureAppController {
	
	private $pn = 0;
	protected $contactNo = 0;
	protected $isNewOrder;
	protected $orderDataModel;
	protected $componentModel;
	protected $componentFieldModel;
	protected $orderFormMiscDataModel;
	protected $purchaseModel;
	protected $compPriceDiscountModel;
	protected $productionSizesModel;
	protected $contactModel;
	protected $addressModel;
	protected $phoneNumberModel;
	protected $purchaseData;
	protected $contactData;
	
	public function initialize() : void {
        parent::initialize();
    	$this->orderDataModel = TableRegistry::get('OrderData');
    	$this->componentModel = TableRegistry::get('Component');
    	$this->componentFieldModel = TableRegistry::get('ComponentField');
    	$this->orderFormMiscDataModel = TableRegistry::get('OrderFormMiscData');
    	$this->purchaseModel = TableRegistry::get('Purchase');
    	$this->compPriceDiscountModel = TableRegistry::get('CompPriceDiscount');
    	$this->productionSizesModel = TableRegistry::get('ProductionSizes');
    	$this->contactModel = TableRegistry::get('Contact');
    	$this->addressModel = TableRegistry::get('Address');
    	$this->phoneNumberModel = TableRegistry::get('PhoneNumber');
	}
	
	public function beforeFilter(Event $event) {
    	parent::beforeFilter($event);
    	
    	if ($this->request->is('post')) {
    		// this is the form being submitted, so just leave
    		return;
		} 
		
    	if (isset($this->request->getQuery('pn'))) {
	    	$this->pn = $this->request->getQuery('pn');
	    	$this->isNewOrder = false;
	    	$this->purchaseData = $this->purchaseModel->find('all', ['conditions'=> ['PURCHASE_No' => $this->pn]])->toArray()[0];
	    	$this->contactNo = $this->purchaseData['contact_no'];
    	} else {
	    	$this->pn = 0;
	    	$this->isNewOrder = true;
	    	if (!isset($this->request->getQuery('contactno'))) {
	    		throw new Exception('contactno not set');
	    	}
    		$this->contactNo = $this->request->getQuery('contactno');
    	}
    	$this->contactData = $this->contactModel->find('all', ['conditions'=> ['CONTACT_NO' => $this->contactNo]])->toArray()[0];
	}

    public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	
    	$fieldOptionsModel = TableRegistry::get('FieldOpt');
    	$options = $fieldOptionsModel->getFieldOptions();
    	
    	$currencyCode = "GBP";
    	if (isset($this->request->getQuery('ordercurrency'))) {
    		$currencyCode = $this->request->getQuery('ordercurrency');
    	} else {
    		$compData = $this->orderDataModel->getOrderDataForComponent($this->getPn(), 0);
    		foreach ($compData as $compItem) {
    			if ($compItem['fieldname'] == 'order_currency') {
		    		if (isset($compItem['strvalue'])) {
			    		$currencyCode = $compItem['strvalue'];
			    	}
    				break;
    			}
    		}
    	}
    	
    	$componentData = $this->componentModel->getComponentData();
    	$vatRates = $this->orderFormMiscDataModel->getVatRates($this->contactData['idlocation']);
    	$leadTimes = $this->orderFormMiscDataModel->getLeadTimes();
    	
    	// the shipping addresses
    	$shipperAddresses = $this->orderFormMiscDataModel->getShipperAddresses($defShipAddressId);
    	$orderShippingAddress = $this->orderFormMiscDataModel->getOrderShippingAddress($this->getPn());
    	if (!empty($orderShippingAddress)) {
    		$name = $orderShippingAddress['shipperName'] . ', ' . $orderShippingAddress['TOWN'];
    		foreach ($shipperAddresses as $id => $tmpName) {
    			if ($tmpName == $name) {
    				$defShipAddressId = $id;
    			}
    		}
    	}
    	//die;
    	
    	$builder = $this->viewBuilder();
        $builder->setHelpers([
            'OrderForm' => ['options' => $options, 'currencyCode' => $currencyCode, 'componentData' => $componentData, 'shipperAddresses' => $shipperAddresses
        	, 'defShipAddressId' => $defShipAddressId, 'vatRates' => $vatRates, 'regionId' => $this->contactData['OWNING_REGION']]
        	,'OrderFormProduction' => ['leadTimes' => $leadTimes]
        ]);
    }
    
    protected function getPn() {
    	return $this->pn;
    }
    
    protected function setPn($pn) {
    	$this->pn = $pn;
    }
    
    protected function _getComponentName($compId) {
    	$component = $this->componentModel->get($compId);
    	return strtolower($component->componentname);
    }
    
    protected function _getOrderData($compId) {
    	$rs = $this->orderDataModel->getOrderDataForComponentAndChildren($this->getPn(), $compId);
    	
    	//debug($rs);
		//if ($compId == 3) {
			//debug($rs);
			//die;
		//}
    	$schema['id'] = ['type' => 'string'];
    	$fieldValues['id'] = $this->getPn() . '-' . $compId;
    	foreach ($rs as $row) {
    		$value = "<NOT SET>";
			if ($row['datatype'] == 'string') {
				$value = $row['strvalue'];
			} else if ($row['datatype'] == 'integer') {
				$value = $row['intvalue'];
			} else if ($row['datatype'] == 'double') {
				$value = $row['dblvalue'];
			} else if ($row['datatype'] == 'money') {
				$value = $row['dblvalue'];
			} else if ($row['datatype'] == 'datetime') {
				$value = $row['datetimevalue'];
			} else {
				throw new Exception("invalid field type " . $row['datatype']);
			}
			//echo '<br>' . $row['fieldname'] . ' is ' . gettype($value) . ' ' . $value;
			$schema[$row['fieldname']] = ['type' => $row['datatype']];
			$fieldValues[$row['fieldname']] = $value;
		}

		// apply mappings
		if ($compId == 99) {
			debug($fieldValues);
		}
		$fieldValues = $this->_applyMappings($compId, $fieldValues);
    	
		$data = [
			'schema' => $schema,
			'defaults' => $fieldValues
		];

		return $data;
	}
	
	protected function _applyMappings($compId, $fieldValues) {
		$rs = $this->componentFieldModel->find('all', ['conditions'=> ['from_order_data_mapping is not null', 'ComponentID' => $compId]]);
		if ($compId == 999) {
			debug($fieldValues);
		}
		
		foreach ($rs as $row) {
			$mapping = json_decode($row['from_order_data_mapping'], true);
			foreach ($mapping as $srcField => $mapData) {
				// should only be one
				if ($srcField == 'fixedvalue') {
					// just use the fixed value
					$fieldValues[$row['fieldname']] = $mapData;
				} else if (array_key_exists($srcField, $fieldValues)) {
					// get the value from the mapped field
					$srcVal = $fieldValues[$srcField];
					$starMapValue = null;
					foreach ($mapData as $key => $val) {
						if ($key == 'null' && is_null($srcVal)) {
							$value = $val;
						} else if (strval($srcVal) == $key) {
							$fieldValues[$row['fieldname']] = $val;
						}
						if ($key == '*') $starMapValue = $val;
					}
					if (!isset($fieldValues[$row['fieldname']]) && !empty($starMapValue)) {
						$fieldValues[$row['fieldname']] = $starMapValue;
					}
				}
			}
		}
		
		if ($compId == 999) {
			debug($fieldValues);
		}
		return $fieldValues;
	}
	
	protected function _getSafeFloatFromArray($arr, $key) {
		$floatVal = 0.0;
		if (!empty($arr[$key])) {
			$floatVal = floatval($arr[$key]);
		}
		return $floatVal;
	}

	protected function _isTopLevelComponent($compId) {
    	$component = $this->componentModel->get($compId);
    	return empty($component['ParentComponentId']);
    }
}