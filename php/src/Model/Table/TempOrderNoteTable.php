<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class TempOrderNoteTable extends AbstractOrderNoteTable {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('temp_ordernote');
        $this->setPrimaryKey('ordernote_id');
    }
	
}
?>