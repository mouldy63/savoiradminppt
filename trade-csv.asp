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
<%Dim postcode, postcodefull, Con, rs, recordfound, id, rspostcode, submit, count, sql, msg, dateasc, orderasc, customerasc, coasc, datefrom, datefromstr, datetostr, dateto, user, rs2, rs3, receiptasc, amttotal, currencysym, strsurname, ordervaltotal, totalpayments, totalos, payasc, location, strtotal, strpaymentstotal, stroutstanding
strsurname=""
amttotal=0
ordervaltotal=0
totalpayments=0
totalos=0
strtotal=0
strpaymentstotal=0
stroutstanding=0
Dim  cnt,  excellist, excelLine,  failedwrite, errormsg
Set Con = getMysqlConnection()
user=Request("user")
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

Dim filesys, tempfile, tempfolder, tempname, filename, objStream
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
msg=msg & " - Total records = " & rs.recordcount
tempfile.WriteLine(msg)
tempfile.WriteLine("Order Date,Customer Name,Company,Order No,Order Source,Order Value,Total Payments to Date,Total Outstanding")

Do until rs.EOF
Set rs2 = getMysqlQueryRecordSet("Select * from savoir_user where username='" & rs("salesusername") & "'", con)
Set rs3 = getMysqlQueryRecordSet("Select * from location where idlocation='" & rs2("id_location") & "'", con)
currencysym=rs3("currency")
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
If rs("total")<>"" then strtotal=formatcurrency(rs("total"),2) else strtotal=0
If rs("paymentstotal")<>"" then strpaymentstotal=formatcurrency(rs("paymentstotal"),2) else strpaymentstotal=0
If rs("balanceoutstanding")<>"" then stroutstanding=formatcurrency(rs("balanceoutstanding"),2) else stroutstanding=0

excelLine = """" & DateValue(rs("order_date")) & """,""" & strsurname & """,""" & rs("company") & """,""" & rs("order_number") & """,""" & rs3("adminheading") & """,""" & strtotal & """,""" & strpaymentstotal & """,""" & stroutstanding & """"
tempfile.WriteLine(excelLine)
rs2.close
  set rs2=nothing
  rs3.close
  set rs3=nothing
  count=count+1
rs.movenext
loop
excelLine = """" & "TOTALS " & """,""" & " " & """,""" & " " & """,""" & " " & """,""" & " " & """,""" & formatcurrency(ordervaltotal) & """,""" & formatcurrency(totalpayments)  & """,""" & formatcurrency(totalos) & """"
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
