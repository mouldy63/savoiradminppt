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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, correspondence, found, item, msg2, ItemValue, e1, orderno, mattressrequired, mattressprice, topperrequired, topperprice, baserequired, baseprice, upholsteredbase, upholsteryprice, valancerequired, accessoriesrequired, valanceprice, bedsettotal, headboardrequired, headboardprice, deliverycharge, deliveryprice, total, val, contact,  orderdate, reference, clientstitle, clientsfirst, clientssurname, deldate, add1, add2, add3, town, county, country, add1d, add2d, add3d, townd, countyd, postcoded, countryd, deliveryinstructions, savoirmodel, mattresstype, tickingoptions, mattresswidth, mattresslength, leftsupport, rightsupport, ventposition, ventfinish, mattressinstructions, toppertype, topperwidth, topperlength, toppertickingoptions, specialinstructionstopper, basesavoirmodel, basetype, basestyle, basewidth, baselength, legstyle, legfinish, legheight, linkposition, linkfinish, baseinstructions, basefabric, basefabricchoice, headboardstyle, headboardfabric, headboardfabricchoice, headboardheight, specialinstructionsheadboard, pleats, valancefabric, valancefabricchoice, specialinstructionsvalance, specialinstructionsdelivery, sql, localeref, order, rs1, rs2, rs3, selcted, custcode, msg, signature, custname, quote, showroomaddress, showroomtelemail, custaddress, s, deliveryaddress, clientdetails, clienthdg, str2, str3, str4, str5, str6, str7, valreq, valancetotal, sumtbl, basevalanceprice, discountamt, termstext, xacc, accesscost, accessoriesonly, deltime, deliverytrue, mattresspicked, basepicked, topperpicked, valancepicked,  legspicked, headboardpicked, itemcount, tobedelivered, itemqty, accessoriespicked, accessoryqtysum, valencelength, valancewidth, valancedrop, str1, str10, str11, str12, str13, str14, str15, mattwidth1, mattwidth2, mattlength1, mattlength2, basewidth1, basewidth2, baselength1, baselength2, topper1width, topper1length, deliveredby, x, y, prodno, prodcount, itempicked, xacconorder, amountdelivered, amounttobedelivered, accessoryqtysumtofollow, legqty, hblegqty, giftpackrequired, shipmentdate, bookeddeliverydate, shipmentexportid, exportinclude
showroomtelemail=""
accessoryqtysumtofollow=0
exportinclude=""
bookeddeliverydate=""
shipmentdate=""
shipmentdate=request("shipmentdate")
itempicked=0
prodcount=0
itemcount=0
accessoryqtysum=0
deltime=request("deltime")
deliveredby=request("deliveredby")
giftpackrequired=request("giftpack")
if giftpackrequired="y" then str15=""
'deltime="10:00 hrs"
dim purchase_no, i, paymentSum, payments, n, displayterms, orderCurrency, upholsterysum, deltxt
displayterms=""
quote=Request("quote")
custname=""
msg=""
localeref=retrieveuserregion()
Set Con = getMysqlConnection()
sql="Select * from location where idlocation=" & retrieveuserlocation()
Set rs = getMysqlQueryRecordSet(sql, con)
				termstext=rs("terms")
				
rs.close
set rs=nothing
sql="Select * from region WHERE id_region=" & localeref
'REsponse.Write("sql=" & sql)	
Set rs = getMysqlUpdateRecordSet(sql, con)

Session.LCID = rs("locale")
rs.close
set rs=nothing
sql="Select * from location where idlocation=" & retrieveuserlocation()

Set rs = getMysqlUpdateRecordSet(sql, con)
displayterms=rs("terms")
rs.close
set rs=nothing

purchase_no=request("pn")
'purchase_no=CDbl(Request("val"))
selcted=""
count=0
order=""
submit=""
sql = "Select * from productionsizes where purchase_no = " & purchase_no & ""
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
end if
rs2.close
set rs2=nothing

sql="Select * from purchase WHERE purchase_no=" & purchase_no & ""
Set rs = getMysqlUpdateRecordSet(sql, con)
rs("deliveredby")=deliveredby
rs("delivery_Time")=deltime
if isNull(rs("bookeddeliverydate")) then
bookeddeliverydate=""
else
bookeddeliverydate=rs("bookeddeliverydate")
end if
rs.update
rs.close
set rs=nothing
if bookeddeliverydate="" then
sql="SELECT L.componentid, L.linkscollectionid, E.collectiondate  FROM exportlinks L, exportcollshowrooms C, exportcollections E where L.purchase_no=" & purchase_no & " and L.linkscollectionid=C.exportCollshowroomsID and C.exportCollectionID =E.exportCollectionsID and L.linkscollectionid=" & shipmentdate
shipmentexportid=shipmentdate
Set rs = getMysqlUpdateRecordSet(sql, con)
if not rs.eof then
shipmentdate=rs("CollectionDate")
end if 
rs.close
set rs=nothing
end if

sql="Select * from purchase WHERE purchase_no=" & purchase_no & ""

Set rs = getMysqlQueryRecordSet(sql, con)
deliveryaddress="<font family=""Tahoma""><font size=""8"">"
If rs("deliveryadd1") <> "" then deliverytrue=1 else deliverytrue=0
If rs("deliveryadd1") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd1")) & "<br />"
If rs("deliveryadd2") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd2")) & "<br />"
If rs("deliveryadd3") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliveryadd3")) & "<br />"
If rs("deliverytown") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverytown")) & "<br />"
If rs("deliverycounty") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverycounty")) & "<br />"
If rs("deliverypostcode") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverypostcode")) & "<br />"
If rs("deliverycountry") <> "" then deliveryaddress=deliveryaddress & Utf8ToUnicode(rs("deliverycountry"))
deliveryaddress=deliveryaddress & "</font></font>"
if rs("legqty")<>"" and NOT ISNULL(rs("legqty")) then legqty=rs("legqty")
if rs("addlegqty")<>"" and NOT ISNULL(rs("addlegqty")) then legqty=legqty + rs("addlegqty")
if rs("headboardlegqty")<>"" and NOT ISNULL(rs("headboardlegqty")) then hblegqty= rs("headboardlegqty")

'add giftpack
If giftpackrequired="y" then
		accreccount=accreccount+1
		sql="select * from orderaccessory where description='Delivery Gift Pack' and purchase_no=" & purchase_no
		Set rs3 = getMysqlUpdateRecordSet(sql, con)
		if rs3.eof then
			rs3.close
			set rs3=nothing
			sql="select * from orderaccessory"
			Set rs3 = getMysqlUpdateRecordSet(sql, con)
			rs3.AddNew
		end if

		rs3("purchase_no")=purchase_no
		rs3("description")="Delivery Gift Pack"
		rs3("qty")=1
		rs3("status")=70
				If rs("bookeddeliverydate")<>"" then
				rs3("delivered")=rs("bookeddeliverydate")
				else
				
				end if
rs3.Update
rs3.close
set rs3 = nothing
end if
'end add gift pack
'remove gift pack if change of mind
if (rs("giftpackrequired")="y" and giftpackrequired="") then
Set rs3 = getMysqlUpdateRecordSet("select * from orderaccessory where purchase_no=" & purchase_no & " and description like 'Delivery Gift Pack'", con)
if not rs3.eof then
rs3.delete
end if
rs3.close
set rs3=nothing
end if
'end delete gift pack
dim accreccount
Set rs3 = getMysqlUpdateRecordSet("select * from orderaccessory where purchase_no=" & purchase_no, con)
if not rs3.eof then
accreccount=rs3.recordcount
else
accreccount=0
end if
rs3.close
set rs3=nothing


sql="Select * from purchase WHERE purchase_no=" & purchase_no & ""
Set rs3 = getMysqlUpdateRecordSet(sql, con)
if giftpackrequired="y" then rs3("giftpackrequired")="y" else rs3("giftpackrequired")="n"
if giftpackrequired="y" then 
	rs3("accessoriesrequired")="y" 
else 
	if accreccount=0 then
	rs3("accessoriesrequired")="n"
	end if
end if
rs3.update
rs3.close
set rs3=nothing


sql="Select * from location WHERE idlocation=" & rs("idlocation") & ""
Set rs2 = getMysqlQueryRecordSet(sql, con)

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

if deliverytrue=0 then deliveryaddress=custaddress 
if deliverytrue=1 then deliveryaddress=deliveryaddress
s = "<br><br><table cellpadding=""1""> "
s = s & " <tr><td></td></tr>"
s = s & " <tr><td width=""11"" height=""55""></td> "
s = s & " <td width=""54"" valign=""top"">" & clienthdg & "</td><td width=""236"" valign=""top"">" & clientdetails & "</td><td width=""39""></td><td width=""366"">" & deliveryaddress & "</td> "
s = s & " </tr> "
s = s & " </table> "

mattwidth1=rs("mattresswidth")
mattlength1=rs("mattresslength")
if left(rs("mattresstype"),11)="Zipped Pair" and (rs("mattresswidth")<>"Special (as instructions)" AND rs("mattresswidth")<>"Special Width" and rs("mattresslength")<>"Special (as instructions)" AND rs("mattresslength")<>"Special Length" AND rs("mattresswidth")<>"n") then
		  if right(rs("mattresswidth"),2)="cm" then
		     mattwidth1= left(rs("mattresswidth"), len(rs("mattresswidth"))-2)/2 & "cm"
			 mattlength1=left(rs("mattresslength"), len(rs("mattresslength"))-2) & "cm"
			 mattwidth2=mattwidth1
			 mattlength2=mattlength1
		end if
		if right(rs("mattresswidth"),2)="in" then
		     mattwidth1= (left(rs("mattresswidth"), len(rs("mattresswidth"))-2)*2.54)/2  & "cm"
			 mattlength1=left(rs("mattresslength"), len(rs("mattresslength"))-2)*2.54 & "cm"
			  mattwidth2=mattwidth1
		end if
		else
		mattwidth1=rs("mattresswidth")
		mattlength1=rs("mattresslength")
		if right(rs("mattresswidth"),2)="in" then
		mattwidth1= (left(rs("mattresswidth"), len(rs("mattresswidth"))-2)*2.54)
		end if
		if right(rs("mattresslength"),2)="in" then
			mattlength1= (left(rs("mattresslength"), len(rs("mattresslength"))-2)*2.54)
		end if
end if

basewidth1=rs("basewidth")
baselength1=rs("baselength")
if left(rs("basetype"),5)="North" and (rs("basewidth")<>"Special (as instructions)"  AND rs("basewidth")<>"Special Width" AND rs("basewidth")<>"n") then
			  if right(basewidth1,2)="cm" then  basewidth1= left(rs("basewidth"), len(rs("basewidth"))-2) 
			  if right(basewidth1,2)="in" then  basewidth1= (left(rs("basewidth"), len(rs("basewidth"))-2)*2.54)
			  basewidth1=basewidth1/2 & "cm"
			  if right(baselength1,2)="cm" then  baselength1= left(rs("baselength"), len(rs("baselength"))-2) & "cm" 
			  if right(baselength1,2)="in" then  baselength1= (left(rs("baselength"), len(rs("baselength"))-2) *2.54) & "cm"
			  baselength2=baselength1
			  basewidth2=basewidth1
end if
if left(rs("basetype"),4)="East" and (rs("basewidth")<>"Special (as instructions)"  AND  (rs("basewidth")<>"Special Width"AND rs("baselength")<>"Special Length") AND rs("basewidth")<>"n")  then
			  if right(basewidth1,2)="cm" then  basewidth1= left(rs("basewidth"), len(rs("basewidth"))-2)  & "cm"
			  if right(baselength1,2)="cm" then  baselength1= left(rs("baselength"), len(rs("baselength"))-2)
			  if right(baselength1,2)="in" then  baselength1= (left(rs("baselength"), len(rs("baselength"))-2) *2.54)
			  	baselength2=baselength1-130 & "cm"
			  baselength1=130 & "cm"
			  basewidth2=basewidth1 & "cm"
end if
'response.Write("matt=" & mattwidth1)
'response.End()
rs2.close
set rs2=nothing
if rs("mattresswidth")="Special (as instructions)"  or rs("mattresswidth")="Special Width"  then
Set rs2 = getMysqlQueryRecordSet("Select * from productionsizes where purchase_no=" & purchase_no, con)
										if not rs2.eof then
										mattwidth1=rs2("matt1width") & "cm"
										mattwidth2=rs2("matt2width")	 & "cm"
										end if
										rs2.close
										set rs2=nothing

end if
if rs("mattresslength")="Special (as instructions)"  or rs("mattresslength")="Special Length"  then
Set rs2 = getMysqlQueryRecordSet("Select * from productionsizes where purchase_no=" & purchase_no, con)
										if not rs2.eof then
										mattlength1=rs2("matt1length") & "cm"
										mattlength2=rs2("matt2length") & "cm"
										end if
										rs2.close
										set rs2=nothing

end if

if rs("basewidth")="Special (as instructions)"  or rs("basewidth")="Special Width"  then
Set rs2 = getMysqlQueryRecordSet("Select * from productionsizes where purchase_no=" & purchase_no, con)
										if not rs2.eof then
										basewidth1=rs2("base1width") & "cm"
										basewidth2=rs2("base2width")	 & "cm"
										end if
										rs2.close
										set rs2=nothing

end if
if rs("baselength")="Special (as instructions)"  or rs("baselength")="Special Length"  then
Set rs2 = getMysqlQueryRecordSet("Select * from productionsizes where purchase_no=" & purchase_no, con)
										if not rs2.eof then
										baselength1=rs2("base1length") & "cm"
										baselength2=rs2("base2length") & "cm"
										end if
										rs2.close
										set rs2=nothing

end if

																				
	
	sql="select * from orderaccessory where (status=120 or status=130 or status=70) AND purchase_no=" & purchase_no & " order by orderaccessory_id"
	Set rs3 = getMysqlUpdateRecordSet(sql, con)

if not rs3.eof then
xacc="<table><tr><td width=""10"" height=""20""></td><td><b>Item&nbsp;Description</b></td><td>Design</td><td>Colour</td><td>Size</td><td align=""right""><b>Qty</b></td></tr>"
 do until rs3.eof
xacc=xacc & "<tr ><td width=""10"" height=""10""></td>"
xacc=xacc & "<td width=""350"">" & rs3("description") & "</td>"
xacc=xacc & "<td width=""150"">" & rs3("design") & "</td>"
xacc=xacc & "<td width=""100"">" & rs3("colour") & "</td>"
xacc=xacc & "<td width=""100"">" & rs3("size") & "</td>"
if rs3("qtytofollow")>0 then
amountdelivered=rs3("qty")-rs3("qtytofollow")
else
amountdelivered=rs3("qty")
end if


xacc=xacc & "<td width=""60"" align=""right"">" & amountdelivered & "</td>"
accessoryqtysum=accessoryqtysum+amountdelivered
xacc=xacc & "</tr>"
xacc=xacc & "<tr><td></td><td colspan=""7""><hr style=""color:#eeeeee;""></td></tr>"
accesscost=0   
	rs3.movenext
	loop
xacc=xacc & "</table>"
end if
rs3.close
set rs3 = nothing

sql="select * from orderaccessory where status<>120 AND status<>70 and purchase_no=" & purchase_no & " order by orderaccessory_id"
Set rs3 = getMysqlUpdateRecordSet(sql, con)

if not rs3.eof then
xacconorder="<br><br><strong><font face=""Tahoma""><font size=""8"">&nbsp;&nbsp;&nbsp;&nbsp;<b>Accessories to Follow: &nbsp;&nbsp;</b></font></font></strong><table><tr><td width=""10"" height=""20""></td><td><b>Item&nbsp;Description</b></td><td>Design</td><td>Colour</td><td>Size</td><td align=""right""><b>Qty</b></td></tr>"
 do until rs3.eof
xacconorder=xacconorder & "<tr ><td width=""10"" height=""10""></td>"
xacconorder=xacconorder & "<td width=""350"">" & rs3("description") & "</td>"
xacconorder=xacconorder & "<td width=""150"">" & rs3("design") & "</td>"
xacconorder=xacconorder & "<td width=""100"">" & rs3("colour") & "</td>"
xacconorder=xacconorder & "<td width=""100"">" & rs3("size") & "</td>"
if rs3("qtytofollow")>0 then
amounttobedelivered=rs3("qtytofollow") 
else
amounttobedelivered=rs3("qty")
end if
xacconorder=xacconorder & "<td width=""60"" align=""right"">" & amounttobedelivered & "</td>"
accessoryqtysumtofollow=accessoryqtysumtofollow+amounttobedelivered
xacconorder=xacconorder & "</tr>"
xacconorder=xacconorder & "<tr><td></td><td colspan=""7""><hr style=""color:#eeeeee;""></td></tr>"
accesscost=0   
	rs3.movenext
	loop
xacconorder=xacconorder & "</table>"
end if
rs3.close
set rs3 = nothing


'sql="Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=9 order by qc_date desc"
'Set rs3 = getMysqlQueryRecordSet(sql, con)
	'	if not rs3.eof then
	'		if rs3("qc_statusid")=60 then 
	'			accessoriespicked="y" 
	'			else 
'				if rs3("qc_statusid")<>70 and rs3("qc_statusid")<>80 then tobedelivered=tobedelivered & "'<br>"
	'		end if
'		end if
'	rs3.close
'	set rs3=nothing
	
	'MATTRESS REQ'
If rs("mattressrequired")="y" then
	if bookeddeliverydate="" then
		sql="SELECT * FROM exportlinks where purchase_no=" & purchase_no & " and componentid=1 and linkscollectionid=" & shipmentexportid
		Set rs3 = getMysqlUpdateRecordSet(sql, con)
		if NOT rs3.eof then
			exportinclude="y"
			else
			exportinclude="n"
		end if
		rs3.close
		set rs3=nothing
	end if
	Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=1 order by qc_date desc", con)
		if not rs3.eof then
			if rs3("qc_statusid")=60 then 
				mattresspicked="y"
				if (bookeddeliverydate="" and exportinclude="n") then 
					mattresspicked=""
					tobedelivered=tobedelivered & "Mattress<br>"
				end if
				else 
				if rs3("qc_statusid")<>70 and rs3("qc_statusid")<>80 then tobedelivered=tobedelivered & "Mattress<br>"
			end if
		end if
	rs3.close
	set rs3=nothing
	
	if mattresspicked="y" then 
	prodcount=1
		if left(rs("mattresstype"),6)="Zipped" then 
			itemqty=2 
			itemcount=itemcount+itemqty
			else 
			itemqty=1
			itemcount=itemcount+itemqty
		end if
	
	
	str1="<table border=""0"" cellspacing=""0"" cellpadding=""0""><tr><td width=""12"">&nbsp;</td>"
	str1=str1 & "<td width=""43""><strong><font face=""Tahoma""><font size=""8""><b>Model:</b></font></font></strong></td>"
	str1=str1 & "<td width=""74""><font face=""Tahoma""><font size=""8"">" &  rs("savoirmodel") & "</font></font></td>"
	str1=str1 & "<td width=""43""><strong><font face=""Tahoma""><font size=""8""><b>Type:</b></font></font></strong></td>"
	str1=str1 & "<td width=""90""><font face=""Tahoma""><font size=""8"">" & rs("mattresstype") & "</font></font></td>"
	str1=str1 & "<td width=""90""><strong><font face=""Tahoma""><font size=""8""><b>Overall Size Required:</b></font></font></strong></td>"
	str1=str1 & "<td width=""145""><font face=""Tahoma""><font size=""8"">" & rs("mattresswidth") & " x " & rs("mattresslength") & ""
	str1=str1 & "</font></font></td>"
	str1=str1 & "<td width=""10""><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str1=str1 & "<td width=""10""><font face=""Tahoma""><font size=""8"">"
	str1=str1 & "</font></font></td>"
	str1=str1 & "<td width=""10"">&nbsp;</td>"
	str1=str1 & "<td width=""10"">&nbsp;</td>"
	str1=str1 & "</tr>"
	if mattwidth1<>"" then
	str1=str1 & "<tr><td>&nbsp;</td>"
	str1=str1 & "<td><strong><font face=""Tahoma""><font size=""8""><b>Mattress:</b></font></font></strong></td>"
	str1=str1 & "<td><font face=""Tahoma""><font size=""8"">" & mattwidth1 &  " x " & mattlength1 & "</font></font></td>"
	if mattwidth2<>"" then
	str1=str1 & "<td><strong><font face=""Tahoma""><font size=""8""><b>Mattress:</b></font></font></strong></td>"
	str1=str1 & "<td><font face=""Tahoma""><font size=""8"">" & mattwidth2 &  " x " & mattlength2 & "</font></font></td>"
	else
	str1=str1 & "<td><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str1=str1 & "<td><font face=""Tahoma""><font size=""8""></font></font></td>"
	end if
	str1=str1 & "<td><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str1=str1 & "<td><font face=""Tahoma""><font size=""8"">"
	str1=str1 & "</font></font></td>"
	str1=str1 & "<td><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str1=str1 & "<td><font face=""Tahoma""><font size=""8"">"
	str1=str1 & "</font></font></td>"
	str1=str1 & "<td>&nbsp;</td>"
	str1=str1 & "<td>&nbsp;</td></tr>"
	end if
	
	str1=str1 & "<tr ><td>&nbsp;</td>"
	str1=str1 & "<td><strong><font face=""Tahoma""><font size=""8""><b>Left:</b></font></font></strong></td>"
	str1=str1 & "<td><font face=""Tahoma""><font size=""8"">" & rs("leftsupport") & "</font></font>&nbsp;</td>"
	str1=str1 & "<td><strong><font face=""Tahoma""><font size=""8""><b>Right:</b></font></font></strong></td>"
	str1=str1 & "<td><font face=""Tahoma""><font size=""8"">" & rs("rightsupport") & "</font></font>&nbsp;</td>"
	str1=str1 & "<td><strong><font face=""Tahoma""><font size=""8""><b>Ticking:</b></font></font></strong></td>"
	str1=str1 & "<td><font face=""Tahoma""><font size=""8"">" & rs("tickingoptions") & "</font></font>&nbsp;</td>"
	str1=str1 & "<td>&nbsp;</td>"
	str1=str1 & "<td>&nbsp;</td>"
	str1=str1 & "<td>&nbsp;</td>"
	str1=str1 & "<td width=""30""><strong><font face=""Tahoma""><font size=""8""><b>QTY:</b> " & itemqty & "</font></font></strong></td></tr>"
	str1=str1 & "</table>"



else
	itemqty=0
	end if
itemqty=1	
	

end if
'MATTRESS REQ END
'BASE REQ
If rs("baserequired")="y" then
	if bookeddeliverydate="" then
		sql="SELECT * FROM exportlinks where purchase_no=" & purchase_no & " and componentid=3 and linkscollectionid=" & shipmentexportid
		Set rs3 = getMysqlUpdateRecordSet(sql, con)
		if NOT rs3.eof then
			exportinclude="y"
			else
			exportinclude="n"
		end if
		rs3.close
		set rs3=nothing
	end if
	
	Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=3 order by qc_date desc", con)
		if not rs3.eof then
			if rs3("qc_statusid")=60 then 
				basepicked="y"
				if (bookeddeliverydate="" and exportinclude="n") then 
					basepicked=""
					tobedelivered=tobedelivered & "Base<br>"
				end if 
				else 
				if rs3("qc_statusid")<>70 and rs3("qc_statusid")<>80 then tobedelivered=tobedelivered & "Base<br>"
			end if
		end if
	rs3.close
	set rs3=nothing
	
	if basepicked="y" then
	prodcount=prodcount+1 
			if left(rs("basetype"),4)="Nort"  or left(rs("basetype"),4)="East" then 
				itemqty=2
				itemcount=itemcount+2
				else 
				itemqty=1
				itemcount=itemcount+1
			end if
			
	
	
	str10="<table border=""0"" cellspacing=""0"" cellpadding=""0""><tr><td width=""12"">&nbsp;</td>"
	str10=str10 & "<td width=""116""><strong><font face=""Tahoma""><font size=""8""><b>Model: &nbsp;&nbsp;</b></font></font></strong>"
	str10=str10 & "<font face=""Tahoma""><font size=""8"">" &  rs("basesavoirmodel") & "</font></font></td>"
	str10=str10 & "<td width=""43""><strong><font face=""Tahoma""><font size=""8""><b>Type:</b></font></font></strong></td>"
	str10=str10 & "<td width=""91""><font face=""Tahoma""><font size=""8"">" & rs("basetype") & "</font></font></td>"
	str10=str10 & "<td width=""90""><strong><font face=""Tahoma""><font size=""8""><b>Overall Size Required:</b></font></font></strong></td>"
	str10=str10 & "<td width=""145""><font face=""Tahoma""><font size=""8"">" & rs("basewidth") & " x "  & rs("baselength") & "</font></font></td>"
	str10=str10 & "<td width=""10""></td>"
	str10=str10 & "<td width=""10""></td>"
	str10=str10 & "<td width=""10"">&nbsp;</td>"
	str10=str10 & "<td width=""10"">&nbsp;</td>"
	str10=str10 & "</tr>"
	if basewidth1<>"" then
	str10=str10 & "<tr><td>&nbsp;</td>"
	str10=str10 & "<td><strong><font face=""Tahoma""><font size=""8""><b>Base:</b></font></font></strong>"
	str10=str10 & "<font face=""Tahoma""><font size=""8"">&nbsp;&nbsp;&nbsp;" & basewidth1 &  " x " & baselength1 & "</font></font></td>"
	if basewidth2<>"" then
	str10=str10 & "<td><strong><font face=""Tahoma""><font size=""8""><b>Base:</b></font></font></strong></td>"
	str10=str10 & "<td><font face=""Tahoma""><font size=""8"">" & basewidth2 &  " x " & baselength2 & "</font></font></td>"
	else
	str10=str10 & "<td><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str10=str10 & "<td><font face=""Tahoma""><font size=""8""></font></font></td>"
	end if
	str10=str10 & "<td><strong><font face=""Tahoma""><font size=""8""><b>Ticking</b></font></font></strong></td>"
	str10=str10 & "<td><font face=""Tahoma""><font size=""8"">" & rs("basetickingoptions") & ""
	str10=str10 & "</font></font></td>"
	str10=str10 & "<td><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str10=str10 & "<td><font face=""Tahoma""><font size=""8"">"
	str10=str10 & "</font></font></td>"
	str10=str10 & "<td>&nbsp;</td>"
	str10=str10 & "<td>&nbsp;</td></tr>"
	end if
	str10=str10 & "<tr><td>&nbsp;</td>"
	if rs("upholsteredbase") = "Yes" or rs("upholsteredbase") = "Yes, Com" then
	str10=str10 & "<td><strong><font face=""Tahoma""><font size=""8"">Upholstered Base &nbsp;&nbsp;</font></font></strong>"
	else
	str10=str10 & "<td><strong><font face=""Tahoma""><font size=""8""></font></font></strong>"
	end if
	str10=str10 & "<font face=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"
	str10=str10 & "<td><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str10=str10 & "<td><font face=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"
	str10=str10 & "<td><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str10=str10 & "<td><font face=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"
	str10=str10 & "<td><strong><font family=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str10=str10 & "<td><font family=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"
	str10=str10 & "<td>&nbsp;</td>"
	str10=str10 & "<td width=""30""><strong><font face=""Tahoma""><font size=""8""><b>QTY:</b> " & itemqty & "</font></font></strong></td>"
	str10=str10 & "</tr></table>"


	
itemqty=1
else
	itemqty=0
end if
end if

'BASE REQ END

'LEGS REQ
if bookeddeliverydate="" then
		sql="SELECT * FROM exportlinks where purchase_no=" & purchase_no & " and componentid=7 and linkscollectionid=" & shipmentexportid
		Set rs3 = getMysqlUpdateRecordSet(sql, con)
		if NOT rs3.eof then
			exportinclude="y"
			else
			exportinclude="n"
		end if
		rs3.close
		set rs3=nothing
	end if 
Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=7 order by qc_date desc", con)
		if not rs3.eof then
			if rs3("qc_statusid")=60 then 
				legspicked="y" 
				if (bookeddeliverydate="" and exportinclude="n") then 
					legspicked=""
					tobedelivered=tobedelivered & "Legs<br>"
				end if 
				else 
				if rs3("qc_statusid")<>70 and rs3("qc_statusid")<>80 then tobedelivered=tobedelivered & "Legs<br>"
			end if
		end if
	rs3.close
	set rs3=nothing

'END IF


'LEGS REQ QTY COUNT
if legspicked="y" then 
	itemqty=1 
	itemcount=itemcount+itemqty
	
str11="<table border=""0"" cellspacing=""0"" cellpadding=""0"">"
	str11=str11 & "<tr><td width=""12"">&nbsp;</td>"
	str11=str11 & "<td width=""45""><strong><font face=""Tahoma""><font size=""8""><b>Leg Style:</b></font></font></strong></td>"
	str11=str11 & "<td width=""71""><font face=""Tahoma""><font size=""8"">" & rs("legstyle") & "</font></font>&nbsp;</td>"
	str11=str11 & "<td width=""45""><strong><font face=""Tahoma""><font size=""8""><b>Leg Finish:</b></font></font></strong></td>"
	str11=str11 & "<td width=""89""><font face=""Tahoma""><font size=""8"">" & rs("legfinish") & "</font></font>&nbsp;</td>"
	str11=str11 & "<td width=""47""><strong><font face=""Tahoma""><font size=""8""><b>Leg Height:</b></font></font></strong></td>"
	str11=str11 & "<td width=""145""><font face=""Tahoma""><font size=""8"">" & rs("legheight") & "</font></font>&nbsp;</td>"
	
		str11=str11 & "<td width=""30""><strong><font family=""Tahoma""><font size=""8""><b>Leg Qty: " & legqty & "</b></font></font></strong></td>"
	str11=str11 & "<td width=""4""><font family=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"
	
	str11=str11 & "<td width=""10"">&nbsp;</td>"
	str11=str11 & "<td width=""30""><strong><font face=""Tahoma""><font size=""8""><b>QTY:</b> " & itemqty & "</font></font></strong></td>"
	str11=str11 & "</tr>"
		str11=str11 & "<tr><td width=""12"">&nbsp;</td>"
		if rs("legstyle")="Castors" then
	str11=str11 & "<td width=""45""><strong><font face=""Tahoma""><font size=""8""><b>Floor Type:</b></font></font></strong></td>"
	str11=str11 & "<td width=""71""><font face=""Tahoma""><font size=""8"">" & rs("floortype") & "</font></font>&nbsp;</td>"
	else
	str11=str11 & "<td width=""45""><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str11=str11 & "<td width=""71""><font face=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"
	end if
	str11=str11 & "<td width=""45""><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str11=str11 & "<td width=""89""><font face=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"
	str11=str11 & "<td width=""47""><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str11=str11 & "<td width=""148""><font face=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"

		str11=str11 & "<td width=""50""><strong><font family=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str11=str11 & "<td width=""10""><font family=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"
	
	str11=str11 & "<td width=""10"">&nbsp;</td>"
	str11=str11 & "<td width=""30""><strong><font face=""Tahoma""><font size=""8""></font></font></strong></td>"
	str11=str11 & "</tr></table>"


else
	itemqty=0 
end if
'LEGS END
itemqty=0

'IF TOPPER REQ
If rs("topperrequired")="y" then
	if bookeddeliverydate="" then
		sql="SELECT * FROM exportlinks where purchase_no=" & purchase_no & " and componentid=5 and linkscollectionid=" & shipmentexportid
		Set rs3 = getMysqlUpdateRecordSet(sql, con)
		if NOT rs3.eof then
			exportinclude="y"
			else
			exportinclude="n"
		end if
		rs3.close
		set rs3=nothing
	end if
	Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=5 order by qc_date desc", con)
		if not rs3.eof then
			if rs3("qc_statusid")=60 then 
				topperpicked="y"
				if (bookeddeliverydate="" and exportinclude="n") then 
					topperpicked=""
					tobedelivered=tobedelivered & "Topper<br>"
				end if 
				
				else 
				if rs3("qc_statusid")<>70 and rs3("qc_statusid")<>80 then tobedelivered=tobedelivered & "Topper<br>"
			end if
		end if
	rs3.close
	set rs3=nothing
	if topperpicked="y" then
	itemcount=itemcount+1 
	itemqty=1
	
	
	str12="<table  border=""0"" cellspacing=""0"" cellpadding=""0""><tr><td width=""12"">&nbsp;</td>"
	str12=str12 & "<td width=""35""><strong><font face=""Tahoma""><font size=""8""><b>Model:</b></font></font></strong></td>"
	str12=str12 & "<td width=""80""><font face=""Tahoma""><font size=""8"">" &  rs("toppertype") & "</font></font></td>"
	str12=str12 & "<td width=""35""><strong><font face=""Tahoma""><font size=""8""><b>Width:</b></font></font></strong></td>"
	str12=str12 & "<td width=""100""><font face=""Tahoma""><font size=""8"">" & rs("topperwidth") & "</font></font></td>"
	str12=str12 & "<td width=""35""><strong><font face=""Tahoma""><font size=""8""><b>Length:</b></font></font></strong></td>"
	str12=str12 & "<td width=""80""><font face=""Tahoma""><font size=""8"">" & rs("topperlength") & "</font></font></td>"
	str12=str12 & "<td width=""35""><strong><font face=""Tahoma""><font size=""8""><b>Ticking:</b></font></font></strong></td>"
	str12=str12 & "<td width=""107""><font face=""Tahoma""><font size=""8"">" & rs("toppertickingoptions") & "</font></font></td>"
	str12=str12 & "<td>&nbsp;</td>"
	str12=str12 & "<td width=""30""><strong><font face=""Tahoma""><font size=""8""><b>QTY:</b> " & itemqty & "</font></font></strong></td>"
	str12=str12 & "</tr>"
	str12=str12 & "<tr><td>&nbsp;</td>"
	str12=str12 & "<td><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str12=str12 & "<td><font face=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"
	str12=str12 & "<td><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str12=str12 & "<td><font face=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"
	str12=str12 & "<td><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str12=str12 & "<td><font face=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"
	str12=str12 & "<td><strong><font family=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str12=str12 & "<td><font family=""Tahoma""><font size=""8""></font></font>&nbsp;</td>"
	str12=str12 & "<td>&nbsp;</td>"
	str12=str12 & "<td><strong><font face=""Tahoma""><font size=""8""><b></b> </font></font></strong></td>"
	str12=str12 & "</tr></table>"

end if
itemqty=0

else
	itemqty=0
end if
'TOPPER REQ END
'VALANCE REQ
If rs("valancerequired")="y" then
	if bookeddeliverydate="" then
		sql="SELECT * FROM exportlinks where purchase_no=" & purchase_no & " and componentid=6 and linkscollectionid=" & shipmentexportid
		Set rs3 = getMysqlUpdateRecordSet(sql, con)
		if NOT rs3.eof then
			exportinclude="y"
			else
			exportinclude="n"
		end if
		rs3.close
		set rs3=nothing
	end if
	Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=6 order by qc_date desc", con)
		if not rs3.eof then
			if rs3("qc_statusid")=60 then 
				valancepicked="y"
				if (bookeddeliverydate="" and exportinclude="n") then 
					valancepicked=""
					tobedelivered=tobedelivered & "Valance<br>"
				end if  
				else 
				if rs3("qc_statusid")<>70 and rs3("qc_statusid")<>80 then tobedelivered=tobedelivered & "Valance<br>"
			end if
		end if
	rs3.close
	set rs3=nothing
	valreq="Yes"
	If rs("valanceprice")<>"" and NOT ISNULL(rs("valanceprice")) then
		if CDbl(rs("valanceprice"))>0.0 then basevalanceprice=CDbl(rs("valanceprice"))
	end if
	else 
	valreq="No"
end if

'VALANCE REQ ENTERED WHETHER YES OR NO
'PDF.AddHTMLPos 220, 411, "<font family=""Tahoma""><font size=""8""><b>Valance:</b></font></font>"
'if valancepicked="y" then PDF.AddHTMLPos 253, 411, "<font family=""Tahoma""><font size=""8"">" & valreq & "</font></font>"
'END VALANCE REQ ENTERED WHETHER YES OR NO

'VALANCE REQUIRED
If rs("valancerequired")="y" then
if valancepicked="y" then 
		itemqty=1
		itemcount=itemcount+1 
str13="<table border=""0"" cellspacing=""0"" cellpadding=""0""><tr><td width=""12"">&nbsp;</td>"
	str13=str13 & "<td width=""55""><strong><font face=""Tahoma""><font size=""8""><b>No. of Pleats:</b></font></font></strong></td>"
	str13=str13 & "<td width=""60""><font face=""Tahoma""><font size=""8"">" &  rs("pleats") & "</font></font></td>"
	str13=str13 & "<td width=""35""><strong><font face=""Tahoma""><font size=""8""><b>Width:</b></font></font></strong></td>"
	str13=str13 & "<td width=""100""><font face=""Tahoma""><font size=""8"">" & rs("valancewidth") & "</font></font></td>"
	str13=str13 & "<td width=""35""><strong><font face=""Tahoma""><font size=""8""><b>Length:</b></font></font></strong></td>"
	str13=str13 & "<td width=""80""><font face=""Tahoma""><font size=""8"">" & rs("valancelength") & "</font></font></td>"
	str13=str13 & "<td width=""30""><strong><font face=""Tahoma""><font size=""8""><b>Drop:</b></font></font></strong></td>"
	str13=str13 & "<td width=""110""><font face=""Tahoma""><font size=""8"">" & rs("valancedrop") & "</font></font></td>"
	str13=str13 & "<td width=""10"">&nbsp;</td>"
	str13=str13 & "<td width=""30""><strong><font face=""Tahoma""><font size=""8""><b>QTY:</b> " & itemqty & "</font></font></strong></td>"
	str13=str13 & "</tr></table>"

	
	
	
else
		itemqty=0

	end if	
END IF

itemqty=0



'end valance
'headboard options
if rs("headboardrequired")="y" then
	if bookeddeliverydate="" then
		sql="SELECT * FROM exportlinks where purchase_no=" & purchase_no & " and componentid=8 and linkscollectionid=" & shipmentexportid
		Set rs3 = getMysqlUpdateRecordSet(sql, con)
		if NOT rs3.eof then
			exportinclude="y"
			else
			exportinclude="n"
		end if
		rs3.close
		set rs3=nothing
	end if 
	Set rs3 = getMysqlQueryRecordSet("Select * from qc_history WHERE purchase_no=" & purchase_no & " AND componentid=8 order by qc_date desc", con)
		if not rs3.eof then
			if rs3("qc_statusid")=60 then 
				headboardpicked="y"
				if (bookeddeliverydate="" and exportinclude="n") then 
					valancepicked=""
					tobedelivered=tobedelivered & "Headboard<br>"
				end if 
				else 
				if rs3("qc_statusid")<>70 and rs3("qc_statusid")<>80 then tobedelivered=tobedelivered & "Headboard<br>"
			end if
		end if
	rs3.close
	set rs3=nothing
	if headboardpicked="y" then 
	itemqty=1
	itemcount=itemcount+1 
	str14="<table border=""0"" cellspacing=""0"" cellpadding=""0""><tr><td width=""12"">&nbsp;</td>"
	str14=str14 & "<td width=""25""><strong><font face=""Tahoma""><font size=""8""><b>Style:</b></font></font></strong></td>"
	str14=str14 & "<td width=""222""><font face=""Tahoma""><font size=""8"">" &  rs("headboardstyle") & "</font></font></td>"
	str14=str14 & "<td width=""35""><strong><font face=""Tahoma""><font size=""8""><b>Height:</b></font></font></strong></td>"
	str14=str14 & "<td width=""160""><font face=""Tahoma""><font size=""8"">" & rs("headboardheight") & "</font></font></td>"
	str14=str14 & "<td width=""50""><strong><font face=""Tahoma""><font size=""8""><b>Leg Qty: " & hblegqty & "</b></font></font></strong></td>"
	str14=str14 & "<td width=""5""><font face=""Tahoma""><font size=""8""></font></font></td>"
	str14=str14 & "<td width=""5""><strong><font face=""Tahoma""><font size=""8""><b></b></font></font></strong></td>"
	str14=str14 & "<td width=""5""><font face=""Tahoma""><font size=""8""></font></font></td>"
	str14=str14 & "<td>&nbsp;</td>"
	str14=str14 & "<td width=""30""><strong><font face=""Tahoma""><font size=""8""><b>QTY:</b> " & itemqty & "</font></font></strong></td>"
	str14=str14 & "</tr></table>"
else
	itemqty=0
end if
	
end if

itemqty=0


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
if rs("mattressrequired")="y" or rs("topperrequired")="y" or rs("legsrequired")="y" or rs("baserequired")="y" or rs("headboardrequired")="y" or rs("valancerequired")="y" then accessoriesonly="n" else accessoriesonly="y"

if accessoriesonly="n" then 

		DrawBox 20,93, 250, 95
		
		DrawBox 280,93, 250, 95
		
		x=47
		y=195
		If mattresspicked="y" then 
			y=195
			DrawBox 20,y, 510, x
			y=y+55
		end if
		'MATTRESS REQ
		
		'end MATTRESS
		'BASE REQ
		if basepicked="y" then
			DrawBox 20,y, 510, x
			y=y+55
		end if
		'end BASE
		
		'LEGS REQ
		if legspicked="y" then
			DrawBox 20,y, 510, x
			y=y+55
		end if
		'end LEGS
		'TOPPER REQ
		if topperpicked="y" then
			DrawBox 20,y, 510, x
			y=y+55
		end if
		'end TOPPER
		'VALANCE OPTIONS REQ
		if valancepicked="y" then
			DrawBox 20,y, 510, x
			y=y+55
		end if
		
		'end VALANCE
		'HEADBOARD REQ
		if headboardpicked="y" then
			DrawBox 20,y, 510, x
			y=y+55
		end if
		y=y+10
		'end HEADBOARD
		'ORDER SUMMARY
		DrawBox 20,y, 270, 82
		'end ORDER SUMMARY
		'TOTAL DETAILS
		
		If accessoriespicked="y" then
		DrawBox 310,y, 270, 47
		else
		DrawBox 310,y, 270, 47
		end if
		'end TOTAL DETAILS
		'PAYMENTS
		DrawBox 20,764, 270, 70
		'end PAYMENTS
		'CUST SIG
		DrawBox 310,764, 270, 70
		'end CUST SIG
		
		
		
		PDF.AddHTML "<p align=""right""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
		
		
		
		PDF.SetFont "F15", 16, "#999"
		PDF.AddTextPos 230, 30, "Delivery Note"
		PDF.SetFont "F15", 12, "#999"
		PDF.AddTextPos 230, 50, "Order No. " & rs("order_number")
		PDF.SetFont "F15", 10, "#999"
		
		If rs("bookeddeliverydate")<>"" then
		PDF.AddHtmlPos 20, 15, "Delivery Date: <b>" & FormatDateTime(rs("bookeddeliverydate"),vbShortDate) & "</b>"
		else
		PDF.AddHtmlPos 20, 15, "Ex-Works Date: " & shipmentdate
		end if
		
		
		PDF.AddHtmlPos 20, 30, "Delivery Time:<b> " & deltime & "</b>"
		PDF.AddHtmlPos 20, 45, "Delivered by: <b>" & deliveredby & "</b>"
		
		PDF.SetFont "F15", 9, "#999"
		PDF.AddTextPos 20, 72, "Showroom: " & showroomaddress
		PDF.AddTextPos 20, 83, showroomtelemail
		PDF.AddHTML "<br /><hr>"
		PDF.AddHTMLPos 25, 69, s
		
		
		PDF.AddHTMLPos 25, 85, "<img src=""images/whitebg.png"" width=""95"" height=""16"">"
		PDF.AddHTMLPos 287, 85, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
		z=190
		If mattresspicked="y" then
			PDF.AddHTMLPos 25, z, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
			z=z+55
		end if
		if basepicked="y" then
			PDF.AddHTMLPos 25, z, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
			z=z+55
		end if
		if legspicked="y" then
			PDF.AddHTMLPos 25, z, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
			z=z+55
		end if
		if topperpicked="y" then
			PDF.AddHTMLPos 25, z, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
			z=z+55
		end if
		if valancepicked="y" then
			PDF.AddHTMLPos 25, z, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
			z=z+55
		end if
		if headboardpicked="y" then
			PDF.AddHTMLPos 25, z, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"
			z=z+55
		end if
		z=z+10
		PDF.AddHTMLPos 25, z, "<img src=""images/whitebg.png"" width=""130"" height=""16"">"
		PDF.AddHTMLPos 25, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"
		PDF.AddHTMLPos 315, 753, "<img src=""images/whitebg.png"" width=""170"" height=""16"">"
		
		PDF.AddTextPos 33, 97, "Client Details"
		prodno=199
		If mattresspicked="y" then
			prodno=199
			PDF.AddTextPos 33, prodno, "Mattress"
			prodno=prodno+55
		end if
		if basepicked="y" then
			PDF.AddTextPos 33, prodno, "Base"
			prodno=prodno+55
		end if
		if legspicked="y" then
			PDF.AddTextPos 33, prodno, "Legs"
			prodno=prodno+55
		end if
		if topperpicked="y" then
			PDF.AddTextPos 33, prodno, "Topper"
			prodno=prodno+55
		end if
		if valancepicked="y" then
			PDF.AddTextPos 33, prodno, "Valance"
			prodno=prodno+55
		end if
		if headboardpicked="y" then
			PDF.AddTextPos 33, prodno, "Headboard"
			prodno=prodno+55
		end if
		prodno=prodno+10
		PDF.AddTextPos 33, prodno, "ITEMS TO FOLLOW"
		PDF.AddTextPos 33, 767, "Customer's Signature"
		
		PDF.AddTextPos 323, 767, "Customer's Signature"
		
		
		PDF.AddTextPos 295, 97, "Delivery Address"
		PDF.SetFont "F15", 8, "#999"
		PDF.AddHTMLPos 535, 190, "<font family=""Tahoma""><font size=""10""><b>TOTALS</b></font></font>"
		itempicked=189
		If mattresspicked="y" then
			PDF.AddHTMLPos 33, itempicked, str1	
			itempicked=itempicked+55
		end if
		If basepicked="y" then
			PDF.AddHTMLPos 33, itempicked, str10
			itempicked=itempicked+55
		end if
		If legspicked="y" then
			PDF.AddHTMLPos 33, itempicked, str11
			itempicked=itempicked+55
		end if
		If topperpicked="y" then
			PDF.AddHTMLPos 33, itempicked, str12
			itempicked=itempicked+55
		end if
		If valancepicked="y" then
			PDF.AddHTMLPos 33, itempicked, str13
			itempicked=itempicked+55
		end if
		If headboardpicked="y" then
			PDF.AddHTMLPos 33, itempicked, str14
			itempicked=itempicked+55
		end if
		prodno=prodno+10
		
		
		PDF.SetFont "F15", 8, "#999"
		PDF.SetProperty csPropAddTextWidth , 2
		PDF.AddTextWidth 33,prodno,490, tobedelivered
		
		
		
		If accessoriespicked="y" then
		PDF.AddHTMLPos 320, prodno, "<b>Bed Set Total</b>"
		PDF.AddHTMLPos 550, prodno, "<b>" & itemcount & "</b>"
		prodno=prodno+12
		PDF.AddHTMLPos 320, prodno, "<b>Accessories Total (see next page)</b>"
		PDF.AddHTMLPos 550, prodno, "<b>" & accessoryqtysum & "</b>"
		prodno=prodno+34
		PDF.AddHTMLPos 320, prodno, "<b>TOTAL ITEMS DELIVERED</b>"
		prodno=prodno-20
		PDF.AddHTMLPos 550, prodno, "<b>" & itemcount + accessoryqtysum & "</b>"
		else
		prodno=prodno-10
		if str15<>"" then 
		PDF.AddHTMLPos 320, prodno, str15
		itemcount=itemcount+1
		prodno=prodno+15
		end if
		PDF.AddHTMLPos 320, prodno, "<b>TOTAL ITEMS DELIVERED</b>"
		PDF.AddHTMLPos 550, prodno, "<b>" & itemcount & "</b>"
		end if
		prodno=prodno+35
		PDF.AddHTMLPos 320, prodno, "<table width=""600""><tr><td width=""300""></td><td><b>DELIVERY INSTRUCTIONS: </b> <br />" & Utf8ToUnicode(rs("specialinstructionsdelivery")) & "</td></tr></table>"
		
		PDF.SetProperty csPropAddTextWidth , 2
		PDF.AddTextWidth 30,720,260, "I have requested that this item should not be assembled or installed today.  I understand that if I request assembly in the future that this will incur an assembly charge."
		PDF.AddTextWidth 310,720,270, "No claim in respect of any loss or damage to goods in transit or any shortage on delivery will be accepted unless the Customer shall have notified the Company in writing of such loss, damage or shortage within three days of delivery."
		
		PDF.AddHTMLPos 30, 785, "<font family=""Tahoma""><font size=""8"">Print Name:</font></font>"
		PDF.AddHTMLPos 30, 800, "<font family=""Tahoma""><font size=""8"">Company:</font></font>"
		PDF.AddTextPos 30, 820, "......................................................................................................."
		If rs("bookeddeliverydate")<>"" then 
		PDF.AddTextPos 130, 828, FormatDateTime(rs("bookeddeliverydate"),vbShortDate)
		end if
		
		PDF.AddHTMLPos 320, 785, "<font family=""Tahoma""><font size=""8"">Print Name:</font></font>"
		PDF.AddHTMLPos 320, 800, "<font family=""Tahoma""><font size=""8"">Company:</font></font>"
		PDF.AddTextPos 320, 820, "......................................................................................................." 
		If rs("bookeddeliverydate")<>"" then 
		PDF.AddTextPos 420, 828, FormatDateTime(rs("bookeddeliverydate"),vbShortDate)
		end if
		
		
end if

'ACCESSORIES ONLY SECTION
if accreccount>0 then
PDF.AddPage
DrawBox 20,93, 250, 95
		
		DrawBox 280,93, 250, 95

'DrawBox 400,96, 180, 95

DrawBox 20,200, 560, 405

DrawBox 20,754, 270, 80

DrawBox 310,754, 270, 80


PDF.SetFont "F15", 12, "#999"
PDF.AddHTML "<p align=""right""><img src=""images/logo.gif"" width=""255"" height=""66""></p>"
PDF.AddTextPos 20, 20, "Order No. " & rs("order_number")
PDF.SetFont "F15", 16, "#999"
PDF.AddTextPos 230, 30, "Delivery Note"
PDF.SetFont "F15", 10, "#999"
If rs("bookeddeliverydate")<>"" then
		PDF.AddHtmlPos 20, 30, "Delivery Date: <b>" & FormatDateTime(rs("bookeddeliverydate"),vbShortDate) & "</b>"
		else
		PDF.AddHtmlPos 20, 30, "Ex-Works Date: "
		end if
PDF.AddHtmlPos 20, 40, "Delivery Time: " & deltime
PDF.AddHtmlPos 20, 57, "Showroom: " & showroomaddress
PDF.AddHtmlPos 20, 70, "Showroom: " & showroomtelemail

PDF.AddHTML s

'PDF.AddHTML s
'PDF.AddHTMLPos -20, -20, s

PDF.AddHTMLPos 25, 91, "<img src=""images/whitebg.png"" width=""95"" height=""16"">"
'PDF.AddHTMLPos 215, 92, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 290, 91, "<img src=""images/whitebg.png"" width=""125"" height=""16"">"
PDF.AddHTMLPos 25, 192, "<img src=""images/whitebg.png"" width=""90"" height=""16"">"


PDF.AddTextPos 30, 98, "Client Details"
PDF.AddTextPos 296, 98, "Delivery Address"
PDF.AddTextPos 33, 205, "Accessories"



PDF.AddHTML xacc
exportinclude=""
if rs("accessoriesrequired")="y" then
	if bookeddeliverydate="" then
			
			sql="SELECT * FROM exportlinks where purchase_no=" & purchase_no & " and componentid=9 and linkscollectionid=" & shipmentexportid
			Set rs3 = getMysqlUpdateRecordSet(sql, con)
			if NOT rs3.eof then
				exportinclude="y"
				else
				exportinclude="n"
			end if
			rs3.close
			set rs3=nothing
	end if
	if exportinclude="y" or bookeddeliverydate<>"" then
	PDF.AddHTML "<table width=""600""><tr><td width=""365"" align=""right""></td><td><b>TOTAL ACCESSORIES DELIVERED: </b> " & accessoryqtysum & "</td></tr></table>"
	PDF.AddHTML xacconorder
	PDF.AddHTML "<table width=""600""><tr><td width=""365"" align=""right""></td><td><b>TOTAL ACCESSORIES TO FOLLOW: </b> " & accessoryqtysumtofollow & "</td></tr></table>"
	else
	PDF.AddHTML "<table width=""600""><tr><td width=""365"" align=""right""></td><td><b>TOTAL ACCESSORIES TO FOLLOW: </b> " & accessoryqtysumtofollow + accessoryqtysum & "</td></tr></table>"
	end if
end if
PDF.AddHTMLPos 25, 750, "<img src=""images/whitebg.png"" width=""160"" height=""16"">"
PDF.AddHTMLPos 316, 750, "<img src=""images/whitebg.png"" width=""160"" height=""16"">"
PDF.AddHTMLPos 30, 748, "Customer's Signature"
PDF.AddHTMLPos 320, 748, "Customer's Signature"


PDF.SetFont "F15", 8, "#999"
PDF.AddHTMLPos 320, 600, "<table width=""600""><tr><td width=""290""></td><td><b>DELIVERY INSTRUCTIONS: </b> <br />" & Utf8ToUnicode(rs("specialinstructionsdelivery")) & "</td></tr></table>"
		
		PDF.SetProperty csPropAddTextWidth , 2
		PDF.AddTextWidth 30,705,260, "I have requested that this item should not be assembled or installed today.  I understand that if I request assembly in the future that this will incur an assembly charge."
		PDF.AddTextWidth 310,705,270, "No claim in respect of any loss or damage to goods in transit or any shortage on delivery will be accepted unless the Customer shall have notified the Company in writing of such loss, damage or shortage within three days of delivery."
		
		PDF.AddHTMLPos 30, 785, "<font family=""Tahoma""><font size=""8"">Print Name:</font></font>"
		PDF.AddHTMLPos 30, 800, "<font family=""Tahoma""><font size=""8"">Company:</font></font>"
		PDF.AddTextPos 30, 820, "......................................................................................................."
		If rs("bookeddeliverydate")<>"" then 
		PDF.AddTextPos 130, 828, FormatDateTime(rs("bookeddeliverydate"),vbShortDate)
		end if
		
		PDF.AddHTMLPos 320, 785, "<font family=""Tahoma""><font size=""8"">Print Name:</font></font>"
		PDF.AddHTMLPos 320, 800, "<font family=""Tahoma""><font size=""8"">Company:</font></font>"
		PDF.AddTextPos 320, 820, "......................................................................................................." 
		If rs("bookeddeliverydate")<>"" then 
		PDF.AddTextPos 420, 828, FormatDateTime(rs("bookeddeliverydate"),vbShortDate)
		end if
		


end if
'END ACCESSORIES ONLY SECTION


PDF.BinaryWrite
set pdf = nothing
rs1.close
rs.close

set rs1=nothing
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
