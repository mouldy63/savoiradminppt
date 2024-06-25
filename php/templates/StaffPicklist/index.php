<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure">
<h1>STAFF EDIT SECTION</h1>
<div><form name="form1" method="post" action="/php/StaffPicklist/add">
			  <p>
			   <label for="newname"></label>
			    Add New Person:
			    <input type="text" name="newname" id="newname">
		        <input type="submit" name="addperson" id="addperson" value="Add">
			  </p>
            </form>
<table width="510" border="0" cellspacing="2" cellpadding="2" style="margin-left:10px;">
		    <tr>
		      <td width="124" class="redtext">NAME</td>
		      <td width="230" class="redtext">Location</td>
		      <td width="62" class="redtext">Pick List</td>
		      <td width="251" class="redtext">Made By</td>
		      <td width="261" class="redtext">&nbsp;</td>
	        </tr>
         
        <?php foreach ($savoirusers as $row): ?> 
		<tr><?php if ($row['Retired']=='y') {
              $color='#CCCCCC;';
	 		  } else {
	 		  $color='#000000;';
              }	 ?>      
            <td width="124"><span style="color:<?= $color ?>"><?php echo $row['name'] ?></span></td>
		      <td width="230"><?php echo $row['location'] ?></td>
		      <td width="62"><?php echo $row['PickedBy'] ?></td>
		      <td width="251"><?php echo $row['MadeBy'] ?></td>
		      <td width="261"><a href="/php/StaffPicklist/edit?userid=<?= $row['user_id'] ?>">Edit</a> | 
			  <?php if ($row['Retired']=='y') {
			  ?><a href="/php/StaffPicklist/unretire?userid=<?= $row['user_id'] ?>">Un-Retire</a>
			  <?php } else {
			  ?><a href="/php/StaffPicklist/retire?userid=<?= $row['user_id'] ?>">Retire</a>
			  <?php 
			  } ?>
			</td>
		</tr>
		<?php endforeach; ?>
		</table>
</div>
                

    <a href="/php/editconsignee?lid=<?= $row['consignee_ADDRESS_ID'] ?>">
    

</div>