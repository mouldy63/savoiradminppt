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
<%Dim postcode, postcodefull, val, Con, rs, rs1, recordfound, id, rspostcode, submit, count, findus, sql, typeofupdate, website
count=0
val=""
val=Request("country")
typeofupdate=Request("typeofupdate")
If typeofupdate="" then typeofupdate="text"
website=1
if request("typeofupdate")="savoirid" then website=2
submit=Request("submit") 
Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
	<script type="text/javascript" src="ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="ckeditor/lang/_languages.js"></script>
	<script src="ckeditor/_samples/sample.js" type="text/javascript"></script>
<SCRIPT LANGUAGE="VBScript">
Function MyForm_onSubmit
  If Msgbox("Are you sure you want to delete this record?", vbYesNo + vbExclamation) = vbNo Then
    MyForm_onSubmit = False
  End If
End Function
</SCRIPT>
<link href="ckeditor/_samples/sample.css" rel="stylesheet" type="text/css" />

<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">



<p>
	
<%If typeofupdate="text" or typeofupdate="savoirid" then
sql="Select * from texts WHERE website=" & website & " AND restrictedaccess='n' AND metatags='n' AND storecountry_id=" & val & " order by textkey"
end if
If typeofupdate="seo" then
sql="Select * from texts WHERE website=" & website & " AND restrictedaccess='n' AND metatags='y' AND storecountry_id=" & val & " order by page"
end if
If typeofupdate="mobile" then
sql="Select * from texts WHERE website=" & website & " AND restrictedaccess='n' AND metatags='n' and page='mobile' AND storecountry_id=" & val & " order by textkey"
end if
'response.Write("sql=" & sql)
'response.End()
%>
<table border="0" cellpadding="3">
  
<%
Set rs = getMysqlQueryRecordSet(sql, con)
Do until rs.eof
%>
<tr>
    <%if rs("javasc")="y" then
	response.Write("<td>" & rs("page") & "</td><td><a href=""amend-plaintext.asp?val=" & rs("text_id") & """>" & rs("textkey") & "</a></td>")
	else
	response.Write("<td>" & rs("page") & "</td><td><a href=""amend-webtext.asp?val=" & rs("text_id") & """>" & rs("textkey") & "</a></td>")
end if%>
</tr>
<%rs.movenext
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
