<?php

use Cake\Routing\Router; ?>
<?php echo $this->Html->css('bootstrap.min.css', array('inline' => false)); ?>
<?php echo $this->Html->css('fabricStatus.css', array('inline' => false)); ?>
<?php echo $this->Html->css('userAdmin.css', array('inline' => false)); ?>
<?php echo $this->Html->css('style.css', array('inline' => false)); ?>
<?php echo $this->Html->script('popper.min.js', array('inline' => false)); ?>
<?php echo $this->Html->script('bootstrap.min.js', array('inline' => false)); ?>

<div class="container">
    <div class="border" style="margin-top:-1px;">
        <div class="row">
            <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 col-xl-12">
                <div class="text-right pl-3 pr-3">
                <a href="<?=Router::url('/', true)?>sales-detail/create-order">ADD NEW COLLECTION</a><br>
                    <a href="<?=Router::url('/', true)?>sales-detail">SALES ADMIN</a>
                </div>
            </div>
            <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 col-xl-12">
                <h3 class="title">Delivered Export Collections</h3>
                <div class="pl-3 pr-3">
                    <table class="table table-tr">
                        <tr>
                            <th>Showrooms</th>
                            <th>Collection Date
                                <br>
                                <span class="arou">
                                    <a href="?date=desc"><img width="34" height="30" border="0" align="middle" alt="Descending" src="/img/desc.gif"></a>
                                    <a href="?date=asc"><img width="34" height="30" border="" align="middle" alt="Ascending" src="/img/asc.gif"></a>
                                </span>
                            </th>
                            <th>ETA Date</th>
                            <th>Shipper</th>
                            <th>Transport Mode</th>
                            <th>Container Reff.</th>
                            <th>Qty. of<br>Orders</th>
                            <th>Items</th>
                            <th>Status</th>
                            
                        </tr>
                        <?php foreach ($data2 as $row): ?>
                            <tr>
                                <td>
                                    <?php foreach ($row->export_coll_showroom as $s): ?>
                                        <?= $s->location->adminheading ?? "unknown" ?><br>
                                    <?php endforeach; ?>
                                </td>
                                <td><?= $row->CollectionDate != null ? $this->Html->link(
                                        h($row->CollectionDate->i18nFormat('dd/MM/yyyy')),
                                        Router::url('/', true).'sales-detail/container-detail?id='.$row->exportCollectionsID

                                    ): h($row->CollectionDate->i18nFormat('dd/MM/yyyy')) ?></td>
                                <td>
                                    <?php foreach ($row->export_coll_showroom as $s): ?>
                                    <?=  h($s->ETAdate->i18nFormat('dd/MM/yyyy')) ?><br>
                                    <?php endforeach; ?>
                                </td>
                                <td><?= $row->shipper_addres->shipperName ?></td>
                                <td><?= $row->TransportMode ?></td>
                                <td><?= $row->ContainerRef ?></td>
                                <td>
                                    
                                <?php
                                    $purchaseNo = ""; 
                                    foreach ($row->export_coll_showroom as $s): ?>
                                
                                        <?php if ($s->export_links!=null)  {
                                            //var_dump($s->export_links);
                                            $orderCount = 0;
                                            ?>
                                            <?php foreach ($s->export_links as $l): 
                                                ?>
                                                <?php 
                                                    if ($l->purchase) {
                                                        if ($purchaseNo !=$l->purchase->PURCHASE_No) {
                                                            $purchaseNo =$l->purchase->PURCHASE_No;
                                                            $orderCount++;
                                                        }
                                                    }
                                                ?>
                                            <?php endforeach; ?>
                                            <?=$orderCount?> <?= $row->exportCollectionsID != null ? "<a href='/shipment-details.asp?location=".$s->location->idlocation."&id=".$row->exportCollectionsID."'>".$s->location->adminheading."</a>" ?? "unknown": "" ?> <br/>
                                        <?php } ?>
                                    <?php endforeach; ?>
                                </td>
                                <td>
                                <?php foreach ($row->export_coll_showroom as $s): ?>
                                
                                        <?php if ($s->export_links!=null)  {
                                            //var_dump($s->export_links);
                                            $orderCount = 0;
                                            ?>
                                            <?php foreach ($s->export_links as $l): 
                                                ?>
                                                <?php 
                                                    if ($l->orderConfirmed == "y") {
                                                        $orderCount++;
                                                    }
                                                ?>
                                            <?php endforeach; ?>
                                            <?=$orderCount?>
                                        <?php } ?>
                                    <?php endforeach; ?>
                                </td>
                                <td><?= $row->collection_status->collectionStatusName ?></td>
                                
                            </tr>
                        <?php endforeach ?>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>