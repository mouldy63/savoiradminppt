<%dim cardiffNo, londonNo, londonitems, cardiffitems, n
Set Con = getMysqlConnection()

sql="Select count(*) as n from qc_history_latest Q, purchase P where P.purchase_no=Q.purchase_no and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=2 or Q.QC_StatusID=20) AND  P.orderonhold<>'y' and  (P.cancelled is Null or P.cancelled='n')"
Set rs = getMysqlQueryRecordSet(sql , con)
londonitems=rs("n")
rs.close
set rs=nothing

sql="Select count(*) as n from qc_history_latest Q, purchase P where P.purchase_no=Q.purchase_no and Q.madeat=1 and Q.finished is Null and (Q.QC_StatusID=2 or Q.QC_StatusID=20) and P.code<>15919 AND  P.orderonhold<>'y'and (P.cancelled is Null or P.cancelled='n')"
Set rs = getMysqlQueryRecordSet(sql , con)
cardiffitems=rs("n")
rs.close
set rs=nothing

sql="Select NoItemsWeek, manufacturedatid from manufacturedat"
Set rs = getMysqlQueryRecordSet(sql , con)
Do until rs.eof
	if rs("manufacturedatid")=1 then cardiffNo=rs("NoItemsWeek")
	if rs("manufacturedatid")=2 then londonNo=rs("NoItemsWeek")
	rs.movenext
loop
rs.close
set rs=nothing
cardiffNo=round(CDbl(cardiffitems)/CDbl(cardiffNo)+0.5)
londonNo=round(CDbl(londonitems)/CDbl(londonNo)+0.5)
%>
<div> <a href="index.asp" style="float:left;"><img src="/images/logo-s.gif" border="0" /></a>
  <p align="right" style="float:right;">&nbsp;Lead Time: London = <%=londonNo%> weeks, Cardiff = <%=cardiffNo%> weeks | Logged in as <%=retrieveUserName()%> | <a href="/access/logout.asp"> Logout</a></p>
</div>
<div class="clear"></div>
<div id="adminhdr">
<ul>
  <li><a href="index.asp">Home</a></li>
  <% if userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR,TESTER") then %>
  <li><a href="/check-postcode.asp">Add Customer</a></li>
  <%end if%>
  <li class="dropdown">
    <a href="#" class="dropbtn">Brochure Requests</a>
    <div class="dropdown-content">
    <% if userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR,TESTER") then
	    if retrieveUserRegion()=6 then
		  else%>
      <a href="/brochure-requests.asp">Outstanding Requests</a>
       <%end if
	   end if%>
      <%if userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR,TRADE") then%>
      <a href="/company-brochure-requests.asp">Company Requests</a>
      <%end if%>
    </div>
  </li>
  <%if retrieveUserRegion()=1 then%>
  <li class="dropdown">
    <a href="#" class="dropbtn">Correspondence</a>
    <div class="dropdown-content">
      <a href="/add-letter.asp">Add</a>
      <a href="/amend-correspondence.asp">Edit</a>
    </div>
  </li>
  <%end if%>
  <%if retrieveUserRegion()=1 and retrieveuserlocation()=1 then%>
  <li class="dropdown">
    <a href="#" class="dropbtn">Customer Services</a>
    <div class="dropdown-content">
      <a href="/customer-service.asp">Add Case</a>
      <%if userHasRoleInList("ADMINISTRATOR") then %>
      <a href="/customerservicehistory.asp">Closed Cases</a>
      <%end if%>
      <a href="/customerservicelist.asp">Outstanding Cases</a>
    </div>
  </li>
  <%end if%>
  <%if retrieveUserRegion()=1 or retrieveuserlocation()=8 or retrieveuserlocation()=24 or retrieveuserlocation()=25 or retrieveuserlocation()=34 or retrieveuserlocation()=31 or retrieveuserlocation()=35 or retrieveuserlocation()=17 or retrieveuserlocation()=33 or retrieveuserlocation()=14 or retrieveUserRegion()=17 or retrieveuserregion()=19 then%>
  <li class="dropdown">
    <a href="#" class="dropbtn">Orders</a>
    <div class="dropdown-content">
      <a href="/awaiting-confirmation.asp">Awaiting Confirmation</a>
      <a href="/current-orders.asp">Current Orders</a>
      <a href="/heldorders.asp">Held Orders</a>
      <%if retrieveUserRegion()=1 then%>
      <a href="/quotes.asp">Quotes</a>
      <%end if%>
    </div>
  </li>
  <%end if%>
 <%if userHasRoleInList("ADMINISTRATOR") then %>
  <li class="dropdown">
    <a href="#" class="dropbtn">Production</a>
    <div class="dropdown-content">
      <a href="/add-shipper.asp">Add Shipper</a>
      <a href="/add-consignee.asp">Add Consignee</a>
      <a href="/production-orders.asp">Orders In Production</a>
      <a href="/component-data.asp">Packaging Information</a>
      <a href="/items-produced.asp">Production Admin</a>
      <a href="/production-list.asp">Production List</a>
      <a href="/edit-picklist.asp">Staff List</a>
      <hr />
      <a href="deliveriesbooked1.asp?madeat=2">Cardiff Screen</a>
      <a href="/deliveriesbooked1.asp?madeat=1">London Screen</a>
      <a href="http://wrap.savoirproduction.co.uk/production.php">Labels Screen</a>
    </div>
  </li>
  <%end if%> 
  <%if retrieveUserLocation=1 or retrieveUserLocation=27 or retrieveUserRegion>1 then%>
  <li class="dropdown">
    <a href="#" class="dropbtn">Sales Admin</a>
    <div class="dropdown-content">
    <%if (retrieveUserLocation()=1  or retrieveUserLocation()=27) then%>
      <a href="/cancelled-exports.asp">Cancelled Shipments</a>
      <%end if%>
      <a href="/delivered-exports.asp">Delivered Shipments</a>
      <a href="/planned-exports.asp">Planned Export Collections</a>
    </div>
  </li>
  <%end if%> 
  <%if userHasRoleInList("ADMINISTRATOR") then %>
  <li class="dropdown">
    <a href="#" class="dropbtn">Reports</a>
    <div class="dropdown-content">
      <%if retrieveUserRegion()=1 then%>
      <a href="/searchaccounts.asp">Accounts</a>
      <a href="/customer-reports.asp">Brochures for Prospects</a>
      <%end if%>
      <%if userHasRoleInList("ADMINISTRATOR,TESTER,SALES") then %>
      <a href="/production-orders.asp">Customer Orders</a>
      <%end if%>
      <%If retrieveuserregion()=1 then%>
      <a href="/cust-ready-not-inv.asp">Customer Ready Not Invoiced</a>
      <%end if%>
      <%if userHasRoleInList("ADMINISTRATOR") then %>
      <a href="/delivery-report-filter.asp">Delivery</a>
      <%end if%>
      <%if isSuperUser() then %> 
      <a href="/customer-reportsfull.asp">Full Customer/Prospects</a>
      <%end if%>
	  <%if retrieveUserLocation()=1 or retrieveUserLocation()=23 then%>
      <a href="/searchtrade.asp">Trade</a>
      <%end if%>
      <%if isSuperUser() then %> 
      <a href="/vapp.asp">VAPP</a>
      <%end if%>
    </div>
  </li>
  <%end if%>
  <%if isSuperUser() then %>
  <li class="dropdown">
    <a href="#" class="dropbtn">Admin Control</a>
    <div class="dropdown-content">
      <a href="/deletespam.asp">Delete Spam</a>
      <a href="/storelistadmin.asp">Edit Showrooms</a>
      <a href="/maintain-price-matrix.asp">Pricing Matrix</a>
    </div>
  </li>
  <%end if%>  
</ul>
</div>

