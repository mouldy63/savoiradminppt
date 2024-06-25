<?php use Cake\Routing\Router; ?>


<div id="brochureform" class="brochure">
<form action="AddCustomer" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
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
				<input name="email" type="text" id="email" class="text"  value="<%=Request("email")%>"/>
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
                <input name="postcode" type="text" id="postcode" value="<? =$custPostcode ?>"><SCRIPT LANGUAGE=JAVASCRIPT SRC="https://services.postcodeanywhere.co.uk/popups/javascript.aspx?account_code=savoi11112&license_key=tf86-hh48-pc89-wj73"></SCRIPT>
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
	               

        </form>
</div>
