<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES,WEBSITEADMIN"
dim orderexists, Con, rs, rs1, sql, contactno
contactno=""
orderexists=""
orderexists=Request("orderexists")
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="customer_service_followup_email.asp" -->


<%
dim cardiffNo, londonNo, londonitems, cardiffitems, n, headText
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


if CDbl(cardiffNo)=0 then
cardiffNo=0
else
cardiffNo=round(CDbl(cardiffitems)/CDbl(cardiffNo)+0.5)
end if
if CDbl(cardiffNo)=0 then
londonNo=0
else
londonNo=round(CDbl(londonitems)/CDbl(londonNo)+0.5)
end if


headText = "<div> <a href='/php/home' style='float:left;'><img src='/images/logo-s.gif' border='0' /></a>" & _
  "<p align='right' style='margin-top:14px;float:right;'>&nbsp;Lead Time: London ="& londonNo&" weeks, Cardiff = " & cardiffNo &" weeks | Logged in as "&retrieveUserName()&" | <a href='/access/logout.asp'> Logout</a></p>" & _
"</div>" & _
"<div class='clear'></div>" & _
"<div id='adminhdr'><ul>"

if userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR,SALES") then
  		headText = headText & "<li><a href='/php/AddCustomer'>Add Customer</a></li>"
	end if
end if
headText = headText & "<li class='dropdown'><a href='#' class='dropbtn'>Brochure Requests</a><div class='dropdown-content'>"
if userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR,TESTER") then
	    if retrieveUserRegion()=6 then
		
		else
      		headText = headText & "<a href='/php/OutstandingBrochureRequests'>Outstanding Requests</a>"
    	end if
	end if
if userHasRoleInList("ADMINISTRATOR,REGIONAL_ADMINISTRATOR,TRADE") then
    headText = headText & "<a href='/php/OutstandingCoBrochureRequests'>Company Requests</a>"
end if
headText = headText & "</div></li>"
if retrieveUserRegion()=1 or userHasRoleInList("ONLINE_SHOWROOM") then
  	headText = headText & "<li><a href='/php/marketingarticles'>Marketing</a></li>"
 end if
 if retrieveUserRegion()=1 or retrieveUserRegion()=27 or userHasRoleInList("ONLINE_SHOWROOM") then
  	headText = headText & "<li class='dropdown'><a href='#' class='dropbtn'>Customer Services</a>" & _
    		"<div class='dropdown-content'><a href='/php/customerservice/add'>Add Case</a>"
    if userHasRoleInList("ADMINISTRATOR") then 
      	headText = headText & "<a href='/php/customerservicehistory'>Closed Cases</a>"
    end if
    headText = headText & "<a href='/php/customerservice'>Outstanding Cases</a></div></li>"
 end if
 if retrieveUserRegion()=1 or retrieveuserlocation()=8 or retrieveuserlocation()=24 or retrieveuserlocation()=25 or retrieveuserlocation()=34 or retrieveuserlocation()=31 or retrieveuserregion()=26 or retrieveuserlocation()=35 or retrieveuserlocation()=17 or retrieveuserlocation()=33 or retrieveuserlocation()=14 or retrieveUserRegion()=17 or retrieveuserregion()=19  or retrieveuserlocation()=40 or retrieveuserlocation()=41 then
  	headText = headText & "<li class='dropdown'><a href='#' class='dropbtn'>Orders</a>" & _
  			"<div class='dropdown-content'><a href='/php/awaitingorders'>Awaiting Confirmation</a>" & _
      		"<a href='/php/currentorders'>Current Orders</a><a href='/php/heldorders'>Held Orders</a>" & _
			"<a href='/php/harrodsImport'>Harrods Ecom Import</a>"
    if retrieveUserRegion()=1 then
      	headText = headText & "<a href='/php/quotes'>Quotes</a>"
    end if
    headText = headText & "</div></li>"
 end if
 if userHasRoleInList("ADMINISTRATOR") then
  		headText = headText & "<li class='dropdown'><a href='#' class='dropbtn'>Production</a>" & _
    			"<div class='dropdown-content'>" & _
      			"<a href='/php/shipper'>Add Shipper</a>" & _
      			"<a href='/php/consignee'>Add Consignee</a>" & _
      			"<a href='/php/ordersinproduction'>Orders In Production</a>" & _
      			"<a href='/php/packagingdata'>Packaging Information</a>" & _
      			"<a href='/php/itemsproduced'>Production Admin</a>" & _
      			"<a href='/php/productionlist'>Production List</a>" & _
      			"<a href='/php/fabricstatus'>Fabric Screen</a>" & _
      			"<a href='/php/accessory'>Accessories Screen</a>" & _
      			"<a href='/php/StaffPicklist'>Staff List</a><hr />" & _
      			"<a href='/php/deliveriesbooked?madeat=1'>Cardiff Screen</a>" & _
      			"<a href='/php/deliveriesbooked?madeat=2'>London Screen</a>" & _
      			"<a href='http://wrap.savoirproduction.co.uk/production.php'>Labels Screen</a></div></li>"
      			"<a href='http://wrap.savoirproduction.co.uk/qcMonitor/qcIndex.php'>QC Screen</a>"
 end if
 if retrieveUserLocation=1 or retrieveUserLocation=27 or retrieveUserRegion>1 then
  	headText = headText & "<li class='dropdown'><a href='#' class='dropbtn'>Sales Admin</a>" & _
    		"<div class='dropdown-content'>"
 	if (retrieveUserLocation()=1  or retrieveUserLocation()=27) then
    	headText = headText & "<a href='/php/CancelledExports'>Cancelled Shipments</a>"
	end if
    headText = headText & "<a href='/php/DeliveredShipments'>Delivered Shipments</a>" & _
      "<a href='/php/PlannedExports'>Planned Export Collections</a></div></li>"
end if
if retrieveUserRegion()=1 then
  headText = headText & "<li class='dropdown'>" & _
    "<a href='#' class='dropbtn'>Reports</a>" & _
    "<div class='dropdown-content'>" & _
      "<a href='/php/revenue'>Accounts</a>" & _
      "<a href='/php/brochurereport'>Brochures for Prospects</a>" & _
      "<a href='/php/customerordersreport'>Customer Orders</a>" & _
      "<a href='/php/CustomerReadyNotInvoiced'>Customer Ready Not Invoiced</a>" & _
      "<a href='/php/deliveryreport'>Delivery</a>"
   if isSuperUser() then
      headText = headText & "<a href='/php/customerprospectreport'>Full Customer/Prospects</a>"
   end if
   if userHasRoleInList("ADMINISTRATOR") then
   headText = headText & "<a href='/php/orderStatusReport'>Order Status Report</a>"
	end if
   
   
   if isSuperUser() or retrieveUserID()=90 then
      headText = headText & "<a href='/php/showroomordersreport'>Showroom Report</a>"
   end if
   headText = headText & "<a href='/php/tradesearch'>Trade</a>"
  
   headText = headText & "</div></li>"
end if
if isSuperUser() then
	headText = headText & "<li class='dropdown'>" & _
    	"<a href='#' class='dropbtn'>Admin Control</a>" & _
    	"<div class='dropdown-content'>" & _
        "<a href='/php/correspondence'>Correspondence</a>" & _
      	"<a href='/php/spamdelete'>Delete Spam</a>" & _
      	"<a href='/php/showrooms'>Edit Showrooms</a>" & _
      	"<a href='/php/terms'>Edit Terms & Conditions</a>" & _
      	"<a href='/php/pricingmatrix'>Pricing Matrix</a>" & _
      	"<a href='/wholesale-price-report.asp'>Wholesale Price Report</a>" & _
      	"<a href='/php/newsalefigures/monthly'>Sale Figures</a>" & _
      	"<a href='/php/useradmin/'>Manage Users</a></div></li>"
      	
end if
headText = headText & "</ul></div><div id='adminhdr2'>" & _
	"<form action='/php/advancedsearch/results' method='post' name='formSearch3' id='formSearch3' onSubmit='return FrontPageForm1_Validator(this)'>" & _
				  "<label for='surname' id='surname' ><strong>Surname:&nbsp;</strong>" & _
				    "<input name='surname' type='text' class='text' id='surname' size='16' />" & _
			      "</label><label for='cref' id='cref'><strong>&nbsp;&nbsp;Customer Ref:&nbsp;</strong>" & _
				    "<input name='cref' type='text' class='text' id='cref' size='16' />" & _
			      "</label><label for='company' id='cref'><strong>&nbsp;&nbsp;Company:&nbsp;</strong>" & _
				    "<input name='company' type='text' class='text' id='company' size='16' />" & _
			      "</label> <label for='orderno' id='orderno'><strong>&nbsp;&nbsp;Order No:&nbsp;</strong>" & _
				    "<input name='orderno' type='text' class='text' id='orderno' size='7' />" & _
			      "</label> <input name='channel' type='hidden' value='n'>" & _
				  "<input name='type' type='hidden' value='n'>" & _
				  "<input name='qresults' type='hidden' value='y'>" & _
				   "<input name='channel' type='hidden' value=''>" & _
		 "<input name='type' type='hidden' value='n'>" & _
		 "<input name='qresults' type='hidden' value='y'>" & _
		 "<input name='sb' type='hidden' value='SB'>" & _
		 "<input name='postcode' type='hidden' value=''>" & _
		 "<input name='contacttype' type='hidden' value=''>" & _
		 "<input name='location' type='hidden' value=''>
				  "<input type='submit' name='submitSearch' value='Search'  id='submitSearch' class='button' />" & _
		   "&nbsp;&nbsp;<a href='/php/AdvancedSearch'>Advanced Search</a>" & _
      "</form>" & _
      "<script Language='JavaScript' type='text/javascript'>" & _
"function FrontPageForm1_Validator(theForm)" & _
"{ " & _
"   if ((theForm.surname.value == '') && (theForm.orderno.value == '') && (theForm.company.value == '') && (theForm.cref.value == ''))" & _
"  {" & _
"    alert('Please complete one of the fields to obtain results');" & _
"    theForm.surname.focus();" & _
"    return (false);" & _    
"  }" & _
"if ((theForm.surname.value != '') && (theForm.surname.value.length <2))" & _
"  {" & _
"    alert('Surname needs to be at least 2 characters long');" & _
"    theForm.surname.focus();" & _
"    return (false);" & _
"  }" & _
"    return true;" & _
"} " & _
"//-->" & _
"</script>" & _
"</div>"
response.write(headText)
%>
