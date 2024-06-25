<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="generalfuncs.asp" -->
<%dim orderexists, Con, rs, rs4, sql, rs1, totalpn, id, items, location, exportlinksid, collectionid, loc, shipperid
dim pnarray(), count, GBPshipmenttotalcost, EURshipmenttotalcost, USDshipmenttotalcost, currencyno, wholesaleinv, wholesaleinvno
Dim totalexportcost
currencyno=1
wholesaleinv="n"
GBPshipmenttotalcost=0
EURshipmenttotalcost=0
USDshipmenttotalcost=0
count = 0
id=request("id")
location=request("location")
Set Con = getMysqlConnection()




%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">

<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script src="common/jquery.js" type="text/javascript"></script>
<script src="scripts/keepalive.js"></script>

</head>

<body>
<div class="container">
<!-- #include file="header.asp" -->
<%sql="SELECT * from exportcollections E, location L, shipper_address S, collectionStatus C, exportCollShowrooms T where  T.idlocation=L.idlocation AND T.idlocation=" & location & " and E.shipper=S.shipper_address_id AND C.collectionStatusID=E.collectionStatus AND  T.exportCollectionID=" & id & " and E.exportcollectionsid=T.exportCollectionid order by CollectionDate"



Set rs = getMysqlQueryRecordSet(sql, con)
collectionid=rs("exportcollectionsid")
loc=rs("idlocation")
shipperid=rs("shipper_address_id")
'response.write(sql)
%>
<table width="100%" border="0" align="center" cellpadding="5" cellspacing="0">
<tr valign="top">
<td width="647" class="maintext">

<%if retrieveUserLocation()=1 or retrieveUserLocation()=27  or retrieveUserRegion > 1 then
'response.Write(retrieveUserLocation())%>

<h1>Shipment Details</h1>
<table width="99%" border="0" align="center" cellpadding="2" cellspacing="2">
<tr>
<td>Country</td>
<td>Collection Date</td>
<td>ETA Date</td>
<td>Shipper</td>
<td>Transport Mode</td>
<td>Container Ref.</td>
<td>Qty. of Orders</td>
<td>Status</td>
<td>Manifest</td>
</tr>
<tr>
<td colspan="9"><hr></td>
</tr>
</tr>
<tr>
<td><%=rs("location")%></td>
<td><%=rs("collectiondate")%></td>
<td><%=rs("etadate")%></td>
<td><%=rs("shippername")%></td>
<td><%=rs("transportmode")%></td>
<td><%=rs("containerref")%></td>
<%if retrieveUserLocation()=1 or retrieveUserLocation()=27 then
sql="SELECT distinct purchase_no, linksCollectionid from exportlinks E, exportCollShowrooms S where  E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & rs("exportCollectionsID") & " AND S.idlocation=" & location & " and orderConfirmed='y'"
else
sql="SELECT distinct E.purchase_no, linksCollectionid from exportlinks E, exportCollShowrooms S, Purchase P where  E.LinksCollectionID=S.exportCollshowroomsID and E.purchase_no=P.purchase_no AND S.exportCollectionID=" & rs("exportCollectionsID") & " AND S.idlocation=" & location & " AND orderConfirmed='y'"

end if

'response.Write(sql)
Set rs1 = getMysqlQueryRecordSet(sql, con)

if rs1.eof then
totalpn=0
else
exportlinksid=rs1("LinksCollectionID")

totalpn=rs1.recordcount
while not rs1.eof
count = count + 1
redim preserve pnarray(count)
pnarray(count)=rs1("purchase_no")
rs1.movenext
wend
end if
rs1.close
set rs1=nothing%>
<td><%if totalpn<>0 then%>
<%=totalpn%>
<%else%>
<%=totalpn%>
<%end if%>&nbsp;</td>
<td><%=rs("collectionStatusName")%></td>
<td><a href="/php/commercialmanifest.pdf?sid=<%=shipperid%>&cid=<%=collectionid%>&loc=<%=loc%>&eta=<%=rs("etadate")%>" target="_blank">Print</a></td>
</tr>
<%
rs.close
set rs=nothing%>
</table>
<p>&nbsp;</p>
<%end if%>

<hr />

<h1>Order Details</h1>
<table width="99%" border="0" align="center" cellpadding="0" cellspacing="3">
  <tr>
    <td valign="bottom"><b>Surname</b></td>
    <td valign="bottom"><b>Order</b></td>
    <td valign="bottom"><b>Invoice No.</b></td>
    <td valign="bottom"><b>Company Name</b></td>
    <td valign="bottom"><b>Customer Ref.</b></td>
    <td valign="bottom"><b>Mat spec</b></td>
    <td valign="bottom"><b>Base Spec</b></td>
    <td valign="bottom"><b>Topper Spec</b></td>
    <td valign="bottom"><b>Headboards Spec</b></td>
    <td valign="bottom"><b>Legs</b></td>
    <td valign="bottom"><b>Leg Colour</b></td>
    <td valign="bottom"><b>Valance</b></td>
    <td valign="bottom"><b>Accessories</b></td>
    <%if NOT userHasRoleInList("NOPRICESUSER") then
	'if (retrieveuserid()<>181 and retrieveuserid()<>182) then%>
    <td align="right" valign="bottom"><b>Total<br />Export<br />Value</b></td>
    <%end if%>
     <td align="right" valign="bottom"><b>Items</b></td>
      <td valign="bottom" align="right"><b>Commercial Invoice</b></td>
      <td valign="bottom" align="right"><b>Wholesale Invoice No.</b></td>
  </tr>
  <tr><td colspan="14"></td></tr>
<%
if count>0 then
for n = 1 to ubound(pnarray)
sql="SELECT * from exportLinks where LinksCollectionID=" & exportlinksid & " and purchase_no=" & pnarray(n)
'response.Write(sql)
Set rs = getMysqlQueryRecordSet(sql, con)
items=rs.recordcount

totalexportcost=0
do until rs.eof

if rs("componentid")=1 then
	totalexportcost = totalexportcost + getComponentPrice(con, 1, pnarray(n))
sql="Select mattresstype, mattressprice from purchase where purchase_no=" & pnarray(n)
Set rs1 = getMysqlQueryRecordSet(sql, con)
if left(rs1("mattresstype"),3)="Zip" then items=items+1
	closers(rs1)
end if

if rs("componentid")=3 then
	totalexportcost = totalexportcost + getComponentPrice(con, 3, pnarray(n))
sql="Select basetype, baseprice, upholsteryprice, basefabricprice from purchase where purchase_no=" & pnarray(n)
Set rs1 = getMysqlQueryRecordSet(sql, con)
if (left(rs1("basetype"),3)="Eas" or left(rs1("basetype"),3)="Nor") then items=items+1
	closers(rs1)
end if

if rs("componentid")=5 then
	totalexportcost = totalexportcost + getComponentPrice(con, 5, pnarray(n))
end if

if rs("componentid")=6 then
	totalexportcost = totalexportcost + getComponentPrice(con, 6, pnarray(n))
end if

if rs("componentid")=7 then
	totalexportcost = totalexportcost + getComponentPrice(con, 7, pnarray(n))
end if

if rs("componentid")=8 then
	totalexportcost = totalexportcost + getComponentPrice(con, 8, pnarray(n))
end if

if rs("componentid")=9 then
	totalexportcost = totalexportcost + getComponentPrice(con, 9, pnarray(n))
end if

rs.movenext
loop
rs.close
set rs=nothing
'response.Write("items=" & items)

sql="SELECT * from purchase P, contact C, address A, exportLinks E where P.purchase_no=" & pnarray(n) & " and P.purchase_no=E.purchase_no AND E.LinksCollectionID=" & exportlinksid & " and P.contact_no=C.contact_no and A.code=P.code"

Set rs = getMysqlQueryRecordSet(sql, con)

if not rs.eof Then
%>


<tr>
<td valign="top"><%=rs("surname")%>&nbsp;</td>
<td valign="top"><%if retrieveUserLocation()=1 or retrieveUserLocation()=27 then%>
<a href="orderdetails.asp?pn=<%=pnarray(n)%>"><%=rs("order_number")%></a>
<%else%>
<a href="edit-purchase.asp?order=<%=pnarray(n)%>"><%=rs("order_number")%>
<%end if%>&nbsp;</td>
<td valign="top"><%=rs("invoiceNo")%>&nbsp;</td>
<td valign="top"><%=rs("company")%>&nbsp;</td>
<td valign="top"><%=rs("customerreference")%>&nbsp;</td>

    <td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 1))%>">
    <%=getSpecCellText(con, pnarray(n), 1, id, rs("savoirmodel"))%></span>&nbsp;</td>
    <td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 3))%>">
    <%=getSpecCellText(con, pnarray(n), 3, id, rs("basesavoirmodel"))%></span>&nbsp;</td>
    <td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 5))%>">
    <%=getSpecCellText(con, pnarray(n), 5, id, rs("toppertype"))%></span>&nbsp;</td>
    <td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 8))%>">
    <%=getSpecCellText(con, pnarray(n), 8, id, rs("headboardstyle"))%></span>&nbsp;</td>
    <td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 7))%>">
    <%=getSpecCellText(con, pnarray(n), 7, id, rs("legstyle"))%></span>&nbsp;</td>
    <td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 7))%>">
    <%=getSpecCellText(con, pnarray(n), 7, id, rs("legfinish"))%></span>&nbsp;</td>
    <td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 6))%>">
    <%=getSpecCellText(con, pnarray(n), 6, id, rs("valancerequired"))%></span>&nbsp;</td>
    <td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 9))%>">
    <%=getSpecCellText(con, pnarray(n), 9, id, rs("accessoriesrequired"))%></span>&nbsp;</td>
    <%if NOT userHasRoleInList("NOPRICESUSER") then
	'if (retrieveuserid()<>181 and retrieveuserid()<>182) then%>
        <td align="right" valign="top">
        <%=fmtCurr2(totalexportcost, true, rs("ordercurrency"))%>
        <%if rs("total")<>"" and rs("total")<>"0" then 
        'response.Write("total=" & rs("total"))
        if rs("ordercurrency")="GBP" then
        GBPshipmenttotalcost=GBPshipmenttotalcost+totalexportcost
        elseif rs("ordercurrency")="EUR" then
        EURshipmenttotalcost=EURshipmenttotalcost+totalexportcost
        elseif rs("ordercurrency")="USD" then
        USDshipmenttotalcost=USDshipmenttotalcost+totalexportcost
        end if
    
        end if%>&nbsp;</td>
    <%end if%>
    <td align="right" valign="top"><%=items%>&nbsp;</td>
    <%Set rs4 = getMysqlQueryRecordSet("Select * from wholesale_prices where purchase_no=" & pnarray(n), con)
		if not rs4.eof then
		wholesaleinv="y"
		else
		wholesaleinv="n"
		end if
		rs4.close
		set rs4=nothing
		
		if wholesaleinv="y" then
			Set rs4 = getMysqlQueryRecordSet("Select * from wholesale_invoices where purchase_no=" & pnarray(n), con)
			if not rs4.eof then
				if isNull(rs4("wholesale_inv_no")) then
				wholesaleinvno="<font color=""red"">Missing</font>"
				else
				wholesaleinvno=rs4("wholesale_inv_no")
				end if
			else
			wholesaleinvno="<font color=""red"">Missing</font>"
			end if
			rs4.close
			set rs4=nothing
		else
		wholesaleinvno=""
		end if
		%>
    <td valign="top" align="right"> <a href="/php/CommercialInvoice.pdf?wholesale=n&sid=<%=shipperid%>&items=<%=items%>&loc=<%=loc%>&cid=<%=collectionid%>&pno=<%=pnarray(n)%>">Retail</a><%if wholesaleinv="y" then%>|<a href="/php/CommercialInvoice.pdf?wholesale=y&sid=<%=shipperid%>&items=<%=items%>&loc=<%=loc%>&cid=<%=collectionid%>&pno=<%=pnarray(n)%>">Wholesale</a><%end if%></td>
    <td valign="top" align="right"><%response.Write(wholesaleinvno)%></td>
  </tr>
<%end if
next

%>
<tr><td colspan="13"></td><td align="right"><hr><br>
<%if GBPshipmenttotalcost>0 then response.Write(fmtCurr2(GBPshipmenttotalcost, true, "GBP") & "<br>")
if EURshipmenttotalcost>0 then response.Write(fmtCurr2(EURshipmenttotalcost, true, "EUR") & "<br>")
if USDshipmenttotalcost>0 then response.Write(fmtCurr2(USDshipmenttotalcost, true, "USD") & "<br>")%></td><td colspan="2">&nbsp;</td></tr>
</table>
<%rs.close
set rs=nothing
end if
con.close
set con=nothing%>
</td>
    </tr>
    <tr>
      <td colspan="14"><hr>        
        &nbsp;&nbsp;Key<br>        <img src="images/colour-key.gif" width="229" height="151" alt=""></td></tr>
</table>
</div>

</body>
</html>

<%
function getSpecCellText(byref acon, aPn, aCompId, aCollectionId, aDefaultText)
	if exportCollectionIncludesComponent(acon, aPn, aCompId, aCollectionId) then
		getSpecCellText = aDefaultText
	else
		getSpecCellText = getCollectionDateForComponent(acon, aPn, aCompId)
	end if
end function

function getCollectionDateForComponent(byref acon, aPn, aCompId)
	dim asql, ars
	
	asql = "select e.collectiondate,e.exportcollectionsid, S.idlocation  from exportlinks l, exportcollections e, exportcollshowrooms S  where l.purchase_no=" & aPn & " and l.componentid=" & aCompId & " and l.linkscollectionid=S.exportCollshowroomsID and S.exportCollectionID=e.exportcollectionsid"
	'response.Write("sql" & asql)
	set ars = getMysqlQueryRecordSet(asql, acon)
	if not ars.eof then
		getCollectionDateForComponent = "<a href='shipment-details.asp?location=" & ars("idlocation") & "&id=" & ars("exportcollectionsid") & "'>" & ars("collectiondate") & "</a>"
	else
		getCollectionDateForComponent = ""
	end if
	call closemysqlrs(ars)
end function

function exportCollectionIncludesComponent(byref acon, aPn, aCompId, aCollectionId)
dim asql, ars
asql = "select * from exportlinks L, exportcollshowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & id & " and S.idlocation=" & loc & " and purchase_no=" & aPn & " and componentid=" & aCompId
set ars = getMysqlQueryRecordSet(asql, acon)
exportCollectionIncludesComponent = (not ars.eof)
call closemysqlrs(ars)
end function

function getLockColourForStatus(aStatus)

if aStatus = 20 then
getLockColourForStatus = "red" 'In Production
elseif aStatus = 30 then
getLockColourForStatus = "orange" ' Order on Stock, Waiting QC
elseif aStatus = 40 then
getLockColourForStatus = "green" ' QC Checked
elseif aStatus = 50 then
getLockColourForStatus = "green" ' In Bay
elseif aStatus = 60 then
getLockColourForStatus = "green" ' Order Picked
elseif aStatus = 70 then
getLockColourForStatus = "grey" ' Delivered
else
getLockColourForStatus = ""
end if

end function
%>
 
<!-- #include file="common/logger-out.inc" -->
