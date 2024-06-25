<?php use Cake\Routing\Router; ?>


<div id="brochureform" class="brochure">
    
<form action="/php/AddCustomer/postcodecheck" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	<p>Enter postcode for customer:
		  <input name="postcode" type="text" id="postcode" size="10" onKeyDown="javascript: clearemail();" />
			  <input type="submit" name="submit1" value="Submit Postcode"  id="submit1" class="button" />
			</p>
    </form>
            <form action="/php/AddCustomer/postcodecheck" method="post" name="form2" onSubmit="return FrontPage_Form1_Validator(this)">
		  <p>Enter email address for customer:
            <input name="emailadd" type="text" id="emailadd" size="10" onKeyDown="javascript: clearpostcode();" />
            <input type="submit" name="submit2" value="Check Email address"  id="submit2" class="button" />
          </p>
</form>	


</div>
<script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{
 
   if (theForm.postcode.value == "")
  {
    alert("Please enter the postcode");
    theForm.postcode.focus();
    return (false);
  }


    return true;
} 

function clearemail() {
	$('#emailadd').val('');
}
function clearpostcode() {
	$('#postcode').val('');
}

//-->
</script>