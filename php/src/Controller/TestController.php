<?php

namespace App\Controller;

use Cake\ORM\TableRegistry;
use Cake\I18n\FrozenTime;

class TestController extends AppController {
	
    public function index() {
		$this->viewBuilder()->setLayout('savoirlazydatatables');
    }

    public function page() {
		$this->autoRender = false;
		$start = (int)$this->request->getQuery('start');
		$length = (int)$this->request->getQuery('length');
		$dataArray = [];
		for ($i = $start; $i < $start+$length; $i++) {
			$dataArray[] = [$i, 'John Doe'];
		}
		$totalRecords = 100;
		$draw = isset($_GET['draw']) ? intval($_GET['draw']) : 1;
		$recordsFiltered = 100;
		$response = [
			'draw' => $draw,
			'recordsTotal' => $totalRecords,
			'recordsFiltered' => $recordsFiltered,
			'data' => $dataArray,
		];
		//header('Content-Type: application/json');
		//echo json_encode($response, JSON_PRETTY_PRINT);
		$this->response = $this->response->withStringBody(json_encode($response));
    }
	
}

?>