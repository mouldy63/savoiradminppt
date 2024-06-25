<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="component-price-funcs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="pricematrixfuncs.asp" -->
<%
Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, dateasc, orderasc, customerasc, coasc, datefrom, datefromstr, datetostr, dateto, dateto1, user, rs2, rs3, receiptasc, amttotal, currencysym, ordervaltotal, totalpayments, totalos, location, payasc, matt1TOTAL, matt2TOTAL, matt3TOTAL, matt4TOTAL, mattFrenchTOTAL, mattStateTOTAL, base1TOTAL, base2TOTAL, base3TOTAL, base4TOTAL, basePegTOTAL, basePlatTOTAL, baseSlimTOTAL, baseStateTOTAL, cwtopperTOTAL, hcatopperTOTAL, hwtopperTOTAL, cwtopperonlyTOTAL, hcatopperonlyTOTAL, hwtopperonlyTOTAL, legsTOTAL, hbTOTAL, hide, locationname, recno, sql1, sql2, excelLine, excelLine2, itemtype, totalorder, totalorderUSD, totalorderGBP, totalorderEUR, exworksdate, wholesale, nonWholesale, nonWholesaleGBP, nonWholesaleUSD, nonWholesaleEUR, discount, discountGBP, discountUSD, discountEUR,upholsteredbase, basewholesale, basenonWholesale, basenonWholesaleGBP, basenonWholesaleUSD, basenonWholesaleEUR, wholesaleholder, salesother, salesotherGBP, salesotherUSD, salesotherEUR, legswholesale, legprice, legqtytotal, wholesalelegPrice, legqty
Session.LCID = 2057
Dim stryear, strmonth
dim exWorksRevenue, price
dim wholesaleprice, cheapertopperM, cheapertopperB

stryear=year(cdate(request("datefrom")))
strmonth=month(cdate(request("datefrom")))

Set Con = getMysqlConnection()

sql="Select * FROM qc_history_latest Q, purchase P, address A, contact C, Location L, Component X where (P.cancelled is Null or P.cancelled='n') and P.code<>15919  AND C.retire='n' AND P.orderonhold<>'y' AND C.contact_no<>319256 AND C.contact_no<>24188 AND A.code=C.code AND C.contact_no=P.contact_no and P.idlocation=L.idlocation and Q.purchase_no=P.purchase_no and Q.componentid in (1, 3, 5, 7, 8, 0) and X.componentid=Q.componentid and Month(production_completion_date)=" & strmonth & " AND YEAR(production_completion_date)=" & stryear & " order by order_number, Q.componentid desc"
'set bom to utf-8
Call Response.BinaryWrite(ChrB(239) & ChrB(187) & ChrB(191))
	

Dim filesys, tempfile, tempfolder, tempname, filename, objStream
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Wholesale Price Report")
tempfile.WriteLine("Date: " & strmonth & "/" & stryear)
tempfile.WriteLine("Date,Production Completion Date,Order No.,Surname,Company,Showroom,Price List,Item,Order Total Ex VAT from Order Form in sales GBP,Order Total Ex VAT from Order Form in sales USD,Order Total Ex VAT from Order Form in sales EUR,Price of item in £ Wholesale (from price matrix),Price of Items not on matrix Ex VAT Retail Prices in sales GBP,Price of Items not on matrix Ex VAT Retail Prices in sales USD,Price of Items not on matrix Ex VAT Retail Prices in sales EUR,Discount (from order) in order GBP,Discount (from order) in order USD,Discount (from order) in order EUR,Delivery Date,Ex-Works Date,Other non-matrix items (fabric/accessories/delivery etc) ex vat in sales order currency GBP,Other non-matrix items (fabric/accessories/delivery etc) ex vat in sales order currency USD,Other non-matrix items (fabric/accessories/delivery etc) ex vat in sales order currency EUR")
Set rs = getMysqlQueryRecordSet(sql, con)
if not rs.eof then
	Do until rs.eof
	itemtype=""
	totalorder=0
	totalorderGBP=null
	totalorderUSD=null
	totalorderEUR=null
	cheapertopperM=""
	cheapertopperB=""
	discountGBP=NULL
	discountUSD=NULL
	discountEUR=NULL
	upholsteredbase=""
	basewholesale=""
	basenonWholesale=""
	wholesaleholder=""
	nonWholesaleGBP=Null
	nonWholesaleUSD=Null
	nonWholesaleEUR=Null
	basenonWholesaleGBP=Null
	basenonWholesaleUSD=Null
	basenonWholesaleEUR=Null
	salesother=0
	salesotherGBP=NULL
	salesotherUSD=NULL
	salesotherEUR=NULL
	legswholesale=Null
	legprice=Null
	exworksdate=Null
	legqty=0
	wholesalelegPrice=Null
	if rs("discount")<>"" and rs("discount")<>"0" and Not isNull(rs("discount")) then
		if rs("discounttype")="percent" then
			discount=CDbl(rs("discount"))/100 * CDbl(rs("bedsettotal"))
			if rs("isTrade")<>"y" then discount=discount/(1 + CDbl(rs("VATrate"))/100)
			if rs("ordercurrency")="GBP" then 
				discountGBP=discount
				discountGBP=FormatNumber(discountGBP,2)
			end if
			if rs("ordercurrency")="USD" then 
				discountUSD=discount
				discountUSD=FormatNumber(discountUSD,2)
			end if
			if rs("ordercurrency")="EUR" then 
				discountEUR=discount
				discountEUR=FormatNumber(discountEUR,2)
				end if
		else
			discount=CDBL(rs("discount"))
			if rs("isTrade")<>"y" then discount=discount/(1 + CDbl(rs("VATrate"))/100)
			if rs("ordercurrency")="GBP" then
			discountGBP=FormatNumber(discount,2)
			end if
			if rs("ordercurrency")="USD" then
			discountUSD=FormatNumber(discount,2)
			end if
			if rs("ordercurrency")="EUR" then
			discountEUR=FormatNumber(discount,2)
			end if
		end if
	else
	discount=""
	end if
	if rs("tradediscount")<>"" and rs("tradediscount")<>"0.00" then 
		discount=CDbl(rs("tradediscount"))
		if rs("ordercurrency")="GBP" then
			discountGBP=FormatNumber(discount,2)
			end if
			if rs("ordercurrency")="USD" then
			discountUSD=FormatNumber(discount,2)
			end if
			if rs("ordercurrency")="EUR" then
			discountEUR=FormatNumber(discount,2)
			end if
		discount=""
	end if
	if rs("componentid")=1 then 
	itemtype=rs("savoirmodel")
	wholesale=getMatrixPrice(con, exWorksRevenue, wholesalePrice, "1", rs("savoirmodel"), rs("mattresswidth"), rs("mattresslength"), "", "GBP", "", "")
		if wholesalePrice=-1 then
		nonWholesale=getComponentPriceXVat(con, 1, rs("purchase_no"))
		wholesalePrice=""
		else
		cheapertopperM="1"
		nonWholesale=""
		wholesaleholder="£" & wholesalePrice
		end if
	end if
	if rs("componentid")=3 then 
	if rs("basefabricprice")<>"" and not isNull(rs("basefabricprice")) then salesother=salesother+CDbl(rs("basefabricprice"))
	itemtype=rs("basesavoirmodel")
	wholesale=getMatrixPrice(con, exWorksRevenue, wholesalePrice, "3", rs("basesavoirmodel"), rs("basewidth"), rs("baselength"), "", "GBP", "", "")
		if wholesalePrice=-1 then
		wholesalePrice=""
		nonWholesale=getComponentPriceXVat(con, 3, rs("purchase_no"))
		else
		cheapertopperB="3"
		nonWholesale=""
		wholesaleholder="£" & wholesalePrice
		end if
		if left(rs("upholsteredbase"),3)="Yes" then
		upholsteredbase="y"
			if wholesalePrice<>"" then
			wholesale=getMatrixPrice(con, exWorksRevenue, wholesalePrice, "12", "Base Upholstery", "", "", "", "GBP", "", "")
			basewholesale = wholesalePrice
			else
			basenonWholesale=rs("upholsteryprice")
				if basenonWholesale<>"0" then
					if rs("isTrade")<>"y" then
						basenonWholesale=CDbl(basenonWholesale)/(1 + CDbl(rs("vatrate"))/100)
					end if
					basenonWholesale=FormatNumber(CDbl(basenonWholesale),2)
				end if
			end if
		end if
	end if
	
	if rs("componentid")=5 then 
	itemtype=rs("toppertype")
		wholesale=getMatrixPrice(con, exWorksRevenue, wholesalePrice, "5", rs("toppertype"), rs("topperwidth"), rs("topperlength"), "", "GBP", cheapertopperB, cheapertopperM)
		if wholesalePrice = -1 then
		wholesalePrice=""
		nonWholesale=getComponentPriceXVat(con, 5, rs("purchase_no"))
		else
		wholesaleholder="£" & wholesalePrice
		nonWholesale=""
		end if
	end if
	
	if rs("componentid")=7 then 
	itemtype=rs("legstyle")
	wholesale=getMatrixPrice(con, exWorksRevenue, wholesalePrice, "7", rs("legstyle"), "", "", "", "GBP", "", "")
		if wholesalePrice = -1 then
		wholesalePrice=""
		nonWholesale=getComponentPriceXVat(con, 7, rs("purchase_no"))
		else
		if rs("legqty")<>"" and not isNull(rs("legqty")) then legqtytotal=CDbl(rs("legqty"))
		if rs("addlegqty")<>"" and not isNull(rs("addlegqty")) then legqtytotal=legqtytotal+CDbl(rs("addlegqty"))
		if legqtytotal<>0 then wholesalelegPrice=wholesalePrice * legqtytotal
		wholesaleholder="£" & wholesalelegPrice
		nonWholesale=""
		end if
	end if
	
	if rs("componentid")=8 then 
	itemtype=rs("headboardstyle")
	if rs("hbfabricprice")<>"" and not isNull(rs("hbfabricprice")) then salesother=salesother+CDbl(rs("hbfabricprice"))
	wholesale=getMatrixPrice(con, exWorksRevenue, wholesalePrice, "8", rs("headboardstyle"), "", "", "", "GBP", "", "")
		if wholesalePrice = -1 then
		wholesalePrice=""
		nonWholesale=getComponentPriceXVat(con, 8, rs("purchase_no"))
		else
		wholesaleholder="£" & wholesalePrice
		nonWholesale=""
		end if
	end if
	if rs("componentid")<>0 then
	if nonWholesale<>"" then nonWholesale= FormatNumber(nonWholesale,2)
	end if
	totalorder=FormatNumber(rs("totalexvat"),2)
	if rs("ordercurrency")="GBP" then 
		totalorderGBP=totalorder
		if nonWholesale<>"" then nonWholesaleGBP=nonWholesale
		if basenonWholesale<>"" then basenonWholesaleGBP=basenonWholesale
	end if
	if rs("ordercurrency")="USD" then 
		totalorderUSD=totalorder
		if nonWholesale<>"" then nonWholesaleUSD=nonWholesale
		if basenonWholesale<>"" then basenonWholesaleUSD=basenonWholesale
	end if
	if rs("ordercurrency")="EUR" then 
		totalorderEUR=totalorder
		if nonWholesale<>"" then nonWholesaleEUR=nonWholesale
		if basenonWholesale<>"" then basenonWholesaleEUR=basenonWholesale
	end if
	exworksdate=getExportDate(con, rs("componentid"), rs("purchase_no"))
	if rs("deliverycharge")="y" then
		if rs("deliveryprice")<>"" and not isNull(rs("deliveryprice")) then salesother=salesother+CDbl(rs("deliveryprice"))
	end if
	if rs("accessoriesrequired")="y" then
		if rs("accessoriestotalcost")<>"" and (rs("accessoriestotalcost")<>"0.00" and not isNull(rs("accessoriestotalcost"))) then salesother=salesother+CDbl(rs("accessoriestotalcost"))
	end if
	'if rs("legsrequired")="y" then
	'	legswholesale=getMatrixPrice(con, exWorksRevenue, wholesalePrice, "7", rs("legstyle"), "", "", "", "GBP", "", "")
	'	if legswholesale<>-1 and (rs("legprice")<>"0.00" and Not IsNull(rs("legprice"))) then salesother=salesother+CDbl(rs("legprice"))
	'end if
	if salesother>0 then
	    if rs("isTrade")<>"y" then salesother=salesother/(1 + CDbl(rs("VATrate"))/100)
		if rs("ordercurrency")="GBP" then
			salesotherGBP=getCurrencySymbolForCurrencyNonHtml(rs("orderCurrency")) & FormatNumber(salesother,2)
		end if
		if rs("ordercurrency")="USD" then
			salesotherUSD=FormatNumber(salesother,2)
		end if
		if rs("ordercurrency")="EUR" then
			salesotherEUR=getCurrencySymbolForCurrencyNonHtml(rs("orderCurrency")) & FormatNumber(salesother,2)
		end if
	end if
	
	
if rs("componentid")<>0 then 
	if upholsteredbase="y" then
	excelLine2="""" & rs("order_date") & """,""" & rs("production_completion_date") & """,""" & rs("order_number") & """,""" & rs("surname") & """,""" & rs("company") & """,""" & rs("adminheading") & """,""" & rs("price_list") & """,""" & itemtype & " - " & "Base - Upholstery" & """,""" & "" & """,""" & "" & """,""" & "" & """,""" & basewholesale & """,""" & basenonWholesaleGBP & """,""" & basenonWholesaleUSD & """,""" & basenonWholesaleEUR & """,""" & "" & """,""" & "" & """,""" & "" & """,""" & rs("bookeddeliverydate") & """,""" & exworksdate & """"
	end if

	excelLine="""" & rs("order_date") & """,""" & rs("production_completion_date") & """,""" & rs("order_number") & """,""" & rs("surname") & """,""" & rs("company") & """,""" & rs("adminheading") & """,""" & rs("price_list") & """,""" & itemtype & " - " & rs("component") & """,""" & "" & """,""" & "" & """,""" & "" & """,""" & wholesaleholder & """,""" & nonWholesaleGBP & """,""" & nonWholesaleUSD & """,""" & nonWholesaleEUR & """,""" & "" & """,""" & "" & """,""" & "" & """,""" & rs("bookeddeliverydate") & """,""" & exworksdate & """"
else
	excelLine="""" & rs("order_date") & """,""" & rs("production_completion_date") & """,""" & rs("order_number") & """,""" & rs("surname") & """,""" & rs("company") & """,""" & rs("adminheading") & """,""" & rs("price_list") & """,""" & "Order Total" & """,""" & totalorderGBP & """,""" & totalorderUSD & """,""" & totalorderEUR & """,""" & wholesaleholder & """,""" & "" & """,""" & "" & """,""" & "" & """,""" & discountGBP & """,""" & discountUSD & """,""" & discountEUR & """,""" & rs("bookeddeliverydate") & """,""" & "" & """,""" & salesotherGBP & """,""" & salesotherUSD & """,""" & salesotherEUR & """"

end if

tempfile.WriteLine(excelLine)
if upholsteredbase="y" then
tempfile.WriteLine(excelLine2)
end if

	rs.movenext
	loop
end if
rs.close
set rs=nothing

tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""wholesale-price-report.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing



Con.Close
Set Con = Nothing%>  
