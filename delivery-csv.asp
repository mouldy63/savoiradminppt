<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = True %>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="customerfuncs.asp" -->
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, dateasc, orderasc, customerasc, coasc, datefrom, datefromstr, datetostr, dateto, user, rs2, rs3, receiptasc, amttotal, currencysym, strsurname, ordervaltotal, totalpayments, totalos, payasc, location, strtotal, strpaymentstotal, stroutstanding, showroom,proddate, reporttype, giftpack, deliveryaddress, custaddress, deliverytrue, deliveryadd1, deliveryadd2, deliveryadd3, deliveryadd4, deliveryadd5, deliveryadd6, deliveryadd7, tel, fax, delconfirmed
giftpack=request("giftpack")
reporttype=request("reporttype")
strsurname=""
amttotal=0
ordervaltotal=0
totalpayments=0
totalos=0
strtotal=0
strpaymentstotal=0
stroutstanding=0

Dim  cnt,  excellist, excelLine,  failedwrite, errormsg, showr, productiondate, deldate, companyasc
Set Con = getMysqlConnection()
user=Request("user")
showr=request("showr")
productiondate=request("productiondate")
deldate=request("deldate")
proddate=request("proddate")
companyasc=request("companyasc")
showroom=Request("showroom")
datefrom=Request("datefrom")
dateto=Request("dateto")
payasc=request("payasc")
location=request("location")
coasc=request("coasc")
dateasc=request("dateasc")
customerasc=request("customerasc")
orderasc=request("orderasc")
msg=request("msg")
count=0
submit=Request("submit") 

if userHasRole("Administrator") or retrieveuserid()=22 then
else
showroom=retrieveUserLocation()
end if

sql = "Select * from address A, contact C, Purchase P" 
'if userHasRole("ADMINISTRATOR") or userHasRole("SHOWROOM_VIEWER")  then 
sql = sql & ", Location L"
'end if
sql = sql & " Where (P.cancelled is null or P.cancelled <> 'y') AND C.retire='n' AND C.contact_no<>319256 AND C.contact_no<>24188  AND P.orderonhold<>'y' AND "
'sql = sql & "C.contact_no<>319256 AND C.contact_no<>24188 AND "
sql = sql & "A.code=C.code AND C.contact_no=P.contact_no AND P.quote='n' "
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

if customerasc=""  and  orderasc="" and companyasc=""  and (deldate=""  or proddate="") and showr="" then
sql = sql & " order by P.order_number asc"
end if
'url="datefrom=" & datefrom & "&dateto=" & dateto & "&location=" & showroom & "&"
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
tempfile.WriteLine("Customer Name,Tel,Fax,Company,Ref,Order No,Order Date,Order Source,Order Value,Payments Total,Balance Outstanding," & ucase(left(reporttype,1)) & right(reporttype, len(reporttype)-1) & " Date, Delivery Add1, Add2, Add3, Town, County, Postcode, Country, Email, Order Notes")

Do until rs.EOF
dim noteHistory, customerNotes, i
noteHistory = getCustomerNotes(con, rs("code"))
if ubound(noteHistory) > 0 then
	for i = 1 to ubound(noteHistory)
		customerNotes=customerNotes & noteHistory(i).commDate
		customerNotes=customerNotes & " " & noteHistory(i).commType
		customerNotes=customerNotes & " " & noteHistory(i).person
		customerNotes=customerNotes & " " & noteHistory(i).notes
		customerNotes=customerNotes & " " & noteHistory(i).actionnext
		customerNotes=customerNotes & " " & noteHistory(i).actionresponse
		customerNotes=customerNotes & " " & noteHistory(i).staff & vbCrLf
        next
end if

If rs("total")<>"" then
ordervaltotal=ordervaltotal+CCur(rs("total"))
end if
If rs("paymentstotal")<>"" then
totalpayments=totalpayments+CCur(rs("paymentstotal"))
end if
totalos=totalos+CCur(rs("balanceoutstanding"))
strsurname=""
If rs("surname")<>"" then strsurname=strsurname & rs("surname") & ", "
If rs("title")<>"" then strsurname=strsurname & rs("title") & " "
If rs("first")<>"" then strsurname=strsurname & rs("first") & " "
If rs("total")<>"" then strtotal=rs("total") else strtotal=0
If rs("paymentstotal")<>"" then strpaymentstotal=rs("paymentstotal") else strpaymentstotal=0
If rs("balanceoutstanding")<>"" then stroutstanding=rs("balanceoutstanding") else stroutstanding=0

If rs("deliveryadd1") <> "" then 
deliverytrue=1
deliveryadd1 = rs("deliveryadd1")
else 
deliveryadd1=""
end if
If rs("deliveryadd2") <> "" then 
deliveryadd2 = rs("deliveryadd2") 
 else 
 deliveryadd2=""
 end if
If rs("deliveryadd3") <> "" then 
deliveryadd3 = rs("deliveryadd3") 
else 
deliveryadd3=""
end if
If rs("deliverytown") <> "" then
 deliveryadd4 = rs("deliverytown") 
else 
deliveryadd4=""
end if
If rs("deliverycounty") <> "" then 
deliverytrue=1
deliveryadd5 = rs("deliverycounty")
 else 
 deliveryadd5=""
 end if
If rs("deliverypostcode") <> "" then 
deliverytrue=1
deliveryadd6 = rs("deliverypostcode") 
else 
deliveryadd6=""
end if
If rs("deliverycountry") <> "" then 
deliverytrue=1
deliveryadd7= rs("deliverycountry")
 else
  deliveryadd7=""
end if

Set rs2 = getMysqlQueryRecordSet("select * from address where code=" & rs("code"), con)
if deliverytrue="" then
tel=rs2("tel")
fax=rs2("fax")
If rs2("street1")<>"" then deliveryadd1 = rs2("street1") else deliveryadd1=""
If rs2("street2")<>"" then deliveryadd2 =  rs2("street2") else deliveryadd2=""
If rs2("street3")<>"" then deliveryadd3 =  rs2("street3") else deliveryadd3=""
If rs2("town")<>"" then deliveryadd4 =  rs2("town") else deliveryadd4=""
If rs2("county")<>"" then deliveryadd5 =  rs2("county") else deliveryadd5=""
If rs2("postcode")<>"" then deliveryadd6 =  rs2("postcode") else deliveryadd6=""
If rs2("country")<>"" then deliveryadd7 =  rs2("country") else deliveryadd7=""
end if
rs2.close
set rs2=nothing
'if rs("DeliveryDateConfirmed")="y" then delconfirmed="Yes" else delconfirmed="No"
excelLine = """" & strsurname & """,""" & tel & """,""" & fax & """,""" & rs("company") & """,""" & rs("customerreference") & ""","""
excelLine = excelLine & rs("order_number") & """,""" & rs("order_date") & """,""" & rs("adminheading") & """,""" 
excelLine = excelLine & strtotal & """,""" & strpaymentstotal & """,""" & stroutstanding & ""","""
if reporttype="delivery" then
excelLine = excelLine & rs("bookeddeliverydate") & ""","""
end if
if reporttype="production" then
excelLine = excelLine & rs("production_completion_date") & ""","""
end if
excelLine = excelLine & deliveryadd1 & """,""" & deliveryadd2 & """,""" & deliveryadd3 & """,""" & deliveryadd4 & """,""" & deliveryadd5 & """,""" & deliveryadd6 & """,""" & deliveryadd7 & """,""" & rs("email_address") & """,""" & customerNotes & """"
tempfile.WriteLine(excelLine)
customerNotes=""
  count=count+1
rs.movenext
loop
rs.close
set rs=nothing

tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""report.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing

Con.Close
Set Con = Nothing%>
    

 
