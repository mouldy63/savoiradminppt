<?php

use Cake\Routing\Router; ?>
<?php echo $this->Html->css('bootstrap.min.css', array('inline' => false)); ?>
<?php echo $this->Html->css('fabricStatus.css', array('inline' => false)); ?>
<?php echo $this->Html->css('userAdmin.css', array('inline' => false)); ?>
<?php echo $this->Html->css('style.css', array('inline' => false)); ?>
<?php echo $this->Html->css('jquery-ui.min.css', array('inline' => false)); ?>
<?php //echo $this->Html->script('popper.min.js', array('inline' => false)); ?>
<?php echo $this->Html->script('bootstrap.min.js', array('inline' => false)); ?>
<?php echo $this->Html->script('jquery-ui.min.js', array('inline' => false)); ?>

<script>

    $(function(){
        var etadate = $(".eta-date,#collection-date");
        var year = new Date().getFullYear();
        year = year + 10;
        etadate.datepicker({
            changeMonth: true,
            yearRange: "1997:"+year,
            changeYear: true
        });
        etadate.datepicker( "option", "dateFormat", "dd/mm/yy" );
    })
</script>

<div class="container">
    <div class="bg-grey">
        <div class="row">
            <form class="form-custom pl-3 pr-3 pb-3 font-15" method="post" action="<?=Router::url('/', true)?>/sales-detail/create-order-submit">
                <div class="col-sm-12 col-xs-12 col-md-4 col-lg-4 col-xl-4 p-0">
                    <div class=" blok-strip">
                        <h5 class="ml-0 mr-0 mt-3">ADD NEW COLLECTION</h5>
                        <div class="form-group">
                            <label for="">Collection Date:</label>
                            <div class="line-blok">
                                <input type="text" class="form-control" name="collection-date" id="collection-date" placeholder="" style="width:100px;"  />
                                <span class="note" style="cursor:pointer;" onclick="$(this).prev().trigger('focus')">Choose date</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <select name="shipper_address_id" class="form-control" style="width:200px;">
                                <option>Shipper address</option>
                                <?php foreach ($shipper_addresses as $address): ?>
                                    <option value="<?= $address['shipper_ADDRESS_ID'] ?>"><?= $address["shipperName"] ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="">Transport Mode:</label>
                            <input name="transport_mode" type="text" class="form-control" id="" placeholder="" style="width:200px;"  />
                        </div>
                        <div class="form-group">
                            <label for="">Container Ref:</label>
                            <input name="container_ref" type="text" class="form-control" id="" placeholder="" style="width:200px;"  />
                        </div>
                    </div>
                </div>
                <div class="col-sm-12 col-xs-12 col-md-5 col-lg-5 col-xl-5 p-0" style="margin-left:-3px;">
                    <div class=" blok-strip">
                        <p class="my-3 mx-0">Choose which showroom can use this Collection</p>
                        <?php foreach ($locations as $location): ?>
                            <div class="form-group">
                                <div class="line-blok">
                                    <label for="" class="m-0">ETA Date:&nbsp;</label>
                                    <input name="eta_date[]" type="text" class="form-control eta-date" id="" placeholder="" style="width:80px;"  />
                                    <span class="note" style="cursor:pointer;" onclick="$(this).prev().trigger('focus')">Choose date</span>
                                    <div class="checkbox">
                                        <label class="m-0">
                                            <input name="location_ids[]" type="checkbox" id="" value="<?= $location["idlocation"]?>" aria-label=""><?= $location["adminheading"] ?>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        <?php endforeach; ?>

                        <!-- /form-group -->
                        <div class="form-group">
                            <button type="submit" name="addcollection" value="Add Collection" class="btn btn-default">Add Collection</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
