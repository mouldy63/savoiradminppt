<?php
namespace App\Controller;
use Cake\I18n\Time;
use Cake\I18n\FrozenTime;
use Exception;
use \App\Controller\Component\UtilityComponent;

class SugarAuthenticationController extends AppController {

	public function initialize() : void {
        parent::initialize();
        $this->loadComponent('JwtHelper');
        $this->loadComponent('Comreg');
	}

    public function viewClasses(): array {
        return [JsonView::class];
    }

    public function index() {
        if (!$this->request->is('post')) {
            $this->autoRender = false;
            $response = [
                "error" => "invalid_method",
                "error_description" => "HTTP method must be POST"
            ];
            header('Content-Type: application/json');
            echo json_encode($response);
            $this->response = $this->response->withStatus(500);
            return;
        }

        if (!$this->JwtHelper->validateClientCredentials($this->request->getData(), $this->Comreg)) {
            $this->autoRender = false;
            $response = array(
                "error" => "invalid_client_credentials",
                "error_description" => "The provided client credentials are invalid"
            );
            header('Content-Type: application/json');
            echo json_encode($response);
            $this->response = $this->response->withStatus(404);
            return;
        }
        
        $jwt = $this->JwtHelper->makeSugarJwt($this->Comreg);
        $this->set([
            'access_token' => $jwt,
            'token_type' => 'Bearer',
        ]);
        $this->viewBuilder()->setOption('serialize', ['access_token', 'token_type']);
    }

}
?>