<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure">

			      
	<div id="c1">
    		<form name="form1" method="post" action="/php/editshipper/edit">
    		<input name="shipperid" type="hidden" value="<?php echo $shipper_address['shipper_ADDRESS_ID']; ?>">
			  <h1>EDIT SHIPPER</h1>
			  <p>Shipper Name:<br>
			    <input name="shippername" type="text" id="shippername" size="40" value="<?php echo $shipper_address['shipperName']; ?>">
		      </p>
			  <p>Address Line 1:<br>
			    <input name="add1" type="text" id="add1" size="40" value="<?php echo $shipper_address['ADD1']; ?>">
			  </p>
			  <p>Address Line 2:<br>
			    <input name="add2" type="text" id="add2" size="40" value="<?php echo $shipper_address['ADD2']; ?>">
			    <br>
			  </p>
               <p>Address Line 3:<br>
			    <input name="add3" type="text" id="add3" size="40" value="<?php echo $shipper_address['ADD3']; ?>">
			    <br>
			  </p>
			  <p>Town:<br>
			    <input name="town" type="text" id="town" size="40" value="<?php echo $shipper_address['TOWN']; ?>">
			  </p>
			  <p>County / State :<br>
			    <input name="county" type="text" id="county" size="40" value="<?php echo $shipper_address['COUNTYSTATE']; ?>">
			  </p>
              <p>Postcode :<br>
			    <input name="postcode" type="text" id="postcode" size="40" value="<?php echo $shipper_address['POSTCODE']; ?>">
			  </p>
			  <p>Country :<br>
			    <input name="country" type="text" id="country" size="40" value="<?php echo $shipper_address['COUNTRY']; ?>">
			    <br>
			  </p>
			  <p>Contact Name :<br>
			    <input name="contact" type="text" id="contact" size="40" value="<?php echo $shipper_address['CONTACT']; ?>">
			  </p>
			  <p>Tel :<br>
			    <input name="tel" type="text" id="tel" size="40" value="<?php echo $shipper_address['PHONE']; ?>">
			  </p>
			  <p>
			    <input type="submit" name="submit1" id="submit1" value="Edit Shipper">
		      </p>
            </form>
		</div>
        <div id="c2">
       
        </div>
                

    
    

</div>