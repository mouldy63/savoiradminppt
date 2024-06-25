<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class PostcodeLocationTable extends Table {
    //public $name = 'PostcodeLocation';
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('postcode_location');
        $this->setPrimaryKey('POSTCODE_LOCATION_ID');
    }
}
?>