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
<!-- #include file="componentfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, deltime, deliverytrue, mattresspicked, basepicked, topperpicked, valancepicked,  legspicked, headboardpicked, itemcount, tobedelivered, itemqty, accessoriespicked, accessoryqtysum, valencelength, valancewidth, valancedrop, matttable, matttable2, mattqty, mattwidth1, mattwidth2, mattlength1, mattlength2, toptable, topperqty, baseqty, basetable, basewidth1, basewidth2, baselength1, baselength2, eastwest, northsouth, wrappingtype, x, y, mattspecial, userlocation, showmattress, showtopper, showbase, mattressfactory, topperfactory, basefactory, manufacturedatid, basemanufacturedatid, toppermanufacturedatid, bookeddeliverydate, showroomtel, correspondence1, correspondence2, deliveryaddress1, deltrue, sageref, invno, prodtable
dim componentarray(), dimensionsarray(), tarrifarray(), weightarray(), cubicmetersarray()
dim m1width, m2width, m1length, m2length
dim weight, tarrifcode, depth, weightcalc
dim sizes, valancesize, hblegs, cid, showroomadd, invoicetotal, accprice, showroomnotes, invoicenotecount, paymentterms, bankdetails, paymentduedate, invdate
invoicenotecount=1
invoicetotal=0
cid=request("cid")
hblegs=""
dim componentpricearray()
prodtable=""
invno=request("invno")
sageref=" "
deltrue="n"
deliverytrue=false
showmattress="n"
showtopper="n"
showbase="n"
itemcount=0
count=0

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


'purchase_no=request("pn")
purchase_no=request("pno")
selcted=""
count=0
order=""
submit=""

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

sql="SELECT * from exportLinks L where invoiceno='" & invno & "' and purchase_no=" & purchase_no
Set rs1 = getMysqlQueryRecordSet(sql, con)

if not rs1.eof then
invdate=rs1("invoiceDate")
sql="SELECT * from exportcollshowrooms where exportCollshowroomsID=" & rs1("linkscollectionid")
response.Write(sql)
response.End()
Set rs2 = getMysqlQueryRecordSet(sql, con)
	showroomadd=rs2("idlocation")
	rs2.close
	set rs2=nothing
	do until rs1.eof
		count=count+1
		redim preserve componentarray(count)
		componentarray(count)=rs1("componentid")
	rs1.movenext
	loop
end if
rs1.close
set rs1=nothing
'response.write("show=" & showroomadd)
'response.End()	
		
sql="Select * from purchase WHERE purchase_no=" & purchase_no & ""

Set rs = getMysqlQueryRecordSet(sql, con)

orderCurrency = rs("ordercurrency")
if orderCurrency="GBP" then ordercurrency="&pound;"
if orderCurrency="USD" then ordercurrency="&#36;"
if orderCurrency="EUR" then ordercurrency="&#8364;"

prodtable="<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""1"">"
prodtable=prodtable & "<font size=""8px""><tr><td width=""40%""><b>Bed Model</b></td><td><b>Size</b></td><td align=""center""><b>Quantity</b></td><td align=""right""><b>Unit Price/" & rs("ordercurrency") & "</b></td><td align=""right""><b>Price/" & rs("ordercurrency") & "</b></td></tr>"
for i= 1 to count
	if componentarray(i)=1 then
	mattressprice=0.00
	If rs("mattressprice")<>"" and NOT ISNULL(rs("mattressprice"))  then mattressprice=FormatNumber(rs("mattressprice"),2)
		if matt1width<>"" then mattwidthstring= matt1width & " x "
		if matt1width="" then mattwidthstring= rs("mattresswidth") & " x "
		if matt1length<>"" then mattwidthstring=mattwidthstring & matt1length & "cm "
		if matt1length="" then mattwidthstring=mattwidthstring & rs("mattresslength") & " "
		if matt2width<>"" then mattwidthstring=mattwidthstring & matt2width & " x "
		if matt2length<>"" then mattwidthstring=mattwidthstring & matt2length & "cm"
		prodtable=prodtable & "<tr><td>" & rs("savoirmodel") & " Mattress<br />" & rs("mattresstype") & "<br />Left Support: " & rs("leftsupport") & "<br />Right Support: " & rs("rightsupport")
		if rs("tickingoptions")<>"n" then prodtable=prodtable & "<br />" & rs("tickingoptions")
		prodtable=prodtable & "</td><td>" & mattwidthstring & "</td><td align=""center"">1</td><td align=""right"">" & ordercurrency & formatnumber(mattressprice,2) & "</td><td align=""right"">" & ordercurrency & formatnumber(mattressprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(mattressprice)
	end if
	if componentarray(i)=3 then
		baseprice=0.00
		if (rs("basetrimprice")<>"" or NOT ISNULL(rs("basetrimprice"))) then baseprice=CDbl(baseprice) + CDbl(rs("basetrimprice"))
		if (rs("basedrawersprice")<>"" or NOT ISNULL(rs("basedrawersprice"))) then baseprice=CDbl(baseprice) + CDbl(rs("basedrawersprice"))
		if (rs("baseprice")<>"" or NOT ISNULL(rs("baseprice"))) then baseprice=CDbl(baseprice) + CDbl(rs("baseprice")) 
		if base1width<>"" then basewidthstring= base1width & " x "
		if base1width="" then basewidthstring= rs("basewidth") & " x "
		if base1length<>"" then basewidthstring=basewidthstring & base1length & "cm "
		if base1length="" then basewidthstring=basewidthstring & rs("baselength") & " "
		if base2width<>"" then basewidthstring=basewidthstring & base2width & " x "
		if base2length<>"" then basewidthstring=basewidthstring & base2length & "cm"
		prodtable=prodtable & "<tr><td>" & rs("basesavoirmodel") & " Base<br />" & rs("basetype")
		if rs("basetickingoptions")<>"n" then prodtable=prodtable & "<br />" & rs("basetickingoptions")
		prodtable=prodtable & "</td><td>" & basewidthstring & "</td><td align=""center"">1</td><td align=""right"">" & ordercurrency & FormatNumber(baseprice,2) & "</td><td align=""right"">" & ordercurrency & FormatNumber(baseprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(baseprice)
		If rs("basefabricprice")<>"" and rs("basefabricprice")<>"0" and NOT ISNULL(rs("basefabricprice")) then
			prodtable=prodtable & "<tr><td>Base Fabric " & rs("basefabric") & "<br />" & rs("basefabricchoice")
			prodtable=prodtable & "</td><td>Meters</td><td align=""center"">" & rs("basefabricmeters") & "</td><td align=""right"">" & ordercurrency & FormatNumber(CDbl(rs("basefabriccost")),2) & "</td><td align=""right"">" & ordercurrency & FormatNumber(CDbl(rs("basefabricprice")),2) & "</td></tr>"
			invoicetotal=invoicetotal + CDbl(rs("basefabricprice"))
		end if
		if (rs("upholsteryprice") <> "" and rs("upholsteryprice")<>"0" and  Not isNull("upholsteryprice")) then
			prodtable=prodtable & "<tr><td>Upholstered Base<br />"
			prodtable=prodtable & "</td><td>&nbsp;</td><td align=""center"">1</td><td align=""right"">" & ordercurrency & FormatNumber(CDbl(rs("upholsteryprice")),2) & "</td><td align=""right"">" & ordercurrency & FormatNumber(CDbl(rs("upholsteryprice")),2) & "</td></tr>"
			invoicetotal=invoicetotal + CDbl(rs("upholsteryprice"))
		end if
	end if
	if componentarray(i)=5 then
		if topper1width<>"" then topperwidthstring= topper1width & " x "
		if topper1width="" then topperwidthstring= rs("topperwidth") & " x "
		if topper1length<>"" then topperwidthstring=topperwidthstring & topper1length & "cm"
		if topper1length="" then topperwidthstring=topperwidthstring & rs("topperlength") & ""
		If rs("topperprice")<>"" and   NOT ISNULL(rs("topperprice"))  then topperprice=rs("topperprice") else topperprice=0
		prodtable=prodtable & "<tr><td>" & rs("toppertype")
		if rs("toppertickingoptions")<>"n" then prodtable=prodtable & "<br />" & rs("toppertickingoptions")
		prodtable=prodtable & "</td><td>" & topperwidthstring & "</td><td align=""center"">1</td><td align=""right"">" & ordercurrency & formatnumber(topperprice,2) & "</td><td align=""right"">" & ordercurrency & formatnumber(topperprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(topperprice)
	end if
	if componentarray(i)=6 then
		If rs("valanceprice")<>"" and NOT ISNULL(rs("valanceprice"))  then valanceprice=rs("valanceprice")
		if rs("valancedrop")<>"" then valancesize= rs("valancedrop") & " x "
		if rs("valancewidth")<>"" then valancesize=valancesize & rs("valancewidth") & " x "
		if rs("valancelength")<>"" then valancesize=valancesize &  rs("valancelength") & "cm"
		prodtable=prodtable & "<tr><td>Valance<br />" & rs("valancefabricchoice") & "</td><td>" & valancesize & "</td><td align=""center"">1</td><td align=""right"">" & ordercurrency & formatnumber(valanceprice,2) & "</td><td align=""right"">" & ordercurrency & formatnumber(valanceprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(valanceprice)
	end if
	if componentarray(i)=7 then
		If rs("legprice")<>"" and NOT ISNULL(rs("legprice")) then legprice=rs("legprice") else legprice=0
		prodtable=prodtable & "<tr><td>" & rs("legstyle") & " Legs<br />" & rs("legfinish") & "</td><td>" & rs("legheight") & "</td><td align=""center"">" & rs("legqty") & "</td><td align=""right"">" & ordercurrency & formatnumber((CDbl(legprice))/CDbl(rs("legqty")),2) & "</td><td align=""right"">" & ordercurrency & formatnumber(legprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(legprice)
	end if
	if componentarray(i)=8 then
		If rs("headboardprice")<>"" and   NOT ISNULL(rs("headboardprice"))  then headboardprice=rs("headboardprice")
		'If rs("hbfabricprice")<>"" and   NOT ISNULL(rs("hbfabricprice"))  then headboardprice=CDbl(headboardprice) + CDbl(rs("hbfabricprice"))
		'if rs("headboardlegqty") <>"" and not isNull(rs("headboardlegqty")) and rs("headboardlegqty")<>"n" and rs("headboardlegqty")<>"0" then hblegs="<br />Heaboard Legs:" &  rs("headboardlegqty")
		sizes=""
		sizes=getHbWidth(con, rs("purchase_no"))
		if sizes<>"" then sizes=sizes & "cm wide<br />"
		'sizes=sizes & rs("headboardheight")
		prodtable=prodtable & "<tr><td>" & rs("headboardstyle") & " Headboard</td><td>" & sizes & "</td><td align=""center"">1</td><td align=""right"">" & ordercurrency & formatnumber(headboardprice,2) & "</td><td align=""right"">" & ordercurrency & formatnumber(headboardprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(headboardprice)
		If rs("hbfabricprice")<>"" and rs("hbfabricprice")<>"0" and NOT ISNULL(rs("hbfabricprice")) then
			prodtable=prodtable & "<tr><td>Headboard Fabric " & rs("headboardfabric") & "<br />" & rs("headboardfabricchoice")
			prodtable=prodtable & "</td><td>Meters</td><td align=""center"">" & rs("hbfabricmeters") & "</td><td align=""right"">" & ordercurrency & FormatNumber(CDbl(rs("hbfabriccost")),2) & "</td><td align=""right"">" & ordercurrency & FormatNumber(CDbl(rs("hbfabricprice")),2) & "</td></tr>"
			invoicetotal=invoicetotal + CDbl(rs("hbfabricprice"))
		end if
	end if
	if componentarray(i)=9 then
		sql="SELECT * from orderaccessory where purchase_no=" & purchase_no
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		if not rs1.eof then
			do until rs1.eof
			accprice=0
			accprice=CDbl(rs1("unitprice")) * CDbl(rs1("qty"))
		prodtable=prodtable & "<tr><td>" & rs1("description") & " " & rs1("colour") & " " & rs1("design") & "</td><td>" & rs1("size") & "</td><td align=""center"">" & rs1("qty") & "</td><td align=""right"">" & ordercurrency & formatNumber(CDbl(rs1("unitprice")),2) & "</td><td align=""right"">" & ordercurrency & formatNumber(accprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(accprice)
			rs1.movenext
			loop
		end if
		rs1.close
		set rs1=nothing
	end if
	prodtable=prodtable & "<tr><td colspan=""5"">&nbsp;</td></tr>"
next
if rs("deliverycharge")="y" then
		prodtable=prodtable & "<tr><td>Delivery Charge </td><td>&nbsp;</td><td align=""center"">1</td><td align=""right"">" & ordercurrency & FormatNumber(CDbl(rs("deliveryprice")),2) & "</td><td align=""right"">" & ordercurrency & FormatNumber(CDbl(rs("deliveryprice")),2) & "</td></tr>"
			invoicetotal=invoicetotal + CDbl(rs("deliveryprice"))
	end if
prodtable=prodtable & "</font></table>"


x=530

sql="Select * from showroomdata WHERE showroomlocationid=" & showroomadd

Set rs2 = getMysqlQueryRecordSet(sql, con)
if rs2("invoiceconame")<>"" then showroomaddress=rs2("invoiceconame") & "<br />"
if rs2("Invoiceadd1")<>"" then showroomaddress= showroomaddress & rs2("Invoiceadd1") & "<br />"
if rs2("Invoiceadd2")<>"" then showroomaddress= showroomaddress & rs2("Invoiceadd2") & "<br />"
if rs2("Invoiceadd3")<>"" then showroomaddress= showroomaddress & rs2("Invoiceadd3") & "<br />"
if rs2("Invoicetown")<>"" then showroomaddress= showroomaddress & rs2("Invoicetown") & "<br />"
if rs2("Invoicecountry")<>"" then showroomaddress= showroomaddress & rs2("Invoicecountry") & "<br />"
if rs2("Invoicepostcode")<>"" then showroomaddress= showroomaddress & rs2("Invoicepostcode")
if rs2("sageref")<>"" then sageref=rs2("sageref")
if rs2("invoicenote1")<>"" then 
	showroomnotes=invoicenotecount & ". " & rs2("invoicenote1") & "<br>"
	invoicenotecount=invoicenotecount+1
	else
	x=x+10
end if
if rs2("invoicenote2")<>"" then 
	showroomnotes=showroomnotes & invoicenotecount & ". " & rs2("invoicenote2") & "<br>"
	invoicenotecount=invoicenotecount+1
	else
	x=x+10
end if
if rs2("invoicenote3")<>"" then 
	showroomnotes=showroomnotes & invoicenotecount & ". " & rs2("invoicenote3") & "<br>"
	invoicenotecount=invoicenotecount+1
	else
	x=x+10
end if
if rs2("invoicenote4")<>"" then 
	showroomnotes=showroomnotes & invoicenotecount & ". " & rs2("invoicenote4") & "<br>"
	invoicenotecount=invoicenotecount+1
	else
	x=x+10
end if
if rs2("invoicenote5")<>"" then 
	showroomnotes=showroomnotes & invoicenotecount & ". " & rs2("invoicenote5") & "<br>"
	invoicenotecount=invoicenotecount+1
	else
	x=x+10
end if
if rs2("invoicenote6")<>"" then 
	showroomnotes=showroomnotes & invoicenotecount & ". " & rs2("invoicenote6") & "<br>"
	invoicenotecount=invoicenotecount+1
	else
	x=x+10
end if
if rs2("paymentterms")<>"" and rs2("termsenabled")="y" then
paymentterms=CDbl(rs2("paymentterms"))


paymentduedate=DateAdd("D", paymentterms, invdate)
if Weekday(paymentduedate)=7 then paymentduedate=DateAdd("D", 2, paymentduedate)
if Weekday(paymentduedate)=1 then paymentduedate=DateAdd("D", 1, paymentduedate)

showroomnotes=showroomnotes & invoicenotecount & ". Payment due on: " & paymentduedate
end if
bankdetails="<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""1"">"

	bankdetails=bankdetails & "<font size=""8""><tr><td width=""80"">Bank Details:</td><td width=""80"">Account Name:</td><td>" & rs2("bankacname") & "</td><tr>"
	
if rs2("bankacNO")<>"" then 
	bankdetails=bankdetails & "<tr><td>&nbsp;</td><td>Account No:</td><td>" & rs2("bankacNO") & "</td><tr>"
else
	x=x+10
end if
if rs2("banksortcode")<>"" then 
	bankdetails=bankdetails & "<tr><td>&nbsp;</td><td>Sort Code:</td><td>" & rs2("banksortcode") & "</td><tr>"
	else
	x=x+10
end if
if rs2("bankroutingno")<>"" then 
	bankdetails=bankdetails & "<tr><td>&nbsp;</td><td>Bank Routing No:</td><td>" & rs2("bankroutingno") & "</td><tr>"
	else
	x=x+10
end if
if rs2("bankaddress")<>"" then 
	bankdetails=bankdetails & "<tr><td>&nbsp;</td><td>Bank Address:</td><td>" & rs2("bankaddress") & "</td><tr>"
	else
	x=x+10
end if
if rs2("IBAN")<>"" then 
	bankdetails=bankdetails & "<tr><td>&nbsp;</td><td>IBAN:</td><td>" & rs2("IBAN") & "</td><tr>"
	else
	x=x+10
end if
if rs2("SWIFT")<>"" then 
	bankdetails=bankdetails & "<tr><td>&nbsp;</td><td>SWIFT:</td><td>" & rs2("SWIFT") & "</td><tr>"
	else
	x=x+10
end if
bankdetails=bankdetails & "<tr><td colspan=""3"" align=""center""><br /><br /><b>PAYMENT DUE</b><br />VAT Reg. No. GB 706 8175 27<br />Savoir Beds Limited, Registered in England No. 3395749<br />Registered Office: 1 Old Oak Lane, London NW10 6UD, UK. Email: accounts@savoirbeds.co.uk<br /><br />All goods remain the property of Savoir Beds Ltd until payment is received in full.</td></tr></font></table>"
rs2.close
set rs2=nothing





clienthdg="<font family=""Arial""><font size=""8"">"
clienthdg=clienthdg & "</font></font>"



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
const csHTML_FontSize  = 101
const csHTML_FontName=252


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
const csPropGraphWidthLine = 400
const csPropGraphBorder = 413

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
PDF.SetMargins 50,50,50,10
 


PDF.SetProperty csPropTextAlign, algCenter
YPos = int(PDF.GetProperty(csPropPosY))
PDF.SetPos 20, YPos - 25
PDF.AddFont"F9", "Arial", "WinAnsi", fsNone, 0 
PDF.SetProperty csPropParLeft, "60"
PDF.SetProperty csPropPosX, "40"
PDF.SetProperty csHTML_FontName, "F1"
PDF.SetProperty csHTML_FontSize, "1"
PDF.SetProperty csPropTextColor,"#999"
PDF.SetProperty csPropTextAlign, "0"
PDF.SetProperty csPropAddTextWidth, 1
PDF.SetProperty csPropGraphWidthLine, 0.5
PDF.SetProperty csPropGraphBorder, 1
PDF.SetFont "F15", 10, "#999"
PDF.SetProperty csPropTextFont, "F1"

DrawBox 50,90, 235, 92
DrawBox 303,90, 237, 92

PDF.SetFont "F1", 6, "#000"
PDF.AddHTML "<p align=""center""><img src=""images/savoirbeds-logo.gif""></p>"
PDF.AddHTMLPos 234, 56, "<font size=""8px"">1 Old Oak Lane London, NW10 6UD, UK</font>"
PDF.AddHTMLPos 194, 66, "<font size=""8px"">Telephone: +44 (0)20 8838 4838  Facsimile: +44 (0)20 8838 6660</font>"

PDF.AddHTMLPos 50, 96, "<p align=""left""><font size=""8px"">" & utf8toLatin1(showroomaddress) & "</font></p>"
PDF.AddHTMLPos 311, 96, "<font size=""8px""><b>Invoice:</b></font>"
PDF.AddHTMLPos 360, 96, "<font size=""8px"">" & invno & "</font>"
PDF.AddHTMLPos 311, 106, "<font size=""8px""><b>Tax Point:</b></font>"
PDF.AddHTMLPos 360, 106, "<font size=""8px"">" & invdate & "</font>"
PDF.AddHTMLPos 311, 116, "<font size=""8px""><b>Our Ref:</b></font>"
PDF.AddHTMLPos 360, 116, "<font size=""8px"">" & rs("order_number") & "</font>"
PDF.AddHTMLPos 311, 126, "<font size=""8px""><b>Account:</b></font>"
PDF.AddHTMLPos 360, 126, "<font size=""8px"">" & sageref & "</font>"
PDF.AddHTMLPos 311, 136, "<font size=""8px""><b>Your Order:</b></font>"
if rs("customerreference")<>"" then PDF.AddHTMLPos 360, 136, "<font size=""8px"">" & rs("customerreference") & "</font>"

PDF.AddHTMLPos 270, 189, "<font size=""12px""><b>INVOICE</b></font>"
PDF.AddHTMLPos 58, 200, prodtable
if rs("istrade")="y" then
vat=invoicetotal*(CDbl(rs("vatrate"))/100)
else
vatcalc=invoicetotal/(1+CDbl(rs("vatrate"))/100)
vat=invoicetotal-vatcalc
end if
if rs("istrade")="y" then
invoicetotal=invoicetotal+vat
else
end if
PDF.AddHTMLPos 380, x, "&nbsp;"
PDF.AddHTML "<table width=""100%"" border=""1"" cellspacing=""0"" cellpadding=""2""><font size=""8px""><tr><td width=""80%"" style=""border-right:none""><font size=""8"">Total Net:</font></td><td align=""right"">" & ordercurrency & formatnumber(invoicetotal,2) & "</td></tr><tr><td>VAT: " & rs("vatrate") & "%</td><td align=""right"">" & ordercurrency & formatNumber(vat,2) & "</td></tr><tr><td>Gross Total: </td><td align=""right"">" & ordercurrency & formatnumber(invoicetotal,2) & "</td></tr></table>"


if showroomnotes<>"" then 
PDF.AddHTML "<br><table width=""100%"" border=""0"" cellspacing=""2"" cellpadding=""1""><tr><td width=""80"">Notes:</td><td>" & showroomnotes & "</td></tr></font></table>"
end if
PDF.AddHTML "<br />" & bankdetails
PDF.BinaryWrite
set pdf = nothing

rs.close
set rs=nothing

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
