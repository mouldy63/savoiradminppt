<?php use Cake\Routing\Router; ?>
<style>
.AccordionPanel {float: left;}
.AccordionPanelTab {margin-left:5px; float:left;}
.Accordclear {clear:both;}
.stickleft {float:left;left:0px;}
.AccordionPanel table {margin-left:30px; background-color:#d4d4d4;}


            .rowlineheight tr
            {
                line-height: 0px;
            }

            .rowlineheight table
            {
                float: left;
            }

            .floatleft
            {
                float: left;
            }

            .lineclear
            {
                clear: both;
                line-height: 0px;
            }

            input.myClass
            {
                color: #000000;
                background-color: transparent;
                border: 0px solid;
                text-align: left;
            }
			.readonly {color:#999;}
			.bordergris {border:1px; border-color:#333333; border-style:solid; padding:5px; margin-top:5px;}
			
        </style>
<?php
	$leadTimes = $this->OrderFormProduction->getLeadTimes();
	
	$deldate = '';
	if (!empty($deliverydate)) {
		$deldate = substr($deldate, 0, 10);
	} else {
		$tempdate = strtotime('+'. $leadTimes['longest'] . ' week', time());
		$deldate = date("Y-m-d", $tempdate);
	}
	
	$approxDateOptions = $this->OrderFormProduction->makeApproxDateOptions($deldate);
    $currentUserId = $this->Security->retrieveUserId();
?>

<script>
$(function() {
var year = new Date().getFullYear();
$( "#ackdate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true
});
$( "#ackdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );

$( "#productiondate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true
});
$( "#productiondate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );

$( "#bookeddeldate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true
});
$( "#bookeddeldate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );


$( "#winvoicedate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true
});
$( "#winvoicedate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );

$( "#ordernote_followupdate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true
});
$( "#ordernote_followupdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
<?php if ($ordernotes != '') { 
    foreach ($ordernotes as $ordernote):?>
    $( "#Note_followupdate<?=($ordernote['ordernote_id'])?>" ).datepicker({
    changeMonth: true,
    yearRange: "-21:+0",
    changeYear: true 
    });
    $( "#Note_followupdate<?=($ordernote['ordernote_id'])?>").datepicker( "option", "dateFormat", "dd/mm/yy" );
    <?php endforeach; 
    }
    ?>


});
</script>

<div id="brochureform" class="brochure">
<?php 
$orderwording=' Order';
if ($quote=='y') {
    $orderwording=' Quote';
}
?>
<form name="partoneform" id="partoneform" method="post" action="/php/Order/addPartOne">	
    <div class="row">
        <div class="col-sm-12">
         <h1><a href="/php/editcustomer?val=<?=$contact_no?>#orders">GO TO CUSTOMER DETAILS</a></h1>
            <div>
                <a href="javascript:void(0)" class="stickleft" onclick="loadOtherCustomerOrders(<?=$pn?>, <?=$contact_no?>, 'otherCustomerOrders', 'otherOrdersImg')">&nbsp;&nbsp;<img id="otherOrdersImg" src="/php/img/plus.gif"/>&nbsp;Other Current Orders</a>
            </div>
         <div id="otherCustomerOrders" style="display: none;"></div>
        </div>
    </div>
   <?php if ($pn > 0) { ?>
    <div class="row">
        <div class="col-sm-4"><br>
        <?php if ($isAdministrator=='y') { ?>
            <p>Order Completed (tick if yes) <input name = "complete" type = "checkbox" id = "complete" <?php if ($purchase['completedorders']=='y') echo 'checked'; ?> value = "y" class="partonefield" ></p>
        <?php } ?>
        </div>
        <div class="col-sm-8">
            <?php if ($quote!='y') { ?>
        <p><?php  if ($isAdministrator=='y' && $wholesaleenabled=='y') { ?>
            <div align="right" id="wholesaleswitch">WHOLESALE INVOICE : ON
			
            <input name="wholesaleinv" id="wholesaleinv_y" type="radio" value="y" onClick="showHideWholesale();" /> OFF<input name="wholesaleinv" id="wholesaleinv_n" type="radio" value="n" checked onClick="showHideWholesale();" />&nbsp;&nbsp;
        </div>
        <?php } ?>
        </p>
         <p align='right'>
            <a href="/orderdetails.asp?pn=<?=$purchase['PURCHASE_No'] ?>">PRODUCTION</a>&nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="/php/balancerequest.pdf?pn=<?=$purchase['PURCHASE_No'] ?>">BALANCE REQUEST LETTER</a>&nbsp;&nbsp;|&nbsp;&nbsp;
            <a href="/php/PrintPDF.pdf?val=<?=$purchase['PURCHASE_No'] ?>">PRINT PDF</a>&nbsp;&nbsp;|&nbsp;&nbsp;
            <input type="button" class="duplicate-button" id="duplicate-button" value="Duplicate Order" />
            
         </p>
         <?php } ?>
        
      </div>
   </div>
   <?php } 
   
   ?>

<h1 style="margin-top:-10px;"><br><?=isset($purchase['ORDER_NUMBER'])?'Edit':'Add'?> <?=$orderwording?>&nbsp;<?=isset($ordercopiedtotemptables)?'***':''?>
<?php if ($ordersource != '') {
	echo $ordersource . $orderwording;
} ?>
 | Contact: <?php echo $this->Security->retrieveUserName(); ?></h1>
<p></p>
	      
	<input type="hidden" name="contact" id="contact" value="<?php echo $this->Security->retrieveUserName(); ?>" />
    <input type="hidden" name="contact_no" id="contact_no" value="<?=$contactdetails['CONTACT_NO'] ?>" />
    <input type="hidden" name="ordersource" id="ordersource" value="<?=$ordersource ?>" />
    <input type="hidden" name="overseas" id="overseas" value="<?=$overseas ?>" />
    <input type="hidden" name="quote" id="quote" value="<?=$quote ?>" />
    <input type="hidden" name="orderdate" id="quorderdateote" value="<?=$orderdate ?>" />
    <?php if (isset($purchase['PURCHASE_No'])) { ?>
        <input type="hidden" name="pn" id="pn" value="<?=$purchase['PURCHASE_No'] ?>" />
        <input type="hidden" name="stamp" id="stamp" value="<?=$purchase['stamp'] ?>" />
    <?php  } ?>

<div class="container">
	<div class="row">
        <div class="col-sm-4">
                
            <div class="col-md-12">    
                <p class="ordertxt1"><?=$orderwording?> No: <?php if (isset($purchase['ORDER_NUMBER'])) {
                    echo $purchase['ORDER_NUMBER'];
                } else {
                    echo 'TBA';
                } ?></p>
                <p class="ordertxt1" >Date: <input type="text" name="orderdate" id="orderdate" value="<?=$orderdate ?>" readonly class="partonefield" /></p>
                <p class="ordertxt1" >Customer Ref: <input type="text" name="customerref" id="customerref" value="<?=$customerreference ?>" class="partonefield" /></p>
                <p class="ordertxt1" >Client's Title: <input type="text" name="title" id="title" value="<?=$contactdetails['title'] ?>" readonly class="partonefield" /></p>
                <p class="ordertxt1" >First Name: <input type="text" name="first" id="first" value="<?=$contactdetails['first'] ?>" readonly class="partonefield" /></p>
                <p class="ordertxt1" >Surname: <input type="text" name="surname" id="surname" value="<?=$contactdetails['surname'] ?>" readonly class="partonefield" /></p>
                <p class="ordertxt1" >Tel Home: <input type="text" name="telhome" id="telhome" value="<?=$contactdetails['tel'] ?>" readonly class="partonefield" /></p>
                <p class="ordertxt1" >Tel Work: <input type="text" name="telwork" id="telwork" value="<?=$contactdetails['telwork'] ?>" readonly class="partonefield" /></p>
                <p class="ordertxt1" >Mobile: <input type="text" name="mobile" id="mobile" value="<?=$contactdetails['mobile'] ?>" readonly class="partonefield" /></p>
                <p class="ordertxt1" >Email Address: <input type="text" name="email" id="email" value="<?=$contactdetails['EMAIL_ADDRESS'] ?>" readonly class="partonefield" /></p>
                <p class="ordertxt1" ><?=$vatWording ?>(%): 
                <select name="vatrates" id="vatrates" style="width:138px;" class="partonefield xview">
                    <?php foreach ($vatrates as $row): ?>               
                    <option value="<?php echo $row['vatrate'] ?>" <?= $row['vatrate']==$partOneFormData['vatrate'] ? 'selected':'' ?> ><?php echo $row['vatrate'] ?> </option>
                    <?php endforeach; ?>
                </select>
                </p>
                <p class="ordertxt1" >Wrap Type: 
                <select name="wrappingtype" id="wrappingtype" style="width:138px;" class="partonefield">
                    <?php foreach ($wrappingtypes as $row): ?>               
                    <option value="<?php echo $row['WrappingID'] ?>" <?= $row['WrappingID']==$partOneFormData['wrappingtype'] ? 'selected':'' ?>><?php echo $row['Wrap']  ?> </option>
                    <?php endforeach; ?>
                </select></p>
                <p class="ordertxt1" >Select Order Type: 
                <select name="ordertype" id="ordertype" style="width:138px;" class="partonefield">
                    <?php foreach ($ordertype as $row): ?>               
                    <option value="<?php echo $row['ordertypeID'] ?>" <?= $row['ordertypeID']==$partOneFormData['ordertype'] ? 'selected':'' ?>><?php echo $row['ordertype'] ?> </option>
                    <?php endforeach; ?>
                </select></p>
                
                
            </div>
        </div>    
        <div class="col-sm-4">
            <div class="col-md-12">    
                <h5 class="card-title">Invoice Address</h5>
                <p class="ordertxt1" >Line 1: <input type="text" name="add1" id="add1" value="<?=$contactdetails['street1'] ?>" class="partonefield" /></p>
                <p class="ordertxt1" >Line 2: <input type="text" name="add2" id="add2" value="<?=$contactdetails['street2'] ?>" class="partonefield" /></p>
                <p class="ordertxt1" >Line 3: <input type="text" name="add3" id="add3" value="<?=$contactdetails['street3'] ?>" class="partonefield" /></p>
                <p class="ordertxt1" >Town: <input type="text" name="town" id="town" value="<?=$contactdetails['town'] ?>" class="partonefield" /></p>
                <p class="ordertxt1" >County: <input type="text" name="county" id="county" value="<?=$contactdetails['county'] ?>" class="partonefield" /></p>
                <p class="ordertxt1" >Postcode: <input type="text" name="postcode" id="postcode" value="<?=$contactdetails['postcode'] ?>" class="partonefield" maxlength="20" /></p>
                <p class="ordertxt1" >Country: 
                <select name="country" id="country" style="width:138px;" class="partonefield">
                    <?php foreach ($countrylist as $row): 
                        $slcted='';
                        if ($contactdetails['country']==$row['country']) {
                            $slcted='selected';

                        }?>               
                    <option value="<?php echo $row['country'] ?>" <?=$slcted ?> ><?php echo $row['country'] ?> </option>
                    <?php endforeach; ?>
                </select></p>
                <p class="ordertxt1" >Company: <input type="text" name="company" id="company" value="<?=$contactdetails['company'] ?>" class="partonefield" /></p>
                <?php 
                if ($userregion == 1 && $overseas == '') { ?>
                <p class="ordertxt1">Approx. Delivery Date: <select id = "deldate" name = "deldate" class="partonefield">
                    <?php foreach (array_keys($approxDateOptions['vals']) as $datekey) { 
                        $select='';
                        if ($datekey == $approxDateOptions['def']) {
                            $select='selected';
                        }
                            ?>
                        <option value="<?php echo $datekey ?>" <?= $select ?>><?php echo $approxDateOptions['vals'][$datekey] ?> </option>
                        <?php  } ?>

                </select></p>
                <?php } else { ?>
                    <p class="ordertxt1" >Ex. Works Date:  <select name="exworks" id="exworks" class="partonefield">
                    <?php foreach ($plannedexports as $row): ?>               
                    <option value="<?php echo $row['exportCollshowroomsID'] ?>"><?php echo $row['location'].", ".$row['CollectionDate']  ?> </option>
                    <?php endforeach; ?>
                </select></p>
                <?php } ?>
            </div>
        </div>
        <div class="col-sm-4 gx-5" >
            <div class="col-md-12">    
                <h5 class="card-title">Delivery Address (<a href="cleardeliveryaddress();">Clear delivery address X</a>)</h5>
                <p class="ordertxt1" >Line 1: <input type="text" name="deladd1" id="deladd1" value="<?=$partOneFormData['deladd1'] ?>" class="partonefield" /></p>
                <p class="ordertxt1" >Line 2: <input type="text" name="deladd2" id="deladd2" value="<?=$partOneFormData['deladd2'] ?>" class="partonefield" /></p>
                <p class="ordertxt1" >Line 3: <input type="text" name="deladd3" id="deladd3" value="<?=$partOneFormData['deladd3'] ?>" class="partonefield" /></p>
                <p class="ordertxt1" >Town: <input type="text" name="deltown" id="deltown" value="<?=$partOneFormData['deladdtown'] ?>" class="partonefield" /></p>
                <p class="ordertxt1" >County: <input type="text" name="delcounty" id="delcounty" value="<?=$partOneFormData['deladdcounty'] ?>" class="partonefield" /></p>
                <p class="ordertxt1" >Postcode: <input type="text" name="delpostcode" id="delpostcode" maxlength="20" value="<?=$partOneFormData['deladdpostcode']?>" class="partonefield" /></p>
                <p class="ordertxt1" >Country: <select name="delcountry" id="delcountry" style="width:138px;" class="partonefield">
                    <?php foreach ($countrylist as $row): 
                        $slcted='';
                        if ($partOneFormData['deladdcountry']==$row['country']) {
                            $slcted='selected';

                        }?>               
                    <option value="<?php echo $row['country'] ?>" <?=$slcted ?> ><?php echo $row['country'] ?> </option>
                    <?php endforeach; ?>
                </select></p>
                <p class="ordertxt1" ><select name="delphonetype1" id="delphonetype1" class="partonefield">
                    <?php foreach ($phonenoTypes as $row): ?>               
                    <option value="<?php echo $row['typename'] ?>" <?= $this->MyForm->setSelectedByKey($phoneNumbers, [1, 'phonenumbertype'], $row['typename'])?> ><?php echo $row['typename'] ?> </option>
                    <?php endforeach; ?>
                </select><br>
                Contact No 1: <input type="text" name="delContact1" id="delContact1" value="<?=$this->MyForm->safeArrayGet($phoneNumbers, [1,'number'])?>" class="partonefield" /></p>
                <p class="ordertxt1" ><select name="delphonetype2" id="delphonetype2" class="partonefield">
                    <?php foreach ($phonenoTypes as $row): ?>               
                    <option value="<?php echo $row['typename'] ?>" <?= $this->MyForm->setSelectedByKey($phoneNumbers, [2, 'phonenumbertype'], $row['typename'])?> ><?php echo $row['typename'] ?> </option>
                    <?php endforeach; ?>
                </select><br>
                Contact No 2: <input type="text" name="delContact2" id="delContact2" value="<?=$this->MyForm->safeArrayGet($phoneNumbers, [2,'number'])?>" class="partonefield" /></p>
                <p class="ordertxt1" ><select name="delphonetype3" id="delphonetype3" class="partonefield">
                    <?php foreach ($phonenoTypes as $row): ?>               
                    <option value="<?php echo $row['typename'] ?>" <?= $this->MyForm->setSelectedByKey($phoneNumbers, [3, 'phonenumbertype'], $row['typename'])?>><?php echo $row['typename'] ?> </option>
                    <?php endforeach; ?>
                </select><br>
                Contact No 3: <input type="text" name="delContact3" id="delContact3" value="<?=$this->MyForm->safeArrayGet($phoneNumbers, [3,'number'])?>" class="partonefield" /></p>
                <p class="ordertxt1" >Production Date: <input style="width:128px" type="text" name="productiondate" id="productiondate" value="" readonly class="partonefield" />&nbsp;<a href="clearproductiondate();">X</a></p>
                <p class="ordertxt1" >Booked Delivery Date: <input style="width:128px" type="text" name="bookeddeldate" id="bookeddeldate" value="" readonly class="partonefield" />&nbsp;<a href="clearbookeddeldate();">X</a></p>
                <p class="ordertxt1" >Order Currency: <select name="currency" id="currency" style="width:139px" class="partonefield">
                    <?php foreach ($currencylist as $row): ?>               
                    <option value="<?php echo $row ?>" <?= $row==$partOneFormData['currency'] ? 'selected':'' ?>><?php echo $row ?> </option>
                    <?php endforeach; ?>
                </select></p>
            </div>       
        </div>
    </div>
    <?php if ($savoirowned=='y') {?>
    <div class="row">
        <div class="col-sm-8">
            <div class="col-md-12">
            <p><label>
    Order Notes:</label> <textarea name="ordernote_notetext"   rows="2" class="partonefield"></textarea></p>
            </div>
        </div>
        <div class="col-sm-2">
            <div class="col-md-12">
            <p class="ordertxt1" ><label>Follow-up Date:</label><br><input style="width:80px" type="text" name="ordernote_followupdate" id="ordernote_followupdate" value="" readonly class="partonefield" />&nbsp;<a href="clearfollowupdate();">X</a></p>
            
            </div>
        </div>
        <div class="col-sm-2">
            <div class="col-md-12">
            <label>
    Action:</label><select name = "ordernote_action" id = "ordernote_action" class="partonefield">
<option value = "To Do">To Do</option>
<option value = "No Further Action">No Further Action</option>
</select>
            </div>
        </div>
    </div>
    <?php if ($ordernotes != '') {
?>    <div class="row" style="padding-left:10px; padding-right:10px;">
        <div class="col-sm-12">
            <p><a href = "showHideNotesHistory();">Show/Hide Previous Order
                                            Notes</a></p>
        </div>
    </div>
    <div class="row ordernotehistory" style="padding-left:10px; padding-right:10px;">
            <div class="col-sm-5">
            <b>Text:</b>
            </div></b>
            <div class="col-sm-1">
            <b>Status:</b>
            </div>
            <div class="col-sm-2">
            <b>Created By/Date:</b>
            </div>
            
            <div class="col-sm-1">
            <b>Type:</b>
            </div>
            <div class="col-sm-1" style="min-width:100px">
            <b>Task Due Date:</b>
            </div>
            <div class="col-sm-1">
            <b>Completed:</b>
            </div>
    </div>
    <?php 
    
    foreach ($ordernotes as $ordernote): 
              ?>
    <div class="row ordernotehistory" style="padding-left:10px; padding-right:10px; max-height:5px;"><hr style="width:100%; margin-top:5px;margin-bottom:5px;">
    </div>           
    <div class="row ordernotehistory" style="padding-left:10px; padding-right:10px;">
            <div class="col-sm-5">
            <?= $ordernote['notetext'] ?>
            </div>
            <div class="col-sm-1">
            <?= $ordernote['action'] ?>
            </div>
            <div class="col-sm-2">
            <?= $ordernote['username'] ?>
    </br>
            <?= $ordernote['createddate'] ?>
            </div>
            <div class="col-sm-1">
            <?= $ordernote['notetype'] ?>
            </div>
            <div class="col-sm-1" style="min-width:100px">
            <? if ($ordernote['action']=='Completed') {
                echo $ordernote['followupdate'];
            } else {
                $followupdate = !empty($ordernote['followupdate']) ? date("m/d/Y", strtotime(substr($ordernote['followupdate'],0,10))) : '';
                ?>
                <input name="Note_followupdate<?=($ordernote['ordernote_id'])?>" type="text" class="text partonefield" id="Note_followupdate<?=($ordernote['ordernote_id'])?>" value="<?= $followupdate ?>" size="10" />
            <?php } ?>
            </div>
            <div class="col-sm-1">
            <? if ($ordernote['action']=='Completed') {
                $notecompdate=date("d/m/Y", strtotime(substr($ordernote['NoteCompletedDate'],0,10)));
                echo 'Completed<br>'.$notecompdate.' '.$ordernote['NoteCompletedBy'];
            } else {
            ?>
            <input name="notecompleted<?=($ordernote['ordernote_id'])?>" id="notecompleted<?=($ordernote['ordernote_id'])?>" type="checkbox" class="partonefield" />
            <?php } ?>
            </div>
    </div>
    <?php endforeach; 
    }
    ?>
    <?php } ?>
    <div class="row">
        <div class="col-sm-12 text-right">
            <div class="col-md-12 text-right">
<?php 
$firstButton='Save 1st part of Order';
if ($quote=='y') {
    $firstButton='Save 1st part of Quote';
}
?>
<?php if ($pn == 0) { ?>
    <input type = "submit" name = "submit" value = "<?=$firstButton?>" id = "submit" class = "button" />
<?php } ?>
        </div>
    </div>
</div>
</form>
<!-- imagedropzone begins -->
<?php if ($pn > 0) { ?>
<div>
<hr class="h-divider">
    <b>Click or Drag to upload files for this order<br><br>

Files Required for Production:</b><br/><?php echo $this->element('dropzone', ['dzType'=>'entry', 'dzPurchaseNo'=>$pn, 'dzOrderNum'=>$purchase['ORDER_NUMBER'], 'dzUserId'=>$currentUserId]); ?></div>
<?php } ?>
<!-- imagedropzone ends -->

<?php if ($pn > 0) { ?>
<p class = "purplebox"><span class = "radiobxmargin">Mattress Required</span>&nbsp;Yes
<?php 
$chkd='';
if (isset($purchase) && $purchase['mattressrequired']=='y') {
    $chkd='checked';
} ?>
<label> <input type = "radio" name = "mattressrequired" class="otherfield" <?=$chkd ?> id = "mattressrequired_y" value = "y"
</label>

No
<?php 
$chkd='';
if (!isset($purchase) || $purchase['mattressrequired']=='n') {
    $chkd='checked';
} ?>
<input name="mattressrequired" class="otherfield" <?=$chkd ?> type="radio" id="mattressrequired_n" value="n" />
</p>
<div id="mattressdiv"></div>


<p class = "purplebox"><span class = "radiobxmargin">Topper Required</span>&nbsp;Yes
<?php 
$chkd='';
if (isset($purchase) && $purchase['topperrequired']=='y') {
    $chkd='checked';
} ?>
<label> <input type = "radio" name = "topperrequired" class="otherfield" <?=$chkd ?> id = "topperrequired_y" value = "y"
</label>

No
<?php 
$chkd='';
if (!isset($purchase) || $purchase['topperrequired']=='n') {
    $chkd='checked';
} ?>
<input name="topperrequired" class="otherfield" <?=$chkd ?> type="radio" id="topperrequired_n" value="n" />
</p>
<div id="topperdiv"></div>
<!-- base begins -->
<p class = "purplebox"><span class = "radiobxmargin">Base Required</span>&nbsp;Yes
<?php 
$chkd='';
if (isset($purchase) && $purchase['baserequired']=='y') {
    $chkd='checked';
} ?>
<label> <input type = "radio" name = "baserequired" class="otherfield" <?=$chkd ?> id = "baserequired_y" value = "y" />
</label>

No
<?php 
$chkd='';
if (!isset($purchase) || $purchase['baserequired']=='n') {
    $chkd='checked';
} ?>
<input name="baserequired" class="otherfield" <?=$chkd ?> type="radio" id="baserequired_n" value="n" />
</p>
<div id="basediv"></div>
<!-- base ends -->
<!-- legs begins -->
<p class = "purplebox"><span class = "radiobxmargin">Legs Required</span>&nbsp;Yes
<?php 
$chkd='';
if (isset($purchase) && $purchase['legsrequired']=='y') {
    $chkd='checked';
} ?>
<label> <input type = "radio" name = "legsrequired" class="otherfield" <?=$chkd ?> id = "legsrequired_y" value = "y"
</label>

No
<?php 
$chkd='';
if (!isset($purchase) || $purchase['legsrequired']=='n') {
    $chkd='checked';
} ?>
<input name="legsrequired" class="otherfield" <?=$chkd ?> type="radio" id="legsrequired_n" value="n" />
</p>
<div id="legsdiv"></div>

<!-- legs ends -->
<!-- hb begins -->
<p class = "purplebox"><span class = "radiobxmargin">Headboard Required</span>&nbsp;Yes
<?php 
$chkd='';
if (isset($purchase) && $purchase['headboardrequired']=='y') {
    $chkd='checked';
} ?>
<label> <input type = "radio" name = "headboardrequired" class="otherfield" <?=$chkd ?> id = "headboardrequired_y" value = "y"
</label>

No
<?php 
$chkd='';
if (!isset($purchase) || $purchase['headboardrequired']=='n') {
    $chkd='checked';
} ?>
<input name="headboardrequired" class="otherfield" <?=$chkd ?> type="radio" id="headboardrequired_n" value="n" />
</p>
<div id="headboarddiv"></div>
<!-- legs ends -->

<!-- valance begins -->
<p class = "purplebox"><span class = "radiobxmargin">Valance Required</span>&nbsp;Yes
<?php 
$chkd='';
if (isset($purchase) && $purchase['valancerequired']=='y') {
    $chkd='checked';
} ?>
<label> <input type = "radio" name = "valancerequired" class="otherfield" <?=$chkd ?> id = "valancerequired_y" value = "y"
</label>

No
<?php 
$chkd='';
if (!isset($purchase) || $purchase['valancerequired']=='n') {
    $chkd='checked';
} ?>
<input name="valancerequired" class="otherfield" <?=$chkd ?> type="radio" id="valancerequired_n" value="n" />
</p>
<div id="valancediv"></div>
<!-- valance ends -->

<!-- accessories begins -->
<p class = "purplebox"><span class = "radiobxmargin">Accessories Required</span>&nbsp;Yes
<?php 
$chkd='';
if (isset($purchase) && $purchase['accessoriesrequired']=='y') {
    $chkd='checked';
} ?>
<label> <input type = "radio" name = "accessoriesrequired" class="otherfield" <?=$chkd ?> id = "accessoriesrequired_y" value = "y"
</label>

No
<?php 
$chkd='';
if (!isset($purchase) || $purchase['accessoriesrequired']=='n') {
    $chkd='checked';
} ?>
<input name="accessoriesrequired" class="otherfield" <?=$chkd ?> type="radio" id="accessoriesrequired_n" value="n" />
</p>
<div id="accessoriesdiv"></div>
<!-- accessories ends -->

<!-- deliverycharge begins -->
<p class = "purplebox"><span class = "radiobxmargin">Delivery Charge</span>&nbsp;Yes
<?php 
$chkd='';
if (isset($purchase) && $purchase['deliverycharge']=='y') {
    $chkd='checked';
} ?>
<label> <input type = "radio" name = "deliverycharge" class="otherfield" <?=$chkd ?> id = "deliverycharge_y" value = "y"
</label>
No
<?php 
$chkd='';
if (!isset($purchase) || $purchase['deliverycharge']=='n') {
    $chkd='checked';
}
?>
<input name="deliverycharge" class="otherfield" <?=$chkd ?> type="radio" id="deliverycharge_n" value="n" />
</p>
<div id="deliverydiv"></div>
<!-- deliverycharge ends -->

<!-- imagedropzone begins -->
<?php if ($pn > 0) { ?>
<div><hr class="h-divider">
    <b>Click or Drag to upload files for this order<br><br>

Exit shots only:</b><br/><?php echo $this->element('dropzone', ['dzType'=>'exit', 'dzPurchaseNo'=>$pn, 'dzOrderNum'=>$purchase['ORDER_NUMBER'], 'dzUserId'=>$currentUserId]); ?></div>
<?php } ?>
<!-- imagedropzone ends -->

<!-- order summary begins -->

<div id="summarydiv"></div>
<!-- order summary ends -->

<!-- order payments begins -->

<div id="paymentsdiv"></div>
<!-- order payments ends -->

<?php } ?>
<?php
$submitButtonWording='';
$action='';
if (isset($purchase) && (!isset($purchase['cancelled']) || $purchase['cancelled'] != 'y')) {
    if (isset($purchase['ORDER_NUMBER'])) {
        $submitButtonWording = ($quote=='y') ? 'Update Quote' : 'Update Order';
        $action = 'Order/updateOrder';
    } else {
        $submitButtonWording = ($quote=='y') ? 'Update Quote' : 'Finalise Order';
        $action = ($quote=='y') ? 'Order/updateOrder' : 'FinaliseOrder';
    }
}
?>
<?php if (isset($purchase['PURCHASE_No']) && (!isset($purchase['cancelled']) || $purchase['cancelled'] != 'y')) { ?>
    <a href="/php/<?=$action?>?pn=<?=$purchase['PURCHASE_No'] ?>" class="btn btn-info otherfield" id="updateorder" onclick="return checkPurchaseStamp(event)"><?=$submitButtonWording?></a>
    <?php if ($quote=='y') { ?>
        <a href="/php/FinaliseOrder?pn=<?=$purchase['PURCHASE_No'] ?>" class="btn btn-info otherfield" id="updateorder"onclick="return checkPurchaseStamp(event)">Convert Quote to Order</a>
    <?php } ?>
<?php } ?>

<?php if (isset($purchase['PURCHASE_No']) && $quote!='y' && !isset($purchase['cancelled']) && $purchase['cancelled'] != 'y') { ?>
    <p style="padding-top:30px;"><a href="/php/CancelOrder?pn=<?=$purchase['PURCHASE_No'] ?>" class="btn btn-warning otherfield" id="updateorder" onclick="return checkPurchaseStamp(event)">Cancel Order</a></p>
<?php } ?>

<p><br><a href = "#top" class = "addorderbox">&gt;&gt; Back to
                                                  Top</a></p>
</div>
<!-- wholesale invoice entry begins -->
<div class="showWholesale" style="display: none">
<table width="350" class="bordergris" border="0" cellspacing="0" cellpadding="3" align="right">
  <tr>
    <td colspan="2"><div align="center"><strong>Wholesale Invoicing</strong></div></td>
    </tr>
  <tr>
    <td>Allocate Wholesale Invoice Number : &nbsp;</td>
    <td><input name="winvoiceno" type="text" id="winvoiceno" size="10" maxlength="25" onKeyUp="showWholesalePDFButton();" value="<?=$wholesaledata['wholesale_inv_no']?>" class="otherfield" >&nbsp;</td>
  </tr>
  <tr>
    <td>Invoice Date :&nbsp;</td>
    <?php
    if ($wholesaledata['wholesale_inv_date']<>'') {
        $wdate=date('m/d/Y', strtotime($wholesaledata['wholesale_inv_date']));
    } else {
        $wdate='';
    }?>
    <td><input name="winvoicedate" type="text" id="winvoicedate" size="10" maxlength="25" onChange="showWholesalePDFButton();" value="<?=$wdate?>" class="otherfield" >&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2"><div align="center"><strong><a href="#" id="generatePDF" class="btn btn-info otherfield">Wholesale Invoice PDF</a></strong></div></td>
    </tr>
</table>

</div>

<input type='hidden' id='pricematrixenabled' name='pricematrixenabled' value='<?=$priceMatrixEnabled?>' />
<script>

document.getElementById('generatePDF').addEventListener('click', function(event) {
  event.preventDefault(); // Prevent the default action of following the link

  // Get the values of winvoiceno and winvoicedate
  var winvoiceno = document.getElementById('winvoiceno').value;
  var winvoicedate = document.getElementById('winvoicedate').value;
  var pn = "<?=$pn?>";
  // Construct the URL with query parameters
  var url = '/php/WholesaleInvoice.pdf?winvoiceno=' + encodeURIComponent(winvoiceno) + '&winvoicedate=' + encodeURIComponent(winvoicedate) + '&pn=' + encodeURIComponent(pn);

  // Navigate to the constructed URL
  window.location.href = url;
});


    function clearackdate() {
        $('#ackdate').val('');
    }
    function clearproductiondate() {
        $('#productiondate').val('');
    }
    function clearbookeddeldate() {
        $('#bookeddeldate').val('');
    }
    function clearfollowupdate() {
        $('#ordernote_followupdate').val('');
    }
    function cleardeliveryaddress() {
        $('#deladd1').val('');
        $('#deladd2').val('');
        $('#deladd3').val('');
        $('#deltown').val('');
        $('#delcounty').val('');
        $('#delpostcode').val('');
        $('#delcountry').val('');
    }
    
    $("#delphonetype1").eComboBox({
        'editableElements' : false
    });
    $("#delphonetype2").eComboBox({
        'editableElements' : false
    });
    $("#delphonetype3").eComboBox({
        'editableElements' : false
    });

    $('input[type=radio][name=mattressrequired]').change(function() {
        if (this.value == 'y') {
            loadMattress();
        } else {
            unloadMattress();
        }
    });

    function showWholesalePDFButton() 
    {	var Winv = $("#winvoiceno").val();
        var Wdate = $("#winvoicedate").val();
        if (Winv=="" || Wdate=="") {
            $("input[name='wholesalePDF']").attr("disabled", true);
        }
        else {
            $("input[name='wholesalePDF']").attr("disabled", false);
        }
    }

    function showHideWholesale() {
        if ($("#wholesaleinv_y").is(":checked")) {
            $('.showWholesale').show();
            $('.hideAccDel').hide();
        } else if ($("#wholesaleinv_n").is(":checked")) {
            $('.showWholesale').hide();
            $('.hideAccDel').show();
        }
    }

    function loadMattress() {
        const url = '/php/order/mattress?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#mattressdiv').html(data);
                mattressInit();
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }
    function unloadMattress() {
        const url = '/php/order/removeMattress?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#mattressdiv').html('');
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }

    <?php if (isset($purchase) && $purchase['mattressrequired']=='y') { ?> 
    loadMattress(); 
    <?php } ?>

    $('input[type=radio][name=topperrequired]').change(function() {
        if (this.value == 'y') {
            loadTopper();
        } else {
            unloadTopper();
        }
    });

    function loadTopper() {
        const url = '/php/order/topper?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#topperdiv').html(data);
                topperInit();
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }
    function unloadTopper() {
        const url = '/php/order/removeTopper?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#topperdiv').html('');
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }

    <?php if (isset($purchase) && $purchase['topperrequired']=='y') { ?> 
    loadTopper(); 
    <?php } ?>

    $('input[type=radio][name=baserequired]').change(function() {
        if (this.value == 'y') {
            loadBase();
        } else {
            unloadBase();
        }
    });

    function loadBase() {
        const url = '/php/order/base?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#basediv').html(data);
                baseInit();
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }
    function unloadBase() {
        const url = '/php/order/removeBase?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#basediv').html('');
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }

    <?php if (isset($purchase) && $purchase['baserequired']=='y') { ?> 
    loadBase(); 
    <?php } ?>

    
    $('input[type=radio][name=legsrequired]').change(function() {
        if (this.value == 'y') {
            loadLegs();
        } else {
            unloadLegs();
        }
    });

    function loadLegs() {
        const url = '/php/order/legs?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#legsdiv').html(data);
                legsInit();
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }
    function unloadLegs() {
        const url = '/php/order/removeLegs?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#legsdiv').html('');
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }

    <?php if (isset($purchase) && $purchase['legsrequired']=='y') { ?> 
    loadLegs(); 
    <?php } ?>

    $('input[type=radio][name=headboardrequired]').change(function() {
        if (this.value == 'y') {
            loadHeadboard();
        } else {
            unloadHeadboard();
        }
    });

    function loadHeadboard() {
        const url = '/php/order/headboard?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#headboarddiv').html(data);
                headboardInit();
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }
    function unloadHeadboard() {
        const url = '/php/order/removeHeadboard?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#headboarddiv').html('');
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }

    <?php if (isset($purchase) && $purchase['headboardrequired']=='y') { ?> 
    loadHeadboard(); 
    <?php } ?>

    $('input[type=radio][name=valancerequired]').change(function() {
        if (this.value == 'y') {
            loadValance();
        } else {
            unloadValance();
        }
    });

    function loadValance() {
        const url = '/php/order/valance?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#valancediv').html(data);
                valanceInit();
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }
    function unloadValance() {
        const url = '/php/order/removeValance?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#valancediv').html('');
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }

    <?php if (isset($purchase) && $purchase['valancerequired']=='y') { ?> 
    loadValance(); 
    <?php } ?>


    $('input[type=radio][name=accessoriesrequired]').change(function() {
        if (this.value == 'y') {
            loadAccessories();
        } else {
            unloadAccessories();
        }
    });

    function loadAccessories() {
        const url = '/php/order/accessories?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#accessoriesdiv').html(data);
                accessoriesInit();
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }
    function unloadAccessories() {
        const url = '/php/order/removeAccessories?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#accessoriesdiv').html('');
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }

    <?php if (isset($purchase) && $purchase['accessoriesrequired']=='y') { ?> 
    loadAccessories(); 
    <?php } ?>

    
    $('input[type=radio][name=deliverycharge]').change(function() {
        if (this.value == 'y') {
            loadDelivery();
        } else {
            unloadDelivery();
        }
    });

    function loadDelivery() {
        const url = '/php/order/delivery?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#deliverydiv').html(data);
                deliveryInit();
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }
    function unloadDelivery() {
        const url = '/php/order/removeDelivery?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#deliverydiv').html('');
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }

    <?php if (isset($purchase) && $purchase['deliverycharge']=='y') { ?> 
    loadDelivery(); 
    <?php } ?>

    //Summary of order begins
    <?php if (isset($purchase['ORDER_NUMBER'])) { ?> 
            loadOrdersummary();
    <?php   } ?>

    function loadOrdersummary() {
        const url = '/php/order/ordersummary?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#summarydiv').html(data);
                ordersummaryInit();
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }
    //summary of order ends

    //Payments section of order begins
    <?php if (isset($purchase['ORDER_NUMBER'])) { ?> 
            loadOrderpayments();
    <?php   } ?>

    function loadOrderpayments() {
        const url = '/php/order/orderpayments?pn=<?=$pn?>';
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#paymentsdiv').html(data);
                orderpaymentsInit();
            },
            error: function(error) {
                console.error('An error occurred:', error);
            }
        });
    }
    //Payments section of order ends

    function showHideNotesHistory() {
        $('.ordernotehistory').toggle();
    }

    function reloadComponents(compsToReload) {
        console.log("reloadComponents: compsToReload=" + compsToReload);
        console.log("reloadComponents: compsToReload=" + typeof compsToReload);
        if (typeof compsToReload === 'undefined') {
            return;
        }
        compsToReload.forEach(function(compId) {
            if (compId == 1 && typeof loadMattress !== 'undefined') {
                loadMattress();
            }
            if (compId == 3 && typeof loadBase !== 'undefined') {
                loadBase();
            }
            if (compId == 5 && typeof loadTopper !== 'undefined') {
                loadTopper();
            }
            if (compId == 6 && typeof loadValance !== 'undefined') {
                loadValance();
            }
            if (compId == 7 && typeof loadLegs !== 'undefined') {
                loadLegs();
            }
            if (compId == 8 && typeof loadHeadboard !== 'undefined') {
                loadHeadboard();
            }
            if (compId == 9 && typeof loadAccessories !== 'undefined') {
                loadAccessories();
            }
            if (compId == 98 && typeof loadOrdersummary !== 'undefined') {
                loadOrdersummary();
            }
        });
    }

    function submitComponentForm(changedCompId) {
        // changedCompId is the component ID of the form that changed.
        // We don't want changes within forms to cause them to submit themselves.
        if (changedCompId != 0 && typeof partOneFieldChanged !== 'undefined' && partOneFieldChanged) {
            submitPartOneForm();
        }
        if (changedCompId != 1 && typeof mattressFieldChanged !== 'undefined' && mattressFieldChanged) {
            submitMattressForm();
        }
        if (changedCompId != 3 && typeof baseFieldChanged !== 'undefined' && baseFieldChanged) {
            submitBaseForm();
        }
        if (changedCompId != 5 && typeof topperFieldChanged !== 'undefined' && topperFieldChanged) {
            submitTopperForm();
        }
        if (changedCompId != 6 && typeof valanceFieldChanged !== 'undefined' && valanceFieldChanged) {
            submitValanceForm();
        }
        if (changedCompId != 7 && typeof legsFieldChanged !== 'undefined' && legsFieldChanged) {
            submitLegsForm();
        }
        if (changedCompId != 8 && typeof headboardFieldChanged !== 'undefined' && headboardFieldChanged) {
            submitHeadboardForm();
        }
        if (changedCompId != 9 && typeof accessoriesFieldChanged !== 'undefined' && accessoriesFieldChanged) {
            submitAccessoriesForm();
        }
        if (changedCompId != 99 && typeof deliveryFieldChanged !== 'undefined' && deliveryFieldChanged) {
            submitDeliveryForm();
        }
        if (changedCompId != 98 && typeof summaryFieldChanged !== 'undefined' && summaryFieldChanged) {
            submitOrdersummaryForm();
        }
    }

    $(".otherfield").on("focus", function() {
        submitComponentForm(-1);
    });

    $(".partonefield").on("focus", function() {
        submitComponentForm(0);
    });

    function submitPartOneForm() {
        $('#partoneform').submit();
    }

    <?php if ($pn > 0) { ?> 
        overridePartOneSubmit();
        $(".partonefield").on("change", function() {
            partOneFieldChanged = true;
            console.log("partOneFieldChanged");
        });
    <?php } ?>

    function overridePartOneSubmit() { 
        $('#partoneform').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();
            $('#loading-spinner').show();
    
            $.ajax({
                type: 'POST',
                url: '/php/Order/addPartOne',
                data: formData,
                error: function(xhr, status, error) {
                    console.error(error);
                },
                complete: function() {
                    $('#loading-spinner').hide();
                }
            });
        });
        partOneFieldChanged = false;
    }

    function loadOtherCustomerOrders(pn, contactNo, divId, imgTagId) {
        var imgTag = $("#"+imgTagId);
        if ($("#"+divId).is(":visible")) {
            $('#' + divId).html('');
            $('#' + divId).hide();
            imgTag.attr("src", "/php/img/plus.gif");
            return;
        }

        const url = '/php/Order/customerOrders?pn=' + pn + '&contact_no=' + contactNo;
        $.ajax({
            url: url,
            type: 'GET',
            success: function(data) {
                $('#' + divId).html(data);
                $('#' + divId).show();
                imgTag.attr("src", "/php/img/minus.gif");
            },
            error: function(error) {
                console.error('call to customerOrders returned an error', error);
            }
        });
    }

    function getMadeAt() {
        //console.log("getMadeAt called");
		var madeAtCardiff = false;
		var madeAtLondon = false;
		var mattressRequired=$("input[name=mattressrequired]:checked").val();
		var savoirmodel=$("#savoirmodel option:selected").val();
        //console.log("savoirmodel=" + savoirmodel);
		var mattMadeAt=getMattressMadeAt(savoirmodel);
        //console.log("mattMadeAt=" + mattMadeAt);
		if (mattressRequired == 'y') {
			if (mattMadeAt==1) {
				madeAtCardiff=true;
			}
			if (mattMadeAt==2) {
				madeAtLondon=true;
			}
		}
        //console.log("madeAtLondon=" + madeAtLondon + ", madeAtCardiff=" + madeAtCardiff);

        var TopperRequired=$("input[name=topperrequired]:checked").val();
		var topperType=$("#toppertype option:selected").val();
		var TopperMadeAt=getTopperMadeAt(topperType);
		if (TopperRequired == 'y') {
			if (TopperMadeAt==1) {
				madeAtCardiff=true;
			}
			if (TopperMadeAt==2) {
				madeAtLondon=true;
			}
		}
        //console.log("madeAtLondon=" + madeAtLondon + ", madeAtCardiff=" + madeAtCardiff);

        var BaseRequired=$("input[name=baserequired]:checked").val();
		var BaseType=$("#basesavoirmodel option:selected").val();
		var BaseMadeAt=getBaseMadeAt(BaseType);
		if (BaseRequired == 'y') {
			if (BaseMadeAt==1) {
				madeAtCardiff=true;
			}
			if (BaseMadeAt==2) {
				madeAtLondon=true;
			}
		}
        //console.log("madeAtLondon=" + madeAtLondon + ", madeAtCardiff=" + madeAtCardiff);

        var HBRequired=$("input[name=headboardrequired]:checked").val();
		var HBType=$("#headboardstyle option:selected").val();
		var HBMadeAt=getHeadboardMadeAt(HBType);
		if (HBRequired == 'y') {
			if (HBMadeAt==1) {
				madeAtCardiff=true;
			}
			if (HBMadeAt==2) {
				madeAtLondon=true;
			}
		}
        //console.log("madeAtLondon=" + madeAtLondon + ", madeAtCardiff=" + madeAtCardiff);

        var LegType=$("input[name=legsrequired]:checked").val();
		var LegsMadeAt=getLegsMadeAt(LegType);
		if (LegType == 'y') {
			if (LegsMadeAt==1) {
				madeAtCardiff=true;
			}
			if (LegsMadeAt==2) {
				madeAtLondon=true;
			}
		}
        //console.log("madeAtLondon=" + madeAtLondon + ", madeAtCardiff=" + madeAtCardiff);

        var ValanceType=$("input[name=valancerequired]:checked").val();
		var ValanceMadeAt=getValanceMadeAt(ValanceType);
		if (ValanceType == 'y') {
			if (ValanceMadeAt==1) {
				madeAtCardiff=true;
			}
			if (ValanceMadeAt==2) {
				madeAtLondon=true;
			}
		}
        //console.log("madeAtLondon=" + madeAtLondon + ", madeAtCardiff=" + madeAtCardiff);

        var AccessoryType=$("input[name=accessoriesrequired]:checked").val();
		if (AccessoryType == 'y') {
			madeAtLondon=true;
		}
        //console.log("madeAtLondon=" + madeAtLondon + ", madeAtCardiff=" + madeAtCardiff);
        //console.log("londonDeliveryDate=<?=$londonDeliveryDate?>, cardiffDeliveryDate=<?=$cardiffDeliveryDate?>");
		
		var delDate = "<?=$latestDeliveryDate?>";
		if (madeAtLondon == true && madeAtCardiff==false) {
            var delDate = "<?=$londonDeliveryDate?>";
		} else if (madeAtLondon == false && madeAtCardiff==true) {
            var delDate = "<?=$cardiffDeliveryDate?>";
		}
		
        //console.log("delDate=" + delDate);
        $("#deldate").val(delDate);
	}

    function getMattressMadeAt(savoirmodel) {
        var mattressMadeAt = 0;
        if (savoirmodel=="No. 1" || savoirmodel=="No. 2"  || savoirmodel=="State") mattressMadeAt = 2; //2 is made at london
        if (savoirmodel=="No. 3" || savoirmodel=="No. 4") mattressMadeAt = 1; //1 is made at Cardiff
        //If savoirmodel!="No. 1" && savoirmodel!="No. 2"  && savoirmodel!="No. 3" && savoirmodel!="No. 4" then getMattressMadeAt = 1 '2 is made at london
        return mattressMadeAt;
    }

    function getBaseMadeAt(basesavoirmodel) {
        var baseMadeAt = 0;
        if (basesavoirmodel=="No. 1" || basesavoirmodel=="No. 2" || basesavoirmodel=="State" || basesavoirmodel=="Savoir Slim") baseMadeAt=2;
        if (basesavoirmodel=="No. 3" || basesavoirmodel=="No. 4")  baseMadeAt=1;
        return baseMadeAt;
    }

    function getTopperMadeAt(toppertype, savoirmodel, basesavoirmodel, mattressmadeat, basemadeat) {
        var topperMadeAt = 0;
        if (toppertype=="HCa Topper")  topperMadeAt=2;
        if (toppertype=="HW Topper" && (savoirmodel!="" && savoirmodel!="n"))  topperMadeAt=mattressmadeat;
        if (toppertype=="HW Topper" && (basesavoirmodel!="" && basesavoirmodel!="n"))  topperMadeAt=basemadeat;
        if (toppertype=="HW Topper" && (savoirmodel=="" || savoirmodel=="n")  && (basesavoirmodel=="" || basesavoirmodel=="n"))  topperMadeAt=1;
        if (toppertype=="CW Topper" && (savoirmodel!="" && savoirmodel!="n"))  topperMadeAt=mattressmadeat;
        if (toppertype=="CW Topper" && (basesavoirmodel!="" && basesavoirmodel!="n"))  topperMadeAt=basemadeat;
        if (toppertype=="CW Topper" && (savoirmodel=="" || savoirmodel=="n") && (basesavoirmodel=="" || basesavoirmodel=="n"))  topperMadeAt=1;
        if (topperMadeAt == "")  topperMadeAt = 0; // happens if theres no mattress or base in the order
        return topperMadeAt;
    }

    function getHeadboardMadeAt(aHeadboardstyle, basemadeat, mattressmadeat) {
        var headboardMadeAt = 0;
        var headcardiff = false;
        if (aHeadboardstyle=="C1" || aHeadboardstyle=="C2" || aHeadboardstyle=="C4" || aHeadboardstyle=="C5" || aHeadboardstyle=="C6" || aHeadboardstyle=="CF1" || aHeadboardstyle=="CF2" || aHeadboardstyle=="C4" || aHeadboardstyle=="C5")  headcardiff=true;
        if (headcardiff) {
            headboardMadeAt=1;
            if (headboardMadeAt!="" && basemadeat!="")  headboardMadeAt=basemadeat;
            if (headboardMadeAt!="" && mattressmadeat!="")  headboardMadeAt=mattressmadeat;
        } else {
            headboardMadeAt=2;
        }
        return headboardMadeAt;
    }

    function getValanceMadeAt() {
        return 2;
    }

    function getLegsMadeAt() {
        return 2;
    }

    $(document).ready(function() {
        let currentUrl = new URL(window.location.href);
        if (!currentUrl.searchParams.has('open')) {
            currentUrl.searchParams.append('open', 'y');
            history.pushState(null, null, currentUrl.toString());
        }
        disablePartOneComponentSections(<?=$isComponentLocked?>);
    });

    function disablePartOneComponentSections(disable) {
        if (disable) {
            $('.partonefield').attr('disabled', true);
        }
    }

    function checkPurchaseStamp(event) {
        var stampValue = $('input[name="stamp"]').val();
        const url = '/php/order/checkPurchaseStamp?pn=<?=$pn?>&stamp='+stampValue;
        var result = null;
        $.ajax({
            url: url,
            type: 'GET',
            async: false,
            success: function(response) {
                console.log("@@@ response.valid="+response.valid+", response.msg="+response.msg+", response="+JSON.stringify(response));
                var isValid = Boolean(response.valid);
                console.log("@@@ isValid="+isValid);
                if (!isValid) {
                    result = confirm(response.msg);
                }
            },
            error: function(error) {
                console.error('An error occurred:', error);
                result = false;
            }
        });

        if (result === false) {
            event.preventDefault();
            return false;
        }
    }

    $(document).ready(function() {
        $('#duplicate-button').click(function() {
            jconfirm.defaults = {
                title: 'Hello',
                titleClass: '',
                type: 'default',
                draggable: true,
                alignMiddle: true,
                typeAnimated: true,
                content: '',
                buttons: {},
                defaultButtons: {
                    ok: {
                        action: function () {
                        }
                        },
                    close: {
                        action: function () {
                        }
                        },
                },
                contentLoaded: function(data, status, xhr){
                },
                icon: '',
                lazyOpen: false,
                bgOpacity: null,
                theme: 'light',
                animation: 'zoom',
                closeAnimation: 'scale',
                animationSpeed: 400,
                animationBounce: 1.2,
                rtl: false,
                container: 'body',
                containerFluid: false,
                backgroundDismiss: false,
                backgroundDismissAnimation: 'shake',
                autoClose: false,
                closeIcon: null,
                closeIconClass: false,
                watchInterval: 100,
                columnClass: 'col-md-4 col-md-offset-4 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1',
                boxWidth: '50%',
                scrollToPreviousElement: true,
                scrollToPreviousElementAnimate: true,
                useBootstrap: true,
                offsetTop: 50,
                offsetBottom: 50,
                dragWindowGap: 15,
                bootstrapClasses: {
                    container: 'container',
                    containerFluid: 'container-fluid',
                    row: 'row',
                },
                onContentReady: function () {},
                onOpenBefore: function () {},
                onOpen: function () {},
                onClose: function () {},
                onDestroy: function () {},
                onAction: function () {}
            };
            $.confirm({//2
                    title: 'Are you sure you want to create a copy of this order?',
                    buttons: {//3
                        Cancel: function () {
                            $.alert('Duplication Cancelled');
                            jconfirm.instances[0].close();
                            return false;
                        },
                        Proceed: {
                            action: function () {
                                    $.confirm({
                                        title: 'Please choose order type:',
                                        content: '<span> <br></span>',
                                        buttons: {
                                            confirm: {
                                                text: 'Customer Order',
                                                btnClass: 'btn-orange',
                                                action: function () {
                                                    $.confirm({
                                                    title: 'Please let us know what type of customer:',
                                                    content: '<span> <br></span>',
                                                    buttons: {
                                                        confirm: {
                                                        text: 'Retail',
                                                        btnClass: 'btn-orange',
                                                        action: function () {
                                                            window.location.href = '/php/Order/duplicateOrder/?order=<?=$pn?>&ordersource=Client Retail';
                                                            $("#form1").submit();
                                                            }
                                                        },
                                                        confirm2: {
                                                        text: 'Trade',
                                                        btnClass: 'btn-orange',
                                                        action: function () {
                                                            window.location.href = '/php/Order/duplicateOrder/?order=<?=$pn?>&ordersource=Client Trade';
                                                            $("#form1").submit();
                                                            }
                                                        },
                                                        confirm3: {
                                                        text: 'Contract',
                                                        btnClass: 'btn-orange',
                                                        action: function () {
                                                            window.location.href = '/php/Order/duplicateOrder/?order=<?=$pn?>&ordersource=Client Contract';
                                                            $("#form1").submit();
                                                            }
                                                        }
                                                    },
                                                    });
                                                }
                                            },
                                            confirm2: {
                                                text: 'Floorstock Order',
                                                btnClass: 'btn-orange',
                                                action: function () {
                                                    window.location.href = '/php/duplicateOrder/?order=<?=$pn?>&ordersource=Floorstock';
                                                }
                                            },
                                            confirm3: {
                                                text: 'Stock Order',
                                                btnClass: 'btn-orange',
                                                action: function () {
                                                    window.location.href = '/php/Order/duplicateOrder/?order=<?=$pn?>&ordersource=Stock';
                                                }
                                            },
                                            confirm4: {
                                                text: 'Marketing Order',
                                                btnClass: 'btn-orange',
                                                action: function () {
                                                    window.location.href = '/php/Order/duplicateOrder/?order=<?=$pn?>&ordersource=Marketing';
                                                }
                                            },
                                            confirm5: {
                                                text: 'Test Order',
                                                btnClass: 'btn-orange',
                                                action: function () {
                                                    window.location.href = '/php/Order/duplicateOrder/?order=<?=$pn?>&ordersource=Test';
                                                }
                                            },
                                            
                                            someButton: {
                                                text: 'HELP',
                                                btnClass: 'btn-green',
                                                action: function () {
                                                    this.$content.find('span').append('<br><b>Customer Order:</b><br>Select this option if you want to place an order for your customer.<br><br><b>Floorstock Order:</b><br>Select this option if you are placing an order which is a floorstock bed for your showroom display.<br><br><b>Stock Order:</b><br>Select this option if you are placing an order for delivery or storage to your warehouse.<br><br><b>Marketing Order:</b><br>Select this option if you are placing an order for Marketing purposes.<br><br>');
                                                    return false; // prevent dialog from closing.
                                                }
                                            },
                                            cancel: function () {
                                                $.alert('Duplication Cancelled');
                                                jconfirm.instances[0].close();
                                                return false;
                                            },
                                        },
                                    });
                                }
                        }
                    }
                });
        });
    });


//-->
</script>

</script>

