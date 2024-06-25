<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure">

			      
	<div id="c1">
    		<form name="form1" method="post" action="/php/editcompdata/edit">
    		<p><?php echo $componentdata['Component']; ?></p>
    		<input name="componentid" type="hidden" value="<?php echo $componentdata['COMPONENTDATA_ID']; ?>">
			  <h1>EDIT PRODUCT</h1>
			  <p>Product Name:<br>
			    <input name="compname" type="text" id="compname" size="40" value="<?php echo $componentdata['COMPONENTNAME']; ?>">
		      </p>
			  <p>Weight per Square Cm (linear for headboards)::<br>
			    <input name="compweight" type="text" id="compweight" size="40" value="<?php echo $componentdata['WEIGHT']; ?>">
			  </p>
			  <p>Harmonised Tariff Code:<br>
			    <input name="comptariff" type="text" id="comptariff" size="40" value="<?php echo $componentdata['TARIFFCODE']; ?>">
			    <br>
			  </p>
               <p>Depth of Product (cms):<br>
			    <input name="compdepth" type="text" id="compdepth" size="40" value="<?php echo $componentdata['DEPTH']; ?>">
			    <br>
			  </p>
			 
			  <p>
			    <input type="submit" name="submit1" id="submit1" value="UPDATE">
		      </p>
            </form>
		</div>
        

    
    

</div>