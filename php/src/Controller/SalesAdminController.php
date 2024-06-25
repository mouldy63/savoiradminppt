<?php
namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use \App\Controller\Component\UtilityComponent;
use \DateTime;

use App\Controller\AppController;

class SalesAdminController extends SecureAppController {

	public function initialize() : void {
		parent::initialize();
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
	}

    protected function _getAllowedRoles(){
        return ["ALL"];
    }
}