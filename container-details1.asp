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
<%dim orderexists, Con, rs, sql, rs1, rs3, rs4, totalpn, id, items, location, exportlinksid, collectionid, loc, shipperid
dim pnarray(), count, GBPshipmenttotalcost, EURshipmenttotalcost, USDshipmenttotalcost, currencyno, shipmentcount, madeat
Dim totalexportcost, orderno, deliveryterms, wholesaleinv, wholesaleinvno, addedby, updatedby, updatedbytext, updateddate
wholesaleinv="n"
shipmentcount=1
currencyno=1
GBPshipmenttotalcost=0
EURshipmenttotalcost=0
USDshipmenttotalcost=0
count = 0
id=request("id")
location=request("location")
addedby=""
updatedby=""
updateddate=""
updatedbytext=""
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
<%sql="SELECT * from exportcollections E, location L, shipper_address S, collectionStatus C, exportCollShowrooms T where  T.idlocation=L.idlocation and E.shipper=S.shipper_address_id AND C.collectionStatusID=E.collectionStatus AND  T.exportCollectionID=" & id & " and E.exportcollectionsid=T.exportCollectionid order by CollectionDate"	
		


Set rs3 = getMysqlQueryRecordSet(sql, con)
collectionid=rs3("exportcollectionsid")
addedby=rs3("Addedby")
updatedby=rs3("UpdatedBy")
updateddate=rs3("UpdatedDate")
shipperid=rs3("shipper_address_id")

'response.write(sql)

Set rs4 = getMysqlQueryRecordSet("Select * from savoir_user where user_id=" & addedby, con) 
		if not rs4.eof then
		addedby=rs4("username")
		end if
		rs4.close
		set rs4=nothing
		
if updatedby <> 0 then
Set rs4 = getMysqlQueryRecordSet("Select * from savoir_user where user_id=" & updatedby, con) 
		if not rs4.eof then
		updatedbytext=" |  Last updated on: " & Left(updateddate,10) & " by " & rs4("username")
		end if
		rs4.close
		set rs4=nothing
end if
%>
<table width="100%" border="0" align="center" cellpadding="5" cellspacing="0">

  <tr valign="top">
    <td width="647" class="maintext">
      <%Do until rs3.eof
	  loc=rs3("idlocation")
	  'response.Write("loc=" & loc)%>
        <%if retrieveUserLocation()=1 or retrieveUserLocation()=27  or retrieveUserRegion > 1 then
		'response.Write(retrieveUserLocation())%>
      
      <h1>Shipment Details</h1>
      
      <p>Created by : <%=addedby %> <%=updatedbytext %></p>
      <table width="99%" border="0" align="center" cellpadding="2" cellspacing="2">
        <tr>
          <td>Country</td>
          <td>Collection Date</td>
          <td>ETA Date</td>
          <%if shipmentcount=2 then%>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
         <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
         <td>&nbsp;</td>
         <td>&nbsp;</td>
         <td>&nbsp;</td>
          <%else%>
          <td>Terms of Delivery</td>
          <td>Shipper</td>
          <td>Destination Port</td>
          <td>Transport Mode</td>
          <td>Container Ref.</td>
          <td>Qty. of Orders</td>
          <td>Status</td>
         <td>Manifest</td>
         <%end if%>
        </tr>
         <tr>
          <td colspan="11"><hr></td>
          </tr>
          </tr>
        <%if rs3("ExportDeliveryTerms")<>0 then
		deliveryterms=""
		Set rs4 = getMysqlQueryRecordSet("Select * from deliveryterms where deliveryTermsID=" & rs3("ExportDeliveryTerms"), con) 
		if not rs4.eof then
		deliveryterms=rs4("DeliveryTerms")
		end if
		rs4.close
		set rs4=nothing
		end if
		if rs3("termstext")<>"" then
			deliveryterms=deliveryterms & "<br>" & rs3("termstext")
			else
			deliveryterms=rs3("termstext")
		end if%>
        <tr>
          <td><%=rs3("location")%></td>
          <td width="100"><%=rs3("collectiondate")%></td>
          <td><%=rs3("etadate")%></td> 
		  <%if shipmentcount=2 then%>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
       	  <td>&nbsp;</td>
          <td>&nbsp;</td>
       	  <td>&nbsp;</td>
          <%else%>
          <td><%=deliveryterms%></td>
          <td><%=rs3("shippername")%></td>
          <td><%=rs3("DestinationPort")%></td>
          <td><%=rs3("transportmode")%></td>
          <td><%=rs3("containerref")%></td>
          <%end if%>
          <%if retrieveUserLocation()=1 or retrieveUserLocation()=27 then
		  sql="SELECT distinct purchase_no, linksCollectionid from exportlinks E, exportCollShowrooms S where  E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & rs3("exportCollectionsID") & " AND S.idlocation=" & rs3("idlocation") & " and orderConfirmed='y'"		  
		  else
		  sql="SELECT distinct E.purchase_no, linksCollectionid from exportlinks E, exportCollShowrooms S, Purchase P where  E.LinksCollectionID=S.exportCollshowroomsID and P.idlocation=" & retrieveUserLocation & " and E.purchase_no=P.purchase_no AND S.exportCollectionID=" & rs3("exportCollectionsID") & " AND S.idlocation=" & location & "  AND orderConfirmed='y'"
		  
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
           <%if shipmentcount=2 then%>
           <td width="540">&nbsp;</td>
           <td>&nbsp;</td>
           <td>&nbsp;</td>
           <%else%>
          <td><%if totalpn<>0 then%>
         <%=totalpn%>
          <%else%>
		  <%=totalpn%>
          <%end if%>&nbsp;</td>
          <td><%=rs3("collectionStatusName")%></td>
         <td><a href="php/CommercialManifest.pdf?sid=<%=shipperid%>&cid=<%=collectionid%>&loc=<%=loc%>&eta=<%=rs3("etadate")%>" target="_blank">Print</a></td>
         <%end if%>
        </tr>
       
      </table> 
	  
      <p>&nbsp;</p>
<%end if%>
<%if shipmentcount=2 then%>
<%else%>    
<hr />
<%end if%>
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
    <%if NOT userHasRoleInList("NOPRICESUSER") then%>
    <td align="left" valign="bottom"><b>Total<br />Export<br />Value</b></td>
    <%end if%>
     <td align="right" valign="bottom"><b>Items</b></td>
      <td valign="bottom" align="right"><b>Commercial Invoice</b></td>
      <td valign="bottom" align="right"><b>Wholesale Invoice No.</b></td>
  </tr>
  <tr><td colspan="16"></td></tr>
<%
if count>0 then

totalexportcost=0
for n = 1 to ubound(pnarray)
orderno=getOrderNumberForPurchaseNo(con, pnarray(n))
totalexportcost=0
		sql="SELECT * from exportLinks E, exportcollshowrooms S where E.LinksCollectionID=S.exportCollshowroomsID and S.Exportcollectionid=" & id & " and purchase_no=" & pnarray(n)
		Set rs = getMysqlQueryRecordSet(sql, con)
		items=rs.recordcount
		do until rs.eof
		if rs("componentid")=1 then
			sql="Select mattresstype, mattressprice from purchase where purchase_no=" & pnarray(n)
			Set rs1 = getMysqlQueryRecordSet(sql, con)
			if left(rs1("mattresstype"),3)="Zip" then items=items+1
				if rs1("mattressprice")="0" or isNull(rs1("mattressprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("mattressprice"))
				end if
			rs1.close 
			set rs1=nothing
		end if
		if rs("componentid")=3 then
			sql="Select basetype, baseprice, upholsteryprice, basefabricprice from purchase where purchase_no=" & pnarray(n)
			Set rs1 = getMysqlQueryRecordSet(sql, con)
			if (left(rs1("basetype"),3)="Eas" or left(rs1("basetype"),3)="Nor") then items=items+1
			if rs1("baseprice")="0" or isNull(rs1("baseprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("baseprice"))
				end if
				if rs1("upholsteryprice")="0" or isNull(rs1("upholsteryprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("upholsteryprice"))
				end if
				if rs1("basefabricprice")="0" or isNull(rs1("basefabricprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("basefabricprice"))
				end if
				
			rs1.close 
			set rs1=nothing
		end if
		if rs("componentid")=5 then
sql="Select topperprice from purchase where purchase_no=" & pnarray(n)
Set rs1 = getMysqlQueryRecordSet(sql, con)
if rs1("topperprice")="0" or isNull(rs1("topperprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("topperprice"))
				end if
rs1.close
set rs1=nothing
end if
if rs("componentid")=6 then
sql="Select valanceprice, valfabricprice from purchase where purchase_no=" & pnarray(n)
Set rs1 = getMysqlQueryRecordSet(sql, con)
if rs1("valanceprice")="0" or isNull(rs1("valanceprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("valanceprice"))
				end if
				if rs1("valfabricprice")="0" or isNull(rs1("valfabricprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("valfabricprice"))
				end if
				

rs1.close
set rs1=nothing
end if
if rs("componentid")=7 then
sql="Select legprice, addlegprice from purchase where purchase_no=" & pnarray(n)
Set rs1 = getMysqlQueryRecordSet(sql, con)
if rs1("legprice")="0" or isNull(rs1("legprice")) then
else
totalexportcost=totalexportcost+CDbl(rs1("legprice"))
end if
if rs1("addlegprice")="0" or isNull(rs1("addlegprice")) then
else
totalexportcost=totalexportcost+CDbl(rs1("addlegprice"))
end if
rs1.close
set rs1=nothing
end if

if rs("componentid")=8 then
sql="Select headboardprice, hbfabricprice from purchase where purchase_no=" & pnarray(n)
Set rs1 = getMysqlQueryRecordSet(sql, con)
if rs1("headboardprice")="0" or isNull(rs1("headboardprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("headboardprice"))
				end if
				if rs1("hbfabricprice")="0" or isNull(rs1("hbfabricprice")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("hbfabricprice"))
				end if
				
rs1.close
set rs1=nothing
end if

if rs("componentid")=9 then
sql="Select accessoriestotalcost from purchase where purchase_no=" & pnarray(n)
Set rs1 = getMysqlQueryRecordSet(sql, con)
if rs1("accessoriestotalcost")="0" or isNull(rs1("accessoriestotalcost")) then
				else
				totalexportcost=totalexportcost+CDbl(rs1("accessoriestotalcost"))
				end if
rs1.close
set rs1=nothing
end if


		rs.movenext
		loop
		rs.close
		set rs=nothing
		'response.Write("items=" & items)
		sql="SELECT * FROM exportlinks E, exportcollshowrooms  S, purchase P, Address A, Contact C WHERE E.purchase_no=" & pnarray(n) & " and E.LinksCollectionID=S.exportCollshowroomsID and P.purchase_no=E.purchase_no and P.code=C.code and A.code=P.code group by E.purchase_no" 	
		
		'sql="SELECT * from purchase P, contact C, address A, exportLinks E, exportcollshowrooms S where E.LinksCollectionID=S.exportCollshowroomsID and P.purchase_no=" & pnarray(n) & " and P.purchase_no=E.purchase_no AND E.LinksCollectionID=" & exportlinksid & " and P.code=C.code and A.code=P.code"
		'response.Write("sql=" & sql)
		Set rs = getMysqlQueryRecordSet(sql, con)
		if not rs.eof Then
		Set rs4 = getMysqlQueryRecordSet("Select * from wholesale_prices where purchase_no=" & pnarray(n), con)
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
			<%=getSpecCellText(con, pnarray(n), 1, id, rs("savoirmodel"))%><%madeat=getComponentCurrentMadeAt(con, pnarray(n), 1)
			if madeat=4 then 
			response.Write("<br>Stock<br>")
			response.Write(getComponentBay(con, orderno, 1))
			madeat=""
			end if%></span>&nbsp;</td>
			<td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 3))%>">
			<%=getSpecCellText(con, pnarray(n), 3, id, rs("basesavoirmodel"))%><%madeat=getComponentCurrentMadeAt(con, pnarray(n), 3)
			if madeat=4 then 
			response.Write("<br>Stock<br>")
			response.Write(getComponentBay(con, orderno, 3))
			madeat=""
			end if%></span>&nbsp;</td>
			<td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 5))%>">
			<%=getSpecCellText(con, pnarray(n), 5, id, rs("toppertype"))%><%madeat=getComponentCurrentMadeAt(con, pnarray(n), 5)
			if madeat=4 then 
			response.Write("<br>Stock<br>")
			response.Write(getComponentBay(con, orderno, 5))
			madeat=""
			end if%></span>&nbsp;</td>
			<td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 8))%>">
			<%=getSpecCellText(con, pnarray(n), 8, id, rs("headboardstyle"))%><%madeat=getComponentCurrentMadeAt(con, pnarray(n), 8)
			if madeat=4 then 
			response.Write("<br>Stock<br>")
			response.Write(getComponentBay(con, orderno, 8))
			madeat=""
			end if%></span>&nbsp;</td>
			<td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 7))%>">
			<%=getSpecCellText(con, pnarray(n), 7, id, rs("legstyle"))%></span>&nbsp;</td>
			<td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 7))%>">
			<%=getSpecCellText(con, pnarray(n), 7, id, rs("legfinish"))%><%madeat=getComponentCurrentMadeAt(con, pnarray(n), 7)
			if madeat=4 then 
			response.Write("<br>Stock<br>")
			response.Write(getComponentBay(con, orderno, 7))
			madeat=""
			end if%></span>&nbsp;</td>
			<td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 6))%>">
			<%=getSpecCellText(con, pnarray(n), 6, id, rs("valancerequired"))%><%madeat=getComponentCurrentMadeAt(con, pnarray(n), 6)
			if madeat=4 then 
			response.Write("<br>Stock<br>")
			response.Write(getComponentBay(con, orderno, 6))
			madeat=""
			end if%></span>&nbsp;</td>
			<td valign="top"><span style="color:<%=getLockColourForStatus(getComponentStatus(con, pnarray(n), 9))%>">
			<%=getSpecCellText(con, pnarray(n), 9, id, rs("accessoriesrequired"))%></span>&nbsp;</td>
			<td align="right" valign="top">
			<%=fmtCurr2(totalexportcost, true, rs("ordercurrency"))%>
            <%if NOT userHasRoleInList("NOPRICESUSER") then%>
					<%if rs("total")<>"" and rs("total")<>"0" then 
                    'response.Write("total=" & rs("total"))
                    if rs("ordercurrency")="GBP" then
                    GBPshipmenttotalcost=GBPshipmenttotalcost+totalexportcost
                    elseif rs("ordercurrency")="EUR" then
                    EURshipmenttotalcost=EURshipmenttotalcost+totalexportcost
                    elseif rs("ordercurrency")="USD" then
                    USDshipmenttotalcost=USDshipmenttotalcost+totalexportcost
                    end if
		
				end if
			end if%>&nbsp;</td>
			<td align="right" valign="top"><%=items%>&nbsp;</td>
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
count=0
Erase pnarray
GBPshipmenttotalcost=0
EURshipmenttotalcost=0
USDshipmenttotalcost=0
shipmentcount=2
		rs3.movenext
		loop
		rs3.close
		set rs3=nothing
		
con.close
set con=nothing%>
</td>
    </tr>
    <tr>
      <td colspan="14"><hr><p style="float:right;"><a href="print-container-csv.asp?id=<%=id%>&location=<%=location%>">Print CSV</a></p>        
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
	asql = "select * from exportlinks L, exportcollshowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & id & " and purchase_no=" & aPn & " and componentid=" & aCompId
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
