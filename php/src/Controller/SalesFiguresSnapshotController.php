<?php
namespace App\Controller;

use Cake\I18n\FrozenTime;
use App\Controller\NewSalesFiguresController;
use App\Controller\EmailServicesController;

class SalesFiguresSnapshotController extends AppController {
	
	private $MONTHS = ['January','Febuary','March','April','May','June','July','August','September','October','November','December'];

	public function initialize() : void {
        parent::initialize();
        $this->loadModel('SalesFiguresHistory');
        $this->loadComponent('SalesFigures');
        $this->loadComponent('Comreg');
	}
	
	public function index() {
		$this->autoRender = false;

		$key = $this->request->getQuery('key');
		if ($key == null || $key != 'azerty') {
			http_response_code(404);
			exit;
		}

		$isInRunWindow = $this->isInRunWindow();
		$isForceRun = false;
		if (!$isInRunWindow) {
			$isForceRun = $this->request->getQuery('forcerun') === 'true';
		}
		if (!$isInRunWindow && !$isForceRun) {
			echo "<br>Not in run window (23:30 to 00:00 on last day of month) & forcerun=false, so aborting now.";
			return;
		}

		$now = FrozenTime::now();
		$thisMonthsFigures = $this->calcFiguresForMonth($now->year, $now->month);
		
		if ($isInRunWindow) {
			$this->saveFiguresForMonth($now->year, $now->month, $thisMonthsFigures);
			echo '<br>Figures stored successfully for this month ('.$this->MONTHS[$now->month-1].' '.$now->year.').';
		} else {
			echo "<br>Not in run window (23:30 to 00:00 on last day of month) so not saving this month's figures.";
		}
		
		// WRITE DATA TO FILE
		// this month
		list($fileNameThisMonth, $fullFileNameThisMonth) = $this->saveFiguresToFile('sales-figures_', $now->year, $now->month, $now, $thisMonthsFigures);
		
		// last month stored
		$lastMonth = $now->modify('-1 month');
		$lastMonthsStoredFigures = $this->getStoredFiguresForMonth($lastMonth->year, $lastMonth->month);
		if ($lastMonthsStoredFigures === null) {
			echo '<br>No stored figures for last month ('.$this->MONTHS[$now->month-1].' '.$now->year.'), so will not be included in email.';
			$fullFileNameLastMonthStored = null;
		} else {
			list($fileNameLastMonthStored, $fullFileNameLastMonthStored) = $this->saveFiguresToFile('sales-figures-stored_', $lastMonth->year, $lastMonth->month, $lastMonthsStoredFigures->updated, unserialize($lastMonthsStoredFigures->salesfigures));
		}

		// last month fresh
		$lastMonthsFreshFigures = $this->calcFiguresForMonth($lastMonth->year, $lastMonth->month);
		list($fileNameLastMonthFresh, $fullFileNameLastMonthFresh) = $this->saveFiguresToFile('sales-figures-fresh_', $lastMonth->year, $lastMonth->month, $now, $lastMonthsFreshFigures);

		// SEND EMAIL
		$emailServices = new EmailServicesController;
		$to = $this->Comreg->getComregVal('SALES_FIGURES_SNAPSHOT_RECIPIENT');
		$cc = 'david@natalex.co.uk';
		$from = 'noreply@savoirbeds.co.uk';
		$fromName = 'Daryl';
		$subject = 'Sales figures for '.$this->MONTHS[$now->month-1].' '.$now->year.'.';
		if (!$isInRunWindow) {
			$subject .= ' (forced run outside run window).';
		}
		if (!$this->Comreg->isLiveSystem()) {
			$subject .= ' (' . $this->Comreg->getSystemName() . ').';
		}
		$content = "<h2>Attached are the sales figures for this month and last month, as follows:</h2>";
		$content .= "<div>This month's figures: $fileNameThisMonth</div>";
		if ($lastMonthsStoredFigures === null) {
			$content .= "<div>Last month's stored figures: Not Available</div>";
		} else {
			$content .= "<div>Last month's stored figures: $fileNameLastMonthStored</div>";
		}
		$content .= "<div>Last month's freshly calculated figures: $fileNameLastMonthFresh</div>";
		$content .= "<div>The file name format is as follows: sales-figures_202301_20230131-233000 where 202301 is the year and month the data is for, and 20230131-233000 is the year, month, day, hour, minute & second it was generated.</div>";
		if (!$isInRunWindow) {
			$content .= "<div>The run was forced as it was outside the normal run window (23:30 to 00:00 on last day of month). This month's figures were therefore not saved.</div>";
		}
    	$emailServices->generateBatchEmail($to, $cc, $from, $fromName, $subject, $content, 'html', $fullFileNameThisMonth, $fullFileNameLastMonthFresh, $fullFileNameLastMonthStored);
	}
	
	private function saveFiguresToFile($fileNameStub, $year, $month, $ts, $figures) {
		
		$fileName = $fileNameStub . $this->makeYearMonth($year, $month) . '_' . $this->makeTimestamp($ts) . '.csv';
    	$fullFileName = $this->getTempDir().$fileName;
    	$fp = fopen($fullFileName,'w');
    	foreach($figures as $row) {
            fputcsv($fp, $row);
    	}
        fclose($fp);
        return [$fileName, $fullFileName];
	}
	
	private function saveFiguresForMonth($year, $month, $figures) {
		$entry = $this->getStoredFiguresForMonth($year, $month);
		if ($entry !== null) {
			$this->SalesFiguresHistory->delete($entry);
		}
		$entry = $this->SalesFiguresHistory->newEntity([]);
		$entry->yearmonth = $this->makeYearMonth($year, $month);
		$entry->salesfigures = serialize($figures);
		$this->SalesFiguresHistory->save($entry);
	}
	
	private function calcFiguresForMonth($year, $month) {
		return $this->SalesFigures->fetchMonthlyData($month, $year, 'native');
	}
	
	private function getStoredFiguresForMonth($year, $month) {
		$yearmonth = $this->makeYearMonth($year, $month);
		$rs = $this->SalesFiguresHistory->find('all', ['conditions'=> ['yearmonth' => $yearmonth]])->toArray();
		if (count($rs) > 0) {
			return $rs[0];
		}
		return null;
	}
	
	private function makeYearMonth($year, $month) {
		return $year . sprintf('%02d', $month);
	}
	
	private function makeTimestamp($frozenTime) {
		return $frozenTime->year . sprintf('%02d', $frozenTime->month) . sprintf('%02d', $frozenTime->day) . '-' . sprintf('%02d', $frozenTime->hour) . sprintf('%02d', $frozenTime->minute) . sprintf('%02d', $frozenTime->second);
	}

	private function isInRunWindow() {
		$lastOfMonth = FrozenTime::now()->lastOfMonth()->hour(23)->minute(30);
		return $lastOfMonth->wasWithinLast('30 minutes');
	}
	
	private function getTempDir() {
		return $_SERVER["DOCUMENT_ROOT"].'/temp/';
	}
}
?>