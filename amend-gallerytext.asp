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
Set rs = getMysqlQueryRecordSet("Select * from gallery WHERE id=" & val, con)

%>

		<form action="update-gallery-text.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
        <p>Amend gallery image text below</a></p>


		<p>
        Image Title / Name:<br />
        <input name="imagename" type="text" id="imagename" value="<%=rs("imagename")%>" size="80" maxlength="255">
			
	      <br>
	      <br>English:<br />
			<textarea cols="80" id="desc1" name="desc1" rows="10"><%=rs("description")%></textarea>
			
	      <br>
          Russian:<br />
          <textarea cols="80" id="desc2" name="desc2" rows="10"><%=rs("descrussian")%></textarea>
	      <br>
          Swedish:<br />
          <textarea cols="80" id="desc3" name="desc3" rows="10"><%=rs("descsweden")%></textarea>
          <br>
          German:<br />
          <textarea cols="80" id="desc4" name="desc4" rows="10"><%=rs("descgerman")%></textarea>
          <br>
          Czech:<br />
          <textarea cols="80" id="desc5" name="desc5" rows="10"><%=rs("descczech")%></textarea>
          <br>
          French:<br />
          <textarea cols="80" id="desc6" name="desc6" rows="10"><%=rs("descfrench")%></textarea>
           <br>
          Taiwanese:<br />
          <textarea cols="80" id="desc5" name="desc7" rows="10"><%=rs("desctaiwan")%></textarea>
          <br>
        </p><input name="val" type="hidden" value="<%=val%>">
        <input type="submit" name="submit1" value="Amend Gallery Image Text"  id="submit1" class="button" />
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
