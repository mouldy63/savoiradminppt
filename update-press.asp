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
<%Dim postcode, postcodefull, val, Con, rs, rs1, recordfound, id, rspostcode, submit, count, findus, sql, englishtxt, russiantxt, frenchtxt, czechtxt, germantxt, swedishtxt
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
	
<%sql="Select * from press WHERE pressid=" & val & ""
'response.Write("sql=" & sql)
'response.End()

Set rs = getMysqlUpdateRecordSet(sql, con)
rs("country")=request("maincountry")
if request("urllink")<>"" then rs("urllink")=request("urllink") else rs("urllink")=""
if request("country1")="y" then rs("country1")="y" else rs("country1")="n"
if request("country2")="y" then rs("country2")="y" else rs("country2")="n"
if request("country3")="y" then rs("country3")="y" else rs("country3")="n"
if request("country4")="y" then rs("country4")="y" else rs("country4")="n"
if request("country5")="y" then rs("country5")="y" else rs("country5")="n"
if request("country6")="y" then rs("country6")="y" else rs("country6")="n"
if request("country7")="y" then rs("country7")="y" else rs("country7")="n"
if request("country8")="y" then rs("country8")="y" else rs("country8")="n"
if request("country9")="y" then rs("country9")="y" else rs("country9")="n"
rs.update
rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>  
The press item has been updated - <a href="javascript: history.go(-2)">back to index</a>
</p>     
  </div>
  </div>
<div>
</div>
       
</body>
</html>

   
<!-- #include file="common/logger-out.inc" -->
