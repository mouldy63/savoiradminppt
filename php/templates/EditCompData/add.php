<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure">

<h1>ADD PRODUCT DATA</h1>
<form action="/php/editcompdata/add" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">

<select name="component" id="component">
<option value="n"> Select Product:  </option>
<?php foreach ($componentlist as $row): ?>               
<option value="<?php echo $row['ComponentID'] ?>"><?php echo $row['Component'] ?></option>
<?php endforeach; ?>
</select>

	
<p>Product Name:<br>
<input name="productname" type="text" id="productname" size="40" maxlength="70">
<br>
 </p>
<p>Weight per Square Cm (linear for headboards):<br>
<input name="weight" type="text" id="weight" size="40" maxlength="20"> </p>
<p>Harmonised Tariff Code:<br>
<input name="tariff" type="text" id="tariff" size="40" maxlength="20">
</p>
<p>Depth of Product (cms):<br>
<input name="depth" type="text" id="depth" size="40" maxlength="20">
              </p>
			  <p>
			    <input type="submit" name="addproduct" id="addproduct" value="Add Product">
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