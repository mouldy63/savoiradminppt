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
<%Dim val, Con, rs, rs1, recordfound, id, submit, count, findus, sql, add1, add2, add3, town, countystate, postcode, tel, fax, email, openingdays, openingtimes, openingmoreinfo, moreinfo
count=0
val=""
val=Request("val")
add1=request("add1")
add2=request("add2")
add3=request("add3")
town=request("town")
countystate=request("county")
postcode=request("postcode")
tel=request("tel")
fax=request("fax")
email=request("email")
openingdays=request("odays")
openingtimes=request("otime")
openingmoreinfo=request("omoreinfo")

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
	
<%sql="Select * from location WHERE idlocation=" & val & ""
'response.Write("sql=" & sql)
'response.End()
Set rs = getMysqlUpdateRecordSet(sql, con)

moreinfo = Replace(openingmoreinfo, chr(10),"<br />")
if add1<>"" then rs("add1")=add1 else rs("add1")=null
if add2<>"" then rs("add2")=add2 else rs("add2")=null
if add3<>"" then rs("add3")=add3 else rs("add3")=null
if town<>"" then rs("town")=town else rs("town")=null
if countystate<>"" then rs("countystate")=countystate else rs("countystate")=null
if postcode<>"" then rs("postcode")=postcode else rs("postcode")=null
if tel<>"" then rs("tel")=tel else rs("tel")=null
if email<>"" then rs("email")=email else rs("email")=null
if fax<>"" then rs("fax")=fax else rs("fax")=null
if openingdays<>"" then rs("openingdays")=openingdays else rs("openingdays")=null
if openingtimes<>"" then rs("openingtimes")=openingtimes else rs("openingtimes")=null
if moreinfo<>"" then rs("openingmoreinfo")=moreinfo else rs("openingmoreinfo")=null
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
