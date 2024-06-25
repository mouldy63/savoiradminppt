<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%dim orderexists, Con, rs, sql, rs1, totalpn, items, itemtotal, ordersql
ordersql=request("ordersql")
if ordersql="a" then ordersql="asc"
if ordersql="" then ordersql="desc"
if ordersql="d" then  ordersql ="desc"
itemtotal=0
dim pnarray(), count
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
<% if retrieveUserLocation()=1 or retrieveUserLocation()=27  then
sql="SELECT * from exportcollections E, shipper_address S, collectionStatus C where E.shipper=S.shipper_address_id AND C.collectionStatusID=E.collectionStatus AND E.collectionStatus=4 order by CollectionDate " & ordersql
else
sql="SELECT * from exportcollections E, shipper_address S, collectionStatus C, exportcollshowrooms T where  T.idlocation=" & retrieveUserLocation() & " and T.exportCollectionID=E.exportCollectionsid and E.shipper=S.shipper_address_id AND C.collectionStatusID=E.collectionStatus AND E.collectionStatus=4  order by CollectionDate " & ordersql
end if
Set rs = getMysqlUpdateRecordSet(sql, con)%>
<table width="100%" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr valign="top">
    <td width="647" class="maintext">
      <%if retrieveUserLocation()=1 or retrieveUserLocation()=27  then%>  <p align="right"><a href="add-collection.asp">ADD NEW COLLECTION</a><br /><%end if%>
      <a href="sales-admin.asp">SALES ADMIN</a></p>
        <%if retrieveUserLocation()=1 or retrieveUserLocation()=27 or retrieveUserRegion()>1  then%>
      
      <h1>Delivered Shipments </h1>
      <table width="95%" border="0" align="center" cellpadding="2" cellspacing="2">
        <tr>
          <td>Showrooms</td>
          <td>Collection Date<a href="delivered-exports.asp?ordersql=d"><br>
        <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="delivered-exports.asp?ordersql=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></td>
          <td>ETA Date</td>
          <td>Shipper</td>
          <td>Transport Mode</td>
          <td>Container Ref.</td>
          <td>Qty. of Orders</td>
          <td>Items</td>
          <td>Status</td>
           <%if retrieveUserLocation()=1 or retrieveUserLocation()=27  then%>
          
          <%end if%>
        </tr>
         <tr>
        
          <td colspan="9"><hr></td>
         
          </tr>
          </tr>
        <%if rs.eof then response.Write("<tr><td colspan=""9"">Currently there are no delivered shipments</td></tr>")
		do until rs.eof%>
       
        <tr>
          <td valign="top"><%
		  if retrieveUserLocation()=1 or retrieveUserLocation()=27  then
		  sql="select * from exportCollShowrooms E, location L where exportCollectionID=" & rs("exportCollectionsID") & " and E.idlocation=L.idlocation"
		  else
		  sql="select * from exportCollShowrooms E, location L where exportCollectionID=" & rs("exportCollectionsID") & " and E.idlocation=L.idlocation and E.idlocation=" & retrieveUserLocation()
		  end if
		  Set rs1 = getMysqlUpdateRecordSet(sql, con)
		  Do until rs1.eof
		  response.Write(rs1("adminheading") & "<br />")
		  rs1.movenext
		  loop
		  rs1.close
		  set rs1=nothing
		 %></td>
          <td valign="top"><a href="container-details1.asp?id=<%=rs("exportCollectionsID")%>"><%=rs("collectiondate")%></a></td>
        
          <td valign="top">  <%
		   if retrieveUserLocation()=1 or retrieveUserLocation()=27  then
		  sql="select * from exportCollShowrooms E, location L where exportCollectionID=" & rs("exportCollectionsID") & " and E.idlocation=L.idlocation"
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
          <td valign="top"><%=rs("transportmode")%></td>
          <td valign="top"><%=rs("containerref")%></td>
          <%
		    if retrieveUserLocation()=1 or retrieveUserLocation()=27  then
		  sql="SELECT distinct purchase_no from exportlinks E, exportCollShowrooms S  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & rs("exportCollectionsID") & " AND orderConfirmed='y'"
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
		  set rs1=nothing%>
          <td valign="top"><%if totalpn<>0 then
		   if retrieveUserLocation()=1 or retrieveUserLocation()=27  then  
		sql="SELECT count(distinct (E.purchase_no)) as n, exportCollectionID, S.idlocation, L.adminheading from exportlinks E, exportCollShowrooms S, location L  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & rs("exportCollectionsID") & " AND orderConfirmed='y' and S.idlocation=L.idlocation group by idlocation " 
		else
		sql="SELECT count(distinct (E.purchase_no)) as n, exportCollectionID, S.idlocation, L.adminheading from exportlinks E, exportCollShowrooms S, location L , purchase P where E.LinksCollectionID=S.exportCollshowroomsID and P.purchase_no=E.purchase_no and P.idlocation=" & retrieveUserLocation() & " and S.exportCollectionID=" & rs("exportCollectionsID") & " AND orderConfirmed='y' and S.idlocation=L.idlocation group by idlocation " 
		end if
		Set rs1 = getMysqlQueryRecordSet(sql, con) 
		if not rs1.eof then
		  do until rs1.eof
		  response.Write("<a href=""shipment-details.asp?location=" & rs1("idlocation")  & "&id=" & rs("exportCollectionsID") & """>" & rs1("n") &  " (" & rs1("adminheading") & ")</a><br />")
		  rs1.movenext
		  loop
		  end if
		  rs1.close
		  set rs1=nothing%>
  
          <%else%>
		  0
          <%end if%>&nbsp;
          
          </td>
          
          
          <td valign="top"><%
		  sql="SELECT count(E.purchase_no) as n, exportCollectionID, S.idlocation, L.adminheading from exportlinks E, exportCollShowrooms S, location L  where E.LinksCollectionID=S.exportCollshowroomsID and S.exportCollectionID=" & rs("exportCollectionsID") & " AND orderConfirmed='y' and S.idlocation=L.idlocation group by idlocation "
	Set rs1 = getMysqlQueryRecordSet(sql, con) 
		if not rs1.eof then
		  do until rs1.eof
		  response.Write(rs1("n") &  "<br />")
		  rs1.movenext
		  loop
		  end if
		  rs1.close
		  set rs1=nothing%></td>
          <td valign="top"><%=rs("collectionStatusName")%></td>
          
        </tr>
        <tr> 
          <td colspan="9"><hr></td>
       </tr>
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
