<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
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


<%If submit<>"" Then 
%>
<p>Your blog has been added to the website.</p>
	
<%sql="Select * from blogs"
'response.Write("sql=" & sql)
'response.End()
Set rs = getMysqlUpdateRecordSet(sql, con)
rs.AddNew
rs("locationpageid")=val
If Request("date")<>"" Then rs("date")=Request("date") else rs("date")=Null
If Request("author")<>"" Then rs("author")=Request("author") else rs("author")=Null
If Request("title")<>"" Then rs("title")=Request("title") else rs("title")=Null
If Request("desc")<>"" Then rs("desc")=Request("desc") else rs("desc")=Null
rs.Update
rs.close
set rs=nothing

Else
%>		<form action="addblog.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">
  <p>
  <label>Date
    <br>
    <input name="date" type="text" id="date"><a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.date','calendar_window','width=154,height=288');calendar_window.focus()">
      Choose Date
       </a>
    <br>
    <br>
  </label>
  </p>
  <p>
    <label>Author<br>
      <input name="author" type="text" id="author" maxlength="255">
    </label>
  </p>
  <p>
    <label>Event Title<br>
<input name="title" type="text" id="title" size="60" maxlength="255">
    </label>
  </p>
  <p>
    <label>Blog<br>
      <textarea name="desc" cols="70" rows="9" id="desc"></textarea>
    </label>
  </p>
  <p><input name="val" type="hidden" id="val" value="<%=val%>">

    <input type="submit" name="submit" value="Add Blog"  id="submit" class="button" />
  </p>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
</form>
<%

End If
Con.Close
Set Con = Nothing%>       
  </div>
  </div>
<div>
</div>
       
</body>
</html>

   
<!-- #include file="common/logger-out.inc" -->
