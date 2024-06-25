<%Option Explicit%>
<%
dim ALLOWED_ROLES, sql, Con, rs
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
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

</head>

<body>
<div class="container">
<!-- #include file="header.asp" -->
<table width="667" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr valign="top">
    <td class="maintext">Click on a menu item below to edit it
     <table border="0" cellspacing="3" cellpadding="3">

      <%Set Con = getMysqlConnection()
if userHasRoleInList("ADMINISTRATOR,SALES") then 
sql="Select * from locationPages WHERE locationid=" & retrieveUserLocation() & " order by priority asc"
'response.Write("sql=" & sql)
Set rs = getMysqlQueryRecordSet(sql, con)
Do until rs.eof
If rs("priority")>0 AND rs("priority")<7 Then%>	
        <tr>
          <td><%Response.write("<a href=""editpage.asp?val=" & rs("locationpageid") & """>" & rs("menuname") & "</a>")%>&nbsp;</td>
          <td><%If rs("active")="y" then response.write("Active") else response.write("NOT Live")%></td>
        </tr>
     
<p></p>
<%End If
rs.movenext
loop
rs.close
set rs=nothing
end if %> </table>
      </td>
  </tr>
</table>
</div>
<p>Region <%=retrieveUserRegion()%></p>
</body>
</html>
<%Con.close
Set Con=nothing%>
<!-- #include file="common/logger-out.inc" -->
