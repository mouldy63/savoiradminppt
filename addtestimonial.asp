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
<p>Your testimonial has been added to the website.</p>
	
<%sql="Select * from testimonials"
'response.Write("sql=" & sql)
'response.End()
Set rs = getMysqlUpdateRecordSet(sql, con)
rs.addnew
rs("locationid")=retrieveUserLocation()
If Request("date")<>"" Then rs("date")=Request("date") else rs("date")=Null
If Request("name")<>"" Then rs("name")=Request("name") else rs("name")=Null
If Request("company")<>"" Then rs("company")=Request("company") else rs("company")=Null
If Request("testimonial")<>"" Then rs("testimonial")=Request("testimonial") else rs("testimonial")=Null
rs.Update
rs.close
set rs=nothing

Else
%>		<form action="addtestimonial.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">
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
    <label>Name<br>
      <input name="name" type="text" id="name" size="60" maxlength="100">
    </label>
  </p>
  <p>
    <label>Company<br>
<input name="company" type="text" id="company" size="60" maxlength="255">
    </label>
  </p>
  <p>
    <label>Testimonial<br>
      <textarea name="testimonial" cols="70" rows="9" id="testimonial"></textarea>
    </label>
  </p>
  <p><input name="val" type="hidden" id="val" value="<%=val%>">

    <input type="submit" name="submit" value="Add Testimonial"  id="submit" class="button" />
  </p>
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
