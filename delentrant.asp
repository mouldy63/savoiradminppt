<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,WEBSITEADMIN"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/mysqldbfuncsGrandPrix.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<%Dim Con, rs, id, submit, count, sql, msg, contactname, entrantyear
entrantyear=request("entrantyear")
id=""
id=Request("id")
Set Con = getMysqlConnection()
sql="SELECT * from designapplicants where id=" & id
Set rs = getMysqlUpdateRecordSet(sql, con)
if not rs.eof then
contactname=rs("lastname")
rs.delete
end if
rs.close
set rs=nothing
Con.Close
Set Con = Nothing
response.Redirect("grandprix-entrants.asp?entrantyear=" & entrantyear & "&msg=" & contactname & " has been deleted")%>
<!-- #include file="common/logger-out.inc" -->
