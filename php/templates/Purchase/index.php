<?php
/**
 * @var \App\View\AppView $this
 * @var \App\Model\Entity\Purchase[]|\Cake\Collection\CollectionInterface $purchases
 */
?>
<?php use Cake\Routing\Router; ?>

<style>


ul.pagination li a {
    color: rgba(0, 0 ,0 , 0.54);
}

ul.pagination li.active a {
    background-color: #DCE47E;
    color: #FFF;
    font-weight: bold;
    cursor: default;
}
ul.pagination .disabled:hover a {
    background: none;
}

.paginator {
    text-align: center;
}

.paginator ul.pagination li {
    float: none;
    display: inline-block;
    padding:10px;
}

.paginator p {
    text-align: right;
    color: rgba(0, 0 ,0 , 0.54);
}

</style>

<div class="container">


    <h3><?= __('Purchases') ?></h3>
    <form action="" method="get">
    <p>Filter: <?= $this->Paginator->counter(['format' => '{{count}}'])?> Records<br>
    
     <select name="filter" onchange="this.form.submit()">
    <option value=''>--- All ---</option>
      <?php foreach ($locations as $location): ?>
    <option <?php if (isset($_GET['filter'])) { if ($_GET['filter']==$location->adminheading) {?> selected <?php }}; ?>><?php echo $location->adminheading ?></option>
     <?php endforeach; ?>
    </select>
   
    </form>
    
    <?php $filter='';
    if (isset($_GET['filter'])) {
    $filter= $_GET['filter'];
    }
    ?>
    
    
    <?= $this->Form->create($locations, [ 'url' => ['action' => 'export']]) ?>
    <?= $this->Form->hidden('filter', ['value'=>$filter]) ?>
    <?= $this->Form->button(__('Download CSV File'),[ 'class' => 'button pull-left padding-standard']) ?>
      <?= $this->Form->end() ?>
    <table cellpadding="0" cellspacing="0" width="100%" style="width:100% !important;">
        <thead>
            <tr>
            <th scope="col"><?= $this->Paginator->sort('CONTACT_No','Customer') ?></th>
            <th scope="col"><?= $this->Paginator->sort('companyname','Company') ?></th>
            <th scope="col"><?= $this->Paginator->sort('ORDER_NUMBER','Order No') ?></th>
            <th scope="col"><?= $this->Paginator->sort('code','Code') ?></th>
            <th scope="col"><?= $this->Paginator->sort('deliverypostcode','Postcode') ?></th>
            <th scope="col"><?= $this->Paginator->sort('order date','Order Date') ?></th>
            <th scope="col"><?= $this->Paginator->sort('acknowdate','Ack Date') ?></th>
            <th scope="col"><?= $this->Paginator->sort('adminheading','Showroom') ?></th>
						<th scope="col"><?= $this->Paginator->sort('Order') ?></th>
						<th scope="col"><?= $this->Paginator->sort('Payments') ?></th>
						<th scope="col"><?= $this->Paginator->sort('Balance') ?></th>
						<th scope="col"><?= $this->Paginator->sort('Production Date') ?></th>
						<th scope="col"><?= $this->Paginator->sort('Booked Delivery Date') ?></th>
						<th scope="col"><?= $this->Paginator->sort('Ex-works Date') ?></th>	     
            </tr>
        </thead>
        <tbody>
            <?php foreach ($purchases as $purchase): ?>
            <tr>
            <td><?= $purchase->contact->surname ?>, <?= $purchase->contact->title ?> <?= $purchase->contact->first ?></td>
            <td><?= $purchase->companyname ?></td>
            <td><a href="/edit-purchase.asp?order=<?= $purchase->PURCHASE_No ?>"><?= $purchase->ORDER_NUMBER ?></a></td>
            <td><?= h($purchase->CODE) ?></td>
            <td><?= h($purchase->deliverypostcode) ?></td> 
            <td><?php if ($purchase->ORDER_DATE != '') {?><?=h(date_format(date_create($purchase->ORDER_DATE),"d/m/Y "))?><?php }?></td> 
            <td>
                    
         
            <?php 
             if ($purchase->acknowdate != '') {
          		  $olderDate = date("Y/m/d");
            		$newerDate = strtotime($purchase->acknowdate);
								$thenTimestamp = strtotime($olderDate);
								$difference = $thenTimestamp - $newerDate;
 								$days = floor($difference / (60*60*24) );
 								if ($days>7) {
 								echo '<img src="http://www.savoirdev.co.uk/img/redflag.jpg">';
 								}
 								}

?>
            
            </td> 
            <td><?= h($purchase->location->adminheading) ?></td> 
            <td><?= currencysymbol($purchase->ordercurrency) ?><?= number_format(h($purchase->total), 2, '.', ''); ?></td>
          	<td><?= currencysymbol($purchase->ordercurrency) ?><?= number_format(h($purchase->paymentstotal), 2, '.', ''); ?></td>
     	 	    <td><?= currencysymbol($purchase->ordercurrency) ?><?= number_format(h($purchase->balanceoutstanding), 2, '.', ''); ?></td>
     				<td><?php if ($purchase->productiondate != '') {?><?=h(date_format(date_create($purchase->productiondate),"d/m/Y"))?><?php }?></td>
     				<td><?php if ($purchase->bookeddeliverydate != '') {?><?=h(date_format(date_create($purchase->bookeddeliverydate),"d/m/Y"))?><?php }?></td>
     				<td><?php if ($purchase->acknowdate != '') {?><?=h(date_format(date_create($purchase->acknowdate),"d/m/Y"))?><?php }?></td> 
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
    <div class="paginator">
        <ul class="pagination">
            <?= $this->Paginator->first('<< ' . __('first')) ?>
            <?= $this->Paginator->prev('< ' . __('previous')) ?>
            <?= $this->Paginator->numbers() ?>
            <?= $this->Paginator->next(__('next') . ' >') ?>
            <?= $this->Paginator->last(__('last') . ' >>') ?>
        </ul>
        <p><?= $this->Paginator->counter(['format' => __('Page {{page}} of {{pages}}, showing {{current}} record(s) out of {{count}} total')]) ?></p>
    </div>
</div>


<?php

function currencysymbol($cs) {
    $currensymboltodisplay = '&pound;';
    switch ($cs) {
    case "EUR":
        $currensymboltodisplay = '&#8364;';
        break;
    case "USD":
        $currensymboltodisplay = '&#36;';
        break;
    case "CZK":
        $currensymboltodisplay = '&#75;&#269;;';
        break;
		}
		echo $currensymboltodisplay;    
}

?>  