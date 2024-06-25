<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = False
Server.ScriptTimeout =832900%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype, notes, bookeddeliverydate, contactno, matt1width, matt2width, matt1length, matt2length, base1width, base2width, base1length, base2length, basedrawerconfigid, mattinstructions, topperinstructions, speclegheight, ordertype

msg=""



if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
sql="select * from purchase P where code=261187"
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
contactno=""

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Order Source,Completed Order,Sales Username,Customer Ref,Order No,Order Date,Mattress Model,Ticking,Mattress Width,Mattress Length,Special mattress 1 width,Special mattress 2 width,Special mattress 1 length,Special mattress 2 length,Left Support,Right Support,Vent Position,Vent Finish,Mattress Instructions,Mattress Price,Topper Type,Topper Width,Topper Length,Topper Ticking,Topper instructions,Base Model,Base Type,Base Depth,Base Width,Base Length,Special Base 1 width,Special Base 2 width,Special Base 1 length,Special Base 2 length,Base Drawers,Base Drawer Config,Drawer Height,Drawer Price,Drawer Qty,Drawer Total,Base Spring Height,Base Ticking,Leg Style,Leg Position,Leg Finish,Leg Shape,Leg Height,Special Leg Height,Leg Qty,Additional Leg Qty,Additional Leg Style,Additional Leg Finish,Special Instructions Legs,Floor Type,Link Position,Link Finish,Base Instructions,Base Price,Base Trim,Base Trim Colour,Base Trim Price,Base Drawers Price,Ext Base,Base Fabric Meters,Base Fabric Cost,Base Fabric Price,Leg Unit Price,Leg Price,Additional Leg Price,Upholstered Base,Base Fabric,Base Fabric Choice,Base Fabric Description,Base Fabric Direction,Upholstered Unit Price,Upholstery Price,Headboard Style,Headboard Fabric,Headboard Fabric Choice,Headboard Height,Headboard Width,Headboard Fabric Desc,Headboard Finish,Headboard Fabric Direction,Headboard Fabric Options,Headboard Fabric Meters,Headboard Fabric Price,Headboard Fabric Cost,Headboard Leg Qty,Headboard Leg Height,Headboard Unit Price,Headboard Special Instructions,Headboard Price,Headboard Trim Price,Manhattan Trim,Footboard Height,Footboard Finish,Pleats,Valance Fabric,Valance Fabric Choice,Valance Fabric Description,Valance Fabric Direction,Valance Fabric Options,Valance Fabric Meters,Valance Fabric Price,Valance Fabric Cost,Valance Width,Valance Length,Valance Drop,Special Valance Instructions,Valance Price,Special Delivery Instructions,Delivery Price,Order Currency,Bedset Total,Discount,Discount type,Total,Order on Hold,Order Type,Quote,Total Ex VAT,VAT,VAT Rate,Is Trade,Trade Discount,Old Bed,Access Check,Cancelled,Accessories")
Do until rs.eof
matt1width=""
matt2width=""
matt1length=""
matt2length=""
base1width=""
base2width=""
base1length=""
base2length=""
if rs("mattresswidth")="Special Width" or rs("mattresslength")="Special Length" then
sql="select * from productionsizes where purchase_no=" & rs("purchase_no")
Set rs1 = getMysqlQueryRecordSet(sql, con)
if not rs1.eof then
matt1width=rs1("matt1width")
matt2width=rs1("matt2width")
matt1length=rs1("matt1length")
matt2length=rs1("matt2length")
end if
rs1.close
set rs1=nothing 
end if
if rs("basewidth")="Special Width" or rs("baselength")="Special Length" then
sql="select * from productionsizes where purchase_no=" & rs("purchase_no")
Set rs1 = getMysqlQueryRecordSet(sql, con)
if not rs1.eof then
base1width=rs1("base1width")
base2width=rs1("base2width")
base1length=rs1("base1length")
base2length=rs1("base2length")
end if
rs1.close
set rs1=nothing 
end if
basedrawerconfigid=""
if rs("basedrawerconfigid")<>"" and rs("basedrawerconfigid")<>"n" then
sql="select * from drawerconfig where drawerconfigid=" & rs("basedrawerconfigid")
Set rs1 = getMysqlQueryRecordSet(sql, con)
if not rs1.eof then
basedrawerconfigid=rs1("drawerconfig")
end if
rs1.close
set rs1=nothing 
end if
mattinstructions=""
if rs("mattressinstructions") <> "" then
mattinstructions=rs("mattressinstructions")
mattinstructions=Replace(mattinstructions,chr(34),"in")
end if
topperinstructions=""
if rs("specialinstructionstopper") <> "" then
topperinstructions=rs("specialinstructionstopper")
topperinstructions=Replace(topperinstructions,chr(34),"in")
end if
speclegheight=""
if rs("legheight")="Special (as instructions)" or rs("legheight")<>"Special Height" then
sql="select * from productionsizes where purchase_no=" & rs("purchase_no")
Set rs1 = getMysqlQueryRecordSet(sql, con)
if not rs1.eof then
speclegheight=rs1("legheight")
end if
rs1.close
set rs1=nothing 
end if
accsummary=""
if rs("accessoriesrequired")="y" then
		sql3="select * from orderaccessory where purchase_no=" & rs("purchase_no") & ""
		Set rs1 = getMysqlQueryRecordSet(sql3, con)
		if not rs1.eof then
			do until rs1.eof
			accsummary=accsummary & rs1("description") & ", "
			if rs1("design") <> "" then
			accsummary=accsummary & "Design: " & rs1("design") & ", "
			end if
			if rs1("colour") <> "" then
			accsummary=accsummary & "Colour: " & rs1("colour") & ", "
			end if
			if rs1("size") <> "" then
			accsummary=accsummary & "Size: " & rs1("size") & ", "
			end if
			if rs1("unitprice") <> "" then
			accsummary=accsummary & "Unit Price: " & rs1("unitprice") & ", "
			end if
			if rs1("qty") <> "" then
			accsummary=accsummary & "Qty: " & rs1("qty") & ", "
			end if
			if rs1("delivered") <> "" then
			accsummary=accsummary & "Delivered: " & rs1("delivered") & ", "
			end if
			rs1.movenext
			loop
		end if
		rs1.close
		set rs1=nothing
		if len(accsummary)>2 then
		accsummary=left(accsummary,len(accsummary)-2)
		end if
	end if

ordertype=""
if rs("ordertype")<>"" then
sql="select * from ordertype where ordertypeid=" & rs("ordertype")
Set rs1 = getMysqlQueryRecordSet(sql, con)
if not rs1.eof then
ordertype=rs1("ordertype")
end if
rs1.close
set rs1=nothing 
end if


excelLine = """" & rs("orderSource") & """,""" & rs("completedorders") & """,""" & rs("salesusername") & """,""" & rs("customerreference") & """,""" & rs("order_number") & """,""" & rs("order_date") & """,""" & rs("savoirmodel") & """,""" & rs("tickingoptions") & """,""" & rs("mattresswidth") & """,""" & rs("mattresslength") & """,""" & matt1width & """,""" & matt2width & """,""" & matt1length & """,""" & matt1length & """,""" & rs("leftsupport") & """,""" & rs("rightsupport") & """,""" & rs("ventposition") & """,""" & rs("ventfinish") & """,""" & mattinstructions & """,""" & rs("mattressprice") & """,""" & rs("toppertype") & """,""" & rs("topperwidth") & """,""" & rs("topperlength") & """,""" & rs("toppertickingoptions") & """,""" & topperinstructions & """,""" & rs("basesavoirmodel") & """,""" & rs("basetype") & """,""" & rs("basedepth") & """,""" & rs("basewidth") & """,""" & rs("baselength") & """,""" & base1width & """,""" & base2width & """,""" & base1length & """,""" & base1length & """,""" & rs("basedrawers") & """,""" & basedrawerconfigid & """,""" & rs("basedrawerheight") & """,""" & rs("drawerprice") & """,""" & rs("drawerqty") & """,""" & rs("drawertotal") & """,""" & rs("baseheightspring") & """,""" & rs("basetickingoptions") & """,""" & rs("legstyle") & """,""" & rs("legposition") & """,""" & rs("legfinish") & """,""" & rs("legshape") & """,""" & rs("legheight") & """,""" & speclegheight & """,""" & rs("legqty") & """,""" & rs("addlegqty") & """,""" & rs("addlegstyle") & """,""" & rs("addlegfinish") & """,""" & rs("specialinstructionslegs") & """,""" & rs("floortype") & """,""" & rs("linkposition") & """,""" & rs("linkfinish") & """,""" & rs("baseinstructions") & """,""" & rs("baseprice") & """,""" & rs("basetrim") & """,""" & rs("basetrimcolour") & """,""" & rs("basetrimprice") & """,""" & rs("basedrawersprice") & """,""" & rs("extbase") & """,""" & rs("basefabricmeters") & """,""" & rs("basefabriccost") & """,""" & rs("basefabricprice") & """,""" & rs("legunitprice") & """,""" & rs("legprice") & """,""" & rs("addlegprice") & """,""" & rs("upholsteredbase") & """,""" & rs("basefabric") & """,""" & rs("basefabricchoice") & """,""" & rs("basefabricdesc") & """,""" & rs("basefabricdirection") & """,""" & rs("uphunitprice") & """,""" & rs("upholsteryprice") & """,""" & rs("headboardstyle") & """,""" & rs("headboardfabric") & """,""" & rs("headboardfabricchoice") & """,""" & rs("headboardheight") & """,""" & rs("headboardwidth") & """,""" & rs("headboardfabricdesc") & """,""" & rs("headboardfinish") & """,""" & rs("headboardfabricdirection") & """,""" & rs("hbfabricoptions") & """,""" & rs("hbfabricmeters") & """,""" & rs("hbfabricprice") & """,""" & rs("hbfabriccost") & """,""" & rs("headboardlegqty") & """,""" & rs("hblegheight") & """,""" & rs("headboardunitprice") & """,""" & rs("specialinstructionsheadboard") & """,""" & rs("headboardprice") & """,""" & rs("headboardtrimprice") & """,""" & rs("manhattantrim") & """,""" & rs("footboardheight") & """,""" & rs("footboardfinish") & """,""" & rs("pleats") & """,""" & rs("valancefabric") & """,""" & rs("valancefabricchoice") & """,""" & rs("valancefabricdesc") & """,""" & rs("valancefabricdirection") & """,""" & rs("valancefabricoptions") & """,""" & rs("valfabricmeters") & """,""" & rs("valfabricprice") & """,""" & rs("valfabriccost") & """,""" & rs("valancewidth") & """,""" & rs("valancelength") & """,""" & rs("valancedrop") & """,""" & rs("specialinstructionsvalance") & """,""" & rs("valanceprice") & """,""" & rs("specialinstructionsdelivery") & """,""" & rs("deliveryprice") & """,""" & rs("ordercurrency") & """,""" & rs("bedsettotal") & """,""" & rs("discount") & """,""" & rs("discounttype") & """,""" & rs("total") & """,""" & rs("orderonhold") & """,""" & ordertype & """,""" & rs("quote") & """,""" & rs("totalexvat") & """,""" & rs("vat") & """,""" & rs("vatrate") & """,""" & rs("istrade") & """,""" & rs("tradediscount") & """,""" & rs("oldbed") & """,""" & rs("accesscheck") & """,""" & rs("cancelled") & """,""" & accsummary & """"
	
	tempfile.WriteLine(excelLine)
	notes=""

rs.movenext
loop
rs.close
set rs=nothing

tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""datadump.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing
Con.Close
Set Con = Nothing
end if
%>
  
<!-- #include file="common/logger-out.inc" -->
