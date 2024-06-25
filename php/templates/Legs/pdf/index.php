<div id="x1">
    <span style="font-size:14px;font-weight:bold;">CARPENTRY</span><br><br>
    <span style="font-size:14px;font-weight:bold;">Week:</span>
    <br><br><span style="font-size:95px;font-weight:400;"><?= $carpentryweekno ?></span>
</div>
<div id="x2">
    <h1 align="center" style="font-size:20px;font-weight:400;"><?= $legstyle ?></h1>
   
</div>
<div id="x3">
    <span style="font-size:14px;font-weight:bold;">FINISHING</span><BR><BR>
    <span style="font-size:14px;font-weight:bold;">Week:</span>
    <br><br><span style="font-size:95px;font-weight:400;"><?= $finishedweekno ?></span>
</div>
<div class="clear">&nbsp;</div>
<hr>

<div id="Lx1"><?= $legdetails ?></div>
<div id="Lx2">
<table width="100%" border="0" cellspacing="0" cellpadding="3">
<tr><td>Order No:<br><br></td><td><span style="font-size:22px;"><?= $ordernumber ?><br><br></span></td></tr>
<tr><td>Customer:<br><br></td><td><?= $customername ?><br><br></td></tr>
<?php if ($customerreference != '') { ?>
<tr><td>Customer Ref:<br><br></td><td><?= $customerreference ?><br><br></td></tr>
<?php } ?>
<tr><td>Source:<br><br></td><td><?= $showroomaddress ?><br><br></td></tr>
</table>
</div>
<div class="clear">&nbsp;</div>
<div align="center"><?= $legimage ?></div>