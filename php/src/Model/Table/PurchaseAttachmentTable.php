<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class PurchaseAttachmentTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('purchase_attachment');
        $this->setPrimaryKey('purchase_attachment_id');
    }
}
?>