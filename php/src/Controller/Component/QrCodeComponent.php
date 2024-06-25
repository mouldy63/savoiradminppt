<?php
namespace App\Controller\Component;
require_once(ROOT . DS . 'vendor' . DS . "phpqrcode" . DS . "qrlib.php");
use QRcode;

class QrCodeComponent extends \Cake\Controller\Component {
	private $qrImgDir = ROOT . DS . 'webroot' . DS . 'img' .DS .'qrimages';
	
	public function getOrderNumberImageUrl($ordernumber) {
		$fileName = $ordernumber.'.png';
		$pngAbsoluteFilePath = $this->qrImgDir . DS . $fileName;
		$urlRelativeFilePath = "qrimages/" . $fileName;
		if (!file_exists($pngAbsoluteFilePath)) {
        	$res = QRcode::png($ordernumber, $pngAbsoluteFilePath);
	    }
	    return $urlRelativeFilePath;
	}
}
