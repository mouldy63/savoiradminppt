<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, customerasc, orderasc, showr,  companyasc, bookeddate, productiondate, previousOrderNumber, acknowDateWarning, rs2, compstatus
dim matt_madeat, base_madeat, topper_madeat, headboard_madeat, legs_madeat, factory, bold, stat
dim diff, factories
stat=request("stat")
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
sql = sql & "select purchase_no,order_number,c.first,c.surname,c.title"
sql = sql & ",company,adminheading,order_date,productiondate,bookeddeliverydate"
sql = sql & ",mattressrequired,legsrequired,baserequired,headboardrequired,topperrequired"
sql = sql & ",basesavoirmodel,savoirmodel,headboardstyle,legstyle,toppertype"

sql = sql & " , (Select madeat from qc_history_latest h where h.componentid=1 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) as matt_madeat" 
sql = sql & " , (Select madeat from qc_history_latest h where h.componentid=3 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) as base_madeat" 
sql = sql & " , (Select madeat from qc_history_latest h where h.componentid=5 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) as topper_madeat" 
sql = sql & " , (Select madeat from qc_history_latest h where h.componentid=8 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) as headboard_madeat" 
sql = sql & " , (Select madeat from qc_history_latest h where h.componentid=7 AND h.purchase_no=P.purchase_no and h.madeat is not null and h.madeat<> 0) as legs_madeat" 

sql = sql & " , (Select qc_statusid from qc_history_latest h where h.componentid=0 AND h.purchase_no=P.purchase_no) as order_status"

sql = sql & " from address A, contact C, Purchase P" 
sql = sql & ", Location L"
sql = sql & " Where P.purchase_no IN (SELECT Distinct purchase_no FROM qc_history_latest) and (P.cancelled is null or P.cancelled <> 'y') AND C.retire='n' AND A.code=C.code AND C.contact_no=P.contact_no AND P.completedorders='n' AND P.quote='n' AND  P.orderonhold<>'y' "
sql = sql & " AND P.idlocation=L.idlocation "
sql = sql & " AND P.source_site='SB' " 

if showr="a" then
sql = sql & " order by L.adminheading asc"
end if
if showr="d" then
sql = sql & " order by L.adminheading desc"
end if
if customerasc="a" then
sql = sql & " order by C.surname asc"
end if
if customerasc="d" then
sql = sql & " order by C.surname desc"
end if
if orderasc="a" then
sql = sql & " order by P.order_number asc"
end if
if orderasc="d" then
sql = sql & " order by P.order_number desc"
end if
if companyasc="a" then
sql = sql & " order by A.company asc"
end if
if companyasc="d" then
sql = sql & " order by A.company desc"
end if

if bookeddate="a" then
sql = sql & " order by P.bookeddeliverydate asc"
end if
if bookeddate="d" then
sql = sql & " order by P.bookeddeliverydate desc"
end if

if productiondate="a" then
	sql = sql & " order by P.productiondate asc"
end if
if productiondate="d" then
	sql = sql & " order by P.productiondate desc"
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

if customerasc=""  and  orderasc="" and companyasc=""  and bookeddate=""  and showr="" and productiondate="" and matt_madeat="" and base_madeat="" and topper_madeat="" and headboard_madeat="" and legs_madeat="" then
	sql = sql & " order by CAST(P.order_number as decimal) asc"
end if

' order status must be 'awaiting confirmation', 'on order', 'in production', 'order on hold', 'part delivered'
sql = sql & ") as x where x.order_status in (0,2,4,10,20,90,130)"

if factory <> -1 then
	if factory = 0 then
		' unassigned
		sql = sql & " and (x.matt_madeat is null OR x.matt_madeat=0 OR x.base_madeat is null OR x.base_madeat=0 OR x.topper_madeat is null OR x.topper_madeat=0 OR x.headboard_madeat is null OR x.headboard_madeat=0 OR x.legs_madeat is null OR x.legs_madeat=0)"
	else
		sql = sql & " and (x.matt_madeat=" & factory & " OR x.base_madeat=" & factory & " OR x.topper_madeat=" & factory & " OR x.headboard_madeat=" & factory & " OR x.legs_madeat=" & factory & ")"
	end if
end if


response.write("<br>" & sql & "<br>")
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
response.Write("Total = " & rs.recordcount & "<br /><br />")
factories = getFactories(con)

%>
 
<p align="center"><% bold = (factory=2)%>
&nbsp;<a href="production-list.asp?factory=2&stat=WTC"><%if bold then%><b><%end if%>London Confirmed Waiting to Check<%if bold then%></b><%end if%></a>&nbsp;&nbsp;&nbsp;&nbsp;
<% bold = (factory=1)%>
&nbsp;<a href="production-list.asp?factory=1&stat=WTC"><%if bold then%><b><%end if%>Cardiff Confirmed Waiting to Check<%if bold then%></b><%end if%></a>
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
   <th width="66" align="left" valign="bottom">&nbsp;</th>
   <th width="52" align="left" valign="bottom">&nbsp;</th>
 </tr>
 <tr>
    <th width="57" align="left" valign="bottom"><b>Customer Name<a href="production-list.asp?customerasc=d&factory=<%=factory%>"><br>
      <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?customerasc=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b></th>
       <th width="60" align="left" valign="bottom"><strong>Company<br>
       </strong><b><a href="production-list.asp?companyasc=d&factory=<%=factory%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?companyasc=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b></th>
       <th width="60" align="left" valign="bottom"><strong>Order Source<a href="production-list.asp?showr=d&factory=<%=factory%>"><br>
           <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?showr=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="0"></a></strong></th> 
       <th width="60" align="left" valign="bottom"><b>Order No<a href="production-list.asp?orderasc=d&factory=<%=factory%>"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?orderasc=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="0"></a></b></th>
       <th width="60" align="left" valign="bottom"><b>Order<br>
         Date</b></th>

    <th width="51" align="left" valign="bottom"><b>Required</b></th>

    <th width="48" align="left" valign="bottom"><b> Made At<br>
    </b>
    	<b><a href="production-list.asp?matt_madeat=d&factory=<%=factory%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?matt_madeat=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    <th width="54" align="left" valign="bottom"><strong> Order Status</strong></th>
    <th width="51" align="left" valign="bottom"><strong> Required</strong></th>
    <th width="48" align="left" valign="bottom"><strong>Made At<br>
    </strong>
       	<b><a href="production-list.asp?base_madeat=d&factory=<%=factory%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?base_madeat=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
      <th width="36" align="left" valign="bottom">  <strong> Order Status</strong></th>
    <th width="51" align="left" valign="bottom"><strong> Required</strong></th>
    <th width="48" align="left" valign="bottom"><strong>Made At</strong><br>
       	<b><a href="production-list.asp?topper_madeat=d&factory=<%=factory%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?topper_madeat=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    <th width="41" align="left" valign="bottom"><strong> Order Status</strong></th>
    <th width="51" align="left" valign="bottom"><strong>Required</strong></th>
    <th width="48" align="left" valign="bottom"><strong> Made At</strong>
       	<br>
       	<b><a href="production-list.asp?headboard_madeat=d&factory=<%=factory%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?headboard_madeat=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    <th width="64" align="left" valign="bottom"><strong> Order Status</strong></th>
  <th width="51" align="left" valign="bottom"><strong> Required</strong></th>
    <th width="48" align="left" valign="bottom"><strong>Made At</strong><br>
       	<b><a href="production-list.asp?legs_madeat=d&factory=<%=factory%>"><img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?legs_madeat=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle"border></a></b>
    </th>
    <th width="36" align="left" valign="bottom"><strong>Order Status</strong></th>
    <th align="left" valign="bottom"><strong>Production Date<a href="production-list.asp?productiondate=d&factory=<%=factory%>"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?productiondate=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="0"></a></strong>&nbsp;</th>
    <th align="left" valign="bottom"><strong>Booked Delivery Date
      <a href="production-list.asp?bookeddate=d&factory=<%=factory%>"><br>
        <img src="img/desc.gif" alt="Descending" width="24" height="21" align="middle" border="0"></a><a href="production-list.asp?bookeddate=a&factory=<%=factory%>"><img src="img/asc.gif" alt="Ascending" width="24" height="21" align="middle" border="0"></a></strong>&nbsp;</th>
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
        <%
		if stat="WTC" and getComponentStatusLatest(con, rs("purchase_no"), 1)="2" and (parseMadeat(rs("matt_madeat"))=factory) then%>
                   <td align="left" valign="top" class="borderleft"><%if rs("mattressrequired")="y" then response.Write(rs("savoirmodel"))%>&nbsp;<br><%response.Write("stat=" & stat & ", status=" & getComponentStatus(con, rs("purchase_no"), 1) & "factory=" & factory)%></td>
                <% if parseMadeat(rs("matt_madeat")) = -1 and rs("mattressrequired")="y" then%>
                    <td align="left" valign="top" class="redborder">
                <%else%>
                    <td align="left" valign="top" >
                <%end if%>
                <% if parseMadeat(rs("matt_madeat")) = factory and rs("mattressrequired")="y" then response.write(factories(parseMadeat(rs("matt_madeat")))) %>&nbsp;</td>
                <%if rs("mattressrequired")="y" then%>
                    <td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 1)%>"><%=getComponentStatusTxt(rs("purchase_no"), 1, con)%>&nbsp;</td>
                <%else%>
                    <td align="left" valign="top">&nbsp;</td>
                <%end if%>
        <%end if
		if stat="" then%>
                   <td align="left" valign="top" class="borderleft"><%if rs("mattressrequired")="y" then response.Write(rs("savoirmodel"))%>&nbsp;</td>
                <% if parseMadeat(rs("matt_madeat")) = -1 and rs("mattressrequired")="y" then%>
                    <td align="left" valign="top" class="redborder">
                <%else%>
                    <td align="left" valign="top" >
                <%end if%>
                <% if parseMadeat(rs("matt_madeat")) > -1 and rs("mattressrequired")="y" then response.write(factories(parseMadeat(rs("matt_madeat")))) %>&nbsp;</td>
                <%if rs("mattressrequired")="y" then%>
                    <td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 1)%>"><%=getComponentStatusTxt(rs("purchase_no"), 1, con)%>&nbsp;</td>
                <%else%>
                    <td align="left" valign="top">&nbsp;</td>
                <%end if%>
        <%end if%>
	 
	    
		<!-- base -->
        <%if stat="WTC" and getComponentStatusLatest(con, rs("purchase_no"), 3)="2" and (parseMadeat(rs("matt_madeat"))=factory) then%>
                <td align="left" valign="top" class="borderleft"><%if rs("baserequired")="y" then response.Write(rs("basesavoirmodel"))%>&nbsp;</td>
                <% if parseMadeat(rs("base_madeat")) = -1 and rs("baserequired")="y" then%>
                    <td align="left" valign="top" class="redborder">
                <%else%>
                    <td align="left" valign="top">
                <%end if%>
                <% if parseMadeat(rs("base_madeat")) > -1 and rs("baserequired")="y" then response.write(factories(parseMadeat(rs("base_madeat")))) %>&nbsp;</td>
                <%if rs("baserequired")="y" then%>
                    <td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 3)%>"><%=getComponentStatusTxt(rs("purchase_no"), 3, con)%>&nbsp;</td>
                <%else%>
                    <td align="left" valign="top">&nbsp;</td>
                <%end if%>
          <%end if
		if stat="" then%>
                        <td align="left" valign="top" class="borderleft"><%if rs("baserequired")="y" then response.Write(rs("basesavoirmodel"))%>&nbsp;</td>
                <% if parseMadeat(rs("base_madeat")) = -1 and rs("baserequired")="y" then%>
                    <td align="left" valign="top" class="redborder">
                <%else%>
                    <td align="left" valign="top">
                <%end if%>
                <% if parseMadeat(rs("base_madeat")) > -1 and rs("baserequired")="y" then response.write(factories(parseMadeat(rs("base_madeat")))) %>&nbsp;</td>
                <%if rs("baserequired")="y" then%>
                    <td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 3)%>"><%=getComponentStatusTxt(rs("purchase_no"), 3, con)%>&nbsp;</td>
                <%else%>
                    <td align="left" valign="top">&nbsp;</td>
                <%end if%>
        <%end if%>
	    
        
		<!-- topper -->
        <%if stat="WTC" and getComponentStatusLatest(con, rs("purchase_no"), 5)="2" and (parseMadeat(rs("matt_madeat"))=factory) then%>
                <td align="left" valign="top" class="borderleft"><%if rs("topperrequired")="y" then response.Write(rs("toppertype"))%>
                  &nbsp;</td>
                <% if parseMadeat(rs("topper_madeat")) = -1 and rs("topperrequired")="y" then%>
                    <td align="left" valign="top" class="redborder" >
                <%else%>
                    <td align="left" valign="top">
                <%end if%>
                <% if parseMadeat(rs("topper_madeat")) > -1 and rs("topperrequired")="y" then response.write(factories(parseMadeat(rs("topper_madeat")))) %>&nbsp;</td>
                <%if rs("topperrequired")="y" then%>
                    <td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 5)%>"><%=getComponentStatusTxt(rs("purchase_no"), 5, con)%>&nbsp;</td>
                <%else%>
                    <td align="left" valign="top">&nbsp;</td>
                <%end if%>
         <%end if
		if stat="" then%>
                <td align="left" valign="top" class="borderleft"><%if rs("topperrequired")="y" then response.Write(rs("toppertype"))%>
                  &nbsp;</td>
                <% if parseMadeat(rs("topper_madeat")) = -1 and rs("topperrequired")="y" then%>
                    <td align="left" valign="top" class="redborder" >
                <%else%>
                    <td align="left" valign="top">
                <%end if%>
                <% if parseMadeat(rs("topper_madeat")) > -1 and rs("topperrequired")="y" then response.write(factories(parseMadeat(rs("topper_madeat")))) %>&nbsp;</td>
                <%if rs("topperrequired")="y" then%>
                    <td align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 5)%>"><%=getComponentStatusTxt(rs("purchase_no"), 5, con)%>&nbsp;</td>
                <%else%>
                    <td align="left" valign="top">&nbsp;</td>
                <%end if%>
        <%end if%>
	    
	    
		<!-- headboard -->
         <%if stat="WTC" and getComponentStatusLatest(con, rs("purchase_no"), 8)="2" and (parseMadeat(rs("matt_madeat"))=factory) then%>
                         <td align="left" valign="top" class="borderleft"><%if rs("headboardrequired")="y" then response.Write(rs("headboardstyle"))%>
                    &nbsp;</td>
                <% if parseMadeat(rs("headboard_madeat")) = -1 and rs("headboardrequired")="y" then%>
                    <td align="left" valign="top" class="redborder" >
                <%else%>
                    <td width="17" align="left" valign="top">
                <%end if%>
                <% if parseMadeat(rs("headboard_madeat")) > -1 and rs("headboardrequired")="y" then response.write(factories(parseMadeat(rs("headboard_madeat")))) %>&nbsp;</td>
                <%if rs("headboardrequired")="y" then%>
                    <td width="17" align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 8)%>"><%=getComponentStatusTxt(rs("purchase_no"), 8, con)%>&nbsp;</td>
                <%else%>
                    <td width="1" align="left" valign="top" >&nbsp;</td>
                <%end if%>

           <%end if
		if stat="" then%>
                <td align="left" valign="top" class="borderleft"><%if rs("headboardrequired")="y" then response.Write(rs("headboardstyle"))%>
                    &nbsp;</td>
                <% if parseMadeat(rs("headboard_madeat")) = -1 and rs("headboardrequired")="y" then%>
                    <td align="left" valign="top" class="redborder" >
                <%else%>
                    <td width="17" align="left" valign="top">
                <%end if%>
                <% if parseMadeat(rs("headboard_madeat")) > -1 and rs("headboardrequired")="y" then response.write(factories(parseMadeat(rs("headboard_madeat")))) %>&nbsp;</td>
                <%if rs("headboardrequired")="y" then%>
                    <td width="17" align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 8)%>"><%=getComponentStatusTxt(rs("purchase_no"), 8, con)%>&nbsp;</td>
                <%else%>
                    <td width="1" align="left" valign="top" >&nbsp;</td>
                <%end if%>
   <%end if%>
		<!-- legs -->
        
        <%if stat="WTC" and getComponentStatusLatest(con, rs("purchase_no"), 7)="2" and (parseMadeat(rs("matt_madeat"))=factory) then%>
                <td width="18" align="left" valign="top" class="borderleft"><%if rs("legstyle")<>"" then response.Write(rs("legstyle"))%>
                    &nbsp;</td>
                <% if parseMadeat(rs("legs_madeat")) = -1 and rs("legsrequired") = "y" then%>
                    <td width="19" align="left" valign="top" class="redborder" >
                <%else%>
                    <td width="17" align="left" valign="top">
                <%end if%>
                <%'=rs("legs_madeat")%>
                <% if parseMadeat(rs("legs_madeat")) > -1 then response.write(factories(parseMadeat(rs("legs_madeat")))) %>&nbsp;</td>
                <% if rs("legsrequired") ="y" then%>
                    <td width="17" align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 7)%>"><%=getComponentStatusTxt(rs("purchase_no"), 7, con)%>&nbsp;</td>
                <%else%>
                    <td width="1" align="left" valign="top">&nbsp;</td>
                <%end if%>
         <%end if
		if stat="" then%>
                <td width="18" align="left" valign="top" class="borderleft"><%if rs("legstyle")<>"" then response.Write(rs("legstyle"))%>
                    &nbsp;</td>
                <% if parseMadeat(rs("legs_madeat")) = -1 and rs("legsrequired") = "y" then%>
                    <td width="19" align="left" valign="top" class="redborder" >
                <%else%>
                    <td width="17" align="left" valign="top">
                <%end if%>
                <%'=rs("legs_madeat")%>
                <% if parseMadeat(rs("legs_madeat")) > -1 then response.write(factories(parseMadeat(rs("legs_madeat")))) %>&nbsp;</td>
                <% if rs("legsrequired") ="y" then%>
                    <td width="17" align="left" valign="top" class="<%=getComponentCellStatusClass(con, rs("purchase_no"), 7)%>"><%=getComponentStatusTxt(rs("purchase_no"), 7, con)%>&nbsp;</td>
                <%else%>
                    <td width="1" align="left" valign="top">&nbsp;</td>
                <%end if%>
	    <%end if%>
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

<input name="prodsql" type="hidden" value="<%=sql%>">
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
	aStatus = getComponentStatus(acon, aPurchaseNo, aCompId)
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
   