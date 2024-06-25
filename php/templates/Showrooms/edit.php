<?php use Cake\Routing\Router; ?>

<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/ckeditor/lang/_languages.js"></script>
<script src="/ckeditor/_samples/sample.js" type="text/javascript"></script>
<link href="/ckeditor/_samples/sample.css" rel="stylesheet" type="text/css" />

<div id="brochureform" class="brochure">

<h1><?php echo $row['adminheading']; ?> Showroom Bank Information</h1>
<form action="/php/showrooms/edit" method="post" name="form1" >	
<input name="idlocation" type="hidden" value="<?php echo $row['idlocation']; ?>">
<div id="c1">        <p><strong></strong></p>
<p>Savoir Owned Showroom<br>
Yes:<input type="radio" name="savoirowned" id="savoirowned" value="y" <?php $this->MyForm->setChecked($row, 'SavoirOwned', 'y'); ?> />
No:<input type="radio" name="savoirowned" id="savoirowned" value="n" <?php $this->MyForm->setChecked($row, 'SavoirOwned', 'n'); ?> />
</p>
  <p>Sage Account Reference: <br>
          <input name="sageref" type="text" id="sageref" value="<?php echo $row['SageRef']; ?>" size="30" maxlength="100">
<br>
          <br>
Bank Account Name:<br>
<input name="bankacname" type="text" id="bankacname" value="<?php echo $row['BankAcName']; ?>" size="30" maxlength="100">
<br>
<br>
Bank Account Number: <br>
<input name="bankacno" type="text" id="bankacno" value="<?php echo $row['BankAcNo']; ?>" size="30" maxlength="60">
<br>
<br>
Bank Routing Number: <br>
<input name="bankroutingno" type="text" id="bankroutingno" value="<?php echo $row['BankRoutingNo']; ?>" size="30" maxlength="60">
<br>
<br>
Bank Sort Code: <br>
<input name="banksortcode" type="text" id="banksortcode" value="<?php echo $row['BankSortCode']; ?>" size="30" maxlength="50">
<br>
<br>
Bank Name: <br>
<input name="bankname" type="text" id="bankname" value="<?php echo $row['BankName']; ?>" size="30" maxlength="100">
<br>
<br>
Bank Address: <br>
<input name="bankaddress" type="text" id="bankaddress" value="<?php echo $row['BankAddress']; ?>" size="30" maxlength="255">
<br>
<br>
IBAN: <br>
<input name="iban" type="text" id="iban" value="<?php echo $row['IBAN']; ?>" size="30" maxlength="50">
<br>
<br>
SWIFT: <br>
<input name="swift" type="text" id="swift" value="<?php echo $row['SWIFT']; ?>" size="30" maxlength="100">
<br></p>
<p><strong>Showroom Invoice Information</strong></p>
<p>Payment Terms (days): <br>
<input name="paymentterms" type="text" id="paymentterms" value="<?php echo $row['PaymentTerms']; ?>" size="10" maxlength="3">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="radio" name="termsvalid" id="termsvalid" value="y" <?php $this->MyForm->setChecked($row, 'TermsEnabled', 'y'); ?> > Enable
<input type="radio" name="termsvalid" id="termsvalid" value="n" <?php $this->MyForm->setChecked($row, 'TermsEnabled', 'n'); ?> > Disable
</p>
<p>Invoice Notes: <br>
          1.
          <input name="invoicenote1" type="text" id="invoicenote1" value="<?php echo $row['InvoiceNote1']; ?>" size="40" maxlength="150">
          <a href="javascript:clearinvoicenote(1)">X</a><br>
          2.
          
          <input name="invoicenote2" type="text" id="invoicenote2" value="<?php echo $row['InvoiceNote2']; ?>" size="40"> <a href="javascript:clearinvoicenote(2)">X</a>
          <br>
		  3.
		  <input name="invoicenote3" type="text" id="invoicenote3" value="<?php echo $row['InvoiceNote3']; ?>" size="40"> <a href="javascript:clearinvoicenote(3)">X</a>
		  <br>
4.
<input name="invoicenote4" type="text" id="invoicenote4" value="<?php echo $row['InvoiceNote4']; ?>" size="40"> <a href="javascript:clearinvoicenote(4)">X</a>
<br>
5.
  <input name="invoicenote5" type="text" id="invoicenote5" value="<?php echo $row['InvoiceNote5']; ?>" size="40"> <a href="javascript:clearinvoicenote(5)">X</a>
	    <br>
	    6.
        <input name="invoicenote6" type="text" id="invoicenote6" value="<?php echo $row['InvoiceNote6']; ?>" size="40"> <a href="javascript:clearinvoicenote(6)">X</a>
        </p>
<p><strong>Showroom Invoice Address</strong></p>
<p>Invoice Company Name: <br>
<input name="invoiceconame" type="text" id="invoiceconame" value="<?php echo $row['InvoiceCoName']; ?>" size="40" maxlength="150">
<br>
<br>Line 1: <br>
<input name="invoiceadd1" type="text" id="invoiceadd1" value="<?php echo $row['InvoiceAdd1']; ?>" size="40" maxlength="150">
<br>
<br>
Line 2:<br>
<input name="invoiceadd2" type="text" id="invoiceadd2" value="<?php echo $row['InvoiceAdd2']; ?>" size="40" maxlength="150">
<br>
<br>
Line 3: <br>
<input name="invoiceadd3" type="text" id="invoiceadd3" value="<?php echo $row['InvoiceAdd3']; ?>" size="40" maxlength="150">
<br>
<br>
Town: <br>
<input name="invoicetown" type="text" id="invoicetown" value="<?php echo $row['InvoiceTown']; ?>" size="40" maxlength="150">
<br>
<br>
Country: <br>
<input name="invoicecountry" type="text" id="invoicecountry" value="<?php echo $row['InvoiceCountry']; ?>" size="40" maxlength="150">
<br>
<br>
Postcode: <br>
<input name="invoicepostcode" type="text" id="invoicepostcode" value="<?php echo $row['InvoicePostcode']; ?>" size="40" maxlength="150">
        </p>
<p>&nbsp;</p>
</div>
<div id="c2">
<p><strong>Amend Showroom Address</strong> </p>
<p>Line 1: <br>
<input name="add1" type="text" id="add1" value="<?php echo $row['add1']; ?>" size="30">
    <br>
    <br>
    Line 2:<br>
  <input name="add2" type="text" id="add2" value="<?php echo $row['add2']; ?>" size="30">
  <br>
  <br>
    Line 3: <br>
  <input name="add3" type="text" id="add3" value="<?php echo $row['add3']; ?>" size="30">
  <br>
  <br>
    Town: <br>
  <input name="town" type="text" id="town" value="<?php echo $row['town']; ?>" size="30">
  <br>
  <br>
    County/State: <br>
  <input name="county" type="text" id="county" value="<?php echo $row['countystate']; ?>" size="30">
  <br>
  <br>
    Postcode: <br>
  <input name="postcode" type="text" id="postcode" value="<?php echo $row['postcode']; ?>" size="30">
  <strong><br>
    <br>
  </strong></p>
  <p>Phone:
          <br>
          <input name="tel" type="text" id="tel" value="<?php echo $row['tel']; ?>" size="30">
          
          <br>
          <br>
          Fax:</p>
<p>
  <input name="fax" type="text" id="fax" value="<?php echo $row['fax']; ?>" size="30">
</p>
<p>Email:<br>
  <input name="email" type="text" id="email" value="<?php echo $row['email']; ?>" size="30">
</p>

</div>
<div class="clear"></div>
	      <input type="submit" name="submit" value="Update Showroom"  id="submit" class="button" />
        </p>
        
	</form>

</div>

<script Language="JavaScript" type="text/javascript">
function IsNumeric(sText)
	{
	   var ValidChars = "0123456789.";
	   var IsNumber=true;
	   var Char;
	
	 
	   for (i = 0; i < sText.length && IsNumber == true; i++) 
		  { 
		  Char = sText.charAt(i); 
		  if (ValidChars.indexOf(Char) == -1) 
			 {
			 IsNumber = false;
			 }
		  }
	   return IsNumber;
	   
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

function clearinvoicenote(n) {
	$('#invoicenote'+n).val('');
} 
</script>  