<?php use Cake\Routing\Router; ?>


<div id="brochureform" class="brochure">
    
<form action="/php/AdvancedSearch/results" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	

	<div class="content brochure">
		<div class="one-col head-col">
			<p><strong><p>Search for customers below by filling in relevant criteria:</strong>:</p>
			<br><br>
        </div>


		<div class="two-col">
        	<div class="row">

				 
				<strong>Surname</strong><br />
				<input name="surname" type="text" id="surname" class="text" />
		  	</div>
 			<div class="row">
		    	<label for="postcode" id="postcode" class="b">Post Code/Zip Code</label>
				<br />
                <input name="postcode" type="text" id="postcode" value="">
			</div>
			<div class="row">
		    	<label for="dpostcode" id="dpostcode" class="b">Delivery Post Code/Zip Code</label>
				<br />
                <input name="dpostcode" type="text" id="dpostcode" value="">
			</div>
            <div class="row">
		  		<label for="company" id="company" class="b">Company</label>
				<br />
				<input name="company" type="text" id="company" class="text" />
		  	</div>
			<div class="row">
				<label for="orderno" id="orderno"><strong>Order No.</strong></label>
		    	<br />
				<input name="orderno" type="text" id="orderno" class="text" />
		  	</div>
		  	<div class="row">
				<label for="email" id="email"><strong>Email Address</strong></label>
		    	<br />
				<input name="email" type="text" id="email" class="text" />
		  	</div>
 		</div>

		<div class="two-col">
		<?php 
		if ($this->Security->retrieveUserRegion()==1) { ?>
			<div class="row">
			  	<label for="cref" id="cref"><strong>Customer Ref</strong></label>
		    	<br />
				<input name="cref" type="text" id="cref" class="text" />
		  	</div>
			<div class="row">
				<label><b>Please select a channel:</b><br />
			    <select name="channel" id="channel" class="text">
			    <option value=''></option>
 				<?php foreach ($channellist as $row): ?>
                <option value='<?=$row['Channel'] ?>'><?=$row['Channel'] ?></option>
				<?php endforeach; ?>
		        </select>
		      	</label>
			</div>  
			<div class="row">
				<label><b>Please enter type of contact:</b><br />
			    <select name="contacttype" id="contacttype" class="text">
			    <option value=''></option>
 				<?php foreach ($contacttype as $row): ?>
                <option value='<?=$row['ContactType'] ?>'><?=$row['ContactType'] ?></option>
				<?php endforeach; ?>
		        </select>
		      	</label>
			</div> 
			<div class="row">
				<label><b>Where customer visited:</b><br />
			    <select name="location" id="location" class="text">
			    <option value=''></option>
 				<?php foreach ($activeshowrooms as $row): ?>
                <option value='<?=$row['idlocation'] ?>'><?=$row['adminheading'] ?></option>
				<?php endforeach; ?>
		        </select>
		      	</label>
			</div>
	         <?php
			 }
			
			?>    
           
		</div>
		
		</div>
	<div> 
	<div class="clear"></div>
	<div style="position:relative; margin-left:74px; padding-bottom:40px; padding-top:20px;">
	      <input type="submit" name="submit" value="Search Database"  id="submit"  />
	</div>	
</form>
</div>
<script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{
if ((theForm.surname.value == "") && (theForm.postcode.value == "") && (theForm.dpostcode.value == "") && (theForm.company.value == "") && (theForm.orderno.value == "") && (theForm.cref.value == "") && (theForm.channel.value == "") && (theForm.contacttype.value == "") && (theForm.email.value == ""))
  {
    alert("Please complete one of the fields to obtain results");
    theForm.surname.focus();
    return (false);
  }

if ((theForm.surname.value != "") && (theForm.surname.value.length <2))
  {
    alert("Surname needs to be at least 2 characters long");
    theForm.surname.focus();
    return (false);
  }
if ((theForm.company.value != "") && (theForm.company.value.length <2))
  {
    alert("Company name needs to be at least 2 characters long");
    theForm.company.focus();
    return (false);
  }
    if (((theForm.surname.value != "") || (theForm.postcode.value != "") || (theForm.company.value != "") || (theForm.channel.value != "") || (theForm.contacttype.value != "")) && (theForm.orderno.value != "") && (theForm.email.value != ""))
   {
    alert("Only the order number will be returned in this search - any other search criteria entered will be ignored");
    theForm.orderno.focus();
    return (true);
  }
    return true;
} 

//-->
</script>