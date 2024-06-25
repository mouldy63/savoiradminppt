<?php use Cake\Routing\Router; ?>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#firstaware" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true

});
$( "#firstaware" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#DateDelivered" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true
});
$( "#DateDelivered" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#actiondate" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true
});
$( "#actiondate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});
</script>

<div class="container minthirtyfive-top-margin">
    <div class="bg-grey">
        <div class="row">
            <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 col-xl-12">
                <h3 class="title">Customer Service form - Customer Service Date <?= date('d/m/Y') ?></h3>
                <?= $this->Form->create($customerservice, ['type' => 'file', 'class' => 'form-custom']) ?>
                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6">
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">Customer Service Number</label>
                        <div class="col-sm-7">
                            <?= $this->Form->text('CSNumber', ['class' => $this->Form->isFieldError('CSNumber') ? 'form-control is-invalid' : $this->Form->isFieldError('CSNumber') ? 'form-control is-invalid' : 'form-control']) ?>
                            <?php
                            if ($this->Form->isFieldError('CSNumber')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('CSNumber') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">Form Completed by:</label>
                        <div class="col-sm-7">
                            <?= $this->Form->text('CompletedBy', ['readonly' => 'readonly', 'class' => $this->Form->isFieldError('CompletedBy') ? 'form-control-plaintext is-invalid' : 'form-control-plaintext']) ?>
                            <?php
                            if ($this->Form->isFieldError('CompletedBy')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('CompletedBy') . '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="" class="col-sm-5 col-form-label">Date item delivered to Customer</label>
                        <div class="col-sm-7">
                            <?= $this->Form->text('DateDelivered', ['id' => $this->Form->isFieldError('DateDelivered'), 'class' => $this->Form->isFieldError('DateDelivered') ? 'form-control is-invalid' : 'form-control']) ?>
                            <?php
                            if ($this->Form->isFieldError('DateDelivered')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('DateDelivered') . '</div>';
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
                            <?php
                            echo $this->Form->date('FirstAwareDate', [
                                'maxYear' => date('Y'),
                                'minYear' => 1997,
                                'class' => $this->Form->isFieldError('FirstAwareDate') ? 'form-control is-invalid' : 'form-control'
                            ]);
                            if ($this->Form->isFieldError('FirstAwareDate')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('FirstAwareDate') . '</div>';
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
                            <?php
                            echo $this->Form->date('VisitActionDate', [
                                'maxYear' => date('Y'),
                                'minYear' => 1997,
                                'class' => $this->Form->isFieldError('VisitActionDate') ? 'form-control is-invalid' : 'form-control'
                            ]);
                            if ($this->Form->isFieldError('VisitActionDate')) {
                                echo '<div class="invalid-feedback">' . $this->Form->error('VisitActionDate') . '</div>';
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