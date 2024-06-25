<?php
App::uses('SecureAppController', 'Controller');

class MarketingsController extends AppController {
    public $helpers = array('Html', 'Form');

    public function index() {
        $this->set('marketing', $this->Marketing->find('all'));
    }

    public function view($id = null) {
        if (!$id) {
            throw new NotFoundException(__('Invalid post'));
        }

        $post = $this->Marketing->findById($id);
        if (!$post) {
            throw new NotFoundException(__('Invalid post'));
        }
        $this->set('marketing', $post);
    }

}
