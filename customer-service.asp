<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->

<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, customerasc, orderasc, showr,  companyasc, bookeddate, previousOrderNumber, acknowDateWarning, csnumber, completedby, deliverdon, problemdesc, showroom, userid, username
problemdesc=request("problemdesc")
deliverdon=request("deliverdon")
completedby=request("completedby")
csnumber=request("csnumber")
count=0
Set Con = getMysqlConnection()
Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveUserlocation(), con)
showroom=rs("adminheading")
rs.close
set rs=nothing
Set rs = getMysqlQueryRecordSet("Select * from savoir_user where username like '" & retrieveUserName() & "'", con)
username=rs("username")
userid=rs("user_id")
rs.close
set rs=nothing
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>

<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>

<script>
$(function() {
var year = new Date().getFullYear();
$( "#firstaware" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true

});
$( "#firstaware" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#deliverdon" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true
});
$( "#deliverdon" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#actiondate" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true
});
$( "#actiondate" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});
</script>
</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
<h1>Customer Service form - Customer Service Date <%=date()%></h1>
<form METHOD="POST" name="form1" ENCTYPE="multipart/form-data" ACTION="customer-service-update.asp" onSubmit="return FrontPage_Form1_Validator(this)">
<table width="90%" border="0" cellpadding="4" align="center">
<tr>
<td width="24%" valign="top">Customer Service Number</td>
<td width="13%" valign="top"><input name="csnumber" type="text" id="csnumber" tabindex="1" value="<%=getNextCustomerServiceNumber(con)%>" size="10" readonly></td>
<td width="31%" valign="top">Showroom</td>
<td width="32%" valign="top"><%=showroom%>
<input name="showroom" type="hidden" id="showroom" value="<%=showroom%>" readonly></td>
</tr>
<tr>
<td valign="top">Form Completed by:</td>
<td valign="top"><label for="completedby"></label>
<%=username%>
<input type="hidden" name="completedby" id="completedby" value="<%=userid%>">
<input type="hidden" name="completedbyname" id="completedbyname" value="<%=username%>"></td>
<td valign="top">Customer Name:</td>
<td valign="top"><label for="custname"></label>
<input type="text" name="custname" id="custname"  tabindex="10" ></td>
</tr>
<tr>
<td valign="top">Date item delivered to Customer</td>
<td valign="top"><input name="deliverdon" type="text" id="deliverdon" tabindex="2" size="10" readonly>
</td>
<td valign="top">*Order Number</td>
<td valign="top"><input name="orderno" type="text" id="orderno" tabindex="11" size="10"></td>
</tr>
<tr>
<td rowspan="2" valign="top">*Item Description<br>
<br>
(for example No2 Mattress, HW Topper)</p></td>
<td rowspan="2" valign="top"><textarea name="itemdesc" cols="30" rows="6" id="itemdesc" tabindex="3"></textarea></td>
<td valign="top">*Date customer first made you aware of the problem</td>
<td valign="top"><input name="firstaware" type="text" id="firstaware" tabindex="12" size="10" readonly>
</td>
</tr>
<tr>
<td valign="top">Please email video with sound if the item is making noises which are the problem. MAX FILE SIZE 3mb</td>
<td valign="top"><input name="video" type="file" id="video" ></td>
</tr>
<tr>
<td valign="top">*Please describe the problem with the product</td>
<td valign="top"><textarea name="problemdesc" cols="30" rows="6" id="problemdesc" tabindex="4"></textarea></td>
<td valign="top">Please let us know what you feel the solution to the problem is:</td>
<td valign="top"><textarea name="solution" cols="30" rows="6" id="solution" tabindex="15"></textarea></td>
</tr>
<tr>
<td rowspan="3" valign="top">Please email photographs of beds which are relevant<br>
<br>
MAX FILE SIZE 3mb</td>
<td rowspan="3" valign="top"><label for="photos"></label>
<input name="photos" type="file" id="photos" >
<input type="file" name="photos" id="photos" >
<input type="file" name="photos" id="photos" >
<input type="file" name="photos" id="photos" >
<input type="file" name="photos" id="photos" >
<input type="file" name="photos" id="photos" ></td>
<td valign="top">What action have you already taken about this problem:</td>
<td valign="top"><textarea name="actiontaken" cols="30" rows="6" id="actiontaken" tabindex="16"></textarea></td>
</tr>
<tr>
<td valign="top">What date was this visit/ action:</td>
<td valign="top"><input name="actiondate" type="text" id="actiondate" tabindex="17" size="10" readonly></td>
</tr>
<tr>
<td valign="top">Any other comments:
<p>&nbsp;</p></td>
<td><label for="anycomments"></label>
<textarea name="anycomments" id="anycomments" cols="30" rows="6" tabindex="18" ></textarea></td>
</tr>
<tr>
<td valign="top">* Required fields</td>
<td valign="top">&nbsp;</td>
<td colspan="2">&nbsp;</td>
</tr>
<tr>
<td colspan="4" align="right"><input name="submitcs" type="submit" id="submitcs" tabindex="40" value="Submit"></td>
</tr>
</table>
</form>
<p>&nbsp;</p>
<!--</form>-->
</div>
</div>
<div>
</div>

</body>
</html>
<%con.close
set con=nothing%>
<script Language="JavaScript" type="text/javascript">
<!--
function IsNumeric(sText)
{
var ValidChars = "0123456789";
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

if (theForm.problemdesc.value == "")
{
alert("Please enter description of the problem");
theForm.problemdesc.focus();
return (false);
}
if (theForm.orderno.value == "")
{
alert("Please enter order number");
theForm.orderno.focus();
return (false);
}
if (!IsNumeric(theForm.orderno.value))
{
alert('Please enter only numbers for order number')
theForm.orderno.focus();
return false;
}



if (theForm.itemdesc.value == "")
{
alert("Please enter item description");
theForm.itemdesc.focus();
return (false);
}
if (theForm.firstaware.value == "")
{
alert("Please enter date customer first made you aware");
theForm.firstaware.focus();
return (false);
}

return true;
}

	
//-->
</script>
<!-- #include file="common/logger-out.inc" -->
