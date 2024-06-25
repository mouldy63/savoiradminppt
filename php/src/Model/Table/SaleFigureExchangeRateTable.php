<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class SaleFigureExchangeRateTable extends Table {

    //public $name = 'saleFigureExchangeRate';
    private $currencyCodeQuery;
    private $myconn;

    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('sale_figure_exchange_rate');
        $this->setPrimaryKey('exchange_rate_id');
        $this->myconn = ConnectionManager::get('default');
        $this->currencyCodeQuery = "SELECT DISTINCT a.currency_code FROM sale_figure_exchange_rate AS a";
    }

    public function getCurrencyCodeArray() {
        return $this->myconn->execute($this->currencyCodeQuery)->fetchAll('assoc');
    }

    public function getExchangeRate($year, $month, $currencyCode) {
        $sql = "select exchange_rate from sale_figure_exchange_rate where currency_code=:curcode and time='" . $year . "-" . sprintf('%02d', $month) . "-15 00:00:00'";
        $rs = $this->myconn->execute($sql, ['curcode' => $currencyCode])->fetchAll('assoc');
        $exchange_rate = 1.0;
        if (sizeof($rs) > 0) {
            $exchange_rate = $rs[0]['exchange_rate'];
        }
        return (float)$exchange_rate;
    }
    
    public function getRatesForYear($year, $currencyCode) {
        $sql = "select exchange_rate,month(time) as month from sale_figure_exchange_rate where currency_code=:curcode and year(time)=:year";
        $rs = $this->myconn->execute($sql, ['curcode' => $currencyCode, 'year' => $year])->fetchAll('assoc');
        $results = [];
        foreach ($rs as $row) {
            $results[$row['month']] = $row['exchange_rate'];
        }
        return $results;
    }
}

?>