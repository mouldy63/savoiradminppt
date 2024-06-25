<?php

namespace App\Controller\Component;


class ArrayHelperComponent extends \Cake\Controller\Component {
	
	public function getFloat($arr, $keys, $def=0.0) {
		$val = $this->getVal($arr, $keys);
		if ($val === null) {
			return $def;
		}
		return floatval($val);
	}

	public function getInt($arr, $keys, $def=0) {
		$val = $this->getVal($arr, $keys);
		if ($val === null) {
			return $def;
		}
		return intval($val);
	}

	public function getStr($arr, $keys, $def='') {
		$val = $this->getVal($arr, $keys);
		if ($val === null) {
			return $def;
		}
		return strval($val);
	}

	public function getVal($arr, $keys) {
		if ($arr === null || count($arr) == 0 || $keys === null || count($keys) == 0) {
			return null;
		}
		$var = $arr;
		foreach ($keys as $key) {
			if (!isset($var[$key])) {
				return null;
			}
			$var = $var[$key];
		}
		return $var;
	}

}

?>