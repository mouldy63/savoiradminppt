<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ChannelTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('channel');
        $this->setPrimaryKey('Channel');
    }
	
	public function getChannelList() {
    	$sql = "Select * from channel where brochurerequest='y'";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
    
    public function getChannelListAll() {
    	$sql = "Select * from channel order by Channel asc";
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }
	
}

?>