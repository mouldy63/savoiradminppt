<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;
use Cake\Event\EventInterface;

class DeliveriesBookedController extends IpRestrictedAppController
{
	public function initialize() : void {
		parent::initialize();
		set_time_limit(120);
		$this->loadModel('Purchase');
		$this->loadModel('QcHistoryLatest');
    }
    
    public function beforeRender(EventInterface $event) {
    	parent::beforeRender($event);
    	$builder = $this->viewBuilder();
    	$builder->addHelpers([
        	'AuxiliaryData'
        ]);
    }
	
    public function index() {
		$this->viewBuilder()->setLayout('monitorpage');
		
		$ProductionListTable = TableRegistry::get('ProductionList');
		$factory='';
		$factoryname='';
		$today = getdate();
		
		$params = $this->request->getParam('?');
		if ($params != '') {
			$factory = $params['madeat'];
			if ($factory == '1') {
			   $factoryname = 'CardiffProductionDate';
			} else {
				$factoryname = 'LondonProductionDate';
			}
		}
		
		$getNoFloorItems = $ProductionListTable->getProductionFloorItems($factory);
		//debug($getNoFloorItems);
		//die;
		$bookeddeliveries = $ProductionListTable->getBookedDeliveries($factoryname);
		//debug($bookeddeliveries);
		//die;		
		$this->set('bookeddeliveries', $bookeddeliveries);
		$this->set('getNoFloorItems', $getNoFloorItems);
		$this->set('factory', $factory);
	}
	

	
	protected function _getAllowedRoles() {
		return ["ADMINISTRATOR"];
	}
    
}

?>
