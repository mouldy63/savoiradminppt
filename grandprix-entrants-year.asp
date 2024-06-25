<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
Dim i, Con, rs, sql%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncsGrandPrix.asp" -->
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
<body>
<div class="container">
<!-- #include file="header.asp" -->
	
					  <div class="content brochure">
			    <div class="one-col head-col">
			<p>Grandprix design entrants - Select Year</p>
            <p>
			<form name="form1" method="post" action="grandprix-entrants.asp">
			  <label for="entrantyear"></label>
			  <select name="entrantyear" id="entrantyear">
			    <option value="<%=year(date())%>"><%=year(date())%></option>
                <%for i=1 to 5%>
			    <option value="<%=year(date())-i%>"><%=year(date())-i%></option>
                <%next%>
		      </select>
              <input type="submit" name="button" id="button" value="Select">
			</form></p>
			
                </div>
  </div>
<div>
</div>
        </form>
</body>
</html>
<!-- #include file="common/logger-out.inc" -->
