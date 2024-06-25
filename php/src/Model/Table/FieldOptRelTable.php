<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class FieldOptRelTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('fieldoptrel');
        $this->setPrimaryKey('fieldoptrelid');
    }
    
}
?>