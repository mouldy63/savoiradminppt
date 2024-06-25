<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES,ACCOUNTS"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, dateasc, orderasc, customerasc, coasc, datefrom, datefromstr, datetostr, dateto, dateto1, user, rs2, rs3, receiptasc, amttotal, currencysym, ordervaltotal, totalpayments, totalos, location, payasc
location=""
location=request("location")
Set Con = getMysqlConnection()
user=Request("user")
'If user<>"all" then
	'Set rs2 = getMysqlQueryRecordSet("Select * from savoir_user where username='" & user & "'", con)
'		If rs2("name")<>"" then
'			user=rs2("name")
'		end if
'	rs2.close
'	set rs2=nothing
'end if
datefromstr=Request("datefrom")
If datefromstr <>"" then
datefrom=year(datefromstr) & "-" & month(datefromstr) & "-" & day(datefromstr)
end if
datetostr=Request("dateto")
If datetostr <>"" then
dateto=year(datetostr) & "-" & month(datetostr) & "-" & day(datetostr)
end if
amttotal=0
ordervaltotal=0
totalpayments=0
totalos=0
receiptasc=""
coasc=""
dateasc=""
customerasc=""
orderasc=""
receiptasc=request("receiptasc")
payasc=request("payasc")
coasc=request("coasc")
dateasc=request("dateasc")
customerasc=request("customerasc")
orderasc=request("orderasc")
msg=""
msg="You searched for orders "
If datefromstr<> "" then msg=msg & "dated from " & datefromstr
If datetostr<> "" then msg=msg & " - dated to " & datetostr
if user<>"" then msg = msg & " Source: " & user
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

<% 
postcodefull=Request("postcode")
postcode=Replace(postcodefull, " ", "")%>
<p>TRADE REPORT</p>
<form name="form1" method="post" action="trade-csv.asp">

<p>  <label>
    <input type="submit" name="button" id="button" value="Download CSV file">
  </label></p>



<!--<form name="form1" method="post" action="">-->	
  <p>
    <%
sql = "Select * from address A, contact C, Purchase P Where C.retire='n' AND A.code=C.code AND C.Code<>218766 AND C.code<>213190 AND C.contact_no=P.contact_no AND P.quote='n' and P.salesusername<>'dave' AND P.salesusername<>'maddy' "

if not isSuperuser()  and retrieveUserLocation()<>1 and retrieveUserLocation()<>23 and retrieveUserLocation()<>27 then
sql = sql & " AND P.idlocation=" & retrieveUserLocation() & ""
	'sql = sql & " AND A.source_site='" & retrieveUserSite() & "'"


else
	if location="all" then
	else
	sql = sql & " AND P.idlocation=" & location & ""
	end if
end if
'If retrieveUserLocation=1 then
'sql = sql & " AND C.owning_region=" & retrieveUserRegion() & ""
'end if
sql = sql & " AND A.source_site='SB' " 
If datefrom<>"" then
sql=sql & " AND P.order_date >= '" & datefrom & "'"
end if
If dateto<>"" then
dateto=DateAdd("d",1,dateto)
dateto=year(dateto) & "-" & month(dateto) & "-" & day(dateto)
sql=sql & " AND P.order_date <= '" & dateto & "'"
end if
'If user<>"all" then
'sql=sql & " AND Z.salesusername = '" & request("user") & "'"
'end if

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
if orderasc="a" then
sql = sql & " order by P.order_number asc"
end if
if dateasc="d" then
sql = sql & " order by P.order_date desc"
end if
if coasc="a" then
sql = sql & " order by A.company asc"
end if
if coasc="d" then
sql = sql & " order by A.company desc"
end if
if customerasc=""  and  orderasc="" and payasc="" and dateasc="" and coasc=""  then
sql = sql & " order by P.order_number asc"
end if

'response.write("<br>" & sql)
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)

If not rs.eof then

response.Write(msg & "<br>Total = " & rs.recordcount & "<br /><br />")%>
<table border="0" cellpadding="2" cellspacing="2" class="text">
 <tr><td valign="bottom"><b>Order Date</b>
       <a href="tradereport.asp?location=<%=location%>&dateasc=d&datefrom=<%=datefrom%>&dateto=<%=datetostr%>"><img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a>
 <a href="tradereport.asp?location=<%=location%>&dateasc=a&datefrom=<%=datefrom%>&dateto=<%=datetostr%>"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle"border></a>
 </td>
   
    <td valign="bottom">
    <b>Customer Name<br>
<a href="tradereport.asp?location=<%=location%>&customerasc=d&datefrom=<%=datefrom%>&dateto=<%=datetostr%>"><img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a>
<a href="tradereport.asp?location=<%=location%>&customerasc=a&datefrom=<%=datefrom%>&dateto=<%=datetostr%>"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle"border></a></b></td>
    <td valign="bottom">Company&nbsp;<br> 
<a href="tradereport.asp?location=<%=location%>&coasc=d&datefrom=<%=datefrom%>&dateto=<%=datetostr%>"><img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a>
<a href="tradereport.asp?location=<%=location%>&coasc=a&datefrom=<%=datefrom%>&dateto=<%=datetostr%>"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle"border></a></td>
    <td valign="bottom"><b>Order&nbsp;No&nbsp;<br>
<a href="tradereport.asp?location=<%=location%>&orderasc=d&datefrom=<%=datefrom%>&dateto=<%=datetostr%>"><img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a>
<a href="tradereport.asp?location=<%=location%>&orderasc=a&datefrom=<%=datefrom%>&dateto=<%=datetostr%>"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle" border="0"></a></b></td>
       
       <td valign="bottom">Order Source</td> 
       
    <td align="right" valign="bottom"><b>Order Value</b></td>
    <td align="right" valign="bottom">Total Payments to Date</td>
    <td align="right" valign="bottom">Total Outstanding</td>
    </tr>
<%Do until rs.EOF
Set rs2 = getMysqlQueryRecordSet("Select * from savoir_user where username='" & rs("salesusername") & "'", con)
Set rs3 = getMysqlQueryRecordSet("Select * from location where idlocation='" & rs2("id_location") & "'", con)
currencysym=rs3("currency")
If rs("total")<>"" then
ordervaltotal=ordervaltotal+CCur(rs("total"))
end if
If rs("paymentstotal")<>"" then
totalpayments=totalpayments+CCur(rs("paymentstotal"))
end if
totalos=totalos+CCur(rs("balanceoutstanding"))%>
  <tr>
  <td valign="bottom"><%If rs("order_date")<>"" then response.write(DateValue(rs("order_date")) & " ")%></td>
  
    <td valign="bottom"><%'response.Write("<p><input type=""checkbox"" name=""XX_" & rs("purchase_no") & """ id=""XX_" & rs("purchase_no") & """><a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>")
response.Write("<a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>")
If rs("surname")<>"" then response.write(rs("surname") & ",&nbsp;")
If rs("title")<>"" then response.write(rs("title") & "&nbsp;")
If rs("first")<>"" then response.write(rs("first") & " ")

%></td>
    <td valign="bottom"><%
If rs("company")<>"" then response.write(rs("company"))
response.Write("</a>")%></td>
    <td valign="bottom"><%If rs("order_number")<>"" then response.write(rs("order_number") & " ")%>
      &nbsp;</td>
      
        <td valign="bottom"><%If rs("salesusername")<>"" then response.write(rs3("adminheading"))%></td>
       
    <td align="right" valign="bottom"><%If rs("total")<>"" then response.write(fmtCurr2(rs("total"), true, rs3("currency")) & " ")%></td>
    <td align="right" valign="bottom"><%If rs("paymentstotal")<>"" then response.write(fmtCurr2(rs("paymentstotal"), true, rs3("currency")) & " ")%></td>
    <td align="right" valign="bottom"><%If rs("balanceoutstanding")<>"" then response.write(fmtCurr2(rs("balanceoutstanding"), true, rs3("currency")) & " ")%></td>
   
    </tr>
  <%rs2.close
  set rs2=nothing
  rs3.close
  set rs3=nothing
  count=count+1
rs.movenext
loop%>
<tr>
<td colspan="5" valign="bottom"><b>TOTALS</b></td>

<td valign="bottom"><b><%=fmtCurr2(ordervaltotal, true, currencysym)%></b></td>
<td align="right" valign="bottom"><b><%=fmtCurr2(totalpayments, true, currencysym)%></b></td>
<td align="right" valign="bottom"><b><%=fmtCurr2(totalos, true, currencysym)%></b></td>

</tr>
</table>
<input name="user" type="hidden" value="<%=request("user")%>">
<input name="datefrom" type="hidden" value="<%=datefrom%>">
<input name="location" type="hidden" value="<%=location%>">
<input name="dateto" type="hidden" value="<%=dateto%>">
<input name="amttotal" type="hidden" value="<%=amttotal%>">
<input name="customerasc" type="hidden" value="<%=customerasc%>">
<input name="payasc" type="hidden" value="<%=payasc%>">
<input name="coasc" type="hidden" value="<%=coasc%>">
<input name="dateasc" type="hidden" value="<%=dateasc%>">
<input name="orderasc" type="hidden" value="<%=orderasc%>">
<input name="msg" type="hidden" value="<%=msg%>">
</form>
<%else
response.Write("No records available")
end if
If rs.recordcount > 20 then%>
<p><a href="#top" class="addorderbox">&gt;&gt; Back to Top</a></p>
<%end if
rs.close
set rs=nothing
Con.Close
Set Con = Nothing%>
    

    
  </p>
  <p>&nbsp;</p>
<!--</form>-->
</div>
  </div>
<div>

       
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
