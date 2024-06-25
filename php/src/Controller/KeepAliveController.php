<?php
namespace App\Controller;

class KeepAliveController extends AppController {
    public function keepalive(){
        $this->viewBuilder()->setLayout('ajax');
        $this->set('msg', "Still alive!");
    }
}
?>