<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;

class SalesFiguresHistoryTable extends Table {

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('sales_figures_history');
        $this->setPrimaryKey('sales_figures_history_id');
    }
	
}
?>
