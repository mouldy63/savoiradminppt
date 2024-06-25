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
<p>Your testimonial has been amended on the website.</p>
	
<%sql="Select * from testimonials WHERE testimonialid=" & val & ""
'response.Write("sql=" & sql)
'response.End()
Set rs = getMysqlUpdateRecordSet(sql, con)
If Request("date")<>"" Then rs("date")=Request("date") else rs("date")=Null
If Request("name")<>"" Then rs("name")=Request("name") else rs("name")=Null
If Request("company")<>"" Then rs("company")=Request("company") else rs("company")=Null
If Request("testimonial")<>"" Then rs("testimonial")=Request("testimonial") else rs("testimonial")=Null
rs.Update
rs.close
set rs=nothing

Else
Set rs = getMysqlQueryRecordSet("Select * from testimonials WHERE testimonialid=" & val & "", con)
%>		<form action="edittestimonial.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">
  <p>
  <label>Date
    <br>
    <input name="date" type="text" id="date" value="<%=rs("date")%>"><a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.date','calendar_window','width=154,height=288');calendar_window.focus()">
      Choose Date
       </a>
    <br>
    <br>
  </label>
  </p>
  <p>
    <label>Name<br>
      <input name="name" type="text" id="name" value="<%=rs("name")%>" size="60" maxlength="100">
    </label>
  </p>
  <p>
    <label>Company<br>
<input name="company" type="text" id="company" value="<%=rs("company")%>" size="60" maxlength="255">
    </label>
  </p>
  <p>
    <label>Testimonial<br>
      <textarea name="testimonial" cols="70" rows="9" id="testimonial"><%=rs("testimonial")%></textarea>
    </label>
  </p>
  <p><input name="val" type="hidden" id="val" value="<%=val%>">

    <input type="submit" name="submit" value="Amend Testimonial"  id="submit" class="button" />
  </p>
  <p>OR</p>
  <p>&nbsp;</p>
</form>
<SCRIPT LANGUAGE="VBScript">
Function MyForm_onSubmit
  If Msgbox("Are you sure you want to delete this record?", vbYesNo + vbExclamation) = vbNo Then
    MyForm_onSubmit = False
  End If
End Function
</SCRIPT>
     <form method="post" action="deletetestimonial.asp" name="MyForm">
        <input type="hidden" name="val" value="<%=rs("testimonialID")%>">
        <input type="submit" value="Delete Testimonial" name="submit">
      </form>
<%
rs.close
set rs=nothing
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
