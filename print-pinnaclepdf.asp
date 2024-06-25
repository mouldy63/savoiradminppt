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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, str8, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, ademail, aw, x, str18, baseupholsteryprice
Dim matt1width, matt2width, matt1length, matt2length, base1width, base2width, base1length, base2length, topper1width, topper1length, basewidthstring, mattwidthstring, mattwidthstring2,basewidthstring2, topperwidthstring, speciallegheight, savoirterms, basetotal, hbtotal, pnarray()
hbtotal=0
basetotal=0
savoirterms="Savoir Beds Ltd standard terms and conditions apply.  All goods remain the property of Savoir Beds Ltd until payment is received in full."
speciallegheight=""
aw="n"
aw=request("aw")
dim purchase_no, i, paymentSum, payments, n, displayterms, orderCurrency, upholsterysum, deltxt
displayterms=""
quote=Request("quote")
custname=""
msg=""
orderno=request("val")
localeref=retrieveuserregion()
Set Con = getMysqlConnection()
If retrieveuserregion()=1 then
	Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=1", con)
else
	Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
end if
	termstext=rs("terms")
	rs.close
	set rs=nothing
sql="Select * from purchase WHERE order_number=" & orderno

Set rs = getMysqlQueryRecordSet(sql, con)
redim pnarray(rs.recordcount)
rownum=1
Do until rs.eof
pnarray(rownum)=rs("purchase_no")
rownum=rownum+1
rs.movenext
loop
rs.close
set rs=nothing

sql="Select * from region WHERE id_region=" & localeref
response.Write("sql=" & sql)
response.End()	
Set rs = getMysqlQueryRecordSet(sql, con)

Session.LCID = rs("locale")
rs.close
set rs=nothing
Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
displayterms=rs("terms")
rs.close
set rs=nothing

Set rs = getMysqlQueryRecordSet("Select * from savoir_user where user_id=" & retrieveuserid(), con)
ademail=rs("adminemail")
rs.close
set rs=nothing

'purchase_no=Request("val")


selcted=""
count=0
order=""
submit=""




Set rs = getMysqlQueryRecordSet("Select * from purchase WHERE purchase_no=" & pnarray(1) & "", con)
purchase_no=rs("purchase_no")

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
if showroomaddress<>"" then showroomaddress=left(showroomaddress, len(showroomaddress)-2)
If rs2("tel")<>"" then showroomaddress=showroomaddress & "&nbsp;&nbsp;Tel: " & rs2("tel")
If ademail<>"" then showroomaddress=showroomaddress & "&nbsp;&nbsp;Email: " &ademail
rs2.close
set rs2=nothing
Set rs2 = getMysqlQueryRecordSet("Select * from savoir_user WHERE username like '" & rs("salesusername") & "'", con)
orderCurrency = rs("ordercurrency")
contact = rs2("name")
rs2.close
set rs2=nothing

payments = getPaymentsForOrder(purchase_no, con)

Set rs1 = getMysqlQueryRecordSet("Select * from contact WHERE code=" & rs("code") & "", con)
Set rs2 = getMysqlQueryRecordSet("Select * from address WHERE code=" & rs1("code") & "", con)

signature = rs("signature")

If rs1("title") <> "" Then custname=custname & Utf8ToUnicode(capitalise(lcase(rs1("title")))) & " "
If rs1("first") <> "" Then custname=custname & Utf8ToUnicode(capitalise(lcase(rs1("first")))) & " "
If rs1("surname") <> "" Then custname=custname & Utf8ToUnicode(capitalise(lcase(rs1("surname"))))
clienthdg="<font family=""Tahoma""><font size=""8"">"
clienthdg=clienthdg & "Client: <br />"
clienthdg=clienthdg & "Company: <br />"
if rs1("company_vat_no")<>"" then clienthdg=clienthdg & "VAT No: <br />"
clienthdg=clienthdg & "Home Tel: <br />"
clienthdg=clienthdg & "Work Tel: <br />"
clienthdg=clienthdg & "Mobile: <br />"
clienthdg=clienthdg & "Email: <br />"
clienthdg=clienthdg & "Client Ref: <br />"
clienthdg=clienthdg & "</font></font>"

clientdetails="<font family=""Tahoma""><font size=""9""><b>"
clientdetails=clientdetails & custname & "&nbsp;</b><br /></font><font family=""Tahoma""><font size=""8""><b>"
clientdetails=clientdetails & Utf8ToUnicode(rs2("company")) & "&nbsp;<br />"
if rs1("company_vat_no")<>"" then clientdetails=clientdetails & rs1("company_vat_no") & "<br />"
clientdetails=clientdetails & rs2("tel") & "&nbsp;<br />"
clientdetails=clientdetails & rs1("telwork") & "&nbsp;<br />"
clientdetails=clientdetails & rs1("mobile") & "&nbsp;<br />"
clientdetails=clientdetails & rs2("email_address") & "&nbsp;<br />"
clientdetails=clientdetails & rs("customerreference") & "&nbsp;<br />"
clientdetails=clientdetails & "</font></font>"
custaddress="<font family=""Tahoma""><font size=""8"">"
If rs2("street1")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("street1")) & "<br />"
If rs2("street2")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("street2")) & "<br />"
If rs2("street3")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("street3")) & "<br />"
If rs2("town")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("town")) & "<br />"
If rs2("county")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("county")) & "<br />"
If rs2("postcode")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("postcode")) & "<br />"
If rs2("country")<>"" then custaddress=custaddress & Utf8ToUnicode(rs2("country"))
custaddress=custaddress & "</b></font></font>"
s = "<br><br><table cellpadding=""1""> "
s = s & " <tr height=""0""><td colspan=""7"" height=""0""></td></tr>"
s = s & " <tr><td width=""11"" height=""55""></td> "
s = s & " <td width=""54"" valign=""top"">" & clienthdg & "</td><td width=""112"" valign=""top"">" & clientdetails & "</td><td width=""24""></td><td width=""166""><b>" & custaddress & "</b></td><td width=""24""></td><td width=""166""><b>" & deliveryaddress & "</b></td> "
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
xacc="<table><tr><td width=""10"" height=""20""></td><td>Item&nbsp;Description</td><td>Design</td><td>Colour</td><td>Size</td><td align=""right"">Qty</td><td align=""right"">Unit&nbsp;Price</td><td align=""right"">Total</td></tr>"
if not rs3.eof then
 do until rs3.eof
xacc=xacc & "<tr ><td width=""10"" height=""20""></td>"
xacc=xacc & "<td width=""150""><b>" & rs3("description") & "</b></td>"
xacc=xacc & "<td width=""100""><b>" & rs3("design") & "</b></td>"
xacc=xacc & "<td width=""80""><b>" & rs3("colour") & "</b></td>"
xacc=xacc & "<td width=""80""><b>" & rs3("size") & "</b></td>"
xacc=xacc & "<td width=""40"" align=""right""><b>" & rs3("qty") & "</b></td>"
xacc=xacc & "<td width=""50"" align=""right""><b>" & fmtCurr2(rs3("unitprice"), true, rs("ordercurrency")) & "</b></td>"
if (rs3("unitprice")<>"" and CDbl(rs3("unitprice"))>0.0) then accesscost=rs3("qty")*CDbl(rs3("unitprice")) else accesscost=0
xacc=xacc & "<td width=""40"" align=""right""><b>" & fmtCurr2(accesscost, true, rs("ordercurrency")) & "</b></td>"
xacc=xacc & "</tr>"
xacc=xacc & "<tr><td></td><td colspan=""7""><hr style=""color:#eeeeee;""></td></tr>"
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

const csPropGraphLineColor=405
const csPropGraphZoom= 1
const csPropGraphWZoom= 50 
const csPropGraphHZoom= 50
const csPropTextFont  = 100
const csHTML_FontName=252
const csHTML_FontSize  = 253
const csPropGraphWL = 400


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

PDF.SetTrueTypeFont "F15", "Tahoma", 0, 0
PDF.SetProperty csPropParLeft, "20"
PDF.SetProperty csPropPosX, "20"
PDF.SetProperty csHTML_FontName, "F1"
PDF.SetProperty csHTML_FontSize, "8"
PDF.SetProperty csPropTextColor,"#999"
PDF.SetProperty csPropTextAlign, "0"
PDF.SetProperty csPropTextAlign, "0"

PDF.SetProperty csPropGraphWL, 0.5
PDF.SetFont "F15", 12, "#999"

'PDF.AddFormObj 0, 0, 2, 2, "form.button1", "", "", 0 
'PDF.AddEventObj 6, "form.button1", "app.alert(""please print off this form"");", "JavaScript" 
'start check whether just accessories ordered
'if rs("mattressrequired")="y" or rs("topperrequired")="y" or rs("baserequired")="y" or rs("headboardrequired")="y" or rs("valancerequired")="y" then accessoriesonly="n" else accessoriesonly="y"

'if accessoriesonly="n" then 

DrawBox 20,93, 180, 95
DrawBox 210,93, 180, 95

DrawBox 400,93, 180, 95





'ORDER SUMMARY
DrawBox 20,614, 270, 142
'end ORDER SUMMARY
'DELIVERY DETAILS
DrawBox 310,614, 270, 102
'end ORDER DELIVERY DETAILS
'PAYMENTS
DrawBox 20,764, 270, 70
'end PAYMENTS
'CUST SIG
if aw = "y" then
else
DrawBox 310,764, 270, 70
end if
'end CUST SIG


PDF.AddHTML "<p align=""right""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
PDF.AddTextPos 20, 20, "Order No. " & rs("order_number")
if aw="y" then
PDF.AddTextPos 220, 20, "ORDER CONFIRMATION"
end if
PDF.SetFont "F15", 10, "#999"
PDF.AddTextPos 20, 40, "Order Date. " & FormatDateTime(rs("order_date"),vbShortDate)
PDF.AddTextPos 20, 60, "Savoir Contact: " & contact
PDF.SetFont "F15", 9, "#999"
PDF.AddTextPos 20, 75, "Showroom: " & showroomaddress
PDF.AddHTML "<hr>"
PDF.AddHTMLPos 25, 74, s


PDF.AddHTMLPos 25, 85, "<img src=""images/whitebg.png"" width=""95"" height=""16"">"
PDF.AddHTMLPos 215, 85, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 405, 85, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"


PDF.AddHTMLPos 25, 600, "<img src=""images/whitebg.png"" width=""230"" height=""16"">"
PDF.AddHTMLPos 25, 753, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
PDF.AddHTMLPos 315, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"

PDF.AddTextPos 33, 97, "Client Details"

PDF.AddTextPos 33, 625, "Order Summary - Order No." & rs("order_number")
PDF.AddTextPos 33, 767, "Payments"
if aw = "y" then
else
PDF.AddTextPos 323, 767, "Customer's Signature"
end if

PDF.AddTextPos 223, 97, "Invoice Address"
PDF.AddTextPos 413, 97, "Delivery Address"
PDF.SetFont "F15", 8, "#999"
PDF.AddHTMLPos 30, 190, "<b>Your Ref:</b> " & rs("customerreference") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Bed Ref:</b> " & rs("pinnacleBedRef")       
PDF.AddHTMLPos 470, 190, "Unit Price"
PDF.AddHTMLPos 518, 190, "Qty"
PDF.AddHTMLPos 540, 190, "Total Price"
rs.close
set rs=nothing
x=215
'MATTRESS REQ'
for z=1 to ubound(pnarray)
If rs("mattressrequired")="y" then
sql="Select * from purchase WHERE Purchase_No=" & pnarray(z)
purchase_no=rs("purchase_no")
sql = "Select * from productionsizes where purchase_no = " & purchase_no
Set rs = getMysqlQueryRecordSet(sql, con)
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("matt1width")<>"" then matt1width=rs2("matt1width") else matt1width=""
if rs2("matt2width")<>"" then matt2width=rs2("matt2width") else matt2width=""
if rs2("matt1length")<>"" then matt1length=rs2("matt1length") else matt1length=""
if rs2("matt2length")<>"" then matt2length=rs2("matt2length") else matt2length=""
if rs2("base1width")<>"" then base1width=rs2("base1width") else base1width=""
if rs2("base2width")<>"" then base2width=rs2("base2width") else base2width=""
if rs2("base1length")<>"" then base1length=rs2("base1length") else base1length=""
if rs2("base2length")<>"" then base2length=rs2("base2length") else base2length=""
if rs2("topper1width")<>"" then topper1width=rs2("topper1width") else topper1width=""
if rs2("topper1length")<>"" then topper1length=rs2("topper1length") else topper1length=""
if rs2("legheight")<>"" then speciallegheight=rs2("legheight") else speciallegheight=""
end if
rs2.close
set rs2=nothing


PDF.SetProperty csPropGraphWL, 0.5
		PDF.AddLine 20, 202, 580, 202
		PDF.SetProperty csPropGraphLineColor, "black"
		
		PDF.AddHTMLPos 25, x-10, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
		PDF.AddHTMLPos 33, x-12, "<font family=""Tahoma""><font size=""8""><b>Mattress</b></font></font>"
			'PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8"">Model:</font></font>"
			PDF.SetFont "F15", 9, "#999"
			PDF.AddHTMLPos 110, x, "<font family=""Tahoma""><font size=""9""><b>" & rs("savoirmodel") & "</b></font></font>"
			PDF.SetFont "F15", 8, "#999"
			'PDF.AddHTMLPos 100, x, "<font family=""Tahoma""><font size=""8"">Type:</font></font>"
			PDF.AddHTMLPos 160, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("mattresstype") & "</b></font></font>"
			'PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8"">Size (w x l):</font></font>"
			if matt1width<>"" then mattwidthstring= matt1width & "cm x "
			if matt1width="" then mattwidthstring= rs("mattresswidth") & " x "
			if matt1length<>"" then mattwidthstring=mattwidthstring & matt1length & "cm. "
			if matt1length="" then mattwidthstring=mattwidthstring & rs("mattresslength") & ". "
			if matt2width<>"" then mattwidthstring2=mattwidthstring2 & matt2width & "cm x "
			if matt2length<>"" then mattwidthstring2=mattwidthstring2 & matt2length & "cm."
			
			PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8""><b>" & mattwidthstring & "</b></font></font>"
			if mattwidthstring2<>"" then
				PDF.AddHTMLPos 33, x+12, "<font family=""Tahoma""><font size=""8""><b>" & mattwidthstring2 & "</b></font></font>"
			end if
			PDF.AddHTMLPos 223, x, "<font family=""Tahoma""><font size=""8"">Left:</font></font>"
			PDF.AddHTMLPos 241, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("leftsupport") & "</b></font></font>"
			PDF.AddHTMLPos 292, x, "<font family=""Tahoma""><font size=""8"">Right:</font></font>"
			PDF.AddHTMLPos 315, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("rightsupport") & "</b></font></font>"
			PDF.AddHTMLPos 362, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("tickingoptions") & "</b></font></font>"
			PDF.SetProperty csHTML_FontSize, "6"
				If rs("mattressinstructions")<>"" then
				str= rs("mattressinstructions") 
				PDF.SetFont " F1 ", 6, " #000000"
			PDF.SetProperty csPropAddTextWidth , 2
			PDF.AddTextWidth 110,x+20,355, str
				end if

			If rs("mattressprice")<>"" and   NOT ISNULL(rs("mattressprice"))  then
			PDF.AddHTMLPos 470, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("mattunitprice"),2) & "</b></font></font>"
			PDF.AddHTMLPos 518, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("mattqty") & "</b></font></font>"
			PDF.AddHTMLPos 540, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("mattressprice"),2) & "</b></font></font>"
			else
			PDF.AddHTMLPos 540, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & "0.00</b></font></font>"
			end if
			
			x=x+35
end if
'MATTRESS REQ END
'BASE REQ

 
If rs("baserequired")="y" then
	PDF.AddLine 20, x, 580, x
		PDF.SetProperty csPropGraphLineColor, "black"
				
		PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8""><b>Base</b></font></font>"
	x=x+12
		PDF.AddHTMLPos 110, x, "<font family=""Tahoma""><font size=""9""><b>" & rs("basesavoirmodel") & "</b></font></font>"
		PDF.AddHTMLPos 180, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("basetype") & "</b></font></font>" 
		PDF.AddHTMLPos 260, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("basedepth") & "</b></font></font>" 
		PDF.AddHTMLPos 310, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("basetickingoptions") & "</b></font></font>"
		If rs("baseprice")<>"" and   NOT ISNULL(rs("baseprice"))  then
			PDF.AddHTMLPos 470, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("baseunitprice"),2) & "</b></font></font>"
			PDF.AddHTMLPos 518, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("baseqty") & "</b></font></font>"
			PDF.AddHTMLPos 540, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("baseprice"),2) & "</b></font></font>"
			basetotal=basetotal + CDbl(rs("baseprice"))
			else
			PDF.AddHTMLPos 540, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & "0.00</b></font></font>"
			end if
			if base1width<>"" then basewidthstring= base1width & "cm x "
			if base1width="" then basewidthstring= rs("basewidth") & " x "
			if base1length<>"" then basewidthstring=basewidthstring & base1length & "cm. "
			if base1length="" then basewidthstring=basewidthstring & rs("baselength") & ". "
			if base2width<>"" then basewidthstring2=basewidthstring2 & base2width & "cm x "
			if base2length<>"" then basewidthstring2=basewidthstring2 & base2length & "cm."
		PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8""><b>" & basewidthstring & "</b></font></font>"
		If rs("baseinstructions")<>"" then
			str2=rs("baseinstructions")
			PDF.SetFont " F1 ", 6, " #000000"
			PDF.SetProperty csPropAddTextWidth , 2
			PDF.AddTextWidth 110,x+20,355, str2
			end if
		if basewidthstring2<>"" then
			x=x+12
			PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8""><b>" & basewidthstring & "</b></font></font>"
		end if
		
		x=x+12
		PDF.AddLine 200, x, 580, x
		x=x+2
		PDF.AddHTMLPos 200, x, "<font family=""Tahoma""><font size=""8"">Leg Details:</font></font>"
		PDF.AddHTMLPos 300, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("legstyle") & "</b></font></font>"
		If rs("legprice")<>"" and   NOT ISNULL(rs("legprice"))  then
			PDF.AddHTMLPos 470, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("legunitprice"),2) & "</b></font></font>"
			PDF.AddHTMLPos 518, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("legqty") & "</b></font></font>"
			PDF.AddHTMLPos 540, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("legprice"),2) & "</b></font></font>"
			basetotal=basetotal + CDbl(rs("legprice"))
			else
			PDF.AddHTMLPos 540, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & "0.00</b></font></font>"
			end if
		x=x+12
		PDF.AddLine 200, x, 580, x
		x=x+2	
		if (rs("upholsteredbase") <> "n" and  Not isNull("upholsteredbase")) then
		
			PDF.AddHTMLPos 200, x, "<font family=""Tahoma""><font size=""8"">Upholstery Details:</font></font>"
			PDF.AddHTMLPos 390, x, "<font family=""Tahoma""><font size=""8"">Upholstery Charge</font></font>"
			If rs("upholsteryprice")<>"" and   NOT ISNULL(rs("upholsteryprice"))  then
				PDF.AddHTMLPos 470, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("uphunitprice"),2) & "</b></font></font>"
				PDF.AddHTMLPos 518, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("baseqty") & "</b></font></font>"
				PDF.AddHTMLPos 540, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("upholsteryprice"),2) & "</b></font></font>"
				basetotal=basetotal + CDbl(rs("upholsteryprice"))
			end if
		end if
			
		if rs("basefabricchoice")<>"" or rs("basefabricprice")<>"" or rs("basefabriccost")<>"" or rs("basefabricmeters")<>"" then
		x=x+12
		PDF.AddTextWidth 200,x+5,165, rs("basefabricchoice")
		'PDF.AddHTMLPos 200, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("basefabricchoice") &  " </b></font></font>"
		PDF.AddHTMLPos 390, x, "<font family=""Tahoma""><font size=""8"">Fabric Charge</font></font>"
		If rs("basefabricprice")<>"" and   NOT ISNULL(rs("basefabricprice"))  then
				PDF.AddHTMLPos 470, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("basefabriccost"),2) & "</b></font></font>"
				PDF.AddHTMLPos 518, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("basefabricmeters") & "</b></font></font>"
				PDF.AddHTMLPos 540, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("basefabricprice"),2) & "</b></font></font>"
				basetotal=basetotal + CDbl(rs("basefabricprice"))
			end if
		end if
		if rs("basefabricdirection")<>"" then
		x=x+15
		PDF.AddHTMLPos 200, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("basefabricdirection") & "</b></font></font>"
		end if
	x=x+13
	PDF.AddLine 200, x, 580, x
	if rs("basedrawerconfigID")<>"Not Required" or  NOT isNull(rs("basedrawerconfigID"))then	
		PDF.AddHTMLPos 200, x, "<font family=""Tahoma""><font size=""8"">Drawers:</font></font>"
		PDF.AddHTMLPos 300, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("basedrawerconfigID") & "</b></font></font>"
		If rs("drawerprice")<>"" and   NOT ISNULL(rs("drawerprice"))  then
				PDF.AddHTMLPos 470, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("drawerprice"),2) & "</b></font></font>"
				PDF.AddHTMLPos 518, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("drawerqty") & "</b></font></font>"
				PDF.AddHTMLPos 540, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("drawertotal"),2) & "</b></font></font>"
				basetotal=basetotal + CDbl(rs("drawertotal"))
			end if
		end if
		if (basetotal<>0)  then
	PDF.AddHTMLPos 540, x+13, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(basetotal,2) & "</b></font></font>"
		end if	
				
end if
'BASE REQ END
if rs("headboardrequired")="y" then 
x=x+22
PDF.AddLine 20, x, 580, x
PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8""><b>Headboard</b></font></font>"
	x=x+12
	PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""9""><b>" & rs("headboardstyle") & "</b></font></font>"
		If rs("specialinstructionsheadboard")<>"" then
		str5=rs("specialinstructionsheadboard")
		PDF.SetFont "F1", 6, "#000000"
		PDF.SetProperty csPropAddTextWidth , 2
		x=x+8
		PDF.AddTextWidth 150,x,305, str5
		end if	
	If rs("headboardprice")<>"" and   NOT ISNULL(rs("headboardprice"))  then
				PDF.AddHTMLPos 470, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("headboardUnitPrice"),2) & "</b></font></font>"
				PDF.AddHTMLPos 518, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("hbqty") & "</b></font></font>"
				PDF.AddHTMLPos 540, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("headboardprice"),2) & "</b></font></font>"
				hbtotal=hbtotal + CDbl(rs("headboardprice"))
			end if
	x=x+12
		PDF.AddLine 200, x, 580, x
		x=x+2
	PDF.AddHTMLPos 200, x, "<font family=""Tahoma""><font size=""8"">Fabric Details:</font></font>"
			PDF.AddHTMLPos 390, x, "<font family=""Tahoma""><font size=""8"">Fabric Charge</font></font>"
	If rs("hbfabricprice")<>"" and   NOT ISNULL(rs("hbfabricprice"))  then
				PDF.AddHTMLPos 470, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("hbfabriccost"),2) & "</b></font></font>"
				PDF.AddHTMLPos 518, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("hbfabricmeters") & "</b></font></font>"
				PDF.AddHTMLPos 540, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("hbfabricprice"),2) & "</b></font></font>"
				hbtotal=hbtotal + CDbl(rs("hbfabricprice"))
	end if
	x=x+15
	if rs("basefabricdirection")<>"" then
		
		PDF.AddHTMLPos 200, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("headboardfabricdirection") & "</b></font></font>"
		end if	
		
	If hbtotal<>0 then
	PDF.AddHTMLPos 540, x, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(hbtotal,2) & "</b></font></font>"
	end if
end if
'end headboard
next
'end of array loop
PDF.SetFont "F15", 8, "#999"
sumtbl="<font family=""Tahoma""><font size=""8""><table width=""260"" align=""left"">" 
sumtbl=sumtbl & "<tr>"
If rs("mattressrequired")="y" then
sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Mattress</td><td width=25 align=""right""><b>" & fmtCurr2(rs("mattressprice"), true, rs("ordercurrency")) & "</b></td></tr>"	
end if
If rs("baserequired")="y" then
sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Base</td><td width=25 align=""right""><b>" & fmtCurr2(baseprice, true, rs("ordercurrency")) & "</b></td></tr>"	
end if
If (upholsterysum<>0 and upholsterysum<>"") then
'valance fabric & valance price added together
sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Upholstery</td><td width=25 align=""right""><b>" & fmtCurr2(upholsterysum, true, rs("ordercurrency")) & "</b></td></tr>"	
end if
If rs("headboardrequired")="y" then
sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Headboard</td><td width=25 align=""right""><b>" & fmtCurr2(rs("headboardprice"), true, rs("ordercurrency")) & "</b></td></tr>"	
end if

'sumtbl=sumtbl & "<tr><td width=10></td><td width=215><b>Bed Set Total</b></td><td width=25 align=""right""><b>" & fmtCurr2(rs("bedsettotal"), true, rs("ordercurrency")) & "</b></td></tr>"	


If rs("accessoriesrequired")="y" then
	sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Accessories (see next page for details)</td><td width=25 align=""right""><b>" & fmtCurr2(rs("accessoriestotalcost"), true, rs("ordercurrency")) & "</b></td></tr>"	
end if
If rs("discount")<>"" and NOT ISNULL(rs("discount")) then
	If CDbl(rs("discount"))>0.0 then
		If rs("discounttype")="percent" then 
		discountamt=CDbl(rs("bedsettotal"))*(CDbl(rs("discount"))/100)
		sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Discount</td><td width=25 align=""right""><b>" & fmtCurr2(discountamt, true, rs("ordercurrency")) & "</b></td></tr>"
		end if
	end if
end if
If rs("discounttype")="currency" then 
	If rs("discount")<>"" and NOT ISNULL(rs("discount")) then
		If CDbl(rs("discount"))>0.0 then 
			discountamt=CDbl(rs("discount"))
			sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Discount</td><td width=25 align=""right""><b>" & fmtCurr2(discountamt, true, rs("ordercurrency")) & "</b></td></tr>"
		end if
	end if	
end if


 
if rs("deliverycharge")="y" then
	sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Delivery Charge</td><td width=25 align=""right""><b>" & fmtCurr2(rs("deliveryprice"), true, rs("ordercurrency")) & "</b></td></tr>"
end if

If rs("istrade")="y" then

	If rs("tradediscount")<>"" and NOT ISNULL(rs("tradediscount")) then
		If  CDbl(rs("tradediscount"))>0.0 then sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Trade Discount</td><td width=25 align=""right""></b>" & fmtCurr2(rs("tradediscount"), true, rs("ordercurrency")) & "</b></td></tr>"
	end if
	
	sumtbl=sumtbl & "<tr><td width=10></td><td width=215><b>Order Total, Ex VAT</b></td><td width=25 align=""right""><b>" & fmtCurr2(rs("subtotal"), true, rs("ordercurrency")) & "</b></td></tr>"
	
	If rs("vat")<>"" and NOT ISNULL(rs("vat")) then
		If  CDbl(rs("vat"))>0.0 then sumtbl=sumtbl & "<tr><td width=10></td><td width=215>VAT</td><td width=25 align=""right""><b>" & fmtCurr2(rs("vat"), true, rs("ordercurrency")) & "</b></td></tr>"	
	end if 
	sumtbl=sumtbl & "<tr><td width=10></td><td width=215><b>Order Total inc. VAT</b></td><td width=25 align=""right""><b>" & fmtCurr2(rs("total"), true, rs("ordercurrency")) & "</b></td></tr>"

else

If rs("totalexvat")<>"" and NOT ISNULL(rs("totalexvat")) then
	If  CDbl(rs("totalexvat"))>0.0 then sumtbl=sumtbl & "<tr><td width=10></td><td width=215>Total Ex. VAT</td><td width=25 align=""right""><b>" & fmtCurr2(rs("totalexvat"), true, rs("ordercurrency")) & "</b></td></tr>"	
end if 

If rs("vat")<>"" and NOT ISNULL(rs("vat")) then
	If  CDbl(rs("vat"))>0.0 then sumtbl=sumtbl & "<tr><td width=10></td><td width=215>VAT</td><td width=25 align=""right""><b>" & fmtCurr2(rs("vat"), true, rs("ordercurrency")) & "</b></td></tr>"	
end if 
sumtbl=sumtbl & "<tr><td width=10></td><td width=215><b>Order Total inc. VAT</b></td><td width=25 align=""right""><b>" & fmtCurr2(rs("total"), true, rs("ordercurrency")) & "</b></td></tr>"
end if
sumtbl=sumtbl & "</table></font>"

PDF.AddHTMLPos 33, 611, sumtbl


PDF.AddHTMLPos 320, 613, "<b>DELIVERY DATE:</b>"
PDF.SetFont "F15", 8, "#999"
If rs("bookeddeliverydate")<>"" then
	PDF.AddTextPos 490, 622, rs("bookeddeliverydate")
else
	if day(rs("deliverydate"))=15 then deltxt="Approx middle of " & monthname(month(rs("deliverydate"))) & " " & year(rs("deliverydate"))
	if day(rs("deliverydate"))=5 then deltxt="Approx beginning of " & monthname(month(rs("deliverydate"))) & " " & year(rs("deliverydate"))
	if day(rs("deliverydate"))=25 then deltxt="Approx end of " & monthname(month(rs("deliverydate"))) & " " & year(rs("deliverydate"))
PDF.AddHtmlPos 412, 613, "<b><font family=""Tahoma""><font size=""8"">" & deltxt & "</font></font></b>"
end if


PDF.SetProperty csPropAddTextWidth , 2
if aw="y" then
PDF.AddHtmlPos 310, 730, "<font size=""14""><b>Confirmation Code:  </b>" & rs("OrderConfirmationCode") & "</font>"
PDF.AddTextWidth 310, 790,280, savoirterms
else
PDF.AddTextWidth 310,730,280, "I have read and understood the terms and conditions on the reverse of this order form and accept them in full."
end if
paymentSum = 0.0
     if ubound(payments) > 0 then
	 str7="<table width=""250"" align=""left"">" 
	 str7=str7 & "<tr><td></td><td><b>Type</b></td><td><b>Method</b></td><td><b>Date</b></td><td><b>Receipt&nbsp;No.</b></td><td align=""right""><b>Amount</b></td></tr>"   
	     for n = 1 to ubound(payments)
		     paymentSum = paymentSum + payments(n).amount
		     
		    str7=str7 & "<tr><td width=10></td><td width=75><font family=""Tahoma""><font size=""8""><b>"
		     str7=str7 & payments(n).paymentType
			 str7=str7 & "</b></td><td width=50><b>"
		     str7=str7 & payments(n).paymentMethod
			 str7=str7 & "</b></td><td width=40><b>"
			 str7=str7 & left(payments(n).placed, 10)
			 str7=str7 & "</b></td><td width=7><b>"
		     str7=str7 & payments(n).receiptNo
			 str7=str7 & "</b></td><td align=""right"" width=8><b>"
		     str7=str7 & fmtCurr2(abs(payments(n).amount), true, orderCurrency)
			 str7=str7 & "</b></td></tr>"
		     
	     next
	str7=str7 & "<tr><td></td><td colspan=""4""><b>Outstanding Balance</b></td><td align=""right"">" & "<b>" & fmtCurr2(rs("balanceoutstanding"), true, rs("ordercurrency")) & "</b></td></tr></table>"
	str7=str7 & "</table>"
	end if

PDF.AddHTMLPos 53, 758, str7
if aw = "y" then
else
PDF.AddTextPos 320, 828, "........................................................... Date: " & date()
end if

if retrieveUserRegion()=1 then
PDF.AddPage
PDF.SetFont "F1", 8, "#000000"
termstext=replace(termstext, "<p>", "<div style=""font-size:7px;"">")
termstext=replace(termstext, "</p>", "<br><br></div>")
termstext=replace(termstext, "<p align=""center"">", "<div align=""center"">")
termstext=termstext
PDF.AddHTML termstext





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
end if
%>
<!-- #include file="common/logger-out.inc" -->
