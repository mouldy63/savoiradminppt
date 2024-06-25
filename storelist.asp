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
<%Dim Con, rs, val, sql
val=Request("val")
val=3
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
	<br /><br />


		<form action="amend-storedetail.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">
        <%sql="Select * from location where retire<>'y' order by adminheading"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						%>
					        <select name="val" size="1" class="formtext" id="val">
					          <option value="all">Choose Showroom</option>
					          <%do until rs.EOF%>
					          <option value="<%=rs("idlocation")%>"><%=rs("adminheading")%></option>
					          <% rs.movenext 
  loop%>
					          <%
rs.Close
Set rs = Nothing


%>
				            </select>
		  <div class="clear"></div>
        </p>
        <input type="submit" name="submit1" value="Amend Store details"  id="submit1" class="button" />
	</form>

<%

Con.Close
Set Con = Nothing%>       
  </div>
  </div>
<div>
</div>
       
</body>
</html>

   
<!-- #include file="common/logger-out.inc" -->
