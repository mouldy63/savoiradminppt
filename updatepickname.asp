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
<%Dim Con, rs, userid, sql, addperson, msg, newname, pick, made, factory
userid=request("userid")
addperson=""
msg=""
newname=""
newname=request("newname")
addperson=request("addperson")
pick=request("pick")
made=request("made")
factory=request("factory")
if addperson<>""  and newname<>"" then
Set Con = getMysqlConnection()
sql="SELECT * from savoir_user where user_id=" & userid

Set rs = getMysqlUpdateRecordSet(sql, con)
rs("name")=newname
rs("pickedby")=pick
rs("madeby")=made
rs("id_location")=factory
rs.Update
rs.close
set rs=nothing
msg="Name has been amended"
Con.Close
Set Con = Nothing
response.Redirect("edit-picklist.asp?msg=" & msg & "")
end if
%>
  
<!-- #include file="common/logger-out.inc" -->
