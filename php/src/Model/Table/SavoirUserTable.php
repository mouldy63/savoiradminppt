<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class SavoirUserTable extends Table {
    //public $name = 'SavoirUser';

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('savoir_user');
        $this->setPrimaryKey('user_id');
    }
	public function getProductionUsers() {
    	$sql = "SELECT * from savoir_user S, Location L where S.id_location=L.idlocation and username='production' order by retired asc, name asc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }

	public function retireUser($userid) {
		$myconn = ConnectionManager::get('default');
		$sql = "Update savoir_user set Retired='y' Where user_id=" .$userid;
		$myconn->execute($sql);
    }
	public function checkUserName() {
		$myconn = ConnectionManager::get('default');
		$sql = "Select username from savoir_user Where Retired='n'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
		
    }
	public function addUser($username) {
		$myconn = ConnectionManager::get('default');
		$sql = "INSERT INTO savoir_user (name,username,pw,salt,id_region,superuser,id_location,site,adminemail) values ('" .$username ."','production','0b970464225757d65b1e543ee840049e049dc77c74b325b97019dc2a879adbb0','7dtwBGDBYXSYStVd75kB','1','N','1','SB','info@savoirbeds.co.uk')";
		$myconn->execute($sql);
		$sql = "SELECT LAST_INSERT_ID() as id";
		$rs=$myconn->execute($sql);
		foreach ($rs as $row) {
			$id=$row['id'];
		}
		
		$sql = "INSERT INTO savoir_userrole (user_id,role_id) values (" .$id .",7)";
		$myconn->execute($sql);
    }
}
?>
