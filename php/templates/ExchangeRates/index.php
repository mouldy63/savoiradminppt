<?php use Cake\Routing\Router; ?>
<?php
$now = date('d-m-Y');
$currentyear = date("Y",strtotime($now));
?>
<div id="brochureform" class="brochure">
<br><br>
<button style='margin-left:15px' type="button" onclick="monthlysales();">Sales Figures Monthly</button>
<button type="button" onclick="yearlysales();">Sales Figures Yearly</button>
<button type="button" onclick="swapToSalesTargets();">Sales Targets</button>
<br><br>
<h1>Exchange Rates</h1>
<br><br>
<div style='max-width:500px; margin-left:15px;'>
<form action="/php/ExchangeRates/edit" onsubmit="return confirmAction()" method="post" name="form1" >	

<table width="50%" style='border-collapse: collapse; border-spacing: 13px;  padding:12px; font-size:12px;' id="myExTable">
<tr style="border: 1px solid black; border-collapse: collapse;"><td>
<select name='year' id='year'>
			<?php for ($i = $currentyear; $i > 2012; $i--) { ?>
			<option value='<?=$i?>' <?php if ($year == $i) echo 'selected';?> ><?=$i?></option>
			<?php } ?>
		</select></td>
		<td align='center'>USD</td>
		<td align='center'>EUR</td></tr>
<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;">JANUARY</td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="USD1" type="text" id="USD1" value="<?= $rates['USD'][1] ?>" size="10" maxlength="10"></td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="EUR1" type="text" id="EUR1" value="<?= $rates['EUR'][1] ?>" size="10" maxlength="10"></td>
</tr>

<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;">FEBRUARY</td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="USD2" type="text" id="USD2" value="<?= $rates['USD'][2] ?>" size="10" maxlength="10"></td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="EUR2" type="text" id="EUR2" value="<?= $rates['EUR'][2] ?>" size="10" maxlength="10"></td>
</tr>

<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;">MARCH</td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="USD3" type="text" id="USD3" value="<?= $rates['USD'][3] ?>" size="10" maxlength="10"></td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="EUR3" type="text" id="EUR3" value="<?= $rates['EUR'][3] ?>" size="10" maxlength="10"></td>
</tr>

<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;">APRIL</td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="USD4" type="text" id="USD4" value="<?= $rates['USD'][4] ?>" size="10" maxlength="10"></td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="EUR4" type="text" id="EUR4" value="<?= $rates['EUR'][4] ?>" size="10" maxlength="10"></td>
</tr>

<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;">MAY</td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="USD5" type="text" id="USD5" value="<?= $rates['USD'][5] ?>" size="10" maxlength="10"></td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="EUR5" type="text" id="EUR5" value="<?= $rates['EUR'][5] ?>" size="10" maxlength="10"></td>
</tr>

<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;">JUNE</td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="USD6" type="text" id="USD6" value="<?= $rates['USD'][6] ?>" size="10" maxlength="10"></td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="EUR6" type="text" id="EUR6" value="<?= $rates['EUR'][6] ?>" size="10" maxlength="10"></td>
</tr>

<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;">JULY</td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="USD7" type="text" id="USD7" value="<?= $rates['USD'][7] ?>" size="10" maxlength="10"></td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="EUR7" type="text" id="EUR7" value="<?= $rates['EUR'][7] ?>" size="10" maxlength="10"></td>
</tr>

<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;">AUGUST</td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="USD8" type="text" id="USD8" value="<?= $rates['USD'][8] ?>" size="10" maxlength="10"></td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="EUR8" type="text" id="EUR8" value="<?= $rates['EUR'][8] ?>" size="10" maxlength="10"></td>
</tr>

<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;">SEPTEMBER</td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="USD9" type="text" id="USD9" value="<?= $rates['USD'][9] ?>" size="10" maxlength="10"></td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="EUR9" type="text" id="EUR9" value="<?= $rates['EUR'][9] ?>" size="10" maxlength="10"></td>
</tr>

<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;">OCTOBER</td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="USD10" type="text" id="USD10" value="<?= $rates['USD'][10] ?>" size="10" maxlength="10"></td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="EUR10" type="text" id="EUR10" value="<?= $rates['EUR'][10] ?>" size="10" maxlength="10"></td>
</tr>

<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;">NOVEMBER</td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="USD11" type="text" id="USD11" value="<?= $rates['USD'][11] ?>" size="10" maxlength="10"></td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="EUR11" type="text" id="EUR11" value="<?= $rates['EUR'][11] ?>" size="10" maxlength="10"></td>
</tr>

<tr style="border: 1px solid black; border-collapse: collapse; border-spacing: 13px;">
<td style="border: 1px solid black; border-collapse: collapse; text-align:left; border-spacing: 13px;">DECEMBER</td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="USD12" type="text" id="USD12" value="<?= $rates['USD'][12] ?>" size="10" maxlength="10"></td>
<td style="border: 1px solid black; border-collapse: collapse; text-align:right; border-spacing: 13px;">
<input name="EUR12" type="text" id="EUR12" value="<?= $rates['EUR'][12] ?>" size="10" maxlength="10"></td>
</tr>

</table>
<br><br>
<input type="submit" name="submit"  value="Update Exchange Rates"  id="submit" class="button" />
</form>
</div>
</div>

<script Language="JavaScript" type="text/javascript">
$(document).ready( function () {
    
    $('#year').on('change', function () {
          var year = $(this).val(); // get selected value
          console.log(year);
          if (year) { // require a URL
              window.location = '/php/ExchangeRates?year='+year; // redirect
          }
          return false;
      });
} );

function monthlysales() {
		window.location = '/php/NewSalesFigures/monthly';
	}
function yearlysales() {
		window.location = '/php/NewSalesFigures/yearly';
	}
function swapToSalesTargets() {
		window.location = '/php/SalesTargets?year=<?=$year?>';
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
            if (confirm('You are about to update the exchange rates')) {
                return true;
            } else {
                return false;
            }
        }


</script>  