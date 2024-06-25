<?php
use Cake\Core\Configure;
?>
<!DOCTYPE html>
<html>
<head>
    <?= $this->Html->charset() ?>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <?= $this->fetch('title') ?>
    </title>

    <?= $this->Html->css('printpdf.css', ['fullBase' => true]) ?>
</head>
<body>
    <div>
        <?= $this->fetch('content') ?>
    </div>
</body>

</html>
