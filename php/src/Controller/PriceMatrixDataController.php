<?php

namespace App\Controller;

use Cake\Routing\Router;
use \Exception;

class PriceMatrixDataController extends AppController {

	private $oHeader;

	public function initialize() : void {
        parent::initialize();
		$this->loadModel('PriceMatrix');
	}

    public function getMatrixPrice() {
    	$this->autoRender = false;
		$queryParams = $this->request->getQuery();
		$compId = $queryParams["compid"];
		$priceTypeName = $queryParams["type"];
		$dim1 = $queryParams["dim1"];
		$dim2 = $queryParams["dim2"];
		$dim3 = $queryParams["dim3"];
		$curr = $queryParams["curr"];
		$multiplier = (float)$queryParams["multiplier"];

		$compIdSet1 = '';
		if (isset($queryParams["compidset1"])) {
			$compIdSet1 = $queryParams["compidset1"];
		}

		$compIdSet2 = '';
		if (isset($queryParams["compidset2"])) {
			$compIdSet2 = $queryParams["compidset2"];
		}

		$isTrade = false;
		if (isset($queryParams["trade"])) {
			$isTrade = $queryParams["trade"] == "y";
		}

		$vatRate = 0.0;
		if (isset($queryParams["vatrate"])) {
			$vatRate = (float)$queryParams["vatrate"];
		}
		
		$prices = $this->PriceMatrix->getMatrixPrice($compId, $priceTypeName, $dim1, $dim2, $dim3, $curr, $compIdSet1, $compIdSet2);
		$price = $prices['listPrice'];
		
		if ($price == -1.0 && ($compIdSet1 != "" || $compIdSet2 != "")) {
			// no price found for the set, so try with just the component
			$prices = $this->PriceMatrix->getMatrixPrice($compId, $priceTypeName, $dim1, $dim2, $dim3, $curr, "", "");
			$price = $prices['listPrice'];
		}
		
		if ($price == -1.0 && ($dim1 != "" || $dim2 != "" || $dim3 != "")) {
			//no price found for the set, or with the dimensions, so try without the dimensions
			$prices = $this->PriceMatrix->getMatrixPrice($compId, $priceTypeName, "", "", "", $curr, "", "");
			$price = $prices['listPrice'];
		}
		
		if ($price != -1.0) {
			$price = $price * $multiplier;
			if ($isTrade && $curr != "USD") { // prices in price matrix table for USD are VAT excl
				$price = $price / (1.0 + $vatRate/100.0);
			}
		}
		
		$this->response = $this->response->withType('application/json');
		$this->response = $this->response->withStringBody(number_format($price, 2, ".", ""));
		return $this->response;
	}
}

?>