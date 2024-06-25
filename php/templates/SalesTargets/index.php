<?php use Cake\Routing\Router; ?>
<?php
$now = date('d-m-Y');
$currentyear = date("Y",strtotime($now))+1;
?>
<div id="brochureform" class="brochure">
<br><br>
<button style='margin-left:15px' type="button" onclick="monthlysales();">Sales Figures Monthly</button>
<button type="button" onclick="yearlysales();">Sales Figures Yearly</button>
<button type="button" onclick="swapToExchangeRates();">Exchange Rates</button>
<br><br>
<h1>Sales Targets</h1>
<br><br>
<div style='max-width:700px; margin-left:15px;'>
<form action="/php/SalesTargets/edit" onsubmit="return confirmAction()" method="post" name="form1" >	

<table width="50%" style='border-collapse: collapse; border-spacing: 13px;  padding:12px; font-size:11px;' id="myExTable">
<tr style="border: 1px solid black; border-collapse: collapse;">
	<td>Target <select name='year' id='year'>
		<?php for ($i = $currentyear; $i > 2012; $i--) { ?>
		<option value='<?=$i?>' <?php if ($year == $i) echo 'selected';?> ><?=$i?></option>
		<?php } ?>
	</select>
	</td>
	
</tr>
<tr height="30px"><td>Showrooms</td>
<td align='center'>Jan</td>
	<td align='center'>Feb</td>
	<td align='center'>Mar</td>
	<td align='center'>Apr</td>
	<td align='center'>May</td>
	<td align='center'>Jun</td>
	<td align='center'>Jul</td>
	<td align='center'>Aug</td>
	<td align='center'>Sep</td>
	<td align='center'>Oct</td>
	<td align='center'>Nov</td>
	<td align='center'>Dec</td>
	</tr>
 <?php foreach ($showroomTargets as $row): ?>
<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="white-space: nowrap; border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;"><?= $row['name'] ?> (<?= $row['currency'] ?>)</td>

<?php
for ($i = 1; $i < 13; $i++) { ?>
<td>
<?php 
if (isset($row['targets'][$i]['sale_figure_target_id'])) { ?>
<input style="text-align:right; font-size:11px;" name="T_<?= $row['idlocation'] ?>_<?= $i ?>" type="text" value="<?php 
echo $this->MyForm->formatMoney($row['targets'][$i]['target_amount']); ?>"  size="10" maxlength="10"  >
<?php  
} else { 
?>
<input style="text-align:right; font-size:11px;" name="T_<?= $row['idlocation'] ?>_<?= $i ?>" type="text" value="0.00" size="10" maxlength="10"  >
<? } 
} ?>
</td></tr>
<?php endforeach; ?>
<tr height="30px"><td>Dealers</td><td align='center'>Jan</td>
	<td align='center'>Feb</td>
	<td align='center'>Mar</td>
	<td align='center'>Apr</td>
	<td align='center'>May</td>
	<td align='center'>Jun</td>
	<td align='center'>Jul</td>
	<td align='center'>Aug</td>
	<td align='center'>Sep</td>
	<td align='center'>Oct</td>
	<td align='center'>Nov</td>
	<td align='center'>Dec</td>
	</tr>
 <?php foreach ($dealerTargets as $row): ?>
<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="white-space: nowrap; border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;"><?= $row['name'] ?> (<?= $row['currency'] ?>)</td>
<?php
for ($i = 1; $i < 13; $i++) { ?>
<td>
<?php 
if (isset($row['targets'][$i]['sale_figure_target_id'])) { ?>
<input style="text-align:right; font-size:11px;" name="T_<?= $row['idlocation'] ?>_<?= $i ?>" type="text" value="<?php 
echo $this->MyForm->formatMoney($row['targets'][$i]['target_amount']); ?>"  size="10" maxlength="10"  >
<?php  
} else { 
?>
<input style="text-align:right; font-size:11px;" name="T_<?= $row['idlocation'] ?>_<?= $i ?>" type="text" value="0.00" size="10" maxlength="10"  >
<? } 
} ?>
</td></tr>
<?php endforeach; ?>
</table>
<br><br>
<input type="submit" name="submit"  value="Update Sales Targets"  id="submit" class="button" />
</form>
</div>
</div>

<script Language="JavaScript" type="text/javascript">
$(document).ready( function () {
    
    $('#year').on('change', function () {
          var year = $(this).val(); // get selected value
          if (year) { // require a URL
              window.location = '/php/SalesTargets?year='+year; // redirect
          }
          return false;
      });
} );

function monthlysales() {
		window.location = '/php/NewSalesFigures/monthly';
	}
function yearlysales() {
		window.location = '/php/NewSalesFigures/Yearly?year=<?=$year?>';
	}
function swapToExchangeRates() {
		window.location = '/php/exchangeRates?year=<?=$year?>';
	}
function FrontPage_Form1_Validator(theForm)
{
 if (!IsNumeric(theForm.paymentterms.value)) 
   { 
      alert('Please enter only numbers for Payment Terms') 
      theForm.paymentterms.focus();
      return false; 
      }

return true;
} 
 function confirmAction() {
            if (confirm('You are about to update the sales targets')) {
                return true;
            } else {
                return false;
            }
        }


</script>  