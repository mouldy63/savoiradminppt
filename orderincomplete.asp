<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,SALES"
Dim  Con, rs, val
val=request("val")
Set Con = getMysqlConnection()%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%if (isSuperuser or userHasRoleInList("ORDER_REOPENER")) then
Set rs = getMysqlUpdateRecordSet("Select * from purchase WHERE purchase_no=" & val, con)
rs("completedorders")="n"
rs.Update
rs.close
set rs=nothing
response.Redirect("editcust.asp?val=" & Session("custval") & "")
end if%>
<!-- #include file="common/logger-out.inc" -->
