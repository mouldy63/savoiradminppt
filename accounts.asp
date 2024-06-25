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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, dateasc, orderasc, customerasc, coasc, datefrom, datefromstr, datetostr, dateto, dateto1, user, rs2, rs3, receiptasc, amttotal, currencysym, ordervaltotal, totalpayments, totalos, location, i, pid, fieldName, submitX,amttotalGBP, ordervaltotalGBP, totalpaymentsGBP, totalosGBP, amttotalEUR, ordervaltotalEUR, totalpaymentsEUR, totalosEUR, amttotalUSD, ordervaltotalUSD, totalpaymentsUSD, totalosUSD, orderGBP, orderUSD, orderEUR, IncCom, excelcurrencysymbol, totalordervalue, totalordervalueGBP, totalordervalueUSD, totalordervalueEUR,totalbaloutstanding, totalbaloutstandingGBP, totalbaloutstandingUSD, totalbaloutstandingEUR
totalbaloutstanding=0
totalordervalue=0
totalordervalueGBP=0
totalordervalueUSD=0
totalordervalueEUR=0
totalbaloutstandingGBP=0
totalbaloutstandingUSD=0
totalbaloutstandingEUR=0
amttotal=""
ordervaltotal=""
totalpayments=""
totalos=""
submitX=request("SubmitX")
Set Con = getMysqlConnection()
'Update Inccom here
if submitX<>"" then

	For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 2) = "YY" Then
		pid=right(fieldName, len(fieldName)-2)
		sql="Select * from payment where paymentid=" & pid
		Set rs = getMysqlUpdateRecordSet(sql, con)
		if request("XX" & pid)<>"" then 
			rs("inccom")="y"
		else
			rs("inccom")="n"
		end if
		rs.Update
		rs.close
		set rs=nothing
	end if
	next
end if

location=""
location=request("location")

user=Request("user")
If user<>"all" then
	Set rs2 = getMysqlQueryRecordSet("Select * from savoir_user where username='" & user & "'", con)
		If rs2("name")<>"" then
			user=rs2("name")
		end if
	rs2.close
	set rs2=nothing
end if
datefromstr=Request("datefrom")
If datefromstr <>"" then
datefrom=year(datefromstr) & "-" & month(datefromstr) & "-" & day(datefromstr)
end if
datetostr=Request("dateto")
If datetostr <>"" then
dateto=year(datetostr) & "-" & month(datetostr) & "-" & day(datetostr)
end if
amttotal=""
ordervaltotal=""
totalpayments=""
totalos=""
receiptasc=""
coasc=""
dateasc=""
customerasc=""
orderasc=""
receiptasc=request("receiptasc")
coasc=request("coasc")
dateasc=request("dateasc")
customerasc=request("customerasc")
orderasc=request("orderasc")
msg=""
msg="You searched for payments "
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
<p>ACCOUNTS - PAYMENTS</p>
<form name="form1" id="form1" method="post" action="accounts-csv.asp">
<input name="user" type="hidden" value="<%=request("user")%>">
<input name="datefrom" type="hidden" value="<%=datefrom%>">
<input name="location" type="hidden" value="<%=location%>">
<input name="dateto" type="hidden" value="<%=dateto%>">
<input name="amttotal" type="hidden" value="<%=amttotal%>">
<input name="receiptasc" type="hidden" value="<%=receiptasc%>">
<input name="customerasc" type="hidden" value="<%=customerasc%>">
<input name="coasc" type="hidden" value="<%=coasc%>">
<input name="dateasc" type="hidden" value="<%=dateasc%>">
<input name="orderasc" type="hidden" value="<%=orderasc%>">
<input name="msg" type="hidden" value="<%=msg%>">

<p>  <label>
    <input type="submit" name="button" id="button" value="Download CSV file">
  </label></p>

</form>
<form name="form2" id="form2" method="post" action="accounts.asp">
  <p>
    <%
sql = "Select P.total, P.balanceoutstanding, P.ordercurrency, P.idlocation  from address A, contact C, Purchase P,  Payment Z Where C.retire='n' AND A.code=C.code AND C.Code<>218766 AND C.code<>213190 AND C.code=P.code AND P.purchase_no=Z.purchase_no AND P.quote='n' and P.salesusername<>'dave' AND P.salesusername<>'maddy' "
sql = sql & " AND A.source_site='SB' "
If location<>"all" then
sql=sql & " AND P.idlocation = " & location & ""
end if 
If datefrom<>"" then
sql=sql & " AND Z.placed >= '" & datefrom & "'"
end if
If dateto<>"" then
dateto=DateAdd("d",1,dateto)
dateto=year(dateto) & "-" & month(dateto) & "-" & day(dateto)
sql=sql & " AND Z.placed <= '" & dateto & "'"
end if
sql=sql & " group by P.purchase_no"
Set rs = getMysqlQueryRecordSet(sql, con)
do until rs.eof
if rs("ordercurrency")="GBP" then
totalordervalueGBP=totalordervalueGBP + CDbl(rs("total"))
totalbaloutstandingGBP=totalbaloutstandingGBP + CDbl(rs("balanceoutstanding"))
end if
if rs("ordercurrency")="USD" then
totalordervalueUSD=totalordervalueUSD + CDbl(rs("total"))
totalbaloutstandingUSD=totalbaloutstandingUSD + CDbl(rs("balanceoutstanding"))
end if
if rs("ordercurrency")="EUR" then
totalordervalueEUR=totalordervalueEUR + CDbl(rs("total"))
totalbaloutstandingEUR=totalbaloutstandingEUR + CDbl(rs("balanceoutstanding"))
end if
rs.movenext
loop
rs.close
set rs=nothing
	
sql = "Select P.purchase_no, P.order_number, Z.amount, P.total, P.Paymentstotal, P.ordercurrency, P.idlocation, Z.placed, Z.salesusername, Z.receiptno, A.company, P.balanceoutstanding, C.surname, C.title, C.first, Z.paymenttype, P.order_date, Z.paymentid, Z.invoice_number, P.customerreference, Z.invoicedate, Z.inccom from address A, contact C, Purchase P,  Payment Z Where C.retire='n' AND A.code=C.code AND C.Code<>218766 AND C.code<>213190 AND C.code=P.code AND P.purchase_no=Z.purchase_no AND P.quote='n' and P.salesusername<>'dave' AND P.salesusername<>'maddy' "

if not isSuperuser() and retrieveUserLocation()<>1 and retrieveUserLocation()<>27 then
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
sql=sql & " AND Z.placed >= '" & datefrom & "'"
end if
If dateto<>"" then
dateto=DateAdd("d",1,dateto)
dateto=year(dateto) & "-" & month(dateto) & "-" & day(dateto)
sql=sql & " AND Z.placed <= '" & dateto & "'"
end if
If user<>"all" then
sql=sql & " AND Z.salesusername = '" & request("user") & "'"
end if

if customerasc="a" then
sql = sql & " order by C.surname asc"
end if
if customerasc="d" then
sql = sql & " order by C.surname desc"
end if

if receiptasc="a" then
sql = sql & " order by Z.receiptno asc"
end if
if receiptasc="d" then
sql = sql & " order by Z.receiptno desc"
end if
if orderasc="a" then
sql = sql & " order by P.order_number asc"
end if
if orderasc="d" then
sql = sql & " order by P.order_number desc"
end if
if dateasc="a" then
sql = sql & " order by Z.placed asc"
end if
if dateasc="d" then
sql = sql & " order by Z.placed desc"
end if
if coasc="a" then
sql = sql & " order by A.company asc"
end if
if coasc="d" then
sql = sql & " order by A.company desc"
end if
if customerasc=""  and  orderasc="" and dateasc="" and coasc=""  and receiptasc="" then
sql = sql & " order by P.order_number asc"
end if

'response.write("<br>" & sql)
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)

amttotalGBP=0 
ordervaltotalGBP=0
totalpaymentsGBP=0
totalosGBP=0

amttotalEUR=0 
ordervaltotalEUR=0
totalpaymentsEUR=0
totalosEUR=0

amttotalUSD=0 
ordervaltotalUSD=0
totalpaymentsUSD=0
totalosUSD=0
orderGBP="n"
orderUSD="n"
orderEUR="n"

If not rs.eof then

response.Write(msg & "<br>Total = " & rs.recordcount & "<br /><br />")%>


<table border="0" cellpadding="2" cellspacing="2" class="text">
 <tr><td valign="bottom"><b>Payment Date<br>
 </b>
 <a href="accounts.asp?location=<%=location%>&dateasc=d&datefrom=<%=datefrom%>&dateto=<%=datetostr%>&user=<%=request("user")%>"><img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a>
 <a href="accounts.asp?location=<%=location%>&dateasc=a&datefrom=<%=datefrom%>&dateto=<%=datetostr%>&user=<%=request("user")%>"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle"border></a></td>
    <td valign="bottom">
    <b>Customer Name (&amp; Customer Ref.<br>
<a href="accounts.asp?location=<%=location%>&customerasc=d&datefrom=<%=datefrom%>&dateto=<%=datetostr%>&user=<%=request("user")%>"><img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a>
<a href="accounts.asp?location=<%=location%>&customerasc=a&datefrom=<%=datefrom%>&dateto=<%=datetostr%>&user=<%=request("user")%>"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle"border></a></b></td>

    <td valign="bottom">Company&nbsp;<br> 
<a href="accounts.asp?location=<%=location%>&coasc=d&datefrom=<%=datefrom%>&dateto=<%=datetostr%>&user=<%=request("user")%>"><img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a>
<a href="accounts.asp?location=<%=location%>&coasc=a&datefrom=<%=datefrom%>&dateto=<%=datetostr%>&user=<%=request("user")%>"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle"border></a></td>
    <td valign="bottom"><b>Order&nbsp;No&nbsp;<br>
<a href="accounts.asp?location=<%=location%>&orderasc=d&datefrom=<%=datefrom%>&dateto=<%=datetostr%>&user=<%=request("user")%>"><img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a>
<a href="accounts.asp?location=<%=location%>&orderasc=a&datefrom=<%=datefrom%>&dateto=<%=datetostr%>&user=<%=request("user")%>"><img src="img/asc.gif" alt="Ascending" width="24" height="20" align="middle" border="0"></a></b></td>
       <td align="right" valign="bottom">
        Payment Amount<br>
        Payment Type        <b></b></td>
       
       <td valign="bottom">Receipt&nbsp;No.<br /><a href="accounts.asp?location=<%=location%>&receiptasc=d&datefrom=<%=datefrom%>&dateto=<%=datetostr%>&user=<%=request("user")%>"><img src="img/desc.gif" alt="Descending" width="24" height="20" align="middle" border="0"></a><a href="accounts.asp?location=<%=location%>&receiptasc=a&datefrom=<%=datefrom%>&dateto=<%=datetostr%>&user=<%=request("user")%>"><img src="img/asc.gif" alt="Ascending" width="26" height="22" align="middle" border="0"></a></td>
       <td valign="bottom">Order Source</td> 
       <td valign="bottom"><b>Order Date</b></td>
       <td valign="bottom">Exworks&nbsp;Date:</td>
     
       <td valign="bottom">Invoice Date /<br>
         Invoice No.         :</td>
       <td valign="bottom">Description</td>
    <td align="right" valign="bottom"><b>Order Value</b></td>
    <td align="right" valign="bottom">Total Payments to Date</td>
    <td align="right" valign="bottom">Total Outstanding</td>
    <td align="right" valign="bottom">Com Total</td>
    <td align="right" valign="bottom">Inc Com</td>
    </tr>
<%Do until rs.EOF
Set rs2 = getMysqlQueryRecordSet("Select * from savoir_user where username='" & rs("salesusername") & "'", con)
Set rs3 = getMysqlQueryRecordSet("Select * from location where idlocation='" & rs2("id_location") & "'", con)

currencysym=rs("ordercurrency")
if currencysym="GBP" then 
	excelcurrencysymbol="£"
	orderGBP="y"
	
	if rs("paymenttype")="Refund" then
		amttotalGBP=CDbl(amttotalGBP)+CCur(rs("amount")) 
		ordervaltotalGBP=CDbl(ordervaltotalGBP)+CCur(rs("total"))
		totalpaymentsGBP=CDbl(totalpaymentsGBP)-CCur(rs("paymentstotal"))
		totalosGBP=CDbl(totalosGBP)+CCur(rs("balanceoutstanding"))
	else
		amttotalGBP=CDbl(amttotalGBP)+CCur(rs("amount")) 
		ordervaltotalGBP=CDbl(ordervaltotalGBP)+CCur(rs("total"))
		totalpaymentsGBP=CDbl(totalpaymentsGBP)+CCur(rs("paymentstotal"))
		totalosGBP=CDbl(totalosGBP)+CCur(rs("balanceoutstanding"))
	end if
end if
if currencysym="EUR" then 
	excelcurrencysymbol="€"
	orderEUR="y"
	if rs("paymenttype")="Refund" then
		amttotalEUR=CDbl(amttotalEUR)+CCur(rs("amount")) 
		ordervaltotalEUR=CDbl(ordervaltotalEUR)+CCur(rs("total"))
		totalpaymentsEUR=CDbl(totalpaymentsEUR)-CCur(rs("paymentstotal"))
		totalosEUR=CDbl(totalosEUR)+CCur(rs("balanceoutstanding"))
	else
		amttotalEUR=CDbl(amttotalEUR)+CCur(rs("amount")) 
		ordervaltotalEUR=CDbl(ordervaltotalEUR)+CCur(rs("total"))
		totalpaymentsEUR=CDbl(totalpaymentsEUR)+CCur(rs("paymentstotal"))
		totalosEUR=CDbl(totalosEUR)+CCur(rs("balanceoutstanding"))
	end if
end if
if currencysym="USD" then 
	excelcurrencysymbol="$"
	orderUSD="y"
	if rs("paymenttype")="Refund" then
	response.Write("amt=" & amttotalUSD & "<br>")
		amttotalUSD=CDbl(amttotalUSD)+CCur(rs("amount")) 
	response.Write("amtaft=" & amttotalUSD & "<br>")
		ordervaltotalUSD=CDbl(ordervaltotalUSD)+CCur(rs("total"))
		totalpaymentsUSD=CDbl(totalpaymentsUSD)-CCur(rs("paymentstotal"))
		totalosUSD=CDbl(totalosUSD)+CCur(rs("balanceoutstanding"))
	else
		amttotalUSD=CDbl(amttotalUSD)+CCur(rs("amount")) 
		ordervaltotalUSD=CDbl(ordervaltotalUSD)+CCur(rs("total"))
		totalpaymentsUSD=CDbl(totalpaymentsUSD)+CCur(rs("paymentstotal"))
		totalosUSD=CDbl(totalosUSD)+CCur(rs("balanceoutstanding"))
	end if
end if
%>
  <tr>
  <td valign="top"><%=DateValue(rs("placed"))%></td>
    <td valign="top"><%'response.Write("<p><input type=""checkbox"" name=""XX_" & rs("purchase_no") & """ id=""XX_" & rs("purchase_no") & """><a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>")
response.Write("<a href=""edit-purchase.asp?order=" & rs("purchase_no") & """>")
If rs("surname")<>"" then response.write(rs("surname") & "<br>")
If rs("title")<>"" then response.write(rs("title") & "&nbsp;")
If rs("first")<>"" then response.write(rs("first") & " ")
if rs("customerreference")<>"" then response.Write("<br>" & rs("customerreference"))
%></td>
    <td valign="top"><%
If rs("company")<>"" then response.write(rs("company"))
response.Write("</a>")%></td>
    <td valign="top"><%response.Write(rs("order_number"))%>
      &nbsp;</td>
       <% if userHasRoleInList("ACCOUNTS") then %>
        <td align="right" valign="top">
        
		<%If rs("amount")<>"" then response.write("<a href=""amendpmt.asp?location=" & location & "&datefrom=" & datefrom & "&dateto=" & datetostr & "&user=" & request("user") & "&val=" & rs("paymentid") & """>" & excelcurrencysymbol & abs(cdbl(rs("amount"))) & "</a>")
		 'If rs("dateofamend")<>"" then response.Write("<br />Amended on " & rs("dateofamend") & " by " & rs("amendedby") & " - " & rs("reasonforamend"))
		 If rs("paymenttype")<>"" then response.write("<br>" & rs("paymenttype"))%></td>
        <%else%>
        <td align="right" valign="top"><%If rs("amount")<>"" then response.write(excelcurrencysymbol & abs(cdbl(rs("amount"))))%><%If rs("paymenttype")<>"" then response.write("<br>" & rs("paymenttype"))%></td>
        <%end if%>
        
        <td valign="top"><%If rs("receiptno")<>"" then response.write("R" & rs("receiptno"))%></td>
        <td valign="top"><%If rs("salesusername")<>"" then response.write(rs3("adminheading"))%></td>
        
        
        <td valign="top"><%If rs("order_date")<>"" then response.write(DateValue(rs("order_date")) & " ")%></td>
        <td valign="top"><%=getExWorksDate(con,rs("purchase_no"))%>&nbsp;</td>
        
        <td valign="top"><%=rs("invoicedate")%>
        <%if rs("invoice_number")<>"" then response.write("<br>" & rs("invoice_number"))%></td>
        <td valign="top"><%=getBasicProductInfo(con,rs("purchase_no"))%>&nbsp;</td>
    <td align="right" valign="top"><%If rs("total")<>"" then response.write(excelcurrencysymbol & rs("total"))%></td>
    <td align="right" valign="top"><%If rs("paymentstotal")<>"" then response.write(excelcurrencysymbol & rs("paymentstotal"))%></td>
    <td align="right" valign="top"><%If rs("balanceoutstanding")<>"" then response.write(excelcurrencysymbol & rs("balanceoutstanding"))%></td>
    <td align="right" valign="top"><%Response.Write(excelcurrencysymbol & getComTotal(con,rs("purchase_no")))%></td>
   <td align="right" valign="top"><%If rs("incCom")="y" then%>
   <input name="XX<%=rs("paymentid")%>" id="XX<%=rs("paymentid")%>" type="checkbox" value="y" checked /> 
   <%else%>
   <input name="XX<%=rs("paymentid")%>" id="XX<%=rs("paymentid")%>" type="checkbox" value="y" />
   <%end if%>
   <input name="YY<%=rs("paymentid")%>" type="hidden" />
   </td>
    </tr>
  <%rs2.close
  set rs2=nothing
  rs3.close
  set rs3=nothing
  count=count+1
rs.movenext
loop
if orderGBP="y" then
if amttotalGBP<>"" then amttotal="£" & formatNumber(CDbl(amttotalGBP)) & vbnewline
if ordervaltotalGBP<>"" then totalordervalue="£" & formatNumber(CDbl(totalordervalueGBP)) & vbnewline
if totalpaymentsGBP<>"" then totalpayments="£" & formatNumber(CDbl(totalpaymentsGBP)) & vbnewline
if totalosGBP<>"£" then totalbaloutstanding="£" & formatNumber(CDbl(totalbaloutstandingGBP)) & vbnewline
end if

if orderEUR="y" then
if amttotalEUR<>"" then amttotal=amttotal & "€" & formatNumber(CDbl(amttotalEUR)) & vbnewline
if ordervaltotalEUR<>"" then totalordervalue=totalordervalue & "€" & formatNumber(ordervaltotalEUR) & vbnewline
if totalpaymentsEUR<>"" then totalpayments=totalpayments & "€" & formatNumber(CDbl(totalpaymentsEUR)) & vbnewline
if totalosEUR<>"€" then totalbaloutstanding=totalbaloutstanding & "€" & formatNumber(totalbaloutstandingEUR) & vbnewline
end if

if orderUSD="y" then
if amttotalUSD<>"" then amttotal=amttotal & "$" & formatNumber(CDbl(amttotalUSD))
if ordervaltotalUSD<>"" then totalordervalue="$" & formatNumber(CDbl(totalordervalueUSD))
if totalpaymentsUSD<>"" then totalpayments=totalpayments & "$" & formatNumber(CDbl(totalpaymentsUSD))
if totalosUSD<>"$" then totalbaloutstanding="$" & formatNumber(CDbl(totalbaloutstandingUSD))
end if %>
<tr>
<td colspan="5" valign="bottom"><b>TOTALS</b></td>
<td align="right" valign="bottom"><b><%response.Write(amttotal)%></b></td>
<td colspan="8" valign="bottom">&nbsp;</td>
<td align="right" valign="bottom"><b><%=totalordervalue%></b></td>
<td valign="bottom"><div align="right"><b><%response.Write(totalpayments)%></b></div></td>
<td valign="bottom"><div align="right"><b><%=totalbaloutstanding%></b></div></td>
</tr>
</table>
<input name="user" type="hidden" value="<%=request("user")%>">
<input name="datefrom" type="hidden" value="<%=datefrom%>">
<input name="location" type="hidden" value="<%=location%>">
<input name="dateto" type="hidden" value="<%=dateto%>">
<input name="amttotal" type="hidden" value="<%=amttotal%>">
<input name="receiptasc" type="hidden" value="<%=receiptasc%>">
<input name="customerasc" type="hidden" value="<%=customerasc%>">
<input name="coasc" type="hidden" value="<%=coasc%>">
<input name="dateasc" type="hidden" value="<%=dateasc%>">
<input name="orderasc" type="hidden" value="<%=orderasc%>">
<input name="msg" type="hidden" value="<%=msg%>">

<input name="SubmitX" id="SubmitX" value="Update Inc Com" type="submit">
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
</div>
  </div>
<div>

       
</body>
</html>
 
<!-- #include file="common/logger-out.inc" -->
