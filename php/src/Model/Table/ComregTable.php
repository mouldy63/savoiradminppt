<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class ComregTable extends Table {
    //public $name = 'Comreg';

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('comreg');
        $this->setPrimaryKey('COMREG_ID');
    }
    
    public function getNextOrderNumber() {
		    return $this->getNextNumber('NEXTORDERNUMBER');
    }

    public function getNextReceiptNumber() {
		    return $this->getNextNumber('NEXTRECEIPTNUMBER');
    }

    private function getNextNumber($name) {
        $query = $this->find()->where(['NAME' => $name]);
        $number = 0;
        foreach ($query as $row) {
          $number = $row['VALUE'];
          $row['VALUE'] += 1;
          $this->save($row);
        }
        return $number;
    }

    function isFeatureEnabled($featureName) {
      $rs = $this->find()->where(['NAME' => 'FS_' . $featureName])->first();
      return $rs['VALUE'] == 'y';
    }
}
?>