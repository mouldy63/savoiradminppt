<?php
declare(strict_types=1);
namespace App\Model\Table;

class TempPhoneNumberTable extends AbstractPhoneNumberTable {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('temp_phonenumber');
        $this->setPrimaryKey('phonenumber_id');
    }
	
}
?>