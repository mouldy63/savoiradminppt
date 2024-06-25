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
<%Dim postcode, postcodefull, val, Con, rs, rs1, recordfound, id, rspostcode, submit, count, findus, sql
count=0
val=""
val=Request("val")

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
	
<%sql="Select * from texts WHERE text_id=" & val & ""
'response.Write("sql=" & sql)
'response.End()
Dim webtext, alertlive
Set rs = getMysqlUpdateRecordSet(sql, con)
webtext=trim(request("editor1"))
if rs("javasc")="y" then
webtext = Replace(webtext, chr(10),"<br>")
webtext=Replace(webtext, CHR(13), "")
webtext=Replace(webtext, "“", "&#8220;")
webtext=Replace(webtext, "”", "&#8221;")
webtext=Replace(webtext, "‘", "&#8216;")
webtext=Replace(webtext, "’", "&#8217;")
webtext=Replace(webtext, "'", "&#8216;")
end if
alertlive=request("alertlive")
'webtext = Replace(webtext, vbcrlf,"<br>")
if val<>387 and val<>112 and val<>731 and val<>1609 and val<>2132 and val<>2643 and val<>3179  and val<>3862 then webtext=Replace(webtext,"<div>","")
if val<>387 and val<>112 and val<>731 and val<>1609 and val<>2132 and val<>2643 and val<>3179  and val<>3862 then webtext=Replace(webtext,"</div>","")

webtext=trim(webtext)
rs("text")=webtext
if alertlive<>"" then rs("alertlive")="y" else rs("alertlive")="n"
rs.update
rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>  
The text has been updated - <a href="javascript: history.go(-2)">back to index</a>
</p>     
  </div>
  </div>
<div>
</div>
       
</body>
</html>

   
<!-- #include file="common/logger-out.inc" -->
