<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = True %>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, dateasc, orderasc, customerasc, coasc, datefrom, datefromstr, datetostr, dateto, user, rs2, rs3, receiptasc, currencysym, strsurname,  exWorksDate, productinfo, comtotal, excelcurrencysymbol, amttotal, ordervaltotal, totalpayments, totalos,amttotalGBP, ordervaltotalGBP, totalpaymentsGBP, totalosGBP, amttotalEUR, ordervaltotalEUR, totalpaymentsEUR, totalosEUR, amttotalUSD, ordervaltotalUSD, totalpaymentsUSD, totalosUSD, orderGBP, orderUSD, orderEUR, IncCom, totalordervalue, totalordervalueGBP, totalordervalueUSD, totalordervalueEUR,totalbaloutstanding, totalbaloutstandingGBP, totalbaloutstandingUSD, totalbaloutstandingEUR, location
totalbaloutstanding=0
totalordervalue=0
totalordervalueGBP=0
totalordervalueUSD=0
totalordervalueEUR=0
totalbaloutstandingGBP=0
totalbaloutstandingUSD=0
totalbaloutstandingEUR=0
strsurname=""
amttotal=""
ordervaltotal=""
totalpayments=""
totalos=""
Dim  cnt,  excellist, excelLine,  failedwrite, errormsg
Set Con = getMysqlConnection()
user=Request("user")
datefrom=Request("datefrom")
dateto=Request("dateto")
receiptasc=request("receiptasc")
coasc=request("coasc")
dateasc=request("dateasc")
location=request("location")
customerasc=request("customerasc")
orderasc=request("orderasc")
msg=request("msg")
count=0
submit=Request("submit") 

sql = "Select P.total, P.balanceoutstanding, P.ordercurrency, P.idlocation  from address A, contact C, Purchase P,  Payment Z Where C.retire='n' AND A.code=C.code AND C.Code<>218766 AND C.code<>213190 AND C.code=P.code AND P.purchase_no=Z.purchase_no AND P.quote='n' and P.salesusername<>'dave' AND P.salesusername<>'maddy' "
sql = sql & " AND A.source_site='SB' " 
If datefrom<>"" then
sql=sql & " AND Z.placed >= '" & datefrom & "'"
end if
If location<>"all" then
sql=sql & " AND P.idlocation = " & location & ""
end if
If dateto<>"" then
dateto=DateAdd("d",1,dateto)
dateto=year(dateto) & "-" & month(dateto) & "-" & day(dateto)
sql=sql & " AND Z.placed <= '" & dateto & "'"
end if
sql=sql & " group by P.purchase_no"
'response.Write(sql)
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

sql = "Select P.purchase_no, P.order_number, P.idlocation, Z.amount, P.total, P.ordercurrency, P.Paymentstotal, P.idlocation, Z.placed, Z.salesusername, Z.receiptno, A.company, P.balanceoutstanding, C.surname, C.title, C.first, Z.paymenttype, P.order_date, Z.paymentid, Z.invoice_number, P.customerreference, Z.invoicedate, Z.inccom from address A, contact C, Purchase P,  Payment Z Where C.retire='n' AND A.code=C.code AND C.Code<>218766 AND C.code<>213190 AND C.code=P.code AND P.purchase_no=Z.purchase_no AND P.quote='n' and P.salesusername<>'dave' AND P.salesusername<>'maddy' "


if not isSuperuser() and retrieveUserLocation()<>1 and retrieveUserLocation()<>27 then
sql = sql & " AND P.idlocation=" & retrieveUserLocation() & ""
	'sql = sql & " AND A.source_site='" & retrieveUserSite() & "'"

else
	if location="all" then
	else
	sql = sql & " AND P.idlocation=" & location & ""
	end if
end if
'If retrieveUserRegion=1 then
'sql = sql & " OR C.owning_region=" & retrieveUserRegion() & ""
'end if
sql = sql & " AND A.source_site='SB' " 
If datefrom<>"" then
sql=sql & " AND Z.placed >= '" & datefrom & "'"
end if
If dateto<>"" then
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

Dim filesys, tempfile, tempfolder, tempname, filename, objStream
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
msg=msg & " - Total records = " & rs.recordcount
tempfile.WriteLine(msg)
tempfile.WriteLine("Payment Date,Customer Name,Customer Ref,Company,Order No,Payment Amount,Payment Type,Receipt No.,Order Source,Order Date,Ex-Works Date,Invoice No.,Invoice Date,Description,Order Value,Total Payments to Date,Total Outstanding,Com Total,Inc. Com")

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

Do until rs.EOF
exWorksDate=""
exWorksDate=getExWorksDate(con,rs("purchase_no"))
exWorksDate=replace(exWorksDate, "<br>", " ")
productinfo=""
productinfo=getBasicProductInfo(con,rs("purchase_no"))
productinfo=replace(productinfo, "<br>", ", ")

comtotal=""

Set rs2 = getMysqlQueryRecordSet("Select * from savoir_user where username='" & rs("salesusername") & "'", con)
Set rs3 = getMysqlQueryRecordSet("Select * from location where idlocation='" & rs2("id_location") & "'", con)
if rs("inccom")="y" then IncCom="Yes" else IncCom="No"

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
		amttotalUSD=CDbl(amttotalUSD)+CCur(rs("amount")) 
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
comtotal=getComTotal(con,rs("purchase_no"))
if comtotal<>"" then comtotal=excelcurrencysymbol & formatNumber(comtotal)
strsurname=""
If rs("surname")<>"" then strsurname=strsurname & rs("surname") & ", "
If rs("title")<>"" then strsurname=strsurname & rs("title") & " "
If rs("first")<>"" then strsurname=strsurname & rs("first") & " "
excelLine = """" & DateValue(rs("placed")) & """,""" & strsurname & """,""" & rs("customerreference") & """,""" & rs("company") & """,""" & rs("order_number") & """,""" & excelcurrencysymbol & formatnumber(abs(cdbl(rs("amount"))),2) & """,""" & rs("paymenttype") & """,""" & "R" & rs("receiptno") & """,""" & rs3("adminheading") & """,""" & DateValue(rs("order_date")) & """,""" & exWorksDate & """,""" & rs("invoice_number") & """,""" & rs("invoicedate") & """,""" & productinfo & """,""" & excelcurrencysymbol & formatnumber(rs("total"),2) & """,""" & excelcurrencysymbol & formatnumber(rs("paymentstotal"),2)  & """,""" & excelcurrencysymbol & formatnumber(rs("balanceoutstanding"),2) & """,""" & comtotal & """,""" & IncCom & """"
tempfile.WriteLine(excelLine)




rs2.close
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
end if 

excelLine = """" & "TOTALS " & """,""" & " " & """,""" & " " & """,""" & " " & """,""" & " " & """,""" & amttotal & " " & """,""" & " " & """,""" & " " & """,""" & " " & """,""" & " " & """,""" & " " & """,""" & " " & """,""" & " " & """,""" & " " & """,""" & totalordervalue & """,""" & totalpayments  & """,""" & totalbaloutstanding & """"
tempfile.WriteLine(excelLine)


rs.close
set rs=nothing

tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""accountslist.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing

Con.Close
Set Con = Nothing%>
    

 
<!-- #include file="common/logger-out.inc" -->
