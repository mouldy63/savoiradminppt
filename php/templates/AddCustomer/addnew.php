<?php use Cake\Routing\Router; ?>

<script>
$(function() {
	var year = new Date().getFullYear();
	
	$( "#visitdate" ).datepicker({
		changeMonth: true,
		yearRange: "-21:+0",
		changeYear: true
	});
	$( "#visitdate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
	
});

</script>
<div id="brochureform" class="brochure">
<form action="doadd" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
    <div class="content brochure">
			    <div class="one-col head-col">
			<p><strong id="docs-internal-guid-6208f503-965b-4d1b-f67c-81fbb9cfdcff">Please enter details of the new customer below</strong>:</p>
			<p>&nbsp;</p>
                </div>


		<div class="two-col">
        <div class="row">
				<label for="title" id="title"><strong>Title</strong><br>
				  <input name="title" type="text" id="title" class="text" /></label>
				  <br>
				  <br>
				  First
				  <label for="name" id="name"><strong> Name</strong><br>
                  <input name="name" type="text" id="name" class="text" />
</label><br>
				  <br>
    <strong>Surname</strong><br />
				<input name="surname" type="text" id="surname" class="text" />
		  </div>


			

			<div class="row">
		    <label for="email" id="email" class="b">Email</label>
				<br />
				<?php 
                if ($email != '') { 
                ?>
				<input name="email" type="text" id="email" class="text"  value="<?=$email ?>"/>
				<?php 
                } else { 
                ?>
                <input name="email" type="text" id="email" class="text"  value=""/>
                <?php 
                }
                ?>
			</div>

            
			<div class="row">
	      <label for="address1" id="address" class="b">Address</label>
			  <br />
                <input name="address1" type="text" id="address1" value="" size="40" maxlength="120">
              <br>
                <input name="address2" type="text" id="address2" value="" size="40" maxlength="120">
		      <br>
		      <input name="address3" type="text" id="address3" value="" size="40" maxlength="120">
            </div>
<div class="row">
		  <label for="town" id="town" class="b">Town/City</label>
				<br />
                <input name="town" type="text" id="town" value="">
		  </div>
          <div class="row">
		  <label for="county" id="county" class="b">County/State</label>
				<br />
                <input name="county" type="text" id="county" value="">
		  </div>
          <div class="row">
		    <label for="postcode" id="postcode" class="b">Post Code/Zip Code</label>
				<br />
                <?php 
                if ($custPostcode != '') { 
                ?>
                <input name="postcode" type="text" id="postcode" value="<?=$custPostcode ?>"><SCRIPT LANGUAGE=JAVASCRIPT SRC="https://services.postcodeanywhere.co.uk/popups/javascript.aspx?account_code=savoi11112&license_key=tf86-hh48-pc89-wj73"></SCRIPT>
				<?php 
                } else { 
                ?>
                <input name="postcode" type="text" id="postcode" value=""><SCRIPT LANGUAGE=JAVASCRIPT SRC="https://services.postcodeanywhere.co.uk/popups/javascript.aspx?account_code=savoi11112&license_key=tf86-hh48-pc89-wj73"></SCRIPT>
                <?php 
                }
                ?>
			</div>
            <div class="row">
		  <label for="country" id="country" class="b">Country</label>
	 
				<br />
				   <select name="country" id="country" class="text">
           <?php foreach ($countrylist as $row):      
                 if ($row['country'] == $country) {
					$strSelected='selected';
					} else {
					$strSelected='';
					}
					?>
                   <option value="<?=$row['country'] ?>" <?= $strSelected ?> ><?=$row['country'] ?></option>
<?php endforeach; ?>
</select>
		  </div>
<div class="row">
			  <label for="tel" id="tel"><strong>Tel</strong></label>
		    <br />
				<input name="tel" type="text" id="tel" class="text" />
		  </div>

			<div class="row">
				<label for="fax" id="fax"><strong>Fax</strong></label>
		    <br />
				<input name="fax" type="text" id="fax" class="text" />
			</div>

			
		<div class="row"><b>Visit Date:</b><br>
            <label>
              <input name="visitdate" type="text" id="visitdate">
            </label>
<br>
          </div>
<div class="row">
          
	<b>Visit Location:</b><br /> 	 
  <select name="location" size="1" class="formtext" id="location">
            <option value="n">Please enter visit location</option>
            <?php foreach ($activeshowrooms as $row): ?>
            <option value='<?=$row['idlocation'] ?>'><?=$row['adminheading'] ?></option>
           <?php endforeach; ?>
          </select>  
           	
			
		</div>

 </div>

		<div class="two-col">
			
			<div class="row">

			  <label><b>Interested In:</b><br />
			 
			    <select name="channel" id="channel" class="text" onChange="showHideCompanyField(this)">
 <?php foreach ($activechannels as $row): ?>
                   <option value='<?=$row['Channel'] ?>'>'<?=$row['adminwording'] ?>'</option>
<?php endforeach; ?>
		        </select>
		      </label>
			
				
			</div>              

 <div id="company_fields" class="row">
				<label for="company"><b><span id="company_label">Company</span></b></label><br />
				<input name="company" type="text" id="company" class="text" /><br /><br />
                <label for="position"><b>Your Job Title</b></label><br />
				<input name="position" type="text" id="position" class="text" />
			</div>	
		<div class="row">
        	<label for="where" class="b">Where did you hear about us?</label><br>
			  <label>
			    <select name="where" id="where" class="text" onChange="javascript:populateSourceDropdown(this)">
			      ' these values must be in the SOURCE column of the SOURCE table & MUST NOT include spaces
			      ' remember to keep the other list in brochure_source.asp up to date
			       <option value=""></option>
                   <option value="Advertising">Saw advertisement in</option>
			      <option value="Editorial">Read article in</option>
			      <option value="Hotel">Slept on a Savoir at</option>
			      <option value="Internet">Internet Search</option>
			      <option value="recommendation">Recommendation</option>
			      <option value="other">Other</option>
		        </select>
		      </label><br />
			<div id="source_div" /></div>
</div>
<div class="row">
			  <label for="other" id="other"><strong>If none of the sources above - state here where heard, seen about us.</strong></label>
    <br />
				<input name="other" type="text" id="other" class="text" />
		  </div>
            <div class="row">
			  <label for="products" id="products"><strong>Which of the following products are you interested in</strong><br /></label>
    <br />
    <b>Savoir Beds</b><br />
		<?php foreach ($interestproducts as $row): ?>
          <input name="XX_<?=$row['id'] ?>" type="checkbox" value="<?=$row['id'] ?>">
          '<?=$row['product'] ?>'<br>
         <?php endforeach; ?>
			</div>
<div class="row">
	  <label for="comments" id="comments" class="b">Any questions or comments?</label>
			  <br />
				<textarea name="comments" rows="2" cols="20" id="comments"></textarea>
		  </div>
            <div class="row"><hr /><br />
              <b>Admin:
            </b><br>
         
          <select name="type" size="1" class="formtext" id="type">
            <option value="n">Please enter type of contact</option>
            <?php foreach ($contacttype as $row): ?>
            <option value="<?=$row['ContactType'] ?>"><?=$row['ContactType'] ?></option>
           <?php endforeach; ?>
          </select>
		  </div>
  <div class="row">
		 <b>Status:</b><br>
          <select name="status" size="1" class="formtext" id="status">
            <?php 
           
            foreach ($status as $row): 
             	$disableoption='';
            if ($row['Status']=='Customer') {
            	$disableoption='disabled="true"';
            }?>
            <option value="<?=$row['Status'] ?>" <?=$disableoption ?>><?=$row['Status'] ?></option>
            <?php endforeach; ?>
          </select>
           
			
			</p>	
		  </div>		  

<div class="row"> Marketing Correspondence<br>
           <br>
           <?php if ($this->Security->retrieveUserLocation()==1) {
           $showmarketing='';
           } else {
           $showmarketing='readonly';
           }?>
           <input type="checkbox" name="post" value="y" id="post" checked <?=$showmarketing ?> /> <label for="post">Customer accepts postal marketing (tick if yes)<br>
           </label>
         </label>
         <div class="clear"></div>
        
         <input type="checkbox" name="emailsallowed" value="y" id="emailsallowed" checked  <?=$showmarketing ?> />
         Customer accepts email marketing (tick if yes)</div>
          <div class="row"></div>
			<div class="row">
			  <input type="submit" name="submit2" value="Add to database only"  id="submit2" class="button" />
	      <input type="submit" name="submit" value="Add Brochure Request to database"  id="submit" class="button" /></div>	
		</div>
	</div>
    <p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
</div>
<div>
</div>
		  
        </form>
</div>
<script Language="JavaScript" type="text/javascript">
<!--
     window.onload = init();
	function init() {
		populateSourceDropdown(document.form1.where);
		showHideCompanyField(document.form1.channel);
	};
	
	function populateSourceDropdown(e) {
		var url = "/brochure_source.asp?sg="+e.options[e.selectedIndex].value + "&txt=" + encodeURI(e.options[e.selectedIndex].text)+ "&ts=" + (new Date()).getTime();
		console.log("url = " + url);
		$('#source_div').load(url);
	}
	
	function showHideCompanyField(e) {
		if (e.options[e.selectedIndex].value == 'Direct') {
			$("#company_fields").hide("fast");
		} else {
			$("#company_fields").show("fast");
		}

		if (e.options[e.selectedIndex].value == 'Hotel') {
			$("#company_label").html("Hotel Name");
		} else {
			$("#company_label").html("Company");
		}
	}
	
	function IsNumeric(sText)
	{
	   var ValidChars = "0123456789";
	   var IsNumber=true;
	   var Char;
	
	 
	   for (i = 0; i < sText.length && IsNumber == true; i++) 
		  { 
		  Char = sText.charAt(i); 
		  if (ValidChars.indexOf(Char) == -1) 
			 {
			 IsNumber = false;
			 }
		  }
	   return IsNumber;
	   
	   }

	function validEmail(email) {
		invalidChars = " /:,;"
		if (email == "") {
			return false
		}
		for (i=0; i<invalidChars.length; i++) {
			badChar = invalidChars.charAt(i)
			if (email.indexOf(badChar,0) > -1) {
				return false
			}
		}
		atPos = email.indexOf("@",1)
		if (atPos == -1) {
			return false
		}
		if (email.indexOf("@",atPos+1) > -1) {
			return false
		}
		periodPos = email.indexOf(".",atPos)
		if (periodPos == -1) {
			return false
		}
		if (periodPos+3 > email.length) {
			return false
		}
		return true
	}
function FrontPage_Form1_Validator(theForm)
{
   
   if (theForm.surname.value == "")
  {
    alert("Please enter surname");
    theForm.surname.focus();
    return (false);
  }

 

	if (!validEmail(theForm.email.value)) {
		alert("invalid email address - please re-enter")
		theForm.email.focus()
		theForm.email.select()
		return false
	}
  

    return true;
} 

//-->
</script>
