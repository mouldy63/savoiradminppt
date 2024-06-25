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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, deltime, deliverytrue, mattresspicked, basepicked, topperpicked, valancepicked,  legspicked, headboardpicked, itemcount, tobedelivered, itemqty, accessoriespicked, accessoryqtysum, valencelength, valancewidth, valancedrop, matttable, matttable2, mattqty, mattwidth1, mattwidth2, mattlength1, mattlength2, toptable, topperqty, baseqty, basetable, basewidth1, basewidth2, baselength1, baselength2, eastwest, northsouth, wrappingtype, x, y, mattspecial, userlocation, showmattress, showtopper, showbase, mattressfactory, topperfactory, basefactory, manufacturedatid, basemanufacturedatid, toppermanufacturedatid, bookeddeliverydate, showroomtel, correspondence1, correspondence2, deliveryaddress1, deltrue, sageref, invno, prodtable, basefabricmeters, baseuph, addlegqty, hbfabricunitcost, accunitprice
dim componentarray(), dimensionsarray(), tarrifarray(), weightarray(), cubicmetersarray()
dim m1width, m2width, m1length, m2length
dim weight, tarrifcode, depth, weightcalc
dim sizes, valancesize, hblegs, cid, showroomadd, invoicetotal, accprice, showroomnotes, invoicenotecount, paymentterms, bankdetails, paymentduedate, invdate, valfabricprice, valfabriccost, winvoiceno, winvoicedate
Dim legqty, showroomname, basetrim, basedrawers, base1width, basewidthstring, base1length, base2width, base2length, customername, contactno
contactno=""
customername=""
purchase_no=request("pn")
winvoiceno=request("winvoiceno")
winvoicedate=request("winvoicedate")
invoicenotecount=1
invoicetotal=0
cid=request("cid")
hblegs=""
dim componentpricearray()
prodtable=""
invno=request("winvoiceno")
sageref=" "
deltrue="n"
deliverytrue=false
showmattress="n"
showtopper="n"
showbase="n"
itemcount=0
count=0
purchase_no=request("pn")
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



sql="Select * from wholesale_invoices where purchase_no=" & purchase_no

  Set rs = getMysqlUpdateRecordSet(sql, con)
  if rs.eof then
  	rs.AddNew
	rs("purchase_no")=purchase_no
  end if
    rs("wholesale_inv_no")=winvoiceno
	rs("wholesale_inv_date")=winvoicedate
   rs.update


rs.close
set rs = nothing


sql="Select * from region WHERE id_region=" & localeref

	
Set rs = getMysqlUpdateRecordSet(sql, con)

Session.LCID = rs("locale")
rs.close
set rs=nothing

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

sql="SELECT * from purchase where purchase_no=" & purchase_no

Set rs = getMysqlQueryRecordSet(sql, con)

if not rs.eof then
customerno=rs("contact_no")
sql="SELECT * from savoir_user S, location L where S.id_location=L.idlocation and S.username like '" & rs("salesusername") & "'"
Set rs1 = getMysqlQueryRecordSet(sql, con)
if not rs1.eof then
showroomname=rs1("adminheading")
end if
rs1.close
set rs1=nothing

sql="SELECT * from contact where contact_no=" & customerno

Set rs1 = getMysqlQueryRecordSet(sql, con)
if not rs1.eof then
customername=rs1("surname")
end if
rs1.close
set rs1=nothing

invdate=request("winvoicedate")
showroomadd=rs("idlocation")

orderCurrency = rs("ordercurrency")
if orderCurrency="GBP" then ordercurrency="&pound;"
if orderCurrency="USD" then ordercurrency="&#36;"
if orderCurrency="EUR" then ordercurrency="&#8364;"

prodtable="<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""1"">"
prodtable=prodtable & "<font size=""8px""><tr><td width=""40%""><b>Bed Model</b></td><td width=""18%""><b>Size</b></td><td align=""center""><b>Quantity</b></td><td align=""right""><b>Unit Price/" & rs("ordercurrency") & " " & ordercurrency & "</b></td><td align=""right""><b>Price/" & rs("ordercurrency") & " " & ordercurrency & "</b></td></tr>"

	if rs("mattressrequired")="y" then
	mattressprice=0.00
	mattressprice=getComponentWholesalePrice(con, 1, rs("purchase_no"))
	mattressprice=FormatNumber(mattressprice,2)
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
		prodtable=prodtable & "</td><td>" & mattwidthstring & "</td><td align=""center"">1</td><td align=""right"">" & formatnumber(mattressprice,2) & "</td><td align=""right"">" & formatnumber(mattressprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(mattressprice)
	end if
	if rs("topperrequired")="y" then
		if topper1width<>"" then topperwidthstring= topper1width & " x "
		if topper1width="" then topperwidthstring= rs("topperwidth") & " x "
		if topper1length<>"" then topperwidthstring=topperwidthstring & topper1length & "cm"
		if topper1length="" then topperwidthstring=topperwidthstring & rs("topperlength") & ""
		topperprice=getComponentWholesalePrice(con, 5, rs("purchase_no")) 'topper
		prodtable=prodtable & "<tr><td>" & rs("toppertype")
		if rs("toppertickingoptions")<>"n" then prodtable=prodtable & "<br />" & rs("toppertickingoptions")
		prodtable=prodtable & "</td><td>" & topperwidthstring & "</td><td align=""center"">1</td><td align=""right"">" & formatnumber(topperprice,2) & "</td><td align=""right"">" & formatnumber(topperprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(topperprice)
	end if
	if rs("legsrequired")="y" then
		Dim legindividualprice, supportlegindividualprice
		legindividualprice=getComponentWholesalePrice(con, 7, rs("purchase_no")) 'legs
		supportlegindividualprice=getComponentWholesalePrice(con, 16, rs("purchase_no")) 'addlegs
		if rs("legqty")<>"" and NOT ISNULL(rs("legqty")) then legqty=rs("legqty") else legqty=0
		if rs("addlegqty")<>"" and NOT ISNULL(rs("addlegqty")) then addlegqty=rs("addlegqty") else addlegqty=0
		if CDbl(legindividualprice)=0 then legprice=0
		if Cdbl(legqty)=0 and CDbl(legindividualprice)>0 then legprice=CDbl(legindividualprice)
		if Cdbl(legqty)>0 and CDbl(legindividualprice)>0 then legprice=CDbl(legindividualprice)*CDbl(legqty)
		
		if CDbl(supportlegindividualprice)=0 then xtralegs=0
		if Cdbl(addlegqty)=0 and CDbl(supportlegindividualprice)>0 then xtralegs=CDbl(supportlegindividualprice)
		if Cdbl(addlegqty)>0 and CDbl(supportlegindividualprice)>0 then xtralegs=CDbl(supportlegindividualprice)*CDbl(addlegqty)
		prodtable=prodtable & "<tr><td>" & rs("legstyle") & " Legs<br />" & rs("legfinish") & "</td><td>" & rs("legheight") & "</td><td align=""center"">" & legqty & "</td><td align=""right"">" & formatnumber(legindividualprice,2) & "</td><td align=""right"">" & formatnumber(legprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(legprice)
		if addlegqty<>0 then
		prodtable=prodtable & "<tr><td>" & rs("addlegstyle") & " Support Legs<br />" & rs("addlegfinish") & "</td><td>&nbsp;</td><td align=""center"">" & addlegqty & "</td><td align=""right"">" & formatnumber(supportlegindividualprice,2) & "</td><td align=""right"">" & formatnumber(xtralegs,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(xtralegs)
		end if
	end if
	if rs("baserequired")="y" then
		baseprice=0.00
		baseprice=getComponentWholesalePrice(con, 3, rs("purchase_no")) 'base
		
		if base1width<>"" then basewidthstring= base1width & " x "
		if base1width<>"" then basewidthstring= base1width & " x "
		if base1width="" then basewidthstring= rs("basewidth") & " x "
		if base1length<>"" then basewidthstring=basewidthstring & base1length & "cm "
		if base1length="" then basewidthstring=basewidthstring & rs("baselength") & " "
		if base2width<>"" then basewidthstring=basewidthstring & base2width & " x "
		if base2length<>"" then basewidthstring=basewidthstring & base2length & "cm"
		prodtable=prodtable & "<tr><td>" & rs("basesavoirmodel") & " Base"
		if rs("basetickingoptions")<>"n" then prodtable=prodtable & ", " & rs("basetickingoptions")
		if rs("basetype")<>"n" AND NOT ISNULL(rs("basetype")) then prodtable=prodtable & ", " & rs("basetype")
		prodtable=prodtable & "</td><td>" & basewidthstring & "</td><td align=""center"">1</td><td align=""right"">" & FormatNumber(baseprice,2) & "</td><td align=""right"">" & FormatNumber(baseprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(baseprice)
		
		if left(rs("upholsteredbase"),3) = "Yes" then
			baseuph=CDbl(getComponentWholesalePrice(con, 12, rs("purchase_no")))
			prodtable=prodtable & "<tr><td>Upholstered Base<br />"
			prodtable=prodtable & "</td><td>&nbsp;</td><td align=""center"">1</td><td align=""right"">" & FormatNumber(baseuph,2) & "</td><td align=""right"">" & FormatNumber(baseuph,2) & "</td></tr>"
			invoicetotal=invoicetotal + baseuph
		end if
		if rs("basetrim") <> "n" and Not IsNull(rs("basetrim")) then
			basetrim=CDbl(getComponentWholesalePrice(con, 11, rs("purchase_no")))
			prodtable=prodtable & "<tr><td>Base Trim<br />"
			prodtable=prodtable & "</td><td>&nbsp;</td><td align=""center"">1</td><td align=""right"">" & FormatNumber(basetrim,2) & "</td><td align=""right"">" & FormatNumber(basetrim,2) & "</td></tr>"
			invoicetotal=invoicetotal + basetrim
		end if
		
		if rs("basedrawers") = "Yes" then
			basedrawers=CDbl(getComponentWholesalePrice(con, 13, rs("purchase_no")))
			prodtable=prodtable & "<tr><td>Base Drawers<br />"
			prodtable=prodtable & "</td><td>&nbsp;</td><td align=""center"">1</td><td align=""right"">" & FormatNumber(basedrawers,2) & "</td><td align=""right"">" & FormatNumber(basedrawers,2) & "</td></tr>"
			invoicetotal=invoicetotal + basetrim
		end if
				
		If left(rs("upholsteredbase"),3) = "Yes" then
		Dim basefabrictotal
		basefabric=CDbl(getComponentWholesalePrice(con, 17, rs("purchase_no"))) 
			prodtable=prodtable & "<tr><td>Base Fabric " & rs("basefabric") & "<br />" & rs("basefabricchoice")
			if rs("basefabricmeters")<>"" then basefabricmeters=CDbl(rs("basefabricmeters"))
			basefabrictotal=basefabricmeters*basefabric
			
			prodtable=prodtable & "</td><td>Meters</td><td align=""center"">" & rs("basefabricmeters") & "</td><td align=""right"">" & FormatNumber(basefabric,2) & "</td><td align=""right"">" & FormatNumber(basefabrictotal,2) & "</td></tr>"
			invoicetotal=invoicetotal + CDbl(basefabrictotal)
		end if
	end if
	if rs("headboardrequired")="y" then
		headboardprice=getComponentWholesalePrice(con, 8, rs("purchase_no")) 'hb
		headboardtrim=getComponentWholesalePrice(con, 10, rs("purchase_no")) 'hb trim
		headboardfabric=getComponentWholesalePrice(con, 15, rs("purchase_no")) 'hb fabric
		'If rs("hbfabricprice")<>"" and   NOT ISNULL(rs("hbfabricprice"))  then headboardprice=CDbl(headboardprice) + CDbl(rs("hbfabricprice"))
		'if rs("headboardlegqty") <>"" and not isNull(rs("headboardlegqty")) and rs("headboardlegqty")<>"n" and rs("headboardlegqty")<>"0" then hblegs="<br />Heaboard Legs:" &  rs("headboardlegqty")
		sizes=""
		sizes=getHbWidth(con, rs("purchase_no"))
		if sizes<>"" then sizes=sizes & "cm wide<br />"
		'sizes=sizes & rs("headboardheight")
		prodtable=prodtable & "<tr><td>" & rs("headboardstyle") & " Headboard</td><td>" & sizes & "</td><td align=""center"">1</td><td align=""right"">" & formatnumber(headboardprice,2) & "</td><td align=""right"">" & formatnumber(headboardprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(headboardprice)
		If rs("hbfabricoptions")<>"" and rs("hbfabricoptions")<>"TBC" and NOT ISNULL(rs("hbfabricoptions")) then
		Dim hbfabrictotalcost
			hbfabrictotalcost=headboardfabric*CDbl(rs("hbfabricmeters"))
			prodtable=prodtable & "<tr><td>Headboard Fabric " & Utf8ToUnicode(rs("headboardfabric")) & "<br />" & Utf8ToUnicode(rs("headboardfabricchoice"))
			prodtable=prodtable & "</td><td>Meters</td><td align=""center"">" & Utf8ToUnicode(rs("hbfabricmeters")) & "</td><td align=""right"">" & FormatNumber(headboardfabric,2) & "</td><td align=""right"">" & FormatNumber(hbfabrictotalcost,2) & "</td></tr>"
			invoicetotal=invoicetotal + hbfabrictotalcost
		end if
		If rs("manhattantrim") <> "" and rs("manhattantrim") <> "--" then
			prodtable=prodtable & "<tr><td>Headboard Trim " & Utf8ToUnicode(rs("manhattantrim"))
			prodtable=prodtable & "</td><td>&nbsp;</td><td align=""center"">1</td><td align=""right"">" & FormatNumber(headboardtrim,2) & "</td><td align=""right"">" & FormatNumber(headboardtrim,2) & "</td></tr>"
			invoicetotal=invoicetotal + headboardtrim
		end if
	end if
	
	if rs("valancerequired")="y" then
	Dim valancefabprice, valancefabmeters, valancefabtotal
		valancefabprice=getComponentWholesalePrice(con, 18, rs("purchase_no"))
		if rs("valfabricmeters")<>"" and  rs("valfabricmeters")<>"0" and Not IsNull(rs("valfabricmeters")) then valancefabmeters=CDbl(rs("valfabricmeters")) else valancefabmeters=0
		valancefabtotal=valancefabprice*valancefabmeters
		valanceprice=getComponentWholesalePrice(con, 6, rs("purchase_no")) 'valance
		if rs("valancedrop")<>"" then valancesize= rs("valancedrop") & " x "
		if rs("valancewidth")<>"" then valancesize=valancesize & rs("valancewidth") & " x "
		if rs("valancelength")<>"" then valancesize=valancesize &  rs("valancelength") & "cm"
		prodtable=prodtable & "<tr><td>Valance</td><td>Size " & valancesize & "</td><td align=""center"">1</td><td align=""right"">" & formatnumber(valanceprice,2) & "</td><td align=""right"">" & formatnumber(valanceprice,2) & "</td></tr>"
		if valancefabprice<>0 then prodtable=prodtable & "<tr><td>Valance Fabric " & rs("valancefabricchoice") & "</td><td>Meters</td><td align=""center"">" & rs("valfabricmeters") & "</td><td align=""right"">" & formatnumber(valancefabprice,2) & "</td><td align=""right"">" & formatnumber(valancefabtotal,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(valanceprice) + Cdbl(valancefabtotal)
	end if
	
	
	if rs("accessoriesrequired")="y" then
		Dim acctotalprice
		sql="SELECT * from orderaccessory where purchase_no=" & purchase_no
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		if not rs1.eof then
			do until rs1.eof
			accprice=0
			accprice=CDbl(rs1("wholesaleprice"))
			acctotalprice=accprice * CDbl(rs1("qty"))
		prodtable=prodtable & "<tr><td>" & Utf8ToUnicode(rs1("description")) & " " & Utf8ToUnicode(rs1("colour")) & " " & Utf8ToUnicode(rs1("design")) & "</td><td>" & Utf8ToUnicode(rs1("size")) & "</td><td align=""center"">" & rs1("qty") & "</td><td align=""right"">" & formatNumber(accprice,2) & "</td><td align=""right"">" & formatNumber(acctotalprice,2) & "</td></tr>"
		invoicetotal=invoicetotal + CDbl(acctotalprice)
			rs1.movenext
			loop
		end if
		rs1.close
		set rs1=nothing
	end if
	prodtable=prodtable & "<tr><td colspan=""5"">&nbsp;</td></tr>"

prodtable=prodtable & "</font></table>"


x=530

sql="Select * from showroomdata WHERE showroomlocationid=" & showroomadd

Set rs2 = getMysqlQueryRecordSet(sql, con)
if rs2("invoiceconame")<>"" then showroomaddress=Utf8ToUnicode(rs2("invoiceconame")) & "<br />"
if rs2("Invoiceadd1")<>"" then showroomaddress= showroomaddress & rs2("Invoiceadd1") & "<br />"
if rs2("Invoiceadd2")<>"" then showroomaddress= showroomaddress & rs2("Invoiceadd2") & "<br />"
if rs2("Invoiceadd3")<>"" then showroomaddress= showroomaddress & rs2("Invoiceadd3") & "<br />"
if rs2("Invoicetown")<>"" then showroomaddress= showroomaddress & rs2("Invoicetown") & "<br />"
if rs2("Invoicecountry")<>"" then showroomaddress= showroomaddress & rs2("Invoicecountry") & "<br />"
if rs2("Invoicepostcode")<>"" then showroomaddress= showroomaddress & rs2("Invoicepostcode")

'if rs2("invoiceconame")<>"" then showroomaddress=Utf8ToUnicode(rs2("invoiceconame")) & "<br />"
'if rs2("Invoiceadd1")<>"" then showroomaddress= showroomaddress & Utf8ToUnicode(rs2("Invoiceadd1")) & "<br />"
'if rs2("Invoiceadd2")<>"" then showroomaddress= showroomaddress & Utf8ToUnicode(rs2("Invoiceadd2")) & "<br />"
'if rs2("Invoiceadd3")<>"" then showroomaddress= showroomaddress & Utf8ToUnicode(rs2("Invoiceadd3")) & "<br />"
'if rs2("Invoicetown")<>"" then showroomaddress= showroomaddress & Utf8ToUnicode(rs2("Invoicetown")) & "<br />"
'if rs2("Invoicecountry")<>"" then showroomaddress= showroomaddress & Utf8ToUnicode(rs2("Invoicecountry")) & "<br />"
'if rs2("Invoicepostcode")<>"" then showroomaddress= showroomaddress & Utf8ToUnicode(rs2("Invoicepostcode"))
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
'PDF.License("$829586222;'David Mildenhall';PDF;1;5-201.516.485.5;0-192.168.0.5")
PDF.License("$810217456;'David Mildenhall';PDF;1;0-31.170.121.214")
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
if rs("customerreference")<>"" then PDF.AddHTMLPos 360, 136, "<font size=""8px"">" & utf8toLatin1(rs("customerreference")) & "</font>"
PDF.AddHTMLPos 311, 146, "<font size=""8px""><b>Customer:</b></font>"
PDF.AddHTMLPos 360, 146, "<font size=""8px"">" & customername & "</font>"
PDF.AddHTMLPos 311, 156, "<font size=""8px""><b>Showroom:</b></font>"
PDF.AddHTMLPos 360, 156, "<font size=""8px"">" & showroomname & "</font>"

PDF.AddHTMLPos 230, 189, "<font size=""12px""><b>WHOLESALE INVOICE</b></font>"
PDF.AddHTMLPos 58, 200, prodtable
vat=0
PDF.AddHTMLPos 380, x, "&nbsp;"
PDF.AddHTML "<table width=""100%"" border=""1"" cellspacing=""0"" cellpadding=""2""><font size=""8px""><tr><td width=""80%"" style=""border-right:none""><font size=""8"">Total Net:</font></td><td align=""right"">" & ordercurrency & formatnumber(invoicetotal,2) & "</td></tr><tr><td>VAT: </td><td align=""right"">" & ordercurrency & formatNumber(vat,2) & "</td></tr><tr><td>Gross Total: </td><td align=""right"">" & ordercurrency & formatnumber(invoicetotal,2) & "</td></tr></table>"


if showroomnotes<>"" then 
PDF.AddHTML "<br><table width=""100%"" border=""0"" cellspacing=""2"" cellpadding=""1""><tr><td width=""80"">Notes:</td><td>" & showroomnotes & "</td></tr></font></table>"
end if
PDF.AddHTML "<br />" & bankdetails
PDF.BinaryWrite
set pdf = nothing
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
