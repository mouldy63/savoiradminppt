<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure">
<h1>Edit Showroom Data</h1>


<form action="showrooms/edit" method="post" name="form1">
      <p>
<select name="showroom" id="showroom">
<option value="n"> Choose Showroom:  </option>
<?php foreach ($activeshowrooms as $row): ?>               
<option value="<?php echo $row['idlocation'] ?>"><?php echo $row['adminheading'] ?></option>
<?php endforeach; ?>
</select>

<input type="submit" name="submit1" value="Edit"  id="submit1" class="button" />
</p>
    </form>
    
    

</div>