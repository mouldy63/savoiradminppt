<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;

class ProductionTable extends Table {
    
    public function initialize(array $config) : void {
        $this->setTable('purchase');
        $this->setPrimaryKey('purchase_no');
    }

    public function getNextOrderNo($pn) {
    	$sql = "Select purchase_no from Purchase Where (cancelled is null or cancelled <> 'y')  AND code<>217911 AND orderSource<>'Test' AND completedorders='n' AND quote='n' AND PURCHASE_No>:pn order by PURCHASE_No asc LIMIT 1";
		$myconn = ConnectionManager::get('default');
        $result = $myconn->execute($sql, ['pn' => $pn])->fetch('assoc'); // Use fetch instead of fetchAll

        // Check if a result was found and return purchase_no or null
        return $result ? $result['purchase_no'] : null;
        
    }

    public function getPrevOrderNo($pn) {
    	$sql = "Select purchase_no from Purchase Where (cancelled is null or cancelled <> 'y')  AND code<>217911 AND orderSource<>'Test' AND completedorders='n' AND quote='n' AND PURCHASE_No<:pn order by PURCHASE_No desc LIMIT 1";
		$myconn = ConnectionManager::get('default');
        $result = $myconn->execute($sql, ['pn' => $pn])->fetch('assoc'); // Use fetch instead of fetchAll

        // Check if a result was found and return purchase_no or null
        return $result ? $result['purchase_no'] : null;
        
    }

    public function getSpringProdNo($pn) {
		$sql = "Select * from spring_prod_row_number Where purchase_no=".$pn;
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }  

    public function getMadeByUsers($madeat) {
        if ($madeat!='n') {
            $sql = "Select U.name, U.user_id from  manufacturedat M, savoir_user U WHERE U.MadeBy='y' and M.ManufacturedAtID=" .$madeat. " and U.id_location = M.id_location and  U.Retired='n' order by U.name asc";
        } else {
            $sql = "Select U.name, U.user_id from  manufacturedat M, savoir_user U WHERE U.MadeBy='y' and U.id_location = M.id_location and  U.Retired='n' order by U.name asc";
        }
		$myconn = ConnectionManager::get('default');
		return $myconn->execute($sql)->fetchAll('assoc');
    }  
    
}
?>