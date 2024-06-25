<?php
namespace App\Controller;
use Cake\ORM\TableRegistry;
use Cake\Http\Session;

class ServicesController extends AppController {
	public $uses = false;
	public $autoRender = false;
	public $imageFilenameExtensions = array("jpg", "jpeg", "gif", "png" , "bmp");
	public $docFilenameExtensions = array("doc", "docx", "rtf");
	private $CAMERAIMAGEUPLOADPATH;
    private $PurchaseAttachment;
	
	public function initialize() : void {
        parent::initialize();
		$this->loadComponent('GoogleDrive');
		$this->loadComponent('PhpThumb');
	}
        
	public function closeSession() {
        $this->autoRender = false;
		$session = new Session();
		$session->destroy();
		return $this->redirect('/home');
	}

	public function workDaysInPeriod($monthYearFrom, $monthYearTo) {
        $this->viewBuilder()->setLayout('ajax');
    	
    	$fromMonth = substr($monthYearFrom, 0, 2);
    	$fromYear = substr($monthYearFrom, 2, 4);
    	$from = '01-'.$fromMonth.'-'.$fromYear;

    	$toMonth = substr($monthYearTo, 0, 2);
    	$toYear = substr($monthYearTo, 2, 4);
    	$daysInMonth = cal_days_in_month(CAL_GREGORIAN, $toMonth, $toYear);
    	$to = $daysInMonth.'-'.$toMonth.'-'.$toYear;
    	
    	$url = "http://www.kayaposoft.com/enrico/json/v1.0/index.php?action=getPublicHolidaysForDateRange&country=eng&fromDate=$from&toDate=$to";
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_HEADER, false);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 0);
		curl_setopt($ch, CURLOPT_FORBID_REUSE, true);
		$result = json_decode(curl_exec($ch));
		curl_close($ch);
		unset($ch);
    	$numBankHolidays = sizeof($result);
    	   
    	$workDaysInMonth = $this->_countDays(1, $fromMonth, $fromYear, $daysInMonth, $toMonth, $toYear);
    	$this->response = $this->response->withStringBody($workDaysInMonth-$numBankHolidays);
    }
    
    public function saveVappFormData($userId, $madeAt, $monthYearFrom, $monthYearTo, $data) {
        $this->viewBuilder()->setLayout('ajax');
    	$data = $this->_cleanData($data);
    	$this->loadModel('VappInputData');
    	
    	if ($monthYearFrom == 'null') $monthYearFrom = null;
    	if ($monthYearTo == 'null') $monthYearTo = null;
    	 
    	$existingRow = $this->VappInputData->find('first', array('conditions'=> array(
    			'month_year_from' => $monthYearFrom, 
    			'month_year_to' => $monthYearTo, 
    			'madeat' => $madeAt)));
    	
    	if (count($existingRow) > 1) {
    		$msg = "ERROR - duplicate VAPP rows for this madeat and from/to dates";
    	} else if (count($existingRow) == 0) {
    		$this->VappInputData->create();
	    	$this->VappInputData->save(array(
	    			'month_year_from' => $monthYearFrom, 
	    			'month_year_to' => $monthYearTo, 
	    			'madeat' => $madeAt, 
	    			'formdata' => $data));
    		$msg = "VAPP input data saved";
    	} else {
	    	$this->VappInputData->save(array(
	    			'vapp_input_data_id' => $existingRow['VappInputData']['vapp_input_data_id'], 
	    			'month_year_from' => $monthYearFrom, 
	    			'month_year_to' => $monthYearTo, 
	    			'madeat' => $madeAt, 
	    			'formdata' => $data));
    		$msg = "VAPP input data updated";
    	}
    	 
    	$this->response = $this->response->withStringBody($msg);
    }
    
    public function getVappFormData($userId, $madeAt, $monthYearFrom, $monthYearTo) {
        $this->viewBuilder()->setLayout('ajax');
    	$this->loadModel('VappInputData');
    	
    	if ($monthYearFrom == 'null') $monthYearFrom = null;
    	if ($monthYearTo == 'null') $monthYearTo = null;
    	
    	$existingRow = $this->VappInputData->find('first', array('conditions'=> array(
    			'month_year_from' => $monthYearFrom, 
    			'month_year_to' => $monthYearTo, 
    			'madeat' => $madeAt)));
    	//echo var_dump($existingRow);
    	//die;
    	
    	if (count($existingRow) > 1) {
    		$msg = "ERROR - duplicate VAPP rows for this madeat and from/to dates";
    		$data = null;
    	} else if (count($existingRow) == 0) {
    		$msg = "Warning - no VAPP input exists for this madeat and from/to dates";
    		$data = null;
    	} else {
    		$data = $existingRow['VappInputData']['formdata'];
    	}
    	 
    	$this->response = $this->response->withStringBody($data);
    }
    
    function _countDays($fromDay, $fromMonth, $fromYear, $toDay, $toMonth, $toYear) {
    	$ignore = array(0, 6);
    	$count = 0;
    	$counter = mktime(0, 0, 0, $fromMonth, $fromDay, $fromYear);
    	$end = mktime(0, 0, 0, $toMonth, $toDay, $toYear);
    	while ($counter <= $end) {
    		if (in_array(date("w", $counter), $ignore) == false) {
    			$count++;
    		}
    		$counter = strtotime("+1 day", $counter);
    	}
    	return $count;
    }

    function _cleanData($data) {
   		$data = $this->_removeParamFromData($data, "log");
   		return $data;
    }
    function _removeParamFromData($data, $paramName) {
    	if (is_numeric(strpos($data,$paramName.'='))) {
    		$pos1 = strpos($data,$paramName.'=');
    		$pos2 = strpos($data,"&", $pos1+1);
   			if ($pos2 > 0) {
   				$data = substr_replace($data, "", $pos1, $pos2-$pos1+1);
   			} else {
   				$data = substr_replace($data, "", $pos1);
   			}
    	}
    	return $data;
    }
    
    function dropzoneUpload($pn, $orderNum, $userId, $type) {
    
    	error_reporting(0); // so we don't get 'SSL certificate problem, verify that the CA cert is OK ...' warning
        $this->viewBuilder()->setLayout('ajax');
        $this->PurchaseAttachment = TableRegistry::get('PurchaseAttachment');
    	//print_r($_FILES);
    	//return;
    	
    	if (!is_uploaded_file($_FILES['file']['tmp_name'])) {
    		$this->response = $this->response->withStringBody("Invalid file content");
    		return;
   		}
    	
    	if (!$this->_validateUploadFileName($_FILES['file']['name'])) {
    		$this->response = $this->response->withStringBody("Invalid file name");
    		return;
    	}
    	
    	$newFileName = $orderNum . '-' . $_FILES['file']['name'];
    	$mimeType = $_FILES['file']['type'];
    	
    	$createdFile = $this->GoogleDrive->uploadFile($_FILES['file']['tmp_name'], $newFileName, '', $mimeType);
    	$fileId = $createdFile->id;
    	
    	$thumbnail = $this->_createAttachmentThumbnail($_FILES['file']['tmp_name'], $newFileName, $mimeType, true);
    	
    	$msg = $this->_upsertPurchaseAttachmentRow($pn, $newFileName, 'googledrive', $mimeType, $thumbnail, $fileId, $userId, $type);
    	if (isset($msg)) {
    		$this->response = $this->response->withStringBody($msg);
    		return;
    	}
    	
    	$this->response = $this->response->withStringBody("OK");
   		return;
    	
		
    	$this->response = $this->response->withStringBody("File uploaded successfully");
    }
    
    function processCameraImageUploads() {
    	$this->loadModel('Purchase');
        $this->PurchaseAttachment = TableRegistry::get('PurchaseAttachment');
        $this->viewBuilder()->setLayout('ajax');
    	set_time_limit(180); // as this can take a while to run
    	
	 $this->CAMERAIMAGEUPLOADPATH = $_SERVER["DOCUMENT_ROOT"] . "/cameraimageuploads";
    
    	$list = scandir($this->CAMERAIMAGEUPLOADPATH);
		foreach($list as $file) {
    		if (!is_dir("$this->CAMERAIMAGEUPLOADPATH/$file")) {
        		echo "<br><br>Processing $file";
        		if (!$this->_doCameraImageUpload($file)) {
			    	$this->response = $this->response->withStringBody("<br>Processing of $file failed");
			   		return;
        		}
    		}
		}
   		$this->response = $this->response->withStringBody("<br>Processing completed successfully");
    }
    
    function _doCameraImageUpload($fileName) {
    
    	
    	$temp = explode(".", $fileName);
    	if (strtolower($temp[1]) == "jpg" || strtolower($temp[1]) == "jpeg") {
    		$mimeType = "image/jpeg";
    	} else if (strtolower($temp[1]) == "png") {
    		$mimeType = "image/png";
    	} else if (strtolower($temp[1]) == "gif") {
    		$mimeType = "image/gif";
    	} else {
    		echo "<br>Invalid file type: " . $temp[1];
    		return false;
    	}
    	
    	$delimiter = "-";
    	if (strrpos($temp[0], "_") !== false) {
	    	$delimiter = "_";
    	}
   		echo "<br>Trying delimiter: " . $delimiter;
    	
    	$vals = explode($delimiter, $temp[0]);
    	
    	if (count($vals) < 1) {
    		echo "<br>Invalid file name: " . $fileName;
    		return false;
    	}

	$orderNumber = $vals[0];
    	echo "<br>orderNumber=$orderNumber";

    	$purchaseRow = $this->Purchase->find('all', array('conditions'=> array('ORDER_NUMBER' => $orderNumber)))->toArray();
    	if (count($purchaseRow) != 1) {

    		// try with the other delimiter
        	$delimiter = "-";
       		echo "<br>Trying delimiter: " . $delimiter;
        	$vals = explode($delimiter, $temp[0]);
        	if (count($vals) < 1) {
        		echo "<br>Invalid file name: " . $fileName;
        		return false;
        	}
    		
    		$orderNumber = $vals[0];
        	echo "<br>orderNumber=$orderNumber";

        	$purchaseRow = $this->Purchase->find('all', array('conditions'=> array('ORDER_NUMBER' => $orderNumber)))->toArray();
        	if (count($purchaseRow) != 1) {
    		echo "<br>Incorrect number of rows found: " . count($purchaseRow);
    		return false;
    	}
    	}
	$pn = $purchaseRow[0]['PURCHASE_No'];
    	echo "<br>pn=$pn";
    	echo "<br>date=".date("Y/m/d h:i:sa");
    	
    	$createdFile = $this->GoogleDrive->uploadFile("$this->CAMERAIMAGEUPLOADPATH/$fileName", $fileName, '', $mimeType);
    	$fileId = $createdFile->id;
    	echo "<br>fileId=$fileId";
    	
    	$thumbnail = $this->_createAttachmentThumbnail("$this->CAMERAIMAGEUPLOADPATH/$fileName", $fileName, $mimeType, false);
    	//echo "<br>thumbnail=$thumbnail";
    	
    	$msg = $this->_upsertPurchaseAttachmentRow($pn, $fileName, 'googledrive', $mimeType, $thumbnail, $fileId, '1', 'exit');
    	if (isset($msg)) {
    		echo '<br>'.$msg;
    		return false;
    	}
		unlink("$this->CAMERAIMAGEUPLOADPATH/$fileName");
    	
   		echo "<br>File processed successfully";
   		return true;
    }

    function _upsertPurchaseAttachmentRow($pn, $fileName, $host, $mimeType, $thumbnail, $id, $userId, $type) {

		$msg = null;
    	$existingRow = $this->PurchaseAttachment->find('all', array('conditions'=> array(
    			'purchase_no' => $pn, 
    			'filename' => $fileName,
    			'type' => $type)))->toArray();
    	
    	if (count($existingRow) > 1) {
    		$msg = "ERROR - duplicate purchase attachment rows for this purchase and filename";
    	} else if (count($existingRow) == 0) {
    		$attch = $this->PurchaseAttachment->newEntity([]);
                $attch->set(array(
	    			'purchase_no' => $pn, 
	    			'filename' => $fileName, 
	    			'host' => $host, 
	    			'mimetype' => $mimeType, 
	    			'thumbnail' => $thumbnail, 
	    			'id' => $id,
	    			'user_id' => $userId,
	    			'type' => $type,
	    			'upload_date' => date('Y-m-d H:i:s')));
	    	$this->PurchaseAttachment->save($attch);
    	} else {
            $attch = $this->PurchaseAttachment->get($existingRow[0]['purchase_attachment_id']);
            $attch->set(array(
	    			'host' => $host, 
	    			'mimetype' => $mimeType, 
	    			'thumbnail' => $thumbnail, 
	    			'id' => $id,
	    			'user_id' => $userId,
	    			'type' => $type,
	    			'upload_date' => date('Y-m-d H:i:s')));
	    $this->PurchaseAttachment->save($attch);
    	}
    	
    	return $msg;
    }
    
    function _createAttachmentThumbnail($tmpFile, $fileName, $mimeType, $isUploadFile) {
    	$thumbnail = 'unknown.jpg';
    	if ($this->_isImageFile($fileName)) {
	    	$thumbFilePath = $_SERVER["DOCUMENT_ROOT"] . "/order_attachment_thumbs/";
    		$msg = $this->PhpThumb->makeThumb(100, $tmpFile, $thumbFilePath, $fileName, $isUploadFile);
    		$thumbnail = $fileName;
    	} else if ($this->_isPdfFile($fileName)) {
    		$thumbnail = 'pdf.jpg';
    	} else if ($this->_isDocument($fileName)) {
    		$thumbnail = 'doc.jpg';
    	}
    	return $thumbnail;
    }
    
    function _validateUploadFileName($filename) {
		$isValid = (bool) ((preg_match("`^[-0-9A-Z_\. ]+$`i",$filename)) ? true : false);
		$isValid .= (bool) ((mb_strlen($filename,"UTF-8") > 225) ? true : false);
		return $isValid;
	}
	
    function dropzoneDelete($purchaseAttachmentId, $fileId) {
        $this->viewBuilder()->setLayout('ajax');
        $this->PurchaseAttachment = TableRegistry::get('PurchaseAttachment');
    	
    	$msg = $this->GoogleDrive->deleteFile($fileId);
    	if (isset($msg)) {
    		$this->response = $this->response->withStringBody($msg);
    		return;
    	}

    	$msg = $this->_deleteThumbnail($purchaseAttachmentId);
    	if (isset($msg)) {
    		$this->response = $this->response->withStringBody($msg);
    	}

    	$msg = $this->_deleteAttachmentRow($purchaseAttachmentId);
    	if (isset($msg)) {
    		$this->response = $this->response->withStringBody($msg);
    		return;
    	}
	}
	
	
	function _deleteThumbnail($purchaseAttachmentId) {

    	$existingRow = $this->PurchaseAttachment->find('all', array('conditions'=> array(
    			'purchase_attachment_id' => $purchaseAttachmentId)))->toArray();
    	
    	if (count($existingRow) != 1) {
    		return "Incorrect number of rows found: " + count($existingRow);
    	}

    	$fileNamePath = $_SERVER["DOCUMENT_ROOT"] . "/order_attachment_thumbs/" . $existingRow[0]['filename'];
    	
    	if (!$this->_isImageFile($fileNamePath)) {
    		// don't delete the generic thumbs
    		return;
    	}

    	unlink($fileNamePath);
    	return null;
	}

	function _deleteAttachmentRow($purchaseAttachmentId) {

    	$existingRow = $this->PurchaseAttachment->find('all', array('conditions'=> array(
    			'purchase_attachment_id' => $purchaseAttachmentId)))->toArray();
    	
    	if (count($existingRow) != 1) {
    		return "Incorrect number of rows found: " + count($existingRow);
    	}
    	
    	$this->PurchaseAttachment->delete($existingRow[0]);
    	return null;
	}
	
	function dropzoneDownload($purchaseAttachmentId) {
		
        $this->PurchaseAttachment = TableRegistry::get('PurchaseAttachment');
    	
    	$this->_deleteTempFiles();

    	$existingRow = $this->PurchaseAttachment->find('all', array('conditions'=> array('purchase_attachment_id' => $purchaseAttachmentId)))->toArray();
    	
    	if (count($existingRow) != 1) {
    		return "Incorrect number of rows found: " + count($existingRow);
    	}
    	
    	$fileId = $existingRow[0]['id'];
    	$fileName = $existingRow[0]['filename'];
		$fileNamePath = $this->_getTempDir().$fileName;
		$msg = $this->GoogleDrive->downloadFile($fileId, $fileNamePath);
		if (isset($msg)) {
	    	$this->response = $this->response->withStringBody($msg);
    		return;
		} 
		
		$path_parts = pathinfo($fileName);
		$response = $this->response->withFile(
			$fileNamePath,
			array('download' => false, 'name' => $path_parts['basename'])
		);
		
    	// Return response object to prevent controller from trying to render a view
    	return $response;
	}
	
	function _isImageFile($fileName) {
		$path_parts = pathinfo($fileName);
		return in_array(strtolower($path_parts['extension']), $this->imageFilenameExtensions);
	}

	function _isPdfFile($fileName) {
		$path_parts = pathinfo($fileName);
		return (strtolower($path_parts['extension']) == 'pdf');
	}

	function _isDocument($fileName) {
		$path_parts = pathinfo($fileName);
		return in_array(strtolower($path_parts['extension']), $this->docFilenameExtensions);
	}
	
	function _deleteTempFiles() {
		foreach (glob($this->_getTempDir()."*") as $file) {
			if (filemtime($file) < time() - 86400) {
				unlink($file);
			}
		}
	}
	
	function _getTempDir() {
		return $_SERVER["DOCUMENT_ROOT"].'/temp/';
	}
	
}
?>