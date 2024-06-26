<?php
declare(strict_types=1);

namespace App\Controller;

/**
 * React Order Controller
 */
class ReactOrderController extends AppController
{
    /**
     * Initialize controller
     *
     * @return void
     */
    public function initialize(): void
    {
        parent::initialize();

        $this->loadComponent('ReactEmbed');
    }

    public function show() {
            $this->viewBuilder()->setLayout('reactpages');
            $this->ReactEmbed->assets('reactassets');
    }

    public function api() {

        $data = [
            'Youtube',
            'Embed React in CakePHP 4',
            'Tutorial'
        ];

        $this->set(compact('data'));

        $this->viewBuilder()->setOption('serialize', ['data']);

        if(!$this->request->is('ajax')) {
            return $this->getResponse()
                ->withStringBody(
                    '<pre>' . json_encode($data, JSON_PRETTY_PRINT). '</pre>'
                );
        }
    }
    public function loadApi() {

    }
}
