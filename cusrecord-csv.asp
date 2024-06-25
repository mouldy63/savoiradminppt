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
<%Dim postcode, postcodefull, Con, rs, rs2, recordfound, id, rspostcode, submit1, submit2, count, envelopecount, i, fieldName, fieldValue, fieldNameArray, type1, val, lettercount, corresid, nobrochurealert, xcount, ycount, x, y, sql, correspondencename
nobrochurealert=Request("nobrochurealert")
corresid=Request("corresid")
'count=0
val=""

val=Request("val")

Dim filesys, tempfile, tempfolder, tempname, filename, objStream, excelLine
Set filesys = CreateObject("Scripting.FileSystemObject")
set tempfolder = filesys.GetFolder(Server.MapPath("temp"))
tempname = filesys.GetTempName
Set tempfile = tempfolder.CreateTextFile(tempname)
filename = tempfolder & "\" & tempname
tempfile.WriteLine("Title,First Name,Surname,Company,Position,Street1,Street2,Street3,Town,County,Postcode,Country,Tel,Fax,Email")

Set Con = getMysqlConnection()
Set rs = getMysqlUpdateRecordSet("Select * from region Where id_region=" & retrieveUserLocation() & "", con)
'Session.LCID=1029
Session.LCID=trim(rs("locale"))
rs.close
set rs=nothing

If val <> "" Then


count=0

	
Set rs = getMysqlQueryRecordSet("Select * from address A, contact C Where A.code=C.code AND C.contact_no=" & val, con)


excelLine = """" & capitalise(rs("title")) & """,""" & capitalise(rs("first")) & """,""" & capitalise(rs("surname")) & """,""" & capitalise(rs("company")) & """,""" & capitalise(rs("position")) & """,""" & capitalise(rs("street1")) & """,""" & capitalise(rs("street2")) & """,""" & capitalise(rs("street3")) & """,""" & capitalise(rs("town")) & """,""" & capitalise(rs("county")) & """,""" & capitalise(rs("postcode")) & """,""" & capitalise(rs("country")) & """,""" & rs("tel") & """,""" & rs("fax") & """,""" & rs("email_address") & """"
tempfile.WriteLine(excelLine)
rs.close
set rs=nothing
end if

tempfile.close

Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Open
objStream.Type = 1
objStream.LoadFromFile(filename)

Response.ContentType = "application/csv"
Response.AddHeader "Content-Disposition", "attachment; filename=""customer-record.csv"""

Response.Status = "200"
Response.BinaryWrite objStream.Read

objStream.Close
Set objStream = Nothing

filesys.deleteFile filename, true
set filesys = Nothing


function capitalise(str)
dim words, word
if isNull(str) or trim(str)="" then
	capitalise=""
else
	words = split(trim(str), " ")
	for each word in words
		If IsNumeric(word) Then
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

%>
<!-- #include file="common/logger-out.inc" -->
