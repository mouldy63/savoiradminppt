<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES,WEBSITEADMIN"
dim orderexists, Con, sql, rs
orderexists=""
orderexists=Request("orderexists")
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
<script src="common/jquery.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>

</head>

<body>
<div class="container">
<!-- #include file="header.asp" -->
<table width="667" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr valign="top">
    <td colspan="2" class="maintext">
      <% If orderexists="y" then response.write("<font color=red>An order with the same number has already been entered - to update the order please Search Database for your order under customer name and click on the Orders tab</font>")%>
	  
      
    </td>
    </tr>
  <tr valign="top">
    <td width="337" class="maintext">   <% 'if userHasRoleInList("ADMINISTRATOR,SALES") then
	   if userHasRoleInList("ADMINISTRATOR,TESTER,SALES") then %>
      	 <p><a href="production-orders.asp">Orders in Production</a></p>
     <%end if%>
	  <% if userHasRoleInList("ADMINISTRATOR,TESTER") then %>
         <p><a href="production-list.asp">Production List</a></p>
      	 <p><a href="edit-picklist.asp">Staff Lists</a></p>
         <p><a href="add-shipper.asp">Add Shipper</a></p>
         <p><a href="add-consignee.asp">Add Consignee</a></p>
        <%end if%>
           <% if userHasRoleInList("ADMINISTRATOR") then %>
            <p><a href="items-produced.asp">Production Admin</a></p> 
                <p><a href="component-data.asp">Product &amp; Packaging Information</a></p> 
              <%end if%>
	  <% if userHasRoleInList("ADMINISTRATOR,TESTER,SALES") then 
	  if retrieveUserRegion=1 then%>
         <p><a href="delivery-report-filter.asp">Delivery Report</a></p>
     <%end if
	 end if%>
     <%if (retrieveuserlocation()=1 or retrieveuserlocation()=27) then%>
     <hr />
     <p><a href="http://savoiradminppt.co.uk/deliveriesbooked1.asp?madeat=2">London Production Screen (statuses)</a></p>
     <p><a href="http://savoiradminppt.co.uk/deliveriesbooked1.asp?madeat=1">Cardiff Production Screen (statuses)</a></p>
     
     <p><a href="http://wrap.savoirproduction.co.uk/production.php">Production Screen Labels</a></p>
     <%end if%>
         </td>
    <td width="310" class="maintext"></td>
  </tr>
</table>
</div>
<!--<p>Region <%=retrieveUserRegion()%></p>-->
</body>
</html>
<%Con.close
set Con=nothing%>
 
<!-- #include file="common/logger-out.inc" -->
