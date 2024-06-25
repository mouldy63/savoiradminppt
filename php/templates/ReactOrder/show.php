<?php

use Cake\Routing\Router;

$this->Html->css($css, ['block' => true]);

$this->Html->script($js, ['block' => 'reactblock']);
?>

<div id="root" data-url="<?= Router::url([ 
    'controller' => 'ReactOrder',
    'action' => 'api'
    ]); ?>"></div>