<?php
require('../fpdf.php');

class PDF extends FPDF
{
	private $currencySymbol;
	private $renderHeader = false;
	private $orderType = "";
	public $sourceTotals = array();
	private $currencyShortCode;
	
	public function setCurrencyShortCode($currencyShortCode) {
		$this->currencyShortCode = $currencyShortCode;
	}

	// Better table
	function title($info){
		$this->SetFont('Arial','B',15);
		$w_m = $this->GetStringWidth($info['month'])+2;
		$this->Cell($w_m,7,$info['month'],0,0,'L');
		$this->Cell(5,7,'',0,0,'L');
		$w_y = $this->GetStringWidth($info['year'])+2;
		$this->Cell($w_y,7,$info['year'],0,0,'L');
		$this->Cell(10,7,'',0,0,'L');
		$showroom = utf8_decode($info['showroom']);
		$w_s = $this->GetStringWidth($showroom)+2;
		$w_space = 165-$w_s-$w_m-$w_y-10;
		$this->Cell($w_s,7,$showroom,0,0,'R');
		$this->Ln(10);
		$this->SetFont('Arial','B',8);
		$this->Cell(0,6,'Monthly Sales Status Report',0,0,'L');
		$this->Ln(10);
	}
	/*
	 *
	 */
    function Header() {
        if ($this->renderHeader) {
            $currencySymbol = $this->getCurrencySymbol($this->currencyShortCode);
            $w_symbol = $this->GetStringWidth($currencySymbol);
            $w_space = 190;
            $cellHight = 5;
            $this->Ln(10);
            $this->SetFont('Arial', 'B', 10);
            $this->Cell($w_space, 7, "List of " . $this->orderType ." Orders", 0, 0, 'L');
            $this->Ln(10);
            $this->SetFont('Arial', '', 7);
            $w = 38;
            $this->Cell(15, $cellHight, 'Order No.', 'LT', 0, 'L');
            $this->Cell(20, $cellHight, 'Customer', 'T', 0, 'L');
            $this->Cell(20, $cellHight, 'Company', 'TB', 0, 'L');
            $this->Cell(20, $cellHight, 'Customer Ref', 'TB', 0, 'L');
            $this->Cell(2, $cellHight, '', 'TB', 0, 'R');
            $this->Cell(16, $cellHight, 'Value', 'T', 0, 'R');
            $this->Cell(2, $cellHight, '', 'TB', 0, 'R');
            $this->Cell(10, $cellHight, 'Cat', 'T', 0, 'L');
            $this->Cell(84, $cellHight, 'Description', 'RT', 0, 'L');
            $this->Ln($cellHight);
            return array($currencySymbol, $w_symbol, $cellHight);
        } else {
            $this->renderHeader = true;
        }
    }

	function getCurrencySymbol($code){
		switch ($code){
			case 'GBP':
				return utf8_decode('£');
				break;
			case 'USD':
				return '$';
				break;
			case 'EUR':
				return chr(128);
				break;
		}
	}
	function tableBody($data){ //first half of page
		$w_space = 189;
		$cellHight = 5;
		$currencySymbol = $this->getCurrencySymbol($data['currency']);
		$this->Cell($w_space,$cellHight,'','LRT',0,'L');
		$this->Ln($cellHight);
		$this->SetFont('Arial','',9);
		$w = $this->GetStringWidth('Sales-New Orders(ex VAT)');
		$total = $data['total'];
		$totalComma = $this->addComma($total);
		$w1 = 126 - $w;
		$this->Cell($w,$cellHight,'Sales-New Orders(ex VAT)','L',0,'L');
		$this->Cell($w1,$cellHight,'',0,0,'L');
		$this->SetFont('Arial','B',9);
		//header ACTUAL
		$this->Cell(63,$cellHight,"Actual: $currencySymbol$totalComma",'R',0,'L');
		$this->SetFont('Arial','',9);
		$this->Ln($cellHight);
		$this->Cell($w_space,$cellHight,'','LR',0,'L');
		$this->Ln($cellHight);
		$w_array = array(30,30,30,30);
		$w1 = 21;
		
		$this->Cell($w_array[0],$cellHight,'','L',0,'L');
		$this->Cell($w_array[1],$cellHight,'total',0,0,'R');
		$this->Cell($w_array[2],$cellHight,'no. sold',0,0,'R');
		$this->Cell($w_array[3],$cellHight,'no. last yr',0,0,'R');
		$this->Cell(6,$cellHight,'',0,0,'L');
		$this->Cell(63,$cellHight,'','R',0,'L');
		$this->Ln($cellHight);
		$amountVStarget = $data['target']==0?0:round((($total - $data['target'])/$data['target'])*100);
		$amountVlyMonth = $data['ly_amount']==0?0:round((($total - $data['ly_amount'])/$data['ly_amount'])*100);
		$w_symbol = $this->GetStringWidth($currencySymbol);
		
		foreach ($data['data'] as $key=>$value){
			$valueAmountComma = $this->addComma($value['amount']);
			$valueTargetComma = $this->addComma($data['target']);
			$ly_amountComma = $this->addComma($data['ly_amount']);
			$totalComma = $this->addComma($data['total']);
			$targetComma = $this->addComma($data['target']);
			
			$this->Cell($w_array[0],$cellHight,ucfirst($key),'L',0,'L');
			$this->Cell($w_symbol,$cellHight,$currencySymbol,0,0,'R');
			$this->Cell($w_array[1]-$w_symbol,$cellHight,$valueAmountComma,0,0,'R');
			$this->Cell($w_array[2],$cellHight,$value['quantities'],0,0,'R');
			$this->Cell($w_array[3],$cellHight,$value['ly_quantities'],0,0,'R');
			$this->Cell(6,$cellHight,'',0,0,'L');
			if($key =='no1'){
				$this->Cell($w1,$cellHight,'Target: ',0,0,'L');
				$this->Cell($w1,$cellHight,$currencySymbol.$valueTargetComma,0,0,'R');
				$this->Cell($w1,$cellHight,"$amountVStarget%",'R',0,'R');
			}else if($key =='no2'){
				$this->Cell($w1,$cellHight,'Mth last Yr: ',0,0,'L');
				$this->Cell($w1,$cellHight,$currencySymbol.$ly_amountComma,0,0,'R');
				$this->Cell($w1,$cellHight,"$amountVlyMonth%",'R',0,'R');
			}else if($key =='pinnacle'){
				$this->Cell($w1,$cellHight,'',0,0,'L');
				$this->Cell($w1,$cellHight,'Actual',0,0,'L');
				$this->Cell($w1,$cellHight,'Target','R',0,'L');
			}else if($key =='toppers'){
				$this->Cell($w1,$cellHight,'YTD retail: ',0,0,'L');
				$this->Cell($w_symbol,$cellHight,$currencySymbol,0,0,'R');
				$this->Cell($w1-$w_symbol,$cellHight,$totalComma,0,0,'R');
				$this->Cell($w1,$cellHight,$currencySymbol.$targetComma,'R',0,'R');
			}
			else{
				$this->Cell(63,$cellHight,'','R',0,'L');
			}
			
			$this->Ln($cellHight);
		}
		
		$ytdComma = $this->addComma($data['ytd']);
		$ytd_targetComma = $this->addComma($data['ytd_target']);
		$ly_ytdComma = $this->addComma($data['ly_ytd']);
		
		$ytdVytdTarget = $data['ytd_target']==0?0:round((($data['ytd'] - $data['ytd_target'])/$data['ytd_target'])*100);
		$ytdVlyytd = $data['ly_ytd']==0?0:round((($data['ytd'] - $data['ly_ytd'])/$data['ly_ytd'])*100);
		
		$this->Cell($w_space,$cellHight,'','LR',0,'L');
		$this->Ln($cellHight);
		$this->SetFont('Arial','B',9);
        //final row BOLD
		$this->Cell($w_array[0],$cellHight,'Total','L',0,'L');
		$this->Cell($w_symbol,$cellHight,$currencySymbol,0,0,'R');
		$this->Cell($w_array[1]-$w_symbol,$cellHight,$totalComma,0,0,'R');
		$this->Cell($w_array[2],$cellHight,$data['total_quantities'],0,0,'R');
		$this->Cell($w_array[3],$cellHight,$data['ly_total_quantities'],0,0,'R');
		$this->SetFont('Arial','',9);
		$this->Cell(6,$cellHight,'',0,0,'L');
		$this->Cell($w1,$cellHight,'YTD Total: ',0,0,'L');
		$this->Cell($w_symbol,$cellHight,$currencySymbol,0,0,'R');
		$this->Cell($w1-$w_symbol,$cellHight,$ytdComma,0,0,'R');
		$this->Cell($w1,$cellHight,'','R',0,'L');
		$this->Ln($cellHight);
		$this->Cell(126,$cellHight,'','L',0,'L');
		$this->Cell($w1,$cellHight,'YTD Target: ',0,0,'L');
		$this->Cell($w_symbol,$cellHight,$currencySymbol,0,0,'R');
		$this->Cell($w1-$w_symbol,$cellHight,$ytd_targetComma,0,0,'R');
		$this->Cell($w1,$cellHight,"$ytdVytdTarget%",'R',0,'R');
		$this->Ln($cellHight);
		$this->Cell(126,$cellHight,'','L',0,'R');
		
		$this->Cell($w1,$cellHight,'YTD Pr Yr: ',0,0,'L');
		$this->Cell($w_symbol,$cellHight,$currencySymbol,0,0,'R');
		$this->Cell($w1-$w_symbol,$cellHight,$ly_ytdComma,0,0,'R');
		$this->Cell($w1,$cellHight,"$ytdVlyytd%",'R',0,'R');
		$this->Ln($cellHight);
		$this->Cell($w_space,$cellHight,'','LRB',0,'R');
		$this->Ln($cellHight);
	}
	
	function getPagePercentLeft() {
		$y = $this->GetY();
		$h = $this->GetPageHeight();
		$pc = ($h - $y) / $h * 100;
		return $pc;
	}

	//second half of the page
	function orderDetail($data, $type, $total){
		$currencySymbol = $this->getCurrencySymbol($this->currencyShortCode);
//		var_dump($this->currencyShortCode);
//		var_dump($currencySymbol);
//		die;
		
		$this->orderType = $type;
		if ($this->getPagePercentLeft() < 20) {
			$this->renderHeader = false;
			$this->AddPage();
		}
	    list($currencySymbol, $w_symbol, $cellHight) = $this->getOrderDetailHeader($type);
		
		foreach ($data as $d){
			$commaValue = $this->addComma((float)$d['value']);
			$this->Cell(15,$cellHight,$d['order_no'],'LTB',0,'L');
			$this->Cell(20,$cellHight,substr($d['customer'],0,13),'TB',0,'L');
			$this->Cell(20,$cellHight,substr($d['orderDate'],0,13),'TB',0,'L');
			$this->Cell(20,$cellHight,substr($d['company'],0,13),'TB',0,'L');
			$this->Cell(20,$cellHight,substr($d['ref'],0,13),'TB',0,'L');			
			$this->Cell(2,$cellHight,'','TB',0,'R');
			$this->Cell($w_symbol,$cellHight,$currencySymbol,'TB',0,'R');
			$this->Cell(16-$w_symbol,$cellHight,$commaValue,'TB',0,'R');
			$this->Cell(2,$cellHight,'','TB',0,'R');
			$this->Cell(10,$cellHight,$d['cat'],'TB',0,'L');
			$this->Cell(84,$cellHight,$d['description'],'RTB',0,'L');
			$this->Ln($cellHight);
		}
		//BOTTOM TOTAL (in development)
        $this->Cell(13,$cellHight,'TOTAL','LRTB',0,'L');
        $this->Cell(22,$cellHight,'','TB',0,'L');
        $this->Cell(20,$cellHight,'','TB',0,'L');
        $this->Cell(20,$cellHight,'','TB',0,'L');
        $this->Cell(4,$cellHight,$currencySymbol,'TB',0,'R');
        $this->Cell(14,$cellHight, $total,'TB',0,'R'); //HERE
        $this->Cell(2,$cellHight,'','TB',0,'R');
        $this->Cell(10,$cellHight,'','TB',0,'L');
        $this->Cell(84,$cellHight,'','RTB',0,'L');
	}

    public function setSourceTotalsArray($data)
    {
        $this->sourceTotals = $data["source_totals"];
//        switch ($this->sourceTotals){
//			case $this->sourceTotals['Floorstock']:
//
//
//		}
        //var_dump($this->sourceTotals["Client"]);
//		var_dump($this->sourceTotals);
//        echo "<pre>";
//		print_r($this->sourceTotals);
//        echo "</pre>";
//		die();
		return $this->sourceTotals;
    }


    function addComma($digit){
		//var p = s.indexOf('.');
		$x = explode('.',(string)$digit);
		$x1 = $x[0];
		$x2 = (count($x) > 1 && strlen($x[1]) >= 1) ? (strlen($x[1]) > 1?'.'.$x[1]:'.'.$x[1].'0'): '.00';
		$rgx = '/(\d+)(\d{3})/';
		while (preg_match($rgx,$x1)) {
			$x1 = preg_replace($rgx,'$1,$2',$x1);
		}
		return $x1.$x2;
	}
	public function getMonth($month){
		$monthArray = array('January','February','March','April','May','June','July','August','September','October','November','December');
		return $monthArray[$month-1];
	}
	function _multiLineGenerator($str){
		echo strlen($str);
		die();
	}

    public function getOrderDetailHeader()
    {
        $currencySymbol = $this->getCurrencySymbol($this->currencyShortCode);
        $w_symbol = $this->GetStringWidth($currencySymbol);
        $w_space = 190;
        $cellHight = 5;
        $this->Ln(10);
        $this->SetFont('Arial', 'B', 10);
        $this->Cell($w_space, 7, "List of ".$this->orderType. " orders", 0, 0, 'L');
        $this->Ln(10);
        $this->SetFont('Arial', '', 7);
        $w = 38;
        $this->Cell(15, $cellHight, 'Order No.', 'LT', 0, 'L');
        $this->Cell(20, $cellHight, 'Customer', 'T', 0, 'L');
        $this->Cell(20, $cellHight, 'Order Date', 'T', 0, 'L');
        $this->Cell(20, $cellHight, 'Company', 'TB', 0, 'L');
        $this->Cell(20, $cellHight, 'Customer Ref', 'TB', 0, 'L');
        $this->Cell(2, $cellHight, '', 'TB', 0, 'R');
        $this->Cell(16, $cellHight, 'Value', 'T', 0, 'R');
        $this->Cell(2, $cellHight, '', 'TB', 0, 'R');
        $this->Cell(10, $cellHight, 'Cat', 'T', 0, 'L');
        $this->Cell(84, $cellHight, 'Description', 'RT', 0, 'L');
        $this->Ln($cellHight);
        return array($currencySymbol, $w_symbol, $cellHight);
    }

}


if($_SERVER["REQUEST_METHOD"] == "POST"){
	$data = json_decode($_POST["printData"],true);
	$pdf = new PDF();
	// Column headings
	// Data loading
	//$data = $pdf->LoadData('countries.txt');
	$month = $pdf->getMonth($data['month']);
	$year = $data['year'];
	$pdf->SetFont('Arial','',10);
	$pdf->AddPage();
	$pdf->title(array('month'=>$month,'year'=>$year,'showroom'=>ucfirst($data['showroom_name'])));
	if (array_key_exists("data", $data)) {
	$pdf->tableBody($data);
	} else {
		$pdf->Cell(10,6,'No sales',0,0,'L');
	}
    $pdf->setSourceTotalsArray($data);
    //var_dump($pdf->setSourceTotalsArray($data));
	if(!empty($data["order_detail"])){
		$customerOrders = array();
		$stockOrders = array();
		$floorstockOrders = array();
		$marketingOrders = array();
		$testOrders = array();
		$ecomOrders = array();
		$otherOrders = array();

		foreach($data["order_detail"] as $o){
			switch($o["orderSource"]){
				case 'Client':
				case 'Client Retail':
				case 'Client Trade':
				case 'Client Contract':
					$customerOrders[] = $o;
					break;
                case 'Client Retail':
                    $customerOrders[] = $o;
                    break;
                case 'Customer':
                    $customerOrders[] = $o;
                    break;
				case 'Stock':
					$stockOrders[] = $o;
					break;
				case 'Floorstock':
					$floorstockOrders[] = $o;
					break;
				case 'Marketing':
					$marketingOrders[] = $o;
					break;
				case 'Test':
					$testOrders[] = $o;
					break;
				case 'Ecom':
					$ecomOrders[] = $o;
					break;
				default:
					$otherOrders[] = $o;
					break;
			}
		}

		$pdf->setCurrencyShortCode($data['currency']);

		if (!empty($customerOrders)) {
			$pdf->orderDetail($customerOrders, 'Client', $pdf->addComma($data['source_totals']['Client']));
		}

		if (!empty($stockOrders)) {
			$pdf->orderDetail($stockOrders, 'Stock', $pdf->addComma($data['source_totals']['Stock']));
		}

		if (!empty($floorstockOrders)) {
			$pdf->orderDetail($floorstockOrders, 'Floor Stock', $pdf->addComma($data['source_totals']['Floorstock']));
		}

        if (!empty($marketingOrders)) {
            $pdf->orderDetail($marketingOrders, 'Marketing', $pdf->addComma($data['source_totals']['Marketing'] ));

        }

		if (!empty($testOrders)) {
			$pdf->orderDetail($testOrders, 'Test', $data['source_totals']['Test']);
		}

		if (!empty($ecomOrders)) {
			$pdf->orderDetail($ecomOrders, 'Ecom', $pdf->addComma($data['source_totals']['Ecom'] ));
		}
		
		if (!empty($otherOrders)) {
			$pdf->orderDetail($otherOrders, 'Other', $pdf->addComma($data['source_totals']['Other'] ));
		}

	} //end of if
	$pdf->Output();
}else{
	
}


?>
