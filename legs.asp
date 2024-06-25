<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s,  clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, deltime, deliverytrue, mattresspicked, basepicked, topperpicked, valancepicked,  legspicked, headboardpicked, itemcount, tobedelivered, itemqty, accessoriespicked, accessoryqtysum, valencelength, valancewidth, valancedrop, matttable, matttable2, mattqty, mattwidth1, mattwidth2, mattlength1, mattlength2, toptable, topperqty, baseqty, basetable, basewidth1, basewidth2, baselength1, baselength2, eastwest, northsouth, wrappingtype, x, y, legsum, legstext, legcount, speciallegheight, legtext, bcwexpected, dofweek, startweek, pweekno, carpentryweekno, finishedweekno

'legstyle=request("legs")

speciallegheight=""
custname=""
msg=""
localeref=retrieveuserregion()
Set Con = getMysqlConnection()

sql="Select * from region WHERE id_region=" & localeref
'REsponse.Write("sql=" & sql)	
Set rs = getMysqlUpdateRecordSet(sql, con)

Session.LCID = rs("locale")
rs.close
set rs=nothing


purchase_no=request("pn")
'purchase_no=70182
selcted=""
count=0
order=""
submit=""

sql="Select * from productionsizes WHERE purchase_no=" & purchase_no & ""
Set rs = getMysqlQueryRecordSet(sql, con)
if not rs.eof then
speciallegheight=rs("legheight")
end if
rs.close
set rs=nothing

sql="Select * from qc_history_latest WHERE componentid=7 and purchase_no=" & purchase_no & ""
Set rs = getMysqlQueryRecordSet(sql, con)
if isNull(rs("bcwexpected")) then
bcwexpected = ""
cuttingweekno= ""
else
bcwexpected = rs("bcwexpected")
dofweek=Weekday(bcwexpected,0)
'startweek=7-dofweek
pweekno=DatePart("ww", bcwexpected, 2, 2)
'realProdEndDate=FirstDayOfNextWeekN(pweekno, bcwexpected)
finishedweekno=pweekno & "." & dofweek
carpentryweekno=DatePart("ww",DateAdd("ww", -1, bcwexpected), 2, 2) & "." & dofweek
end if
rs.close
set rs=nothing

sql="Select * from purchase WHERE purchase_no=" & purchase_no & ""
Set rs = getMysqlQueryRecordSet(sql, con)

if isNull(rs("legstyle")) or rs("legstyle")="--" then legstyle="Style not provided" else legstyle=rs("legstyle")
legstext=0
if rs("legqty") <> 0 and rs("legqty") <> "" and not isNull(rs("legqty"))  then 
	legsum=CDbl(rs("legqty"))
	legstext=rs("legqty")
	legcount=1
end if
if rs("addlegqty") <> 0 and rs("addlegqty") <> "" and not isNull(rs("addlegqty")) then 
	legsum=legsum + CDbl(rs("addlegqty"))
	if legcount = 1 then
	legstext=legstext & " + " & rs("addlegqty")
	legcount=2
	else
	legstext=rs("addlegqty")
	legcount=1
	end if
end if


if isNULL(rs("legheight")) then legheight="Not provided" else legheight=rs("legheight")
if speciallegheight<>"" then legheight=speciallegheight & "cm"
if isNULL(rs("legfinish")) then legfinish="Not provided" else legfinish=rs("legfinish")


sql="Select * from location WHERE idlocation=" & rs("idlocation") & ""
Set rs2 = getMysqlQueryRecordSet(sql, con)

showroomaddress=rs2("adminheading")
'If rs2("tel")<>"" then showroomaddress=showroomaddress & "&nbsp;&nbsp;Tel: " & rs2("tel")
'If rs2("email")<>"" then showroomaddress=showroomaddress & "&nbsp;&nbsp;Email: " & rs2("email")
rs2.close
set rs2=nothing

sql="Select * from savoir_user WHERE username like '" & rs("salesusername") & "'"

Set rs2 = getMysqlQueryRecordSet(sql, con)

if not rs2.eof then
contact = rs2("name")
end if
rs2.close
set rs2=nothing
sql="Select * from contact WHERE code=" & rs("code") & ""
Set rs1 = getMysqlQueryRecordSet(sql, con)
sql="Select * from address WHERE code=" & rs1("code") & ""
Set rs2 = getMysqlQueryRecordSet(sql, con)

signature = rs("signature")

If rs1("title") <> "" Then custname=custname & Utf8ToUnicode(capitaliseName(rs1("title"))) & " "
If rs1("first") <> "" Then custname=custname & Utf8ToUnicode(capitaliseName(rs1("first"))) & " "
If rs1("surname") <> "" Then custname=custname & Utf8ToUnicode(capitaliseName(rs1("surname")))



' Clear out the existing HTTP header information
Response.Expires = 0
Response.Buffer = TRUE
Response.Clear
Response.Buffer = TRUE
Response.ContentType = "application/pdf"

Response.Expires = 0
Response.Expiresabsolute = Now() - 1
Response.AddHeader "pragma","no-cache"
Response.AddHeader "cache-control","private"
Response.CacheControl = "no-cache" 

dim PDF, str, streamPDF
str=""
const csPropGraphFillColor="#eee"
const csPropGraphZoom= 1
const csPropGraphWZoom= 50 
const csPropGraphHZoom= 50
const csPropTextFont  = 100
const csHTML_FontName = 100
const csHTML_FontSize  = 101


const csPropTextSize  = 101
const csPropTextAlign = 102
const csPropTextColor = 103
const csPropTextUnderline = 104
const csPropTextRender  = 105
const csPropAddTextWidth = 113
const csPropParSpace    = 200
const csPropParLeft 	= 201
const csPropParTop 		= 202
const csPropPosX	    = 205
const csPropPosY	    = 206
const csPropInfoTitle 	= 300

'
const algLeft = "0"
const algRight = "1"
const algCenter = "2"
const algJustified = "3"
'
const pTrue = "1"
const pFalse = "0"

Sub DrawBox(X, Y, Width, Height)
	PDF.AddBox X, Y, X+Width, Y+Height
End Sub
set PDF = server.createobject("aspPDF.EasyPDF")
'PDF.License("C:\Program Files (x86)\MITData\01022012-44318-S1538.lic")
'PDF.License("$829586222;'David Mildenhall';PDF;1;5-201.516.485.5;0-192.168.0.5")
PDF.License("$810217456;'David Mildenhall';PDF;1;0-31.170.121.214")
PDF.page "A4", 0  'landscape

'PDF.DEBUG = True
PDF.SetMargins 10,15,10,5

DrawBox 20,20, 175, 140
DrawBox 405,20, 175, 140

PDF.SetProperty csPropTextAlign, algCenter
YPos = int(PDF.GetProperty(csPropPosY))
PDF.SetPos 0, YPos - 5
'PDF.AddLine 60, 55, 520, 55
PDF.SetTrueTypeFont "F15", "Tahoma", 0, 0
PDF.SetProperty csPropParLeft, "20"
PDF.SetProperty csPropPosX, "20"
PDF.SetProperty csHTML_FontName, "F1"
PDF.SetProperty csHTML_FontSize, "8"
PDF.SetProperty csPropTextColor,"#999"
PDF.SetProperty csPropTextAlign, "0"
PDF.SetProperty csPropAddTextWidth, 1
PDF.SetFont "F15", 12, "#999"


PDF.SetFont "F15", 16, "#999"
PDF.SetProperty csPropTextAlign, algCenter
PDF.AddTextWidth 0,20,600, legstyle
PDF.SetFont "F15", 10, "#999"
PDF.AddHTMLPos 27, 22, "<b>CARPENTRY</b> "
PDF.AddHTMLPos 27, 40, "<b>Week:</b> "
if retrieveUserLocation()=27 then
else
PDF.AddHTMLPos 27, 60, "<font size=+62>" & carpentryweekno & "</font>"
end if
PDF.AddHTMLPos 415, 22, "<b>FINISHING</b> "
PDF.AddHTMLPos 415, 40, "<b>Week:</b> "
if retrieveUserLocation()=27 then
else
PDF.AddHTMLPos 415, 60, "<font size=+62>" & finishedweekno & "</font>"
end if
PDF.AddHTMLPos 1, 165, "<hr>"
PDF.AddTextPos 405, 185, "Order No: " 
PDF.SetFont "F15", 14, "#999"
PDF.AddTextPos 471, 185,  rs("order_number")
PDF.SetFont "F15", 10, "#999"
PDF.AddTextPos 405, 205, "Customer: " 
PDF.AddTextPos 471, 205,  custname
x=225
if rs("customerreference")<>"" then
PDF.AddTextPos 405, x, "Customer Ref: "
PDF.AddTextPos 471, x,  rs("customerreference")
x=x+20
end if
PDF.AddTextPos 405, x, "Source: " 
PDF.AddTextPos 471, x,  showroomaddress
PDF.SetProperty csPropTextAlign, algLeft
PDF.SetProperty csPropAddTextWidth , 2
			PDF.AddTextWidth 405,x+20,180, legtext
			PDF.SetProperty csPropTextAlign, algCenter
PDF.AddTextPos 20, 185, "Leg Height: " & legheight
PDF.AddTextPos 20, 205, rs("legstyle") & " x " & rs("legqty") & " Colour: " & rs("legfinish") 
PDF.AddTextPos 20, 225, rs("addlegstyle") & " x " & rs("addlegqty") & " Colour: " & rs("addlegfinish")

PDF.AddTextPos 20, 245, "Total Quantity: " & legsum
if not ISNULL(rs("floortype")) then
PDF.AddTextPos 20, 265, "Floor Type: " & rs("floortype")
end if
if rs("legstyle")="Wooden Tapered" then
PDF.AddHTMLPos 25, 285, "<img src=""images/Wooden Tapered.gif"">"
end if
 if rs("legstyle")="Metal" then
PDF.AddHTMLPos 25, 285, "<img src=""images/Metal.gif"">"
end if
 if rs("legstyle")="Castors" then
PDF.AddHTMLPos 25, 285, "<img src=""images/Castors.gif"">"
end if
 if rs("legstyle")="Manhattan" then
PDF.AddHTMLPos 25, 285, "<img src=""images/Manhattan.gif"">"
end if
if rs("legstyle")="Georgian (Brass cap)" or rs("legstyle")="Georgian (Chrome cap)" then
PDF.AddHTMLPos 25, 285, "<img src=""images/Georgian (Brass Cap).gif"">"
end if

if rs("legstyle")="Penelope" then
PDF.AddHTMLPos 25, 285, "<img src=""images/Penelope.gif"">"
end if
if rs("legstyle")="Cylindrical" then
PDF.AddHTMLPos 25, 285, "<img src=""images/Cylindrical.gif"">"
end if
if rs("legstyle")="Georgian" or rs("legstyle")="Georgian Upholstered" then
PDF.AddHTMLPos 25, 285, "<img src=""images/Georgian.gif"">"
end if
if rs("legstyle")="Harlech Leg" then
PDF.AddHTMLPos 25, 285, "<img src=""images/Harlech Leg.gif"">"
end if
if rs("legstyle")="Holly" then
PDF.AddHTMLPos 25, 285, "<img src=""images/Holly.gif"">"
end if
if rs("legstyle")="Ian Leg" then
PDF.AddHTMLPos 25, 285, "<img src=""images/Ian Leg.gif"">"
end if
if rs("legstyle")="Block Leg" then
PDF.AddHTMLPos 25, 285, "<img src=""images/Block Leg.gif"">"
end if


PDF.BinaryWrite
set pdf = nothing
rs1.close
rs.close
rs2.close
set rs1=nothing
set rs=nothing
set rs2=nothing

function capitalise(str)
dim words, word
if isNull(str) or trim(str)="" then
	capitalise=""
else
	words = split(trim(str), " ")
	for each word in words
		word = lcase(word)
		word = ucase(left(word,1)) & (right(word,len(word)-1))
		capitalise = capitalise & word & " "
	next
	capitalise = left(capitalise, len(capitalise)-1)
end if

end function
con.close
set con=nothing
%>
<!-- #include file="common/logger-out.inc" -->
