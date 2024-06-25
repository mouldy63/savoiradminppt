<?php
namespace App\Controller\Orders;
use App\Controller\SecureAppController;
use App\Controller\Component\UtilityComponent;
use Cake\ORM\TableRegistry;
use Cake\Datasource\ConnectionManager;
use \Exception;

class OrderController extends AbstractOrderController {

	public function initialize() : void {
		parent::initialize();
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoirorders');
		 
		if (!$this->isNewOrder) {
			$this->_populateOrderDataTable();
			$data = $this->_getOrderData(0);
		}

		$this->set('pn', $this->getPn());
		$this->set('data', $data);
		$this->set('compId', 0);
		$this->set('compName', $this->_getComponentName(0));

		$rs = $this->componentModel->find('all')->order(['ComponentID' => 'ASC']);
		$componentNames = [];
		foreach ($rs as $row) {
			$componentNames[$row['ComponentID']] = $row['componentname'];
		}
		$this->set('componentNames', $componentNames);

		$orderNoteModel = TableRegistry::get('ordernote');
		$orderNotes = $orderNoteModel->find('all', ['conditions'=> ['purchase_no' => $this->getPn()]])->order(['createddate' => 'DESC'])->toArray();
		$this->set('orderNotes', $orderNotes);
	}

	public function save() {
		 
		if (!$this->request->is('post')) {
			throw new Exception('Invalid request type');
		}

		$formData = $this->request->getData();
		//debug($formData);
		//die;
		$this->setPn($formData['pn']);

		$conn = ConnectionManager::get('default');
		$conn->begin();
		$this->_saveFormToOrderDataTable($formData);
		$conn->commit();
		$conn->begin();
		$this->_copyOrderDataToNativeTables();
		$conn->commit();

		$this->redirect(['action' => 'index', '?' => ['pn' => $this->getPn()]]);
	}

	private function _populateOrderDataTable() {
		 
		$compPriceDiscounts = $this->compPriceDiscountModel->getPurchaseDiscountData($this->getPn());
		$productionSizes = $this->productionSizesModel->find('all', ['conditions'=> ['Purchase_No' => $this->getPn()]])->toArray();
		if (sizeof($productionSizes) > 0) $productionSizes = $productionSizes[0];
		$addressData = $this->addressModel->find('all', ['conditions'=> ['CODE' => $this->purchaseData['CODE']]])->toArray()[0];
		$phoneNumberData = $this->phoneNumberModel->getNumbersForPurchase($this->getPn());
		 
		$this->isNewOrder = false;
		 
		// wrap in a transaction
		$conn = ConnectionManager::get('default');
		$conn->begin();

		// clear the order_data table for this pn
		$this->orderDataModel->deleteAll(['PURCHASE_No' => $this->getPn()]);
		 
		$allComponentFieldData = $this->_getComponentFieldData();
		$this->_populateOrderDataTableForComponent(0, $compPriceDiscounts, $productionSizes, $addressData, $phoneNumberData);
		 
		$components = $this->componentModel->find('all', ['order'=> ['ComponentID' => 'asc']])->toArray();
		foreach ($components as $compData) {
			if ($compData['ComponentID'] != 0) {
				// is component required
				$parentCompName = $this->getParentCompName($compData['ComponentID'], $components);
				$isRequired = $this->_isComponentRequired($parentCompName, $compData['ComponentID'], $compData, $allComponentFieldData);
				if ($isRequired) {
					$this->_populateOrderDataTableForComponent($compData['ComponentID'], $compPriceDiscounts, $productionSizes, $addressData, $phoneNumberData);
				}
			}
		}
		 
		$conn->commit();
	}

	private function _isComponentRequired($parentCompName, $compId, $compData, $allComponentFieldData) {
		if ($parentCompName == 'order') {
			$fieldName = $parentCompName.'_'.$compData['componentname'].'req';
		} else {
			$fieldName = $compData['componentname'].'req';
		}

		if (!array_key_exists($fieldName, $allComponentFieldData)) {
			// doesn't exist in the component field list, so assume not required
			return false;
		}
		$field = $allComponentFieldData[$fieldName];
		 
		$isRequired = false;
		if ($field['from_order_data_mapping'] !== null) {
			// {"headboard_manhattantrim":{"n":"n","*":"y"}}
			$mapping = json_decode($field['from_order_data_mapping'], true);
			foreach ($mapping as $srcField => $mapData) {
				// should only be one
				$value = null;
				if ($srcField == 'fixedvalue') {
					// just use the fixed value
					$value = $mapData;
				} else if (array_key_exists($srcField, $allComponentFieldData)) {
					// get the value from the mapped field
					$compFieldData = $allComponentFieldData[$srcField];
					//debug($compFieldData);
					$purchaseTableKey = explode('.', $compFieldData['srccolumn'])[1];
					$srcVal = $this->purchaseData[$purchaseTableKey];
					$starMapValue = null;
					foreach ($mapData as $key => $val) {
						if ($key == 'null' && is_null($srcVal)) {
							$value = $val;
						} else if (strval($srcVal) == $key) {
							$value = $val;
						}
						if ($key == '*') $starMapValue = $val;
					}
					if (!isset($value) && !empty($starMapValue)) {
						$value = $starMapValue;
					}
				}
			}
			$isRequired = isset($value) && $value == 'y';

		} else if ($field['srccolumn'] !== null) {
			$srcColumnName = explode('.', $field['srccolumn'])[1];
			$isRequired = isset($this->purchaseData[$srcColumnName]) && ($this->purchaseData[$srcColumnName] == 'y' || $this->purchaseData[$srcColumnName] == 'Y' || $this->purchaseData[$srcColumnName] == 'Yes');
		} else {
			throw new Exception("cant determine if $compId is required");
		}
		return $isRequired;
	}

	private function getParentCompName($compId, $components) {
		$parentCompId = null;
		foreach ($components as $comp) {
			if ($comp['ComponentID'] == $compId) {
				$parentCompId = $comp['ParentComponentId'];
				if (empty($parentCompId)) $parentCompId = 0;
				break;
			}
		}
		 
		if (!isset($parentCompId)) {
			throw new Exception("parentCompId not found for compId=".$compId);
		}
		 
		$parentCompName = null;
		foreach ($components as $comp) {
			if ($comp['ComponentID'] == $parentCompId) {
				$parentCompName = $comp['componentname'];
			}
		}
		 
		if (empty($parentCompName)) {
			throw new Exception("parentCompName not found for compId=".$compId);
		}
		 
		return $parentCompName;
	}

	private function _getComponentFieldData($compId = null) {
		$query = $this->componentFieldModel->find('all');
		if (isset($compId)) {
			$query = $query->where(['ComponentId' => $compId]);
		}
		$query = $query->order(['ComponentId' => 'asc', 'fieldname' => 'asc']);
		$fieldData = [];
		foreach ($query as $row) {
			$fieldData[$row['fieldname']] = $row;
		}
		return $fieldData;
	}

	private function _populateOrderDataTableForComponent($compId, $compPriceDiscounts, $productionSizes, $addressData, $phoneNumberData) {
		$thisComponentFieldData = $this->_getComponentFieldData($compId);
		$insertData = [];
		 
		foreach ($thisComponentFieldData as $fieldname => $data) {
			if (!isset($data['srccolumn']) || $data['srccolumn'] == '<SPECIAL>') {
				continue;
			}
			//echo '<br>'.$fieldname;

			$pairs = explode(',', $data['srccolumn']);
			$vals = explode('.', $pairs[0]); // only use the first pair for reading the data
			$srcTable = $vals[0];
			$srcCol = $vals[1];
			$val = null;
			if ($srcTable == 'purchase') {
				if (isset($this->purchaseData[$srcCol])) {
					$val = $this->purchaseData[$srcCol];
				}
			} else if ($srcTable == 'productionsizes') {
				if (isset($productionSizes[$srcCol])) {
					$val = $productionSizes[$srcCol];
				}
			} else if ($srcTable == 'comp_price_discount') {
				if (isset($compPriceDiscounts[$compId][$srcCol])) {
					$val = $compPriceDiscounts[$compId][$srcCol];
				}
			} else if ($srcTable == 'contact') {
				if (isset($this->contactData[$srcCol])) {
					$val = $this->contactData[$srcCol];
				}
			} else if ($srcTable == 'address') {
				if (isset($addressData[$srcCol])) {
					$val = $addressData[$srcCol];
				}
			} else if ($srcTable == 'phonenumber') {
				$seq = $vals[2];
				if (isset($phoneNumberData[$seq][$srcCol])) {
					$val = $phoneNumberData[$seq][$srcCol];
				}
			} else {
				throw new Exception("Invalid field type " . $srcTable);
			}
			if (isset($val)) {
				array_push($insertData, [$fieldname, $data['srccolumntype'], $val]);
			}
		}
		 
		$this->_doOrderDataInsert($compId, $insertData);
	}

	private function _doOrderDataInsert($compId, $insertData) {
		 
		foreach($insertData as $item) {
			$orderDataRow = $this->orderDataModel->newEntity([]);
			$orderDataRow->PURCHASE_No = $this->getPn();
			$orderDataRow->ComponentID = $compId;
			$orderDataRow->fieldname = $item[0];
			if ($item[1] == 'string') {
				$orderDataRow->strvalue = $item[2];
			} else if ($item[1] == 'integer') {
				$orderDataRow->intvalue = $item[2];
			} else if ($item[1] == 'double') {
				$orderDataRow->dblvalue = $item[2];
			} else if ($item[1] == 'money') {
				$orderDataRow->dblvalue = $item[2];
			} else if ($item[1] == 'datetime') {
				$orderDataRow->datetimevalue = $item[2];
			} else {
				throw new Exception("Invalid field type " . $item[1]);
			}
			$this->orderDataModel->save($orderDataRow);
		}
	}

	private function _saveFormToOrderDataTable($formData) {
		 
		// clear the order_data table for this pn
		$this->orderDataModel->deleteAll(['PURCHASE_No' => $this->getPn()]);

		// the components selected on the form
		$reqComps = $this->getComponentRequiredListFromForm($formData);

		$compFieldData = $this->_getComponentFieldData();

		foreach($formData as $fieldname => $val) {

			if (!array_key_exists($fieldname, $compFieldData)) {
				continue;
			}

			$compFieldDataRow = $compFieldData[$fieldname];

			if (!in_array($compFieldDataRow['ComponentId'], $reqComps)) {
				// this component is not required, so any field values that somehow got through will be ignored
				continue;
			}


			$orderDataRow = $this->orderDataModel->newEntity([]);
			$orderDataRow->PURCHASE_No = $this->getPn();
			$orderDataRow->ComponentID = $compFieldDataRow['ComponentId'];
			$orderDataRow->fieldname = $fieldname;
			$datatype = $compFieldDataRow['datatype'];
			if ($datatype == 'string') {
				$orderDataRow->strvalue = $val;
			} else if ($datatype == 'integer') {
				$orderDataRow->intvalue = UtilityComponent::strToInt($val);
			} else if ($datatype == 'double') {
				$orderDataRow->dblvalue = UtilityComponent::strToDbl($val);
			} else if ($datatype == 'money') {
				$orderDataRow->dblvalue = UtilityComponent::strToDbl($val);
			} else if ($datatype == 'datetime') {
				if ($val == '') $val = null;
				$orderDataRow->datetimevalue = $val;
			} else {
				throw new Exception("Invalid field type " . $datatype);
			}
			$this->orderDataModel->save($orderDataRow);
		}
	}

	private function getComponentRequiredListFromForm($formData) {
		$componentData = $this->componentModel->getComponentData();
		$reqComps = [];
		foreach($componentData as $compId => $compRow) {
			if ($compId == 0) {
				continue;
			}

			if (isset($compRow['ParentComponentId'])) {
				// child components
				$requiredFieldName = $compRow['name'] . 'req';
			} else {
				// top level components
				$requiredFieldName = 'order_' . $compRow['name'] . 'req';
			}
			if (isset($formData[$requiredFieldName]) && $formData[$requiredFieldName] != 'n') {
				array_push($reqComps, $compId);
			}
		}
		return $reqComps;
	}

	private function _copyOrderDataToNativeTables() {
		 
		$compFieldData = $this->_getComponentFieldData();
		$purchaseRow = $this->purchaseModel->find('all', ['conditions'=> ['PURCHASE_No' => $this->getPn()]])->toArray()[0];
		$orderDataRs = $this->orderDataModel->getKeyedOrderData($this->getPn());
		debug($orderDataRs);
		die;
		debug($orderDataRs['order_invadd1']);
		foreach ($compFieldData as $fieldName => $compField) {
			//debug($fieldName);
			//debug($compField);
			if (array_key_exists($fieldName, $orderDataRs)) {
				// this field has a value in orderdata
				echo '<br>contains ' . $fieldName;
			} else {
				// this field does not
				echo '<br>NOT contain ' . $fieldName;
			}
			$srcColumn = explode(".", $compField['srccolumn']);
			if ($srcColumn[0] == 'purchase') {
				//$this->_putValueInPurchaseRow($purchaseRow, $orderDataRow, $srcColumn);
			}
		}
		die;
		$purchaseRow = $this->purchaseModel->find('all', ['conditions'=> ['PURCHASE_No' => $this->getPn()]])->toArray()[0];

		$orderDataRs = $this->orderDataModel->getOrderData($this->getPn());
		foreach($orderDataRs as $orderDataRow) {
			debug($orderDataRow);
			$srcColumn = explode(".", $orderDataRow['srccolumn']);
			$srcColumnType = $orderDataRow['srccolumntype'];
			$dataType = $orderDataRow['datatype'];
			debug($srcColumn);
			if ($srcColumn[0] == 'purchase') {
				$this->_putValueInPurchaseRow($purchaseRow, $orderDataRow, $srcColumn);
			}
		}

		$this->purchaseModel->save($purchaseRow);
		//debug($purchaseRow);
	}
	 
	private function _putValueInPurchaseRow($purchaseRow, $orderDataRow, $srcColumn) {

		$dataType = $orderDataRow['datatype'];
		$srcColumn = explode(".", $orderDataRow['srccolumn']);
		$srcColumnType = $orderDataRow['srccolumntype'];

		if ($dataType == 'string') {
			$purchaseRow[$srcColumn[1]] = $orderDataRow['strvalue'];
		} else if ($dataType == 'double') {
			$purchaseRow[$srcColumn[1]] = $orderDataRow['dblvalue'];
		} else if ($dataType == 'money') {
			$purchaseRow[$srcColumn[1]] = $orderDataRow['dblvalue'];
		} else if ($dataType == 'integer') {
			$purchaseRow[$srcColumn[1]] = $orderDataRow['intvalue'];
		} else if ($dataType == 'datetime') {
			$purchaseRow[$srcColumn[1]] = $orderDataRow['datetimevalue'];
		}
	}
}