<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \DateTime;

class HeaderController extends SecureAppController {

    public function index() {
        $this->viewBuilder()->setLayout('ajax');
        
        $qchistory = TableRegistry::get('QCHistory');
        $manufacturedat = TableRegistry::get('ManufacturedAt');
		
		$LondonLeadTime = $qchistory->getLeadTime(2);
		$CardiffLeadTime = $qchistory->getLeadTime(1);
		$LondonItemNo = $qchistory->getNoItemsWeek(2);
		$CardiffItemNo = $qchistory->getNoItemsWeek(1);
		
		//debug("londonleadtime=" .$LondonLeadTime. "<br>Cardif=" .$CardiffLeadTime ."<br>LondonItem no=" .$LondonItemNo ."<br>CardifItem no=" .$CardiffItemNo);
		//die();
		$CardiffNo=round((floatval($CardiffLeadTime)/floatval($CardiffItemNo)+0.4999),0,PHP_ROUND_HALF_UP);
		$LondonNo=round((floatval($LondonLeadTime)/floatval($LondonItemNo)+0.4999),0,PHP_ROUND_HALF_UP);
		
		$this->set('CardiffNo', $CardiffNo);
		$this->set('LondonNo', $LondonNo);
	}
    
    

    protected function _getAllowedRoles(){
        return ["ALL"];
    }
}