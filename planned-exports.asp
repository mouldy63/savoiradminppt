<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,REGIONAL_ADMINISTRATOR,SALES"%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%dim orderexists, Con, rs, sql, rs1, rs2, rs3, rs4,  totalpn, items, m, itemtotal, ordersql, actualOrderSql, deliveryterms
ordersql=request("ordersql")
actualOrderSql = "CollectionDate asc"
if ordersql="sa" then
	actualOrderSql = "firstshowroom asc"
elseif ordersql="sd" then
	actualOrderSql = "firstshowroom desc"
elseif ordersql="da" then
	actualOrderSql = "CollectionDate asc"
elseif ordersql="dd" then
	actualOrderSql = "CollectionDate desc"
end if

itemtotal=0
dim pnarray(), showrooms(), count
count = 0
'response.Write("my location = " & retrieveUserLocation() & " = " )
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
<%
sql="SELECT ExportDeliveryTerms,termstext,exportCollectionsID,collectiondate,shippername,consignee,transportmode,destinationport,containerref,collectionStatusName,"
sql= sql & " (select adminheading from exportCollShowrooms t1, location t2 where t1.idlocation=t2.idlocation and t1.exportCollectionID=exportCollectionsID order by t2.idlocation limit 1) as firstshowroom"
sql= sql & " from exportcollections E, shipper_address S, collectionStatus C"
if retrieveUserLocation()=1 or retrieveUserLocation()=27  then
	sql= sql & " where E.shipper=S.shipper_address_id AND C.collectionStatusID=E.collectionStatus AND E.collectionStatus<>4 and E.collectionStatus<>5"
elseif retrieveUserLocation()=211 then
	sql= sql & " where E.exportCollectionsid in (select T.exportCollectionID from exportcollshowrooms T join location L on T.idlocation=L.idlocation and (T.idlocation=" & retrieveUserLocation() & " or T.idlocation=30))"
	sql= sql & " and E.shipper=S.shipper_address_id"
	sql= sql & " AND C.collectionStatusID=E.collectionStatus"
	sql= sql & " AND E.collectionStatus not in (4,5)"
elseif userHasRole("REGIONAL_ADMINISTRATOR") then
	sql= sql & " where E.exportCollectionsid in (select T.exportCollectionID from exportcollshowrooms T join location L on T.idlocation=L.idlocation and L.owning_region=" & retrieveUserRegion() & ")"
	sql= sql & " and E.shipper=S.shipper_address_id"
	sql= sql & " AND C.collectionStatusID=E.collectionStatus"
	sql= sql & " AND E.collectionStatus not in (4,5)"
else
	sql= sql & " where E.exportCollectionsid in (select T.exportCollectionID from exportcollshowrooms T join location L on T.idlocation=L.idlocation and T.idlocation=" & retrieveUserLocation() & ")"
	sql= sql & " and E.shipper=S.shipper_address_id"
	sql= sql & " AND C.collectionStatusID=E.collectionStatus"
	sql= sql & " AND E.collectionStatus not in (4,5)"
end if
sql= sql & " order by " & actualOrderSql
'response.write("<br>" & sql & "<br>")

Set rs = getMysqlUpdateRecordSet(sql, con)%>
<table width="100%" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr valign="top">
    <td width="647" class="maintext">
      <%if retrieveUserLocation()=1 or retrieveUserLocation()=27  then%>  <p align="right"><a href="add-collection.asp">ADD NEW COLLECTION</a><br /><%end if%>
      <a href="sales-admin.asp">SALES ADMIN</a></p>
        <%if retrieveUserLocation()=1 or retrieveUserLocation()=27 or retrieveUserRegion()>1  then%>
      
      <h1>Planned Export Collections </h1>
      <table width="95%" border="0" align="center" cellpadding="2" cellspacing="2">
        <tr>
          <td>Showrooms<a href="planned-exports.asp?ordersql=sd"><br>
        <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="planned-exports.asp?ordersql=sa"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></td>
          <td>Collection Date<a href="planned-exports.asp?ordersql=dd"><br>
        <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="planned-exports.asp?ordersql=da"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></td>
          <td>ETA Date</td>
          <td>Shipper</td>
          <td>Terms of Delivery</td>
          <td>Consignee</td>
          <td>Transport Mode</td>
          <td>Destination Port</td>
          <td>Container Ref.</td>
          <td>Qty. of Orders</td>
          <td>Items</td>
          <td>Status</td>
           <%if retrieveUserLocation()=1 or retrieveUserLocation()=27  then%>
          <td>Action</td>
          <%end if%>
        </tr>
         <tr>
          <%if retrieveUserLocation()=1 or retrieveUserLocation()=27  then%>
          <td colspan="10"><hr></td>
          <%else%>
          <td colspan="9"><hr></td>
          <%end if%>
          </tr>
          </tr>
        <%if rs.eof then response.Write("<tr><td colspan=""9"">Currently there are no planned exports</td></tr>")
		do until rs.eof
		deliveryterms=""
		if rs("ExportDeliveryTerms")<>0 then
		'deliveryterms=""
		Set rs4 = getMysqlQueryRecordSet("Select * from deliveryterms where deliveryTermsID=" & rs("ExportDeliveryTerms"), con) 
		if not rs4.eof then
		deliveryterms=rs4("DeliveryTerms")
		end if
		rs4.close
		set rs4=nothing
		end if
		if deliveryterms<>"" then
		deliveryterms=deliveryterms & "<br>" & rs("termstext")
		else
		deliveryterms=rs("termstext")
		end if%>
       
        <tr>
          <td valign="top"><%
		  if retrieveUserLocation()=1 or retrieveUserLocation()=27  then
		  	sql="select * from exportCollShowrooms E, location L where exportCollectionID=" & rs("exportCollectionsID") & " and E.idlocation=L.idlocation order by L.idlocation"
		  elseif  retrieveUserLocation()=21 then
		  	sql="select * from exportCollShowrooms E, location L where exportCollectionID=" & rs("exportCollectionsID") & " and E.idlocation=L.idlocation and (E.idlocation=" & retrieveUserLocation() & " or E.idlocation=30) order by L.idlocation"
		  elseif userHasRole("REGIONAL_ADMINISTRATOR") then
		  	sql="select * from exportCollShowrooms E, location L where exportCollectionID=" & rs("exportCollectionsID") & " and E.idlocation=L.idlocation and L.owning_region=" & retrieveUserRegion() & " order by L.idlocation"
		  else
		  	sql="select * from exportCollShowrooms E, location L where exportCollectionID=" & rs("exportCollectionsID") & " and E.idlocation=L.idlocation and E.idlocation=" & retrieveUserLocation() & " order by L.idlocation"
		  end if
		  'response.write("<br>" & sql)
		  Set rs1 = getMysqlUpdateRecordSet(sql, con)
		  redim showrooms(0)
		  count = 0
		  Do until rs1.eof
		  	response.Write(rs1("adminheading") & "<br />")
		  	count = count + 1
		  	redim preserve showrooms(count)
		  	showrooms(count) = rs1("exportCollshowroomsID")
		  	rs1.movenext
		  	loop
		  rs1.close
		  set rs1=nothing
		 %></td>
         <%if retrieveUserLocation()=1 or retrieveUserLocation()=27  then%>
          <td valign="top"><a href="container-details1.asp?id=<%=rs("exportCollectionsID")%>"><%=rs("collectiondate")%></a></td>
        <%else%>
          <td valign="top"><%=rs("collectiondate")%></td>
        <%end if%>
          <td valign="top">  <%
		  if retrieveUserLocation()=1 or retrieveUserLocation()=27  then
		  	sql="select * from exportCollShowrooms E, location L where exportCollectionID=" & rs("exportCollectionsID") & " and E.idlocation=L.idlocation"
		  elseif retrieveUserLocation()=21 then
		  	sql="select * from exportCollShowrooms E, location L where exportCollectionID=" & rs("exportCollectionsID") & " and E.idlocation=L.idlocation and (E.idlocation=" & retrieveUserLocation() & " or E.idlocation=30)"
		  elseif userHasRole("REGIONAL_ADMINISTRATOR") then
		  	sql="select * from exportCollShowrooms E, location L where exportCollectionID=" & rs("exportCollectionsID") & " and E.idlocation=L.idlocation and L.owning_region=" & retrieveUserRegion()
		  else
		  	sql="select * from exportCollShowrooms E, location L where exportCollectionID=" & rs("exportCollectionsID") & " and E.idlocation=L.idlocation and E.idlocation=" & retrieveUserLocation()
		  end if
		  Set rs1 = getMysqlUpdateRecordSet(sql, con)
		  Do until rs1.eof
		  response.Write(rs1("etadate") & "<br />")
		  rs1.movenext
		  loop
		  rs1.close
		  set rs1=nothing
		 %>
		</td>
        
          <td valign="top"><%=rs("shippername")%></td>
          <td valign="top"><%=deliveryterms%></td>
<%if isNull(rs("consignee")) then%>
<td valign="top">&nbsp;</td>
<%
else
sql="SELECT * from exportcollections E, consignee_address C where E.consignee=C.consignee_ADDRESS_ID and E.exportCollectionsID=" & rs("exportCollectionsID")

Set rs3 = getMysqlUpdateRecordSet(sql, con)%>
          <td valign="top"><%response.Write(rs3("consigneename") & "<br>" & rs3("add1"))%></td>
<%rs3.close
set rs3=nothing
end if%>
          <td valign="top"><%=rs("transportmode")%></td>
          <td valign="top"><%=rs("destinationport")%></td>
          <td valign="top"><%=rs("containerref")%></td>
          <%
		  if retrieveUserLocation()=1 or retrieveUserLocation()=27  then
		  	sql="SELECT distinct purchase_no from exportlinks E, exportCollShowrooms S  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & rs("exportCollectionsID") & " AND orderConfirmed='y'"
		  elseif retrieveUserLocation()=21 then
		  	sql="SELECT distinct E.purchase_no from exportlinks E, exportCollShowrooms S, purchase P  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & rs("exportCollectionsID") & " AND P.purchase_no=E.purchase_no and (P.idlocation=" &  retrieveUserLocation() & " or P.idlocation=30) and orderConfirmed='y'"
		  elseif userHasRole("REGIONAL_ADMINISTRATOR") then
		  	sql="SELECT distinct E.purchase_no from exportlinks E, exportCollShowrooms S, Location L, purchase P  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & rs("exportCollectionsID") & " AND P.purchase_no=E.purchase_no and S.idlocation=L.idlocation and L.owning_region=" & retrieveUserRegion() & " and orderConfirmed='y'"
		  else
		  	sql="SELECT distinct E.purchase_no from exportlinks E, exportCollShowrooms S, purchase P  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & rs("exportCollectionsID") & " AND P.purchase_no=E.purchase_no and P.idlocation=" &  retrieveUserLocation() & " and orderConfirmed='y'"
		  end if
		  'response.Write(sql)
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
		  'response.Write("totalpn=" & totalpn)
		  %><td valign="top"><%
		if totalpn<>0 then
			for m = 1 to ubound(showrooms)
				if retrieveUserLocation()=1 or retrieveUserLocation()=27  then  
					sql="SELECT count(distinct (E.purchase_no)) as n, exportCollectionID, S.idlocation, L.adminheading from exportlinks E, exportCollShowrooms S, location L  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & rs("exportCollectionsID") & " AND orderConfirmed='y' and S.idlocation=L.idlocation and s.exportCollshowroomsID=" & showrooms(m) & " group by idlocation" 
				elseif retrieveUserLocation()=21 then
					sql="SELECT count(distinct (E.purchase_no)) as n, exportCollectionID, S.idlocation, L.adminheading from exportlinks E, exportCollShowrooms S, location L , purchase P where E.LinksCollectionID=S.exportCollshowroomsID and P.purchase_no=E.purchase_no and (P.idlocation=" & retrieveUserLocation() & " or P.idlocation=30) and S.exportCollectionID=" & rs("exportCollectionsID") & " AND orderConfirmed='y' and S.idlocation=L.idlocation and s.exportCollshowroomsID=" & showrooms(m) & " group by idlocation" 
	   		    elseif userHasRole("REGIONAL_ADMINISTRATOR") then
					sql="SELECT count(distinct (E.purchase_no)) as n, exportCollectionID, S.idlocation, L.adminheading from exportlinks E, exportCollShowrooms S, location L , purchase P where E.LinksCollectionID=S.exportCollshowroomsID and P.purchase_no=E.purchase_no and L.owning_region=" & retrieveUserRegion() & " and S.exportCollectionID=" & rs("exportCollectionsID") & " AND orderConfirmed='y' and S.idlocation=L.idlocation and s.exportCollshowroomsID=" & showrooms(m) & " group by idlocation" 
				else
					sql="SELECT count(distinct (E.purchase_no)) as n, exportCollectionID, S.idlocation, L.adminheading from exportlinks E, exportCollShowrooms S, location L , purchase P where E.LinksCollectionID=S.exportCollshowroomsID and P.purchase_no=E.purchase_no and P.idlocation=" & retrieveUserLocation() & " and S.exportCollectionID=" & rs("exportCollectionsID") & " AND orderConfirmed='y' and S.idlocation=L.idlocation and s.exportCollshowroomsID=" & showrooms(m) & " group by idlocation" 
				end if
				'response.write("<br>" & sql)
				Set rs1 = getMysqlQueryRecordSet(sql, con) 
				if not rs1.eof then
				  do until rs1.eof
				  	response.Write("<a href=""shipment-details.asp?location=" & rs1("idlocation")  & "&id=" & rs("exportCollectionsID") & """>" & rs1("n") &  " (" & rs1("adminheading") & ")</a><br />")
				  	rs1.movenext
				  loop
  	            else
				  response.Write("0<br/>")
				end if
				rs1.close
				set rs1=nothing
	        next
          end if
          %>&nbsp;
          
          </td>
          
          
          <td valign="top"><%
    ' the item count
	for m = 1 to ubound(showrooms)
		items=0
		'response.Write("showrooms=" & showrooms(m) & "<br>")
		'response.Write("totalpn=" & totalpn & "<br>")
		if totalpn>0 then
		for n = 1 to ubound(pnarray)
			sql="SELECT * from exportLinks L, exportcollshowrooms S where L.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & rs("exportCollectionsID") & " and purchase_no=" & pnarray(n) & " and s.exportCollshowroomsID=" & showrooms(m)
			'response.Write(sql & "<br>")
			Set rs1 = getMysqlQueryRecordSet(sql, con)
			items = items + rs1.recordcount
			do until rs1.eof
				if rs1("componentid")=1 then
					sql="Select mattresstype from purchase where purchase_no=" & pnarray(n)
					Set rs2 = getMysqlQueryRecordSet(sql, con)
					if left(rs2("mattresstype"),3)="Zip" then items=items+1
					rs2.close 
					set rs2=nothing
				end if
				if rs1("componentid")=3 then
					sql="Select basetype from purchase where purchase_no=" & pnarray(n)
					Set rs2 = getMysqlQueryRecordSet(sql, con)
					'if (left(rs2("basetype"),3)="Eas" or left(rs2("basetype"),3)="Nor") then items=items+1
					rs2.close 
					set rs2=nothing
				end if
				rs1.movenext
			loop
			rs1.close
			set rs1=nothing
			
		next
		end if
		response.Write(items & "<br />")
	next
				
		%></td>
          <td valign="top"><%=rs("collectionStatusName")%></td>
           <%if retrieveUserLocation()=1 or retrieveUserLocation()=27  then%>
          <td valign="top"><a href="edit-collection.asp?collectionid=<%=rs("exportCollectionsID")%>">Edit</a></td>
          <%end if%>
        </tr>
        <tr> <%if retrieveUserLocation()=1 or retrieveUserLocation()=27  then%>
          <td colspan="10"><hr></td>
          <%else%>
          <td colspan="9"><hr></td>
          <%end if%></tr>
        <%items=0
		itemtotal=0
		rs.movenext
		loop
		rs.close
		set rs=nothing%>
        
      </table>
      <p>&nbsp;</p>
<%end if%>
    </td>
    </tr>
</table>
</div>

</body>
</html>
 
<!-- #include file="common/logger-out.inc" -->
