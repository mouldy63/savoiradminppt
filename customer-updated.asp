<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Dim Con, sql, rs
Set Con = getMysqlConnection()%>
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
<script src="common/jquery.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>
</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->
	
					  <div class="content brochure">
			    <div class="one-col head-col">
			<p>The customer records have been updated.<form action="editcust.asp" method="post" name="form1" id="form1">
            <input name="val" type="hidden" value="<%=Session("custval")%>">
			  <input name="submit" type="submit" value="Go back to Customer Record">
			</form></p>
			<p>&nbsp;</p>
                </div>
    </div>
  </div>
<div>
</div>
</body>
</html>
<!-- #include file="common/logger-out.inc" -->
