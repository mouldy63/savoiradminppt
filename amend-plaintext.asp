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
<%Dim Con, rs, val
val=Request("val")
Set Con = getMysqlConnection()%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />


<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
	
<%
Set rs = getMysqlQueryRecordSet("Select * from texts WHERE text_id=" & val, con)
response.Write("<b>The page will edit the " & rs("textkey") & " text</b>")
%>

		<form action="update-text.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
        <p>Amend web text below</a></p>


		<p>
			<textarea cols="80" id="editor1" name="editor1" rows="10"><%=rs("text")%></textarea>
			
	      <br>
	      <br>
        </p><input name="val" type="hidden" value="<%=val%>">
        <input type="submit" name="submit1" value="Amend Website Text"  id="submit1" class="button" />
	</form>
<%rs.close
set rs=nothing

Con.Close
Set Con = Nothing%>       
  </div>
  </div>
<div>
</div>
       
</body>
</html>

   
<!-- #include file="common/logger-out.inc" -->
