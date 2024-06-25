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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, deltime, deliverytrue, mattresspicked, basepicked, topperpicked, valancepicked,  legspicked, headboardpicked, itemcount, tobedelivered, itemqty, accessoriespicked, accessoryqtysum, valencelength, valancewidth, valancedrop, matttable, matttable2, mattqty, mattwidth1, mattwidth2, mattlength1, mattlength2, toptable, topperqty, baseqty, basetable, basewidth1, basewidth2, baselength1, baselength2, eastwest, northsouth, wrappingtype, x, y, mattspecial, userlocation, showmattress, showtopper, showbase, mattressfactory, topperfactory, basefactory, manufacturedatid, basemanufacturedatid, toppermanufacturedatid,drawersexist, drawerconfig, drawerheight, drawertext2, bcwexpected, dofweek, startweek, pweekno, cuttingweekno, finishedweekno
showmattress="n"
showtopper="n"
showbase="n"
itemcount=0
accessoryqtysum=0
deltime=request("deltime")
'deltime="10:00 hrs"
dim purchase_no, i, paymentSum, payments, n, displayterms, orderCurrency, upholsterysum, deltxt
displayterms=""
quote=Request("quote")
custname=""
msg=""
localeref=retrieveuserregion()
userlocation=retrieveuserlocation()
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
bcwexpected = ""
cuttingweekno= ""

sql="Select * from qc_history_latest WHERE (componentid=1 or componentid=3 or componentid=5) and MadeAt=2 and purchase_no=" & purchase_no & " order by bcwexpected desc"
Set rs = getMysqlQueryRecordSet(sql, con)
if not rs.eof then
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
	cuttingweekno=DatePart("ww",DateAdd("ww", -1, bcwexpected), 2, 2) & "." & dofweek
	end if
end if
rs.close
set rs=nothing


sql="Select * from purchase WHERE purchase_no=" & purchase_no & ""


Set rs = getMysqlQueryRecordSet(sql, con)
If rs("baserequired")="y" then 
	Set rs2 = getMysqlQueryRecordSet("Select * from qc_history_latest Q, manufacturedat M where Q.madeat=M.manufacturedatid AND Q.componentid=3 AND purchase_no=" & purchase_no, con)
		if not rs2.eof then
			basemanufacturedatid=rs2("id_location")
			if basemanufacturedatid=userlocation then showbase="y"
			basefactory=rs2("manufacturedat")
		end if
		rs2.close
		set rs2=nothing
	baseqty=1 
	else 
	baseqty=0
end if

if rs("basedrawers")="Yes" then
 drawersexist="y"
 drawerconfig=rs("basedrawerconfigID")
 drawerheight=rs("basedrawerheight")
 drawertext=drawerconfig
 drawertext2=drawerheight
end if

if left(rs("basetype"),5)="North" or left(rs("basetype"),4)="East" then baseqty=2 
wrappingtype=rs("wrappingid")
basewidth=rs("basewidth")
baselength1=rs("baselength")
if right(basewidth,2)="cm" then basewidth= left(basewidth, len(basewidth)-2)
if right(baselength1,2)="cm" then baselength1= left(baselength1, len(baselength1)-2)
if right(basewidth,2)="in" then basewidth= (left(basewidth, len(basewidth)-2)*2.54)
if right(baselength1,2)="in" then baselength1= (left(baselength1, len(baselength1)-2)*2.54)

if left(rs("basetype"),5)="North" then
		  northsouth="y"
		  if (rs("basewidth")<>"Special (as instructions)" and  rs("basewidth")<>"Special Width" and  rs("basewidth")<>"n") then
				 basewidth=basewidth/2
				 basewidth2=basewidth
				 end if
				  if (rs("baselength")<>"Special (as instructions)" and  rs("baselength")<>"Special Length") then
				 baselength2=baselength1
				 end if
end if
if left(rs("basetype"),4)="East"  then
		  eastwest="y"
		   if (rs("baselength")<>"Special (as instructions)" and  rs("baselength")<>"Special Length" and  rs("baselength")<>"n") then
				 baselength2=baselength1-130
				 baselength1=130
				 end if
				  if (rs("basewidth")<>"Special (as instructions)" and  rs("basewidth")<>"Special Width") then
				 basewidth2=basewidth
				 end if
end if

if rs("basewidth")="Special (as instructions)"  or  rs("basewidth")="Special Width" then
Set rs2 = getMysqlQueryRecordSet("Select * from productionsizes where purchase_no=" & purchase_no, con)
										if not rs2.eof then
										basewidth=rs2("base1width")
										basewidth2=rs2("base2width")	
										end if
										rs2.close
										set rs2=nothing
end if
if rs("baselength")="Special (as instructions)"  or  rs("baselength")="Special Length" then
Set rs2 = getMysqlQueryRecordSet("Select * from productionsizes where purchase_no=" & purchase_no, con)
										if not rs2.eof then
										baselength1=rs2("base1length")
										baselength2=rs2("base2length")
										end if
										rs2.close
										set rs2=nothing
end if

if rs("topperrequired")="y" then 
	topperqty=1 
	Set rs2 = getMysqlQueryRecordSet("Select * from qc_history_latest Q, manufacturedat M where Q.madeat=M.manufacturedatid AND Q.componentid=5 AND purchase_no=" & purchase_no, con)
		if not rs2.eof then
			toppermanufacturedatid=rs2("id_location")
			if toppermanufacturedatid=userlocation then showtopper="y"
			topperfactory=rs2("manufacturedat")
		end if
		rs2.close
		set rs2=nothing
	else 
	topperqty=0
end if
topperwidth=rs("topperwidth")
topperlength=rs("topperlength")
if right(topperwidth,2)="cm" then topperwidth=left(topperwidth,len(topperwidth)-2)
if right(topperlength,2)="cm" then topperlength=left(topperlength,len(topperlength)-2)
if rs("topperwidth")="Special (as instructions)" or rs("topperwidth")="Special Width" then
	Set rs2 = getMysqlQueryRecordSet("Select * from productionsizes where purchase_no=" & purchase_no, con)
										if not rs2.eof then
										topperwidth=rs2("topper1width")
										end if
	rs2.close
	set rs2=nothing
end if

if rs("topperlength")="Special (as instructions)" or rs("topperlength")="Special Length" then
	Set rs2 = getMysqlQueryRecordSet("Select * from productionsizes where purchase_no=" & purchase_no, con)
										if not rs2.eof then
										topperlength=rs2("topper1length")	
										end if
	rs2.close
	set rs2=nothing
end if

if rs("mattressrequired")="y" then
		'check where made
		Set rs2 = getMysqlQueryRecordSet("Select * from qc_history_latest Q, manufacturedat M where Q.madeat=M.manufacturedatid AND Q.componentid=1 AND purchase_no=" & purchase_no, con)
		if not rs2.eof then
			manufacturedatid=rs2("id_location")
			if manufacturedatid=userlocation then showmattress="y"
			mattressfactory=rs2("manufacturedat")
		end if
		rs2.close
		set rs2=nothing
   		mattqty=1 
		if rs("mattresstype")="Zipped Pair (Centre Only)"  or rs("mattresstype")="Zipped Pair" then 
				mattqty=2
				if (rs("mattresswidth")<>"Special (as instructions)" and  rs("mattresswidth")<>"Special Width") then
					mattwidth1=rs("mattresswidth")
					if right(mattwidth1,2)="cm" then mattwidth1=left(mattwidth1,len(mattwidth1)-2)
					if right(mattwidth1,2)="in" then mattwidth1=(left(mattwidth1,len(mattwidth1)-2))*2.54
					mattwidth1=mattwidth1/2
					mattwidth2=mattwidth1
				end if
				if (rs("mattresslength")<>"Special (as instructions)" and  rs("mattresslength")<>"Special Length") then
					mattlength1=rs("mattresslength")
					if right(mattlength1,2)="cm" then mattlength1=left(mattlength1,len(mattlength1)-2)
					if right(mattlength1,2)="in" then mattlength1=(left(mattlength1,len(mattlength1)-2))*2.54
					mattlength1=mattlength1
					mattlength2=mattlength1		
				end if		
				if rs("savoirmodel")="No. 1" or rs("savoirmodel")="No. 2" then
																if mattwidth1<>"" then mattwidth1=CDbl(mattwidth1)-1
																if mattwidth2<>"" then mattwidth2=CDbl(mattwidth2)-1
				end if				
			else
					if rs("mattresswidth")<>"Special (as instructions)" or rs("mattresswidth")<>"Special Width" then
						mattwidth1=rs("mattresswidth")
						if right(mattwidth1,2)="cm" then mattwidth1=left(mattwidth1,len(mattwidth1)-2)
						if right(mattwidth1,2)="in" then mattwidth1=(left(mattwidth1,len(mattwidth1)-2))*2.54
					end if
					if rs("mattresslength")<>"Special (as instructions)" or rs("mattresslength")<>"Special Length" then
						mattlength1=rs("mattresslength")
						if right(mattlength1,2)="cm" then mattlength1=left(mattlength1,len(mattlength1)-2)
						if right(mattlength1,2)="in" then mattlength1=(left(mattlength1,len(mattlength1)-2))*2.54
					end if
			end if
				if rs("mattresswidth")="Special (as instructions)" or rs("mattresswidth")="Special Width" then
												Set rs2 = getMysqlQueryRecordSet("Select * from productionsizes where purchase_no=" & purchase_no, con)
												if not rs2.eof then
												mattwidth1=rs2("matt1width")
												mattwidth2=rs2("matt2width")	
														if  (rs("mattresstype")="Zipped Pair (Centre Only)"  or rs("mattresstype")="Zipped Pair") and (rs("savoirmodel")="No. 1" or rs("savoirmodel")="No. 2") then
																		if mattwidth1<>"" then mattwidth1=CDbl(mattwidth1)-1
																		if mattwidth2<>"" then mattwidth2=CDbl(mattwidth2)-1
														end if	
												end if
												rs2.close
												set rs2=nothing
		end if	
		if rs("mattresslength")="Special (as instructions)" or rs("mattresslength")="Special Length" then
												Set rs2 = getMysqlQueryRecordSet("Select * from productionsizes where purchase_no=" & purchase_no, con)
												if not rs2.eof then
												mattlength1=rs2("matt1length")
												mattlength2=rs2("matt2length")
												end if
												rs2.close
												set rs2=nothing
		end if	
  else mattqty=0
end if

deliveryaddress="<font family=""Tahoma""><font size=""8"">"
If rs("deliveryadd1") <> "" then deliverytrue=1 AND deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd1")) & "<br />"
If rs("deliveryadd2") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd2")) & "<br />"
If rs("deliveryadd3") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd3")) & "<br />"
If rs("deliverytown") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverytown")) & "<br />"
If rs("deliverycounty") <> "" then deliverytrue=1 AND deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverycounty")) & "<br />"
If rs("deliverypostcode") <> "" then deliverytrue=1 AND deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverypostcode")) & "<br />"
If rs("deliverycountry") <> "" then deliverytrue=1 AND deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverycountry"))
deliveryaddress=deliveryaddress & "</font></font>"
sql="Select * from location WHERE idlocation=" & rs("idlocation") & ""
Set rs2 = getMysqlQueryRecordSet(sql, con)

showroomaddress=Utf8ToUnicode(rs2("adminheading"))
'If rs2("tel")<>"" then showroomaddress=showroomaddress & "&nbsp;&nbsp;Tel: " & rs2("tel")
'If rs2("email")<>"" then showroomaddress=showroomaddress & "&nbsp;&nbsp;Email: " & rs2("email")
rs2.close
set rs2=nothing
if wrappingtype<>"" then
sql="Select * from WrappingTypes where wrappingid=" & wrappingtype
Set rs2 = getMysqlQueryRecordSet(sql, con)
if not rs2.eof then
wrappingtype=rs2("wrap")
end if
rs2.close 
set rs2=nothing
end if
sql="Select * from savoir_user WHERE username like '" & rs("salesusername") & "'"

Set rs2 = getMysqlQueryRecordSet(sql, con)

if not rs2.eof then
orderCurrency = rs("ordercurrency")
contact = Utf8ToUnicode(rs2("name"))
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
clientdetails=clientdetails & Utf8ToUnicode(rs("customerreference")) & "<br />"
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
s = s & " <td width=""54"" valign=""top"">" & clienthdg & "</td><td width=""112"" valign=""top"">" & clientdetails & "</td><td width=""24""></td><td width=""166"">&nbsp;</td><td width=""24""></td><td width=""166"">" & deliveryaddress & "</td> "
s = s & " </tr> "
s = s & " </table> "

sql="Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=9 order by qc_date desc"
Set rs3 = getMysqlQueryRecordSet(sql, con)
		if not rs3.eof then
			if rs3("qc_statusid")=60 then 
				accessoriespicked="y" 
				else 
				if rs3("qc_statusid")<>70 and rs3("qc_statusid")<>80 then tobedelivered=tobedelivered & "Accessories<br>"
			end if
		end if
	rs3.close
	set rs3=nothing

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
if rs("mattressrequired")="y" or rs("topperrequired")="y" or rs("baserequired")="y" or rs("headboardrequired")="y" or rs("valancerequired")="y" then accessoriesonly="n" else accessoriesonly="y"
DrawBox 20,5, 170, 170
DrawBox 410,5, 170, 170
'box 1
if mattqty=0  then
else
	if showmattress="y" then
	DrawBox 340,195, 240, 180
	DrawBox 460,213, 10, 10
	DrawBox 520,213, 10, 10
	DrawBox 460,227, 10, 10
	DrawBox 520,227, 10, 10
	DrawBox 460,242, 10, 10
	DrawBox 520,242, 10, 10
	DrawBox 460,257, 10, 10
	DrawBox 520,257, 10, 10
	DrawBox 460,272, 10, 10
	DrawBox 520,272, 10, 10
	end if
end if

'box2
if topperqty=0 then
else
if showtopper="y" then
	DrawBox 340,410, 240, 180
	DrawBox 460,428, 10, 10
	DrawBox 520,428, 10, 10
	DrawBox 460,442, 10, 10
	DrawBox 520,442, 10, 10
	DrawBox 460,457, 10, 10
	DrawBox 520,457, 10, 10
	DrawBox 460,472, 10, 10
	DrawBox 520,472, 10, 10
	DrawBox 460,487, 10, 10
	DrawBox 520,487, 10, 10
	end if
end if
'box3
if baseqty=0 then
else
	if showbase="y" then
	DrawBox 420,610, 160, 180
	DrawBox 550,638, 10, 10
	DrawBox 550,652, 10, 10
	DrawBox 550,667, 10, 10
	DrawBox 550,682, 10, 10
	end if
end if



PDF.SetFont "F15", 16, "#999"
PDF.AddTextPos 260, 20, "Cases" 
PDF.SetFont "F15", 10, "#999"
PDF.AddTextPos 205, 35, "Order No: " 
PDF.SetFont "F15", 14, "#999"
PDF.AddTextPos 271, 35,  rs("order_number")
PDF.SetFont "F15", 10, "#999"
PDF.AddTextPos 205, 46, "Customer: " 
PDF.AddTextPos 271, 46,  custname
x=57
if rs("customerreference")<>"" then
PDF.AddTextPos 205, x, "Customer Ref: "
PDF.AddTextPos 271, x,  Utf8ToUnicode(rs("customerreference"))
x=x+11
end if
PDF.AddTextPos 205, x, "Order Source: " 
PDF.AddTextPos 271, x, showroomaddress
x=x+11
PDF.AddTextPos 205, x, "Wrap: " 
PDF.AddTextPos 271, x, wrappingtype
x=x+11
Set rs3 = getMysqlUpdateRecordSet("Select * from FireLabel where firelabelid=" & rs("firelabelid") , con)
If not rs3.eof then
PDF.AddTextPos 205, x, "Fire Label: "
PDF.AddTextPos 271, x, rs3("firelabel")
else
PDF.AddTextPos 205, x, "Fire Label: " 
PDF.AddTextPos 271, x, "N/a" 
end if
rs3.close
set rs3=nothing

PDF.AddHTMLPos 30, 10, "<b>CUTTING & SEWING</b>"
PDF.AddHTMLPos 30, 30, "<b>Week: </b>"
if retrieveUserLocation()=27 then
else
PDF.AddHTMLPos 30, 60, "<font size=+62>" & cuttingweekno & "</font>"
end if
PDF.AddHTMLPos 420, 10, "<b>FINISHING</b>"
PDF.AddHTMLPos 420, 30, "<b>Week: </b>"
if retrieveUserLocation()=27 then
else
PDF.AddHTMLPos 420, 60, "<font size=+62>" & finishedweekno & "</font>"
end if
PDF.AddHTMLPos 1, 180, "<hr>"
if mattqty = 0 then
matttable="<br /><br />MATTRESS NOT REQUIRED"
else
	if showmattress="y" then
	PDF.AddHTMLPos 20, 195, "<b>MATTRESS:    Machined by:</b>............................."
	matttable="<table width=""487"" border=""0"" cellspacing=""0"" cellpadding=""0"" align=""left"">"
	matttable=matttable & "<tr> <td>" & rs("savoirmodel") & "&nbsp;&nbsp;&nbsp;&nbsp; <br /><b> Type:</b> " & rs("mattresstype") & "<br /> <b>Mattress 1:</b> " & mattwidth1 & " cm x " & mattlength1 & " cm" 
	If mattwidth2<>"" then matttable=matttable & "<br /><b>Mattress 2:</b> " & mattwidth2 & " cm x " & mattlength2 & " cm"
	matttable=matttable & "<br /><br /><b>Ticking Style: </b>" & rs("tickingoptions") & "<br /><b>Support:</b><br /><b>Left: </b>" & rs("leftsupport") & " &nbsp;&nbsp;<b>Right: </b> " & rs("rightsupport") & "<br /><b>Date Cut:.................................</b><br /><b>Date Machined:......................</b><br /><b>Date Finished:........................</b><br /><b>Finished By:...........................</b><br /><b><u>Cutter to Write Ticking Used</u></b><br /><b>Ticking Batch Used:..............</b><br /><b>Ticking Batch Used:..............</b></td> <td><p><b>Vent position:</b> " & rs("ventposition") & "<br /><b> Vent Finish:</b> " & rs("ventfinish") & "<br /> <b>Special Instructions: </b>" & ucase(rs("mattressinstructions") )& "</p> <p><b>Production Hours Used:</b></p> <p><b>Cut.............. &nbsp; Machine.............. </b><br /> <b>Finish:..............</b></p></td> <td>&nbsp;</td> </tr> </table>"
	
	PDF.AddTextPos 371, 208, "Progress Check"
	PDF.AddTextPos 501, 208, "Final Check" 
	PDF.AddTextPos 351, 221, "Size Checked?" 
	PDF.AddLine 350, 225, 560, 225
	PDF.AddTextPos 351, 236, "Ticking Correct?" 
	PDF.AddLine 350, 240, 560, 240
	PDF.AddTextPos 351, 251, "Labels Checked?"
	PDF.AddLine 350, 255, 560, 255
	PDF.AddTextPos 351, 266, "Labels in Correct Place?"
	PDF.AddLine 350, 270, 560, 270
	PDF.AddTextPos 351, 281, "Vents checked"
	PDF.AddLine 350, 285, 560, 285
	PDF.AddTextPos 351, 306, "Checked by (name):"
	PDF.AddTextPos 351, 330, "..............................."
	PDF.AddTextPos 351, 350, "Date:"
	PDF.AddTextPos 481, 306, "Checked by (name):"
	PDF.AddTextPos 481, 330, "..............................."
	PDF.AddTextPos 481, 350, "Date:"
	PDF.AddTextPos 351, 370, "Mattress Made By: ........................................"
	PDF.AddHTMLPos 475, 196,  "<img src=""images/straightline.gif"" width=""1"" height=""210"">"
	else
		matttable="<br /><br />Mattress made in " & mattressfactory 
	end if
end if
PDF.AddHTMLPos 33, 196, matttable
PDF.AddHTMLPos 1, 400, "<hr>"


if topperqty = 0 then
toptable="<br /><br />TOPPER NOT REQUIRED"
else
if showtopper="y" then
toptable="<table width=""487"" border=""0"" cellspacing=""0"" cellpadding=""0"" align=""left"">"
toptable=toptable & "<tr> <td><b>TOPPER<br /> <b>Type:</b> " & rs("toppertype") & "<br /><b> Size:</b>  " & topperwidth & " cm x " & topperlength & " cm" 
toptable=toptable & "<br /><br /><b>Ticking Style: </b>" & rs("toppertickingoptions") & "<br /><b>Date Cut:.................................</b><br /><b>Date Machined:......................</b><br /><b>Date Finished:........................</b><br /><b>Finished By:...........................</b><br /><b><u>Cutter to Write Ticking Used<br>Batches Used Below</u></b><br /><b>Ticking Batch Used:..............</b><br /><b>Ticking Batch Used:..............</b></td> <td><p><b>Special Instructions: </b>" & ucase(rs("specialinstructionstopper") )& "</p> <p><b>Production Hours Used:</b></p> <p><b>Cut.............. &nbsp; Machine.............. </b><br /> <b>Finish:..............</b></p></td> <td>&nbsp;</td> </tr> </table>"




PDF.AddTextPos 371, 423, "Progress Check" 
PDF.AddTextPos 501, 423, "Final Check" 
PDF.AddTextPos 351, 436, "Size Checked?" 
PDF.AddLine 350, 440, 560, 440
PDF.AddTextPos 351, 451, "Ticking Correct?" 
PDF.AddLine 350, 455, 560, 455
PDF.AddTextPos 351, 466, "Labels Checked?"
PDF.AddLine 350, 470, 560, 470
PDF.AddTextPos 351, 481, "Labels in Correct Place?"
PDF.AddLine 350, 485, 560, 485
PDF.AddTextPos 351, 511, "Checked by (name):"
PDF.AddTextPos 351, 535, "..............................."
PDF.AddTextPos 351, 555, "Date:"
PDF.AddTextPos 481, 511, "Care Card?..............."
PDF.AddTextPos 481, 531, "Checked by (name):"
PDF.AddTextPos 481, 555, "..............................."
PDF.AddTextPos 481, 575, "Date:"
PDF.AddHTMLPos 475, 431,  "<img src=""images/straightline.gif"" width=""1"" height=""210"">"
else
toptable="<br /><br />Topper made in " & topperfactory
end if
end if
PDF.AddHTMLPos 33, 400, toptable
PDF.AddHTMLPos 1, 600, "<hr>"


If baseqty=0 then
basetable="<br /><br />BOX NOT REQUIRED"
else
if showbase="y" then
basetable="<table width=""487"" border=""0"" cellspacing=""0"" cellpadding=""0"" align=""left"">"
basetable=basetable & "<tr> <td width=""162""><b>Box: </b>" & rs("basesavoirmodel") & "<br /><b> Type:</b> " & rs("basetype") & "<br /> <b>Box 1:</b>  " & basewidth & " cm x " & baselength1 & " cm" 
If basewidth2<>"" then basetable=basetable & "<br /><b>Box 2:</b> " & basewidth2 & " cm x " & baselength2 & " cm"
basetable=basetable & "<br /><br /><b>Ticking Style: </b>" & rs("basetickingoptions") & "<br /><b>Date Cut:.................................</b><br /><b>Date Machined:......................</b><br /><b>Date Finished:........................</b><br /><b>Finished By:...........................</b><br /><b><u>Fabric Cutter to Write Ticking<br />Batches Used Below</u></b><br /><b>Ticking Batch Used:..............</b><br /><b>Ticking Batch Used:..............</b></td> <td width=""225""><p><b>Special Instructions: </b>" & ucase(rs("baseinstructions") )& "</p> <p><b>Production Hours Used:</b></p> <p><b>Cut.............. &nbsp; Machine.............. </b><br /> <b>Finish:..............</b></p>"
if rs("headboardrequired")="y" then 
basetable=basetable & "<p><b>Headboard Style: </b>" & rs("headboardstyle") & "</p>"
end if
if rs("upholsteredbase")="Yes" or rs("upholsteredbase")="Yes, Com" then 
basetable=basetable & "<p><b>Upholstered Base: </b>" & rs("upholsteredbase") & "</p>"
end if
if drawersexist="y" then
	basetable=basetable & "<p><b>Drawers: </b>" & drawertext & "<br />"
	basetable=basetable & "<b>Drawer Height: </b>" & drawertext2 & "</p>"
end if 
basetable=basetable & "</td> <td>&nbsp;</td> </tr> </table>"


PDF.AddTextPos 461, 6533, "Progress Check" 
PDF.AddTextPos 431, 646, "Size Checked?" 
PDF.AddLine 430, 650, 560, 650
PDF.AddTextPos 431, 661, "Ticking Correct?" 
PDF.AddLine 430, 665, 560, 665
PDF.AddTextPos 431, 676, "Labels Checked?"
PDF.AddLine 430, 680, 560, 680
PDF.AddTextPos 431, 691, "Labels in Correct Place?"
PDF.AddLine 430, 695, 560, 695
PDF.AddTextPos 431, 721, "Checked by (name):"
PDF.AddTextPos 431, 735, "..............................."
PDF.AddTextPos 431, 765, "Date:"
else
basetable="<br /><br />Base made in " & basefactory 
end if
end if
PDF.AddHTMLPos 33, 620, basetable
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
