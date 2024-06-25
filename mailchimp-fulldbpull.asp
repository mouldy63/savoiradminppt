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
<%Dim title, strname, surname, address1, address2, address3, town, county, postcode, country, company, position, tel, fax, email, xsource, comments, channel, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, showroomname, mattresswidth, orderNo, bedname, accsummary, orderedprod, customertype
msg=""



if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
'sql for all contacts who accept email
'sql="select * from contact C, Address A where C.code=A.code and is_developer='n' and C.acceptemail='y' AND C.contact_no<>319256 AND C.contact_no<>24188 and A.SOURCE_SITE='SB' and contact_no>299999"
'sql for customertype i.e. yacht designer etc
sql="select * from contact C, Address A, customertype T where C.customerType=T.customerTypeID and C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and A.SOURCE_SITE='SB' and (T.customerTypeID=2 or T.customerTypeID=3 or T.customerTypeID=4)"
'response.Write(sql)
Set rs = getMysqlQueryRecordSet(sql, con)


Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Customer Type,Customer Status, Title ,First Name, Surname ,Company,Position,Email ,Tel,Tel Work,Mobile,address1 ,address2 ,address3 ,Town ,County ,Postcode ,Country, Accept Email, Accept Post")
Do until rs.eof
excelLine = """" & rs("customerType") & """,""" & rs("status") & """,""" & rs("title") & """,""" & rs("first") & """,""" & rs("surname") & """,""" & rs("company") & """,""" & rs("position") & """,""" & rs("email_address") & """,""" & rs("tel") & """,""" & rs("telWork") & """,""" & rs("mobile") & """,""" & rs("street1") & """,""" & rs("street2") & """,""" & rs("street3") & """,""" & rs("town") & """,""" & rs("county") & """,""" & rs("postcode") & """,""" & rs("country") & """,""" & rs("acceptemail") & """,""" & rs("acceptpost") & """"
tempfile.WriteLine(excelLine)

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
  
<!-- #include file="common/logger-out.inc" -->
