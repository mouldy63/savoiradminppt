<?php
/**
 * @var \App\View\AppView $this
 * @var \App\Model\Entity\Customerservice[]|\Cake\Collection\CollectionInterface $customerservice
 */
?>
<?php echo $this->Html->css('bootstrap.min.css', array('inline' => false)); ?>
<?php echo $this->Html->css('fabricStatus.css', array('inline' => false)); ?>
<?php echo $this->Html->css('userAdmin.css', array('inline' => false)); ?>
<?php echo $this->Html->css('style.css', array('inline' => false)); ?>

<?php echo $this->Html->script('bootstrap.min.js', array('inline' => false)); ?>
<div class="container minthirtyfive-top-margin">
    <div class="bg-grey">
        <div class= "row">
            <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 col-xl-12">
            
                <h3 class="title">Customer Service List</h3>
                <p>Total number of reports open = <?= $total ?></p>
                <table width="935" border="0" cellpadding="6" cellspacing="2">
                <tr>
                    <td width="71" valign="bottom"><b>Customer Service No.<a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=desc&sort=CSNumber"><br>  
                    <br>
                    <img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=asc&sort=CSNumber"><img src="/img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
                    <td width="69" valign="bottom"><strong>Location<br>
                    <br>
                    </strong><b><a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=desc&sort=Showroom"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=asc&sort=Showroom"><img src="/img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
                    <td width="72" valign="bottom"><strong>Order No<br>
                        <br>s
                    </strong><b><a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=desc&sort=OrderNo"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=asc&sort=OrderNo"><img src="/img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
                    <td width="75" valign="bottom"><strong>Customer Name</strong><br>
                        <br>
                        <b><a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=desc&sort=custname"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=asc&sort=custname"><img src="/img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></b></td> 
                    <td width="72" valign="bottom"><b>Customer Service Date<a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=desc&sort=dataentrydate"><br>
                        <br>
                        <img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=asc&sort=dataentrydate"><img src="/img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></b></td>
                    <td width="106" valign="bottom"><strong>Item Description</strong></td>
                    <td width="100" valign="bottom"><strong>Latest Note</strong></td>
                    <td width="49" valign="bottom"><strong>Last note by</strong></td>
                    <td width="71" valign="bottom"><strong>Savoir Staff resolving this issue</strong><br>
                        <br>
                        <strong><a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=desc&sort=closedby"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=asc&sort=closedby"><img src="/img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></strong></td>

                    <td width="108" valign="bottom"><b>Follow-up Date<br>
                    <br>
                    </b><strong><a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=desc&sort=followupdate"><img src="/img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><br/><a href="<?php echo $this->request->getAttributes()['webroot']; ?>customerservice?direction=asc&sort=followupdate"><img src="/img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></strong></td>
                
                    </tr>
                        <?php foreach ($customerservices as $customerservice): ?>
                        <tr>
                           
                            <td><?php echo $this->Html->link(
                                h($customerservice->CSNumber),
                                $this->Url->build([
                                    "controller" => "customerservice",
                                    "action" => "report",
                                    "?" => ["csid" => $customerservice->CSID],
                                
                                ],[
                                    'escape' => false,
                                    'fullBase' => true,
                                ])
                            ); ?></td>
                            <td><?= h($customerservice->Showroom) ?></td>
                            <td><?= $customerservice->purchase != null ? $this->Html->link(
                                h($customerservice->OrderNo),
                                'http://www.savoirdev.co.uk/edit-purchase.asp?order='.$customerservice->purchase->PURCHASE_No
                                
                            ): h($customerservice->OrderNo) ?></td>
                            <td><?= h($customerservice->custname) ?></td>
                            <td><?= $this->Time->format($customerservice->dataentrydate, 'dd/MM/yyyy', '')?></td>
                            <td><?= h($customerservice->ItemDesc) ?></td>
                            <td><?= h( count($customerservice->customer_service_notes) > 0 ? $customerservice->customer_service_notes[count($customerservice->customer_service_notes)-1]->note : "") ?></td>
                            <td><?= h((count($customerservice->customer_service_notes) > 0  && $customerservice->customer_service_notes[count($customerservice->customer_service_notes)-1]->savoir_user!=null ) ? $customerservice->customer_service_notes[count($customerservice->customer_service_notes)-1]->savoir_user->username :"") ?></td>
                            <td><?= h($customerservice->closedby) ?></td>
                            <?php
                            $fontstyle='';
                            if ($customerservice->followupdate != '') {
                            	$today = date("Y-m-d");
                            	$today_time = strtotime($today);
                            	
                            	if (strtotime($customerservice->followupdate) < $today_time) {
                            		$fontstyle='red'; 
                           		 } else {
                           			 $fontstyle=''; 
                           		 }
                           	}
                            ?>
                            <td>
                            <font color='<?= $fontstyle ?>'>
                            <?=  $this->Time->format($customerservice->followupdate, 'dd/MM/yyyy', '') ?>
                            </font>
                            </td>
                            <!--<td class="actions">
                                <?= $this->Html->link(__('View'), ['action' => 'view', $customerservice->CSID]) ?>
                                <?= $this->Html->link(__('Edit'), ['action' => 'edit', $customerservice->CSID]) ?>
                                <?= $this->Form->postLink(__('Delete'), ['action' => 'delete', $customerservice->CSID], ['confirm' => __('Are you sure you want to delete # {0}?', $customerservice->CSID)]) ?>
                            </td>-->
                        </tr>
                        <?php endforeach; ?>
                </table>
                <div class="paginator">
                    <ul class="pagination">
                        <?= $this->Paginator->first('<<  ' . __('first')) ?>
                        <?= $this->Paginator->prev('<  ' . __('previous')) ?>
                        <?= $this->Paginator->numbers() .'&nbsp;&nbsp;' ?>
                        <?= $this->Paginator->next(__('next') . '  >') ?>
                        <?= $this->Paginator->last(__('last') . '  >>') ?>
                    </ul>
                    <p><?= $this->Paginator->counter(['format' => __('Page {{page}} of {{pages}}, showing {{current}} record(s) out of {{count}} total')]) ?></p>
                </div>
            </div> 
        </div>
    </div>
</div>
