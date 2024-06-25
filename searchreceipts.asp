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

</head>
<body>
<form action="receiptreport.asp" method="post" name="form1">
<div class="container">
<!-- #include file="header.asp" -->
	
					  
    <div class="content brochure">
			    <div class="one-col head-col">
			<p>Search Receipts</p>

        
<table width="400" border="0" align="center" cellpadding="5" cellspacing="2">
					    <tr>
					      <td><label for="datefrom" id="surname"><strong>Order date from :</strong><br>
		  <input name="datefrom" type="text" class="text" id="datefrom" size="10" /><a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.datefrom','calendar_window','width=154,height=288');calendar_window.focus()">
      Choose Date
       </a></label></td>
					      <td><strong>Order date to: </strong><br>
                          <input name="dateto" type="text" class="text" id="dateto" size="10" /><a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.dateto','calendar_window','width=154,height=288');calendar_window.focus()">
      Choose Date
       </a></td>
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
<div>
</div>
        </form>
</body>
</html>

 <%Con.Close
Set Con = Nothing%> 
<!-- #include file="common/logger-out.inc" -->
