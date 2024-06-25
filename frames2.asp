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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, deltime, deliverytrue, mattresspicked, basepicked, topperpicked, valancepicked,  legspicked, headboardpicked, itemcount, tobedelivered, itemqty, accessoriespicked, accessoryqtysum, valencelength, valancewidth, valancedrop, matttable, matttable2, mattqty, mattwidth1, mattwidth2, mattlength1, mattlength2, toptable, topperqty, baseqty, basetable, basewidth1, basewidth2, baselength1, baselength2, eastwest, northsouth, wrappingtype, bookeddeliverydate, legtext, x, drawersexist, drawerconfig, drawerheight, drawertext2

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


sql="Select * from purchase WHERE purchase_no=" & purchase_no & ""


Set rs = getMysqlQueryRecordSet(sql, con)

if (rs("legstyle")="" or rs("legstyle")="--" or rs("legstyle")=null) then 
	legstyle="0" 
	else 
	legstyle=rs("legstyle")
	if (rs("legstyle")="Holly" or rs("legstyle")="Georgian" or rs("legstyle")="Penelope") then 
	legtext="Mortice corner block required as leg is " & rs("legstyle")
	else
	legtext=""
	end if
end if
if isNull(rs("basedrawerconfigID")) or rs("basedrawerconfigID")="n" then
else
 drawersexist="y"
 drawerconfig=rs("basedrawerconfigID")
 drawerheight=rs("basedrawerheight")
 drawertext="Drawers: " & drawerconfig
 drawertext2="Height: " & drawerheight
end if
if rs("bookeddeliverydate")<>"" then bookeddeliverydate=FormatDateTime(rs("bookeddeliverydate"),1) else bookeddeliverydate=""
If rs("baserequired")="y" then baseqty=1 else baseqty=0
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
if left(rs("basetype"),4)="East" then
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

if rs("topperrequired")="y" then topperqty=1 else topperqty=0
topperwidth=rs("topperwidth")
topperlength=rs("topperlength")
if right(topperwidth,2)="cm" then topperwidth=left(topperwidth,len(topperwidth)-2)
if right(topperlength,2)="cm" then topperlength=left(topperlength,len(topperlength)-2)
if rs("topperwidth")="Special (as instructions)" or rs("topperlength")="Special (as instructions)" or rs("topperwidth")="Special Width" or rs("topperlength")="Special Length" then
	Set rs2 = getMysqlQueryRecordSet("Select * from productionsizes where purchase_no=" & purchase_no, con)
										if not rs2.eof then
										topperwidth=rs2("topper1width")
										topperlength=rs2("topper1length")	
										end if
	rs2.close
	set rs2=nothing
end if

if rs("mattressrequired")="y" then
   mattqty=1 
			if rs("mattresstype")="Zipped Pair (Centre Only)"  or rs("mattresstype")="Zipped Pair" then 
				mattqty=2
							if rs("mattresswidth")="Special (as instructions)" or rs("mattresslength")="Special (as instructions)"  or rs("mattresswidth")="Special Width" or rs("mattresslength")="Special Length" then
										Set rs2 = getMysqlQueryRecordSet("Select * from productionsizes where purchase_no=" & purchase_no, con)
										if not rs2.eof then
										mattwidth1=rs2("matt1width")
										mattwidth2=rs2("matt2width")	
										mattlength1=rs2("matt1length")
										mattlength2=rs2("matt2length")
										end if
										rs2.close
										set rs2=nothing
							else
							mattwidth1=rs("mattresswidth")
							mattlength1=rs("mattresslength")
							if right(mattwidth1,2)="cm" then mattwidth1=left(mattwidth1,len(mattwidth1)-2)
							if right(mattlength1,2)="cm" then mattlength1=left(mattlength1,len(mattlength1)-2)
							if right(mattwidth1,2)="in" then mattwidth1=(left(mattwidth1,len(mattwidth1)-2))*2.54
							if right(mattlength1,2)="in" then mattlength1=(left(mattlength1,len(mattlength1)-2))*2.54
							mattwidth1=mattwidth1/2
							mattlength1=mattlength1
							mattwidth2=mattwidth1
							mattlength2=mattlength1
							end if
							if rs("savoirmodel")="No. 1" or rs("savoirmodel")="No. 2" then
											if mattwidth1<>"" then mattwidth1=CDbl(mattwidth1)-1
											if mattwidth2<>"" then mattwidth2=CDbl(mattwidth2)-1
							end if
			else
				mattwidth1=rs("mattresswidth")
				if right(mattwidth1,2)="cm" then mattwidth1=left(mattwidth1,len(mattwidth1)-2)
					if right(mattwidth1,2)="in" then 
					mattwidth1=(left(mattwidth1,len(mattwidth1)-2))*2.54
					end if
				mattlength1=rs("mattresslength")
				if right(mattlength1,2)="cm" then mattlength1=left(mattlength1,len(mattlength1)-2)
				if right(mattlength1,2)="in" then 
					mattlength1=(left(mattlength1,len(mattlength1)-2))*2.54
					end if
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
showroomaddress=rs2("adminheading")
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
contact = rs2("name")
end if
rs2.close
set rs2=nothing
sql="Select * from contact WHERE code=" & rs("code") & ""
Set rs1 = getMysqlQueryRecordSet(sql, con)
sql="Select * from address WHERE code=" & rs1("code") & ""
Set rs2 = getMysqlQueryRecordSet(sql, con)

signature = rs("signature")

If rs1("title") <> "" Then custname=custname & Utf8ToUnicode(capitalise(lcase(rs1("title")))) & " "
If rs1("first") <> "" Then custname=custname & Utf8ToUnicode(capitalise(lcase(rs1("first")))) & " "
If rs1("surname") <> "" Then custname=custname & Utf8ToUnicode(capitalise(lcase(rs1("surname"))))
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
if rs("mattressrequired")="y" or rs("topperrequired")="y" or rs("baserequired")="y" or rs("headboardrequired")="y" or rs("valancerequired")="y" then accessoriesonly="n" else accessoriesonly="y"
'box 1




DrawBox 20,20, 175, 140
DrawBox 405,20, 175, 140

DrawBox 300,175, 280, 385

DrawBox 20,575, 560, 255

DrawBox 180,608, 10, 10
DrawBox 180,622, 10, 10
DrawBox 180,637, 10, 10
DrawBox 180,652, 10, 10
DrawBox 180,667, 10, 10
DrawBox 180,682, 10, 10

DrawBox 280,608, 10, 10
DrawBox 280,622, 10, 10
DrawBox 280,637, 10, 10
DrawBox 280,652, 10, 10
DrawBox 280,667, 10, 10

DrawBox 480,608, 10, 10
DrawBox 480,622, 10, 10
DrawBox 480,637, 10, 10
DrawBox 480,652, 10, 10
DrawBox 480,667, 10, 10
DrawBox 480,682, 10, 10
DrawBox 480,697, 10, 10

PDF.SetFont "F15", 16, "#999"
PDF.AddTextPos 230, 20, "Divan / Box Frames" 
PDF.SetFont "F15", 10, "#999"
PDF.AddHTMLPos 210, 45, "<b>Order No: </b>"
PDF.SetFont "F15", 14, "#999"
PDF.AddTextPos 263, 55, rs("order_number")
PDF.SetFont "F15", 10, "#999"
PDF.AddHTMLPos 210, 70, "<b>Customer:  </b>" & custname
x=85
if rs("customerreference")<>"" then
PDF.AddHTMLPos 210, x, "<b>Customer Ref: </b>" &  Utf8ToUnicode(rs("customerreference"))
x=x+15
end if
PDF.AddHTMLPos 210, x, "<b>Source:  </b>" & showroomaddress
PDF.AddHTMLPos 27, 22, "<b>CARPENTRY</b> "
PDF.AddHTMLPos 27, 40, "<b>Week:</b> "
PDF.AddHTMLPos 415, 22, "<b>FINISHING</b> "
PDF.AddHTMLPos 415, 40, "<b>Week:</b> "
PDF.AddHTMLPos 1, 165, "<hr>"
PDF.AddHTMLPos 20, 176, "<b>Box:</b> "
PDF.SetFont "F15", 12, "#999"

PDF.SetFont "F15", 10, "#999"
If basewidth2<>"" then 

PDF.AddHTMLPos 20, 236, "<b>Box W/L Box 2:</b> "
PDF.SetFont "F15", 12, "#999"
PDF.AddTextPos 100, 246, basewidth2 & " cm x " & baselength2 & " cm"
PDF.SetFont "F15", 10, "#999"
end if
PDF.SetFont "F15", 12, "#999"
if left(rs("baseheightspring"),6)="Non St" then
PDF.AddTextPos 20, 286, "Non-Standard Base - Check Order Details " 
end if
if left(rs("baseheightspring"),6)="Standa" then
PDF.AddTextPos 20, 286, "Standard " & rs("basesavoirmodel") & " Base " 
end if
PDF.SetFont "F15", 10, "#999"
PDF.AddHTMLPos 20, 296, "<b>Link Bar:</b> " & rs("linkfinish") & " " & rs("linkposition")
PDF.AddHTMLPos 20, 316, "<b>Ticking:</b> " & rs("basetickingoptions")
 PDF.AddHTMLPos 20, 336, "<b>Legs:</b> " & legstyle
 if rs("upholsteredbase")="Yes" or rs("upholsteredbase")="Yes, Com" then 
 PDF.AddHTMLPos 20, 356, "<b>Order Detail:</b> Upholstered Base"
 end if
 PDF.AddHTMLPos 20, 396, "<b>Wrapping Instructions:</b> " & wrappingtype

Set rs3 = getMysqlUpdateRecordSet("Select * from FireLabel where firelabelid=" & rs("firelabelid") , con)
If not rs3.eof then
PDF.AddHTMLPos 20, 416, "<b>Fire Label: </b>" & rs3("firelabel")
else
PDF.AddHTMLPos 20, 416, "<b>Fire Label: </b> N/a" 
end if
rs3.close
set rs3=nothing
PDF.AddHTMLPos 20, 436, "<b>Frame Made by: </b>......................." 
PDF.AddHTMLPos 20, 456, "<b>To be finished by: </b>......................." 

PDF.AddHTMLPos 310, 175, "<b>Box Special Instructions: </b>" 
x=175
If rs("baseinstructions") <>"" then
PDF.SetProperty csPropAddTextWidth , 2
		x=209
		PDF.AddTextWidth 310,x,250, rs("baseinstructions")
end if
if legtext<>"" then
	x=x+20
	PDF.AddHTMLPos 310, x, legtext
end if
if drawersexist="y" then
	x=x+20
	PDF.AddHTMLPos 310, x, drawertext
	PDF.AddHTMLPos 310, x+20, drawertext2
end if 
PDF.AddHTMLPos 310, 526, "<b>Production Hours Used: </b>" 

PDF.AddHTMLPos 310, 546, "<b>Frame:..........................  Finish:..........................  </b>" 


PDF.AddTextPos 90, 593, "Progress Check" 
PDF.AddTextPos 30, 616, "Size Checked?" 
PDF.AddLine 30, 620, 290, 620
PDF.AddTextPos 30, 631, "Depth of Frame" 
PDF.AddLine 30, 635, 290, 635
PDF.AddTextPos 30, 646, "T-Nuts for H/Board"
PDF.AddLine 30, 650, 290, 650
PDF.AddTextPos 30, 661, "T-Nuts for Legs"
PDF.AddLine 30, 665, 290, 665
PDF.AddTextPos 30, 676, "T-Nuts for Link Bars"
PDF.AddLine 30, 680, 290, 680
PDF.AddTextPos 30, 691, "Check for Edge Knots"
PDF.AddLine 30, 695, 190, 695


PDF.AddTextPos 30, 741, "Checked by (name):"
PDF.AddTextPos 30, 795, "..............................."
PDF.AddTextPos 30, 805, "Date:"
PDF.AddHTMLPos 235, 575,  "<img src=""images/straightline.gif"" width=""1"" height=""344"">"
PDF.AddTextPos 280, 593, "Final Check"

PDF.AddTextPos 330, 616, "Size Checked?" 
PDF.AddLine 330, 620, 490, 620
PDF.AddLine 330, 635, 490, 635
PDF.AddTextPos 330, 631, "Ticking Correct?" 
PDF.AddLine 330, 635, 490, 635
PDF.AddTextPos 330, 646, "Labels Checked?"
PDF.AddLine 330, 650, 490, 650
PDF.AddTextPos 330, 661, "Labels in Correct Place?"
PDF.AddLine 330, 665, 490, 665
PDF.AddTextPos 330, 676, "Vents Checked?"
PDF.AddLine 330, 680, 490, 680
PDF.AddTextPos 330, 691, "Legs Marked?"
PDF.AddLine 330, 695, 490, 695
PDF.AddTextPos 330, 706, "Link Bar Position?"
PDF.AddLine 330, 710, 490, 710

PDF.AddTextPos 330, 741, "Checked by (name):"
PDF.AddTextPos 330, 795, "..............................."
PDF.AddTextPos 330, 805, "Date:"

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
