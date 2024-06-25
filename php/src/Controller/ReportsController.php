<?php
namespace App\Controller;
use Cake\ORM\TableRegistry;
use App\Controller\EmailServicesController;

class ReportsController extends AppController {
	public $uses = false;
	public $autoRender = false;
        private $comreg;
        private $reports;
    
    public function initialize() : void {
        parent::initialize();
        $this->comreg = TableRegistry::get('Comreg');
        $this->reports = TableRegistry::get('Reports');
    }
    
    public function generateMattressTurnReport() {
        $this->viewBuilder()->setLayout('ajax');
    	$theRow = $this->comreg->find('all', array('conditions'=> array('name' => 'MATTRESS_TURN_REPORT_LAST_GEN_MONTH')))->toArray();
    	if (count($theRow) != 1) {
    		$this->response = $this->response->withStringBody("MATTRESS_TURN_REPORT_LAST_GEN_MONTH row missing from comreg");
    		return;
    	}
    	
    	$strLastGenMonth = $theRow[0]['VALUE'];
    	$lastGenMonth = $this->_monthStrToInt($strLastGenMonth);
    	$strCurrentMonth = date('Y-m');
    	$currentMonth = $this->_monthStrToInt($strCurrentMonth);
    	$diff = $currentMonth - $lastGenMonth;

    	if ($diff < 5) {
    		$this->response = $this->response->withStringBody("Success - report already generated for $strLastGenMonth, so no need to generate now.");
    		return;
    	}
    	
    	$monthToGen = $lastGenMonth + 1;
    	$year = intval(ceil($monthToGen/12 - 1));
    	$month = $monthToGen - 12*$year;
    	//echo "<br>lastGenMonth = $lastGenMonth</br>";
    	//echo "<br>monthToGen = $monthToGen</br>";
    	//echo "<br>month = $month</br>";
    	//echo "<br>year = $year</br>";
    	$fileName = $this->_generateMattressTurnReport($month, $year);
    	$emailAddress = $this->_emailMattressTurnReport($fileName, $month, $year);
    	
        $val = $this->comreg->get($theRow[0]['COMREG_ID']);
        $val->VALUE = "$year-$month";
	$this->comreg->save($val);

	$path_parts = pathinfo($fileName);
    	$msg = "Success - ".$path_parts['basename']." successfully generated for $month/$year and sent to $emailAddress";
    	
    	$this->response = $this->response->withStringBody($msg);
    }
    
    function _generateMattressTurnReport($month, $year) {
    	$results = $this->reports->getMattressTurnReportData($month, $year);
    	$fileName = $this->_getTempDir().'MattressTurnReport.csv';
    	$fp = fopen($fileName,'w');
	fputcsv($fp, array('Title', 'First name', 'Last name', 'Showroom', 'Email address', 'Company', 'Street 1', 'Street 2', 'Street 3', 'Town/City', 'Postcode', 'Order number', 'Delivery date', 'Mattress model', 'Mattress width', 'Mattress length', 'Base model', 'Base width', 'Base length', 'Topper type', 'Topper width', 'Topper length', 'Headboard style', 'Leg style', 'Order total (ex VAT)'));
    	//var_dump($results);
    	foreach($results as $row) {
            fputcsv($fp, $row);
    	}
        fclose($fp);
        return $fileName;
    }
    
    function _emailMattressTurnReport($fileName, $month, $year) {
    	$emailServices = new EmailServicesController();
    	$to = "SavoirAdminMattressTurn@Savoirbeds.co.uk";
    	$cc = null;
    	$from = "noreply@savoirbeds.co.uk";
    	$fromName = null;
    	$subject = "Matress Turn Report for $month/$year";
    	$body = "Please find attached the mattress turn report for $month/$year";
    	
    	$emailServices->generateBatchEmail($to, $cc, $from, $fromName, $subject, $body, 'html', $fileName);
    	
	return $to;
    }

    function _monthStrToInt($strMonth) {
    	$arr = explode('-', $strMonth);
    	return 12 * intval($arr[0]) + intval($arr[1]);
    }
    
	function _deleteTempFiles() {
		foreach (glob($this->_getTempDir()."*") as $file) {
			if (filemtime($file) < time() - 86400) {
				unlink($file);
			}
		}
	}
	
	function _getTempDir() {
		return $_SERVER["DOCUMENT_ROOT"].'/temp/';
	}
}
?>