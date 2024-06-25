<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;
use Cake\Event\EventInterface;

class WholesalePriceReportController extends SecureAppController {
	private $auxiliaryDataModel;
	
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
		$this->auxiliaryDataModel = TableRegistry::get('AuxiliaryData');
	}

	public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
        $builder->addHelpers([
        	'AuxiliaryData'
        ]);
    }

    public function index() {
		$this->viewBuilder()->setLayout('savoir');

		
		$formData = $this->request->getData();
		
		$this->set('month', $this->_getSafeValueFromForm($formData, 'month'));
		
	}
	
	public function export() {		
		$wholesaleTable = TableRegistry::get('WholesalePrices');
		$pmTable = TableRegistry::get('PriceMatrix');
		$purchaseTable = TableRegistry::get('Purchase');
		$exportTable = TableRegistry::get('ExportCollections');
		$formData = $this->request->getData();
		$inputdate=$formData['month'];

		$year=substr($inputdate, -4);
		$month=substr($inputdate, 0, -5);
		
		$monthName = $month;
		$date = date_parse($monthName);
		$monthNumber = $date['month'];

		$wholesalepricereport = $wholesaleTable->getWholesalePriceReport($monthNumber, $year);
		//debug($wholesalepricereport);
		//die;
		$data = [];
		
		
		foreach ($wholesalepricereport as $row) {
			$query = $purchaseTable->find()->where(['PURCHASE_No' => $row['PURCHASE_No']]);
			$exworksdate='';
			$totalexvat='';
			$totalorder='';
			$totalorderGBP='';
			$totalorderUSD='';
			$totalorderEUR='';
			$totalorder=$row['totalexvat'];
	
			$exworksdate2=$exportTable->getExportDate($row['PURCHASE_No'], $row['ComponentID']);
			foreach ($exworksdate2 as $rows) {
				$exworksdate=date("d/m/Y", strtotime(substr($row['CollectionDate'],0,10)));
			}
			
			$component='';
			$component=$row['Component'];
			$itemtype='';
			$wholesaleholder='';
			$wholesale='';
			$wholesaleprice='';
			$compexvat='';
			$exvatGBP='';
			$exvatEUR='';
			$exvatUSD='';
			$discount='';
			$discount=$row['discount'];
			$discounttype='';
			$discounttype=$row['discounttype'];
			$bedsettotal='';
			$bedsettotal=$row['bedsettotal'];
			$discountGBP='';
			$discountUSD='';
			$discountEUR='';
			$ordercurrency=
			$ordercurrency=$row['ordercurrency'];
			$cheapertopperM='';
			$cheapertopperB='';
			$istrade='';
			$istrade=$row['istrade'];
			$vatrate='';
			$vatrate=$row['vatrate'];
			$uphbase='';
			$basenonwholesale='';
			$basenonwholesaleGBP='';
			$basenonwholesaleUSD='';
			$basenonwholesaleEUR='';
			$basewholesale='';
			
			
			
			if (isset($row['discount']) && $row['discounttype']== 'percent') {
				$discount=$row['discount']/100 * $row['bedsettotal'];
				if ($istrade != 'y') {
					$discount=$discount/(1+$vatrate/100);
				}
			}
			if (isset($row['discount']) && $row['discounttype']== 'currency') {
				$discount=$row['discount'];
				if ($istrade != 'y') {
					$discount=$discount/(1+$vatrate/100);
				}
			}
			if (is_string($discount) || $discount == null) {
			} else {
				$discount=number_format($discount,2);
			}
			if (!isset($row['discount'])) {
				$discount='';
			}
			if (isset($row['discount'])) {
				if ($ordercurrency=='GBP') {
					$discountGBP=$discount;
				}
				if ($ordercurrency=='USD') {
					$discountUSD=$discount;
				}
				if ($ordercurrency=='EUR') {
					$discountEUR=$discount;
				}
			}
			if ($ordercurrency == 'GBP') {
				$totalorderGBP=$totalorder;
			}
			if ($ordercurrency == 'USD') {
				$totalorderUSD=$totalorder;
			}
			if ($ordercurrency == 'EUR') {
				$totalorderEUR=$totalorder;
			}	
		
			if ($row['ComponentID'] == 1) {
				$itemtype=$row['savoirmodel']." - ".$row['Component'];
				$wholesale=$pmTable->getMatrixPrice(1, $row['savoirmodel'], $row['mattresswidth'], $row['mattresslength'], '', 'GBP', '', '');
				if ($wholesale['wholesalePrice'] != -1) {
					$wholesaleholder="£".$wholesale['wholesalePrice'];
					$cheapertopperM=1;
				} else {
					$compexvat=$purchaseTable->getComponentPriceXVat(1, $row['PURCHASE_No'], false);
					
					if ($ordercurrency=='GBP') {$exvatGBP=$compexvat;}
					if ($ordercurrency=='EUR') {$exvatEUR=$compexvat;}
					if ($ordercurrency=='USD') {$exvatUSD=$compexvat;}
				}
			}
			$wholesaleuph='';
			if ($row['ComponentID'] == 3) {
				if (isset($row['upholsteredbase'])) {
					if (substr($row['upholsteredbase'], 0, 3)=='Yes') {
						$uphbase='y';
					} else {
						$uphbase='';
					}
				}
				$itemtype=$row['basesavoirmodel']." - ".$row['Component'];
				$wholesale=$pmTable->getMatrixPrice(3, $row['basesavoirmodel'], $row['basewidth'], $row['baselength'], '', 'GBP', '', '');
				if ($wholesale['wholesalePrice'] != -1) {
					$wholesaleholder="£".$wholesale['wholesalePrice'];
					$cheapertopperB=3;
				} else {
					$compexvat=$purchaseTable->getComponentPriceXVat(3, $row['PURCHASE_No'], false);
					if ($ordercurrency=='GBP') {$exvatGBP=$compexvat;}
					if ($ordercurrency=='EUR') {$exvatEUR=$compexvat;}
					if ($ordercurrency=='USD') {$exvatUSD=$compexvat;}
				}
				
				if ($uphbase=='y') {
					$wholesaleuph=$pmTable->getMatrixPrice(12, 'Base Upholstery', '', '', '', 'GBP', '', '');
					if ($wholesaleuph['wholesalePrice'] != '') {
						$basewholesale="£".$wholesaleuph['wholesalePrice'];
					} else {
						$basenonwholesale=$purchaseTable->getComponentPriceXVat(31, $row['PURCHASE_No'], false);
						if ($ordercurrency=='GBP') {$basenonwholesaleGBP=$basenonwholesale;}
						if ($ordercurrency=='EUR') {$basenonwholesaleEUR=$basenonwholesale;}
						if ($ordercurrency=='USD') {$basenonwholesaleUSD=$basenonwholesale;}

					}
					
				}
			}
			if ($row['ComponentID'] == 5) {
				$itemtype=$row['toppertype']." - ".$row['Component'];
				$wholesale=$pmTable->getMatrixPrice(5, $row['toppertype'], $row['topperwidth'], $row['topperlength'], '', 'GBP', $cheapertopperB, $cheapertopperM);
				if ($wholesale['wholesalePrice'] != -1) {
					$wholesaleholder="£".$wholesale['wholesalePrice'];
				} else {
					$compexvat=$purchaseTable->getComponentPriceXVat(5, $row['PURCHASE_No'], false);
					if ($ordercurrency=='GBP') {$exvatGBP=$compexvat;}
					if ($ordercurrency=='EUR') {$exvatEUR=$compexvat;}
					if ($ordercurrency=='USD') {$exvatUSD=$compexvat;}
				}
			}
			$nooflegs=0;
			if ($row['ComponentID'] == 7) {
				$itemtype=$row['legstyle']." - ".$row['Component'];
				$wholesale=$pmTable->getMatrixPrice(7, $row['legstyle'], '', '', '', 'GBP', '', '');
				if ($wholesale['wholesalePrice'] != -1) {
					$nooflegs=$row['LegQty']+$row['AddLegQty'];
					$wholesaleholder="£".$wholesale['wholesalePrice']*$nooflegs;
				} else {
					$compexvat=$purchaseTable->getComponentPriceXVat(7, $row['PURCHASE_No'], false);
					if ($ordercurrency=='GBP') {$exvatGBP=$compexvat;}
					if ($ordercurrency=='EUR') {$exvatEUR=$compexvat;}
					if ($ordercurrency=='USD') {$exvatUSD=$compexvat;}
				}
			}
			if ($row['ComponentID'] == 8) {
				$itemtype=$row['headboardstyle']." - ".$row['Component'];
				$wholesale=$pmTable->getMatrixPrice(8, $row['headboardstyle'], '', '', '', 'GBP', '', '');
				if ($wholesale['wholesalePrice'] != -1) {
					$wholesaleholder="£".$wholesale['wholesalePrice'];
				} else {
					$compexvat=$purchaseTable->getComponentPriceXVat(8, $row['PURCHASE_No'], false);
					if ($ordercurrency=='GBP') {$exvatGBP=$compexvat;}
					if ($ordercurrency=='EUR') {$exvatEUR=$compexvat;}
					if ($ordercurrency=='USD') {$exvatUSD=$compexvat;}
					
				}
			}
			$salesother='';
			$salesotherGBP='';
			$salesotherUSD='';
			$salesotherEUR='';

			$salesother=$purchaseTable->getComponentPriceXVat(99, $row['PURCHASE_No'], false);
			if ($ordercurrency=='GBP') {$salesotherGBP=$salesother;}
			if ($ordercurrency=='EUR') {$salesotherEUR=$salesother;}
			if ($ordercurrency=='USD') {$salesotherUSD=$salesother;}
			
$prodcompletiondate='';
if ($row['production_completion_date'] != '' && $row['production_completion_date'] != null) {
	$prodcompletiondate=date("d/m/Y", strtotime(substr($row['production_completion_date'],0,10)));
}
$bookeddeldate='';
if ($row['bookeddeliverydate'] != '' && $row['bookeddeliverydate'] != null) {
	$bookeddeldate=date("d/m/Y", strtotime(substr($row['bookeddeliverydate'],0,10)));
}
			
if ($row['ComponentID'] != 0) {
		if ($uphbase=='y') {
					$a = [date("d/m/Y", strtotime(substr($row['ORDER_DATE'],0,10))),$prodcompletiondate,$row['ORDER_NUMBER'],$row['surname'],$row['company'],$row['adminheading'],$row['PRICE_LIST'], $itemtype.' - Base - Upholstery','','','',$basewholesale,$basenonwholesaleGBP,$basenonwholesaleUSD,$basenonwholesaleEUR,'','','',$bookeddeldate,$exworksdate];
					array_push($data, $a);
		} 
		
		$a = [date("d/m/Y", strtotime(substr($row['ORDER_DATE'],0,10))),$prodcompletiondate,$row['ORDER_NUMBER'],$row['surname'],$row['company'],$row['adminheading'],$row['PRICE_LIST'], $itemtype.' - '.$component,'','','',$wholesaleholder,$exvatGBP,$exvatUSD,$exvatEUR,'','','',$bookeddeldate,$exworksdate];
					array_push($data, $a);

		} else {
				$a = [date("d/m/Y", strtotime(substr($row['ORDER_DATE'],0,10))),$prodcompletiondate,$row['ORDER_NUMBER'],$row['surname'],$row['company'],$row['adminheading'],$row['PRICE_LIST'], 'Order Total',$totalorderGBP,$totalorderUSD,$totalorderEUR,$wholesaleholder,'','','',$discountGBP,$discountUSD,$discountEUR,$bookeddeldate,'',$salesotherGBP,$salesotherUSD,$salesotherEUR];				
					array_push($data, $a);
			}
		}
		
		$header = ['Order Date', 'Production Completion Date', 'Order No.', 'Surname', 'Company', 'Showroom', 'Price List', 'Item','Order Total Ex VAT from Order Form in sales GBP','Order Total Ex VAT from Order Form in sales USD','Order Total Ex VAT from Order Form in sales EUR','Price of item in £ Wholesale (from price matrix)','Price of Items not on matrix Ex VAT Retail Prices in sales GBP','Price of Items not on matrix Ex VAT Retail Prices in sales USD','Price of Items not on matrix Ex VAT Retail Prices in sales EUR','Discount (from order) in order GBP','Discount (from order) in order USD','Discount (from order) in order EUR]','Delivery Date','Ex-Works Date','Other non-matrix items (fabric/accessories/delivery etc) ex vat in sales order currency GBP','Other non-matrix items (fabric/accessories/delivery etc) ex vat in sales order currency USD','Other non-matrix items (fabric/accessories/delivery etc) ex vat in sales order currency EUR'];
		
//")		
    	
    	$this->setResponse($this->getResponse()->withDownload('WholesalePricesReport.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $header
    	]);

		
		
	}
	
	
	

	private function _getSafeValueFromForm($formData, $name) {
		$value = "";
		if (isset($formData[$name])) {
			$value = $formData[$name];
		}
		return $value;
	}

	protected function _getAllowedRoles() {
		return array("ADMINISTRATOR","REGIONAL_ADMINISTRATOR");
	}
}

?>
