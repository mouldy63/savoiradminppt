<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class ItemsProducedController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
		$manufacturedatTable = TableRegistry::get('ManufacturedAt');
		$formData = $this->request->getData();
		
		if ($this->request->is('post')) {
			$this->_edit();
			$this->set('datefrom', $this->_getSafeValueFromForm($formData, 'datefrom'));
			$this->set('dateto', $this->_getSafeValueFromForm($formData, 'dateto'));
			$datefrom = $this->_getSafeValueFromForm($formData, 'datefrom');
			$dateto = $this->_getSafeValueFromForm($formData, 'dateto');
			$ProdLondonMattress = $manufacturedatTable->getProdMattress($datefrom, $dateto, 2);
			$ProdCardiffMattress = $manufacturedatTable->getProdMattress($datefrom, $dateto, 1);
			$ProdStockMattress = $manufacturedatTable->getProdMattress($datefrom, $dateto, 4);
			$ItemLondonMattress = $manufacturedatTable->getItemMattress($datefrom, $dateto, 2);
			$ItemCardiffMattress = $manufacturedatTable->getItemMattress($datefrom, $dateto, 1);
			$ItemStockMattress = $manufacturedatTable->getItemMattress($datefrom, $dateto, 4);
			$OBLondonMattress = $manufacturedatTable->getOBMattress(2);
			$OBCardiffMattress = $manufacturedatTable->getOBMattress(1);
			$OBStockMattress = $manufacturedatTable->getOBMattress(4);
			$ProdLondonBase = $manufacturedatTable->getProdBase($datefrom, $dateto, 2);
			$ProdCardiffBase = $manufacturedatTable->getProdBase($datefrom, $dateto, 1);
			$ProdStockBase = $manufacturedatTable->getProdBase($datefrom, $dateto, 4);
			$ItemLondonBase = $manufacturedatTable->getItemBase($datefrom, $dateto, 2);
			$ItemCardiffBase = $manufacturedatTable->getItemBase($datefrom, $dateto, 1);
			$ItemStockBase = $manufacturedatTable->getItemBase($datefrom, $dateto, 4);
			$OBLondonBase = $manufacturedatTable->getOBBase(2);
			$OBCardiffBase = $manufacturedatTable->getOBBase(1);
			$OBStockBase = $manufacturedatTable->getOBBase(4);
			$ProdLondonTopper = $manufacturedatTable->getProdTopper($datefrom, $dateto, 2);
			$ProdCardiffTopper = $manufacturedatTable->getProdTopper($datefrom, $dateto, 1);
			$ProdStockTopper = $manufacturedatTable->getProdTopper($datefrom, $dateto, 4);
			$ItemLondonTopper = $manufacturedatTable->getItemTopper($datefrom, $dateto, 2);
			$ItemCardiffTopper = $manufacturedatTable->getItemTopper($datefrom, $dateto, 1);
			$ItemStockTopper = $manufacturedatTable->getItemTopper($datefrom, $dateto, 4);
			$OBLondonTopper = $manufacturedatTable->getOBTopper(2);
			$OBCardiffTopper = $manufacturedatTable->getOBTopper(1);
			$OBStockTopper = $manufacturedatTable->getOBTopper(4);
			$ProdLondonTopperOnly = $manufacturedatTable->getProdTopperOnly($datefrom, $dateto, 2);
			$ProdCardiffTopperOnly = $manufacturedatTable->getProdTopperOnly($datefrom, $dateto, 1);
			$ProdStockTopperOnly = $manufacturedatTable->getProdTopperOnly($datefrom, $dateto, 4);
			$ItemLondonTopperOnly = $manufacturedatTable->getItemTopperOnly($datefrom, $dateto, 2);
			$ItemCardiffTopperOnly = $manufacturedatTable->getItemTopperOnly($datefrom, $dateto, 1);
			$ItemStockTopperOnly = $manufacturedatTable->getItemTopperOnly($datefrom, $dateto, 4);
			$OBLondonTopperOnly = $manufacturedatTable->getOBTopperOnly(2);
			$OBCardiffTopperOnly = $manufacturedatTable->getOBTopperOnly(1);
			$OBStockTopperOnly = $manufacturedatTable->getOBTopperOnly(4);
			$ProdLondonLegs = $manufacturedatTable->getProdLegs($datefrom, $dateto, 2);
			$ProdCardiffLegs = $manufacturedatTable->getProdLegs($datefrom, $dateto, 1);
			$ProdStockLegs = $manufacturedatTable->getProdLegs($datefrom, $dateto, 4);
			$ItemLondonLegs = $manufacturedatTable->getItemLegs($datefrom, $dateto, 2);
			$ItemCardiffLegs = $manufacturedatTable->getItemLegs($datefrom, $dateto, 1);
			$ItemStockLegs = $manufacturedatTable->getItemLegs($datefrom, $dateto, 4);
			$OBLondonLegs = $manufacturedatTable->getOBLegs(2);
			$OBCardiffLegs = $manufacturedatTable->getOBLegs(1);
			$OBStockLegs = $manufacturedatTable->getOBLegs(4);
			$ProdLondonHB = $manufacturedatTable->getProdHB($datefrom, $dateto, 2);
			$ProdCardiffHB = $manufacturedatTable->getProdHB($datefrom, $dateto, 1);
			$ProdStockHB = $manufacturedatTable->getProdHB($datefrom, $dateto, 4);
			$ItemLondonHB = $manufacturedatTable->getItemHB($datefrom, $dateto, 2);
			$ItemCardiffHB = $manufacturedatTable->getItemHB($datefrom, $dateto, 1);
			$ItemStockHB = $manufacturedatTable->getItemHB($datefrom, $dateto, 4);
			$OBLondonHB = $manufacturedatTable->getOBHB(2);
			$OBCardiffHB = $manufacturedatTable->getOBHB(1);
			$OBStockHB = $manufacturedatTable->getOBHB(4);
			$ProdLondonTopperTotal = $manufacturedatTable->getTopperProdTotal($datefrom, $dateto, 2);
			$ProdCardiffTopperTotal = $manufacturedatTable->getTopperProdTotal($datefrom, $dateto, 1);
			$ProdStockTopperTotal = $manufacturedatTable->getTopperProdTotal($datefrom, $dateto, 4);
			$ItemLondonTopperTotal = $manufacturedatTable->getTopperItemTotal($datefrom, $dateto, 2);
			$ItemCardiffTopperTotal = $manufacturedatTable->getTopperItemTotal($datefrom, $dateto, 1);
			$ItemStockTopperTotal = $manufacturedatTable->getTopperItemTotal($datefrom, $dateto, 4);
			$OBLondonTopperTotal = $manufacturedatTable->getTopperOBTotal($datefrom, $dateto, 2);
			$OBCardiffTopperTotal = $manufacturedatTable->getTopperOBTotal($datefrom, $dateto, 1);
			$OBStockTopperTotal = $manufacturedatTable->getTopperOBTotal($datefrom, $dateto, 4);
			$OBDetailCSV = $manufacturedatTable->getOBDetailCSV(4);
			
	
			$this->set('ProdLondonMattress', $ProdLondonMattress);
			$this->set('ProdCardiffMattress', $ProdCardiffMattress);
			$this->set('ProdStockMattress', $ProdStockMattress);
			$this->set('ItemLondonMattress', $ItemLondonMattress);
			$this->set('ItemCardiffMattress', $ItemCardiffMattress);
			$this->set('ItemStockMattress', $ItemStockMattress);
			$this->set('OBLondonMattress', $OBLondonMattress);
			$this->set('OBCardiffMattress', $OBCardiffMattress);
			$this->set('OBStockMattress', $OBStockMattress);
			$this->set('ProdLondonBase', $ProdLondonBase);
			$this->set('ProdCardiffBase', $ProdCardiffBase);
			$this->set('ProdStockBase', $ProdStockBase);
			$this->set('ItemLondonBase', $ItemLondonBase);
			$this->set('ItemCardiffBase', $ItemCardiffBase);
			$this->set('ItemStockBase', $ItemStockBase);
			$this->set('OBLondonBase', $OBLondonBase);
			$this->set('OBCardiffBase', $OBCardiffBase);
			$this->set('OBStockBase', $OBStockBase);
			$this->set('ProdLondonTopper', $ProdLondonTopper);
			$this->set('ProdCardiffTopper', $ProdCardiffTopper);
			$this->set('ProdStockTopper', $ProdStockTopper);
			$this->set('ItemLondonTopper', $ItemLondonTopper);
			$this->set('ItemCardiffTopper', $ItemCardiffTopper);
			$this->set('ItemStockTopper', $ItemStockTopper);
			$this->set('OBLondonTopper', $OBLondonTopper);
			$this->set('OBCardiffTopper', $OBCardiffTopper);
			$this->set('OBStockTopper', $OBStockTopper);
			$this->set('ProdLondonTopperOnly', $ProdLondonTopperOnly);
			$this->set('ProdCardiffTopperOnly', $ProdCardiffTopperOnly);
			$this->set('ProdStockTopperOnly', $ProdStockTopperOnly);
			$this->set('ItemLondonTopperOnly', $ItemLondonTopperOnly);
			$this->set('ItemCardiffTopperOnly', $ItemCardiffTopperOnly);
			$this->set('ItemStockTopperOnly', $ItemStockTopperOnly);
			$this->set('OBLondonTopperOnly', $OBLondonTopperOnly);
			$this->set('OBCardiffTopperOnly', $OBCardiffTopperOnly);
			$this->set('OBStockTopperOnly', $OBStockTopperOnly);
			$this->set('ProdLondonLegs', $ProdLondonLegs);
			$this->set('ProdCardiffLegs', $ProdCardiffLegs);
			$this->set('ProdStockLegs', $ProdStockLegs);
			$this->set('ItemLondonLegs', $ItemLondonLegs);
			$this->set('ItemCardiffLegs', $ItemCardiffLegs);
			$this->set('ItemStockLegs', $ItemStockLegs);
			$this->set('OBLondonLegs', $OBLondonLegs);
			$this->set('OBCardiffLegs', $OBCardiffLegs);
			$this->set('OBStockLegs', $OBStockLegs);
			$this->set('ProdLondonHB', $ProdLondonHB);
			$this->set('ProdCardiffHB', $ProdCardiffHB);
			$this->set('ProdStockHB', $ProdStockHB);
			$this->set('ItemLondonHB', $ItemLondonHB);
			$this->set('ItemCardiffHB', $ItemCardiffHB);
			$this->set('ItemStockHB', $ItemStockHB);
			$this->set('OBLondonHB', $OBLondonHB);
			$this->set('OBCardiffHB', $OBCardiffHB);
			$this->set('OBStockHB', $OBStockHB);
			$this->set('ProdLondonTopperTotal', $ProdLondonTopperTotal);
			$this->set('ProdCardiffTopperTotal', $ProdCardiffTopperTotal);
			$this->set('ProdStockTopperTotal', $ProdStockTopperTotal);
			$this->set('ItemLondonTopperTotal', $ItemLondonTopperTotal);
			$this->set('ItemCardiffTopperTotal', $ItemCardiffTopperTotal);
			$this->set('ItemStockTopperTotal', $ItemStockTopperTotal);
			$this->set('OBLondonTopperTotal', $OBLondonTopperTotal);
			$this->set('OBCardiffTopperTotal', $OBCardiffTopperTotal);
			$this->set('OBStockTopperTotal', $OBStockTopperTotal);
			
			//debug($ProdLondonLegs);
			//die();
		}
		
		$LondonItemsProduced = $manufacturedatTable->getManufacturedAtData(2);
		$CardiffItemsProduced = $manufacturedatTable->getManufacturedAtData(1);
		
		//debug($smallbox);
		//die;
		$this->set('LondonItemsProduced', $LondonItemsProduced[0]);
		$this->set('CardiffItemsProduced', $CardiffItemsProduced[0]);
		
		

	}
	
	private function _edit()
    {
    	//debug($this->request->getData());
		$formData = $this->request->getData();
		$manufacturedatTable = TableRegistry::get('ManufacturedAt');
		$manufacturedatid = 2;
		//debug($shippingboxid);
		//die();
		$itemsproduceddata = $manufacturedatTable->find('all', array('conditions'=> array('ManufacturedAtID' => $manufacturedatid)));
    	$itemsproduceddata = $itemsproduceddata->toArray()[0];
		//debug($shippingboxdata);
		//die();
		$itemsproduceddata->NoItemsWeek = trim($formData['alondonNo']);
		$itemsproduceddata->WoodworkNoItems = trim($formData['londonNoW']);
		$itemsproduceddata->CuttingRoomNoItems = trim($formData['londonNoCR']);
		$itemsproduceddata->ProductionFloorNoItems = trim($formData['londonNoPF']);
		$itemsproduceddata->SpringCompletionNoItems = trim($formData['londonNoSC']);
		$itemsproduceddata->LegCompletionNoItems = trim($formData['londonNoLC']);
		$manufacturedatTable->save($itemsproduceddata);
		

		$manufacturedatid = 1;
		$itemsproduceddata = $manufacturedatTable->find('all', array('conditions'=> array('ManufacturedAtID' => $manufacturedatid)));
    	$itemsproduceddata = $itemsproduceddata->toArray()[0];
		//debug($shippingboxdata);
		//die();
		$itemsproduceddata->NoItemsWeek = trim($formData['acardiffNo']);
		$itemsproduceddata->WoodworkNoItems = trim($formData['cardiffNoW']);
		$itemsproduceddata->CuttingRoomNoItems = trim($formData['cardiffNoCR']);
		$itemsproduceddata->ProductionFloorNoItems = trim($formData['cardiffNoPF']);
		$itemsproduceddata->SpringCompletionNoItems = trim($formData['cardiffNoSC']);
		$manufacturedatTable->save($itemsproduceddata);

	}
	
	public function export() {
		$formData = $this->request->getData();
		$manufacturedatTable = TableRegistry::get('ManufacturedAt');
		
		$datefrom=$formData['datefrom'];
		$dateto=$formData['dateto'];
		$xmadeat=$formData['madeat'];
		$xtype=$formData['type'];
		$xcomp=$formData['comp'];
		
		if ($xmadeat==2) {
			$factory="London";
		} elseif ($xmadeat==1) {
			$factory="Cardiff";
		}
		 elseif ($xmadeat==4) {
			$factory="Stock";
		}
		
		if ($xtype=="prod" && $xcomp==1) {
			$theCSV = $manufacturedatTable->getMattressProdCSV($datefrom, $dateto, $xmadeat);
			$_header = [$factory ." Mattress Orders Produced between ". $datefrom . " to " .$dateto];
		} elseif ($xtype=="item" && $xcomp==1) {
			$theCSV = $manufacturedatTable->getMattressItemCSV($datefrom, $dateto, $xmadeat);
			$_header = [$factory ." Mattress Orders Items Produced between ". $datefrom . " to " .$dateto];
		}
		 elseif ($xtype=="OB" && $xcomp==1) {
			$theCSV = $manufacturedatTable->getMattressOBCSV($xmadeat);
			$_header = [$factory ." Mattress Order Book"];
		}
		if ($xtype=="prod" && $xcomp==3) {
			$theCSV = $manufacturedatTable->getBaseProdCSV($datefrom, $dateto, $xmadeat);
			$_header = [$factory ." Base Orders Produced between ". $datefrom . " to " .$dateto];
		} elseif ($xtype=="item" && $xcomp==3) {
			$theCSV = $manufacturedatTable->getBaseItemCSV($datefrom, $dateto, $xmadeat);
			$_header = [$factory ." Base Orders Items Produced between ". $datefrom . " to " .$dateto];
		}
		 elseif ($xtype=="OB" && $xcomp==3) {
			$theCSV = $manufacturedatTable->getBaseOBCSV($xmadeat);
			$_header = [$factory ." Base Order Book"];
		}
		$data = [];
		$title = ['Order No', 'Component', 'Special Instructions', 'Width', 'Length', 'Special Width 1', 'Special Length 1', 'Special Width 2', 'Special Length 2'];
		array_push($data, $title);
		
		foreach ($theCSV as $row) {
			//debug($row);
			//die();
			$a = [$row['order_number'],$row['n'],$row['x'],$row['w'],$row['l'],$row['specialwidth1'],$row['specialwidth2'],$row['speciallength1'],$row['speciallength2']];
			array_push($data, $a);
		}
		
		$this->setResponse($this->getResponse()->withDownload('itemsproduced.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $_header
    	]);

	}
	
	public function exporttopper() {
		$formData = $this->request->getData();
		$manufacturedatTable = TableRegistry::get('ManufacturedAt');
		$datefrom=$formData['datefrom'];
		$dateto=$formData['dateto'];
		$xmadeat=$formData['madeat'];
		$xtype=$formData['type'];
		$incexc=$formData['incexc'];

		if ($xmadeat==2) {
			$factory="London";
		} elseif ($xmadeat==1) {
			$factory="Cardiff";
		}
		 elseif ($xmadeat==4) {
			$factory="Stock";
		}
		
		if ($xtype=="prod" && $incexc=="inc") {
			$theCSV = $manufacturedatTable->getTopperProdCSV($datefrom, $dateto, $xmadeat);
			$_header = [$factory ." Topper Orders Produced between ". $datefrom . " to " .$dateto];
		} elseif ($xtype=="item" && $incexc=="inc") {
			$theCSV = $manufacturedatTable->getTopperItemCSV($datefrom, $dateto, $xmadeat);
			$_header = [$factory ." Topper Orders Items Produced between ". $datefrom . " to " .$dateto];
		}
		 elseif ($xtype=="OB" && $incexc=="inc") {
			$theCSV = $manufacturedatTable->getTopperOBCSV($xmadeat);
			$_header = [$factory ." Topper Order Book"];
		}
		
		if ($xtype=="prod" && $incexc=="exc") {
			$theCSV = $manufacturedatTable->getTopperOnlyProdCSV($datefrom, $dateto, $xmadeat);
			$_header = [$factory ." Topper Orders Produced between ". $datefrom . " to " .$dateto];
		} elseif ($xtype=="item" && $incexc=="exc") {
			$theCSV = $manufacturedatTable->getTopperOnlyItemCSV($datefrom, $dateto, $xmadeat);
			$_header = [$factory ." Topper Orders Items Produced between ". $datefrom . " to " .$dateto];
		}
		 elseif ($xtype=="OB" && $incexc=="exc") {
			$theCSV = $manufacturedatTable->getTopperOnlyOBCSV($xmadeat);
			$_header = [$factory ." Topper Order Book"];
		}
		
		$data = [];
		$title = ['Order No', 'Component', 'Special Instructions', 'Width', 'Length', 'Special Width 1', 'Special Length 1'];
		array_push($data, $title);
		
		foreach ($theCSV as $row) {
			//debug($row);
			//die();
			$a = [$row['order_number'],$row['n'],$row['x'],$row['w'],$row['l'],$row['specialwidth1'],$row['speciallength1']];
			array_push($data, $a);
		}
		
		
    	$this->setResponse($this->getResponse()->withDownload('Toppersproduced.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $_header
    	]);
	}
	
	public function exportlegs() {
		$formData = $this->request->getData();
		$manufacturedatTable = TableRegistry::get('ManufacturedAt');
		$datefrom=$formData['datefrom'];
		$dateto=$formData['dateto'];
		$xmadeat=$formData['madeat'];
		$xtype=$formData['type'];

		if ($xmadeat==2) {
			$factory="London";
		} elseif ($xmadeat==1) {
			$factory="Cardiff";
		}
		 elseif ($xmadeat==4) {
			$factory="Stock";
		}
		
		if ($xtype=="prod") {
			$theCSV = $manufacturedatTable->getLegsProdCSV($datefrom, $dateto, $xmadeat);
			$_header = [$factory ." Legs Orders Produced between ". $datefrom . " to " .$dateto];
		} elseif ($xtype=="item") {
			$theCSV = $manufacturedatTable->getLegsItemCSV($datefrom, $dateto, $xmadeat);
			$_header = [$factory ." Legs Orders Items Produced between ". $datefrom . " to " .$dateto];
		}
		 elseif ($xtype=="OB") {
			$theCSV = $manufacturedatTable->getLegsOBCSV($xmadeat);
			$_header = [$factory ." Legs Order Book"];
		}
		
		$data = [];
		$title = ['Order No', 'Component', 'Special Instructions', 'Height', 'Special Height', 'Leg Finish'];
		array_push($data, $title);
		
		foreach ($theCSV as $row) {
			//debug($row);
			//die();
			$a = [$row['order_number'],$row['n'],$row['x'],$row['w'],$row['specialheight'],$row['lf']];
			array_push($data, $a);
		}
		
    	$this->setResponse($this->getResponse()->withDownload('Legsproduced.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $_header
    	]);
	}
	
	public function exporthb() {
		$formData = $this->request->getData();
		$manufacturedatTable = TableRegistry::get('ManufacturedAt');
		$datefrom=$formData['datefrom'];
		$dateto=$formData['dateto'];
		$xmadeat=$formData['madeat'];
		$xtype=$formData['type'];
		if ($xmadeat==2) {
			$factory="London";
		} elseif ($xmadeat==1) {
			$factory="Cardiff";
		}
		 elseif ($xmadeat==4) {
			$factory="Stock";
		}
		
		if ($xtype=="prod") {
			$theCSV = $manufacturedatTable->getHBProdCSV($datefrom, $dateto, $xmadeat);
			$_header = [$factory ." Headboard Orders Produced between ". $datefrom . " to " .$dateto];
		} elseif ($xtype=="item") {
			$theCSV = $manufacturedatTable->getHBItemCSV($datefrom, $dateto, $xmadeat);
			$_header = [$factory ." Headboard Orders Items Produced between ". $datefrom . " to " .$dateto];
		}
		 elseif ($xtype=="OB") {
			$theCSV = $manufacturedatTable->getHBOBCSV($xmadeat);
			$_header = [$factory ." Headboard Order Book"];
		}
		
		$data = [];
		$title = ['Order No', 'Component', 'Special Instructions', 'Width', 'Height', 'Showroom', 'Fabric Company', 'Fabric Description', 'Fabric Special Instructions'];
		array_push($data, $title);
		
		foreach ($theCSV as $row) {
			//debug($row);
			//die();
			$a = [$row['order_number'],$row['n'],$row['x'],$row['w'],$row['l'],$row['adminheading'],$row['headboardfabric'],$row['headboardfabricchoice'],$row['headboardfabricdesc']];
			array_push($data, $a);
		}

		$this->setResponse($this->getResponse()->withDownload('headboardproduced.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $_header
    	]);		
	}
	
	public function exportOBdetail() {
		
		$manufacturedatTable = TableRegistry::get('ManufacturedAt');
		$xmadeat=$this->request->getQuery('madeat');
		if ($xmadeat==2) {
			$factory="London";
		} elseif ($xmadeat==1) {
			$factory="Cardiff";
		}
		 elseif ($xmadeat==4) {
			$factory="Stock";
		}
		
			$theCSV = $manufacturedatTable->getOBDetailCSV($xmadeat);
			$_header = [$factory ." Order Book"];
		
		$data = [];
		$title = ['Order No','Component','Model','Type','Ticking','Size','Width 1','Length 1','Width 2','Length 2','Production Date','Approx. Delivery Date'];
		array_push($data, $title);
		
		foreach ($theCSV as $row) {
			//debug($row);
			//die();
			$modelname='';
			$modeltype='';
			$ticking='';
			$size='';
			$width1='';
			$length1='';
			$width2='';
			$length2='';
			if ($row['ComponentID']==1) {
				$modelname=$row['savoirmodel'];
				$modeltype=$row['mattresstype'];
				$ticking=$row['tickingoptions'];
				$size='(w x l): ' .$row['mattresswidth'] .' x ' .$row['mattresslength'] ."\n";
				$width1=$row['mattresswidth'];
				$length1=$row['mattresslength'];
				if (substr($row['mattresswidth'], 0, 4)=='Spec') {
					if (isset($row['Matt1Width'])) {
						$size .= 'W: ' .$row['Matt1Width'] . "cm ";
						$width1=$row['Matt1Width'] . "cm ";
					}
				}
				if (substr($row['mattresswidth'], 0, 4)=='Spec' && substr($row['mattresslength'], 0, 4)=='Spec') {
					$size .= 'x ';
				}
				if (substr($row['mattresslength'], 0, 4)=='Spec') {
					if (isset($row['Matt1Length'])) {
						$size .= 'L: ' .$row['Matt1Length'] . "cm ";
						$length1=$row['Matt1Length'] . "cm ";
					}
				}
				if (isset($row['mattresstype'])) {
					if (substr($row['mattresstype'], 0, 3)=='Zip' && substr($row['mattresswidth'], 0, 4)=='Spec') {
					if (isset($row['Matt2Width'])) {
						$size .= 'W: ' .number_format($row['Matt2Width']) . "cm ";
						$width2=number_format($row['Matt2Width']) . "cm ";
						}
					}
				}
				if (isset($row['mattresstype'])) {
					if (substr($row['mattresstype'], 0, 3)=='Zip' && substr($row['mattresswidth'], 0, 4)=='Spec' && substr($row['mattresslength'], 0, 4)=='Spec') {
						$size .= ' x ';
					}
				}
				if (isset($row['mattresstype'])) {
					if (substr($row['mattresstype'], 0, 3)=='Zip' && substr($row['mattresslength'], 0, 4)=='Spec') {
					if (isset($row['Matt2Length'])) {	
						$size .= 'L: ' .number_format($row['Matt2Length']) . "cm ";
						$length2=number_format($row['Matt2Length']) . "cm ";
						}
					}
				}
			} elseif ($row['ComponentID']==3) {
				$modelname=$row['basesavoirmodel'];
				$modeltype=$row['basetype'];
				$ticking=$row['basetickingoptions'];
				$width1=$row['basewidth'];
				$length1=$row['baselength'];
				$size='(w x l): ' .$row['basewidth'] .' x ' .$row['baselength'] ."\n";
				if (substr($row['basewidth'], 0, 4)=='Spec') {
					if (isset($row['Base1Width'])) {
						$size .= 'W: ' .$row['Base1Width'] . "cm ";
						$width1=$row['Base1Width'] . "cm ";
						}
				}
				if (substr($row['basewidth'], 0, 4)=='Spec' && substr($row['baselength'], 0, 4)=='Spec') {
					$size .= 'x ';
				}
				if (isset($row['baselength'])) {
					if (substr($row['baselength'], 0, 4)=='Spec') {
						if (isset($row['Base1Length'])) {
							$size .= 'L: ' .$row['Base1Length'] . "cm ";
							$length1=$row['Base1Length'] . "cm ";
						}
					}
				}
				if ((substr($row['basetype'], 0, 3)=='Nor' || substr($row['basetype'], 0, 3)=='Eas') && substr($row['basewidth'], 0, 4)=='Spec') {
					if (isset($row['Base2Width'])) {
					$size .= 'W: ' .number_format($row['Base2Width']) . "cm ";
					$width2=number_format($row['Base2Width']) . "cm ";
					} else {
						$size .= 'W:';
						$width2= '';
					}
				}
				if ((substr($row['basetype'], 0, 3)=='Nor' || substr($row['basetype'], 0, 3)=='Eas') && substr($row['basewidth'], 0, 4)=='Spec' && substr($row['baselength'], 0, 4)=='Spec') {
					$size .= ' x ';
				}
				if ((substr($row['basetype'], 0, 3)=='Nor' || substr($row['basetype'], 0, 3)=='Eas') && substr($row['baselength'], 0, 4)=='Spec') {
					if (isset($row['Base2Length'])) {
						$size .= 'L: ' .$row['Base2Length'] . "cm ";
						$length2=$row['Base2Length'] . "cm ";
					}
				}
			} elseif ($row['ComponentID']==5) {
				$modelname=$row['toppertype'];
				$ticking=$row['toppertickingoptions'];
				$size='(w x l): ' .$row['topperwidth'] .' x ' .$row['topperlength'] ."\n";
				$width1=$row['topperwidth'];
				$length1=$row['topperlength'];
				if (substr($row['topperwidth'], 0, 4)=='Spec') {
					$size .= 'W: ' .$row['topper1Width'] . "cm ";
					$width1=$row['topper1Width'] . "cm ";
				}
				if (substr($row['topperwidth'], 0, 4)=='Spec' && substr($row['topperlength'], 0, 4)=='Spec') {
					$size .= 'x ';
				}
				if (substr($row['topperlength'], 0, 4)=='Spec') {
					$size .= 'L: ' .number_format($row['topper1Length']) . "cm ";
					$length1=number_format($row['topper1Length']) . "cm ";
				}
			} elseif ($row['ComponentID']==6) {
				$modelname=$row['valancefabricchoice'];
				$modeltype=$row['valancefabric'];
				
				$size='(w x l): ' .$row['valancewidth'] .' x ' .$row['valancelength'] . '. Drop: ' .$row['valancedrop'];
				$width1=$row['valancewidth'];
				$length1=$row['valancelength'];
			} elseif ($row['ComponentID']==7) {
				$modelname=$row['legstyle'];
				$modeltype=$row['legfinish'];
				if (isset($row['plh'])) {
					$size='Height: ' .$row['plh'] ."\n";
					$width1=$row['plh'];
					if (isset($row['plh'])) {
						if (substr($row['plh'], 0, 4)=='Spec') {
							$size .= 'Special Height: ' .$row['pslh'] . "cm ";
							$width1=$row['pslh'] . "cm ";
						}
					}
				}
			} elseif ($row['ComponentID']==8) {
				$modelname=$row['headboardstyle'];
				$modeltype=$row['headboardfabric'];
				$size='(w x h): ';
				if ($row['headboardWidth'] != '') {
					$size .= $row['headboardWidth'] .' '; 
					$width1=$row['headboardWidth'];
				}
					$size .= ' x '; 
				if ($row['headboardheight'] != '') {
					$size .= $row['headboardheight'];
					$length1=$row['headboardheight']; 
				}
			}
				
			
			$a = [$row['ORDER_NUMBER'],$row['Component'],$modelname,$modeltype,$ticking,$size,$width1,$length1,$width2,$length2,$this->_getFormattedDateFromRs($row, 'productiondate'),$this->_getFormattedDateFromRs($row, 'deliverydate')];
			array_push($data, $a);
		}
		
		$this->setResponse($this->getResponse()->withDownload('orderbook.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $_header
    	]);		
		
	}
	
	private function _getFormattedDateFromRs($row, $name) {
		$date = "";
		if (isset($row[$name])) {
			$date = date("d/m/Y", strtotime(substr($row[$name],0,10)));
		}
		return $date;
	}
	
	private function _getSafeValueFromForm($formData, $name) {
		$value = "";
		if (isset($formData[$name])) {
			$value = $formData[$name];
		}
		return $value;
	}
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR");
	}

}

?>