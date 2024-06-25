<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
Dim con, pn, sql, newCode
pn = request("pn")
set con = getMysqlConnection()

newCode = getRandomConfirmationNumber(con)

sql = "update purchase set OrderConfirmationCode='" & newCode & "' where purchase_no=" & pn
con.execute(sql)

con.close
set con=nothing

response.write(newCode)
%>