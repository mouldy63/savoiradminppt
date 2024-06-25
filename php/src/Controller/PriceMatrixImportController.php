<?php
namespace App\Controller;
use Cake\Datasource\ConnectionManager;
use \DateTime;
use \Exception;

class PriceMatrixImportController extends SecureAppController {

	private $brHeader;
	private $tmpFolder;

	public function initialize() : void {
        parent::initialize();
        $this->viewBuilder()->setLayout('savoir');
        $tmpFolder = WWW_ROOT . 'uploads'. DS . 'tmp' . DS;
        $this->brHeader = ['Price Type','Component','Dimension 1 Name','Dimension 1','Dimension 2 Name','Dimension 2','Set Component 1','Set Component 2','Retail GBP','Retail USD','Retail EUR','Wholesale GBP','Wholesale USD','Wholesale EUR','Ex Works Revenue'];
        $this->loadModel('PriceMatrix');
        $this->loadModel('PriceMatrixType');
        $this->loadModel('Component');
	}
	
	public function index() {
		$this->set('pageTitle', 'Upload Project Csv File');
	}
	
	public function save(){
		if (!$this->request->is('post')) {
			$this->Flash->error('Call to save must be a post');
			return $this->redirect(['action' => 'index']);
		}
		
		$fn = $this->request->getData('fn');
		$rowsToSave = [];		
		$rowsToDelete = [];		
		$formData = $this->request->getData();	
		foreach ($formData as $formfield => $value) {
			$parts = explode("-", $formfield);
			if ($parts[0] == "DELETE") {
				array_push($rowsToDelete, $parts[1]);
			} else if ($parts[0] == "KEY") {
				array_push($rowsToSave, $parts[1]);
			}
		}
		if (count($rowsToSave) == 0 && count($rowsToDelete) == 0) {
			$this->Flash->error('No rows selected for saving or deletion!');
			return $this->redirect(['action' => 'display', urlencode($fn)]);
		}
		
		$results = null;
		$conn = ConnectionManager::get('default');
    	$conn->begin();
		try {
			$deletedCount = 0;
			foreach ($rowsToDelete as $key) {
				$deletedCount += $this->_deleteByKey($key);
			}
			
			$fileName = $this->tmpFolder . $fn;
			$fileContent = $this->_parseFile($fileName);
			$rowsToBeSaved = [];
			$rowsToBeSavedKeys = [];
			foreach ($fileContent as $row) {
				$rowKey = $this->_makeRowKeyFromCsv($row);
				if (in_array($rowKey, $rowsToSave) && !in_array($rowKey, $rowsToBeSavedKeys)) {
					array_push($rowsToBeSaved, $row);
					array_push($rowsToBeSavedKeys, $rowKey);
				}
			}
			
			$results = $this->_saveRows($rowsToBeSaved);
		} catch (Exception $e) {
    		$conn->rollback();
			$this->Flash->error($e->getMessage());
			return $this->redirect(['action' => 'display', urlencode($fn)]);
		}
		$conn->commit();
		$this->Flash->success($results['added'] . " rows added, " . $results['updated'] . " updated and " . $deletedCount . ' deleted');
		$this->redirect(['action' => 'index']);
	}
	
	public function upload(){
		if ($this->request->is('post')) {
			$theFile = $this->request->getData('upload_project_csv_file');
			$name = $theFile->getClientFilename();
			$type = $theFile->getClientMediaType();
			if ($type != 'application/vnd.ms-excel' && $type != 'text/csv') {
 		  	    $this->Flash->error('Invalid file type (' . $type . '). Must be a CSV file.');
				return $this->redirect(['action' => 'index']);
			}
			$destination = $this->tmpFolder . $name;
			$theFile->moveTo($destination);
 		  	$this->Flash->success($name . ' successfully uploaded.');
			return $this->redirect(['action' => 'display', urlencode($name)]);
		}
	}
	
	public function display($fn) {
		if (empty($fn)) {
			$this->Flash->error('No File supplied.');
			return $this->redirect(['action' => 'index']);
		}
		$this->set('pageTitle', $fn);
		
		$fileName = $this->tmpFolder . $fn;
		$fileContent = $this->_parseFile($fileName);
		list($fileContent, $hasErrors) = $this->_enhanceFileContent($fileContent);
		$this->set('fileContent', $fileContent);
		$this->set('fn', $fn);
		if ($hasErrors) {
		  	$this->Flash->error('There are problems with the csv file. Scroll down to see the rows in red.');
		}
	}
	
	protected function _saveRows($rowsToBeSaved) {
		$nAdded = 0;
		$nUpdated = 0;
    	
    	try {
			foreach ($rowsToBeSaved as $row) {
				$isNewRow = $this->_saveRow($row);
				if ($isNewRow) {
					$nAdded = $nAdded + 1;
				} else {
					$nUpdated = $nUpdated + 1;
				}
			}
    	} catch (Exception $e) {
    		throw $e;
    	}

		return ['added' => $nAdded, 'updated' => $nUpdated];
	}
	
	protected function _saveRow($row) {
		$qr = $this->PriceMatrix->find('all', ['conditions'=> ['COMPONENTID' => $this->_getComponentID($row['Component']),
																  'PRICE_TYPE_ID' => $this->_getPriceTypeID($row['Price Type']),
																  'DIM1 IS' => $this->_toString($row['Dimension 1']),
																  'DIM2 IS' => $this->_toString($row['Dimension 2']),
																  'COMPID_SET1 IS' => $this->_getComponentID($row['Set Component 1']),
																  'COMPID_SET2 IS' => $this->_getComponentID($row['Set Component 2'])]]);
		$rs = $qr->toArray();
    	$isNewRow = false;
    	 
    	if (count($rs) == 0) {
    		$rsrow = $this->PriceMatrix->newEntity([]);
    		$isNewRow = true;
    	} else if (count($rs) == 1) {
    		$rsrow = $rs[0];
    		$isNewRow = false;
    	} else {
    		$sql = $this->_makeSql($row);
    		throw new Exception('More than one row found in DB for row in CSV file. Execute this sql to find it: ' . $sql);
    	}
    	
    	$rsrow->PRICE_TYPE_ID = $this->_getPriceTypeID($row['Price Type']);
    	$rsrow->COMPONENTID = $this->_getComponentID($row['Component']);
    	$rsrow->DIM1 = $this->_toString($row['Dimension 1']);
    	$rsrow->DIM2 = $this->_toString($row['Dimension 2']);
    	$rsrow->GBP = $this->_toFloat($row['Retail GBP']);
    	$rsrow->USD = $this->_toFloat($row['Retail USD']);
    	$rsrow->EUR = $this->_toFloat($row['Retail EUR']);
    	$rsrow->GBP_WHOLESALE = $this->_toFloat($row['Wholesale GBP']);
    	$rsrow->USD_WHOLESALE = $this->_toFloat($row['Wholesale USD']);
    	$rsrow->EUR_WHOLESALE = $this->_toFloat($row['Wholesale EUR']);
    	$rsrow->EX_WORKS_REVENUE = $this->_toFloat($row['Ex Works Revenue']);
    	$rsrow->COMPID_SET1 = $this->_getComponentID($row['Set Component 1']);
    	$rsrow->COMPID_SET2 = $this->_getComponentID($row['Set Component 2']);
    	$this->PriceMatrix->save($rsrow);
    	
    	return $isNewRow;
	}
	
	protected function _enhanceFileContent($fileContent) {
		$priceMatrixRowKeys = $this->_getAllExistingPriceMatrixRowKeys();
		
		$newFileContent = [];
		$rowKeyList = [];
		$hasErrors = false;
		foreach ($fileContent as $row) {
			$rowKey = $this->_makeRowKeyFromCsv($row);
			$row['key'] = $rowKey;
			if (in_array($rowKey, $priceMatrixRowKeys)) {
				$row['isnew'] = false;
			} else {
				$row['isnew'] = true;
			}
			$errorMessages = $this->_validateRow($row);
			if (in_array($rowKey, $rowKeyList)) {
				array_push($errorMessages, 'Duplicate of another row in CVS file');
			}
			$row['errorMessages'] = implode("<br/>", $errorMessages);
			if (!empty($row['errorMessages'])) {
				$hasErrors = true;
			}
			array_push($newFileContent, $row);
			array_push($rowKeyList, $rowKey);
		}
		return [$newFileContent, $hasErrors];
	}
	
	protected function _validateRow($row) {
		$errorMessages = [];
		
		$priceTypeId = null;
		try {
			$priceTypeId = $this->_getPriceTypeID($row['Price Type']);
		} catch (Exception $e) {
			array_push($errorMessages, $e->getMessage());
		}
		if (!$priceTypeId) {
			return $errorMessages;
		}

		try {
			$this->_getComponentID($row['Component']);
		} catch (Exception $e) {
			array_push($errorMessages, $e->getMessage());
		}

		try {
			$this->_validateDimension($row['Dimension 1 Name'], $row['Dimension 1'], $priceTypeId, 1);
		} catch (Exception $e) {
			array_push($errorMessages, $e->getMessage());
		}

		try {
			$this->_validateDimension($row['Dimension 2 Name'], $row['Dimension 2'], $priceTypeId, 2);
		} catch (Exception $e) {
			array_push($errorMessages, $e->getMessage());
		}
		
		try {
			$this->_getComponentID($row['Set Component 1']);
		} catch (Exception $e) {
			array_push($errorMessages, $e->getMessage());
		}
		
		try {
			$this->_validateMoneyAmount('Retail GBP', $row['Retail GBP']);
		} catch (Exception $e) {
			array_push($errorMessages, $e->getMessage());
		}
		
		try {
			$this->_validateMoneyAmount('Retail USD', $row['Retail USD']);
		} catch (Exception $e) {
			array_push($errorMessages, $e->getMessage());
		}

		try {
			$this->_validateMoneyAmount('Retail EUR', $row['Retail EUR']);
		} catch (Exception $e) {
			array_push($errorMessages, $e->getMessage());
		}

		try {
			$this->_validateMoneyAmount('Wholesale GBP', $row['Wholesale GBP']);
		} catch (Exception $e) {
			array_push($errorMessages, $e->getMessage());
		}

		try {
			$this->_validateMoneyAmount('Wholesale USD', $row['Wholesale USD']);
		} catch (Exception $e) {
			array_push($errorMessages, $e->getMessage());
		}

		try {
			$this->_validateMoneyAmount('Wholesale EUR', $row['Wholesale EUR']);
		} catch (Exception $e) {
			array_push($errorMessages, $e->getMessage());
		}

		try {
			$this->_validateMoneyAmount('Ex Works Revenue', $row['Ex Works Revenue']);
		} catch (Exception $e) {
			array_push($errorMessages, $e->getMessage());
		}

		return $errorMessages;
	}
	
	protected function _getAllExistingPriceMatrixRowKeys() {
		$idlist = $this->PriceMatrix->find('all')->order(['PRICE_MATRIX_ID' => 'ASC']);
		$keys = [];
		foreach ($idlist->all() as $row) {
			$key = $this->_makeRowKeyFromDb($row);
			array_push($keys, $key);
		}
		return $keys;
	}
	
	protected function _makeRowKeyFromDb($row) {
		$key = [];
		array_push($key, $row['COMPONENTID']);
		array_push($key, $row['PRICE_TYPE_ID']);
		array_push($key, $this->_toString($row['DIM1']));
		array_push($key, $this->_toString($row['DIM2']));
		array_push($key, $row['COMPID_SET1']);
		array_push($key, $row['COMPID_SET2']);
		return implode('_', $key);
	}
	
	protected function _makeRowKeyFromCsv($row) {
		$key = [];
		array_push($key, $this->_getComponentID($row['Component']));
		array_push($key, $this->_getPriceTypeID($row['Price Type']));
		array_push($key, $this->_toString($row['Dimension 1']));
		array_push($key, $this->_toString($row['Dimension 2']));
		array_push($key, $this->_getComponentID($row['Set Component 1']));
		array_push($key, $this->_getComponentID($row['Set Component 2']));
		return implode('_', $key);
	}

	protected function _parseFile($file) {
		$row = 1;
		$content = [];
		if (($handle = fopen($file, "r")) !== FALSE) {
			while (($data = fgetcsv($handle, 0, ",")) !== FALSE) {
				//$data = array_map("utf8_encode", $data);
				if ($row > 1 && count($data) > 1) {
					$num = count($this->_getHeader());
					$r = [];
					for ($c=0; $c < $num; $c++) {
					    $r[$this->_getHeader()[$c]] = $data[$c];
					}
					array_push($content, $r);
				}
				$row++;
			}
			fclose($handle);
		}
		return $content;
	}

	protected function _getPriceTypeID($priceType) {
		if (empty($priceType)) {
			return null;
		}
		$rs = $this->PriceMatrixType->find('all', ['conditions'=> ['NAME' => trim($priceType)]]);
    	$rs = $rs->toArray();
    	
    	if (count($rs) == 0) {
    		throw new Exception("Unknown price type '" . $priceType . "'");
    	}
    	return $rs[0]->PRICE_TYPE_ID;
	}
	
	protected function _getComponentID($component) {
		if (empty($component)) {
			return null;
		}
		$rs = $this->Component->find('all', ['conditions'=> ['Component' => trim($component)]])->toArray();
    	
    	if (count($rs) == 0) {
    		throw new Exception("Unknown component '" . $component . "'");
    	}
    	return $rs[0]->ComponentID;
	}
	
	protected function _validateDimension($dimensionName, $dimension, $priceTypeId, $index) {
		if (empty($dimensionName)) {
			return null;
		}
		$colName = 'DIM' . $index . '_NAME';
		$rs = $this->PriceMatrixType->find('all', ['conditions'=> ['PRICE_TYPE_ID' => $priceTypeId, $colName => $dimensionName]]);
    	$rs = $rs->toArray();
    	
    	if (count($rs) == 0) {
    		throw new Exception("Bad dimension name '" . $dimensionName . "'");
    	}
    	
    	if (empty($dimension)) {
    		throw new Exception("Missing dimension value for dimension '" . $dimensionName . "'");
    	}
	}
	
	protected function _makeSql($row) {
		$sql = "select * from price_matrix where COMPONENTID=" . $this->_getComponentID($row['Component']);
		$sql .= " and PRICE_TYPE_ID=" . $this->_getPriceTypeID($row['Price Type']);
		$dim1 = $this->_toString($row['Dimension 1']);
		if ($dim1 != null) {
			$sql .= " and DIM1='" . $dim1 . "'";
		} else {
			$sql .= " and DIM1 is null";
		}
		$dim2 = $this->_toString($row['Dimension 2']);
		if ($dim2 != null) {
			$sql .= " and DIM2='" . $dim2 . "'";
		} else {
			$sql .= " and DIM2 is null";
		}
		$compSet1 = $this->_getComponentID($row['Set Component 1']);
		if ($compSet1 != null) {
			$sql .= " and COMPID_SET1=" . $compSet1;
		} else {
			$sql .= " and COMPID_SET1 is null";
		}
		$compSet2 = $this->_getComponentID($row['Set Component 2']);
		if ($compSet2 != null) {
			$sql .= " and COMPID_SET2=" . $compSet2;
		} else {
			$sql .= " and COMPID_SET2 is null";
		}
		return $sql;
	}
	
	protected function _deleteByKey($key) {
		$params = explode('_', $key);
		$componentId = $params[0];
		$priceTypeId = $params[1];
		$dim1 = !empty($params[2]) ? $params[2] : null;
		$dim2 = !empty($params[3]) ? $params[3] : null;
		$setCompId1 = !empty($params[4]) ? $params[4] : null;
		$setCompId2 = !empty($params[5]) ? $params[5] : null;
		$result = $this->PriceMatrix->deleteAll(['COMPONENTID' => $componentId,
				  'PRICE_TYPE_ID' => $priceTypeId,
				  'DIM1 IS' => $dim1,
				  'DIM2 IS' => $dim2,
				  'COMPID_SET1 IS' => $setCompId1,
				  'COMPID_SET2 IS' => $setCompId2]);
		return $result;
	}
	
	protected function _validateMoneyAmount($name, $amount) {
		if (empty($amount)) {
			return;
		}
    	if (!is_numeric($amount)) {
    		throw new Exception("Value for " . $name . " must be numeric");
    	}
	}
	
    protected function _getHeader() {
		return $this->brHeader;
	}
	
	protected function _toDate($str) {
		$date = null;
		if (!empty($str)) {
			$fmt = null;
			if (strpos($str, '-')) {
				$fmt = 'd-M-y';
			} else if (strpos($str, '/')) {
				$fmt = 'd/m/Y';
			} else {
				throw new Exception("Unknown date format '" . $str . "'");
			}
			$date = DateTime::createFromFormat($fmt, $str);
		}
		return $date;
	}

	protected function _toFloat($str) {
		if (empty($str)) {
			return null;
		}
		$arr = str_split($str);
		$s = '';
		foreach ($arr as $c) {
			if (is_numeric($c) || $c == '.') {
				$s .= $c;
			}
		}
		if (empty($s)) {
			return null;
		}
		return floatval($s);
	}

	protected function _toInt($str) {
		if (empty($str)) {
			return null;
		}
		$arr = str_split($str);
		$s = '';
		foreach ($arr as $c) {
			if (is_numeric($c)) {
				$s .= $c;
			}
		}
		if (empty($s)) {
			return null;
		}
		return intval($s);
	}
	
	protected function _toString($str) {
		if (empty($str) || empty(trim($str))) {
			return null;
		}
		return trim($str);
	}
	
	protected function _getAllowedRoles() {
		return array("ADMINISTRATOR");
	}
}
?>