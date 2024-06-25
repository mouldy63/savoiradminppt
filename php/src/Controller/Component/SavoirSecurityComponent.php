<?php
namespace App\Controller\Component;

use Cake\ORM\TableRegistry;

class SavoirSecurityComponent extends \Cake\Controller\Component {
	public $components = array('Utility');
	public $controller = null;
	public $session = null;
	private $sessCookieName = 'SavoirAdminSession';
	
	public function initialize(array $config) : void {
		parent::initialize($config);
	
		/**
		 * Get current controller
		*/
		$this->controller = $this->_registry->getController();
		$this->session = $this->controller->getRequest()->getSession();
	}
		
	public function isUserLoggedOn() {
		
		$savoirAdminSession = null;
		if (isset($_COOKIE[$this->sessCookieName])) {
			$savoirAdminSession = $_COOKIE[$this->sessCookieName];
		}
		if (empty($savoirAdminSession)) {
			$this->log("SavoirSecurityComponent.isUserLoggedOn: SavoirAdminSession cookie empty, so leaving");
			return false;
		}
		
		$userId = $this->session->read('userid');
		$this->log("SavoirSecurityComponent.isUserLoggedOn: userId from session=" . $userId);
		if (!empty($userId)) {
			// reset the cookie to expire in another 30 mins
			setcookie($this->sessCookieName, $savoirAdminSession, time() + 1800, "/");
			$this->log("SavoirSecurityComponent.isUserLoggedOn: userId already set in session, so leaving");
			return true;
		}
		
		$sessionLog = TableRegistry::get('SessionLog');
	
		$sessionLogQuery = $sessionLog->find('all', array('conditions'=> array('sessionid' => $savoirAdminSession), 'order' => array('sessionlog_id' => 'desc')));
		$this->log("SavoirSecurityComponent.isUserLoggedOn: sessionlog count = " . count($sessionLogQuery->toArray()));
		$this->log("SavoirSecurityComponent.isUserLoggedOn: sessionlog = " . $this->Utility->varDumpToString($sessionLogQuery));
		if (count($sessionLogQuery->toArray()) == 0) {
                    setcookie($this->sessCookieName, "", time() - 1, "/"); // delete the cookie as not logged on
                    $this->log("SavoirSecurityComponent.isUserLoggedOn: seesionlog count=0, so leaving");
                    return false;
		}
		$sessionLogRow = $sessionLogQuery->first();
		
		$userid = $sessionLogRow->user_id;
		$this->log("SavoirSecurityComponent.isUserLoggedOn: userid from sessionlog = " . $userid);
        $this->session->write('userid', $userid);
        if (isset($sessionLogRow->superuser)) {
        	$this->session->write('superuser', $sessionLogRow->superuser == 'True');
        }
        if (isset($sessionLogRow->roles)) {
        	$this->session->write('roles', $sessionLogRow->roles);
        }
        if (isset($sessionLogRow->username)) {
        	$this->session->write('username', $sessionLogRow->username);
        }
        
		// reset the cookie to expire in another 30 mins
        setcookie($this->sessCookieName, $savoirAdminSession, time() + 1800, "/");
        
        return true;
	}

	public function getCurrentUsersId() {
		if (!$this->isUserLoggedOn()) {
			return null;
		}
		return $this->session->read('userid');
	}
	
	public function getCurrentUserName() {
		if (!$this->isUserLoggedOn()) {
			return null;
		}
		return $this->session->read('username');
	}
	
	public function isSuperuser() {
		return $this->session->read('superuser');
	}
	
	public function getRoles() {
		if (empty($this->session->read('roles'))) {
			return "";
		}
		return explode(',', $this->session->read('roles'));
	}
	
    public function userHasRole($roleName) {
    	return in_array($roleName, $this->getRoles());
    }

}
