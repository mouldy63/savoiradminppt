<?php
// src/Controller/AccessoryController.php

namespace App\Controller;
use Cake\Datasource\ConnectionManager;

class AccessoryController extends SecureAppController {
	private $databaseName = 'orderaccessory';
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
		//5. Not a quote
		//6. Not on hold
		$orderQuery = "SELECT a.*, b.surname, b.title, b.first, c.location FROM purchase AS a, contact AS b, location AS c ".
				"WHERE a.accessoriesrequired='y' ".
				"AND a.completedorders = 'n' ".
				"AND a.contact_no <> 326314 ".
				"AND a.contact_no <> 324273 ".
				"AND a.contact_no <> 313820 ".
				"AND a.quote = 'n' ".
				"AND a.orderonhold = 'n' ".
				"AND a.ORDER_DATE > '2015-12-31' ".
				"AND (a.cancelled IS NULL OR a.cancelled <> 'y') ".
				"AND a.contact_no=b.CONTACT_NO ".
				"AND a.idlocation=c.idlocation ".
				"ORDER BY ".$orderBy." ".$order;
                $rows = $conn->execute($orderQuery)->fetchAll('assoc');
                
		$itemsInfo = array();
		foreach ($rows as $row){
				
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
			
			$productionsize = '';
			
			if( $row["mattressrequired"] == "y"){
				$temparray['mattressrequired'] = $row["mattressrequired"];
				
				if(strpos($row["mattresswidth"],'Special')!== false){
					if($productionsize == null || $productionsize == ''){
						$sql = "SELECT * FROM productionsizes AS a WHERE Purchase_No=".$row["PURCHASE_No"];
                                                $productionsize = $conn->execute($sql)->fetch('assoc');
					}
					if($productionsize != null && $productionsize != ''){
						if(!empty($productionsize['Matt2Width'])){
							$temp = $productionsize['Matt1Width']+$productionsize['Matt2Width']; 
							$temparray['mattresswidth'] = $temp.'cm';
						}
						else{
							$temparray['mattresswidth'] = $productionsize['Matt1Width'].'cm';
						}
						
					}
				}
				else{
					$temparray['mattresswidth'] = $row["mattresswidth"];
				}
				
				if(strpos($row["mattresslength"],'Special')!== false){
					if($productionsize == null || $productionsize == ''){
						$sql = "SELECT * FROM productionsizes AS a WHERE Purchase_No=".$row["PURCHASE_No"];
                                                $productionsize = $conn->execute($sql)->fetch('assoc');
					}
					if($productionsize != null && $productionsize != ''){
						$temparray['mattresslength'] = $productionsize['Matt1Length'].'cm';
						
					}
				}
				else{
					$temparray['mattresslength'] = $row["mattresslength"];
				}
			}
			else{
				$temparray['mattressrequired'] = 'n';
				$temparray['mattresswidth'] = null;
				$temparray['mattresslength'] = null;
			}
				
			if( $row["baserequired"] == "y"){
				$temparray['baserequired'] = $row["baserequired"];
				if(strpos($row["basewidth"],'Special')!== false){
					if($productionsize == null || $productionsize == ''){
						$sql = "SELECT * FROM productionsizes AS a WHERE Purchase_No=".$row["PURCHASE_No"];
                                                $productionsize = $conn->execute($sql)->fetch('assoc');
					}
					if($productionsize != null && $productionsize != ''){
						if(!empty($productionsize['Base2Width'])){
							if($row["basetype"] == 'North-South Split'){
								 $temp = $productionsize['Base1Width'] + $productionsize['Base2Width'];
								 $temparray['basewidth'] = $temp.'cm';
							}
							else{
								$temparray['basewidth'] = $productionsize['Base1Width'].'cm';
							}
						}
						else{
							$temparray['basewidth'] = $productionsize['Base1Width'].'cm';
						};
						
					}
				}
				else{
					$temparray['basewidth'] = $row["basewidth"];
				}
				if(strpos($row["baselength"],'Special')!== false){
					if($productionsize == null || $productionsize == ''){
						$sql = "SELECT * FROM productionsizes AS a WHERE Purchase_No=".$row["PURCHASE_No"];
                                                $productionsize = $conn->execute($sql)->fetch('assoc');
					}
					if($productionsize != null && $productionsize != ''){
						if(!empty($productionsize['Base2Width'])){
							if($row["basetype"] == 'East-West Split'){
								$temparray['baselength'] = (floatval($productionsize['Base1Length']) +
										floatval($productionsize['Base2Length'])).'cm';
							}
							else{
								$temparray['baselength'] = $productionsize['Base1Length'].'cm';
							}
						}
						else{
							$temparray['baselength'] = $productionsize['Base1Length'].'cm';
						};
						
					}
				}
				else{
					$temparray['baselength'] = $row["baselength"];
				}
			}
			else{
				$temparray['baserequired'] = 'n';
				$temparray['basewidth'] = null;
				$temparray['baselength'] = null;
			}
				
			if( $row["topperrequired"] == "y"){
				$temparray['topperrequired'] = $row["topperrequired"];
				if(strpos($row["topperwidth"],'Special')!== false){
					if($productionsize == null || $productionsize == ''){
						$sql = "SELECT * FROM productionsizes AS a WHERE Purchase_No=".$row["PURCHASE_No"];
						$productionsize = $conn->execute($sql)->fetch('assoc');
					}
					if($productionsize != null && $productionsize != ''){
						$temparray['topperwidth'] = $productionsize['topper1Width'].'cm';
					}
				}
				else{
					$temparray['topperwidth'] = $row["topperwidth"];
				}
				if(strpos($row["topperlength"],'Special')!== false){
					if($productionsize == null || $productionsize == ''){
						$sql = "SELECT * FROM productionsizes AS a WHERE Purchase_No=".$row["PURCHASE_No"];
						$productionsize = $conn->execute($sql)->fetch('assoc');
					}
					if($productionsize != null && $productionsize != ''){
						$temparray['topperlength'] = $productionsize['topper1Length'].'cm';
					}
				}
				else{
					$temparray['topperlength'] = $row["topperlength"];
				}
			}
			else{
				$temparray['topperrequired'] = 'n';
				$temparray['topperwidth'] = null;
				$temparray['topperlength'] = null;
			}
			//Get Order Location information from table location.
			$temparray['order_source'] = $row['location'];
			$temparray["purchase_number"] = $row["PURCHASE_No"];
			$temparray["order_date"] = $this->dateFormatChange($row["ORDER_DATE"]);
			$temparray["amended_date"] = $this->dateFormatChange($row["AmendedDate"]);
			$temparray["productiondate"] = $this->dateFormatChange($row["productiondate"]);
			$temparray["bookeddeliverydate"] = $this->dateFormatChange($row["bookeddeliverydate"]);
			//Get progress of the order from table $this->databaseName based on the Purchase_No.
			$query = "SELECT * FROM ".$this->databaseName." WHERE purchase_no=". $row["PURCHASE_No"] ." ORDER BY orderaccessory_id ASC";
                        $itemInfo = $conn->execute($query)->fetchAll('assoc');
			// Get Base Fabric progress status, if there is no status assign one based on other information
				
			$temparray['accessories'] = $this->accessoriesArrayGenerate($conn,$row,$itemInfo);
			if(!empty($temparray['accessories'])){
				$temparray['accessory_quantity'] = count($temparray['accessories']);
			}
			else{
				$temparray['accessory_quantity'] = 0;
			}
			array_push($itemsInfo, $temparray);
		}

                //Delete those orders that all of the fabrics have been approved
		$outputArray=array();

		foreach($itemsInfo as $info){
			if($info['accessory_quantity']>0){
				$isDelivered = true;
				foreach($info['accessories'] as $accessory){
					if($accessory['status_id']!='70'&&!(empty($accessory['status_id'])||$accessory['status_id']=='')){
						$isDelivered = false;
						continue;
					}
				}
				if(!$isDelivered){
					array_push($outputArray, $info);
				}
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
	private function accessoriesArrayGenerate($conn,$row,$itemInfo){
		// Get Base Fabric progress status, if there is no status assign one based on other information
		$tempItems = array();
		if($itemInfo && count($itemInfo)>0){
			foreach ($itemInfo as $item){
				$tempItem = array();
				$tempItem['description'] = $item['description'];
				$tempItem['status_id'] = $this->statusCalculator($item);
				$tempItem['ponumber'] = $item['POnumber'];
				$tempItem['supplier'] = $item['Supplier'];
				$tempItem['design'] = $item['design'];
				$tempItem['colour'] = $item['colour'];
				$tempItem['size'] = $item['size'];
				$tempItem['unit'] = $item['unitprice'];
				$tempItem['podate'] = $this->dateFormatChange($item['PODate']);
				$tempItem['qty'] = $item['qty'];
				$tempItem['surname'] = $row['surname'];
				if(!empty($tempItem["status_id"])&&$tempItem["status_id"]!=''){
					$query = "SELECT QC_status FROM qc_status AS a WHERE QC_statusID=".$tempItem["status_id"];
                                        $temp_status_word = $conn->execute($query)->fetch('assoc');
					$tempItem["status_word"] = $temp_status_word["QC_status"];
				}
				else{
					$tempItem["status_word"]= null;
				}
				array_push($tempItems, $tempItem);
			}
			
		}
		else{

			$tempItems = null;

		}
		return $tempItems;
	}
	private function statusCalculator($item){
		if(empty($item['Status'])){
			$status = -1;
			if ($item['description']!=""){
				$status = 100;
			}
			if($item['POnumber']!=""){
				$status = 10;
			}
			if($item['Received']!=""){
				$status = 10;
			}
			if($item['Checked']!=""){
				$status = 120;
			}
			if($item['Delivered']!=""&&$item['Delivered']>0){
				$status = 70;
			}
			if($item['QtyToFollow']!=""&&$item['QtyToFollow']>0){
				$status = 130;
			}
			if($status<0){
				$status = null;
			}
			return $status;
		}
		return $item['Status'];
	}
	private function dateFormatChange($date){
		if(!empty($date))
		{
			return date('d/m/Y',strtotime($date));
		}
		return null;
	}
    
    protected function _getAllowedRoles() {
    	return array("ADMINISTRATOR");
    }
}
?>