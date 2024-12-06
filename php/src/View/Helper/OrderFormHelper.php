<?php
namespace App\View\Helper;
use Cake\View\Helper;
use Cake\ORM\TableRegistry;

class OrderFormHelper extends Helper {

	private $myConfig = null;
	public function initialize(array $config) : void {
		$this->myConfig = $config;
	}

	public function getOptions($fieldname) {
		return $this->myConfig['options'][$fieldname];
	}

	public function getCurrencySymbol() {
		$currencyCode = $this->getCurrencyCode();
		$currencySymbol = "";
		if ($currencyCode == "GBP") {
			$currencySymbol = "&pound;";
		} else if ($currencyCode == "USD") {
			$currencySymbol = "&dollar;";
		} else if ($currencyCode == "EUR") {
			$currencySymbol = "&euro;";
		}
		return $currencySymbol;
	}

	public function getCurrencyCode() {
		return $this->myConfig['currencyCode'];
	}

	public function formatCurrency($amt, $showDefForZero=true, $def='-') {
		if (!empty($amt)) {
			if ($amt == 0 && $showDefForZero) {
				return $def;
			}
			return $this->getCurrencySymbol() . number_format($amt,2);
		}
		return $def;
	}

	public function formatPercent($amt, $showDefForZero=true, $def='-') {
		if (!empty($amt)) {
			if ($amt == 0 && $showDefForZero) {
				return $def;
			}
			return number_format($amt,2) . '%';
		}
		return $def;
	}

	public function formatAmount($amt, $def='-') {
		if (!empty($amt)) {
			return number_format($amt,2);
		}
		return $def;
	}

	public function getComponentDisplayName($compId) {
		return $this->myConfig['componentData'][$compId]['displayName'];
	}

	public function getComponentPricingType($compId) {
		return $this->myConfig['componentData'][$compId]['pricingType'];
	}

	public function getComponentPricingData($compId) {
		return $this->myConfig['componentData'][$compId]['pricingData'];
	}

	public function getShipperAddresses() {
		return $this->myConfig['shipperAddresses'];
	}

	public function getDefaultShippingAddressId() {
		return $this->myConfig['defShipAddressId'];
	}
	
	public function getVatRates($formDefault) {
		$data = $this->myConfig['vatRates'];
		if (isset($formDefault)) {
			$data['def'] = $formDefault;
		}
		return $data;
	}
	
	public function hideField($fieldname) {
		$regionId = $this->myConfig['regionId'];
		return ($regionId == 8); // for the mo hide if NY 
	}

	public function getComponentPriceXVat($useTempTable, $compid, $pn, $incextras) {
        $tablename = $useTempTable ? 'TempPurchase' : 'Purchase';
        $purchaseTable = TableRegistry::get($tablename);
        $price = $purchaseTable->getComponentPriceXVat($compid, $pn, $incextras);
		return floatval(str_replace(',', '', $price));
    }

	public function getPaymentsForInvoiceNo($useTempTable, $invno, $pn) {
        $tablename = $useTempTable ? 'TempPurchase' : 'Purchase';
        $purchaseTable = TableRegistry::get($tablename);
        return $purchaseTable->getPaymentsForInvoiceNo($invno, $pn);
    }

	public function getOutstandingForInvoiceNo($useTempTable, $totalinvoice, $invno, $pn) {
        $tablename = $useTempTable ? 'TempPurchase' : 'Purchase';
        $purchaseTable = TableRegistry::get($tablename);
        return $purchaseTable->getOutstandingForInvoiceNo($totalinvoice, $invno, $pn);
    }
}
