<?php
declare(strict_types=1);
namespace App\Model\Table;
use Cake\ORM\Table;
use Cake\Datasource\ConnectionManager;
use Cake\I18n\FrozenTime;

class PendingMailchimpUpdatesTable extends Table {
    
    public function initialize(array $config) : void {
        parent::initialize($config);
        $this->setTable('pending_mailchimp_updates');
        $this->setPrimaryKey('pmu_id');
    }
	
    public function getStatusChangedContacts($limit = null) {
		if ($limit == null) {
			$limit = 100;
		}

		$sql = "select a.EMAIL_ADDRESS,C.CONTACT_NO,c.acceptemail,p.pmu_id from contact c";
		$sql .= " join address a on c.code=a.code";
		$sql .= " join pending_mailchimp_updates p on p.contact_no=c.contact_no and p.processed is null and a.EMAIL_ADDRESS is not null";
		$sql .= " limit " . intval($limit);

    	$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql)->fetchAll('assoc');
		return $rs;
    }

    public function getDistinctStatusChangedContacts($limit = null) {
		if ($limit == null) {
			$limit = 100;
		}

    	$sql = "select c.CONTACT_NO, a.EMAIL_ADDRESS, c.acceptemail from contact c join address a on c.code=a.code where a.email_address is not null and a.email_address != '' and c.contact_no in"
    		 . " (select distinct p.contact_no from pending_mailchimp_updates p where p.processed is null) order by c.dateadded desc limit " . intval($limit);

    	$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql)->fetchAll('assoc');
		return $rs;
    }

    public function getContactByEmail($email) {
    	$sql = "select a.EMAIL_ADDRESS,C.CONTACT_NO,c.acceptemail from contact c";
		$sql .= " join address a on c.code=a.code";
		$sql .= " where a.EMAIL_ADDRESS=:email";
    	$myconn = ConnectionManager::get('default');
		$rs = $myconn->execute($sql, ['email' => $email])->fetchAll('assoc');
		return $rs;
    }
    
    public function deleteOrphanUpdates() {
    	$sql = "delete from pending_mailchimp_updates where contact_no is null";
    	$myconn = ConnectionManager::get('default')->execute($sql);
    }
    
    public function markAsProcessed($contactNo) {
    	$sql = "update pending_mailchimp_updates set processed=:t where contact_no=:cn and processed is null";
    	$t = FrozenTime::now()->i18nFormat('yyyy-MM-dd HH:mm:ss', 'Europe/London');
    	ConnectionManager::get('default')->execute($sql, ['t' => $t, 'cn' => $contactNo]);
    }

    public function markAsProcessedByEmail($email) {
    	$sql = "update pending_mailchimp_updates set processed=:t where processed is null and contact_no in (select c.contact_no from contact c join address a on c.code=a.code where email_address=:e)";
    	ConnectionManager::get('default')->execute($sql, ['t' => FrozenTime::now()->i18nFormat('yyyy-MM-dd HH:mm:ss', 'Europe/London'), 'e' => $email]);
    }
    
    public function deleteLatestContactEntries($contactNo) {
    	$sql = "delete from pending_mailchimp_updates where pmu_id = (select pmu_id from pending_mailchimp_updates where contact_no=:cn and changename in ('CONTACT_INSERTED','CONTACT_UPDATED') and processed is null order by pmu_id desc limit 1)";
    	ConnectionManager::get('default')->execute($sql, ['cn' => $contactNo]);
    }
}
?>