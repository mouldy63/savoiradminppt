<?php use Cake\Routing\Router; ?>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#FirstAwareD" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true,
altField: "#FirstAwareDate",
altFormat: "yy-mm-dd"
});
$( "#FirstAwareD" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#DateDeliveredD" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true,
altField: "#DateDelivered",
altFormat: "yy-mm-dd"
});
$( "#DateDeliveredD" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#actiondateD" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true,
altField: "#VisitActionDate",
altFormat: "yy-mm-dd"
});
$( "#actiondateD" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});
</script>
<?php
/**
 * @var \App\View\AppView $this
 * @var \App\Model\Entity\Customerservice $customerservice
 */
$this->Form->setTemplates([
    'dateWidget' => '{{day}}{{month}}{{year}}{{hour}}{{minute}}{{second}}{{meridian}}'
]);
?>

<?php echo $this->Html->css('bootstrap.min.css', array('inline' => false)); ?>
<?php echo $this->Html->css('fabricStatus.css', array('inline' => false)); ?>
<?php echo $this->Html->css('userAdmin.css', array('inline' => false)); ?>
<?php echo $this->Html->css('style.css', array('inline' => false)); ?>
<?php echo $this->Html->script('popper.min.js', array('inline' => false)); ?>
<?php echo $this->Html->script('bootstrap.min.js', array('inline' => false)); ?>

<div class="container minthirtyfive-top-margin">
    <div class="bg-grey">
        <div class="row">
            <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 col-xl-12">
                <h3 class="title">Customer Service form - Customer Service Date <?= date('d/m/Y') ?></h3>
                <?= $this->Form->create($customerservice, ['type' => 'file', 'class' => 'form-custom']) ?>
                <div style="display:none;">
                			<?= $this->Form->text('CompletedBy', ['readonly' => 'readonly', 'class' => $this->Form->isFieldError('CompletedBy') ? 'form-control-plaintext is-invalid' : 'form-control-plaintext']) ?>
                            <?php
                            if ($this->Form->isFieldError('CompletedBy')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('CompletedBy') . '</div>';
                            }
                            ?>
               				 <?= $this->Form->text('IDLocation', ['readonly' => 'readonly']) ?>
               				<?= $this->Form->text('DateDelivered', ['id' => 'DateDelivered', 'class' => $this->Form->isFieldError('DateDelivered') ? 'form-control-plaintext is-invalid' : 'form-control-plaintext']) ?>
               				
               				<?= $this->Form->text('FirstAwareDate', ['id' => 'FirstAwareDate', 'class' => $this->Form->isFieldError('FirstAwareDate') ? 'form-control-plaintext is-invalid' : 'form-control-plaintext']) ?>
               				
               				<?= $this->Form->text('VisitActionDate', ['id' => 'VisitActionDate', 'class' => $this->Form->isFieldError('VisitActionDate') ? 'form-control-plaintext is-invalid' : 'form-control-plaintext']) ?>
                            
                </div>
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6">
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">Customer Service Number</label>
                        <div class="col-sm-7">
                            <?= $this->Form->text('CSNumber', ['class' => $this->Form->isFieldError('CSNumber') ? 'form-control is-invalid' : ($this->Form->isFieldError('CSNumber') ? 'form-control is-invalid' : 'form-control')]) ?>
                            <?php
                            if ($this->Form->isFieldError('CSNumber')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('CSNumber') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">Form Completed by:</label>
                        <div class="col-sm-7 col-form-label">
                            <?= $currentusername ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">Date item delivered to Customer</label>
                        <div class="col-sm-7">
                            <?= $this->Form->text('DateDeliveredD', ['id' => 'DateDeliveredD', 'class' => $this->Form->isFieldError('DateDeliveredD') ? 'form-control is-invalid' : 'form-control']) ?>
                            <?php
                            if ($this->Form->isFieldError('DateDeliveredD')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('DateDeliveredD') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label"><span class="require">*</span>Item Description <br><br>(for example No2 Mattress, HW Topper)</label>
                        <div class="col-sm-7">
                            <?= $this->Form->textarea('ItemDesc', ['rows' => '6', 'class' => $this->Form->isFieldError('ItemDesc') ? 'form-control is-invalid' : 'form-control']) ?>
                            <?php
                            if ($this->Form->isFieldError('ItemDesc')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('ItemDesc') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label"><span class="require">*</span>Please describe the problem with the product</label>
                        <div class="col-sm-7">
                            <?= $this->Form->textarea('ProblemDesc', ['rows' => '6', 'class' => $this->Form->isFieldError('ProblemDesc') ? 'form-control is-invalid' : 'form-control']) ?>
                            <?php
                            if ($this->Form->isFieldError('ProblemDesc')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('ProblemDesc') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">Please email photographs of beds which are relevant <br><br>MAX FILE SIZE 3mb</label>
                        <div class="col-sm-7">
                            <label class="custom-file">
                                <?= $this->Form->file('pictures[]', ['class' => 'form-control-file']) ?>
                                <?= $this->Form->file('pictures[]', ['class' => 'form-control-file']) ?>
                                <?= $this->Form->file('pictures[]', ['class' => 'form-control-file']) ?>
                                <?= $this->Form->file('pictures[]', ['class' => 'form-control-file']) ?>
                                <?= $this->Form->file('pictures[]', ['class' => 'form-control-file']) ?>
                                <?= $this->Form->file('pictures[]', ['class' => 'form-control-file']) ?>
                            </label>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6">
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">Showroom</label>
                        <div class="col-sm-7">
                            <?= $this->Form->text('Showroom', ['readonly' => 'readonly', 'class' => $this->Form->isFieldError('Showroom') ? 'form-control-plaintext is-invalid' : 'form-control-plaintext']) ?>
                            <?php
                            if ($this->Form->isFieldError('Showroom')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('Showroom') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">Customer Name:</label>
                        <div class="col-sm-7">
                            <?= $this->Form->text('custname', ['class' => $this->Form->isFieldError('custname') ? 'form-control is-invalid' : 'form-control']) ?>
                            <?php
                            if ($this->Form->isFieldError('custname')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('custname') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label"><span class="require">*</span>Order Number:</label>
                        <div class="col-sm-7">
                            <?= $this->Form->text('OrderNo', ['class' => $this->Form->isFieldError('OrderNo') ? 'form-control is-invalid' : 'form-control']) ?>
                            <?php
                            if ($this->Form->isFieldError('OrderNo')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('OrderNo') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label"><span class="require">*</span>Date customer first made you aware of the problem:</label>
                        <div class="col-sm-7">
                            <?= $this->Form->text('FirstAwareD', ['id' => 'FirstAwareD', 'class' => $this->Form->isFieldError('FirstAwareD') ? 'form-control is-invalid' : 'form-control']) ?>
                            <?php
                            if ($this->Form->isFieldError('FirstAwareD')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('FirstAwareD') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">Please email video with sound if the item is making noises which are the problem. MAX FILE SIZE 3mb</label>
                        <div class="col-sm-7">
                            <?= $this->Form->file('video', ['class' => $this->Form->isFieldError('video') ? 'form-control-file is-invalid' : 'form-control-file']) ?>
                            <?php
                            if ($this->Form->isFieldError('video')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('video') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">Please let us know what you feel the PossibleSolution to the problem is:</label>
                        <div class="col-sm-7">
                            <?= $this->Form->textarea('PossibleSolution', ['rows' => '6', 'class' => $this->Form->isFieldError('PossibleSolution') ? 'form-control is-invalid' : 'form-control']) ?>
                            <?php
                            if ($this->Form->isFieldError('PossibleSolution')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('PossibleSolution') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">What action have you already taken about this problem:</label>
                        <div class="col-sm-7">
                            <?= $this->Form->textarea('ActionTaken', ['rows' => '6', 'class' => $this->Form->isFieldError('ActionTaken') ? 'form-control is-invalid' : 'form-control']) ?>
                            <?php
                            if ($this->Form->isFieldError('ActionTaken')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('ActionTaken') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">What date was this visit/ action:</label>
                        <div class="col-sm-7">
                             <?= $this->Form->text('actiondateD', ['id' => 'actiondateD', 'class' => $this->Form->isFieldError('actiondateD') ? 'form-control is-invalid' : 'form-control']) ?>
                            <?php
                            if ($this->Form->isFieldError('actiondateD')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('actiondateD') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">Any other comments: </label>
                        <div class="col-sm-7">
                            <?= $this->Form->textarea('anycomments', ['rows' => '6', 'class' => $this->Form->isFieldError('anycomments') ? 'form-control is-invalid' : 'form-control']) ?>
                            <?php
                            if ($this->Form->isFieldError('anycomments')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('anycomments') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
                    <div class="form-group row">
                        <div class="col-sm-6 text-left">
                            <p style="font-size:12px;"><span class="require">*</span> Required fields</p>
                        </div>
                        <div class="col-sm-6 text-right">
                            <?= $this->Form->button(__('Submit'), ['class' => 'btn btn-default']) ?>
                        </div>
                    </div>
                </div>
                <?= $this->Form->end() ?>
            </div>
        </div>
    </div>
</div>