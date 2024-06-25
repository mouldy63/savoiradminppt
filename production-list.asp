<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, sql2, msg, customerasc, orderasc, showr,  companyasc, bookeddate, productiondate, previousOrderNumber, acknowDateWarning, rs2, compstatus
dim matt_madeat, base_madeat, topper_madeat, headboard_madeat, legs_madeat, valance_madeat, factory, bold
dim diff, factories, cwc

showr=request("showr")
productiondate=request("productiondate")
bookeddate=request("bookeddate")
companyasc=request("companyasc")
customerasc=request("customerasc")
orderasc=request("orderasc")
matt_madeat=request("matt_madeat")
base_madeat=request("base_madeat")
topper_madeat=request("topper_madeat")
headboard_madeat=request("headboard_madeat")
legs_madeat=request("legs_madeat")
valance_madeat=request("valance_madeat")

cwc = false
if request("cwc") = "true" or request("cwc") = "True" then cwc = true

factory=request("factory")
if factory = "" then factory=-1
factory = cint(factory)

msg=""
msg=Request("msg")
count=0
submit=Request("submit") 

postcodefull=Request("postcode")
postcode=Replace(postcodefull, " ", "")
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" 
	"http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head><title>Administration.</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="ROBOTS" content="NOINDEX,NOFOLLOW" />
<link href="Styles/screen.css" rel="Stylesheet" type="text/css" />
<link href="Styles/extra.css" rel="Stylesheet" type="text/css" />
<link href="Styles/screenP.css" rel="Stylesheet" type="text/css" />
<link href="Styles/print.css" rel="Stylesheet" type="text/css" media="print" />
<script   
   src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js">
    </script>

<STYLE type="text/css">
  body {
    color: #222222;
    font-family: "Trebuchet MS",Arial,Verdana,San serif;
    font-size: 65%;}

 </STYLE>


</head>
<body>

<div class="containerwide">

  <div class="one-col head-col">

<p>
  <% 
%>
  <a href="index.asp">Back to Main menu</a>
  </p>
<p><a href="production-index.asp">Back to Production menu</a>
</p>
<p>Production Orders</p>

<p>Filter by:
<% bold = (factory=2)%>
&nbsp;<a href="production-list.asp?factory=2"><%if bold then%><b><%end if%>London Orders<%if bold then%></b><%end if%></a>
<% bold = (factory=1)%>
&nbsp;<a href="production-list.asp?factory=1"><%if bold then%><b><%end if%>Cardiff Orders<%if bold then%></b><%end if%></a>
<% bold = (factory=4)%>
&nbsp;<a href="production-list.asp?factory=4"><%if bold then%><b><%end if%>Stock Items<%if bold then%></b><%end if%></a>
<% bold = (factory=0)%>
&nbsp;<a href="production-list.asp?factory=0"><%if bold then%><b><%end if%>Unassigned Orders<%if bold then%></b><%end if%></a>
<% bold = (factory=-1)%>
&nbsp;<a href="production-list.asp"><%if bold then%><b><%end if%>None<%if bold then%></b><%end if%></a>
</p>
<!--<form name="form1" method="post" action="">-->	
  <p>
<%
Set Con = getMysqlConnection()
sql = "select * from ("
sql = sql & "select purchase_no,order_number,orderSource,totalexvat,ordercurrency,paymentstotal,vatrate,c.first,c.surname,c.title,a.street1,a.street2,a.street3,a.town,a.county,a.postcode,a.country,a.price_list"
sql = sql & ",company,adminheading,order_date,productiondate,bookeddeliverydate,deliveryadd1,deliveryadd2,deliveryadd3,deliverytown,deliverycounty,deliverypostcode,deliverycountry"
sql = sql & ",mattressrequired,legsrequired,baserequired,headboardrequired,topperrequired,valancerequired"
sql = sql & ",basesavoirmodel,savoirmodel,headboardstyle,legstyle,toppertype,valancefabric,valancefabricchoice"

sql = sql & " , (Select madeat from qc_history_latest h where h.componentid=1 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) as matt_madeat" 
sql = sql & " , (Select madeat from qc_history_latest h where h.componentid=3 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) as base_madeat" 
sql = sql & " , (Select madeat from qc_history_latest h where h.componentid=5 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) as topper_madeat" 
sql = sql & " , (Select madeat from qc_history_latest h where h.componentid=6 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) as valance_madeat" 
sql = sql & " , (Select madeat from qc_history_latest h where h.componentid=8 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) as headboard_madeat" 
sql = sql & " , (Select madeat from qc_history_latest h where h.componentid=7 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) as legs_madeat" 
sql = sql & " , (Select qc_statusid from qc_history_latest h where h.componentid=1 AND h.purchase_no=P.purchase_no) as matt_status"
sql = sql & " , (Select qc_statusid from qc_history_latest h where h.componentid=3 AND h.purchase_no=P.purchase_no) as base_status"
sql = sql & " , (Select qc_statusid from qc_history_latest h where h.componentid=5 AND h.purchase_no=P.purchase_no) as topper_status"
sql = sql & " , (Select qc_statusid from qc_history_latest h where h.componentid=6 AND h.purchase_no=P.purchase_no) as valance_status"
sql = sql & " , (Select qc_statusid from qc_history_latest h where h.componentid=8 AND h.purchase_no=P.purchase_no) as headboard_status"
sql = sql & " , (Select qc_statusid from qc_history_latest h where h.componentid=7 AND h.purchase_no=P.purchase_no) as legs_status"
sql = sql & " , (Select qc_statusid from qc_history_latest h where h.componentid=0 AND h.purchase_no=P.purchase_no) as order_status"

sql = sql & " from address A, contact C, Purchase P" 
sql = sql & ", Location L"
sql = sql & " Where P.purchase_no IN (SELECT Distinct purchase_no FROM qc_history_latest) and (P.cancelled is null or P.cancelled <> 'y') AND A.code=C.code AND C.contact_no=P.contact_no AND P.completedorders='n' AND P.quote='n' AND  P.orderonhold<>'y' "
sql = sql & " AND P.idlocation=L.idlocation "
sql = sql & " AND P.source_site='SB' " 

' order status must be 'awaiting confirmation', 'on order', 'in production', 'order on hold', 'part delivered'
sql = sql & ") as x"
sql2=sql
if cwc then
	sql = sql & " where ((x.matt_madeat=" & factory & " or x.matt_madeat is null) and x.matt_status=2)"
	sql = sql & " or ((x.base_madeat=" & factory & " or x.base_madeat is null) and x.base_status=2)"
	sql = sql & " or ((x.topper_madeat=" & factory & " or x.topper_madeat is null) and x.topper_status=2)"
	sql = sql & " or ((x.headboard_madeat=" & factory & " or x.headboard_madeat is null) and x.headboard_status=2)"
	sql = sql & " or ((x.legs_madeat=" & factory & " or x.legs_madeat is null) and x.legs_status=2)"
	sql = sql & " or ((x.valance_madeat=" & factory & " or x.valance_madeat is null) and x.valance_status=2)"
else
	sql = sql & " where x.order_status in (0,2,4,10,20,90,130)"

	if factory <> -1 then
		if factory = 0 then
			' unassigned
			sql = sql & " and (x.matt_madeat is null OR x.matt_madeat=0 OR x.base_madeat is null OR x.base_madeat=0 OR x.topper_madeat is null OR x.topper_madeat=0 OR x.headboard_madeat is null OR x.headboard_madeat=0 OR x.legs_madeat is null OR x.legs_madeat=0 OR x.valance_madeat is null OR x.valance_madeat=0)"
		else
			sql = sql & " and (x.matt_madeat=" & factory & " OR x.base_madeat=" & factory & " OR x.topper_madeat=" & factory & " OR x.headboard_madeat=" & factory & " OR x.legs_madeat=" & factory & " OR x.valance_madeat=" & factory & ")"
		end if
	end if
end if

if showr="a" then
sql = sql & " order by adminheading asc"
end if
if showr="d" then
sql = sql & " order by adminheading desc"
end if
if customerasc="a" then
sql = sql & " order by surname asc"
end if
if customerasc="d" then
sql = sql & " order by surname desc"
end if
if orderasc="a" then
sql = sql & " order by order_number asc"
end if
if orderasc="d" then
sql = sql & " order by order_number desc"
end if
if companyasc="a" then
sql = sql & " order by company asc"
end if
if companyasc="d" then
sql = sql & " order by company desc"
end if

if bookeddate="a" then
sql = sql & " order by bookeddeliverydate asc"
end if
if bookeddate="d" then
sql = sql & " order by bookeddeliverydate desc"
end if

if productiondate="a" then
	sql = sql & " order by productiondate asc"
end if
if productiondate="d" then
	sql = sql & " order by productiondate desc"
end if
if matt_madeat = "a" then
	sql = sql & " order by matt_madeat asc"
end if
if matt_madeat = "d" then
	sql = sql & " order by matt_madeat desc"
end if
if base_madeat = "a" then
	sql = sql & " order by base_madeat asc"
end if
if base_madeat = "d" then
	sql = sql & " order by base_madeat desc"
end if
if topper_madeat = "a" then
	sql = sql & " order by topper_madeat asc"
end if
if topper_madeat = "d" then
	sql = sql & " order by topper_madeat desc"
end if
if valance_madeat = "a" then
	sql = sql & " order by valance_madeat asc"
end if
if valance_madeat = "d" then
	sql = sql & " order by valance_madeat desc"
end if
if headboard_madeat = "a" then
	sql = sql & " order by headboard_madeat asc"
end if
if headboard_madeat = "d" then
	sql = sql & " order by headboard_madeat desc"
end if
if legs_madeat = "a" then
	sql = sql & " order by legs_madeat asc"
end if
if legs_madeat = "d" then
	sql = sql & " order by legs_madeat desc"
end if

if customerasc=""  and  orderasc="" and companyasc=""  and bookeddate=""  and showr="" and productiondate="" and matt_madeat="" and base_madeat="" and topper_madeat="" and headboard_madeat="" and legs_madeat="" and valance_madeat="" then
	sql = sql & " order by CAST(order_number as decimal) asc"
end if

'response.write("<br>" & sql & "<br>")
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
response.Write("Total = " & rs.recordcount & "<br /><br />")
factories = getFactories(con)

%>
 
<p align="center"><% bold = (factory=2 and cwc)%>
&nbsp;<a href="production-list.asp?factory=2&cwc=true"><%if bold then%><b><%end if%>London Confirmed Waiting to Check<%if bold then%></b><%end if%></a>&nbsp;&nbsp;&nbsp;&nbsp;
<% bold = (factory=1 and cwc)%>
&nbsp;<a href="production-list.asp?factory=1&cwc=true"><%if bold then%><b><%end if%>Cardiff Confirmed Waiting to Check<%if bold then%></b><%end if%></a>
</p><div style="width:1416;border:2px green solid;">
<table width="" border="0" cellpadding="3" cellspacing="0"   id="tblNeedsScrolling" >
<thead>
 <tr>
   <th width="57" align="left" valign="bottom">&nbsp;</th>
   <th width="60" align="left" valign="bottom">&nbsp;</th>
   <th width="60" align="left" valign="bottom">&nbsp;</th>
   <th width="60" align="left" valign="bottom">&nbsp;</th>
   <th width="60" align="left" valign="bottom">&nbsp;</th>
   <th colspan="3" align="left" valign="bottom">MATTRESS</th>
   <th colspan="3" align="left" valign="bottom">BASE</th>
   <th colspan="3" align="left" valign="bottom">TOPPER</th>
   <th colspan="3" align="left" valign="bottom">HEADBOARD</th>
   <th colspan="3" align="left" valign="bottom">LEGS</th>
   <th colspan="3" align="left" valign="bottom">VALANCE</th>
   <th width="66" align="left" valign="bottom">&nbsp;</th>
   <th width="52" align="left" valign="bottom">&nbsp;</th>
 </tr>
 <tr>
    <th width="57" align="left" valign="bottom"><b>Customer Name<a href="production-list.asp?customerasc=d&factory=<%=factory%>&cwc=<%=cwc%>"><br>
      <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?customerasc=a&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b></th>
       <th width="60" align="left" valign="bottom"><strong>Company<br>
       </strong><b><a href="production-list.asp?companyasc=d&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?companyasc=a&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b></th>
       <th width="60" align="left" valign="bottom"><strong>Order Source<a href="production-list.asp?showr=d&factory=<%=factory%>&cwc=<%=cwc%>"><br>
           <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?showr=a&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="0"></a></strong></th> 
       <th width="60" align="left" valign="bottom"><b>Order No<a href="production-list.asp?orderasc=d&factory=<%=factory%>&cwc=<%=cwc%>"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?orderasc=a&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="0"></a></b></th>
       <th width="60" align="left" valign="bottom"><b>Order<br>
         Date</b></th>

    <th width="51" align="left" valign="bottom"><b>Required</b></th>

    <th width="48" align="left" valign="bottom"><b> Made At<br>
    </b>
    	<b><a href="production-list.asp?matt_madeat=d&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?matt_madeat=a&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    <th width="54" align="left" valign="bottom"><strong> Order Status</strong></th>
    <th width="51" align="left" valign="bottom"><strong> Required</strong></th>
    <th width="48" align="left" valign="bottom"><strong>Made At<br>
    </strong>
       	<b><a href="production-list.asp?base_madeat=d&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?base_madeat=a&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
      <th width="36" align="left" valign="bottom">  <strong> Order Status</strong></th>
    <th width="51" align="left" valign="bottom"><strong> Required</strong></th>
    <th width="48" align="left" valign="bottom"><strong>Made At</strong><br>
       	<b><a href="production-list.asp?topper_madeat=d&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?topper_madeat=a&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    <th width="41" align="left" valign="bottom"><strong> Order Status</strong></th>
    <th width="51" align="left" valign="bottom"><strong>Required</strong></th>
    <th width="48" align="left" valign="bottom"><strong> Made At</strong>
       	<br>
       	<b><a href="production-list.asp?headboard_madeat=d&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?headboard_madeat=a&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    <th width="64" align="left" valign="bottom"><strong> Order Status</strong></th>
  <th width="51" align="left" valign="bottom"><strong> Required</strong></th>
    <th width="48" align="left" valign="bottom"><strong>Made At</strong><br>
       	<b><a href="production-list.asp?legs_madeat=d&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?legs_madeat=a&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    
    <th width="64" align="left" valign="bottom"><strong> Order Status</strong></th>
  <th width="51" align="left" valign="bottom"><strong> Required</strong></th>
    <th width="48" align="left" valign="bottom"><strong>Made At</strong><br>
       	<b><a href="production-list.asp?valance_madeat=d&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?valance_madeat=a&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    
    <th width="36" align="left" valign="bottom"><strong>Order Status</strong></th>
    <th align="left" valign="bottom"><strong>Production Date<a href="production-list.asp?productiondate=d&factory=<%=factory%>&cwc=<%=cwc%>"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?productiondate=a&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="0"></a></strong>&nbsp;</th>
    <th align="left" valign="bottom"><strong>Booked Delivery Date
      <a href="production-list.asp?bookeddate=d&factory=<%=factory%>&cwc=<%=cwc%>"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?bookeddate=a&factory=<%=factory%>&cwc=<%=cwc%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="0"></a></strong>&nbsp;</th>
    </tr>
 </thead>
 <tbody>
	<%Do until rs.EOF%>

	  <tr>
	    <td width="57" align="left" valign="top"><%
	response.Write("<a href=""orderdetails.asp?pn=" & rs("purchase_no") & """>")
	If rs("surname")<>"" then response.write(rs("surname") & ", ")
	If rs("title")<>"" then response.write(rs("title") & " ")
	If rs("first")<>"" then response.write(rs("first") & " ")
	response.Write("</a>")
	%>&nbsp;</td>
	        <td width="60" align="left" valign="top"><%
	If rs("company")<>"" then response.write(rs("company"))
	%>&nbsp;</td>
	        <td width="60" align="left" valign="top"><%=rs("adminheading")%>&nbsp;</td>
	        <td width="60" align="left" valign="top"><a href="orderdetails.asp?pn=<%=rs("purchase_no")%>"><%If rs("order_number")<>"" then response.write(rs("order_number") & " ")%></a>&nbsp;</td>
	        <td width="60" align="left" valign="top"><%If rs("order_date")<>"" then response.write(left(rs("order_date"),10) & " ")%>
	          &nbsp;</td>
	
		<!-- mattress -->
		<% if showComponent(rs, cwc, "matt_madeat", "mattressrequired", "matt_status", factory) then %>
		    <td align="left" valign="top" class="borderleft"><%=rs("savoirmodel")%>&nbsp;</td>
	        <td align="left" valign="top" class="<%=getBorderClass(rs, "matt_madeat")%>">
			<% if parseMadeat(rs("matt_madeat")) > -1 then response.write(factories(parseMadeat(rs("matt_madeat")))) %>&nbsp;</td>
		    <td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 1)%>"><%=getComponentStatusTxtLatest(rs("purchase_no"), 1, con)%><br /><%=getComponentBay(con, rs("order_number"), 1)%>&nbsp;</td>
        <% else %>
		    <td align="left" valign="top" class="borderleft">&nbsp;</td>
	        <td align="left" valign="top">&nbsp;</td>
		    <td align="left" valign="top">&nbsp;</td>
        <% end if %>
	    
		<!-- base -->
		<% if showComponent(rs, cwc, "base_madeat", "baserequired", "base_status", factory) then %>
		    <td align="left" valign="top" class="borderleft"><%=rs("basesavoirmodel")%>&nbsp;</td>
	        <td align="left" valign="top" class="<%=getBorderClass(rs, "base_madeat")%>">
			<% if parseMadeat(rs("base_madeat")) > -1 then response.write(factories(parseMadeat(rs("base_madeat")))) %>&nbsp;</td>
		    <td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 3)%>"><%=getComponentStatusTxtLatest(rs("purchase_no"), 3, con)%><br /><%=getComponentBay(con, rs("order_number"), 3)%>&nbsp;</td>
        <% else %>
		    <td align="left" valign="top" class="borderleft">&nbsp;</td>
	        <td align="left" valign="top">&nbsp;</td>
		    <td align="left" valign="top">&nbsp;</td>
        <% end if %>
        
		<!-- topper -->
		<% if showComponent(rs, cwc, "topper_madeat", "topperrequired", "topper_status", factory) then %>
		    <td align="left" valign="top" class="borderleft"><%=rs("toppertype")%>&nbsp;</td>
	        <td align="left" valign="top" class="<%=getBorderClass(rs, "topper_madeat")%>">
			<% if parseMadeat(rs("topper_madeat")) > -1 then response.write(factories(parseMadeat(rs("topper_madeat")))) %>&nbsp;</td>
		    <td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 5)%>"><%=getComponentStatusTxtLatest(rs("purchase_no"), 5, con)%><br /><%=getComponentBay(con, rs("order_number"), 5)%>&nbsp;</td>
        <% else %>
		    <td align="left" valign="top" class="borderleft">&nbsp;</td>
	        <td align="left" valign="top">&nbsp;</td>
		    <td align="left" valign="top">&nbsp;</td>
        <% end if %>

		<!-- headboard -->
		<% if showComponent(rs, cwc, "headboard_madeat", "headboardrequired", "headboard_status", factory) then %>
		    <td align="left" valign="top" class="borderleft"><%=rs("headboardstyle")%>&nbsp;</td>
	        <td align="left" valign="top" class="<%=getBorderClass(rs, "headboard_madeat")%>">
			<% if parseMadeat(rs("headboard_madeat")) > -1 then response.write(factories(parseMadeat(rs("headboard_madeat")))) %>&nbsp;</td>
		    <td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 8)%>"><%=getComponentStatusTxtLatest(rs("purchase_no"), 8, con)%><br /><%=getComponentBay(con, rs("order_number"), 8)%>&nbsp;</td>
        <% else %>
		    <td align="left" valign="top" class="borderleft">&nbsp;</td>
	        <td align="left" valign="top">&nbsp;</td>
		    <td align="left" valign="top">&nbsp;</td>
        <% end if %>
  
		<!-- legs -->
		<% if showComponent(rs, cwc, "legs_madeat", "legsrequired", "legs_status", factory) then %>
		    <td align="left" valign="top" class="borderleft"><%=rs("legstyle")%>&nbsp;</td>
	        <td align="left" valign="top" class="<%=getBorderClass(rs, "legs_madeat")%>">
			<% if parseMadeat(rs("legs_madeat")) > -1 then response.write(factories(parseMadeat(rs("legs_madeat")))) %>&nbsp;</td>
		    <td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 7)%>"><%=getComponentStatusTxtLatest(rs("purchase_no"), 7, con)%><br /><%=getComponentBay(con, rs("order_number"), 7)%>&nbsp;</td>
        <% else %>
		    <td align="left" valign="top" class="borderleft">&nbsp;</td>
	        <td align="left" valign="top">&nbsp;</td>
		    <td align="left" valign="top">&nbsp;</td>
        <% end if %>

<!-- valance -->
		<% if showComponent(rs, cwc, "valance_madeat", "valancerequired", "valance_status", factory) then %>
		    <td align="left" valign="top" class="borderleft"><%if rs("valancefabric")<>"" then response.Write(rs("valancefabric") & " ")
			if rs("valancefabricchoice")<>"" then response.Write(rs("valancefabricchoice"))
			%>&nbsp;</td>
	        <td align="left" valign="top" class="<%=getBorderClass(rs, "valance_madeat")%>">
			<% if parseMadeat(rs("legs_madeat")) > -1 then response.write(factories(parseMadeat(rs("valance_madeat")))) %>&nbsp;</td>
		    <td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 6)%>"><%=getComponentStatusTxtLatest(rs("purchase_no"), 6, con)%><br /><%=getComponentBay(con, rs("order_number"), 6)%>&nbsp;</td>
        <% else %>
		    <td align="left" valign="top" class="borderleft">&nbsp;</td>
	        <td align="left" valign="top">&nbsp;</td>
		    <td align="left" valign="top">&nbsp;</td>
        <% end if %>        
        

	    <td width="18" align="left" valign="top" class="borderleft"><%=rs("productiondate")%>&nbsp;</td><td width="17" align="left" valign="top"><%=rs("bookeddeliverydate")%>&nbsp;</td>
	    </tr>
	<%

rs.movenext
loop%>
</tbody></table>
</div>
<%if rs.recordcount>20 then%>
  <p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
  <%end if%>
<%rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>
    

    
  </p>

<!--</form>-->
<div id="topright">
<form action="prodlist-csv.asp"  method="post" name="form1">

<input name="prodsql" type="hidden" value="<%=sql2%>">
<input name="submit" type="submit" value="Produce CSV File">
</form>
</div>
</div>
</div>
<div>

       
</body>
</html>

<%
function getComponentCellStatusClass(byref acon, aPurchaseNo, aCompId)
	dim aStatus
	aStatus = getComponentStatusLatest(acon, aPurchaseNo, aCompId)
	getComponentCellStatusClass = ""
	if aStatus < 20 then getComponentCellStatusClass = "redcell"
end function

function parseMadeat(byref aval)
	parseMadeat = -1

	on error resume next
		parseMadeat = cint(cstr(aval))
	if err.number <> 0 then
		parseMadeat = -1
	end if
	on error goto 0
	'response.write("<br>aval = " & cstr(aval))
	'response.write("<br>parseMadeat = " & parseMadeat)
	'response.end
	
end function

function showComponent(byref ars, byref acwc, aMadeAtColName, aRequiredColName, aStatusColName, aFactory)
	dim aParsedMadeAt
	if not ars(aRequiredColName)="y" then
		showComponent = false
		exit function
	end if
	
	if acwc then
		aParsedMadeAt = parseMadeat(ars(aMadeAtColName))
		if (aParsedMadeAt = aFactory or aParsedMadeAt = -1) and ars(aStatusColName) = "2" then
			showComponent = true
		else
			showComponent = false
		end if
	else
		showComponent = true
	end if
end function

function getBorderClass(byref ars, aMadeAtColName)
	if parseMadeat(ars(aMadeAtColName)) = -1 then
		getBorderClass = "redborder"
	else
		getBorderClass = ""
	end if
end function
%>

<script>

    function scrolify(tblAsJQueryObject, height) {
        var oTbl = tblAsJQueryObject;

        // for very large tables you can remove the four lines below
        // and wrap the table with <div> in the mark-up and assign
        // height and overflow property  
        var oTblDiv = $("<div/>");
        oTblDiv.css('height', height);
        oTblDiv.css('overflow','scroll');               
        oTbl.wrap(oTblDiv);

        // save original width
        oTbl.attr("data-item-original-width", oTbl.width());
        oTbl.find('thead tr td').each(function(){
            $(this).attr("data-item-original-width",$(this).width());
        }); 
        oTbl.find('tbody tr:eq(0) td').each(function(){
            $(this).attr("data-item-original-width",$(this).width());
        });                 


        // clone the original table
        var newTbl = oTbl.clone();

        // remove table header from original table
        oTbl.find('thead tr').remove();                 
        // remove table body from new table
        newTbl.find('tbody tr').remove();   

        oTbl.parent().parent().prepend(newTbl);
        newTbl.wrap("<div/>");

        // replace ORIGINAL COLUMN width                
        newTbl.width(newTbl.attr('data-item-original-width'));
        newTbl.find('thead tr td').each(function(){
            $(this).width($(this).attr("data-item-original-width"));
        });     
        oTbl.width(oTbl.attr('data-item-original-width'));      
        oTbl.find('tbody tr:eq(0) td').each(function(){
            $(this).width($(this).attr("data-item-original-width"));
        });                 
    }

    $(document).ready(function(){
        scrolify($('#tblNeedsScrolling'), 460); // 160 is height
    });


</script>
 <script language="JavaScript">
<!--

function selectAll() {

	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = true;
	        }
	    }
	}

}

function deselectAll() {

	if (document.form1.elements) {
	    for (var j = 0; j < document.form1.elements.length; j++) {
	        var e = document.form1.elements[j];
	        if (e.type == "checkbox" && e.name.length > 2 && e.name.substr(0,3) == "XX_" ) {
	            e.checked = false;
	        }
	    }
	}

}

//-->
</script>
   
<!-- #include file="common/logger-out.inc" -->
