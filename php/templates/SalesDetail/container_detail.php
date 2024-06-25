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
            <div class="pl-3 pr-3">
            <?php if ($exportCollection != null) { 
                $first = true;

                //var_dump($exportCollection);
                ?>  
                <?php foreach ($exportCollection->export_coll_showroom as $exportcollshowrooms) {
                    $total = 0;
                    ?>
                    <h3 class="title pl-0">Shipment Details</h3>
                    <table class="table table-sd">
                        <tr>
                            <th>Country</th>
                            <th>Collection Date</th>
                            <th>ETA Date</th>
                            <?php if ($first) { ?>
                            <th>Shipper</th>
                            <th>Transport Mode</th>
                            <th>Container Reff.</th>
                            <th>Qty. of Orders</th>
                            <th>Status</th>
                            <th>Mainfest</th>
                            <?php } else {?>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                                <th>&nbsp;</th>
                            <?php }?>
                        </tr>
                        <?php if ($exportcollshowrooms != null) { 
                            //var_dump($exportCollection->CollectionDate);
                            //var_dump($exportcollshowrooms->export_links);
                            ?>  
                            <tr>
                                <td><?= h($exportcollshowrooms->location != null ? $exportcollshowrooms->location->location : "")?></td>
                                <td><?= $exportCollection->CollectionDate->i18nFormat('dd/MM/yyyy')?></td>
                                <td><?= $exportcollshowrooms->ETAdate->i18nFormat('dd/MM/yyyy')?></td>
                                <?php if ($first) { ?>
                                    <td><?=h($exportCollection->shipper_addres != null ? $exportCollection->shipper_addres->shipperName : "")?></td>
                                    <td><?=$exportCollection->TransportMode?></td>
                                    <td><?=$exportCollection->ContainerRef?></td>
                                    <td>
                                    <?php 
                                    $orderCount = 0;
                                    if ($exportcollshowrooms->export_links!=null)  {
                                                //var_dump($s->export_links);
                                            
                                            $purchaseNo = "";
                                            
                                    ?>
                                        <?php foreach ($exportcollshowrooms->export_links as $l): 
                                            ?>
                                            <?php 
                                                if ($l->orderConfirmed == "y") {
                                                    if ($l->purchase) {
                                                        if ($purchaseNo !=$l->purchase->PURCHASE_No) {
                                                            $purchaseNo =$l->purchase->PURCHASE_No;
                                                            $orderCount++;
                                                        }
                                                    }
                                                }
                                            ?>
                                        <?php endforeach; ?>
                                        
                                    <?php } ?>    
                                    <?=$orderCount?>
                                    </td>
                                    <td><?= h($exportCollection->collection_status != null ? $exportCollection->collection_status->collectionStatusName : "")?></td>
                                    <td><a href="#">Print</a></td>
                                <?php } else {?>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                <?php }?>
                            </tr>
                        
                            <tr>
                                <td colspan="9" class="p-0">
                                    <br>
                                    <br>
                                    <br>
                                    <?php if ($first) { ?>
                                        <table class="table sub-table">
                                    <?php } else { ?>
                                        <table class="table sub-table no-line-top">
                                    <?php } ?>
                                        <tr>
                                            <td colspan="16"><h3 class="title mt-0 p-0">Order Details</h3></td>
                                        </tr>
                                        <tr>
                                            <th><strong>Surname</strong></th>
                                            <th><strong>Order</strong></th>
                                            <th><strong>Invoice<br>No.<br></strong></th>
                                            <th><strong>Company<br>Name<br></strong></th>
                                            <th><strong>Customer Ref.</strong></th>
                                            <th style="width:46px;"><strong>Mat<br>Spec</strong></th>
                                            <th style="width:46px;"><strong>Base<br>Spec<br></strong></th>
                                            <th><strong>Topper<br>Spec<br></strong></th>
                                            <th><strong>Headboards<br>Spec<br></strong></th>
                                            <th><strong>Legs</strong></th>
                                            <th><strong>Leg<br>Colour<br></strong></th>
                                            <th><strong>Valance</strong></th>
                                            <th><strong>Accessories</strong></th>
                                            <th><strong>Total Export<br>Value<br></strong></th>
                                            <th><strong>Items</strong></th>
                                            <th class="text-right"><strong>Commercial<br>Invoice<br></strong></th>
                                        </tr>
                                        
                                            
                                        <?php if (count($orderDetails)>0) { ?>
                                            <?php foreach ($orderDetails as $details) { 
                                                    //debug($details);
                                                   //cho '<pre>' . var_export($exportcollshowrooms->export_links) . '</pre>';
                                                   if ($exportcollshowrooms->location->idlocation == $details['idLocation']) {
                                                       $total += $details['bedsettotal']
                                                ?>
                                                
                                                    <tr>
                                                        <td><?=h($details['surname'])?></td>
                                                        <td><?=
                                                        '<a href="http://www.savoirdev.co.uk/orderdetails.asp?pn='.$details['PURCHASE_No'].'">'.h($details['ORDER_NUMBER']).'</a>'
                                                        ?></td>
                                                        <td><?=h($details['InvoiceNo'])?></td>
                                                        <td><?=h($details['companyname'])?></td>
                                                        <td><?=h($details['customerreference'])?></td>
                                                        <td><?= $this->ComponentStatus->colourise($details['savoirmodel'], $details['PURCHASE_No'],$exportCollection->CollectionDate, $exportcollshowrooms->export_links,  $exportcollshowrooms->location->idlocation, $exportCollection->exportCollectionsID, '1')?></td>
                                                        <td><?=$this->ComponentStatus->colourise($details['basesavoirmodel'], $details['PURCHASE_No'], $exportCollection->CollectionDate, $exportcollshowrooms->export_links,  $exportcollshowrooms->location->idlocation, $exportCollection->exportCollectionsID,  '3')?></td>
                                                        <td><?=$this->ComponentStatus->colourise($details['toppertype'], $details['PURCHASE_No'], $exportCollection->CollectionDate, $exportcollshowrooms->export_links,  $exportcollshowrooms->location->idlocation, $exportCollection->exportCollectionsID,  '5')?></td>
                                                        <td><?=$this->ComponentStatus->colourise($details['headboardstyle'], $details['PURCHASE_No'], $exportCollection->CollectionDate, $exportcollshowrooms->export_links,  $exportcollshowrooms->location->idlocation, $exportCollection->exportCollectionsID,  '8')?></td>
                                                        <td><?=$this->ComponentStatus->colourise($details['legstyle'], $details['PURCHASE_No'], $exportCollection->CollectionDate, $exportcollshowrooms->export_links,  $exportcollshowrooms->location->idlocation, $exportCollection->exportCollectionsID,  '7')?></td>
                                                        <td><?=$this->ComponentStatus->colourise($details['legfinish'], $details['PURCHASE_No'], $exportCollection->CollectionDate, $exportcollshowrooms->export_links,  $exportcollshowrooms->location->idlocation, $exportCollection->exportCollectionsID,  '7')?></td>
                                                        <td><?=$this->ComponentStatus->colourise($details['valancerequired'], $details['PURCHASE_No'], $exportCollection->CollectionDate, $exportcollshowrooms->export_links,  $exportcollshowrooms->location->idlocation, $exportCollection->exportCollectionsID,  "6")?></td>
                                                        <td><?=$this->ComponentStatus->colourise($details['accessoriesrequired'], $details['PURCHASE_No'], $exportCollection->CollectionDate, $exportcollshowrooms->export_links,  $exportcollshowrooms->location->idlocation, $exportCollection->exportCollectionsID, "9")?></td>
                                                        <td>$<?=h(number_format($details['bedsettotal'],2))?></td>
                                                        <td>
                                                            
                                                        <?php 
                                                        $orderCount= $this->ComponentStatus->countItemQtyDetails($exportcollshowrooms->exportCollectionID, $exportcollshowrooms->exportCollshowroomsID, $details['PURCHASE_No']);
                                                        ?>      
                                                        <?= $orderCount?><br></td>
                                                        <td class="text-right"><a href="#">Print</a></td>
                                                    </tr>
                                                    <?php } ?> 
                                            <?php } ?> 
                                                    <tr>
                                                        <td colspan="13"></td>
                                                        <td><hr class="mt-0">$<?=h(number_format($total,2))?></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                 
                                        <?php } ?>
                                            
                                    <?php } ?>
                                    </table>
                                </td>
                        </tr>
                    
                    </table>
                    <?php 
                        $first = false;
                    }?>
                <?php } ?>
                    <hr class="special">
                    <div class="text-right"><?= $exportCollection != null ? $this->Html->link(
                                        "Print CSV",
                                        Router::url('/', true).'sales-detail/export?id='.$exportCollection->exportCollectionsID
                                        
                                    ): $this->Html->link(
                                        "Print CSV",
                                        "#"
                                        
                                    ) ?></div>
                    
                
    			<div class="key">
    				<h3>Key</h3>
    				<ul>
    					<li>
    						<span class="keycolor red">&nbsp;</span> <p>In Production</p>
    					</li>
    					<li>
    						<span class="keycolor orange">&nbsp;</span> <p>Order on Stock, Waiting QC</p>
    					</li>
    					<li>
    						<span class="keycolor green">&nbsp;</span> <p>QC Checked</p>
    					</li>
    					<li>
    						<span class="keycolor green">&nbsp;</span> <p>In Bay</p>
    					</li>
    					<li>
    						<span class="keycolor green">&nbsp;</span> <p>Order Picked</p>
    					</li>
    					<li>
    						<span class="keycolor">&nbsp;</span> <p>Delivered</p>
    					</li>
    				</ul>
    			</div>
            </div>
    		</div>
        </div>
	</div>
</div>