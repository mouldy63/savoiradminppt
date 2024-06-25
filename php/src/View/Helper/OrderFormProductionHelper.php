<?php
namespace App\View\Helper;
use Cake\View\Helper;
use \Datetime;
use \App\Controller\Component\UtilityComponent;

class OrderFormProductionHelper extends Helper {

	public function initialize(array $config) : void {
		//debug($config);
	}

	public function makeApproxDateOptions($default) {

		//echo '<br>default = ' . $default;
		$ORDER_DATE_SELECT_COUNT = 36;
		$defaultFound = false;
		$defDay = 0;
		$defMonth = 0;
		$defYear = 0;
		if (!empty($default)) {
			// date format is yyyy-mm-dd
			$tempArr = explode("-", $default);
			$defDay = $tempArr[2];
			$defMonth = $tempArr[1];
			$defYear = $tempArr[0];
			$this->roundApproxDate($defDay, $defMonth, $defYear);
			// rewrite in mysql format, in case it wasn't in the first place
			$default = UtilityComponent::makeMysqlDateString($defYear, $defMonth, $defDay);
		}
		//echo '<br>defDay = ' . $defDay;
		//echo '<br>defMonth = ' . $defMonth;
		//echo '<br>defYear = ' . $defYear;
		
		$day = date("d");
		$month = date("m");
		$year = date("Y");
		//echo '<br>day = ' . $day;
		//echo '<br>month = ' . $month;
		//echo '<br>year = ' . $year;
		
		$this->roundApproxDate($day, $month, $year);
		//echo '<br>day = ' . $day;
		//echo '<br>month = ' . $month;
		//echo '<br>year = ' . $year;
		
		$values[UtilityComponent::makeMysqlDateString($year, $month, $day)]	= $this->getApproxDateDescription($day, $month, $year);
		if ($day == $defDay && $month == $defMonth && $year == $defYear) {
			$defaultFound = true;
		}

		for ($ai = 1; $ai < $ORDER_DATE_SELECT_COUNT; $ai++) {
			if ($day == 5) {
				$day = 15;
			} else if ($day == 15) {
				$day = 25;
			} else {
				$day = 5;
				if ($month < 12) {
					$month = $month + 1;
				} else {
					$month = 1;
					$year = $year + 1;
				}
			}

			$values[UtilityComponent::makeMysqlDateString($year, $month, $day)]	= $this->getApproxDateDescription($day, $month, $year);
			if ($day == $defDay && $month == $defMonth && $year == $defYear) {
				$defaultFound = true;
			}
		}


		if (!empty($default) && !$defaultFound) {
			$values[$default] = $this->getApproxDateDescription($defDay, $defMonth, $defYear);
		}
		
		//debug($values);
		return ['vals' => $values, 'def' => $default];
	}

	private function roundApproxDate(&$day, &$month, &$year) {

		if ($day <= 5) {
			$day = 5;
		} else if ($day <= 15) {
			$day = 15;
		} else if ($day <= 25) {
			$day = 25;
		} else {
			$day = 5;
			if ($month < 12) {
				$month = $month + 1;
			} else {
				$month = 1;
				$year = $year + 1;
			}
		}
	}

	private function getApproxDateDescription($day, $month, $year) {
		if ($day == 5) {
			$getApproxDateDescription = "Beginning";
		} else if ($day == 15) {
			$getApproxDateDescription = "Middle";
		} else {
			$getApproxDateDescription = "End";
		}
		$dt = DateTime::createFromFormat('!m', $month);
		$monthName = $dt->format('F');
		$getApproxDateDescription = $getApproxDateDescription . " " . $monthName . " " . $year;
		return $getApproxDateDescription;
	}
	
	public function getLeadTimes() {
		return $this->getConfig()['leadTimes'];
	}
}
