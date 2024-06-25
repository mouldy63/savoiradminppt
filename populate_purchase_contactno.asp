<%option explicit%>
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<%
Server.ScriptTimeout = 600
dim sql, rs, n, con, rs2, nn
set con = getMysqlConnection()

sql = "select code,purchase_no from purchase where contact_no is null order by purchase_no"
Set rs = getMysqlQueryRecordSet(sql, con)

n = 0
nn = 0
while not rs.eof and n < 100000000
	sql = "select contact_no from contact where code=" & rs("code") & " order by contact_no desc"
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	if not rs2.eof then
		sql = "update purchase set contact_no=" & rs2("contact_no") & " where purchase_no=" & rs("purchase_no") ' use the lastest contact for the code (i.e. address)
		con.execute(sql)
		if n<20 then response.write("<br>sql = " & sql)
		n = n + 1
	else
		'response.write("<br>" & rs("purchase_no") & " has no contact")
		nn = nn + 1
	end if
	call closemysqlrs(rs2)
	rs.movenext
wend

response.write("<br>n=" & n)
response.write("<br>nn=" & nn)

call closemysqlrs(rs)

call closemysqlcon(con)

%>
