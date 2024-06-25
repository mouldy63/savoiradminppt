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
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, customerasc, orderasc, showr,  companyasc, deldate, productiondate, previousOrderNumber, acknowDateWarning, datefrom, dateto, showroom, url, reporttype, proddate, giftpack
dim diff
giftpack=request("giftpack")
reporttype=request("reporttype")
datefrom=request("datefrom")
datefrom=year(datefrom) & "/" & month(datefrom) & "/" & day(datefrom)
dateto=request("dateto")
dateto=year(dateto) & "/" & month(dateto) & "/" & day(dateto)
showroom=request("location")
companyasc=""
customerasc=""
orderasc=""
showr=""
showr=request("showr")
productiondate=request("productiondate")
deldate=request("deldate")
companyasc=request("companyasc")
customerasc=request("customerasc")
orderasc=request("orderasc")
msg=""
msg=Request("msg")
count=0
submit=Request("submit") 
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
<div class="content brochure">
<div class="one-col head-col">

<p><%response.write(ucase(left(reporttype,1)))%><%response.write(right(reporttype, len(reporttype)-1))%> Report</p>
<%if reporttype="delivery" then%>
<form name="form1" method="post" action="delivery-csv.asp?reporttype=delivery">
<%end if%>
<%if reporttype="production" then%>
<form name="form1" method="post" action="delivery-csv.asp?reporttype=production">
<%end if%>
<p>  <label>
    <input type="submit" name="button" id="button" value="Download CSV file">
  </label></p>


<!--<form name="form1" method="post" action="">-->	
  <p>
<%if userHasRole("Administrator") or retrieveuserid()=22 then
else
showroom=retrieveUserLocation()
end if
Set Con = getMysqlConnection()
sql = "Select * from address A, contact C, Purchase P" 
'if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER")  then 
sql = sql & ", Location L"
'end if
sql = sql & " Where (P.cancelled is null or P.cancelled <> 'y') AND C.retire='n' AND P.orderonhold<>'y' AND C.contact_no<>319256 AND C.contact_no<>24188 AND A.code=C.code AND C.contact_no=P.contact_no AND P.quote='n' "
if giftpack="y" then
sql=sql & " AND giftpackrequired = 'y'"
end if
if showroom<>"all" then
sql = sql & " AND L.idlocation=" & showroom & " "
end if


if reporttype="delivery" then
	sql = sql & " AND P.idlocation=L.idlocation and P.bookeddeliverydate is not null and P.bookeddeliverydate<>'' "
	if datefrom<>"" then
		sql = sql & " AND P.bookeddeliverydate >= '" & datefrom & "' " 
	end if
	if dateto<>"" then
		sql = sql & " AND P.bookeddeliverydate <= '" & dateto & "' " 
	end if
end if

if reporttype="production" then
	sql = sql & " AND P.idlocation=L.idlocation and P.production_completion_date is not null and P.production_completion_date<>''"
	if datefrom<>"" then
		sql = sql & " AND P.production_completion_date >= '" & datefrom & "' " 
	end if
	if dateto<>"" then
		sql = sql & " AND P.production_completion_date <= '" & dateto & "' " 
	end if
end if

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

if deldate="a" then
sql = sql & " order by P.bookeddeliverydate asc"
end if
if deldate="d" then
sql = sql & " order by P.bookeddeliverydate desc"
end if

if proddate="a" then
sql = sql & " order by P.production_completion_date asc"
end if
if proddate="d" then
sql = sql & " order by P.production_completion_date desc"
end if



if customerasc=""  and  deldate="" and orderasc="" and companyasc=""  and (deldate=""  or proddate="") and showr="" then
sql = sql & " order by P.order_number asc"
end if
url="giftpack=" & giftpack & "&reporttype=" & reporttype & "&datefrom=" & datefrom & "&dateto=" & dateto & "&location=" & showroom & "&"
'response.Write("sql=" & sql)
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
response.Write("Total = " & rs.recordcount & "<br /><br />")
%>
<table border="0" cellpadding="6" cellspacing="2">
 <tr>
    <td width="88"><b>Customer Name<a href="delivery-reports.asp?<%=url%>customerasc=d"><br>
      <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="delivery-reports.asp?<%=url%>customerasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
       <td width="33"><strong>Company<br>
       </strong><b><a href="delivery-reports.asp?<%=url%>companyasc=d"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="delivery-reports.asp?<%=url%>companyasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
       <td width="34">Ref.</td> 
       <td><b>Order No<a href="delivery-reports.asp?<%=url%>orderasc=d"><br>
        <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="delivery-reports.asp?<%=url%>orderasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></b></td>
       <%if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER") then%>
<td width="59"><strong>Order Source<br>
       <a href="delivery-reports.asp?<%=url%>showr=d"><br>
        <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="delivery-reports.asp?<%=url%>showr=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></strong></td>
<%end if%>
    <td width="68"><b>Order Value</b></td>
    <td width="80"><strong>Payments Total</strong></td>
    <td width="110"><strong>Balance Outstanding</strong></td>
    <%if reporttype="delivery" then%>
    <td width="124"><strong>Delivery Date<br><a href="delivery-reports.asp?<%=url%>deldate=d"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="delivery-reports.asp?<%=url%>deldate=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a>
    </strong></td>
    <%end if%>
    <td width="20">Confirmed Delivery</td>
    <%if reporttype="production" then%>
    <td width="124"><strong>Production Date<br><a href="delivery-reports.asp?<%=url%>proddate=d"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="delivery-reports.asp?<%=url%>proddate=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a>
    </strong></td>
    <%end if%>

    </tr>
<%Do until rs.EOF%>
<% if rs("order_number") <> previousOrderNumber then
'rs("order_date") 
'If the acknowledgement date is Null, and the Order Date is more than 7 days beyond than current date then a Red flag appears
acknowDateWarning = false
if (isnull(rs("acknowdate")) or rs("acknowdate") = "") and rs("order_date") <> "" then
	diff = dateDiff("d", cdate(rs("order_date")), now())
	acknowDateWarning = (diff > 7)
end if

%>
	  <tr>
	    <td valign="top"><%'response.Write("<p><input type=""checkbox"" name=""XX_" & rs("purchase_no") & """ id=""XX_" & rs("purchase_no") & """><a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>")
	response.Write("<a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>")
	If rs("surname")<>"" then response.write(rs("surname") & ", ")
	If rs("title")<>"" then response.write(rs("title") & " ")
	If rs("first")<>"" then response.write(rs("first") & " ")
	response.Write("</a>")
	%></td>
	        <td valign="top"><%
	If rs("company")<>"" then response.write(rs("company"))
	%></td>
	        <td valign="top"><%=rs("customerreference")%>&nbsp;</td>
	        <td valign="top"><%If rs("order_number")<>"" then response.write(rs("order_number") & " ")%>&nbsp;</td>
	
	    <%if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER") then%>
<td><%=rs("adminheading")%></td>
<%end if%>
	    <td align="right" valign="top"><%If rs("total")<>"" then response.write(rs("total") & " ")%>&nbsp;</td>
	    <td align="right" valign="top"><%response.Write(rs("paymentstotal"))%>&nbsp;</td>
	    <td align="right" valign="top"><%response.Write(rs("balanceoutstanding"))%></td>
        <%if reporttype="delivery" then%>
	    <td valign="top"><%If rs("bookeddeliverydate")<>"" then response.Write(rs("bookeddeliverydate"))%>&nbsp;</td>
        <%end if%>
        <td valign="top"><%If rs("DeliveryDateConfirmed")="y" then response.Write("Yes") else response.Write("No")%></td>
        <%if reporttype="production" then%>
	    <td valign="top"><%If rs("production_completion_date")<>"" then response.Write(rs("production_completion_date"))%>&nbsp;</td>
        <%end if%>
	  
	    </tr>
	<%
	count=count+1
	previousOrderNumber = rs("order_number")
end if
rs.movenext
loop%>
</table>
<%if rs.recordcount>20 then%>
  <p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
  <%end if%>
<%rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>
    
<input name="giftpack" type="hidden" value="<%=giftpack%>">
<input name="datefrom" type="hidden" value="<%=datefrom%>">
<input name="showroom" type="hidden" value="<%=showroom%>">
<input name="dateto" type="hidden" value="<%=dateto%>">
<input name="customerasc" type="hidden" value="<%=customerasc%>">
<input name="showr" type="hidden" value="<%=showr%>">
<input name="productiondate" type="hidden" value="<%=productiondate%>">
<input name="deldate" type="hidden" value="<%=deldate%>">
<input name="proddate" type="hidden" value="<%=proddate%>">
<input name="companyasc" type="hidden" value="<%=companyasc%>">
<input name="showr" type="hidden" value="<%=showr%>">
<input name="orderasc" type="hidden" value="<%=orderasc%>">
<input name="msg" type="hidden" value="<%=msg%>">
</form>
    
  </p>

<!--</form>-->
</div>
  </div>
<div>
</div>
       
</body>
</html>
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
