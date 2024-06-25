<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionslegs, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, showroomtelemail, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, str8, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, ademail, ademail2, aw, x, str18, str118, baseupholsteryprice, legprice, basefabricdesc, headboardfabricdesc
Dim matt1width, matt2width, matt1length, matt2length, base1width, base2width, base1length, base2length, topper1width, topper1length, basewidthstring, mattwidthstring, topperwidthstring, speciallegheight, savoirterms, legtotal, NPage, P, OrderTotalExVAT, VATWording, OrderTotalIncVAT, nyx, lw1, lw2, wrap
quote=Request("quote")
Dim orderorquote
if quote="y" then 
orderorquote="Quote"
else
orderorquote="Order"
end if
Dim ordTotExVat
showroomtelemail=""



savoirterms="Savoir Beds Ltd standard terms and conditions apply.  All goods remain the property of Savoir Beds Ltd until payment is received in full."
speciallegheight=""
aw="n"
aw=request("aw")
dim purchase_no, i, paymentSum, payments, n, displayterms, orderCurrency, upholsterysum, deltxt
displayterms=""

custname=""
msg=""
localeref=retrieveuserregion()
Set Con = getMysqlConnection()
If retrieveuserregion()=1 then
Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=1", con)
else
Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
end if
				termstext=Utf8ToUnicode(rs("terms"))
rs.close
set rs=nothing
sql="Select * from region WHERE id_region=" & localeref
'REsponse.Write("sql=" & sql)	
Set rs = getMysqlUpdateRecordSet(sql, con)

Session.LCID = rs("locale")
rs.close
set rs=nothing
Set rs = getMysqlUpdateRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
displayterms=Utf8ToUnicode(rs("terms"))
rs.close
set rs=nothing

Set rs = getMysqlUpdateRecordSet("Select * from savoir_user where user_id=" & retrieveuserid(), con)
ademail=rs("adminemail")
rs.close
set rs=nothing

'purchase_no=Request("val")
purchase_no=CDbl(Request("val"))
selcted=""
count=0
order=""
submit=""

Set rs = getMysqlQueryRecordSet("Select * from purchase P, savoir_user S where P.purchase_no=" & purchase_no & " and P.salesusername like S.username", con)
if not rs.eof then
ademail2=rs("adminemail")
else
ademail2=""
end if
rs.close
set rs=nothing

payments = getPaymentsForOrder(purchase_no, con)

sql = "Select * from productionsizes where purchase_no = " & purchase_no
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
wrap=""
Set rs = getMysqlQueryRecordSet("Select W.pdfwrapname from wrappingtypes W, purchase P WHERE purchase_no=" & purchase_no & " and P.wrappingid=W.WrappingID", con)
if not rs.eof then
wrap=rs("pdfwrapname")
end if
rs.close
set rs=nothing
Set rs = getMysqlQueryRecordSet("Select * from purchase WHERE purchase_no=" & purchase_no & "", con)
'VAT wording
if rs("owning_region")=23 or rs("owning_region")=4 then

OrderTotalExVAT="Sub Total"
VATWording="Sales Tax"
OrderTotalIncVAT=orderorquote & " Total, Inc Sales Tax"
OrderTotalExVAT=orderorquote & " Total, Ex Sales Tax" 
else
OrderTotalExVAT=orderorquote & " Total, Ex VAT"
VATWording="VAT"
OrderTotalIncVAT=orderorquote & " Total inc. VAT"
end if


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
If rs2("tel")<>"" then showroomtelemail=showroomtelemail & "Tel: " & rs2("tel")
If ademail2<>"" then showroomtelemail=showroomtelemail & "&nbsp;&nbsp;Email: " &ademail2
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

If rs1("title") <> "" Then custname=custname & Utf8ToUnicode(capitaliseName(lcase(rs1("title")))) & " "
If rs1("first") <> "" Then custname=custname & Utf8ToUnicode(capitaliseName(rs1("first"))) & " "
If rs1("surname") <> "" Then custname=custname & Utf8ToUnicode(capitaliseName(rs1("surname")))
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
s = s & " <td width=""44"" valign=""top"">" & clienthdg & "</td><td width=""127"" valign=""top"">" & clientdetails & "</td><td width=""20""></td><td width=""166""><b>" & custaddress & "</b></td><td width=""24""></td><td width=""166""><b>" & deliveryaddress & "</b></td> "
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
xacc="<table><tr height=""10""><td width=""10"" height=""10""></td><td>Item&nbsp;Description</td><td>Design</td><td>Colour</td><td>Size</td><td align=""right"">Qty</td>"
if NOT userHasRoleInList("NOPRICESUSER") then
	xacc=xacc & "<td align=""right"">Unit&nbsp;Price</td><td align=""right"">Total</td>"
end if
xacc=xacc & "</tr>"
if not rs3.eof then
 do until rs3.eof
xacc=xacc & "<tr height=""0""><td width=""10"" height=1></td>"
xacc=xacc & "<td width=""130"" height=0><b><font size=8>" & rs3("description") & "</font></b></td>"
xacc=xacc & "<td width=""130"" align=top height=0><b><font size=8>" & rs3("design") & "</font></b></td>"
xacc=xacc & "<td width=""80"" height=0><b><font size=8>" & rs3("colour") & "</font></b></td>"
xacc=xacc & "<td width=""80"" height=0><b><font size=8>" & rs3("size") & "</font></b></td>"
xacc=xacc & "<td width=""40"" align=""right"" height=0><b><font size=8>" & rs3("qty") & "</font></b></td>"
if NOT userHasRoleInList("NOPRICESUSER") then
	xacc=xacc & "<td width=""50"" align=""right"" height=0><b><font size=8>" & fmtCurr2(rs3("unitprice"), true, rs("ordercurrency")) & "</font></b></td>"
	if (rs3("unitprice")<>"" and CDbl(rs3("unitprice"))>0.0) then accesscost=rs3("qty")*CDbl(rs3("unitprice")) else accesscost=0
	xacc=xacc & "<td width=""40"" align=""right"" height=0><b><font size=8>" & fmtCurr2(accesscost, true, rs("ordercurrency")) & "</font></b></td>"
end if
xacc=xacc & "</tr>"
'xacc=xacc & "<tr><td height=1></td>&nbsp;<td colspan=""7""></td></tr>"
xacc=xacc & "<tr><td height=0></td><td colspan=""7""><hr style=""color:#eeeeee;""></td></tr>"
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
const csHTML_FontName = 101
const csHTML_FontSize  = 102


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

'NPage = PDF.PageCount
'PDF.PageNumber = P
'PDF.AddTextPos 10, 10, " Page: " & P+1 & " of " & NPage + 1
'P=P+1
'PDF.AddFormObj 0, 0, 2, 2, "form.button1", "", "", 0 
'PDF.AddEventObj 6, "form.button1", "app.alert(""please print off this form"");", "JavaScript" 
'start check whether just accessories ordered
if rs("mattressrequired")="y" or rs("topperrequired")="y" or rs("baserequired")="y" or rs("legsrequired")="y" or rs("deliverycharge")="y" or rs("headboardrequired")="y" or rs("valancerequired")="y" then accessoriesonly="n" else accessoriesonly="y"
if accessoriesonly="n" then 

	DrawBox 20,93, 180, 95
	DrawBox 210,93, 180, 95

	DrawBox 400,93, 180, 95%>

	<!-- #include file="print-pdf-header.asp" -->
<%
	x=200
'MATTRESS REQ'
If rs("mattressrequired")="y" then
	If rs("mattressinstructions")<>"" then
		DrawBox 20,x-5, 560, 58
		PDF.SetProperty csPropGraphLineColor, "silver"
		DrawBox 25,x+29, 500, 18
		PDF.SetProperty csPropGraphLineColor, "black"
	else
		DrawBox 20,x-5, 560, 35
	end if
		
		
		PDF.AddHTMLPos 25, x-10, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
		PDF.AddHTMLPos 33, x-12, "<font family=""Tahoma""><font size=""8""><b>Mattress</b></font></font>"
			PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8"">Model:</font></font>"
			PDF.SetFont "F15", 9, "#999"
			PDF.AddHTMLPos 63, x, "<font family=""Tahoma""><font size=""9""><b>" & rs("savoirmodel") & "</b></font></font>"
			PDF.SetFont "F15", 8, "#999"
		
			PDF.AddHTMLPos 100, x, "<font family=""Tahoma""><font size=""8"">Type:</font></font>"
			PDF.AddHTMLPos 123, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("mattresstype") & "</b></font></font>"
			PDF.AddHTMLPos 225, x, "<font family=""Tahoma""><font size=""8"">Size (w x l):</font></font>"
			if matt1width<>"" then mattwidthstring= matt1width & "cm x "
			if matt1width="" then mattwidthstring= rs("mattresswidth") & " x "
			if matt1length<>"" then mattwidthstring=mattwidthstring & matt1length & "cm. "
			if matt1length="" then mattwidthstring=mattwidthstring & rs("mattresslength") & ". "
			if matt2width<>"" then mattwidthstring=mattwidthstring & matt2width & "cm x "
			if matt2length<>"" then mattwidthstring=mattwidthstring & matt2length & "cm."
			PDF.AddHTMLPos 272, x, "<font family=""Tahoma""><font size=""8""><b>" & mattwidthstring & "</b></font></font>"
			PDF.AddHTMLPos 410, x, "<font family=""Tahoma""><font size=""8"">Ticking:</font></font>"
			PDF.AddHTMLPos 442, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("tickingoptions") & "</b></font></font>"
			if NOT userHasRoleInList("NOPRICESUSER") then
				PDF.AddHTMLPos 534, x, "<font family=""Tahoma""><font size=""8"">PRICE:</font></font>"
				If rs("mattressprice")<>"" and   NOT ISNULL(rs("mattressprice"))  then
				PDF.AddHTMLPos 534, x+10, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("mattressprice"),2) & "</b></font></font>"
				else
				PDF.AddHTMLPos 534, x+10, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & "0.00</b></font></font>"
				end if
			end if
			PDF.AddHTMLPos 33, x+12, "<font family=""Tahoma""><font size=""8"">LHS:</font></font>"
			PDF.AddHTMLPos 55, x+12, "<font family=""Tahoma""><font size=""8""><b>" & rs("leftsupport") & "</b></font></font>"
			PDF.AddHTMLPos 100, x+12, "<font family=""Tahoma""><font size=""8"">RHS:</font></font>"
			PDF.AddHTMLPos 125, x+12, "<font family=""Tahoma""><font size=""8""><b>" & rs("rightsupport") & "</b></font></font>"
			PDF.AddHTMLPos 225, x+12, "<font family=""Tahoma""><font size=""8"">Vent Position:</font></font>"
			PDF.AddHTMLPos 281, x+12, "<font family=""Tahoma""><font size=""8""><b>" & rs("ventposition") & "</b></font></font>"
			PDF.AddHTMLPos 345, x+12, "<font family=""Tahoma""><font size=""8"">Vent Finish:</font></font>"
			PDF.AddHTMLPos 394, x+12, "<font family=""Tahoma""><font size=""8""><b>" & rs("ventfinish") & "</b></font></font>"
			
			
			
			PDF.SetProperty csHTML_FontSize, "6"
				If rs("mattressinstructions")<>"" then
				mattressinstructions=replace(rs("mattressinstructions"),CHR(13)," ")
					str= mattressinstructions
					PDF.SetFont " F1 ", 6, " #000000"
					PDF.SetProperty csPropAddTextWidth , 2
					PDF.AddTextWidth 33,x+37,490, str
					x=x+65
				else
					x=x+40
				end if
			
end if
'MATTRESS REQ END
'BASE REQ

 
If rs("baserequired")="y" then
		if (rs("upholsteredbase") <> "n" and  Not isNull("upholsteredbase")) then
			if (rs("upholsteryprice") <> "" and  Not isNull("upholsteryprice")) then 
					upholsterysum=upholsterysum + Cdbl(rs("upholsteryprice"))
					baseupholsteryprice=Cdbl(rs("upholsteryprice"))
			end if
			If rs("basefabricprice")<>"" and NOT ISNULL(rs("basefabricprice")) then
				if Cdbl(rs("basefabricprice"))>0.0 then upholsterysum=upholsterysum + Cdbl(rs("basefabricprice"))
				baseupholsteryprice=baseupholsteryprice + Cdbl(rs("basefabricprice"))
			end if
		end if
		
		if (rs("upholsteredbase") <> "n" and rs("upholsteredbase") <> "--" and  Not isNull(rs("upholsteredbase"))) then
				if rs("basefabricdesc")<>"" then y=23 else y=0
				If trim(rs("baseinstructions"))<>"" then
					y=89+y
					DrawBox 20,x-2, 560, y
					PDF.SetProperty csPropGraphLineColor, "silver"
					DrawBox 25,x+40, 500, 18
					if rs("basefabricdesc")<>"" then DrawBox 25,x+85, 500, 18
				else
					if rs("basefabricdesc")<>"" then 
						y=23 
						else 
						y=0
					end if
					y=63+y
					DrawBox 20,x-2, 560, y
					PDF.SetProperty csPropGraphLineColor, "silver"
					if rs("basefabricdesc")<>"" then DrawBox 25,x+63, 500, 18
				end if
			
		else
			If rs("baseinstructions")<>"" then
				DrawBox 20,x-2, 560, 67
				PDF.SetProperty csPropGraphLineColor, "silver"
				DrawBox 25,x+40, 500, 18
			else
				DrawBox 20,x-2, 560, 44
			end if
			
		end if
		PDF.SetProperty csPropGraphLineColor, "black"
		
		PDF.AddHTMLPos 25, x-8, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
		
		PDF.AddHTMLPos 33, x-10, "<font family=""Tahoma""><font size=""8""><b>Base</b></font></font>"
		PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8"">Model:</font></font>"
		PDF.AddHTMLPos 63, x, "<font family=""Tahoma""><font size=""9""><b>" & rs("basesavoirmodel") & "</b></font></font>"
		if left(rs("basesavoirmodel"),8)="Platform" then
			PDF.AddHTMLPos 128, x, "<font family=""Tahoma""><font size=""8"">Type:</font></font>"
		PDF.AddHTMLPos 151, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("basetype") & "</b></font></font>"

			else
			PDF.AddHTMLPos 100, x, "<font family=""Tahoma""><font size=""8"">Type:</font></font>"
			PDF.AddHTMLPos 123, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("basetype") & "</b></font></font>"
			end if
		PDF.AddHTMLPos 225, x, "<font family=""Tahoma""><font size=""8"">Size (w x l):</font></font>"
			if base1width<>"" then basewidthstring= base1width & "cm x "
			if base1width="" then basewidthstring= rs("basewidth") & " x "
			if base1length<>"" then basewidthstring=basewidthstring & base1length & "cm. "
			if base1length="" then basewidthstring=basewidthstring & rs("baselength") & ". "
			if base2width<>"" then basewidthstring=basewidthstring & base2width & "cm x "
			if base2length<>"" then basewidthstring=basewidthstring & base2length & "cm."
		PDF.AddHTMLPos 272, x, "<font family=""Tahoma""><font size=""8""><b>" & basewidthstring & "</b></font></font>"
		
		
		PDF.AddHTMLPos 410, x, "<font family=""Tahoma""><font size=""8"">Ticking:</font></font>"
		if rs("basetickingoptions")="n" then 
		PDF.AddHTMLPos 442, x, "<font family=""Tahoma""><font size=""8""><b>None</b></font></font>"
		else
		PDF.AddHTMLPos 442, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("basetickingoptions") & "</b></font></font>"
		end if
		if NOT userHasRoleInList("NOPRICESUSER") then
			PDF.AddHTMLPos 534, x, "<font family=""Tahoma""><font size=""8"">PRICE:</font></font>"
		
			if (rs("baseprice")<>"" or NOT ISNULL(rs("baseprice"))) then baseprice=baseprice + CDbl(rs("baseprice")) 
			PDF.AddHTMLPos 534, x+10, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(baseprice,2) & "</b></font></font>"
		end if
		
		PDF.AddHTMLPos 33, x+12, "<font family=""Tahoma""><font size=""8"">Link Position:</font></font>"
		PDF.AddHTMLPos 88, x+12, "<font family=""Tahoma""><font size=""8""><b>" & rs("linkposition") & "</b></font></font>"
		PDF.AddHTMLPos 225, x+12, "<font family=""Tahoma""><font size=""8"">Link Finish:</font></font>"
		PDF.AddHTMLPos 272, x+12, "<font family=""Tahoma""><font size=""8""><b>" & rs("linkfinish") & "</b></font></font>"
		
		if (rs("upholsteredbase") <> "n" and  Not isNull("upholsteredbase")) then
		PDF.AddHTMLPos 410, x+12, "<font family=""Tahoma""><font size=""8"">Upholstered Base:</font></font>"
		PDF.AddHTMLPos 477, x+12, "<font family=""Tahoma""><font size=""8""><b>" & rs("upholsteredbase") & "</b></font></font>"
		else
		PDF.AddHTMLPos 410, x+12, "<font family=""Tahoma""><font size=""8"">Upholstered Base: No</font></font>"
	end if
		
	'If rs("basedrawerconfigID")<>"n" then	
		PDF.AddHTMLPos 33, x+24, "<font family=""Tahoma""><font size=""8"">Drawers:</font></font>"
		PDF.AddHTMLPos 88, x+24, "<font family=""Tahoma""><font size=""8""><b>" & rs("basedrawerconfigID") & "</b></font></font>"
		PDF.AddHTMLPos 225, x+24, "<font family=""Tahoma""><font size=""8"">Drawer Height:</font></font>"
		PDF.AddHTMLPos 280, x+24, "<font family=""Tahoma""><font size=""8""><b>" & rs("basedrawerheight") & "</b></font></font>"
		PDF.AddHTMLPos 410, x+24, "<font family=""Tahoma""><font size=""8""></font></font>"
		PDF.AddHTMLPos 447, x+24, "<font family=""Tahoma""><font size=""8""><b></b></font></font>"
		'end if
	PDF.AddHTMLPos 410, x+24, "<font family=""Tahoma""><font size=""8"">Spring Height:</font></font>"
	PDF.AddHTMLPos 462, x+24, "<font family=""Tahoma""><font size=""8""><b>" & rs("baseheightspring") &  " </b></font></font>"
	if NOT isNull(rs("basetrim")) and rs("basetrim")<>"" and rs("basetrim")<>"n" then
			if NOT userHasRoleInList("NOPRICESUSER") then
			PDF.AddHTMLPos 534, x+20, "<font family=""Tahoma""><font size=""8"">+TRIM:</font></font>"
				if (rs("basetrimprice")<>"" or NOT ISNULL(rs("basetrimprice"))) then 
				PDF.AddHTMLPos 534, x+30, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("basetrimprice")) & FormatNumber(rs("basetrimprice"),2) & "</b></font></font>"
				end if
			end if
	end if
	
			If rs("baseinstructions")<>"" then
			baseinstructions=replace(rs("baseinstructions"),CHR(13)," ")
			x=x+17
			str2=baseinstructions
			PDF.SetFont " F1 ", 6, " #000000"
			PDF.SetProperty csPropAddTextWidth , 2
			PDF.AddTextWidth 33,x+31,490, str2
			x=x+12
			else
			x=x+7
			end if
	if (rs("upholsteredbase") <> "n" and  Not isNull("upholsteredbase")) then
		'If rs("basefabric")<>"" then
		PDF.AddHTMLPos 33, x+29, "<font family=""Tahoma""><font size=""8"">Fabric Selection:</font></font>"
		PDF.AddHTMLPos 98, x+29, "<font family=""Tahoma""><font size=""8""><b>" & rs("basefabric") & "</b></font></font>"
		PDF.AddHTMLPos 410, x+29, "<font family=""Tahoma""><font size=""8"">Direction:</font></font>"
		PDF.AddHTMLPos 450, x+29, "<font family=""Tahoma""><font size=""8""><b>" & rs("basefabricdirection") & "</b></font></font>"
		PDF.AddHTMLPos 33, x+41, "<font family=""Tahoma""><font size=""8"">Description:</font></font>"
		PDF.AddHTMLPos 98, x+41, "<font family=""Tahoma""><font size=""8""><b>" & rs("basefabricchoice") & "</b></font></font>"
		if NOT userHasRoleInList("NOPRICESUSER") then
			PDF.AddHTMLPos 534, x+29, "<font family=""Tahoma""><font size=""8"">PRICE:</font></font>"
			PDF.AddHTMLPos 534, x+39, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(baseupholsteryprice,2) & "</b></font></font>"
		end if
		If rs("basefabricdesc")<>"" then
				basefabricdesc=replace(rs("basefabricdesc"),CHR(13)," ")
				str18="Base Fabric Instructions: " & basefabricdesc & " "
				PDF.SetFont " F1 ", 6, " #000000"
				PDF.SetProperty csPropAddTextWidth , 2
				PDF.AddTextWidth 33,x+64,490, str18
		end if
	end if

'end base upholstery options
		
			if (rs("upholsteredbase") <> "n" and rs("upholsteredbase") <> "--" and  Not isNull("upholsteredbase")) then
				If trim(rs("baseinstructions"))<>"" then
				 	x=x+69
				 else
					x=x+66
				end if
			else
				x=x+49
			end if
			if (rs("upholsteredbase") <> "n" and rs("upholsteredbase") <> "--" and  Not isNull("upholsteredbase")) then
				If rs("basefabricdesc")<>"" then x=x+27
				
			end if
			'If rs("baseinstructions")<>"" then x=x+30
end if
'BASE REQ END
'LEGS REQ
If rs("legsrequired")="y" then
	If rs("specialinstructionslegs")<>"" then
			DrawBox 20,x-5, 560, 55
			PDF.SetProperty csPropGraphLineColor, "silver"
			DrawBox 25,x+27, 500, 18
			PDF.SetProperty csPropGraphLineColor, "black"
	else
			DrawBox 20,x-5, 560, 30
			PDF.SetProperty csPropGraphLineColor, "black"
	end if

	PDF.AddHTMLPos 25, x-10, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
	PDF.AddHTMLPos 33, x-12, "<font family=""Tahoma""><font size=""8""><b>Legs</b></font></font>"
	PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8"">Leg Style/Finish:</font></font>"
	PDF.AddHTMLPos 95, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("legstyle") & "</b></font></font>"
	PDF.AddHTMLPos 225, x, "<font family=""Tahoma""><font size=""8"">Leg Finish:</font></font>"
	PDF.AddHTMLPos 272, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("legfinish") & "</b></font></font>"
	PDF.AddHTMLPos 410, x, "<font family=""Tahoma""><font size=""8"">Leg Height:</font></font>"
	If speciallegheight<>"" then
	PDF.AddHTMLPos 457, x, "<font family=""Tahoma""><font size=""8""><b>" & speciallegheight & "cm</b></font></font>"
	else
	PDF.AddHTMLPos 457, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("legheight") & "</b></font></font>"
	end if
	if NOT userHasRoleInList("NOPRICESUSER") then
		PDF.AddHTMLPos 534, x, "<font family=""Tahoma""><font size=""8"">PRICE:</font></font>"
		if NOT ISNULL(rs("addlegprice")) then legprice=CDbl(rs("addlegprice"))
		if NOT ISNULL(rs("legprice")) then
			legprice=legprice+CDbl(rs("legprice"))
		end if
		if legprice<>"" then
			PDF.AddHTMLPos 534, x+10, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(legprice,2) & "</b></font></font>"
		else
			PDF.AddHTMLPos 534, x+10, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & "0.00</b></font></font>"
		end if
	end if
	'PDF.AddHTMLPos 33, x+30, "<font family=""Tahoma""><font size=""8"">Packaging:</font></font>"
	'PDF.AddHTMLPos 75, x+30, "<font family=""Tahoma""><font size=""8""><b>xxx" & wrap & "</b></font></font>"

	if NOT ISNULL(rs("floortype")) then
	PDF.AddHTMLPos 33, x+10, "<font family=""Tahoma""><font size=""8"">Floor Type:</font></font>"
	PDF.AddHTMLPos 75, x+10, "<font family=""Tahoma""><font size=""8""><b>" & rs("floortype") & "</b></font></font>"
	lw1=130
	lw2=60
	else 
	lw=0
	lw2=0
	end if
 
	PDF.AddHTMLPos 33+lw1, x+10, "<font family=""Tahoma""><font size=""8"">Standard Legs:</font></font>"
	PDF.AddHTMLPos 95+lw1, x+10, "<font family=""Tahoma""><font size=""8""><b>" & rs("legqty") & "</b></font></font>"
	PDF.AddHTMLPos 225+lw2, x+10, "<font family=""Tahoma""><font size=""8"">Additional Legs:</font></font>"
	PDF.AddHTMLPos 289+lw2, x+10, "<font family=""Tahoma""><font size=""8""><b>" & rs("AddLegQty") & "</b></font></font>"
	PDF.AddHTMLPos 410, x+10, "<font family=""Tahoma""><font size=""8"">Legs total:</font></font>"
	legtotal=0
	If rs("legqty")<>"" then legtotal=CInt(rs("LegQty"))
	if rs("AddLegQty")<>"" then legtotal=legtotal+CInt(rs("AddLegQty"))
	PDF.AddHTMLPos 457, x+10, "<font family=""Tahoma""><font size=""8""><b>" & legtotal & "</b></font></font>"
	If rs("specialinstructionslegs")<>"" then
				specialinstructionslegs=replace(rs("specialinstructionslegs"),CHR(13)," ")
				str118="Leg Instructions: " & specialinstructionslegs & " "
				PDF.SetFont " F1 ", 6, " #000000"
				PDF.SetProperty csPropAddTextWidth , 2
				PDF.AddTextWidth 33,x+35,490, str118
		end if
x=x+39
end if

If rs("specialinstructionslegs")<>"" then x=x+23

'LEGS REQ END

'IF TOPPER REQ
If rs("topperrequired")="y" then
	If rs("specialinstructionstopper")<>"" then
			DrawBox 20,x-5, 560, 45
			PDF.SetProperty csPropGraphLineColor, "silver"
			DrawBox 25,x+17, 500, 18
			PDF.SetProperty csPropGraphLineColor, "black"
	else
			DrawBox 20,x-5, 560, 30
			PDF.SetProperty csPropGraphLineColor, "black"
	end if
		PDF.AddHTMLPos 25, x-10, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
		PDF.AddHTMLPos 33, x-12, "<font family=""Tahoma""><font size=""8""><b>Topper</b></font></font>"
		
		PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8"">Model:</font></font>"
		PDF.AddHTMLPos 60, x, "<font family=""Tahoma""><font size=""9""><b>" & rs("toppertype") & "</b></font></font>"
			if topper1width<>"" then topperwidthstring= topper1width & "cm x "
			if topper1width="" then topperwidthstring= rs("topperwidth") & " x "
			if topper1length<>"" then topperwidthstring=topperwidthstring & topper1length & "cm"
			if topper1length="" then topperwidthstring=topperwidthstring & rs("topperlength") & ""
		PDF.AddHTMLPos 225, x, "<font family=""Tahoma""><font size=""8"">Size (w x l):</font></font>"
		PDF.AddHTMLPos 272, x, "<font family=""Tahoma""><font size=""8""><b>" & topperwidthstring & "</b></font></font>"
		PDF.AddHTMLPos 410, x, "<font family=""Tahoma""><font size=""8"">Ticking:</font></font>"
		PDF.AddHTMLPos 442, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("toppertickingoptions") & "</b></font></font>"
		if NOT userHasRoleInList("NOPRICESUSER") then
			PDF.AddHTMLPos 534, x, "<font family=""Tahoma""><font size=""8"">PRICE:</font></font>"
			If rs("topperprice")<>"" and   NOT ISNULL(rs("topperprice"))  then
			PDF.AddHTMLPos 534, x+10, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(rs("topperprice"),2) & "</b></font></font>"
			else
			PDF.AddHTMLPos 534, x+10, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & "0.00</b></font></font>"
			end if
		end if
			If rs("specialinstructionstopper")<>"" then
			specialinstructionstopper=replace(rs("specialinstructionstopper"),CHR(13)," ")
			str3=specialinstructionstopper
			PDF.SetFont "F15", 6, "#999"
			
			PDF.SetProperty csPropAddTextWidth , 2
			PDF.AddTextWidth 33,x+23,490, str3
			end if
			x=x+37
			If rs("specialinstructionstopper")<>"" then x=x+17
end if
'TOPPER REQ END

'base upholstery options
'UPHOLSTERY OPTIONS REQ

if rs("valancerequired")="y" then
	If rs("specialinstructionsvalance")<>"" then
		DrawBox 20,x-5, 560, 75
		PDF.SetProperty csPropGraphLineColor, "silver"
		'DrawBox 25,x+17, 500, 25
		DrawBox 25,x+47, 500, 18
		PDF.SetProperty csPropGraphLineColor, "black"
	else
		DrawBox 20,x-5, 560, 52
		PDF.SetProperty csPropGraphLineColor, "black"
	end if
PDF.AddHTMLPos 25, x-10, "<img src=""images/whitebg.png"" width=""132"" height=""16"">"
	'SUM VALANCE FABRIC
		If rs("valfabricprice")<>"" and NOT ISNULL(rs("valfabricprice"))  then
			if Cdbl(rs("valfabricprice"))>0.0 then
				if rs("valancerequired")="y" then upholsterysum=upholsterysum + Cdbl(rs("valfabricprice"))
				valanceprice=Cdbl(rs("valfabricprice"))
			end if
		end if
		If rs("valanceprice")<>"" and NOT ISNULL(rs("valanceprice"))  then
        upholsterysum=upholsterysum + Cdbl(rs("valanceprice"))
		valanceprice=valanceprice + Cdbl(rs("valanceprice"))
		end if
'VALANCE REQ ENTERED WHETHER YES OR NO
PDF.AddHTMLPos 33, x-12, "<font family=""Tahoma""><font size=""8""><b>Valance</b></font></font>"


'VALANCE REQUIRED

	PDF.AddHTMLPos 33, x, "<font family=""Tahoma""><font size=""8"">No. of Pleats:</font></font>"
	PDF.AddHTMLPos 98, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("pleats") & "</b></font></font>"
	PDF.AddHTMLPos 220, x, "<font family=""Tahoma""><font size=""8"">Direction:</font></font>"
	PDF.AddHTMLPos 260, x, "<font family=""Tahoma""><font size=""8""><b>" & rs("valancefabricdirection") & "</b></font></font>"
	if NOT userHasRoleInList("NOPRICESUSER") then
		PDF.AddHTMLPos 534, x, "<font family=""Tahoma""><font size=""8"">PRICE:</font></font>"
		PDF.AddHTMLPos 534, x+10, "<font family=""Tahoma""><font size=""8""><b>" & getCurrencySymbolForCurrency(rs("ordercurrency")) & FormatNumber(valanceprice,2) & "</b></font></font>"
	end if
	PDF.AddHTMLPos 33, x+11, "<font family=""Tahoma""><font size=""8"">Valance Drop:</font></font>"
	PDF.AddHTMLPos 98, x+11, "<font family=""Tahoma""><font size=""8""><b>" & rs("valancedrop") & "</b></font></font>"
	PDF.AddHTMLPos 220, x+11, "<font family=""Tahoma""><font size=""8"">Valance Width:</font></font>"
	PDF.AddHTMLPos 277, x+11, "<font family=""Tahoma""><font size=""8""><b>" & rs("valancewidth") & "</b></font></font>"
	PDF.AddHTMLPos 355, x+11, "<font family=""Tahoma""><font size=""8"">Valance Length:</font></font>"
	PDF.AddHTMLPos 417, x+11, "<font family=""Tahoma""><font size=""8""><b>" & rs("valancelength") & "</b></font></font>"
	If rs("specialinstructionsvalance")<>"" then
		specialinstructionsvalance=replace(rs("specialinstructionsvalance"),CHR(13)," ")
		str8=str8 & " Valance Instructions: " & specialinstructionsvalance
		PDF.SetFont "F15", 6, "#999"
		PDF.SetProperty csPropAddTextWidth , 2
		PDF.AddTextWidth 33,x+55,490, str8
	end if
	PDF.AddHTMLPos 33, x+22, "<font family=""Tahoma""><font size=""8"">Fabric Selection:</font></font>"
	PDF.AddHTMLPos 98, x+22, "<font family=""Tahoma""><font size=""8""><b>" & rs("valancefabric") & "</b></font></font>"
	PDF.AddHTMLPos 33, x+33, "<font family=""Tahoma""><font size=""8"">Description:</font></font>"
	PDF.AddHTMLPos 98, x+33, "<font family=""Tahoma""><font size=""8""><b>" & rs("valancefabricchoice") & "</b></font></font>"


	
	
	x=x+59
	If rs("specialinstructionsvalance")<>"" then x=x+23
end if



if x > 554 then 
	'headboard options%>
	<!-- #include file="print-pdf-headboard.asp" -->
<%	PDF.AddPage
	DrawBox 20,93, 180, 95
	DrawBox 210,93, 180, 95
	
	DrawBox 400,93, 180, 95
	
	
	%>

	<!-- #include file="print-pdf-header.asp" -->
    <%
      'headboard options'ORDER SUMMARY
	DrawBox 20,604, 270, 142
	'end ORDER SUMMARY
	'DELIVERY DETAILS
	DrawBox 310,604, 270, 102
	'end ORDER DELIVERY DETAILS
	'PAYMENTS
	DrawBox 20,754, 270, 78
	'end PAYMENTS
	'CUST SIG
	if aw = "y" then
	else
	DrawBox 310,754, 270, 78
	end if
	'end CUST SIG
	PDF.AddHTMLPos 25, 600, "<img src=""images/whitebg.png"" width=""230"" height=""16"">"
	PDF.AddHTMLPos 25, 753, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
	PDF.AddHTMLPos 315, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"
	PDF.SetFont "F15", 9, "#999"
	if retrieveuserlocation()=46 then
		PDF.AddHTMLPos 160, 570, "<b>All items sold within this showroom event are sold as seen.</b>"
		PDF.AddHTMLPos 55, 581, "<b>Our remake guarantee (section 6 of our Terms and Conditions) therefore does not apply to this order.</b>"
	end if
	PDF.AddTextPos 28, 607, orderorquote & " Summary - " & orderorquote & " No." & rs("order_number")
	if quote<>"y" then
		PDF.AddTextPos 28, 757, "Payments"
		if aw = "y" then
		else
		PDF.AddTextPos 323, 757, "Customer's Signature"
		end if
	end if
        
else
	 %>
	<!-- #include file="print-pdf-headboard.asp" -->
	<%
	     'headboard options'ORDER SUMMARY
	if quote="y" then
	DrawBox 20,604, 270, 192
	else
	DrawBox 20,604, 270, 142
	'end ORDER SUMMARY
	end if
	if quote<>"y" then
		'DELIVERY DETAILS
		DrawBox 310,604, 270, 102
		'end ORDER DELIVERY DETAILS
		'PAYMENTS
		DrawBox 20,754, 270, 78
		'end PAYMENTS
		'CUST SIG
		if aw = "y" then
		else
		DrawBox 310,754, 270, 78
		end if
		'end CUST SIG
	end if
	PDF.AddHTMLPos 25, 600, "<img src=""images/whitebg.png"" width=""230"" height=""16"">"
	PDF.AddHTMLPos 25, 753, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
	PDF.AddHTMLPos 315, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"
	PDF.SetFont "F15", 9, "#999"
	if retrieveuserlocation()=46 then
	 PDF.AddHTMLPos 160, 570, "<b>All items sold within this showroom event are sold as seen.</b>"
	 PDF.AddHTMLPos 55, 581, "<b>Our remake guarantee (section 6 of our Terms and Conditions) therefore does not apply to this order.</b>"
	end if
	PDF.AddTextPos 28, 607, orderorquote & " Summary - " & orderorquote & " No." & rs("order_number")
	if quote<>"y" then
		PDF.AddTextPos 28, 757, "Payments"
		if aw = "y" then
		else
		PDF.AddTextPos 323, 757, "Customer's Signature"
		end if
	end if
	
end if
Dim nytablewidth
if rs("owning_region")=4 then
nytablewidth=205
else
nytablewidth=215
end if

sumtbl="<font family=""Times""><font size=""8""><table width=""260"" height=""50"" align=""left"" cellpadding=-1 cellspacing=-1>" 
sumtbl=sumtbl & "<tr>"
If rs("mattressrequired")="y" then
sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">Mattress</td>"
	if NOT userHasRoleInList("NOPRICESUSER") then
	sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(rs("mattressprice"), true, rs("ordercurrency")) & "</b></td>"
	end if
	sumtbl=sumtbl & "</tr>"	
end if
If rs("baserequired")="y" then
sumtbl=sumtbl & "<tr height=5><td width=10 height=5></td><td width=" & nytablewidth & ">Base</td>"
	if NOT userHasRoleInList("NOPRICESUSER") then
	sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(baseprice, true, rs("ordercurrency")) & "</b></td>"
	end if
	sumtbl=sumtbl & "</tr>"	
	if NOT isNull(rs("basetrim")) and rs("basetrim")<>"" then
	sumtbl=sumtbl & "<tr height=5><td width=10 height=5></td><td width=" & nytablewidth & ">Base Trim</td>"
		if NOT userHasRoleInList("NOPRICESUSER") then
		sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(rs("basetrimprice"), true, rs("ordercurrency")) & "</b></td>"
		end if
		sumtbl=sumtbl & "</tr>"	
	end if
end if
If rs("legsrequired")="y" then
	if NOT ISNULL(rs("legprice")) then
		legprice=CDbl(rs("legprice"))
	else
		legprice=0.00
	end if
	if NOT ISNULL(rs("addlegprice")) then
		legprice=legprice + CDbl(rs("addlegprice"))
	end if
	

	sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">Legs</td>"
	if NOT userHasRoleInList("NOPRICESUSER") then
		sumtbl=sumtbl & "<td width=25 align=""right""><font family=""Times""><font size=""8""><b>" & fmtCurr2(legprice, true, rs("ordercurrency")) & "</b></font></font></td>"
	end if
	sumtbl=sumtbl & "</tr>"	
end if
If rs("topperrequired")="y" then
sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">Topper</td>"
	if NOT userHasRoleInList("NOPRICESUSER") then
	sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(rs("topperprice"), true, rs("ordercurrency")) & "</b></td>"
	end if	
	sumtbl=sumtbl & "</tr>"	
end if
If (upholsterysum<>0 and upholsterysum<>"") then
'valance fabric & valance price added together
sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">Upholstery</td>"
	if NOT userHasRoleInList("NOPRICESUSER") then
	sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(upholsterysum, true, rs("ordercurrency")) & "</b></td>"
	end if
	sumtbl=sumtbl & "</tr>"		
end if
If rs("headboardrequired")="y" then
sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">Headboard</td>"
	if NOT userHasRoleInList("NOPRICESUSER") then
	sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(rs("headboardprice"), true, rs("ordercurrency")) & "</b></td>"	
	end if
	sumtbl=sumtbl & "</tr>"		
end if

'sumtbl=sumtbl & "<tr><td width=10></td><td width=215><b>Bed Set Total</b></td><td width=25 align=""right""><b>" & fmtCurr2(rs("bedsettotal"), true, rs("ordercurrency")) & "</b></td></tr>"	


If rs("accessoriesrequired")="y" then
	sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">Accessories (see next page for details)</td>"
	if NOT userHasRoleInList("NOPRICESUSER") then
	sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(rs("accessoriestotalcost"), true, rs("ordercurrency")) & "</b></td>"	
	end if
	sumtbl=sumtbl & "</tr>"
end if
If rs("discount")<>"" and NOT ISNULL(rs("discount")) then
	If CDbl(rs("discount"))>0.0 then
		If rs("discounttype")="percent" then 
		discountamt=CDbl(rs("bedsettotal"))*(CDbl(rs("discount"))/100)
			if NOT userHasRoleInList("NOPRICESUSER") then
				sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">Discount</td><td width=25 align=""right""><b>" & fmtCurr2(discountamt, true, rs("ordercurrency")) & "</b></td></tr>"
			end if
		end if
	end if
end if
If rs("discounttype")="currency" then 
	If rs("discount")<>"" and NOT ISNULL(rs("discount")) then
		If CDbl(rs("discount"))>0.0 then 
			discountamt=CDbl(rs("discount"))
			if NOT userHasRoleInList("NOPRICESUSER") then
				sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">Discount</td><td width=25 align=""right""><b>" & fmtCurr2(discountamt, true, rs("ordercurrency")) & "</b></td></tr>"
			end if
		end if
	end if	
end if

If rs("istrade")="y" then

	If rs("tradediscount")<>"" and NOT ISNULL(rs("tradediscount")) then
		sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">Trade Discount</td>"
		if NOT userHasRoleInList("NOPRICESUSER") then
				sumtbl=sumtbl & "<td width=25 align=""right""></b>" & fmtCurr2(rs("tradediscount"), true, rs("ordercurrency")) & "</b></td>"
		end if
	sumtbl=sumtbl & "</tr>"
	end if

	if rs("deliverycharge")="y" then
		sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">Delivery Charge</td>"
		if NOT userHasRoleInList("NOPRICESUSER") then
			sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(rs("deliveryprice"), true, rs("ordercurrency")) & "</b></td>"
		end if
		sumtbl=sumtbl & "</tr>"
	end if
	
	sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & "><b>" & OrderTotalExVAT & "</b></td>"
	if NOT userHasRoleInList("NOPRICESUSER") then
		ordTotExVat = ccur(rs("total")) - ccur(rs("vat"))
		sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(ordTotExVat, true, rs("ordercurrency")) & "</b></td>"
	end if
	sumtbl=sumtbl & "</tr>"
	If rs("vat")<>"" and rs("vat")<>"0" and NOT ISNULL(rs("vat")) then
		sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">" & VATWording & "</td>"
		if NOT userHasRoleInList("NOPRICESUSER") then
			sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(rs("vat"), true, rs("ordercurrency")) & "</b></td>"
		end if
		sumtbl=sumtbl & "</tr>"	
	end if 
	sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & "><b>" & OrderTotalIncVAT & "</b></td>"
	if NOT userHasRoleInList("NOPRICESUSER") then
		sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(rs("total"), true, rs("ordercurrency")) & "</b></td>"
	end if
	sumtbl=sumtbl & "</tr>"
else

	if rs("deliverycharge")="y" then
		sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">Delivery Charge</td>"
		if NOT userHasRoleInList("NOPRICESUSER") then
			sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(rs("deliveryprice"), true, rs("ordercurrency")) & "</b></td>"
		end if
		sumtbl=sumtbl & "</tr>"
	end if

	If rs("totalexvat")<>"" and NOT ISNULL(rs("totalexvat")) then
		sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">Total Ex. VAT</td>"
		if NOT userHasRoleInList("NOPRICESUSER") then
			sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(rs("totalexvat"), true, rs("ordercurrency")) & "</b></td>"	
		end if
		sumtbl=sumtbl & "</tr>"
	end if 
	
	If rs("vat")<>"" and NOT ISNULL(rs("vat")) then
		sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & ">VAT</td>"
		if NOT userHasRoleInList("NOPRICESUSER") then
			sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(rs("vat"), true, rs("ordercurrency")) & "</b></td>"
		end if
		sumtbl=sumtbl & "</tr>"	
	end if 
	sumtbl=sumtbl & "<tr><td width=10></td><td width=" & nytablewidth & "><b>" & orderorquote & " Total inc. VAT</b></td>"
	if NOT userHasRoleInList("NOPRICESUSER") then
		sumtbl=sumtbl & "<td width=25 align=""right""><b>" & fmtCurr2(rs("total"), true, rs("ordercurrency")) & "</b></td>"
	end if
	sumtbl=sumtbl & "</tr>"

end if
sumtbl=sumtbl & "</table></font>"


PDF.AddHTMLPos 33, 599, sumtbl
nyx=0
if quote<>"y" then
	if rs("idlocation")<>34 then
		PDF.AddHTMLPos 320, 613, "<b>DELIVERY DATE:</b>"
		If rs("bookeddeliverydate")<>"" then
		PDF.AddTextPos 490, 622-nyx, rs("bookeddeliverydate")
		else
			if day(rs("deliverydate"))=15 then deltxt="Approx middle of " & monthname(month(rs("deliverydate"))) & " " & year(rs("deliverydate"))
			if day(rs("deliverydate"))=5 then deltxt="Approx beginning of " & monthname(month(rs("deliverydate"))) & " " & year(rs("deliverydate"))
			if day(rs("deliverydate"))=25 then deltxt="Approx end of " & monthname(month(rs("deliverydate"))) & " " & year(rs("deliverydate"))
	PDF.AddHtmlPos 412, 613, "<b><font family=""Tahoma""><font size=""8"">" & deltxt & "</font></font></b>"
		end if
	else
	nyx=15
	end if


	PDF.SetFont "F15", 8, "#999"


	PDF.AddTextPos 320, 633-nyx, "Dispose of old bed:"
	if NOT ISNULL(rs("oldbed")) then
	PDF.AddHtmlPos 412, 623-nyx, "<b>" & rs("oldbed") & "</b>"
	end if
	PDF.AddTextPos 320, 644-nyx, "Access Check:"
	if NOT ISNULL(rs("accesscheck")) then
	PDF.AddHtmlPos 412, 633-nyx, "<b>" & rs("accesscheck") & "</b>"
	end if
	PDF.AddTextPos 320, 655-nyx, "Floor Type:"
	PDF.AddHtmlPos 412, 645-nyx, "<b>" & rs("floortype") & "</b>"
	PDF.AddTextPos 320, 666-nyx, "Packaging:"
	PDF.AddHtmlPos 412, 656-nyx, "<b>" & wrap & "</b>"
	PDF.SetProperty csPropAddTextWidth , 2
end if	

if quote="y" then
else
	if aw="y" then
	PDF.AddHtmlPos 310, 730, "<font size=""14""><b>Confirmation Code:  </b>" & rs("OrderConfirmationCode") & "</font>"
	PDF.AddTextWidth 310, 790,280, savoirterms
	else
	PDF.AddTextWidth 310,730,280, "I have read and understood the terms and conditions on the reverse of this order form and accept them in full."
	end if
end if

paymentSum = 0.0
     if ubound(payments) > 0 then
	 str7="<table width=167 align=""left"" cellpadding=-1 cellspacing=-1>"  
	 str7=str7 & "<tr><td></td><td><font family=""Tahoma"" size=-1><b>Type</b></font></td><td><font family=""Tahoma"" size=-1><b>Method</b></font></td><td><font family=""Tahoma"" size=-1><b>Date</b></font></td><td><font family=""Tahoma"" size=-1><b>Receipt&nbsp;No.</b></font></td><td align=""right""><font family=""Tahoma"" size=-1><b>Amount</b></font></td></tr>"   
	     for n = 1 to ubound(payments)
		     paymentSum = paymentSum + payments(n).amount
		     
		    str7=str7 & "<tr><td width=8></td><td width=65><font family=""Tahoma"" size=-1>"
		     str7=str7 & payments(n).paymentType
			 str7=str7 & "</font></td><td width=58><font family=""Tahoma"" size=-1>"
		     str7=str7 & payments(n).paymentMethod
			 str7=str7 & "</font></td><td width=40><font family=""Tahoma"" size=-1>"
			 str7=str7 & left(payments(n).placed, 10)
			 str7=str7 & "</font></td><td width=42><font family=""Tahoma"" size=-1>"
		     str7=str7 & payments(n).receiptNo
			 str7=str7 & "</td><td align=""right"" width=8><b>"
		     str7=str7 & fmtCurr2(abs(payments(n).amount), true, orderCurrency)
			 str7=str7 & "</b></td></tr>"
		     
	     next
	str7=str7 & "<tr><td></td><td colspan=""4""><b>Outstanding Balance</b></td><td align=""right"">" & "<b>" & fmtCurr2(rs("balanceoutstanding"), true, rs("ordercurrency")) & "</b></td></tr></table>"
	str7=str7 & "</table>"
	end if

if NOT userHasRoleInList("NOPRICESUSER") then
	PDF.AddHTMLPos 53, 750, str7
end if
if quote<>"y" then
	if aw = "y" then
	else
	PDF.AddTextPos 320, 828, "........................................................... Date: " & date()
	end if
end if
if request("tandc")="n" then
else
	if retrieveUserRegion()=1 or retrieveUserLocation()=24 or retrieveUserLocation()=17 or retrieveUserLocation()=34 or retrieveUserLocation()=37 then
	
	
	PDF.AddPage
	PDF.SetFont "F1", 8, "#000000"
	termstext=replace(termstext, "<p>", "<div style=""font-size:6px;"">")
	termstext=replace(termstext, "</p>", "<br></div>")
	termstext=replace(termstext, "<p align=""center"">", "<div align=""center"">")
	termstext=termstext
	PDF.AddHTML termstext
	end if
end if
if rs("accessoriesrequired")="y" then
	PDF.AddPage
	DrawBox 20,96, 180, 95
	DrawBox 210,96, 180, 95
	DrawBox 400,96, 180, 95
	
	DrawBox 20,200, 560, 465
	if quote="y" then
	else
	'CUST SIG
	DrawBox 310,754, 270, 80
	'end CUST SIG
	end if
	PDF.SetFont "F15", 12, "#999"
	PDF.AddHTML "<p align=""right""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
	PDF.AddTextPos 20, 20, orderorquote & " No. " & rs("order_number")
	PDF.SetFont "F15", 10, "#999"
	PDF.AddTextPos 20, 40, orderorquote & " Date. " & FormatDateTime(rs("order_date"),vbShortDate)
	PDF.AddTextPos 20, 60, "Savoir Contact: " & contact
	PDF.SetFont "F15", 9, "#999"
	
	PDF.AddHTML "<hr>"
	'PDF.AddHTML s
	PDF.AddHTMLPos 10, 75, s
	
	PDF.AddHTMLPos 25, 92, "<img src=""images/whitebg.png"" width=""95"" height=""16"">"
	PDF.AddHTMLPos 215, 92, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
	PDF.AddHTMLPos 405, 92, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
	PDF.AddHTMLPos 25, 192, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
	
	
	PDF.AddTextPos 33, 101, "Client Details"
	PDF.AddTextPos 223, 101, "Invoice Address"
	PDF.AddTextPos 413, 101, "Delivery Address"
	PDF.AddTextPos 33, 205, "Accessories"
	
	
	
	PDF.AddHTML xacc
	if quote<>"y" then
	if retrieveuserlocation()=46 then
		PDF.AddHTMLPos 160, 638, "<b>All items sold within this showroom event are sold as seen.</b>"
		PDF.AddHTMLPos 55, 648, "<b>Our remake guarantee (section 6 of our Terms and Conditions) therefore does not apply to this order.</b>"
	end if
	PDF.AddHTMLPos 315, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"
	PDF.AddTextPos 323, 757, "Customer's Signature"
	PDF.AddTextPos 320, 828, "....................................................... Date: " & date()
	
	end if
end if
end if

'ACCESSORIES ONLY SECTION
if rs("accessoriesrequired")="y" and accessoriesonly="y" then

DrawBox 20,96, 180, 95
DrawBox 210,96, 180, 95
DrawBox 400,96, 180, 95

DrawBox 20,200, 560, 405

'ORDER SUMMARY
if quote="y" then
DrawBox 20,634, 270, 97
else
DrawBox 20,634, 270, 77
end if
'end ORDER SUMMARY
if quote="y" then
else
'DELIVERY DETAILS
DrawBox 310,634, 270, 77
'end ORDER DELIVERY DETAILS
'PAYMENTS
DrawBox 20,754, 270, 80
'end PAYMENTS
'CUST SIG
DrawBox 310,754, 270, 80
'end CUST SIG
end if
PDF.SetFont "F15", 12, "#999"
PDF.AddHTML "<p align=""right""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
PDF.AddTextPos 20, 25, orderorquote & " No. " & rs("order_number")
PDF.SetFont "F15", 10, "#999"
PDF.AddTextPos 20, 40, orderorquote & " Date. " & FormatDateTime(rs("order_date"),vbShortDate)
PDF.AddTextPos 20, 55, "Savoir Contact: " & contact


if retrieveuserlocation()=46 then 
PDF.AddTextPos 20, 70, "Showroom: Event Showroom, 18-20 Chelsea Manor Street, SW3 4YR. Tel. During Event: 07523 900622 or 07523 900619"
PDF.AddTextPos 20, 82, "AFTER Event please call our Marylebone Showroom at 7 Wigmore Street London W1U 1AD on: 020 7493 4444."
else
PDF.AddTextPos 20, 70, "Showroom: " & showroomaddress
PDF.AddTextPos 20, 85, showroomtelemail
end if
PDF.AddHTML s

'PDF.AddHTML s
'PDF.AddHTMLPos -20, -20, s

PDF.AddHTMLPos 25, 92, "<img src=""images/whitebg.png"" width=""95"" height=""16"">"
PDF.AddHTMLPos 215, 92, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 405, 92, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 25, 192, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"


PDF.AddTextPos 33, 101, "Client Details"
PDF.AddTextPos 223, 101, "Invoice Address"
PDF.AddTextPos 413, 101, "Delivery Address"
PDF.AddTextPos 33, 205, "Accessories"



PDF.AddHTML xacc
if quote<>"y" then
if aw="y" then
PDF.AddHtmlPos 20, 720, "<font size=""14""><b>Confirmation Code:  </b>" & rs("OrderConfirmationCode") & "</font>"
else
PDF.AddTextWidth 310,730,200, "I have read and understood the terms and conditions on the reverse of this order form and accept them in full."
end if
end if
PDF.AddHTMLPos 25, 630, "<img src=""images/whitebg.png"" width=""230"" height=""16"">"
PDF.AddHTMLPos 25, 753, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
if retrieveuserlocation()=46 then
	PDF.AddHTMLPos 160, 580, "<b>All items sold within this showroom event are sold as seen.</b>"
	PDF.AddHTMLPos 55, 590, "<b>Our remake guarantee (section 6 of our Terms and Conditions) therefore does not apply to this order.</b>"
end if
PDF.AddTextPos 33, 638, orderorquote & " Summary - " & orderorquote & " No." & rs("order_number")
if quote<>"y" then
PDF.AddTextPos 33, 757, "Payments"
end if
PDF.SetFont "F15", 8, "#999"
sumtbl="<font family=""Tahoma""><font size=""8""><table width=256 align=""left"">" 
sumtbl=sumtbl & "<tr>"

If rs("accessoriesrequired")="y" and rs("accessoriestotalcost")<>"" then 
sumtbl=sumtbl & "<tr><td width=10></td><td width=209>Accessories</td>"
	if NOT userHasRoleInList("NOPRICESUSER") then
		sumtbl=sumtbl & "<td width=21 align=""right""><b>" & fmtCurr2(rs("accessoriestotalcost"), true, rs("ordercurrency")) & "</b></td>"
	end if
	sumtbl=sumtbl & "</tr>"	
end if
If rs("discount")<>"" and NOT ISNULL(rs("discount")) then
	If CDbl(rs("discount"))>0.0 then
		If rs("discounttype")="percent" then
		 discountamt=CDbl(rs("bedsettotal"))*(CDbl(rs("discount"))/100)
		sumtbl=sumtbl & "<tr><td width=10></td><td width=209>Discount</td>"
			if NOT userHasRoleInList("NOPRICESUSER") then
				sumtbl=sumtbl & "<td width=21 align=""right"">" & fmtCurr2(discountamt, true, rs("ordercurrency")) & "</td>"
			end if
			sumtbl=sumtbl & "</tr>"	
		end if
	end if
end if
If rs("discounttype")="currency" then
	If rs("discount")<>"" and NOT ISNULL(rs("discount")) then 
		discountamt=CDbl(rs("discount"))
		sumtbl=sumtbl & "<tr><td width=10></td><td width=209>Discount</td>"
			if NOT userHasRoleInList("NOPRICESUSER") then
				sumtbl=sumtbl & "<td width=21 align=""right"">" & fmtCurr2(discountamt, true, rs("ordercurrency")) & "</td>"	
			end if
			sumtbl=sumtbl & "</tr>"	
	end if
end if

If rs("istrade")="y" then

	If rs("tradediscount")<>"" and NOT ISNULL(rs("tradediscount")) then
		If  CDbl(rs("tradediscount"))>0.0 then sumtbl=sumtbl & "<tr><td width=10></td><td width=209>Trade Discount</td>"
			if NOT userHasRoleInList("NOPRICESUSER") then
				sumtbl=sumtbl & "<td width=21 align=""right"">" & fmtCurr2(rs("tradediscount"), true, rs("ordercurrency")) & "</td>"
			end if
			sumtbl=sumtbl & "</tr>"
	end if
	
	sumtbl=sumtbl & "<tr><td width=10></td><td width=209><b>" & OrderTotalExVAT & "</b></td>"
		if NOT userHasRoleInList("NOPRICESUSER") then
			ordTotExVat = ccur(rs("total")) - ccur(rs("vat"))
			sumtbl=sumtbl & "<td width=21 align=""right"">" & fmtCurr2(ordTotExVat, true, rs("ordercurrency")) & "</td>"
		end if
		sumtbl=sumtbl & "</tr>"
	If rs("vat")<>"" and NOT ISNULL(rs("vat")) then
		If  CDbl(rs("vat"))>0.0 then sumtbl=sumtbl & "<tr><td width=10></td><td width=209>" & VATWording & "</td>"
			if NOT userHasRoleInList("NOPRICESUSER") then
				sumtbl=sumtbl & "<td width=21 align=""right"">" & fmtCurr2(rs("vat"), true, rs("ordercurrency")) & "</td>"
			end if	
			sumtbl=sumtbl & "</tr>"
	end if 
	sumtbl=sumtbl & "<tr><td width=10></td><td width=209><b>" & OrderTotalIncVAT & "</b></td>"
		if NOT userHasRoleInList("NOPRICESUSER") then
			sumtbl=sumtbl & "<td width=21 align=""right""><b>" & fmtCurr2(rs("total"), true, rs("ordercurrency")) & "</b></td>"
		end if	
		sumtbl=sumtbl & "</tr>"
else

If rs("totalexvat")<>"" and NOT ISNULL(rs("totalexvat")) then
	If  CDbl(rs("totalexvat"))<>"0.00" then sumtbl=sumtbl & "<tr><td width=10></td><td width=209>Total Ex. VAT</td>"
		if NOT userHasRoleInList("NOPRICESUSER") then
			sumtbl=sumtbl & "<td width=21 align=""right"">" & fmtCurr2(rs("totalexvat"), true, rs("ordercurrency")) & "</td>"	
		end if	
		sumtbl=sumtbl & "</tr>"
end if 

If rs("vat")<>"" and NOT ISNULL(rs("vat")) then
	if CDbl(rs("vat"))<>0 then
		If  CDbl(rs("vat"))>0.0 then sumtbl=sumtbl & "<tr><td width=10></td><td width=209>VAT</td>"
			if NOT userHasRoleInList("NOPRICESUSER") then
			sumtbl=sumtbl & "<td width=21 align=""right"">" & fmtCurr2(rs("vat"), true, rs("ordercurrency")) & "</td>"
			
			end if	
		sumtbl=sumtbl & "</tr>"	
	end if
end if 
sumtbl=sumtbl & "<tr><td width=10></td><td width=209><b>Order " & orderorquote & " inc. VAT</b></td>"
	if NOT userHasRoleInList("NOPRICESUSER") then
		sumtbl=sumtbl & "<td width=21 align=""right""><b>" & fmtCurr2(rs("total"), true, rs("ordercurrency")) & "</b></td>"
	end if	
	sumtbl=sumtbl & "</tr>"
end if
sumtbl=sumtbl & "</table></font>"

PDF.AddHTMLPos 33, 631, sumtbl

if quote<>"y" then
	PDF.AddHTMLPos 320, 639, "<b>DELIVERY DATE:</b>"
	If rs("bookeddeliverydate")<>"" then
	PDF.AddTextPos 490, 648, rs("bookeddeliverydate")
	else
		if day(rs("deliverydate"))=15 then deltxt="Approx middle of " & monthname(month(rs("deliverydate"))) & " " & year(rs("deliverydate"))
		if day(rs("deliverydate"))=5 then deltxt="Approx beginning of " & monthname(month(rs("deliverydate"))) & " " & year(rs("deliverydate"))
		if day(rs("deliverydate"))=25 then deltxt="Approx end of " & monthname(month(rs("deliverydate"))) & " " & year(rs("deliverydate"))
	PDF.AddTextPos 412, 648, deltxt
	end if
end if
if quote<>"y" then
	PDF.SetProperty csPropAddTextWidth , 2
	PDF.AddTextWidth 310,730,280, "I have read and understood the terms and conditions on the reverse of this order form and accept them in full."
end if
paymentSum = 0.0
     if ubound(payments) > 0 then
	 str7="<table width=""260"" align=""left"">" 
	 str7=str7 & "<tr><td></td><td><b>Type</b></td><td><b>Method</b></td><td><b>Date</b></td><td><b>Receipt&nbsp;No.</b></td><td align=""right""><b>Amount</b></td></tr>"   
	     for n = 1 to ubound(payments)
		     paymentSum = paymentSum + payments(n).amount
		     
		     str7=str7 & "<tr><td width=10></td><td width=75><font family=""Tahoma""><font size=""8"">"
		     str7=str7 & payments(n).paymentType
			 str7=str7 & "</td><td width=50>"
		     str7=str7 & payments(n).paymentMethod
			 str7=str7 & "</td><td width=40>"
			 str7=str7 & left(payments(n).placed, 10)
			 str7=str7 & "</td><td width=7>"
		     str7=str7 & payments(n).receiptNo
			 str7=str7 & "</td><td align=""right"" width=8>"
		     str7=str7 & fmtCurr2(abs(payments(n).amount), true, orderCurrency)
			 str7=str7 & "</td></tr>"
		     
	     next
	str7=str7 & "<tr><td></td><td colspan=""4""><b>Outstanding Balance</b></td><td align=""right"">" & "<b>" & fmtCurr2(rs("balanceoutstanding"), true, rs("ordercurrency")) & "</b></td></tr></table>"
	str7=str7 & "</table>"
end if
if quote<>"y" then
if NOT userHasRoleInList("NOPRICESUSER") then
	PDF.AddHTMLPos 53, 748, str7
end if
PDF.AddHTMLPos 315, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"
PDF.SetFont "F15", 10, "#999"
PDF.AddTextPos 323, 757, "Customer's Signature"
PDF.AddTextPos 320, 828, "....................................................... Date: " & date()
end if
if termstext<>"" then
		PDF.AddPage
		PDF.SetFont "F1", 8, "#000000"
	
		termstext=replace(termstext, "<p>", "<div style=""font-size:6px;"">")
	termstext=replace(termstext, "</p>", "<br></div>")
	termstext=replace(termstext, "<p align=""center"">", "<div align=""center"">")
		termstext=termstext
		PDF.AddHTML termstext
	end if
end if
'END ACCESSORIES ONLY SECTION


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
		if len(word)<2 then
			word = ucase(word)
		else
			word = ucase(left(word,1)) & (right(word,len(word)-1))
		end if
		capitalise = capitalise & word & " "
	next
	capitalise = left(capitalise, len(capitalise)-1)
end if

end function
con.close
set con=nothing
%>
