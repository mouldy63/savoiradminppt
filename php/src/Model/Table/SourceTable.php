<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class SourceTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('source');
        $this->setPrimaryKey('Source');
    }
	
	public function getNonRetiredSources() {
    	$sql = "Select Source from source where retired='n' order by Source";
		$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql)->fetchAll('assoc');
		$sourceData = [];
		foreach ($rs as $row) {
			array_push($sourceData, $row['Source']);
		}
		return $sourceData;			
    }
	
}
?>