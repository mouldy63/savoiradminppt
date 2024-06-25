<%Option Explicit%>
<%
dim ALLOWED_ROLES, sql, Con, rs, val, rs2, i, checked, count2
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
Set Con = getMysqlConnection()

val=request("val")
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">

<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />

</head>

<body bgcolor="#FFFFFF" text="#000000">
<div class="container">
<!-- #include file="header.asp" -->


      <p align="center" class="pagetitles">&nbsp;</p>
      <div align="left">
       
        <h1>Search for Savoir Images</h1>
        <p>&nbsp;</p>
        <hr>
        
        <form METHOD="POST" name="form1" ACTION="galleryimages.asp">
    
          <div id="c1">
       <p><strong>Select Category:</strong><br /><br />
 <%Set rs = getMysqlQueryRecordSet("Select * from gallerycategory order by gallerycategory asc", con)%>
  <%Do until rs.eof%>
 <input name="XX<%=rs("gcid")%>" type="checkbox">&nbsp;<%=rs("gallerycategory")%><br />
   <%rs.movenext
  loop
  rs.close
  set rs=nothing%>
</p>
 <p>Search for jpg name: 
   <input name="jpgname" type="text">
 </p>
 <p>
   <input type="submit" name="submit" id="submit" value="Submit">
 </p>
<p>&nbsp;</p>
           
           
              </p>
          </div>
    

     
 </form>
</div>
</body>
</html>
<%
Con.close
set Con=nothing%>
<!-- #include file="common/logger-out.inc" -->
