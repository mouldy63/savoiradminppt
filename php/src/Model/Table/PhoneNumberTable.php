<?php
declare(strict_types=1);
namespace App\Model\Table;

class PhoneNumberTable extends AbstractPhoneNumberTable {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('phonenumber');
        $this->setPrimaryKey('phonenumber_id');
    }
	
}
?>