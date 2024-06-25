<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class FieldOptTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('fieldopt');
        $this->setPrimaryKey('fieldoptid');
    }
    
    public function getFieldOptions() {
    	$query = $this->find();
        $query = $query->where(['retired' => 'n']);
        $query->order(['fieldname' => 'ASC', 'seq' => 'ASC']);
    	
    	$options = [];
		foreach ($query as $row) {
			$options[$row['fieldname']][$row['optkey']] = $row['optval'];
		}
		return $options;
    }
}
?>