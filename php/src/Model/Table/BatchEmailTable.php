<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;


class BatchEmailTable extends Table {
    //public $name = 'BatchEmail';


    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('batchemail');
        $this->setPrimaryKey('batchemail_id');
    }
}
?>