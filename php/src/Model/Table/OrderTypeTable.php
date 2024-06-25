<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use \DateTime;

class OrderTypeTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('ordertype');
        $this->setPrimaryKey('ordertypeID');
    }
	
}
?>

