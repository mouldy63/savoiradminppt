<?php
namespace App\Controller;
use Cake\View\View;

class RevenueController extends SecureAppController{
	public function initialize() : void {
            parent::initialize();
		//$this->loadComponent('Cookie');
            $this->loadModel('Revenue');
	}
	public function index(){
		$thisYear = date('Y');
		$years = array();
		for($i=2015;$i<=$thisYear;$i++){
			$years[] = $i;
		}
		$data['years'] = $years;
		$data['showroom'] = $this->Revenue->getShowroom();
                $this->viewBuilder()->setLayout('fabricstatus');
		$this->set('data',$data);
	}
	
    
	public function getRevenue(){
		if($this->request->is('ajax')){
			$raw = $this->request->getData()['revenue'];
			$data = json_decode($raw,true);
			if($data["dataformat"]=='table'){
				$rawRevenue = $this->Revenue->getRevenuesData($data);
				$view = new View($this->request, null);
				$data['table'] = $view->element('revenueTable', array('data'=>$rawRevenue));
				echo json_encode($data);
				die();
			}
		}else if($this->request->is('post')){
                    $raw = $this->request->getData()['revenue'];
                    $data = json_decode($raw,true);
                    $data = $this->Revenue->getRevenuesCSV($data);
                    
                    $response = $this->response;
                    $response = $response->withStringBody($data);
                    $response = $response->withType('csv');
                    $response = $response->withDownload('export.csv');
                    return $response;
		}else{
			$this->redirect(array('controller' =>'revenue', 'action' => 'index'));
		}
	}
	
   protected function _getAllowedRoles() {
    	return array("ADMINISTRATOR");
    }
}

?>
