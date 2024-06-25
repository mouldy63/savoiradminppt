<?php

namespace App\Controller;
use Cake\Event\Event;
use Cake\Routing\Router;

class ResetController extends AppController{
	private $link;
	public function initialize() : void {
            parent::initialize();
            $this->link =  str_replace("php/","",Router::url('/', true));
            $this->loadModel('userAdmin');
	}
	public function index(){
		$link = $this->link;
		$this->log("link = " . $link);
		if(!key_exists('trtx', $this->request->getQuery())||!key_exists('tytc', $this->request->getQuery())||!key_exists('txtp', $this->request->getQuery())){
			
			$this->redirect($link);
		}
		$trtx = $this->request->getQuery('trtx');
		$tytc = $this->request->getQuery('tytc');
		$txtp = $this->request->getQuery('txtp');
		$this->log("trtx = " . $trtx);
		$this->log("tytc = " . $tytc);
		$this->log("txtp = " . $txtp);
		if(empty($trtx)||strlen($trtx)<=0||empty($tytc)||strlen($tytc)<=0||empty($txtp)||strlen($txtp)<=0){
			$this->redirect($link);
		}
		$safeHash = preg_replace('/[^A-Za-z0-9\-]/', '', $trtx);
		$safeSalt = preg_replace('/[^A-Za-z0-9\-]/', '', $txtp);
		$safeUserId = preg_replace('/[^A-Za-z0-9\-]/', '', $tytc);
		$userInfo = $this->userAdmin->getResetByHash($safeHash,$safeSalt,(int)$safeUserId);
		if(empty($userInfo)||count($userInfo)<=0){
			$this->redirect( array('controller' => 'reset', 'action' => 'info?trtx=1'));
		}
		$user_id = $userInfo[0]["user_id"];
		$is_reset = $userInfo[0]["is_reset"];;
		$resetTimeInfo = $userInfo[0]["reset_time"];
		$timeSinceLastReset = floor((time() - strtotime($resetTimeInfo))/3600);
		$this->log("user_id = " . $user_id);
		$this->log("is_reset = " . $is_reset);
		if($timeSinceLastReset>=12||$is_reset == 'y'){
			$this->userAdmin->delteExpiredReset((int)$userInfo[0]["id"]);
			$this->redirect( array('controller' => 'reset', 'action' => 'info?trtx=1'));
		}
		$info['user_id'] =  $user_id;
		$info['id'] =  $userInfo[0]["id"];
                $this->viewBuilder()->setLayout('reset');
		$this->set('data',$info);
	}
	public function reset(){
		$link = $this->link;
		if($this->request->is('post')){
			$user_id = $this->request->getData()['reset'];
			$reset_id = $this->request->getData()['reset2'];
			$pass = $this->request->getData()['pass'];
			if(empty($pass)||strlen($pass)<=0){
				$this->redirect($link);
			}
			$salt = $this->_generateRandomString(16);
			$hash = hash('sha256', $salt.$pass,false);
                        $userinfo = $this->userAdmin->get($user_id);
                        $userinfo->pw = $hash;
                        $userinfo->salt = $salt;
			$userinfo = $this->userAdmin->save($userinfo);
			$this->userAdmin->delteExpiredReset((int)$reset_id);
			if(count($userinfo->toArray())>0){
				$this->redirect( array('controller' => 'reset', 'action' => 'info?trtx=2'));
			}else{
				$this->redirect( array('controller' => 'reset', 'action' => 'info?trtx=3'));
			}
		}
		else{
			$this->redirect($link);
		}
	}
	public function info(){
		$link = $this->link;
		$trtx = $this->request->getQuery('trtx');
		if(empty($trtx)||strlen($trtx)<=0){
			$this->redirect($link);
		}
		switch ($trtx){
                    case '1':
                        $data['msg'] = "Your reset link is expired, please contact your administrator.";
                        break;
                    case '2':
                        $data['msg'] = "Your password has been reset successfully. Please log in.";
                        break;
                    case '3':
                        $data['msg'] = "Your password is not reset, please contact your administrator.";
                        break;
		}
		$data['link'] = $link;
                $this->viewBuilder()->setLayout('reset');
		$this->set('data',$data);
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
}
?>