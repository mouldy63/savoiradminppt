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
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="fieldoptionfuncs.asp" -->
<%
Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg, msg2, ItemValue, e1, contact_no, deldate
dim orderno, orderdate, clientstitle, clientsfirst, clientssurname, quote, i, n, tel, email_address, rsContactAddress, orderCurrency, defaultOrderCurrency, alternateCurrencies, arrCurr, curr
dim delDateValues(), delDateDescriptions(), typenames(), vatRates, defaultVatRate

quote=""
quote=Request("quote")
contact_no=Request("contact_no")
correspondence=Request("correspondence")
count=0


Set Con = getMysqlConnection()

defaultOrderCurrency = getCurrencyForLocation(retrieveUserLocation(), con)

if request("orderno") <> "" then
	orderno = request("orderno") ' got here via back button of order-added.asp, so use existing order no
	orderdate = ""
    clientstitle  = request("clientstitle")
    clientsfirst  = request("clientsfirst")
    clientssurname  = request("clientssurname")
    orderCurrency = request("ordercurrency")
else
	orderno = ""
	'orderdate = now()
	clientstitle = session("title")
	clientsfirst = session("firstname")
	clientssurname = session("surname")
    orderCurrency = defaultOrderCurrency
end if

' get any alternate currencies
set rs = getMysqlQueryRecordSet("Select alternatecurrencies from location where idLocation=" & retrieveUserLocation(), con)
if not rs.eof then
	alternateCurrencies = rs("alternatecurrencies")
end if
call closeRs(rs)

set rsContactAddress = getMysqlQueryRecordSet("Select * from contact c, address a where c.code=a.code and c.contact_no=" & contact_no, con)

deldate = request("deldate")
call makeApproxDateOptions(delDateValues, delDateDescriptions, deldate)

call getPhoneNumberTypes(con, typenames)
defaultVatRate = session("vatrate")
vatRates = getVatRates(con, defaultVatRate)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta content="text/html; charset=utf-8" http-equiv="content-type" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />

<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script src="common/jquery.eComboBox.custom.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>
</head>
<body>
<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">


<%If quote="y" Then%>
<p>ADD QUOTE</p>
<%Else%>
<p>ADD ORDER</p>
<%End If%>


		<form action="oldorder-added.asp" method="post" name="form1" onSubmit="return FrontPage_Form1_Validator(this)">	
        <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
          <tr>
            <td width="10%">Contact:</td>
            <td width="23%"><select name="contact" tabindex="1">
              <option value="<%=retrieveUserName()%>" <%=selected(retrieveUserName(), request("contact"))%> ><%=retrieveUserName()%></option>
              
            </select></td>
            <td colspan="2">Invoice Address:</td>
            <td colspan="2">Delivery Address:</td>
          </tr>
          <tr>
            <td>
<%If quote="y" Then%>
Quote
<%Else%>
Order
<%End If%> No:</td>
            <td><input type="text" name="orderno" value="<%=orderno%>" tabindex="2"></td>
            <td width="8%">Line 1:              </td>
            <td width="28%"><input name="add1" type="text" id="add1" tabindex="10" value="<%=requestOrSession("add1")%>" size="30" maxlength="100" ></td>
            <td width="8%">Line 1: </td>
            <td width="23%"><input name="add1d" value="<%=request("add1d")%>" type="text" id="add1d" tabindex="20" size="30" maxlength="100"></td>
          </tr>
          <tr>
            <td>Date:            </td>
            <td><input name="orderdate" type="text" id="orderdate" tabindex="3" value="<%=orderdate%>"></td>
            <td>Line 2:              </td>
            <td><input name="add2" type="text" id="add2" tabindex="11" value="<%=requestOrSession("add2")%>" size="30" maxlength="100" ></td>
            <td>Line 2: </td>
            <td><input name="add2d" type="text" value="<%=request("add2d")%>" id="add2d" tabindex="21" size="30" maxlength="100"></td>
          </tr>
          <tr>
            <td>Customer Reference:</td>
            <td><input name="reference" value="<%=request("reference")%>" type="text" id="reference" tabindex="4" maxlength="50"></td>
            <td>Line 3:</td>
            <td><input name="add3" type="text" id="add3" tabindex="11" value="<%=requestOrSession("add3")%>" size="30" maxlength="100" ></td>
            <td>Line 3:</td>
            <td><input name="add3d" value="<%=request("add3d")%>" type="text" id="add3d" tabindex="21" size="30" maxlength="100"></td>
          </tr>
          <tr>
            <td>Clients Title:</td>
            <td><input name="clientstitle" type="text" id="clientstitle" tabindex="5" value="<%=clientstitle%>" ></td>
            <td>Town:              </td>
            <td><input name="town" type="text" id="town" tabindex="12" value="<%=requestOrSession("town")%>" size="30" maxlength="100" ></td>
            <td>Town: </td>
            <td><input name="townd" value="<%=request("townd")%>" type="text" id="townd" tabindex="22" size="30" maxlength="100"></td>
          </tr>
          <tr>
            <td>First Name:</td>
            <td><input name="clientsfirst" type="text" id="clientsfirst" tabindex="5" value="<%=clientsfirst%>" ></td>
            <td>County:              </td>
            <td><input name="county" type="text" id="county" tabindex="13" value="<%=requestOrSession("county")%>" size="30" maxlength="100" ></td>
            <td>County: </td>
            <td><input name="countyd" value="<%=request("countyd")%>" type="text" id="countyd" tabindex="23" size="30" maxlength="100"></td>
          </tr>
          <tr>
            <td>Surname:</td>
            <td><input name="clientssurname" type="text" id="clientssurname" tabindex="5" value="<%=clientssurname%>" ></td>
            <td>Postcode:            </td>
            <td><input name="postcode" type="text" id="postcode" tabindex="14" value="<%=requestOrSession("postcode")%>" size="15" maxlength="50" ></td>
            <td>Postcode: </td>
            <td><input name="postcoded" value="<%=request("postcoded")%>" type="text" id="postcoded" tabindex="24" size="15" maxlength="50"></td>
          </tr>
          <tr>
            <td>Tel Home:</td>
            <td><input name="tel" type="text" id="tel" tabindex="5" value="<%=recordSetOrSession("tel", rsContactAddress)%>"></td>
            <td>Country:            </td>
            <td><input name="country" type="text" id="country" tabindex="15" value="<%=requestOrSession("country")%>" size="30" maxlength="100" ></td>
            <td>Country: </td>
            <td><input name="countryd" value="<%=request("countryd")%>" type="text" id="countryd" tabindex="25" size="30" maxlength="100"></td>
          </tr>
          <tr>
            <td>Tel Work:</td>
            <td><input name="telwork" type="text" id="telwork" tabindex="5" value="<%=recordSetOrSession("telwork", rsContactAddress)%>" />
              &nbsp;</td>
          	<td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>Contact number 1:</td>
            <td>
            	<select name="delphonetype1" id="delphonetype1">
            	<% for n = 1 to ubound(typenames) %>
            	<option value="<%=typenames(n)%>" <%=selected(typenames(n), request("delphonetype1"))%> ><%=typenames(n)%></option>
            	<% next %>
            	</select>
            	&nbsp;<input name="delphone1" type="text" id="delphone1" value="<%=request("delphone1")%>" />
            </td>
          </tr>
          <tr>
            <td>Mobile:</td>
            <td><input name="mobile" type="text" id="mobile" tabindex="5" value="<%=recordSetOrSession("mobile", rsContactAddress)%>">
              &nbsp;</td>
            <td>&nbsp;</td><td>&nbsp;</td>
            <td>Contact number 2:</td>
            <td>
            	<select name="delphonetype2" id="delphonetype2">
            	<% for n = 1 to ubound(typenames) %>
            	<option value="<%=typenames(n)%>" <%=selected(typenames(n), request("delphonetype2"))%> ><%=typenames(n)%></option>
            	<% next %>
            	</select>
            	&nbsp;<input name="delphone2" type="text" id="delphone2" value="<%=request("delphone2")%>" />
            </td>
          </tr>
          <tr>
            <td>VAT Rate</td>
            <td>
            	<select name="vatrate" id="vatrate">
            	<% for n = 1 to ubound(vatRates) %>
            	<option value="<%=vatRates(n)%>" <%=selected(defaultVatRate, vatRates(n))%> ><%=formatNumber(vatRates(n), 1, -1)%>%</option>
            	<% next %>
            	</select>
            </td>
            <% if rsContactAddress("company_vat_no") <> "" then %>
	            <td>Company VAT Number:</td><td><%=rsContactAddress("company_vat_no")%></td>
            <% else %>
            <td>&nbsp;</td><td>&nbsp;</td>
            <% end if %>
            <td>Contact number 3:</td>
            <td>
            	<select name="delphonetype3" id="delphonetype3">
            	<% for n = 1 to ubound(typenames) %>
            	<option value="<%=typenames(n)%>" <%=selected(typenames(n), request("delphonetype3"))%> ><%=typenames(n)%></option>
            	<% next %>
            	</select>
            	&nbsp;<input name="delphone3" type="text" id="delphone3" value="<%=request("delphone3")%>" />
            </td>
          </tr>
          <tr>
            <td>Email Address:</td>
            <td><input name="email_address" type="text" id="email_address" tabindex="5" value="<%=recordSetOrSession("email_address", rsContactAddress)%>"></td>
            <td>Company Name: </td>
            <td><input name="companyname" value="<%=request("companyname")%>" type="text" id="companyname" tabindex="26" size="30" maxlength="255"></td>
            <td>Production Date:</td>
            <td><input name="productiondate" value="<%=request("productiondate")%>" type="text" id="productiondate"  size="10" maxlength="10">
              <a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.productiondate','calendar_window','width=154,height=288');calendar_window.focus()"> Choose Date </a>
            </td>
          </tr>
          <tr>
            <td>Select Order Type:</td>
            <td><%Set rs = getMysqlUpdateRecordSet("Select * from ORDERTYPE", con)%>
              <select name="ordertype" id="ordertype">
                <%Do until rs.EOF%>
                <option value="<%=rs("ordertypeid")%>" <%=selected(rs("ordertypeid"), request("ordertype"))%> ><%=rs("ordertype")%></option>
                <%
				  rs.movenext
				  loop
				  rs.close 
				  set rs=nothing%>
              </select></td>
            <td>Approx. Delivery Date:</td>
            <td><select id="deldate" name="deldate" tabindex="4">
              <% for i = 1 to ubound(delDateValues) %>
              <option value="<%=delDateValues(i)%>" <%=selected(delDateValues(i), deldate)%> ><%=delDateDescriptions(i)%></option>
              <% next %>
            </select></td>
            <td>Booked Delivery Date:</td>
            <td><input name="bookeddeliverydate" value="<%=request("bookeddeliverydate")%>" type="text" id="bookeddeliverydate"  size="10" maxlength="10">
              <a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.bookeddeliverydate','calendar_window','width=154,height=288');calendar_window.focus()"> Choose Date </a></td>
          </tr>
          <tr>
            <td>Acknowledgement Date:</td>
            <td><input name="acknowdate" value="<%=request("acknowdate")%>" type="text" id="acknowdate"  size="10" maxlength="10">
              <a href="javascript:calendar_window=window.open('calendar.aspx?formname=form1.acknowdate','calendar_window','width=154,height=288');calendar_window.focus()"> Choose Date </a>
            </td>
            <td>Acknowledgement Version:</td>
            <td><select id="acknowversion" name="acknowversion">
              <option/>
              <% for i = 1 to 10 %>
              <option value="<%=i%>" <%=selected(request("acknowversion"), i)%> ><%=i%></option>
              <% next %>
            </select></td>
            <td>Order Currency: </td>
            <td>
            	<% if alternateCurrencies <> "" then
            		arrCurr = split(alternateCurrencies, ",")
            	%>
            		<select name="ordercurrency" id="ordercurrency" onchange="changeCurrency();">
                		<option value="<%=defaultOrderCurrency%>" <%=selected(defaultOrderCurrency, orderCurrency)%> ><%=defaultOrderCurrency%></option>
            			<% for each curr in arrCurr %>
	                		<option value="<%=curr%>" <%=selected(curr, orderCurrency)%> ><%=curr%></option>
            			<% next %>
            		</select>
            	<% else %>
	            	<input name="ordercurrency" value="<%=orderCurrency%>" type="text" id="ordercurrency" tabindex="27" size="30" maxlength="3" readonly />
            	<% end if %>
            </td>
          </tr>
        </table>
        <br>
        
<div id="ordernote">
	
	<table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
		<tr>
		<td>Order Notes:</td>
        <td><textarea name="ordernote_notetext" cols="50" rows="2" class="indentleft"><%=request("ordernote_notetext")%></textarea></td>
		<td><input name="ordernote_followupdate" value="<%=request("ordernote_followupdate")%>" type="text" id="ordernote_followupdate"  size="10" maxlength="10">
			<a href="javascript:calendar_window=window.open('calendar_ext.aspx?formname=form1.ordernote_followupdate','calendar_window','width=154,height=288');calendar_window.focus();"> Choose Date </a>
		</td>
		<td><select name="ordernote_action" id="ordernote_action">
                <option value="<%=ACTION_REQUIRED%>" <%=selected(ACTION_REQUIRED, request("ordernote_action"))%> ><%=ACTION_REQUIRED%></option>
                <option value="<%=NO_FURTHER_ACTION%>" <%=selected(NO_FURTHER_ACTION, request("ordernote_action"))%> ><%=NO_FURTHER_ACTION%></option>
 		</select></td>
        </tr>
    </table>
</div>
       
         <div class="clear"></div>
        <p class="purplebox"><span class="radiobxmargin">Mattress Required</span>&nbsp;Yes
          <label>
        <input type="radio" name="mattressrequired" id="mattressrequired" value="y" <%=ischeckedY(request("mattressrequired"))%> onClick="javascript:mattressChanged()" >
      </label>
No
<input name="mattressrequired" type="radio" id="mattressrequired" value="n" <%=ischeckedN(request("mattressrequired"))%> onClick="javascript:mattressChanged()" ></p>
<div id="mattress_div">
  <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
    <tr>
    <td width="11%">Savoir Model:</td>
    <td width="22%">
    <%Set rs = getMysqlUpdateRecordSet("Select * from Bedmodel where retired='n' order by priority asc", con)%>
    <select name="savoirmodel" id="savoirmodel" tabindex="30" onChange="defaultBaseModel(); defaultVentPosition();">
      <option value="n" <%=selected("n", request("savoirmodel"))%> >--</option>
      <%do until rs.eof%>
      <option value="<%=rs("bedmodel")%>" <%=selected(rs("bedmodel"), request("savoirmodel"))%> ><%=rs("bedmodel")%></option>
      <%rs.movenext
	  loop
	  rs.close
	  set rs=nothing%>
  
    </select></td>
    <td width="10%">Mattress Type: </td>
    <td>
     <%Set rs = getMysqlUpdateRecordSet("Select * from Bedmodel where retired='n' order by priority asc", con)%>
    <select name="mattresstype" id="mattresstype" tabindex="31" onChange="javascript:defaultBaseTypeFromMattressType()" >
    </select></td>
    <td width="8%">Ticking Options</td>
    <td width="24%"> <select name="tickingoptions" id="tickingoptions" tabindex="32" onChange="javascript:defaultTopperTickingOptions()" >
      <option value="n" <%=selected("n", request("tickingoptions"))%> >--</option>
      <option value="TBC" <%=selected("TBC", request("tickingoptions"))%> >TBC</option>
      <option value="White Trellis" <%=selected("White Trellis", request("tickingoptions"))%> >White Trellis</option>
      <option value="Grey Trellis" <%=selected("Grey Trellis", request("tickingoptions"))%> >Grey Trellis</option>
      <option value="Silver Trellis" <%=selected("Silver Trellis", request("tickingoptions"))%> >Silver Trellis</option>
      <option value="Oatmeal Trellis" <%=selected("Oatmeal Trellis", request("tickingoptions"))%> >Oatmeal Trellis</option>
    </select>
 </td>
  </tr>
  <tr>
    <td>Mattress Width:</td>
    <td><select name="mattresswidth" id="mattresswidth" tabindex="33" onChange="javascript:defaultBaseWidth(); javascript:setMattressTypes($('#mattresstype option:selected').val());" >
      <option value="n" <%=selected("n", request("mattresswidth"))%> >--</option>
      <option value="TBC" <%=selected("TBC", request("mattresswidth"))%> >TBC</option>
      <option value="90cm" <%=selected("90cm", request("mattresswidth"))%> >90cm</option>
      <option value="100cm" <%=selected("100cm", request("mattresswidth"))%> >100cm</option>
      <option value="105cm" <%=selected("105cm", request("mattresswidth"))%> >105cm</option>
      <option value="120cm" <%=selected("120cm", request("mattresswidth"))%> >120cm</option>
      <option value="140cm" <%=selected("140cm", request("mattresswidth"))%> >140cm</option>
       <option value="150cm" <%=selected("150cm", request("mattresswidth"))%> >150cm</option>
     <option value="160cm" <%=selected("160cm", request("mattresswidth"))%> >160cm</option>
     <option value="170cm" <%=selected("170cm", request("mattresswidth"))%> >170cm</option>
      <option value="180cm" <%=selected("180cm", request("mattresswidth"))%> >180cm</option>
      <option value="200cm" <%=selected("200cm", request("mattresswidth"))%> >200cm</option>
      <option value="210cm" <%=selected("210cm", request("mattresswidth"))%> >210cm</option>
      <option value="240cm" <%=selected("240cm", request("mattresswidth"))%> >240cm</option>
      <option value="Special (as instructions)" <%=selected("Special (as instructions)", request("mattresswidth"))%> >Special (as instructions)</option>
      <option value="60in" <%=selected("60in", request("mattresswidth"))%> >60in</option>
      <option value="76in" <%=selected("76in", request("mattresswidth"))%> >76in</option>
    </select>

</td>
    <td width="10%">Mattress Length: </td>
    <td width="25%"><select name="mattresslength" id="mattresslength" tabindex="34" onChange="javascript:defaultBaseLength()" >
      <option value="n" <%=selected("n", request("mattresslength"))%> >--</option>
      <option value="TBC" <%=selected("TBC", request("mattresslength"))%> >TBC</option>
       <option value="190cm" <%=selected("190cm", request("mattresslength"))%> >190cm</option>
      <option value="200cm" <%=selected("200cm", request("mattresslength"))%> >200cm</option>
      <option value="210cm" <%=selected("210cm", request("mattresslength"))%> >210cm</option>
      <option value="220cm" <%=selected("220cm", request("mattresslength"))%> >220cm</option>
      <option value="Special (as instructions)" <%=selected("Special (as instructions)", request("mattresslength"))%> >Special (as instructions)</option>
      <option value="80in" <%=selected("80in", request("mattresslength"))%> >80in</option>
    </select></td>
    <td colspan="2">&nbsp; </td>
    </tr>
</table>
        <p>Support (as viewed from the foot looking toward the head end):</p>
        <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
          <tr>
            <td width="11%">Left Support:</td>
            <td width="14%"><select name="leftsupport" id="leftsupport" tabindex="40">
              <option value="n" <%=selected("n", request("leftsupport"))%> >--</option>
              <option value="TBC" <%=selected("TBC", request("leftsupport"))%> >TBC</option>
              <option value="Extra Soft" <%=selected("Extra Soft", request("leftsupport"))%> >Extra Soft</option>
              <option value="Soft" <%=selected("Soft", request("leftsupport"))%> >Soft</option>
              <option value="Medium" <%=selected("Medium", request("leftsupport"))%> >Medium</option>
              <option value="Firm" <%=selected("Firm", request("leftsupport"))%> >Firm</option>
              <option value="Extra Firm" <%=selected("Extra Firm", request("leftsupport"))%> >Extra Firm</option>
            </select>
    
</td>
            <td width="11%">Right Support: </td>
            <td width="13%"><select name="rightsupport" id="rightsupport" tabindex="41">
              <option value="n" <%=selected("n", request("rightsupport"))%> >--</option>
              <option value="TBC" <%=selected("TBC", request("rightsupport"))%> >TBC</option>
              <option value="Extra Soft" <%=selected("Extra Soft", request("rightsupport"))%> >Extra Soft</option>
              <option value="Soft" <%=selected("Soft", request("rightsupport"))%> >Soft</option>
              <option value="Medium" <%=selected("Medium", request("rightsupport"))%> >Medium</option>
              <option value="Firm" <%=selected("Firm", request("rightsupport"))%> >Firm</option>
              <option value="Extra Firm" <%=selected("Extra Firm", request("rightsupport"))%> >Extra Firm</option>
            </select></td>
            <td width="11%">Vent Position:</td>
            <td width="16%"><select name="ventposition" id="ventposition" tabindex="42">
              <option value="n" <%=selected("n", request("ventposition"))%> >--</option>
              <option value="Vents on Ends" <%=selected("Vents on Ends", request("ventposition"))%> >Vents on Ends</option>
              <option value="Vents on Sides" <%=selected("Vents on Sides", request("ventposition"))%> >Vents on Sides</option>
            </select></td>
            <td width="10%">Vent Finish:</td>
            <td width="14%"><select name="ventfinish" id="ventfinish" tabindex="43" onChange="javascript:defaultLinkFinish()" >
              <!--<option value="n" <%'=selected("n", request("ventfinish"))%> >--</option> not wanted-->
              <option value="Brass Vents" <%=selected("Brass Vents", request("ventfinish"))%> >Brass Vents</option>
              <option value="Chrome Vents" <%=selected("Chrome Vents", request("ventfinish"))%> >Chrome Vents</option
            ></select></td>
          </tr>
        </table>
         
        <p>Mattress Special Instructions:</p>
    <div id="tick1"> <img src="img/white-trellis.jpg" alt="White Trellis" width="149" height="96" hspace="30" align="right"></div>
          <div id="tick2"> <img src="img/grey-trellis.jpg" alt="Grey Trellis" width="149" height="96" hspace="30" align="right"></div>
           <div id="tick3"> <img src="img/silver-trellis.jpg" alt="Silver Trellis" width="149" height="96" hspace="30" align="right"></div>
           <div id="tick4"> <img src="img/oatmeal-trellis.jpg" alt="oatmeal Trellis" width="149" height="96" hspace="30" align="right"></div>
           <textarea name="mattressinstructions" cols="65" rows="2" class="indentleft" tabindex="44"><%=request("mattressinstructions")%></textarea>
    <div class="clear">&nbsp; </div><span class="floatprice"> Mattress  <span class="cursym"><%=getCurrencySymbolForCurrency(orderCurrency)%></span>
           <label>
             <input name="mattressprice" value="<%=request("mattressprice")%>" type="text" id="mattressprice" size="15">
           </label></span>
           <div class="clear"></div>
  </div>
  <p class="purplebox"><span class="radiobxmargin">Topper Required</span>&nbsp;Yes
      <label>
        <input type="radio" name="topperrequired" id="topperrequired" value="y" <%=ischeckedY(request("topperrequired"))%> onClick="javascript:topperChanged()">
      </label>
No
<input name="topperrequired" type="radio" id="topperrequired" value="n" <%=ischeckedN(request("topperrequired"))%> onClick="javascript:topperChanged()"></p>
<div id="topper_div">
  <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
        <tr>
              <td width="11%">Topper Type:</td>
              <td width="22%"><select name="toppertype" id="toppertype" tabindex="45">
                <option value="n" <%=selected("n", request("toppertype"))%> >--</option>
                <option value="TBC" <%=selected("TBC", request("toppertype"))%> >TBC</option>
                <option value="HCa Topper" <%=selected("HCa Topper", request("toppertype"))%> >HCa Topper</option>
                <option value="HW Topper" <%=selected("HW Topper", request("toppertype"))%> >HW Topper</option>
                <option value="CW Topper" <%=selected("CW Topper", request("toppertype"))%> >CW Topper</option>
         </select></td>
              <td>Topper Width: </td>
              <td><select name="topperwidth" id="topperwidth" tabindex="46">
                <option value="n" <%=selected("n", request("topperwidth"))%> >--</option>
                <option value="TBC" <%=selected("TBC", request("topperwidth"))%> >TBC</option>
                <option value="90cm" <%=selected("90cm", request("topperwidth"))%> >90cm</option>
                <option value="100cm" <%=selected("100cm", request("topperwidth"))%> >100cm</option>
                <option value="105cm" <%=selected("105cm", request("topperwidth"))%> >105cm</option>
                <option value="120cm" <%=selected("120cm", request("topperwidth"))%> >120cm</option>
                <option value="140cm" <%=selected("140cm", request("topperwidth"))%> >140cm</option>
                <option value="150cm" <%=selected("150cm", request("topperwidth"))%> >150cm</option>
                <option value="160cm" <%=selected("160cm", request("topperwidth"))%> >160cm</option>
                <option value="170cm" <%=selected("170cm", request("topperwidth"))%> >170cm</option>
                <option value="180cm" <%=selected("180cm", request("topperwidth"))%> >180cm</option>
                <option value="200cm" <%=selected("200cm", request("topperwidth"))%> >200cm</option>
                <option value="210cm" <%=selected("210cm", request("topperwidth"))%> >210cm</option>
                <option value="240cm" <%=selected("240cm", request("topperwidth"))%> >240cm</option>
         <option value="Special (as instructions)" <%=selected("Special (as instructions)", request("topperwidth"))%> >Special (as instructions)</option>
              </select></td>
              <td width="8%">Topper Length:</td>
              <td width="24%"><select name="topperlength" id="topperlength" tabindex="47" >
                <option value="n" <%=selected("n", request("topperlength"))%> >--</option>
                <option value="TBC" <%=selected("TBC", request("topperlength"))%> >TBC</option>
                <option value="190cm" <%=selected("190cm", request("topperlength"))%> >190cm</option>
                <option value="200cm" <%=selected("200cm", request("topperlength"))%> >200cm</option>
                <option value="210cm" <%=selected("210cm", request("topperlength"))%> >210cm</option>
                <option value="220cm" <%=selected("220cm", request("topperlength"))%> >220cm</option>
                <option value="Special (as instructions)" <%=selected("Special (as instructions)", request("topperlength"))%> >Special (as instructions)</option>
              </select></td>
         </tr>
            <tr>
              <td>Ticking Options:</td>
              <td><select name="toppertickingoptions" id="toppertickingoptions" tabindex="48">
                <option value="n" <%=selected("n", request("toppertickingoptions"))%> >--</option>
                <option value="TBC" <%=selected("TBC", request("toppertickingoptions"))%> >TBC</option>
                <option value="White Trellis" <%=selected("White Trellis", request("toppertickingoptions"))%> >White Trellis</option>
                <option value="Grey Trellis" <%=selected("Grey Trellis", request("toppertickingoptions"))%> >Grey Trellis</option>
                <option value="Silver Trellis" <%=selected("Silver Trellis", request("toppertickingoptions"))%> >Silver Trellis</option>
                <option value="Oatmeal Trellis" <%=selected("Oatmeal Trellis", request("toppertickingoptions"))%> >Oatmeal Trellis</option>
         </select></td>
              <td width="10%">&nbsp;</td>
              <td width="25%">&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table>          
        <div id="tick1t"> <img src="img/white-trellis.jpg" alt="White Trellis" width="149" height="96" hspace="30" align="right"></div>
        <div id="tick2t"> <img src="img/grey-trellis.jpg" alt="Grey Trellis" width="149" height="96" hspace="30" align="right"></div>
        <div id="tick3t"> <img src="img/silver-trellis.jpg" alt="Silver Trellis" width="149" height="96" hspace="30" align="right"></div>
        <div id="tick4t"> <img src="img/oatmeal-trellis.jpg" alt="oatmeal Trellis" width="149" height="96" hspace="30" align="right"></div>
           <div class="clear"></div>
<p>Topper Special Instructions:</p>
<textarea name="specialinstructionstopper" cols="65" class="indentleft" id="specialinstructionstopper" tabindex="49"><%=request("specialinstructionstopper")%></textarea>
<span class="floatprice"> Topper <span class="cursym"><%=getCurrencySymbolForCurrency(orderCurrency)%></span>
    <label>
             <input name="topperprice" value="<%=request("topperprice")%>" type="text" id="topperprice" size="15">
</label></span>
          <div class="clear"></div>
</div>
        <p class="purplebox"><span class="radiobxmargin">Base Required</span>&nbsp;Yes
      <label>
        <input type="radio" name="baserequired" id="baserequired" value="y" <%=ischeckedY(request("baserequired"))%> onClick="javascript:baseChanged()">
      </label>
No
<input name="baserequired" type="radio" id="baserequired" value="n" <%=ischeckedN(request("baserequired"))%> onClick="javascript:baseChanged()"></p>     
<div id="base_div">
  <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
          <tr>
              <td>Savoir Model:</td>
              <td><select name="basesavoirmodel" id="basesavoirmodel" tabindex="50">
                <option value="n" <%=selected("n", request("basesavoirmodel"))%> >--</option>
                <option value="No. 1" <%=selected("No. 1", request("basesavoirmodel"))%> >No. 1</option>
                <option value="No. 2" <%=selected("No. 2", request("basesavoirmodel"))%> >No. 2</option>
                <option value="No. 3" <%=selected("No. 3", request("basesavoirmodel"))%> >No. 3</option>
                <option value="No. 4" <%=selected("No. 4", request("basesavoirmodel"))%> >No. 4</option>
              </select></td>
              <td>Base Type:</td>
              <td><select name="basetype" id="basetype" tabindex="51">
                <option value="n" <%=selected("n", request("basetype"))%> >--</option>
                <option value="TBC" <%=selected("TBC", request("basetype"))%> >TBC</option>
                <option value="One Piece" <%=selected("One Piece", request("basetype"))%> >One Piece</option>
                <option value="North-South Split" <%=selected("North-South Split", request("basetype"))%> >North-South Split</option>
                <option value="East-West Split" <%=selected("East-West Split", request("basetype"))%> >East-West Split</option>
                <option value="One-Piece" <%=selected("One-Piece", request("basetype"))%> >One-Piece</option>

          </select></td>
              <td>Base Width: </td>
              <td><select name="basewidth" id="basewidth" tabindex="52" onChange="javascript:defaultBaseTypeFromBaseWidth()">
                <option value="n" <%=selected("n", request("basewidth"))%> >--</option>
                <option value="TBC" <%=selected("TBC", request("basewidth"))%> >TBC</option>
                <option value="90cm" <%=selected("90cm", request("basewidth"))%> >90cm</option>
                <option value="100cm" <%=selected("100cm", request("basewidth"))%> >100cm</option>
                <option value="105cm" <%=selected("105cm", request("basewidth"))%> >105cm</option>
                <option value="120cm" <%=selected("120cm", request("basewidth"))%> >120cm</option>
                <option value="140cm" <%=selected("140cm", request("basewidth"))%> >140cm</option>
                 <option value="150cm" <%=selected("150cm", request("basewidth"))%> >150cm</option>
               <option value="160cm" <%=selected("160cm", request("basewidth"))%> >160cm</option>
                 <option value="170cm" <%=selected("170cm", request("basewidth"))%> >170cm</option>
               <option value="180cm" <%=selected("180cm", request("basewidth"))%> >180cm</option>
                <option value="200cm" <%=selected("200cm", request("basewidth"))%> >200cm</option>
                <option value="210cm" <%=selected("210cm", request("basewidth"))%> >210cm</option>
                <option value="240cm" <%=selected("240cm", request("basewidth"))%> >240cm</option>
                <option value="Special (as instructions)" <%=selected("Special (as instructions)", request("basewidth"))%> >Special (as instructions)</option>
              </select></td>
          </tr>
            <tr>
              <td>Base Length:</td>
              <td><select name="baselength" id="baselength" tabindex="53" >
                <option value="n" <%=selected("n", request("baselength"))%> >--</option>
                <option value="TBC" <%=selected("TBC", request("baselength"))%> >TBC</option>
                <option value="190cm" <%=selected("190cm", request("baselength"))%> >190cm</option>
                <option value="200cm" <%=selected("200cm", request("baselength"))%> >200cm</option>
                <option value="210cm" <%=selected("210cm", request("baselength"))%> >210cm</option>
                <option value="220cm" <%=selected("220cm", request("baselength"))%> >220cm</option>
                <option value="Special (as instructions)" <%=selected("Special (as instructions)", request("baselength"))%> >Special (as instructions)</option>
              </select></td>
              <td>Leg Style:</td>
              <td>
              	<select name="legstyle" id="legstyle" tabindex="54" onChange="javascript:setLegFinishes(); javascript:showLegStylePriceField()"; >
              		<%=makeOptionString("legstyle", request("legstyle"), true, con)%>
                </select>
              </td>
              <td>Leg Finish: </td>
              <td><select name="legfinish" id="legfinish" tabindex="55">
              </select></td>
            </tr>
            <tr>
              <td>Leg Height:</td>
              <td><select name="legheight" id="legheight" tabindex="56">
              </select></td>
              <td>Link Position:</td>
              <td><select name="linkposition" id="linkposition" tabindex="60"></select></td>
              <td>Link Finish</td>
              <td><select name="linkfinish" id="linkfinish" tabindex="61">
                <option value="n" <%=selected("n", request("linkfinish"))%> >--</option>
                <option value="Brass Vents and Link Bar" <%=selected("Brass Vents and Link Bar", request("linkfinish"))%> >Brass Vents & Link Bar</option>
                <option value="Chrome Vents and Link Bar" <%=selected("Chrome Vents and Link Bar", request("linkfinish"))%> >Chrome Vents & Link Bar</option>
              </select></td>
            </tr>
            <tr>
              <td>Extended Base:</td>
              <td><select name="extbase" id="extbase" tabindex="56">
               <option value="no" <%=selected("no", request("extbase"))%> >No</option>
                <option value="yes" <%=selected("yes", request("linkfinish"))%> >Yes (6" on Length 12" on width)</option>
               
              </select></td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
         
        </table>
<p>Base Special Instructions:</p>
<textarea name="baseinstructions" cols="65" class="indentleft" id="baseinstructions" tabindex="62"><%=request("baseinstructions")%></textarea>  
        <span id="legpricespan" class="floatprice"> Leg Price  <span class="cursym"><%=getCurrencySymbolForCurrency(orderCurrency)%></span>
        <label>
          <input name="legprice" value="<%=request("legprice")%>" type="text" id="legprice" size="15">
        </label></span>
        <span class="floatprice"> Base  <span class="cursym"><%=getCurrencySymbolForCurrency(orderCurrency)%></span>
        <label>
          <input name="baseprice" value="<%=request("baseprice")%>" type="text" id="baseprice" size="15">
        </label></span>
            <div class="clear"></div>
            &nbsp;

          
<p>Upholstery Fabric Options</p>
<table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
            <tr>
              <td width="12%">Upholstered Base:</td>
              <td width="11%"><select name="upholsteredbase" id="upholsteredbase" tabindex="70" onChange="javascript:setLinkPosition(null)" >
                <option value="--" <%=selected("--", request("upholsteredbase"))%> >--</option>
                <option value="TBC" <%=selected("TBC", request("upholsteredbase"))%> >TBC</option>
                <option value="Yes" <%=selected("Yes", request("upholsteredbase"))%> >Yes</option>
                <option value="No" <%=selected("No", request("upholsteredbase"))%> >No</option>
      </select></td>
              <td width="11%">Fabric Options: </td>
              <td width="21%"><select name="basefabric" id="basefabric" tabindex="71" onChange="javascript:populateFabricDropdown(this)">
                <option value="None" <%=selected("None", request("basefabric"))%> >None</option>
                <option value="TBC" <%=selected("TBC", request("basefabric"))%> >TBC</option>
                <option value="ClientsFabric" <%=selected("ClientsFabric", request("basefabric"))%> >Client's Own Fabric</option>
                <option value="Novasuede" <%=selected("Novasuede", request("basefabric"))%> >Novasuede</option>
                <option value="Romo" <%=selected("Romo", request("basefabric"))%> >Romo</option>
                <option value="AndrewMartin" <%=selected("AndrewMartin", request("basefabric"))%> >Andrew Martin</option>
                <option value="Muirhead" <%=selected("Muirhead", request("basefabric"))%> >Muirhead</option>
                <option value="As Fabric Special Instructions" <%=selected("As Fabric Special Instructions", request("basefabric"))%> >As Fabric Special Instructions</option>
     </select></td>
              <td width="12%">Fabric Selection:</td>
              <td width="33%"><span id="basefabric_div"></span>
       
            </td>
            </tr>
            <tr>
              <td>Base Fabric Cost per metre</td>
              <td><input name="basefabriccost" value="<%=request("basefabriccost")%>" type="text" id="basefabriccost" size="15"></td>
              <td>Metres of Fabric</td>
              <td><input name="basefabricmeters" value="<%=request("basefabricmeters")%>" type="text" id="basefabricmeters" size="15"></td>
              <td>Base Fabric Price</td>
              <td><input name="basefabricprice" value="<%=request("basefabricprice")%>" type="text" id="basefabricprice" size="15"></td>
            </tr>
            <tr>
              <td>Base Fabric Direction</td>
              <td><select name="basefabricdirection" id="basefabricdirection">
                <option value="--" <%=selected("--", request("basefabricdirection"))%> >--</option>
                <option value="Fabric on the run" <%=selected("Fabric on the run", request("basefabricdirection"))%> >Fabric on the run</option>
                <option value="Fabric on the drop" <%=selected("Fabric on the drop", request("basefabricdirection"))%> >Fabric on the drop</option>
      </select>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table>
           <p>Base Fabric Description</p>
        <input name="basefabricdesc" type="text" class="indentleft" value="<%=request("basefabricdesc")%>" size="85" maxlength="255">
     
<span class="floatpricenotop"> Upholstery <span class="cursym"><%=getCurrencySymbolForCurrency(orderCurrency)%></span> 
       <label>
             <input name="upholsteryprice" value="<%=request("upholsteryprice")%>" type="text" id="upholsteryprice" size="15">
         </label></span>
          <br></div>  <div class="clear"></div>
          <p class="purplebox"><span class="radiobxmargin">Headboard Required</span>&nbsp;Yes
      <label>
        <input type="radio" name="headboardrequired" id="headboardrequired" value="y" <%=ischeckedY(request("headboardrequired"))%> onClick="javascript:headboardChanged()">
      </label>
No
<input name="headboardrequired" type="radio" id="headboardrequired" value="n" <%=ischeckedN(request("headboardrequired"))%> onClick="javascript:headboardChanged()"></p>
<div id="headboard_div">
  <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
        <tr>
          <td>Headboard Styles:</td>
          <td>
          	<select name="headboardstyle" id="headboardstyle" tabindex="80">
          		<%=makeOptionString("headboardstyle", request("headboardstyle"), true, con)%>
          	</select>
          </td>
              <td width="11%">Fabric Options:</td>
              <td width="21%"><select name="headboardfabric" id="headboardfabric" tabindex="74"  onChange="javascript:populateFabricDropdown(this)">
                <option value="None" <%=selected("None", request("headboardfabric"))%> >None</option>
                <option value="TBC" <%=selected("TBC", request("headboardfabric"))%> >TBC</option>
                <option value="ClientsFabric" <%=selected("ClientsFabric", request("headboardfabric"))%> >Client's Own Fabric</option>
                <option value="Novasuede" <%=selected("Novasuede", request("headboardfabric"))%> >Novasuede</option>
                <option value="Romo" <%=selected("Romo", request("headboardfabric"))%> >Romo</option>
                <option value="AndrewMartin" <%=selected("AndrewMartin", request("headboardfabric"))%> >Andrew Martin</option>
                <option value="Muirhead" <%=selected("Muirhead", request("headboardfabric"))%> >Muirhead</option>
                <option value="As Fabric Special Instructions" <%=selected("As Fabric Special Instructions", request("headboardfabric"))%> >As Fabric Special Instructions</option>
              </select></td>
              <td width="12%">Fabric Selection:</td>
              <td width="33%"><span id="headboardfabric_div"></span></td>
            </tr>
            <tr>
              <td>Headboard Height:</td>
              <td>
              	<select name="headboardheight" id="headboardheight" tabindex="81">
              		<%=makeOptionString("headboardheight", request("headboardheight"), true, con)%>
                </select>
              </td>
              <td>Headboard Finish</td>
               <%Set rs = getMysqlUpdateRecordSet("Select * from headboardfinish", con)%>
              <td><select name="headboardfinish" id="headboardfinish" tabindex="82">
                <%Do until rs.eof%>
                <option value="<%=rs("hbfinish")%>" <%=selected(rs("hbfinish"), request("headboardfinish"))%> ><%=rs("hbfinish")%></option>
               <%rs.movenext
			   loop
			   rs.close
			   set rs=nothing%>
              </select></td>
              <td>
              	<div id="manhattantrimdiv1">Manhattan Trim</div>&nbsp;
              </td>
              <td>
              	<div id="manhattantrimdiv2">
	              	<select name="manhattantrim" id="manhattantrim" tabindex="83">
	              		<%=makeOptionString("manhattantrim", request("manhattantrim"), true, con)%>
	              	</select>
              	</div>&nbsp;
              </td>
            </tr>
            <tr>
              <td>Headboard Fabric Cost per metre</td>
              <td><input name="hbfabriccost" value="<%=request("hbfabriccost")%>" type="text" id="hbfabriccost" size="15"></td>
              <td>Metres of Fabric</td>
              <td><input name="hbfabricmeters" value="<%=request("hbfabricmeters")%>" type="text" id="hbfabricmeters" size="15"></td>
              <td>Headboard Fabric Price</td>
              <td><input name="hbfabricprice" value="<%=request("hbfabricprice")%>" type="text" id="hbfabricprice" size="15"></td>
            </tr>
            <tr>
              <td>Headboard Fabric Direction</td>
              <td><select name="headboardfabricdirection" id="headboardfabricdirection">
                <option value="--" <%=selected("--", request("headboardfabricdirection"))%> >--</option>
                <option value="Fabric on the run" <%=selected("Fabric on the run", request("headboardfabricdirection"))%> >Fabric on the run</option>
                <option value="Fabric on the drop" <%=selected("Fabric on the drop", request("headboardfabricdirection"))%> >Fabric on the drop</option>
      </select>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table>
 <p>Headboard Fabric Description</p>
        <input name="headboardfabricdesc" type="text" class="indentleft" value="<%=request("headboardfabricdesc")%>" size="85" maxlength="255">
     <div class="clear"></div>
          <p>Headboard Special Instructions:</p>
      <br>
          
          <div id="tick5"> <img src="img/c1.gif" alt="C1" width="77" height="119" hspace="30" align="right"></div>
          <div id="tick6"> <img src="img/c2.gif" alt="C2" width="77" height="119" hspace="30" align="right"></div>
          <div id="tick7"> <img src="img/c4.gif" alt="C4" width="160" height="131" hspace="30" align="right"></div>
          <div id="tick8"> <img src="img/c5.gif" alt="C5" width="77" height="119" hspace="30" align="right"></div>
          <div id="tick9"> <img src="img/c6.gif" alt="C6" width="77" height="119" hspace="30" align="right"></div>
          <div id="tick10"> <img src="img/m31.gif" alt="M31" width="77" height="119" hspace="30" align="right"></div>
          <div id="tick11"> <img src="img/m32.gif" alt="M32" width="160" height="131" hspace="30" align="right"></div>
          <div id="tick12"> <img src="img/holly.gif" alt="Holly" width="77" height="119" hspace="30" align="right"></div>
           <div id="tick13"> <img src="img/f100.gif" alt="F100" width="77" height="119" hspace="30" align="right"></div>
           <div id="tick14"> <img src="img/MF31.gif" alt="M31" width="115" height="119" hspace="30" align="right"></div>
           <div id="tick15"> <img src="img/MF32.gif" alt="M32" width="112" height="119" hspace="30" align="right"></div>
           <div id="tick16"> <img src="img/Animal.gif" alt="Animal" width="91" height="119" hspace="30" align="right"></div>
          <textarea name="specialinstructionsheadboard" cols="65" class="indentleft" id="specialinstructionsheadboard" tabindex="86"><%=request("specialinstructionsheadboard")%></textarea>
 <div class="clear">&nbsp; </div>   <span class="floatprice"> Headboard <span class="cursym"><%=getCurrencySymbolForCurrency(orderCurrency)%></span> 
           <label>
             <input name="headboardprice" value="<%=request("headboardprice")%>" type="text" id="headboardprice" size="15">
</label></span>
          <div class="clear"></div>
</div>

          <p class="purplebox"><span class="radiobxmargin">Valance Required</span>&nbsp;Yes
      <label>
        <input type="radio" name="valancerequired" id="valancerequired" value="y" <%=ischeckedY(request("valancerequired"))%> onClick="javascript:valanceChanged()">
      </label>
No
<input name="valancerequired" type="radio" id="valancerequired" value="n" <%=ischeckedN(request("valancerequired"))%> onClick="javascript:valanceChanged()"></p> 
<div id="valance_div">
  <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
        <tr>
              <td width="11%">No. of Pleats:</td>
              <td width="12%"><select name="pleats" id="pleats" tabindex="90">
                <option value="--" <%=selected("--", request("pleats"))%> >--</option>
                <option value="TBC" <%=selected("TBC", request("pleats"))%> >TBC</option>
                <option value="2" <%=selected("2", request("pleats"))%> >2</option>
                <option value="4" <%=selected("4", request("pleats"))%> >4</option>
                <option value="5" <%=selected("5", request("pleats"))%> >5</option>
              </select></td>
              <td width="11%">Fabric Options: </td>
              <td width="21%"><select name="valancefabric" id="valancefabric" tabindex="91" onChange="javascript:populateFabricDropdown(this)">
                <option value="None" <%=selected("None", request("valancefabric"))%> >None</option>
                <option value="TBC" <%=selected("TBC", request("valancefabric"))%> >TBC</option>
                <option value="ClientsFabric" <%=selected("ClientsFabric", request("valancefabric"))%> >Client's Own Fabric</option>
                <option value="Novasuede" <%=selected("Novasuede", request("valancefabric"))%> >Novasuede</option>
                <option value="Romo" <%=selected("Romo", request("valancefabric"))%> >Romo</option>
                <option value="AndrewMartin" <%=selected("AndrewMartin", request("valancefabric"))%> >Andrew Martin</option>
                <option value="Muirhead" <%=selected("Muirhead", request("valancefabric"))%> >Muirhead</option>
                <option value="As Fabric Special Instructions" <%=selected("As Fabric Special Instructions", request("valancefabric"))%> >As Fabric Special Instructions</option>
              </select></td>
              <td width="12%">Fabric Selection:</td>
              <td width="33%"><span id="valancefabric_div"></span></td>
            </tr>
            <tr>
              <td>Valance Fabric Cost per metre</td>
              <td><input name="valfabriccost" value="<%=request("valfabriccost")%>" type="text" id="valfabriccost" size="15"></td>
              <td>Metres of Fabric</td>
              <td><input name="valfabricmeters" value="<%=request("valfabricmeters")%>" type="text" id="valfabricmeters" size="15"></td>
              <td>Valance Fabric Price</td>
              <td><input name="valfabricprice" value="<%=request("valfabricprice")%>" type="text" id="valfabricprice" size="15"></td>
            </tr>
            <tr>
              <td>Valance Fabric Direction</td>
              <td><select name="valancefabricdirection" id="valancefabricdirection">
                <option value="--" <%=selected("--", request("headboardfabricdirection"))%> >--</option>
                <option value="Fabric on the run" <%=selected("Fabric on the run", request("valancefabricdirection"))%> >Fabric on the run</option>
                <option value="Fabric on the drop" <%=selected("Fabric on the drop", request("valancefabricdirection"))%> >Fabric on the drop</option>
      </select>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table>
          <p>Valance Fabric Description</p>
        <input name="valancefabricdesc" type="text" class="indentleft" value="<%=request("valancefabricdesc")%>" size="85" maxlength="255">
     <div class="clear"></div>
          <p>Valance Special Instructions:</p>
        <textarea name="specialinstructionsvalance" cols="65" class="indentleft" id="specialinstructionsvalance" tabindex="95"><%=request("specialinstructionsvalance")%></textarea>
<span class="floatprice"> Valance <span class="cursym"><%=getCurrencySymbolForCurrency(orderCurrency)%></span> 
           <label>
             <input name="valanceprice" value="<%=request("valanceprice")%>" type="text" id="valanceprice" size="15">
         </label></span> <div class="clear"></div>  
</div>  

<!-- accessories section -->  
<p class="purplebox"><span class="radiobxmargin">Accessories Required</span>&nbsp;Yes
      <label>
        <input type="radio" name="accessoriesrequired" id="accessoriesrequired" value="y" <%=ischeckedY(request("accessoriesrequired"))%> onClick="javascript:accessoriesChanged()">
      </label>
No
<input name="accessoriesrequired" type="radio" id="accessoriesrequired" value="n" <%=ischeckedN(request("accessoriesrequired"))%> onClick="javascript:accessoriesChanged()"></p> 
<div id="accessories_div">
<table>
<tr><th>Item&nbsp;No.</th><th>Item&nbsp;Description</th><th>Unit&nbsp;Price</th><th>Quantity</th></tr>
<% for i = 1 to 10 %>
	<tr id="acc_row<%=i%>">
		<td><%=i%></td>
		<td><input type="text" name="acc_desc<%=i%>" id="acc_desc<%=i%>" value="<%=request("acc_desc"&i)%>" size="50" /></td>
		<td><input type="text" name="acc_unitprice<%=i%>" id="acc_unitprice<%=i%>" value="<%=request("acc_unitprice"&i)%>" size="10" /></td>
		<td>
			<select name="acc_qty<%=i%>" id="acc_qty<%=i%>">
				<% for n = 1 to 50 %>
					<option value="<%=n%>" <%=selected(cstr(n), request("acc_qty"&i))%> ><%=n%></option>
				<% next %>
			</select>
		</td>
	</tr>
<% next %>
</table>
<p>Accessories total:&nbsp;<span id="accessories_total"></span></p>
</div>  

<!-- delivery charge section -->
<p class="purplebox"><span class="radiobxmargin">Delivery Charge</span>&nbsp;Yes
      <label>
        <input type="radio" name="deliverycharge" id="deliverycharge" value="y" <%=ischeckedY(request("deliverycharge"))%> onClick="javascript:deliveryChanged()">
      </label>
No
<input name="deliverycharge" type="radio" id="deliverycharge" value="n" <%=ischeckedN(request("deliverycharge"))%> onClick="javascript:deliveryChanged()"></p> 
<div id="delivery_div">
 <table width="98%" border="0" align="center" cellpadding="3" cellspacing="3">
        <tr>
        <td width="17%">Access Check Required?</td>
        <td width="38%"><select name="accesscheck" id="accesscheck" tabindex="90">
        <option value="No" <%=selected("No", request("accesscheck"))%> >No</option>
        <option value="Yes" <%=selected("Yes", request("accesscheck"))%> >Yes</option>
                
              </select>&nbsp;</td>
        <td width="14%">Disposal of old bed</td>
        <td width="31%"><select name="oldbed" id="oldbed" tabindex="91">
        <option value="--" <%=selected("--", request("oldbed"))%> >--</option>
          <option value="No" <%=selected("No", request("oldbed"))%> >No</option>
          <option value="Yes" <%=selected("Yes", request("oldbed"))%> >Yes</option>
        </select></td>
        </tr>
        </table>
        <p>Delivery Special Instructions:</p>
        <textarea name="specialinstructionsdelivery" cols="65" class="indentleft" id="specialinstructionsdelivery" tabindex="95"><%=request("specialinstructionsdelivery")%></textarea>
      <span class="floatprice"> Delivery <span class="cursym"><%=getCurrencySymbolForCurrency(orderCurrency)%></span> 
           <label>
             <input name="deliveryprice" value="<%=request("deliveryprice")%>" type="text" id="deliveryprice" size="15">
        </label>
        <br/><button type="button" onClick="JavaScript: setDefaultDeliveryCharge()">Get Standard Delivery Price</button>
        </span>
      
         </div> <div class="clear"></div>   <hr>


          <p><input type="hidden" name="quote" id="quote" value="<%=quote%>">
            <input type="hidden" name="contact_no" id="contact_no" value="<%=contact_no%>">
<%If quote="y" Then%>
<input type="submit" name="submit" value="Save Quote" id="submit" class="button" tabindex="105" />
<%Else%>
<input type="submit" name="submit" value="Add Order" id="submit" class="button" tabindex="105" />
<%End If%>
          </p>
          <p>&nbsp;</p>
          <p>&nbsp;</p>
          <p>&nbsp;</p>
    </form>
 </div> </div></div>

<%
call closemysqlrs(rsContactAddress)
call closemysqlcon(con)
%>

       
</body>
</html>

      <script Language="JavaScript" type="text/javascript">
<!--
$('#basefabriccost').blur(function() {
	calcBaseFabricPrice(null);
});

$('#basefabricmeters').blur(function() {
	calcBaseFabricPrice(null);
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
	   
$(document).ready(init());
function init() {
	tickingSelected();
	$("#tickingoptions").change(tickingSelected);
	headboardstyle();
	manhattanTrimOptions();
	$("#headboardstyle").change(headboardstyle);
	$("#headboardstyle").change(setHeadboardHeightOptions);
	$("#headboardstyle").change(setLegStyleOptions);
	$("#headboardstyle").change(manhattanTrimOptions);
	
	mattressChanged();
	topperChanged();
	baseChanged();
	headboardChanged();
	valanceChanged();
	accessoriesChanged();
	deliveryChanged();
	calcBaseFabricPrice(<%=request("basefabricprice")%>)
	calcHBFabricPrice(<%=request("hbfabricprice")%>)
	calcValFabricPrice(<%=request("valfabricprice")%>)
}

function tickingSelected() {
	hideAllTickingSwatches();
	var selection = $("#tickingoptions").val();
	if (selection == "White Trellis") {
		$('#tick1').show();
		$('#tick1t').show();
	} else if (selection == "Grey Trellis") {
		$('#tick2').show();
		$('#tick2t').show();
	} else if (selection == "Silver Trellis") {
		$('#tick3').show();
		$('#tick3t').show();
	} else if (selection == "Oatmeal Trellis") {
		$('#tick4').show();
		$('#tick4t').show();
	}
}

function headboardstyle() {
	hideAllHeadboardSwatches();
	var selection = $("#headboardstyle").val();
	if (selection == "C1") {
		$('#tick5').show();
	} else if (selection == "C2") {
		$('#tick6').show();
	} else if (selection == "C4") {
		$('#tick7').show();
	} else if (selection == "C5") {
		$('#tick8').show();
	} else if (selection == "C6") {
		$('#tick9').show();
	} else if (selection == "M31") {
		$('#tick10').show();
	} else if (selection == "M32") {
		$('#tick11').show();
	} else if (selection == "H1 Holly") {
		$('#tick12').show();
	} else if (selection == "F100") {
		$('#tick13').show();
	} else if (selection == "MF31") {
		$('#tick14').show();
	} else if (selection == "MF32") {
		$('#tick15').show();
	} else if (selection == "Animal") {
		$('#tick16').show();
	}
}

function manhattanTrimOptions() {
	var slct = $("#headboardstyle").val();
	if (slct && slct.substring(0, 9) == 'Manhattan') {
		$('#manhattantrimdiv1').show();
		$('#manhattantrimdiv2').show();
	} else {
		$("#manhattantrim option[value='--']").attr('selected', 'selected');
		$('#manhattantrimdiv1').hide();
		$('#manhattantrimdiv2').hide();
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
	$('#tick1').hide();
	$('#tick2').hide();
	$('#tick3').hide();
	$('#tick4').hide();
	$('#tick1t').hide();
	$('#tick2t').hide();
	$('#tick3t').hide();
	$('#tick4t').hide();
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
}

function mattressChanged() {
	var value = $("input[@name=mattressrequired]:checked").val();
	if (value == 'y') {
		$('#mattress_div').show("slow");
	} else {
		$('#mattress_div').hide("slow");
	}
}
   
function topperChanged() {
	var value = $("input[@name=topperrequired]:checked").val();
	if (value == 'y') {
		$('#topper_div').show("slow");
	} else {
		$('#topper_div').hide("slow");
	}
}

function baseChanged() {
	var value = $("input[@name=baserequired]:checked").val();
	if (value == 'y') {
		$('#base_div').show("slow");
	} else {
		$('#base_div').hide("slow");
	}
}

function headboardChanged() {
	var value = $("input[@name=headboardrequired]:checked").val();
	if (value == 'y') {
		$('#headboard_div').show("slow");
	} else {
		$('#headboard_div').hide("slow");
	}
}

function valanceChanged() {
	var value = $("input[@name=valancerequired]:checked").val();
	if (value == 'y') {
		$('#valance_div').show("slow");
	} else {
		$('#valance_div').hide("slow");
	}
}

function accessoriesChanged() {
	var value = $("input[@name=accessoriesrequired]:checked").val();
	if (value == 'y') {
		$('#accessories_div').show("slow");
	} else {
		$('#accessories_div').hide("slow");
	}
}

function deliveryChanged() {
	var value = $("input[@name=deliverycharge]:checked").val();
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
	var url = "ajaxGetShippingCost.asp?country=" + country + "&postcode=" + postcode + "&ts=" + (new Date()).getTime();
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
		finishOptions.push("Special (as instructions)");
        heightOptions.push("TBC");
        heightOptions.push("9.5cm/ Low");
        heightOptions.push("13.5cm/ Standard");
        heightOptions.push("17cm/ Tall");
        heightOptions.push("21cm/ Very Tall");
	} else if (slct == "Holly") {
		finishOptions.push("TBC");
		finishOptions.push("Natural Maple");
		finishOptions.push("Oak");
		finishOptions.push("Ebony");
		finishOptions.push("Rosewood");
		finishOptions.push("Special (as instructions)");
		defaultFinishSelection = "Rosewood";
        heightOptions.push("15cm");
		defaultHeightSelection = "15cm";
	} else if (slct == "Metal") {
		finishOptions.push("Polished");
        heightOptions.push("15cm");
        heightOptions.push("Special (as instructions)");
		defaultHeightSelection = "15cm";
	} else if (slct == "Manhattan") {
		finishOptions.push("TBC");
		finishOptions.push("Natural Maple");
		finishOptions.push("Oak");
		finishOptions.push("Ebony");
		finishOptions.push("Special (as instructions)");
		defaultFinishSelection = "Ebony";
        heightOptions.push("13.5cm");
        heightOptions.push("Special (as instructions)");
		defaultHeightSelection = "13.5cm";
	} else if (slct == "Ball & Claw") {
		finishOptions.push("TBC");
		finishOptions.push("Silver Gilded");
		finishOptions.push("Gold Gilded");
		finishOptions.push("Special (as instructions)");
        heightOptions.push("15cm");
        heightOptions.push("Special (as instructions)");
	} else if (slct == "Castors") {
		finishOptions.push("Brown");
        heightOptions.push("TBC");
        heightOptions.push("9.5cm/ Low");
        heightOptions.push("13.5cm/ Standard");
        heightOptions.push("17cm/ Tall");
        heightOptions.push("21cm/ Very Tall");
	} else if (slct == "Special (as instructions)") {
		finishOptions.push("Special (as instructions)");
        heightOptions.push("Special (as instructions)");
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

function showLegStylePriceField() {
	var slct = $("#legstyle option:selected").val();
	if (slct == "Holly" || slct == "Ball & Claw" || slct == "Manhattan" || slct == "Special (as instructions)") {
		$('#legpricespan').show();
	} else {
		$('#legpricespan').hide();
		$('#legprice').val(''); // remove leg price if leg price field hidden
	}
}

function calcBaseFabricPrice(baseFabricPrice) {
	if (baseFabricPrice == null || baseFabricPrice == 0.0) {
		var basefabriccost = $('#basefabriccost').val()*1.0
		var basefabricmeters = $('#basefabricmeters').val()*1.0
		baseFabricPrice = basefabriccost * basefabricmeters;
	}
	$('#basefabricprice').val((baseFabricPrice).toFixed(2));
}

function calcHBFabricPrice(hbFabricPrice) {
	if (hbFabricPrice == null || hbFabricPrice == 0.0) {
		var hbfabriccost = $('#hbfabriccost').val()*1.0
		var hbfabricmeters = $('#hbfabricmeters').val()*1.0
		hbFabricPrice = hbfabriccost * hbfabricmeters;
	}
	$('#hbfabricprice').val((hbFabricPrice).toFixed(2));
}

function calcValFabricPrice(valFabricPrice) {
	if (valFabricPrice == null || valFabricPrice == 0.0) {
		var valfabriccost = $('#valfabriccost').val()*1.0
		var valfabricmeters = $('#valfabricmeters').val()*1.0
		valFabricPrice = valfabriccost * valfabricmeters;
	}
	$('#valfabricprice').val((valFabricPrice).toFixed(2));
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
if (!IsNumeric(theForm.baseprice.value)) 
   { 
      alert('Please enter only numbers for base price'); 
      theForm.baseprice.focus();
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
      
  
if (theForm.ordernote_followupdate.value != "" && theForm.ordernote_notetext.value == "") {
	alert('Please enter a note');
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
<script Language="JavaScript" type="text/javascript">
<!--
	window.onload = init2();
	function init2() {
		populateFabricDropdown(document.form1.basefabric);
		populateFabricDropdown(document.form1.headboardfabric);
		populateFabricDropdown(document.form1.valancefabric);
		setMattressTypes("<%=request("mattresstype")%>");
		setLinkPosition("<%=request("linkposition")%>");
		showLegStylePriceField();
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
	}
	
	function defaultVentPosition() {
		var slct = $("#savoirmodel option:selected").val();
		var ventPositionDefault = null;
		if (slct == "No. 1" || slct == "No. 2") {
			ventPositionDefault = "Vents on Ends";
		} else if (slct == "No. 3" || slct == "No. 4") {
			ventPositionDefault = "Vents on Sides";
		}
		if (ventPositionDefault != null) {
			$("#ventposition option[value='" + ventPositionDefault + "']").attr('selected', 'selected');
		}
	}
	
	function defaultBaseTypeFromMattressType() {
		var slct = $("#mattresstype option:selected").val();
		if (slct && slct.substring(0, 11) == 'Zipped Pair') {
			slct = "North-South Split";
		}
		$("#basetype option[value='" + slct + "']").attr('selected', 'selected');
	}

	function defaultBaseTypeFromBaseWidth() {
		var slct = $("#basewidth option:selected").val();
		var baseTypeDefault = null;
		if (slct == "90cm" || slct == "100cm" || slct == "105cm" || slct == "120cm") {
			baseTypeDefault = "One Piece";
		} else if (slct == "140cm" || slct == "160cm") {
			baseTypeDefault = "East-West Split";
		} else if (slct == "180cm" || slct == "200cm" || slct == "210cm" || slct == "240cm") {
			baseTypeDefault = "North-South Split";
		}
		if (baseTypeDefault != null) {
			$("#basetype option[value='" + baseTypeDefault + "']").attr('selected', 'selected');
		}
	}

	function defaultBaseWidth() {
		var slct = $("#mattresswidth option:selected").val();
		$("#basewidth option[value='" + slct + "']").attr('selected', 'selected');
		$("#topperwidth option[value='" + slct + "']").attr('selected', 'selected');
	}

	function defaultBaseLength() {
		var slct = $("#mattresslength option:selected").val();
		$("#topperlength option[value='" + slct + "']").attr('selected', 'selected');
		$("#baselength option[value='" + slct + "']").attr('selected', 'selected');
	}

	function defaultLinkFinish() {
		var slct = $("#ventfinish option:selected").val();
		if (slct == 'Brass Vents' || slct == 'Chrome Vents') {
			slct = slct + " and Link Bar";
		}
		$("#linkfinish option[value='" + slct + "']").attr('selected', 'selected');
	}

	function defaultTopperTickingOptions() {
		var slct = $("#tickingoptions option:selected").val();
		$("#toppertickingoptions option[value='" + slct + "']").attr('selected', 'selected');
	}
	
	function setMattressTypes(defaultSelection) {
		var slct = $("#mattresswidth option:selected").val();
		if (defaultSelection == null) defaultSelection = "";
		
		var mattressTypeOptions = [];
		if (slct == "90cm" || slct == "100cm" || slct == "105cm" || slct == "120cm" || slct == "140cm") {
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
		var slct = $("#upholsteredbase option:selected").val();
		
		var linkPositionOptions = [];
		if (slct == "Yes") {
			linkPositionOptions.push("Link Underneath");
		} else {
			linkPositionOptions.push("Link Underneath");
			linkPositionOptions.push("Link on Ends");
			if (defaultSelection == "") {
				defaultSelection = "Link on Ends";
			}
		}
		
		$('#linkposition').find('option').remove();
		$.each(linkPositionOptions, function(val, text) {
			$('#linkposition').append($('<option></option>').val(text).html(text));
		});
		if (defaultSelection != "") {
			$("#linkposition option[value='" + defaultSelection + "']").attr('selected', 'selected');
		}
	}

// accessories stuff
for (var i = 1; i < 11; i++) {
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

function calcAccessoriesTotal() {
	var total = 0.0;
	for (var i = 1; i < 11; i++) {
		total += $('#acc_unitprice'+i).val() * $('#acc_qty'+i).val() * 1.0;
	}
	$('#accessories_total').html(getCurrSym() + total.toFixed(2));
}

function showNextAccessoriesRow() {
	for (var i = 1; i < 10; i++) {
		var ii = i+1;
		if ($('#acc_desc'+i).val() == "") {
			$('#acc_row'+ii).hide();
		} else {
			$('#acc_row'+ii).show();
		}
	}
}

var theCurrencySymbol = '<%=getCurrencySymbolForCurrency(orderCurrency)%>';
function getCurrSym() {
	return theCurrencySymbol;
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

//-->
</script>
<!-- #include file="common/logger-out.inc" -->
