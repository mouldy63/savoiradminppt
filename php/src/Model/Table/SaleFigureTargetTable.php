<?php
declare(strict_types=1);
namespace App\Model\Table;

use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use Cake\ORM\TableRegistry;

class SaleFigureTargetTable extends Table {

    public $name = "saleFigureTarget";
    public $useTable = "sale_figure_target";
    public $primaryKey = 'sale_figure_target_id';
    private $sqlQuery;
    private $insertQuery;
    private $updateQuery;
    private $myconn;

    public function __construct() {

        parent::__construct();

        $this->sqlQuery = "SELECT * FROM sale_figure_target AS a WHERE " .
                "a.target_date <= '%d-12-31' " .
                "AND a.target_date >= '%d-01-01'";
        $this->insertQuery = "INSERT INTO sale_figure_target (idlocation,target_amount,target_date) VALUES (%d,%f,'%s')";
        $this->updateQuery = "UPDATE sale_figure_target SET idlocation=%d,target_amount=%f,target_date='%s' WHERE sale_figure_target_id=%d";
        $this->myconn = ConnectionManager::get('default');
    }

    public function getTargetData($year, $startyear) {
        $sql = sprintf($this->sqlQuery, $year, $startyear);
        return $this->myconn->execute($sql)->fetchAll('assoc');
    }

    public function insertData($idlocation, $target_amount, $target_date) {
        $sql = sprintf($this->insertQuery, $idlocation, $target_amount, $target_date);
        return $this->myconn->execute($sql);
    }

    public function updateData($idlocation, $target_amount, $target_date, $id) {
        $sql = sprintf($this->updateQuery, $idlocation, $target_amount, $target_date, $id);
        return $this->myconn->execute($sql);
    }

    public function getShowroomMonthTarget($year, $month, $idlocation) {
        $sql = "select target_amount from sale_figure_target where idlocation=:idlocation and target_date='" . $year . "-" . sprintf('%02d', $month) . "-15'";
        $rs = $this->myconn->execute($sql, ['idlocation' => $idlocation])->fetchAll('assoc');
        $target = 0.0;
        if (sizeof($rs) > 0) {
            $target = $rs[0]['target_amount'];
        }
        return $target;
    }
    
    public function getMonthTargetForShowroomAndCurrency($year, $month, $idlocation, $currency) {
    	$resNative = $this->getShowroomMonthTarget($year, $month, $idlocation);
		
    	$saleFigureExchangeRate = TableRegistry::getTableLocator()->get('SaleFigureExchangeRate');
		$location = TableRegistry::getTableLocator()->get('Location');

        $showroomCurrencyCode = $location->get($idlocation)['currency'];
		$usdRate = $saleFigureExchangeRate->getExchangeRate($year, $month, 'USD');
		$eurRate = $saleFigureExchangeRate->getExchangeRate($year, $month, 'EUR');

        if ($showroomCurrencyCode == 'GBP') {
            $resGBP = $resNative;
            $resUSD = $resNative * $usdRate;
            $resEUR = $resNative * $eurRate;
        } else if ($showroomCurrencyCode == 'USD') {
            $resGBP = $resNative / $usdRate;
            $resUSD = $resNative;
            $resEUR = $resNative / $usdRate * $eurRate;
        } else if ($showroomCurrencyCode == 'EUR') {
            $resGBP = $resNative / $eurRate;
            $resUSD = $resNative / $eurRate * $usdRate;
            $resEUR = $resNative;
        }
        $res = ['native' => $resNative, 'GBP' => $resGBP, 'USD' => $resUSD, 'EUR' => $resEUR];
        return $res[$currency];
    }


    public function getShowroomYtdTarget($idLocation, $month, $year) {
        $sql = "select target_amount from sale_figure_target where idlocation=:idlocation and target_date >= '" . $year . "-01-01' and target_date <= '" . $year . "-" . sprintf('%02d', $month) . "-31'";
        $rs = $this->myconn->execute($sql, ['idlocation' => $idLocation])->fetchAll('assoc');
        $target = 0.0;
        foreach ($rs as $row) {
            $target += $row['target_amount'];
        }
        return $target;
    }

    public function getYtdTargetForShowroomAndCurrency($idLocation, $month, $year, $currency) {
    	$target = 0.0;
    	for ($m = 1; $m <= $month; $m++) {
    		$target += $this->getMonthTargetForShowroomAndCurrency($year, $m, $idLocation, $currency);
    	}
        return $target;
    }
    
    public function getTargetDataForLocationAndYear($idlocation, $year) {
        $sql = "select t.sale_figure_target_id,month(t.target_date) as month,t.target_amount"
            . " from sale_figure_target t where t.idlocation=:idlocation and year(t.target_date) = :year order by t.target_date";
            $rs = $this->myconn->execute($sql, ['idlocation' => $idlocation, 'year' => $year])->fetchAll('assoc');
        $data = [];
        foreach ($rs as $row) {
            $data[$row['month']] = $row;
        }
        return $data;
    }
    
}

?>
