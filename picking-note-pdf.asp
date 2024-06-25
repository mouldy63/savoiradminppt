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

<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, deltime, deliverytrue, mattresspicked, mattressbay, basepicked, basebay, topperpicked, topperbay, valancepicked, valancebay, legspicked, legsbay, headboardpicked, headboardbay, itemcount, tobedelivered, itemqty, accessoriespicked, accessoriesbay, accessoryqtysum, rs4, x, y, legqty, hblegqty, xacconorder, amounttobedelivered, accessoryqtysumtofollow, accessoriesinorder, amounttofollow, accessoriestofollow, accesssumtodeliver, showroomtelemail
showroomtelemail=""
accessoriesinorder="n"
itemcount=0
accessoryqtysum=0
'deltime=request("dt")
deltime="10:00 hrs"
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

purchase_no=Request("pn")
'purchase_no=CDbl(Request("val"))
selcted=""
count=0
order=""
submit=""

'payments = getPaymentsForOrder(purchase_no, con)
sql="select * from orderaccessory where (status=110 or status=120 or status=130) and purchase_no=" & purchase_no & " order by orderaccessory_id"
Set rs = getMysqlUpdateRecordSet(sql, con)
if not rs.eof then
	accessoriesrequired="y"
	accessoriesinorder="y"
	xacconorder="<br><br><strong><font family=""Tahoma""><font size=""10"">&nbsp;&nbsp;&nbsp;&nbsp;<b>Accessories Delivered: &nbsp;&nbsp;</b></font></font></strong><table width=""540""><tr><td width=""10"" height=""20""></td><td><font family=""Tahoma""><font size=""10""><b>Item&nbsp;Description</b></font></font></td><td><strong><font family=""Tahoma""><font size=""10""><b>Design</b></font></font></strong></td><td><font family=""Tahoma""><font size=""10""><b>Colour</b></font></font></td><td><font size=""10""><b>Size</b></font></font></td><td align=""right""><font size=""10""><b>Qty</b></font></font></td></tr>"
	do until rs.eof
	xacconorder=xacconorder & "<tr ><td width=""10"" height=""10""></td>"
	xacconorder=xacconorder & "<td width=""180"">" & rs("description") & "</td>"
	xacconorder=xacconorder & "<td width=""150"">" & rs("design") & "</td>"
	xacconorder=xacconorder & "<td width=""100"">" & rs("colour") & "</td>"
	xacconorder=xacconorder & "<td width=""50"">" & rs("size") & "</td>"
	if rs("qtytofollow")>0 then
	amounttobedelivered=rs("qty")-rs("qtytofollow") 
	amounttofollow=rs("qtytofollow")
	else
	amounttobedelivered=rs("qty")
	end if
	xacconorder=xacconorder & "<td width=""50"" align=""right"">" & amounttobedelivered & "</td>"
	accessoryqtysumtofollow=accessoryqtysumtofollow+amounttofollow
	xacconorder=xacconorder & "</tr>"
	accesscost=0 
	accesssumtodeliver=accesssumtodeliver+amounttobedelivered	
	rs.movenext
	loop
	xacconorder=xacconorder & "</table>"
end if
rs.close
set rs = nothing

sql="select * from orderaccessory where (status <> 0  and status <>110 and status <>120 and status <> 70 and status <> 80) and purchase_no=" & purchase_no & " order by orderaccessory_id"
Set rs = getMysqlUpdateRecordSet(sql, con)
if not rs.eof then
	accessoriesrequired="y"
	accessoriestofollow="y"
	xaccfollowing="<br><br><strong><font family=""Tahoma""><font size=""10"">&nbsp;&nbsp;&nbsp;&nbsp;<b>Accessories To Follow: &nbsp;&nbsp;</b></font></font></strong><table width=""540""><tr><td width=""10"" height=""20""></td><td><font family=""Tahoma""><font size=""10""><b>Item&nbsp;Description</b></font></font></td><td><strong><font family=""Tahoma""><font size=""10""><b>Design</b></font></font></strong></td><td><font family=""Tahoma""><font size=""10""><b>Colour</b></font></font></td><td><font size=""10""><b>Size</b></font></font></td><td align=""right""><font size=""10""><b>Qty</b></font></font></td></tr>"
	do until rs.eof
	xaccfollowing=xaccfollowing & "<tr ><td width=""10"" height=""10""></td>"
	xaccfollowing=xaccfollowing & "<td width=""180"">" & rs("description") & "</td>"
	xaccfollowing=xaccfollowing & "<td width=""150"">" & rs("design") & "</td>"
	xaccfollowing=xaccfollowing & "<td width=""100"">" & rs("colour") & "</td>"
	xaccfollowing=xaccfollowing & "<td width=""50"">" & rs("size") & "</td>"
	if rs("qtytofollow")>0 then 
	amounttofollow=rs("qtytofollow")
	else
	amounttofollow=rs("qty")
	end if
	xaccfollowing=xaccfollowing & "<td width=""50"" align=""right"">" & amounttofollow & "</td>"
	accessoryqtysumtofollow=accessoryqtysumtofollow+amounttofollow
	xaccfollowing=xaccfollowing & "</tr>"
	accesscost=0 
	rs.movenext
	loop
	xaccfollowing=xaccfollowing & "</table>"
	
end if
rs.close
set rs = nothing


Set rs = getMysqlQueryRecordSet("Select * from purchase WHERE purchase_no=" & purchase_no & "", con)
if rs("legqty")<>"" and NOT ISNULL(rs("legqty")) then legqty=rs("legqty")
if rs("addlegqty")<>"" and NOT ISNULL(rs("addlegqty")) then legqty=legqty + rs("addlegqty")
if rs("headboardlegqty")<>"" and NOT ISNULL(rs("headboardlegqty")) then hblegqty= rs("headboardlegqty")
deliveryaddress="<font family=""Tahoma""><font size=""8"">"
If rs("deliveryadd1") <> "" then deliverytrue=1 AND deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd1")) & "<br />"
If rs("deliveryadd2") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd2")) & "<br />"
If rs("deliveryadd3") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd3")) & "<br />"
If rs("deliverytown") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverytown")) & "<br />"
If rs("deliverycounty") <> "" then deliverytrue=1 AND deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverycounty")) & "<br />"
If rs("deliverypostcode") <> "" then deliverytrue=1 AND deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverypostcode")) & "<br />"
If rs("deliverycountry") <> "" then deliverytrue=1 AND deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverycountry"))
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
If rs2("email")<>"" then showroomtelemail=showroomtelemail & "&nbsp;&nbsp;Email: " & rs2("email")
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

If rs1("title") <> "" Then custname=custname & Utf8ToUnicode(capitaliseName(rs1("title"))) & " "
If rs1("first") <> "" Then custname=custname & Utf8ToUnicode(capitaliseName(rs1("first"))) & " "
If rs1("surname") <> "" Then custname=custname & Utf8ToUnicode(capitaliseName(rs1("surname")))
clienthdg="<font family=""Tahoma""><font size=""8"">"
clienthdg=clienthdg & "<b>Client: </b><br />"
clienthdg=clienthdg & "<b>Company: </b><br />"
if rs1("company_vat_no")<>"" then clienthdg=clienthdg & "<b>VAT No: </b><br />"
clienthdg=clienthdg & "<b>Home Tel: </b><br />"
clienthdg=clienthdg & "<b>Work Tel: </b><br />"
clienthdg=clienthdg & "<b>Mobile: </b><br />"
clienthdg=clienthdg & "<b>Email: </b><br />"
clienthdg=clienthdg & "<b>Client Ref: </b><br />"
clienthdg=clienthdg & "</font></font>"

clientdetails="<font family=""Tahoma""><font size=""8"">"
clientdetails=clientdetails & custname & "<br />"
clientdetails=clientdetails & Utf8ToUnicode(rs2("company")) & "<br />"
if rs1("company_vat_no")<>"" then clientdetails=clientdetails & rs1("company_vat_no") & "<br />"
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
if deliverytrue="" then deliveryaddress=custaddress
s = "<br><br><table cellpadding=""1""> "
s = s & " <tr height=""0""><td colspan=""7"" height=""0""></td></tr>"
s = s & " <tr><td width=""11"" height=""55""></td> "
s = s & " <td width=""54"" valign=""top"">" & clienthdg & "</td><td width=""112"" valign=""top"">" & clientdetails & "</td><td width=""24""></td><td width=""166"">&nbsp;</td><td width=""24""></td><td width=""166""></td> "
s = s & " </tr> "
s = s & " </table> "
 



'Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=9 order by qc_date desc", con)
	'	if not rs3.eof then
	'		if rs3("qc_statusid")=60 then 
	'			accessoriespicked="y" 
	'			else 
	'			if rs3("qc_statusid")<>70 and rs3("qc_statusid")<>80 then tobedelivered=tobedelivered & "Accessories<br>"
	'		end if
	'	end if
	'rs3.close
	'set rs3=nothing

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
const csPropGraphLineColor=405
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
PDF.SetMargins 10,1,10,5


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
if rs("mattressrequired")="y" or rs("topperrequired")="y" or rs("baserequired")="y" or rs("headboardrequired")="y" or rs("valancerequired")="y" or rs("legsrequired")="y" then accessoriesonly="n" else accessoriesonly="y"

if accessoriesonly="n" then 

DrawBox 20,93, 180, 95




'end TOTAL DETAILS
'PAYMENTS
DrawBox 20,764, 270, 70
'end PAYMENTS
'CUST SIG
DrawBox 310,764, 270, 70
'end CUST SIG


PDF.AddHTML "<p align=""right""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
PDF.AddTextPos 20, 20, "Order No. " & rs("order_number")
PDF.SetFont "F15", 16, "#999"
PDF.AddTextPos 230, 30, "Picking Note"
PDF.SetFont "F15", 10, "#999"
If rs("bookeddeliverydate")<>"" then 
PDF.AddTextPos 20, 40, "Delivery Date. " & FormatDateTime(rs("bookeddeliverydate"),vbShortDate)
end if
PDF.SetFont "F15", 9, "#999"
PDF.AddTextPos 20, 67, "Showroom: " & showroomaddress
PDF.AddTextPos 20, 80, showroomtelemail
PDF.AddHTML "<hr>"
PDF.AddHTMLPos 25, 69, s


PDF.AddHTMLPos 25, 85, "<img src=""images/whitebg.png"" width=""95"" height=""16"">"
PDF.AddHTMLPos 215, 85, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 405, 85, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"


'PDF.AddHTMLPos 25, 342, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
'PDF.AddHTMLPos 25, 402, "<img src=""images/whitebg.png"" width=""132"" height=""16"">"
'PDF.AddHTMLPos 25, 500, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
'PDF.AddHTMLPos 25, 600, "<img src=""images/whitebg.png"" width=""230"" height=""16"">"
PDF.AddHTMLPos 25, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"
PDF.AddHTMLPos 315, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"

PDF.AddTextPos 33, 97, "Client Details"


'PDF.AddTextPos 33, 352, "Topper"

'PDF.AddTextPos 33, 508, "Headboard"
PDF.AddTextPos 33, 767, "Signature"

PDF.AddTextPos 323, 767, "Signature"


PDF.SetFont "F15", 8, "#999"
PDF.AddHTMLPos 533, 190, "<font family=""Tahoma""><font size=""8""><b>TOTALS</b></font></font>"
PDF.AddHTMLPos 570, 190, "<font family=""Tahoma""><font size=""8""><b>BAY</b></font></font>"

y=65
x=195
'MATTRESS REQ'
If rs("mattressrequired")="y" then

Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=1 order by qc_date desc", con)
		if not rs3.eof then
			if rs3("qc_statusid")>0 and rs3("qc_statusid")<50 or rs3("qc_statusid")=90 then tobedelivered="Mattress<br>" 
			if rs3("qc_statusid")=50  then 
			Set rs4 = getMysqlQueryRecordSet("Select * from bay_content WHERE orderid=" & rs("order_number") & " AND componentid=1", con)
			if not rs4.eof then
				mattressbay=CStr(rs4("baynumber"))
				if mattressbay="40" then mattressbay="Car"
				if mattressbay="42" then mattressbay="NYW"
				if mattressbay="43" then mattressbay="NYU"
				if mattressbay="44" then mattressbay="NYD"
				mattresspicked="y"
				else
				mattressbay="0"
			end if
			rs4.close
			set rs4=nothing
			end if
		end if
	rs3.close
	set rs3=nothing
'MATTRESS REQ
if mattresspicked="y" then
PDF.AddLine 567, x, 567, x+73
DrawBox 20,x, 510, y
PDF.SetProperty csPropGraphLineColor, "silver"
DrawBox 25,x+34, 500, y-40
PDF.SetProperty csPropGraphLineColor, "black"
PDF.AddHTMLPos 25, 190, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
PDF.AddTextPos 33, 199, "Mattress"

	
	PDF.AddHTMLPos 33, x+5, "<font family=""Tahoma""><font size=""8""><b>Model:</b></font></font>"
	PDF.AddHTMLPos 63, x+5, "<font family=""Tahoma""><font size=""8"">" & rs("savoirmodel") & "</font></font>"
	PDF.AddHTMLPos 100, x+5, "<font family=""Tahoma""><font size=""8""><b>Type:</b></font></font>"
	PDF.AddHTMLPos 123, x+5, "<font family=""Tahoma""><font size=""8"">" & rs("mattresstype") & "</font></font>"
	PDF.AddHTMLPos 205, x+5, "<font family=""Tahoma""><font size=""8""><b>Width:</b></font></font>"
	PDF.AddHTMLPos 232, x+5, "<font family=""Tahoma""><font size=""8"">" & rs("mattresswidth") & "</font></font>"
	PDF.AddHTMLPos 345, x+5, "<font family=""Tahoma""><font size=""8""><b>Length:</b></font></font>"
	PDF.AddHTMLPos 377, x+5, "<font family=""Tahoma""><font size=""8"">" & rs("mattresslength") & "</font></font>"
	PDF.AddHTMLPos 440, x+17, "<font family=""Tahoma""><font size=""8""><b>Ticking:</b></font></font>"
	PDF.AddHTMLPos 472, x+17, "<font family=""Tahoma""><font size=""8"">" & rs("tickingoptions") & "</font></font>"
	
	
	PDF.AddHTMLPos 33, x+17, "<font family=""Tahoma""><font size=""8""><b>LHS:</b></font></font>"
	PDF.AddHTMLPos 55, x+17, "<font family=""Tahoma""><font size=""8"">" & rs("leftsupport") & "</font></font>"
	PDF.AddHTMLPos 100, x+17, "<font family=""Tahoma""><font size=""8""><b>RHS:</b></font></font>"
	PDF.AddHTMLPos 125, x+17, "<font family=""Tahoma""><font size=""8"">" & rs("rightsupport") & "</font></font>"
	PDF.AddHTMLPos 205, x+17, "<font family=""Tahoma""><font size=""8""><b>Vent Position:</b></font></font>"
	PDF.AddHTMLPos 261, 212, "<font family=""Tahoma""><font size=""8"">" & rs("ventposition") & "</font></font>"
	PDF.AddHTMLPos 345, x+17, "<font family=""Tahoma""><font size=""8""><b>Vent Finish:</b></font></font>"
	PDF.AddHTMLPos 394, x+17, "<font family=""Tahoma""><font size=""8"">" & rs("ventfinish") & "</font></font>"
	
	if mattresspicked="y" then 
	if left(rs("mattresstype"),6)="Zipped" then 
		itemqty=2 
		itemcount=itemcount+itemqty
		else 
		itemqty=1
		itemcount=itemcount+itemqty
	end if
	PDF.AddHTMLPos 533, x+9, "<font family=""Tahoma""><font size=""8""><b>QTY: " & itemqty & "</b></font></font>"
	PDF.AddHTMLPos 571, x+9, "<font family=""Tahoma""><font size=""8""><b>" & mattressbay & "</b></font></font>"
	else
	PDF.AddHTMLPos 533, x+39, "<font family=""Tahoma""><font size=""8""><b>QTY: 0</b></font></font>"
	end if
	
	if mattresspicked="y" then
		If rs("mattressinstructions")<>"" then
		str=rs("mattressinstructions")
		PDF.SetFont "F15", 6, "#999"
		PDF.SetProperty csPropAddTextWidth , 2
		PDF.AddTextWidth 33,x+41,490, str
		end if
	end if
	x=x+73
	PDF.SetFont "F15", 8, "#999"
end if
end if
'MATTRESS REQ END

'BASE REQ
If rs("baserequired")="y" then

Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=3 order by qc_date desc", con)
		if not rs3.eof then
		if rs3("qc_statusid")>0 and rs3("qc_statusid")<50 or rs3("qc_statusid")=90 then tobedelivered="Base<br>" 
			if rs3("qc_statusid")=50 then 
				Set rs4 = getMysqlQueryRecordSet("Select * from bay_content WHERE orderid=" & rs("order_number") & " AND componentid=3", con)
				if not rs4.eof then
				basebay=CStr(rs4("baynumber"))
				if basebay="40" then basebay="Car"
				if basebay="42" then basebay="NYW"
				if basebay="43" then basebay="NYU"
				if basebay="44" then basebay="NYD"
				basepicked="y"
				else
				basebay="0"
				end if
				rs4.close
				set rs4=nothing
			end if
		end if
	rs3.close
	set rs3=nothing

if basepicked="y" then
PDF.AddLine 567, x, 567, x+85
DrawBox 20,x, 510, y+10
PDF.SetProperty csPropGraphLineColor, "silver"
DrawBox 25,x+44, 500, 25
PDF.SetProperty csPropGraphLineColor, "black"
PDF.AddHTMLPos 25, x-4, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
PDF.AddTextPos 33, x+3, "Base"
'end BASE
	
PDF.AddHTMLPos 33, x+3, "<font family=""Tahoma""><font size=""8""><b>Model:</b></font></font>"
PDF.AddHTMLPos 63, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("basesavoirmodel") & "</font></font>"
PDF.AddHTMLPos 100, x+3, "<font family=""Tahoma""><font size=""8""><b>Type:</b></font></font>"
PDF.AddHTMLPos 123, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("basetype") & "</font></font>"
PDF.AddHTMLPos 205, x+3, "<font family=""Tahoma""><font size=""8""><b>Width:</b></font></font>"
PDF.AddHTMLPos 232, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("basewidth") & "</font></font>"
PDF.AddHTMLPos 375, x+3, "<font family=""Tahoma""><font size=""8""><b>Length:</b></font></font>"
PDF.AddHTMLPos 407, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("baselength") & "</font></font>"

PDF.AddHTMLPos 33, x+15, "<font family=""Tahoma""><font size=""8""><b>Link Position:</b></font></font>"
PDF.AddHTMLPos 88, x+15, "<font family=""Tahoma""><font size=""8"">" & rs("linkposition") & "</font></font>"
PDF.AddHTMLPos 205, x+15, "<font family=""Tahoma""><font size=""8""><b>Link Finish:</b></font></font>"
PDF.AddHTMLPos 252, x+15, "<font family=""Tahoma""><font size=""8"">" & rs("linkfinish") & "</font></font>"
PDF.AddHTMLPos 375, x+15, "<font family=""Tahoma""><font size=""8""><b>Ticking:</b></font></font>"
PDF.AddHTMLPos 407, x+15, "<font family=""Tahoma""><font size=""8"">" & rs("basetickingoptions") & "</font></font>"

PDF.AddHTMLPos 33, x+27, "<font family=""Tahoma""><font size=""8""><b>Upholstered Base:</b></font></font>"
if basepicked="y" then PDF.AddHTMLPos 105, x+27, "<font family=""Tahoma""><font size=""8"">" & rs("upholsteredbase") & "</font></font>"
PDF.AddHTMLPos 205, x+27, "<font family=""Tahoma""><font size=""8""><b>Extented Base:</b></font></font>"
if basepicked="y" then PDF.AddHTMLPos 265, x+27, "<font family=""Tahoma""><font size=""8"">" & rs("extbase") & "</font></font>"
PDF.AddHTMLPos 375, x+27, "<font family=""Tahoma""><font size=""8""><b>Drawers:</b></font></font>"
if basepicked="y" then PDF.AddHTMLPos 411, x+27, "<font family=""Tahoma""><font size=""8"">" & rs("basedrawers") & "</font></font>"

	if left(rs("basetype"),4)="Nort"  or left(rs("basetype"),4)="East" then 
		itemqty=2
		itemcount=itemcount+2
		else 
		itemqty=1
		itemcount=itemcount+1
	end if
	PDF.AddHTMLPos 533, x+5, "<font family=""Tahoma""><font size=""8""><b>QTY: " & itemqty & "</b></font></font>"
	PDF.AddHTMLPos 571, x+5, "<font family=""Tahoma""><font size=""8""><b>" & basebay & "</b></font></font>"
		If rs("baseinstructions")<>"" then
		str2=rs("baseinstructions")
		PDF.SetFont "F15", 6, "#999"
		PDF.SetProperty csPropAddTextWidth , 2
		PDF.AddTextWidth 33,x+52,490, str2
		end if


x=x+85
end if
end if
'BASE REQ END

'LEGS REQ
if rs("legsrequired")="y" then
PDF.SetFont "F15", 8, "#999"
Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=7 order by qc_date desc", con)
		if not rs3.eof then
		if rs3("qc_statusid")>0 and rs3("qc_statusid")<50 or rs3("qc_statusid")=90 then tobedelivered="Legs<br>" 
			if rs3("qc_statusid")=50  then 
				Set rs4 = getMysqlQueryRecordSet("Select * from bay_content WHERE orderid=" & rs("order_number") & " AND componentid=7", con)
				if not rs4.eof then
					legsbay=CStr(rs4("baynumber"))
					if legsbay="40" then legsbay="Car"
					if legsbay="42" then legsbay="NYW"
					if legsbay="43" then legsbay="NYU"
					if legsbay="44" then legsbay="NYD"
					legspicked="y"
					itemcount=itemcount+1
					else
					legsbay="0"
				end if
				rs4.close
				set rs4=nothing
			end if
		end if
	rs3.close
	set rs3=nothing
if legspicked="y" then
PDF.AddLine 567, x, 567, x+40
DrawBox 20,x, 510, y-34
PDF.SetProperty csPropGraphLineColor, "silver"
'DrawBox 25,x+34, 500, 25
PDF.SetProperty csPropGraphLineColor, "black"
PDF.AddHTMLPos 25, x-4, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
PDF.AddTextPos 33, x+3, "Legs"

	
PDF.AddHTMLPos 33, x+3, "<font family=""Tahoma""><font size=""8""><b>Leg Style:</b></font></font>"
PDF.AddHTMLPos 75, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("legstyle") & "</font></font>"
PDF.AddHTMLPos 205, x+3, "<font family=""Tahoma""><font size=""8""><b>Leg Finish:</b></font></font>"
PDF.AddHTMLPos 250, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("legfinish") & "</font></font>"
PDF.AddHTMLPos 375, x+3, "<font family=""Tahoma""><font size=""8""><b>Leg Height:</b></font></font>"
PDF.AddHTMLPos 421, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("legheight") & "</font></font>"
PDF.AddHTMLPos 33, x+15, "<font family=""Tahoma""><font size=""8""><b>Leg Qty:</b></font></font>"
PDF.AddHTMLPos 75, x+15, "<font family=""Tahoma""><font size=""8"">" & legqty & "</font></font>"

		itemqty=1
	
	PDF.AddHTMLPos 533, x+5, "<font family=""Tahoma""><font size=""8""><b>QTY: " & itemqty & "</b></font></font>"
	PDF.AddHTMLPos 571, x+5, "<font family=""Tahoma""><font size=""8""><b>" & legsbay & "</b></font></font>"
x=x+40
end if
end if
'END IF

'IF TOPPER REQ
If rs("topperrequired")="y" then
PDF.SetFont "F15", 8, "#999"
	Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=5 order by qc_date desc", con)
		if not rs3.eof then
		if rs3("qc_statusid")>0 and rs3("qc_statusid")<50 or rs3("qc_statusid")=90 then tobedelivered="Topper<br>" 
			if rs3("qc_statusid")=50 then
				Set rs4 = getMysqlQueryRecordSet("Select * from bay_content WHERE orderid=" & rs("order_number") & " AND componentid=5", con)
				if not rs4.eof then
				topperbay=CStr(rs4("baynumber"))
				if topperbay="40" then topperbay="Car"
				if topperbay="42" then topperbay="NYW"
				if topperbay="43" then topperbay="NYU"
				if topperbay="44" then topperbay="NYD"
				topperpicked="y" 
				itemcount=itemcount+1
				itemqty=1
				else
				topperbay="0"
				end if
				
				rs4.close
				set rs4=nothing 
			end if
		end if
	rs3.close
	set rs3=nothing
if topperpicked="y" then
PDF.AddLine 567, x, 567, x+74
	DrawBox 20,x, 510, y
	PDF.SetProperty csPropGraphLineColor, "silver"
	DrawBox 25,x+34, 500, 25
	PDF.SetProperty csPropGraphLineColor, "black"
	PDF.AddHTMLPos 25, x-4, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
	PDF.AddTextPos 33, x+3, "Topper"
	PDF.AddHTMLPos 33, x+3, "<font family=""Tahoma""><font size=""8""><b>Model:</b></font></font>"
	PDF.AddHTMLPos 61, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("toppertype") & "</font></font>"
	PDF.AddHTMLPos 205, x+3, "<font family=""Tahoma""><font size=""8""><b>Width:</b></font></font>"
	PDF.AddHTMLPos 232, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("topperwidth") & "</font></font>"
	PDF.AddHTMLPos 375, x+3, "<font family=""Tahoma""><font size=""8""><b>Length:</b></font></font>"
	PDF.AddHTMLPos 405, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("topperlength") & "</font></font>"
	PDF.AddHTMLPos 33, x+15, "<font family=""Tahoma""><font size=""8""><b>Ticking:</b></font></font>"
	PDF.AddHTMLPos 66, x+15, "<font family=""Tahoma""><font size=""8"">" & rs("toppertickingoptions") & "</font></font>"
	
		PDF.AddHTMLPos 533, x+5, "<font family=""Tahoma""><font size=""8""><b>QTY: " & itemqty & "</b></font></font>"
		PDF.AddHTMLPos 571, x+5, "<font family=""Tahoma""><font size=""8""><b>" & topperbay & "</b></font></font>"
		
		
			If rs("specialinstructionstopper")<>"" then
			str3=rs("specialinstructionstopper")
			PDF.SetFont "F15", 6, "#999"
			PDF.SetProperty csPropAddTextWidth , 2
			PDF.AddTextWidth 33,x+42,490, str3
			end if
			x=x+74
	end if
end if
'TOPPER REQ END
'VALANCE REQ
If rs("valancerequired")="y" then
PDF.SetFont "F15", 8, "#999"
	
	Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=6 order by qc_date desc", con)
		if not rs3.eof then
		if rs3("qc_statusid")>0 and rs3("qc_statusid")<50 or rs3("qc_statusid")=90 then tobedelivered="Valance<br>" 
			if rs3("qc_statusid")=50 then 
				Set rs4 = getMysqlQueryRecordSet("Select * from bay_content WHERE orderid=" & rs("order_number") & " AND componentid=6", con)
				if not rs4.eof then
				valancebay=CStr(rs4("baynumber"))
				if valancebay="40" then valancebay="Car"
				if valancebay="42" then valancebay="NYW"
				if valancebay="43" then valancebay="NYU"
				if valancebay="44" then valancebay="NYD"
				valancepicked="y" 
				itemqty=1
				itemcount=itemcount+itemqty
				else
				valancebay="0"
				end if
				rs4.close
				set rs4=nothing 
			end if
		end if
	rs3.close
	set rs3=nothing
if valancepicked = "y" then	 
PDF.AddLine 567, x, 567, x+84
DrawBox 20,x, 510, y+10
	PDF.SetProperty csPropGraphLineColor, "silver"
	DrawBox 25,x+44, 500, 25
	PDF.SetProperty csPropGraphLineColor, "black"
	PDF.AddHTMLPos 25, x-4, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
	PDF.AddTextPos 33, x+3, "Valance"
	
	PDF.AddHTMLPos 33, x+3, "<font family=""Tahoma""><font size=""8""><b>Fabric Selection:</b></font></font>"
PDF.AddHTMLPos 105, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("valancefabric") & "</font></font>"
PDF.AddHTMLPos 375, x+3, "<font family=""Tahoma""><font size=""8""><b>No. of Pleats:</b></font></font>"
	PDF.AddHTMLPos 430, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("pleats") & "</font></font>"
PDF.AddHTMLPos 33, x+15, "<font family=""Tahoma""><font size=""8""><b>Description:</b></font></font>"
PDF.AddHTMLPos 86, x+15, "<font family=""Tahoma""><font size=""8"">" & rs("valancefabricchoice") & "</font></font>"
PDF.AddHTMLPos 375, x+15, "<font family=""Tahoma""><font size=""8""><b>Direction:</b></font></font>"
PDF.AddHTMLPos 415, x+15, "<font family=""Tahoma""><font size=""8"">" & rs("valancefabricdirection") & "</font></font>"

PDF.AddHTMLPos 33, x+27, "<font family=""Tahoma""><font size=""8""><b>Width:</b></font></font>"
PDF.AddHTMLPos 60, x+27, "<font family=""Tahoma""><font size=""8"">" & rs("valancewidth") & "</font></font>"
PDF.AddHTMLPos 205, x+27, "<font family=""Tahoma""><font size=""8""><b>Length:</b></font></font>"
PDF.AddHTMLPos 238, x+27, "<font family=""Tahoma""><font size=""8"">" & rs("valancelength") & "</font></font>"
PDF.AddHTMLPos 375, x+27, "<font family=""Tahoma""><font size=""8""><b>Drop:</b></font></font>"
PDF.AddHTMLPos 399, x+27, "<font family=""Tahoma""><font size=""8"">" & rs("valancedrop") & "</font></font>"

		If rs("specialinstructionsvalance")<>"" then
		str4=rs("specialinstructionsvalance")
		PDF.SetFont "F15", 6, "#999"
		PDF.SetProperty csPropAddTextWidth , 2
		PDF.AddTextWidth 33,x+52,490, str4
		end if
		PDF.AddHTMLPos 533, x+5, "<font family=""Tahoma""><font size=""8""><b>QTY: " & itemqty & "</b></font></font>"
		PDF.AddHTMLPos 571, x+5, "<font family=""Tahoma""><font size=""8""><b>" & valancebay & "</b></font></font>"
x=x+84
end if
end if


'VALANCE END

'headboard options
if rs("headboardrequired")="y" then
PDF.SetFont "F15", 8, "#999" 
	Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=8 order by qc_date desc", con)
		if not rs3.eof then
		if rs3("qc_statusid")>0 and rs3("qc_statusid")<50 or rs3("qc_statusid")=90 then tobedelivered="Headboard<br>" 
			if rs3("qc_statusid")=50 then 
				Set rs4 = getMysqlQueryRecordSet("Select * from bay_content WHERE orderid=" & rs("order_number") & " AND componentid=8", con)
				if not rs4.eof then
				headboardbay=CStr(rs4("baynumber"))
				if headboardbay="40" then headboardbay="Car"
				if headboardbay="42" then headboardbay="NYW"
				if headboardbay="43" then headboardbay="NYU"
				if headboardbay="44" then headboardbay="NYD"
				headboardpicked="y"
				itemqty=1
				itemcount=itemcount+itemqty
				else
				headboardbay="0"
				end if
				rs4.close
				set rs4=nothing 
			end if
		end if
	rs3.close
	set rs3=nothing
if headboardpicked="y" then 
PDF.AddLine 567, x, 567, x+75
	DrawBox 20,x, 510, y+10
	PDF.SetProperty csPropGraphLineColor, "silver"
	DrawBox 25,x+44, 500, 25
	PDF.SetProperty csPropGraphLineColor, "black"
	PDF.AddHTMLPos 25, x-4, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
	PDF.AddTextPos 33, x+3, "Headboard"
PDF.AddHTMLPos 33, x+3, "<font family=""Tahoma""><font size=""8""><b>Style:</b></font></font>"
PDF.AddHTMLPos 57, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("headboardstyle") & "</font></font>"
PDF.AddHTMLPos 205, x+3, "<font family=""Tahoma""><font size=""8""><b>Finish:</b></font></font>"
PDF.AddHTMLPos 235, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("headboardfinish") & "</font></font>"
PDF.AddHTMLPos 375, x+3, "<font family=""Tahoma""><font size=""8""><b>Height:</b></font></font>"
PDF.AddHTMLPos 407, x+3, "<font family=""Tahoma""><font size=""8"">" & rs("headboardheight") & "</font></font>"

PDF.AddHTMLPos 33, x+15, "<font family=""Tahoma""><font size=""8""><b>Fabric Selection:</b></font></font>"
PDF.AddHTMLPos 99, x+15, "<font family=""Tahoma""><font size=""8"">" & rs("headboardfabric") & "</font></font>"
PDF.AddHTMLPos 375, x+15, "<font family=""Tahoma""><font size=""8""><b>Direction:</b></font></font>"
PDF.AddHTMLPos 414, x+15, "<font family=""Tahoma""><font size=""8"">" & rs("headboardfabricdirection") & "</font></font>"
PDF.AddHTMLPos 33, x+27, "<font family=""Tahoma""><font size=""8""><b>Description:</b></font></font>"
PDF.AddHTMLPos 81, x+27, "<font family=""Tahoma""><font size=""8"">" & rs("headboardfabricchoice") & "</font></font>"
PDF.AddHTMLPos 375, x+27, "<font family=""Tahoma""><font size=""8""><b>Leg Qty:</b></font></font>"
PDF.AddHTMLPos 410, x+27, "<font family=""Tahoma""><font size=""8"">" & hblegqty & "</font></font>"

	If rs("specialinstructionsheadboard")<>"" then
	str5=rs("specialinstructionsheadboard")
	PDF.SetFont "F15", 6, "#999"
	PDF.SetProperty csPropAddTextWidth , 2
	PDF.AddTextWidth 33,x+54,490, str5
	end if
		
	PDF.AddHTMLPos 533, x+5, "<font family=""Tahoma""><font size=""8""><b>QTY: " & itemqty & "</b></font></font>"
	PDF.AddHTMLPos 571, x+5, "<font family=""Tahoma""><font size=""8""><b>" & headboardbay & "</b></font></font>"

	
	x=x+84	
end if	
end if



PDF.SetFont "F15", 8, "#999"
PDF.SetProperty csPropAddTextWidth , 2
if accessoryqtysumtofollow > 0 then tobedelivered="Accessories<br>" 
if tobedelivered<>"" then
PDF.AddHTMLPos 33,x+10, "<b>To be delivered:</b>"
PDF.AddTextWidth 33,x+32,490, tobedelivered
End if


DrawBox 310,x+16, 270, 25
PDF.AddHTMLPos 320, x+20, "<b>TOTAL BED ITEMS DELIVERED</b>"
PDF.AddHTMLPos 550, x+20, "<b>" & itemcount & "</b>"



PDF.AddHTMLPos 30, 740, "<font family=""Tahoma""><font size=""12"">These items have been picked by:</font></font>"


PDF.AddTextPos 30, 828, ".................................................................................."  & Date()


PDF.AddTextPos 320, 828, "................................................................................."  & Date()



'ACCESSORIES  SECTION
if rs("accessoriesrequired")="y" then
PDF.AddPage
DrawBox 20,96, 180, 95
'DrawBox 210,96, 180, 95
'DrawBox 400,96, 180, 95

DrawBox 20,200, 560, 405
DrawBox 20,764, 270, 70
'end PAYMENTS
'CUST SIG
DrawBox 310,764, 270, 70
'end CUST SIG

PDF.AddHTML "<p align=""right""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
PDF.AddTextPos 20, 20, "Order No. " & rs("order_number")
PDF.SetFont "F15", 16, "#999"
PDF.AddTextPos 230, 30, "Picking Note"
PDF.SetFont "F15", 10, "#999"
If rs("bookeddeliverydate")<>"" then 
PDF.AddTextPos 20, 40, "Delivery Date. " & FormatDateTime(rs("bookeddeliverydate"),vbShortDate)
end if
PDF.SetFont "F15", 9, "#999"
PDF.AddTextPos 20, 67, "Showroom: " & showroomaddress
PDF.AddTextPos 20, 80, showroomtelemail
PDF.AddHTML "<hr>"
PDF.AddHTMLPos 25, 71, s

PDF.AddHTMLPos 25, 92, "<img src=""images/whitebg.png"" width=""95"" height=""16"">"
PDF.AddHTMLPos 215, 92, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 405, 92, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 25, 192, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
PDF.SetFont "F15", 8, "#999"

PDF.AddTextPos 33, 101, "Client Details"
PDF.AddTextPos 33, 205, "Accessories"

If accessoriesinorder="y" then PDF.AddHTML xacconorder


if accessoriestofollow="y" then PDF.AddHTML xaccfollowing
If accessoriesrequired="y" then
DrawBox 310,x+256, 270, 25
PDF.AddHTMLPos 320, x+260, "<b>TOTAL ACCESSORIES DELIVERED</b>"
PDF.AddHTMLPos 530, x+260, "<b>" & accesssumtodeliver & "</b>"
end if

PDF.AddHTMLPos 25, 630, "<img src=""images/whitebg.png"" width=""230"" height=""16"">"


PDF.SetFont "F15", 8, "#999"



PDF.AddHTMLPos 25, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"
PDF.AddHTMLPos 315, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"

PDF.AddHTMLPos 30, 740, "<font family=""Tahoma""><font size=""12"">These items have been picked by:</font></font>"
PDF.AddTextPos 33, 767, "Signature"
PDF.AddTextPos 323, 767, "Signature"

PDF.AddTextPos 30, 828, ".................................................................................."  & Date()


PDF.AddTextPos 320, 828, "................................................................................."  & Date()

end if
else
		
		'ACCESSORIES  SECTION
if accessoriesonly="y" then

DrawBox 20,96, 180, 95
'DrawBox 210,96, 180, 95
'DrawBox 400,96, 180, 95

DrawBox 20,200, 560, 405
DrawBox 20,764, 270, 70
'end PAYMENTS
'CUST SIG
DrawBox 310,764, 270, 70
'end CUST SIG

PDF.AddHTML "<p align=""right""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
PDF.AddTextPos 20, 20, "Order No. " & rs("order_number")
PDF.SetFont "F15", 16, "#999"
PDF.AddTextPos 230, 30, "Picking Note"
PDF.SetFont "F15", 10, "#999"
If rs("bookeddeliverydate")<>"" then 
PDF.AddTextPos 20, 40, "Delivery Date. " & FormatDateTime(rs("bookeddeliverydate"),vbShortDate)
end if
PDF.SetFont "F15", 9, "#999"
PDF.AddTextPos 20, 67, "Showroom: " & showroomaddress
PDF.AddTextPos 20, 80, showroomtelemail
PDF.AddHTML "<hr>"
PDF.AddHTMLPos 25, 71, s

PDF.AddHTMLPos 25, 92, "<img src=""images/whitebg.png"" width=""95"" height=""16"">"
PDF.AddHTMLPos 215, 92, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 405, 92, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 25, 192, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
PDF.SetFont "F15", 8, "#999"

PDF.AddTextPos 33, 101, "Client Details"
PDF.AddTextPos 33, 205, "Accessories"

If accessoriesinorder="y" then PDF.AddHTML xacconorder


if accessoriestofollow="y" then PDF.AddHTML xaccfollowing
If accessoriesrequired="y" then
DrawBox 310,x+556, 270, 25
PDF.AddHTMLPos 320, x+560, "<b>TOTAL ACCESSORIES DELIVERED</b>"
PDF.AddHTMLPos 530, x+560, "<b>" & accesssumtodeliver & "</b>"
end if

PDF.AddHTMLPos 25, 630, "<img src=""images/whitebg.png"" width=""230"" height=""16"">"


PDF.SetFont "F15", 8, "#999"



PDF.AddHTMLPos 25, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"
PDF.AddHTMLPos 315, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"

PDF.AddHTMLPos 30, 740, "<font family=""Tahoma""><font size=""12"">These items have been picked by:</font></font>"
PDF.AddTextPos 33, 767, "Signature"
PDF.AddTextPos 323, 767, "Signature"

PDF.AddTextPos 30, 828, ".................................................................................."  & Date()


PDF.AddTextPos 320, 828, "................................................................................."  & Date()

end if


end if
'END ACCESSORIES  SECTION


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
