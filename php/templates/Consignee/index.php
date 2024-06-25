<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure">

			      
	<div id="c1">
    		<form name="form1" method="post" action="consignee/add">
			  <h1>ADD NEW CONSIGNEE</h1>
			  <p>Consignee Name:<br>
			    <input name="consigneename" type="text" id="consigneename" size="40">
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
			    <input type="submit" name="addconsignee" id="addconsignee" value="Add Consignee">
		      </p>
            </form>
		</div>
        <div id="c2">
        <h1>Current Consignees (click on Consignee to edit)</h1>
        <p> 
        <?php foreach ($consignee_address as $row): ?> 
		<a href="/php/editconsignee?lid=<?= $row['consignee_ADDRESS_ID'] ?>"><font color='red'><?php echo $row['consigneeName'] ?></font></a><br>
		<?php endforeach; ?>
		</p>
        </div>
                

    
    

</div>