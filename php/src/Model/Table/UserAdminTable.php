<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Database\Connection;
use Cake\Datasource\ConnectionManager;

class UserAdminTable extends Table {
	//public $name = "userAdmin";
	private $isSuperUserQuery;
	private $getUserInfoQuery;
	private $getUserTotalQuery;
	private $searchFilterTotalQuery;
	private $getUserByIdQuery;
	private $getCreatorModifierQuery;
	private $getShowroomQuery;
	private $getRegionQuery;
	private $getRolesQuery;
	private $updateModifierQuery;
	private $createModifierQuery;
	private $insertRoleQuery;
	private $deleteRoleQuery;
	Private $retireQuery;
	private $userResetQuery;
	private $delteExpiredResetQuery;
	private $newResetQuery;
	private $getJustInsertIdQuery;
	private $getResetRecordByIdQuery;
	private $getResetByHashQuery;
	private $activeQuery;
        private $myconn;
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('savoir_user');
        $this->setPrimaryKey('user_id');
        $this->myconn = ConnectionManager::get('default');
        
        $this->isSuperUserQuery = "SELECT 1 FROM savoir_user AS a WHERE a.user_id=%d AND a.superuser='Y'";

        $this->getUserInfoQuery = "SELECT a.user_id,a.username,a.name,a.Retired,a.superuser,a.adminemail,a.telephone,a.id_location,a.id_region,a.MadeBy,a.PickedBy, ".
                "(SELECT created FROM sessionlog AS d WHERE a.user_id = d.user_id ORDER BY d.created DESC LIMIT 1) AS last_login, ".
                "GROUP_CONCAT(c.rolename) AS roles, GROUP_CONCAT(CONVERT(c.role_id,CHAR(6)) SEPARATOR ',') AS role_id, f.location, g.name FROM `savoir_user` AS a ".
                "LEFT JOIN location AS f ON a.id_location=f.idlocation ".
                "LEFT JOIN region AS g ON a.id_region=g.id_region ".
                "JOIN savoir_userrole AS b ON a.user_id=b.user_id ".
                "JOIN savoir_role AS c ON b.role_id=c.role_id ".
                "WHERE a.user_id IS NOT NULL AND a.username IS NOT NULL %s GROUP BY a.user_id ORDER BY %s LIMIT %d OFFSET %d";

        $this->getUserByIdQuery = "SELECT a.user_id,a.username,a.name,a.Retired,a.superuser,a.adminemail,a.telephone,a.id_location,a.id_region,a.MadeBy,a.PickedBy, ".
                        "(SELECT created FROM sessionlog AS d WHERE a.user_id = d.user_id ORDER BY d.created DESC LIMIT 1) AS last_login, ".
                        "GROUP_CONCAT(c.rolename) AS roles, GROUP_CONCAT(CONVERT(c.role_id,CHAR(6)) SEPARATOR ',') AS role_id, f.location, g.name FROM `savoir_user` AS a ".
                        "LEFT JOIN location AS f ON a.id_location=f.idlocation ".
                        "LEFT JOIN region AS g ON a.id_region=g.id_region ".
                        "JOIN savoir_userrole AS b ON a.user_id=b.user_id ".
                        "JOIN savoir_role AS c ON b.role_id=c.role_id ".
                        "WHERE a.user_id=%d GROUP BY a.user_id";

        $this->searchFilterTotalQuery = "SELECT COUNT(*) AS num FROM (SELECT a.*,GROUP_CONCAT(c.rolename) AS roles FROM `savoir_user` AS a ".
                "LEFT JOIN location AS f ON a.id_location=f.idlocation ".
                "JOIN savoir_userrole AS b ON a.user_id=b.user_id ".
                "JOIN savoir_role AS c ON b.role_id=c.role_id ".
                "WHERE a.user_id IS NOT NULL AND a.username IS NOT NULL %s GROUP BY a.user_id) AS T";

        $this->getUserTotalQuery ="SELECT COUNT(*) AS num FROM savoir_user AS a WHERE a.user_id IS NOT NULL AND a.username IS NOT NULL";

        $this->getCreatorModifierQuery = "SELECT (SELECT a.name FROM savoir_user AS a WHERE a.user_id = (SELECT create_id FROM savoir_user_create_modify WHERE user_id=%d)) AS creator, ".
                                                                        "(SELECT b.name FROM savoir_user AS b WHERE b.user_id = (SELECT modify_id FROM savoir_user_create_modify WHERE user_id=%d)) AS modifier";
        $this->getShowroomQuery = "SELECT a.location,a.idlocation FROM location AS a WHERE a.retire='n'";
        $this->getRegionQuery = "SELECT a.name,a.id_region FROM region AS a";
        $this->getRolesQuery = "SELECT a.* FROM savoir_role AS a";
        $this->updateModifierQuery = "UPDATE savoir_user_create_modify SET modify_id=%d WHERE user_id=%d";
        $this->createModifierQuery = "INSERT INTO savoir_user_create_modify ( `user_id`, `create_id`, `modify_id`) VALUES (%d,%d,%d)";
        $this->insertRoleQuery = "INSERT INTO savoir_userrole ( `user_id`, `role_id`) VALUES (%d,%d)";
        $this->deleteRoleQuery = "DELETE FROM savoir_userrole WHERE user_id=%d AND role_id=%d";
        $this->retireQuery = "UPDATE savoir_user SET Retired='y' where user_id=%d";
        $this->activeQuery = "UPDATE savoir_user SET Retired='n' where user_id=%d";
        $this->userResetQuery = "SELECT a.* FROM savoir_user_pass_reset AS a WHERE a.user_id=%d ORDER BY reset_time DESC";
        $this->delteExpiredResetQuery = "UPDATE savoir_user_pass_reset SET is_reset='y' WHERE id=%d";
        $this->newResetQuery = "INSERT INTO savoir_user_pass_reset (user_id,salt,temp_hash,reset_time,is_reset) VALUES (%d,'%s','%s','%s','%s')";
        $this->getJustInsertIdQuery = "SELECT LAST_INSERT_ID()";
        $this->getResetRecordByIdQuery = "SELECT * FROM savoir_user_pass_reset WHERE id=%d";
        $this->getResetByHashQuery = "SELECT * FROM savoir_user_pass_reset WHERE temp_hash='%s' AND salt='%s' AND user_id='%d';";
    }

        public function getResetByHash($hash,$salt,$userId){
		$sql = sprintf($this->getResetByHashQuery,$hash,$salt,$userId);
		return $this->myconn->execute($sql)->fetchAll('assoc');
	}
	public function getResetById($id){
		$sql = sprintf($this->getResetRecordByIdQuery,$id);
		return $this->myconn->execute($sql);
	}
	public function createNewReset($user_id,$salt,$hash,$time,$isReset){
		$sql = sprintf($this->newResetQuery,$user_id,$salt,$hash,$time,$isReset);
		$this->myconn->execute($sql);
		$idInfo = $this->myconn->execute($this->getJustInsertIdQuery)->fetchAll('assoc');
		return $idInfo[0]["LAST_INSERT_ID()"];
	}
	public function delteExpiredReset($id){
		$sql = sprintf($this->delteExpiredResetQuery,$id);
		return $this->myconn->execute($sql);
	}
	public function checkUserResetBefore($id){
		$sql = sprintf($this->userResetQuery,$id);
		return $this->myconn->execute($sql);
	}
	public function retire($id){
		$sql = sprintf($this->retireQuery,$id);
		return $this->myconn->execute($sql);
	}
	public function active($id){
		$sql = sprintf($this->activeQuery,$id);
		return $this->myconn->execute($sql);
	}
	public function deleteRole($user_id,$role_id){
		$sql = sprintf($this->deleteRoleQuery,$user_id,$role_id);
		return $this->myconn->execute($sql);
	}
	public function addRole($user_id,$role_id){
		$sql = sprintf($this->insertRoleQuery,$user_id,$role_id);
		return $this->myconn->execute($sql);
	}
	public function updateModifier($modify_id,$user_id){
		$sql = sprintf($this->updateModifierQuery,$modify_id,$user_id);
		return $this->myconn->execute($sql);
	}
	public function createModifier($create_id,$user_id){
		$sql = sprintf($this->createModifierQuery,$user_id,$create_id,$create_id);
		return $this->myconn->execute($sql);
	}
	public function getRoles(){
		$sql = $this->getRolesQuery;
		$roleinfo = $this->myconn->execute($sql);
		$returnArray = array();
		foreach ($roleinfo as $role){
			$temp['id'] = $role['role_id'];
			$temp['role'] = $role['rolename'];
			$temp['description'] = $role['description'];
			array_push($returnArray, $temp);
		}
		return $returnArray;
	}
	public function getShowroom(){
		$sql = $this->getShowroomQuery;
		$showroominfo = $this->myconn->execute($sql);
		$returnArray = array();
		foreach ($showroominfo as $showroom){
			$temp['location'] = $showroom['location'];
			$temp['id'] = $showroom['idlocation'];
			array_push($returnArray, $temp);
		}
		return $returnArray;
	}
	public function getRegion(){
		$sql = $this->getRegionQuery;
		$regionInfo = $this->myconn->execute($sql);
		$returnArray = array();
		foreach ($regionInfo as $region){
			$temp['region'] = $region['name'];
			$temp['id'] = $region['id_region'];
			array_push($returnArray, $temp);
		}
		return $returnArray;
	}
	public function getTotalPages($recordsPerPage){
		$sql = $this->getUserTotalQuery;
		$num = $this->myconn->execute($sql)->fetchAll('assoc');
		$totalRecords = (int)$num[0]['num'];
		return ceil($totalRecords/$recordsPerPage);
	}
	public function isSuperUser($userId){
		$sql = sprintf($this->isSuperUserQuery,$userId);
		$userinfo = $this->myconn->execute($sql)->fetchAll('assoc');
		return count($userinfo)>0?$userId:false;
	}
	public function getSearchFilterTotalPages($pageRecords,$conditions){
		$whereClause = '';
		$orderBy='';
		if(key_exists('searchkey', $conditions)){
			$key = $conditions['searchkey'];
			$whereClause .= "AND (a.name LIKE '%".$key."%' OR a.username LIKE '%".$key."%' OR f.location LIKE '%".$key."%')";
			//$whereClause .= "AND (a.name LIKE '%".$key."%' OR a.username LIKE '%".$key."%' OR c.rolename LIKE '%".strtoupper($key)."%' OR f.location LIKE '%".$key."%')";
		}
		if(key_exists('filter', $conditions)){
			$whereClause .= "";
		}
		$sql = sprintf($this->searchFilterTotalQuery,$whereClause);
		$num = $this->myconn->execute($sql)->fetchAll('assoc');
		$totalRecords = (int)$num[0]['num'];
		return ceil($totalRecords/$pageRecords);
	}
	public function getCreatorModifier($id){
		$sql = sprintf($this->getCreatorModifierQuery,$id,$id);
		$userinfo = $this->myconn->execute($sql)->fetchAll('assoc');
		$returnInfo = array();
		if(!empty($userinfo) && count($userinfo)>0){
			$returnInfo['create'] = $userinfo[0]["creator"];
			$returnInfo['modify'] = $userinfo[0]["modifier"];
		}
		return $returnInfo;
	}
	public function getUserById($id){
		$sql = sprintf($this->getUserByIdQuery,$id);
		$user = $this->myconn->execute($sql)->fetchAll('assoc');
		$reuturnUserInfo = array();
		$reuturnUserInfo['user_id'] = $user[0]["user_id"];
		$reuturnUserInfo['username'] = $user[0]["username"];
		$reuturnUserInfo['Retired'] = $user[0]["Retired"];
		$reuturnUserInfo['email'] = $user[0]["adminemail"];
		$reuturnUserInfo['tel'] = $user[0]["telephone"];
		$reuturnUserInfo['id_location'] = $user[0]["id_location"];
		$reuturnUserInfo['id_region'] = $user[0]["id_region"];
		$reuturnUserInfo['superuser'] = $user[0]["superuser"];
		$reuturnUserInfo['madeby'] = $user[0]["MadeBy"];
		$reuturnUserInfo['pickedby'] = $user[0]["PickedBy"];
		$reuturnUserInfo['location'] = $user[0]["location"];
		$reuturnUserInfo['region'] = $user[0]["name"];
		$reuturnUserInfo['last_login'] = $user[0]["last_login"];
		$fullName = explode(' ',$user[0]["name"]);
		$lastNamePos = count($fullName) - 1;
		$reuturnUserInfo['last_name'] = $lastNamePos>0?$fullName[$lastNamePos]:' ';
		$reuturnUserInfo['first_name'] = $lastNamePos>0?trim($user[0]["name"],$reuturnUserInfo['last_name']):$user[0]["name"];
		$reuturnUserInfo['name'] = $user[0]["name"];
		$roles = explode(',',$user[0]["roles"]);
		$reuturnUserInfo['roles'] = $roles;
		$role_ids = explode(',',$user[0]["role_id"]);
		$reuturnUserInfo['role_id'] = $role_ids;
		
		return $reuturnUserInfo;
	}
	public function getUserInfo($page,$pageRecords,$conditions = array()){
		$offset= ($page - 1) * $pageRecords;		
		$whereClause = '';
		$orderBy='';
		if(key_exists('searchkey', $conditions)){
			$key = $conditions['searchkey'];
			$whereClause .= "AND (a.name LIKE '%".$key."%' OR a.username LIKE '%".$key."%' OR f.location LIKE '%".$key."%')";
			//$whereClause .= "AND (a.name LIKE '%".$key."%' OR a.username LIKE '%".$key."%' OR c.rolename LIKE '%".strtoupper($key)."%' OR f.location LIKE '%".$key."%')";
		}
		if(key_exists('filter', $conditions)){
			$whereClause .= "";
		}
		switch ($conditions['sort']['sortkey']){
			case 'name':
				$orderBy = 'a.name ';
				break;
			case 'lastname':
				$orderBy = "substring(a.name, locate(' ', a.name)+1, length(a.name)-(locate(' ', a.name)-1)) ";
				break;
			case 'login':
				$orderBy = 'a.username ';
				break;
			case 'location':
				$orderBy = 'f.location ';
				break;
			case 'lastlogin':
				$orderBy = 'last_login ';
				break;
			case 'retire':
				$orderBy = 'a.Retired ';
				break;
			default:
				$orderBy = 'a.name ';
		}
		switch ($conditions['sort']['order']){
			case 'desc':
				$orderBy .='DESC';
				break;
			default:
				$orderBy .='ASC';
		}
		$sql = sprintf($this->getUserInfoQuery,$whereClause,$orderBy,$pageRecords,$offset);
		$userinfo = $this->myconn->execute($sql);
		$reuturnUserInfo = array();
		foreach ($userinfo as $user){
			$temparray = array();
			$temparray['user_id'] = $user["user_id"];
			$temparray['username'] = $user["username"];
			$temparray['Retired'] = $user["Retired"];
			$temparray['email'] = $user["adminemail"];
			$temparray['tel'] = $user["telephone"];
			$temparray['id_location'] = $user["id_location"];
			$temparray['id_region'] = $user["id_region"];
			$temparray['superuser'] = $user["superuser"];
			$temparray['madeby'] = $user["MadeBy"];
			$temparray['pickedby'] = $user["PickedBy"];
			$temparray['location'] = $user["location"];
			$temparray['region'] = $user["name"];
			$temparray['last_login'] = $user["last_login"];
			$fullName = explode(' ',$user["name"]);
			$lastNamePos = count($fullName) - 1;
			$temparray['last_name'] = $lastNamePos>0?$fullName[$lastNamePos]:' ';
			$temparray['first_name'] = $lastNamePos>0?trim($user["name"],$temparray['last_name']):$user["name"];
			$temparray['name'] = $user["name"];
			$roles = explode(',',$user["roles"]);
			$temparray['roles'] = $roles;
			array_push($reuturnUserInfo, $temparray);
		}
		return $reuturnUserInfo;
	}
}
?>