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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, customerasc, orderasc, showr,  companyasc, bookeddate, productiondate, previousOrderNumber, acknowDateWarning
dim diff
companyasc=""
customerasc=""
orderasc=""
showr=""
showr=request("showr")
productiondate=request("productiondate")
bookeddate=request("bookeddate")
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
<% 
postcodefull=Request("postcode")
postcode=Replace(postcodefull, " ", "")
If msg<>"" Then response.Write("<p><font color=""red"">The Brochure Requests were " & msg & "</font></p>")%>
<p>Current Orders.</p>


<!--<form name="form1" method="post" action="">-->	
  <p>
<%
Set Con = getMysqlConnection()
sql = "Select * from address A, contact C, Purchase P" 
if userHasRole("ADMINISTRATOR") then 
sql = sql & ", Location L"
end if
sql = sql & " Where C.retire='n' AND P.orderonhold<>'y' AND C.contact_no<>319256 AND C.contact_no<>24188 AND A.code=C.code AND C.contact_no=P.contact_no AND P.completedorders='n' AND P.quote='n' "
if userHasRole("ADMINISTRATOR") then 
	sql = sql & " AND P.idlocation=L.idlocation "
else
	if not isSuperuser() and not userHasRole("ADMINISTRATOR") then
		sql = sql & " AND P.owning_region=" & retrieveuserregion()
		If retrieveuserlocation()<>1 then
			sql = sql & " AND P.idlocation in (" & makeBuddyLocationList(retrieveUserLocation(), con) & ")"
		end if
	'	sql = sql & " AND P.source_site='" & retrieveUserSite() & "'"
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

if customerasc=""  and  orderasc="" and companyasc=""  and bookeddate=""  and showr="" and productiondate="" then
sql = sql & " order by P.order_number asc"
end if

'response.write("<br>" & sql)
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)
response.Write("Total = " & rs.recordcount & "<br /><br />")
%>
<table border="0" cellpadding="6" cellspacing="2">
 <tr>
    <td width="88"><b>Customer Name<a href="current-orders.asp?customerasc=d"><br>
      <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="current-orders.asp?customerasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
       <td width="69"><strong>Company<br>
       </strong><b><a href="current-orders.asp?companyasc=d"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="current-orders.asp?companyasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td> 
       <td width="75"><b>Order No<a href="current-orders.asp?orderasc=d"><br>
        <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="current-orders.asp?orderasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></b></td>

    <td width="56"><b>Note Date</b></td>
    <td width="56"><b>Order Date</b></td>
    <td width="56"><b>Ackgt Date</b></td>
<%if userHasRole("ADMINISTRATOR") then%>
<td width="59"><strong>Showroom<br>
       <a href="current-orders.asp?showr=d"><br>
        <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="current-orders.asp?showr=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></strong></td>
<%end if%>
    <td width="68"><b>Order Value</b></td>
    <td width="86"><strong>Payments Total</strong></td>
    <td width="114"><strong>Balance Outstanding</strong></td>
    <td width="124"><strong>Production Date<br><a href="current-orders.asp?productiondate=d"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="current-orders.asp?productiondate=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a>
    <td width="124"><strong>Booked Delivery Date<br><a href="current-orders.asp?bookeddate=d"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="current-orders.asp?bookeddate=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a>
    </strong></td>
    <td width="21">&nbsp;</td>
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
	        <td valign="top"><%If rs("order_number")<>"" then response.write(rs("order_number") & " ")%>&nbsp;</td>
	
	    <td valign="top">&nbsp;
	    	<% if orderHasOverdueNote(con, rs("purchase_no")) then %><img src="img/redflag.jpg" alt="Warning" align="middle" border="0"><% end if %>
	    </td>
	    <td valign="top"><%If rs("order_date")<>"" then response.write(rs("order_date") & " ")%>&nbsp;</td>
	    <td valign="top">
	    	<%If rs("acknowdate")<>"" then response.write(rs("acknowdate") & " ")%>&nbsp;
	    	<% if acknowDateWarning then %><img src="img/redflag.jpg" alt="Warning" align="middle" border="0"><% end if %>
	    </td>
	<%if userHasRole("ADMINISTRATOR") then%>
<td><%=rs("adminheading")%></td>
<%end if%>
	    <td align="right" valign="top"><%If rs("total")<>"" then response.write(rs("total") & " ")%>&nbsp;</td>
	    <td align="right" valign="top"><%response.Write(rs("paymentstotal"))%>&nbsp;</td>
	    <td align="right" valign="top"><%response.Write(rs("balanceoutstanding"))%></td>
	    <td valign="top"><%If rs("productiondate")<>"" then response.Write(rs("productiondate"))%>&nbsp;</td>
	    <td valign="top"><%If rs("bookeddeliverydate")<>"" then response.Write(rs("bookeddeliverydate"))%>&nbsp;</td>
	    <td valign="top"><%'response.Write("<br>Reason for declining quote<label><input type=""text"" name=""decline"" id=""decline""></label>")
	'response.Write("Date Declined<label><input type=""text"" name=""datedeclined"" id=""datedeclined""></label>")%>&nbsp;</td>
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
