<?php use Cake\Routing\Router; ?>

<div id="brochureform" class="brochure">
<h1>Correspondence Section</h1>
<p>NB: If updating brochure request section - please EDIT original rather than Add New Correspondence</p>
<p>
            <a href="/php/correspondence/add"><button>Add New Correspondence</button></a>
      </p>
<form action="correspondence/edit" method="post" name="form1">
      <p>
<select name="correspondence" id="correspondence">
<option value="n"> Choose Correspondence:  </option>
<?php foreach ($correspondence as $row): ?>               
<option value="<?php echo $row['correspondenceid'] ?>"><?php echo $row['correspondencename'] ?> - <?php echo $row['location'] ?></option>
<?php endforeach; ?>
</select>

<input type="submit" name="submit1" value="Edit"  id="submit1" class="button" />
</p>
    </form>
    
    

</div>