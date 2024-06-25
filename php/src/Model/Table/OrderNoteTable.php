<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class OrderNoteTable extends AbstractOrderNoteTable {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('ordernote');
        $this->setPrimaryKey('ordernote_id');
    }
	
  
  
    
}
?>