<%Option Explicit%>
<%
dim ALLOWED_ROLES
ALLOWED_ROLES = "ADMINISTRATOR"
%>
<!-- #include file="access/funcs.asp" -->
<!-- #include file="access/login.inc" -->
<!-- #include file="common/logger-in.inc" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/adovbs2.inc" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="customerfuncs.asp" -->
<!-- #include file="generalfuncs.asp" -->
<%
Server.ScriptTimeout = 600
dim con, rs, sql, rs2, id, idlatest
Set Con = getMysqlConnection()

sql = "select distinct purchase_no, componentid from qc_history where qc_date>'2013-01-01' order by purchase_no"
Set rs = getMysqlQueryRecordSet(sql, con)

while not rs.eof
	'response.write("<br>Purchase_no=" & rs("purchase_no") & " and componentid=" & rs("componentid"))
	sql = "select qc_historyid from qc_history where purchase_no=" & rs("purchase_no") & " and componentid=" & rs("componentid") & " order by qc_date desc"
	'response.write("<br>" & sql)
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	id = 0
	if not rs2.eof then
		id = cint(rs2("qc_historyid"))
	else
		response.write("<br>No qc_history row for Purchase_no=" & rs("purchase_no") & " and componentid=" & rs("componentid"))
	end if
	call closeRs(rs2)
	
	sql = "select qc_historyid from qc_history_latest where purchase_no=" & rs("purchase_no") & " and componentid=" & rs("componentid")
	'response.write("<br>" & sql)
	Set rs2 = getMysqlQueryRecordSet(sql, con)
	idlatest = 0
	if not rs2.eof then
		idlatest = cint(rs2("qc_historyid"))
	else
		response.write("<br>No qc_history_latest row for Purchase_no=" & rs("purchase_no") & " and componentid=" & rs("componentid"))
	end if
	call closeRs(rs2)

	'response.write("<br>ID=" & id & " IDLATEST = " & idlatest)
	if id <> idlatest then
		response.write("<br>qc_history_latest row not latest for Purchase_no=" & rs("purchase_no") & " and componentid=" & rs("componentid"))
		if request("fix") = "y" then
			sql = "update qc_history set qc_date=qc_date where qc_historyid=" & id
			response.write("<br>" & sql)
			con.execute(sql)
			response.write("<br>FIXED")
		else
			response.write("<br>NOT FIXED")
		end if
	end if

	rs.movenext
wend
call closeRs(rs)

call closeRs(con)
%>
<!-- #include file="common/logger-out.inc" -->
