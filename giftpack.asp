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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, deltime, deliverytrue, mattresspicked, basepicked, topperpicked, valancepicked,  legspicked, headboardpicked, itemcount, tobedelivered, itemqty, accessoriespicked, accessoryqtysum, valencelength, valancewidth, valancedrop, matttable, matttable2, mattqty, mattwidth1, mattwidth2, mattlength1, mattlength2, toptable, topperqty, baseqty, basetable, basewidth1, basewidth2, baselength1, baselength2, eastwest, northsouth, wrappingtype, x, y, mattspecial, userlocation, showmattress, showtopper, showbase, mattressfactory, topperfactory, basefactory, manufacturedatid, basemanufacturedatid, toppermanufacturedatid, bookeddeliverydate, showroomtel, correspondence1, correspondence2, deliveryaddress1, deltrue
deltrue="n"
deliverytrue=false
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

selcted=""
count=0
order=""
submit=""
Set rs = getMysqlQueryRecordSet("Select * from correspondence WHERE correspondenceid=21", con)
correspondence1=rs("correspondence")
correspondence1=left(rs("correspondence"), len(rs("correspondence"))-6)
'response.Write(correspondence1)
'response.End()
correspondence2=rs("correspondence2")
rs.close
set rs=nothing

		
		
sql="Select * from purchase WHERE purchase_no=" & purchase_no & ""
Set rs = getMysqlQueryRecordSet(sql, con)

bookeddeliverydate=rs("bookeddeliverydate")

Set rs2 = getMysqlQueryRecordSet("Select * from location WHERE idlocation=" & rs("idlocation") & "", con)
showroomaddress=rs2("adminheading")
showroomtel=rs2("tel")
showroomtel=replace(showroomtel, "(", "")
showroomtel=replace(showroomtel, ")", "")
showroomtel=replace(showroomtel," ","",1,1)

rs2.close
set rs2=nothing

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

If rs1("title") <> "" Then custname=custname & capitaliseName(lcase(rs1("title"))) & " "
If rs1("surname") <> "" Then custname=custname & capitaliseName(lcase(rs1("surname")))

clienthdg="<font family=""Times-Roman""><font size=""8"">"
clienthdg=clienthdg & "<b>Client: </b><br />"
clienthdg=clienthdg & "<b>Company: </b><br />"
if rs1("company_vat_no")<>"" then clienthdg=clienthdg & "<b>VAT No: </b><br />"
clienthdg=clienthdg & "<b>Home Tel: </b><br />"
clienthdg=clienthdg & "<b>Work Tel: </b><br />"
clienthdg=clienthdg & "<b>Mobile: </b><br />"
clienthdg=clienthdg & "<b>Email: </b><br />"
clienthdg=clienthdg & "<b>Client Ref: </b><br />"
clienthdg=clienthdg & "</font></font>"

clientdetails="<font family=""Times New Roman""><font size=""8"">"
clientdetails=clientdetails & custname & "<br />"
clientdetails=clientdetails & rs2("company") & "<br />"
clientdetails=clientdetails & "</font></font>"

deliveryaddress="<table align=""left"" width=""150""><p><font family=""Times New Roman""><font size=""8"">"
deliveryaddress="<br />" & custname & "<br />"
If rs("deliveryadd1") <> "" then 
deliveryaddress=deliveryaddress & rs("deliveryadd1") & "<br />"
deltrue="y"
end if
If rs("deliveryadd2") <> "" then deliveryaddress=deliveryaddress & rs("deliveryadd2") & "<br />"
If rs("deliveryadd3") <> "" then deliveryaddress=deliveryaddress & rs("deliveryadd3") & "<br />"
If rs("deliverytown") <> "" then deliveryaddress=deliveryaddress & rs("deliverytown") & "<br />"
If rs("deliverycounty") <> "" then deliveryaddress=deliveryaddress & rs("deliverycounty") & "<br />"
If rs("deliverypostcode") <> "" then deliveryaddress=deliveryaddress & rs("deliverypostcode") & "<br />"
If rs("deliverycountry") <> "" then deliveryaddress=deliveryaddress & rs("deliverycountry")
deliveryaddress=Utf8ToUnicode(deliveryaddress) & "</font></p></table>"

custaddress="<table align=""left"" width=""150""><p><font family=""Times New Roman""><font size=""8"">"
custaddress="<br />" & custname & "<br />"
If rs2("street1")<>"" then custaddress=custaddress & rs2("street1") & "<br />"
If rs2("street2")<>"" then custaddress=custaddress & rs2("street2") & "<br />"
If rs2("street3")<>"" then custaddress=custaddress & rs2("street3") & "<br />"
If rs2("town")<>"" then custaddress=custaddress & rs2("town") & "<br />"
If rs2("county")<>"" then custaddress=custaddress & rs2("county") & "<br />"
If rs2("postcode")<>"" then custaddress=custaddress & rs2("postcode") & "<br />"
If rs2("country")<>"" then custaddress=custaddress & rs2("country")
custaddress=Utf8ToUnicode(custaddress) & "</font></p></table>"
if deltrue="y" then
else
	deliveryaddress=custaddress
end if


Dim letter
letter="<p>" & WeekdayName(Weekday(bookeddeliverydate)) & " " & FormatDateTime(bookeddeliverydate,1) & "</p>"
letter=letter & "<font family=""Times New Roman""><p>&nbsp;</p><p>&nbsp;</p></font>"
letter=letter & correspondence1 & " " & Utf8ToUnicode(showroomaddress) & " showroom on " & showroomtel & ". " & correspondence2

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
PDF.SetMargins 50,55,50,55



PDF.SetProperty csPropTextAlign, algCenter
YPos = int(PDF.GetProperty(csPropPosY))
PDF.SetPos 20, YPos - 25
PDF.AddFont"F9", "Times-Roman", "WinAnsi", fsNone, 0 
PDF.SetProperty csPropParLeft, "60"
PDF.SetProperty csPropPosX, "40"
PDF.SetProperty csHTML_FontName, "F9"
PDF.SetProperty csHTML_FontSize, "8"
PDF.SetProperty csPropTextColor,"#999"
PDF.SetProperty csPropTextAlign, "0"
PDF.SetProperty csPropAddTextWidth, 1
PDF.SetFont "F15", 12, "#999"
PDF.SetProperty csPropTextFont, "F9"

PDF.AddHTMLPos 93, 160, deliveryaddress & letter
'PDF.AddHTMLPos 93, 290, letter

PDF.BinaryWrite
set pdf = nothing
rs1.close
rs.close
rs2.close
set rs1=nothing
set rs=nothing
set rs2=nothing

sql="Select * from purchase WHERE purchase_no=" & purchase_no & ""
Set rs = getMysqlUpdateRecordSet(sql, con)
rs("giftpackrequired")="y"
rs.Update
rs.close
set rs=nothing

sql="select * from orderaccessory where description='Delivery Gift Pack' and purchase_no=" & purchase_no
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if rs.eof then
			sql="select * from orderaccessory"
			Set rs = getMysqlUpdateRecordSet(sql, con)
			rs.AddNew
			rs("purchase_no")=purchase_no
			rs("description")="Delivery Gift Pack"
			rs("qty")=1
			rs("status")=70
			rs("delivered")=bookeddeliverydate
			rs.Update
		else
			rs("purchase_no")=purchase_no
			rs("description")="Delivery Gift Pack"
			rs("qty")=1
			rs("status")=70
			rs("delivered")=bookeddeliverydate
			rs.Update
		end if
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
