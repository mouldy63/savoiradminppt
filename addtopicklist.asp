<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim Con, rs, userid, sql, addperson, msg, newname, id

addperson=""
msg=""
newname=""
newname=request("newname")
addperson=request("addperson")
if addperson<>""  and newname<>"" then
Set Con = getMysqlConnection()
sql="SELECT * from savoir_user"
Set rs = getMysqlUpdateRecordSet(sql, con)
rs.AddNew
rs("username")="production"
rs("pw")="AAAxxx111"
rs("name")=newname
rs("id_region")=1
rs("superuser")="N"
rs("id_location")=1
rs("site")="SB"
rs("adminemail")="info@savoirbeds.co.uk"
rs.Update
id=rs("user_id")
rs.close
set rs=nothing

sql="SELECT * from savoir_userrole"
Set rs = getMysqlUpdateRecordSet(sql, con)
rs.AddNew
rs("user_id")=id
rs("role_id")=7

rs.update
rs.close
set rs=nothing
msg="New member of production team added"
Con.Close
Set Con = Nothing
response.Redirect("edit-picklist.asp?msg=" & msg & "")
end if
%>
  
<!-- #include file="common/logger-out.inc" -->
