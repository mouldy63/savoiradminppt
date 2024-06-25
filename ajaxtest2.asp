<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR,NOPRICESUSER,TESTER"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
dim con, sql, n, val
n = request("n")
val = request("val")
Set con = getMysqlConnection()
sql = "update press set country" & n & "='" & val & "' where pressid=1"
'response.write(sql)
con.execute(sql)
call closemysqlcon(con)
response.write("x")
%>
