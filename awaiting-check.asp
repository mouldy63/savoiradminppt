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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, msg, customerasc, orderasc, showr,  companyasc, bookeddate, productiondate, previousOrderNumber, acknowDateWarning, rs1, dateasc
dim diff, statusList
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

<%
Set Con = getMysqlConnection()
statusList = getStatusList(con)
' Confirmed, Waiting to Check orders
set rs = getAwaitingOrders(2, "n")
%>
<p>Confirmed Orders, Waiting for Check<b>:</b>&nbsp;Total = <%=rs.recordcount%></p>
<table border="0" cellpadding="6" cellspacing="2">
  <tr>
    <td width="75"><b>Order No<a href="awaiting-check.asp?orderasc=d"><br>
      <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="awaiting-check.asp?orderasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></b></td>
       <td width="56"><b>Order Date<br>
        <a href="awaiting-check.asp?dateasc=d"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="awaiting-check.asp?dateasc=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a>       </b></td>
    <%if userHasRole("ADMINISTRATOR") then%>
<td width="28"><strong>Showroom<br>
       <a href="awaiting-check.asp?showr=d"><br>
        <img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="awaiting-check.asp?showr=a"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></strong></td>
<td width="29">Mattress Spec</td>
<td width="59">Mattress Status</td>
<td width="59">Base Spec</td>
<td width="28">Base Status</td>
<td width="29">Topper Spec</td>
<td width="59">Topper Status</td>
<td width="59">Headboard Spec</td>
<td width="28">Headboard Status</td>
<td width="13">Legs Spec</td>
<td width="14">Legs Status</td>
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
	    <td valign="middle"><%If rs("order_number")<>"" then response.write(rs("order_number") & " ")%>&nbsp;</td>
        <td valign="middle"><%If rs("order_date")<>"" then response.write(rs("order_date") & " ")%>&nbsp;</td>
	    <%if userHasRole("ADMINISTRATOR") then%>
<td valign="middle"><%=rs("adminheading")%></td>
<td valign="middle"><%=rs("savoirmodel")%></td>
<td valign="middle"><%=getStatusName(rs("mattress_status"))%></td>
<td valign="middle"><%=rs("basesavoirmodel")%></td>
<td valign="middle"><%=getStatusName(rs("base_status"))%></td>
<td valign="middle"><%=rs("toppertype")%></td>
<td valign="middle"><%=getStatusName(rs("topper_status"))%> </td>
<td valign="middle"><%=rs("headboardstyle")%></td>
<td valign="middle"><%=getStatusName(rs("headboard_status"))%></td>
<td valign="middle"><%=rs("legstyle")%></td>
<td valign="middle"><%=getStatusName(rs("legs_status"))%></td>
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
	asql = asql & "select P.order_number,P.order_date,P.purchase_no,P.acknowdate,P.savoirmodel,P.basesavoirmodel,P.legstyle,P.headboardstyle,P.toppertype,C.surname,C.title,C.first,A.company,P.total,P.amendeddate"
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
	
	if orderasc="a" then
		asql = asql & " order by P.order_number asc"
	end if
	if orderasc="d" then
		asql = asql & " order by P.order_number desc"
	end if
	if dateasc="a" then
		asql = asql & " order by P.order_date asc"
	end if
	if dateasc="d" then
		asql = asql & " order by P.order_date desc"
	end if
	
	if customerasc=""  and  orderasc="" and companyasc=""  and bookeddate=""  and showr="" and productiondate="" then
		asql = asql & " order by P.order_number asc"
	end if
	asql = asql & " ) as x" 
	asql = asql & " where x.mattress_status=" & aStatusId & " or x.base_status=" & aStatusId & " or x.topper_status=" & aStatusId & " or x.valance_status=" & aStatusId & " or x.headboard_status=" & aStatusId & " or x.legs_status=" & aStatusId & " or x.accessories_status=" & aStatusId & " or x.order_status=" & aStatusId
	'response.write("<br>" & asql)
	
	Set getAwaitingOrders = getMysqlQueryRecordSet(asql, con)
end function

function getStatusName(aStatusId)
	if cint(aStatusId) = -1 then
		getStatusName = "N/A"
	else
		getStatusName = statusList(aStatusId)
	end if
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
