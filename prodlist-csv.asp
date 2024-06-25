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
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%Dim  Con, rs, rs2, recordfound, id, count, i, fieldName, fieldValue, fieldNameArray, type1, prodsql, custname, sql, mattreq, mattmadeat, factories, mattstatus, basereq, basemadeat, basestatus, topperreq, toppermadeat, topperstatus, hbreq, hbmadeat, hbstatus, legsreq, legsmadeat, legsstatus, orderstatus, exportcollection
sql=Request("prodsql")
Server.ScriptTimeout=1200
Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Customer Name,Company,Address 1,Address 2,Address 3,Town,County,Postcode,Country,Order Source,Order No.,Order Date,Mattress Required,Mattress Made at,Mattress Order Status,Base Required,Base Made at,Base Order Status,Topper Required,Topper Made at,Topper Order Status,Headboard Required,Headboard Made at,Headboard Order Status,Legs Required,Legs Made at,Legs Order Status,Production Date,Booked Delivery Date,Total Ex VAT,Currency,Order Status,Ex-Works Date,Price List,Patyments Total,Vat Rate")
Set Con = getMysqlConnection()

Set rs = getMysqlQueryRecordSet(sql, con)
factories = getFactories(con)
if not rs.eof then
Do until rs.eof
If rs("surname")<>"" then custname=rs("surname") & ", "
If rs("title")<>"" then custname=custname & rs("title") & " "
If rs("first")<>"" then custname=custname & rs("first") & " "
if rs("mattressrequired")="y" then 
	mattreq=rs("savoirmodel")
	if parseMadeat(rs("matt_madeat")) > -1 then mattmadeat=factories(parseMadeat(rs("matt_madeat")))
	mattstatus=getComponentStatusTxt(rs("purchase_no"), 1, con)
end if
if rs("baserequired")="y" then 
	basereq=rs("basesavoirmodel")
	if parseMadeat(rs("base_madeat")) > -1 then basemadeat=factories(parseMadeat(rs("base_madeat")))
	basestatus=getComponentStatusTxt(rs("purchase_no"), 3, con)
end if
if rs("topperrequired")="y" then 
	topperreq=rs("toppertype")
	if parseMadeat(rs("topper_madeat")) > -1 then toppermadeat=factories(parseMadeat(rs("topper_madeat")))
	topperstatus=getComponentStatusTxt(rs("purchase_no"), 5, con)
end if
if rs("headboardrequired")="y" then 
	hbreq=rs("headboardstyle")
	if parseMadeat(rs("headboard_madeat")) > -1 then hbmadeat=factories(parseMadeat(rs("headboard_madeat")))
	hbstatus=getComponentStatusTxt(rs("purchase_no"), 8, con)
end if
if rs("legsrequired")="y" then 
	legsreq=rs("legstyle")
	if parseMadeat(rs("legs_madeat")) > -1 then legsmadeat=factories(parseMadeat(rs("legs_madeat")))
	legsstatus=getComponentStatusTxt(rs("purchase_no"), 7, con)
end if
orderstatus=getComponentStatusTxt(rs("purchase_no"), 0, con)
Set rs2 = getMysqlQueryRecordSet("SELECT * FROM exportlinks L, exportcollshowrooms S, exportcollections E WHERE purchase_no=" & rs("purchase_no") & " AND S.exportCollShowroomsID=L.LinksCollectionID AND S.exportCollectionID=E.ExportCollectionsID order by E.Collectiondate desc", con)
if not rs2.eof then
exportcollection=rs2("Collectiondate")
else
exportcollection=""
end if
rs2.close
set rs2=nothing

excelLine = """" & custname & """,""" & rs("company") & """,""" & rs("deliveryadd1") & """,""" & rs("deliveryadd2") & """,""" & rs("deliveryadd3") & """,""" & rs("deliverytown") & """,""" & rs("deliverycounty") & """,""" & rs("deliverypostcode") & """,""" & rs("deliverycountry") & """,""" & rs("adminheading") & """,""" & rs("order_number") & """,""" & rs("order_date") & """,""" & mattreq & """,""" & mattmadeat & """,""" & mattstatus & """,""" & basereq & """,""" & basemadeat & """,""" & basestatus & """,""" & topperreq & """,""" & toppermadeat & """,""" & topperstatus & """,""" & hbreq & """,""" & hbmadeat & """,""" & hbstatus & """,""" & legsreq & """,""" & legsmadeat & """,""" & legsstatus & """,""" & rs("productiondate") & """,""" & rs("bookeddeliverydate") & """,""" & rs("totalexvat") & """,""" & rs("ordercurrency") & """,""" & orderstatus & """,""" & exportcollection & """,""" & rs("price_list") & """,""" & rs("paymentstotal") & """,""" & rs("vatrate") & """"



mattmadeat=""
mattstatus=""
custname=""
mattreq=""
basemadeat=""
basestatus=""
basereq=""
toppermadeat=""
topperstatus=""
topperreq=""
hbmadeat=""
hbstatus=""
hbreq=""
legsmadeat=""
legsstatus=""
legsreq=""
tempfile.WriteLine(excelLine)

rs.movenext
loop
end if
rs.close
set rs=nothing

tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""production-list.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing

function getComponentCellStatusClass(byref acon, aPurchaseNo, aCompId)
	dim aStatus
	aStatus = getComponentStatus(acon, aPurchaseNo, aCompId)
	getComponentCellStatusClass = ""
	if aStatus < 20 then getComponentCellStatusClass = "redcell"
end function

function parseMadeat(byref aval)
	parseMadeat = -1

	on error resume next
		parseMadeat = cint(cstr(aval))
	if err.number <> 0 then
		parseMadeat = -1
	end if
	on error goto 0
	'response.write("<br>aval = " & cstr(aval))
	'response.write("<br>parseMadeat = " & parseMadeat)
	'response.end
	
end function
%>
<!-- #include file="common/logger-out.inc" -->
