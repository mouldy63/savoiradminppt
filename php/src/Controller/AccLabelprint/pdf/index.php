<div><?=$header?></div>
<div style="border: 1px solid black;position:relative; top:100px; padding:20px;">
   <p align="left" style="font-size:16px;margin-top:20px;">This box contains:</p>
   <p><?=$accitems?></p>
   <p>Customer: <?=$customername?><br>
   <?php if ($company !='') { ?>
      Company: <?=$company?><br>
   <?php } ?>
   Order Number: <?=$ordernumber?>
	</div>
