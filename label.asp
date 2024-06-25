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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s, deliveryaddress, clientdetails, clienthdg, strmattress
dim purchase_no, i, paymentSum, payments, n, displayterms, orderCurrency
displayterms=""
quote=Request("quote")
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
Set rs = getMysqlUpdateRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
displayterms=rs("terms")
rs.close
set rs=nothing

'purchase_no=Request("val")
purchase_no=69837
selcted=""
count=0
order=""
submit=""

payments = getPaymentsForOrder(purchase_no, con)

Set rs = getMysqlQueryRecordSet("Select * from purchase WHERE purchase_no=" & purchase_no & "", con)

deliveryaddress="<font family=""Tahoma""><font size=""8"">"
If rs("deliveryadd1") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd1")) & "<br />"
If rs("deliveryadd2") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd2")) & "<br />"
If rs("deliveryadd3") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd3")) & "<br />"
If rs("deliverytown") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverytown")) & "<br />"
If rs("deliverycounty") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverycounty")) & "<br />"
If rs("deliverypostcode") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverypostcode")) & "<br />"
If rs("deliverycountry") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverycountry"))
deliveryaddress=deliveryaddress & "</font></font>"
Set rs2 = getMysqlQueryRecordSet("Select * from location WHERE idlocation=" & rs("idlocation") & "", con)
If rs2("add1")<>"" then showroomaddress=Utf8ToUnicode(rs2("add1")) & ", "
If rs2("add2")<>"" then showroomaddress=showroomaddress & Utf8ToUnicode(rs2("add2")) & ", "
If rs2("add3")<>"" then showroomaddress=showroomaddress & Utf8ToUnicode(rs2("add3")) & ", "
If rs2("town")<>"" then showroomaddress=showroomaddress & Utf8ToUnicode(rs2("town")) & ", "
If rs2("countystate")<>"" then showroomaddress=showroomaddress & Utf8ToUnicode(rs2("countystate")) & ", "
If rs2("postcode")<>"" then showroomaddress=showroomaddress & Utf8ToUnicode(rs2("postcode")) & ", "
showroomaddress=left(showroomaddress, len(showroomaddress)-2)
If rs2("tel")<>"" then showroomaddress=showroomaddress & "&nbsp;&nbsp;Tel: " & rs2("tel")
If rs2("email")<>"" then showroomaddress=showroomaddress & "&nbsp;&nbsp;Email: " & rs2("email")
rs2.close
set rs2=nothing
Set rs2 = getMysqlQueryRecordSet("Select * from savoir_user WHERE username like '" & rs("salesusername") & "'", con)
orderCurrency = rs("ordercurrency")
contact = rs2("name")
rs2.close
set rs2=nothing
Set rs1 = getMysqlQueryRecordSet("Select * from contact WHERE code=" & rs("code") & "", con)
Set rs2 = getMysqlQueryRecordSet("Select * from address WHERE code=" & rs1("code") & "", con)

signature = rs("signature")

If rs1("title") <> "" Then custname=custname & Utf8ToUnicode(capitalise(lcase(rs1("title")))) & " "
If rs1("first") <> "" Then custname=custname & Utf8ToUnicode(capitalise(lcase(rs1("first")))) & " "
If rs1("surname") <> "" Then custname=custname & Utf8ToUnicode(capitalise(lcase(rs1("surname"))))
clienthdg="<font family=""Tahoma""><font size=""8"">"
clienthdg=clienthdg & "<b>Client: </b><br />"
clienthdg=clienthdg & "<b>Company: </b><br />"
clienthdg=clienthdg & "<b>Home Tel: </b><br />"
clienthdg=clienthdg & "<b>Work Tel: </b><br />"
clienthdg=clienthdg & "<b>Mobile: </b><br />"
clienthdg=clienthdg & "<b>Email: </b><br />"
clienthdg=clienthdg & "<b>Client Ref: </b><br />"
clienthdg=clienthdg & "</font></font>"

clientdetails="<font family=""Tahoma""><font size=""8"">"
clientdetails=clientdetails & custname & "<br />"
clientdetails=clientdetails & Utf8ToUnicode(rs2("company")) & "<br />"
clientdetails=clientdetails & rs2("tel") & "<br />"
clientdetails=clientdetails & rs1("telwork") & "<br />"
clientdetails=clientdetails & rs1("mobile") & "<br />"
clientdetails=clientdetails & rs2("email_address") & "<br />"
clientdetails=clientdetails & rs("customerreference") & "<br />"
clientdetails=clientdetails & "</font></font>"
custaddress="<font family=""Tahoma""><font size=""8"">"
If rs2("street1")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("street1")) & "<br />"
If rs2("street2")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("street2")) & "<br />"
If rs2("street3")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("street3")) & "<br />"
If rs2("town")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("town")) & "<br />"
If rs2("county")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("county")) & "<br />"
If rs2("postcode")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("postcode")) & "<br />"
If rs2("country")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("country"))
custaddress=custaddress & "</font></font>"
s = "<table cellpadding=""9""> "
s = s & " <tr height=""0""><td colspan=""7"" height=""0""></td></tr>"
s = s & " <tr><td width=""4"" height=""55""></td> "
s = s & " <td width=""66"">" & clienthdg & "</td><td width=""100"">" & clientdetails & "</td><td width=""24""></td><td width=""166"">" & custaddress & "</td><td width=""24""></td><td width=""166"">" & deliveryaddress & "</td> "
s = s & " </tr> "
s = s & " </table> "
If quote="y" then 
hdg="Pricing is subject to change.  This quote is valid for 60 days"
hdg2="Quote for:"
Else
hdg2="Order for:"
End If   


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
PDF.License("$1987662561;'David Mildenhall';PDF;1;0-94.136.44.145;0-217.199.174.247")
PDF.page "A4", 0  'landscape

'PDF.DEBUG = True
PDF.SetMargins 10,15,10,50


PDF.SetProperty csPropTextAlign, algCenter
YPos = int(PDF.GetProperty(csPropPosY))
PDF.SetPos 0, YPos - 5
'PDF.AddLine 60, 55, 520, 55
PDF.SetTrueTypeFont "F15", "Tahoma", 0, 0

DrawBox 20,93, 180, 95
DrawBox 210,93, 180, 95
DrawBox 400,93, 180, 95
If rs("mattressrequired")="y" Then
DrawBox 20,195, 560, 55
end if
PDF.SetProperty csPropParLeft, "20"
PDF.SetProperty csPropPosX, "20"
PDF.SetProperty csHTML_FontName, "F1"
PDF.SetProperty csPropTextColor,"#999"
PDF.SetProperty csPropTextAlign, "0"
PDF.SetProperty csPropAddTextWidth, 1
PDF.SetFont "F15", 12, "#999"
PDF.AddHTML "<p align=""right""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
PDF.AddTextPos 20, 20, "Order No. " & rs("order_number")
PDF.SetFont "F15", 10, "#999"
PDF.AddTextPos 20, 40, "Order Date. " & FormatDateTime(rs("order_date"),vbShortDate)
PDF.AddTextPos 20, 60, "Savoir Contact: " & contact
PDF.AddTextPos 20, 80, "Showroom: " & showroomaddress
PDF.AddHTML "<hr>"
PDF.AddHTML s


PDF.AddHTMLPos 25, 85, "<img src=""images/whitebg.png"" width=""95"" height=""16"">"
PDF.AddHTMLPos 215, 85, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 405, 85, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 25, 190, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"

PDF.AddTextPos 33, 97, "Client Details"
PDF.AddTextPos 33, 199, "Mattress"

PDF.AddTextPos 223, 97, "Invoice Address"
PDF.AddTextPos 413, 97, "Delivery Address"
PDF.SetFont "F1", 8, "#999"
If rs("mattressrequired")="y" then
PDF.AddHTMLPos 25, 200, "<b>Model</b>"
end if

PDF.SetProperty csPropTextSize, 12	
PDF.SetFont "F1", 12, "#3e7034"
PDF.SetProperty csPropTextAlign, "1"
PDF.SetProperty csPropAddTextWidth, 1
PDF.AddTextWidth 120,260,200, "After 5 years"
PDF.AddTextWidth 120,180,200, str
PDF.AddTextWidth 120,200,200, str
PDF.SetProperty csPropTextAlign, "2"
str="Treat Yourself -"
PDF.AddTextWidth 143,350,200, str
str="Treat Your Garden"
PDF.AddTextWidth 143,367,200, str
PDF.SetFont "F1", 14, "#3366CC"
PDF.SetProperty csPropAddTextWidth, 2
PDF.AddTextWidth 172,393,505, str 
PDF.SetProperty csPropTextAlign, "3"
PDF.SetFont "F1", 10, "#000000"
PDF.AddTextWidth 172,410,505, str 
PDF.SetFont "F1", 10, "#3e7034"
PDF.AddTextWidth 172,462,505, str
	

' Write it directly to window

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
