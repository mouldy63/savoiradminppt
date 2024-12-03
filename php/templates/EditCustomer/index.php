<?php use Cake\Routing\Router;
use Cake\I18n\FrozenTime;?>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#commnextdate" ).datepicker({
changeMonth: true,
yearRange: year + ":+2",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#commnextdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#initialcontactdate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#initialcontactdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#visitdate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#visitdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#lastcontactdate" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#lastcontactdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#contactagain" ).datepicker({
changeMonth: true,
yearRange: year + ":+2",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#contactagain" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
<?php foreach ($communications as $commsrow): ?>
$( "#nextactive_<?=$commsrow['communicationid']?>" ).datepicker({
changeMonth: true,
yearRange: year + ":+2",
changeYear: true,
dateFormat: 'dd/mm/yy'
});
$( "#nextactive_<?=$commsrow['communicationid']?>" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
<?php endforeach; ?>
});

</script>
<div id="brochureform" class="brochure">

<form name="form1" class = "form-horizontal" id="form1" role = "form" method="post" action="/php/EditCustomer/edit">
<div class="whitebox">

	
  <div class="row">
  <div class="col-md-6">
  <?=$custdetails ?>
  <p>Edit customer details using the tabs below and finally clicking the Save Changes button.<br><a href="/php/EditCustomer/export/?val=<?=$customer['CONTACT_NO']?>"><strong>Download Customer Record CSV</strong></a></p>
  </div>

    <div class="col-md-3">
        
        <p> <a href="/php/EditCustomer/print?env=y&val=<?=$customer['CONTACT_NO']?>"><strong>Print Label</strong></a><strong> |  <label>Print Letter:</label></strong><br>

        <select onChange="window.open(this.options[this.selectedIndex].value,'_parent')" name="corresid" id="corresid">
          <option value="n">None</option>
          <?php foreach ($correspondenceList as $row): ?>
            <option value="/php/EditCustomer/print?env=n&val=<?=$customer['CONTACT_NO']?>&corresid=<?=$row['correspondenceid']?>"><?=$row['correspondencename']?></option>
          <?php endforeach; ?>
        </select>


       </p>
    </div>
    <div class="col-md-3">
    <div class="keepright">
        <input type="submit" name="submitdb" value="Save Changes"  id="submitdb" class="button" />
        </div>
        <div class="keepright">
            <input type="submit" name="submitbrochure" value="Brochure Request"  id="submitbrochure" class="button" />
        </div> 
        
        <div class="keepright">
	      	<?php if ($allowedshowrooms=='y') { ?>  
		      <select name="orderquote" id="orderquote" style="margin-right:13px;" onChange="return orderQuoteChangeHandler2();">
		      <option value="0">Please select</option>
           <?php if ($userRegion == 1) { ?>
		      <option value="/Order/?contact_no=<?=$customer['CONTACT_NO']?>&e1=y&quote=n">New Order</option>
            <?php } else { ?>
               <option value="/Order/?contact_no=<?=$customer['CONTACT_NO']?>&e1=y&quote=n&overseas=y">New  Order</option>
         <?php } 
         } 
       if ($userLocation==1) {
       ?>
             <option value="/Order/?contact_no=<?=$customer['CONTACT_NO']?>&e1=y&quote=n&overseas=y">New Overseas Order</option>
       <?php }
       if ($allowedquote=='y') { ?>
              <option value="/Order/?contact_no=<?=$customer['CONTACT_NO']?>&e1=y&quote=y">New Quote</option>
       <?php } ?>
             
	       </select>
       </div>     
	  
          <script type="text/javascript">
                                $('.orderquote').on('select', function () {
                                    $.confirm({
                                        title: 'Any changes you made to the customer details will be saved first. Please confirm.',
                                        content: 'Customer Order',
                                        buttons: {
                                            yes: function () {
                                                $("#form1").submit();
                                            },
                                            no: function () {
                                            }
                                        }
                                    });
                                });
                            </script>
    
    </div>
  </div>
  
</div>
<br>
<!-- Nav tabs -->

<ul class="nav nav-tabs" role="tablist">
 
  <li class="active"><a href="#details" role="tab" data-toggle="tab">Contact Details</a></li>
  <li><a href="#info" role="tab" data-toggle="tab">Customer Information/Source</a></li>
  <li><a href="#orders" role="tab" data-toggle="tab">Orders & Quotes</a></li>
  <li><a href="#delivery" role="tab" data-toggle="tab">Delivery Address</a></li>
  <li><a href="#notes" role="tab" data-toggle="tab">Correspondence/Notes</a></li>
  <li><a href="#additional" role="tab" data-toggle="tab">Additional Contacts</a></li>
</ul>

<input type="hidden" name="nextpage" id="nextpage" value="" />
<input name="contactno" type="hidden" id="contactno" value="<?=$customer['CONTACT_NO']?>">
<input name="code" type="hidden" id="code" value="<?=$customer['CODE']?>">
<input name="owningregion" type="hidden" id="owningregion" value="<?=$customer['OWNING_REGION']?>">
<!-- Tab panes -->
<div class="tab-content responsive">
  <div id="details" class="tab-pane fade in active">
    <div class="form-row">
        <div class="form-group col-md-6">
        
          <div>
          <label class="control-label" for="title">Title</label>
          <input type="text" class="form-control form-control-sm" name="title" id="title" placeholder="Title" value="<?=$customer['title']?>">
          </div>
          <div>
          <label for="name">First Name</label>
          <input type="text" class="form-control form-control-sm" name="first" id="first" placeholder="First name" value="<?=$customer['first']?>">
          </div>
          <label for="surname">Surname</label>
          <input type="text" class="form-control form-control-sm" name="surname" id="surname" placeholder="Surname" value="<?=$customer['surname']?>">

          <label for="email">Email</label>
          <input type="text" class="form-control form-control-sm" name="email" id="email" placeholder="Email" value="<?=$addressdetails['EMAIL_ADDRESS']?>">

          <label for="address1">Address</label>
          <input type="text" class="form-control form-control-sm" name="address1" id="address1" placeholder="Address Line 1" value="<?=$addressdetails['street1']?>">
          <input type="text" class="form-control form-control-sm" name="address2" id="address2" placeholder="Address Line 3" value="<?=$addressdetails['street2']?>">
          <input type="text" class="form-control form-control-sm" name="address3" id="address3" placeholder="Address Line 3" value="<?=$addressdetails['street3']?>">

          <label for="town">Town</label>
          <input type="text" class="form-control form-control-sm" name="town" id="town" placeholder="Town" value="<?=$addressdetails['town']?>">

          <label for="county">County</label>
          <input type="text" class="form-control form-control-sm" name="county" id="county" placeholder="County" value="<?=$addressdetails['county']?>">

          <label for="postcode">Postcode</label>
          <input type="text" class="form-control form-control-sm" name="postcode" id="postcode" placeholder="Postcode" value="<?=$addressdetails['postcode']?>">

          <label for="preferredshipper">Preferred Shipper</label>
          <select class="form-control" name="preferredshipper" id="preferredshipper">
          <?php foreach ($shippers as $shipper):
            $selectedA='';
            if (isset($customer['PreferredShipper']) && $customer['PreferredShipper']==$shipper['shipper_ADDRESS_ID']) {
                $selectedA='selected';
              }
          ?>               
                    <option value="<?php echo $shipper['shipper_ADDRESS_ID'] ?>" <?= $selectedA ?>><?php echo $shipper['shipperName'].', '.$shipper['TOWN'] ?> </option>
                    <?php endforeach; ?>
          </select>
        </div> 

        <div class="form-group col-md-6">
         <label class="control-label" for="country">Country</label>
         <select class="form-control" name="country" id="country">
          <?php 
          $retiredversion='y';
          foreach ($countries as $country):
            $selected='';
            if ($addressdetails['country']==$country['country']) {
                $selected='selected';
                $retiredversion='n';
              } else if ($addressdetails['country']=='') { ?>
                  <option value="United Kingdom" selected >United Kingdom</option> 
          <?php } ?>
                    <option value="<?php echo $country['country'] ?>" <?= $selected ?>><?php echo $country['country']?> </option>
                    <?php endforeach; ?>
          <?php if ($retiredversion=='y' && $addressdetails['country'] != '') { ?>
             <option value="<?=$addressdetails['country']?>" selected><?=$addressdetails['country']?></option>
          <?php }
          ?>               
          </select>      
          <label class="control-label" for="telhome">Tel Home</label>
          <input type="text" class="form-control form-control-sm" name="telhome" id="telhome" placeholder="Tel Home" value="<?=$addressdetails['tel']?>">       
          <label class="control-label" for="telwork">Tel Work</label>
          <input type="text" class="form-control form-control-sm" name="telwork" id="telwork" placeholder="Tel Work" value="<?=$customer['telwork']?>">  
          <label class="control-label" for="mobile">Mobile</label>
          <input type="text" class="form-control form-control-sm" name="mobile" id="mobile" placeholder="Mobile" value="<?=$customer['mobile']?>">        
          <label class="control-label" for="company">Company</label>
          <input type="text" class="form-control form-control-sm" name="company" id="company" placeholder="Company" value="<?=$addressdetails['company']?>">  
          <label class="control-label" for="companyposition">Position in Company</label>
          <input type="text" class="form-control form-control-sm" name="companyposition" id="companyposition" placeholder="Position in Company" value="<?=$customer['position']?>">  
          <label class="control-label" for="companyvat">Company VAT No</label>
          <input type="text" class="form-control form-control-sm" name="companyvat" id="companyvat" placeholder="Company VAT No." value="<?=$customer['COMPANY_VAT_NO']?>"> 
          <label class="control-label" for="accountsref">Accounts Customer Ref.</label>
          <input type="text" class="form-control form-control-sm" name="accountsref" id="accountsref" placeholder="Accounts Customer Reference" value="<?=$customer['accountsRef']?>"> 
          
          <label class="control-label" for="acceptemail">Customer accepts email marketing (ticked if yes)</label>
          <?php if ($userLocation ==1) {
            $showmarketing='';
          } else {
            $showmarketing='readonly';
          }
         if ($customer['acceptemail']=='n') { ?>
    	    <input name="acceptemail" type="checkbox" id="acceptemail" value="y" <?=$showmarketing?> onchange="updateVipCheckbox()">
          <?php } else { ?>
         	<input name="acceptemail" type="checkbox" id="acceptemail" value="y" checked <?=$showmarketing?> onchange="updateVipCheckbox()">
          <?php } ?>
            <br>
          <label class="control-label" for="acceptemail">Customer accepts postal marketing (ticked if yes)</label>   
          <?php if ($customer['acceptpost']=='n') { ?>
    	    <input name="acceptpost" type="checkbox" id="acceptpost" value="y" <?=$showmarketing?> >
          <?php } else { ?>
         	<input name="acceptpost" type="checkbox" id="acceptpost" value="y" checked <?=$showmarketing?> >
          <?php } ?>
            <br>
            <label class="control-label" for="acceptemail">Wrong Address (ticked if yes)</label>
           <?php if (!isset($addressdetails['wrongaddress']) || $addressdetails['wrongaddress']=='n') { ?>
            <input name="wrongaddress" type="checkbox" id="wrongaddress" value="y">
          <?php  } else { ?>
            <input name="wrongaddress" type="checkbox" id="wrongaddress" value="y" checked>
          <?php }  
          if ($showVipBox) { 
            $checked='';
            if ($isVIP=='y') {
              $checked='checked';
            }
            ?><br><br>
            <label class="control-label" for="vip">VIP Member</label>
            <input name="vip" type="checkbox" id="vip" value="y" <?=$checked?> <?=$showmarketing?> >
            <input type="button" id="viptooltip" value="?" title=" VIP Member is automatically set to yes when the following criteria are met.<br><br>Cumulative spend of £ 19,999 inc VAT, either<br><br>Harrods, Mayfair or Chelsea as showroom, and customer type set to Private." /> 
          <?php  }
          ?>
        </div>
    </div>
  
       
  </div>



  <div id="info" class="tab-pane fade">
  <div class="form-row">
      <div class="form-group col-md-6">
          <b>Interested in the following products:</b><br><br>
            <?php foreach ($interestprods as $row):
            $chked='';
            foreach ($interestprodlinks as $interestprodlinksrow):
            if ($interestprodlinksrow['product_id'] == $row['id']) {
                $chked='checked';
                }
            endforeach; ?>
            <div class="form-check">
                <input type="checkbox" id="XX_<?= $row['id'] ?>" name="XX_<?= $row['id'] ?>" <?= $chked ?>> <?= $row['product'] ?>
              </div>
            <?php endforeach; ?>
      
       <label class="control-label" for="status">Status</label>
         <select class="form-control" name="status" id="status">
          <?php 
          $retiredstatus='y';
          foreach ($status as $statusrow):
            $selected='';
            if ($addressdetails['STATUS']==$statusrow['Status']) {
                $selected='selected';
                $retiredstatus='n';
              } ?>
                    <option value="<?php echo $statusrow['Status'] ?>" <?= $selected ?>><?php echo $statusrow['Status']?> </option>
                    <?php endforeach; ?>
          <?php if ($retiredstatus=='y' && $addressdetails['STATUS'] != '') { ?>
             <option value="<?=$addressdetails['STATUS']?>" selected><?=$addressdetails['STATUS']?></option>
          <?php }
          ?>               
          </select> 

          <label class="control-label" for="channel">Channel</label>
         <select class="form-control" name="channel" id="channel">
         <option value="n">Interested In</option>
          <?php 
          foreach ($channels as $channel):
            $selected='';
            if ($addressdetails['CHANNEL']==$channel['Channel']) {
                $selected='selected';
              } ?>
                    <option value="<?php echo $channel['Channel'] ?>" <?= $selected ?>><?php echo $channel['Channel']?> </option>
                    <?php endforeach; ?>
          ?>               
          </select>

          <label class="control-label" for="customertype">Customer Type</label>
         <select class="form-control" name="customertype" id="customertype">
         <option value="n">Select Customer Type</option>
          <?php 
          foreach ($customertype as $ctype):
            $selected='';
            if ($customer['customerType']==$ctype['customerTypeID']) {
                $selected='selected';
              } ?>
                    <option value="<?php echo $ctype['customerTypeID'] ?>" <?= $selected ?>><?php echo $ctype['customerType']?> </option>
                    <?php endforeach; ?>
          ?>               
          </select>
  </div>
  
        <div class="form-group col-md-6">
        <label class="control-label" for="source">Source: I.e. Where seen, read article in, slept on at</label>
        <select class="form-control" name="source" id="source">
        <option value="n">Enter where seen, read, slept on</option>
          <?php 
          $retiredsource='y';
          foreach ($sources as $sourcerow):
            $selected='';
            
            if (isset($addressdetails['source']) && $addressdetails['source']==$sourcerow) {
                $selected='selected';
                $retiredsource='n';
              } ?>
                    <option value="<?php echo $sourcerow ?>" <?= $selected ?>><?php echo $sourcerow?> </option>
                    <?php endforeach; ?>
          <?php if ($retiredsource=='y' && $addressdetails['source'] != '') { ?>
             <option value="<?=$addressdetails['source']?>" selected><?=$addressdetails['source']?></option>
          <?php }
          ?>               
          </select>
          <label class="control-label" for="other">Alternative source description
          </label>
          <input type="text" class="form-control form-control-sm" name="other" id="other" placeholder="" value="<?=$addressdetails['source_other']?>">  
         
          <label class="control-label" for="inintialcontact">Initial Contact Made By</label>
        <select class="form-control" name="inintialcontact" id="inintialcontact">
        <option value="n">Initial Contact Made By</option>
          <?php 
          $retiredcontacttype='y';
          foreach ($contacttypes as $contacttype):
            $selected='';
            
            if (isset($addressdetails['INITIAL_CONTACT']) && $addressdetails['INITIAL_CONTACT']==$contacttype['ContactType']) {
                $selected='selected';
                $retiredcontacttype='n';
              } ?>
                    <option value="<?php echo $contacttype['ContactType'] ?>" <?= $selected ?>><?php echo $contacttype['ContactType']?> </option>
                    <?php endforeach; ?>
          <?php if ($retiredcontacttype=='y' && $addressdetails['INITIAL_CONTACT'] != '') { ?>
             <option value="<?=$addressdetails['INITIAL_CONTACT']?>" selected><?=$addressdetails['INITIAL_CONTACT']?></option>
          <?php }
          ?>               
          </select>
          <label class="control-label" for="initialcontactdate">Initial Contact Date</label>
          <?php 
          $initialcontactdate='';
          if ($addressdetails['FIRST_CONTACT_DATE'] != '') {
            $initialcontactdate=substr($addressdetails['FIRST_CONTACT_DATE'],0,10);
          } ?>
          <input type="text" class="form-control form-control-sm" name="initialcontactdate" id="initialcontactdate" value="<?=$initialcontactdate?>">  

          <?php if ($savoirowned && ($userRegion == 1 || $userRegion == 23 || $userRegion == 9)) { ?> 
              <label class="control-label" for="pricelist">Price List</label>
              <select class="form-control" name="pricelist" id="pricelist" onChange="showHideTradeDiscountRate();">
              <option value="n">Please enter details of Price List given</option>
                <?php 
                foreach ($pricelist as $pricelistrow):
            	     $selected='';
            	    if (!isset($addressdetails['PRICE_LIST']) || $addressdetails['PRICE_LIST']=='') {
                    if (str_contains(','.$pricelistrow['DEFAULT_FOR_LOC_IDS'].',', ','.$userLocation.',')) {
                      $selected='selected';
                    }
                  } else if ($addressdetails['PRICE_LIST']==$pricelistrow['PriceList']) {
                    $selected='selected';
                  } else if (mb_strtolower($addressdetails['PRICE_LIST'])=='direct' && $pricelistrow['PriceList']=='Retail') {
                    $selected='selected';
                 } 
                ?>
            <option value="<?=$pricelistrow['PriceList']?>" <?=$selected ?>><?=$pricelistrow['PriceList']?></option>
              <?php endforeach; 
            }  else {
              $strpricelist=''; 
              if (isset($addressdetails['PRICE_LIST']) && mb_strtolower($addressdetails['PRICE_LIST'])=='direct') {
                $strpricelist='Retail';
              } else if (isset($addressdetails['PRICE_LIST'])) {
                $strpricelist=$addressdetails['PRICE_LIST'];
              } ?>
              <input type="hidden" name="pricelist" value="<?=$strpricelist?>" />
           <?php }
          ?>
           </select>
           <span id="tradediscountrate">
           <label class="control-label" for="pricelist">Trade Discount Rate(%):</label>
	          <input name="tradediscountrate" type="text" class="form-control form-control-sm" value="<?=$customer['tradediscountrate']?>" size="5" />
            </span>
            <label class="control-label" for="visitdate">Visit Date</label>
            <? $visitdate='';
            if (isset($addressdetails['VISIT_DATE'])) {
              $visitdate=substr($addressdetails['VISIT_DATE'], 0, 10);
            }
            ?>
            <input type="text" class="form-control form-control-sm" name="visitdate" id="visitdate" placeholder="" value="<?=$visitdate?>" readonly> 
            
            <label class="control-label" for="visitlocation">Visit Location</label>
            <select class="form-control" name="visitlocation" id="visitlocation">
            <option value="n">Please enter visit location</option>
          <?php 
          foreach ($visitlocations as $visitlocation):
            $selected='';
            if (isset($addressdetails['VISIT_LOCATION']) && $addressdetails['VISIT_LOCATION']==$visitlocation['idlocation']) {
                $selected='selected';
              } ?>
                    <option value="<?php echo $visitlocation['idlocation'] ?>" <?= $selected ?>><?php echo $visitlocation['adminheading']?> </option>
          <?php endforeach; ?>          
          </select> 
          <label class="control-label" for="lastcontactdate">Last Contact Date</label>
            <? $lastcontactdate='';
            if (isset($addressdetails['last_contact_date'])) {
              $lastcontactdate=substr($addressdetails['last_contact_date'], 0, 10);
            }
            ?>
            <input type="text" class="form-control form-control-sm" name="lastcontactdate" id="lastcontactdate" placeholder="" value="<?=$lastcontactdate?>" readonly> 
        </div>
  </div>

</div>

<div class="tab-pane" id="orders" class="tab-pane fade">
  <?php if (count($allorders)==0) {
    echo '<p>No orders currently</p>';
  } else { ?>
 

 <p><b>Existing Orders (<font color="#FF0000">orders in red are not complete</font><font color="#3333CC"> - orders in blue are on HOLD</font>
 <?php if ($userRegion==1) { ?>
    <font color="#009900"> - orders in green are QUOTES</font>
 <?php }?>
 <font color="#555555"> - orders in grey are CANCELLED</font>):</b><br>
<?php
foreach ($totalspendinfo['overall'] as $line) {
  echo 'Total orders=<b>'.$totalspendinfo['totalorders'].'</b>.';
    $total = $this->MyForm->formatMoneyWithSymbol($line['total'], $line['ordercurrency'], true);
    echo ' Total spend=<b>'.$total.'</b>';
    $totExVat = $this->MyForm->formatMoneyWithSymbol($line['totExVat'], $line['ordercurrency'], true);
    echo ' <b>(Ex VAT='.$totExVat.')</b>';
}
foreach ($totalspendinfo['year'] as $line) {
  $total = $this->MyForm->formatMoneyWithSymbol($line['total'], $line['ordercurrency'], true);
  echo ' Calendar Year Spend=<b>'.$total.'</b>';
  $totExVat = $this->MyForm->formatMoneyWithSymbol($line['totExVat'], $line['ordercurrency'], true);
  echo ' <b> (Ex VAT='.$totExVat.'<b>)';
}


?>
</p> 


<table id="ordersdt" class="table table-striped table-bordered" style="width:100%">
  <thead>
    <tr>
      <th>Order No</th>
      <th>Order Date</th>
      <th>Customer Ref.</th>
      <th>Product Purchased</th>
      <th>Notes</th>
      <th>Order Total ex VAT</th>
      <?php if ($this->Security->isSuperuser() || $this->Security->userHasRoleInList('ORDER_REOPENER')) { ?>
      <th>Order Complete</th>
      <?php } ?>
    </tr>
  </thead>
  <tbody>
  <?php 
    foreach ($allorders as $allorder):
      $orderdate='&nbsp;';
      if (isset($allorder['ORDER_DATE'])) {
        $orderdate = new FrozenTime($allorder['ORDER_DATE']);
        $orderdate = $orderdate->format('d/m/Y');
      }
      $productspurchased='';
      if ($allorder['mattressrequired']=='y') {
        $productspurchased.='<b>Mattress:</b> ';
        $productspurchased.=$this->OrderFuncs->getOrderComponentSummary($allorder['PURCHASE_No'], 1).'<br>';
      }
      if ($allorder['baserequired']=='y') {
        $productspurchased.='<b>Base:</b> ';
        $productspurchased.=$this->OrderFuncs->getOrderComponentSummary($allorder['PURCHASE_No'], 3).'<br>';
      }
      if ($allorder['topperrequired']=='y') {
        $productspurchased.='<b>Topper:</b> ';
        $productspurchased.=$this->OrderFuncs->getOrderComponentSummary($allorder['PURCHASE_No'], 5).'<br>';
      }
      if ($allorder['legsrequired']=='y') {
        $productspurchased.='<b>Legs:</b> ';
        $productspurchased.=$this->OrderFuncs->getOrderComponentSummary($allorder['PURCHASE_No'], 7).'<br>';
      }
      if ($allorder['valancerequired']=='y') {
        $productspurchased.='<b>Valance:</b> Yes<br>';
      }
      if ($allorder['headboardrequired']=='y') {
        $productspurchased.='<b>Headboard:</b> ';
        $productspurchased.=$this->OrderFuncs->getOrderComponentSummary($allorder['PURCHASE_No'], 8).'<br>';
      }
      if ($allorder['accessoriesrequired']=='y') {
        $productspurchased.='<b>Accessories</b> ';
      }
      ?>
      
    <tr>
      <td><?php 
      $colorclass='';
      $extratext='';
      if ($allorder['cancelled']=='y') {
		      echo '<a class="greytext" href="/php/order/?pn='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' CANCELLED ORDER</a>';
      } else if ($allorder['completedorders']=='n' && $allorder['orderonhold']=='n' && $allorder['quote']=='d') {
          echo '<a class="greentext" href="/php/order/?quote=y&pn=?'.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' Declined</a>';
      } else if ($allorder['completedorders']=='n' && $allorder['orderonhold']=='n' && $allorder['quote']=='y' ) {
          echo '<a class="greentext" href="/php/order/?quote=y&pn='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' </a>';
      } else if ($allorder['completedorders']=='n' && $allorder['orderonhold']=='n' && $allorder['quote']=='n') {
          echo '<a class="redtext" href="/php/order/?pn='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' </a>';
      } else if ($allorder['orderonhold']=='y' && $allorder['completedorders']=='n') {
        echo '<a class="bluetext" href="/php/order/?pn='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' </a>';
    } else if ($allorder['completedorders']=='y') {
        echo '<a style="color:grey;" href="/php/order/?readonly=y&pn='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' </a>';
    } else {
      //just in case
        echo '<a class="bluetext" href="/php/order/?readonly=y&pn='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' </a>';
  }?>

  </td>
      <td><?=$orderdate?></td>
      <td><?=$allorder['customerreference']?></td>
      <td><?=$allorder['BED']?> <?=$productspurchased?></td>
      <td><?=$allorder['NOTES']?></td>
      <td><?php if (!$this->Security->userHasRoleInList('NOPRICEUSER')) { 
       echo $this->MyForm->formatMoneyWithSymbol($allorder['totalexvat'], $allorder['ordercurrency'],true);
      }
       ?></td>
       <?php if ($this->Security->isSuperuser() || $this->Security->userHasRoleInList('ORDER_REOPENER')) {  ?>
          <td>
            <?php if ($allorder['completedorders']=='y') { ?>
              <a href="EditCustomer/reopenorder?val=<?=$allorder['PURCHASE_No']?>&contactno=<?=$customer['CONTACT_NO']?>">Re-open order</a>
            <?php } ?>
          </td> 
      <?php } ?>
    </tr>
    <?php endforeach; ?>    
    
  </tbody>
</table>
    <?php if ($allordercount > 25) { ?>
    <p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
    <?php } ?> 
  
  
  
  
  
  <?php  } ?>
</div>


<div id="delivery" class="tab-pane fade">
  <?php if (count($deliveryaddresses)==0) {
    echo '<p>No delivery addresses available</p>';
    } else { 
      foreach ($deliveryaddresses as $deliveryaddress):
      
        $deladdress='';
        if ($deliveryaddress['DELIVERY_NAME'] != '') {
          $deladdress.=$deliveryaddress['DELIVERY_NAME'].', ';
        }
        if ($deliveryaddress['ADD1'] != '') {
          $deladdress.=$deliveryaddress['ADD1'].', ';
        }
        if ($deliveryaddress['ADD2'] != '') {
          $deladdress.=$deliveryaddress['ADD2'].', ';
        }
        if ($deliveryaddress['ADD3'] != '') {
          $deladdress.=$deliveryaddress['ADD3'].', ';
        }
        if ($deliveryaddress['TOWN'] != '') {
          $deladdress.=$deliveryaddress['TOWN'].', ';
        }
        if ($deliveryaddress['COUNTYSTATE'] != '') {
          $deladdress.=$deliveryaddress['COUNTYSTATE'].', ';
        }
        if ($deliveryaddress['COUNTRY'] != '') {
          $deladdress.=$deliveryaddress['COUNTRY'].', ';
        }
        if ($deliveryaddress['CONTACT'] != '') {
          $deladdress.=$deliveryaddress['CONTACT'];
        }
        $retire='';
        if ($deliveryaddress['retire']=='y') {
          $retire='<span style="color:red">Retired </span>';
        }

      if ($deliveryaddress['ISDEFAULT']=='y') {    ?>
      <div class="form-row" style="background-color: #C8E6F1">
          <div class="form-group col-md-10">
          <span class="delfloatleft" style="margin-top:15px;"><input name="maindeliveryaddress" type="radio" checked id="maindeliveryaddress_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" onClick="alert('You are changing the default delivery address')" value="<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>"></span>
          <br><?=$retire?><b>Default Address: </b><?=$deladdress?>
          </div>
          <div class="form-group col-md-2"><br>
          <p class="delfloatright" data-toggle="collapse" data-target="#ZZ<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>"><b>Edit</b></p>
          </div>
      </div>
      <?php } 
      if ($deliveryaddress['ISDEFAULT']=='n') { ?>
      <div class="form-row" style="background-color: #fff">
          <div class="form-group col-md-10">
            <span class="delfloatleft" style="margin-top:15px;"><input name="maindeliveryaddress" type="radio" id="maindeliveryaddress_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" onClick="alert('You are changing the default delivery address')" value="<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>"></span><br><?=$retire?><?=$deladdress?>
            </div>
            <div class="form-group col-md-2">
            <p class="delfloatright" style="margin-top:15px;" data-toggle="collapse" data-target="#ZZ<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>"><b>Edit</b></p>
            </div>
      </div>
              <?php } ?>
      <div id="ZZ<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" class="collapse">
          <div class="form-row">
              <div class="form-group col-md-6">
                <div>
                <label class="control-label" for="deliveryname_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Delivery Name:</label>
                <input type="text" class="form-control form-control-sm" name="deliveryname_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliveryname_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['DELIVERY_NAME']?>">
                </div>
                <div>
                <label class="control-label" for="deliveryadd1_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Delivery Address 1:</label>
                <input type="text" class="form-control form-control-sm" name="deliveryadd1_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliveryadd1_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['ADD1']?>">
                </div>
                <div>
                <label class="control-label" for="deliveryadd2_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Delivery Address 2:</label>
                <input type="text" class="form-control form-control-sm" name="deliveryadd2_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliveryadd2_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['ADD2']?>">
                </div>
                <div>
                <label class="control-label" for="deliveryadd3_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Delivery Address 3:</label>
                <input type="text" class="form-control form-control-sm" name="deliveryadd3_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliveryadd3_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['ADD3']?>">
                </div>
                
                <div>
                <label class="control-label" for="deliverytown_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Town:</label>
                <input type="text" class="form-control form-control-sm" name="deliverytown_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliverytown_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['TOWN']?>">
                </div>
              
                <div>
                <label class="control-label" for="deliverycounty_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">County:</label>
                <input type="text" class="form-control form-control-sm" name="deliverycounty_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliverycounty_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['COUNTYSTATE']?>">
                </div>

                <div>
                <label class="control-label" for="deliverypostcode_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Postcode:</label>
                <input type="text" class="form-control form-control-sm" name="deliverypostcode_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliverypostcode_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['POSTCODE']?>">
                </div>

                <div>
                <label class="control-label" for="deliverycountry_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Country:</label>
                <input type="text" class="form-control form-control-sm" name="deliverycountry_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliverycountry_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['COUNTRY']?>">
                </div>


              </div>
              <div class="form-group col-md-6">
                <div class="row">
                    <div class="col-md-8">
                      <label class="control-label" for="deliverycontact1_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Contact 1 Name:</label>
                      <input type="text" class="form-control form-control-sm" name="deliverycontact1_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliverycontact1_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['CONTACT']?>">

                      <label class="control-label" for="deliverytel1_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Tel 1:</label>
                      <input type="text" class="form-control form-control-sm" name="deliverytel1_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliverycontact1_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['PHONE']?>">
                    </div>
                    <div class="form-group col-md-4">
                      <label class="control-label" for="deliveryphonetype1_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Select Phone Type:</label>
                      <select class="form-control" name="deliveryphonetype1_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliveryphonetype1_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">
                      <?php 
                      foreach ($phonenotypes as $phonenotype):
                      $selected='';
                      if (isset($deliveryaddress['CONTACTTYPE1']) && $deliveryaddress['CONTACTTYPE1']==$phonenotype['typename']) {
                        $selected='selected';
                      } ?>
                      <option value="<?php echo $phonenotype['typename'] ?>" <?= $selected ?>><?php echo $phonenotype['typename']?> </option>
                      <?php endforeach; ?>          
                      </select> 
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                      <label class="control-label" for="deliverycontact2_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Contact 2 Name:</label>
                      <input type="text" class="form-control form-control-sm" name="deliverycontact2_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliverycontact2_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['CONTACT2']?>">

                      <label class="control-label" for="deliverytel2_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Tel 2:</label>
                      <input type="text" class="form-control form-control-sm" name="deliverytel2_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliverycontact2_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['PHONE2']?>">
                    </div>
                    <div class="form-group col-md-4">
                      <label class="control-label" for="deliveryphonetype2_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Select Phone Type:</label>
                      <select class="form-control" name="deliveryphonetype2_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="visitlocation">
                      <?php 
                      foreach ($phonenotypes as $phonenotype):
                      $selected='';
                      if (isset($deliveryaddress['CONTACTTYPE2']) && $deliveryaddress['CONTACTTYPE2']==$phonenotype['typename']) {
                        $selected='selected';
                      } ?>
                      <option value="<?php echo $phonenotype['typename'] ?>" <?= $selected ?>><?php echo $phonenotype['typename']?> </option>
                      <?php endforeach; ?>          
                      </select> 
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                      <label class="control-label" for="deliverycontact3_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Contact 3 Name:</label>
                      <input type="text" class="form-control form-control-sm" name="deliverycontact3_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliverycontact3_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['CONTACT3']?>">

                      <label class="control-label" for="deliverytel3_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Tel 3:</label>
                      <input type="text" class="form-control form-control-sm" name="deliverytel3_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="deliverycontact3_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" placeholder="" value="<?=$deliveryaddress['PHONE3']?>">
                      <p><b>Tick to Retire this address:</b> 
                      <?php if ($deliveryaddress['retire']=='n') { ?>
                      <input name="deliveryretire_<?= $deliveryaddress['DELIVERY_ADDRESS_ID'] ?>" id="deliveryretire_<?php $deliveryaddress['DELIVERY_ADDRESS_ID'] ?>" type="checkbox" value="y">
                      <?php } else { ?>
                      <input name="deliveryretire_<?= $deliveryaddress['DELIVERY_ADDRESS_ID'] ?>" id="deliveryretire_<?php $deliveryaddress['DELIVERY_ADDRESS_ID'] ?>" type="checkbox" value="y" checked>
                      <?php } ?>
                      </p>   
                    </div>
                    <div class="form-group col-md-4">
                      <label class="control-label" for="deliveryphonetype3_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>">Select Phone Type:</label>
                      <select class="form-control" name="deliveryphonetype3_<?=$deliveryaddress['DELIVERY_ADDRESS_ID']?>" id="visitlocation">
                      <?php 
                      foreach ($phonenotypes as $phonenotype):
                      $selected='';
                      if (isset($deliveryaddress['CONTACTTYPE3']) && $deliveryaddress['CONTACTTYPE3']==$phonenotype['typename']) {
                        $selected='selected';
                      } ?>
                      <option value="<?php echo $phonenotype['typename'] ?>" <?= $selected ?>><?php echo $phonenotype['typename']?> </option>
                      <?php endforeach; ?>          
                      </select> 
                    </div>
                </div>
            </div>
          </div>
    
   </div>
   <div><hr></div>
<?php endforeach; ?>   

<?php } ?>  

        <p data-toggle="collapse" data-target="#newadd"><b>ADD NEW DELIVERY ADDRESS</b></p>
          <div id="newadd" class="collapse">

          <div class="form-row">
            <div class="form-group col-md-6">
              <div>
              <label class="control-label" for="deliveryname">Delivery Name:</label>
              <input type="text" class="form-control form-control-sm" name="deliveryname" id="deliveryname" placeholder="" value="">
              </div>
              <div>
              <label class="control-label" for="deliveryadd1">Delivery Address 1:</label>
              <input type="text" class="form-control form-control-sm" name="deliveryadd1" id="deliveryadd1" placeholder="" value="">
              </div>
              <div>
              <label class="control-label" for="deliveryadd2">Delivery Address 2:</label>
              <input type="text" class="form-control form-control-sm" name="deliveryadd2" id="deliveryadd2" placeholder="" value="">
              </div>
              <div>
              <label class="control-label" for="deliveryadd3">Delivery Address 3:</label>
              <input type="text" class="form-control form-control-sm" name="deliveryadd3" id="deliveryadd3" placeholder="" value="">
              </div>
              
              <div>
              <label class="control-label" for="deliverytown">Town:</label>
              <input type="text" class="form-control form-control-sm" name="deliverytown" id="deliverytown" placeholder="" value="">
              </div>
              
              <div>
              <label class="control-label" for="deliverycounty">County:</label>
              <input type="text" class="form-control form-control-sm" name="deliverycounty" id="deliverycounty" placeholder="" value="">
              </div>

              <div>
              <label class="control-label" for="deliverypostcode">Postcode:</label>
              <input type="text" class="form-control form-control-sm" name="deliverypostcode" id="deliverypostcode" placeholder="" value="">
              </div>

              <div>
              <label class="control-label" for="deliverycountry">Country:</label>
              <input type="text" class="form-control form-control-sm" name="deliverycountry" id="deliverycountry" placeholder="" value="">
              </div>


            </div>
            <div class="form-group col-md-6">
               <div class="row">
                    <div class="col-md-8">
                      <label class="control-label" for="deliverycontact1">Contact 1 Name:</label>
                      <input type="text" class="form-control form-control-sm" name="deliverycontact1" id="deliverycontact1" placeholder="" value="">

                      <label class="control-label" for="deliverytel1">Tel 1:</label>
                      <input type="text" class="form-control form-control-sm" name="deliverytel1" id="deliverytel1" placeholder="" value="">
                    
                    
                    </div>
                    <div class="form-group col-md-4">
                      <label class="control-label" for="deliveryphonetype1">Select Phone Type:</label>
                      <select class="form-control" name="deliveryphonetype1" id="deliveryphonetype1">
                  
                      <?php 
                    
                  foreach ($phonenotypes as $phonenotype):
                    ?>
                      <option value="<?php echo $phonenotype['typename'] ?>" <?= $selected ?>><?php echo $phonenotype['typename']?> </option>
                  <?php endforeach; ?>          
                  </select> 
                      </div>
              </div>
              <div class="row">
                    <div class="col-md-8">
                      <label class="control-label" for="deliverycontact2">Contact 2 Name:</label>
                      <input type="text" class="form-control form-control-sm" name="deliverycontact2" id="deliverycontact2" placeholder="" value="">

                      <label class="control-label" for="deliverytel2">Tel 2:</label>
                      <input type="text" class="form-control form-control-sm" name="deliverytel2" id="deliverytel2" placeholder="" value="">
                    
                    
                    </div>
                    <div class="form-group col-md-4">
                      <label class="control-label" for="deliveryphonetype2">Select Phone Type:</label>
                      <select class="form-control" name="deliveryphonetype2" id="deliveryphonetype2">
                      <?php 
                  foreach ($phonenotypes as $phonenotype):
                     ?>
                            <option value="<?php echo $phonenotype['typename'] ?>" <?= $selected ?>><?php echo $phonenotype['typename']?> </option>
                  <?php endforeach; ?>          
                  </select> 
                      </div>
              </div>
              <div class="row">
                    <div class="col-md-8">
                      <label class="control-label" for="deliverycontact3">Contact 3 Name:</label>
                      <input type="text" class="form-control form-control-sm" name="deliverycontact3" id="deliverycontact3" placeholder="" value="">

                      <label class="control-label" for="deliverytel3">Tel 3:</label>
                      <input type="text" class="form-control form-control-sm" name="deliverytel3" id="deliverycondeliverytel3tact3" placeholder="" value="">

                    </div>
                    <div class="form-group col-md-4">
                      <label class="control-label" for="deliveryphonetype3">Select Phone Type:</label>
                      <select class="form-control" name="deliveryphonetype3" id="deliveryphonetype3">
                      <?php 
                  foreach ($phonenotypes as $phonenotype):
                    ?>
                            <option value="<?php echo $phonenotype['typename'] ?>" <?= $selected ?>><?php echo $phonenotype['typename']?> </option>
                  <?php endforeach; ?>          
                  </select> 
                      
              </div>

          
            </div></div></div>
       </div>
  </div>
  <div id="notes" class="tab-pane fade">
    <h1><b>Add Communication / Note (will be dated today):</b></h1>
  <div class="table-responsive">
  <table class="table">
   <thead>
    <th>Created by</th>
    <th>Date created</th>
    <th>Contact name</th>
    <th>Notes</th>
    <th>Follow-up date</th>
    <th>Status</th>
   </thead>
   <tbody>
    <tr>
      <td><?=$username?></td>
      <td><input name="commdate" type="text" value="<?=$today?>" readonly></td>
      <td valign="top"><input name="commperson" type="text" value="<?=$custname?>"></td>
      <td><textarea name="commnote" rows="5"></textarea></td>
      <td><label for="commnext" id="commnext">
		  <input name="commnextdate" type="text" class="text" id="commnextdate" value="" size="10" /></label></td>
      <td><select name="commstatus" size="1" class="formtext" id="commstatus">
            <option value="n">Select Status:</option>
           
            <option value="To Do">To Do</option>
            <option value="Completed">Completed</option>
            <option value="Cancelled">Cancelled</option>
            
          </select></td>
    </tr>
   
   </tbody>
  </table>
</div>  

<div class="table-responsive table-striped">
  <table class="table">
  <thead>
  <tr>
    <td colspan="8"> <b>Previous Correspondence / Notes:</b><br><?=$commscount?> comments/notes<br /></td></tr>
  <tr>
    <th>Date Created</th>
    <th>Type</th>
    <th>Contact Name</th>
    <th>Contacted By:</th>
    <th>Notes</th>
    <th>Follow Up Date</th>
    <th>Response</th>
    <th>Status</th>
  </tr>
  </thead>
  <tbody>
  <?php foreach ($communications as $commsrow): 
    $commdate='';
    if (isset($commsrow['commDate'])) {
    $commdate = new FrozenTime($commsrow['commDate']);
    $commdate = $commdate->format('d/m/Y H:i:s');
    }
    $followup='';
    if (!empty($commsrow['actionnext'])) {
    $followup = new FrozenTime($commsrow['actionnext']);
    $followup = $followup->format('d/m/Y');
    }
    $completeddate ='';
    if (isset($commsrow['completeddate'])) {
      $completeddate = new FrozenTime($commsrow['completeddate']);
      $completeddate = $completeddate->format('d/m/Y');
      }
    ?>
  <tr>
    <td><?=$commdate?></td>
    <td><?=$commsrow['commType']?></td>
    <td><?=$commsrow['person']?></td>
    <td><?=$commsrow['staff']?></td>
    <td>
      <?php if ($commsrow['commstatus']=='To Do' && str_contains($commsrow['notes'], 'Brochure Request')!=0 && $commsrow['notes'] != 'Brochure Request Follow-Up') { ?>
        <textarea name="notesactive_<?=$commsrow['communicationid']?>"><?=$commsrow['notes']?></textarea>
      <? } else { ?>
        <?=$commsrow['notes']?>&nbsp;
      <?php } ?>
    
    </td>
    <td>
      <?php if ($commsrow['commstatus']=='To Do' && str_contains($commsrow['notes'], 'Brochure Request')!=0) { ?>
        <input name="nextactive_<?=$commsrow['communicationid']?>" id="nextactive_<?=$commsrow['communicationid']?>" type="text" value="<?=$followup?>" readonly >
        <? } else { ?>
          <?=$followup?>&nbsp;
      <?php } ?>
   </td>
    <td>
    <?php if ($commsrow['commstatus']=='To Do') { ?>
    <textarea rows="5" name="responseactive_<?=$commsrow['communicationid']?>" id="responseactive_<?=$commsrow['communicationid']?>"></textarea><br><br>
    <?php } ?>
      <?=$commsrow['actionresponse']?>&nbsp;
    </td>
    <td>
    <?php 
    if ($commsrow['commstatus']==null) {

    } elseif (isset($commsrow['commstatus']) && ($commsrow['commstatus']=='Completed' || $commsrow['commstatus']=='Cancelled')) { 
      echo  $commsrow['commstatus'].'<br>'.$completeddate.'<br>'.$commsrow['completedby'];
    } else { 
      $selectToDo='';
      $selectComp='';
      $selectCan='';
      if ($commsrow['commstatus'] == 'To Do') {
        $selectToDo='selected';
      }
      if ($commsrow['commstatus'] == 'Completed') {
        $selectComp='selected';
      }
      if ($commsrow['commstatus'] == 'Cancelled') {
        $selectCan='selected';
      }
      ?>
    <select name="commstatusActive_<?=$commsrow['communicationid']?>" size="1" class="formtext" id="commstatusActive_<?=$commsrow['communicationid']?>">           
            <option value="To Do" <?=$selectToDo?>>To Do</option>
            <option value="Completed" <?=$selectComp?>>Completed</option>
            <option value="Cancelled" <?=$selectCan?>>Cancelled</option>
            
          </select>&nbsp;

          <?php } ?>

   &nbsp;</td>
  </tr>
  <?php endforeach; ?>

  </tbody>
  </table>
</div>  

  </div>


  <div id="additional" class="tab-pane fade">
  <div class="row"> 
      <div class="form-group col-md-6"> 
      <label class="control-label" for="removecontact1"><b>Additional Contact 1:</b></label>
         <p>Tick to remove contact 1 <input name="removecontact1" type="checkbox" id="removecontact1" value="y" onchange="cTrig('removecontact1')">

                     <br></p>
                      <p><label class="control-label" for="addcontact1title"><b>Title:</b></label><br>
                        <input class="form-control form-control-sm" name="addcontact1title" type="text" id="addcontact1title" size="40" value="<?=$additionalcontact1['title']?>">
                      </p>
                      <p><label class="control-label" for="addcontact1name"><b>First Name:</b></label><br>
                        <input class="form-control form-control-sm" name="addcontact1name" type="text" id="addcontact1name" size="40" value="<?=$additionalcontact1['first']?>">
                      </p>
                      <p><label class="control-label" for="addcontact1surname"><b>Surname:</b></label><br>
                        <input class="form-control form-control-sm" name="addcontact1surname" type="text" id="addcontact1surname" size="40" value="<?=$additionalcontact1['surname']?>">
                      </p>
                      <p><label class="control-label" for="addcontact1tel"><b>Telephone:</b></label><br>
                        <input class="form-control form-control-sm" name="addcontact1tel" type="text" id="addcontact1tel" size="40" value="<?=$additionalcontact1['telwork']?>">
                      </p>
                      <p><label class="control-label" for="addcontact1mobile"><b>Mobile:</b></label><br>
                        <input class="form-control form-control-sm" name="addcontact1mobile" type="text" id="addcontact1mobile" size="40" value="<?=$additionalcontact1['mobile']?>">
                      </p>
                      <p><label class="control-label" for="addcontact1email"><b>Email:</b></label><br>
                        <input class="form-control form-control-sm" name="addcontact1email" type="text" id="addcontact1email" size="40" value="<?=$additionalcontact1['AdditionalContactEmail']?>">
                      </p>
                      <p><label class="control-label" for="addcontact1pos"><b>Position in company:</b></label><br>
                        <input class="form-control form-control-sm" name="addcontact1pos" type="text" id="addcontact1pos" size="40" value="<?=$additionalcontact1['position']?>">
                      </p>

    </div> 
    <div class="form-group col-md-6">
    <label class="control-label" for="removecontact2"><b>Additional Contact 2:</b></label>
    <p>Click to remove contact 2 <input name="removecontact2" type="checkbox" id="removecontact2" value="y" onchange="cTrig2('removecontact2')">

<br></p>
 <p><label class="control-label" for="addcontact2title"><b>Title:</b></label><br>
   <input class="form-control form-control-sm" name="addcontact2title" type="text" id="addcontact2title" size="40" value="<?=$additionalcontact2['title']?>">
 </p>
 <p><label class="control-label" for="addcontact2name"><b>First Name:</b></label><br>
   <input class="form-control form-control-sm" name="addcontact2name" type="text" id="addcontact2name" size="40" value="<?=$additionalcontact2['first']?>">
 </p>
 <p><label class="control-label" for="addcontact2surname"><b>Surname:</b></label><br>
   <input class="form-control form-control-sm" name="addcontact2surname" type="text" id="addcontact2surname" size="40" value="<?=$additionalcontact2['surname']?>">
 </p>
 <p><label class="control-label" for="addcontact2tel"><b>Telephone:</b></label><br>
   <input class="form-control form-control-sm" name="addcontact2tel" type="text" id="addcontact2tel" size="40" value="<?=$additionalcontact2['telwork']?>">
 </p>
 <p><label class="control-label" for="addcontact2mobile"><b>Mobile:</b></label><br>
   <input class="form-control form-control-sm" name="addcontact2mobile" type="text" id="addcontact2mobile" size="40" value="<?=$additionalcontact2['mobile']?>">
 </p>
 <p><label class="control-label" for="addcontact2email"><b>Email:</b></label><br>
   <input class="form-control form-control-sm" name="addcontact2email" type="text" id="addcontact2email" size="40" value="<?=$additionalcontact2['AdditionalContactEmail']?>">
 </p>
 <p><label class="control-label" for="addcontact2pos"><b>Position in company:</b></label><br>
   <input class="form-control form-control-sm" name="addcontact2pos" type="text" id="addcontact2pos" size="40" value="<?=$additionalcontact2['position']?>">
 </p>
              </div>
              </div>
              </div>
  </div>
</div>
    
</form> 

</div>
<script>
  new DataTable('#ordersdt', {
    responsive: true,
    paging: false,
    sDom: 'lrtip',
    order: [[0, 'desc']]
});

$(document).ready(showHideTradeDiscountRate());
  $('#viptooltip').powerTip({
    placement: 'n',
    smartPlacement: true
});
$('.responsive-tabs').responsiveTabs({
  accordionOn: ['xs', 'sm'] // xs, sm, md, lg
});
var jsIsVipCandidate = '<?= $isVipCandidate ? 'y' : 'n' ?>';

	function updateVipCheckbox() {
    var acceptEmailCheckbox = document.getElementById("acceptemail");
    var vipCheckbox = document.getElementById("vip");

    if (!acceptEmailCheckbox.checked) {
        vipCheckbox.checked = false;
    } else if (jsIsVipCandidate == "y") {
        vipCheckbox.checked = true;
    }
  }

	$(".nav li").on("click", function(){
   $(".nav").find(".active").removeClass("active");
   $(this).addClass("active");
});

function FrontPage_Form1_Validator(theForm)
{
 
   if (theForm.surname.value == "")
  {
    alert("Please enter surname");
    theForm.surname.focus();
    return (false);
  }

    
 

	if ((theForm.email.value !="") && (!validEmail(theForm.email.value))) {
		alert("Email address is not in the correct format")
		theForm.email.focus()
		theForm.email.select()
		return false
	}
  
	if (theForm.tradediscountrate.value != "" && !IsNumeric(theForm.tradediscountrate.value)) {
		alert("Please enter a whole number for trade discount rate")
		theForm.tradediscountrate.focus()
		theForm.tradediscountrate.select()
		return false
	}
	if (theForm.commstatus.value == "To Do" && theForm.commnextdate.value == "") {
		alert("Please enter a follow-up date")
		theForm.commnextdate.focus()
		theForm.commnextdate.select()
		return false
	}
	

    return true;
} 


function isTradeCustomer() {
	var priceList = document.form1.pricelist.value;
	var isTradeCustomer = (priceList == "Trade" || priceList == "Savoy" || priceList == "Contract" || priceList == "Wholesale" || priceList == "Net Retail");
	return isTradeCustomer;
}

function showHideTradeDiscountRate() {
	if (isTradeCustomer()) {
		$('#tradediscountrate').show();
	} else {
		$('#tradediscountrate').hide();
		document.form1.tradediscountrate.value = 0;
	}
}

function orderQuoteChangeHandler2() { //1
var value = $("#orderquote").val();
	//console.log("value = " + value);
	if (value == 0) {
		alert("Please select an option");
		$("#orderquote").focus();
		return;
	}
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
    columnClass: 'col-md-6 col-md-offset-6 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1',
    boxWidth: '100%',
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
		title: 'Any changes you made to the customer details will be saved first. Please confirm.',
		buttons: {//3
			Cancel: function () {
				$.alert('Order Cancelled');
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
												$("#nextpage").val(value + "&ordersource=Client Retail");
												$("#form1").submit();
												}
											},
											confirm2: {
											text: 'Trade',
											btnClass: 'btn-orange',
											action: function () {
												$("#nextpage").val(value + "&ordersource=Client Trade");
												$("#form1").submit();
												}
											},
											confirm3: {
											text: 'Contract',
											btnClass: 'btn-orange',
											action: function () {
												$("#nextpage").val(value + "&ordersource=Client Contract");
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
										$("#nextpage").val(value + "&ordersource=Floorstock");
										$("#form1").submit();
									}
								},
								confirm3: {
									text: 'Stock Order',
									btnClass: 'btn-orange',
									action: function () {
										$("#nextpage").val(value + "&ordersource=Stock");
										$("#form1").submit();
									}
								},
								confirm4: {
									text: 'Marketing Order',
									btnClass: 'btn-orange',
									action: function () {
										$("#nextpage").val(value + "&ordersource=Marketing");
										$("#form1").submit();
									}
								},
								confirm5: {
									text: 'Test Order',
									btnClass: 'btn-orange',
									action: function () {
										$("#nextpage").val(value + "&ordersource=Test");
										$("#form1").submit();
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
									$.alert('Order Cancelled');
								}
							},
							
							
							
							
						});
					}
        	},
        	
		}
	});
}

function orderQuoteChangeHandler() {
	var value = $("#orderquote").val();
	//console.log("value = " + value);
	if (value == 0) {
		alert("Please select an option");
		$("#orderquote").focus();
	}
	$("#nextpage").val(value);
	if (confirm("Any changes you made to the customer details will be saved first. Please confirm.")) {
		//console.log("confirmed");
		$("#form1").submit();
	}
}

$(document).ready(function() {
    $('#removecontact1').on('change', function() {
        if ($(this).is(':checked')) {
            var confirmDelete = confirm("Are you sure you want to delete additional contact 1");
            if (confirmDelete) {
              $('#addcontact1title').val('');
              $('#addcontact1name').val('');
              $('#addcontact1surname').val('');
              $('#addcontact1tel').val('');
              $('#addcontact1mobile').val('');
              $('#addcontact1email').val('');
              $('#addcontact1pos').val('');
              var confirmMove = confirm("Do you want to change contact 2 to be contact 1?");
                if (confirmMove) {
                    var contact1Title = $('#addcontact2title').val();
                    $('#addcontact1title').val(contact1Title);
                    $('#addcontact2title').val('');
                    var contact1Name = $('#addcontact2name').val();
                    $('#addcontact1name').val(contact1Name);
                    $('#addcontact2name').val('');
                    var contact1Surname = $('#addcontact2surname').val();
                    $('#addcontact1surname').val(contact1Surname);
                    $('#addcontact2surname').val('');
                    var contact1Tel = $('#addcontact2tel').val();
                    $('#addcontact1tel').val(contact1Tel);
                    $('#addcontact2tel').val('');
                    var contact1Mobile = $('#addcontact2mobile').val();
                    $('#addcontact1mobile').val(contact1Mobile);
                    $('#addcontact2mobile').val('');
                    var contact1Email = $('#addcontact2email').val();
                    $('#addcontact1email').val(contact1Email);
                    $('#addcontact2email').val('');
                    var contact1Pos = $('#addcontact2pos').val();
                    $('#addcontact1pos').val(contact1Pos);
                    $('#addcontact2pos').val('');
                    $(this).prop('checked', false);
                }
            } else {
                $(this).prop('checked', false); // Uncheck the checkbox if user cancels
            }
        }
    });
    $('#removecontact2').on('change', function() {
        if ($(this).is(':checked')) {
            var confirmDelete = confirm("Are you sure you want to delete additional contact 2");
            if (confirmDelete) {
              $('#addcontact2title').val('');
              $('#addcontact2name').val('');
              $('#addcontact2surname').val('');
              $('#addcontact2tel').val('');
              $('#addcontact2mobile').val('');
              $('#addcontact2email').val('');
              $('#addcontact2pos').val('');
            } else {
                $(this).prop('checked', false); // Uncheck the checkbox if user cancels
            }
        }
    });
});

$(document).ready(function() {
    // Get the current hash from the URL
    var hash = window.location.hash;

    // Function to activate the tab
    function activateTab(hash) {
        // Remove 'active' and 'in' classes from all tabs and tab content
        $('.nav-tabs li, .tab-pane').removeClass('active').removeClass('in').removeClass('show');

        // Add 'active' class to the tab link and 'in active show' to the tab content
        $('.nav-tabs a[href="' + hash + '"]').parent().addClass('active');
        $(hash).addClass('in active show');
    }

    // Check if a valid hash is provided, and activate the corresponding tab
    if (hash && $(hash).length) {
        activateTab(hash);
    } else {
        // No hash or invalid hash, activate the 'details' tab by default
        activateTab('#details');
    }

    // Update the URL hash when a tab is clicked and activate it
    $('.nav-tabs a').on('shown.bs.tab', function(e) {
       // window.location.hash = e.target.hash;
        activateTab(e.target.hash);
    });
});


//-->
</script>