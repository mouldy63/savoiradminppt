<?php
/**
 * @var \App\View\AppView $this
 * @var \App\Model\Entity\Customerservice $customerservice
 */
?>
<nav class="large-3 medium-4 columns" id="actions-sidebar">
    <ul class="side-nav">
        <li class="heading"><?= __('Actions') ?></li>
        <li><?= $this->Html->link(__('Edit Customerservice'), ['action' => 'edit', $customerservice->CSID]) ?> </li>
        <li><?= $this->Form->postLink(__('Delete Customerservice'), ['action' => 'delete', $customerservice->CSID], ['confirm' => __('Are you sure you want to delete # {0}?', $customerservice->CSID)]) ?> </li>
        <li><?= $this->Html->link(__('List Customerservice'), ['action' => 'index']) ?> </li>
        <li><?= $this->Html->link(__('New Customerservice'), ['action' => 'add']) ?> </li>
    </ul>
</nav>
<div class="customerservice view large-9 medium-8 columns content">
    <h3><?= h($customerservice->CSID) ?></h3>
    <table class="vertical-table">
        <tr>
            <th scope="row"><?= __('CSNumber') ?></th>
            <td><?= h($customerservice->CSNumber) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Showroom') ?></th>
            <td><?= h($customerservice->Showroom) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Csclosed') ?></th>
            <td><?= h($customerservice->csclosed) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Custname') ?></th>
            <td><?= h($customerservice->custname) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Savoirstaffresolvingissue') ?></th>
            <td><?= h($customerservice->savoirstaffresolvingissue) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Closedby') ?></th>
            <td><?= h($customerservice->closedby) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('CSID') ?></th>
            <td><?= $this->Number->format($customerservice->CSID) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('CompletedBy') ?></th>
            <td><?= $this->Number->format($customerservice->CompletedBy) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Photos') ?></th>
            <td><?= $this->Number->format($customerservice->Photos) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('OrderNo') ?></th>
            <td><?= $this->Number->format($customerservice->OrderNo) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Video') ?></th>
            <td><?= $this->Number->format($customerservice->Video) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('IDLocation') ?></th>
            <td><?= $this->Number->format($customerservice->IDLocation) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('IDRegion') ?></th>
            <td><?= $this->Number->format($customerservice->IDRegion) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Replacementprice') ?></th>
            <td><?= $this->Number->format($customerservice->replacementprice) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('ServiceCode') ?></th>
            <td><?= $this->Number->format($customerservice->ServiceCode) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('DateDelivered') ?></th>
            <td><?= h($customerservice->DateDelivered) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('FirstAwareDate') ?></th>
            <td><?= h($customerservice->FirstAwareDate) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('VisitActionDate') ?></th>
            <td><?= h($customerservice->VisitActionDate) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Dataentrydate') ?></th>
            <td><?= h($customerservice->dataentrydate) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Followupdate') ?></th>
            <td><?= h($customerservice->followupdate) ?></td>
        </tr>
        <tr>
            <th scope="row"><?= __('Datecaseclosed') ?></th>
            <td><?= h($customerservice->datecaseclosed) ?></td>
        </tr>
    </table>
    <div class="row">
        <h4><?= __('ProblemDesc') ?></h4>
        <?= $this->Text->autoParagraph(h($customerservice->ProblemDesc)); ?>
    </div>
    <div class="row">
        <h4><?= __('ActionTaken') ?></h4>
        <?= $this->Text->autoParagraph(h($customerservice->ActionTaken)); ?>
    </div>
    <div class="row">
        <h4><?= __('PossibleSolution') ?></h4>
        <?= $this->Text->autoParagraph(h($customerservice->PossibleSolution)); ?>
    </div>
    <div class="row">
        <h4><?= __('ItemDesc') ?></h4>
        <?= $this->Text->autoParagraph(h($customerservice->ItemDesc)); ?>
    </div>
    <div class="row">
        <h4><?= __('Anycomments') ?></h4>
        <?= $this->Text->autoParagraph(h($customerservice->anycomments)); ?>
    </div>
    <div class="row">
        <h4><?= __('Closedcasenotes') ?></h4>
        <?= $this->Text->autoParagraph(h($customerservice->closedcasenotes)); ?>
    </div>
</div>
