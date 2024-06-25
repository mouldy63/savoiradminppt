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
<%Dim postcode, postcodefull, val, Con, rs, rs1, recordfound, id, rspostcode, submit, count, findus, sql, typeofupdate, website, convertdate, i
convertdate=""

count=0
submit=Request("submit") 
Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
	
<SCRIPT LANGUAGE="VBScript">
Function MyForm_onSubmit
  If Msgbox("Are you sure you want to delete this record?", vbYesNo + vbExclamation) = vbNo Then
    MyForm_onSubmit = False
  End If
End Function
</SCRIPT>

<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">


<p>Click on date below to amend countries listed:</p>
<p>
	
<%
sql="Select * from press order by date desc"

'response.Write("sql=" & sql)
'response.End()
%>
<table border="0" cellpadding="3" class="indentleft">
  
<%
Set rs = getMysqlQueryRecordSet(sql, con)
Do until rs.eof
%>
<tr>
    <%convertdate=day(rs("date")) & "-" & month(rs("date")) & "-" & year(rs("date"))
	
	response.Write("<td><a href=""amend-pressdate.asp?val=" & rs("pressid") & """>" & rs("date") & "</a></td><td><img src=""http://savoirbeds.co.uk/press/" &  convertdate  & ".jpg"" border=""0"" height=""100"" align=""absmiddle"">  <b>Listed on the following websites:</b> &nbsp;")

sql="Select * from store_country order by country_id"
Set rs1 = getMysqlQueryRecordSet(sql, con)

	Do until rs1.eof%>
   
    <%for i=1 to rs1.recordcount
	if rs("country" & i & "")="y" AND rs1("country_id")=i then response.Write(rs1("country") & "&nbsp;&nbsp;")
	'if rs("country2")="y" AND rs1("country_id")=2  then response.Write(rs1("country") & "&nbsp;&nbsp;")
	next%>
    

<%rs1.movenext
loop
rs1.close
set rs1=nothing
%></td></tr><%
rs.movenext
loop

rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>
</table>
<p>&nbsp;</p>     
  </div>
  </div>
<div>
</div>
       
</body>
</html>

   
<!-- #include file="common/logger-out.inc" -->
