<?php
namespace App\Controller;

use App\Controller\AppController;
use Cake\ORM\TableRegistry;
use Cake\ORM\Table;

class PurchaseController extends SecureAppController
{


	public function index()
	{
		$this->viewBuilder()->setLayout('savoir');


		$this->loadModel('Location');
		$locations = $this->Location->find()->where(['retire !=' => 'y'])->order(['adminheading']);
		$this->set(compact('locations'));
		 
		$this->paginate = ['contain' => ['Contact','Location']];

		$addfilter = 'no';

		if (isset($_GET['filter'])) {
			IF ($_GET['filter'] != '') {
				$addfilter = 'yes';
			}
		}

		if ($addfilter == 'yes') {
			$purchases = $this->paginate($this->Purchase
			->find()
			->where(['adminheading' => $_GET['filter'],'Purchase.completedorders' => 'n', 'Purchase.SOURCE_SITE' => 'SB', 'Purchase.quote !=' => 'y'  , 'Purchase.cancelled IS ' => NULL , 'Purchase.orderonhold !=' => 'y' , 'Contact.retire' => 'n', 'Contact.contact_no !=' => 319256, 'Contact.contact_no !=' => 24188 ])
			);
		}	else {
			$purchases = $this->paginate($this->Purchase
			->find()
			->where(['Purchase.completedorders' => 'n', 'Purchase.SOURCE_SITE' => 'SB', 'Purchase.quote !=' => 'y'  , 'Purchase.cancelled IS ' => NULL , 'Purchase.orderonhold !=' => 'y' , 'Contact.retire' => 'n', 'Contact.contact_no !=' => 319256, 'Contact.contact_no !=' => 24188 ])
			);
		}

		$this->set(compact('purchases'));

	}

	public function export()

	{
		$csvArray = [];
		$this->loadModel('Purchase');

		$addfilter = 'no';
		if (isset($_POST['filter'])) {
			IF ($_POST['filter'] != '') {
				$addfilter = 'yes';
			}
		}
		echo $addfilter;
		if ($addfilter == 'yes') {
			$purchases = $this->Purchase->find('all', ['contain' => ['Contact','Location']])->where(['adminheading' => $_POST['filter'],' Purchase.completedorders' => 'n', 'Purchase.SOURCE_SITE' => 'SB', 'Purchase.quote !=' => 'y'  , 'Purchase.cancelled IS ' => NULL , 'Purchase.orderonhold !=' => 'y', 'Contact.retire' => 'n', 'Contact.contact_no !=' => 319256, 'Contact.contact_no !=' => 24188  ]);
		} else {
			$purchases = $this->Purchase->find('all', ['contain' => ['Contact','Location']])->where(['Purchase.completedorders' => 'n', 'Purchase.SOURCE_SITE' => 'SB', 'Purchase.quote !=' => 'y'  , 'Purchase.cancelled IS ' => NULL , 'Purchase.orderonhold !=' => 'y', 'Contact.retire' => 'n', 'Contact.contact_no !=' => 319256, 'Contact.contact_no !=' => 24188  ]);
			 
		}
		$this->set(compact('Purchases'));

		$Purchases = $purchases->toArray();
		$csvArray = [];
		$_header = ["Customer", "Company", "Order No", "Code", "Postcode", "Order Date", "Ack Date", "Showroom", "Order", "Payments", "Balance", "Currency", "Production Date", "Booked Delivery Date", "Ex-works Date"];


		foreach ($Purchases as $datum) {
			if ($datum->ORDER_DATE != '') {
				$orderdate =	h(date_format(date_create($datum->ORDER_DATE),"d/m/Y "));
			} else {
				$orderdate = "";
			}
			$ackdate="";
			if ($datum->acknowdate != '') {
				$olderDate = date("Y/m/d");
				$newerDate = strtotime($datum->acknowdate);
				$thenTimestamp = strtotime($olderDate);
				$difference = $thenTimestamp - $newerDate;
				$days = floor($difference / (60*60*24) );
				if ($days>7) {
					$ackdate="warning";
				} else {
					$askdate="";
				}
			}
				
			if ($datum->productiondate != '') {
				$proddate =	h(date_format(date_create($datum->productiondate),"d/m/Y "));
			} else {
				$proddate = "";
			}

			if ($datum->bookeddeliverydate != '') {
				$bookeddate =	h(date_format(date_create($datum->bookeddeliverydate),"d/m/Y "));
			} else {
				$bookeddate = "";
			}

			if ($datum->acknowdate != '') {
				$acknowdate =	h(date_format(date_create($datum->acknowdate),"d/m/Y "));
			} else {
				$acknowdate = "";
			}
				

			$single = [h($datum->contact->surname).', '.h($datum->contact->title).' '.h($datum->contact->first),h($datum->companyname),h($datum->ORDER_NUMBER),h($datum->CODE),h($datum->deliverypostcode),h($orderdate), $ackdate, h($datum->location->adminheading), number_format(h($datum->total), 2, '.', ''),number_format(h($datum->paymentstotal), 2, '.', ''),number_format(h($datum->balanceoutstanding), 2, '.', ''),$datum->ordercurrency,$proddate,$bookeddate, $acknowdate ];
			$csvArray[] = $single;

		}

		 
		$this->setResponse($this->getResponse()->withDownload('purchases.csv'));
    	$this->set(compact('csvArray'));
    	$this->viewBuilder()
    	->setClassName('CsvView.Csv')
    	->setOptions([
            'serialize' => 'csvArray',
            'header' => $_header
    	]);
	}


}

