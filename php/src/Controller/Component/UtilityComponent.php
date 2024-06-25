<?php
namespace App\Controller\Component;

class UtilityComponent extends \Cake\Controller\Component {

	public function varDumpToString($obj) {
		ob_start();
		var_dump($obj);
		return ob_get_clean();
	}
	
	public static function makeMysqlDateString($year, $month, $day) {
		return sprintf('%02d', $year) . "-" . sprintf('%02d', $month) . "-" . sprintf('%02d', $day);
	}

	public static function makeMysqlDateStringFromDisplayString($displayString) {
		$arr = explode('/', $displayString);
		return sprintf('%02d', $arr[2]) . "-" . sprintf('%02d', $arr[1]) . "-" . sprintf('%02d', $arr[0]);
	}
	
	public static function mysqlToDisplayStrDate($mysqlDateStr) {
		$arr = explode('-', $mysqlDateStr);
		return sprintf('%02d', $arr[0]) . "/" . sprintf('%02d', $arr[1]) . "/" . sprintf('%02d', $arr[2]);
	}

	public static function mysqlToUsStrDate($mysqlDateStr) {
		$arr = explode('-', $mysqlDateStr);
		return sprintf('%02d', $arr[1]) . "/" . sprintf('%02d', $arr[2]) . "/" . sprintf('%04d', $arr[0]);
	}

	public static function mysqlToDisplayStrDate2($mysqlDateStr) {
		$arr = explode('-', $mysqlDateStr);
		return sprintf('%02d', $arr[2]) . "/" . sprintf('%02d', $arr[1]) . "/" . sprintf('%02d', $arr[0]);
	}
	
	public static function ukDateStrToUsFormat($dateStr) {
		$arr = explode('/', $dateStr);
		return sprintf('%02d', $arr[1]) . "/" . sprintf('%02d', $arr[0]) . "/" . sprintf('%04d', $arr[2]);
	}

	public static function formatMoney($val, $incThouSep = false) {
		if (empty($val)) $val = 0.0;
		$thouSep = '';
		if ($incThouSep) {
			$thouSep = ',';
		}
		return number_format($val, 2, '.', $thouSep);
	}

	public static function formatMoneyWithSymbol($val, $currencyCode) {
		$currencySymbol = $currencyCode;
		if ($currencyCode == "GBP") {
			$currencySymbol = "£";
		} else if ($currencyCode == "USD") {
			$currencySymbol = "$";
		} else if ($currencyCode == "EUR") {
			$currencySymbol = "€";
		}
		
		$formattedVal = UtilityComponent::formatMoney($val);
		return $currencySymbol . $formattedVal;
	}

	public static function formatMoneyWithHtmlSymbol($val, $currencyCode) {
		$currencySymbol = "";
		if ($currencyCode == "GBP") {
			$currencySymbol = "&pound;";
		} else if ($currencyCode == "USD") {
			$currencySymbol = "&#36;";
		} else if ($currencyCode == "EUR") {
			$currencySymbol = "&#8364;";
		}
		
		$formattedVal = UtilityComponent::formatMoney($val, true);
		return $currencySymbol . $formattedVal;
	}
	
	public static function formatcurrencyHtmlSymbol($currencyCode) {
		$currencySymbol = "";
		if ($currencyCode == "GBP") {
			$currencySymbol = "&pound;";
		} else if ($currencyCode == "USD") {
			$currencySymbol = "&#36;";
		} else if ($currencyCode == "EUR") {
			$currencySymbol = "&#8364;";
		}
		
		return $currencySymbol;
	}
	
	public static function strToInt($val, $def = null) {
		$intVal = null;
		if (isset($val)) {
			$intVal = intval($val);
		} else {
			$intVal = $def;
		}
		return $intVal;
	}

	public static function strToDbl($val, $def = null) {
		$dblVal = null;
		if (isset($val)) {
			$dblVal = doubleval($val);
		} else {
			$dblVal = $def;
		}
		return $dblVal;
	}
}
