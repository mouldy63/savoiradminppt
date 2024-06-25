<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class JobFlagController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		$this->loadComponent('Flash');
    	$this->loadModel('Purchase');
		$this->loadModel('Contact');		
	}
	
	public function index() {
		$purchaseTable = TableRegistry::get('Purchase');
        $this->viewBuilder()->setOptions([
            'pdfConfig' => [
                'orientation' => 'portrait',
            ]
        ]);
		$docroot=$_SERVER['DOCUMENT_ROOT'];
        $this->set('docroot', $docroot);
        
        $params = $this->request->getParam('?');
        $pn = $params['pn'];
		
        $query = $this->Purchase->find()->where(['PURCHASE_No' => $pn]);
		$purchase = null;
        $ordernumber = null;
		foreach ($query as $row) {
			$purchase = $row;
			
		}
		$ordernumber = $purchase['ORDER_NUMBER'];
		$contact = $purchase['contact_no'];
		$code = $purchase['CODE'];
		$customerreference = $purchase['customerreference'];
		$this->set('ordernumber', $ordernumber);
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
		if ($contact['first'] != '') {
			$customername .= $contact['first'] ." ";
		}
		if ($contact['surname'] != '') {
			$customername .= $contact['surname'] ."";
		}
		$this->set('customername', $customername);

	
	}
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR","SALES");
	}

}

?>
