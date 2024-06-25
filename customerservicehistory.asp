<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR, SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, postcodefull, Con, rs, rs1, recordfound, id, rspostcode, submit, count, sql, msg, csnumberdesc, orderasc, showr,  csnumberasc, bookeddate, previousOrderNumber, acknowDateWarning, sortorder, replacementsum, scode, datefrom, datefrom1, dateto, dateto1, csvsql
replacementsum=0
dim diff
datefrom=""
dateto=""
datefrom=request("datefrom")
if datefrom <>"" then datefrom1=year(datefrom) & "/" & month(datefrom) & "/" & day(datefrom)
dateto=request("dateto")
if dateto <>"" then dateto1=year(dateto) & "/" & month(dateto) & "/" & day(dateto)
sortorder=request("sortorder")
If sortorder="" then sortorder="csnumber desc"
msg=""
msg=Request("msg")
count=0
submit=Request("submit") 
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
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
<script src="scripts/keepalive.js"></script>
<script>
$(function() {
var year = new Date().getFullYear();
$( "#datefrom" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true
});
$( "#datefrom" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
$( "#dateto" ).datepicker({
changeMonth: true,
yearRange: "1997:"+year,
changeYear: true
});
$( "#dateto" ).datepicker( "option", "dateFormat", "dd/mm/yy" );
});
</script>
</head>
<body>

<div class="container">
<!-- #include file="header.asp" -->
<div class="content brochure">
<div class="one-col head-col">
<%
sql = "Select distinct(purchase_no) from qc_history_latest where qc_statusid=70 and  qc_date >= '" & datefrom1 & "' and qc_date <= '" & dateto1 & "'"

sql = "Select * from customerservice where csclosed='y'"
if datefrom1<>"" then sql=sql & " AND datecaseclosed >= '" & datefrom1 & "'"
if dateto1<>"" then sql=sql & " AND datecaseclosed <= '" & dateto1 & "'"
sql=sql &  " order by " & sortorder 
csvsql=sql 
Set rs = getMysqlQueryRecordSet(sql, con)

If msg<>"" Then response.Write("<p><font color=""red"">" & msg & "</font></p>")%>
<p>Customer Service Closed Cases</p>
<form name="form1" method="post" action="customerservicehistory.asp">

<p>
<label for="datefrom" id="surname">
Choose between CS closed dates: From:
<input name="datefrom" type="text" class="text" id="datefrom" value="<%=datefrom%>" size="10" />
</label>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To:
<input name="dateto" type="text" class="text" id="dateto" value="<%=dateto%>" size="10" />

</p>
<p>
<input type="submit" name="submit" id="submit" value="Submit">
</p>
</form>
<div class="delfloatright"><form name="form2" method="post" action="customerservice-csv.asp">
<label>
<input type="submit" name="button" id="button" value="Download CSV file">
</label>
<input name="csvsql" value="<%=csvsql%>" type="hidden">
</form>
</div>
<p>
<%

response.Write("Number of closed reports = " & rs.recordcount)
'response.Write("sql = " & sql)
%>
<table width="100%" border="0" cellpadding="6" cellspacing="2">
<tr>
<td width="74" valign="bottom"><b>Customer Service No.<a href="customerservicehistory.asp?datefrom=<%=datefrom%>&dateto=<%=dateto%>&sortorder=csnumber desc"><br>
<br>
<img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="customerservicehistory.asp?datefrom=<%=datefrom%>&dateto=<%=dateto%>&sortorder=csnumber asc"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
<td width="57" valign="bottom"><strong>Location<br>
<br>
</strong><b><a href="customerservicehistory.asp?datefrom=<%=datefrom%>&dateto=<%=dateto%>&sortorder=showroom desc"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="customerservicehistory.asp?datefrom=<%=datefrom%>&dateto=<%=dateto%>&sortorder=showroom asc"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
<td width="47" valign="bottom"><strong>Order No<br>
<br>
</strong><b><a href="customerservicehistory.asp?datefrom=<%=datefrom%>&dateto=<%=dateto%>&sortorder=orderno desc"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="customerservicehistory.asp?datefrom=<%=datefrom%>&dateto=<%=dateto%>&sortorder=orderno asc"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle"border></a></b></td>
<td width="71" valign="bottom"><b>Customer Service Date<a href="customerservicehistory.asp?datefrom=<%=datefrom%>&dateto=<%=dateto%>&sortorder=dataentrydate desc"><br>
<br>
<img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="customerservicehistory.asp?datefrom=<%=datefrom%>&dateto=<%=dateto%>&sortorder=dataentrydate asc"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></b></td>

<td width="57" valign="bottom"><b>Date Closed<br>
<br>
</b><strong><a href="customerservicehistory.asp?datefrom=<%=datefrom%>&dateto=<%=dateto%>&sortorder=datecaseclosed desc"><img src="img/desc.gif" alt="Descending" width="34" height="30" align="middle" border="0"></a><a href="customerservicehistory.asp?datefrom=<%=datefrom%>&dateto=<%=dateto%>&sortorder=datecaseclosed asc"><img src="img/asc.gif" alt="Ascending" width="34" height="30" align="middle" border="0"></a></strong></td>
<td width="74" valign="bottom"><strong>Item Description</strong></td>
<td width="58" valign="bottom"><strong>Problem with Product</strong></td>
<td width="89" valign="bottom"><strong>Replacement Price</strong></td>
<td width="52" valign="bottom"><strong>Service Code</strong></td>
<td width="159" valign="bottom"><strong>Closing Notes</strong></td>
<td width="56" valign="bottom"><strong>Closed by</strong></td>

</tr>
<%Do until rs.EOF%>
<%' if rs("order_number") <> previousOrderNumber then
'rs("order_date")
'If the acknowledgement date is Null, and the Order Date is more than 7 days beyond than current date then a Red flag appears
'acknowDateWarning = false
'if (isnull(rs("acknowdate")) or rs("acknowdate") = "") and rs("order_date") <> "" then
'	diff = dateDiff("d", cdate(rs("order_date")), now())
'	acknowDateWarning = (diff > 7)
'end if
%>
<tr>
<td valign="top"><%
response.Write("<a href=""customerservicereport.asp?csid=" & rs("csid") & """>")
response.Write(rs("csnumber"))
response.Write("</a>")
%></td>
<td valign="top"><%
If rs("showroom")<>"" then response.write(rs("showroom"))
%></td>
<td valign="top"><%
If rs("orderno")<>"" then response.write(rs("orderno"))
%></td>
<td valign="top"><%If rs("dataentrydate")<>"" then response.write(rs("dataentrydate") & " ")%>&nbsp;</td>

<td valign="top">
<%response.Write(rs("datecaseclosed"))%>&nbsp;</td>
<td valign="top"><%response.Write(rs("itemdesc"))%>&nbsp;</td>
<td valign="top"><%response.Write(rs("problemdesc"))%>&nbsp;</td>
<td valign="top" align="right"><%if rs("replacementprice")<>"" then
response.Write("£" & formatnumber(rs("replacementprice"),2))
replacementsum=replacementsum+CDbl(rs("replacementprice"))
end if%>&nbsp;</td>
<td valign="top">
<%if isNull(rs("servicecode")) then
else
sql="Select * from service_code where servicecodeID=" & rs("servicecode")
Set rs1 = getMysqlQueryRecordSet(sql, con)
scode=rs1("servicecode")
response.Write(scode)
rs1.close
set rs1=nothing
end if
scode=""
%>&nbsp;</td>
<td valign="top"><%response.Write(rs("closedcasenotes"))%></td>
<td valign="top"><%response.Write(rs("closedby"))%></td>

</tr>

<%
count=count+1

rs.movenext
loop%>
<tr>
<td valign="top">TOTAL:</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top" align="right"><%response.Write("£" & formatnumber(replacementsum,2))%>&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
<td valign="top">&nbsp;</td>
</tr>
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
