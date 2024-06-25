<?php
namespace App\Controller;

use Cake\ORM\TableRegistry;
use Cake\Event\EventInterface;
use Cake\Routing\Router;

class SecureAppController extends AppController {
    private $currentUser;
    private $currentUserLocation;
    
    public function initialize() : void {
        parent::initialize();
        $this->loadComponent('SavoirSecurity');
        date_default_timezone_set('Europe/London');
        
        if (!$this->SavoirSecurity->isUserLoggedOn()) {
            $retUrl = Router::url(null, true);
            $url = env($_SERVER["HTTP_HOST"]) . '/access/access.asp';
            if (!empty($retUrl)) {
            	$url = $url . "?ret=" . urlencode($retUrl);
            }
            header('Location: ' . $url, true, 302);
            exit();
        }
        
        $savoirUser = TableRegistry::get('SavoirUser');
        $this->currentUser = $savoirUser->get($this->SavoirSecurity->getCurrentUsersId());
    	$locationTable = TableRegistry::get('Location');
        $this->currentUserLocation = $locationTable->find('all', ['conditions'=> ['idlocation' => $this->getCurrentUserLocationId()]])->toArray()[0];
        
        $canUsePage = false;
        $this->log("super=" . $this->SavoirSecurity->isSuperuser());
        if ($this->SavoirSecurity->isSuperuser()) {
        	$canUsePage = true;
        } else {
			if ($this->_isSuperuserOnly()) {
        		echo "<p>You must be a superuser to use this page</p>";
        		die;
			}        	
	        $allowedRoles = $this->_getAllowedRoles();
	        $userRoles = $this->SavoirSecurity->getRoles();
	        $roleOK = false;
        	if (isset($allowedRoles)) {
				foreach ($allowedRoles as $allowedRole) {
        			$this->log("allowedRole=" . $allowedRole);
					if ($allowedRole == "ALL" || in_array($allowedRole, $userRoles)) {
						$roleOK = true;
						break;
					}
				}
	        }

	        $allowedRegionData = $this->_getAllowedRegions();
	        $allowedRegions = $allowedRegionData[0];
	        $andAllowedRegions = true;
	        if (isset($allowedRegionData[1]) && $allowedRegionData[1] == "OR") {
		        $andAllowedRegions = false;
	        }
	        $regionOK = false;
        	$regionTable = TableRegistry::get('Region');
        	$userRegion = $regionTable->get($this->getCurrentUserRegionId());
	        if (isset($allowedRegions)) {
				foreach ($allowedRegions as $allowedRegion) {
        			$this->log("allowedRegion=" . $allowedRegion);
					if ($allowedRegion == "ALL" || $userRegion['name'] == $allowedRegion) {
						$regionOK = true;
						break;
					}
				}
	        }
	        
	        if ($andAllowedRegions) {
		        $canUsePage = $roleOK && $regionOK;
	        } else {
		        $canUsePage = $roleOK || $regionOK;
	        }
        }
        
		if (!$canUsePage) {
        	echo "<p>You do not have an appropriate role to use this page</p>";
        	die;
        }
    }
    
    public function beforeRender(EventInterface $event)
    {
        parent::beforeRender($event);
    	$userRoles = $this->_getUserRoles();
    	$this->set('userroles', $userRoles);
        $builder = $this->viewBuilder();
        $builder->addHelpers([
            'Security' => ['userroles' => $userRoles, 
            				'userregion' => $this->getCurrentUserRegionId(), 
            				'userlocation' => $this->getCurrentUserLocationId(), 
            				'usersite' => $this->getCurrentUserSite(),
            				'userid' => $this->SavoirSecurity->getCurrentUsersId(),
            				'username' => $this->SavoirSecurity->getCurrentUserName(),
        					'issuperuser' => $this->SavoirSecurity->isSuperuser(),
        					'issavoirowned' => ($this->currentUserLocation['SavoirOwned'] == 'y')],
            'MyForm' => ['foo' => 'bar'],
            'AuxiliaryData' => ['foo' => 'bar']
        ]);
    }

    protected function _getAllowedRoles() {
    	return null;
    }
    
    protected function _getAllowedRegions(){
    	// return [["London"], "OR"];
    	// return [["London","Wales"], "AND"];
        return [["ALL"]];
    }
    
    protected function _isSuperuserOnly(){
        return false;
    }
    
    public function _userHasRole($roleName) {
    	return $this->SavoirSecurity->userHasRole($roleName);
    }
    
    public function _getUserRoles() {
    	return $this->SavoirSecurity->getRoles();
    }
    
    public function getCurrentUserSite() {
    	return $this->currentUser->site;
    }
	
	public function getCurrentUserName() {
    	return $this->currentUser->username;
    }

    public function getCurrentUserLocationId() {
    	return $this->currentUser->id_location;
    }

    public function getCurrentUserRegionId() {
    	return $this->currentUser->id_region;
    }
    
    public function isSavoirOwned() {
    	return ($this->currentUserLocation['SavoirOwned'] == 'y');
    }

    public function isSuperuser() {
		return $this->SavoirSecurity->isSuperuser();
	}

    public function getCurrentUsersId() {
    	return $this->SavoirSecurity->getCurrentUsersId();
	}
}
?>
