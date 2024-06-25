<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;
use Cake\Event\EventInterface;

class CustomerservicehistoryController extends SecureAppController

{
    public function initialize() : void {
        parent::initialize();
        $this->loadComponent('Paginator');
        $this->loadModel('Location');
    }    
    public function index()
    {
        $filter = (object)array(
            "datefrom" => "",
            "dateto"=>""
        );
        
        $this->viewBuilder()->setLayout('savoirdatatables');
        $Customerservice = TableRegistry::get('Customerservice');
        
        $datefrom='';
        $dateto='';
        $this->set('datefrom', $datefrom);
		$this->set('dateto', $dateto);
        if ($this->request->is('post')) {
        	$formData = $this->request->getData();
            $datefrom = $formData['datefrom'];
			$dateto = $formData['dateto'];
			if ($datefrom=='') {
				$datefrom=new DateTime('2012-01-01');
				}
			if ($dateto=='') {
				$dateto=new DateTime();
				}
			$this->set('datefrom', $this->_getSafeValueFromForm($formData, 'datefrom'));
			$this->set('dateto', $this->_getSafeValueFromForm($formData, 'dateto'));
        }
       
        $noofrecs=0;
        $customerservices = $Customerservice->getClosedCases($this,$this->getCurrentUserRegionId(),$this->getCurrentUserLocationId(),$datefrom,$dateto);
        $noofrecs=count($customerservices);
        $this->set('customerservices', $customerservices);
        $this->set('noofrecs', $noofrecs);
    }
    public function export()
    {
        
        $Customerservice = TableRegistry::get('Customerservice');
        $formData = $this->request->getData();
		$datefrom = $formData['datefrom'];
		$dateto = $formData['dateto'];
			
		//debug($datefrom);
		//debug($dateto);
		//die;
		$this->set('datefrom', $this->_getSafeValueFromForm($formData, 'datefrom'));
		$this->set('dateto', $this->_getSafeValueFromForm($formData, 'dateto'));
        $customerservices = $Customerservice->getClosedCases($this,$this->getCurrentUserRegionId(),$this->getCurrentUserLocationId(),$datefrom,$dateto);
		$data = [];
        
		$replacementprice=0;
		$replacementpriceTotal=0;
		
        foreach ($customerservices as $row) {
        $dataentrydate='';
        $datecaseclosed='';
				
				if (isset($row['dataentrydate'])) {
				$dataentrydate .= date("d/m/Y", strtotime(substr($row["dataentrydate"],0,10)));
				}
				if (isset($row['datecaseclosed'])) {
				$datecaseclosed .= date("d/m/Y", strtotime(substr($row["datecaseclosed"],0,10)));
				}
		$replacementprice=0.00;
        if ($row['replacementprice'] != '') {
        	$replacementprice=$row['replacementprice'];
        	$replacementpriceTotal += $replacementprice;
        }
			
		$a = [$row['CSNumber'], $row['adminheading'], $row['OrderNo'], $dataentrydate, $datecaseclosed, $row['closedcasenotes'], $replacementprice, $row['ServiceCode'], $row['closedby']];
			array_push($data, $a);
			
        }
        $_header = ["Customer Service No","Location","Order No","Customer Service Date","Date Closed","Closing Notes","Replacement Price (£)","Service Code","Closed By"];
        $_footer = ["Total:","","","","","","£".$replacementpriceTotal,"",""];
        
        



       	$this->setResponse($this->getResponse()->withDownload('customer-service-history.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $_header,
            'footer' => $_footer
    	]);
    	
		
    }
    
    private function _getSafeValueFromForm($formData, $name) {
		$value = "";
		if (isset($formData[$name])) {
			$value = $formData[$name];
		}
		return $value;
	}
    protected function _getAllowedRoles(){
        return array("ADMINISTRATOR","SALES");
    }
}
?>