<%Option Explicit%>
<%
dim ALLOWED_ROLES, sql, Con, rs, val, editimg
editimg=""
editimg=Request("img")
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
val=Request("val")
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="emailfuncs.asp" -->
<%
set acon = getMysqlConnection()
call sendBatchEmail("Savoir Beds application for image approval on accessories section", "Approval for accessory image from " & retrieveUserName() & " is requested.  Log in to the admin section to approve", "noreply@savoirbeds.co.uk", "info@natalex.co.uk", "", "", true, acon)
call closemysqlcon(acon)
%>	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">

<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>

<body bgcolor="#FFFFFF" text="#000000">
<div class="container">
<!-- #include file="header.asp" -->
<div align="center"> 
</div>

<table  border="0" align="center" cellpadding="0" cellspacing="0" class="bodytextunj">
  <tr> 
    <td valign="top">
      <p align="center" class="pagetitles">&nbsp;</p>
      <p align="center" class="pagetitles">Approval has been sent</p>
     
      
        </td>
  </tr>
  
</table>
</div>
</body>
</html>
<!-- #include file="common/logger-out.inc" -->