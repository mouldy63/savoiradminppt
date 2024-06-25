<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

class GiftpackController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
		set_time_limit(120);
		$this->loadModel('Communication');
		$this->loadModel('Correspondence');
		$this->loadModel('Purchase');
		$this->loadModel('Location');
		$this->loadModel('SavoirUser');
    }
	
    public function index() {
		$this->viewBuilder()->setLayout('printx');
		$this->viewBuilder()->setOptions([
            'pdfConfig' => [
                'orientation' => 'portrait',
            ]
        ]);
		$docroot=$_SERVER['DOCUMENT_ROOT'];
        $this->set('docroot', $docroot);
        
        $proto = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') ? 'https' : 'http';
    	
    	//debug($this->request->getData());
		$contactTable = TableRegistry::get('Contact');
		$addressTable = TableRegistry::get('Address');
		$purchaseTable = TableRegistry::get('Purchase');
		$corresondenceTable = TableRegistry::get('Correspondence');
		$showroomTable = TableRegistry::get('Location');
		$userTable = TableRegistry::get('SavoirUser');
		$params = $this->request->getParam('?');
        $pn = $params['pn'];
        $letterdate='';
        $query = $this->Purchase->find()->where(['PURCHASE_No' => $pn]);
		foreach ($query as $row) {
			$purchase = $row;
			
		}

		$letterdate=$purchase['bookeddeliverydate'];
		$this->set('letterdate', $letterdate);
		$query = $this->Location->find()->where(['idlocation' => $purchase['idlocation']]);
		foreach ($query as $row) {
			$location = $row;
		}
	    $showroomtel=$location['tel'];
	    $showroomtel=str_replace("(","",$showroomtel);
	    $showroomtel=str_replace(")","",$showroomtel);
	    $showroomtel=preg_replace('/ /', '', $showroomtel, 1);
	    
	    
	    $showroom=$location['adminheading'];
		$this->set('showroom', $showroom);
		$client=$contactTable->getContact($purchase['contact_no'])[0];
		if ($client['isVIP'] == 'y') {
				$letter = 24;
			} else {
				$letter=21;
			}
		
		$query = $this->SavoirUser->find()->where(['username' => $purchase['salesusername']]);
		foreach ($query as $row) {
			$salesuser = $row;
		}
		
		$query = $this->Correspondence->find()->where(['correspondenceid' => $letter]);
		foreach ($query as $row) {
			$correspondence = $row;
		}
		$corres=$correspondence['correspondence'];
		
		if ($letter==24) {
			$corres=substr($corres, 0, strlen($corres)-4);
			$letter = $corres;
		} else {
			$corres=substr($corres, 0, strlen($corres)-6);
		$letter = $corres." ".$showroom." showroom on ".$showroomtel.". ".$correspondence['correspondence2'];
	}
		$this->set('letter', $letter);
				
		$username=$salesuser['name'];
		$this->set('username', $username);	
        
		$address='<p>';
		if ($client['title'] != '') {
		$address .= ucwords($client['title'])." ";
		}
		if ($client['surname'] != '') {
		$address .= ucwords($client['surname'])."<br>";
		}
		if ($client['company'] != '') {
		$address .= ucwords($client['company'])."<br>";
		}
		$salutation = "";
		if ($correspondence['greeting']=="Dear") {
			$salutation = "Dear ";
			if ($client['title'] != '') {
				$salutation .= $client['title'] ." ";
			}
			if ($client['surname'] != '') {
				$salutation .= $client['surname'];
			}
		}
		$deladd='n';
		if ($purchase['deliveryadd1'] != '') {
			$address .= $purchase['deliveryadd1']."<br>";
			$deladd='y';
			if ($purchase['deliveryadd2'] != '') {
			$address .= $purchase['deliveryadd2']."<br>";
			}
			if ($purchase['deliveryadd3'] != '') {
			$address .= $purchase['deliveryadd3']."<br>";
			}
			if ($purchase['deliverytown'] != '') {
			$address .= $purchase['deliverytown']."<br>";
			}
			if ($purchase['deliverycounty'] != '') {
			$address .= $purchase['deliverycounty']."<br>";
			}
			if ($purchase['deliverypostcode'] != '') {
			$address .= $purchase['deliverypostcode']."<br>";
			}
			if ($purchase['deliverycountry'] != '') {
			$address .= $purchase['deliverycountry'];
			}	
		}

       if ($deladd=='n') {
		
			if ($client['street1'] != '') {
			$address .= ucwords($client['street1'])."<br>";
			}
			if ($client['street2'] != '') {
			$address .= ucwords($client['street2'])."<br>";
			}
			if ($client['street3'] != '') {
			$address .= ucwords($client['street3'])."<br>";
			}
			if ($client['town'] != '') {
			$address .= ucwords($client['town'])."<br>";
			}
			if ($client['county'] != '') {
			$address .= ucwords($client['county'])."<br>";
			}
			if ($client['postcode'] != '') {
			$address .= ucwords($client['postcode'])."<br>";
			}
			if ($client['country'] != '') {
			$address .= ucwords($client['country'])."<br>";
			}
		}

		$address .= "</p>";
		
		$bankref=$purchase['ORDER_NUMBER'];
		$bankref.="-".$client['surname'];
		$this->set('salutation', $salutation);
		$this->set('address', $address);
		
	}
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR","SALES"];
	}
    
}

?>
