<?php

namespace App\Controller;
use \Cake\Mailer\Email;
use Cake\Datasource\ConnectionManager;
use Cake\ORM\TableRegistry;

class EmailServicesController extends AppController {
	public $uses = false;
	public $autoRender = false;
	
    public function sendSimpleEmail() {
        $this->viewBuilder()->setLayout('ajax');
    	
    	$Email = new Email();
		$Email->setFrom(array($_REQUEST['from'] => $_REQUEST['fromname']));
		$Email->setTo($_REQUEST['to']);
		$Email->setSubject($_REQUEST['subject']);
		if (!empty($_REQUEST['cc'])) {
			$Email->setCc($_REQUEST['cc']);
		}
		if (!empty($_REQUEST['bcc'])) {
			$Email->setBcc($_REQUEST['bcc']);
		}
		$response = $Email->send($_REQUEST['body']);

    	$this->response = $this->response->withStringBody("Email sent");
    }
    
    public function sendTestEmail() {
        $this->viewBuilder()->setLayout('ajax');
    	$Email = new Email();
		$Email->setFrom(array('noreply@savoiradmin.co.uk' => 'Dave'));
		$Email->setTo('david@natalex.co.uk');
		$Email->setSubject("The date and time is " . date('d/m/Y H:i:s'));
		//$Email->setCc(explode(',', 'dmildenhall@salmon.com,info@natalex.co.uk'));
		$Email->setEmailFormat('html');
		$msg = "<div>The <b>date and time</b> is " . date('d/m/Y H:i:s') . "</div>";
		$response = $Email->send($msg);
		$result = (strcmp(trim($response["message"]), $msg) === 0) ? "Success" : "Failed";
    	$this->response = $this->response->withStringBody($result);
    }

    public function sendUnsentBatchEmails() {
    	$batchEmail = TableRegistry::get('BatchEmail');
        $this->viewBuilder()->setLayout('ajax');
    	$conn = ConnectionManager::get('default');
    	
        $query = $batchEmail->find('all', array('conditions'=> array('sent is' => null), 'order' => array('added' => 'asc')));
        $count = 0;
        $failed = 0;
        foreach($query as $row) {
            if ($this->_sendBatchEmail($row)) {
                $conn->begin();
                $row->sent = date('Y-m-d H:i:s');
                $batchEmail->save($row);
                $conn->commit();
                $count++;
            } else {
                $conn->rollback();
                $failed++;
            }
        }
    	$this->response = $this->response->withStringBody('<br>' . $count .' emails sent. '.$failed.' failed.');
    }
    
    public function testGenerateBatchEmail() {
        $this->generateBatchEmail('david@natalex.co.uk', 'info@natalex.co.uk', 'david@natalex.co.uk', 'david', 'test', 'test', 'html', null);
    }
    
    public function generateBatchEmail($to, $cc, $from, $fromName, $subject, $body, $format, $attachment, $attachment2=null, $attachment3=null) {
        $conn = ConnectionManager::get('default');
        $conn->getDriver()->enableAutoQuoting();
        $batchEmail = TableRegistry::get('BatchEmail');
        $email = $batchEmail->newEntity([]);
        $email->to = $to;
        $email->from = $from;
        $email->fromalias = $fromName;
        $email->cc = $cc;
        $email->subject = $subject;
        $email->body = $body;
        $email->format = $format;
        $email->attachment = $attachment;
        $email->attachment2 = $attachment2;
        $email->attachment3 = $attachment3;
        $email->added = date('Y-m-d H:i:s');

        $batchEmail->save($email);


    }
    
    private function _sendBatchEmail($batchEmailRow) {
    	
		try {
			$success = true;
	    	
	    	$Email = new Email();

    		if (!empty($batchEmailRow['fromalias'])) {
				$Email->setFrom(array($batchEmailRow['from'] => $batchEmailRow['fromalias']));
	    	} else {
				$Email->setFrom(array($batchEmailRow['from']));
    		}

			$Email->setTo($this->_parseRecepients(trim($batchEmailRow['to'])));
    	
			$Email->setSubject($batchEmailRow['subject']);
			if (!empty($batchEmailRow['cc'])) {
				$Email->setCc($this->_parseRecepients(trim($batchEmailRow['cc'])));
			}
			$Email->setBcc('david@natalex.co.uk');
			if (!empty($batchEmailRow['format'])) {
				$Email->setEmailFormat($batchEmailRow['format']);
			}
			
			$attachments = [];
			if (!empty($batchEmailRow['attachment'])) {
				array_push($attachments, $batchEmailRow['attachment']);
			}
			if (!empty($batchEmailRow['attachment2'])) {
				array_push($attachments, $batchEmailRow['attachment2']);
			}
			if (!empty($batchEmailRow['attachment3'])) {
				array_push($attachments, $batchEmailRow['attachment3']);
			}
			if (count($attachments) > 0) {
				$Email->setAttachments($attachments);
			}

			if (!empty($batchEmailRow['body'])) {
				$response = $Email->send($batchEmailRow['body']);
			} else {
				$response = $Email->send();
			}

		} catch (Exception $e) { // Exception would be too generic, so use SocketException here
			echo $e;
			$success = false;
		}
		return $success;
    }
    
    private function _parseRecepients($to) {
    	$result = $to;
    	if (strpos($to, ',')) {
            $result = explode(',', $to);
    	}
    	return $result;
    }
}
?>