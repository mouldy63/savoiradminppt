<?php
namespace App\View\Helper;
use Cake\View\Helper;

class SecurityHelper extends Helper {
	
	public function initialize(array $config) : void {
        //debug($config);
    }
	
    public function userHasRoleInList($roleListStr) {
    	$roles = explode(",",$roleListStr);
    	$userHasRole = false;
    	foreach ($roles as $role) {
    		if ($this->userHasRole($role)) {
    			$userHasRole = true;
    			break;
    		}
    	}
    	return $userHasRole;
    }

    public function userHasRole($role) {
    	$userHasRole = false;
    	foreach($this->getConfig()['userroles'] as $id => $name) {
    		if ($role == $name) {
    			$userHasRole = true;
    			break;
    		}
    	}
    	return $userHasRole;
    }

    public function retrieveUserRegion() {
    	return $this->getConfig()['userregion'];
    }

    public function retrieveUserLocation() {
    	return $this->getConfig()['userlocation'];
    }

    public function retrieveUserSite() {
    	return $this->getConfig()['usersite'];
    }
    
    public function retrieveUserId() {
    	return $this->getConfig()['userid'];
    }
    
    public function retrieveUserName() {
    	return $this->getConfig()['username'];
    }
    
    public function isSuperuser() {
    	return $this->getConfig()['issuperuser'];
    }

    public function isSavoirOwned() {
    	return $this->getConfig()['issavoirowned'];
    }
}