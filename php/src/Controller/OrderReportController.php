<?php
namespace App\Controller;

class OrderReportController extends SecureAppController{
	public function initialize() : void {
            parent::initialize();
            $this->loadModel('OrderReportModel');
	}
	public function index(){
                if (isset($this->request->getData()['ids'])) {
                    $ids = $this->request->getData()['ids'];
                } else {
                    $ids = $this->request->getQuery('ids');
                }
		$data= array();
		$idArray = explode(',', $ids);
		if(count($idArray)>0){
			foreach ($idArray as $id){
				$t = $this->OrderReportModel->getOrderDetail($id);
				array_push($data, $t);
			}
		}
		else{
			$data= null;
		}
                $this->viewBuilder()->setLayout('fabricstatus');
		$this->set('data',$data);
	}
   	protected function _getAllowedRoles() {
    	return array("ADMINISTRATOR");
    }
}
?>