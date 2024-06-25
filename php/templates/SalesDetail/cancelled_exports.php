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
                <div class="text-right px-3 pt-2">
                    <a href="<?=Router::url('/', true)?>sales-detail/create-order">ADD NEW COLLECTION</a><br>
                    <a href="<?=Router::url('/', true)?>sales-detail">SALES ADMIN</a>
                </div>
            </div>
            <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 col-xl-12">
                <h3 class="title">Cancelled Export Collections</h3>
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
                                        <strong><?php echo $s->location->adminheading ?? "unknown" ?></strong><br>
                                    <?php endforeach; ?>
                                </td>
                                <td><?php echo
                                        h($row->CollectionDate->i18nFormat('dd/MM/yyyy'))
                                         ?></td>
                                <td>
                                    <?php foreach ($row->export_coll_showroom as $s): ?>
                                        <?= h($s->ETAdate->i18nFormat('dd/MM/yyyy')) ?><br>
                                    <?php endforeach; ?>
                                </td>
                                <td><?php echo isset($row->shipper_addres->shipperName) ? $row->shipper_addres->shipperName : ""; ?></td>
                                <td><?php echo $row->TransportMode ?></td>
                                <td><?php echo $row->ContainerRef ?></td>
                                <td><?php 
                                $orderCount = 0;
                                foreach ($row->export_coll_showroom as $s): ?>
                                
                                        <?php 
                                        
                                        if ($s->export_links!=null)  {
                                             //var_dump($s->export_links);
                                             
                                            ?>
                                            <?php foreach ($s->export_links as $l): 
                                                ?>
                                                <?php 
                                                    if ($l->orderConfirmed == "y") {
                                                        $orderCount++;
                                                    }
                                                ?>
                                            <?php endforeach; ?>
                                            <?=$orderCount?> <?= $row->exportCollectionsID != null && $orderCount > 0 ? "<a href='/shipment-details.asp?location=".$s->location->idlocation."&id=".$row->exportCollectionsID."'>".$s->location->adminheading."</a>" ?? "unknown": "" ?><br/>
                                        <?php } ?>
                                    <?php endforeach; ?>
                                    <?=$orderCount == 0 ? $orderCount : ""?>
                                </td>
                                <td>
                                <?php 
                                $orderCount = 0;
                                foreach ($row->export_coll_showroom as $s): 
                                    
                                    ?>
                                
                                    <?php if ($s->export_links!=null)  {
                                        
                                        ?>
                                        <?php foreach ($row->export_coll_showroom as $l): 
                                            ?>
                                            <?php 
                                                if ($l->orderConfirmed == "y") {
                                                    $orderCount++;
                                                }
                                            ?>
                                        <?php endforeach; ?>
                                        
                                        <?php } ?>
                                    
                                <?php endforeach; ?>
                                <?=$orderCount > 0 ? $orderCount : ""?>
                                </td>
                                <td><?php echo $row->collection_status->collectionStatusName ?></td>
                                
                            </tr>
                        <?php endforeach ?>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>