<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = True %>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="customerfuncs.asp" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->

<%Const UTF8_BOM = "﻿"
Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, dateasc, orderasc, customerasc, coasc, datefrom, datefromstr, datetostr, dateto, user, rs2, rs3, rs5,  receiptasc, amttotal, currencysym, strsurname, ordervaltotal, totalpayments, totalos, payasc, location, strtotal, strpaymentstotal, stroutstanding, showroom,proddate, reporttype, giftpack, deliveryaddress, custaddress, deliverytrue, deliveryadd1, deliveryadd2, deliveryadd3, deliveryadd4, deliveryadd5, deliveryadd6, deliveryadd7, tel, fax, delconfirmed, previousOrderNumber, bookeddate, acknowDateWarning, diff, balanceOutstanding, lorrycount, splitshipment, collectiondate, bookeddeliverydate, excelcurrencysymbol,acknowDate, notedate, deliverypostcode

strsurname=""
amttotal=0
ordervaltotal=0
totalpayments=0
totalos=0
strtotal=0
strpaymentstotal=0
stroutstanding=0

Dim  cnt,  excellist, excelLine,  failedwrite, errormsg, showr, productiondate, deldate, companyasc
Set Con = getMysqlConnection()
user=Request("user")
showr=request("showr")
productiondate=request("productiondate")
deldate=request("deldate")
proddate=request("proddate")
deliverypostcode=request("deliverypostcode")
companyasc=request("companyasc")
showroom=Request("showroom")
datefrom=Request("datefrom")
dateto=Request("dateto")
payasc=request("payasc")
location=request("location")
coasc=request("coasc")
dateasc=request("dateasc")
customerasc=request("customerasc")
orderasc=request("orderasc")


count=0
submit=Request("submit") 

sql = "select * from ("
sql = sql & "select order_number,order_date,acknowdate,purchase_no,surname,c.title,first,company,total,ordercurrency,paymentstotal,balanceoutstanding,vat,productiondate,bookeddeliverydate,deliverypostcode,overseasOrder,istrade,"
if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER")  then 
sql = sql & "adminheading,"
end if
sql = sql & " (select min(ec.collectionstatus) as mincollectionstatus from exportlinks el, exportcollections ec where ec.exportcollectionsid=el.linkscollectionid and el.purchase_no=p.purchase_no) as mincollectionstatus"
sql = sql & " from address A, contact C, Purchase P" 
if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER")  then 
sql = sql & ", Location L"
end if
sql = sql & " Where (P.cancelled is null or P.cancelled <> 'y') AND C.retire='n' AND P.orderonhold<>'y' AND C.contact_no<>319256 AND C.contact_no<>24188 AND A.code=C.code AND C.contact_no=P.contact_no AND P.completedorders='n' AND P.quote='n' "
if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER")  then 
	sql = sql & " AND P.idlocation=L.idlocation "
else
	if not isSuperuser() and not userHasRole("ADMINISTRATOR") then
		sql = sql & " AND P.owning_region=" & retrieveuserregion()
		If retrieveuserlocation()<>1 and retrieveuserlocation()<>27 then 'Bedworks & Cardiff
			sql = sql & " AND P.idlocation in (" & makeBuddyLocationList(retrieveUserLocation(), con) & ")"
		end if
	'	sql = sql & " AND P.source_site='" & retrieveUserSite() & "'"
	end if
end if
if showroom="all" or showroom="" then
else
	sql = sql & " and P.idlocation=" & showroom
end if

sql = sql & " AND P.source_site='SB' " 
if showr="a" then
sql = sql & " order by L.adminheading asc"
end if
if showr="d" then
sql = sql & " order by L.adminheading desc"
end if
if customerasc="a" then
sql = sql & " order by C.surname asc"
end if
if customerasc="d" then
sql = sql & " order by C.surname desc"
end if
if orderasc="a" then
sql = sql & " order by P.order_number asc"
end if
if orderasc="d" then
sql = sql & " order by P.order_number desc"
end if
if companyasc="a" then
sql = sql & " order by A.company asc"
end if
if companyasc="d" then
sql = sql & " order by A.company desc"
end if
if deliverypostcode="a" then
sql = sql & " order by P.deliverypostcode asc"
end if
if deliverypostcode="d" then
sql = sql & " order by P.deliverypostcode desc"
end if

if bookeddate="a" then
sql = sql & " order by P.bookeddeliverydate asc"
end if
if bookeddate="d" then
sql = sql & " order by P.bookeddeliverydate desc"
end if

if productiondate="a" then
	sql = sql & " order by P.productiondate asc"
end if
if productiondate="d" then
	sql = sql & " order by P.productiondate desc"
end if

if customerasc=""  and  orderasc="" and companyasc=""  and bookeddate=""  and showr="" and productiondate="" then
sql = sql & " order by P.order_number asc"
end if

sql = sql & ") as x where (x.mincollectionstatus is null or x.mincollectionstatus<4)"


Set rs = getMysqlQueryRecordSet(sql, con)


Dim filesys, tempfile, tempfolder, tempname, filename, objStream
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
tempfile.Write(UTF8_BOM)
filename = tempfolder & "\" & tempname
'msg="Total records = " & rs.recordcount
'tempfile.WriteLine(msg)

if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER")  then
tempfile.WriteLine("Customer Name,Company,Order No,Delivery Postcode,Note Date,Order Date,Ackgt Date,Order Source,Order Value,Payments Total,Balance Outstanding,Production Date, Booked Delivery Date, Ex-Works")
else
tempfile.WriteLine("Customer Name,Company,Order No,Delivery Postcode,Note Date,Order Date,Ackgt Date,Order Value,Payments Total,Balance Outstanding,Production Date, Booked Delivery Date, Ex-Works")
end if
Do until rs.EOF
acknowDate=""
notedate=""
 if rs("order_number") <> previousOrderNumber then
'rs("order_date") 
'If the acknowledgement date is Null, and the Order Date is more than 7 days beyond than current date then a Red flag appears
acknowDateWarning = false
if (isnull(rs("acknowdate")) or rs("acknowdate") = "") and rs("order_date") <> "" then
	diff = dateDiff("d", cdate(rs("order_date")), now())
	acknowDateWarning = (diff > 7)
end if
If rs("acknowdate")<>"" then acknowDate=rs("acknowdate")
if acknowDateWarning then acknowDate="Warning"
if orderHasOverdueNote(con, rs("purchase_no")) then
 notedate="Warning"
end if
currencysym=rs("ordercurrency")
if currencysym="GBP" then 
	excelcurrencysymbol="£"
end if
if currencysym="USD" then 
	excelcurrencysymbol="$"
end if
if currencysym="EUR" then 
	excelcurrencysymbol="€"
end if

balanceOutstanding = 0.0
if rs("istrade") = "y" then
	balanceOutstanding = CDbl(rs("balanceoutstanding")) + CDbl(rs("vat"))
else
	balanceOutstanding = rs("balanceoutstanding")
end if


	If rs("surname")<>"" then strsurname=rs("surname")
	If rs("title")<>"" then strsurname=strsurname & ", " & rs("title")
	If rs("first")<>"" then strsurname=strsurname & " " & rs("first")

	strtotal=rs("total")
	strpaymentstotal=rs("paymentstotal")
	stroutstanding=balanceOutstanding

	bookeddeliverydate=rs("bookeddeliverydate")
	if rs("overseasOrder")="y" then
					Set rs5 = getMysqlQueryRecordSet("select count(*) as lorrycount from (SELECT exportcollectionid FROM exportlinks E, exportcollshowrooms L where E.linkscollectionid=L.exportCollshowroomsID and purchase_no=" & rs("purchase_no") & "  group by exportcollectionid)  as x", con)
					if not rs5.eof then
						lorrycount=rs5("lorrycount")
					end if
					rs5.close
					set rs5=nothing
					
					if Cint(lorrycount) > 1 then 
						splitshipment="y"
						collectiondate="Split Shipment"
					else
						splitshipment="n"
						Set rs5 = getMysqlUpdateRecordSet("Select * from exportcollections E, exportLinks L, exportCollShowrooms S where L.purchase_no=" & rs("purchase_no") & " and L.linksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=E.exportCollectionsID", con)
						if not rs5.eof then
							collectiondate=rs5("CollectionDate")
						else
							collectiondate="TBA"
						end if
						rs5.close
					set rs5=nothing
					end if
					
	   end if
       
       
	count=count+1
	previousOrderNumber = rs("order_number")
end if
excelLine = """" & strsurname & """,""" & rs("company") & """,""" & rs("order_number") & """,""" & rs("deliverypostcode") & """,""" & notedate & ""","""
if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER")  then
excelLine = excelLine & rs("order_date") & """,""" & acknowDate & """,""" & rs("adminheading") & """,""" & excelcurrencysymbol & strtotal & """,""" 
else
excelLine = excelLine & rs("order_date") & """,""" & acknowDate & """,""" & excelcurrencysymbol & strtotal & """,""" 
end if
excelLine = excelLine & excelcurrencysymbol & strpaymentstotal & """,""" & excelcurrencysymbol & stroutstanding & """,""" & rs("productiondate") & """,""" & rs("bookeddeliverydate") & """,""" & collectiondate & """"
tempfile.WriteLine(excelLine)
  count=count+1
rs.movenext
loop
rs.close
set rs=nothing

tempfile.close


Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Charset = "UTF-8"
objStream.Type = 1
objStream.Open
objStream.LoadFromFile(filename)

Response.ContentType = "text/csv; charset=utf-8"
Response.AddHeader "Content-Disposition", "attachment; filename=""currentorders.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing

Con.Close
Set Con = Nothing%>
    

 
<!-- #include file="common/logger-out.inc" -->
