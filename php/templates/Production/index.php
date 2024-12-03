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
    <div class="row">
        <div class="col-md-12">
        <form name="form2" method="post" action="/php/Production/searchproduction">
            <label for="search"></label>
            Search for an Order Number
            <input type="text" name="orderno" id="orderno">
            <input type="submit" name="submitX" id="submitX" value="Submit">
            <br><br>
        </form>
        </div>
    </div>
   
   
    
    <div class="row">
        <div class="col-sm-12">
         <h1><a href="/php/editcustomer?val=<?=$contact_no?>#orders" style="margin-left:5px;">GO TO CUSTOMER DETAILS</a></h1>
            <div>
                <a href="javascript:void(0)" class="stickleft" onclick="loadOtherCustomerOrders(<?=$pn?>, <?=$contact_no?>, 'otherCustomerOrders', 'otherOrdersImg')">&nbsp;&nbsp;<img id="otherOrdersImg" src="/php/img/plus.gif"/>&nbsp;Other Current Orders</a>
            </div>
         <div id="otherCustomerOrders" style="display: none;"></div>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-4"><br>
        <?php if ($isAdministrator=='y') { ?>
            <p>&nbsp;Order Completed (tick if yes) <input name = "complete" type = "checkbox" id = "complete" <?php if ($purchase['completedorders']=='y') echo 'checked'; ?> value = "y" class="partonefield" ></p>
        <?php } ?>
        </div>
        <div class="col-sm-8">
        </p>
         <p align='right'>
         
            <a href="/php/ordersinproduction">PRODUCTION ORDERS</a>&nbsp;&nbsp;
            <?php if ($prevorder != '') { ?>
                |&nbsp;&nbsp;
                <a href="/php/Production?pn=<?=$prevorder?>">PREVIOUS ORDER</a>&nbsp;&nbsp;
            <?php } ?> 
            <?php if ($nextorder != '') { ?> 
                |&nbsp;&nbsp;<a href="/php/Production?pn=<?=$nextorder?>">NEXT ORDER</a>&nbsp;&nbsp;
            <?php } ?> 
           <br>
           <?php if ($commercialInvoiceDetails != '') {
            foreach ($commercialInvoiceDetails as $row ) {
                $sid=$row['Shipper'];
                $loc=$row['idLocation'];
                $cid=$row['exportCollectionID'];
                ?>
                <a href="/php/commercialinvoice.pdf?pno=<?=$pn?>&sid=<?=$sid?>&loc=<?=$loc?>&cid=<?=$cid?>">Commercial Invoice</a> | 
            <?php } 
            }?>
           <a href="/php/PickingNote.pdf?pn=<?=$purchase['PURCHASE_No']?>">Picking Note</a> | <a href="#" id="toggleLink" onclick="setBalanceAlert();">Delivery Note</a> | <a href="/php/ProductionList">Production List</a> | <a href="/php/PrintPDF.pdf?val=<?=$purchase['PURCHASE_No'] ?>">Print PDF</a>&nbsp;&nbsp;
           <br><br><b>Order Total: <?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['total']?>&nbsp;&nbsp;<br>
           Balance Outstanding: <?=$this->OrderForm->getCurrencySymbol()?><?=$purchase['balanceoutstanding']?></b>&nbsp;&nbsp;

         </p> 
         <p></p>       
      </div>
   </div>

   <div id="deltime" style="display:none;"><br />
    <div class="row">
        <div class="col-sm-8"></div> 
        <div class="col-sm-4">
            <form method="post" name="formD" id="formD" onSubmit="return FrontPage_Form2_Validator(this)" action="/php/deliverynote.pdf?pn=<?=$purchase['PURCHASE_No']?>" target="_blank">
            Enter Delivery Time: <input name="deltime" type="text" size="20" value="<?=$purchase['delivery_Time']?>"><br /><br>
            Delivered by: <input name="deliveredby" type="text" value="<?=$purchase['deliveredby']?>" size="20"><br /><br>
            <?php if($purchase['giftpackrequired']=='y') {
                
                if ($isVIP=='y')  { ?>
                <input name="giftpack" id="giftpack" type="checkbox" value="y" onChange="setGiftLetter(); setVIPAlert();" checked>
                <?php } else { ?>
                    <input name="giftpack" id="giftpack" type="checkbox" value="y" onChange="setGiftLetter();" checked>
                <?php }
                } else {
                    if ($isVIP=='y')  { ?>
                        <input name="giftpack" id="giftpack" type="checkbox" value="y" onChange="setGiftLetter(); setVIPAlert();">
                    <?php } else { ?>
                        <input name="giftpack" id="giftpack" type="checkbox" value="y" onChange="setGiftLetter();" >
                    <?php }

                } ?>
                Deliver Gift Pack&nbsp;&nbsp;
                <div id="delletter"><button onClick="window.open('/php/giftpack.pdf?pn=<?=$purchase['PURCHASE_No']?>'); return false;">Delivery Letter</button></div>
                <br /><br>
                <?php if ($prodCollectionData != '') {
                    $shipmentchecked="checked";
                    echo"<b>Select shipment date for delivery note</b><br />";
                    foreach($prodCollectionData as $shipmentdata) { ?>
                    <input name="shipmentdate" id="shipmentdate" type="radio" value="<?=$shipmentdata['linkscollectionid']?>" <?= $shipmentchecked?>><?=$shipmentdata['collectiondate']?>
                    <br />  
                    $shipmentchecked="";  
                 <?php   }

                } ?>

                <input type="submit" name="Save2" id="Save2" value="Go To Delivery Note">
            </form>
            
        </div>
        
     </div>
    </div>
    <div class="row">
        <div class="col-sm-8"></div> 
        <div class="col-sm-4 text-right">
                <form name="jump2">
            <select name="myjumpbox"
            OnChange="window.open(jump2.myjumpbox.options[selectedIndex].value)">
                <option selected>Please Select...
                <option value="/php/Cases.pdf?pn=<?=$purchase['PURCHASE_No']?>">Work Sheet - Cases
                <option value="/php/Frames.pdf?pn=<?=$purchase['PURCHASE_No']?>">Work Sheet - Frames
                <?php if ($purchase['legsrequired']=='y' || $purchase['headboardlegqty']>0) { ?> 
                    <option value="/php/Legs.pdf?pn=<?=$purchase['PURCHASE_No']?>">Work Sheet - Legs
                <?php } ?>
                <option value="/php/JobFlag.pdf?pn=<?=$purchase['PURCHASE_No']?>">Job Flag
                <option value="/php/PrintPDF.pdf?val=<?=$purchase['PURCHASE_No']?>">Print PDF
            </select>
            </form>
            </div>
    </div>
    <form name="partoneform" id="partoneform" method="post" action="/php/Production/addPartOne">	
    <h1 style="margin-top:-10px;"><br><?=$purchase['orderSource']?> Order No. <?=$purchase['ORDER_NUMBER']?></h1>
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
	<div class="row col-md-12">
        <div class="col-sm-4">
                
            
                <p class="ordertxt1" >Date: <input type="text" name="orderdate" id="orderdate" value="<?=$orderdate ?>" readonly class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Customer Ref: <input type="text" name="customerref" id="customerref" value="<?=$customerreference ?>" class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Client's Title: <input type="text" name="title" id="title" value="<?=$contactdetails['title'] ?>" readonly class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >First Name: <input type="text" name="first" id="first" value="<?=$contactdetails['first'] ?>" readonly class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Surname: <input type="text" name="surname" id="surname" value="<?=$contactdetails['surname'] ?>" readonly class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Tel Home: <input type="text" name="telhome" id="telhome" value="<?=$contactdetails['tel'] ?>" readonly class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Tel Work: <input type="text" name="telwork" id="telwork" value="<?=$contactdetails['telwork'] ?>" readonly class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Mobile: <input type="text" name="mobile" id="mobile" value="<?=$contactdetails['mobile'] ?>" readonly class="partonefield" style="width:70%" /></p>
                 <p class="ordertxt1" >Email Address: <input type="text" name="email" id="email" value="<?=$contactdetails['EMAIL_ADDRESS'] ?>" readonly class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" ><?=$vatWording ?>(%): 
                <select name="vatrates" id="vatrates" style="width:70%;" class="partonefield xview">
                    <?php foreach ($vatrates as $row): ?>               
                    <option value="<?php echo $row['vatrate'] ?>" <?= $row['vatrate']==$partOneFormData['vatrate'] ? 'selected':'' ?> ><?php echo $row['vatrate'] ?> </option>
                    <?php endforeach; ?>
                </select>
                </p>
                <p class="ordertxt1" >Wrap Type: 
                <select name="wrappingtype" id="wrappingtype" style="width:70%;" class="partonefield">
                    <?php foreach ($wrappingtypes as $row): ?>               
                    <option value="<?php echo $row['WrappingID'] ?>" <?= $row['WrappingID']==$partOneFormData['wrappingtype'] ? 'selected':'' ?>><?php echo $row['Wrap']  ?> </option>
                    <?php endforeach; ?>
                </select></p>
                <p class="ordertxt1" >Order Type: 
                <select name="ordertype" id="ordertype" style="width:70%;" class="partonefield">
                    <?php foreach ($ordertype as $row): ?>               
                    <option value="<?php echo $row['ordertypeID'] ?>" <?= $row['ordertypeID']==$partOneFormData['ordertype'] ? 'selected':'' ?>><?php echo $row['ordertype'] ?> </option>
                    <?php endforeach; ?>
                </select></p>
                
                
           
        </div>    
        <div class="col-sm-4">
           
                <h5 class="card-title">Invoice Address</h5>
                <p class="ordertxt1" >Line 1: <input type="text" name="add1" id="add1" value="<?=$contactdetails['street1'] ?>" readonly class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Line 2: <input type="text" name="add2" id="add2" value="<?=$contactdetails['street2'] ?>" readonly class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Line 3: <input type="text" name="add3" id="add3" value="<?=$contactdetails['street3'] ?>" readonly class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Town: <input type="text" name="town" id="town" value="<?=$contactdetails['town'] ?>" readonly class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >County: <input type="text" name="county" id="county" value="<?=$contactdetails['county'] ?>" readonly class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Postcode: <input type="text" name="postcode" id="postcode" value="<?=$contactdetails['postcode'] ?>" readonly class="partonefield" maxlength="20" style="width:70%" /></p>
                <p class="ordertxt1" >Country: <input type="text" name="country" id="country" value="<?=$contactdetails['country'] ?>" readonly class="partonefield" maxlength="20" style="width:70%" /></p>
                
                <p class="ordertxt1" >Company: <input type="text" name="company" id="company" value="<?=$contactdetails['company'] ?>" readonly class="partonefield" style="width:70%" /></p>
                <?php 
                if ($userregion == 1 && $overseas == '') { ?>
                <p class="ordertxt1">Approx. Delivery Date: <select id = "deldate" name = "deldate" class="partonefield" style="width:70%;">
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
        <div class="col-sm-4 gx-5" >
             
                <h5 class="card-title">Delivery Address (<a href= "#" onclick = "cleardeliveryaddress(); return false;"></a>)</h5>
                <p class="ordertxt1" >Line 1: <input type="text" name="deladd1" id="deladd1" value="<?=$partOneFormData['deladd1'] ?>" class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Line 2: <input type="text" name="deladd2" id="deladd2" value="<?=$partOneFormData['deladd2'] ?>" class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Line 3: <input type="text" name="deladd3" id="deladd3" value="<?=$partOneFormData['deladd3'] ?>" class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Town: <input type="text" name="deltown" id="deltown" value="<?=$partOneFormData['deladdtown'] ?>" class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >County: <input type="text" name="delcounty" id="delcounty" value="<?=$partOneFormData['deladdcounty'] ?>" class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Postcode: <input type="text" name="delpostcode" id="delpostcode" maxlength="20" value="<?=$partOneFormData['deladdpostcode']?>" class="partonefield" style="width:70%" /></p>
                <p class="ordertxt1" >Country: <select name="delcountry" id="delcountry" style="width:70%;" class="partonefield">
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
                Contact No 1: <input type="text" name="delContact1" id="delContact1" value="<?=$this->MyForm->safeArrayGet($phoneNumbers, [1,'number'])?>" class="partonefield" style="width:70%;" /></p>
                <p class="ordertxt1" ><select name="delphonetype2" id="delphonetype2" class="partonefield">
                    <?php foreach ($phonenoTypes as $row): ?>               
                    <option value="<?php echo $row['typename'] ?>" <?= $this->MyForm->setSelectedByKey($phoneNumbers, [2, 'phonenumbertype'], $row['typename'])?> ><?php echo $row['typename'] ?> </option>
                    <?php endforeach; ?>
                </select><br>
                Contact No 2: <input type="text" name="delContact2" id="delContact2" value="<?=$this->MyForm->safeArrayGet($phoneNumbers, [2,'number'])?>" class="partonefield" style="width:70%;" /></p>
                <p class="ordertxt1" ><select name="delphonetype3" id="delphonetype3" class="partonefield">
                    <?php foreach ($phonenoTypes as $row): ?>               
                    <option value="<?php echo $row['typename'] ?>" <?= $this->MyForm->setSelectedByKey($phoneNumbers, [3, 'phonenumbertype'], $row['typename'])?>><?php echo $row['typename'] ?> </option>
                    <?php endforeach; ?>
                </select><br>
                Contact No 3: <input type="text" name="delContact3" id="delContact3" value="<?=$this->MyForm->safeArrayGet($phoneNumbers, [3,'number'])?>" class="partonefield" style="width:70%;" /></p>
                <p class="ordertxt1" >Production Date: <input style="width:128px" type="text" name="productiondate" id="productiondate" value="" readonly class="partonefield" />&nbsp;<a  href= "#" onclick = "clearproductiondate(); return false;">X</a></p>
                <p class="ordertxt1" >Booked Delivery Date: <input style="width:128px" type="text" name="bookeddeldate" id="bookeddeldate" value="" readonly class="partonefield  />&nbsp;<a href= "#" onclick = "clearbookeddeldate(); return false;"> X</></p>
                <p class="ordertxt1" >Order Currency: <select name="currency" id="currency" style="width:139px" class="partonefield">
                    <?php foreach ($currencylist as $row): ?>               
                    <option value="<?php echo $row ?>" <?= $row==$partOneFormData['currency'] ? 'selected':'' ?>><?php echo $row ?> </option>
                    <?php endforeach; ?>
                </select></p>
                
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
            <p class="ordertxt1" ><label>Follow-up Date:</label><br><input style="width:80px" type="text" name="ordernote_followupdate" id="ordernote_followupdate" value="" readonly class="partonefield" />&nbsp;<a href= "#" onclick = "clearfollowupdate(); return false;">X</a></p>
            
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
            <p><a href= "#" onclick = "showHideNotesHistory(); return false;">Show/Hide Previous Order
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
            <div class="col-sm-1" style="min-width:103px">
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
    <!-- imagedropzone begins -->
<?php if ($pn > 0) { ?>
<div>
<hr class="h-divider">
    <b>Click or Drag to upload files for this order<br><br>

Files Required for Production:</b><br/><?php echo $this->element('dropzone', ['dzType'=>'entry', 'dzPurchaseNo'=>$pn, 'dzOrderNum'=>$purchase['ORDER_NUMBER'], 'dzUserId'=>$currentUserId]); ?></div>
<?php } ?>
<!-- imagedropzone ends -->

<hr class="h-divider">
<div class="row">
    <div class="col-sm-3" style="min-width:450px">
        <b>SALES (<a href="/php/order?prod=y&pn=<?=$purchase['PURCHASE_No']?>"><font color="#FF0000">click here to amend sales section</font></a>)</b>
    </div>
    <div class="col-sm-2" align="center">
        <b>FABRIC</b>
    </div>
    <div class="col-sm-2" align="center">
         <b>PRODUCTION</b>
    </div>
    <div class="col-sm-2" align="center">
        <b>LOGISTICS</b>
    </div>
</div>

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
<div id="mattressdiv">


</div>

    <div class="row">
        
    </div>
</div><input type="submit" name="Save" id="right-button" value="Save" > 
    </form>

<!-- Custom Alert Modal -->
<div id="customAlert" class="modal">
    <div class="modal-content">
      <span class="close" onclick="closeAlert()">&times;</span>
      <p>VIP MEMBER</p>
      <p>Please note, this customer is part of the VIP Member club and as such the alternate VIP gift box should be provided with the delivery. Please ensure the VIP gift box is correctly provided and delivered to this customer.</p>
    </div>
  </div>



<script>
    $('input[type=radio][name=mattressrequired]').change(function() {
        if (this.value == 'y') {
            loadMattress();
        } else {
            unloadMattress();
        }
    });

    function loadMattress() {
        const url = '/php/production/mattress?pn=<?=$pn?>';
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
        const url = '/php/production/removeMattress?pn=<?=$pn?>';
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

    $(document).ready(init());
    function init() {
    setGiftLetter();
    }
    function setGiftLetter() {
        if ($('#giftpack').is(':checked')) {
            $('#delletter').show();
        } else {
            $('#delletter').hide();
        }
    }
    function setVIPAlert() {
    var checkBox = document.getElementById("giftpack");
    if (checkBox.checked) {
        // If checked, show the custom alert
        var modal = document.getElementById("customAlert");
        modal.style.display = "block";
    }
    }

    function closeAlert() {
    var modal = document.getElementById("customAlert");
    modal.style.display = "none";
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

    

    function loadOtherCustomerOrders(pn, contactNo, divId, imgTagId) {
        var imgTag = $("#"+imgTagId);
        if ($("#"+divId).is(":visible")) {
            $('#' + divId).html('');
            $('#' + divId).hide();
            imgTag.attr("src", "/php/img/plus.gif");
            return;
        }

        const url = '/php/Production/customerOrders?pn=' + pn + '&contact_no=' + contactNo;
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

    $(document).ready(function() {
    $('#toggleLink').click(function(e) {
        e.preventDefault(); // Prevent the default link behavior
        $('#deltime').toggle(); // Toggle the visibility of the #deltime element
    });
});

    function setBalanceAlert() {
	var message;
	var curr = "<?=$this->OrderForm->getCurrencySymbol()?>";
	var decoded = $("<div/>").html(curr).text();
	var outstanding="<?=$purchase['balanceoutstanding'] ?>";
	if (outstanding>0) {
	message = "OUTSTANDING BALANCE REMINDER\n\nan outstanding balance of " + decoded + "<?=$purchase['balanceoutstanding'] ?> remains";
    alert(message);
	}

   
}

function calendarBlurHandler(ctrl) {
	if (ctrl.name == 'productiondate') {
		defaultComponentProductionDates(true);
	} else if (ctrl.name == 'mattbcwexpected' 
		|| ctrl.name == 'basebcwexpected'
		|| ctrl.name == 'topperbcwexpected'
		|| ctrl.name == 'headboardbcwexpected'
		|| ctrl.name == 'legsbcwexpected'
		|| ctrl.name == 'valancebcwexpected'
		|| ctrl.name == 'accessoriesbcwexpected') {
			componentProductionDateUpdateHandler(ctrl.name);
			defaultAreaProductionDates();
	} else if (ctrl.name == 'ordernote_followupdate') {
		$("#ordernote_action option[value='<?='ACTION_REQUIRED'?>]").attr('selected', 'selected');
	} else if (ctrl.name == 'mattfinished') {
		checkAllMattDatesCompleted();
	} else if (ctrl.name == 'basefinished') {
		checkAllBaseDatesCompleted();
	} else if (ctrl.name == 'topperfinished') {
		checkAllTopperDatesCompleted();
	} else if (ctrl.name == 'headboardfinished') {
		checkAllHeadboardDatesCompleted();
	} else if (ctrl.name == 'legsfinished') {
		checkAllLegsDatesCompleted();
	}
	logChange($('#'+ctrl.name));
}
       
function showHideNotesHistory() {
        console.log('showHideNotesHistory');
        $('.ordernotehistory').toggle();
    }
//-->
</script>

