<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%
Const UTF8_BOM = "﻿"
Dim postcode, postcodefull, Con, rs, rs1, rs2, recordfound, id, rspostcode, submit1, submit2, count, envelopecount, i, fieldName, fieldValue, fieldNameArray, type1, submit6, lettercount, corresid, nobrochurealert, xcount, ycount, x, y, sql, correspondencename, requestdate

nobrochurealert=Request("nobrochurealert")
corresid=Request("corresid")
'count=0
submit6=Request("submit6")

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.Write(UTF8_BOM)
tempfile.WriteLine("Title,First Name,Surname,Company,Position,Street1,Street2,Street3,Town,County,Postcode,Country,Tel,Fax,Email,Date of Request")

Set Con = getMysqlConnection()
'Set rs = getMysqlUpdateRecordSet("Select * from region Where id_region=" & retrieveUserLocation() & "", con)
'Session.LCID=1029
'Session.LCID=trim(rs("locale"))
'rs.close
'set rs=nothing

If submit6 <> "" Then

count=0
For i = 1 To Request.Form.Count
	fieldName = Request.Form.Key(i)
	If left(fieldName, 3) = "XX_" Then
	count=count+1
	fieldNameArray = Split(fieldName, "_")
	type1 = fieldNameArray(1)
	

	sql="Select * from address A, contact C Where A.code=C.code AND A.code=" & type1
	Set rs = getMysqlQueryRecordSet(sql, con)
	
	requestdate=""
	sql="Select * from communication where code=" & rs("code") & " and type like '%brochure request%' order by date desc"
	Set rs1 = getMysqlQueryRecordSet(sql, con)
	
	if NOT rs1.eof then
	requestdate=rs1("date")
	else
	requestdate=rs("first_contact_date")
	end if
	rs1.close
	set rs1=nothing

excelLine = """" & capitalise(rs("title")) & """,""" & capitalise(rs("first")) & """,""" & capitalise(rs("surname")) & """,""" & capitalise(rs("company")) & """,""" & capitalise(rs("position")) & """,""" & capitalise(rs("street1")) & """,""" & capitalise(rs("street2")) & """,""" & capitalise(rs("street3")) & """,""" & capitalise(rs("town")) & """,""" & capitalise(rs("county")) & """,""" & capitalise(rs("postcode")) & """,""" & capitalise(rs("country")) & """,""" & rs("tel") & """,""" & rs("fax") & """,""" & rs("email_address") & """,""" & requestdate & """"
tempfile.WriteLine(excelLine)
rs.close
set rs=nothing
end if
next
tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Charset = "UTF-8"
objStream.Type = 1
objStream.Open
objStream.LoadFromFile(filename)

Response.ContentType = "text/csv; charset=utf-8"
Response.AddHeader "Content-Disposition", "attachment; filename=""brochure-requests.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing

end if


function capitalise(str)
dim words, word
if isNull(str) or trim(str)="" then
	capitalise=""
else
	words = split(trim(str), " ")
	for each word in words
		If IsNumeric(word) Then
		capitalise = capitalise & word & " "
			elseif notAscii(word) Then
				capitalise = capitalise & word & " "
		Else
		word = lcase(word)
		if len(word)<2 then
		word=ucase(word)
		else
		word = ucase(left(word,1)) & (right(word,len(word)-1))
		end if
		capitalise = capitalise & word & " "
		End If
	next
	capitalise = left(capitalise, len(capitalise)-1)
end if
end function

function notAscii(str)
	dim i, c
	notAscii = false
	for i = 1 to len(str)
		c = asc(mid(str, i, 1))
		if c > 127 then
			notAscii = true
			exit function
		end if
	next
end function
%>
<!-- #include file="common/logger-out.inc" -->
