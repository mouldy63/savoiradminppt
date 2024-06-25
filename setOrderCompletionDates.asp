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
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="generalfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
Dim con, rs, sql
Set Con = getMysqlConnection()
con.begintrans

sql = "select distinct purchase_no from qc_history_latest where componentid in (1,3,5,8) and finished is not null"
set rs = getMysqlQueryRecordSet(sql, con)

while not rs.eof
	response.write("<br>pn = " & rs("purchase_no"))
	call setOrderProductionCompletionDate(con, rs("purchase_no"))
	rs.movenext
wend

con.committrans
'con.rollbacktrans

call closemysqlcon(con)
%>
<!-- #include file="common/logger-out.inc" -->
