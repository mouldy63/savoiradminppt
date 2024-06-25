<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim Con, rs,  sql, val, moreinfo, savoirchecked
val=Request("val")

Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />


<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
	
<%
Set rs = getMysqlQueryRecordSet("Select * from showroomdata S, Location L WHERE L.idlocation=S.ShowroomLocationID and showroomlocationid=" & val, con)
%>

		<form action="update-adminstoredetail.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
<div id="c1">        <p><strong>Showroom Bank Information</strong></p>
  <p>Savoir Owned Showroom<br>
    Yes:
   <%if rs("savoirOwned")="y" then savoirchecked="checked" else savoirchecked=""%>
      <input type="radio" name="savoirowned" id="savoirowned" value="y" <%=savoirchecked%>>
      No: 
   <%if rs("savoirOwned")="" or IsNull(rs("SavoirOwned")) then savoirchecked="checked" else savoirchecked=""%>
      <input type="radio" name="savoirowned" id="savoirowned" value="" <%=savoirchecked%>>
  </p>
  <p>Sage Account Reference: <br>
          <input name="sageref" type="text" id="sageref" value="<%=rs("SageRef")%>" size="30" maxlength="100">
          <br>
          <br>
Bank Account Name:<br>
<input name="bankacname" type="text" id="bankacname" value="<%=rs("BankAcName")%>" size="30" maxlength="100">
<br>
<br>
Bank Account Number: <br>
<input name="bankacno" type="text" id="bankacno" value="<%=rs("BankAcNo")%>" size="30" maxlength="60">
<br>
<br>
Bank Routing Number: <br>
<input name="bankroutingno" type="text" id="bankroutingno" value="<%=rs("bankroutingno")%>" size="30" maxlength="60">
<br>
<br>
Bank Sort Code: <br>
<input name="banksortcode" type="text" id="banksortcode" value="<%=rs("banksortcode")%>" size="30" maxlength="50">
<br>
<br>
Bank Name: <br>
<input name="bankname" type="text" id="bankname" value="<%=rs("bankname")%>" size="30" maxlength="100">
<br>
<br>
Bank Address: <br>
<input name="bankaddress" type="text" id="bankaddress" value="<%=rs("bankaddress")%>" size="30" maxlength="255">
<br>
<br>
IBAN: <br>
<input name="iban" type="text" id="iban" value="<%=rs("iban")%>" size="30" maxlength="50">
<br>
<br>
SWIFT: <br>
<input name="swift" type="text" id="swift" value="<%=rs("swift")%>" size="30" maxlength="100">
		</p>
		<p>&nbsp;</p>
		<p><strong>Showroom Invoice Information</strong></p>
		<p>Payment Terms (days): <br>
          <input name="paymentterms" type="text" id="paymentterms" value="<%=rs("paymentterms")%>" size="10" maxlength="3">
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <%if rs("termsenabled")="y" then%>
          <input type="radio" name="termsvalid" id="enabled" value="y" checked>
          <%else%>
          <input type="radio" name="termsvalid" id="enabled" value="y" >
          <%end if%>
         
          Enable
		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 <%if rs("termsenabled")="n" then%>
          <input type="radio" name="termsvalid" id="enabled" value="n" checked>
          <%else%>
          <input type="radio" name="termsvalid" id="enabled" value="n" >
          <%end if%>
   
Disable</p>
		<p>Invoice Notes: <br>
          1.
          <input name="invoicenote1" type="text" id="invoicenote1" value="<%=rs("invoicenote1")%>" size="40" maxlength="150">
          <a href="javascript:clearinvoicenote(1)">X</a><br>
          2.
          
          <input name="invoicenote2" type="text" id="invoicenote2" value="<%=rs("invoicenote2")%>" size="40"> <a href="javascript:clearinvoicenote(2)">X</a>
          <br>
		  3.
		  <input name="invoicenote3" type="text" id="invoicenote3" value="<%=rs("invoicenote3")%>" size="40"> <a href="javascript:clearinvoicenote(3)">X</a>
		  <br>
4.
<input name="invoicenote4" type="text" id="invoicenote4" value="<%=rs("invoicenote4")%>" size="40"> <a href="javascript:clearinvoicenote(4)">X</a>
<br>
5.
  <input name="invoicenote5" type="text" id="invoicenote5" value="<%=rs("invoicenote5")%>" size="40"> <a href="javascript:clearinvoicenote(5)">X</a>
	    <br>
	    6.
        <input name="invoicenote6" type="text" id="invoicenote6" value="<%=rs("invoicenote6")%>" size="40"> <a href="javascript:clearinvoicenote(6)">X</a>
        </p>
		<p><strong>Showroom Invoice Address</strong></p>
		<p>Invoice Company Name: <br>
          <input name="invoiceconame" type="text" id="invoiceconame" value="<%=rs("invoiceconame")%>" size="40" maxlength="150">
          <br>
          <br>Line 1: <br>
          <input name="invoiceadd1" type="text" id="invoiceadd1" value="<%=rs("invoiceadd1")%>" size="40" maxlength="150">
          <br>
          <br>
Line 2:<br>
<input name="invoiceadd2" type="text" id="invoiceadd2" value="<%=rs("invoiceadd2")%>" size="40" maxlength="150">
<br>
<br>
Line 3: <br>
<input name="invoiceadd3" type="text" id="invoiceadd3" value="<%=rs("invoiceadd3")%>" size="40" maxlength="150">
<br>
<br>
Town: <br>
<input name="invoicetown" type="text" id="invoicetown" value="<%=rs("invoicetown")%>" size="40" maxlength="150">
<br>
<br>
Country: <br>
<input name="invoicecountry" type="text" id="invoicecountry" value="<%=rs("invoicecountry")%>" size="40" maxlength="150">
<br>
<br>
Postcode: <br>
<input name="invoicepostcode" type="text" id="invoicepostcode" value="<%=rs("invoicepostcode")%>" size="40" maxlength="150">
        </p>
<p>&nbsp;</p>
</div>
<%rs.close
set rs=nothing
Set rs = getMysqlQueryRecordSet("Select * from location WHERE idlocation=" & val, con)%>
<div id="c2">
  <p><strong>Amend Showroom Address</strong> </p>
  <p>Line 1: <br>
    <input name="add1" type="text" id="add1" value="<%=rs("add1")%>" size="30">
    <br>
    <br>
    Line 2:<br>
  <input name="add2" type="text" id="add2" value="<%=rs("add2")%>" size="30">
  <br>
  <br>
    Line 3: <br>
  <input name="add3" type="text" id="add3" value="<%=rs("add3")%>" size="30">
  <br>
  <br>
    Town: <br>
  <input name="town" type="text" id="town" value="<%=rs("town")%>" size="30">
  <br>
  <br>
    County/State: <br>
  <input name="county" type="text" id="county" value="<%=rs("countystate")%>" size="30">
  <br>
  <br>
    Postcode: <br>
  <input name="postcode" type="text" id="postcode" value="<%=rs("postcode")%>" size="30">
  <strong><br>
    <br>
  </strong></p>
  <p>Phone:
          <br>
          <input name="tel" type="text" id="tel" value="<%=rs("tel")%>" size="30">
          
          <br>
          <br>
          Fax:</p>
<p>
  <input name="fax" type="text" id="fax" value="<%=rs("fax")%>" size="30">
</p>
<p>Email:<br>
  <input name="email" type="text" id="email" value="<%=rs("email")%>" size="30">
</p>
<p><strong>Amend Store Times</strong></p>
<p>Days:<br>
  <input name="odays" type="text" id="odays" value="<%=rs("openingdays")%>" size="30">
  <br>
  <br>
  Time:<br>
  <input name="otime" type="text" id="otime" value="<%=rs("openingtimes")%>" size="30">
  <br>
  <br>
  <%if rs("openingmoreinfo")<>"" then moreinfo=replace(rs("openingmoreinfo"), "<br />", chr(10))%>
  Extra lines (i.e. to add further dates / times / By Appointment text etc: - NOTE to create the start of a new line which will show up on the site please press return key)</p>
<p>
  <textarea name="omoreinfo" cols="30" id="omoreinfo"><%=moreinfo%></textarea>
  <br>
  <br>
</p>
</div>
<div class="clear"></div>
        </p><input name="val" type="hidden" value="<%=val%>">
        <input type="submit" name="submit1" value="Amend Showroom details"  id="submit1" class="button" />
	</form>
<%rs.close
set rs=nothing

Con.Close
Set Con = Nothing%>       
  </div>
  </div>
<div>
</div>
       
</body>
</html>
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
<!-- #include file="common/logger-out.inc" -->
