<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Dim Con, sql, rs%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
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
    <td class="maintext">

      <% 'if userHasRoleInList("ADMINISTRATOR,SALES") then
	   if userHasRoleInList("ADMINISTRATOR,TESTER") then %>
      	<p><a href="brochure-report.asp">Track number of brochure requests for Prospect customers</a></p>
        <%if retrieveuserregion()=1 then%>
        <p><a href="cust-ready-not-inv.asp">Customer Ready Not Invoiced</a></p>
      
<%		end if
 end if %>
      <% if userHasRoleInList("SALES") then %>
<%End If%>      
      </td>
  </tr>
</table>
</div>

</body>
</html>
<!-- #include file="common/logger-out.inc" -->
