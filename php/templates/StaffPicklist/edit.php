<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure">

<h1>STAFF EDIT DETAILS </h1>
<form action="/php/StaffPicklist/doedit" method="post" name="form1" >	
			  <p> <input type="hidden" name="userid" id="userid" value="<?=$userinfo['user_id'] ?>">
			    <label for="newname"></label>
			    Edit name:
			    <input type="text" name="namestr" id="namestr" value="<?=$userinfo['name'] ?>">
			  </p>
			  <p><?php if ($userinfo['PickedBy']=='y') {?>
              <input name="pick" type="checkbox" id="pick" value="y" checked>
              <?php } else { ?>
              <input name="pick" type="checkbox" id="pick" value="y">
              <?php } ?>
		      Picklist</p>
			    
			  <p>
             <?php if ($userinfo['MadeBy']=='y') {?>
                <input name="made" type="checkbox" id="made" value="y" checked>
              <?php } else { ?> 
              <input name="made" type="checkbox" id="made" value="y">
              <?php } ?>
                Made By
</p>
			  <p>
			    <label for="factory"></label>
			    <select name="factory" id="factory">
               <?php if ($userinfo['id_location']=='27') {?>
                 <option value="27" selected>Cardiff</option>
                <?php } else { ?> 
                <option value="27">Cardiff</option>
              <?php } ?>
                
			    <?php if ($userinfo['id_location']=='1') {?>
                 <option value="1" selected>Bedworks</option>
                <?php } else { ?> 
               <option value="1">Bedworks</option>
               <?php } ?> 
			     
		        </select>
		      Base			  </p>
			  <p>
			    
			    <input type="submit" name="editperson" id="editperson" value="Edit">
		      </p>
            </form>

</div>

<script Language="JavaScript" type="text/javascript">
<!--
   
function FrontPage_Form1_Validator(theForm)
{
 
   if (theForm.correspondencename.value == "")
  {
    alert("You need to give this correspondence a name so you can refer to it later");
    theForm.correspondencename.focus();
    return (false);
  }

 

    return true;
} 

//-->
</script>