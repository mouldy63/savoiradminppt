<?php
namespace App\Controller;
use Cake\ORM\TableRegistry;

class CustomersController extends SecureAppController {
    public $helpers = array('Html', 'Form');
    public $autoRender = true;
    
    public function initialize() : void {
        parent::initialize();
        $this->loadComponent('Paginator');
    }    
    
    public $paginate = [
        'contain' => 'Address',
        'limit' => 50,
        'order' => [
            'Contact.surname' => 'asc', 'Contact.first' => 'asc'
        ]
    ];

    public function index() {
    	$this->autoRender = true;
        $this->viewBuilder()->setLayout('cake2default');
    	$this->set('title_for_layout', 'Maintain Customers');
        $contact = TableRegistry::get('Contact');

        $query = $contact->find('all', 
                                ['contain' => ['Address']]
                                );
        $customerList = $this->Paginator->paginate($query, $this->paginate);
        
//        debug($query);
//        debug($customerList);
//        die;
        $this->set('customers', $customerList);
        $this->set('title', 'Maintain Customers');
    }

    public function getCustomer($customerId) {
    	$this->autoRender = false;
        $this->viewBuilder()->setLayout('ajax');
    	
    	$vals = explode("-", $customerId);
    	$contactNo = $vals[0];
    	$code = $vals[1];
    	
    	$customer = $this->_getCustomer($contactNo, $code);
        //debug(json_encode($customer));
    	
    	$this->response = $this->response->withStringBody(json_encode($customer));
    }
    
    private function _getCustomer($contactNo, $code) {
        $contact = TableRegistry::get('Contact');
        $customer = $contact->find('all', ['contain' => ['Address']])
                    ->andWhere(['Contact.CONTACT_NO' => $contactNo, 'Address.CODE' => $code]);

        //debug($customer);
        
    	return $customer->first()->toArray();
    }

    public function saveCustomer($customerId) {
    	$this->autoRender = false;
        $this->viewBuilder()->setLayout('ajax');
    	
    	$vals = explode("-", $customerId);
    	$contactNo = $vals[0];
    	$code = $vals[1];
        
        //var_dump($this->request->getQuery());
        //die;
    	
    	// CONTACT
        $contact = TableRegistry::get('Contact');
    	$existingRow = $contact->get($contactNo);
    	
    	$params = array();
    	$this->_pushQueryParam($params, 'title', $existingRow, 'title');
    	$this->_pushQueryParam($params, 'first', $existingRow, 'first');
    	$this->_pushQueryParam($params, 'surname', $existingRow, 'surname');
    	$this->_pushQueryParam($params, 'acceptemail', $existingRow, 'acceptemail');
    	$this->_pushQueryParam($params, 'acceptpost', $existingRow, 'acceptpost');
        
        $existingRow->title = isset($params['title']) ? $params['title'] : null;
        $existingRow->first = isset($params['first']) ? $params['first'] : null;
        $existingRow->surname = isset($params['surname']) ? $params['surname'] : null;
        $existingRow->acceptemail = isset($params['acceptemail']) ? $params['acceptemail'] : null;
        $existingRow->acceptpost = isset($params['acceptpost']) ? $params['acceptpost'] : null;
	$contact->save($existingRow);
    	
    	// ADDRESS
    	$address = TableRegistry::get('Address');
    	$existingRow = $address->get($code);

    	$params = array();
    	$this->_pushQueryParam($params, 'company', $existingRow, 'company');
    	$this->_pushQueryParam($params, 'street1', $existingRow, 'street1');
    	$this->_pushQueryParam($params, 'street2', $existingRow, 'street2');
    	$this->_pushQueryParam($params, 'street3', $existingRow, 'street3');
    	$this->_pushQueryParam($params, 'town', $existingRow, 'town');
    	$this->_pushQueryParam($params, 'county', $existingRow, 'county');
    	$this->_pushQueryParam($params, 'postcode', $existingRow, 'postcode');
    	$this->_pushQueryParam($params, 'country', $existingRow, 'country');
    	$this->_pushQueryParam($params, 'email_address', $existingRow, 'EMAIL_ADDRESS');
    	$this->_pushQueryParam($params, 'status', $existingRow, 'STATUS');

        $existingRow->company = isset($params['company']) ? $params['company'] : null;
        $existingRow->street1 = isset($params['street1']) ? $params['street1'] : null;
        $existingRow->street2 = isset($params['street2']) ? $params['street2'] : null;
        $existingRow->street3 = isset($params['street3']) ? $params['street3'] : null;
        $existingRow->town = isset($params['town']) ? $params['town'] : null;
        $existingRow->county = isset($params['county']) ? $params['county'] : null;
        $existingRow->postcode = isset($params['postcode']) ? $params['postcode'] : null;
        $existingRow->country = isset($params['country']) ? $params['country'] : null;
        $existingRow->EMAIL_ADDRESS = isset($params['EMAIL_ADDRESS']) ? $params['EMAIL_ADDRESS'] : null;
        $existingRow->STATUS = isset($params['STATUS']) ? $params['STATUS'] : null;

        $address->save($existingRow);
    	$this->response = $this->response->withStringBody("Success");
   	}
   	
   	private function _pushQueryParam(&$data, $paramName, $resultSet, $resultSetName) {
   		$val = $this->request->getQuery($paramName);
   		$oldVal = $resultSet[$resultSetName];
   		//echo "<br>val = $val, oldval = $oldVal";
   		//echo "<br>val = " . is_null($val) . " oldval = " . is_null($oldVal);
   		if (isset($val) && $val != "") {
   			$data[$resultSetName] = trim($val);
   		} else if ( (isset($oldVal) && $oldVal != "") && (!isset($val) || $val == "") ) {
   			$data[$resultSetName] = null;
   		}
   	}

    protected function _getAllowedRoles() {
    	return array("ADMINISTRATOR","SALES");
    }
}
?>