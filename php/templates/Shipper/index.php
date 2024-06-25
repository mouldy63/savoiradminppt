<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure">

			      
	<div id="c1">
    		<form name="form1" method="post" action="shipper/add">
			  <h1>ADD NEW SHIPPER</h1>
			  <p>Shipper Name:<br>
			    <input name="shippername" type="text" id="shippername" size="40">
		      </p>
			  <p>Address Line 1:<br>
			    <input name="add1" type="text" id="add1" size="40">
			  </p>
			  <p>Address Line 2:<br>
			    <input name="add2" type="text" id="add2" size="40">
			    <br>
			  </p>
               <p>Address Line 3:<br>
			    <input name="add3" type="text" id="add3" size="40">
			    <br>
			  </p>
			  <p>Town:<br>
			    <input name="town" type="text" id="town" size="40">
			  </p>
			  <p>County / State :<br>
			    <input name="county" type="text" id="county" size="40">
			  </p>
              <p>Postcode :<br>
			    <input name="postcode" type="text" id="postcode" size="40">
			  </p>
			  <p>Country :<br>
			    <input name="country" type="text" id="country" size="40">
			    <br>
			  </p>
			  <p>Contact Name :<br>
			    <input name="contact" type="text" id="contact" size="40">
			  </p>
			  <p>Tel :<br>
			    <input name="tel" type="text" id="tel" size="40">
			  </p>
			  <p>
			    <input type="submit" name="addperson" id="addperson" value="Add Shipper">
		      </p>
            </form>
		</div>
        <div id="c2">
        <h1>Current Shippers (click on Shipper to edit)</h1>
        <p> 
        <?php foreach ($shipper_address as $row): ?> 
		<a href="/php/editshipper?lid=<?= $row['shipper_ADDRESS_ID'] ?>"><font color='red'><?php echo $row['shipperName'] ?></font></a><br>
		<?php endforeach; ?>
		</p>
        </div>
                

    
    

</div>