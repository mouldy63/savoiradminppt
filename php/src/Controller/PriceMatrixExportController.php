<?php

namespace App\Controller;

use Cake\Mailer\Email;
use Cake\ORM\TableRegistry;
use Cake\Routing\Router;
use Cake\Datasource\ConnectionManager;
use \Exception;

class PriceMatrixExportController extends AbstractImportController {

	private $oHeader;

	public function initialize() : void {
        parent::initialize();
		$this->oHeader = ['Price Type','Component','Dimension 1 Name','Dimension 1','Dimension 2 Name','Dimension 2','Set Component 1','Set Component 2','Retail GBP','Retail USD','Retail EUR','Wholesale GBP','Wholesale USD','Wholesale EUR','Ex Works Revenue'];
		$this->loadModel('PriceMatrix');
	}

    public function export() {
    	
		$data = $this->PriceMatrix->getFullTableForExport();
		    	
		// create the CSV
    	$this->setResponse($this->getResponse()->withDownload('pricematrix.csv'));
    	$this->set(compact('data'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'data',
            'header' => $this->oHeader
    	]);   		
    }
    
	protected function _getHeader() {
		return $this->oHeader;
	}
    
	protected function _getAllowedRoles()
	{
		return array("ADMINISTRATOR");
	}
    
	protected function _getAllowedRegions(){
        return array("London");
    }
}

?>