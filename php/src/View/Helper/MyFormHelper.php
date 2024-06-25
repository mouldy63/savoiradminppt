<?php
namespace App\View\Helper;
use Cake\View\Helper;

class MyFormHelper extends Helper {

	public function initialize(array $config) : void {
		//debug($config);
	}

	function setSelectedByKey($array, $keys, $optionVal) {
		if (!isset($array)) {
			return;
		}
		
		$selectedVal = $array;
		foreach ($keys as $key) {
			if (!isset($selectedVal[$key])) {
				return;
			}
			$selectedVal = $selectedVal[$key];
		}
		
		$isSelected = ($selectedVal == $optionVal);
		if ($isSelected) {
			echo 'selected';
		}
	}

	function setSelected($frmDefs, $fieldName, $defVal) {
		$isSelected = false;
		if (isset($frmDefs[$fieldName])) {
			if (is_array($frmDefs[$fieldName])) {
				foreach ($frmDefs[$fieldName] as $val) {
					if ($val == $defVal) {
						$isSelected = true;
						break;
					}
				}
			} else {
				if ($frmDefs[$fieldName] == $defVal) $isSelected = true;
			}
		}

		if ($isSelected) {
			echo 'selected';
		}
	}

	function setChecked($frmDefs, $fieldName, $defVal) {
		$isChecked = false;
		if (isset($frmDefs[$fieldName])) {
			if ($frmDefs[$fieldName] == $defVal) $isChecked = true;
		}
		if ($isChecked) {
			echo 'checked';
		}
	}

	function setValue($frmDefs, $fieldName) {
		$value = '';
		if (isset($frmDefs[$fieldName])) {
			$value = $frmDefs[$fieldName];
		}
		echo $value;
	}

	function fmtDate($frmDefs, $fieldName) {
		// takes date string formatted dd/mm/yyyy - returns date string formatted mm/dd/yyyy - US fmt is what the date picker needs
		$dateout = '';
		if (!empty($frmDefs[$fieldName])) {
			$date = date_parse_from_format("d/m/Y", $frmDefs[$fieldName]);
			$dateout = sprintf('%02d', $date['month']) . '/' . sprintf('%02d', $date['day']) . '/' . $date['year'];
		}
		return $dateout;
	}

	function fmtDateForDatePicker($val) {
		// takes date string formatted dd/mm/yyyy - returns date string formatted mm/dd/yyyy - US fmt is what the date picker needs
		$dateout = '';
		if (!empty($val)) {
			$date = date_parse_from_format("d/m/Y", $val);
			$dateout = sprintf('%02d', $date['month']) . '/' . sprintf('%02d', $date['day']) . '/' . $date['year'];
		}
		return $dateout;
	}
	
	function fmtDateForDatePicker2($val) {
	    // takes date string formatted yyyy-mm-dd hh:MM:ss- returns date string formatted dd/mm/yyyy
	    $dateout = '';
	    if (!empty($val)) {
	        $date = date_parse_from_format("Y-m-d H:i:s", $val);
	        $dateout = sprintf('%02d', $date['day']) . '/' . sprintf('%02d', $date['month']) . '/' . $date['year'];
	    }
	    return $dateout;
	}
	
	function mysqlToUsStrDate($mysqlDateStr) {
		// takes date string formatted yyyy-mm-dd - returns date string formatted mm/dd/yyyy
		$dateout = '';
		if (!empty($mysqlDateStr)) {
			$arr = explode('-', $mysqlDateStr);
			$dateout = sprintf('%02d', $arr[1]) . "/" . sprintf('%02d', $arr[2]) . "/" . sprintf('%04d', $arr[0]);
		}
		return $dateout;
	}

	function disableZeroCountFilterOption($fltCnts, $fieldName, $fieldValue) {
		$disabled = "disabled='disabled'";
		if (isset($fltCnts[$fieldName])) {
			$counts = $fltCnts[$fieldName];
			if (isset($counts[$fieldValue]) && $counts[$fieldValue] > 0) {
				$disabled = '';
			}
		}
		echo $disabled;
	}

	function isZeroCountFilterOption($fltCnts, $fieldName, $fieldValue) {
		$isZero = true;
		if (isset($fltCnts[$fieldName])) {
			$counts = $fltCnts[$fieldName];
			if (isset($counts[$fieldValue]) && $counts[$fieldValue] > 0) {
				$isZero = false;
			}
		}
		return $isZero;
	}

	function safeArrayGet($array, $keys, $default = "") {
		if (!isset($array)) {
			return $default;
		}
		
		$temp = $array;
		foreach ($keys as $key) {
			if (!isset($temp[$key])) {
				return $default;
			}
			$temp = $temp[$key];
		}
		return $temp;
	}
	
	function getDefaultValue($array, $fieldName, $default = "") {
		return $this->safeArrayGet($array, ['defaults',$fieldName], $default);
	}
	
	function getDefaultFormattedDoubleValue($array, $fieldName, $dp) {
		$val = $this->getDefaultValue($array, $fieldName, 0);
		return number_format($val, $dp, '.', '');
	}
	
	function getDefaultFormattedDateValue($array, $fieldName, $default = "") {
		$val = $this->safeArrayGet($array, ['defaults',$fieldName], $default);
		if (isset($val) && gettype($val) == 'object') {
			$val = $val->i18nFormat('dd/MM/yyyy');
		}
		return $val;
	}
	
	function getOptions($view, $fieldName, $data) {
		$options = $view->OrderForm->getOptions($fieldName);
		$defValue = $this->getDefaultValue($data, $fieldName);
		if (!empty($defValue) && !isset($options[$defValue])) {
			// Add in the missing option. This can happen if an option has been retired, and we're looking at an old order.
			$options[$defValue] = $defValue;
		}
		//debug($options);
		return $options;
	}

	function restrictOptions($view, $allOptions, $permittedLocations, $permittedRegions, $optionList) {
		$userLocation = $view->Security->retrieveUserLocation();
		$userRegion = $view->Security->retrieveUserRegion();
		$permit = false;
		$restrictedOptions = $allOptions;
		foreach ($permittedLocations as $location) {
			if ($userLocation == $location) {
				$permit = true;
				break;
			}
		}
		if (!$permit) {
			foreach ($permittedRegions as $region) {
				if ($userRegion == $region) {
					$permit = true;
					break;
				}
			}
		}
		if (!$permit) {
			foreach ($optionList as $opt) {
				unset($restrictedOptions[$opt]);
			}
		}
		return $restrictedOptions;
	}
	
	function formatMoney($val, $sep='') {
		if (empty($val)) $val = 0.0;
		return number_format($val, 2, '.', $sep);
	}

	function formatMoneyWithSymbol($val, $currencyCode) {
		$currencySymbol = "";
		if ($currencyCode == "GBP") {
			$currencySymbol = "&pound;";
		} else if ($currencyCode == "USD") {
			$currencySymbol = "&dollar;";
		} else if ($currencyCode == "EUR") {
			$currencySymbol = "&euro;";
		}
		
		$formattedVal = $this->formatMoney($val);
		return $currencySymbol . $formattedVal;
	}
}