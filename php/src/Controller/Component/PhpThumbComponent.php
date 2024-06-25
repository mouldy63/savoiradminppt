<?php
/**
 * DJM 21/01/15
 */
namespace App\Controller\Component;

require_once(__DIR__."/../../../phpThumb/phpthumb.class.php");
use phpthumb;


class PhpThumbComponent extends \Cake\Controller\Component {
	
	public function makeThumb($thumbnail_width, $tmpSourceFileName, $thumbFilePath, $thumbFileName, $isUploadFile) {
		$tmpTarget = $thumbFilePath . 'tmp-' . $thumbFileName;
		$output_filename = $thumbFilePath . $thumbFileName;
		if ($isUploadFile) {
			if (!move_uploaded_file($tmpSourceFileName, $tmpTarget)) {
				return "File move failed";
			}
		} else {
			if (!copy($tmpSourceFileName, $tmpTarget)) {
				return "File move failed";
			}
		}
		
		$phpThumb = new phpthumb();
		$phpThumb->setSourceData(file_get_contents($tmpTarget));
		$phpThumb->setParameter('w', $thumbnail_width);
		$msg = null;
		
		if ($phpThumb->GenerateThumbnail()) { // this line is VERY important, do not remove it!
			if (!$phpThumb->RenderToFile($output_filename)) {
				$msg = 'Failed to render thumbnail';
			}
			$phpThumb->purgeTempFiles();
		} else {
			$msg = 'Failed to generate thumbnail: ' . implode("\n\n", $phpThumb->debugmessages);
		}
		
		unlink($tmpTarget);

		return $msg;
	}
	
}
?>