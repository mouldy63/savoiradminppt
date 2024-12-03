<?php use Cake\Routing\Router; ?>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#mattcut" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true
});
$( "#mattcut" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#mattmachined" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true
});
$( "#mattmachined" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#springunitdate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true
});
$( "#springunitdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#mattfinished" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true
});
$( "#mattfinished" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});

</script>
<form name="mattressform" id="mattressform" method="post" action="/php/Production/saveMattress" style="padding:5px;">
<input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />

<div id="mattress_div">
	
<div class="row smallproductiontext">
    <div class="col-sm-3" style="min-width:450px">
        <div class="row">
            <div class="col-3"><strong>Made At:</strong></div>
            <div class="col-3 bgwhite">
            <select name="mattressmadeat" id="mattressmadeat" onChange="javascript: defaultAreaProductionDates(); ">
            <option value="n">Not Allocated</option>
            <option value="1" <?php if ($mattMadeat=='Cardiff') echo 'selected' ?> >Cardiff</option>
            <option value="2" <?php if ($mattMadeat=='London') echo 'selected' ?> >London</option>
            </select>
            </div>
            <div class="col-3"></div>
            <div class="col-3 bgwhite"></div>
        </div>
        <div class="row">
            <div class="col-3"><strong>Model:</strong></div>
            <div class="col-3 bgwhite">
            <?=$purchase['savoirmodel']?>
            </div>
            <div class="col-3"><strong>Type:</strong></div>
            <div class="col-3 bgwhite"><?=$purchase['mattresstype']?></div>
        </div>
        <div class="row">
            <div class="col-3"><strong>Left&nbsp;Support:</strong></div>
            <div class="col-3 bgwhite">
            <?=$purchase['leftsupport']?>
            </div>
            <div class="col-3"><strong>Right&nbsp;Support:</strong></div>
            <div class="col-3 bgwhite"><?=$purchase['rightsupport']?></div>
        </div>
        <div class="row">
            <div class="col-3"><strong>Ticking:</strong></div>
            <div class="col-3 bgwhite">
            <?=$purchase['tickingoptions']?>
            </div>
            <div class="col-3"><strong>Vent Pos:</strong></div>
            <div class="col-3 bgwhite"><?=$purchase['ventposition']?></div>
        </div>
        <?php if ($mattwidthdivided != '' && $mattlengthdivided != '' && $zippedpair=='y') { ?>
        <div class="row">
            <div class="col-3"><strong>Matt 1 Width:</strong></div>
            <div class="col-3 bgwhite">
            <?=$mattwidthdivided?>
            </div>
            <div class="col-3"><strong>Matt 1 Length:</strong></div>
            <div class="col-3 bgwhite"><?=$mattlengthdivided?></div>
        </div>
        <div class="row">
            <div class="col-3"><strong><?php if ($mattwidthdivided != '') { ?>Matt 2 Width:<?php } ?></strong></div>
            <div class="col-3 bgwhite"><?= $mattwidthdivided ?></div>
            <div class="col-3"><strong><?php if ($mattlengthdivided != '') { ?>Matt 2 Length:<?php } ?></strong></div>
            <div class="col-3 bgwhite"><?= $mattlengthdivided ?></div>
        </div>
        <?php } ?>
        <?php if ($zippedpair == 'n') { ?>
        <div class="row">
            <div class="col-3"><strong>Matt Width:</strong></div>
            <div class="col-3 bgwhite"><?= $mattwidthdivided ?></div>
            <div class="col-3"><strong>Matt Length:</strong></div>
            <div class="col-3 bgwhite"><?= $mattlengthdivided ?></div>
        </div>
        <?php } ?>
        <?php  
        if ($prodsizes['Matt1Width'] != '' || $prodsizes['Matt1Length'] != '') { ?>
        <div class="row">
            <div class="col-3"><strong><?php if ($prodsizes['Matt1Width'] != '') { ?>Matt 1 Width:<?php } ?></strong></div>
            <div class="col-3 bgwhite"><input name="matt1width" type="text" value="<?= $prodsizes['Matt1Width'] ?>" size="7"> cm</div>
            <div class="col-3"><strong><?php if ($prodsizes['Matt1Length'] != '') { ?>Matt 1 Length:<?php } ?></strong></div>
            <div class="col-3 bgwhite"><input name="matt1length" type="text" value="<?= $prodsizes['Matt1Length'] ?>" size="7"> cm</div>
        </div>
        <?php } 
        if ($prodsizes['Matt2Width'] != '' || $prodsizes['Matt2Length'] != '') { ?>
        <div class="row">
            <div class="col-3"><strong><?php if ($prodsizes['Matt2Width'] != '') { ?>Matt 2 Width:<?php } ?></strong></div>
            <div class="col-3 bgwhite"><input name="matt2width" type="text" value="<?= $prodsizes['Matt2Width'] ?>" size="7"> cm</div>
            <div class="col-3"><strong><?php if ($prodsizes['Matt2Length'] != '') { ?>Matt 2 Length:<?php } ?></strong></div>
            <div class="col-3 bgwhite"><input name="matt2length" type="text" value="<?= $prodsizes['Matt2Length'] ?>" size="7"> cm</div>
        </div>
        <?php } ?>
        
        <div class="row">
            <div class="col-3"><strong>Vent Finish:</strong></div>
            <div class="col-3 bgwhite"><?php if ($purchase['ventfinish'] != 'n') echo $purchase['ventfinish'] ?></div>
            <div class="col-3"><strong>Price</strong></div>
            <div class="col-3 bgwhite"><?=$this->OrderForm->getCurrencySymbol()?><?= $purchase['mattressprice'] ?></div>
        </div>
       <?php if ($purchase['mattressinstructions'] != '') { ?>
        <div class="row">
            <div class="col-12 box"><strong>Instructions: </strong><?= $purchase['mattressinstructions'] ?></div>
        </div>
        <?php } 
        ?>

        <?php if (count($springs) > 0) { ?>
        <div class="row">
            <div class="col-12 box"><strong>Spring Unit Row Count: </strong><br>
                Left Row = <?= $springs[0]['row_number'] ?><br>
                Right Row = <?= $springs[0]['row_number_right'] ?>
            </div>
        </div>
        <?php } ?>
        
       
    </div>
    <div class="col-sm-2">
        
    </div>
    <div class="col-sm-2 prod">
        <strong>Matt Case Cut</strong><br>
        <input name="mattcut" type="text" id="mattcut" value="<?=$mattcut?>" size="10"> <a href="javascript:clearmattcut();">X</a>
        <br><hr class="hyphen-line"><br>
        <strong>Matt Case Machined</strong><br>
        <input name="mattmachined" type="text" id="mattmachined" value="<?=$mattmachined?>" size="10" readonly> <a href="javascript:clearmattmachined();">X</a> 
        <br><hr class="hyphen-line"><br>
        <strong>Mattress Ticking Used</strong>
        <label for="tickingbatchno"></label>
        <input name="tickingbatchno" type="text" id="tickingbatchno" value="<?=$tickingbatchno?>" size="20">
        <br><hr class="hyphen-line"><br>
        <strong>Spring Unit Complete Date</strong>
        <label for="springunitdate"></label>
        <input name="springunitdate" type="text" id="springunitdate" value="<?=$springunitdate?>" size="10" readonly> <a href="javascript:clearspringunitdate();">X</a>
        <br><hr class="hyphen-line"><br>
        <strong>Made By:</strong><br>
        <select name = "mattmadeby" id = "mattmadeby" class="form-select">
        <option value="n"></option>
         <?php foreach ($madebyUsers as $User): 
                $slcted=''; 
                if ($madeby== $User['user_id']) {
                    $slcted='selected';
                } 
              ?>
              <option value="<?= $User['user_id'] ?>" <?=$slcted ?> ><?= $User['name'] ?> </option>  
              <?php endforeach; ?> 
         </select>  
         <br><hr class="hyphen-line"><br>
         <?php if ($jobflagMatt) { ?>
            <strong>Job Flag: </strong><?=$jobflagMatt?>
            <br><hr class="hyphen-line"><br>
         <?php } ?>
         <strong>Finished:<br>
         <input name="mattfinished" type="text" id="mattfinished" value="<?=$mattfinished?>" size="10" readonly onChange="calendarBlurHandler(mattfinished); checkMattFinishedStatus();"> <a href="javascript:clearmattfinished();checkFinishedDateCompleted(null)">X</a> </strong>
    </div>
    <div class="col-sm-2 logistics">
    <strong>Matt Planned Prod Date</strong><br>
    <input name="mattbcwexpected" type="text" id="mattbcwexpected" value="<?=$mattbcwexpected?>" size="10" onChange="calendarBlurHandler(mattbcwexpected)" readonly> <a href="javascript:clearmattbcwexpected();">X</a>
        <br><hr class="hyphen-line"><br>
    </div>
</div>



    
</div> <!-- mattress_div end -->
<input type = "submit" name = "submit" value = "Save Mattress" id = "submit" class = "button" />
</form>

<script>
    var mattressFieldChanged = false;
    function mattressInit() {
        overrideMattressSubmit();
        disableMattressComponentSections(<?=$isComponentLocked?>, '<?=$lockColour?>');
    }

    function disableMattressComponentSections(disable, lockColour) {
        if (disable) {
            $('#mattressrequired_y').attr('disabled', true);
            $('#mattressrequired_n').attr('disabled', true);
            $('#mattress_div :input').attr('disabled', true);
            $('#mattress_div :input').css('color', lockColour);
        }
    }
    
    function clearmattcut() {
	    $('#mattcut').val('');
    }
    function clearmattcut() {
	    $('#mattmachined').val('');
    }
    function clearmattfinished() {
	    $('#mattfinished').val('');
    }
    function clearmattbcwexpected() {
	    $('#mattbcwexpected').val('');
    }

    
    function checkAllMattDatesCompleted() {
        var finishDate = $("#mattfinished").val();
        if (finishDate != "") {
            if ($("#mattcut").val() == "") {
                $('#mattcut').val(finishDate);
            }

            if ($("#mattmachined").val() == "") {
                $('#mattmachined').val(finishDate);
            }

            if ($("#springunitdate").val() == "") {
                $('#springunitdate').val(finishDate);
            }
        }
    }
    function checkFinishedDateCompleted(origmattstatus) {
        var finDate = $("#mattfinished").val();
        var mattstatus = $("#mattressqc").val();
        if ((mattstatus == "50" || mattstatus == "60" || mattstatus == "70")
                && finDate == "") {
            alert("Please enter Mattress Finished Date and then Order Status can be changed");
            $("#mattressqc option[value='" + origmattstatus + "']").attr(
                    'selected', 'selected');
            $('#mattfinished').focus();
        }

    }
    
    function overrideMattressSubmit() { 
        $('#mattressform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Production/saveMattress',
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
        mattressFieldChanged = false;
    }

    function submitMattressForm() {
        $('#mattressform').submit();
    }
    
</script>
