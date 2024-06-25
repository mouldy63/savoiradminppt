<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\Event\EventInterface;

class BrochureReportController extends SecureAppController
{
	public function initialize() : void {
		parent::initialize();
	}

	public function index() {
		$this->viewBuilder()->setLayout('savoir');
		
		$monthfrom="";
		$strmonth="";
		$monthto="";
		$year="";
		$totalbrochurereq=0;
		$totalbrochuresent=0;
		$totalbrochurerem=0;
		
		$address = TableRegistry::get('Address');
		if (null !== $this->request->getData('monthfrom')) {
			$monthfrom = $this->request->getData('monthfrom');
			$monthto = $this->request->getData('monthto');
			$strmonth = $this->request->getData('strmonth');
			$year = $this->request->getData('year');

			$sourceCounts = $address->getSourceCounts($this->SavoirSecurity->isSuperuser(), $this->getCurrentUserRegionId(), $this->getCurrentUserSite(), $monthfrom, $monthto, $strmonth, $year);
			$this->set('sourceCounts', $sourceCounts);
			

			$currentShowrooms = $address->getCurrentShowrooms();
			
			$i = 0;
			foreach ($currentShowrooms as $showroom) {
				$currentShowrooms[$i]['request_count'] = $address->getShowroomBrochureRequestCount($showroom['idlocation'], $monthfrom, $monthto, $strmonth, $year);
				$totalbrochurereq  += $currentShowrooms[$i]['request_count'];
				$currentShowrooms[$i]['brochures_sent_count'] = $address->getShowroomBrochuresSentCount($showroom['idlocation'], $monthfrom, $monthto, $strmonth, $year);
				$totalbrochuresent  += $currentShowrooms[$i]['brochures_sent_count'];
				$currentShowrooms[$i]['brochures_remaining_count'] = $currentShowrooms[$i]['request_count'] - $currentShowrooms[$i]['brochures_sent_count'];
				$totalbrochurerem = $totalbrochurereq - $totalbrochuresent;
				$i++;
			}
			$this->set('currentShowrooms', $currentShowrooms);
				
		} else {
			$this->set('sourceCounts', array());
			$this->set('currentShowrooms', array());
		}
		$this->set('monthfrom', $monthfrom);
		$this->set('monthto', $monthto);
		$this->set('strmonth', $strmonth);
		$this->set('year', $year);
		$this->set('totalbrochurereq', $totalbrochurereq);
		$this->set('totalbrochuresent', $totalbrochuresent);
		$this->set('totalbrochurerem', $totalbrochurerem);
		
	}

    public function export() {
		$totalbrochurereq=0;
		$totalbrochuresent=0;
		$totalbrochurerem=0;
    	
		$address = TableRegistry::get('Address');
		if (null !== $this->request->getData('monthfrom')) {
			$monthfrom = $this->request->getData('monthfrom');
			$monthto = $this->request->getData('monthto');
			$strmonth = $this->request->getData('strmonth');
			$year = $this->request->getData('year');

			$sourceCounts = $address->getSourceCounts($this->SavoirSecurity->isSuperuser(), $this->getCurrentUserRegionId(), $this->getCurrentUserSite(), $monthfrom, $monthto, $strmonth, $year);
			$currentShowrooms = $address->getCurrentShowrooms();
			
			$i = 0;
			foreach ($currentShowrooms as $showroom) {
				$currentShowrooms[$i]['request_count'] = $address->getShowroomBrochureRequestCount($showroom['idlocation'], $monthfrom, $monthto, $strmonth, $year);
				$totalbrochurereq  += $currentShowrooms[$i]['request_count'];
				$currentShowrooms[$i]['brochures_sent_count'] = $address->getShowroomBrochuresSentCount($showroom['idlocation'], $monthfrom, $monthto, $strmonth, $year);
				$totalbrochuresent  += $currentShowrooms[$i]['brochures_sent_count'];
				$currentShowrooms[$i]['brochures_remaining_count'] = $currentShowrooms[$i]['request_count'] - $currentShowrooms[$i]['brochures_sent_count'];
				$totalbrochurerem = $totalbrochurereq - $totalbrochuresent;
				$i++;
			}
				
		} else {
			$currentShowrooms = array();
		}

		$data = array();
		foreach ($currentShowrooms as $row) {
			$a = array("Showroom" => $row['adminheading'],  "Total Requested Brochures" => $row['request_count'], "Brochures Sent" => $row['brochures_sent_count'], "Brochures Remaining" => $row['brochures_remaining_count']);
			array_push($data, $a);
		}
		$a = array("Showroom" => 'TOTALS',  "Total Requested Brochures" => $totalbrochurereq, "Brochures Sent" => $totalbrochuresent, "Brochures Remaining" => $totalbrochurerem);
		array_push($data, $a);
    	
		$header = ['Showroom', 'Total Requested Brochures', 'Brochures Sent', 'Brochures Remaining'];
		
    	$this->setResponse($this->getResponse()->withDownload('brochure_report.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $header
    	]);
    }
	
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR,SALES");
	}
    
	protected function _getAllowedRegions(){
        return array("London");
    }
}

?>