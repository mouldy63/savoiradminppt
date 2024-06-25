<?php
namespace App\Controller;
use App\Controller\EmailServicesController;
use Cake\ORM\TableRegistry;
use Cake\Datasource\ConnectionManager;
use Cake\I18n\FrozenTime;
use \Exception;

class SavoirbedsOrderImportController extends AbstractImportController {

	private $oHeader;
	private $emailServices;

	public function initialize() : void {
        parent::initialize();
		$this->oHeader = ['order_number', 'order_number_formatted', 'date', 'status', 'shipping_total', 'shipping_tax_total', 'fee_total', 'fee_tax_total', 'tax_total', 'discount_total', 'order_total', 'refunded_total', 'order_currency', 'payment_method', 'shipping_method', 'customer_id', 'billing_first_name', 'billing_last_name', 'billing_company', 'billing_email', 'billing_phone', 'billing_address_1', 'billing_address_2', 'billing_postcode', 'billing_city', 'billing_state', 'billing_country', 'shipping_first_name', 'shipping_last_name', 'shipping_address_1', 'shipping_address_2', 'shipping_postcode', 'shipping_city', 'shipping_state', 'shipping_country', 'shipping_company', 'customer_note', 'line_items', 'shipping_items', 'fee_items', 'tax_items', 'coupon_items', 'refunds', 'order_notes', 'download_permissions_granted'];
    	$this->loadModel('ImportOrderFiles');
    	$this->loadModel('Comreg');
    	$this->loadModel('Accessory');
    	$this->loadModel('PurchaseCoupon');
    	$this->loadModel('CouponCodeMapping');
    	$this->loadModel('Payment');
    	$this->loadModel('QcHistory');
    	$this->loadModel('OrderNote');
    	$this->emailServices = new EmailServicesController();
	}
	
	public function import() {
		$this->autoRender = false;
		$this->viewBuilder()->setLayout('ajax');

		echo "Importing orders from " . $this->path;
		
		$files = $this->_getNewFiles('orders-export-');

		foreach ($files as $file) {
			echo "<br/>Processing " . $file;
			
			// check if we've had this file before
			if (!$this->_isFileNew($file)) {
				echo "<br/>Already processed " . $file;
				unlink($this->path . '/' . $file);
				continue;
			}
			// get file content
			$fileContent = $this->_parseFile($file);
			//debug($fileContent);
			//die;
			
			$conn = ConnectionManager::get('default');
	    	$conn->begin();

			foreach ($fileContent as $row) {
				$this->_uploadOrder($row, $file);
			}
			
			$this->_markFileAsProcessed($file);

    		$conn->commit();
    		echo '<br/>Order import suceeded<br/>';
    		
    		// archive the file
			rename($this->path . '/' . $file, $this->path . '/archive/' . $file);
		}
		echo "<br/><br/>All orders imported";
	}
	
	private function _uploadOrder($row, $filename) {
		
		echo '<br/><br/>row: ';
    	debug($row);
    	
    	if ($this->_isEmptyRow($row)) {
    		echo '<br>Empty row, so skipping';
    		return;
    	}
    	
    	$errors = $this->_validateRow($row);
    	if (!empty($errors)) {
    		echo '<br>Errors with row, so exiting:';
    		echo '<br>' . $errors;
    		throw new Exception($errors);
    	}
    	
    	if ($row['status'] == 'failed') {
    		echo '<br>Status=failed, so not importing';
    		return;
    	}
    	
    	$now = $this->_getCurrentDateTimeStr();
    	
    	$postcode = $row['billing_postcode'];
    	$country = $row['billing_country'];
    	$idLocation = $this->_getShowroomForCurrency($row['order_currency']);
    	$idRegion = $this->_getRegionOfLocation($idLocation);
    	$orderNumber = $row['order_number']; //$this->Comreg->getNextOrderNumber();
    	$receiptNo = $this->Comreg->getNextReceiptNumber();
    	$money = $this->_getMoneyData($row);
    	//debug($money);
    	
    	$addressCode = $this->_addUpdateAddress($row, $idLocation, $idRegion, $now);
    	$contactNo = $this->_addUpdateContact($row, $idLocation, $idRegion, $addressCode, $now);
    	$pn = $this->_addOrder($row, $idLocation, $idRegion, $addressCode, $contactNo, $now, $orderNumber, $money);
    	$accessories = $this->_buildAccessories($pn, $row, $money['vatrate']);
    	$this->_addAccessories($accessories);
    	$this->_addCoupons($pn, $row);
    	$paymentId = $this->_addPayment($pn, $receiptNo, $row);
    	$qcHistoryId = $this->_addQcHistory($pn, $row, $now);
    	if (!empty($row['customer_note'])) {
	    	$this->_addOrderNote($pn, $row);
    	}
    	$this->_sendNewPaymentEmail($pn, $orderNumber, $receiptNo, $row, $money);
    	$this->_sendNewOrderEmail($pn, $orderNumber, $receiptNo, $accessories, $row, $money);
	}
	
	private function _getMoneyData($row) {
		
		$total = floatval($row['order_total']);
		$vat = floatval($row['tax_total']);
		$shipping = floatval($row['shipping_total']);
		if ($total-$vat > 0) {
			$vatrate = 100.0*$vat/($total-$vat);
		} else {
			$vatrate = 0.0;
		}
		$bedsetTotal = $this->_getBedsetTotalFromAccessories($row);
		$discount = floatval($row['discount_total']);
		$discountPc = $discount / $bedsetTotal * 100.0;
		
		$money = [];
		$money['shipping'] = number_format($shipping, 2, '.', '');
		$money['bedsettotal'] = number_format($bedsetTotal, 2, '.', '');
		$money['subtotal'] = number_format($total-$shipping, 2, '.', '');
		$money['vat'] = number_format($vat, 2, '.', '');
		$money['vatrate'] = number_format($vatrate, 3, '.', '');
		$money['totalexvat'] = number_format($total-$vat, 2, '.', '');
		$money['total'] = number_format($total, 2, '.', '');
		$money['discountPc'] = number_format($discountPc, 2, '.', '');
		
		return $money;
	}
	
	private function _getBedsetTotalFromAccessories($row) {
		$strLineItems = str_replace("&amp\;", "&", $row['line_items']);
		$lineitems = explode(";", $strLineItems);
		$bedsetTotal = 0.0;
		
		foreach ($lineitems as $lineitem) {
			$data = explode("|", $lineitem);
			$items = [];
			foreach ($data as $d) {
				$temp = explode(":", $d);
				$items[$temp[0]] = $temp[1];
			}
			$bedsetTotal = $bedsetTotal + floatval($items['subtotal']) + floatval($items['subtotal_tax']);
		}
		return $bedsetTotal;
		
	}
	
	private function _addUpdateAddress($row, $idLocation, $idRegion, $now) {
    	$addressRs = $this->Address->find('all', array('conditions'=> array('email_address' => $row['billing_email'])))->toArray();
		$addressCode = 0;
    	$priceList = "";
    	$company = $row['billing_company'];
    	if (!empty($company)) {
    		$priceList = "Trade";
    	} else {
    		$priceList = $this->_getPriceListForLocation($idLocation);
    	}
    	echo '<br/>priceList = ' . $priceList;
    	 
    	if (count($addressRs) == 0) {
    		echo '<br/>new address';
    		$address = $this->Address->newEntity([]);
    		$isNewContact = true;
    	} else {
    		echo '<br/>existing address so updating';
    		$address = $addressRs[0];
    		$isNewContact = false;
    	}
    	$address->street1 = $row['billing_address_1'];
    	$address->street2 = $row['billing_address_2'];
    	$address->town = $row['billing_city'];
    	$address->county = $row['billing_state'];
    	$address->country = $row['billing_country'];
    	$address->postcode = $row['billing_postcode'];
    	$address->EMAIL_ADDRESS = $row['billing_email'];
    	if ($isNewContact) {
    		$address->FIRST_CONTACT_DATE = $now;
	    	$address->INITIAL_CONTACT = 'Website Order';
	    	$address->CHANNEL = 'Direct';
    		$address->source = 'Website';
    	}
	    $address->STATUS = 'Customer';
    	$address->OWNING_REGION = $idRegion;
    	$address->SOURCE_SITE = 'SB';
    	if (!empty($company)) {
    		$address->company = $company;
    		$address->CHANNEL = 'Trade';
    	}
    	$address->PRICE_LIST = $priceList;
    	$this->Address->save($address);
    	$addressCode = $address->CODE;
    	 
    	echo '<br/>address code=' . $addressCode;
		return $addressCode;
	}
	
	private function _addUpdateContact($row, $idLocation, $idRegion, $addressCode, $now) {
    	$contactRs = $this->Contact->find('all', array('conditions'=> array('CODE' => $addressCode)));
    	$contactRs = $contactRs->toArray();
    	$contactNo = 0;
    	if (count($contactRs) == 0) {
    		echo '<br/>new contact';
    		$contact = $this->Contact->newEntity([]);
    		$newContact = true;
    	} else {
    		echo '<br/>existing contact so updating';
    		$contact = $contactRs[0];
    		$newContact = false;
    	}
    	$contact->CODE = $addressCode;
    	$contact->first = $row['shipping_first_name'];
    	$contact->surname = $row['shipping_last_name'];
    	$contact->mobile = $row['billing_phone'];
    	if ($newContact) {
    		$contact->dateadded = $now;
    		$contact->acceptemail = 'y';
    	}
    	$contact->dateupdated = $now;
    	$contact->retire = 'n';
    	$contact->SOURCE_SITE = 'SB';
    	$contact->idlocation = $idLocation;
    	$contact->OWNING_REGION = $idRegion;
    	$contact->BrochureRequestSent = 'y'; // so they don't appear on the outstanding brochure request list
    	$this->Contact->save($contact);
    	$contactNo = $contact->CONTACT_NO;
    	 
    	echo '<br/>contactid=' . $contactNo;
    	return $contactNo;
	}
	
	private function _addOrder($row, $idLocation, $idRegion, $addressCode, $contactNo, $now, $orderNumber, $money) {
    	
		$orderDate = null;
		try {
			$orderDate = FrozenTime::createFromFormat('Y-m-d H:i:s', $row['date'], 'Europe/London');
		} catch (Exception $e) {
			$orderDate = FrozenTime::createFromFormat('d/m/Y H:i', $row['date'], 'Europe/London');
		}
    	
    	$purchase = $this->Purchase->newEntity([]);
    	$purchase->CODE = $addressCode;
    	$purchase->orderConfirmationStatus = 'n';
    	$purchase->pinnacle = 'n';
    	$purchase->pinnacleAddItemsRequired = 'n';
    	$purchase->mattressrequired = 'n';
    	$purchase->topperrequired = 'n';
    	$purchase->baserequired = 'n';
    	$purchase->legsrequired = 'n';
    	$purchase->headboardrequired = 'n';
    	$purchase->valancerequired = 'n';
    	$purchase->giftpackrequired = 'n';
    	$purchase->mattqty = 0;
    	$purchase->baseqty = 0;
    	$purchase->hbqty = 0;
    	$purchase->deliverycharge = 0;
    	$purchase->ORDER_NUMBER = $orderNumber;
    	$purchase->ORDER_DATE = $orderDate;
    	$purchase->AmendedDate = $orderDate;
    	$purchase->SOURCE_SITE = 'SB';
    	$purchase->OWNING_REGION = $idRegion;
    	$purchase->completedorders = 'n';
    	$purchase->salesusername = 'Ecommerce';
    	$purchase->customerreference = 'WEB ORDER ' . $row['order_number'];
    	$purchase->deliveryadd1 = $row['shipping_address_1'];
    	$purchase->deliveryadd2 = $row['shipping_address_2'];
    	$purchase->deliverytown = $row['shipping_city'];
    	$purchase->deliverycounty = $row['shipping_state'];
    	$purchase->deliverypostcode = $row['shipping_postcode'];
    	$purchase->deliverycountry = $row['shipping_country'];
    	$purchase->deliveryprice = $money['shipping'];
    	$purchase->bedsettotal = $money['bedsettotal'];
    	$purchase->discount = $money['discountPc'];
    	$purchase->discounttype = 'percent';
    	$purchase->total = $money['total'];
    	$purchase->paymentstotal = $money['total'];
    	$purchase->balanceoutstanding = '0.00';
    	$purchase->subtotal = $money['subtotal'];
    	$purchase->ordertype = 5; // website order
    	$purchase->version = 1;
    	$purchase->quote = 'n';
    	$purchase->accessoriestotalcost = $purchase->bedsettotal;
    	$purchase->accessoriesrequired = 'y';
    	$purchase->companyname = $row['shipping_company'];
    	$purchase->totalexvat = $money['totalexvat'];
    	$purchase->vat = $money['vat'];
    	$purchase->vatrate = $money['vatrate'];
    	$purchase->ordercurrency = $row['order_currency'];
    	$purchase->tradediscount = '0.00';
    	$purchase->tradediscountrate = 0;
    	$purchase->istrade = 'n';
    	$purchase->idlocation = $idLocation;
    	$purchase->cancelled = 'n';
    	$purchase->OrderStatusID = 1;
    	$purchase->DeliveryTermsID = 0;
    	$purchase->overseasOrder = 'n';
    	$purchase->orderSource = 'Client';
    	$purchase->contact_no = $contactNo;
    	
    	if (!empty($row['customer_note'])) {
    		$purchase->deliverycharge = 'y';
    		$purchase->specialinstructionsdelivery = $row['customer_note'];
    	}
    	
    	debug($purchase);
    	
    	$this->Purchase->save($purchase);
    	$pn = $purchase->PURCHASE_No;
    	echo '<br/>Purchase_No=' . $pn;
    	return $pn;
	}
	
	private function _buildAccessories($pn, $row, $vatRate) {
		
		$strLineItems = str_replace("&amp\;", "&", $row['line_items']);
		$lineitems = explode(";", $strLineItems);
		$accessories = [];
		
		foreach ($lineitems as $lineitem) {
			//debug($lineitem);
			$data = explode("|", $lineitem);
			//debug($data);
			
			$items = [];
			$meta = [];
			foreach ($data as $d) {
				$temp = explode(":", $d);
				$items[$temp[0]] = $temp[1];
				if ($temp[0] == 'meta' && !empty($temp[1])) {
					foreach (explode(",", $temp[1]) as $x) {
						$xx = explode("=", $x);
						$meta[$xx[0]] = $xx[1];
					}
				}
			}
			
			$accessory = [];
			$accessory['description'] = $items['name'];
			if (!empty($items['sku'])) {
				$accessory['productcode'] = $items['sku'];
			}
			if (!empty($meta)) {
				$accessory['design'] = '';
				if (array_key_exists('Style', $meta)) {
					$accessory['design'] .= $meta['Style'];
				}
				if (array_key_exists('Finishing', $meta)) {
					if (!empty($accessory['design'])) {
						$accessory['design'] .= ' ';
					}
					$accessory['design'] .= $meta['Finishing'];
				}
				if (array_key_exists('Tog', $meta)) {
					if (!empty($accessory['design'])) {
						$accessory['design'] .= ' ';
					}
					$accessory['design'] .= 'Tog=' . $meta['Tog'];
				}
				foreach ($meta as $mk => $mv) {
					if (strpos(strtolower($mk), 'size') !== false) {
						$accessory['size'] = $mv;
					}
				}
			}
			$accessory['unitprice'] = (1.0 + $vatRate/100.0) * floatval($items['subtotal']) / floatval($items['quantity']);
			$accessory['qty'] = intval($items['quantity']);
			$accessory['purchase_no'] = $pn;
			
			array_push($accessories, $accessory);
		}
		return $accessories;
	}
	
	private function _addAccessories($accessories) {
		
		foreach ($accessories as $accessory) {
			$acc = $this->Accessory->newEntity([]);
			$acc->description = $accessory['description'];
			if (array_key_exists('productcode', $accessory)) {
				$acc->productcode = $accessory['productcode'];
			}
			if (array_key_exists('design', $accessory)) {
				$acc->design = $accessory['design'];
			}
			if (array_key_exists('size', $accessory)) {
				$acc->size = $accessory['size'];
			}
			$acc->unitprice = $accessory['unitprice'];
			$acc->qty = $accessory['qty'];
			$acc->purchase_no = $accessory['purchase_no'];
			$this->Accessory->save($acc);
		}
	}
	
	private function _addCoupons($pn, $row) {
		
		if (empty($row['coupon_items'])) {
			return;
		}
		
		$strCouponItems = str_replace("&amp\;", "&", $row['coupon_items']);
		$couponitems = explode(";", $strCouponItems);
		$coupons = [];
		
		foreach ($couponitems as $couponitem) {
			//debug($couponitem);
			$data = explode("|", $couponitem);
			//debug($data);

			$coupObj = $this->PurchaseCoupon->newEntity([]);
			$coupObj->purchase_no = $pn;
			
			foreach ($data as $d) {
				$temp = explode(":", $d);
				//debug($temp);
				if ($temp[0] == 'id' && !empty($temp[1])) {
					$coupObj->coupon_id = $temp[1];
				}
				if ($temp[0] == 'code' && !empty($temp[1])) {
					$coupObj->code = $temp[1];
				}
				if ($temp[0] == 'amount' && !empty($temp[1])) {
					$coupObj->amount = $temp[1];
				}
				if ($temp[0] == 'description' && !empty($temp[1])) {
					$coupObj->description = $temp[1];
				}
			}
			
			$coupObj->virtual_idlocation = $this->_getVirtualIdLocation($coupObj->code);
			$this->PurchaseCoupon->save($coupObj);
		}
	}
	
	private function _getVirtualIdLocation($couponCode) {
		if (empty($couponCode)) {
			return null;
		}
		
		$stub = substr($couponCode, 0, 3);
		$query = $this->CouponCodeMapping->find()->where(['cc_stub' => strtoupper($stub)]);
		$idLocation = null;
		foreach ($query as $row) {
			$idLocation = $row['idlocation'];
		}
		return $idLocation;
	}
	
	private function _addPayment($pn, $receiptNo, $row) {
		$placedplaced = null;
		try {
			$placedplaced = FrozenTime::createFromFormat('Y-m-d H:i:s', $row['date'], 'Europe/London');
		} catch (Exception $e) {
			$placedplaced = FrozenTime::createFromFormat('d/m/Y H:i', $row['date'], 'Europe/London');
		}
		
		$payment = $this->Payment->newEntity([]);
		$payment->amount = $row['order_total'];
		$payment->salesusername = 'Ecommerce';
		$payment->paymentmethodid = 1; // credit card
		$payment->paymenttype = 'Full Payment';
		$payment->purchase_no = $pn;
		$payment->placed = $placedplaced;
		$payment->receiptno = $receiptNo;
		
		//debug($payment);
		$this->Payment->save($payment);
		$paymentId = $payment->paymentid;
    	echo '<br/>paymentid=' . $paymentId;
		return $paymentId;
	}
	
	private function _addOrderNote($pn, $row) {
		$createddate = null;
		try {
			$createddate = FrozenTime::createFromFormat('Y-m-d H:i:s', $row['date'], 'Europe/London');
		} catch (Exception $e) {
			$createddate = FrozenTime::createFromFormat('d/m/Y H:i', $row['date'], 'Europe/London');
		}
		
		$note = $this->OrderNote->newEntity([]);
		$note->purchase_no = $pn;
		$note->createddate = $createddate;
		$note->username = 'Ecommerce';
		$note->notetext = "Customer Notes from Website Order - " . $row['customer_note'];
		$note->action = 'Completed';
		$note->notetype = 'AUTO';
		$note->followupdate = $note->createddate;
		$note->NoteCompletedDate = $note->createddate;
		$note->NoteCompletedBy = 'Ecommerce';
		
		$this->OrderNote->save($note);
		$ordernote_id = $note->ordernote_id;
    	echo '<br/>ordernote_id=' . $ordernote_id;
		return $ordernote_id;
	}
	
	private function _addQcHistory($pn, $row, $now) {
		$qcHistory = $this->QcHistory->newEntity([]);
		$qcHistory->ComponentID = 9; // accessories
		$qcHistory->QC_StatusID = 0;
		$qcHistory->Purchase_No = $pn;
		$qcHistory->QC_Date = $now;
		$qcHistory->UpdatedBy = 3; // Ecommerce user
		$qcHistory->MadeAt = 0;
		
		//debug($qcHistory);
		$this->QcHistory->save($qcHistory);
		$qcHistoryId = $qcHistory->QC_HistoryID;
    	echo '<br/>QC_HistoryID=' . $qcHistoryId;
		return $qcHistoryId;
	}
	
	private function _sendNewPaymentEmail($pn, $orderNumber, $receiptNo, $row, $money) {
		$query = $this->Location->find()->where(['idlocation' => 1]);
		$cc = null;
		foreach ($query as $row2) {
			$cc = $row2['payment_notification_email'];
		}
		
		$to = 'SavoirAdminAccounts@savoirbeds.co.uk';
		$from = 'noreply@savoirbeds.co.uk';
		$fromName = 'Savoir Admin';
		$subject = $row['billing_last_name'];
		if (!empty($row['billing_company'])) {
			$subject .= ' - ' . $row['billing_company'];
		}
		$subject .= ' - ' . $orderNumber . ' - ' . $row['order_currency'] . $money['total'] . ' - Credit Card';
		
        $content = "<html><body><font face='Arial, Helvetica, sans-serif'><b>CUSTOMER PAYMENT</b><br /><table width='98%' border='1'  cellpadding='3' cellspacing='0'>";
        $content .= "<tr><td>Order Type</td><td>&nbsp;Website Order</td></tr>";
        $content .= "<tr><td>Payment Amount</td><td>&nbsp;" . $row['order_currency'] . $money['total'] . "</td></tr>";
        $content .= "<tr><td>Payment Type</td><td>&nbsp;Credit Card</td></tr>";
        $content .= "<tr><td>Customer Surname</td><td>&nbsp;" . $row['billing_last_name'] . "</td></tr>";
        $content .= "<tr><td>Company</td><td>&nbsp;" . $row['billing_company'] . "</td></tr>";
        $content .= "<tr><td>Order No</td><td>&nbsp;" . $orderNumber . "</td></tr>";
        $content .= "<tr><td>Amount Outstanding on this order</td><td>&nbsp;" . $row['order_currency'] . "0.00</td></tr>";
        $content .= "<tr><td>Order Total Amount</td><td>&nbsp;" . $row['order_currency'] . $money['total'] . "</td></tr>";
        $content .= "<tr><td>Payment Source</td><td>&nbsp;Bedworks</td></tr>";
        $content .= "<tr><td>Price List</td><td>&nbsp;Retail</td></tr>";
        $content .= "<tr><td>Receipt No.</td><td>&nbsp;" . $receiptNo . "</td></tr>";
		$content .= "<tr><td>Customer Reference: </td><td>&nbsp;" . 'WEB ORDER ' . $row['order_number'] . "</td></tr>";
        $content .= "</font></body></html>";
		
    	$this->emailServices->generateBatchEmail($to, $cc, $from, $fromName, $subject, $content, 'html', null);
	}
	
	private function _sendNewOrderEmail($pn, $orderNumber, $receiptNo, $accessories, $row, $money) {

		$msg = "This auto generated email has been sent to the distribution group called SavoirAdminNewOrder@savoirbeds.co.uk and confirms the following new order<br /><br />";
		$msg .= "<html><body><font face='Arial, Helvetica, sans-serif'>";
		$msg .= "<b>CUSTOMER DETAILS</b><br /><table width='98%' border='1'  cellpadding='3' cellspacing='0'>";
		$msg .= "<tr><td width='10%'>Contact:</td><td width='23%'>Ecommerce</td>";
		$msg .= "<td colspan='2'>Invoice Address:</td><td colspan='2'>Delivery Address:</td></tr>";
		$msg .= "<tr><td>Order No:</td><td>&nbsp;" . $orderNumber . "</td>";
		$msg .= "<td width='8%'>Line 1: </td><td width='28%'>" . $row['billing_address_1'] . "</td>";
		$msg .= "<td width='8%'>Line 1: </td><td width='23%'>" . $row['shipping_address_1'] . "</td></tr>";
		$msg .= "<tr><td>Date of order: </td><td>&nbsp;" . $row['date'] . "</td>";
		$msg .= "<td>Line 2: </td><td>&nbsp;" . $row['billing_address_2'] . "</td>";
		$msg .= "<td>Line 2: </td><td>&nbsp;" . $row['shipping_address_2'] . "</td></tr>";
		$msg .= "<tr><td>Email: </td><td>&nbsp;" . $row['billing_email'] . "</td>";
		$msg .= "<td>Town: </td><td>&nbsp;" . $row['billing_city'] . "</td>";
		$msg .= "<td>Town: </td><td>&nbsp;" . $row['shipping_city'] . "</td></tr>";
		$msg .= "<tr><td>Order Type: </td><td>&nbsp;Website Order</td>";
		$msg .= "<td>County: </td><td>&nbsp;" . $row['billing_state'] . "</td>";
		$msg .= "<td>County: </td><td>&nbsp;" . $row['shipping_state'] . "</td></tr>";
		$msg .= "<tr><td>Surname:</td><td>&nbsp;" . $row['billing_last_name'] . "</td>";
		$msg .= "<td>Postcode: </td><td>&nbsp;" . $row['billing_postcode'] . "</td>";
		$msg .= "<td>Postcode: </td><td>&nbsp;" . $row['shipping_postcode'] . "</td></tr>";
		$msg .= "<tr><td>Tel Home:</td><td>&nbsp;" . $row['billing_phone'] . "</td>";
		$msg .= "<td>Country: </td><td>&nbsp;" . $row['billing_country'] . "</td>";
		$msg .= "<td>Country: </td><td>&nbsp;" . $row['shipping_country'] . "</td></tr>";
		$msg .= "<tr><td>Company Name: </td><td>&nbsp;" . $row['billing_company'] . "</td>";
		$msg .= "<td>Customer Reference: </td><td>&nbsp;" . 'WEB ORDER ' . $row['order_number'] . "</td></tr>";
		$msg .= "</table>";
		$msg .= "<br/><br/>";
		
		$msg .= "<b>ACCESSORIES</b><br /><table width='98%' border='1' cellpadding='3' cellspacing='0'><tr><td><b>Description</b></td><td><b>Design</b></td><td><b>Product Code</b></td><td><b>Size</b></td><td><b>Unit Price</b></td><td><b>Qty</b></td></tr>";
		$accessoriestotalcost = 0.0;
		foreach ($accessories as $accessory) {
			$accessoriestotalcost += $accessory['unitprice'] * $accessory['qty'];
			$design = (array_key_exists('design', $accessory)) ? $accessory['design'] : '';
			$size = (array_key_exists('size', $accessory)) ? $accessory['size'] : '';
			$productcode = (array_key_exists('productcode', $accessory)) ? $accessory['productcode'] : '';
			$msg .= "<tr><td>" . $accessory['description'] . "</td><td>" . $design . "</td><td>" . $productcode . "</td><td>" . $size . "</td><td>" . number_format($accessory['unitprice'], 2, '.', '') . "</td><td>" . $accessory['qty'] . "</td></tr>";
		}
		$msg .= "</table>";
		
		$msg .= "<br /> ";
		$msg .= "<table width='563' border='1' cellpadding='0' cellspacing='2'>";
		$msg .= "<tr><td colspan='2'><strong>Order Summary - Order No. " . $orderNumber . "</strong></td></tr>";
		$msg .= "<tr><td>Accessories Total Cost</td><td>" . number_format($accessoriestotalcost, 2, '.', '') . "</td></tr>";
		$msg .= "<tr><td><strong>Bed Set Total</strong></td><td>" . number_format($accessoriestotalcost, 2, '.', '') . "</td></tr>";
		$msg .= "<tr><td><strong>Sub Total</strong></td><td>" . number_format($accessoriestotalcost, 2, '.', '') . "</td></tr>";
		
		$msg .= "<tr><td>Total excluding VAT</td><td>" . $money['totalexvat'] . "</td></tr>";
		$msg .= "<tr><td>VAT</td><td>" . $money['vat'] . "</td></tr>";
		$msg .= "<tr><td><strong>TOTAL</strong></td><td>" . $money['total'] . "</td></tr>";
		$msg .= "<tr><td>Payments Total</td><td>" . $money['total'] . "</td></tr>";
		$msg .= "<tr><td><strong>Balance Outstanding</strong></td><td>0.00</td></tr></table>";
        
		$msg .= "</font></body></html>";
		
		$to = 'SavoirAdminNewOrder@savoirbeds.co.uk';
		$cc = "david@natalex.co.uk";
		$from = 'noreply@savoirbeds.co.uk';
		$fromName = 'Savoir Admin';
		$subject = "NEW ORDER - " . $row['billing_last_name'] . " - " . $orderNumber . " - Bedworks";
		
    	$this->emailServices->generateBatchEmail($to, $cc, $from, $fromName, $subject, $msg, 'html', null);
	}
	
	private function _isFileNew($filename) {
    	$rs = $this->ImportOrderFiles->find('all', ['conditions'=> ['filename' => $filename]]);
    	$isNew = true;
    	foreach ($rs as $row) {
    		$isNew = false;
    	}
    	return $isNew;
    }

    private function _markFileAsProcessed($filename) {
    	$row = $this->ImportOrderFiles->newEntity([]);
    	$row->filename = $filename;
    	$this->ImportOrderFiles->save($row);
    }

    private function _validateRow($row) {
    	if (empty($row['billing_email'])) {
    		return 'billing_email not provided';
    	}
    	
    	if (empty($row['billing_postcode'])) {
    		return 'billing_postcode not provided';
    	}
    	
    	if (empty($row['billing_country'])) {
    		return 'billing_country not provided';
    	}
    	
    	return null;
    }
    
	protected function _getHeader() {
		return $this->oHeader;
	}
}
?>