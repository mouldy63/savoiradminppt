<div><?=$header?></div>
<div style="border: 1px solid black;position:relative; top:60px; height:600px; padding:20px;" align="center">
   <p align="left" style="font-size:16px;margin-top:20px;">This box contains:</p>
   <p align="left" style="font-size:28px; margin-left:20px;"><?=$accitems?></p>
   <table  style="width:100%; position:absolute; bottom:208px; left:10px;">
      <tr><td style="width:490px;" valign="bottom">
   <p style="font-size:28px; margin-right:15px; line-height:36px;">Customer:<span style="position:relative; margin-left:99px;"> <?=$customername?></span><br>
   <?php if ($company !='') { ?>
      Company: <span style="position:relative; margin-left:100px;"><?=$company?></span><br>
   <?php } ?>
   Order Number: <span style="position:relative; margin-left:41px;"><?=$ordernumber?></span><br><br>
	</p></td>
   <td valign="top" style="width:190px;"><?=$qrcode?></td>
   <td valign="top"><p align="center" style="width:280px; height:58px; border: 1px solid black;position:relative; padding:20px; font-size:28px; padding-top:90px; margin-top:12px;">Box ____ / ____ </p> </span></td></tr>
   </table>
</div>
