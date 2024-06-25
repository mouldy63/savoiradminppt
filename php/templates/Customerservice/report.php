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
<?php echo $this->Html->css('jquery-ui.min.css', array('inline' => false)); ?>
<?php echo $this->Html->script('popper.min.js', array('inline' => false)); ?>
<?php echo $this->Html->script('bootstrap.min.js', array('inline' => false)); ?>
<?php echo $this->Html->script('jquery-ui.min.js', array('inline' => false)); ?>
<script>
$(function() {
    var year = new Date().getFullYear();
    $( "#followupdate" ).datepicker({
        changeMonth: true,
        yearRange: "1997:"+year,
        changeYear: true
    });
    $( "#followupdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
    $("#closecase").click(function() {
                //debugger;
                if (this.checked) {
                    $('#closednotes_div').show("fast");
                } else {
                    $('#closednotes_div').hide("fast");
                }
            }
    );
    $("#submitcs").click( function(ev) {
        console.log($("input[name='csclosed']:checked").val());
        
        
        if ($("input[name='csclosed']:checked").val()=="y") {
            var tempVal = $('#replacementprice').val();
            var regex = /^\d+(\.\d{0,2})?$/;
            //console.log(tempVal);
            //debugger;
                if (!(regex.test(tempVal))) {
                    alert("Replacement Price not Numeric");
                    ev.preventDefault();
                }
        
        }
       
    });
});
</script>
<div class="container minthirtyfive-top-margin">
    <div class="bg-grey">
        <div class= "row">
            <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 col-xl-12">
                <h3 class="title">Customer Service report: Issue raised on <?= $this->Time->format($customerservice->dataentrydate, 'dd MMMM yyyy', '')?></h1>

                <form class="form-custom" method="POST" name="form1" enctype="multipart/form-data">
                    
                    <table class="table">
                        <tbody>
                            <tr>
                                <td width="22%" valign="top">Customer Service Number</td>
                                <td width="31%" valign="top"><?=$customerservice->CSNumber?></td>
                                <td width="25%" valign="top">Showroom</td>
                                <td width="22%" valign="top">
                                <?=$customerservice->Showroom?></td>
                            </tr>
                            <tr>
                                <td valign="top">Original Form Completed by:</td>
                                <td valign="top">
                                <?=($customerservice->savoir_user != NULL ? $customerservice->savoir_user->username : "")?>

                                </td>
                                <td valign="top">Order Number</td>
                                <td valign="top"><?=($customerservice->OrderNo != NULL ? $customerservice->OrderNo :"")?></td>
                            </tr>
                            <tr>
                                
                                <td valign="top">Date item delivered to Customer</td>
                                <td valign="top"><?= $this->Time->format($customerservice->DateDelivered, 'dd/MM/yyyy', '')?>
                                </td>
                                <td valign="top">Customer Name</td>
                                <td valign="top"><?=$customerservice->custname?></td>
                            </tr>
                            <tr>
                                <td valign="top">Item Description</td>
                                <td valign="top"><?=$customerservice->ItemDesc?></td>
                                <td valign="top">Date customer first made you aware of the problem</td>
                                <td valign="top"><?= $this->Time->format($customerservice->FirstAwareDate, 'dd/MM/yyyy', '')?></td>
                            </tr>
                            <tr>
                                <td valign="top">Please describe the problem with the product</td>
                                <td valign="top"><?=$customerservice->ProblemDesc?></td>
                                <td valign="top">Please let us know what you feel the solution to the problem is:</td>
                                <td valign="top"><?=$customerservice->PossibleSolution?></td>
                            </tr>
                            <tr>
                                <td valign="top">Photos / Videos of problem</td>
                                <td rowspan="4" valign="top">

                                <?php  $i = 1;
                                foreach ($customerservice->customer_service_upload as $customer_service_upload) { ?>
                                    <a href="../../<?=$customer_service_upload->prodfilename?>" target="_blank"> Download <?= $i?></a><br>
                                <?php $i++;
                                } ?>
                                </td>
                                <td valign="top">What action have you already taken about this problem:</td>
                                <td valign="top"><?=$customerservice->ActionTaken?></td>
                            </tr>
                            <tr>
                                <td valign="top">&nbsp;</td>
                                <td valign="top">What date was this visit / action:</td>
                                <td valign="top"><?= $this->Time->format($customerservice->VisitActionDate, 'dd/MM/yyyy', '')?></td>
                            </tr>
                            <tr>
                                <td valign="top">&nbsp;</td>
                                <td valign="top">Any other comments</td>
                                <td valign="top"><?=$customerservice->anyComments?></td>
                            </tr>
                            <tr>
                                <td valign="top">&nbsp;</td>
                                <td valign="top"><div class="form-group">
                                        <label for="savoirstaff" class="">Savoir Staff resolving this issue</label></div></td>
                                <td valign="top">
                                    <div class="form-group">
                                    <?= $this->Form->text('savoirstaffresolvingissue', ['value' => $customerservice->savoirstaffresolvingissue, 'class' => $this->Form->isFieldError('savoirstaffresolvingissue') ? 'form-control is-invalid' : 'form-control']) ?>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" valign="top">
                                    <hr>
                                </td>
                            </tr>
                            
                            <tr>
                                <td valign="top"><strong>NOTES:</strong></td>
                                <td valign="top">&nbsp;</td>
                                <td><?php if ($customerservice->csclosed != "y") { ?>
                                    <strong>
                                    LATEST FOLLOW-UP ACTION DATE
                                    </strong> <?= $this->Time->format($customerservice->followupdate, 'dd/MM/yyyy', '')?>
                                <?php } else {?>
                                    <strong>
                                    DATE CLOSED
                                    </strong> <?= $this->Time->format($customerservice->datecaseclosed, 'dd/MM/yyyy', '')?>
                                <?php } ?>
                                </td>
                                <td></td>
                            </tr>
                            
                            <tr>
                            <td valign="top"><strong>Date of Note</strong></td>
                            <td valign="top"><strong>Note</strong></td>
                            <td valign="top"><strong>Action Date</strong></td>
                            <td><strong>Note Added By</strong></td>
                            </tr>
                            <?php if (count($customerservice->customer_service_notes) > 0 ) {  ?>
                            <?php  $i = 1;
                                foreach ($customerservice->customer_service_notes as $customer_service_note) { 
                                   
                                    ?>
                                    <tr>
                                        <td valign="top"><?= $this->Time->format($customer_service_note->dateadded, 'dd/MM/yyyy', '')?></td>
                                        <td valign="top"><?=$customer_service_note->note?></td>
                                        <td valign="top"><?= $this->Time->format($customer_service_note->actiondate, 'dd/MM/yyyy', '')?></td>

                                        <td valign="top"><?= ($customer_service_note->noteaddedby == NULL  ? "" : ($customer_service_note->savoir_user == NULL ? "" :$customer_service_note->savoir_user->username))?></td>
                                    </tr>
                                <?php $i++;
                                } ?>
                            <?php } ?>
                            <tr>
                                <td valign="top">
                                    <div class="form-group">
                                        <label for="photos">Add Photos/Videos:</label>
                                       
                                    </div>
                                </td>
                                <td valign="top">
                                    <div class="form-group">
                                        <label class="custom-file">
                                        <?= $this->Form->file('pictures[]', ['class' => 'form-control-file']) ?>
                                        <?= $this->Form->file('pictures[]', ['class' => 'form-control-file']) ?>
                                        <?= $this->Form->file('pictures[]', ['class' => 'form-control-file']) ?>
                                        <?= $this->Form->file('pictures[]', ['class' => 'form-control-file']) ?>
                                        <?= $this->Form->file('pictures[]', ['class' => 'form-control-file']) ?>
                                        <?= $this->Form->file('pictures[]', ['class' => 'form-control-file']) ?>
                                        </label>
                                    </div>
                                </td>
                                <td valign="top">&nbsp;</td>
                                <td valign="top">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="4" valign="top">
                                    <hr>
                                </td>
                            </tr>
                            <?php if ($customerservice->csclosed != "y") { ?>
                                <tr>
                                    <td valign="top"><label for="note">Add Note</label></td>
                                    <td valign="top">
                                        <div class="form-group">
                                        <?= $this->Form->textarea('note', ['rows' => '6', 'class' => $this->Form->isFieldError('note') ? 'form-control is-invalid' : 'form-control']) ?>
                                        <?php
                                        if ($this->Form->isFieldError('note')) {
                                            echo '<div class="invalid-feedback">' . $this->Form->error('note') . '</div>';
                                        }
                                        ?>
                                        </div>
                                    </td>
                                    <td valign="top"><label for="dateA">Follow up action date</label></td>
                                    <td valign="top">
                                        <div class="form-group">
                                        <?= $this->Form->text('followupdate', ['class' => $this->Form->isFieldError('followupdate') ? 'form-control is-invalid datepicker' : 'datepicker', 'id'=>'followupdate']) ?>
                                        </div>
                                    </td>
                                </tr>
                                <?php if ($this->Security->retrieveUserLocation()==1) { ?>}
                                <tr>
                                    <td valign="top">Close Case (if ticked case is closed)</td>
                                    <td valign="top">
                                        <p>
                                            <?= $this->Form->checkbox('csclosed', ['id'=>"closecase", 'value' => 'y'])?>
                                            <label for="closecase"></label>
                                        </p>
                                    </td>
                                    <td colspan="2" valign="top">
                                        <div id="closednotes_div" style="display:none;">
                                            <div class="form-group">
                                            
                        
                                            
                                                <label for="closedcasenotes">Please describe how this case was resolved</label>
                                                <?= $this->Form->textarea('closedcasenotes', ['rows' => '6', 'class' => $this->Form->isFieldError('closedcasenotes') ? 'form-control is-invalid' : 'form-control']) ?>
                                                <?php
                                                if ($this->Form->isFieldError('closedcasenotes')) {
                                                    echo '<div class="invalid-feedback">' . $this->Form->error('closedcasenotes') . '</div>';
                                                }
                                                ?>
                                            </div>
                                            <div class="form-group">
                                                <label for="closedby">Case closed by</label>
                                                <?= $this->Form->text('closedby', ['class' => $this->Form->isFieldError('closedby') ? 'form-control is-invalid' : 'form-control']) ?>
                                            </div>
                                            <div class="form-group">
                                                <label for="replacementprice">Replacement Item GBP Retail Price (Inc. VAT)</label>
                                                £<?= $this->Form->text('replacementprice', ['class' => $this->Form->isFieldError('replacementprice') ? 'form-control is-invalid' : 'form-control', 'id'=>"replacementprice"]) ?>
                                            </div>
                                            <div class="form-group">
                                                <label for="servicecode">Please enter service code:</label>
                                                <?php 
                                                    //$sizes = ['n' => 'Please choose code', '1' => 'Customer Fault', '2' => 'Product Fault'];
                                                    echo $this->Form->select('sizes', $row_options_servicecode, ['default' => 'n', 'class' => 'form-control']);
                                                ?>
                                                
                                            </div>
                                            
                                            
                                            
                                        </div>
                                    </td>
                                </tr>
                                <?php } ?>
                            
                            <tr>
                                <td colspan="4" class="text-right">
                                    <input class="btn" name="submitcs" type="submit" id="submitcs" tabindex="40" value="Submit"/>
                                </td>
                            </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </form>
                <p>21/6/2018&nbsp;</p>
                <!--</form>-->
            </div>
        </div>
    </div>

</div>
