<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="componentfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, rs1, rs2, recordfound, id, rspostcode, submit1, submit2, count, envelopecount, i, fieldName, fieldValue, fieldNameArray, type1, submit3, submit4, submit5, lettercount, corresid, nobrochurealert, xcount, ycount, x, y, sql, correspondencename, val, val2, clientname, matt1width, matt2width, matt1length, matt2length, base1width, base2width, base1length, base2length, topper1width, topper1length, speciallegheight, orderCurrency, prodtable, invoicetotal, mattressprice, mattwidthstring, baseprice, basewidthstring, legprice, legqty, valfabriccost, valfabricprice, valanceprice, valancesize, headboardprice, sizes, accprice, vat, topperwidthstring, topperprice, clientaddress, legsspecial
val2=Request("pn")
val=Request("val")
corresid=Request("corresid")

Set Con = getMysqlConnection()
Set rs = getMysqlUpdateRecordSet("Select * from region Where id_region=" & retrieveUserLocation() & "", con)
'Session.LCID=1029
Session.LCID=trim(rs("locale"))
rs.close
set rs=nothing
sql = "Select * from productionsizes where purchase_no = " & val2
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
sql="Select * from purchase WHERE purchase_no=" & val2 & ""

Set rs = getMysqlQueryRecordSet(sql, con)

orderCurrency = rs("ordercurrency")
if orderCurrency="GBP" then ordercurrency="&pound;"
if orderCurrency="USD" then ordercurrency="&#36;"
if orderCurrency="EUR" then ordercurrency="&#8364;"

prodtable="<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""3"">"
prodtable=prodtable & "<tr><td width=""40%""><b>Bed Model</b></td><td><b>Size</b></td><td align=""center""><b>Qty</b></td><td align=""right""><b>Unit Price/" & rs("ordercurrency") & "</b></td><td align=""right""><b>Price/" & rs("ordercurrency") & "</b></td></tr>"

	if rs("mattressrequired")="y" then
	mattressprice=0.00
	If rs("mattressprice")<>"" and NOT ISNULL(rs("mattressprice"))  then mattressprice=FormatNumber(rs("mattressprice"),2)
		if matt1width<>"" then mattwidthstring= matt1width & " x "
		if matt1width="" then mattwidthstring= rs("mattresswidth") & " x "
		if matt1length<>"" then mattwidthstring=mattwidthstring & matt1length & "cm "
		if matt1length="" then mattwidthstring=mattwidthstring & rs("mattresslength") & " "
		if matt2width<>"" then mattwidthstring=mattwidthstring & matt2width & " x "
		if matt2length<>"" then mattwidthstring=mattwidthstring & matt2length & "cm"
		prodtable=prodtable & "<tr><td>" & rs("savoirmodel") & " Mattress"
		if rs("tickingoptions")<>"n" then prodtable=prodtable & ", " & rs("tickingoptions")
		if rs("mattresstype")<>"n" and NOT ISNULL(rs("mattresstype")) then prodtable=prodtable & ", " & rs("mattresstype")
		prodtable=prodtable & "<br />Left Support: " & rs("leftsupport") & ".  Right Support: " & rs("rightsupport")
		prodtable=prodtable & "</td><td>" & mattwidthstring & "</td><td align=""center"">1</td><td align=""right"">" & ordercurrency & formatnumber(mattressprice,2) & "</td><td align=""right"">" & ordercurrency & formatnumber(mattressprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(mattressprice)
	end if
	if rs("baserequired")="y" then
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
		prodtable=prodtable & "<tr><td>" & rs("basesavoirmodel") & " Base"
		if rs("basetickingoptions")<>"n" then prodtable=prodtable & ", " & rs("basetickingoptions")
		if rs("basetype")<>"n" AND NOT ISNULL(rs("basetype")) then prodtable=prodtable & ", " & rs("basetype")
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
	if rs("topperrequired")="y" then
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
	if rs("valancerequired")="y" then
		if (rs("valfabriccost") <> "" and rs("valfabriccost")<>"0" and  Not isNull("valfabriccost")) then valfabriccost=CDbl(rs("valfabriccost")) else valfabriccost=0
		if (rs("valfabricprice") <> "" and rs("valfabricprice")<>"0" and  Not isNull("valfabricprice")) then valfabricprice=CDbl(rs("valfabricprice")) else valfabricprice=0
		If rs("valanceprice")<>"" and NOT ISNULL(rs("valanceprice"))  then valanceprice=rs("valanceprice")
		if rs("valancedrop")<>"" then valancesize= rs("valancedrop") & " x "
		if rs("valancewidth")<>"" then valancesize=valancesize & rs("valancewidth") & " x "
		if rs("valancelength")<>"" then valancesize=valancesize &  rs("valancelength") & "cm"
		prodtable=prodtable & "<tr><td>Valance<br />" & rs("valancefabricchoice") & "</td><td>" & valancesize & "<br />Meters</td><td align=""center"">1<br />" & rs("valfabricmeters") & "</td><td align=""right"">" & ordercurrency & formatnumber(valanceprice,2) & "<br />" & ordercurrency & formatnumber(valfabriccost,2) & "</td><td align=""right"">" & ordercurrency & formatnumber(valanceprice,2) & "<br />" & ordercurrency & formatnumber(valfabricprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(valanceprice) + Cdbl(valfabricprice)
	end if
	if rs("legsrequired")="y" then
		If rs("legprice")<>"" and NOT ISNULL(rs("legprice")) then legprice=rs("legprice") else legprice=0
		if rs("legqty")<>"" and NOT ISNULL(rs("legqty")) then legqty=rs("legqty") else legqty=0
		if rs("AddLegQty")<>"" and NOT ISNULL(rs("AddLegQty")) then legqty=legqty+rs("AddLegQty")
		Dim legindividualprice
		if CDbl(legprice)=0 then legindividualprice=0
		if Cdbl(legqty)=0 and CDbl(legprice)>0 then legindividualprice=CDbl(legprice)
		if Cdbl(legqty)>0 and CDbl(legprice)>0 then legindividualprice=CDbl(legprice)/CDbl(legqty)
		if rs("legstyle") = "Special Instructions" or rs("legstyle")="Special (as instructions)" then 
		legsspecial=" " & rs("specialinstructionslegs") 
		else 
		legsspecial=""
		end if
		prodtable=prodtable & "<tr><td>" & rs("legstyle") & " Legs<br />" & rs("legfinish") & legsspecial & "</td><td>" & rs("legheight") & "</td><td align=""center"">" & legqty & "</td><td align=""right"">" & ordercurrency & formatnumber(legindividualprice,2) & "</td><td align=""right"">" & ordercurrency & formatnumber(legprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(legprice)
	end if
	if rs("headboardrequired")="y" then
		If rs("headboardprice")<>"" and   NOT ISNULL(rs("headboardprice"))  then headboardprice=rs("headboardprice")
		'If rs("hbfabricprice")<>"" and   NOT ISNULL(rs("hbfabricprice"))  then headboardprice=CDbl(headboardprice) + CDbl(rs("hbfabricprice"))
		'if rs("headboardlegqty") <>"" and not isNull(rs("headboardlegqty")) and rs("headboardlegqty")<>"n" and rs("headboardlegqty")<>"0" then hblegs="<br />Heaboard Legs:" &  rs("headboardlegqty")
		sizes=""
		sizes=getHbWidth(con, rs("purchase_no"))
		if sizes<>"" then sizes=sizes & "cm wide<br />"
		'sizes=sizes & rs("headboardheight")
		prodtable=prodtable & "<tr><td>" & rs("headboardstyle") & " Headboard"
		if rs("specialinstructionsheadboard")<>"" then
		prodtable=prodtable & "<br />" & rs("specialinstructionsheadboard")
		end if
		
		prodtable=prodtable & "</td><td>" & sizes & "</td><td align=""center"">1</td><td align=""right"">" & ordercurrency & formatnumber(headboardprice,2) & "</td><td align=""right"">" & ordercurrency & formatnumber(headboardprice,2)
		
		
		prodtable=prodtable & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(headboardprice)
		If rs("hbfabricprice")<>"" and rs("hbfabricprice")<>"0" and NOT ISNULL(rs("hbfabricprice")) then
			prodtable=prodtable & "<tr><td>Headboard Fabric " & Utf8ToUnicode(rs("headboardfabric")) & "<br />" & Utf8ToUnicode(rs("headboardfabricchoice"))
			prodtable=prodtable & "</td><td>Meters</td><td align=""center"">" & Utf8ToUnicode(rs("hbfabricmeters")) & "</td><td align=""right"">" & ordercurrency & FormatNumber(CDbl(rs("hbfabriccost")),2) & "</td><td align=""right"">" & ordercurrency & FormatNumber(CDbl(rs("hbfabricprice")),2) & "</td></tr>"
			invoicetotal=invoicetotal + CDbl(rs("hbfabricprice"))
		end if
	end if
	if rs("accessoriesrequired")="y" then
		sql="SELECT * from orderaccessory where purchase_no=" & val2
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		if not rs1.eof then
			do until rs1.eof
			accprice=0
			accprice=CDbl(rs1("unitprice")) * CDbl(rs1("qty"))
		prodtable=prodtable & "<tr><td>" & Utf8ToUnicode(rs1("description")) & " " & Utf8ToUnicode(rs1("colour")) & " " & Utf8ToUnicode(rs1("design")) & "</td><td>" & Utf8ToUnicode(rs1("size")) & "</td><td align=""center"">" & rs1("qty") & "</td><td align=""right"">" & ordercurrency & formatNumber(CDbl(rs1("unitprice")),2) & "</td><td align=""right"">" & ordercurrency & formatNumber(accprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(accprice)
			rs1.movenext
			loop
		end if
		rs1.close
		set rs1=nothing
	end if
	prodtable=prodtable & "<tr><td colspan=""5"">&nbsp;</td></tr>"

if rs("deliverycharge")="y" then
		prodtable=prodtable & "<tr><td>Delivery Charge </td><td>&nbsp;</td><td align=""center"">1</td><td align=""right"">" & ordercurrency & FormatNumber(CDbl(rs("deliveryprice")),2) & "</td><td align=""right"">" & ordercurrency & FormatNumber(CDbl(rs("deliveryprice")),2) & "</td></tr>"
			invoicetotal=invoicetotal + CDbl(rs("deliveryprice"))
	end if
prodtable=prodtable & "</table>"%>



<%
lettercount=0
sql="Select C.title, C.first, C.surname, A.company, A.street1, A.street2, A.street3, A.county, A.town, A.county, A.postcode, A.country, P.order_number, L.tel, P.mattressrequired, P.vatrate, P.subtotal, P.vat, P.total, P.balanceoutstanding, P.paymentstotal, U.name, L.location from address A, contact C, purchase P, Location L, Savoir_user U Where  P.purchase_no=" & val2 & " AND P.contact_no=C.Contact_no and A.code=C.code and P.idlocation=L.idlocation and P.salesusername=U.username"

Set rs = getMysqlQueryRecordSet(sql, con)
If rs("title")<>"" Then clientaddress=Utf8ToUnicode(capitalise(rs("title"))) & " "
If rs("first")<>"" Then clientaddress=clientaddress & Utf8ToUnicode(capitaliseName(rs("first"))) & " "
If rs("surname")<>"" Then clientaddress=clientaddress & Utf8ToUnicode(capitaliseName(rs("surname"))) & "<br />"
If rs("company")<>"" Then clientaddress=clientaddress & rs("company") & "<br />"
If rs("street1")<>"" Then clientaddress=clientaddress & rs("street1") & "<br />"
If rs("street2")<>"" Then clientaddress=clientaddress & rs("street2") & "<br />"
If rs("street3")<>"" Then clientaddress=clientaddress & rs("street3") & "<br />"
If rs("county")<>"" Then clientaddress=clientaddress & rs("town") & " "
If rs("county")<>"" Then clientaddress=clientaddress & rs("county") & " "
If rs("postcode")<>"" Then clientaddress=clientaddress & rs("postcode") & "<br />"
If rs("country")<>"" Then clientaddress=clientaddress & rs("country")
If rs("title")<>"" Then clientname=capitalise(rs("title")) & " "
If rs("surname")<>"" Then clientname=clientname & Utf8ToUnicode(capitaliseName(rs("surname")))

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
const csHTML_FontName = 252
const csHTML_FontSize  = 253


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
'PDF.License("$162185902;'David Mildenhall';PDF;1;0-217.199.174.247;0-109.104.75.208")
PDF.License("$810217456;'David Mildenhall';PDF;1;0-31.170.121.214")
PDF.page "A4", 0  'landscape

'PDF.DEBUG = True
PDF.SetMargins 40,35,10,5


PDF.SetProperty csPropTextAlign, algCenter
YPos = int(PDF.GetProperty(csPropPosY))
PDF.SetPos 0, YPos - 5
'PDF.AddLine 60, 55, 520, 55
PDF.SetTrueTypeFont "F15", "Times-Roman", 0, 0

PDF.SetProperty csHTML_FontSize, 9
PDF.SetProperty csHTML_FontName, "Times-Roman"
PDF.SetProperty csPropTextColor,"#999"
PDF.SetProperty csPropTextAlign, "0"
PDF.SetProperty csPropAddTextWidth, 1


PDF.AddHTML "<p align=""center""><img src=""images/logo.gif"" width=""255""><br>Order No: " & rs("order_number") & "<br>FINAL BALANCE REQUEST</p>"
PDF.AddHTML  "<p>" & FormatDateTime(date(), 1) & "</p>"
PDF.AddHTML  "<p>" & clientaddress & "</p>"
PDF.AddHTML  "<p>Dear " & clientname & ",</p>"
PDF.AddHTML  "<p>We are pleased to confirm that we are in the final stages of production for your bed set, and your bed set is due to be completed soon.</p><p>The outstanding balance on your bed set is presented on the following page and I would be grateful if you can arrange for this payment to be made prior to delivery. To pay this final amount by card, please call our showroom on " & rs("tel") & ". Alternatively, you can arrange a bank transfer to the following account:</p><p>Bank Name: HSBC<br />Bank Address: 69 Park Royal Road, London, NW10 7JR<br />Account Name: Savoir Beds Ltd<br />Sort Code: 40-05-23<br />Account Number: 81321846<br />IBAN: GB24HBUK40052381321846<br />BIC: HBUKGB4B<br /></p>"

PDF.AddHTML "<p>I look forward to hearing from you soon regarding the delivery. </p> <p>Kind regards,<br>" & rs("name") & "<br />" & rs("location") & "</p><br />"
PDF.AddHTMLPos 230, 774,  "<b>~ Payment is due prior to delivery ~</b>"
PDF.AddHTMLPos 240, 789,  "<b><b>VAT Reg. No. GB 706 8175 27</b>"
PDF.AddPage
PDF.AddHTML "<p align=""center""><img src=""images/logo.gif"" width=""255""><br>Order No: " & rs("order_number") & "<br>FINAL BALANCE REQUEST</p>"
PDF.AddHTML  prodtable
PDF.AddHTML "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""4""><tr><td width=""80%"">Sub Total:</td><td align=""right"">" & ordercurrency & formatnumber(rs("subtotal"),2) & "</td></tr><tr><td>VAT: " & rs("vatrate") & "%</td><td align=""right"">" & ordercurrency & formatNumber(rs("vat"),2) & "</td></tr><tr><td>Gross Total: </td><td align=""right"">" & ordercurrency & formatnumber(rs("total"),2) & "</td></tr><tr><td>Deposit Paid: </td><td align=""right"">" & ordercurrency & formatnumber(rs("paymentstotal"),2) & "</td></tr><tr><td><b>Balance Outstanding:</b> </td><td align=""right""><b>" & ordercurrency & formatnumber(rs("balanceoutstanding"),2) & "</b></td></tr></table>"

PDF.BinaryWrite
set pdf = nothing

rs.close
set rs=nothing
con.close
set con=nothing


function capitalise(str)
dim words, word
if isNull(str) or trim(str)="" then
	capitalise=""
else
	words = split(trim(str), " ")
	for each word in words
		If IsNumeric(word) Then
		Else
		word = lcase(word)
		word = ucase(left(word,1)) & (right(word,len(word)-1))
		capitalise = capitalise & word & " "
		End If
	next
	capitalise = left(capitalise, len(capitalise)-1)
end if
end function

%>

   
