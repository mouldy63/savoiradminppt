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
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="vappfuncs.asp" -->
<!-- #include file="pricematrixfuncs.asp" -->
<%
Server.ScriptTimeout = 1200

Dim postcode, postcodefull, Con, rs, rs1, recordfound, id, rspostcode, submit, count, sql, msg, customerasc, orderasc, showr,  companyasc, deldate, productiondate, previousOrderNumber, acknowDateWarning, datefrom, datefrom1, dateto, dateto1, showroom, url, pno, pnotrue, revenue, staffhours, stdworkweek, adjustment, adjustedRevenue, vappadjustedrevenue, compno, compnototal, datecompcomp, location
dim showrooms, i, totalRevenue, invoicedItemCount, completedItemCount, totalInvoicedItemCount, totalCompletedItemCount, totalAdjustedRevenue, totalOrderDateVsCompletionDate
dim gbp2usd, gbp2eur, invoicedProductionThroughput, orderDateVsCompletionDate, firstInProductionDateVsCompletionDate, errors, nfrt, madeat, diff, revenue2
dim dateFromMonth, dateFromYear, dateToMonth, dateToYear, thisYear, thisMonth
dim fulltimeequiv, revenuePerFte, workdaysinperiod, throughput

location=request("location")
adjustment=request("adjustment")
staffhours=request("staffhours")
stdworkweek=request("stdworkweek")
if stdworkweek = "" then stdworkweek = 39
fulltimeequiv=request("fulltimeequiv")
if fulltimeequiv = "" then fulltimeequiv = 0
workdaysinperiod = request("workdaysinperiod")
if workdaysinperiod = "" then workdaysinperiod = 0
pno=""

thisYear = year(now())
thisMonth = year(now())
dateFromMonth=request("dateFromMonth")
dateFromYear=request("dateFromYear")
dateToMonth=request("dateToMonth")
dateToYear=request("dateToYear")

showroom=request("location")
companyasc=""
customerasc=""
orderasc=""
showr=request("showr")
productiondate=request("productiondate")
deldate=request("deldate")
companyasc=request("companyasc")
customerasc=request("customerasc")
orderasc=request("orderasc")
msg=Request("msg")
madeat=Request("madeat")

if request("gbp2usd") = "" then
	gbp2usd = 1.6
else
	gbp2usd = cdbl(request("gbp2usd"))
end if

if request("gbp2eur") = "" then
	gbp2eur = 1.2
else
	gbp2eur = cdbl(request("gbp2eur"))
end if


errors = request("errors")
count=0

submit=Request("submit")

Set Con = getMysqlConnection()
showrooms = getShowrooms(con, location)
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
	<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
	<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
	<script type="text/javascript" src="scripts/spin.min.js"></script>
	<script src="common/jquery.js" type="text/javascript"></script>
	<script src="scripts/keepalive.js"></script>
	<script src="common/utils.js" type="text/javascript"></script>
</head>

<body>
<div class="container" id="container-div" >
<!-- #include file="header.asp" -->

<div class="content brochure">
<div class="one-col head-col">

Delivery Report<br /><br />
<form action="vapp.asp" method="post" name="form1" id="form1">
<input type="hidden" name="log" id="log" />
<input type="hidden" name="workdaysinperiod" id="workdaysinperiod"  value="<%=workdaysinperiod%>" />
<table border="0" cellspacing="0" cellpadding="5">
  <tr>
    <td>Invoice date From: </td>
    <td>
    	<label for="datefrommonth" id="datefrommonth">
		    <select name="datefrommonth" id="datefrommonth" onchange="retrieveFormData();">
		    	<option value="">&nbsp;</option>
		    	<% for i = 1 to 12 %>
		    		<option value="<%=i%>" <%=selected(cstr(i), datefrommonth)%> ><%=i%></option>
		    	<% next %>
		    </select>
    	</label>
    	<label for="datefromyear" id="datefromyear">
		    <select name="datefromyear" id="datefromyear" onchange="retrieveFormData();">
		    	<option value="">&nbsp;</option>
		    	<% for i = thisYear to (thisYear-10) step -1 %>
		    		<option value="<%=i%>" <%=selected(cstr(i), datefromyear)%> ><%=i%></option>
		    	<% next %>
		    </select>
    	</label>
    </td>
    <td>To: &nbsp;</td>
    <td>
    	<label for="datetomonth" id="datetomonth">
		    <select name="datetomonth" id="datetomonth" onchange="retrieveFormData();">
		    	<option value="">&nbsp;</option>
		    	<% for i = 1 to 12 %>
		    		<option value="<%=i%>" <%=selected(cstr(i), datetomonth)%> ><%=i%></option>
		    	<% next %>
		    </select>
    	</label>
    	<label for="datetoyear" id="datetoyear">
		    <select name="datetoyear" id="datetoyear" onchange="retrieveFormData();">
		    	<option value="">&nbsp;</option>
		    	<% for i = thisYear to (thisYear-10) step -1 %>
		    		<option value="<%=i%>" <%=selected(cstr(i), datetoyear)%> ><%=i%></option>
		    	<% next %>
		    </select>
    	</label>
    </td>
    <td>Showroom:</td>
    <td><%If retrieveUserLocation()=1 or retrieveUserLocation()=23 then%>
<%set rs = getLocationRs(con)%>
      <select name="location" size="1" class="formtext" id="location">
        <option value="all">All Showrooms</option>
        <%do until rs.EOF%>
        <option value="<%=rs("idlocation")%>" <%=selected(location, rs("idlocation"))%> ><%=rs("adminheading")%></option>
        <% rs.movenext 
  loop%>
      </select>
<%call closemysqlrs(rs)%>
      <%end if%>&nbsp;</td>
    <td>Made At:</td>
    <td>
<%set rs = getMadeAtRs(con)%>
      <select name="madeat" size="1" class="formtext" id="madeat" onchange="retrieveFormData();">
        <option value="0">All</option>
        <%do until rs.EOF%>
        <option value="<%=rs("manufacturedatid")%>" <%=selected(madeat, rs("manufacturedatid"))%> ><%=rs("manufacturedat")%></option>
        <% rs.movenext 
  loop%>
</select>
<%call closemysqlrs(rs)%>
&nbsp;</td>
	<td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td>Errors in period: &nbsp;</td>
    <td><input name="errors" type="text" class="text" id="errors" size="10" value="<%=errors%>" />&nbsp;</td>
    <td>Staff Hours in Period,<br/>Excluding Bank hols, Holidays,<br/>Sick hours:&nbsp;</td>
    <td><input name="staffhours" type="text" class="text" id="staffhours" value="<%=staffhours%>" size="10" onchange="calcFullTimeEquiv();" />&nbsp;</td>
    <td>Standard working<br/>week hours:&nbsp;</td>
    <td><input name="stdworkweek" type="text" class="text" id="stdworkweek" value="<%=stdworkweek%>" size="10" onchange="calcWorkHoursInPeriod(true);"/>&nbsp;</td>
    <td>Available Work<br/>Hours in Period:&nbsp;</td>
    <td><input name="workhoursinperiod" type="text" class="text" id="workhoursinperiod" value="0" size="10" readonly onchange="calcFullTimeEquiv();" />&nbsp;</td>
    <td>Full Time Equivalent:&nbsp;</td>
    <td><input name="fulltimeequiv" type="text" class="text" id="fulltimeequiv" value="<%=fulltimeequiv%>" size="10" readonly />&nbsp;</td>
  </tr>
  <tr>
    <td>GBP to USD conversion rate:</td>
    <td><input name="gbp2usd" type="text" class="text" id="gbp2usd" size="10" value="<%=gbp2usd%>" />&nbsp;</td>
    <td>GBP to EUR conversion rate:</td>
    <td><input name="gbp2eur" type="text" class="text" id="gbp2eur" size="10" value="<%=gbp2eur%>" />&nbsp;</td>
	<td colspan="6">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="submit" id="submit" value="Submit" onclick="return setAction('page')" ></td>
    <td><input type="submit" name="submit" id="submitcsv" value="Download CSV" onclick="return setAction('csv')" ></td>
    <td><input type="submit" name="submit" id="submitlog" value="Download Log" onclick="return setAction('log')" ></td>
    <td><input type="submit" name="submit" id="submitsave" value="Save" onclick="saveFormData(); return false;" ></td>
	<td colspan="5">&nbsp;</td>
  </tr>
</table>
</form>

<% if submit <> "" then %>

	<%
	if dateFromYear <> "" and dateFromMonth <> "" then
		datefrom = dateSerial(dateFromYear, dateFromMonth, 1)
		datefrom1=year(datefrom) & "/" & month(datefrom) & "/" & day(datefrom)
	else
		datefrom1 = ""
	end if
	if dateToYear <> "" and dateToMonth <> "" then
		dateto = dateSerial(dateToYear, dateToMonth+1, 0)
		dateto1=year(dateto) & "/" & month(dateto) & "/" & day(dateto)
	else
		dateto1 = ""
	end if
	%>
	<p>&nbsp;</p>
	<table width="100%" border="0" cellspacing="0" cellpadding="5">
	        <tr>
	          <td width="15%">Showroom</td>
	          <td width="15%" valign="bottom">Ex Works Revenue<br/>@ 2014 Prices UK Wholesale<br/>(ex VAT)<br/>(ex Fabric, ex Accessories) (A)</td>
	          <!--<td width="20%" valign="bottom">Adjustment (decimal)<br>
	            User to add per location (B)</td>-->
	          <!--<td width="14%" valign="bottom">Adjusted revenue<br>
	          (C)= A * B</td>-->
	          <!--<td width="11%" valign="bottom">No. of items<br>
	            Invoiced<br>
	            (Per location)<br>
	          (D)</td>-->
	          <td width="15%" valign="bottom">No. of items<br>
	            Completed<br>
	          (E)</td>
	          <td width="15%" valign="bottom">In Production dates<br>
	            compared to Finished<br>
	            dates for items<br>
	          (Median) (F)</td>
	          <td width="15%" valign="bottom">Order Date<br>
	            Vs Order Completed Date<br>
	          (Median) (G)</td>
          <td valign="bottom">First In Production<br>Date vs Order Completed<br>Date(median) (H)</td>
          <td valign="bottom">Throughput - First<br>item started vs. last<br>item finished (Median) (J)</td>
	        </tr>
	<%
	totalRevenue = 0.0
	totalInvoicedItemCount = 0
	totalCompletedItemCount = 0
	totalAdjustedRevenue = 0.0
	totalOrderDateVsCompletionDate = 0.0
	
	for i = 1 to ubound(showrooms)
		revenue = getExWorksRevenueForLocation(con, showrooms(i), datefrom1, dateto1, gbp2usd, gbp2eur, madeAt, null)
		totalRevenue = totalRevenue + revenue
		adjustment = request("adjustment" & showrooms(i))
		if adjustment = "" then
			if showrooms(i) = 4 then
				adjustment = 0.44	' harrods
			elseif showrooms(i) = 3 then
				adjustment = 0.44	' wigmore st
			elseif showrooms(i) = 5 then
				adjustment = 0.5	' wigmore st
			else
				adjustment = 1.0
			end if
		end if
		adjustedRevenue = adjustment * revenue
		totalAdjustedRevenue = totalAdjustedRevenue + adjustedRevenue
		invoicedItemCount = getInvoicedItemCount(con, showrooms(i), datefrom1, dateto1, madeAt, null)
		totalInvoicedItemCount = totalInvoicedItemCount + invoicedItemCount
		completedItemCount = getCompletedItemCount(con, showrooms(i), datefrom1, dateto1, madeAt, null)
		totalCompletedItemCount = totalCompletedItemCount + completedItemCount
		invoicedProductionThroughput = getInvoicedProductionThroughput(con, showrooms(i), datefrom1, dateto1, madeAt, null)
		orderDateVsCompletionDate = getOrderDateVsCompletionDate2(con, showrooms(i), datefrom1, dateto1, madeAt, null)
		totalOrderDateVsCompletionDate = totalOrderDateVsCompletionDate + orderDateVsCompletionDate
		firstInProductionDateVsCompletionDate = getFirstInProductionDateVsCompletionDate(con, showrooms(i), datefrom1, dateto1, madeAt, null)
		throughput = getThroughput(con, showrooms(i), datefrom1, dateto1, madeAt, null)
	%>       
	        <tr>
	          <td><%=getShowroomName(con, showrooms(i))%></td>
	          <td><%=fmtCurr2(revenue, false, "")%>&nbsp;</td>
	          <!--<td><input name="adjustment<%=showrooms(i)%>" type="text" class="text" id="adjustment<%=showrooms(i)%>" value="<%=fmtCurr2(adjustment, false, "")%>" size="10" /></td>-->
	          <input name="adjustment<%=showrooms(i)%>" type="hidden" id="adjustment<%=showrooms(i)%>" value="<%=fmtCurr2(adjustment, false, "")%>" />
	          <!--<td><%=fmtCurr2(adjustedRevenue, false, "")%>&nbsp;</td>-->
	          <!--<td><%=invoicedItemCount%>&nbsp;</td>-->
	          <td><%=completedItemCount%>&nbsp;</td>
	          <td><%=invoicedProductionThroughput%>&nbsp;</td>
	          <td><%=orderDateVsCompletionDate%>&nbsp;</td>
          	  <td><%=firstInProductionDateVsCompletionDate%>&nbsp;</td>
          	  <td><%=throughput%>&nbsp;</td>
	        </tr>
	<% next %>       
	        <tr>
	          <td>Total</td>
	          <td><%=fmtCurr2(totalRevenue, false, "")%>&nbsp;</td>
	          <td>&nbsp;</td>
	          <!--<td><%=fmtCurr2(totalAdjustedRevenue, false, "")%>&nbsp;</td>-->
	          <!--<td><%=totalInvoicedItemCount%>&nbsp;</td>-->
	          <td><%=totalCompletedItemCount%>&nbsp;</td>
	          <td>&nbsp;</td>
          <!-- no longer required <td><%=totalOrderDateVsCompletionDate%>&nbsp;</td> -->
          <td>&nbsp;</td>
	        </tr>
	<% if staffhours <> "" then
		revenuePerFte = 0.0
		if cdbl(fulltimeequiv) > 0.0 then
			revenuePerFte = totalRevenue/cdbl(fulltimeequiv)
		end if
	%>        
	        <tr>
	          <td>Revenue Per FTE(Full Time Equivalent)</td>
	          <td><%=fmtCurr2(revenuePerFte, false, "")%>&nbsp;</td>
	          <td>&nbsp;</td>
	          <!--<td><%=fmtCurr2(totalAdjustedRevenue/cdbl(staffhours), false, "")%>&nbsp;</td>-->
	          <td>&nbsp;</td>
	          <td>&nbsp;</td>
	          <td>&nbsp;</td>
	        </tr>
	<% end if %>
	</table>
	<div><br/><b>&nbsp;Overall Throughput, First Items started vs last item finished (median):  <%=getThroughput(con, 0, datefrom1, dateto1, madeAt, null)%> days</b></div>
	<% if errors <> "" then
		if totalCompletedItemCount > 0 then
			nfrt = 100.0 * errors / totalCompletedItemCount
		else
			nfrt = 0
		end if
	%>
		<div><br/><b>&nbsp;Not Right First Time (NRFT):  <%=formatNumber(nfrt, 1, -1, 0, 0)%>%</b></div>
	<% end if %> 
	
	<div><br/><b>&nbsp;Delivery Schedule Achieved (DSA - Finished Date/ Planned Production Date):  <%=formatNumber(getDeliveryScheduleAchieved(con, location, datefrom1, dateto1, madeAt, null), 1, -1, 0, 0)%>%</b></div>
	
	<div><br/><b>&nbsp;Approx Delivery Date Compared to Booked Delivery Date (Mean Average):  <%=formatNumber(getApproxDelDateVsBookedDelDate(con, location, datefrom1, dateto1, null), 1, -1, 0, 0)%> Days behind</b></div>

<% end if ' end of if submit %>

<% call closemysqlcon(con) %>
</body>
</html>

<script Language="JavaScript" type="text/javascript">

	function validateForm(theForm) {
		if (theForm.datefrommonth.value == "" ) {
			alert('Please select the FROM month');
			theForm.datefrommonth.focus();
			return false; 
		}

		if (theForm.datefromyear.value == "" ) {
			alert('Please select the FROM year');
			theForm.datefromyear.focus();
			return false; 
		}

		if (theForm.datetomonth.value != "" && theForm.datetoyear.value == "") {
			alert('Please enter the TO year for your selected TO month');
			theForm.datetoyear.focus();
			return false; 
		}

		if (theForm.datetomonth.value == "" && theForm.datetoyear.value != "") {
			alert('Please enter the TO month for your selected TO year');
			theForm.datetomonth.focus();
			return false; 
		}

		if (theForm.datetomonth.value != "" && theForm.datetoyear.value != "") {
			var dateFrom = theForm.datefromyear.value * 12 + theForm.datefrommonth.value;
			var dateTo = theForm.datetoyear.value * 12 + theForm.datetomonth.value;
			if (dateFrom > dateTo) {
				alert('Please enter a FROM date BEFORE the TO date');
				theForm.datefrommonth.focus();
				return false; 
			}
		} else {
			theForm.datetomonth.value = theForm.datefrommonth.value;
			theForm.datetoyear.value = theForm.datefromyear.value;
		}
		 
		if (theForm.staffhours.value != "" ) {
			if (!isNumeric(theForm.staffhours.value)) {
				alert('Please enter a valid number for the staff hours');
				theForm.staffhours.focus();
				return false; 
			}
		}

		if (!isInteger(theForm.stdworkweek.value)) {
			alert('Please enter a valid number for the working week hours');
			theForm.stdworkweek.focus();
			return false; 
		}

		return true;
	}

	function setAction(actionName) {
		$('#log').val("");
		if (actionName == "csv") {
			document.form1.action = "vappcsv.asp"
		} else if (actionName == "log") {
			$('#log').val("true");
			document.form1.action = "vappcsv.asp"
		} else {
			document.form1.action = "vapp.asp"
		}
		
		return validateForm(document.form1);
	}
	
	function calcWorkHoursInPeriod(doAlert) {
		var stdWorkWeek = $("#stdworkweek").val();
		console.log("calcWorkHoursInPeriod: stdWorkWeek=" + stdWorkWeek);
		if (!isInteger(stdWorkWeek)) {
			if (doAlert) {
				alert('Please enter a valid number for the working week hours');
			}
			return; 
		}
		console.log("calcWorkHoursInPeriod: workdaysinperiod=" + $("#workdaysinperiod").val());
		var workDaysInPeriod = $("#workdaysinperiod").val()*1.0;
		console.log("calcWorkHoursInPeriod: workdaysinperiod=" + workDaysInPeriod);
		var workHoursInPeriod = stdWorkWeek / 5.0 * workDaysInPeriod;
		console.log("calcWorkHoursInPeriod: workHoursInPeriod=" + workHoursInPeriod);
		$("#workhoursinperiod").val(workHoursInPeriod.toFixed(2));
		console.log("calcWorkHoursInPeriod: calling calcFullTimeEquiv");
		calcFullTimeEquiv();
	}
	
	function getWorkDaysInPeriod() {
		//$("#workdaysinperiod").val(20);
		//calcWorkHoursInPeriod(false);
		//return;
		var dateFromMonth = $("#datefrommonth option:selected").val();
		var dateFromYear = $("#datefromyear option:selected").val();
		if (dateFromMonth == "" || dateFromYear == "") {
			return;
		}
		var dateToMonth = $("#datetomonth option:selected").val();
		var dateToYear = $("#datetoyear option:selected").val();
		if (dateToMonth == "" || dateToYear == "") {
			dateToMonth = dateFromMonth;
			dateToYear = dateFromYear;
		}
		var dateFrom = pad(dateFromMonth, 2) + dateFromYear;
		var dateTo = pad(dateToMonth, 2) + dateToYear;

		var url = "php/services/workDaysInPeriod/" + dateFrom + "/" + dateTo + "/&ts=" + (new Date()).getTime();
		startSpinner("container-div");
		$.get(url, function(workDaysInPeriod) {
			stopSpinner();
			console.log("workDaysInPeriod = " + workDaysInPeriod);
			if (workDaysInPeriod < 0) {
				workDaysInPeriod = 0;
			}
			$("#workdaysinperiod").val(workDaysInPeriod);
			calcWorkHoursInPeriod(false);
		});
	}
	
	function calcFullTimeEquiv() {
		console.log("calcFullTimeEquiv called");
		var staffHours = $("#staffhours").val()*1.0;
		var workHoursInPeriod = $("#workhoursinperiod").val()*1.0;
		console.log("calcFullTimeEquiv: staffHours=" + staffHours);
		console.log("calcFullTimeEquiv: workHoursInPeriod=" + workHoursInPeriod);
		var fullTimeEquiv = 0.0;
		if (workHoursInPeriod > 0) {
			fullTimeEquiv = staffHours / workHoursInPeriod;
		}
		$("#fulltimeequiv").val(fullTimeEquiv.toFixed(2));
	}
	
	function saveFormData() {
		var dateFromMonth = $("#datefrommonth option:selected").val();
		var dateFromYear = $("#datefromyear option:selected").val();
		var dateFrom = "null";
		if (dateFromMonth != "" && dateFromYear != "") {
			dateFrom = pad(dateFromMonth, 2) + dateFromYear;
		}
		var dateToMonth = $("#datetomonth option:selected").val();
		var dateToYear = $("#datetoyear option:selected").val();
		var dateTo = "null";
		if (dateToMonth != "" && dateToYear != "") {
			dateTo = pad(dateToMonth, 2) + dateToYear;
		}

		var data = $('#form1').serialize();
		//trace("data = " + data);
		var madeAt = $("#madeat option:selected").val();
		
		var url = "php/services/saveVappFormData/<%=retrieveUserID()%>/" + madeAt + "/" + dateFrom + "/" + dateTo + "/" + encodeURIComponent(data) + "/&ts=" + (new Date()).getTime();
		//trace(url);
		try {
			startSpinner("container-div");
			$.get(url, function(msg) {
				alert(msg);
				stopSpinner();
			});
		} catch(e) {
				alert(e);
				stopSpinner();
		}
	}
	
	function retrieveFormData() {
		var dateFromMonth = $("#datefrommonth option:selected").val();
		var dateFromYear = $("#datefromyear option:selected").val();
		var dateFrom = "null";
		if (dateFromMonth != "" && dateFromYear != "") {
			dateFrom = pad(dateFromMonth, 2) + dateFromYear;
		}
		var dateToMonth = $("#datetomonth option:selected").val();
		var dateToYear = $("#datetoyear option:selected").val();
		var dateTo = "null";
		if (dateToMonth != "" && dateToYear != "") {
			dateTo = pad(dateToMonth, 2) + dateToYear;
		}

		var madeAt = $("#madeat option:selected").val();
		
		var url = "php/services/getVappFormData/<%=retrieveUserID()%>/" + madeAt + "/" + dateFrom + "/" + dateTo + "/&ts=" + (new Date()).getTime();
		//trace(url);
		startSpinner("container-div");
		$.get(url, function(data) {
			//trace(data);
			deserialize(data);
			getWorkDaysInPeriod();
			stopSpinner();
		});
	}
	
	function deserialize(data) {
		var pairs, i, keyValuePair, key, value;
    	// remove leading question mark if its there
    	if (data.slice(0, 1) === '?') {
        	data = data.slice(1);
    	}
    	if (data !== '') {
        	pairs = data.split('&');
        	for (i = 0; i < pairs.length; i += 1) {
            	keyValuePair = pairs[i].split('=');
            	key = decodeURIComponent(keyValuePair[0]);
            	value = (keyValuePair.length > 1) ? decodeURIComponent(keyValuePair[1]) : undefined;
            	if (key != 'datefrommonth' && key != 'datefromyear' && key != 'datetomonth' && key != 'datetoyear' && key != 'madeat' && key != 'workhoursinperiod' && key != 'fulltimeequiv') {
            		$("#" + key).val(value);
           		}
        	}
    	}
	}
	
	$(document).ready(init());

	function init() {
		//retrieveFormData();
		calcWorkHoursInPeriod(false);
	}
	

</script>
   
<!-- #include file="common/logger-out.inc" -->
