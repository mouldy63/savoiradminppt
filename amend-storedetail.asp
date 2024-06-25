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
<%Dim Con, rs, val, moreinfo
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
Set rs = getMysqlQueryRecordSet("Select * from location WHERE idlocation=" & val, con)
%>

		<form action="update-storedetail.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
<div id="c1">        <p><strong>Amend Address</strong></p>


		<p>Line 1:
          <br>
          <input name="add1" type="text" id="add1" value="<%=rs("add1")%>" size="30">
			
	      <br>
	      <br>
	      Line 2:<br>
	      <input name="add2" type="text" id="add2" value="<%=rs("add2")%>" size="30">
          <br>
          <br>
          Line 3:
          <br>
          <input name="add3" type="text" id="add3" value="<%=rs("add3")%>" size="30">
          <br>
          <br>
          Town:
          <br>
          <input name="town" type="text" id="town" value="<%=rs("town")%>" size="30">
          <br>
          <br>
          County/State:
          <br>
          <input name="county" type="text" id="county" value="<%=rs("countystate")%>" size="30">
          <br>
          <br>
          Postcode:
          <br>
        <input name="postcode" type="text" id="postcode" value="<%=rs("postcode")%>" size="30"></p>
</div>

<div id="c2"><p><strong>Amend Address<br>
  <br>
</strong></p><p>Phone:
          <br>
          <input name="tel" type="text" id="tel" value="<%=rs("tel")%>" size="30">
          
          <br>
          <br>
          Fax:</p>
<p>
  <input name="fax" type="text" id="fax" value="<%=rs("fax")%>" size="30">
</p>
<p>Email:<br>
  <input name="email" type="text" id="email" value="<%=rs("email")%>" size="30">
</p>
<p><strong>Amend Store Times</strong></p>
<p>Days:<br>
  <input name="odays" type="text" id="odays" value="<%=rs("openingdays")%>" size="30">
  <br>
  <br>
  Time:<br>
  <input name="otime" type="text" id="otime" value="<%=rs("openingtimes")%>" size="30">
  <br>
  <br>
  <%if rs("openingmoreinfo")<>"" then moreinfo=replace(rs("openingmoreinfo"), "<br />", chr(10))%>
  Extra lines (i.e. to add further dates / times / By Appointment text etc: - NOTE to create the start of a new line which will show up on the site please press return key)</p>
<p>
  <textarea name="omoreinfo" cols="30" id="omoreinfo"><%=moreinfo%></textarea>
  <br>
  <br>
</p>
</div>
<div class="clear"></div>
        </p><input name="val" type="hidden" value="<%=val%>">
        <input type="submit" name="submit1" value="Amend Store details"  id="submit1" class="button" />
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
