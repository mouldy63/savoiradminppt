<?php

namespace App\Controller\Component;

use Cake\ORM\TableRegistry;
use \DateTime;

class ComregComponent extends \Cake\Controller\Component {
	
	public function initialize($config): void {
        parent::initialize($config);
        $this->Comreg = TableRegistry::getTableLocator()->get('Comreg');
    }

    public function getComregVal($name) {
		$comregRow = $this->Comreg->find('all', array('conditions'=> array('name' => $name)));
    	$comregRow = $comregRow->toArray();
		return $comregRow[0]['VALUE'];
    }
    
    public function isLiveSystem() {
    	return $this->getSystemName() == 'LIVE';
    }

    public function getSystemName() {
    	return $this->getComregVal('SYSTEM_NAME');
    }
}

?>