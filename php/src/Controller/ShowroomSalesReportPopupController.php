<?php
namespace App\Controller;
use Cake\ORM\TableRegistry;

class ShowroomSalesReportPopupController extends SecureAppController {
	
    public function index() {
    	$this->viewBuilder()->setLayout('savoir');
    	$showrooms = TableRegistry::get('Location');
    	
    	$activeshowrooms = [];
    	
    	if ($this->isSuperuser() || $this->getCurrentUserLocationId()==1) {
    		// superuser see all showrooms
    		$activeshowrooms = $showrooms->getActiveShowrooms();
    	} else {
    		// the rest just get their own showroom (e.g. sales people)
    		$activeshowrooms = $showrooms->getActiveShowrooms('', $this->getCurrentUserLocationId());
    	}
       	
    	$this->set('showroomid', $this->getCurrentUserLocationId());
		$this->set('activeshowrooms', $activeshowrooms);
    }
	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR", "REGIONAL_ADMINISTRATOR", "SALES"];
	}
}

?>
