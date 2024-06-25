<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Response.Buffer = False
Server.ScriptTimeout =82900%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim title, strname, surname, postcode, country, submit, msg, strmsg, item, ItemValue, found, Con, rs, rs1, rs2, rs3, rs4, recordfound, id, sql, sql2,  sql3, i, monthfrom, monthto, ddmonth, ddyear, monthfrom1, monthto1, customertype, ordernos, contactno

msg=""



if (retrieveuserid()=2) then	
Set Con = getMysqlConnection()
'sql for all customers and order nos
sql="select * from contact C, Address A where C.code=A.code and is_developer='n' AND C.contact_no<>319256 AND C.contact_no<>24188 and A.status like 'customer'"

Set rs = getMysqlQueryRecordSet(sql, con)

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine, strsource, brochuremsg, orderdt
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Surname,Postcode,Country,Order No.")
Do until rs.eof
ordernos=""
	sql3="select order_number from Purchase where contact_no=" & rs("contact_no") & ""
	Set rs4 = getMysqlQueryRecordSet(sql3, con)
	if not rs4.eof then
		do until rs4.eof
		ordernos=ordernos & rs4("order_number") & " "
	rs4.movenext
	loop
	end if
	rs4.close
	set rs4=nothing

	excelLine = """" & rs("surname") & """,""" & rs("postcode") & """,""" & rs("country") & """,""" & ordernos & """"
	
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
