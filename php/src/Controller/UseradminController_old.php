<?php

namespace App\Controller;
use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;

class UseradminController extends SecureAppController {
	private $page;
        private $userAdmin;
        private $successMessages = [1 => 'The user %u has been created'
                                  , 2 => 'Roles successfully updated'
            ];
        private $errorMessages = [1 => 'Use must be a superuser to use this function'
                                  , 2 => 'No user id set'
                                  , 3 => 'Unknown error'
                                  , 4 => 'Error code not set'
            ];
        
	public function initialize() : void {
            parent::initialize();
            $this->loadComponent('SavoirSecurity');
            $this->loadComponent('Flash');
			//$this->loadComponent('Cookie');
			$this->loadComponent('SavoirSecurity');
			$this->page = 20;
            $this->userAdmin = TableRegistry::get('userAdmin');
	}
	public function index(){
		if(!$this->SavoirSecurity->isSuperuser()){
                        $this->viewBuilder()->setLayout('fabricstatus');
			$this->set('data',false);
                        $this->Flash->error($this->errorMessages[1]);
		}
		if($this->request->is('ajax')){
			$sort = explode('|',$this->request->getData()['sort']);
			$searchkey = $this->request->getData()['searchkey'];
			$filter = $this->request->getData()['filter'];
			$page = (int)$this->request->getData()['page'];
			
			$conditionArray = array();
			$conditionArray['sort'] = array('sortkey'=>$sort[0],'order'=>$sort[1]);
			$isSearch = !empty($searchkey)&& strlen($searchkey)>0;
			$isFilter = !empty($filter)&&strlen($filter)>0;
			if($isSearch){
				$conditionArray['searchkey'] = $searchkey;
			}
			if($isFilter){
				$conditionArray['filter'] = $filter;
			}
			
			$userinfo['users'] = $this->userAdmin->getUserInfo($page,$this->page,$conditionArray);
			if($isSearch || $isFilter){
				$userinfo['totalPage'] = $this->userAdmin->getSearchFilterTotalPages($this->page,$conditionArray);
			}else{
				$userinfo['totalPage'] = $this->userAdmin->getTotalPages($this->page);
			}
			
			$userinfo['currentPage'] = $page;
			$view = new View($this, false);
			$userinfo['table'] = $view->element('userAdminTable', array('users'=>$userinfo['users']));
			echo json_encode($userinfo);
			die();
		}
		else{
			$userinfo['users'] = $this->userAdmin->getUserInfo(1,$this->page,array('sort'=>array('sortkey'=>'name','order'=>'asc')));
			$userinfo['totalPage'] = $this->userAdmin->getTotalPages($this->page);
			$userinfo['currentPage'] = 1;
                        $this->viewBuilder()->setLayout('fabricstatus');
			$this->set('data',$userinfo);
		}
                if (isset($this->request->getQuery('errno')) && array_key_exists($this->request->getQuery('errno'), $this->errorMessages)) {
                    $this->Flash->error($this->errorMessages[$this->request->getQuery('errno')]);
                }
	}
	public function userDetail(){
		if(!$this->SavoirSecurity->isSuperuser()){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=1'));
		}
		$id = $this->request->getQuery('id');
		if(empty($id)||strlen($id)==0){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=2'));
		}
		$userinfo['user'] = $this->userAdmin->getUserById((int)$id);
		$info = $this->userAdmin->getCreatorModifier((int)$id);
		$userinfo['create'] = $info['create'];
		$userinfo['modify'] = $info['modify'];
		$this->set('data',$userinfo);
                $this->viewBuilder()->setLayout('fabricstatus');
                if (isset($this->request->getQuery('msgno')) && array_key_exists($this->request->getQuery('msgno'), $this->successMessages)) {
                    $msg = $this->successMessages[$this->request->getQuery('msgno')];
                    $msg = sprintf($msg, $id);
                    $this->Flash->success($msg);
                }
	}
	public function editUser(){
		if(!$this->SavoirSecurity->isSuperuser()){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=1'));
		}
                $currentUser = $this->SavoirSecurity->getCurrentUsersId();
		if($this->request->is('post')){
			$name = $this->request->getData()['name'];
			$user_id = $this->request->getData()['user_id'];
			$location = $this->request->getData()['location'];
			$superuser = $this->request->getData()['superuser'];
			$region = $this->request->getData()['region'];
			$madeby = $this->request->getData()['madeby'];
			$pickedby = $this->request->getData()['pickedby'];
			$username = $this->request->getData()['username'];
			$tel = $this->request->getData()['tel'];
			$email = $this->request->getData()['email'];

			if(!empty($user_id)&&strlen($user_id)>0){
                            $userRow = $this->userAdmin->get($user_id);
                            $userRow->username = $username;
                            $userRow->name = $name;
                            $userRow->id_location = $location;
                            $userRow->superuser = $superuser;
                            $userRow->id_region = $region;
                            $userRow->MadeBy = $madeby;
                            $userRow->PickedBy = $pickedby;
                            $userRow->telephone = $tel;
                            $userRow->adminemail = $email;
                            $this->userAdmin->save($userRow);
                            $this->userAdmin->updateModifier((int)$currentUser,(int)$user_id);
			}
			
			$this->redirect( array('controller' => 'useradmin', 'action' => 'userDetail?id='.$user_id));
		}
		else if($this->request->is('get')){
			$userid = $this->request->getQuery('id');

			if(empty($userid)||strlen($userid)==0){
				$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=2'));
			}
			$userinfo['user'] = $this->userAdmin->getUserById((int)$userid);
			$userinfo['showroom'] = $this->userAdmin->getShowroom();
			$userinfo['region'] = $this->userAdmin->getRegion();
			$info = $this->userAdmin->getCreatorModifier((int)$userid);
			$userinfo['create'] = $info['create'];
			$userinfo['modify'] = $info['modify'];
                        $this->viewBuilder()->setLayout('fabricstatus');
			$this->set('data',$userinfo);
			
		}else{
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=3'));
		}

	}
	public function editRoles(){
		if(!$this->SavoirSecurity->isSuperuser()){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=1'));
		}
                $currentEditor = $this->SavoirSecurity->getCurrentUsersId();
		if($this->request->is('ajax')){
			$user_id = $this->request->getData()['id'];
			$ids = $this->request->getData()['role_ids'];
			$user = $this->userAdmin->getUserById((int)$user_id);
			$currentRoles = $user['role_id'];
			$role_ids = json_decode($ids,true);
			$addRoles = array_diff($role_ids, $currentRoles);
			$deleteRoles = array_diff($currentRoles,$role_ids);
			if(count($deleteRoles)>0){
				foreach ($deleteRoles as $role){
					$delete = $this->userAdmin->deleteRole((int)$user_id,(int)$role);
				}
			}
			if(count($addRoles)>0){
				foreach ($addRoles as $role){
					$add = $this->userAdmin->addRole((int)$user_id,(int)$role);
				}
			}
			$this->userAdmin->updateModifier((int)$currentEditor,(int)$user_id);
			echo 'y';
			die();
		}
		else if($this->request->is('get')){
			$userid = $this->request->getQuery('id');

			if(empty($userid)||strlen($userid)==0){
				$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=2'));
			}
			$userinfo['user'] = $this->userAdmin->getUserById((int)$userid);
			$userinfo['roles'] = $this->userAdmin->getRoles();
			$info = $this->userAdmin->getCreatorModifier((int)$userid);
			$userinfo['create'] = $info['create'];
			$userinfo['modify'] = $info['modify'];
                        $this->viewBuilder()->setLayout('fabricstatus');
			$this->set('data',$userinfo);
		}
		else{
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=3'));
		}
	}

	public function editAllUsersRoles(){
		if(!$this->SavoirSecurity->isSuperuser()){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=1'));
		}
                $currentEditor = $this->SavoirSecurity->getCurrentUsersId();
		if($this->request->is('ajax')){
			$sort = explode('|',$this->request->getData()['sort']);
			$searchkey = $this->request->getData()['searchkey'];
			$filter = $this->request->getData()['filter'];
			$page = (int)$this->request->getData()['page'];
				
			$conditionArray = array();
			$conditionArray['sort'] = array('sortkey'=>$sort[0],'order'=>$sort[1]);
			$isSearch = !empty($searchkey)&&strlen($searchkey)>0;
			$isFilter = !empty($filter)&&strlen($filter)>0;
			if($isSearch){
				$conditionArray['searchkey'] = $searchkey;
			}
			if($isFilter){
				$conditionArray['filter'] = $filter;
			}
			$userinfo['users'] = $this->userAdmin->getUserInfo($page,$this->page,$conditionArray);
			if($isSearch || $isFilter){
				$userinfo['totalPage'] = $this->userAdmin->getSearchFilterTotalPages($this->page,$conditionArray);
			}else{
				$userinfo['totalPage'] = $this->userAdmin->getTotalPages($this->page);
			}
			$userinfo['roles'] = $this->userAdmin->getRoles();	
			$userinfo['currentPage'] = $page;
			$view = new View($this, false);
			$userinfo['table'] = $view->element('userAdminAllUserRoleTable', array('users'=>$userinfo['users'],'roles'=>$userinfo['roles']));
			echo json_encode($userinfo);
			die();
		}else if($this->request->is('get')){
			
			$userinfo['roles'] = $this->userAdmin->getRoles();
			$userinfo['users'] = $this->userAdmin->getUserInfo(1,$this->page,array('sort'=>array('sortkey'=>'name','order'=>'asc')));
			$userinfo['totalPage'] = $this->userAdmin->getTotalPages($this->page);
			$userinfo['currentPage'] = 1;
                        $this->viewBuilder()->setLayout('fabricstatus');
			$this->set('data',$userinfo);
		}
		else{
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=3'));
		}
	}
	public function info(){
		if(!$this->SavoirSecurity->isSuperuser()){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=1'));
		}
                $currentEditor = $this->SavoirSecurity->getCurrentUsersId();
		$errorCode = $this->request->getQuery('er');
		if(empty($errorCode)||strlen($errorCode)<=0){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=4'));
		}
		switch ((int)$errorCode){
			case 1:
				$data['msg'] = 'The user name or the email has been used, please choose another one.';
				break;
			case 2:
				$data['msg'] = 'New User has been created successfully.';
				break;
		}
		$data['error_code'] = (int)$errorCode;
                $this->viewBuilder()->setLayout('fabricstatus');
		$this->set('data',$data);
	}
	public function createUser(){
		if(!$this->SavoirSecurity->isSuperuser()){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=1'));
		}
                $currentEditor = $this->SavoirSecurity->getCurrentUsersId();
		if($this->request->is('post')){
			$name = $this->request->getData()['name'];
			$location = $this->request->getData()['location'];
			$region = $this->request->getData()['region'];
			$username = $this->request->getData()['username'];
			$password = $this->request->getData()['password'];
			$superuser = $this->request->getData()['superuser'];
			$tel = $this->request->getData()['tel'];
			$email = $this->request->getData()['email'];
			$roles = $this->request->getData()['roles'];
			$madeBy = $this->request->getData()['madeby'];
			$pickedBy = $this->request->getData()['pickedby'];
			//echo var_dump($this->request->getData());
			$query = $this->userAdmin->find('all', array(
					'conditions' => array('OR'=>array(array('userAdmin.adminemail' => $email),
							array('userAdmin.username' => $username)
					)
				)
			));
                        $n = $query->count();
			if (!empty($query) && $query->count() > 0) {
				$this->redirect( array('controller' => 'useradmin', 'action' => 'info?er=1'));
			}
			$salt = $this->_generateRandomString(16);
			$hash = hash("sha256",$salt.$password,false);
                        
                        $userinfo = $this->userAdmin->newEntity([]);
                        $userinfo['username'] = strtolower($username);
                        $userinfo['name'] = $name;
                        $userinfo['superuser'] = $superuser;
                        $userinfo['Retired'] = 'n';
                        $userinfo['MadeBy'] = $madeBy;
                        $userinfo['PickedBy'] = $pickedBy;
                        $userinfo['id_region'] = $region;
                        $userinfo['id_location'] = $location;
                        $userinfo['pw'] = $hash;
                        $userinfo['salt'] = $salt;
                        $userinfo['telephone'] = $tel;
                        $userinfo['site'] = 'SB';
                        $userinfo['adminemail'] = $email;
                        $this->userAdmin->save($userinfo);
			$user_id = $userinfo["user_id"];
			foreach ($roles as $role){
				$this->userAdmin->addRole((int)$user_id,(int)$role);
			}
			$this->userAdmin->createModifier($currentEditor,(int)$user_id);
			$this->redirect( array('controller' => 'useradmin', 'action' => "userDetail?id=".$user_id."&msgno=1"));
		}else if($this->request->is('get')){
			if(key_exists('id', $this->request->getQuery())){
				$user_id = $this->request->getQuery('id');
				$userinfo['user'] = $this->userAdmin->getUserById($user_id);
			}
			$userinfo['showroom'] = $this->userAdmin->getShowroom();
			$userinfo['region'] = $this->userAdmin->getRegion();
			$userinfo['roles'] = $this->userAdmin->getRoles();
                        $this->viewBuilder()->setLayout('fabricstatus');
			$this->set('data',$userinfo);
		}else{
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=3'));
		}
	}
	public function retire(){
		if(!$this->SavoirSecurity->isSuperuser()){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=1'));
		}
                $currentEditor = $this->SavoirSecurity->getCurrentUsersId();
		$id = $this->request->getQuery('id');
		$redirectPage = (int)$this->request->getQuery('redp');
		if(empty($id)||strlen($id)<=0){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=2'));
		}
		$this->userAdmin->updateModifier((int)$currentEditor,(int)$id);
		$this->userAdmin->retire((int)$id);
		if($redirectPage == 1){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index'));
		}else{
			$this->redirect( array('controller' => 'useradmin', 'action' => 'userDetail?id='.$id));
		}
	}
	public function active(){
		if(!$this->SavoirSecurity->isSuperuser()){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=1'));
		}
                $currentEditor = $this->SavoirSecurity->getCurrentUsersId();
		$id = $this->request->getQuery('id');
		if(empty($id)||strlen($id)<=0){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=2'));
		}
		$this->userAdmin->active((int)$id);
		$this->userAdmin->updateModifier((int)$currentEditor,(int)$id);
		$this->redirect( array('controller' => 'useradmin', 'action' => 'userDetail?id='.$id));
	
	}
	public function changePassword(){
		
		if(!$this->SavoirSecurity->isSuperuser()){
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=1'));
		}
                $currentEditor = $this->SavoirSecurity->getCurrentUsersId();
		if($this->request->is('ajax')){
			$user_id = $this->request->getData()['reset'];
			$choice = $this->request->getData()['choice'];
			$email = $this->request->getData()['email'];
			if($choice == 'pass'){
				$pass = $this->request->getData()['p'];
				$salt = $this->_generateRandomString(256);
				$hash = hash("sha256",$salt.$pass,false);
                                $userRow = $this->userAdmin->get($user_id);
                                $userRow->pw = $hash;
                                $userRow->salt = $salt;
                                $this->userAdmin->save($userRow);
				$userinfo = $this->userAdmin->getUserById((int)$user_id);
				$this->_sendEmail($email,'pass',$pass,$userinfo['username']);
				echo 'y';
				die();
			}else{
				$resetPassUser = $this->userAdmin->checkUserResetBefore((int)$user_id);
				 if(!empty($resetPassUser)||strlen($resetPassUser)>0){
					foreach ($resetPassUser as $u){
						$this->userAdmin->delteExpiredReset((int)$u['id']);
					}
				}
				$userinfo['user'] = $this->userAdmin->getUserById((int)$user_id);
				$email = $userinfo['user']['email'];
				$salt = $this->_generateRandomString(256);
				$hash = hash("sha256",$salt.$email,false);
				$time = date('Y-m-d H:i:s',time());
				$usrName = $userinfo['user']['email'];
				$editor = $this->userAdmin->getUserById((int)$currentEditor);
				$editorName = $editor['username'];
				$newResetId = $this->userAdmin->createNewReset((int)$user_id,$salt,$hash,$time,'n');
				file_put_contents(LOGS . 'reset_password_log.log', "$time,$editorName,$usrName,$email;\r\n", FILE_APPEND|LOCK_EX);
				$link = Router::url('/', true).'reset/index?trtx='.$hash.'&tytc='.$user_id.'&txtp='.$salt;
				$this->_sendEmail($email,'link',$link,$userinfo['user']['username']);
				echo 'y';
				die();
			}
		}
		else if($this->request->is('get')){
			$id = $this->request->getQuery('id');
			if(empty($id)||strlen($id)<=0){
				$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=2'));
			}
			$userinfo['user'] = $this->userAdmin->getUserById((int)$id);
                        $this->viewBuilder()->setLayout('fabricstatus');
			$this->set('data',$userinfo);
		}else{
			$this->redirect( array('controller' => 'useradmin', 'action' => 'index?errno=3'));
		}
		
	}
	private function _sendEmail($email,$choice,$info,$username){
			$Email = new Email();
			if($choice == 'pass'){
				$subject = 'Password Reset';
				$content = 'Dear User:<br> Here is your login details:<br>User Name: <b>'.$username.'</b><br>Password: <b>'.$info.'</b><br><br> Please keep it safely.';
			}
			else{
				$subject = 'Please reset your password';
				$content = 'Dear '.$username.':'.
				'<br>We have received a password request for your account within Savoir Admin. Please click the below link to reset your password.'.
				' <br><br><a href="'.$info.'">Reset Password</a><br><br>'.
				'This email has been automatically generated, please do not reply to this email.';
			}
			$Email->template('default', 'default')->emailFormat('html');
			$Email->from(array('info@savoirbeds.co.uk' => 'Savoir Admin'));
			$Email->to($email);
			//$Email->to('daryladkins@savoirbeds.co.uk');
			//$Email->to('JinfeiZhang@savoirbeds.co.uk');
			$Email->cc('daryladkins@savoirbeds.co.uk');
			$Email->bcc('ShanoorBarik@savoirbeds.co.uk');
			$Email->subject($subject);
			return $Email->send($content);
	}
	private function _generateRandomString($nbLetters){
		$randString="";
		$charUniverse="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		for($i=0; $i<$nbLetters; $i++){
			$randInt=rand(0,61);
			$randChar=$charUniverse[$randInt];
			$randString=$randString.$randChar;
		}
		return $randString;
	}
   	protected function _getAllowedRoles() {
    	return array("ADMINISTRATOR");
    }
}
?>