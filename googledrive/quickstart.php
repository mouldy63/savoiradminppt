<?php

require_once "google-api-php-client/src/Google_Client.php";
require_once "google-api-php-client/src/contrib/Google_DriveService.php";
require_once "google-api-php-client/src/contrib/Google_Oauth2Service.php";
session_start();

$DRIVE_SCOPE = 'https://www.googleapis.com/auth/drive';
$SERVICE_ACCOUNT_EMAIL = '856452320665-k01rclumfgu0ck5ks3ddhusadb09hhjo@developer.gserviceaccount.com';
$SERVICE_ACCOUNT_PKCS12_FILE_PATH = $_SERVER["DOCUMENT_ROOT"].'/googledrive/Savoir Attachments-ad4b6a85ec71.p12';

$userEmail = 'savoir.attachments@gmail.com';
  $key = file_get_contents($SERVICE_ACCOUNT_PKCS12_FILE_PATH);
  $auth = new Google_AssertionCredentials(
      $SERVICE_ACCOUNT_EMAIL,
      array($DRIVE_SCOPE),
      $key);
  $auth->sub = $userEmail;
  $client = new Google_Client();
  $client->setUseObjects(true);
  $client->setAssertionCredentials($auth);
  $service = new Google_DriveService($client);

$file = new Google_DriveFile();
$file->setTitle('document.txt');
$file->setDescription('A test document');
$file->setMimeType('text/plain');

$data = file_get_contents($_SERVER["DOCUMENT_ROOT"].'/googledrive/document.txt');

$createdFile = $service->files->insert($file, array(
      'data' => $data,
      'mimeType' => 'text/plain',
    ));
echo 'File ID: ' . $createdFile->getId();


?>
