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
Server.ScriptTimeout = 600

Dim postcode, postcodefull, Con, rs, rs1, recordfound, id, rspostcode, submit, count, sql, msg, customerasc, orderasc, showr,  companyasc, deldate, productiondate, previousOrderNumber, acknowDateWarning, datefrom, datefrom1, dateto, dateto1, showroom, url, pno, pnotrue, revenue, staffhours, stdworkweek, adjustment, adjustedRevenue, vappadjustedrevenue, compno, compnototal, datecompcomp, location
dim showrooms, i, totalRevenue, invoicedItemCount, completedItemCount, totalInvoicedItemCount, totalCompletedItemCount, totalAdjustedRevenue, totalOrderDateVsCompletionDate
dim gbp2usd, gbp2eur, invoicedProductionThroughput, orderDateVsCompletionDate, firstInProductionDateVsCompletionDate, errors, nfrt, madeat, diff, revenue2
dim dateFromMonth, dateFromYear, dateToMonth, dateToYear, thisYear, thisMonth
dim fulltimeequiv, revenuePerFte, workdaysinperiod, workhoursinperiod, throughput
Dim filesys, tempfile, tempfolder, tempname, filename, objStream, line
dim tempname2, logfile, log, logfilename

log = (request("log") <> "")

location=request("location")
adjustment=request("adjustment")
staffhours=request("staffhours")
stdworkweek=request("stdworkweek")
if stdworkweek = "" then stdworkweek = 39
fulltimeequiv=request("fulltimeequiv")
if fulltimeequiv = "" then fulltimeequiv = 0
workdaysinperiod = request("workdaysinperiod")
if workdaysinperiod = "" then workdaysinperiod = 0
workhoursinperiod = request("workhoursinperiod")
if workhoursinperiod = "" then workhoursinperiod = 0
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

Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname

logfile = Null
if log then
	tempname2 = filesys.GetTempName
	set logfile = tempfolder.CreateTextFile(tempname2)
	logfilename = tempfolder & "\" & tempname2
end if

call addItemToLine(line, "Date from month: " & datefrommonth)
call addItemToLine(line, "Date from year: " & datefromyear)
call addItemToLine(line, "Date to month: " & datetomonth)
call addItemToLine(line, "Date to year: " & datetoyear)
call addItemToLine(line, "Showroom: " & showroom)
if madeat <> 0 then
	call addItemToLine(line, "Made at: " & getFactoryName(con, madeat))
end if
if errors <> "" then
	call addItemToLine(line, "Errors in period: " & errors)
end if
if staffhours <> "" then
	call addItemToLine(line, "Staff Hours in Period:  " & staffhours)
end if
call addItemToLine(line, "Standard working week hours:  " & stdworkweek)
call addItemToLine(line, "Available Work Hours in Period:  " & workhoursinperiod)
call addItemToLine(line, "Full Time Equivalent:  " & fulltimeequiv)
call addItemToLine(line, "GBP to USD conversion rate: " & gbp2usd)
call addItemToLine(line, "GBP to EUR conversion rate: " & gbp2eur)
call writeLine(tempfile, line)

call writeBlankLine(tempfile)

call addItemToLine(line, "Showroom,Ex Works Revenue @ 2014 Prices UK Wholesale")
'call addItemToLine(line, "Adjustment (decimal)")
'call addItemToLine(line, "Adjusted revenue")
call addItemToLine(line, "No. of items completed")
call addItemToLine(line, "In Production dates compared to Finished dates for items (Median)")
call addItemToLine(line, "Order Date Vs Order Completed Date (Median)")
call addItemToLine(line, "First In Production Date vs Order Completed Date (Median)")
call addItemToLine(line, "Throughput - First item started vs. last item finished (Median)")
call writeLine(tempfile, line)

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

totalRevenue = 0.0
totalInvoicedItemCount = 0
totalCompletedItemCount = 0
totalAdjustedRevenue = 0.0
totalOrderDateVsCompletionDate = 0.0

for i = 1 to ubound(showrooms)
	revenue = getExWorksRevenueForLocation(con, showrooms(i), datefrom1, dateto1, gbp2usd, gbp2eur, madeAt, logfile)
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
	invoicedItemCount = getInvoicedItemCount(con, showrooms(i), datefrom1, dateto1, madeAt, logfile)
	totalInvoicedItemCount = totalInvoicedItemCount + invoicedItemCount
	completedItemCount = getCompletedItemCount(con, showrooms(i), datefrom1, dateto1, madeAt, logfile)
	totalCompletedItemCount = totalCompletedItemCount + completedItemCount
	invoicedProductionThroughput = getInvoicedProductionThroughput(con, showrooms(i), datefrom1, dateto1, madeAt, logfile)
	orderDateVsCompletionDate = getOrderDateVsCompletionDate2(con, showrooms(i), datefrom1, dateto1, madeAt, logfile)
	totalOrderDateVsCompletionDate = totalOrderDateVsCompletionDate + orderDateVsCompletionDate
	firstInProductionDateVsCompletionDate = getFirstInProductionDateVsCompletionDate(con, showrooms(i), datefrom1, dateto1, madeAt, logfile)
	throughput = getThroughput(con, showrooms(i), datefrom1, dateto1, madeAt, logfile)

	call addItemToLine(line, getShowroomName(con, showrooms(i)))
	call addItemToLine(line, fmtCurr2(revenue, false, ""))
	'call addItemToLine(line, fmtCurr2(adjustment, false, ""))
	'call addItemToLine(line, fmtCurr2(adjustedRevenue, false, ""))
	'call addItemToLine(line, invoicedItemCount)
	call addItemToLine(line, completedItemCount)
	call addItemToLine(line, invoicedProductionThroughput)
	call addItemToLine(line, orderDateVsCompletionDate)
	call addItemToLine(line, firstInProductionDateVsCompletionDate)
	call addItemToLine(line, throughput)
	call writeLine(tempfile, line)
next

call addItemToLine(line, "Total")
call addItemToLine(line, fmtCurr2(totalRevenue, false, ""))
call addItemToLine(line, "")
'call addItemToLine(line, fmtCurr2(totalAdjustedRevenue, false, ""))
'call addItemToLine(line, totalInvoicedItemCount)
call addItemToLine(line, totalCompletedItemCount)
call addItemToLine(line, "")
' no longer required call addItemToLine(line, totalOrderDateVsCompletionDate)
call writeLine(tempfile, line)

call writeBlankLine(tempfile)

if staffhours <> "" then
	revenuePerFte = 0.0
	if cdbl(fulltimeequiv) > 0.0 then
		revenuePerFte = totalRevenue/cdbl(fulltimeequiv)
	end if
	call addItemToLine(line, "Revenue Per FTE(Full Time Equivalent)")
	call addItemToLine(line, fmtCurr2(revenuePerFte, false, ""))
	call addItemToLine(line, "")
	'call addItemToLine(line, fmtCurr2(totalAdjustedRevenue/cdbl(staffhours), false, ""))
	call writeLine(tempfile, line)
end if

call addItemToLine(line, "Overall Throughput, First Items started vs last item finished (median):")
call addItemToLine(line, getThroughput(con, 0, datefrom1, dateto1, madeAt, logfile) & " days")
call writeLine(tempfile, line)

if errors <> "" then
	if totalCompletedItemCount > 0 then
		nfrt = 100.0 * errors / totalCompletedItemCount
	else
		nfrt = 0
	end if
	call addItemToLine(line, "Not Right First Time (NRFT):")
	call addItemToLine(line, formatNumber(nfrt, 1, -1, 0, 0) & "%")
	call writeLine(tempfile, line)
end if

call addItemToLine(line, "Delivery Schedule Achieved (DSA - Finished Date/ Planned Production Date):")
call addItemToLine(line, formatNumber(getDeliveryScheduleAchieved(con, location, datefrom1, dateto1, madeAt, logfile), 1, -1, 0, 0) & "%")
call writeLine(tempfile, line)

call addItemToLine(line, "Approx Delivery Date Compared to Booked Delivery Date (Mean Average):")
call addItemToLine(line, formatNumber(getApproxDelDateVsBookedDelDate(con, location, datefrom1, dateto1, logfile), 1, -1, 0, 0) & " Days behind")
call writeLine(tempfile, line)

tempfile.close
if log then
	logfile.close
end if

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
if log then
	objStream.LoadFromFile(logfilename)
else
	objStream.LoadFromFile(filename)
end if

Response.ContentType = "application/csv"
if log then
	Response.AddHeader "Content-Disposition", "attachment; filename=""vapp-log.csv"""
else
	Response.AddHeader "Content-Disposition", "attachment; filename=""vapp-report.csv"""
end if

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
if log then
	filesys.deleteFile logfilename, true
end if
set filesys = Nothing
call closemysqlcon(con)

%>
   
<!-- #include file="common/logger-out.inc" -->
