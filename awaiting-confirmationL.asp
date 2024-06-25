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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, msg, customerasc, orderasc, showr,  companyasc, bookeddate, productiondate, previousOrderNumber, acknowDateWarning, rs1,customerrefasc
dim diff
companyasc=""
customerasc=""
customerrefasc=""
orderasc=""
showr=""
showr=request("showr")
productiondate=request("productiondate")
bookeddate=request("bookeddate")
companyasc=request("companyasc")
customerasc=request("customerasc")
customerrefasc=request("customerrefasc")
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
<script type="text/javascript">
<!--
function printConfirm(pn){
var url = "ajaxGiveOrderConfirmationCode.asp?pn=" + pn + "&ts=" + (new Date()).getTime();
$.get(url, function(data) {
window.open("print-pdf.asp?aw=y&val=" + pn, "_blank");
if (confirm("Has the order confirmation been printed?")) {
window.location = 'edit-purchase.asp?qw=y&order='+pn;
}
});
}
// -->
</script> 
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
<p>Orders Awaiting Confirmation</p>

<p>


<p>
<%
Set Con = getMysqlConnection()

' awaiting confirmation orders
set rs = getAwaitingOrders(0, "n")
%>
<p><b>Awaiting Confirmation Orders:</b>&nbsp;Total = <%=rs.recordcount%></p>
<table border="0" cellpadding="6" cellspacing="2">
<tr>
<td width="43"><b>Customer Name<a href="awaiting-confirmation.asp?customerasc=d"><br>
<img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="awaiting-confirmation.asp?customerasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
<td width="43">Customer Ref.<b><a href="awaiting-confirmation.asp?customerrefasc=d"><br>
  <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="awaiting-confirmation.asp?customerrefasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
<td width="69"><strong>Company<br>
</strong><b><a href="awaiting-confirmation.asp?companyasc=d"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="awaiting-confirmation.asp?companyasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
<td width="75"><b>Order No<a href="awaiting-confirmation.asp?orderasc=d"><br>
<img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="awaiting-confirmation.asp?orderasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></b></td>
<%if NOT userHasRoleInList("NOPRICESUSER") then%>
<td width="68"><b>Order Total Price</b></td>
<%end if%>
<td width="56"><b>Order Date</b></td>
<td width="56"><b>Amended Date</b></td>
<%if userHasRole("ADMINISTRATOR") then%>
<td width="59"><strong>Showroom<br>
<a href="awaiting-confirmation.asp?showr=d"><br>
<img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="awaiting-confirmation.asp?showr=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></strong></td>
<%end if%>
<td width="21">&nbsp;</td>
</tr>
<%Do until rs.EOF%>
<% if rs("order_number") <> previousOrderNumber then
'If the acknowledgement date is Null, and the Order Date is more than 7 days beyond than current date then a Red flag appears
acknowDateWarning = false
if (isnull(rs("acknowdate")) or rs("acknowdate") = "") and rs("order_date") <> "" then
diff = dateDiff("d", cdate(rs("order_date")), now())
acknowDateWarning = (diff > 7)
end if

%>
	  <tr>
	    <td valign="middle"><%
	response.Write("<a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>")
	If rs("surname")<>"" then response.write(rs("surname") & ", ")
	If rs("title")<>"" then response.write(rs("title") & " ")
	If rs("first")<>"" then response.write(rs("first") & " ")
	response.Write("</a>")
	%></td>
	    <td valign="middle"><%=rs("customerreference")%>&nbsp;</td>
	        <td valign="middle"><%
	If rs("company")<>"" then response.write(rs("company"))
	%></td>
	        <td valign="middle"><%If rs("order_number")<>"" then response.write(rs("order_number") & " ")%>&nbsp;</td>
<%if NOT userHasRoleInList("NOPRICESUSER") then
	'if (retrieveuserid()<>181 and retrieveuserid()<>182) then%>
	        <td align="right" valign="middle"><%If rs("total")<>"" then response.write(rs("total") & " ")%>&nbsp;</td>
<%end if%>
<td valign="middle"><%If rs("order_date")<>"" then response.write(rs("order_date") & " ")%>&nbsp;</td>
<td valign="middle"><%=rs("amendeddate")

%>&nbsp;</td>
<%if userHasRole("ADMINISTRATOR") then%>
<td valign="middle"><%=rs("adminheading")%></td>
<%end if%>
<td width="21"><form name="form1" method="post" action="print-pdf.asp?aw=y&val=<%=rs("purchase_no")%>" target="_blank">
<input type="submit" name="orderconfirmation" id="orderconfirmation" value="Print Confirmation"  onClick="printConfirm(<%=rs("purchase_no")%>); return false;">
</form></td>

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

' showroom to amend orders
previousOrderNumber=""
set rs = getAwaitingOrders(4, "")
%>
<p><b>Showroom to Amend Orders:</b>&nbsp;Total = <%=rs.recordcount%></p>
<p>&nbsp;</p>
<table border="0" cellpadding="6" cellspacing="2">
 <tr>
    <td width="43"><b>Customer Name</b></td>
    <td width="43"><strong>Customer Ref.</strong></td>
       <td width="69"><b>Company</b></td> 
       <td width="75"><b>Order No</b></td>
       <%if NOT userHasRoleInList("NOPRICESUSER") then
	'if (retrieveuserid()<>181 and retrieveuserid()<>182) then%>
       <td width="68"><b>Order Total Price</b></td>
       <%end if%>

    <td width="56"><b>Order Date</b></td>
    <td width="56"><b>Amended Date</b></td>
<%if userHasRole("ADMINISTRATOR") then%>
<td width="59"><b>Showroom</b></td>
<%end if%>
</tr>
<%Do until rs.EOF%>
<% if rs("order_number") <> previousOrderNumber then
'If the acknowledgement date is Null, and the Order Date is more than 7 days beyond than current date then a Red flag appears
acknowDateWarning = false
if (isnull(rs("acknowdate")) or rs("acknowdate") = "") and rs("order_date") <> "" then
diff = dateDiff("d", cdate(rs("order_date")), now())
acknowDateWarning = (diff > 7)
end if

%>
	  <tr>
	    <td valign="middle"><%
	response.Write("<a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>")
	If rs("surname")<>"" then response.write(rs("surname") & ", ")
	If rs("title")<>"" then response.write(rs("title") & " ")
	If rs("first")<>"" then response.write(rs("first") & " ")
	response.Write("</a>")
	%></td>
	    <td valign="middle"><%=rs("customerreference")%></td>
	        <td valign="middle"><%
	If rs("company")<>"" then response.write(rs("company"))
	%></td>
	        <td valign="middle"><%If rs("order_number")<>"" then response.write(rs("order_number") & " ")%>&nbsp;</td>
            <%if NOT userHasRoleInList("NOPRICESUSER") then
	'if (retrieveuserid()<>181 and retrieveuserid()<>182) then%>
	        <td align="right" valign="middle"><%If rs("total")<>"" then response.write(rs("total") & " ")%>&nbsp;</td>
            <%end if%>
	
	    <td valign="middle"><%If rs("order_date")<>"" then response.write(rs("order_date") & " ")%>&nbsp;</td>
	    <td valign="middle"><%=rs("amendeddate")
		
		%>&nbsp;</td>
	<%if userHasRole("ADMINISTRATOR") then%>
<td valign="middle"><%=rs("adminheading")%></td>
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

function getAwaitingOrders(byval aStatusId, byval aConfirmationStatus)
dim asql

asql = "select * from ("
asql = asql & "select P.order_number,P.order_date,P.customerreference,P.acknowdate,P.purchase_no,C.surname,C.title,C.first,A.company,P.total,P.amendeddate"
if userHasRole("ADMINISTRATOR") then
asql = asql & ",L.adminheading"
end if
asql = asql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=1 AND h.purchase_no=P.purchase_no) then (Select h.qc_statusid from qc_history_latest h where h.componentid=1 AND h.purchase_no=P.purchase_no) else -1 end as mattress_status"
asql = asql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=3 AND h.purchase_no=P.purchase_no) then (Select h.qc_statusid from qc_history_latest h where h.componentid=3 AND h.purchase_no=P.purchase_no) else -1 end as base_status"
asql = asql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=5 AND h.purchase_no=P.purchase_no) then (Select h.qc_statusid from qc_history_latest h where h.componentid=5 AND h.purchase_no=P.purchase_no) else -1 end as topper_status"
asql = asql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=6 AND h.purchase_no=P.purchase_no) then (Select h.qc_statusid from qc_history_latest h where h.componentid=6 AND h.purchase_no=P.purchase_no) else -1 end as valance_status"
asql = asql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=8 AND h.purchase_no=P.purchase_no) then (Select h.qc_statusid from qc_history_latest h where h.componentid=8 AND h.purchase_no=P.purchase_no) else -1 end as headboard_status"
asql = asql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=7 AND h.purchase_no=P.purchase_no) then (Select h.qc_statusid from qc_history_latest h where h.componentid=7 AND h.purchase_no=P.purchase_no) else -1 end as legs_status"
asql = asql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=9 AND h.purchase_no=P.purchase_no) then (Select h.qc_statusid from qc_history_latest h where h.componentid=9 AND h.purchase_no=P.purchase_no) else -1 end as accessories_status"
asql = asql & " , case when exists (Select 1 from qc_history_latest h where h.componentid=0 AND h.purchase_no=P.purchase_no) then (Select h.qc_statusid from qc_history_latest h where h.componentid=0 AND h.purchase_no=P.purchase_no) else -1 end as order_status"

asql = asql & " from address A, contact C, Purchase P"
if userHasRole("ADMINISTRATOR") then
asql = asql & ", Location L"
end if

'asql = asql & " Where (P.cancelled is null or P.cancelled <> 'y') AND C.retire='n' AND P.orderonhold<>'y' AND orderConfirmationStatus='n' AND C.contact_no<>319256 AND C.contact_no<>24188 AND A.code=C.code AND C.contact_no=P.contact_no AND P.completedorders='n' AND P.quote='n' "
asql = asql & " Where (P.cancelled is null or P.cancelled <> 'y') AND C.retire='n' AND P.orderonhold<>'y'"

if aConfirmationStatus <> "" then
asql = asql & " AND orderConfirmationStatus='" & aConfirmationStatus & "'"
end if
asql = asql & " AND A.code=C.code AND C.contact_no=P.contact_no AND P.completedorders='n' AND P.quote='n' "

if userHasRole("ADMINISTRATOR") then
asql = asql & " AND P.idlocation=L.idlocation "
else
if not isSuperuser() and not userHasRole("ADMINISTRATOR") then
asql = asql & " AND P.owning_region=" & retrieveuserregion()
If retrieveuserlocation()<>1 and retrieveuserlocation()<>27 then 'Bedworks & Cardiff
asql = asql & " AND P.idlocation in (" & makeBuddyLocationList(retrieveUserLocation(), con) & ")"
end if
'	asql = asql & " AND P.source_site='" & retrieveUserSite() & "'"
end if
end if
asql = asql & " AND P.source_site='SB' "

if showr="a" then
asql = asql & " order by L.adminheading asc"
end if
if showr="d" then
asql = asql & " order by L.adminheading desc"
end if
if customerasc="a" then
asql = asql & " order by C.surname asc"
end if
if customerasc="d" then
asql = asql & " order by C.surname desc"
end if
if customerrefasc="a" then
asql = asql & " order by P.customerreference asc"
end if
if customerrefasc="d" then
asql = asql & " order by P.customerreference desc"
end if
if orderasc="a" then
asql = asql & " order by P.order_number asc"
end if
if orderasc="d" then
asql = asql & " order by P.order_number desc"
end if
if companyasc="a" then
asql = asql & " order by A.company asc"
end if
if companyasc="d" then
asql = asql & " order by A.company desc"
end if

if bookeddate="a" then
asql = asql & " order by P.bookeddeliverydate asc"
end if
if bookeddate="d" then
asql = asql & " order by P.bookeddeliverydate desc"
end if

if productiondate="a" then
asql = asql & " order by P.productiondate asc"
end if
if productiondate="d" then
asql = asql & " order by P.productiondate desc"
end if

if customerasc=""  and  orderasc="" and companyasc="" and customerrefasc="" and bookeddate=""  and showr="" and productiondate="" then
asql = asql & " order by P.order_number asc"
end if
asql = asql & " ) as x"
asql = asql & " where x.mattress_status=" & aStatusId & " or x.base_status=" & aStatusId & " or x.topper_status=" & aStatusId & " or x.valance_status=" & aStatusId & " or x.headboard_status=" & aStatusId & " or x.legs_status=" & aStatusId & " or x.accessories_status=" & aStatusId & " or x.order_status=" & aStatusId
response.write("<br>" & asql)

Set getAwaitingOrders = getMysqlQueryRecordSet(asql, con)
end function

Con.Close
Set Con = Nothing%>



</p>

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
