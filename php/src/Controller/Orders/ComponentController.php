<?php
namespace App\Controller\Orders;
use App\Controller\SecureAppController;
use Cake\ORM\TableRegistry;

class ComponentController extends AbstractOrderController {
	
	private $priceMatrixModel;
	
	public function initialize() : void {
        parent::initialize();
	}
	
    public function index() {
    	$this->viewBuilder()->setLayout('ajax');
    	$compId = $this->request->getQuery('compId');
    	$compName = $this->_getComponentName($compId);
    	$isTopLevelComp = $this->_isTopLevelComponent($compId);
    	$this->viewBuilder()->template($compName);
    	
    	$data = $this->_getOrderData($compId);
    	
		$this->set('pn', $this->getPn());
		$this->set('compId', $compId);
		$this->set('compName', $compName);
		$this->set('isTopLevelComp', $isTopLevelComp);
		$this->set('data', $data);
		
    	// set the list of child select controls, with their parents
    	$this->set('defaultableSelectControlList', $this->componentFieldModel->getRelatedSelectControlList($compId, 'DEF'));

    	// set the list of child select controls, with their parents
    	$this->set('dependentSelectControlList', $this->componentFieldModel->getRelatedSelectControlList($compId, 'DEP'));
    }
    
    public function save() {
    	$this->autoRender = false;
    	debug($this->request->getData());
    }
    
    private function _getPriceAffectingFieldList($compId, $priceTableFields) {
    	
    	$data = $this->componentFieldModel->getPriceAffectingFieldList($compId, $priceTableFields);
    	//debug($data);
    	$fieldList = [];
    	foreach ($data as $row) {
    		$fieldname = $row['fieldname'];
    		if ($row['fieldtype'] == 'radio') {
    			$compName = $row['componentname'];
    			$radioIdData = explode(',', $row['extradata']);
    			$fieldList[$fieldname] = [];
    			foreach ($radioIdData as $radioId) {
    				array_push($fieldList[$fieldname], $compName . '_' . $radioId);
    			}
    		} else {
    			$fieldList[$fieldname] = '';
    		}
    	}
    	return $fieldList;
    }
    
    public function getDropdownData() {
    	$this->viewBuilder()->setLayout('ajax');
    	$this->autoRender = false;
        $fieldOptionsModel = TableRegistry::get('FieldOpt');
    	$fieldOptRelModel = TableRegistry::get('FieldOptRel');
    	
    	$formData = $this->request->getQuery('formdata');
    	//debug($formData);
    	$observed = $this->request->getQuery('observed');
    	$observedValue = $this->request->getQuery('observedValue');
    	$observer = $this->request->getQuery('observer');
    	$observerValue = $this->request->getQuery('observerValue');
    	$defaultSelection = $observerValue;
    	$dropdownData = [];
    	    	
    	// get the new values
    	$query = $fieldOptionsModel->find();
        $query = $query->where(['fieldname' => $observer]);
        $query->order(['seq' => 'ASC']);
        foreach ($query as $row) {
    		$dropdownData[$row['optkey']] = $row['optval'];
        }
    	
        // now check FieldOptRel for dependent values, and remove any not allowed (if there are any dependencies)
    	$query = $fieldOptRelModel->find();
        $query = $query->where(['fieldname_parent =' => $observed, 'optkey_parent =' => $observedValue, 'fieldname_child =' => $observer, 'reltype =' => 'DEP']);
        $filterData = [];
        foreach ($query as $row) {
        	array_push($filterData, $row['optkey_child']);
        }
        
        // apply filter if not empty 
        if (sizeof($filterData) > 0) {
	    	$filteredDropdownData = [];
	        foreach($dropdownData as $key => $text) {
	        	foreach($filterData as $n => $filter) {
	        		if ($key == $filter) {
	        			$filteredDropdownData[$key] = $text;
	        			break;
	        		}
	        	}
	        }
        	$dropdownData = $filteredDropdownData;
        }
        
    	// get the default (default from FIELDOPTREL takes precedence of current value in observer dropdown)
    	$query = $fieldOptRelModel->find();
        $query = $query->where(['fieldname_parent =' => $observed, 'optkey_parent =' => $observedValue, 'fieldname_child =' => $observer, 'reltype =' => 'DEF']);
        $row = $query->first();
        if (isset($row)) {
        	$defaultSelection = $row['optkey_child'];
        }
        
        // make sure the default selection exists in the values to be returned
        if (!empty($defaultSelection) && !array_key_exists($defaultSelection, $dropdownData)) {
        	$defaultSelection = "";
        }
    	
        // add the default to the values
        if (!empty($defaultSelection)) {
        	$dropdownData['SELECTED'] = $defaultSelection;
        }
        
    	// return the data
    	$this->response = $this->response->withStringBody(json_encode($dropdownData));
    }
    
    public function pricingTable() {
    	$this->viewBuilder()->setLayout('ajax');
    	$pn = $this->request->getQuery('pn');
    	$compId = $this->request->getQuery('compId');
    	$compName = $this->_getComponentName($compId);
    	$changedFieldName = "";
    	if (isset($this->request->getQuery('changedFieldName'))) {
    		$changedFieldName = $this->request->getQuery('changedFieldName');
    	}
    	
    	$data = $this->_getOrderData($compId);
    	$initialload = false;
    	
    	if (empty($changedFieldName)) {
    		// this means we were called from initial component tab load, so we use the data from the orderdata table untouched
    		$initialload = true;
    		// get map of the appilicable components/subcomponents, and their names (any subcomps will be excluded if they are not required)
	    	$compList = $this->_getApplicableComponents($compId, $data['defaults']);
    	} else {
    		// this means we were called due to a price field change, so we get the price from the price matrix
    		$formdata = json_decode($this->request->getQuery('formdata'), true);

    		// get map of the appilicable components/subcomponents, and their names (any subcomps will be excluded if they are not required)
	    	$compList = $this->_getApplicableComponents($compId, $formdata);
    		
	    	$orderCurrency = $this->request->getQuery('ordercurrency');
	    	$vatRate = $this->request->getQuery('vatrate');
	    	$isTrade = $this->request->getQuery('istrade');
	    	
	    	$componentData = $this->componentModel->getComponentData();

	    	foreach ($compList as $tempCompId => $tempCompName) {
	    		$pricingType = $componentData[$tempCompId]['pricingType'];
	    		if ($pricingType == 'matrix') {
	    			$formdata = $this->_applyPriceMatrix($tempCompId, $tempCompName, $changedFieldName, $formdata, $orderCurrency, $vatRate, $isTrade);
	    		} else if ($pricingType == 'calculate') {
	    			$formdata = $this->_applyPriceCalculation($tempCompId, $tempCompName, $changedFieldName, $formdata, $componentData[$tempCompId]['pricingData']);
	    		}
	    	}
    		
    		// merge form data back into data
    		foreach ($formdata as $fieldname => $fieldValue) {
    			$data['defaults'][$fieldname] = $fieldValue;
    		}
    	}
    	
		$this->set('pn', $pn);
		$this->set('compId', $compId);
		$this->set('compName', $compName);
		$this->set('compList', $compList);
		$this->set('data', $data);
    	$this->set('initialload', $initialload);

    	// Set the list of fields that affect the component price.
    	// 2 lists - 1 for those in the pricing table, and 1 for the rest. That's because when the pricing table reloads, we need to re-register
    	// for change events, but only the pricing table fields, as the rest will still be registered.
    	$pricingTablePriceAffectingFieldList = $this->_getPriceAffectingFieldList($compId, 'y');
    	$this->set('pricingTablePriceAffectingFieldList', $pricingTablePriceAffectingFieldList);
    	$otherPriceAffectingFieldList = $this->_getPriceAffectingFieldList($compId, 'n');
    	//debug($otherPriceAffectingFieldList);
    	$this->set('otherPriceAffectingFieldList', $otherPriceAffectingFieldList);
    }
    
    public function fieldUpdate() {
    	$this->viewBuilder()->setLayout('ajax');
    	$pn = $this->request->getQuery('pn');
    	$compId = $this->request->getQuery('compId');
    	$fieldname = $this->request->getQuery('fieldname');
    	$fieldvalue = $this->request->getQuery('fieldvalue');
    	
    	$rs = $this->orderDataModel->find('all', ['conditions'=> ['PURCHASE_No' => $pn, 'ComponentID' => $compId, 'fieldname' => $fieldname]]);
    	foreach ($rs as $row) {
			if ($row['fieldtype'] == 'string') {
				$row['strvalue'] = $fieldvalue;
			} else if ($row['fieldtype'] == 'integer') {
				$row['intvalue'] = $fieldvalue;
			} else if ($row['fieldtype'] == 'double') {
				$row['dblvalue'] = $fieldvalue;
			}
    		$this->orderDataModel->save($row);
    	}
    	$this->redirect(['action' => 'index', '?' => ['pn' => $pn, 'compId' => $compId]]);
    }
    
	private function _applyPriceMatrix($compId, $compName, $changedFieldName, $formdata, $currency, $vatRate, $isTrade) {
    	
		if ($this->_isFree($compId, $compName, $formdata)) {
			// this component is free, so no need to look it up in the price matrix
			$formdata[$compName . '_listprice'] = -1.0;
			$formdata[$compName . '_price'] = 0.0;
			$formdata[$compName . '_discount'] = 0.0;
			$formdata[$compName . '_discounttype'] = 'percent';
			return $formdata;
		}
		
		$priceMatrixMappingModel = TableRegistry::get('PriceMatrixMapping');
		$mappingData = $priceMatrixMappingModel->getMappingData($compId);
		//debug($mappingData);
		
		$prices = $this->_getMatrixPrices($mappingData, $compId, $formdata, $currency);
		if (isset($prices['listPrice']) && $prices['listPrice'] == -1) {
			// no row found
			if (isset($mappingData['compIdSet1']) || isset($mappingData['compIdSet2'])) {
				// no price found for the set, so try with just the component
				$mappingData['compIdSet1'] = null;
				$mappingData['compIdSet2'] = null;
				$prices = $this->_getMatrixPrices($mappingData, $compId, $formdata, $currency);
				
				if (isset($prices['listPrice']) && $prices['listPrice'] == -1) {
					if (isset($mappingData['dim1']) || isset($mappingData['dim2'])  || isset($mappingData['dim3'])) {
						// no price found for the set, or with the dimensions, so try without the dimensions
						$mappingData['dim1'] = null;
						$mappingData['dim2'] = null;
						$mappingData['dim3'] = null;
						$prices = $this->_getMatrixPrices($mappingData, $compId, $formdata, $currency);
					}
				}
			} else {
				// no compIdSets, so try with just dim1
				$mappingData['dim2'] = null;
				$mappingData['dim3'] = null;
				$prices = $this->_getMatrixPrices($mappingData, $compId, $formdata, $currency);
				if (isset($prices['listPrice']) && $prices['listPrice'] == -1 && isset($mappingData['dim1'])) {
					// still nothing, so try with no dims at all
					$mappingData['dim1'] = null;
					$prices = $this->_getMatrixPrices($mappingData, $compId, $formdata, $currency);
				}
			}
		}
		//debug($prices);
		
		// apply factors
		if (isset($prices['listPrice']) && $prices['listPrice'] != -1) {
			$listPrice = $prices['listPrice'];
			$multiplier = 1.0;
			if (!empty($mappingData['multiplier'])) {
				$multiplier = (double) $formdata[$mappingData['multiplier']];
			}
			$listPrice = $listPrice * $multiplier;
			
			if ($isTrade == 'y' && $currency != 'USD') { // prices in price matrix table for USD are VAT excl
				$listPrice = $listPrice / (1.0 + $vatRate/100.0);
			}
			
			$price = $this->_getSafeFloatFromArray($formdata, $compName . '_price');
			$discount = $this->_getSafeFloatFromArray($formdata, $compName . '_discount');
			if (!empty($formdata[$compName . '_discounttype'])) {
				$isPercent = ($formdata[$compName . '_discounttype'] == 'percent');
			} else {
				$isPercent = true;
			}
			$calcDiscount = ($changedFieldName == $compName . '_price'); // if the price was edited, we recalc the discount, otherwise we calc the price from the discount
			
			if ($calcDiscount) {
				// calc the discount from the price & list price				
				if ($isPercent) {
					if ($listPrice > 0.0) {
						$discount = 100.0 * (1.0 - $price/$listPrice);
					} else {
						$discount = 0.0;
					}
				} else {
					$discount = $listPrice - $price;
				}
			} else {
				// calc the price from the discount & list price				
				if ($isPercent) {
					$price = $listPrice * (1.0 - $discount / 100.0);
				} else {
					$price = $listPrice - $discount;
				}
			}
			
			$formdata[$compName . '_listprice'] = round($listPrice, 2);
			$formdata[$compName . '_price'] = round($price, 2);
			$formdata[$compName . '_discount'] = round($discount, 2);
			$formdata[$compName . '_discounttype'] = ($isPercent) ? 'percent' : 'currency'; // just in case it wasn't set on the form
		} else {
			// no list price found, so hide list price and discount fields, and leave the price as what ever it was
			$formdata[$compName . '_listprice'] = -1.0;
			$formdata[$compName . '_discount'] = 0.0;
			$formdata[$compName . '_discounttype'] = 'percent';
		}
		//debug($price);
		//die;
		return $formdata;
	}
    
	private function _getMatrixPrices($mappingData, $compId, $formdata, $currency) {
		if (substr($mappingData['type'], 0, 1) == "#") {
			$priceTypeName = substr($mappingData['type'], 1, strlen($mappingData['type'])-1);
		} else {
			$priceTypeName = $formdata[$mappingData['type']];
		}

		$dim1 = null;
		if (isset($mappingData['dim1'])) {
			if (isset($formdata[$mappingData['dim1']])) {
				$dim1 = $formdata[$mappingData['dim1']];
			}
		}
		
		$dim2 = null;
		if (isset($mappingData['dim2'])) {
			if (isset($formdata[$mappingData['dim2']])) {
				$dim2 = $formdata[$mappingData['dim2']];
			}
		}
				
		$dim3 = null;
		if (isset($mappingData['dim3'])) {
			if (isset($formdata[$mappingData['dim3']])) {
				$dim3 = $formdata[$mappingData['dim3']];
			}
		}
				
		$compIdSet1 = null;
		if (isset($mappingData['compIdSet1'])) {
			$compIdSet1 = $mappingData['compIdSet1'];
		}
		
		$compIdSet2 = null;
		if (isset($mappingData['compIdSet2'])) {
			$compIdSet1 = $mappingData['compIdSet2'];
		}
		//echo '<br>$priceTypeName='.$priceTypeName.' dim1='.$dim1.' dim2='.$dim2.' dim3='.$dim3.' compIdSet1='.$compIdSet1.' compIdSet2='.$compIdSet2;
		
		$priceMatrixModel = TableRegistry::get('PriceMatrix');
		$prices = $priceMatrixModel->getMatrixPrice($compId, $priceTypeName, $dim1, $dim2, $dim3, $currency, $compIdSet1, $compIdSet2);
		//debug($prices);
		return $prices;
	}
	
	private function _getApplicableComponents($compId, $formdata) {
    	$componentList = $this->componentModel->getComponentWithChildren($compId);
    	
    	// filter our the subcomps that are not required
    	foreach ($componentList as $id => $name) {
    		if ($id == $compId) {
    			// the parent is always required, else we wouldn't be here
    			continue;
    		}
    		$includeThisSubcomp = false;
    		$requiredFieldName = $name . 'req';
    		if (isset($formdata[$requiredFieldName]) && $formdata[$requiredFieldName] != 'n') {
    			$includeThisSubcomp = true;
    		}
    		if (!$includeThisSubcomp) {
    			unset($componentList[$id]);
    		}
    	}
    	return $componentList;
    }
    
    /**
     * Calculate the component price for sub components where the price is dependent on fields in the form - such as base fabric price.
     * Price does not come from the price matrix.
     */
    private function _applyPriceCalculation($compId, $compName, $changedFieldName, $formdata, $pricingData) {
    	// calc sudo list price
    	$pricingDataFields = explode(",", $pricingData);
    	$listPrice = 0.0;
    	if (!empty($formdata[$pricingDataFields[0]]) && !empty($formdata[$pricingDataFields[1]])) {
    		$listPrice = floatval($formdata[$pricingDataFields[0]]) * floatval($formdata[$pricingDataFields[1]]);
    	}

    	$price = $this->_getSafeFloatFromArray($formdata, $compName . '_price');
		$discount = $this->_getSafeFloatFromArray($formdata, $compName . '_discount');
		if (!empty($formdata[$compName . '_discounttype'])) {
			$isPercent = ($formdata[$compName . '_discounttype'] == 'percent');
		} else {
			$isPercent = true;
		}
		$calcDiscount = ($changedFieldName == $compName . '_price'); // if the price was edited, we recalc the discount, otherwise we calc the price from the discount
		
		if ($calcDiscount) {
			// calc the discount from the price & list price				
			if ($isPercent) {
				if ($listPrice > 0.0) {
					$discount = 100.0 * (1.0 - $price/$listPrice);
				} else {
					$discount = 0.0;
				}
			} else {
				$discount = $listPrice - $price;
			}
		} else {
			// calc the price from the discount & list price				
			if ($isPercent) {
				$price = $listPrice * (1.0 - $discount / 100.0);
			} else {
				$price = $listPrice - $discount;
			}
		}
		
		$formdata[$compName . '_listprice'] = round($listPrice, 2);
		$formdata[$compName . '_price'] = round($price, 2);
		$formdata[$compName . '_discount'] = round($discount, 2);
		$formdata[$compName . '_discounttype'] = ($isPercent) ? 'percent' : 'currency'; // just in case it wasn't set on the form
		
		return $formdata;
    }

    /**
     * Some components are free when combined with other components/options.
     */
    private function _isFree($compId, $compName, $formdata) {
    	// this is horrible, but at least it's all in one place
    	$isFree = false;
    	
    	if ($compId == 7 && $formdata['order_basereq'] == 'y') {
    		//debug($formdata);
    		$legsStyle = isset($formdata['legs_style']) ? $formdata['legs_style'] : '';
    		$legsFinish = isset($formdata['legs_finish']) ? $formdata['legs_finish'] : '';
    		if ($legsStyle == 'Castors' || $legsStyle == 'Metal') {
    			$isFree = true;
   			} else if ($legsStyle == 'Wooden Tapered' && $legsFinish != 'Natural Maple') {
    			$isFree = true;
   			}
    		//debug($isFree);
    	}
    	
    	return $isFree;
    }
    
}