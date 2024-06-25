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
<!-- #include file="packagingfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, rs4, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, str8, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, ademail, aw, x, str18, baseupholsteryprice
Dim matt1width, matt2width, matt1length, matt2length, base1width, base2width, base1length, base2length, topper1width, topper1length, basewidthstring, mattwidthstring, topperwidthstring, speciallegheight, commercialordertable, collectiondate, loc, countryname, shipperid, shipperdetails, overseasterms, items, componentname1, wrap, wraptext, hbwidth,  totalgross, cm3, totalcost, wraptext2, totalexvat, vat, vatrate, invoiceno, legno, contact1, contact2, contact3, containerref, exportdate, eta, transportmode, manifesttable, pnarray(), totalitemcount, totalitemcount1, pagelength, pagelengthtotal, z, manifestable1, manifestable2, manifestable3, manifestable4, manifestable5, pagenumber, footer, valanceexists, consignee, destport, deliveryterms, packdimensions, packheight, boxweight, boxname, accdesccounter, totalNW, totalGW, wholesaleprices
wholesaleprices="n"
totalNW=0
totalGW=0
consignee=""
accdesccounter=1
valanceexists="n"
Dim amanifesttable()
pagenumber=0
pagelengthtotal=0
totalitemcount=1
eta=request("eta")
loc=CDbl(request("loc"))
cm3=0
wraptext=""
dim componentarray(), dimensionsarray(), tarrifarray(), weightarray(), cubicmetersarray(), wholesaleprice()
dim componentpricearray(), grossweightarray()
dim m1width, m2width, m1length, m2length
dim weight, tarrifcode, depth, weightcalc

speciallegheight=""
aw="n"
aw=request("aw")
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
shipperid=CDbl(request("sid"))
collectionid=CDbl(request("cid"))

sql = "Select * from shipper_address where  shipper_Address_Id= " & shipperid
set rs3 = getMysqlQueryRecordSet(sql, con)
if not rs3.eof then
if rs3("shippername")<>"" then shipperdetails=shipperdetails & Utf8ToUnicode(rs3("shippername")) & "<br>"
if rs3("add1")<>"" then shipperdetails=shipperdetails & Utf8ToUnicode(rs3("add1")) & "<br>"
if rs3("add2")<>"" then shipperdetails=shipperdetails & Utf8ToUnicode(rs3("add2")) & "<br>"
if rs3("add3")<>"" then shipperdetails=shipperdetails & Utf8ToUnicode(rs3("add3")) & "<br>"
if rs3("town")<>"" then shipperdetails=shipperdetails & Utf8ToUnicode(rs3("town")) & "<br>"
if rs3("countystate")<>"" then shipperdetails=shipperdetails & Utf8ToUnicode(rs3("countystate")) & "<br>"
if rs3("postcode")<>"" then shipperdetails=shipperdetails & Utf8ToUnicode(rs3("postcode")) & "<br>"
if rs3("country")<>"" then shipperdetails=shipperdetails & Utf8ToUnicode(rs3("country")) & "<br>"
if rs3("contact")<>"" then shipperdetails=shipperdetails & Utf8ToUnicode(rs3("contact")) & " <br> "
if rs3("phone")<>"" then shipperdetails=shipperdetails & "Tel: " & rs3("phone") & " "
end if
rs3.close
set rs3=nothing

sql="SELECT * from exportcollections where exportCollectionsID=" & collectionid
			
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		containerref=rs1("containerref")
		exportdate=rs1("Collectiondate")
		transportmode=rs1("TransportMode")
		deliveryterms=rs1("exportDeliveryTerms")
		destport=rs1("destinationport")
		rs1.close
		set rs1=nothing
sql="SELECT * from deliveryterms where deliverytermsId=" & deliveryterms
			
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		if not rs1.eof then
		deliveryterms=rs1("DeliveryTerms")
		end if
		rs1.close
		set rs1=nothing
		
sql="SELECT * from exportcollections E, consignee_address C where exportCollectionsID=" & collectionid & " and E.consignee=C.consignee_Address_id"
			
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		if not rs1.eof then
		if rs1("consigneename")<>"" then consignee=consignee & Utf8ToUnicode(rs1("consigneename")) & "<br>"
		if rs1("add1")<>"" then consignee=consignee & Utf8ToUnicode(rs1("add1")) & "<br>"
		if rs1("add2")<>"" then consignee=consignee & Utf8ToUnicode(rs1("add2")) & "<br>"
		if rs1("add3")<>"" then consignee=consignee & Utf8ToUnicode(rs1("add3")) & "<br>"
		if rs1("town")<>"" then consignee=consignee & Utf8ToUnicode(rs1("town")) & "<br>"
		if rs1("countystate")<>"" then consignee=consignee & Utf8ToUnicode(rs1("countystate")) & "<br>"
		if rs1("postcode")<>"" then consignee=consignee & Utf8ToUnicode(rs1("postcode")) & "<br>"
		if rs1("country")<>"" then consignee=consignee & Utf8ToUnicode(rs1("country")) & "<br>"
		if rs1("contact")<>"" then consignee=consignee & Utf8ToUnicode(rs1("contact")) & "<br>"
		if rs1("phone")<>"" then consignee=consignee & Utf8ToUnicode(rs1("phone")) & "<br>"
		end if
		rs1.close
		set rs1=nothing

sql="SELECT * from location L, Region R where L.idlocation=" & loc & " AND L.owning_region=R.id_region"
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		country=rs1("country")
		rs1.close
		set rs1=nothing

sql="SELECT distinct purchase_no from exportlinks E, exportCollShowrooms S  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & collectionid & " AND orderConfirmed='y'"
'response.Write("sql=" & sql)
Set rs1 = getMysqlQueryRecordSet(sql, con)
		  if rs1.eof then
		  totalpn=0
		  else
		  totalpn=rs1.recordcount
		  count=0
		  while not rs1.eof
				count = count + 1
				redim preserve pnarray(count)
				pnarray(count)=rs1("purchase_no")
				rs1.movenext
				wend	
		  end if
		  rs1.close
		  set rs1=nothing
		  if count = 0 then redim pnarray(0)
ordercurrency=""
for n = 1 to ubound(pnarray)
	sql="SELECT ordercurrency from purchase where purchase_no=" & pnarray(n) 
	Set rs1 = getMysqlQueryRecordSet(sql, con)
	if not rs1.eof then
		if ordercurrency="" then
			ordercurrency=rs1("ordercurrency")
		end if
		if ordercurrency<>rs1("ordercurrency") then
			ordercurrency=ordercurrency & "<br>" & rs1("ordercurrency")
		end if
	end if
	rs1.close
	set rs1=nothing
	
	sql="SELECT * from wholesale_prices where purchase_no=" & pnarray(n)
	Set rs1 = getMysqlQueryRecordSet(sql, con)
	if not rs1.eof then
		wholesaleprices="y"
	end if
	rs1.close
	set rs1=nothing
next


commercialordertable="<table border=1 width=""100%"" cellspacing=""1"" cellpadding=""4""><tr><td >" & consignee & "</td><td>Shipped By:<br>" & shipperdetails & "</td><td>Container No. " & containerref & "<br><hr>Export Date: " & exportdate & "<br><hr>Expected Arrival Date: " & eta & "</td></tr>"
commercialordertable=commercialordertable & "<tr><td>Terms & Conditions of Delivery and Payment: " & deliveryterms & " " & destport & "</td><td>Currency of Sale: " & ordercurrency & "</td><td>Mode of Transport: " & transportmode & "</td></tr>"
commercialordertable=commercialordertable & "<tr><td>Country of Origin: UK</td><td>Country of Origin of Goods: UK</td><td>Country of Final Destination: " & country & "</td></tr>"
commercialordertable=commercialordertable & "</table>"


		
		  
		  
		  
footer="<p align=""center""><font family=""Tahoma""><font size=""8"">VAT Reg. No. GB 706 8175 27<br>Savoir Beds Limited is registered in England & Wales: No. 3395749.<br>Registered Office: 1 Old Oak Lane, London NW10 6UD, UK</p>"
manifesttable="<table border=1 width=""100%"" cellspacing=""1"" cellpadding=""4""><tr><td width=""30"">Marks&nbsp;&&nbsp;No</td><td width=""67"">Kind of Packages</td><td width=""150"">Description of Goods</td><td width=""80"">Dimensions</td><td width=""40"">NW(kg)</td><tdwidth=""40"">GW(kg)</td><td width=""40"">Qty</td>"
if wholesaleprices="y" then
	manifesttable=manifesttable & "<td width=""30"">Price</td>"
end if
manifesttable=manifesttable & "</tr>"
manifesttable1="<table border=1 width=""100%"" cellspacing=""1"" cellpadding=""4""><tr><td width=""30"">Marks&nbsp;&&nbsp;No</td><td width=""67"">Kind of Packages</td><td width=""150"">Description of Goods</td><td width=""70"">Dimensions</td><td>NW(kg)</td><td>GW(kg)</td><td width=""40"">Qty</td>"
if wholesaleprices="y" then
	manifesttable1=manifesttable1 & "<td width=""30"">Price</td>"
end if
manifesttable1=manifesttable1 & "</tr>"
manifesttable2="<table border=1 width=""100%"" cellspacing=""1"" cellpadding=""4""><tr><td width=""30"">Marks&nbsp;&&nbsp;No</td><td width=""67"">Kind of Packages</td><td width=""150"">Description of Goods</td><td width=""70"">Dimensions</td><td>NW(kg)</td><td>GW(kg)</td><td width=""40"">Qty</td>"
if wholesaleprices="y" then
	manifesttable2=manifesttable2 & "<td width=""50"">Price</td>"
end if
manifesttable2=manifesttable2 & "</tr>"
manifesttable3="<table border=1 width=""100%"" cellspacing=""1"" cellpadding=""4""><tr><td width=""30"">Marks&nbsp;&&nbsp;No</td><td width=""67"">Kind of Packages</td><td width=""150"">Description of Goods</td><td width=""70"">Dimensions</td><td>NW(kg)</td><td>GW(kg)</td><td>Qty</td>"
if wholesaleprices="y" then
	manifesttable3=manifesttable3 & "<td>Price</td>"
end if
manifesttable3=manifesttable3 & "</tr>"
manifesttable4="<table border=1 width=""100%"" cellspacing=""1"" cellpadding=""4""><tr><td width=""30"">Marks&nbsp;&&nbsp;No</td><td width=""67"">Kind of Packages</td><td width=""150"">Description of Goods</td><td width=""70"">Dimensions</td><td>NW(kg)</td><td>GW(kg)</td><td>Qty</td>"
if wholesaleprices="y" then
	manifesttable4=manifesttable4 & "<td>Price</td>"
end if
manifesttable4=manifesttable4 & "</tr>"
manifesttable5="<table border=1 width=""100%"" cellspacing=""1"" cellpadding=""4""><tr><td width=""30"">Marks&nbsp;&&nbsp;No</td><td width=""67"">Kind of Packages</td><td width=""150"">Description of Goods</td><td width=""70"">Dimensions</td><td>NW(kg)</td><td>GW(kg)</td><td>Qty</td>"
if wholesaleprices="y" then
	manifesttable5=manifesttable5 & "<td>Price</td>"
end if
manifesttable5=manifesttable5 & "</tr>"

pagelength = 0
pagenumber=1
lastPageEmpty=true
redim preserve amanifesttable(pagenumber)
amanifesttable(pagenumber)="<table border=1 width=""100%"" cellspacing=""1"" cellpadding=""4""><tr><td width=""30"">Marks&nbsp;&&nbsp;No</td><td width=""67"">Kind of Packages</td><td width=""150"">Description of Goods</td><td width=""70"">Dimensions</td><td>NW(kg)</td><td>GW(kg)</td><td>Qty</td>"
if wholesaleprices="y" then
		amanifesttable(pagenumber)=amanifesttable(pagenumber) & "<td>Price</td>"
		end if
amanifesttable(pagenumber)=amanifesttable(pagenumber) & "<td>Delivery Address</td></tr>"

for n = 1 to ubound(pnarray)
	response.Write("pn=" & pnarray(n))
	lastPageEmpty=false
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & "<tr><td>" & getOrderNo(con,pnarray(n)) & "<br>" & getCustRef(con,pnarray(n)) & "</td>"%>
	<!-- #include file="ordercomponents1.asp" -->
	<%
	rs.movenext
	loop
	
	rs.close
	set rs=nothing
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & "<td colspan=7><table border=0 width=""100%"" cellspacing=""1"" cellpadding=""0"">"
	
for i=1 to itemcount
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & "<tr><td width=""65"" align=""left"">"
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & i & " of " & itemcount & " " & getWrapType(con,pnarray(n)) & "</td><td width=""120""><font size=""8"">"
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & componentarray(i) & "</td><td align=""left"" width=""70"">"
	
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & dimensionsarray(i) & "</td><td align=""left"" width=""40"">"
	
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & weightarray(i) & "</td><td align=""left"" width=""40"">"
	
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & grossweightarray(i) & "</td><td align=""left"" width=""40"">"
	
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & totalitemcount
	totalitemcount=totalitemcount+1
	
	if wholesaleprices="y" then
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & "</td><td align=""right"" width=""30"">" & wholesaleprice(i) & "</td><td>"
	end if
	
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & "</td></tr>"
next	
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & "</table></td><td width=""114"">" & getDeliveryAddress(con,pnarray(n))
	if getDeliveryContact(con,pnarray(n))<>"" then amanifesttable(pagenumber)=amanifesttable(pagenumber) & "<br>" & getDeliveryContact(con,pnarray(n))
	if getDeliveryTelNos(con,pnarray(n))<>"" then amanifesttable(pagenumber)=amanifesttable(pagenumber) & "<br>" & getDeliveryTelNos(con,pnarray(n))
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & "</td><td align=""center"" width=""7"">"
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & "</td></tr>"
	
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & "</tr>"
	'work out pagelength
	totalitemcount1=getDelAddressLinecount(con,pnarray(n))
	
	if itemcount>totalitemcount1 then 
		pagelength=pagelength+itemcount 
	else
		pagelength=pagelength+totalitemcount1
	end if

	if pagelength > 28 then
		amanifesttable(pagenumber)=amanifesttable(pagenumber) & "</table>"
		pagenumber=pagenumber+1
		redim preserve amanifesttable(pagenumber)
		amanifesttable(pagenumber)="<table border=1 width=""100%"" cellspacing=""1"" cellpadding=""4""><tr><td width=""30"">Marks&nbsp;&&nbsp;No</td><td width=""67"">Kind of Packages</td><td width=""150"">Description of Goods</td><td width=""70"">Dimensions</td><td>NW(kg)</td><td>GW(kg)</td><td>Qty</td>"
		if wholesaleprices="y" then
		amanifesttable(pagenumber)=amanifesttable(pagenumber) & "<td>Price</td>"
		end if
		amanifesttable(pagenumber)=amanifesttable(pagenumber) & "<td>Delivery Address</td></tr>"
		pagelength = 0
		lastPageEmpty=true
	end if
next

if pagelength < 29 then
	amanifesttable(pagenumber)=amanifesttable(pagenumber) & "</table>"
end if 
if lastPageEmpty then 
	pagenumber=pagenumber-1
end if
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
const csHTML_TableDraw =0
const csHTML_TRFullPage = 250


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
PDF.SetProperty csHTML_FontName, "F15"
PDF.SetProperty csHTML_FontSize, "9"
PDF.SetProperty csPropTextColor,"#999"
PDF.SetProperty csPropTextAlign, "0"
PDF.SetProperty csPropAddTextWidth, 1
PDF.SetProperty csHTML_TRFullPage, true

for n = 1 to pagenumber

	if n>1 then
		PDF.AddPage
	end if

	PDF.SetFont "F1", 12, "#999"
	PDF.AddHTML "<p align=""center""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
	PDF.AddHTMLPos 250, 10, "<p align=""left"">Savoir Beds Limited<br>1 Old Oak Lane<br>London<br>NW10 6UD UK<br>United Kingdom</p>"
	PDF.AddTextPos 480, 20, "Container Manifest"
	PDF.SetFont "F1", 8, "#999"
	PDF.AddTextPos 530, 32, "Page " & n & " of " & pagenumber
	PDF.SetFont "F1", 8, "#999"
	PDF.AddHTML commercialordertable
	PDF.AddHTML manifesttablehdr
	PDF.AddHTML amanifesttable(n)
	if n<pagenumber then
	PDF.AddHTML "<table border=0 width=""100%"" cellspacing=""1"" cellpadding=""4""><tr><td align=""right"">TOTAL&nbsp;Cont...</td></tr></table>"
	else
	PDF.AddHTML "<table border=0 width=""100%"" cellspacing=""1"" cellpadding=""4""><tr><td width=""30""></td><td width=""67""></td><td width=""130""></td><td width=""70""><font size=""8"">TOTAL WEIGHTS</td><td width=""40"" align=""left""><font size=""8"">" & totalNW & "</td><td width=""40"" align=""left""><font size=""8"">" & totalGW & "</td><td colspan=""2"" align=""left""><font size=""8"">TOTAL PIECES:&nbsp;" & totalitemcount-1 & "</td></tr></table>"
	end if
	PDF.AddHTMLPos 250, 792, footer
	
next

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
