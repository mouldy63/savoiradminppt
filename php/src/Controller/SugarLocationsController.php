<?php
namespace App\Controller;

use Cake\I18n\Time;
use Cake\I18n\FrozenTime;
use Exception;
use \App\Controller\Component\UtilityComponent;

class SugarLocationsController extends AppController {

	public function initialize() : void {
        parent::initialize();
        $this->loadModel('Location');
        $this->loadComponent('JwtHelper');
        $this->loadComponent('Comreg');
	}

    public function viewClasses(): array {
        return [JsonView::class];
    }

    public function index() {
        if (!$this->JwtHelper->validateSugarJwt($this->Comreg)) {
            $this->autoRender = false;
            $response = [
                "error" => "invalid_token",
                "error_description" => "The provided JWT is invalid or has expired"
            ];
            header('Content-Type: application/json');
            echo json_encode($response);
            $this->response = $this->response->withStatus(401);
            return;
        }

        $locations = $this->Location->getSugarLocations();
        $locationsinfoArray = [];
        foreach ($locations as $location) {
            $orderObj = [];
            $orderObj['Showroom'] = $location['adminheading'];
            $orderObj['Location ID'] = $location['idlocation'];
            $orderObj['Region Name'] = $location['name'];
            $orderObj['Region Country'] = $location['country'];
            $orderObj['Region ID'] = $location['id_region'];
            array_push($locationsinfoArray, $orderObj);
        }

        $this->set('location', $locationsinfoArray);
        $this->viewBuilder()->setOption('serialize', ['location']);
    }

    public function view($id) {
        $recipe = $this->Recipes->get($id);
        $this->set('recipe', $recipe);
        $this->viewBuilder()->setOption('serialize', ['recipe']);
    }

    public function add() {
        $this->request->allowMethod(['post', 'put']);
        $recipe = $this->Recipes->newEntity($this->request->getData());
        if ($this->Recipes->save($recipe)) {
            $message = 'Saved';
        } else {
            $message = 'Error';
        }
        $this->set([
            'message' => $message,
            'recipe' => $recipe,
        ]);
        $this->viewBuilder()->setOption('serialize', ['recipe', 'message']);
    }

    public function edit($id) {
        $this->request->allowMethod(['patch', 'post', 'put']);
        $recipe = $this->Recipes->get($id);
        $recipe = $this->Recipes->patchEntity($recipe, $this->request->getData());
        if ($this->Recipes->save($recipe)) {
            $message = 'Saved';
        } else {
            $message = 'Error';
        }
        $this->set([
            'message' => $message,
            'recipe' => $recipe,
        ]);
        $this->viewBuilder()->setOption('serialize', ['recipe', 'message']);
    }

    public function delete($id) {
        $this->request->allowMethod(['delete']);
        $recipe = $this->Recipes->get($id);
        $message = 'Deleted';
        if (!$this->Recipes->delete($recipe)) {
            $message = 'Error';
        }
        $this->set('message', $message);
        $this->viewBuilder()->setOption('serialize', ['message']);
    }
}
?>