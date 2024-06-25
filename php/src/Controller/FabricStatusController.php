<?php
namespace App\Controller;
use Cake\Database\Connection;
use Cake\Datasource\ConnectionManager;

class FabricStatusController extends SecureAppController {
	private $databaseName = 'qc_history_latest';
	public function index(){
                $conn = ConnectionManager::get('default');
		$filter = null;
		if( $this->request->is('ajax') || $this->request->is('post')){
			$request = $this->request->input('json_decode');
			$filter = $request->filter;
			
			$orderby = $request->orderby;
			$orderId = $request->order;
			switch($orderId){
				case '1':
					$order = 'ASC';
					break;
				case '2':
					$order = 'DESC';
					break;
				default:
					$order = 'DESC';
			}
			switch($orderby){
				case '1':
					$orderBy = 'b.surname';
					break;
				case '2':
					$orderBy = 'a.companyname';
					break;
				case '3':
					$orderBy = 'c.location';
					break;
				case '4':
					$orderBy = 'a.ORDER_NUMBER';
					break;
				case '5':
					$orderBy = 'a.ORDER_DATE';
					break;
				case '6':
					$orderBy = 'a.productiondate';
					break;
				case '7':
					$orderBy = 'a.bookeddeliverydate';
					break;
				default:
					$orderBy = 'a.ORDER_DATE';
					break;
			}
		}
		else{
			$filter = null;
			$orderBy = "a.ORDER_DATE";
			$order = "DESC";
		}
		// Get orders which are 
		//1. not finished 
		//2. have at least one fabric not null among basefabric, headboardfabric and valancefabric.
		//3. not a test order
		//4. From 2016
		$orderQuery = "SELECT a.*, b.surname, b.title, b.first, c.location FROM purchase AS a, contact AS b, location AS c ".
				"WHERE ((a.baserequired='y' AND (a.upholsteredbase ='Yes' OR a.upholsteredbase ='Yes, Com')) ".
				"OR (a.headboardrequired ='y') ".
				"OR (a.valancerequired ='y')) ".
				"AND a.completedorders = 'n' ".
				"AND a.quote = 'n' ".
				"AND a.orderonhold = 'n' ".
				"AND a.contact_no <> 326314 ".
				"AND a.contact_no <> 324273 ".
				"AND a.contact_no <> 313820 ".
				"AND a.ORDER_DATE > '2015-12-31' ".
				"AND (a.cancelled IS NULL OR a.cancelled <> 'y') ".
				"AND a.contact_no=b.CONTACT_NO ".
				"AND a.idlocation=c.idlocation ".
				"ORDER BY ".$orderBy." ".$order;
                $purchase = $conn->execute($orderQuery)->fetchAll('assoc');

		$fabricstatusInfo = array();
		foreach ($purchase as $row){
			
			$temparray = array();
			if (isset($row["companyname"])) {
			$temparray["companyname"] = trim($row["companyname"]);
			} else {
			$temparray["companyname"]='';
			}
			$temparray["order_number"] = $row["ORDER_NUMBER"];
			
			//Get Customer name information from table contact.
			$temparray["contact_no"] = $row["contact_no"];
			$temparray["customer"] =$row['surname'].', '.$row['title'].' '.$row['first'];
			
			//Get Order Location information from table location.
			$temparray['order_source'] = $row['location'];
			$temparray["purchase_number"] = $row["PURCHASE_No"];
			$temparray["order_date"] = $this->dateFormatChange($row["ORDER_DATE"]);
			$temparray["productiondate"] = $this->dateFormatChange($row["productiondate"]);
			$temparray["bookeddeliverydate"] = $this->dateFormatChange($row["bookeddeliverydate"]);
			//Get progress of the order from table $this->databaseName based on the Purchase_No.
			$query = "SELECT * FROM ".$this->databaseName." WHERE Purchase_No=". $row["PURCHASE_No"] ." ORDER BY QC_Date DESC";
                        $allfabricsInfo = $conn->execute($query)->fetchAll('assoc');
			

			$basefabricsInfo = array();
			$hbfabricsInfo = array();
			$valancefabricsInfo = array();
			
			// Group all $this->databaseName according to its compoentid.
			foreach ($allfabricsInfo as $info){
				if($info['ComponentID'] == 3){
					array_push($basefabricsInfo, $info);
				}
				if($info['ComponentID'] == 8){
					array_push($hbfabricsInfo, $info);
				}
				if($info['ComponentID'] == 6){
					array_push($valancefabricsInfo, $info);
				}
			}

			// Get Base Fabric progress status, if there is no status assign one based on other information 
			
			$temparray['basefabric'] = $this->fabricArrayGenerate(3,$row,$basefabricsInfo);
			
			// Get Headboard Fabric progress status, if there is no status assign one based on other information
			$temparray['hbfabric'] = $this->fabricArrayGenerate(8,$row,$hbfabricsInfo);

			// Get Valance Fabric progress status, if there is no status assign one based on other information
			$temparray['valancefabric'] = $this->fabricArrayGenerate(6,$row,$valancefabricsInfo);
			array_push($fabricstatusInfo, $temparray);
		}
		//Delete those orders that all of the fabrics have been approved
		$outputArray=array();
		
		foreach($fabricstatusInfo as $info){
				if(
						($info['valancefabric']['fabricstatus']==6||empty($info['valancefabric']['fabricstatus']))&&
						($info['hbfabric']['fabricstatus']==6||empty($info['hbfabric']['fabricstatus']))&&
						($info['basefabric']['fabricstatus']==6||empty($info['basefabric']['fabricstatus'])))
				{
				
				}
				else{
					if(($this->request->is('ajax') || $this->request->is('post'))&&!(empty($filter)||$filter=='')){
						if($info['valancefabric']['fabricstatus']==(int)$filter||
								$info['hbfabric']['fabricstatus']==(int)$filter||
								$info['basefabric']['fabricstatus']==(int)$filter)
						{
							array_push($outputArray,$info);
						}
					}
					else{
						array_push($outputArray,$info);
					}
					//array_push($outputArray,$info);
					
				}
		}
		//$outputArray = $fabricstatusInfo;
		if( $this->request->is('ajax') || $this->request->is('post')){
			echo json_encode($outputArray);
			die();
		}
                $this->viewBuilder()->setLayout('fabricstatus');
		$this->set('msg',$outputArray);
	}
	private function fabricArrayGenerate($componentid, $row,$fabricsInfo){
		// Get Base Fabric progress status, if there is no status assign one based on other information
		$fabric = '';
		$require = '';
		$tempFabric = array();
		switch ($componentid){
			case 3:
				$fabric = 'basefabric';
				$require = 'basesavoirmodel';
				break;
			case 8:
				$fabric = 'headboardfabric';
				$require = 'headboardstyle';
				break;
			case 6:
				$fabric = 'valancefabric';
				$require = 'valancefabricchoice';
				break;
		}

		
		$isFabricNeeded = false;
		if(count($fabricsInfo)>0){
			if(!empty($row[$fabric])&&$row[$fabric]!=''){
				$isFabricNeeded = true;
			}
			else{
				$isQCFabricStatusEmpty = $fabricsInfo[0]['fabricstatus'];
				if(!empty($isQCFabricStatusEmpty)&&$isQCFabricStatusEmpty!=""){
					$isFabricNeeded = true;
				}	
			}
		}
		if($componentid ==3){
			if($row['upholsteredbase'] =='n' || $row['upholsteredbase'] =='No' || $row['upholsteredbase'] =='--'){
				$isFabricNeeded = false;
			}
		}
		if($isFabricNeeded){
		
			$fabricsInfo = $fabricsInfo[0];
			$tempFabric['madeat'] = $this->madeAtTranslate($fabricsInfo['MadeAt']);
			$tempFabric['required'] = $row[$require];
			$tempFabric["qc_status_id"] =$fabricsInfo['QC_StatusID'];
			$tempFabric["ponumber"] = $fabricsInfo['PONumber'];
			$tempFabric["podate"] = $this->dateFormatChange($fabricsInfo['PODATE']);
			$tempFabric["supplier"] = $fabricsInfo['supplier'];
			$tempFabric["expected"] = $this->dateFormatChange($fabricsInfo['FabricExpected']);
			$tempFabric["received"] = $this->dateFormatChange($fabricsInfo['FabricReceived']);
			$tempFabric["cuttingsent"] = $this->dateFormatChange($fabricsInfo['CuttingSent']);
			$tempFabric["confirm"] = $this->dateFormatChange($fabricsInfo['ConfirmedDate']);
			$tempFabric["tocardiff"] = $this->dateFormatChange($fabricsInfo['SentToBCW']);
			$tempFabric["surname"] = $row['surname'];
			$tempFabric["qc_status_word"] = null;
			if($tempFabric["qc_status_id"] == 0 ||
					$tempFabric["qc_status_id"] == 2 ||
					$tempFabric["qc_status_id"] == 4 ||
					$tempFabric["qc_status_id"] == 80 ||
					$tempFabric["qc_status_id"] == 90 ){
						$tempFabric["qc_status_word"] = $this->qcStatusTranslate($tempFabric["qc_status_id"]);
			}
			$tempFabric['fabricstatus'] = null;
			$tempFabric['fabricstatus_word'] = null;
			//If there is no status, assign one based on the other information
			$caculateStatus = $this->caculateFabricStatus($row,$fabricsInfo);
			if(!empty($fabricsInfo['fabricstatus']) &&
					$fabricsInfo['fabricstatus']!=""){
				$tempFabric['fabricstatus'] = $fabricsInfo['fabricstatus'];
				$tempFabric['fabricstatus_word'] = $this->fabricStatusTranslate($fabricsInfo['fabricstatus']);
			}
			else{
				
				if($caculateStatus>0){
					$tempFabric['fabricstatus'] = $caculateStatus;
					$tempFabric['fabricstatus_word'] = $this->fabricStatusTranslate($caculateStatus);
				}else{
					$tempFabric['fabricstatus'] = null;
					$tempFabric['fabricstatus_word'] = null;
				}
			}
		}
		else{
		
			$tempFabric['madeat'] = null;
			$tempFabric['required'] = null;
			$tempFabric['fabricstatus'] = null;
			$tempFabric["qc_status_id"] = null;
			$tempFabric["qc_status_word"] = null;
			$tempFabric["ponumber"] = null;
			$tempFabric["podate"] = null;
			$tempFabric["supplier"] = null;
			$tempFabric["expected"] = null;
			$tempFabric["received"] = null;
			$tempFabric["cuttingsent"] = null;
			$tempFabric["confirm"] = null;
			$tempFabric["tocardiff"] = null;
			$tempFabric["surname"] = null;
			$tempFabric['fabricstatus'] = null;
			$tempFabric['fabricstatus_word'] = null;
		}
		return $tempFabric;
	}
	private function qcStatusTranslate($id){
		switch ($id){
			case 0:
				return 'Awaiting Confirmation';
				break;
			case 2:
				return 'Confirmed, Waiting to Check';
				break;
			case 4:
				return 'Showroom to Amend';
				break;
			case 80:
				return 'Item Cancelled';
				break;
			case 90:
				return 'Order On Hold';
				break;
			default:
				return null;
		}
	}
	private function caculateFabricStatus($record, $qcrecord){
		$status = -1;
		
		if($record["upholsteredbase"]=="TBC"){
			$status = 1;
		}
		if($record["upholsteredbase"]=="Yes"){
			$status = 1;
		}
		if($record["upholsteredbase"]=="Yes, Com"){
			$status = 2;
		}
		if($record["upholsteredbase"]!=""){
			$status = 3;
		}
		
		if($qcrecord['PONumber']!=''){
			$status = 4;
		}
		if($qcrecord['FabricReceived']!=''){
			$status = 7;
		}
		if($qcrecord['CuttingSent']!=''){
			$status = 5;
		}
		if($qcrecord['ConfirmedDate']!=''){
			$status = 6;
		}
		return $status;
	}
	private function dateFormatChange($date){
		if(!empty($date))
		{
			return date('d/m/Y',strtotime($date));
		}
		return null;
	}
	private function madeAtTranslate($code){
		switch ($code){
			case 1:
				return 'cardiff';
				break;
			case 2:
				return 'london';
				break;
			case 4:
				return 'stock item';
				break;
			default:
				return null;
		}	
	}
	private function fabricStatusTranslate($status){
		switch ($status){
			case 1:
				return 'TBC';
				break;
			case 2:
				return 'COM';
				break;
			case 3:
				return 'Selected';
				break;
			case 4:
				return 'On Order';
				break;
			case 5:
				return 'Not Approved, CFA Sent';
				break;		
			case 6:
				return 'Approved';
				break;
			case 7:
				return 'Fabric Received';
				break;
			case 8:
				return 'Fabric Cut & Machined';
				break;
			default:
				return null;
				break;
			
		}
	}
	public function qctest(){
		if( $this->request->is('ajax') || $this->request->is('post')){
			$data = $this->request->input('json_decode');
			$cmd = $data->cmd;
			if($cmd == 'cmd1'){
				$aReturn = ['info'=>$cmd,'news'=>'I received cmd1.'];
			}
			else{
				$aReturn = ['info'=>$cmd,'news'=>'I received cmd1.'];
			}
			//$this->set('_serialize', $aReturn);
			echo json_encode($aReturn);
			die();
		}
		$this->loadModel('Purchase');
		$orderQuery = "SELECT a.*, b.surname, b.title, b.first, c.location FROM purchase AS a, contact AS b, Location AS c ".
				"WHERE ((a.basefabric IS NOT NULL AND a.basefabric <>'') ".
				"OR (a.headboardfabric IS NOT NULL AND a.headboardfabric <>'') ".
				"OR (a.valancefabric IS NOT NULL AND a.valancefabric <>'')) ".
				"AND a.completedorders = 'n' ".
				"AND a.contact_no <> 326314 ".
				"AND a.contact_no <> 324273 ".
				"AND a.contact_no <> 313820 ".
				"AND a.ORDER_DATE > '2015-12-31' ".
				"AND (a.cancelled IS NULL OR a.cancelled <> 'y') ".
				"AND a.contact_no=b.CONTACT_NO ".
				"AND a.idlocation=c.idlocation ".
				"ORDER BY c.location desc";
                $conn = ConnectionManager::get('default');
                $msg = $conn->execute($orderQuery)->fetchAll('assoc');
		$this->set('msg',$msg);
	}
   	protected function _getAllowedRoles() {
    	return array("ADMINISTRATOR");
    }
}
?>