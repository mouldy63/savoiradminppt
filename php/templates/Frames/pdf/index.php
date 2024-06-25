<div id="x1">
    <span style="font-size:14px;font-weight:bold;">CARPENTRY</span><br><br>
    <span style="font-size:14px;font-weight:bold;">Week:</span>
    <br><br><span style="font-size:95px;font-weight:400;"><?= $carpentryweekno ?></span>
</div>
<div id="x2">
    <h1 align="center" style="font-size:20px;font-weight:400;">Divan / Box Frames</h1>
    <table align="center" style="font-size:12px; line-height:20px;">
    <tr style='line-height:14px;'><td>Order No:</td><td style="font-size:16px;"><b><?= $ordernumber ?></b></td></tr>
    <tr style='line-height:14px;'><td>Customer:</td><td style="font-size:14px;"><?= $customername ?></td></tr>
    <?php if ($customerreference != '') { ?>
    <tr style='line-height:14px;'><td>Customer Ref:</td><td><?= $customerreference ?></td></tr>
    <?php } ?>
    <tr style='line-height:14px;'><td>Order Source:</td><td><?= $showroomaddress ?></td></tr>
    <tr><td><?= $qrcode ?></td></tr>
    </table>
</div>
<div id="x3">
    <span style="font-size:14px;font-weight:bold;">FINISHING</span><BR><BR>
    <span style="font-size:14px;font-weight:bold;">Week:</span>
    <br><br><span style="font-size:95px;font-weight:400;"><?= $finishedweekno ?></span>
</div>
<div class="clear">&nbsp;</div>
<hr>

<div id="fx1"><?= $basedetails ?></div>
<div id="fx2" style="margin-top:13px;position:relative;margin-left:-60px;"><?= $basedetails2 ?><?= $legspecialinstructions ?>
<div id="bottom">

<b>Production Hours Used:</b><br><br><b>Frame:..........................  Finish:..........................</b></div>
</div>

<div class="clear">&nbsp;</div>

<div id="fx3">
<table width="100%">
<tr>
<td width="55%">Progress Check<br><br></td>
<td align="center">Final Check<br><br></td>
<td></td>
<td></td>
</tr>
<tr>
<td class="border_right" style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">Size Checked? <div class="square" style="float:right;margin-right:5px;"> </div></td>
<td align="center" style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;"><div class="squarecenter"> </div></td>
<td></td>
<td style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">Size Checked? <div class="square" style="float:right;margin-right:5px;"> </div></td>
</tr>

<tr>
<td class="border_right" style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">Depth of Frame <div class="square" style="float:right;margin-right:5px;"> </div></td>
<td align="center" style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;"><div class="squarecenter"> </div></td>
<td></td>
<td style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">Ticking Correct? <div class="square" style="float:right;margin-right:5px;"> </div></td>
</tr>

<tr>
<td class="border_right" style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">T-Nuts for H/Board <div class="square" style="float:right;margin-right:5px;"> </div></td>
<td align="center" style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;"><div class="squarecenter"> </div></td>
<td></td>
<td style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">Labels Checked? <div class="square" style="float:right;margin-right:5px;"> </div></td>
</tr>

<tr>
<td class="border_right" style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">T-Nuts for Legs <div class="square" style="float:right;margin-right:5px;"> </div></td>
<td align="center" style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;"><div class="squarecenter"> </div></td>
<td></td>
<td style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">Labels in Correct Place? <div class="square" style="float:right;margin-right:5px;"> </div></td>
</tr>

<tr>
<td class="border_right" style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">T-Nuts for Link Bars <div class="square" style="float:right;margin-right:5px;"> </div></td>
<td align="center" style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;"><div class="squarecenter"> </div></td>
<td></td>
<td style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">Vents Checked? <div class="square" style="float:right;margin-right:5px;"> </div></td>
</tr>

<tr>
<td class="border_right" style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">Check for Edge Knots <div class="square" style="float:right;margin-right:5px;"> </div></td>
<td align="center" style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;"><div class="squarecenter"> </div></td>
<td></td>
<td style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">Legs Marked? <div class="square" style="float:right;margin-right:5px;"> </div></td>
</tr>
<tr>
<td rowspan="4" class="border_right" style="padding-top:5px;"> Checked by (name): <br><br>
...............................<br><br>
Date:</td>
<td align="center"></td>
<td></td>
<td style="border-bottom-style:solid;border-bottom-width: 1px;padding-bottom:4px;">Link Bar Position? <div class="square" style="float:right;margin-right:5px;"> </div></td>
</tr>

<tr>
<td></td>
<td></td>
<td align="left" style="padding-top:20px;">Checked by (name): <br><br>
...............................<br><br>
Date:</td>
</tr>

</table></div>

