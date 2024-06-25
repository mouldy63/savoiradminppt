<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim Con, rs, userid, sql, addperson, msg, newname, strname
userid=request("userid")

Set Con = getMysqlConnection()
sql="SELECT * from communication C, Address A, Contact T where C.type like 'Headboard Offer May 2013' and C.code=A.code and C.code = T.code"

Set rs = getMysqlQueryRecordSet(sql, con)

%>
  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/extra.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->
	
					  <div class="content brochure">
			    <div class="one-col head-col">
			<p>Savoir Bed Offers
            </p> <p><table width="467" border="0" cellspacing="0" cellpadding="5" align="center">
              <tr>
    <td><b>Customer</b></td>
    <td><b>Offer</b></td>
    <td><b>Nearest Showroom</b></td>
    <td>&nbsp;</td>
  </tr>
          <%do until rs.eof%>
         
  <tr>
    <td><a href="editcust.asp?val=<%=rs("contact_no")%>"><%response.Write(rs("title") & " " & rs("first") & " " & rs("surname") & "<br />")%></a></td>
    <td><%=rs("notes")%>&nbsp;</td>
    <td><%=rs("staff")%>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>

		 
          <%rs.movenext
		  loop
		  rs.close
		  set rs=nothing%>
         </table> </p>
			
			 
		
                </div>

</div></div>
</body>
</html>
<%
con.close
set con=nothing%>
<!-- #include file="common/logger-out.inc" -->
