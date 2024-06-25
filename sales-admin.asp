<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
dim orderexists, Con, rs, sql
orderexists=""
orderexists=Request("orderexists")
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">

<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>

</head>

<body>
<div class="container">
<!-- #include file="header.asp" -->
<table width="667" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr valign="top">
    <td width="647" class="maintext">
      <p>
        <%if (retrieveUserLocation()=1  or retrieveUserLocation()=27  or retrieveUserRegion >1) then%>
      </p>
      <p>SALES ADMINISTRATION </p>
      <p><a href="planned-exports.asp">Planned Export Collections</a></p>
      <p><a href="delivered-exports.asp">Delivered Shipments</a></p>
      <%end if%>
        <%if (retrieveUserLocation()=1  or retrieveUserLocation()=27) then%>
       <p><a href="cancelled-exports.asp">Cancelled Shipments</a></p>
<%end if%>
    </td>
    </tr>
</table>
</div>
<!--<p>Region <%=retrieveUserRegion()%></p>-->
</body>
</html>
 <script Language="JavaScript" type="text/javascript">
<!--
function FrontPage_Form1_Validator(theForm)
{
 
   if ((theForm.surname.value == "") && (theForm.orderno.value == "") && (theForm.cref.value == ""))
  {
    alert("Please complete one of the fields to obtain results");
    theForm.surname.focus();
    return (false);
  }

if ((theForm.surname.value != "") && (theForm.surname.value.length <3))
  {
    alert("Surname needs to be at least 3 characters long");
    theForm.surname.focus();
    return (false);
  }

    return true;
} 

//-->
</script>
<!-- #include file="common/logger-out.inc" -->
