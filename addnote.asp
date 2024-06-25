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
<!-- #include file="aspupload.asp" -->
<!-- #include file="filefuncs.asp" -->
<%
Dim postcode, postcodefull, Con, rs, count, sql, msg, note, followup, csid, closecase, savoirstaff, closedcasenotes, closedby, userid, replacementprice, servicecode, newFileName1, csnumber

dim file, upload, ext, newFileName, uploadok
Server.ScriptTimeout = 18600
Set Upload = Server.CreateObject("Persits.Upload")

Upload.SetMaxSize 3145728, True
'On Error Resume Next
Upload.SaveVirtual("produploads/temp/")
uploadok=true
If Err.Number = 8 Then
msg="Your file is too large. Please try again."
uploadok=false
Else
If Err <> 0 Then
msg="An error occurred: " & Err.Description
uploadok=false
End If
End If
On Error GoTo 0

Server.ScriptTimeout = 18600
replacementprice=Upload.form("replacementprice")
servicecode=Upload.form("servicecode")
closedby=Upload.form("closedby")
closedcasenotes=Upload.form("closedcasenotes")
savoirstaff=Upload.form("savoirstaff")
note=Upload.form("note")
followup=Upload.form("followup")
csid=Upload.form("csid")
closecase=Upload.form("closecase")
csnumber=Upload.form("csnumber")
Set Con = getMysqlConnection()

Set rs = getMysqlQueryRecordSet("Select * from savoir_user where username like '" & retrieveUserName() & "'", con)
userid=rs("user_id")
rs.close
set rs=nothing
count=0
If followup<>"" or closecase <>"" or savoirstaff<>"" or closedcasenotes<>"" or closedby<>"" then
sql="Select * from customerservice where csid=" & csid
response.Write("sql=" & sql)
Set rs = getMysqlUpdateRecordSet(sql, con)
If closedby<>"" then
rs("closedby")=closedby
end if
If closedcasenotes<>"" then
rs("closedcasenotes")=closedcasenotes
end if
if replacementprice<>"" then
rs("replacementprice")=replacementprice
end if
if servicecode<>"n" then
rs("servicecode")=servicecode
end if
If savoirstaff<>"" then
rs("savoirstaffresolvingissue")=savoirstaff
end if
If followup<>"" then
rs("followupdate")=followup
end if
If closecase<>"" then
rs("csclosed")="y"
rs("datecaseclosed")=date()
else
rs("csclosed")="n"
end if
rs.update
rs.close
set rs=nothing
end if

If note<>"" then
Set rs = getMysqlUpdateRecordSet("Select * from customerservicenotes", con)
rs.addnew
If followup<>"" then
rs("actiondate")=followup
end if
rs("noteaddedby")=userid
rs("csid")=csid
rs("note")=note
rs("dateadded")=date()
rs.update
rs.close
set rs=nothing
end if
'response.Write("csid=" & csid)
'response.End()
Set rs = getMysqlUpdateRecordSet("Select * from customerserviceuploads WHERE csid=" & csid, con)
if not rs.eof then
newFileName=left(rs("prodfilename"),21)
count=rs.recordcount
end if
rs.close
set rs=nothing


For Each File in Upload.Files
'response.write("<br>File.Name=" & File.Name)
ext = getFileNameExtension(File.path)
'response.write("<br>ext=" & ext)
count = count + 1
newFileName1 = "produploads/" & csnumber & "-" & count & ext

'response.write("<br>newFileName=" & newFileName)
call processFile(newFileName1, File, true, 0, 0)

Set rs = getMysqlUpdateRecordSet("Select * from customerserviceuploads", con)
rs.AddNew
rs("csid")=csid
rs("prodfilename")=newfilename1
rs("dateuploaded")=date()
rs.Update
rs.close
set rs=nothing
Next

set Upload = nothing
call closeFileObjects()


con.close
set con=nothing

If closecase<>"" then
response.Redirect("customerservicehistory.asp")
else
response.Redirect("customerservicereport.asp?csid=" & csid & "")
end if
%>
<!-- #include file="common/logger-out.inc" -->
