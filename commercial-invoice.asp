<%
Option Explicit
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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, str8, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, ademail, aw, x, str18, baseupholsteryprice
Dim matt1width, matt2width, matt1length, matt2length, base1width, base2width, base1length, base2length, topper1width, topper1length, basewidthstring, mattwidthstring, topperwidthstring, speciallegheight, commercialordertable, commercialordertable2, collectiondate, loc, countryname, shipperid, shipperdetails, overseasterms, items, componentname1, wrap, wraptext, hbwidth,  totalgross, cm3, totalcost, wraptext2, totalexvat, vat, vatrate, invoiceno, legno, contact1, contact2, contact3, hbheight, baseextras, itempackedwith, legprice, wholesale
Dim collectionid, rs4, compTariffcode, components, packedwithCompName, packedwithCompPrice, compQty, compTotal, accCompPartNo, hdg2, YPos, accWholesale, accWholesaleUnit, accWholesaleTotal, wholesaleprices, unitprice, m1height,  wholesaletotal, exportterms
wholesaletotal=0
wholesaleprices="n"
itempackedwith=false 
baseextras=0
cm3=0
wraptext=""
dim componentarray(), dimensionsarray(), tarrifarray(), weightarray(), cubicmetersarray()
dim componentpricearray(), componentpriceextrasarray()
dim m1width, m2width, m1length, m2length
dim weight, tarrifcode, depth, weightcalc
dim boxwidth, boxlength, boxdepth

speciallegheight=""
aw="n"
aw=request("aw")
dim purchase_no, i, paymentSum, payments, n, displayterms, orderCurrency, upholsterysum, deltxt, standaloneBoxAccessoryIds
displayterms=""
quote=Request("quote")
custname=""
msg=""
wholesale="n"
wholesale=Request("wholesale")
localeref=retrieveuserregion()
Set Con = getMysqlConnection()
If retrieveuserregion()=1 then
Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=1", con)
else
Set rs = getMysqlQueryRecordSet("Select * from location where idlocation=" & retrieveuserlocation(), con)
end if
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

Set rs = getMysqlUpdateRecordSet("Select * from savoir_user where user_id=" & retrieveuserid(), con)
ademail=rs("adminemail")
rs.close
set rs=nothing

'purchase_no=Request("val")
purchase_no=CDbl(Request("pno"))
collectionid=CDbl(request("cid"))
loc=CDbl(request("loc"))
shipperid=CDbl(request("sid"))
items=request("items")

'begin section where variables have no data
if loc="" or loc=0 then
		sql="SELECT * from exportLinks L, exportcollshowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & collectionid & " and purchase_no=" & purchase_no
		'response.Write("sql=" & sql)
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		loc=rs1("idlocation")
		rs1.close
		set rs1=nothing
end if
sql="SELECT * from Purchase where purchase_no=" & purchase_no
			Set rs1 = getMysqlQueryRecordSet(sql, con)
			wrap=rs1("wrappingid")
			orderCurrency = rs1("ordercurrency")

			if wrap=3 or wrap=4 then items=0
		    rs1.close
			set rs1=nothing


sql="SELECT * from exportLinks L, exportcollshowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & collectionid & " and purchase_no=" & purchase_no & " and s.idlocation=" & loc	
			Set rs1 = getMysqlQueryRecordSet(sql, con)
			invoiceno=rs1("invoiceNo")
			rs1.close
			set rs1=nothing	
			
'if items="" then
		sql="SELECT * from exportLinks L, exportcollshowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & collectionid & " and purchase_no=" & purchase_no & " and s.idlocation=" & loc
			Set rs1 = getMysqlQueryRecordSet(sql, con)
			invoiceno=rs1("invoiceNo")
			items = 0
			
			do until rs1.eof
				 
				if wrap=3 or wrap=4 then
				sql="Select * from packagingdata where (packedwith='' or packedwith='0' or packedwith is Null) and purchase_no=" & purchase_no & " and componentID=" & rs1("componentID")
						Set rs4 = getMysqlQueryRecordSet(sql, con)						
						if NOT rs4.eof then
						do until rs4.eof
							if rs4("boxqty")<>"" and NOT isNull(rs4("boxqty")) then
								items=items + CDbl(rs4("boxqty"))
							else
								items=items+1
							end if
						'response.Write(items & ":items " & rs4("boxqty") & " boxqty<br>")
						
						rs4.movenext
						loop
						end if
						rs4.close
						set rs4=nothing
				end if
				if wrap = 2 then
					if rs1("componentid")=1 then
							sql="Select mattresstype from purchase where purchase_no=" & purchase_no
							Set rs2 = getMysqlQueryRecordSet(sql, con)
							if left(rs2("mattresstype"),3)="Zip" then items=items+1
							rs2.close 
							set rs2=nothing
						end if
						if rs1("componentid")=3 then
							sql="Select basetype from purchase where purchase_no=" & purchase_no
							Set rs2 = getMysqlQueryRecordSet(sql, con)
							if (left(rs2("basetype"),3)="Eas" or left(rs2("basetype"),3)="Nor") then items=items+1
							rs2.close 
							set rs2=nothing
						end if
					sql="Select * from packagingdata where (packedwith='' or packedwith='0' or packedwith is Null) and purchase_no=" & purchase_no & " and componentID=" & rs1("componentID")
					
					Set rs4 = getMysqlQueryRecordSet(sql, con)
					if NOT rs4.eof then
						if CInt(rs1("componentid"))=9 then
						
							items=items+CInt(rs4.recordcount)-1
							
						end if
					end if
					rs4.close
					set rs4=nothing						
				end if
				if wrap = 1 then
					if rs1("componentid")=1 then
						sql="Select mattresstype from purchase where purchase_no=" & purchase_no
						Set rs2 = getMysqlQueryRecordSet(sql, con)
						if left(rs2("mattresstype"),3)="Zip" then items=items+1
						rs2.close 
						set rs2=nothing
					end if
					if rs1("componentid")=3 then
						sql="Select basetype from purchase where purchase_no=" & purchase_no
						Set rs2 = getMysqlQueryRecordSet(sql, con)
						if (left(rs2("basetype"),3)="Eas" or left(rs2("basetype"),3)="Nor") then items=items+1
						rs2.close 
						set rs2=nothing
					end if	
				end if
				rs1.movenext
			loop
			if wrap=1 then items=items+CInt(rs1.recordcount)
			if wrap=2 then items=items+CInt(rs1.recordcount)
			
			rs1.close
			set rs1=nothing
		
'end if

sql="SELECT * from exportcollections where exportCollectionsID=" & collectionid
			
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		if rs1("ExportDeliveryTerms")=0 then
		else
			Set rs4 = getMysqlQueryRecordSet("Select * from deliveryterms where deliveryTermsID=" & rs1("ExportDeliveryTerms"), con) 
			if not rs4.eof then
			exportterms=rs4("DeliveryTerms")
			end if
			rs4.close
			set rs4=nothing
		end if
		if exportterms<>"" then
			exportterms=exportterms & "<br>" & rs1("termstext")
			else
			exportterms=rs1("termstext")
		end if
		rs1.close
		set rs1=nothing
		
if shipperid="" then
		sql="SELECT * from exportcollections where exportCollectionsID=" & collectionid
			
		Set rs1 = getMysqlQueryRecordSet(sql, con)
		sid=rs1("shipper_address_id")
		rs1.close
		set rs1=nothing
end if
'end section where variables have no data
selcted=""
count=0
order=""
submit=""

sql = "Select * from productionsizes where purchase_no = " & purchase_no

Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
if rs2("matt1width")<>"" then 
	matt1width=rs2("matt1width")
	hbwidth=matt1width 
	else 
	matt1width=""
end if
if rs2("matt2width")<>"" then 
	matt2width=rs2("matt2width") 
	hbwidth=CDbl(hbwidth)+CDbl(matt2width)
	else 
	matt2width=""
end if
if rs2("matt1length")<>"" then matt1length=rs2("matt1length") else matt1length=""
if rs2("matt2length")<>"" then matt2length=rs2("matt2length") else matt2length=""
if rs2("base1width")<>"" then 
	base1width=rs2("base1width")
	hbwidth=base1width  
	else 
	base1width=""
end if
if rs2("base2width")<>"" then 
	base2width=rs2("base2width") 
	hbwidth=CDbl(hbwidth)+CDbl(base2width) 
	else 
	base2width=""
end if
if rs2("base1length")<>"" then base1length=rs2("base1length") else base1length=""
if rs2("base2length")<>"" then base2length=rs2("base2length") else base2length=""
if rs2("topper1width")<>"" then topper1width=rs2("topper1width") else topper1width=""
if rs2("topper1length")<>"" then topper1length=rs2("topper1length") else topper1length=""
if rs2("legheight")<>"" then speciallegheight=rs2("legheight") else speciallegheight=""
end if
rs2.close
set rs2=nothing

sql="select * from phonenumber where purchase_no=" & purchase_no & " order by seq asc"
Set rs2 = getMysqlQueryRecordSet(sql, con)
If not rs2.eof then
do until rs2.eof
contact1=contact1 & rs2("phonenumbertype") & ": Tel: " & rs2("number") & "<br>"
rs2.movenext
loop
end if
rs2.close
set rs2=nothing

sql = "select l.componentid, P.mattresswidth, P.addlegprice, P.headboardtrimprice, P.istrade, P.mattresslength, P.basewidth, P.valfabricprice, P.hbfabricprice, P.baselength, P.order_number, P.savoirmodel, P.basesavoirmodel, P.upholsteryprice, P.basefabricprice, P.toppertype, P.Headboardstyle, P.headboardheight, P.mattresstype, P.basetype, P.mattressprice, P.baseprice, P.basetrimprice, P.basedrawersprice, P.topperprice, P.topperwidth, P.topperlength, P.valanceprice, P.headboardprice, P.legprice, P.headboardlegqty, P.legsrequired, P.legQty, P.AddLegQty, P.accessoriestotalcost, P.total, P.vat, P.vatrate, P.totalexvat, P.mattressrequired, P.baserequired, P.headboardwidth, P.valancewidth, P.valancelength, P.legheight, P.legfinish, P.wrappingid from exportlinks l, exportcollections e, exportcollshowrooms S, purchase P  where l.purchase_no=" & purchase_no & " and l.linkscollectionid=S.exportCollshowroomsID and S.exportCollectionID=e.exportcollectionsid and P.purchase_no=l.purchase_no and e.exportcollectionsid=" & collectionid & " and S.idlocation=" & loc & " order by l.componentid"
'response.Write(sql)
'response.End()
Set rs = getMysqlQueryRecordSet(sql , con)
'totalcost=rs("total")
'totalexvat=rs("totalexvat")
'vat=rs("vat")
vatrate=rs("vatrate")
orderno=rs("order_number")

Dim packweight, packdimensions, packqty, packagingdata, packweight2, packdimensions2, packqty2, packagingdata2, packcubicmeters1, packcubicmeters2, packtarrifcode, packaccdesc, packaccqty, packaccunitprice, acctotalforitem, baseqty1

packcubicmeters1=0
packcubicmeters2=0
packagingdata=false
packagingdata2=false
packqty=0


'if wrap=2 then
	'Set rs4 = getMysqlQueryRecordSet("Select * from packagingdata where (packedwith='' or packedwith='0' or packedwith is Null) and purchase_no=" & purchase_no, con)
'	if NOT rs4.eof then
'		items=items + CInt(rs4.recordcount)
'	end if
'	rs4.close
	'set rs4=nothing
'end if
'response.Write("items=" & items)
'response.End()



					Do until rs.eof
						%>
						<!-- #include file="commercial-invoice-mattress.asp" -->
						<!-- #include file="commercial-invoice-base.asp" -->
						<!-- #include file="commercial-invoice-topper.asp" -->
						<!-- #include file="commercial-invoice-valance.asp" -->
						<!-- #include file="commercial-invoice-legs.asp" -->
						<!-- #include file="commercial-invoice-headboard.asp" -->
						<!-- #include file="commercial-invoice-accessories.asp" -->
						<%
						rs.movenext
					loop
					rs.close
					set rs=nothing

'response.write("<br>items = " & items)
'response.write("<br>weightarray = " & ubound(weightarray))
'for i= 1 to ubound(weightarray)
'response.write("<br>weightarray = " & weightarray(i))
'next
'response.flush
for i= 1 to items
	if weightarray(i)<>"-" then
totalgross = totalgross + getSumOfValues(weightarray(i))
end if
next

for i= 1 to items
	if cubicmetersarray(i)<>"-" then
cm3=cm3+CDbl(cubicmetersarray(i))

end if
next
cm3=cm3/(100*100*100)
payments = getPaymentsForOrder(purchase_no, con)

if invoiceno="" then
invoiceno="N/a"
end if



Set rs = getMysqlQueryRecordSet("Select * from purchase WHERE purchase_no=" & purchase_no & "", con)
Dim vatcalc
if rs("istrade")="y" then
vat=totalcost*(CDbl(vatrate)/100)
else
vatcalc=totalcost/(1+CDbl(vatrate)/100)
vat=totalcost-vatcalc
end if
wrap=rs("wrappingid")
If rs("deliveryadd1") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd1")) & "<br>"
If rs("deliveryadd2") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd2")) & "<br>"
If rs("deliveryadd3") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd3")) & "<br>"
If rs("deliverytown") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverytown")) & "<br>"
If rs("deliverycounty") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverycounty")) & "<br>"
If rs("deliverypostcode") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverypostcode")) & "<br>"
If rs("deliverycountry") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverycountry"))

Set rs2 = getMysqlQueryRecordSet("Select * from location WHERE idlocation=" & rs("idlocation") & "", con)
If rs2("add1")<>"" then showroomaddress=rs2("add1") & ", "
If rs2("add2")<>"" then showroomaddress=showroomaddress & rs2("add2") & ", "
If rs2("add3")<>"" then showroomaddress=showroomaddress & rs2("add3") & ", "
If rs2("town")<>"" then showroomaddress=showroomaddress & rs2("town") & ", "
If rs2("countystate")<>"" then showroomaddress=showroomaddress & rs2("countystate") & ", "
If rs2("postcode")<>"" then showroomaddress=showroomaddress & rs2("postcode") & ", "
if showroomaddress<>"" then showroomaddress=left(showroomaddress, len(showroomaddress)-2)
showroomaddress=showroomaddress & "<br>"
If rs2("tel")<>"" then showroomaddress=showroomaddress & "Tel: " & rs2("tel")
showroomaddress=showroomaddress & "<br>"
If ademail<>"" then showroomaddress=showroomaddress & "Email: " &ademail
rs2.close
set rs2=nothing
Set rs2 = getMysqlQueryRecordSet("Select * from savoir_user WHERE username like '" & rs("salesusername") & "'", con)
'orderCurrency = rs("ordercurrency")
contact = rs2("name")
rs2.close
set rs2=nothing
Set rs1 = getMysqlQueryRecordSet("Select * from contact WHERE code=" & rs("code") & "", con)
Set rs2 = getMysqlQueryRecordSet("Select * from address WHERE code=" & rs1("code") & "", con)

signature = rs("signature")

If rs1("title") <> "" Then custname=custname & capitalise(lcase(rs1("title"))) & " "
If rs1("first") <> "" Then custname=custname & capitalise(lcase(rs1("first"))) & " "
If rs1("surname") <> "" Then custname=custname & capitalise(lcase(rs1("surname")))
clienthdg="<font family=""Tahoma""><font size=6>"
clienthdg=clienthdg & "Client: <br>"
clienthdg=clienthdg & "Company: <br>"
if rs1("company_vat_no")<>"" then clienthdg=clienthdg & "VAT No: <br>"
clienthdg=clienthdg & "Home Tel: <br>"
clienthdg=clienthdg & "Work Tel: <br>"
clienthdg=clienthdg & "Mobile: <br>"
clienthdg=clienthdg & "Email: <br>"
clienthdg=clienthdg & "Client Ref: <br>"
clienthdg=clienthdg & ""

clientdetails="<font family=""Tahoma""><font size=""9""><b>"
clientdetails=clientdetails & Utf8ToUnicode(custname) & "&nbsp;</b><br></font><font family=""Tahoma""><font size=""8""><b>"
clientdetails=clientdetails & rs2("company") & "&nbsp;<br>"
if rs1("company_vat_no")<>"" then clientdetails=clientdetails & rs1("company_vat_no") & "<br>"
clientdetails=clientdetails & rs2("tel") & "&nbsp;<br>"
clientdetails=clientdetails & rs1("telwork") & "&nbsp;<br>"
clientdetails=clientdetails & rs1("mobile") & "&nbsp;<br>"
clientdetails=clientdetails & rs2("email_address") & "&nbsp;<br>"
clientdetails=clientdetails & rs("customerreference") & "&nbsp;<br>"
clientdetails=clientdetails & ""
if rs2("email_address")<>"" then contact1 = contact1 & "<br><font size=+1>Email: " & rs2("email_address") & "</font>"
if rs1("mobile")<>"" then contact1 = contact1 & "<br>Mobile: " & rs1("mobile")
If rs2("street1")<>"" then custaddress= rs2("street1") & "<br>"
If rs2("street2")<>"" then custaddress=custaddress & rs2("street2") & "<br>"
If rs2("street3")<>"" then custaddress=custaddress & rs2("street3") & "<br>"
If rs2("town")<>"" then custaddress=custaddress & rs2("town") & "<br>"
If rs2("county")<>"" then custaddress=custaddress & rs2("county") & "<br>"
If rs2("postcode")<>"" then custaddress=custaddress & rs2("postcode") & "<br>"
If rs2("country")<>"" then custaddress=custaddress & rs2("country")
s = "<br><br><table cellpadding=""1""> "
s = s & " <tr height=""0""><td colspan=""7"" height=""0""></td></tr>"
s = s & " <tr><td width=""11"" height=""55""></td> "
s = s & " <td width=""54"" valign=""top""><font family=""Tahoma""><font size=""6"">" & clienthdg & "</font></td><td width=""112"" valign=""top""><font family=""Tahoma""><font size=""6"">" & Utf8ToUnicode(clientdetails) & "</font></td><td width=""24""></td><td width=""166""><b><font family=""Tahoma""><font size=""6"">" & Utf8ToUnicode(custaddress) & "</font></b></td><td width=""24""></td><td width=""166""><b><font family=""Tahoma""><font size=""6"">" & deliveryaddress & "</font></b></td> "
s = s & " </tr> "
s = s & " </table> "
If quote="y" then 
hdg="Pricing is subject to change.  This quote is valid for 60 days"
hdg2="Quote for:"
Else
hdg2="Order for:"
End If   
payments = getPaymentsForOrder(purchase_no, con)

Set rs3 = getMysqlQueryRecordSet("select * from orderaccessory where purchase_no=" & purchase_no & " order by orderaccessory_id", con)
xacc="<table><tr><td width=""10"" height=""20""></td><td>Item&nbsp;Description</td><td>Design</td><td>Colour</td><td>Size</td><td align=""right"">Qty</td><td align=""right"">Unit&nbsp;Price</td><td align=""right"">Total</td></tr>"
if not rs3.eof then
 do until rs3.eof
xacc=xacc & "<tr ><td width=""10"" height=""20""></td>"
xacc=xacc & "<td width=""150""><b>" & rs3("description") & "</b></td>"
xacc=xacc & "<td width=""100""><b>" & rs3("design") & "</b></td>"
xacc=xacc & "<td width=""80""><b>" & rs3("colour") & "</b></td>"
xacc=xacc & "<td width=""80""><b>" & rs3("size") & "</b></td>"
xacc=xacc & "<td width=""40"" align=""right""><b>" & rs3("qty") & "</b></td>"
xacc=xacc & "<td width=""50"" align=""right""><b>" & fmtCurr2(rs3("unitprice"), true, rs("ordercurrency")) & "</b></td>"
if (rs3("unitprice")<>"" and CDbl(rs3("unitprice"))>0.0) then accesscost=rs3("qty")*CDbl(rs3("unitprice")) else accesscost=0
xacc=xacc & "<td width=""40"" align=""right""><b>" & fmtCurr2(accesscost, true, rs("ordercurrency")) & "</b></td>"
xacc=xacc & "</tr>"
xacc=xacc & "<tr><td></td><td colspan=""7""><hr style=""color:#cccccc;""></td></tr>"
accesscost=0   
	rs3.movenext
	loop
end if
rs3.close
set rs3 = nothing
	
xacc=xacc & "</table>"
sql = "Select * from exportcollections where  exportCollectionsID= " & collectionid
set rs3 = getMysqlQueryRecordSet(sql, con)
collectiondate=rs3("collectiondate")
countryname=rs3("destinationport")
rs3.close
set rs3=nothing

sql = "Select * from shipper_address where  shipper_Address_Id= " & shipperid
set rs3 = getMysqlQueryRecordSet(sql, con)
if not rs3.eof then
if rs3("contact")<>"" then shipperdetails=rs3("contact") & " - "
if rs3("shippername")<>"" then shipperdetails=shipperdetails & rs3("shippername") & " "
if rs3("phone")<>"" then shipperdetails=shipperdetails & rs3("phone") & " "
end if
rs3.close
set rs3=nothing
if rs("overseasduty")<>"" then
sql = "Select * from overseas_duty where overseas_dutyID=" & rs("overseasduty")
set rs3 = getMysqlQueryRecordSet(sql, con)
if not rs3.eof then
overseasterms=rs3("terms")
else
overseasterms="-"
end if
rs3.close
set rs3=nothing
end if

sql = "Select * from region R, location L where L.idlocation = " & loc & " and L.owning_region=R.id_region"

set rs3 = getMysqlQueryRecordSet(sql, con)
'countryname=rs3("country")
rs3.close
set rs3=nothing

if wrap <> "" then
sql = "Select CommercialText from WrappingTypes where wrappingid = " & wrap
set rs3 = getMysqlQueryRecordSet(sql, con)
wraptext=rs3("commercialText")
if wrap=1 then wraptext2="Piece"
if wrap=2 then wraptext2="Piece"
if wrap=3 then wraptext2="Box"
if wrap=4 then wraptext2="Crate"
rs3.close
set rs3=nothing
end if

sql = "Select * from exportlinks where purchase_no = " & purchase_no & " and linkscollectionid= " & collectionid
set rs3 = getMysqlQueryRecordSet(sql, con)
rs3.close
set rs3=nothing
commercialordertable="<table border=""1"" BORDERCOLOR=""#cccccc"" width=""100%"" cellspacing=""0"" cellpadding=""3""><tr><td colspan=""2""><font family=""Tahoma""><font size=""8"">Seller:<br>Savoir Beds Limited<br>1 Old Oak Lane<br>London NW10 6UD<br>UK</td><td><font family=""Tahoma""><font size=""8"">Date: " & collectiondate & "<br><br>Invoice No. C.INV-" & rs("order_number") & "</font></td><td colspan=""2""><font family=""Tahoma""><font size=""8"">Customer's Order No. " & rs("order_number") & "<br><br>Other References:<br>" & Utf8ToUnicode(rs("customerreference")) & "</td></tr><tr><td colspan=""2""><font family=""Tahoma""><font size=""8"">Consignee:<br>" & deliveryaddress & "<br>" & contact1 & "<br>Contact Name: " & rs("deliverycontact") & "<br></td><td colspan=""3""><font family=""Tahoma""><font size=""8"">Buyer:<br>" & Utf8ToUnicode(custaddress) & "</td></tr>"
commercialordertable=commercialordertable & "<tr><td><font family=""Tahoma""><font size=""8"">Country of Origin:<br><br>UK  </td><td><font family=""Tahoma""><font size=""8"">Country of Final Destination:<br><br> " & ucase(countryname) & "</td><td colspan=""3""><font family=""Tahoma""><font size=""8"">Country of Origin of Goods: <br><br>United Kingdom</td></tr>"
commercialordertable=commercialordertable & "<tr><td colspan=""2""><font family=""Tahoma""><font size=""8"">Terms & Conditions of Delivery and Payment:<br><br>" & exportterms & "<br>" & overseasterms & "  </td><td colspan=""3""><font family=""Tahoma""><font size=""8"">Mode of Transport and Other Transport Information:<br><br>" & shipperdetails & "<hr height=""1px"" border=""none"" color=""#cccccc"" background-color=""#cccccc"">Currency of Sale: " & orderCurrency & "</td></tr>"
commercialordertable=commercialordertable & "<tr><td width=""90""><font family=""Tahoma""><font size=""8"">Marks & Numbers:<br><br>" & items & " Packages marked with " & rs("order_number") & "</td><td width=""200""><font family=""Tahoma""><font size=""8"">Description of Goods:<br><br>" & components & "<br>" & wraptext & "</td><td width=""97""><font family=""Tahoma""><font size=""8"">Total number<br>of packages:<br>" & items & "</td><td width=""98""><font family=""Tahoma""><font size=""8"">Gross Weight (kg):<br>" & totalgross & "</td><td width=""98""><font family=""Tahoma""><font size=""8"">Cube (M3):<br> " & formatnumber(cm3,2) & "</td></tr></table>"
commercialordertable=commercialordertable & "<table border=""1"" BORDERCOLOR=""#cccccc"" width=""100%"" cellspacing=""0"" cellpadding=""3""><tr><td colspan=""3""><font family=""Tahoma""><font size=""8"">Number&nbsp;&&nbsp;Kind&nbsp;of&nbsp;Packages</td><td align=""left""><font family=""Tahoma""><font size=""8"">Dimensions</td><td align=""left""><font family=""Tahoma""><font size=""8"">Harmonized Tariff Code</td><td align=""left""><font family=""Tahoma""><font size=""8"">Weight<br />(kg)</font></td> <td align=""center""><font family=""Tahoma""><font size=""8"">Qty</td>"
if NOT userHasRoleInList("NOPRICESUSER") then
	'if (retrieveuserid()<>181 and retrieveuserid()<>182) then) then
	commercialordertable=commercialordertable & "<td align=""left""><font family=""Tahoma""><font size=""8"">Unit<br>Price</td><td align=""left""><font family=""Tahoma""><font size=""8"">Amount</td>"
end if
commercialordertable=commercialordertable & "</tr>"
for i= 1 to items
commercialordertable=commercialordertable & "<tr><td width=""70"" colspan=2 ><font family=""Tahoma""><font size=""8""> " & i & " of " & items & "<font family=""Tahoma""><font size=""8"">" & wraptext2 & "&nbsp;</td><td width=""320""><font family=""Tahoma""><font size=""8"">" & componentarray(i) & "</td><td><font family=""Tahoma""><font size=""8"">" & dimensionsarray(i) &  "</td><td><font family=""Tahoma""><font size=""8"">" & tarrifarray(i) & "</td><td align=""right""><font family=""Tahoma""><font size=""8"">" & weightarray(i) & "</td><td align=""center""><font family=""Tahoma""><font size=""8"">" & componentqtyarray(i)
if componentpriceextrasarray(i) <>"" then
	commercialordertable=commercialordertable & "<br>" & componentextrasqtyarray(i)
end if 
commercialordertable=commercialordertable & "</font></td>"
if NOT userHasRoleInList("NOPRICESUSER") then
	'if (retrieveuserid()<>181 and retrieveuserid()<>182) then) then
	commercialordertable=commercialordertable & "<td align=""right""><font family=""Tahoma""><font size=""8"">" & getCurrencySymbolForCurrency(orderCurrency)  & componentunitpricearray(i)
	if componentunitpriceextrasarray(i) <>"" then
	commercialordertable=commercialordertable & "<br>" & componentunitpriceextrasarray(i)
	end if
	if isNumeric(componentpricearray(i)) then
		componentpricearray(i) = formatnumber(componentpricearray(i), 2)
	end if
	commercialordertable=commercialordertable & "</td><td align=""right""><font family=""Tahoma""><font size=""8"">" & getCurrencySymbolForCurrency(orderCurrency)  & componentpricearray(i)
	if componentpriceextrasarray(i) <>"" then
	commercialordertable=commercialordertable & "<br>" & componentpriceextrasarray(i)
	end if 
	commercialordertable=commercialordertable & "</td>"
end if
commercialordertable=commercialordertable & "</tr>"
next
commercialordertable=commercialordertable & "<tr><td colspan=""8"" align=""right""><font family=""Tahoma""><font size=""8"">VALUE&nbsp;&nbsp;&nbsp;</td>"
if NOT userHasRoleInList("NOPRICESUSER") then
	'if (retrieveuserid()<>181 and retrieveuserid()<>182) then) then
	commercialordertable=commercialordertable & "<td align=""right""><font family=""Tahoma""><font size=""8"">" & getCurrencySymbolForCurrency(orderCurrency)  & formatnumber(totalcost,2) & "</td>"
end if
commercialordertable=commercialordertable & "</tr>"
commercialordertable=commercialordertable & "</table>"


'response.Write(commercialordertable)
'response.End()
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
const csHTML_FontName = 100
const csHTML_FontSize  = 101
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
PDF.SetProperty csHTML_FontSize, "7"
PDF.SetProperty csPropTextColor,"#999"
PDF.SetProperty csPropTextAlign, "0"
PDF.SetProperty csPropAddTextWidth, 1
PDF.SetProperty csHTML_TRFullPage, true
PDF.SetFont "F15", 12, "#999"
PDF.SetProperty csPropTextSize, "10"

PDF.AddHTML "<p align=""center""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
PDF.AddTextPos 250, 66, "Commercial Invoice"
PDF.AddHTML commercialordertable
if items>12 then
PDF.AddPage
end if
PDF.SetProperty csPropTextSize, "2"
PDF.AddHTML "<table valign=""bottom""><tr><td><p align=""left""><font family=""Tahoma""><font size=""8""><br />IT IS HEREBY CERTIFIED that this invoice shows the actual price of the goods described, that no other invoice has been or will be issued and that all particulars are true and correct.<br /><img src=""images/commercialinv-sig.gif"" width=""120"" height=""77"" border=""0""><br>Signature of Authorised Person</p><p align=""center""><font family=""Tahoma""><font size=""8"">VAT Reg No. GB 706 8175 27<br>EORI Number: GB706817527000<br>Savoir Beds Limited, registered in England: No. 3395749.<br>Registered Address: 1 Old Oak Lane, London NW10 6UD, UK</p></td></tr></table>"
'PDF.AddHTML commercialordertable2
if rs("istrade")="y" then
totalcost=totalcost+vat
else
end if
	'PDF.AddHTMLPos 130, 660, "<table width=""100%""><tr><td width=""300"" >IT IS HEREBY CERTIFIED that this invoice shows the actual price of the goods described, that no other invoice has been or will be issued and that all particulars are true and correct.<br><img src=""images/commercialinv-sig.gif"" width=""150"" height=""96""></td><td width=""200"" align=""right""></td></tr></table><br><table width=""100%""><tr><td align=""center"">VAT Reg No. GB 706 8175 27<br>Savoir Beds Limited, registered in England: No. 3395749.<br>Registered Address: 1 Old Oak Lane, London NW10 6UD, UK</td></tr></table>"





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
