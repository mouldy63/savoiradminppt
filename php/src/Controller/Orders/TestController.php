<?php
namespace App\Controller\Orders;
use App\Controller\AppController;

class TestController extends AppController {

    public function index() {
    	$this->viewBuilder()->setLayout('ajax');
    	$this->response = $this->response->withStringBody('HELLO');
    }
}