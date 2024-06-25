<div id="x1">
    <span style="font-size:14px;font-weight:bold;">CUTTING & SEWING</span><br><br>
    <span style="font-size:14px;font-weight:bold;">Week:</span>
    <br><br><span style="font-size:95px;font-weight:400;"><?= $cuttingweekno ?></span>
</div>
<div id="x2">
    <h1 align="center" style="font-size:20px;font-weight:400;">Cases</h1>
    <table align="center" style="font-size:12px; line-height:18px;">
    <tr><td>Order No:</td><td style="font-size:14px;"><b><?= $ordernumber ?></b></td></tr>
    <tr><td>Customer:</td><td><?= $customername ?></td></tr>
    <tr><td>Customer Ref:</td><td><?= $customerreference ?></td></tr>
    <tr><td>Order Source:</td><td><?= $showroomaddress ?></td></tr>
    <tr><td>Wrap:</td><td><?= $wraptype ?></td></tr>
    <tr><td>Fire Label:</td><td><?= $firelabelname ?></td></tr>
    </table>
</div>
<div id="x3">
    <span style="font-size:14px;font-weight:bold;">FINISHING</span><BR><BR>
    <span style="font-size:14px;font-weight:bold;">Week:</span>
    <br><br><span style="font-size:95px;font-weight:400;"><?= $finishedweekno ?></span>
</div>
<div class="clear">&nbsp;</div>
<hr>
<div class="xx1" style="line-height"><?= $mattressdetails ?></div>
<div class="xx2" style="margin-top:33px;position:relative;margin-left:-60px;"><?= $mattressdetails2 ?></div>
<?php if ($mattressrequired=='' && $mattressmadeelsewhere=='') { ?>
<div class="xx3"><table width="100%">
<tr><td width="55%">Progress Check</td><td align="center">Final Check</td></tr>
<tr class="border_bottom"><td class="border_right">Size Checked? <div class="square" style="float:right;margin-right:5px;"> </div></td><td align="center"><div class="squarecenter"> </div></td></tr>

<tr class="border_bottom"><td class="border_right">Ticking Correct? <div class="square" style="float:right;margin-right:5px;"> </div></td><td align="center"><div class="squarecenter"> </div></td></tr>

<tr class="border_bottom"><td class="border_right">Labels Checked? <div class="square" style="float:right;margin-right:5px;"> </div></td><td align="center"><div class="squarecenter"> </div></td></tr>

<tr class="border_bottom"><td class="border_right">Labels in Correct Place? <div class="square" style="float:right;margin-right:5px;"> </div></td><td align="center"><div class="squarecenter"> </div></td></tr>

<tr class="border_bottom"><td class="border_right">Vents Checked? <div class="square" style="float:right;margin-right:5px;"> </div></td><td align="center"><div class="squarecenter"> </div></td></tr>

<tr><td class="border_right" style="padding-top:20px;">Checked by (name): <br><br>
...............................<br><br>
Date:</td><td align="left" style="padding-top:20px; padding-left:10px;">Checked by (name): <br><br>
...............................<br><br>
Date:</td></tr>
</table></div>
<?php } ?>
<div class="clear"></div>
<hr>

<div class="xx1"><?= $topperdetails ?></div>
<div class="xx2" style="margin-top:13px;position:relative;margin-left:-60px;"><?= $topperdetails2 ?></div>
<?php if ($topperrequired=='' && $toppermadeelsewhere=='') { ?>
<div class="xx3"><table width="100%">
<tr><td width="55%">Progress Check</td><td align="center">Final Check</td></tr>
<tr class="border_bottom"><td class="border_right">Size Checked? <div class="square" style="float:right;margin-right:5px;"> </div></td><td align="center"><div class="squarecenter"> </div></td></tr>

<tr class="border_bottom"><td class="border_right">Ticking Correct? <div class="square" style="float:right;margin-right:5px;"> </div></td><td align="center"><div class="squarecenter"> </div></td></tr>

<tr class="border_bottom"><td class="border_right">Labels Checked? <div class="square" style="float:right;margin-right:5px;"> </div></td><td align="center"><div class="squarecenter"> </div></td></tr>

<tr class="border_bottom"><td class="border_right">Labels in Correct Place? <div class="square" style="float:right;margin-right:5px;"> </div></td><td align="center"><div class="squarecenter"> </div></td></tr>

<tr><td class="border_right" style="padding-top:0px;">Checked by (name): <br><br>
...............................<br><br>
Date:</td><td align="left" style="padding-top:20px; padding-left:10px;">Care Card? ............ <br><br>Checked by (name): <br><br>
...............................<br><br>
Date:</td></tr>
</table></div>
<?php } ?>
<div class="clear"></div>
<hr>

<div class="xx1"><?= $basedetails ?></div>
<div class="xxx2" style="margin-top:13px;position:relative;margin-left:-60px;"><?= $basedetails2 ?></div>
<?php if ($baserequired=='' && $basemadeelsewhere=='') { ?>
<div class="xxx3"><table width="100%">
<tr class="border_bottom"><td>Size Checked? <div class="square" style="float:right;margin-right:5px;"> </div></td></tr>

<tr class="border_bottom"><td>Ticking Correct? <div class="square" style="float:right;margin-right:5px;"> </div></td></tr>

<tr class="border_bottom"><td>Labels Checked? <div class="square" style="float:right;margin-right:5px;"> </div></td></td></tr>

<tr class="border_bottom"><td>Labels in Correct Place? <div class="square" style="float:right;margin-right:5px;"> </div></td></tr>

<tr><td style="padding-top:0px;">Checked by (name): <br><br>
...............................<br><br>
Date:</td><</tr>
</table></div>
<?php } ?>
