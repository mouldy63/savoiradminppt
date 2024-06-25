<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = False
Server.ScriptTimeout =1900%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype, notes
msg=""



if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
'sql for all contacts from a date (uses date added and firstcontactdate)
'sql="select * from contact C, Address A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and (C.dateadded > '2018-12-16' or A.FIRST_CONTACT_DATE > '2018-12-16')"
sql="SELECT  C.contact_no, C.first, C.surname, A.company, A.town, A.country, A.email_address, A.status, C.customerType FROM contact C, address A WHERE C.code=A.code and (C.customertype=2 or C.customertype=4 or C.customertype=6 or C.customertype is null or C.customertype=0) union SELECT C.contact_no, C.first, C.surname, A.company, A.town, A.country, A.email_address, A.status, C.customerType FROM contact C, address A WHERE C.code=A.code and (C.customertype=2 or C.customertype=4 or C.customertype=6 or C.customertype is null or C.customertype=0) and C.contact_no in (select contact_no from purchase)"
'response.End()
Set rs = getMysqlQueryRecordSet(sql, con)


Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("ID,First,Surname,Company,Town,Country,Email,Status,Customer Type")
Do until rs.eof
if rs("customertype")=2 then customertype="Interior Designer"
if rs("customertype")=4 then customertype="Yacht Designer"
if rs("customertype")=6 then customertype="Other"
if (isNull(rs("customertype")) or rs("customertype")=0) then customertype=" "
	excelLine = """" & rs("contact_no") & """,""" & rs("first") & """,""" & rs("surname") & """,""" & rs("company") & """,""" & rs("town") & """,""" & rs("country") & """,""" & rs("email_address") & """,""" & rs("status") & """,""" & customertype & """"
	
	tempfile.WriteLine(excelLine)
	notes=""
	
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
Response.AddHeader "Content-Disposition", "attachment; filename=""datadump.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing
Con.Close
Set Con = Nothing
end if
%>

