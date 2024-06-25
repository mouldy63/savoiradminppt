<?php
/**
 * DJM 21/01/15
 */
namespace App\Controller\Component;
use Google_DriveFile;
use Google_AssertionCredentials;
use Google_Client;
use Google_DriveService;
use Google_HttpRequest;

require_once(__DIR__."/../../../google-api-php-client/src/Google_Client.php");
require_once(__DIR__."/../../../google-api-php-client/src/contrib/Google_DriveService.php");
require_once(__DIR__."/../../../google-api-php-client/src/contrib/Google_Oauth2Service.php");


class GoogleDriveComponent extends \Cake\Controller\Component {
	
	private function _getService() {
		$DRIVE_SCOPE = 'https://www.googleapis.com/auth/drive';
		$SERVICE_ACCOUNT_EMAIL = '856452320665-k01rclumfgu0ck5ks3ddhusadb09hhjo@developer.gserviceaccount.com';
		$SERVICE_ACCOUNT_PKCS12_FILE_PATH = $_SERVER["DOCUMENT_ROOT"].'/php/google-api-php-client/Savoir Attachments-ad4b6a85ec71.p12';
		$SERVICE_USER_EMAIL = 'savoir.attachments@gmail.com';
		
		$key = file_get_contents($SERVICE_ACCOUNT_PKCS12_FILE_PATH);
		$auth = new Google_AssertionCredentials(
			$SERVICE_ACCOUNT_EMAIL,
			array($DRIVE_SCOPE),
			$key);
		$auth->sub = $SERVICE_USER_EMAIL;
		$client = new Google_Client();
		$client->setUseObjects(true);
		$client->setAssertionCredentials($auth);
		$service = new Google_DriveService($client);
		return $service;
	}
	
	public function uploadFile($filePath, $fileName, $description, $mimeType) {
		$service = $this->_getService();
		$data = file_get_contents($filePath);
		$driveFile = new Google_DriveFile();
		$driveFile->setTitle($fileName);
		$driveFile->setDescription($description);
		$driveFile->setMimeType($mimeType);		
		$createdFile = $service->files->insert($driveFile, array(
						'data' => $data,
						'mimeType' => 'text/plain',
						));
		return $createdFile;
	}

	public function deleteFile($fileId) {
		$service = $this->_getService();
		try {
			$service->files->delete($fileId);
		} catch (Exception $e) {
			return "Failed to delete file from Google Drive";
		}
		return null;
	}

	public function downloadFile($fileId, $fileNamePath) {
		$service = $this->_getService();
		try {
			$file = $service->files->get($fileId);
			$downloadUrl = $file->getDownloadUrl();
			if (!$downloadUrl) {
				return "Download link for Google Drive file not available";
			}
			
			$request = new Google_HttpRequest($downloadUrl, 'GET', null, null);
			$httpRequest = Google_Client::$io->authenticatedRequest($request);
			if ($httpRequest->getResponseHttpCode() != 200) {
				return "http request to download file from Google Drive failed";
			}
			
			$bytesWritten = file_put_contents($fileNamePath, $httpRequest->getResponseBody());
			if ($bytesWritten == 0) {
				return "Failed to save file downloaded from Google Drive to disk";
			}

	      	return null;
		} catch (Exception $e) {
			return "Failed to download file from Google Drive";
		}
	}
}
?>