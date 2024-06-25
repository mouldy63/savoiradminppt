<?php
namespace App\Controller;

use Cake\ORM\TableRegistry;
use Cake\Event\EventInterface;
use Cake\Routing\Router;

class IpRestrictedAppController extends AppController {
    
    public function initialize() : void {
        parent::initialize();
        $clientAccess = TableRegistry::get('ClientAccess');
        $ip = $this->request->clientIp();
        $rs = $clientAccess->find()->where(['client_ip' => $ip]);
        $allowed = false;
		foreach ($rs as $row) {
	        $allowed = true;
		}
        if (!$allowed) {
            $clientAccessLog = TableRegistry::get('ClientAccessLog');
            $logEntry = $clientAccessLog->newEntity([]);
            $logEntry->client_ip = $ip;
            $logEntry->screen_name = get_class($this);
            $logEntry->granted = 'n';
            $clientAccessLog->save($logEntry);
        	http_response_code(404);
        	exit;
        }
    }
}
?>
