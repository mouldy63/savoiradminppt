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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly
dim purchase_no, i, paymentSum, payments, n, displayterms, orderCurrency, upholsterysum, deltxt
displayterms=""
quote=Request("quote")
custname=""
msg=""
localeref=retrieveuserregion()
Set Con = getMysqlConnection()
Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
				termstext=rs("terms")
rs.close
set rs=nothing
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
purchase_no=69863
selcted=""
count=0
order=""
submit=""

payments = getPaymentsForOrder(purchase_no, con)

Set rs = getMysqlQueryRecordSet("Select * from purchase WHERE purchase_no=" & purchase_no & "", con)
deliveryaddress="<font family=""Tahoma""><font size=""8"">"
If rs("deliveryadd1") <> "" then deliveryaddress=deliveryaddress & rs("deliveryadd1") & "<br />"
If rs("deliveryadd2") <> "" then deliveryaddress=deliveryaddress & rs("deliveryadd2") & "<br />"
If rs("deliveryadd3") <> "" then deliveryaddress=deliveryaddress & rs("deliveryadd3") & "<br />"
If rs("deliverytown") <> "" then deliveryaddress=deliveryaddress & rs("deliverytown") & "<br />"
If rs("deliverycounty") <> "" then deliveryaddress=deliveryaddress & rs("deliverycounty") & "<br />"
If rs("deliverypostcode") <> "" then deliveryaddress=deliveryaddress & rs("deliverypostcode") & "<br />"
If rs("deliverycountry") <> "" then deliveryaddress=deliveryaddress & rs("deliverycountry")
deliveryaddress=deliveryaddress & "</font></font>"
Set rs2 = getMysqlQueryRecordSet("Select * from location WHERE idlocation=" & rs("idlocation") & "", con)
If rs2("add1")<>"" then showroomaddress=rs2("add1") & ", "
If rs2("add2")<>"" then showroomaddress=showroomaddress & rs2("add2") & ", "
If rs2("add3")<>"" then showroomaddress=showroomaddress & rs2("add3") & ", "
If rs2("town")<>"" then showroomaddress=showroomaddress & rs2("town") & ", "
If rs2("countystate")<>"" then showroomaddress=showroomaddress & rs2("countystate") & ", "
If rs2("postcode")<>"" then showroomaddress=showroomaddress & rs2("postcode") & ", "
if showroomaddress<>"" then showroomaddress=left(showroomaddress, len(showroomaddress)-2)
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

If rs1("title") <> "" Then custname=custname & capitalise(lcase(rs1("title"))) & " "
If rs1("first") <> "" Then custname=custname & capitalise(lcase(rs1("first"))) & " "
If rs1("surname") <> "" Then custname=custname & capitalise(lcase(rs1("surname")))
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
clientdetails=clientdetails & rs2("company") & "<br />"
clientdetails=clientdetails & rs2("tel") & "<br />"
clientdetails=clientdetails & rs1("telwork") & "<br />"
clientdetails=clientdetails & rs1("mobile") & "<br />"
clientdetails=clientdetails & rs2("email_address") & "<br />"
clientdetails=clientdetails & rs("customerreference") & "<br />"
clientdetails=clientdetails & "</font></font>"
custaddress="<font family=""Tahoma""><font size=""8"">"
If rs2("street1")<>"" then custaddress=custaddress & rs2("street1") & "<br />"
If rs2("street2")<>"" then custaddress=custaddress & rs2("street2") & "<br />"
If rs2("street3")<>"" then custaddress=custaddress & rs2("street3") & "<br />"
If rs2("town")<>"" then custaddress=custaddress & rs2("town") & "<br />"
If rs2("county")<>"" then custaddress=custaddress & rs2("county") & "<br />"
If rs2("postcode")<>"" then custaddress=custaddress & rs2("postcode") & "<br />"
If rs2("country")<>"" then custaddress=custaddress & rs2("country")
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
payments = getPaymentsForOrder(purchase_no, con)

Set rs3 = getMysqlUpdateRecordSet("select * from orderaccessory where purchase_no=" & purchase_no & " order by orderaccessory_id", con)
xacc="<table><tr><td width=""10"" height=""20""></td><td><b>Item&nbsp;Description</b></td><td align=""right""><b>Qty</b></td><td align=""right""><b>Unit&nbsp;Price</b></td><td align=""right""><b>Total</b></td></tr>"
if not rs3.eof then
 do until rs3.eof
xacc=xacc & "<tr ><td width=""10"" height=""20""></td>"
xacc=xacc & "<td width=""350"">" & rs3("description") & "</td>"
xacc=xacc & "<td width=""60"" align=""right"">" & rs3("qty") & "</td>"
xacc=xacc & "<td width=""60"" align=""right"">" & fmtCurr2(rs3("unitprice"), true, rs("ordercurrency")) & "</td>"
if (rs3("unitprice")<>"" and CDbl(rs3("unitprice"))>0.0) then accesscost=rs3("qty")*CDbl(rs3("unitprice")) else accesscost=0
xacc=xacc & "<td width=""60"" align=""right"">" & fmtCurr2(accesscost, true, rs("ordercurrency")) & "</td>"
xacc=xacc & "</tr>"
xacc=xacc & "<tr><td></td><td colspan=""4""><hr style=""color:#eeeeee;""></td></tr>"
accesscost=0   
	rs3.movenext
	loop
end if
rs3.close
set rs3 = nothing
	
xacc=xacc & "</table>"

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
PDF.SetMargins 10,15,10,5


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
'start check whether just accessories ordered
'if rs("mattressrequired")="y" or rs("topperrequired")="y" or rs("baserequired")="y" or rs("headboardrequired")="y" or rs("valancerequired")="y" then accessoriesonly="n" else accessoriesonly="y"

'if accessoriesonly="n" then 

DrawBox 20,93, 180, 95
DrawBox 210,93, 180, 95
DrawBox 400,93, 180, 95
'MATTRESS REQ

DrawBox 20,195, 560, 65
DrawBox 25,229, 500, 25
'end MATTRESS
'BASE REQ
DrawBox 20,267, 560, 74
DrawBox 25,311, 500, 25
'end BASE
'TOPPER REQ
DrawBox 20,347, 560, 52
DrawBox 25,369, 500, 25
'end BASE
'UPHOLSTERY OPTIONS REQ
DrawBox 20,405, 560, 92
DrawBox 25,427, 500, 25
DrawBox 25,467, 500, 25
'end UPHOLSTERY
'HEADBOARD REQ
DrawBox 20,503, 560, 93
DrawBox 25,527, 500, 25
DrawBox 25,567, 500, 25
'end HEADBOARD
'ORDER SUMMARY
DrawBox 20,604, 270, 142
'end ORDER SUMMARY
'DELIVERY DETAILS
DrawBox 310,604, 270, 102
'end ORDER DELIVERY DETAILS
'PAYMENTS
DrawBox 20,754, 270, 80
'end PAYMENTS
'CUST SIG
DrawBox 310,754, 270, 80
'end CUST SIG


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
PDF.AddHTMLPos 25, 262, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
PDF.AddHTMLPos 25, 342, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
PDF.AddHTMLPos 25, 402, "<img src=""images/whitebg.png"" width=""132"" height=""16"">"
PDF.AddHTMLPos 25, 500, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
PDF.AddHTMLPos 25, 600, "<img src=""images/whitebg.png"" width=""230"" height=""16"">"
PDF.AddHTMLPos 25, 753, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
PDF.AddHTMLPos 315, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"

PDF.AddTextPos 33, 97, "Client Details"
PDF.AddTextPos 33, 199, "Mattress"
PDF.AddTextPos 33, 271, "Base"
PDF.AddTextPos 33, 352, "Topper"
PDF.AddTextPos 33, 410, "Upholstery Options"
PDF.AddTextPos 33, 508, "Headboard"
PDF.AddTextPos 33, 608, "Order Summary - Order No." & rs("order_number")
PDF.AddTextPos 33, 757, "Payments"

PDF.AddTextPos 323, 757, "Customer's Signature"

PDF.AddTextPos 223, 97, "Invoice Address"
PDF.AddTextPos 413, 97, "Delivery Address"
PDF.SetFont "F15", 8, "#999"

'MATTRESS REQ'
If rs("mattressrequired")="y" then
	PDF.AddHTMLPos 33, 200, "<font family=""Tahoma""><font size=""8""><b>Model:</b></font></font>"
	PDF.AddHTMLPos 63, 200, "<font family=""Tahoma""><font size=""8"">" & rs("savoirmodel") & "</font></font>"
	PDF.AddHTMLPos 100, 200, "<font family=""Tahoma""><font size=""8""><b>Type:</b></font></font>"
	PDF.AddHTMLPos 123, 200, "<font family=""Tahoma""><font size=""8"">" & rs("mattresstype") & "</font></font>"
	PDF.AddHTMLPos 225, 200, "<font family=""Tahoma""><font size=""8""><b>Width:</b></font></font>"
	PDF.AddHTMLPos 252, 200, "<font family=""Tahoma""><font size=""8"">" & rs("mattresswidth") & "</font></font>"
	PDF.AddHTMLPos 345, 200, "<font family=""Tahoma""><font size=""8""><b>Length:</b></font></font>"
	PDF.AddHTMLPos 377, 200, "<font family=""Tahoma""><font size=""8"">" & rs("mattresslength") & "</font></font>"
	PDF.AddHTMLPos 470, 200, "<font family=""Tahoma""><font size=""8""><b>Ticking:</b></font></font>"
	PDF.AddHTMLPos 502, 200, "<font family=""Tahoma""><font size=""8"">" & rs("tickingoptions") & "</font></font>"
	
	PDF.AddHTMLPos 33, 212, "<font family=""Tahoma""><font size=""8""><b>LHS:</b></font></font>"
	PDF.AddHTMLPos 55, 212, "<font family=""Tahoma""><font size=""8"">" & rs("leftsupport") & "</font></font>"
	PDF.AddHTMLPos 100, 212, "<font family=""Tahoma""><font size=""8""><b>RHS:</b></font></font>"
	PDF.AddHTMLPos 125, 212, "<font family=""Tahoma""><font size=""8"">" & rs("rightsupport") & "</font></font>"
	PDF.AddHTMLPos 225, 212, "<font family=""Tahoma""><font size=""8""><b>Vent Position:</b></font></font>"
	PDF.AddHTMLPos 281, 212, "<font family=""Tahoma""><font size=""8"">" & rs("ventposition") & "</font></font>"
	PDF.AddHTMLPos 345, 212, "<font family=""Tahoma""><font size=""8""><b>Vent Finish:</b></font></font>"
	PDF.AddHTMLPos 394, 212, "<font family=""Tahoma""><font size=""8"">" & rs("ventfinish") & "</font></font>"
	
	PDF.AddHTMLPos 534, 234, "<font family=""Tahoma""><font size=""8""><b>PRICE:</b></font></font>"
	PDF.AddHTMLPos 534, 244, "<font family=""Tahoma""><font size=""8"">" & getCurrencySymbolForCurrency(rs("ordercurrency")) & " " & rs("mattressprice") & "</font></font>"
		If rs("mattressinstructions")<>"" then
		str=rs("mattressinstructions")
		PDF.SetFont "F15", 6, "#999"
		PDF.SetProperty csPropAddTextWidth , 2
		PDF.AddTextWidth 33,236,490, str
		end if
end if
'MATTRESS REQ END

'BASE REQ
If rs("baserequired")="y" then
PDF.AddHTMLPos 33, 271, "<font family=""Tahoma""><font size=""8""><b>Model:</b></font></font>"
PDF.AddHTMLPos 63, 271, "<font family=""Tahoma""><font size=""8"">" & rs("basesavoirmodel") & "</font></font>"
PDF.AddHTMLPos 100, 271, "<font family=""Tahoma""><font size=""8""><b>Type:</b></font></font>"
PDF.AddHTMLPos 123, 271, "<font family=""Tahoma""><font size=""8"">" & rs("basetype") & "</font></font>"
PDF.AddHTMLPos 225, 271, "<font family=""Tahoma""><font size=""8""><b>Width:</b></font></font>"
PDF.AddHTMLPos 252, 271, "<font family=""Tahoma""><font size=""8"">" & rs("basewidth") & "</font></font>"
PDF.AddHTMLPos 410, 271, "<font family=""Tahoma""><font size=""8""><b>Length:</b></font></font>"
PDF.AddHTMLPos 442, 271, "<font family=""Tahoma""><font size=""8"">" & rs("baselength") & "</font></font>"

PDF.AddHTMLPos 33, 283, "<font family=""Tahoma""><font size=""8""><b>Leg Style:</b></font></font>"
PDF.AddHTMLPos 75, 283, "<font family=""Tahoma""><font size=""8"">" & rs("legstyle") & "</font></font>"
PDF.AddHTMLPos 225, 283, "<font family=""Tahoma""><font size=""8""><b>Leg Finish:</b></font></font>"
PDF.AddHTMLPos 271, 283, "<font family=""Tahoma""><font size=""8"">" & rs("legfinish") & "</font></font>"
PDF.AddHTMLPos 410, 283, "<font family=""Tahoma""><font size=""8""><b>Leg Height:</b></font></font>"
PDF.AddHTMLPos 457, 283, "<font family=""Tahoma""><font size=""8"">" & rs("legheight") & "</font></font>"
PDF.AddHTMLPos 33, 295, "<font family=""Tahoma""><font size=""8""><b>Link Position:</b></font></font>"
PDF.AddHTMLPos 88, 295, "<font family=""Tahoma""><font size=""8"">" & rs("linkposition") & "</font></font>"
PDF.AddHTMLPos 225, 295, "<font family=""Tahoma""><font size=""8""><b>Link Finish:</b></font></font>"
PDF.AddHTMLPos 272, 295, "<font family=""Tahoma""><font size=""8"">" & rs("linkfinish") & "</font></font>"

PDF.AddHTMLPos 534, 315, "<font family=""Tahoma""><font size=""8""><b>PRICE:</b></font></font>"
If rs("legprice")<>"" and CDbl(rs("legprice"))>0.0 then
baseprice=CDbl(rs("baseprice"))+CDbl(rs("legprice"))
end if
PDF.AddHTMLPos 534, 325, "<font family=""Tahoma""><font size=""8"">" & getCurrencySymbolForCurrency(rs("ordercurrency")) & " " & baseprice & "</font></font>"
	If rs("baseinstructions")<>"" then
	str2=rs("baseinstructions")
	PDF.SetFont "F15", 6, "#999"
	PDF.SetProperty csPropAddTextWidth , 2
	PDF.AddTextWidth 33,317,490, str2
	end if
end if
'BASE REQ END

'IF TOPPER REQ
If rs("topperrequired")="y" then
PDF.AddHTMLPos 33, 353, "<font family=""Tahoma""><font size=""8""><b>Model:</b></font></font>"
PDF.AddHTMLPos 60, 353, "<font family=""Tahoma""><font size=""8"">" & rs("toppertype") & "</font></font>"
PDF.AddHTMLPos 120, 353, "<font family=""Tahoma""><font size=""8""><b>Width:</b></font></font>"
PDF.AddHTMLPos 146, 353, "<font family=""Tahoma""><font size=""8"">" & rs("topperwidth") & "</font></font>"
PDF.AddHTMLPos 255, 353, "<font family=""Tahoma""><font size=""8""><b>Length:</b></font></font>"
PDF.AddHTMLPos 285, 353, "<font family=""Tahoma""><font size=""8"">" & rs("topperlength") & "</font></font>"
PDF.AddHTMLPos 410, 353, "<font family=""Tahoma""><font size=""8""><b>Ticking:</b></font></font>"
PDF.AddHTMLPos 442, 353, "<font family=""Tahoma""><font size=""8"">" & rs("toppertickingoptions") & "</font></font>"
PDF.AddHTMLPos 534, 372, "<font family=""Tahoma""><font size=""8""><b>PRICE:</b></font></font>"
PDF.AddHTMLPos 534, 382, "<font family=""Tahoma""><font size=""8"">" & getCurrencySymbolForCurrency(rs("ordercurrency")) & " " & rs("topperprice") & "</font></font>"
	If rs("specialinstructionstopper")<>"" then
	str3=rs("specialinstructionstopper")
	PDF.SetFont "F15", 6, "#999"
	PDF.SetProperty csPropAddTextWidth , 2
	PDF.AddTextWidth 33,376,490, str3
	end if
end if
'TOPPER REQ END

'base upholstery options
'if rs("baserequired")="y" then
PDF.AddHTMLPos 33, 411, "<font family=""Tahoma""><font size=""8""><b>Upholstered Base:</b></font></font>"
PDF.AddHTMLPos 105, 411, "<font family=""Tahoma""><font size=""8"">" & rs("upholsteredbase") & "</font></font>"
'end if
'end base upholstery options

'VALANCE REQ
If rs("valancerequired")="y" then 
	valreq="Yes"
	basevalanceprice=CDbl(rs("valanceprice"))
	else 
	valreq="No"
end if

'VALANCE REQ ENTERED WHETHER YES OR NO
PDF.AddHTMLPos 220, 411, "<font family=""Tahoma""><font size=""8""><b>Valance:</b></font></font>"
PDF.AddHTMLPos 253, 411, "<font family=""Tahoma""><font size=""8"">" & valreq & "</font></font>"
'END VALANCE REQ ENTERED WHETHER YES OR NO

'VALANCE REQUIRED
If rs("valancerequired")="y" then
	PDF.AddHTMLPos 355, 411, "<font family=""Tahoma""><font size=""8""><b>No. of Pleats:</b></font></font>"
	PDF.AddHTMLPos 407, 411, "<font family=""Tahoma""><font size=""8"">" & rs("pleats") & "</font></font>"
	If rs("specialinstructionsvalance")<>"" then
	str4=rs("specialinstructionsvalance")
	PDF.SetFont "F15", 6, "#999"
	PDF.SetProperty csPropAddTextWidth , 2
	PDF.AddTextWidth 33,434,490, str4
	end if
	PDF.AddHTMLPos 534, 430, "<font family=""Tahoma""><font size=""8""><b>PRICE:</b></font></font>"
END IF

'IF BASE REQUIRED REQUIRED THEN UPHOLSTERY PRICES NEED SUMMING
if rs("baserequired")="y" then
	If rs("upholsteryprice")<>"" and CDbl(rs("upholsteryprice"))>0.0 then
	basevalanceprice=basevalanceprice + CDbl(rs("upholsteryprice"))
	end if
	PDF.AddHTMLPos 534, 442, "<font family=""Tahoma""><font size=""8"">" & getCurrencySymbolForCurrency(rs("ordercurrency")) & " " & basevalanceprice & "</font></font>"
end if
'END IF BASE REQUIRED OR VALANCE REQUIRED THEN UPHOLSTERY PRICES NEED SUMMING

If rs("valancefabric")<>"" and rs("valancerequired")="y" then
PDF.AddHTMLPos 33, 451, "<font family=""Tahoma""><font size=""8""><b>Fabric Selection:</b></font></font>"
PDF.AddHTMLPos 99, 451, "<font family=""Tahoma""><font size=""8"">" & rs("valancefabric") & "</font></font>"
PDF.AddHTMLPos 220, 451, "<font family=""Tahoma""><font size=""8""><b>Description:</b></font></font>"
PDF.AddHTMLPos 268, 451, "<font family=""Tahoma""><font size=""8"">" & rs("valancefabricchoice") & "</font></font>"
PDF.AddHTMLPos 428, 451, "<font family=""Tahoma""><font size=""8""><b>Direction:</b></font></font>"
PDF.AddHTMLPos 466, 451, "<font family=""Tahoma""><font size=""8"">" & rs("valancefabricdirection") & "</font></font>"
end if
If rs("basefabric")<>"" and rs("baserequired")="y" then
PDF.AddHTMLPos 33, 451, "<font family=""Tahoma""><font size=""8""><b>Fabric Selection:</b></font></font>"
PDF.AddHTMLPos 99, 451, "<font family=""Tahoma""><font size=""8"">" & rs("basefabric") & "</font></font>"
PDF.AddHTMLPos 220, 451, "<font family=""Tahoma""><font size=""8""><b>Description:</b></font></font>"
PDF.AddHTMLPos 268, 451, "<font family=""Tahoma""><font size=""8"">" & rs("basefabricchoice") & "</font></font>"
PDF.AddHTMLPos 428, 451, "<font family=""Tahoma""><font size=""8""><b>Direction:</b></font></font>"
PDF.AddHTMLPos 466, 451, "<font family=""Tahoma""><font size=""8"">" & rs("basefabricdirection") & "</font></font>"
end if
if rs("valancerequired")="y" then upholsterysum=upholsterysum + Cdbl(rs("valfabricprice"))

if rs("baserequired")="y" then
if rs("basefabricprice")<>"" and Cdbl(rs("basefabricprice"))>0.0 then upholsterysum=upholsterysum + Cdbl(rs("basefabricprice"))
end if 
if upholsterysum<>"" then
PDF.AddHTMLPos 534, 470, "<font family=""Tahoma""><font size=""8""><b>PRICE:</b></font></font>"
PDF.AddHTMLPos 534, 482, "<font family=""Tahoma""><font size=""8"">" & getCurrencySymbolForCurrency(rs("ordercurrency")) & " " & upholsterysum & "</font></font>"
end if
if rs("valancerequired")="y" then
str4=rs("specialinstructionsvalance")
end if
'end upholstery options
'headboard options
if rs("headboardrequired")="y" then 
PDF.AddHTMLPos 33, 510, "<font family=""Tahoma""><font size=""8""><b>Style:</b></font></font>"
PDF.AddHTMLPos 57, 510, "<font family=""Tahoma""><font size=""8"">" & rs("headboardstyle") & "</font></font>"
PDF.AddHTMLPos 220, 510, "<font family=""Tahoma""><font size=""8""><b>Finish:</b></font></font>"
PDF.AddHTMLPos 250, 510, "<font family=""Tahoma""><font size=""8"">" & rs("headboardfinish") & "</font></font>"
PDF.AddHTMLPos 355, 510, "<font family=""Tahoma""><font size=""8""><b>Height:</b></font></font>"
PDF.AddHTMLPos 387, 510, "<font family=""Tahoma""><font size=""8"">" & rs("headboardheight") & "</font></font>"
PDF.AddHTMLPos 534, 530, "<font family=""Tahoma""><font size=""8""><b>PRICE:</b></font></font>"
PDF.AddHTMLPos 534, 541, "<font family=""Tahoma""><font size=""8"">" & getCurrencySymbolForCurrency(rs("ordercurrency")) & " " & rs("headboardprice") & "</font></font>"
If rs("specialinstructionsheadboard")<>"" then
str5=rs("specialinstructionsheadboard")
PDF.SetFont "F15", 6, "#999"
PDF.SetProperty csPropAddTextWidth , 2
PDF.AddTextWidth 33,535,490, str5
end if	
PDF.AddHTMLPos 33, 551, "<font family=""Tahoma""><font size=""8""><b>Fabric Selection:</b></font></font>"
PDF.AddHTMLPos 99, 551, "<font family=""Tahoma""><font size=""8"">" & rs("headboardfabricchoice") & "</font></font>"
PDF.AddHTMLPos 220, 551, "<font family=""Tahoma""><font size=""8""><b>Description:</b></font></font>"
PDF.AddHTMLPos 268, 551, "<font family=""Tahoma""><font size=""8"">" & rs("headboardfabricdesc") & "</font></font>"
PDF.AddHTMLPos 428, 551, "<font family=""Tahoma""><font size=""8""><b>Direction:</b></font></font>"
PDF.AddHTMLPos 466, 551, "<font family=""Tahoma""><font size=""8"">" & rs("headboardfabricdirection") & "</font></font>"
PDF.AddHTMLPos 534, 568, "<font family=""Tahoma""><font size=""8""><b>PRICE:</b></font></font>"
PDF.AddHTMLPos 534, 579, "<font family=""Tahoma""><font size=""8"">" & getCurrencySymbolForCurrency(rs("ordercurrency")) & " " & rs("hbfabricprice") & "</font></font>"
If rs("hbfabricprice")<>"" and CDbl(rs("hbfabricprice"))>0.0 then upholsterysum=Cdbl(upholsterysum)+Cdbl(rs("hbfabricprice"))
If basevalanceprice<>"" then upholsterysum=upholsterysum+basevalanceprice
If rs("headboardfabricdesc")<>"" then
str6=rs("headboardfabricdesc")
PDF.SetFont "F15", 6, "#999"
PDF.SetProperty csPropAddTextWidth , 2
PDF.AddTextWidth 33,575,490, str6
end if
end if
PDF.SetFont "F15", 8, "#999"
sumtbl="<font family=""Tahoma""><font size=""8""><table width=""260"" align=""left"">" 
sumtbl=sumtbl & "<tr>"
If rs("mattressrequired")="y" then
	If rs("mattressprice")<>"" and NOT ISNULL(rs("mattressprice")) then
		sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Mattress</td><td width=25 align=""right"">" & fmtCurr2(rs("mattressprice"), true, rs("ordercurrency")) & "</td></tr>"	
	end if
end if
If rs("baserequired")="y" then
	If baseprice<>"" then
sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Base</td><td width=25 align=""right"">" & fmtCurr2(baseprice, true, rs("ordercurrency")) & "</td></tr>"
	end if	
end if


If rs("discount")<>"" AND CDbl(rs("discount"))>0.0 then
If rs("discounttype")="percent" then discountamt=CDbl(rs("bedsettotal"))*(CDbl(rs("discount"))/100)
If rs("accessoriesrequired")="y" and rs("accessoriestotalcost")<>"" and CDbl(rs("accessoriestotalcost"))>0.0 then 
sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Accessories (see next page for details)</td><td width=25 align=""right""><b>" & fmtCurr2(rs("accessoriestotalcost"), true, rs("ordercurrency")) & "</b></td></tr>"	
end if
If rs("discounttype")="currency" then discountamt=CDbl(rs("discount"))
sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Discount</td><td width=25 align=""right"">" & fmtCurr2(discountamt, true, rs("ordercurrency")) & "</td></tr>"	
end if

	If rs("tradediscount")<>"" and NOT ISNULL(rs("tradediscount")) then
	If  CDbl(rs("tradediscount"))>0.0 then sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Trade Discount</td><td width=25 align=""right"">" & fmtCurr2(rs("tradediscount"), true, rs("ordercurrency")) & "</td></tr>"	
	end if 

sumtbl=sumtbl & "<tr><td width=10></td><td width=215><b>Sub Total</b></td><td width=25 align=""right"">" & fmtCurr2(rs("subtotal"), true, rs("ordercurrency")) & "</td></tr>"	
if rs("deliverycharge")="y" then
sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Delivery Charge</td><td width=25 align=""right"">" & fmtCurr2(rs("deliveryprice"), true, rs("ordercurrency")) & "</td></tr>"
end if

sumtbl=sumtbl & "<tr><td width=10></td><td width=215><b>TOTAL</b></td><td width=25 align=""right""><b>" & fmtCurr2(rs("total"), true, rs("ordercurrency")) & "</b></td></tr>"
sumtbl=sumtbl & "</table></font>"

PDF.AddHTMLPos 33, 601, sumtbl


PDF.AddHTMLPos 320, 609, "<b>DELIVERY DATE:</b>"
If rs("bookeddeliverydate")<>"" then
PDF.AddTextPos 490, 618, rs("deliverydate")
else
	if day(rs("deliverydate"))=15 then deltxt="Approx middle of " & monthname(month(rs("deliverydate"))) & " " & year(rs("deliverydate"))
	if day(rs("deliverydate"))=5 then deltxt="Approx beginning of " & monthname(month(rs("deliverydate"))) & " " & year(rs("deliverydate"))
	if day(rs("deliverydate"))=25 then deltxt="Approx end of " & monthname(month(rs("deliverydate"))) & " " & year(rs("deliverydate"))
PDF.AddTextPos 450, 618, deltxt
end if

PDF.AddTextPos 320, 633, "Dispose of old bed:"
PDF.AddTextPos 490, 633, rs("oldbed")
PDF.AddTextPos 320, 644, "Access Check:"
PDF.AddTextPos 490, 644, rs("accesscheck")
PDF.AddTextPos 320, 655, "Floor Type:"
PDF.SetProperty csPropAddTextWidth , 2
PDF.AddTextWidth 310,730,280, "I have read and understood the terms and conditions on the reverse of this order form and accept them in full."

paymentSum = 0.0
     if ubound(payments) > 0 then
	 str7="<table width=""260"" align=""left"">" 
	 str7=str7 & "<tr><td></td><td><b>Type</b></td><td><b>Method</b></td><td><b>Receipt&nbsp;No.</b></td><td align=""right""><b>Amount</b></td></tr>"   
	     for n = 1 to ubound(payments)
		     paymentSum = paymentSum + payments(n).amount
		     
		    str7=str7 & "<tr><td width=10></td><td width=90><font family=""Tahoma""><font size=""8"">"
		     str7=str7 & payments(n).paymentType
			 str7=str7 & "</td><td width=70>"
		     str7=str7 & payments(n).paymentMethod
			 str7=str7 & "</td><td width=50>"
		     str7=str7 & payments(n).receiptNo
			 str7=str7 & "</td><td align=""right"" width=28>"
		     str7=str7 & fmtCurr2(abs(payments(n).amount), true, orderCurrency)
			 str7=str7 & "</td></tr>"
		     
	     next
	str7=str7 & "<tr><td></td><td colspan=""3""><b>Outstanding Balance</b></td><td align=""right"">" & "<b>" & fmtCurr2(rs("balanceoutstanding"), true, rs("ordercurrency")) & "</b></td></tr></table>"
	str7=str7 & "</table>"
end if

PDF.AddHTMLPos 53, 748, str7
PDF.AddTextPos 320, 828, "...................................................................................... Date: " & date()
PDF.AddPage
PDF.SetFont "F1", 8, "#000000"
termstext=replace(termstext, "<p>", "<div style=""font-size:7px;"">")
termstext=replace(termstext, "</p>", "<br><br></div>")
termstext=replace(termstext, "<p align=""center"">", "<div align=""center"">")
termstext=termstext
PDF.AddHTML termstext

if rs("accessoriesrequired")="y" then
PDF.AddPage
DrawBox 20,96, 180, 95
DrawBox 210,96, 180, 95
DrawBox 400,96, 180, 95

DrawBox 20,200, 560, 465

'CUST SIG
DrawBox 310,754, 270, 80
'end CUST SIG

PDF.SetFont "F15", 12, "#999"
PDF.AddHTML "<p align=""right""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
PDF.AddTextPos 20, 20, "Order No. " & rs("order_number")
PDF.SetFont "F15", 10, "#999"
PDF.AddTextPos 20, 40, "Order Date. " & FormatDateTime(rs("order_date"),vbShortDate)
PDF.AddTextPos 20, 60, "Savoir Contact: " & contact
PDF.AddTextPos 20, 80, "Showroom: " & showroomaddress
PDF.AddHTML "<hr>"
PDF.AddHTML s

PDF.AddHTMLPos 25, 92, "<img src=""images/whitebg.png"" width=""95"" height=""16"">"
PDF.AddHTMLPos 215, 92, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 405, 92, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 25, 192, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"


PDF.AddTextPos 33, 101, "Client Details"
PDF.AddTextPos 223, 101, "Invoice Address"
PDF.AddTextPos 413, 101, "Delivery Address"
PDF.AddTextPos 33, 205, "Accessories"



PDF.AddHTML xacc

PDF.AddHTMLPos 315, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"
PDF.AddTextPos 323, 757, "Customer's Signature"
PDF.AddTextPos 320, 828, "....................................................... Date: " & date()
'end if
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
