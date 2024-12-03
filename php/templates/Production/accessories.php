<?php use Cake\Routing\Router; ?>
<div class="container" style="padding-left:20px;">
<form name="accessoriesform" id="accessoriesform" method="post" action="/php/Order/saveAccessories">
<input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />


<?php 
for($i=1; $i<=21; $i++) {
    $desc='';
    $design='';
    $colour='';
    $size='';
    $unitprice='';
    $qty='';
    $wholesaleprice='';
    $orderaccessoryid='';
    if (count($accessories) >= $i) {
        $currentaccessory=$accessories[$i-1];
        $desc=htmlspecialchars($currentaccessory['description'], ENT_QUOTES, 'UTF-8');
        $design=htmlspecialchars($currentaccessory['design'], ENT_QUOTES, 'UTF-8');
        $colour=htmlspecialchars($currentaccessory['colour'], ENT_QUOTES, 'UTF-8');
        $size=htmlspecialchars($currentaccessory['size'], ENT_QUOTES, 'UTF-8');
        $unitprice=$currentaccessory['unitprice'];
        $qty=$currentaccessory['qty'];
        $wholesaleprice=$currentaccessory['wholesalePrice'];
        $orderaccessoryid=$currentaccessory['orderaccessory_id'];
    }
?>
<div id="accessories_div">
    <div class="form-row" style="margin-bottom:-6px;" name=acc_row<?= $i ?> id=acc_row<?= $i ?>>
    <input type="hidden" name="accid<?= $i ?>" id="accid<?= $i ?>" value=<?=$orderaccessoryid?>>
        <div class="form-group col-sm-3">
        <input name = "acc_desc<?= $i ?>" type = "text" id = "acc_desc<?= $i ?>" class="form-control accessoriesfield" data-toggle="tooltip" data-placement="top" title="Accessory Item Desc No. <?= $i ?>"  value="<?=$desc?>" placeholder="Item Description No. <?= $i ?>">
        </div>
        <div class="form-group col-sm-3">
            <input name = "acc_design<?= $i ?>" type = "text" id = "acc_design<?= $i ?>" class="form-control accessoriesfield"  data-toggle="tooltip" data-placement="top" title="Item <?= $i ?> Design & Detail" value="<?=$design?>" placeholder="Design & Detail">
        </div>
        <div class="form-group col-sm-2">
            <input name = "acc_colour<?= $i ?>" type = "text" id = "acc_colour<?= $i ?>" class="form-control accessoriesfield"  data-toggle="tooltip" data-placement="top" title="Item <?= $i ?> Colour" value="<?=$colour?>" placeholder="Colour">
        </div>
        <div class="form-group col-sm-1">
            <input name = "acc_size<?= $i ?>" type = "text" id = "acc_size<?= $i ?>" class="form-control accessoriesfield"  data-toggle="tooltip" data-placement="top" title="Item <?= $i ?> Size" value="<?=$size?>" placeholder="Size">
        </div>
        <div class="form-group col-sm-1 xview">
            <input name = "acc_unitprice<?= $i ?>" type = "text" id = "acc_unitprice<?= $i ?>" class="form-control accessoriesfield"  data-toggle="tooltip" data-placement="top" title="Item <?= $i ?> Unit Price" value="<?=$unitprice?>" placeholder="Unit Price" >
        </div>
        <div class="form-group col-sm-1">
        <select name = "acc_qty<?= $i ?>" id = "acc_qty<?= $i ?>" class="form-control accessoriesfield" data-toggle="tooltip" data-placement="top" title="Item <?= $i ?> Qty">
        <option value="n">Qty</option> 
            <?php
            for($j=0; $j<=21; $j++)
            {
                $slcted='';
                if ($qty==$j) {
                    $slcted='selected';
                }
            ?> 
                <option value="<?= $j ?>" <?=$slcted ?>><?= $j ?> </option>  
            <?php } ?> 
            </select>
            </div> 
        <div class="form-group col-sm-1 hideAccDel">    
            <?php if ($orderaccessoryid != '') { ?>
                Delete&nbsp;<input type = "checkbox" class="accessoriesfield" name = "acc_delete<?= $i ?>" id = "acc_delete<?= $i ?>"  />
            <?php }  ?>
        </div>
        <div class="form-group col-sm-1 showWholesale xview">
            <input name = "acc_wholesalePrice<?= $i ?>" type = "text" id = "acc_wholesalePrice<?= $i ?>" class="form-control accessoriesfield"  data-toggle="tooltip" data-placement="top" title="Item <?= $i ?> Wholesale Price" value="<?=$wholesaleprice?>" placeholder="Unit Price" >
        </div>
    </div>
 <?php } ?>       

 <div class="form-row xview">

    <p style="padding-left:5px;">Accessories total:&nbsp;<?=$this->OrderForm->getCurrencySymbol()?><span id = "accessories_total"></span></p>

</div>
   

<!-- <input type = "submit" name = "submit" value = "Save Accessories" id = "submit" class = "button" /> -->
</div><!-- container end -->
</div> <!-- accessories_div end -->
</form>

<script>
    $(function () {
        $('[data-toggle="tooltip"]').tooltip()
    })
    var accessoriesFieldChanged = false;
    function accessoriesInit() {
        $('.showWholesale').hide();
        calcAccessoriesTotal();
        // accessories stuff
        for (var i = 1; i < 21; i++) {
            $('#acc_unitprice'+i).blur(function() {
            calcAccessoriesTotal();
            showNextAccessoriesRow();
            });
            $('#acc_qty'+i).change(function() {
                calcAccessoriesTotal();
            });
            $('#acc_desc'+i).change(function() {
                showNextAccessoriesRow();
            });
        }
        overrideAccessoriesSubmit();
        
        $(".accessoriesfield").on("change", function() {
            accessoriesFieldChanged = true;
        });
        $(".accessoriesfield").on("focus", function() {
            submitComponentForm(9);
        });
        showHideWholesale();
        disableAccessoryComponentSections(<?=$isComponentLocked?>, '<?=$lockColour?>');
    }

    showNextAccessoriesRow();

    function showNextAccessoriesRow() {
        for (var i = 0; i < 21; i++) {
        var ii = i+1;
            if ($('#acc_desc'+i).val() == "") {
            $('#acc_row'+ii).hide();
            } else {
            $('#acc_row'+ii).show();
            }
        }
    }

    function calcAccessoriesTotal() {
        var total = 0.0;
        for (var i = 1; i < 21; i++) {
            if ($('#acc_unitprice'+i).val() && $('#acc_qty'+i).val()) {
                total += $('#acc_unitprice'+i).val() * $('#acc_qty'+i).val() * 1.0;
            }
        }
        $('#accessories_total').html(total.toFixed(2));
    }

    function disableAccessoryComponentSections(disable, lockColour) {
        if (disable) {
            $('#accessoriesrequired_y').attr('disabled', true);
            $('#accessoriesrequired_n').attr('disabled', true);
            $('#accessories_div :input').attr('disabled', true);
            $('#accessories_div :input').css('color', lockColour);
            $('.showWholesale :input').attr('disabled', false);
        }
    }

    function overrideAccessoriesSubmit() { 
        $('#accessoriesform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Order/saveAccessories',
                data: formData,
                success: function(compsToReload) {
                    reloadComponents(compsToReload);
                },
                error: function(xhr, status, error) {
                    console.error(error);
                },
                complete: function() {
                    $('#loading-spinner').hide();
                }
            });
        });
        accessoriesFieldChanged = false;
    }

    function submitAccessoriesForm() {
        $('#accessoriesform').submit();
    }   
    
</script>
