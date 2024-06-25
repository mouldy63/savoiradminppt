<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES,REGIONAL_ADMINISTRATOR"
Response.Buffer = True %>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="reportfuncs.asp" -->
<!-- #include file="customerfuncs.asp" -->
<%

Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, count, sql, msg, orderasc, customerasc, datefrom, datefromstr, datetostr, dateto, rs2, rs3, receiptasc, amttotal, currencysym, strtitle, strfirst, strsurname, ordervaltotal, totalpayments, totalos, strtotal, strpaymentstotal, stroutstanding, location,proddate, reporttype, giftpack, deliveryaddress, custaddress, deliverytrue, deliveryadd1, deliveryadd2, deliveryadd3, deliveryadd4, deliveryadd5, deliveryadd6, deliveryadd7, tel, fax, delconfirmed, delcall
delcall=request("delcall")
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

Dim  cnt,  excellist, excelLine,  failedwrite, errormsg, showr, deldate, companyasc
Set Con = getMysqlConnection()
showr=request("showr")
deldate=request("deldate")
proddate=request("proddate")
companyasc=request("companyasc")
location=Request("location")
datefrom=Request("datefrom")
dateto=Request("dateto")
customerasc=request("customerasc")
orderasc=request("orderasc")
msg=request("msg")
count=0

if userHasRole("ADMINISTRATOR") or retrieveuserid()=22 or userHasRole("REGIONAL_ADMINISTRATOR") then
else
location=retrieveUserLocation()
end if

set rs = getDeliveryReportRs(con, location, delcall, giftpack, reporttype, datefrom, dateto, showr, customerasc, orderasc, companyasc, deldate, proddate)

Dim filesys, tempfile, tempfolder, tempname, filename, objStream
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
msg=msg & " - Total records = " & rs.recordcount
tempfile.WriteLine(msg)
tempfile.WriteLine("Customer Title,Customer First Name,Customer Surame,Tel,Fax,Company,Ref,Order No,Order Date,Order Source,Order Value,Payments Total,Balance Outstanding," & ucase(left(reporttype,1)) & right(reporttype, len(reporttype)-1) & " Date, Confirmed Delivery, Delivery Add1, Add2, Add3, Town, County, Postcode, Country, Email, Order Notes")

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
If rs("surname")<>"" then strsurname=rs("surname")
If rs("title")<>"" then strtitle=rs("title")
If rs("first")<>"" then strfirst=rs("first")
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
if rs("DeliveryDateConfirmed")="y" then delconfirmed="Yes" else delconfirmed="No"
excelLine = """" & strtitle & """,""" & strfirst & """,""" & strsurname & """,""" & tel & """,""" & fax & """,""" & rs("company") & """,""" & rs("customerreference") & ""","""
excelLine = excelLine & rs("order_number") & """,""" & rs("order_date") & """,""" & rs("adminheading") & """,""" 
excelLine = excelLine & strtotal & """,""" & strpaymentstotal & """,""" & stroutstanding & ""","""
if reporttype="delivery" then
excelLine = excelLine & rs("bookeddeliverydate") & ""","""
end if
if reporttype="production" then
excelLine = excelLine & rs("production_completion_date") & ""","""
end if
excelLine = excelLine & delconfirmed & """,""" & deliveryadd1 & """,""" & deliveryadd2 & """,""" & deliveryadd3 & """,""" & deliveryadd4 & """,""" & deliveryadd5 & """,""" & deliveryadd6 & """,""" & deliveryadd7 & """,""" & rs("email_address") & """,""" & customerNotes & """"
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
Set Con = Nothing
%>
    

 
<!-- #include file="common/logger-out.inc" -->
