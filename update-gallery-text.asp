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
<%Dim postcode, postcodefull, val, Con, rs, rs1, recordfound, id, rspostcode, submit, count, findus, sql, englishtxt, russiantxt, frenchtxt, czechtxt, germantxt, swedishtxt, taiwantxt, imagename
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
	
<%sql="Select * from gallery WHERE id=" & val & ""
'response.Write("sql=" & sql)
'response.End()

Set rs = getMysqlUpdateRecordSet(sql, con)
imagename=request("imagename")
germantxt=request("desc4")
swedishtxt=request("desc3")
frenchtxt=request("desc6")
englishtxt=request("desc1")
czechtxt=request("desc5")
russiantxt=request("desc2")
taiwantxt=request("desc7")
rs("imagename")=imagename
rs("description")=englishtxt
rs("descgerman")=germantxt
rs("descsweden")=swedishtxt
rs("descfrench")=frenchtxt
rs("descczech")=czechtxt
rs("descrussian")=russiantxt
rs("desctaiwan")=taiwantxt

rs.update
rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>  
The gallery text has been updated - <a href="javascript: history.go(-2)">back to index</a>
</p>     
  </div>
  </div>
<div>
</div>
       
</body>
</html>

   
<!-- #include file="common/logger-out.inc" -->
