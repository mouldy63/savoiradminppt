<%
Option Explicit
%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="fieldoptionfuncs.asp" -->
<!-- #include file="customerfuncs.asp" -->
<!-- #include file="feature_switches.asp" -->
<!-- #include file="leadtime-inc.asp" -->
<!-- #include file="pricematrixfuncs.asp" -->

<%
Dim postcode, postcodefull, Con, rs, rs2, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg, msg2, ItemValue, e1, contact_no, deldate, legqty
dim orderno, orderdate, clientstitle, clientsfirst, clientssurname, quote, i, tel, email_address, rsContactAddress, orderCurrency, defaultOrderCurrency, alternateCurrencies, arrCurr, curr
dim delDateValues(), delDateDescriptions(), typenames(), vatRates, defaultVatRate, isTrade
Dim matt1widthsingle, matt1width, matt2width, matt1length, matt2length, base1width, base2width, base1length, base2length, topper1width, topper1length
Dim add1d, add2d, add3d, townd, countyd, postcoded, countryd, preferredshipper, contactd, phoned, sql
Dim overseas, ordersource
Dim longestLeadTime, bcardiffNo, blondonNo, latestDeliveryDate, cardiffDeliveryDate, londonDeliveryDate, VATwording

overseas = request("overseas")
ordersource=request("ordersource")
'response.Write("ordersource=" & ordersource)
if overseas = "" then overseas = "n"
quote = ""
quote = Request("quote")
contact_no = Request("contact_no")
correspondence = Request("correspondence")
count = 0
legqty = 0
if retrieveuserlocation()=34 then
VATwording="NY Tax"
else
VATwording="VAT Rate"
end if
if request("legqty") <> "" then legqty = request("legqty")

Set Con = getMysqlConnection()

call getLongestLeadTime(con, longestLeadTime, bcardiffNo, blondonNo)
latestDeliveryDate = getRoundedApproxDateString(longestLeadTime)
cardiffDeliveryDate = getRoundedApproxDateString(bcardiffNo)
londonDeliveryDate = getRoundedApproxDateString(blondonNo)

defaultOrderCurrency = getCurrencyForLocation(retrieveUserLocation(), con)
isTrade = isTradeCustomer(con, contact_no)

set rsContactAddress = getMysqlQueryRecordSet("Select * from contact c, address a where c.code=a.code and c.contact_no=" & contact_no, con)
orderno = getNextOrderNumber(con)
orderdate = now()
clientstitle = rsContactAddress("title")
clientsfirst = rsContactAddress("first")
clientssurname = rsContactAddress("surname")
orderCurrency = defaultOrderCurrency

'get default delivery address

' New York customers should have 271 Scholes Street set as their default delivery address if not already set
call setDefaultDeliveryAddress(con, contact_no, -1, 8) ' idlocation 8 is NY

set rs = getMysqlQueryRecordSet("Select * from delivery_address where isdefault='y' AND contact_no=" & contact_no, con)
'response.write("<br>add-order.asp: default delivery address id = " & rs("DELIVERY_ADDRESS_ID"))
'response.end
if not rs.eof then
add1d = rs("add1")
add2d = rs("add2")
add3d = rs("add3")
townd = rs("town")
countyd = rs("countystate")
postcoded = rs("postcode")
countryd = rs("country")
contactd = rs("contact")
phoned = rs("phone")
end if
call closeRs(rs)


' get any alternate currencies
set rs = getMysqlQueryRecordSet("Select alternatecurrencies from location where idLocation=" & retrieveUserLocation(), con)
if not rs.eof then
alternateCurrencies = rs("alternatecurrencies")
end if
call closeRs(rs)

if not IsNull(rsContactAddress("preferredshipper") ) then preferredshipper = rsContactAddress("preferredshipper") else preferredshipper = ""
deldate = request("deldate")
if isnull(deldate) or deldate = "" then
' default deldate not in request, so default it from
deldate = DateAdd("ww", longestLeadTime, date())
end if
call makeApproxDateOptions(delDateValues, delDateDescriptions, deldate)

call getPhoneNumberTypes(con, typenames)
defaultVatRate = session("vatrate")
vatRates = getVatRates(con, defaultVatRate, retrieveUserLocation() )
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html lang = "en">
<head>
<title>Administration.</title>

<meta content = "text/html; charset=UTF-8" http-equiv = "content-type" />

<meta HTTP-EQUIV = "ROBOTS" content = "NOINDEX,NOFOLLOW" />

<link href = "Styles/extra.css" rel = "Stylesheet" type = "text/css" />

<link href = "Styles/screen.css" rel = "Stylesheet" type = "text/css" />

        <link href = "Styles/print.css" rel = "Stylesheet" type = "text/css" media = "print" />

<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>

<script src = "common/jquery.eComboBox.custom.js" type = "text/javascript"></script>

<script src = "scripts/keepalive.js"></script>

<script src = "scripts/datevalidation.js"></script>
<!-- #include file="pricematrixenabled.asp" -->
<script src = "price-matrix-funcs.js?date=<%=theDate%>"></script>
<script src = "common/utils.js?date=<%=theDate%>"></script>
<script src = "order-funcs.js?date=<%=theDate%>"></script>
<script src = "add-edit-order-common-funcs.js?date=<%=theDate%>"></script>
        <%if userHasRoleInList("NOPRICESUSER") then
'if (retrieveuserid()=181 or retrieveuserid()=182) then%>
<link href="Styles/noprices.css" rel="Stylesheet" type="text/css" />
<%end if%>
<script src="calendar-addorder.js"></script>
    </head>

<body>
<div class = "container">
<!-- #include file="header.asp" -->
<div class = "content brochure">
<%
If quote = "y" Then
%>

<p>ADD QUOTE</p>
<%
Else
%>

<p>ADD ORDER</p>
<%
End If
%>
<%if ordersource<>"" then response.Write("<p>" & ordersource & " Order</p>")%>
<form action = "order-added.asp" method = "post" name = "form1" id="form1"
onSubmit = "return FrontPage_Form1_Validator(this)">
<input type = "hidden" name = "currency" id = "currency" value = "<%= orderCurrency %>" />

<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
<tr>
<td width = "10%">
Contact:
</td>

<td width = "23%">
<select name = "contact" tabindex = "1">
<option value = "<%= retrieveUserName() %>"
<%= selected(retrieveUserName(), request("contact")) %>><%= retrieveUserName() %></option>
</select>
</td>

<td colspan = "2">
Invoice Address:
</td>

<td colspan = "2">
Delivery Address:&nbsp;<button type = "button" onClick = 'copyInvToDelAddr();'>Same as
Contact</button>

<p> <%
set rs2 = getMysqlQueryRecordSet("Select * from delivery_address where retire='n' AND contact_no=" & contact_no & " order by isdefault desc", con)
if not rs2.eof then
%>
<label for = "deladddropdown"></label>

<select name = "deladddropdown" id = "deladddropdown"
onchange = "javascript:populateDelAdd();">
<%
do until rs2.eof
%>

<option value = "<%= rs2("DELIVERY_ADDRESS_ID") %>"><%= rs2("DELIVERY_NAME") %></option>
<%
rs2.movenext
loop
%>
</select>
<%
end if
call closeRs(rs2)
%>

</p>
</td>
</tr>

<tr>
<td>
<%
If quote = "y" Then
%>

Quote
<%
Else
%>

Order
<%
End If
%>

No:
</td>

<td>
<input type = "text" name = "orderno" value = "<%= orderno %>" tabindex = "2" readonly>
</td>

<td width = "8%">
Line 1:
</td>

<td width = "28%">
<input name = "add1" type = "text" id = "add1" tabindex = "10"
value = "<%= rsContactAddress("street1") %>" size = "30" maxlength = "100">
</td>

<td width = "8%">
Line 1:
</td>

<td width = "23%">
<input name = "add1d" value = "<%= add1d %>" type = "text" id = "add1d" tabindex = "20"
size = "30" maxlength = "100">
</td>
</tr>

<tr>
<td>
Date:
</td>

<td>
<input name = "orderdate" type = "text" id = "orderdate" tabindex = "3"
value = "<%= orderdate %>" readonly>
</td>

<td>
Line 2:
</td>

<td>
<input name = "add2" type = "text" id = "add2" tabindex = "11"
value = "<%= rsContactAddress("street2") %>" size = "30" maxlength = "100">
</td>

<td>
Line 2:
</td>

<td>
<input name = "add2d" type = "text" value = "<%= add2d %>" id = "add2d" tabindex = "21"
size = "30" maxlength = "100">
</td>
</tr>

<tr>
<td>
Customer Reference:
</td>

<td>
<input name = "reference" value = "<%= request("reference") %>" type = "text"
id = "reference" tabindex = "4" maxlength = "30">
</td>

<td>
Line 3:
</td>

<td>
<input name = "add3" type = "text" id = "add3" tabindex = "11"
value = "<%= rsContactAddress("street3") %>" size = "30" maxlength = "100">
</td>

<td>
Line 3:
</td>

<td>
<input name = "add3d" value = "<%= add3d %>" type = "text" id = "add3d" tabindex = "21"
size = "30" maxlength = "100">
</td>
</tr>

<tr>
<td>
Clients Title:
</td>

<td>
<input name = "clientstitle" type = "text" id = "clientstitle" tabindex = "5"
value = "<%= clientstitle %>">
</td>

<td>
Town:
</td>

<td>
<input name = "town" type = "text" id = "town" tabindex = "12"
value = "<%= rsContactAddress("town") %>" size = "30" maxlength = "100">
</td>

<td>
Town:
</td>

<td>
<input name = "townd" value = "<%= townd %>" type = "text" id = "townd" tabindex = "22"
size = "30" maxlength = "100">
</td>
</tr>

<tr>
<td>
First Name:
</td>

<td>
<input name = "clientsfirst" type = "text" id = "clientsfirst" tabindex = "5"
value = "<%= clientsfirst %>">
</td>

<td>
County:
</td>

<td>
<input name = "county" type = "text" id = "county" tabindex = "13"
value = "<%= rsContactAddress("county") %>" size = "30" maxlength = "100">
</td>

<td>
County:
</td>

<td>
<input name = "countyd" value = "<%= countyd %>" type = "text" id = "countyd"
tabindex = "23" size = "30" maxlength = "100">
</td>
</tr>

<tr>
<td>
Surname:
</td>

<td>
<input name = "clientssurname" type = "text" id = "clientssurname" tabindex = "5"
value = "<%= clientssurname %>">
</td>

<td>
Postcode:
</td>

<td>
<input name = "postcode" type = "text" id = "postcode" tabindex = "14"
value = "<%= rsContactAddress("postcode") %>" size = "15" maxlength = "50">
</td>

<td>
Postcode:
</td>

<td>
<input name = "postcoded" value = "<%= postcoded %>" type = "text" id = "postcoded"
tabindex = "24" size = "15" maxlength = "50">
</td>
</tr>

<tr>
<td>
Tel Home:
</td>

<td>
<input name = "tel" type = "text" id = "tel" tabindex = "5"
value = "<%= recordSetOrSession("tel", rsContactAddress) %>">
</td>

<td>
Country:
</td>

<td>
<input name = "country" type = "text" id = "country" tabindex = "15"
value = "<%= rsContactAddress("country") %>" size = "30" maxlength = "100">
</td>

<td>
Country:
</td>

<td>
<input name = "countryd" value = "<%= countryd %>" type = "text" id = "countryd"
tabindex = "25" size = "30" maxlength = "100">
</td>
</tr>

<tr>
<td>
Tel Work:
</td>

<td>
<input name = "telwork" type = "text" id = "telwork" tabindex = "5"
value = "<%= recordSetOrSession("telwork", rsContactAddress) %>" />

&nbsp;
</td>

<td rowspan = "3">&nbsp;

</td>
<td rowspan = "3"> </td>

<td>
Contact Name:
</td>

<td>
<input name = "deliverycontact" type = "text" id = "deliverycontact" tabindex = "25"
value = "<%= requestOrSession("deliverycontact") %>" size = "30" maxlength = "100">
</td>
</tr>

<tr>
<td>
Mobile:
</td>

<td>
<input name = "mobile" type = "text" id = "mobile" tabindex = "5"
value = "<%= recordSetOrSession("mobile", rsContactAddress) %>">
&nbsp;
</td>

<td>
Contact number 1:
</td>

<td>
<select name = "delphonetype1" id = "delphonetype1">
<%
for n = 1 to ubound(typenames)
%>

<option value = "<%= typenames(n) %>"
<%= selected(typenames(n), request("delphonetype1")) %>><%= typenames(n) %></option>
<%
next
%>
</select>

&nbsp;

<input name = "delphone1" type = "text" id = "delphone1"
value = "<%= request("delphone1") %>" />
</td>
</tr>

<tr>
<td>
Email Address:
</td>

<td>
<input name = "email_address" type = "text" id = "email_address" tabindex = "5"
value = "<%= recordSetOrSession("email_address", rsContactAddress) %>">
</td>

<td>
Contact number 2:
</td>

<td>
<select name = "delphonetype2" id = "delphonetype2">
<%
for n = 1 to ubound(typenames)
%>

<option value = "<%= typenames(n) %>"
<%= selected(typenames(n), request("delphonetype2")) %>><%= typenames(n) %></option>
<%
next
%>
</select>

&nbsp;

<input name = "delphone2" type = "text" id = "delphone2"
value = "<%= request("delphone2") %>" />
</td>
</tr>

<tr>
<%
if not hideVatRate(con, contact_no) then
%>

<td>
<%=VATwording%>
</td>

                                <td>
                                    <select name = "vatrate" class="xview" id = "vatrate">
                                        <%
                                        for n = 1 to ubound(vatRates)
                                        %>

                                            <option value = "<%= vatRates(n) %>"
                                                <%= selected(defaultVatRate, vatRates(n)) %>><%= formatNumber(vatRates(n), 3, -1) %>%</option>
                                            <%
                                            next
                                            %>
                                    </select>&nbsp;
                                </td>
                            <%
                            else
                                if defaultVatRate = "" then
                                    defaultVatRate = vatRates(1)
                                end if
                            %>

<td>&nbsp;

</td>

<td>
<input type = "hidden" name = "vatrate" id = "vatrate"
value = "<%= defaultVatRate %>" />
</td>
<%
end if
%>
<%
if rsContactAddress("company_vat_no") <> "" then
%>

<td>
Company VAT Number:
</td>

<td><%= rsContactAddress("company_vat_no") %></td>
<%
else
%>

<td>&nbsp;

</td>

<td>&nbsp;

</td>
<%
end if
%>

<td>
Contact number 3:
</td>

<td>
<select name = "delphonetype3" id = "delphonetype3">
<%
for n = 1 to ubound(typenames)
%>

<option value = "<%= typenames(n) %>"
<%= selected(typenames(n), request("delphonetype3")) %>><%= typenames(n) %></option>
<%
next
%>
</select>

&nbsp;

<input name = "delphone3" type = "text" id = "delphone3"
value = "<%= request("delphone3") %>" />
</td>
</tr>

<tr>
<td>Wrap Type:

</td>

<td><%Set rs2 = getMysqlUpdateRecordSet("Select * from WrappingTypes", con)%>
<select name="wraptype" id="wraptype" >
<%do until rs2.eof
%>
<option value="<%=rs2("wrappingid")%>"><%=rs2("wrap")%></option>
<%rs2.movenext
loop
rs2.close
set rs2=nothing%>
</select>

</td>

<td>
Company Name:
</td>

<td>
<input name = "companyname"
value = "<%= recordSetOrSession("company", rsContactAddress) %>" type = "text"
id = "companyname" tabindex = "26" size = "30" maxlength = "255">
</td>

<td>
<%
if retrieveUserRegion = 1 then
%>Production Date:
<%
end if
%></td>

<td>
<%
if retrieveUserRegion = 1 then
%><input name = "productiondate" value = "<%= request("productiondate") %>"
type = "text" id = "productiondate" size = "10" maxlength = "10">
<a href="javascript:clearproductiondate();">X</a>
<%
end if
%>
</td>
</tr>

<tr>
<td>
<%
if not hideOrderType(con, contact_no) then
%>Select Order Type:
<%
end if
%></td>

<td>
<%
if retrieveUserRegion() = 1 then
Set rs = getMysqlUpdateRecordSet("Select * from ORDERTYPE", con)
else
Set rs = getMysqlUpdateRecordSet("Select * from ORDERTYPE where UKOnly='n'", con)
end if

if hideOrderType(con, contact_no) then
%>

<input type = "hidden" name = "ordertype" id = "ordertype"
value = "<%= rs("ordertypeid") %>" />
<%
else
%>

<select name = "ordertype" id = "ordertype">
<%
Do until rs.EOF
%>

<option value = "<%= rs("ordertypeid") %>"
<%= selected(rs("ordertypeid"), request("ordertype")) %>><%= rs("ordertype") %></option>
<%
rs.movenext
loop
%>
</select>
</td>
<%
end if
call closeRs(rs)
if retrieveUserRegion() = 1 and overseas = "n" then
%>

<td>
Approx. Delivery Date:
</td>

<td>
<select id = "deldate" name = "deldate" tabindex = "4">
<%
for i = 1 to ubound(delDateValues)
%>

<option value = "<%= delDateValues(i) %>"
<%= selected(delDateValues(i), deldate) %>><%= delDateDescriptions(i) %></option>
<%
next
%>
</select>
</td>
<%
else
%>

<td>
Ex. Works Date:
</td>
<%
if retrieveUserLocation() = 1 or retrieveUserLocation() = 27 then
Set rs = getMysqlUpdateRecordSet("Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation order by E.collectiondate", con)
else
sql = "Select * from exportcollections E, exportCollShowrooms C, Location L where E.collectionStatus=1 and E.exportCollectionsID=C.exportcollectionID and C.idlocation=L.idlocation and C.idlocation=" & retrieveUserLocation() & " order by E.collectiondate"

Set rs = getMysqlUpdateRecordSet(sql, con)
end if
%>

<td>
<select id = "exworksdate" name = "exworksdate" tabindex = "4">
<option value = "n">TBA</option>
<%
Do until rs.eof
%>

<option value = "<%= rs("exportCollShowroomsID") %>"><%
response.Write(rs("location") & ", " & rs("CollectionDate") )
%></option>
<%
rs.movenext
loop
rs.close
set rs = nothing
%>
</select>
</td>
<%
end if
%>
<%
if retrieveUserRegion = 1 then
%>

<td>
Booked Delivery Date:
</td>

<td>
<input name = "bookeddeliverydate"
value = "<%= request("bookeddeliverydate") %>" type = "text"
id = "bookeddeliverydate" size = "10" maxlength = "10">
<a href="javascript:clearbookeddeliverydate();">X</a>
</td>
<%
else
%>

<td>&nbsp;

</td>

<td>&nbsp;

</td>
<%
end if
%>
</tr>

<tr>
<%
if retrieveUserRegion() = 1 then
%>

<td>
Acknowledgement Date:
</td>

<td>
<input name = "acknowdate" value = "<%= request("acknowdate") %>" type = "text"
id = "acknowdate" size = "10" maxlength = "10">
<a href="javascript:clearacknowdate();">X</a>
</td>

<td>
Acknowledgement Version:
</td>

<td>
<select id = "acknowversion" name = "acknowversion">
<option />
<%
for i = 1 to 20
%>

<option value = "<%= i %>"
<%= selected(request("acknowversion"), i) %>><%= i %></option>
<%
next
%>
</select>
</td>
<%
else
%>

<td colspan = "4">&nbsp;

</td>
<%
end if
%>
<%
if not hideOrderCurrency(con, contact_no) then
%>

<td>
Order Currency:
</td>

<td>
<%
if alternateCurrencies <> "" then
arrCurr = split(alternateCurrencies, ",")
%>

<select name = "ordercurrency" id = "ordercurrency"
onchange = "changeCurrency();">
<option value = "<%= defaultOrderCurrency %>"
<%= selected(defaultOrderCurrency, orderCurrency) %>><%= defaultOrderCurrency %></option>
<%
for each curr in arrCurr
%>

<option value = "<%= curr %>"
<%= selected(curr, orderCurrency) %>><%= curr %></option>
<%
next
%>
</select>
<%
else
%>

<input name = "ordercurrency" value = "<%= orderCurrency %>" type = "text"
id = "ordercurrency" tabindex = "27" size = "30" maxlength = "3" readonly />
<%
end if
%>
</td>
<%
else
%>

<input name = "ordercurrency" value = "<%= orderCurrency %>" type = "hidden"
id = "ordercurrency" />
<%
end if
%>
</tr>

<tr>
<%
if not hideShipper(con, contact_no) then
%>

<td>
Select Shipper:
</td>

<td colspan = "5">
<%
set rs2 = getMysqlQueryRecordSet("Select * from shipper_address  order by shippername desc", con)
if not rs2.eof then
%>
<label for = "shipper"></label>

<select name = "shipper" id = "shipper">
<option value = "">Select Shipper</option>
<%
do until rs2.eof
%>

<option value = "<%= rs2("SHIPPER_ADDRESS_ID") %>"
<%= selected(preferredshipper, rs2("SHIPPER_ADDRESS_ID")) %>><%
response.Write(rs2("shipperName") & ", " & rs2("town") )
%></option>
<%
rs2.movenext
loop
%>
</select>
<%
end if
call closeRs(rs2)
%>&nbsp;
</td>
<%
else
%>

                                <td colspan = "2">
                                    <input type = "hidden" name = "shipper" id = "shipper"
                                        value = "<%= preferredshipper %>" />
                                </td>
                            <%
                            end if
                            %>
      </tr>
    </table>

<br>
<%
if retrieveUserRegion() = 1 then
%>

<div id = "ordernote">
<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
<tr>
<td>
Order Notes:
</td>

<td>
<textarea name = "ordernote_notetext" cols = "50" rows = "2"
class = "indentleft"><%= request("ordernote_notetext") %></textarea>
</td>

<td>
<input name = "ordernote_followupdate"
value = "<%= request("ordernote_followupdate") %>" type = "text"
id = "ordernote_followupdate" size = "10" maxlength = "10">
<a href="javascript:clearordernote_followupdate();">X</a>
</td>

<td>
<select name = "ordernote_action" id = "ordernote_action">
<option value = "<%= ACTION_REQUIRED %>"
<%= selected(ACTION_REQUIRED, request("ordernote_action")) %>><%= ACTION_REQUIRED %></option>

<option value = "<%= NO_FURTHER_ACTION %>"
<%= selected(NO_FURTHER_ACTION, request("ordernote_action")) %>><%= NO_FURTHER_ACTION %></option>
</select>
</td>
</tr>
</table>
</div>
<%
end if
%>
<div class = "clear"></div>

<p class = "purplebox"><span class = "radiobxmargin">Mattress Required</span>&nbsp;Yes

<label> <input type = "radio" name = "mattressrequired" id = "mattressrequired" value = "y"
<%= ischeckedY(request("mattressrequired")) %>
onClick = "mattressChanged(); headboardwidthOptions();  getMadeAt()"></label>

No

<input name = "mattressrequired" type = "radio" id = "mattressrequired" value = "n"
<%= ischeckedN(request("mattressrequired")) %>
onClick = "mattressChanged(); headboardwidthOptions();  getMadeAt()"></p>

<div id = "mattress_div">
<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
<tr>
<td width = "11%">
Savoir Model:
</td>

<td width = "22%">
<% 'if retrieveUserRegion()=1 then
'Set rs = getMysqlUpdateRecordSet("Select * from Bedmodel where retired='n' order by priority asc", con)
'else
Set rs = getMysqlUpdateRecordSet("Select * from Bedmodel where bedmodelid<>14 and UKonly='n' and retired='n' order by priority asc", con)
'end if
%>

                                    <select name = "savoirmodel" id = "savoirmodel" tabindex = "30"
                                        onChange = "defaultBaseModel(); defaultVentPosition(); getStandardMattressPrice();  getMadeAt(); javascript:showtickingoptions();">
                                        <option value = "n"<%= selected("n", request("savoirmodel")) %>>--</option>
                                        <%
                                        do until rs.eof
                                        %>

<option value = "<%= rs("bedmodel") %>"
<%= selected(rs("bedmodel"), request("savoirmodel")) %>><%= rs("bedmodel") %></option>
<%
rs.movenext
loop
rs.close
set rs = nothing
%>
</select>
</td>

<td width = "10%">
Mattress Type:
</td>

<td>
<%
Set rs = getMysqlUpdateRecordSet("Select * from Bedmodel where retired='n' order by priority asc", con)
%>

<select name = "mattresstype" id = "mattresstype" tabindex = "31"
onChange = "javascript:mattspecialwidthSelected(true); javascript:mattspeciallengthSelected(true);">
" >
</select>
</td>

<td width = "8%">
Ticking Options
</td>

<td width = "24%">
<select name = "tickingoptions" id = "tickingoptions" tabindex = "32"
onChange = "javascript:defaultTopperTickingOptions(); javascript:defaultBaseTickingOptions();">
<option value = "n"<%= selected("n", request("tickingoptions")) %>>--</option>

<option value = "TBC"
<%= selected("TBC", request("tickingoptions")) %>>TBC</option>

<option value = "White Trellis"
<%= selected("White Trellis", request("tickingoptions")) %>>White
Trellis</option>

<option value = "Grey Trellis"
<%= selected("Grey Trellis", request("tickingoptions")) %>>Grey
Trellis</option>

<option value = "Silver Trellis"
<%= selected("Silver Trellis", request("tickingoptions")) %>>Silver
Trellis</option>

                                        
            </select>
          </td>
        </tr>

<tr>
<td>
Mattress Width:
</td>

<td>
<select name = "mattresswidth" id = "mattresswidth" tabindex = "33"
onChange = "javascript:mattspecialwidthSelected(true);  javascript:setMattressTypes($('#mattresstype option:selected').val()); getStandardMattressPrice();">
<option value = "n"<%= selected("n", request("mattresswidth")) %>>--</option>

<option value = "TBC"
<%= selected("TBC", request("mattresswidth")) %>>TBC</option>

<option value = "90cm"
<%= selected("90cm", request("mattresswidth")) %>>90cm</option>

<option value = "96.5cm"
<%= selected("96.5cm", request("mattresswidth")) %>>96.5cm</option>

<option value = "100cm"
<%= selected("100cm", request("mattresswidth")) %>>100cm</option>

<option value = "140cm"
<%= selected("140cm", request("mattresswidth")) %>>140cm</option>

<option value = "150cm"
<%= selected("150cm", request("mattresswidth")) %>>150cm</option>

<option value = "152.5cm"
<%= selected("152.5cm", request("mattresswidth")) %>>152.5cm</option>

<option value = "160cm"
<%= selected("160cm", request("mattresswidth")) %>>160cm</option>

<option value = "180cm"
<%= selected("180cm", request("mattresswidth")) %>>180cm</option>

<%
if retrieveUserRegion() = 4 or retrieveUserRegion() = 23 or retrieveUserRegion() = 27 then
%>

<option value = "183cm"
<%= selected("183cm", request("mattresswidth")) %>>183cm</option>
<%
end if
%>
<option value = "190cm"
<%= selected("190cm", request("mattresswidth")) %>>190cm</option>

<option value = "193cm"
<%= selected("193cm", request("mattresswidth")) %>>193cm</option>

<option value = "200cm"
<%= selected("200cm", request("mattresswidth")) %>>200cm</option>

<option value = "210cm"
<%= selected("210cm", request("mattresswidth")) %>>210cm</option>

<option value = "Special Width"
<%= selected("Special Width", request("mattresswidth")) %>>Special
Width</option>
</select>
</td>

<td width = "10%">
Mattress Length:
</td>

<td width = "25%">
<select name = "mattresslength" id = "mattresslength" tabindex = "34"
onChange = "javascript:mattspeciallengthSelected(true); getStandardMattressPrice(); ">
" >

<option value = "n"<%= selected("n", request("mattresslength")) %>>--</option>

<option value = "TBC"
<%= selected("TBC", request("mattresslength")) %>>TBC</option>

<option value = "190cm"
<%= selected("190cm", request("mattresslength")) %>>190cm</option>

<option value = "200cm"
<%= selected("200cm", request("mattresslength")) %>>200cm</option>

<option value = "203cm"
<%= selected("203cm", request("mattresslength")) %>>203cm</option>

<option value = "210cm"
<%= selected("210cm", request("mattresslength")) %>>210cm</option>
<%
if retrieveUserRegion() = 4 or retrieveUserRegion() = 23 or retrieveUserRegion() = 27 then
%>

<option value = "213cm"
<%= selected("213cm", request("mattresslength")) %>>213cm</option>
<%
end if
%>

<option value = "Special Length"
<%= selected("Special Length", request("mattresslength")) %>>Special
Length</option>
</select>
</td>

<td colspan = "2">&nbsp;

</td>
</tr>
</table>

<div id = "mattspecialwidth1">
<table width = "50%" border = "0" align = "left" cellpadding = "3" cellspacing = "3">
<tr id = "mattspecialwidth1">
<td width = "180" class = "mgindent">
Mattress 1 Special Width cms
</td>

<td>
<label for = "matt1width"></label>

<input name = "matt1width" type = "text" id = "matt1width" value = ""
size = "10">
</td>
</tr>
</table>
</div>

<div id = "mattspecialwidth2">
<table width = "50%" border = "0" align = "left" cellpadding = "3" cellspacing = "3">
<tr>
<td width = "180">
Mattress 2 Special Width cms
</td>

<td>
<input name = "matt2width" type = "text" id = "matt2width" value = ""
size = "10">
</td>
</tr>
</table>
</div>

<div id = "mattspeciallength1">
<table width = "50%" border = "0" align = "left" cellpadding = "3" cellspacing = "3">
<tr>
<td width = "180" class = "mgindent">
Mattress 1 Special Length cms
</td>

<td>
<input name = "matt1length" type = "text" id = "matt1length" value = ""
size = "10">
</td>
</tr>
</table>
</div>

<div id = "mattspeciallength2">
<table width = "50%" border = "0" align = "right" cellpadding = "3" cellspacing = "3">
<tr>
<td width = "180">
Mattress 2 Special Length cms
</td>

<td>
<input name = "matt2length" type = "text" id = "matt2length" value = ""
size = "10">
</td>
</tr>
</table>
</div>
<div class = "clear"></div>

<p>Support (as viewed from the foot looking toward the head end):</p>

<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
<tr>
<td width = "11%">
Left Support:
</td>

<td width = "14%">
<select name = "leftsupport" id = "leftsupport" tabindex = "40">
<option value = "n"<%= selected("n", request("leftsupport")) %>>--</option>

<option value = "TBC"<%= selected("TBC", request("leftsupport")) %>>TBC</option>

<option value = "Extra Soft"
<%= selected("Extra Soft", request("leftsupport")) %>>Extra Soft</option>

<option value = "Soft"
<%= selected("Soft", request("leftsupport")) %>>Soft</option>

<option value = "Medium"
<%= selected("Medium", request("leftsupport")) %>>Medium</option>

<option value = "Firm"
<%= selected("Firm", request("leftsupport")) %>>Firm</option>

<option value = "Extra Firm"
<%= selected("Extra Firm", request("leftsupport")) %>>Extra Firm</option>
</select>
</td>

<td width = "11%">
Right Support:
</td>

<td width = "13%">
<select name = "rightsupport" id = "rightsupport" tabindex = "41">
<option value = "n"<%= selected("n", request("rightsupport")) %>>--</option>

<option value = "TBC"
<%= selected("TBC", request("rightsupport")) %>>TBC</option>

<option value = "Extra Soft"
<%= selected("Extra Soft", request("rightsupport")) %>>Extra Soft</option>

<option value = "Soft"
<%= selected("Soft", request("rightsupport")) %>>Soft</option>

<option value = "Medium"
<%= selected("Medium", request("rightsupport")) %>>Medium</option>

<option value = "Firm"
<%= selected("Firm", request("rightsupport")) %>>Firm</option>

<option value = "Extra Firm"
<%= selected("Extra Firm", request("rightsupport")) %>>Extra Firm</option>
</select>
</td>

<td width = "11%">
Vent Position:
</td>

<td width = "16%">
<select name = "ventposition" id = "ventposition" tabindex = "42">
<option value = "n"<%= selected("n", request("ventposition")) %>>--</option>

<option value = "Vents on Ends"
<%= selected("Vents on Ends", request("ventposition")) %>>Vents on
Ends</option>

<option value = "Vents on Sides"
<%= selected("Vents on Sides", request("ventposition")) %>>Vents on
Sides</option>
</select>
</td>

<td width = "10%">
Vent Finish:
</td>

<td width = "14%">
<select name = "ventfinish" id = "ventfinish" tabindex = "43"
onChange = "javascript: defaultLinkFinish()">
<!--<option value="n" <%'=selected("n", request("ventfinish"))%> >--</option> not wanted-->
<option value = "Brass"
<%= selected("Brass", request("ventfinish")) %>>Brass</option>

<option value = "Chrome"
<%= selected("Chrome", request("ventfinish")) %>>Chrome</option
>
</select>
</td>
</tr>
</table>

<p>Mattress Special Instructions:</p>

<div id = "tick1">
<img src = "img/white-trellis.jpg" alt = "White Trellis" width = "149" height = "96"
hspace = "30" align = "right">
</div>

<div id = "tick2">
<img src = "img/grey-trellis.jpg" alt = "Grey Trellis" width = "149" height = "96"
hspace = "30" align = "right">
</div>

<div id = "tick3">
<img src = "img/silver-trellis.jpg" alt = "Silver Trellis" width = "149" height = "96"
hspace = "30" align = "right">
</div>

<div id = "tick4">
<img src = "img/oatmeal-trellis.jpg" alt = "oatmeal Trellis" width = "149" height = "96"
hspace = "30" align = "right">
</div>

<textarea name = "mattressinstructions" id="mattressinstructions" onKeyUp="return taCount(this,'myCounter')"  cols = "65" rows = "2" class = "indentleft"
tabindex = "44" size="250" maxlength="250"><%= request("mattressinstructions") %></textarea>
<br />&nbsp;<B><SPAN id=myCounter>250</SPAN></B>/250
<div class = "clear">
&nbsp;
</div>

<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3" class="xview">
<tr>
<td width = "17%" class = "mattressdiscountcls">
List
Price: <%= getCurrencySymbolForCurrency(orderCurrency) %><span id = "standardmattresspricespan">0</span>

<input type = "hidden" name = "standardmattressprice" id = "standardmattressprice"
value = "0" onchange = "setMattressPrice();" />
</td>

                                <td class = "mattressdiscountcls">
                                    Discount: %

<input type = "radio" name = "mattressdiscounttype" id = "mattressdiscounttype1"
value = "percent" checked onchange = "setMattressPrice();">
&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %><input type = "radio"
name = "mattressdiscounttype" id = "mattressdiscounttype2"
value = "currency" onchange = "setMattressPrice();">
&nbsp;

<input name = "mattressdiscount" value = "0" type = "text" id = "mattressdiscount"
size = "10" onchange = "setMattressPrice();">
</td>

<td colspan = "2" class = "mattressdiscountcls_dummy">&nbsp;

</td>

<td width = "22%">
Mattress
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>

<label><input name = "mattressprice" value = "<%= request("mattressprice") %>"
type = "text" id = "mattressprice" size = "15"
onchange = "setMattressDiscount();"></label>
</td>
</tr>
</table>
<div class = "clear"></div>
</div>

<p class = "purplebox"><span class = "radiobxmargin">Topper Required</span>&nbsp;Yes

<label> <input type = "radio" name = "topperrequired" id = "topperrequired" value = "y"
<%= ischeckedY(request("topperrequired")) %>onClick = "javascript: topperChanged();  getMadeAt()"></label>

No

<input name = "topperrequired" type = "radio" id = "topperrequired" value = "n"
<%= ischeckedN(request("topperrequired")) %>onClick = "javascript: topperChanged();  getMadeAt()"></p>

<div id = "topper_div">
<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
<tr>
<td width = "11%">
Topper Type:
</td>

<td width = "22%">
<select name = "toppertype" id = "toppertype" tabindex = "45"
onchange = "getStandardTopperPrice();  getMadeAt(); showtoppertickingoptions(); toppervegantext();">
<option value = "n"<%= selected("n", request("toppertype")) %>>--</option>

<option value = "TBC"<%= selected("TBC", request("toppertype")) %>>TBC</option>

<option value = "HC Topper"
<%= selected("HC Topper", request("toppertype")) %>>HC Topper</option>

<option value = "HCa Topper"
<%= selected("HCa Topper", request("toppertype")) %>>HCa Topper</option>

<option value = "HW Topper"
<%= selected("HW Topper", request("toppertype")) %>>HW Topper</option>

<option value = "CW Topper"
<%= selected("CW Topper", request("toppertype")) %>>CW Topper</option>
<option value = "CFv Topper"
 <%= selected("CFv Topper", request("toppertype")) %>>CFv Topper</option>
            </select>
          </td>

<td>
Topper Width:
</td>

<td>
<select name = "topperwidth" id = "topperwidth" tabindex = "46"
onChange = "javascript:topperspecialwidthSelected(true); javascript:getStandardTopperPrice();">
<option value = "n"<%= selected("n", request("topperwidth")) %>>--</option>

<option value = "TBC"<%= selected("TBC", request("topperwidth")) %>>TBC</option>

<option value = "90cm"
<%= selected("90cm", request("topperwidth")) %>>90cm</option>

<option value = "96.5cm"
<%= selected("96.5cm", request("topperwidth")) %>>96.5cm</option>

<option value = "100cm"
<%= selected("100cm", request("topperwidth")) %>>100cm</option>

<option value = "140cm"
<%= selected("140cm", request("topperwidth")) %>>140cm</option>

<option value = "150cm"
<%= selected("150cm", request("topperwidth")) %>>150cm</option>

<option value = "152.5cm"
<%= selected("152.5cm", request("topperwidth")) %>>152.5cm</option>

<option value = "160cm"
<%= selected("160cm", request("topperwidth")) %>>160cm</option>

<option value = "180cm"
<%= selected("180cm", request("topperwidth")) %>>180cm</option>
<%
if retrieveUserRegion() = 4 or retrieveUserRegion() = 23 or retrieveUserRegion() = 27 then
%>

<option value = "183cm"
<%= selected("183cm", request("topperwidth")) %>>183cm</option>
<%
end if
%>
<option value = "190cm"
<%= selected("190cm", request("topperwidth")) %>>190cm</option>
<option value = "193cm"
<%= selected("193cm", request("topperwidth")) %>>193cm</option>

<option value = "200cm"
<%= selected("200cm", request("topperwidth")) %>>200cm</option>

<option value = "210cm"
<%= selected("210cm", request("topperwidth")) %>>210cm</option>

<option value = "Special Width"
<%= selected("Special Width", request("topperwidth")) %>>Special
Width</option>
</select>
</td>

<td width = "8%">
Topper Length:
</td>

<td width = "24%">
<select name = "topperlength" id = "topperlength" tabindex = "47"
onChange = "javascript:topperspeciallengthSelected(true); javascript:getStandardTopperPrice(); ">
<option value = "n"<%= selected("n", request("topperlength")) %>>--</option>

<option value = "TBC"
<%= selected("TBC", request("topperlength")) %>>TBC</option>

<option value = "190cm"
<%= selected("190cm", request("topperlength")) %>>190cm</option>

<option value = "200cm"
<%= selected("200cm", request("topperlength")) %>>200cm</option>

<option value = "203cm"
<%= selected("203cm", request("topperlength")) %>>203cm</option>

<option value = "210cm"
<%= selected("210cm", request("topperlength")) %>>210cm</option>
<%
if retrieveUserRegion() = 4 or retrieveUserRegion() = 23 or retrieveUserRegion() = 27 then
%>

<option value = "213cm"
<%= selected("213cm", request("topperlength")) %>>213cm</option>
<%
end if
%>

<option value = "Special Length"
<%= selected("Special Length", request("topperlength")) %>>Special
Length</option>
</select>
</td>
</tr>

<tr>
<td>
Ticking Options:
</td>

<td>
<select name = "toppertickingoptions" id = "toppertickingoptions" tabindex = "48">
<option value = "n"
<%= selected("n", request("toppertickingoptions")) %>>--</option>

<option value = "TBC"
<%= selected("TBC", request("toppertickingoptions")) %>>TBC</option>

<option value = "White Trellis"
<%= selected("White Trellis", request("toppertickingoptions")) %>>White
Trellis</option>

<option value = "Grey Trellis"
<%= selected("Grey Trellis", request("toppertickingoptions")) %>>Grey
Trellis</option>

<option value = "Silver Trellis"
<%= selected("Silver Trellis", request("toppertickingoptions")) %>>Silver
Trellis</option>

                                       
            </select>
          </td>

<td width = "10%">&nbsp;

</td>

<td width = "25%">&nbsp;

</td>

<td>&nbsp;

</td>

<td>&nbsp;

</td>
</tr>
</table>

<div id = "topperspecialwidth1">
<table width = "50%" border = "0" align = "left" cellpadding = "3" cellspacing = "3">
<tr id = "topperspecialwidth1">
<td width = "180" class = "mgindent">
Topper Special Width cms
</td>

<td>
<label for = "topper1width"></label>

<input name = "topper1width" type = "text" id = "topper1width" value = ""
size = "10">
</td>
</tr>
</table>
</div>

<div id = "topperspeciallength1">
<table width = "50%" border = "0" align = "right" cellpadding = "3" cellspacing = "3">
<tr id = "topperspeciallength1">
<td width = "180" class = "mgindent">
Topper Special Length cms
</td>

<td>
<label for = "topper1length"></label>

<input name = "topper1length" type = "text" id = "topper1length" value = ""
size = "10">
</td>
</tr>
</table>
</div>

<div id = "tick1t">
<img src = "img/white-trellis.jpg" alt = "White Trellis" width = "149" height = "96"
hspace = "30" align = "right">
</div>

<div id = "tick2t">
<img src = "img/grey-trellis.jpg" alt = "Grey Trellis" width = "149" height = "96"
hspace = "30" align = "right">
</div>

<div id = "tick3t">
<img src = "img/silver-trellis.jpg" alt = "Silver Trellis" width = "149" height = "96"
hspace = "30" align = "right">
</div>

<div id = "tick4t">
<img src = "img/oatmeal-trellis.jpg" alt = "oatmeal Trellis" width = "149" height = "96"
hspace = "30" align = "right">
</div>
<div class = "clear"></div>

<p>Topper Special Instructions:</p>

<textarea name = "specialinstructionstopper" cols = "65" class = "indentleft"
id = "specialinstructionstopper"
tabindex = "49" onKeyUp="return taCount(this,'myCounter1')"><%= request("specialinstructionstopper") %></textarea><B><SPAN id=myCounter1>250</SPAN></B>/250

<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3" class="xview">
<tr>
<td width = "17%" class = "topperdiscountcls">
List
Price: <%= getCurrencySymbolForCurrency(orderCurrency) %><span id = "standardtopperpricespan">0</span>

<input type = "hidden" name = "standardtopperprice" id = "standardtopperprice"
value = "0" onchange = "setTopperPrice();" />
</td>

                                <td class = "topperdiscountcls">
                                    Discount: %

<input type = "radio" name = "topperdiscounttype" id = "topperdiscounttype1"
value = "percent" checked onchange = "setTopperPrice();">
&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %><input type = "radio"
name = "topperdiscounttype" id = "topperdiscounttype2" value = "currency"
onchange = "setTopperPrice();">
&nbsp;

<input name = "topperdiscount" value = "0" type = "text" id = "topperdiscount"
size = "10" onchange = "setTopperPrice();">
</td>

<td colspan = "2" class = "topperdiscountcls_dummy">&nbsp;

</td>

<td width = "22%">
Topper
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>

<label><input name = "topperprice" value = "<%= request("topperprice") %>"
type = "text" id = "topperprice" size = "15"
onchange = "setTopperDiscount();"></label>
</td>
</tr>
</table>

<div class = "clear"></div>
</div>

<p class = "purplebox"><span class = "radiobxmargin">Base Required</span>&nbsp;Yes

<label> <input type = "radio" name = "baserequired" id = "baserequired" value = "y"
<%= ischeckedY(request("baserequired")) %>
onClick = "baseChanged(); headboardwidthOptions();  getMadeAt()"></label>

No

<input name = "baserequired" type = "radio" id = "baserequired" value = "n"
<%= ischeckedN(request("baserequired")) %>
onClick = "baseChanged(); headboardwidthOptions();  getMadeAt()"></p>

<div id = "base_div">
<input type="hidden" name="extbase" id="extbase" value="no" /> <!-- extbase removed as part of R127, but keeping it as a hidden field to make things easier -->
<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
<tr>
<td>
Savoir Model:
</td>

<td>
<select name = "basesavoirmodel" id = "basesavoirmodel" tabindex = "50"
onchange = "getStandardBasePrice();  getStandardBaseTrimPrice(); getStandardBaseUpholsteryPrice(); getMadeAt(); showbasetickingoptions(); basevegantext();">
<option value = "n"<%= selected("n", request("basesavoirmodel")) %>>--</option>

<option value = "No. 1"<%= selected("No. 1", request("basesavoirmodel")) %>>No.
1</option>

<option value = "No. 2"<%= selected("No. 2", request("basesavoirmodel")) %>>No.
2</option>

<option value = "No. 3"<%= selected("No. 3", request("basesavoirmodel")) %>>No.
3</option>

<option value = "No. 4"<%= selected("No. 4", request("basesavoirmodel")) %>>No.
4</option>

<option value = "No. 4v"<%= selected("No. 4v", request("basesavoirmodel")) %>>No.
4v</option>

<option value = "No. 5"<%= selected("No. 5", request("basesavoirmodel")) %>>No. 5</option>

<option value = "Pegboard"
<%= selected("Pegboard", request("basesavoirmodel")) %>>Pegboard</option>

<option value = "Platform Base"
<%= selected("Platform Base", request("basesavoirmodel")) %>>Platform
Base</option>

<option value = "Savoir Slim"
<%= selected("Savoir Slim", request("basesavoirmodel")) %>>Savoir
Slim</option>

<option value = "State"
<%= selected("State", request("basesavoirmodel")) %>>State</option>

<option value = "Surround"
<%= selected("State", request("basesavoirmodel")) %>>Surround</option>

</select>
</td>

<td>
Base Type:
</td>

                                <td>
                                    <select name = "basetype" id = "basetype" tabindex = "51"
                                        onChange = "setLinkPosition(null); setLegQty();">
                                        <option value = "n"<%= selected("n", request("basetype")) %>>--</option>

<option value = "TBC"<%= selected("TBC", request("basetype")) %>>TBC</option>

<option value = "One Piece"<%= selected("One Piece", request("basetype")) %>>One
Piece</option>

<option value = "North-South Split"
<%= selected("North-South Split", request("basetype")) %>>North-South
Split</option>

<option value = "East-West Split"
<%= selected("East-West Split", request("basetype")) %>>East-West
Split</option>


</select>
</td>

<td>
Base Width:
</td>

                                <td>
                                    <select name = "basewidth" id = "basewidth" tabindex = "52"
                                        onChange = "basespecialwidthSelected(true); setLegQty(); getStandardBasePrice(); ">
                                        <option value = "n"<%= selected("n", request("basewidth")) %>>--</option>

<option value = "TBC"<%= selected("TBC", request("basewidth")) %>>TBC</option>

<option value = "90cm"
<%= selected("90cm", request("basewidth")) %>>90cm</option>

<option value = "96.5cm"
<%= selected("96.5cm", request("basewidth")) %>>96.5cm</option>

<option value = "100cm"
<%= selected("100cm", request("basewidth")) %>>100cm</option>

<option value = "140cm"
<%= selected("140cm", request("basewidth")) %>>140cm</option>

<option value = "150cm"
<%= selected("150cm", request("basewidth")) %>>150cm</option>

<option value = "152.5cm"
<%= selected("152.5cm", request("basewidth")) %>>152.5cm</option>

<option value = "160cm"
<%= selected("160cm", request("basewidth")) %>>160cm</option>

<option value = "180cm"
<%= selected("180cm", request("basewidth")) %>>180cm</option>
<%
if retrieveUserRegion() = 4 or retrieveUserRegion() = 23 or retrieveUserRegion() = 27 then
%>

<option value = "183cm"
<%= selected("183cm", request("basewidth")) %>>183cm</option>
<%
end if
%>
<option value = "190cm"
<%= selected("190cm", request("basewidth")) %>>190cm</option>
<option value = "193cm"
<%= selected("193cm", request("basewidth")) %>>193cm</option>

<option value = "200cm"
<%= selected("200cm", request("basewidth")) %>>200cm</option>

<option value = "210cm"
<%= selected("210cm", request("basewidth")) %>>210cm</option>

<option value = "Special Width"
<%= selected("Special Width", request("basewidth")) %>>Special
Width</option>
</select>
</td>
</tr>

<tr>
<td>
Base Length:
</td>

                                <td>
                                    <select name = "baselength" id = "baselength" tabindex = "53"
                                        onChange = "javascript:basespeciallengthSelected(true); javascript:getStandardBasePrice();">
                                        <option value = "n"<%= selected("n", request("baselength")) %>>--</option>

<option value = "TBC"<%= selected("TBC", request("baselength")) %>>TBC</option>

<option value = "190cm"
<%= selected("190cm", request("baselength")) %>>190cm</option>

<option value = "200cm"
<%= selected("200cm", request("baselength")) %>>200cm</option>

<option value = "203cm"
<%= selected("203cm", request("baselength")) %>>203cm</option>

<option value = "210cm"
<%= selected("210cm", request("baselength")) %>>210cm</option>
<%
if retrieveUserRegion() = 4 or retrieveUserRegion() = 23 or retrieveUserRegion() = 27 then
%>

<option value = "213cm"
<%= selected("213cm", request("baselength")) %>>213cm</option>
<%
end if
%>

<option value = "Special Length"
<%= selected("Special Length", request("baselength")) %>>Special
Length</option>
</select>
</td>

<td>
Height Spring
</td>

<td>
<%
Set rs = getMysqlUpdateRecordSet("Select * from baseheightspring", con)
%>

<select name = "spring" id = "spring">
<%
do until rs.eof
%>

<option value = "<%= rs("baseheightspring") %>"><%= rs("baseheightspring") %></option>
<%
rs.movenext
loop
rs.close
set rs = nothing
%>
</select>

&nbsp;
</td>

<td>
Ticking:
</td>

<td>
<select name = "basetickingoptions" id = "basetickingoptions" tabindex = "32">
<option value = "n"
<%= selected("n", request("basetickingoptions")) %>>--</option>

<option value = "TBC"
<%= selected("TBC", request("basetickingoptions")) %>>TBC</option>

<option value = "White Trellis"
<%= selected("White Trellis", request("basetickingoptions")) %>>White
Trellis</option>

<option value = "Grey Trellis"
<%= selected("Grey Trellis", request("basetickingoptions")) %>>Grey
Trellis</option>

<option value = "Silver Trellis"
<%= selected("Silver Trellis", request("basetickingoptions")) %>>Silver
Trellis</option>

                                        
            </select>

&nbsp;
</td>
</tr>

<tr>
<td>
Link Position:
</td>

<td>
<select name = "linkposition" id = "linkposition" tabindex = "60"
onChange = "javascript:linkPositionChanged();"></select>
</td>

<td>
<span class = "linkfinishclass">Link Finish</span>
</td>

<td>
<span class = "linkfinishclass">

<select name = "linkfinish" id = "linkfinish" tabindex = "61">
<!-- not wanted now<option value = "n"<%= selected("n", request("linkfinish")) %>>--</option>-->

<option value = "Brass"
<%= selected("Brass", request("linkfinish")) %>>Brass</option>

<option value = "Chrome"
<%= selected("Chrome", request("linkfinish")) %>>Chrome</option>
</select>

</span>
</td>

        </tr>

<tr>
<td>
Base Trim:
</td>
<td>
<select name = "basetrim" id = "basetrim"
onchange = "setBaseTrimColours(); getStandardBaseTrimPrice(); resetPriceField('basetrimprice',11); showHideBasePriceSummaryRow(11); ">
<option value = "n">No</option>
<option value = "Standard">Standard</option>
<option value = "Self Levelling">Self Levelling</option>
</select>
</td>
<td class = "baseTrimColourCls">
Base Trim Colour:
</td>
<td class = "baseTrimColourCls">
<select name = "basetrimcolour" id = "basetrimcolour"></select>
</td>
</tr>
<tr>
<td>Drawers:</td>
<td>
<%
Set rs = getMysqlUpdateRecordSet("Select * from drawerconfig", con)
%>
<select name = "drawerconfig" id = "drawerconfig" tabindex = "58"
onchange = "getStandardBaseDrawersPrice(); resetPriceField('basedrawersprice',13); showDrawersSection(); showHideBasePriceSummaryRow(13);">
<option value = "n">No</option>
<%
do until rs.eof
%>
<option value = "<%= rs("drawerconfig") %>"><%= rs("drawerconfig") %></option>
<%
rs.movenext
loop
rs.close
set rs = nothing
%>
</select>
</td>

<td class="drawerscls" >Drawer Height:</td>
<td class="drawerscls" >
<%
Set rs = getMysqlUpdateRecordSet("Select * from drawerheight", con)
%>
<select name = "drawerheight" id = "drawerheight" tabindex = "58">
<option value = "n">--</option>
<%
do until rs.eof
%>
<option value = "<%= rs("drawerheight") %>"><%= rs("drawerheight") %></option>
<%
rs.movenext
loop
rs.close
set rs = nothing
%>
</select>
&nbsp;
</td>

</tr>
</table>

<div id = "basespecialwidth1">
<table width = "50%" border = "0" align = "left" cellpadding = "3" cellspacing = "3">
<tr id = "basespecialwidth1">
<td width = "180" class = "mgindent">
Base 1 Special Width cms
</td>

<td>
<label for = "base1width"></label>

<input name = "base1width" type = "text" id = "base1width" value = ""
size = "10">
</td>
</tr>
</table>
</div>

<div id = "basespecialwidth2">
<table width = "50%" border = "0" align = "left" cellpadding = "3" cellspacing = "3">
<tr>
<td width = "180">
Base 2 Special Width cms
</td>

<td>
<input name = "base2width" type = "text" id = "base2width" value = ""
size = "10">
</td>
</tr>
</table>
</div>

<div id = "basespeciallength1">
<table width = "50%" border = "0" align = "left" cellpadding = "3" cellspacing = "3">
<tr>
<td width = "180" class = "mgindent">
Base 1 Special Length cms
</td>

<td>
<input name = "base1length" type = "text" id = "base1length" value = ""
size = "10">
</td>
</tr>
</table>
</div>

<div id = "basespeciallength2">
<table width = "50%" border = "0" align = "right" cellpadding = "3" cellspacing = "3">
<tr>
<td width = "180">
Base 2 Special Length cms
</td>

<td>
<input name = "base2length" type = "text" id = "base2length" value = ""
size = "10">
</td>
</tr>
</table>
</div>
<div class = "clear"></div>

<div id = "tick1b">
<img src = "img/white-trellis.jpg" alt = "White Trellis" width = "149" height = "96"
hspace = "30" align = "right">
</div>

<div id = "tick2b">
<img src = "img/grey-trellis.jpg" alt = "Grey Trellis" width = "149" height = "96"
hspace = "30" align = "right">
</div>

<div id = "tick3b">
<img src = "img/silver-trellis.jpg" alt = "Silver Trellis" width = "149" height = "96"
hspace = "30" align = "right">
</div>

<div id = "tick4b">
<img src = "img/oatmeal-trellis.jpg" alt = "oatmeal Trellis" width = "149" height = "96"
hspace = "30" align = "right">
</div>

<p>Base Special Instructions:</p>

<textarea name = "baseinstructions" id="baseinstructions" cols = "65" class = "indentleft" 
tabindex = "62" onKeyUp="return taCount(this,'myCounter2')"><%= request("baseinstructions") %></textarea><B><SPAN id=myCounter2>250</SPAN></B>/250
<div class = "clear"></div>

<div class = "clear"></div>

&nbsp;

<p>Upholstered Base:

                        <select name = "upholsteredbase" id = "upholsteredbase" tabindex = "70"
onChange = "setLinkPosition(null); upholsteredBaseChanged(); getStandardBaseUpholsteryPrice(); showHideBasePriceSummaryRow(17); showHideBasePriceSummaryRow(12);">
                            <option value = "n"<%= selected("n", request("upholsteredbase")) %>>No</option>

<option value = "TBC"<%= selected("TBC", request("upholsteredbase")) %>>TBC</option>

<option value = "Yes"<%= selected("Yes", request("upholsteredbase")) %>>Yes</option>

<option value = "Yes, Com"<%= selected("Yes, Com", request("upholsteredbase")) %>>Yes,
Com</option>
</select>

</p>
<!-- uphbase start -->
<div id = "uphbase">
<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
<tr>
<td>
Base Fabric Direction
</td>

<td>
<select name = "basefabricdirection" id = "basefabricdirection">
<option value = "--"
<%= selected("--", request("basefabricdirection")) %>>--</option>

<option value = "Fabric on the run"
<%= selected("Fabric on the run", request("basefabricdirection")) %>>Fabric
on the run</option>

<option value = "Fabric on the drop"
<%= selected("Fabric on the drop", request("basefabricdirection")) %>>Fabric
on the drop</option>
</select>

&nbsp;
</td>

<td width = "11%">
Fabric Company:
</td>

<td width = "21%">
<input name = "basefabric" value = "<%= request("basefabric") %>" type = "text"
id = "basefabric" size = "25" maxlength = "50">
</td>

<td width = "12%">
Fabric Design, Colour & Code:
</td>

<td width = "33%">
<span id = "basefabric_div"></span>

<input name = "basefabricchoice" value = "<%= request("basefabricchoice") %>"
type = "text" id = "basefabricchoice" size = "50" maxlength = "100">
</td>
</tr>

<tr>
<td>
Price Per Metre&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %>
</td>

<td>
<input name = "basefabriccost" value = "<%= request("basefabriccost") %>"
type = "text" class="xview" id = "basefabriccost" size = "15">
</td>

<td>
Fabric Quantity
</td>

<td>
<input name = "basefabricmeters" value = "<%= request("basefabricmeters") %>"
type = "text" id = "basefabricmeters" size = "15">
</td>

</tr>
</table>

<p>Base Fabric Description</p>

                            <input id = "basefabricdesc" name = "basefabricdesc" type = "text" class = "indentleft"
                                value = "<%= request("basefabricdesc") %>" size = "85" maxlength = "250" onKeyUp="return taCount(this,'myCounter3')"><B><SPAN id=myCounter3>250</SPAN></B>/250
<br>
</div> <!-- uphbase end -->

<!-- base prices summary table -->
<div class="clear"></div>
<!-- #include file="base-price-summary.asp" -->
</div>

<div class = "clear"></div>

<!-- LEGS START -->

<p class = "purplebox"><span class = "radiobxmargin">Legs Required</span>&nbsp;Yes
<label> <input type = "radio" name = "legsrequired" id = "legsrequired" value = "y"
<%= ischeckedY(request("legsrequired")) %>onClick = "javascript: legsChanged(); getMadeAt()"></label>
No
<input name = "legsrequired" type = "radio" id = "legsrequired" value = "n"
<%= ischeckedN(request("legsrequired")) %>onClick = "javascript: legsChanged(); getMadeAt()"> </p>
<div id = "legs_div">
<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
<tr>
<td>Feature Leg:&nbsp;
<select name = "legstyle" id = "legstyle" tabindex = "54"
onChange = "setLegFinishes(); showLegStylePriceField(); setLegQty(); showFloorType(); getStandardLegsPrice(); ">
<%= makeSortedOptionString("legstyle", request("legstyle"), true, con) %>
</select>
</td>
<td>
Qty Legs:&nbsp;
<select name = "legqty" id = "legqty" onChange = "getStandardLegsPrice();">
<%
for i = 0 to 12
%>
<option value = "<%= i %>"
<%= selected(i, legqty) %>><%= i %></option>
<%
next
%>
</select>
</td>
<td>
Leg Finish:&nbsp;
<select name = "legfinish" id = "legfinish" onChange = "getStandardLegsPrice();" tabindex = "55"></select>
</td>
<td>
Leg Height:&nbsp;
<select name = "legheight" id = "legheight" tabindex = "56"
onChange = "javascript:legspecialheightSelected(true);"></select>
</td>
<td><span id = "legspecialheight">
Special:
<input name = "speciallegheight" type = "text" id = "speciallegheight"
value = "" size = "10" />
</span>
</td>
<td class = "floortypeclass">
Floor Type:&nbsp;
<select name = "floortype" id = "floortype" tabindex = "61">
<option value = "TBC"<%= selected("TBC", request("floortype")) %>>TBC</option>
<option value = "Wooden"
<%= selected("Brass", request("floortype")) %>>Wooden</option>
<option value = "Carpeted"
<%= selected("Chrome", request("floortype")) %>>Carpeted</option>
</select>
</td>
</tr>
<tr>
<td>Support Leg:&nbsp;
<select name = "addlegstyle" id = "addlegstyle"
onChange = "defaultAddLegFinish(); getStandardAddLegsPrice();">
<%= makeOptionString("addlegstyle", request("addlegstyle"), true, con) %>
</select>
</td>
<td>
Qty Legs:&nbsp;
<select name = "addlegqty" id = "addlegqty" onChange = "getStandardAddLegsPrice();">
<%
for i = 0 to 12
%>
<option value = "<%= i %>"
<%= selected(i, request("addlegqty")) %>><%= i %></option>
<%
next
%>
</select>
</td>
<td>
Leg Finish:&nbsp;
<select name = "addlegfinish" id = "addlegfinish"></select>
</td>
</tr>
<tr>
<td colspan="3">
Leg Special Instructions:<br/>
<textarea name = "specialinstructionslegs" cols = "65" class = "indentleft"
id = "specialinstructionslegs"
tabindex = "49" onKeyUp="return taCount(this,'myCounter4')"><%= request("specialinstructionslegs") %></textarea><B><SPAN id=myCounter4>130</SPAN></B>/130
</td>
</tr>
</table>
<table width = "900px" border = "0" align = "center" cellpadding = "3" cellspacing = "3" class="xview">
<tr>
<td width = "17%" ><span class="legsdiscountcls">
List
Price: <%= getCurrencySymbolForCurrency(orderCurrency) %><span id = "standardlegspricespan">0</span>

<input type = "hidden" name = "standardlegsprice" id = "standardlegsprice"
value = "0" onchange = "setLegsPrice();" />
</span></td>

<td><span class="legsdiscountcls">
DC: %

<input type = "radio" name = "legsdiscounttype" id = "legsdiscounttype1"
value = "percent" checked onchange = "setLegsPrice();">
&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %><input type = "radio"
name = "legsdiscounttype" id = "legsdiscounttype2" value = "currency"
onchange = "setLegsPrice();">
&nbsp;

<input name = "legsdiscount" value = "0" type = "text" id = "legsdiscount"
size = "10" onchange = "setLegsPrice();">
</span></td>

<td colspan = "2">&nbsp;</td>

<td width = "22%" align="right">
Legs
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>

<label><input name = "legprice" value = "<%= request("legprice") %>" type = "text"
id = "legprice" size = "10" onchange = "setLegsDiscount();"></label>
</td>
</tr>
<tr>
<td width = "17%"><span class="addlegsdiscountcls">
List
Price: <%= getCurrencySymbolForCurrency(orderCurrency) %><span id = "standardaddlegspricespan">0</span>

<input type = "hidden" name = "standardaddlegsprice" id = "standardaddlegsprice"
value = "0" onchange = "setAddLegsPrice();" />
</span></td>

<td><span class="addlegsdiscountcls">
DC: %

<input type = "radio" name = "addlegsdiscounttype" id = "addlegsdiscounttype1"
value = "percent" checked onchange = "setAddLegsPrice();">
&nbsp;<%= getCurrencySymbolForCurrency(orderCurrency) %><input type = "radio"
name = "addlegsdiscounttype" id = "addlegsdiscounttype2" value = "currency"
onchange = "setAddLegsPrice();">
&nbsp;

<input name = "addlegsdiscount" value = "0" type = "text" id = "addlegsdiscount"
size = "10" onchange = "setAddLegsPrice();">
</span></td>

<td colspan = "2">&nbsp;</td>

<td width = "22%" align="right">
Support Legs
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>

<label><input name = "addlegprice" value = "<%= request("addlegprice") %>" type = "text"
id = "addlegprice" size = "10" onchange = "setAddLegsDiscount();"></label>
</td>
</tr>
</table>
</div> <!-- legs_div -->

<div class = "clear"></div>

<!-- LEGS END -->

<div class = "clear"></div>

<p class = "purplebox"><span class = "radiobxmargin">Headboard Required</span>&nbsp;Yes

<label> <input type = "radio" name = "headboardrequired" id = "headboardrequired" value = "y"
<%= ischeckedY(request("headboardrequired")) %>
onClick = "headboardChanged(); headboardwidthOptions();  getMadeAt()"></label>

No

<input name = "headboardrequired" type = "radio" id = "headboardrequired" value = "n"
<%= ischeckedN(request("headboardrequired")) %>
onClick = "headboardChanged(); headboardwidthOptions();  getMadeAt()"> </p>

<div id = "headboard_div">
<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
<tr>
<td>
Headboard Style:
</td>

                                <td>
<select name = "headboardstyle" id = "headboardstyle" tabindex = "80"
onchange = "getStandardHeadboardPrice(); getMadeAt(); getStandardHeadboardTrimPrice(); resetPriceField('headboardtrimprice',10); showHideHeadboardPriceSummaryRow(10);">
                                        <%= makeSortedOptionString("headboardstyle", request("headboardstyle"), true, con) %>
                                    </select>
                                </td>
                                <td> Headboard Height: </td>
                                <td><select name = "headboardheight" id = "headboardheight" tabindex = "81">
                                  <%= makeOptionString("headboardheight", request("headboardheight"), true, con) %>
                                </select></td>
                                <td> Headboard Finish </td>
                                <td><select name = "headboardfinish" id = "headboardfinish" tabindex = "82">
                                  <%
Set rs = getMysqlUpdateRecordSet("Select * from headboardfinish", con)
%>
                                  <%
Do until rs.eof
%>
                                  <option value = "<%= rs("hbfinish") %>"
<%= selected(rs("hbfinish"), request("headboardfinish")) %>><%= rs("hbfinish") %></option>
                                  <%
rs.movenext
loop
rs.close
set rs = nothing
%>
                                </select></td>
</tr>

<tr>
  <td> Supporting Leg Qty:
    
    
  &nbsp; </td>
  <td><select name = "hblegs" id = "hblegs">
    <%
for i = 0 to 10
%>
    <option value = "<%= i %>"><%= i %></option>
    <%
next
%>
    </select>
    &nbsp; </td>
  <td><div id = "manhattantrimdiv1"> Wooden Headboard Trim </div>
  <div id = "footboardheightdiv1"> Footboard Height </div>
  &nbsp; </td>
  <td><div id = "manhattantrimdiv2">
    <select name = "manhattantrim" id = "manhattantrim" tabindex = "83"
    onchange = "getStandardHeadboardTrimPrice(); resetPriceField('headboardtrimprice',10); showHideHeadboardPriceSummaryRow(10); ">
      <%= makeOptionString("manhattantrim", request("manhattantrim"), true, con) %>
    </select>
  </div>
  <div id = "footboardheightdiv2">
    <select name = "footboardheight" id = "footboardheight" tabindex = "84">
      <%= makeOptionString("footboardheight", request("footboardheight"), true, con) %>
    </select>
  </div>
  &nbsp; </td>
  <td><div id = "footboardfinishdiv1"> Footboard Finish </div>
  &nbsp;</td>
  <td><div id = "footboardfinishdiv2">
    <select name = "footboardfinish" id = "footboardfinish" tabindex = "84">
      <%= makeOptionString("footboardfinish", request("footboardfinish"), true, con) %>
    </select>
  </div>&nbsp;</td>
  </tr>
<tr>
<td>
Fabric Options:
</td>

<td>
  <select name = "hbfabricoptions" id = "hbfabricoptions" tabindex = "80">
  <option value = "TBC"
<%= selected("TBC", request("hbfabricoptions")) %>>TBC</option>
    
  <option value = "Savoir Supply"
<%= selected("Savoir Supply", request("hbfabricoptions")) %>>Savoir
    Supply</option>
    
  <option value = "Customer Own Material"
<%= selected("Customer Own Material ", request("hbfabricoptions")) %>>Customer
    Own Material</option>
  </select>
</td>
<td> Fabric Company: </td>
<td><input name = "headboardfabric" value = "<%= request("headboardfabric") %>"
type = "text" id = "headboardfabric" size = "25" maxlength = "50"></td>
<td> Headboard Fabric Direction </td>
<td><select name = "headboardfabricdirection" id = "headboardfabricdirection">
  <option value = "TBC"
<%= selected("TBC", request("headboardfabricdirection")) %>>TBC</option>
  <option value = "Fabric on the run"
<%= selected("Fabric on the run", request("headboardfabricdirection")) %>>Fabric
    on the run</option>
  <option value = "Fabric on the drop"
<%= selected("Fabric on the drop", request("headboardfabricdirection")) %>>Fabric
    on the drop</option>
</select>
  &nbsp; </td>
</tr>

<tr>
  <td> Fabric Description (Design, Colour &amp; Code): </td>
  <td colspan="3"><input name = "headboardfabricchoice"
value = "<%= request("headboardfabricchoice") %>" type = "text"
id = "headboardfabricchoice" size = "100%" maxlength = "100"></td>
<td>&nbsp;</td>
                                <td>&nbsp;</td>
          </tr>

<tr>
  <td> Fabric Quantity
    (Metres)</td>
  <td><input name = "hbfabricmeters" value = "<%= request("hbfabricmeters") %>" type = "text"
id = "hbfabricmeters" size = "15"></td>
  <td>Price Per Metre&nbsp;<%=getCurrencySymbolForCurrency(orderCurrency)%></td>
  <td><input name = "hbfabriccost" class="xview" value = "<%= request("hbfabriccost") %>" type = "text"
id = "hbfabriccost" size = "15"></td>
</tr>

</table>

<div id = "headboardwidth">
<table>
<tr>
<td>
<p>Headboard Width</p>
</td>

<td>
<select name = "headboardwidth" id = "headboardwidth" tabindex = "52">
<option value = "n"<%= selected("n", request("headboardwidth")) %>>--</option>

<option value = "TBC"
<%= selected("TBC", request("headboardwidth")) %>>TBC</option>

<option value = "90cm"
<%= selected("90cm", request("headboardwidth")) %>>90cm</option>

<option value = "140cm"
<%= selected("140cm", request("headboardwidth")) %>>140cm</option>

<option value = "150cm"
<%= selected("150cm", request("headboardwidth")) %>>150cm</option>

<option value = "152.5cm"
<%= selected("152.5cm", request("headboardwidth")) %>>152.5cm</option>

<option value = "180cm"
<%= selected("180cm", request("headboardwidth")) %>>180cm</option>
<%
if retrieveUserRegion() = 4 or retrieveUserRegion() = 23 or retrieveUserRegion() = 27 then
%>

<option value = "183cm"
<%= selected("183cm", request("headboardwidth")) %>>183cm</option>
<%
end if
%>

<option value = "193cm"
<%= selected("193cm", request("headboardwidth")) %>>193cm</option>

<option value = "200cm"
<%= selected("200cm", request("headboardwidth")) %>>200cm</option>

<option value = "210cm"
<%= selected("210cm", request("headboardwidth")) %>>210cm</option>
</select>
</td>
</tr>
</table>
</div>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="left"><p>Headboard Fabric Description</p>

<input name = "headboardfabricdesc" type = "text" class = "indentleft"
value = "<%= request("headboardfabricdesc") %>" size = "80%" maxlength = "250" onKeyUp="return taCount(this,'myCounter5')"><B><SPAN id=myCounter5>250</SPAN></B>/250&nbsp;</td>
    <td align="left"><p>Headboard Special Instructions:</p><textarea name = "specialinstructionsheadboard" cols = "55" class = "indentleft"
id = "specialinstructionsheadboard"
tabindex = "86" onKeyUp="return taCount(this,'myCounter6')"><%= request("specialinstructionsheadboard") %></textarea><B><SPAN id=myCounter6>250</SPAN></B>/250
&nbsp;</td>
  </tr>
  
</table>

<div class = "clear"></div>



<br>
<div id = "tick5">
<img src = "img/virginia.gif" alt = "Virginia" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick6">
<img src = "img/savoy.gif" alt = "Savoy" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick7">
<img src = "img/penelope.gif" alt = "Penelope" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick8">
<img src = "img/nicky.gif" alt = "Nicky" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick9">
<img src = "img/mary.gif" alt = "Mary" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick10">
<img src = "img/ian.gif" alt = "Ian" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick11">
<img src = "img/hatti.gif" alt = "Hatti" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick12">
<img src = "img/holly.gif" alt = "Holly" width = "77" height = "119" hspace = "30"
align = "right">
</div>

<div id = "tick13">
<img src = "img/f100.gif" alt = "F100" width = "77" height = "119" hspace = "30"
align = "right">
</div>

<div id = "tick14">
<img src = "img/MF31.gif" alt = "Alex (M31)" width = "115" height = "119" hspace = "30"
align = "right">
</div>

<div id = "tick15">
<img src = "img/MF32.gif" alt = "Elizabeth (M32)" width = "112" height = "119" hspace = "30"
align = "right">
</div>

<div id = "tick16">
<img src = "img/Animal.gif" alt = "Animal" width = "91" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick17">
<img src = "img/leo.gif" alt = "Leo (CF5)" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick18">
<img src = "img/lotti.gif" alt = "Lotti (CF4)" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick19">
<img src = "img/harlech.gif" alt = "Harlech (CF2)" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick20">
<img src = "img/felix.gif" alt = "Felix (TF30)" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick21">
<img src = "img/claudia.gif" alt = "Claudia" width = "115" height = "119" hspace = "30"
align = "right">
</div>
<div id = "tick22">
<img src = "img/gorrivan.gif" alt = "Gorrivan" width = "115" height = "119" hspace = "30"
align = "right">
</div>



<div class = "clear">
&nbsp;
</div>

<!-- headboard prices summary table -->
<!-- #include file="headboard-price-summary.asp" -->

<div class = "clear"></div>
</div>

<p class = "purplebox"><span class = "radiobxmargin">Valance Required</span>&nbsp;Yes

<label> <input type = "radio" name = "valancerequired" id = "valancerequired" value = "y"
<%= ischeckedY(request("valancerequired")) %>onClick = "javascript: valanceChanged(); getMadeAt()"></label>

No

<input name = "valancerequired" type = "radio" id = "valancerequired" value = "n"
<%= ischeckedN(request("valancerequired")) %>onClick = "javascript: valanceChanged(); getMadeAt()"></p>

<div id = "valance_div">
<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
<tr>
<td width = "11%">
No. of Pleats:
</td>

<td width = "12%">
<select name = "pleats" id = "pleats" tabindex = "90">
<option value = "--"<%= selected("--", request("pleats")) %>>--</option>

<option value = "TBC"<%= selected("TBC", request("pleats")) %>>TBC</option>

<option value = "0"<%= selected("0", request("pleats")) %>>0</option>

<option value = "2"<%= selected("2", request("pleats")) %>>2</option>

<option value = "4"<%= selected("4", request("pleats")) %>>4</option>

<option value = "5"<%= selected("5", request("pleats")) %>>5</option>
</select>
</td>

<td width = "11%">
Fabric Company:
</td>

<td width = "21%">
<input name = "valancefabric" value = "<%= request("valancefabric") %>" type = "text"
id = "valancefabric" size = "25" maxlength = "50">
</td>

<td width = "12%">
Fabric Design, Colour & Code:
</td>

<td width = "33%">
<span id = "valancefabric_div">

<input name = "valancefabricchoice" value = "<%= request("valancefabricchoice") %>"
type = "text" id = "valancefabricchoice" size = "50" maxlength = "100"> </span>
</td>
</tr>

<tr>
<td>
Fabric Options:
</td>

<td>
<select name = "valancefabricoptions" id = "valancefabricoptions" tabindex = "80">
<option value = "Savoir Supply"
<%= selected("Savoir Supply", request("valancefabricoptions")) %>>Savoir
Supply</option>

<option value = "Customer Own Material"
<%= selected("Customer Own Material ", request("valancefabricoptions")) %>>Customer
Own Material</option>
</select>
</td>

<td>
Valance Fabric Direction
</td>

<td>
<select name = "valancefabricdirection" id = "valancefabricdirection">
<option value = "--"<%= selected("--", request("valancefabricdirection")) %>>--</option>

<option value = "Fabric on the run"
<%= selected("Fabric on the run", request("valancefabricdirection")) %>>Fabric on
the run</option>

<option value = "Fabric on the drop"
<%= selected("Fabric on the drop", request("valancefabricdirection")) %>>Fabric on
the drop</option>
</select>

&nbsp;
</td>

<td>&nbsp;

</td>

<td>&nbsp;

</td>
</tr>

<tr>
<td>
Price Per Metre
</td>

<td>
<input name = "valfabriccost" class="xview" value = "<%= request("valfabriccost") %>" type = "text"
id = "valfabriccost" size = "15">
</td>

<td>
Fabric Quantity
</td>

<td>
<input name = "valfabricmeters" value = "<%= request("valfabricmeters") %>" type = "text"
id = "valfabricmeters" size = "15">
</td>

<td>
Fabric Price Total
</td>

<td>
<input name = "valfabricprice" class="xview" value = "<%= request("valfabricprice") %>" type = "text"
id = "valfabricprice" size = "15">
</td>
</tr>

<tr>
<td>
Valance Drop
</td>

<td>
<input name = "valancedrop" value = "<%= request("valancedrop") %>" type = "text"
id = "valancedrop" size = "15">
</td>

<td>
Valance Width
</td>

<td>
<input name = "valancewidth" value = "<%= request("valancewidth") %>" type = "text"
id = "valancewidth" size = "15">
</td>

<td>
Valance Length
</td>

<td>
<input name = "valancelength" value = "<%= request("valancelength") %>" type = "text"
id = "valancelength" size = "15">
</td>
</tr>
</table>
<div class = "clear"></div>

<p>Valance Special Instructions:</p>

<textarea name = "specialinstructionsvalance" cols = "65" class = "indentleft"
id = "specialinstructionsvalance"
tabindex = "95" onKeyUp="return taCount(this,'myCounter7')"><%= request("specialinstructionsvalance") %></textarea><B><SPAN id=myCounter7>250</SPAN></B>/250

                <span class = "floatprice"> Valance
                <span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>

                <label>
                <input name = "valanceprice" class="xview" value = "<%= request("valanceprice") %>" type = "text" id = "valanceprice"
                    size = "15"></label>

                </span><div class = "clear"></div>
    </div>

<!-- accessories section -->
<p class = "purplebox"><span class = "radiobxmargin">Accessories Required</span>&nbsp;Yes

<input type = "radio" name = "accessoriesrequired" id = "accessoriesrequired" value = "y"
<%= ischeckedY(request("accessoriesrequired")) %>onClick = "javascript: accessoriesChanged(); getMadeAt()">

</label>

No

<input name = "accessoriesrequired" type = "radio" id = "accessoriesrequired" value = "n"
<%= ischeckedN(request("accessoriesrequired")) %>onClick = "javascript: accessoriesChanged(); getMadeAt()"></p>

<div id = "accessories_div">
<table align = "center">
<tr>
<th>
Item&nbsp;No.
</th>

<th>
Item&nbsp;Description
</th>

<th>
Design &amp; Detail
</th>

<th>
Colour
</th>

<th>
Size
</th>

                        <th class="xview">
                            Unit&nbsp;Price
                        </th>

<th>
Quantity
</th>
</tr>
<%
for i = 1 to 20
%>

<tr id = "acc_row<%= i %>">
<td><%= i %></td>

<td>
<input name = "acc_desc<%= i %>" type = "text" id = "acc_desc<%= i %>"
value = "<%= request("acc_desc"&i) %>" size = "20" maxlength = "50" />
</td>

<td>
<input name = "acc_design<%= i %>" type = "text" id = "acc_design<%= i %>"
value = "<%= request("acc_design"&i) %>" size = "20" maxlength = "50" />
</td>

<td>
<input name = "acc_colour<%= i %>" type = "text" id = "acc_colour<%= i %>"
value = "<%= request("acc_colour"&i) %>" size = "20" maxlength = "50" />
</td>

<td>
<input name = "acc_size<%= i %>" type = "text" id = "acc_size<%= i %>"
value = "<%= request("acc_size"&i) %>" size = "20" maxlength = "50" />
</td>

                        <td class="xview">
                            <input type = "text" name = "acc_unitprice<%= i %>" id = "acc_unitprice<%= i %>"
                                value = "<%= request("acc_unitprice"&i) %>" size = "10" />
                        </td>

<td>
<select name = "acc_qty<%= i %>" id = "acc_qty<%= i %>">
<%
for n = 1 to 50
%>

<option value = "<%= n %>"
<%= selected(cstr(n), request("acc_qty"&i)) %>><%= n %></option>
<%
next
%>
</select>
</td>
</tr>
<%
next
%>
</table>

<p>Accessories total:&nbsp;<span id = "accessories_total"></span></p>
</div>

<!-- delivery charge section -->
<p class = "purplebox"><span class = "radiobxmargin">Delivery Charge</span>&nbsp;Yes

<label> <input type = "radio" name = "deliverycharge" id = "deliverycharge" value = "y"
<%= ischeckedY(request("deliverycharge")) %>onClick = "javascript: deliveryChanged()"></label>

No

<input name = "deliverycharge" type = "radio" id = "deliverycharge" value = "n"
<%= ischeckedN(request("deliverycharge")) %>onClick = "javascript: deliveryChanged()"></p>

<div id = "delivery_div">
<table width = "98%" border = "0" align = "center" cellpadding = "3" cellspacing = "3">
<tr>
<td width = "17%">
Access Check Required?
</td>

<td width = "38%">
<select name = "accesscheck" id = "accesscheck" tabindex = "90">
<option value = "No"<%= selected("No", request("accesscheck")) %>>No</option>

<option value = "Yes"<%= selected("Yes", request("accesscheck")) %>>Yes</option>
</select>

&nbsp;
</td>

<td width = "14%">
Disposal of old bed
</td>

<td width = "31%">
<select name = "oldbed" id = "oldbed" tabindex = "91">
<option value = "--"<%= selected("--", request("oldbed")) %>>--</option>

<option value = "No"<%= selected("No", request("oldbed")) %>>No</option>

<option value = "Yes"<%= selected("Yes", request("oldbed")) %>>Yes</option>
</select>
</td>
</tr>
</table>

<p>Delivery Special Instructions:</p>

<textarea name = "specialinstructionsdelivery" cols = "65" class = "indentleft"
id = "specialinstructionsdelivery"
tabindex = "95"><%= request("specialinstructionsdelivery") %></textarea>

<span class = "floatprice"> Delivery
<span class = "cursym"><%= getCurrencySymbolForCurrency(orderCurrency) %></span>

<label> <input name = "deliveryprice" class="xview" value = "<%= request("deliveryprice") %>" type = "text"
id = "deliveryprice" size = "15"></label>

<br /><button type = "button" class="xview" onClick = "JavaScript: setDefaultDeliveryCharge()">Get Standard Delivery
Price</button> </span>
</div>

<div class = "clear"></div>

<hr>
<p>
<input type = "hidden" name = "ordersource" id = "ordersource" value = "<%= ordersource %>">
<input type = "hidden" name = "overseas" id = "overseas" value = "<%= overseas %>">
<input type = "hidden" name = "quote" id = "quote" value = "<%= quote %>">
<input type = "hidden" name = "contact_no" id = "contact_no" value = "<%= contact_no %>">
<%
If quote = "y" Then
%>

<input type = "submit" name = "submit" value = "Save Quote" id = "submit" class = "button"
tabindex = "105" />
<%
Else
%>

<input type = "submit" name = "submit" value = "Add Order" id = "submit" class = "button"
tabindex = "105" />
<%
End If
%>

</p>

<p>&nbsp;</p>

<p>&nbsp;</p>

<p>&nbsp;</p>

</form>
</div>

</div>

</div>
<%
call closemysqlrs(rsContactAddress)
call closemysqlcon(con)
%>
</body>
</html>

<script Language = "JavaScript" type = "text/javascript">
<!--
$('#basefabriccost').blur(function() {
calcStandardBaseFabricPrice(null);
});

$('#basefabricmeters').blur(function() {
calcStandardBaseFabricPrice(null);
});

$('#hbfabriccost').blur(function() {
calcHBFabricPrice(null);
});

$('#hbfabricmeters').blur(function() {
calcHBFabricPrice(null);
});

$('#valfabriccost').blur(function() {
calcValFabricPrice(null);
});

$('#valfabricmeters').blur(function() {
calcValFabricPrice(null);
});

$('#ordernote_followupdate').blur(function() {
calendarBlurHandler();
});

function calendarBlurHandler(ctrl) {
    //console.log('Handler for .blur() called.');
    $("#ordernote_action option[value='<%=ACTION_REQUIRED%>']").attr('selected', 'selected');
}

var vatRateJs;
var isTradeJs;

$(document).ready(init());
function init() {
mattressTickingSelected();
topperTickingSelected();
baseTickingSelected();
$('.drawerscls').hide();

$("#tickingoptions").change(mattressTickingSelected);
$("#toppertickingoptions").change(topperTickingSelected);
$("#basetickingoptions").change(baseTickingSelected);

    headboardstyle();
    manhattanTrimOptions();
	footboardOptions();
    $("#headboardstyle").change(headboardstyle);
    $("#headboardstyle").change(setHeadboardHeightOptions);
    //$("#headboardstyle").change(setLegStyleOptions); removal requested by Daryl 19july13
    $("#headboardstyle").change(manhattanTrimOptions);
	$("#headboardstyle").change(footboardOptions);
    
    mattspecialwidthSelected(false);
    
    mattspeciallengthSelected(false);
    basespecialwidthSelected(false);
    basespeciallengthSelected(false);
    topperspecialwidthSelected(false);
    topperspeciallengthSelected(false);
    legspecialheightSelected(false);
    mattressChanged();
    topperChanged();
    baseChanged();
    upholsteredBaseChanged();
    headboardChanged();
    legsChanged();
    setLegQty();
    valanceChanged();
    accessoriesChanged();
    deliveryChanged();
    calcStandardBaseFabricPrice(<%=request("standardbasefabricprice")%>)
    calcHBFabricPrice(<%=request("hbfabricprice")%>)
    calcValFabricPrice(<%=request("valfabricprice")%>)
    
    hideDiscountFields();
    
    setBaseTrimColours('<%=request("basetrimcolour")%>');

    vatRateJs = $('#vatrate').val()*1.0;
	<% if isTrade then %>
		isTradeJs = "y";
	<% else %>
		isTradeJs = "n";
	<% end if %>
}

function showtickingoptions() {
    
    var selection = $("#savoirmodel").val();
    if (selection == "No. 4v") {
    
    $("#tickingoptions option[value='Grey Trellis']").show();
    $("#tickingoptions option[value='n']").hide();
    $("#tickingoptions option[value='TBC']").hide();
    $("#tickingoptions option[value='White Trellis']").hide();
    $("#tickingoptions option[value='Silver Trellis']").hide();
    $("#tickingoptions option[value='Grey Trellis']").attr('selected', 'selected');
    $('#mattressinstructions').val('Vegan Bed - Vegan materials to be used');
    mattressTickingSelected();
    defaultTopperTickingOptions();
    defaultBaseTickingOptions();
    } else {
    $("#tickingoptions option[value='n']").show();
    $("#tickingoptions option[value='TBC']").show();
    $("#tickingoptions option[value='White Trellis']").show();
    $("#tickingoptions option[value='Silver Trellis']").show();
    $("#tickingoptions option[value='Grey Trellis']").show();
    $('#mattressinstructions').val('');
    }
    
}
function showtoppertickingoptions() {
    
    var selection = $("#toppertype").val();
    if (selection == "CFv Topper") {
    
    $("#toppertickingoptions option[value='n']").hide();
    $("#toppertickingoptions option[value='TBC']").hide();
    $("#toppertickingoptions option[value='White Trellis']").hide();
    $("#toppertickingoptions option[value='Silver Trellis']").hide();
    $("#toppertickingoptions option[value='Grey Trellis']").attr('selected', 'selected');
    $('#specialinstructionstopper').val('Vegan Bed - Vegan materials to be used');
    //mattressTickingSelected();
    //defaultTopperTickingOptions();
    //defaultBaseTickingOptions();
    } else {
    $("#toppertickingoptions option[value='n']").show();
    $("#toppertickingoptions option[value='TBC']").show();
    $("#toppertickingoptions option[value='White Trellis']").show();
    $("#toppertickingoptions option[value='Silver Trellis']").show();
    $("#toppertickingoptions option[value='Grey Trellis']").show();
    $('#specialinstructionstopper').val('');
    }
    
}
function showbasetickingoptions() {
    
    var selection = $("#basesavoirmodel").val();
    if (selection == "No. 4v") {
    
    $("#basetickingoptions option[value='n']").hide();
    $("#basetickingoptions option[value='TBC']").hide();
    $("#basetickingoptions option[value='White Trellis']").hide();
    $("#basetickingoptions option[value='Silver Trellis']").hide();
    $("#basetickingoptions option[value='Grey Trellis']").attr('selected', 'selected');
    $('#specialinstructions2').val('Vegan Bed - Vegan materials to be used');
    //mattressTickingSelected();
    //defaultTopperTickingOptions();
    //defaultBaseTickingOptions();
    } else {
    $("#basetickingoptions option[value='n']").show();
    $("#basetickingoptions option[value='TBC']").show();
    $("#basetickingoptions option[value='White Trellis']").show();
    $("#basetickingoptions option[value='Silver Trellis']").show();
    $("#basetickingoptions option[value='Grey Trellis']").show();
    $('#specialinstructions2').val('');
    }
    
}


function mattressTickingSelected() {
    $('#tick1').hide();
    $('#tick2').hide();
    $('#tick3').hide();
    $('#tick4').hide();
    
    var selection = $("#tickingoptions").val();
    if (selection == "White Trellis") {
        $('#tick1').show();
    } else if (selection == "Grey Trellis") {
        $('#tick2').show();
    } else if (selection == "Silver Trellis") {
        $('#tick3').show();
    }
}

function topperTickingSelected() {
$('#tick1t').hide();
$('#tick2t').hide();
$('#tick3t').hide();
$('#tick4t').hide();

    var selection = $("#toppertickingoptions").val();
    if (selection == "White Trellis") {
        $('#tick1t').show();
    } else if (selection == "Grey Trellis") {
        $('#tick2t').show();
    } else if (selection == "Silver Trellis") {
        $('#tick3t').show();
    }
}

function baseTickingSelected() {
$('#tick1b').hide();
$('#tick2b').hide();
$('#tick3b').hide();
$('#tick4b').hide();

    var selection = $("#basetickingoptions").val();
    if (selection == "White Trellis") {
        $('#tick1b').show();
    } else if (selection == "Grey Trellis") {
        $('#tick2b').show();
    } else if (selection == "Silver Trellis") {
        $('#tick3b').show();
    }
}

function headboardstyle() {
hideAllHeadboardSwatches();
var selection = $("#headboardstyle").val();
if (selection == "Virginia") {
$('#tick5').show();
} else if (selection == "Savoy") {
$('#tick6').show();
} else if (selection == "Penelope") {
$('#tick7').show();
} else if (selection == "Nicky") {
$('#tick8').show();
} else if (selection == "Mary") {
$('#tick9').show();
} else if (selection == "Ian (Headboard)") {
$('#tick10').show();
} else if (selection == "Hatti") {
$('#tick11').show();
} else if (selection == "Holly") {
$('#tick12').show();
} else if (selection == "Elliot (F100)") {
$('#tick13').show();
} else if (selection == "Alex (MF31)") {
$('#tick14').show();
} else if (selection == "Elizabeth (MF32)") {
$('#tick15').show();
} else if (selection == "Animal") {
$('#tick16').show();
} else if (selection == "Leo (CF5)") {
$('#tick17').show();
} else if (selection == "Lotti (CF4)") {
$('#tick18').show();
} else if (selection == "Harlech (CF2)") {
$('#tick19').show();
} else if (selection == "Felix (TF30)") {
$('#tick20').show();
} else if (selection == "Claudia") {
$('#tick21').show();
} else if (selection == "Gorrivan") {
$('#tick22').show();
}
}

//beginning new legheight section
function legspecialheightSelected(clearvalues) {
hidelegspecialheight(clearvalues);
var slct = $("#legheight option:selected").val();
if (slct == "Special Height") {
$('#legspecialheight').show();
}
}
//beginning new mattwidth section
function mattspecialwidthSelected(clearvalues) {
hidemattspecialwidth(clearvalues);
var selection = $("#mattresswidth").val();
var selection2 = $("#mattresstype").val();
if ((selection == "Special Width") && ((selection2 == "Zipped Pair") || (selection2 == "Zipped Pair (Centre Only)"))) {
$('#mattspecialwidth1').show();
$('#mattspecialwidth2').show();
}
if ((selection == "Special Width") && ((selection2 != "Zipped Pair") && (selection2 != "Zipped Pair (Centre Only)"))) {
$('#mattspecialwidth1').show();
}
}
function mattspeciallengthSelected(clearvalues) {
hidemattspeciallength(clearvalues);
var selection = $("#mattresslength").val();
var selection2 = $("#mattresstype").val();
if ((selection == "Special Length") && ((selection2 == "Zipped Pair") || (selection2 == "Zipped Pair (Centre Only)"))) {
$('#mattspeciallength1').show();
$('#mattspeciallength2').show();
}
if ((selection == "Special Length") && ((selection2 != "Zipped Pair") && (selection2 != "Zipped Pair (Centre Only)"))) {
$('#mattspeciallength1').show();
}
}

function hidelegspecialheight(clearvalues) {
$('#legspecialheight').hide();
if (clearvalues) {
$("#speciallegheight").val("");
}
}

function hidemattspecialwidth(clearvalues) {
$('#mattspecialwidth1').hide();
$('#mattspecialwidth2').hide();
if (clearvalues) {
$("#matt1width").val("");
$("#matt2width").val("");
}
}

function hidemattspeciallength(clearvalues) {
$('#mattspeciallength1').hide();
$('#mattspeciallength2').hide();
if (clearvalues) {
$("#matt1length").val("");
$("#matt2length").val("");
}
}

//end new section
//beginning new basewidth section
function basespecialwidthSelected(clearvalues) {
hidebasespecialwidth(clearvalues);
var selection = $("#basewidth").val();
var selection2 = $("#basetype").val();
if ((selection == "Special Width") && ((selection2 == "North-South Split") || (selection2 == "East-West Split"))) {
$('#basespecialwidth1').show();
$('#basespecialwidth2').show();
}
if ((selection == "Special Width") && ((selection2 != "North-South Split") && (selection2 != "East-West Split"))) {
$('#basespecialwidth1').show();
}
}
function basespeciallengthSelected(clearvalues) {
hidebasespeciallength(clearvalues);
var selection = $("#baselength").val();
var selection2 = $("#basetype").val();
if ((selection == "Special Length") && ((selection2 == "North-South Split") || (selection2 == "East-West Split"))) {
$('#basespeciallength1').show();
$('#basespeciallength2').show();
}
if ((selection == "Special Length") && ((selection2 != "North-South Split") && (selection2 != "East-West Split"))) {
$('#basespeciallength1').show();
}
}

function hidebasespecialwidth(clearvalues) {

$('#basespecialwidth1').hide();
$('#basespecialwidth2').hide();
if (clearvalues) {
$("#base1width").val("");
$("#base2width").val("");
}

}

function hidebasespeciallength(clearvalues) {
$('#basespeciallength1').hide();
$('#basespeciallength2').hide();
if (clearvalues) {
$("#base1length").val("");
$("#base2length").val("");
}
}

//end new section
//beginning new topperwidth section
function topperspecialwidthSelected(clearvalues) {
hidetopperspecialwidth(clearvalues);
var selection = $("#topperwidth").val();
if (selection == "Special Width") {
$('#topperspecialwidth1').show();
}
}
function topperspeciallengthSelected(clearvalues) {
hidetopperspeciallength(clearvalues);
var selection = $("#topperlength").val();
if (selection == "Special Length") {
$('#topperspeciallength1').show();
}
}

function hidetopperspecialwidth(clearvalues) {

$('#topperspecialwidth1').hide();
if (clearvalues) {
$("#topper1width").val("");
}

}

function hidetopperspeciallength(clearvalues) {
$('#topperspeciallength1').hide();
if (clearvalues) {
$("#topper1length").val("");
}
}

//end new section


function headboardwidthOptions() {
    var valueMatt = $("input[name=mattressrequired]:checked").val();
    //console.log("vmatt=" + valueMatt);
    var valueBase = $("input[name=baserequired]:checked").val();
    var valueHB = $("input[name=headboardrequired]:checked").val();
    if (valueMatt == 'n' && valueBase == 'n' && valueHB == 'y')  {
        $('#headboardwidth').show();
    } else {
        $('#headboardwidth').hide();
    }
}

function manhattanTrimOptions() {
var slct = $("#headboardstyle").val();
if (slct && (slct.substring(0, 9) == 'Manhattan' || slct == 'Holly' || slct == 'Hatti' || slct == 'Harlech (CF2)' || slct == 'Lotti (CF4)' || slct == 'Leo (CF5)' || slct == 'Winston (Stitched)' || slct == 'C2' || slct == 'C4' || slct == 'C5' || slct == 'CF2' || slct == 'CF4' || slct == 'CF5')) {
$('#manhattantrimdiv1').show();
$('#manhattantrimdiv2').show();
} else {
$("#manhattantrim option[value='--']").attr('selected', 'selected');
$('#manhattantrimdiv1').hide();
$('#manhattantrimdiv2').hide();
}
}

function footboardOptions() {
var slct = $("#headboardstyle").val();
if (slct && (slct.substring(0, 30) == 'Gorrivan Headboard & Footboard')) {
$('#footboardheightdiv1').show();
$('#footboardheightdiv2').show();
$('#footboardfinishdiv1').show();
$('#footboardfinishdiv2').show();
} else {
$("#footboardheight option[value='--']").attr('selected', 'selected');
$("#footboardfinish option[value='--']").attr('selected', 'selected');
$('#footboardheightdiv1').hide();
$('#footboardheightdiv2').hide();
$('#footboardfinishdiv1').hide();
$('#footboardfinishdiv2').hide();
}
}

function setHeadboardHeightOptions() {
var hbStyle = $("#headboardstyle").val();
var url = "get-field-options-ajax.asp?fieldname=headboardheight&defaultsrcfield=headboardstyle&defaultsrcopt=" + escape(hbStyle) + "&ts=" + (new Date()).getTime();
$('#headboardheight').load(url);
}

function setLegStyleOptions() {
var hbStyle = $("#headboardstyle").val();
var url = "get-field-options-ajax.asp?fieldname=legstyle&defaultsrcfield=headboardstyle&defaultsrcopt=" + escape(hbStyle) + "&ts=" + (new Date()).getTime();
$('#legstyle').load(url, function() {setLegFinishes();});
}

function hideAllTickingSwatches() {
$('#tick1t').hide();
$('#tick2t').hide();
$('#tick3t').hide();
$('#tick4t').hide();
$('#tick1b').hide();
$('#tick2b').hide();
$('#tick3b').hide();
$('#tick4b').hide();
}

function hideAllHeadboardSwatches() {
$('#tick5').hide();
$('#tick6').hide();
$('#tick7').hide();
$('#tick8').hide();
$('#tick9').hide();
$('#tick10').hide();
$('#tick11').hide();
$('#tick12').hide();
$('#tick13').hide();
$('#tick14').hide();
$('#tick15').hide();
$('#tick16').hide();
$('#tick17').hide();
$('#tick18').hide();
$('#tick19').hide();
$('#tick20').hide();
$('#tick21').hide();
$('#tick22').hide();
}
function showDrawersSection() {
var value = $('#drawerconfig').val();
if (value!="n") {
	$('.drawerscls').show();
} else{
	$('.drawerscls').hide();
	$("#drawerheight option[value='n']").attr('selected', 'selected');
	}

}



function mattressChanged() {
getAllStandardPrices(); // so the standard (list) price is shown that results from any defaults
var value = $("input[name=mattressrequired]:checked").val();
if (value == 'y') {
$('#mattress_div').show("slow");
} else {
$('#mattress_div').hide("slow");
}
}

function topperChanged() {
getAllStandardPrices(); // so the standard (list) price is shown that results from any defaults
var value = $("input[name=topperrequired]:checked").val();
if (value == 'y') {
$('#topper_div').show("slow");
} else {
$('#topper_div').hide("slow");
}
}

function baseChanged() {
getAllStandardPrices(); // so the standard (list) price is shown that results from any defaults
var value = $("input[name=baserequired]:checked").val();
if (value == 'y') {
$('#base_div').show("slow");
} else {
$('#base_div').hide("slow");
}
	getStandardLegsPrice(); // because having a base makes some legs free
}

function upholsteredBaseChanged() {
var value = $('#upholsteredbase').val();
if (value == 'n' || value == 'TBC') {
	$('#uphbase').hide("slow");
	$('#basefabricdirection').val("--");
	$('#basefabric').val("");
	$('#basefabricchoice').val("");
	$('#basefabriccost').val("");
	$('#basefabricmeters').val("");
	$('#basefabricdesc').val("");
	$('#basefabricprice').val("");
} else {
	$('#uphbase').show("slow");
}
}

function headboardChanged() {
getAllStandardPrices(); // so the standard (list) price is shown that results from any defaults
var value = $("input[name=headboardrequired]:checked").val();
if (value == 'y') {
$('#headboard_div').show("slow");
} else {
$('#headboard_div').hide("slow");
}
}

function legsChanged() {
    getAllStandardPrices(); // so the standard (list) price is shown that results from any defaults
    var value = $("input[name=legsrequired]:checked").val();
    if (value == 'y') {
        $('#legs_div').show("slow");
    } else {
        $('#legs_div').hide("slow");
    }
}

function valanceChanged() {
    var value = $("input[name=valancerequired]:checked").val();
    if (value == 'y') {
        $('#valance_div').show("slow");
    } else {
        $('#valance_div').hide("slow");
    }
}

function accessoriesChanged() {
var value = $("input[name=accessoriesrequired]:checked").val();
if (value == 'y') {
$('#accessories_div').show("slow");
} else {
$('#accessories_div').hide("slow");
}
}

function deliveryChanged() {
var value = $("input[name=deliverycharge]:checked").val();
if (value == 'y') {
setDefaultDeliveryCharge();
$('#delivery_div').show("slow");
} else {
$('#delivery_div').hide("slow");
$('#deliveryprice').val(''); // remove delivery price if delivery deselected
}
}

function setDefaultDeliveryCharge() {
var country = $('#countryd').val();
if (country == "") country = $('#country').val();
country = encodeURIComponent(country);
var postcode = $('#postcoded').val();
if (postcode == "") postcode = $('#postcode').val();
postcode = encodeURIComponent(postcode);
var jsVatRate = $('#vatrate').val()*1.0;
<% if isTrade then %>
var jsIsTrade = "y";
<% else %>
var jsIsTrade = "n";
<% end if %>
var url = "ajaxGetShippingCost.asp?country=" + country + "&postcode=" + postcode + "&vatrate=" + jsVatRate + "&istrade=" + jsIsTrade + "&ts=" + (new Date()).getTime();
$.get(url, function(data) {
$('#deliveryprice').val(data);
});
}

function setLegFinishes() {

var slct = $("#legstyle option:selected").val();
var finishOptions = [];
var heightOptions = [];
var defaultFinishSelection = "";
var defaultHeightSelection = "";

if (slct == "TBC") {
finishOptions.push("TBC");
heightOptions.push("TBC");
} else if (slct == "Wooden Tapered") {
finishOptions.push("TBC");
finishOptions.push("Natural Maple");
finishOptions.push("Oak");
finishOptions.push("Walnut");
finishOptions.push("Ebony");
finishOptions.push("Rosewood");
finishOptions.push("Upholstered");
finishOptions.push("Special (as instructions)");
heightOptions.push("TBC");
heightOptions.push("9.5cm/ Low");
heightOptions.push("13.5cm/ Standard");
heightOptions.push("17cm/ Tall");
heightOptions.push("21cm/ Very Tall");
heightOptions.push("Special Height");
} else if (slct == "Holly") {
finishOptions.push("TBC");
finishOptions.push("Natural Maple");
finishOptions.push("Oak");
finishOptions.push("Ebony");
finishOptions.push("Rosewood");
finishOptions.push("Walnut");
finishOptions.push("Special (as instructions)");
defaultFinishSelection = "Rosewood";
heightOptions.push("15cm");
defaultHeightSelection = "15cm";
} else if (slct == "Ian Leg")
 {
	 heightOptions.push("15cm");
	 defaultHeightSelection = "15cm";
 } else if (slct == "Metal") {
finishOptions.push("Brass");
finishOptions.push("Silver");
heightOptions.push("15cm");
defaultHeightSelection = "15cm";
}
else if (slct == "Penelope") {
finishOptions.push("Upholstered");
heightOptions.push("15cm");
}
else if (slct == "Cloud") {
finishOptions.push("Bronze");
heightOptions.push("15cm");
}
else if (slct == "Cylindrical") {
finishOptions.push("TBC");
finishOptions.push("Natural");
finishOptions.push("Oak");
finishOptions.push("Walnut");
finishOptions.push("Ebony");
finishOptions.push("Rosewood");
finishOptions.push("Special (as instructions)");
heightOptions.push("TBC");
heightOptions.push("9.5cm/ Low");
heightOptions.push("13.5cm/ Standard");
heightOptions.push("17cm/ Tall");
heightOptions.push("21cm/ Very Tall");
heightOptions.push("Special Height");
defaultHeightSelection = "TBC";
}
else if (slct == "Georgian" || slct == "Georgian (Brass cap)" || slct == "Georgian (Chrome cap)") {
finishOptions.push("Ebony");
finishOptions.push("Walnut");
finishOptions.push("Oak");
finishOptions.push("Rosewood");
finishOptions.push("Fabric Upholstered");
finishOptions.push("Special (as instructions)");
heightOptions.push("20cm");
}
  else if (slct == "Harlech Leg") {
finishOptions.push("Black Brushed Chrome");
finishOptions.push("Antique Brass")
heightOptions.push("17cm");
}
else if (slct == "Manhattan") {
finishOptions.push("TBC");
finishOptions.push("Natural Maple");
finishOptions.push("Oak");
finishOptions.push("Ebony");
finishOptions.push("Walnut");
finishOptions.push("Special (as instructions)");
defaultFinishSelection = "Ebony";
heightOptions.push("13.5cm");
heightOptions.push("TBC");
heightOptions.push("9.5cm/ Low");
heightOptions.push("17cm/ Tall");
heightOptions.push("21cm/ Very Tall");
heightOptions.push("Special Height");
defaultHeightSelection = "13.5cm";
} else if (slct == "Block Leg") {
finishOptions.push("TBC");
finishOptions.push("Ebony");
finishOptions.push("Oak");
finishOptions.push("Natural Maple");
finishOptions.push("Rosewood");
finishOptions.push("Walnut");
finishOptions.push("Special (as instructions)");
heightOptions.push("3cm/Low");
heightOptions.push("Special Height");
} else if (slct == "Ball & Claw") {
finishOptions.push("TBC");
finishOptions.push("Silver Gilded");
finishOptions.push("Gold Gilded");
finishOptions.push("Special (as instructions)");
heightOptions.push("15cm");
} else if (slct == "Castors") {
finishOptions.push("Brown");
heightOptions.push("TBC");
heightOptions.push("9.5cm/ Low");
heightOptions.push("13.5cm/ Standard");
heightOptions.push("17cm/ Tall");
heightOptions.push("21cm/ Very Tall");
heightOptions.push("Special Height");
} else if (slct == "Perspex") {
finishOptions.push("Perspex");
heightOptions.push("TBC");
heightOptions.push("9.5cm/ Low");
heightOptions.push("13.5cm/ Standard");
heightOptions.push("17cm/ Tall");
heightOptions.push("21cm/ Very Tall");
heightOptions.push("Special Height");
} else if (slct == "Special (as instructions)") {
finishOptions.push("Special (as instructions)");
heightOptions.push("Special Height");
}

$('#legfinish').find('option').remove();

$.each(finishOptions, function(val, text) {
$('#legfinish').append($('<option></option>').val(text).html(text));
});

if (defaultFinishSelection != "") {
$("#legfinish option[value='" + defaultFinishSelection + "']").attr('selected', 'selected');
}

$('#legheight').find('option').remove();

$.each(heightOptions, function(val, text) {
$('#legheight').append($('<option></option>').val(text).html(text));
});

if (defaultHeightSelection != "") {
$("#legheight option[value='" + defaultHeightSelection + "']").attr('selected', 'selected');
}
}

function setBaseTrimColours(defaultColour) {

	var selectedTrim = $("#basetrim option:selected").val();
	var colourOptions = [];
	
	if (selectedTrim == "Standard") {
		colourOptions.push("TBC");
		colourOptions.push("Walnut");
		colourOptions.push("Ebony");
		colourOptions.push("Oak");
		colourOptions.push("Maple");
	} else if (selectedTrim == "Self Levelling") {
		colourOptions.push("TBC");
		colourOptions.push("Ebony Macassar");
		colourOptions.push("Burr Walnut");
	}
	
	$('#basetrimcolour').find('option').remove();
	
	$.each(colourOptions, function(val, text) {
		$('#basetrimcolour').append($('<option></option>').val(text).html(text));
	});
	
	if (defaultColour != "") {
		$("#basetrimcolour option[value='" + defaultColour + "']").attr('selected', 'selected');
	}
	
	if (selectedTrim == "n") {
		$('.baseTrimColourCls').hide();
	} else {
		$('.baseTrimColourCls').show();
	}
}

function showLegStylePriceField() {
	// don't think this is needed
	//var slct = $("#legstyle option:selected").val();
	//if (slct == "Holly" || slct == "Ball & Claw" || slct == "Manhattan" || slct == "Special (as instructions)") {
	//	$('#legpricespan').show();
	//} else {
	//	$('#legpricespan').hide();
	//	$('#legprice').val(''); // remove leg price if leg price field hidden
	//}
}

function showFloorType() {
var slct = $("#legstyle option:selected").val();
if (slct == "Castors") {
$('.floortypeclass').show();
} else {
$('.floortypeclass').hide();
$("#floortype option[value='TBC']").attr('selected', 'selected'); // reset floortype selection
}
}

function calcStandardBaseFabricPrice(standardBaseFabricPrice) {
	if (standardBaseFabricPrice == null || standardBaseFabricPrice == 0.0) {
		var basefabriccost = $('#basefabriccost').val()*1.0
		var basefabricmeters = $('#basefabricmeters').val()*1.0
		standardBaseFabricPrice = basefabriccost * basefabricmeters;
	}
	$('#standardbasefabricprice').val((standardBaseFabricPrice).toFixed(2));
	$('#standardbasefabricpricespan').html(standardBaseFabricPrice.toFixed(2));
	setBaseFabricPrice();
}

function calcHBFabricPrice(hbFabricPrice) {
	if (hbFabricPrice == null || hbFabricPrice == 0.0) {
		var hbfabriccost = $('#hbfabriccost').val()*1.0
		var hbfabricmeters = $('#hbfabricmeters').val()*1.0
		hbFabricPrice = hbfabriccost * hbfabricmeters;
	}
	$('#hbfabricprice').val((hbFabricPrice).toFixed(2));
	calcTotalHeadboardPrice();
}

function calcValFabricPrice(valFabricPrice) {
if (valFabricPrice == null || valFabricPrice == 0.0) {
var valfabriccost = $('#valfabriccost').val()*1.0
var valfabricmeters = $('#valfabricmeters').val()*1.0
valFabricPrice = valfabriccost * valfabricmeters;
}
$('#valfabricprice').val((valFabricPrice).toFixed(2));
}

function hideDiscountFields() {
    $('.mattressdiscountcls').hide();
    $('.topperdiscountcls').hide();
    $('.basediscountcls').hide();
    $('.basefabricdiscountcls').hide();
    $('.upholsterydiscountcls').hide();
    $('.basetrimdiscountcls').hide();
    $('.basedrawersdiscountcls').hide();
    $('.legsdiscountcls').hide();
    $('.addlegsdiscountcls').hide();
    $('.headboarddiscountcls').hide();
    $('.headboardtrimdiscountcls').hide();
    
}

function IsNumeric(sText)
{
var ValidChars = "0123456789.";
var IsNumber=true;
var Char;


for (i = 0; i < sText.length && IsNumber == true; i++)
{
Char = sText.charAt(i);
if (ValidChars.indexOf(Char) == -1)
{
IsNumber = false;
}
}
return IsNumber;

}
function FrontPage_Form1_Validator(theForm)
{
 if ((theForm.drawerconfig.value != "n") && (theForm.drawerheight.value == "n"))
	{
	alert("Please add drawer height");
	theForm.drawerheight.focus();
	return (false);
	}
 if (!IsNumeric(theForm.matt1width.value)) 
   { 
      alert('Please enter only numbers for first mattress width') 
      theForm.matt1width.focus();
      return false; 
      }
if (!IsNumeric(theForm.matt2width.value)) 
   { 
      alert('Please enter only numbers for second mattress width') 
      theForm.matt2width.focus();
      return false; 
      }
if (!IsNumeric(theForm.matt1length.value)) 
   { 
      alert('Please enter only numbers for first mattress length') 
      theForm.matt1length.focus();
      return false; 
      }
if (!IsNumeric(theForm.matt2length.value)) 
   { 
      alert('Please enter only numbers for second mattress length') 
      theForm.matt2length.focus();
      return false; 
      }
if (!IsNumeric(theForm.base1width.value)) 
   { 
      alert('Please enter only numbers for first base width') 
      theForm.base1width.focus();
      return false; 
      }
if (!IsNumeric(theForm.base2width.value)) 
   { 
      alert('Please enter only numbers for second base width') 
      theForm.matt2width.focus();
      return false; 
      }
if (!IsNumeric(theForm.base1length.value)) 
   { 
      alert('Please enter only numbers for first base length') 
      theForm.base1length.focus();
      return false; 
      }
if (!IsNumeric(theForm.base2length.value)) 
   { 
      alert('Please enter only numbers for second base length') 
      theForm.base2length.focus();
      return false; 
      }
if (!IsNumeric(theForm.topper1width.value)) 
   { 
      alert('Please enter only numbers for topper width') 
      theForm.topper1width.focus();
      return false; 
      }
if (!IsNumeric(theForm.topper1length.value)) 
   { 
      alert('Please enter only numbers for topper length') 
      theForm.topper1length.focus();
      return false; 
      } 
if (!IsNumeric(theForm.mattressprice.value)) 
   { 
      alert('Please enter only numbers for mattress price'); 
      theForm.mattressprice.focus();
      return false; 
      }
if (!IsNumeric(theForm.topperprice.value)) 
   { 
      alert('Please enter only numbers for topper price'); 
      theForm.topperprice.focus();
      return false; 
      }
if (theForm.baseprice && !IsNumeric(theForm.baseprice.value)) 
   { 
      alert('Please enter only numbers for base price'); 
      theForm.baseprice.focus();
      return false; 
      } 
if (!IsNumeric(theForm.basefabricprice.value)) 
   { 
      alert('Please enter only numbers for base fabric price'); 
      theForm.basefabricprice.focus();
      return false; 
      } 
if (!IsNumeric(theForm.upholsteryprice.value)) 
   { 
      alert('Please enter only numbers for upholstery price'); 
      theForm.upholsteryprice.focus();
      return false; 
      } 
if (!IsNumeric(theForm.headboardprice.value)) 
   { 
      alert('Please enter only numbers for headboard price'); 
      theForm.headboardprice.focus();
      return false; 
      } 
if (!IsNumeric(theForm.valanceprice.value)) 
   { 
      alert('Please enter only numbers for valance price');
      theForm.valanceprice.focus();
      return false; 
      }	  
if (!IsNumeric(theForm.deliveryprice.value)) 
   { 
      alert('Please enter only numbers for delivery price');
      theForm.deliveryprice.focus();
      return false; 
      }	
if (!IsNumeric(theForm.speciallegheight.value)) 
   { 
      alert('Please enter only numbers for special leg height');
      theForm.speciallegheight.focus();
      return false; 
      }	      
if (theForm.ordernote_followupdate.value != "" && !isDate(theForm.ordernote_followupdate.value)) {
alert('Please enter a valid follow up date');
theForm.ordernote_followupdate.focus();
return false;
}

if (theForm.ordernote_followupdate.value != "" && theForm.ordernote_followupdate.value != "" && theForm.ordernote_notetext.value == "") {
// Have entred a date, so lets have a note
alert('Please enter a note for the entered follow up date');
theForm.ordernote_notetext.focus();
return false;
}

if (document.form1.submit) {
document.form1.submit.value = 'Please Wait...';
}
window.setTimeout("delayedSubmitDisable()", 10);
return true;
}

function delayedSubmitDisable() {
if (document.form1.submit) {
document.form1.submit.disabled = true;
}
}

//-->
</script>

<script Language = "JavaScript" type = "text/javascript">
<!--
window.onload = init2();
function init2() {
//populateFabricDropdown(document.form1.basefabric);
//populateFabricDropdown(document.form1.headboardfabric);
//populateFabricDropdown(document.form1.valancefabric);
setMattressTypes("<%=request("mattresstype")%>");
setLinkPosition("<%=request("linkposition")%>");
showLegStylePriceField();
showFloorType();
};

function populateFabricDropdown(e) {
var fabricChoice = getFabricChoiceFromRequest(e.name);
var url = "find-fabric-ajax.asp?fabric="+e.options[e.selectedIndex].value + "&name=" + e.name + "&ts=" + (new Date()).getTime();
if (fabricChoice != "") {
url += "&fabricChoice=" + fabricChoice;
}
//alert("url = " + url);
if (e.name=="basefabric") {
$('#basefabric_div').load(url);
} else if (e.name=="headboardfabric") {
$('#headboardfabric_div').load(url);
//alert("e.name = " + e.name);
} else {
$('#valancefabric_div').load(url);
//alert("e.name = " + e.name);
}
}

function getFabricChoiceFromRequest(selectName) {
var choice;
if (selectName == "basefabric") {
choice = "<%=server.URLEncode(request("basefabricchoice"))%>";
} else if (selectName == "headboardfabric") {
choice = "<%=server.URLEncode(request("headboardfabricchoice"))%>";
} else if (selectName == "valancefabric") {
choice = "<%=server.URLEncode(request("valancefabricchoice"))%>";
} else {
choice = "";
}
return choice;
}

    function defaultBaseModel() {
        var slct = $("#savoirmodel option:selected").val();
        $("#basesavoirmodel option[value='" + slct + "']").attr('selected', 'selected');
        basevegantext();
    }
    
    function toppervegantext() {
    
    var selection = $("#toppertype").val();
    if (selection == "CFv Topper") {
    $('#specialinstructionstopper').val('Vegan Bed - Vegan materials to be used');
    } else {
    $('#specialinstructionstopper').val('');
    }
    
}

function basevegantext() {
    
    var selection = $("#basesavoirmodel").val();
    if (selection == "No. 4v") {
    $('#baseinstructions').val('Vegan Bed - Vegan materials to be used');
    } else {
    $('#baseinstructions').val('');
    }
    
}
    
    function defaultVentPosition() {
        var slct = $("#savoirmodel option:selected").val();
        var ventPositionDefault = null;
        if (slct == "No. 1" || slct == "No. 2") {
            ventPositionDefault = "Vents on Ends";
        } else if (slct == "No. 3" || slct == "No. 4" || slct == "No. 5") {
            ventPositionDefault = "Vents on Sides";
        }
        if (ventPositionDefault != null) {
            $("#ventposition option[value='" + ventPositionDefault + "']").attr('selected', 'selected');
        }
    }
    
    //function defaultBaseTypeFromMattressType() {
    //    var slct = $("#mattresstype option:selected").val();
    //    if (slct && slct.substring(0, 11) == 'Zipped Pair') {
    //        slct = "North-South Split";
    //    }
    //    $("#basetype option[value='" + slct + "']").attr('selected', 'selected');
    //}
	
	function getMadeAt() {
		var MadeAtCardiff;
		MadeAtCardiff='false';
		var MadeAtLondon;
		MadeAtLondon='false';
		var MattressRequired=$("input[name=mattressrequired]:checked").val();
		var savoirmodel=$("#savoirmodel option:selected").val();
		var MattMadeAt=getMattressMadeAt(savoirmodel);
		if (MattressRequired == 'y') {
			if (MattMadeAt==1) {
				MadeAtCardiff='true';
			}
			if (MattMadeAt==2) {
				MadeAtLondon='true';
			}
		}
		var TopperRequired=$("input[name=topperrequired]:checked").val();
		var topperType=$("#toppertype option:selected").val();
		var TopperMadeAt=getTopperMadeAt(topperType);
		if (TopperRequired == 'y') {
			if (TopperMadeAt==1) {
				MadeAtCardiff='true';
			}
			if (TopperMadeAt==2) {
				MadeAtLondon='true';
			}
		}
		var BaseRequired=$("input[name=baserequired]:checked").val();
		var BaseType=$("#basesavoirmodel option:selected").val();
		var BaseMadeAt=getBaseMadeAt(BaseType);
		if (BaseRequired == 'y') {
			if (BaseMadeAt==1) {
				MadeAtCardiff='true';
			}
			if (BaseMadeAt==2) {
				MadeAtLondon='true';
			}
		}
		var HBRequired=$("input[name=headboardrequired]:checked").val();
		var HBType=$("#headboardstyle option:selected").val();
		var HBMadeAt=getHeadboardMadeAt(HBType);
		if (HBRequired == 'y') {
			if (HBMadeAt==1) {
				MadeAtCardiff='true';
			}
			if (HBMadeAt==2) {
				MadeAtLondon='true';
			}
		}
		var LegType=$("input[name=legsrequired]:checked").val();
		var LegsMadeAt=getLegsMadeAt(LegType);
		if (LegType == 'y') {
			if (LegsMadeAt==1) {
				MadeAtCardiff='true';
			}
			if (LegsMadeAt==2) {
				MadeAtLondon='true';
			}
		}
		var ValanceType=$("input[name=valancerequired]:checked").val();
		//console.log("ValanceType=" + ValanceType);
		var ValanceMadeAt=getValanceMadeAt(ValanceType);
		if (ValanceType == 'y') {
			if (ValanceMadeAt==1) {
				MadeAtCardiff='true';
			}
			if (ValanceMadeAt==2) {
				MadeAtLondon='true';
			}
		}
		var AccessoryType=$("input[name=accessoriesrequired]:checked").val();
		//console.log("AccessoryType=" + AccessoryType);
		if (AccessoryType == 'y') {
				MadeAtLondon='true';
		}
		
		var delDate = '<%=year(latestDeliveryDate) & "-" & month(latestDeliveryDate) & "-" & day(latestDeliveryDate)%>';
		if (MadeAtLondon == 'true' && MadeAtCardiff=='false') {
			delDate = '<%=year(londonDeliveryDate) & "-" & month(londonDeliveryDate) & "-" & day(londonDeliveryDate)%>';
		} else if (MadeAtLondon == 'false' && MadeAtCardiff=='true') {
			delDate = '<%=year(cardiffDeliveryDate) & "-" & month(cardiffDeliveryDate) & "-" & day(cardiffDeliveryDate)%>';
		}
		
		//console.log("MadeAtLondon=" + MadeAtLondon);
		//console.log("MadeAtCardiff=" + MadeAtCardiff);
		//console.log("delDate=" + delDate);
		$("#deldate option[value='" + delDate + "']").attr('selected', 'selected');
	}

//function defaultBaseTypeFromBaseWidth() {
//    var slct = $("#basewidth option:selected").val();
//    var baseTypeDefault = null;
//    if (slct == "90cm" || slct == "100cm" || slct == "105cm" || slct == "120cm") {
//        baseTypeDefault = "One Piece";
//    } else if (slct == "140cm" || slct == "160cm") {
//        baseTypeDefault = "East-West Split";
//    } else if (slct == "180cm" || slct == "200cm" || slct == "210cm" || slct == "240cm") {
//        baseTypeDefault = "North-South Split";
//    }
//    if (baseTypeDefault != null) {
//       $("#basetype option[value='" + baseTypeDefault + "']").attr('selected', 'selected');
//    }
//}

    function defaultBaseWidth() {
        var slct = $("#mattresswidth option:selected").val();
    //    $("#basewidth option[value='" + slct + "']").attr('selected', 'selected');
        $("#topperwidth option[value='" + slct + "']").attr('selected', 'selected');
        basespecialwidthSelected(false);
        topperspecialwidthSelected(false);
    }

    function defaultBaseLength() {
        var slct = $("#mattresslength option:selected").val();
        $("#topperlength option[value='" + slct + "']").attr('selected', 'selected');
    //    $("#baselength option[value='" + slct + "']").attr('selected', 'selected');
        basespeciallengthSelected(false);
        topperspeciallengthSelected(false);
    }

function defaultLinkFinish() {
var slct = $("#ventfinish option:selected").val();
if (slct == 'Brass' || slct == 'Chrome') {
//slct = slct + " and Link Bar";
}
$("#linkfinish option[value='" + slct + "']").attr('selected', 'selected');
}

function defaultTopperTickingOptions() {
var slct = $("#tickingoptions option:selected").val();
$("#toppertickingoptions option[value='" + slct + "']").attr('selected', 'selected');
topperTickingSelected();
}

function defaultBaseTickingOptions() {
var slct = $("#tickingoptions option:selected").val();
$("#basetickingoptions option[value='" + slct + "']").attr('selected', 'selected');
baseTickingSelected();
}

function setMattressTypes(defaultSelection) {
var slct = $("#mattresswidth option:selected").val();
if (defaultSelection == null) defaultSelection = "";

var mattressTypeOptions = [];
if (slct == "90cm" || slct == "96.5cm" || slct == "100cm" || slct == "105cm" || slct == "120cm" || slct == "140cm") {
mattressTypeOptions.push("--");
mattressTypeOptions.push("TBC");
mattressTypeOptions.push("One Piece");
localDefault = "One Piece";
if (defaultSelection != "TBC" && defaultSelection != "One Piece") {
defaultSelection = "One Piece";
}
} else {
mattressTypeOptions.push("--");
mattressTypeOptions.push("TBC");
mattressTypeOptions.push("One Piece");
mattressTypeOptions.push("Zipped Pair");
mattressTypeOptions.push("Zipped Pair (Centre Only)");
}

$('#mattresstype').find('option').remove();
$.each(mattressTypeOptions, function(val, text) {
$('#mattresstype').append($('<option></option>').val(text).html(text));
});
if (defaultSelection != "") {
$("#mattresstype option[value='" + defaultSelection + "']").attr('selected', 'selected');
}
}

    function setLinkPosition(defaultSelection) {
        if (defaultSelection == null) defaultSelection = "";
        var slctUpBase = $("#upholsteredbase option:selected").val();
        //console.log("slctUpBase = " + slctUpBase);
        var slctBaseType = $("#basetype option:selected").val();
        //console.log("slctBaseType = " + slctBaseType);
        
        var linkPositionOptions = [];
        linkPositionOptions.push("Link Underneath");
        if (slctUpBase != "Yes") {
            linkPositionOptions.push("Link on Ends");
        }
        linkPositionOptions.push("No Link Required");
        
        if (defaultSelection == "") {
            if (slctBaseType == "One Piece") {
                defaultSelection = "No Link Required";
            } else {
                defaultSelection = "Link Underneath";
            }
        }
        //console.log("defaultSelection = " + defaultSelection);
        
        $('#linkposition').find('option').remove();
        $.each(linkPositionOptions, function(val, text) {
            $('#linkposition').append($('<option></option>').val(text).html(text));
        });
        if (defaultSelection != "") {
            $("#linkposition option[value='" + defaultSelection + "']").attr('selected', 'selected');
        }
        
        linkPositionChanged();
    }

function linkPositionChanged() {
var val = $("#linkposition option:selected").val();
if (val == "No Link Required") {
$('.linkfinishclass').hide();
$("#linkfinish").val("n")
} else {
$('.linkfinishclass').show();
}
}

// accessories stuff
for (var i = 1; i < 21; i++) {
$('#acc_unitprice'+i).blur(function() {
calcAccessoriesTotal();
showNextAccessoriesRow();
});
$('#acc_qty'+i).change(function() {
calcAccessoriesTotal();
});
$('#acc_desc'+i).change(function() {
showNextAccessoriesRow();
});
}

calcAccessoriesTotal();
showNextAccessoriesRow();

var theCurrencySymbol = '<%=getCurrencySymbolForCurrency(orderCurrency)%>';
function getCurrSym() {
return theCurrencySymbol;
}

function calcAccessoriesTotal() {
var total = 0.0;
for (var i = 1; i < 21; i++) {
total += $('#acc_unitprice'+i).val() * $('#acc_qty'+i).val() * 1.0;
}
$('#accessories_total').html(getCurrSym() + total.toFixed(2));
}

function showNextAccessoriesRow() {
for (var i = 1; i < 20; i++) {
var ii = i+1;
if ($('#acc_desc'+i).val() == "") {
$('#acc_row'+ii).hide();
} else {
$('#acc_row'+ii).show();
}
}
}

function changeCurrency() {
var newCurrency = $("#ordercurrency option:selected").val();
var url = "getCurrencySymbolAjax.asp?currency=" + newCurrency + "&ts=" + (new Date()).getTime();
$.get(url, function(symbol) {
$('.cursym').html(symbol);
theCurrencySymbol = symbol;
calcAccessoriesTotal();
});
}

$("#delphonetype1").eComboBox({
'editableElements' : false
});
$("#delphonetype2").eComboBox({
'editableElements' : false
});
$("#delphonetype3").eComboBox({
'editableElements' : false
});

function copyInvToDelAddr() {
$('#add1d').val($('#add1').val());
$('#add2d').val($('#add2').val());
$('#add3d').val($('#add3').val());
$('#townd').val($('#town').val());
$('#countyd').val($('#county').val());
$('#postcoded').val($('#postcode').val());
$('#countryd').val($('#country').val());
}

function populateDelAdd() {
var delAddrId = $("#deladddropdown option:selected").val();
var url = "ajaxGetDeliveryAddress.asp?id=" + delAddrId + "&ts=" + (new Date()).getTime();
$.get(url, function(data) {
if (data != "") {
var vals = data.split('~');
$('#add1d').val(vals[0]);
$('#add2d').val(vals[1]);
$('#add3d').val(vals[2]);
$('#townd').val(vals[3]);
$('#countyd').val(vals[4]);
$('#postcoded').val(vals[5]);
$('#countryd').val(vals[6]);
$('#delphone1').val(vals[7]);
$('#delphone2').val(vals[8]);
$('#delphone3').val(vals[9]);
$('#delphonetype1').val(vals[10]);
$('#delphonetype2').val(vals[11]);
$('#delphonetype3').val(vals[12]);
}
});
}

//-->
</script>
<script language = "Javascript">
/**
 * DHTML textbox character counter script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
 */

maxL=250;
var bName = navigator.appName;
function taLimit(taObj) {
	if (taObj.value.length==maxL) return false;
	return true;
}

function taCount(taObj,Cnt) { 
	objCnt=createObject(Cnt);
	objVal=taObj.value;
	if (objVal.length>maxL) objVal=objVal.substring(0,maxL);
	if (objCnt) {
		if(bName == "Netscape"){	
			objCnt.textContent=maxL-objVal.length;}
		else{objCnt.innerText=maxL-objVal.length;}
	}
	return true;
}
function createObject(objId) {
	if (document.getElementById) return document.getElementById(objId);
	else if (document.layers) return eval("document." + objId);
	else if (document.all) return eval("document.all." + objId);
	else return eval("document." + objId);
}
function clearproductiondate() {
$('#productiondate').val('');
}
function clearbookeddeliverydate() {
$('#bookeddeliverydate').val('');
}
function clearacknowdate() {
$('#acknowdate').val('');
}
function clearordernote_followupdate() {
$('#ordernote_followupdate').val('');
}

</script>
<!-- #include file="common/logger-out.inc" -->
