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
<%Dim  Con, rs, sql
Set Con = getMysqlConnection()%>
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
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#datefrom" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#datefrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#dateto" ).datepicker({
changeMonth: true,
yearRange: "-21:+0",
changeYear: true

});
$( "#dateto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});

</script>
</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
	
<form action="tradereport.asp" method="post" name="form1">					  
    <div class="content brochure">
			    <div class="one-col head-col">
			<p>Search Orders</p>

        
<table width="400" border="0" align="center" cellpadding="5" cellspacing="2">
					    <tr>
					      <td><label for="datefrom" id="surname"><strong>Order date from :</strong><br>
		  <input name="datefrom" type="text" class="text" id="datefrom" size="10" /></label></td>
					      <td><strong>Order date to: </strong><br>
                          <input name="dateto" type="text" class="text" id="dateto" size="10" /></td>
				        </tr>
                      
					    <tr>
					      <td>
					    
				    </td>
					      <td><%If retrieveUserLocation()=1 or retrieveUserLocation()=23 then%>
                           <%
						
						sql="Select * from location where owning_region=1 AND retire<>'y' order by adminheading"
                        Set rs = getMysqlQueryRecordSet(sql , con)
						%>
					        <select name="location" size="1" class="formtext" id="location">
					          <option value="all">Showroom</option>
					          <%do until rs.EOF%>
					          <option value="<%=rs("idlocation")%>"><%=rs("adminheading")%></option>
					          <% rs.movenext 
  loop%>
					          <%
rs.Close
Set rs = Nothing


%>
				            </select>
                          <%end if%>&nbsp;</td>
	      </tr>
					    <tr>
					      <td>&nbsp;</td>
					      <td><span class="row">
					        <input type="submit" name="submit" value="Search Database"  id="submit" class="button" />
					      </span></td>
	      </tr>
    </table>
				
          <br>


    </div>
  </div>
<div></form>
</div>
        
</body>
</html>

 <%Con.Close
Set Con = Nothing%> 
<!-- #include file="common/logger-out.inc" -->
