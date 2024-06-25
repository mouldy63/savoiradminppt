<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="pricematrixfuncs.asp" -->
<%
dim purchase_no, quote, contact_no, con, rs, prod, order, msg, sql
Dim mattdel, basedel, valancedel, topperdel, legsdel, hbdel, accdel


mattdel=request("mattdel")
basedel=request("basedel")
valancedel=request("valancedel")
topperdel=request("topperdel")
legsdel=request("legsdel")
hbdel=request("hbdel")
accdel=request("accdel")
purchase_no=Request("purchase_no")
order=Request("purchase_no")
if mattdel="y" or basedel="y" or valancedel="y" or topperdel="y" or legsdel="y" or hbdel="y" or accdel="y" then
msg="Items deleted from order"
else
msg="No items were deleted"
end if

' get customer contact_no
Set Con = getMysqlConnection()
Set rs = getMysqlUpdateRecordSet("select * from purchase where purchase_no=" & purchase_no, con)
    if mattdel="y" then
			rs("mattressrequired")="n"
			rs("savoirmodel")=null
			rs("mattresstype")=null
			rs("tickingoptions")=null
			rs("mattresswidth")=null
			rs("mattresslength")=null
			rs("leftsupport")=null
			rs("rightsupport")=null
			rs("ventfinish")=null
			rs("ventposition")=null
			rs("mattressinstructions")=null
			rs("mattressprice")=null
			call deleteComponentQcHistory(con, 1, order) ' just in case a mattress has been removed from the order
			call clearProductionSizes(con, 1, order)
			call deleteDiscount(con, order, 1)
			call deleteExportData(con, 1, order)
			call deletePackagingData(con, 1, order)
	end if
	
	'TOPPER
	if topperdel="y" then
			rs("topperrequired")="n"
			rs("toppertype")=null
			rs("topperwidth")=null
			rs("topperlength")=null
			rs("toppertickingoptions")=null
			rs("specialinstructionstopper")=null
			rs("topperprice")=null
			call deleteComponentQcHistory(con, 5, order) ' just in case a topper has been removed from the order
			call clearProductionSizes(con, 5, order)
			call deleteDiscount(con, order, 5)
			call deleteExportData(con, 5, order)
			call deletePackagingData(con, 5, order)
			end if
	
	'BASE
	if basedel="y" then
				rs("baserequired")="n"
			rs("basesavoirmodel")=null
			rs("basetype")=null
			rs("basewidth")=null
			rs("baselength")=null
			rs("linkposition")=null
			rs("linkfinish")=null
			rs("baseinstructions")=null
			rs("basefabriccost")=null
			rs("basefabricmeters")=null
			rs("basefabricprice")=null
			rs("basefabricdesc")=null
			rs("baseprice")=null
			rs("upholsteredbase")=null
			rs("basefabric")=null
			rs("basefabricchoice")=null
			rs("basefabricdirection")=null
			rs("upholsteryprice")=null
			rs("basetrimprice")=null
			rs("basedrawersprice")=null
			rs("extbase")=null
			rs("basedrawerheight")=null
			rs("basetickingoptions")=null
			rs("baseheightspring")=null
			rs("basedrawers")=null
			rs("basedrawerconfigid")=null
			rs("basetrim")=null
			rs("basetrimcolour")=null
			call deleteComponentQcHistory(con, 3, order) ' just in case a base has been removed from the order
			call clearProductionSizes(con, 3, order)
			call deleteDiscount(con, order, 3)
			call deleteDiscount(con, order, 11)
			call deleteDiscount(con, order, 12)
			call deleteExportData(con, 3, order)
			call deletePackagingData(con, 3, order)
	end if
	'LEGS
	if legsdel="y" then
			rs("legsrequired")="n"
			rs("floortype")=null
			rs("legstyle")=null
			rs("legfinish")=null
			rs("legheight")=null
			rs("legprice")=null
			rs("specialinstructionslegs")=null
			rs("legqty")=0
			rs("addlegqty")=0
			call deleteComponentQcHistory(con, 7, order) ' just in case legs have been removed from the order
			call deleteDiscount(con, order, 7)
			call deleteExportData(con, 7, order)
			call deletePackagingData(con, 7, order)
	end if
	
	'HEADBOARD
	if hbdel="y" then
				rs("headboardrequired")="n"
			rs("hbfabriccost")=null
			rs("hbfabricmeters")=null
			rs("hbfabricprice")=null
			rs("headboardstyle")=null
			rs("headboardfabric")=null
			rs("headboardfabricchoice")=null
			rs("headboardheight")=null
			rs("headboardwidth")=null
			rs("headboardfinish")=null
			rs("manhattantrim")=null
			rs("specialinstructionsheadboard")=null
			rs("headboardprice")=null
			rs("headboardfabricdesc")=null
			rs("headboardfabricdirection")=null
			rs("hbfabricoptions")=null
			rs("headboardlegqty")=null
			call deleteComponentQcHistory(con, 8, order) ' just in case the headboard has been removed from the order
			call deleteDiscount(con, order, 8)
			call deleteExportData(con, 8, order)
			call deletePackagingData(con, 8, order)
	end if
	
	'VALANCe
	if valancedel="y" then
			rs("valancerequired")="n"
			rs("valfabriccost")=null
			rs("valfabricmeters")=null
			rs("valfabricprice")=null
			rs("pleats")=null
			rs("valancefabric")=null
			rs("valancefabricchoice")=null
			rs("specialinstructionsvalance")=null
			rs("valanceprice")=null
			rs("valancefabricdirection")=null
			rs("valancewidth")=null
			rs("valancelength")=null
			rs("valancedrop")=null
			rs("valancefabricoptions")=null
			call deleteComponentQcHistory(con, 6, order) ' just in case the valance has been removed from the order
			call deleteExportData(con, 6, order)
			call deletePackagingData(con, 6, order)
	end if
	
	'ACCESSORIES
	if accdel="y" then
			rs("accessoriesrequired")="n"
			rs("accessoriestotalcost") = 0.0
			sql = "delete from orderaccessory where purchase_no=" & order
			con.execute(sql)
			call deleteComponentQcHistory(con, 9, order)
			call deleteExportData(con, 9, order)
			call deletePackagingData(con, 9, order)
   end if
   
rs.update
rs.close
set rs = nothing
con.close
set con = nothing
response.redirect("ordercomplete.asp?msg=" & msg & "&val=" & purchase_no)
%>

<!-- #include file="common/logger-out.inc" -->
