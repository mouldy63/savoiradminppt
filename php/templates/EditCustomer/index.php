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

});



</script>
<div id="brochureform" class="brochure">
<form name="form1" class = "form-horizontal" role = "form" method="post" action="/php/EditCustomer/edit">
<div class="whitebox">

	<?=$custdetails ?>
  <div class="row">
    <div class="col-md-6">
        <p>Edit all customer details here using the tabs below and finally clicking on the Update Customer Record Button at the bottom of the page:</p>
        <p> <a href="/print2.asp?val=<?=$addressdetails['CODE']?>"><strong>Print Label</strong></a><strong> |  <label>Print Letter:</label></strong><br>
        <select onChange="window.open(this.options[this.selectedIndex].value,'_parent')" name="corresid" id="corresid">
          <option value="n">None</option>
          <?php foreach ($correspondenceList as $row): ?>
            <option value="/print2a.asp?val2=<?=$addressdetails['CODE']?>&corresid=<?=$row['correspondenceid']?>"><?=$row['correspondencename']?></option>
          <?php endforeach; ?>
        </select></p>
    </div>
    <div class="col-md-6">
        <div class="keepright">
            <input type="submit" name="submitbrochure" value="Brochure Request"  id="submitbrochure" class="button" />
        </div> 
        <div class="keepright">
        <input type="submit" name="submitdb" value="Save Changes"  id="submitdb" class="button" />
        </div>
        <div class="keepright">
	      	<?php if ($allowedshowrooms=='y') { ?>  
		      <select name="orderquote" id="orderquote" style="margin-right:13px;" onChange="return orderQuoteChangeHandler2();">
		      <option value="0">Please select</option>
           <?php if ($userRegion == 1) { ?>
		      <option value="/php/order/index?contact_no=<%=val%>&e1=y&quote=n">New Order</option>
            <?php } else { ?>
               <option value="php/order/index?contact_no=<%=val%>&e1=y&quote=n&overseas=y">New  Order</option>
         <?php } 
         } 
       if ($userLocation==1) {
       ?>
             <option value="php/order/index?contact_no=<%=val%>&e1=y&quote=n&overseas=y">New Overseas Order</option>
       <?php }
       if ($allowedquote=='y') { ?>
              <option value="php/order/index?contact_no=<%=val%>&e1=y&quote=y">New Quote</option>
       <?php } ?>
              <option value="cusrecord-csv.asp?val=<%=val%>">Download CSV</option>
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
<ul class="nav nav-tabs responsive-tabs" role="tablist">
  <li class="active"><a href="#details" role="tab" data-toggle="tab">Contact Details</a></li>
  <li><a href="#info" role="tab" data-toggle="tab">Customer Information/Source</a></li>
  <li><a href="#orders" role="tab" data-toggle="tab">Orders & Quotes</a></li>
  <li><a href="#delivery" role="tab" data-toggle="tab">Delivery Address</a></li>
  <li><a href="#notes" role="tab" data-toggle="tab">Correspondence/Notes</a></li>
  <li><a href="#additional" role="tab" data-toggle="tab">Additional Contacts</a></li>
</ul>

<input type="hidden" name="nextpage" id="nextpage" value="" />
<input name="contactno" type="hidden" id="val" value="<?=$customer['CONTACT_NO']?>">
<!-- Tab panes -->
<div class="tab-content responsive">
  <div class="tab-pane active" id="details">
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
          <label class="control-label" for="fax">Fax</label>
          <input type="text" class="form-control form-control-sm" name="fax" id="fax" placeholder="Fax" value="<?=$addressdetails['fax']?>">       
          <label class="control-label" for="company">Company</label>
          <input type="text" class="form-control form-control-sm" name="company" id="company" placeholder="Company" value="<?=$addressdetails['company']?>">  
          <label class="control-label" for="companyposition">Position in Company</label>
          <input type="text" class="form-control form-control-sm" name="companyposition" id="companyposition" placeholder="Position in Company" value="<?=$customer['position']?>">  
          <label class="control-label" for="companyvat">Company VAT No</label>
          <input type="text" class="form-control form-control-sm" name="companyvat" id="companyvat" placeholder="Company VAT No." value="<?=$customer['COMPANY_VAT_NO']?>"> 
          
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



  <div class="tab-pane" id="info">
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

<div class="tab-pane" id="orders">
  <?php if (count($allorders)==0) {
    echo '<p>No orders currently</p>';
  } else { ?>
 

 <p><b>Existing Orders (<font color="#FF0000">orders in red are not complete</font><font color="#3333CC"> - orders in blue are on HOLD</font>
 <?php if ($userRegion==1) { ?>
    <font color="#009900"> - orders in green are QUOTES</font>
 <?php }?>
 <font color="#555555"> - orders in grey are CANCELLED</font>):</b></p> 


<table id="ordersdt" class="table table-striped table-bordered" style="width:100%">
  <thead>
    <tr>
      <th>Order No</th>
      <th>Order Date</th>
      <th>Customer Ref.</th>
      <th>Product Purchased</th>
      <th>Notes</th>
      <th>Order Total ex VAT</th>
      <th>Order Complete</th>
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
        $productspurchased.=$this->OrderFuncs->getOrderComponentSummary($allorder['PURCHASE_No'], 1);
      }
      if ($allorder['baserequired']=='y') {
        $productspurchased.='<b>Base:</b> ';
      }
      if ($allorder['topperrequired']=='y') {
        $productspurchased.='<b>Topper:</b> ';
      }
      if ($allorder['legsrequired']=='y') {
        $productspurchased.='<b>Legs:</b> ';
      }
      if ($allorder['valancerequired']=='y') {
        $productspurchased.='<b>Valance:</b> Yes ';
      }
      if ($allorder['headboardrequired']=='y') {
        $productspurchased.='<b>Headboard:</b> ';
      }
      if ($allorder['accessoriesrequired']=='y') {
        $productspurchased.='<b>Accessories:</b> ';
      }
      ?>
      
    <tr>
      <td><?php 
      $colorclass='';
      $extratext='';
      if ($allorder['cancelled']=='y') {
		      echo '<a class="greytext" href="/edit-purchase.asp?order='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' CANCELLED ORDER</a>';
      } else if ($allorder['completedorders']=='n' && $allorder['orderonhold']=='n' && $allorder['quote']=='d') {
          echo '<a class="greentext" href="/edit-purchase.asp?quote=y&order='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' Declined</a>';
      } else if ($allorder['completedorders']=='n' && $allorder['orderonhold']=='n' && $allorder['quote']=='y' ) {
          echo '<a class="greentext" href="/edit-purchase.asp?quote=y&order='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' </a>';
      } else if ($allorder['completedorders']=='n' && $allorder['orderonhold']=='n' && $allorder['quote']=='n') {
          echo '<a class="redtext" href="/edit-purchase.asp?order='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' </a>';
      } else if ($allorder['orderonhold']=='y' && $allorder['completedorders']=='n') {
        echo '<a class="bluetext" href="/edit-purchase.asp?order='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' </a>';
    } else if ($allorder['completedorders']=='y') {
        echo '<a class="bluetext" href="/edit-purchase.asp?readonly=y&order='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' </a>';
    } else {
      //just in case
        echo '<a class="bluetext" href="/edit-purchase.asp?readonly=y&order='.$allorder['PURCHASE_No'].'">'.$allorder['ORDER_NUMBER'].' </a>';
  }?>

  </td>
      <td><?=$orderdate?></td>
      <td><?=$allorder['customerreference']?></td>
      <td><?=$allorder['BED']?> <?=$productspurchased?></td>
      <td><?=$allorder['NOTES']?></td>
      <td><?php if (!$this->Security->userHasRoleInList('NOPRICEUSER')) { 
       echo $allorder['totalexvat'];
      }
       ?></td>
      <td>
      <?php if (($this->Security->isSuperuser() || $this->Security->userHasRoleInList('ORDER_REOPENER')) && $allorder['completedorders']=='y') {  ?>
    	<a href="/orderincomplete.asp?val=<?=$allorder['PURCHASE_No']?>">Re-open order</a>
      <?php } ?>
      </td>
    </tr>
    <?php endforeach; ?>    
    
  </tbody>
</table>
  
  
  
  
  
  
  
  <?php  } ?>
</div>





  <div class="tab-pane" id="delivery">...settings</div>
  <div class="tab-pane" id="notes">...settings</div>
  <div class="tab-pane" id="additional">...settings</div>
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

function cTrig(removecontact1) {
      if (document.getElementById(removecontact1).checked == true) {
		var box= confirm("Are you sure you want to delete contact 1?\n\nThe contact will be deleted when you hit save");
		if (box!=true)
		document.getElementById(removecontact1).checked = false;
	  } else {
        return true;
	  }
}
function cTrig2(removecontact2) {
      if (document.getElementById(removecontact2).checked == true) {
		var box= confirm("Are you sure you want to delete contact 2?\n\nThe contact will be deleted when you hit save");
		if (box!=true)
		document.getElementById(removecontact2).checked = false;
	  } else {
        return true;
	  }
}

//-->
</script>