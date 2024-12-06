<%dim cardiffNo, londonNo, londonitems, cardiffitems, n
Set Con = getMysqlConnection()

sql="Select count(*) as n from qc_history_latest Q, purchase P where P.purchase_no=Q.purchase_no and Q.madeat=2 and Q.finished is Null and (Q.QC_StatusID=2 or Q.QC_StatusID=20) and P.code<>15919 AND  P.orderonhold<>'y' and  (P.cancelled is Null or P.cancelled='n')"
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
if isnull(cardiffNo) or cardiffNo="" or cardiffNo=0 then
	cardiffNo=0
else
	cardiffNo=round(CDbl(cardiffitems)/CDbl(cardiffNo)+0.5)
end if
if isnull(londonNo) or londonNo="" or londonNo=0 then
	londonNo=0
else
	londonNo=round(CDbl(londonitems)/CDbl(londonNo)+0.5)
end if

%>
<div> <a href="/php/home" style="float:left;"><img src="/images/logo-s.gif" border="0" /></a>
  <p align="right" style="float:right;">&nbsp;Lead Time: London = <%=londonNo%> weeks, Cardiff = <%=cardiffNo%> weeks | Logged in as <%=retrieveUserName()%> | <a href="/access/logout.asp"> Logout</a></p>
</div>
<div class="clear"></div>
<div id="adminhdr">
<ul>
  <li><a href="/php/home">Home</a></li>
  <% if userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR,TESTER") then %>
  <li><a href="/php/AddCustomer">Add Customer</a></li>
  <%end if%>
  <li class="dropdown">
    <a href="#" class="dropbtn">Brochure Requests</a>
    <div class="dropdown-content">
    <% if userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR,TESTER") then
	    if retrieveUserRegion()=6 then
		  else%>
      <a href="/php/OutstandingBrochureRequests">Outstanding Requests</a>
       <%end if
	   end if%>
      <%if userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR,TRADE") then%>
      <a href="/php/OutstandingCoBrochureRequests">Company Requests</a>
      <%end if%>
    </div>
  </li>
  <%if retrieveUserRegion()=1 or userHasRoleInList("ONLINE_SHOWROOM") then%>
<!--  <li class="dropdown">
    <a href="#" class="dropbtn">Correspondence</a>
    <div class="dropdown-content">
    <%if retrieveUserRegion()=1 then%>
      <a href="/add-letter.asp">Add</a>
    <%end if%>
      <a href="/amend-correspondence.asp">Edit</a>
    </div>
  </li>-->
  <li><a href='/php/marketingarticles'>Marketing</a></li>
  <%end if%>
  <%if retrieveUserRegion()=1 or retrieveUserRegion()=27 or userHasRoleInList("ONLINE_SHOWROOM") then%>
  <li class="dropdown">
    <a href="#" class="dropbtn">Customer Services</a>
    <div class="dropdown-content">
      <a href="/php/customerservice/add">Add Case</a>
      <%if userHasRoleInList("ADMINISTRATOR") then %>
      <a href="/php/customerservicehistory">Closed Cases</a>
      <%end if%>
      <a href="/php/customerservice">Outstanding Cases</a>
    </div>
  </li>
  <%end if%>
  <%if retrieveUserRegion()=1 or retrieveuserlocation()=8 or retrieveuserlocation()=37 or retrieveuserlocation()=24 or retrieveuserlocation()=25 or retrieveuserlocation()=34 or retrieveuserlocation()=31 or retrieveuserlocation()=35 or retrieveuserlocation()=17 or retrieveuserlocation()=33 or retrieveuserlocation()=38 or retrieveuserregion()=26 or retrieveuserlocation()=39 or retrieveuserlocation()=14 or retrieveUserRegion()=17 or retrieveuserregion()=19 or retrieveuserlocation()=40 or retrieveuserlocation()=51 then%>
  <li class="dropdown">
    <a href="#" class="dropbtn">Orders</a>
    <div class="dropdown-content">
      <a href="/php/awaitingorders">Awaiting Confirmation</a>
      <a href="/php/currentorders">Current Orders</a>
      <a href="/php/heldorders">Held Orders</a>
      <a href="/php/harrodsImport">Harrods Ecom Import</a>
     <%if retrieveUserRegion()=1 or retrieveuserlocation()=34 or retrieveuserlocation()=24 or retrieveuserlocation()=17 or retrieveuserlocation()=37 or retrieveuserlocation()=39 then%>
      <a href="/php/quotes">Quotes</a>
      <%end if%>
    </div>
  </li>
  <%end if%>
 <%if userHasRoleInList("ADMINISTRATOR") then %>
  <li class="dropdown">
    <a href="#" class="dropbtn">Production</a>
    <div class="dropdown-content">
      <a href="/php/shipper">Add Shipper</a>
      <a href="/php/consignee">Add Consignee</a>
      <a href="/php/ordersinproduction">Orders In Production</a>
      <a href="/php/packagingdata">Packaging Information</a>
      <a href="/php/itemsproduced">Production Admin</a>
      <a href="/php/productionlist">Production List</a>
      <a href="/php/StaffPicklist">Staff List</a>
      <a href='/php/fabricstatus'>Fabric Screen</a>
      <a href='/php/accessory'>Accessories Screen</a>
      <hr />
      <a href="/php/deliveriesbooked?madeat=1">Cardiff Screen</a>
      <a href="/php/deliveriesbooked?madeat=2">London Screen</a>
      <a href="http://wrap.savoirproduction.co.uk/production.php">Labels Screen</a>
    </div>
  </li>
  <%end if%> 
  <%if retrieveUserLocation=1 or retrieveUserLocation=27 or retrieveUserRegion>1 then%>
  <li class="dropdown">
    <a href="#" class="dropbtn">Sales Admin</a>
    <div class="dropdown-content">
    <%if (retrieveUserLocation()=1  or retrieveUserLocation()=27) then%>
      <a href="/php/CancelledExports">Cancelled Shipments</a>
      <%end if%>
      <a href="/php/DeliveredShipments">Delivered Shipments</a>
      <a href="/php/PlannedExports">Planned Export Collections</a>
    </div>
  </li>
  <%end if%> 
  <%if retrieveUserRegion()=1 then %>
  <li class="dropdown">
    <a href="#" class="dropbtn">Reports</a>
    <div class="dropdown-content">
      <a href="/php/revenue">Accounts</a>
      <a href="/php/brochurereport">Brochures for Prospects</a>
      <%if userHasRoleInList("ADMINISTRATOR") then %>
      <a href="/php/BrochureFollowUp">Brochure Followup Reports</a>
      <%end if%>
      <a href="/php/customerordersreport">Customer Orders</a>
      <a href="/php/CustomerReadyNotInvoiced">Customer Ready Not Invoiced</a>
      <a href="/php/deliveryreport">Delivery</a>
      <%if isSuperUser() or retrieveUserId()=209 then %> 
      <a href="/php/customerprospectreport">Full Customer/Prospects</a>
      <%end if%>
      <%if userHasRoleInList("ADMINISTRATOR") then %>
      <a href="/php/orderStatusReport">Order Status Report</a>
      <%end if%>
      <%if isSuperUser() or retrieveUserId()=199 or retrieveUserId()=90 then %> 
      <a href="/php/showroomordersreport">Showroom Report</a>
      <%end if%>
      <%if userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR,SALES") then %>
		<a href="/php/ShowroomSalesReportPopup">Showroom Sales Report</a>
      <%end if%>
      <a href="/php/tradesearch">Trade</a>
     
    </div>
  </li>

  <%end if%>
  
  <%if retrieveuserregion<>1 and userHasRole("REGIONAL_ADMINISTRATOR") then %>
  <li class="dropdown">
    <a href="#" class="dropbtn">Reports</a>
    <div class="dropdown-content">
      <a href="/php/deliveryreport">Delivery</a>
    </div>
	<% if isSavoirOwned() then %>
		<div class='dropdown-content'>
			<a href="/php/ShowroomSalesReportPopup">Showroom Sales Report</a>
		</div>
	<%end if%>
  </li>
  <%end if%>

	<% if not isSuperUser() and retrieveuserregion<>1 and not userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR") and userHasRole("SALES") and isSavoirOwned() then %>
	<li class='dropdown'><a href='#' class='dropbtn'>Reports</a>
		<div class='dropdown-content'>
			<a href="/php/ShowroomSalesReportPopup">Showroom Sales Report</a>
		</div>
	</li>
	<%end if%>

  <%if retrieveUserid()=219 then %>
  <li class="dropdown">
    <a href="#" class="dropbtn">Reports</a>
    <div class="dropdown-content">

      <a href="/php/customerprospectreport/ny">Full Customer/Prospects</a>
    </div>
  </li>
  <%end if%>
  <%if isSuperUser() then %>
  <li class="dropdown">
    <a href="#" class="dropbtn">Admin Control</a>
    <div class="dropdown-content">
      <a href="/php/correspondence">Correspondence</a>
      <a href="/php/spamdelete">Delete Spam</a>
      <a href="/php/showrooms">Edit Showrooms</a>
      <a href="/php/terms">Edit Terms & Conditions</a>
      <a href="/php/pricingmatrix">Pricing Matrix</a>
      <a href="/wholesale-price-report.asp">Wholesale Price Report</a>
	  <a href="/php/newsalesfigures/monthly">Sale Figures</a>
	  <a href="/php/useradmin/">Manage Users</a>
	
  </li>
  <%end if%>  
</ul>
</div>
<div id="adminhdr2">
<form action="/php/advancedsearch/results" method="post" name="formSearch3" id="formSearch3" onSubmit="return FrontPageForm1_Validator(this)">
	
				  <label for="surname" id="surname" ><strong>Surname:</strong>
				    <input name="surname" type="text" class="text" id="surname" size="16" />
			      </label><label for="cref" id="cref"><strong>&nbsp;&nbsp;Customer Ref:</strong>
				    <input name="cref" type="text" class="text" id="cref" size="16" />
			      </label><label for="company" id="cref"><strong>&nbsp;&nbsp;Company:</strong>
				    <input name="company" type="text" class="text" id="company" size="16" />
			      </label> <label for="orderno" id="orderno"><strong>&nbsp;&nbsp;Order No:</strong>
				    <input name="orderno" type="text" class="text" id="orderno" size="7" />
			      </label> <input name="channel" type="hidden" value="n">
				  <input name="type" type="hidden" value="n">
				  <input name="qresults" type="hidden" value="y">
				  <input name='channel' type='hidden' value=''>
		<input name='type' type='hidden' value='n'>
		<input name='qresults' type='hidden' value='y'>
		<input name='sb' type='hidden' value='SB'>
		<input name='postcode' type='hidden' value=''>
		<input name='contacttype' type='hidden' value=''>
		<input name='location' type='hidden' value=''>
				  <input type="submit" name="submitSearch" value="Search"  id="submitSearch" class="button" />
		   &nbsp;&nbsp;<a href="/php/AdvancedSearch">Advanced Search</a>
      </form>
      <script Language="JavaScript" type="text/javascript">
<!--
function FrontPageForm1_Validator(theForm)
{
 
   if ((theForm.surname.value == "") && (theForm.orderno.value == "") && (theForm.company.value == "") && (theForm.cref.value == ""))
  {
    alert("Please complete one of the fields to obtain results");
    theForm.surname.focus();
    return (false);
  }

if ((theForm.surname.value != "") && (theForm.surname.value.length <2))
  {
    alert("Surname needs to be at least 2 characters long");
    theForm.surname.focus();
    return (false);
  }

    return true;
} 

	function showShowroomSalesReportPopup() {
		window.open('/php/ShowroomSalesReportPopup','popUpWindow','height=100,width=500,left=100,top=100,resizable=no,scrollbars=no,toolbar=no,menubar=no,location=no,directories=no, status=yes');
	}
//-->
</script>

</div>
