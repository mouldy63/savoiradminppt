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
<%Dim Con, rs, userid, sql, msg
userid=request("userid")
Set Con = getMysqlConnection()
sql="SELECT * from savoir_user where user_id=" & userid

Set rs = getMysqlUpdateRecordSet(sql, con)
rs("retired")="n"
rs.update
rs.close
set rs=nothing
msg="User is unretired"

Con.Close
Set Con = Nothing
response.Redirect("edit-picklist.asp?msg=" & msg)
%>
  
<!-- #include file="common/logger-out.inc" -->
