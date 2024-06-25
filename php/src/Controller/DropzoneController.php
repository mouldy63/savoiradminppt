<?php
namespace App\Controller;
use Cake\ORM\TableRegistry;
use \DateTime;

class DropzoneController extends SecureAppController {

	public function initialize() : void {
		parent::initialize();
		$this->loadModel('PurchaseAttachment');
		$this->loadModel('SavoirUser');
	}

	public function getPurchaseAttachmentWidget() : void {
		$this->viewBuilder()->setLayout('ajax');
		$pn = $this->request->getQuery('pn');
		$theType = $this->request->getQuery('type');
		$this->set('theType', $theType);
		if ($this->isSuperuser() || $this->_userHasRole("BED_PHOTOS_DEL")) {
			$this->set('allowDelete', true);
		} else {
			$this->set('allowDelete', false);
		}

		$rs = $this->PurchaseAttachment->find('all', ['conditions'=> ['purchase_no' => $pn, 'type' => $theType]]);
		$data = [];
		foreach ($rs as $row) {
			$a = [];
			$a['thumbUrl'] = "/order_attachment_thumbs/" . $row["thumbnail"];
			$a['url'] = "services/dropzoneDownload/" . $row["purchase_attachment_id"];
			$a['username'] = "";
			if (isset($row["user_id"])) {
				$a['username'] = $this->SavoirUser->get($row["user_id"])["username"];
			}
			$a['purchase_attachment_id'] = $row["purchase_attachment_id"];
			$a['id'] = $row["id"];
			$a['filename'] = $row["filename"];
			$a['upload_date'] = $row["upload_date"];
			array_push($data, $a);
		}
		$this->set('data', $data);
	}

	protected function _getAllowedRoles() {
		return ["ALL"];
	}
}
?>