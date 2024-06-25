<?php
namespace App\Controller;
use Cake\ORM\TableRegistry;
use \DateTime;

class HousekeepingController extends AppController {
	public $uses = false;
	public $autoRender = false;

	public function index() : void {
		$this->viewBuilder()->setLayout('ajax');
		$msg = "";

		// delete all the SESSIONLOG entries older than 30 days
		$date = new DateTime();
		$date->modify('-30 day');
		$sessionLog = TableRegistry::get('SessionLog');
		$sessionLog->deleteAll(['SessionLog.created <=' => $date->format('Y-m-d H:i:s')]);
		$msg .= "<br/>All SESSIONLOG entries older than " . $date->format('Y-m-d H:i:s') . " deleted";
		
		// delete all PENDING_MAILCHIMP_UPDATES older than 1 day
		$date = new DateTime();
		$date->modify('-1 day');
		$pendingMailchimpUpdates = TableRegistry::get('PendingMailchimpUpdates');
		$pendingMailchimpUpdates->deleteAll(['processed IS NOT NULL', 'processed <=' => $date->format('Y-m-d H:i:s')]);
		$msg .= "<br/>All PENDING_MAILCHIMP_UPDATES non-null entries older than " . $date->format('Y-m-d H:i:s') . " deleted";
		
		// delete all the BATCHEMAIL entries older than 30 days
		$date = new DateTime();
		$date->modify('-30 day');
		$batchEmail = TableRegistry::get('BatchEmail');
		$batchEmail->deleteAll(['sent IS NOT NULL', 'sent <=' => $date->format('Y-m-d H:i:s')]);
		$msg .= "<br/>All BATCHEMAIL non-null entries older than " . $date->format('Y-m-d H:i:s') . " deleted";

		// delete all the CLIENTACCESSLOG entries older than 7 days
		$date = new DateTime();
		$date->modify('-7 day');
		$clientAccessLog = TableRegistry::get('ClientAccessLog');
		$clientAccessLog->deleteAll(['access_timestamp <=' => $date->format('Y-m-d H:i:s')]);
		$msg .= "<br/>All CLIENTACCESSLOG entries older than " . $date->format('Y-m-d H:i:s') . " deleted";

		// delete all the IMPORTBROCHUREREQUESTFILES entries older than 1 year
		$date = new DateTime();
		$date->modify('-1 year');
		$importBrochureRequestFiles = TableRegistry::get('ImportBrochureRequestFiles');
		$importBrochureRequestFiles->deleteAll(['importdate <=' => $date->format('Y-m-d H:i:s')]);
		$msg .= "<br/>All IMPORTBROCHUREREQUESTFILES entries older than " . $date->format('Y-m-d H:i:s') . " deleted";

		// delete all the IMPORTORDERFILES entries older than 1 year
		$date = new DateTime();
		$date->modify('-1 year');
		$importOrderFiles = TableRegistry::get('ImportOrderFiles');
		$importOrderFiles->deleteAll(['importdate <=' => $date->format('Y-m-d H:i:s')]);
		$msg .= "<br/>All IMPORTORDERFILES entries older than " . $date->format('Y-m-d H:i:s') . " deleted";

		// delete all the ORDERHISTORY entries older than 1 year
		$date = new DateTime();
		$date->modify('-1 year');
		$orderHistory = TableRegistry::get('OrderHistory');
		$orderHistory->deleteAll(['datemodified <=' => $date->format('Y-m-d H:i:s')]);
		$msg .= "<br/>All ORDERHISTORY entries older than " . $date->format('Y-m-d H:i:s') . " deleted";

		$msg .= "<br/><br/>Success";
		$this->response = $this->response->withStringBody($msg);
	}

}
?>