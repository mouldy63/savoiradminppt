<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class AccLabelprintController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
		$this->loadComponent('QrCode');
    	$this->loadModel('Purchase');
		$this->loadModel('Contact');	
		$this->loadModel('Address');
		$this->loadModel('Accessory');	
	}
	
	public function index() {
		$purchaseTable = TableRegistry::get('Purchase');
        $this->viewBuilder()->setOptions([
            'pdfConfig' => [
                'orientation' => 'landscape',
            ]
        ]);
		$docroot=$_SERVER['DOCUMENT_ROOT'];
        $this->set('docroot', $docroot);
        
        $params = $this->request->getParam('?');
        $pn = $params['pn'];
		$purchase = null;
        $ordernumber = null;
		
		$query = $this->Purchase->find()->where(['PURCHASE_No' => $pn]);
		foreach ($query as $row) {
			$purchase = $row;
			
		}
		$selected = $this->request->getQuery('selected');
		$accitems='';
		if ($selected) {
			// Decode the parameter and split it into an array
			$selectedArray = explode(',', urldecode($selected));

			// Iterate over each value
			foreach ($selectedArray as $value) {
				$query = $this->Accessory->find()->where(['orderaccessory_id' => $value]);
				foreach ($query as $row) {
					$qty=0;
					$qty=$row['qty']-$row['QtyToFollow'];
					$accitems.= $qty." x ";
					$accitems.=$row['description']." ";
					if (isset($row['design'])) {
						$accitems.= $row['design']." ";
					}
					if (isset($row['colour'])) {
						$accitems.= $row['colour']." ";
					}
					if (isset($row['size'])) {
						$accitems.= $row['size']." ";
					}
					$accitems.= "<br>";
				}
			}
		}
		$this->set('accitems', $accitems);	
        
		
		$header = "<p align='center'><img src='webroot/img/logo.jpg' width='255' height='42' style='position:relative;top:40px;' /></p>";
		$this->set('header', $header);
		$ordernumber = $purchase['ORDER_NUMBER'];
		$contact = $purchase['contact_no'];
		$code = $purchase['CODE'];

		$query = $this->Address->find()->where(['CODE' => $code]);
		$address = null;
		foreach ($query as $row) {
			$address = $row;
		}
		$company='';
		if (isset($address['company'])) {
			$company=$address['company'];
		}
		$customerreference = $purchase['customerreference'];
		$this->set('ordernumber', $ordernumber);
		$this->set('company', $company);
		$this->set('customerreference', $customerreference);
		$query = $this->Contact->find()->where(['CONTACT_NO' => $contact]);
		$contact = null;
		foreach ($query as $row) {
			$contact = $row;
		}
		
		$customername = '';
		if ($contact['title'] != '') {
			$customername .= $contact['title'] ." ";
		}
		if ($contact['surname'] != '') {
			$customername .= $contact['surname'] ."";
		}
		$this->set('customername', $customername);
		$qrdata="!MBASE".$ordernumber;
		$qrcode="<img src='webroot/img/" . $this->QrCode->getOrderNumberImageUrl($qrdata) . "' width='200px' height='200px'/>";
		
		$this->set('qrcode', $qrcode);
	}
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR","SALES");
	}

}

?>
