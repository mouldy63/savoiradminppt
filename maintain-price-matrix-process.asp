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
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
dim con, sql, rs, id

set con = getMysqlConnection()
con.begintrans

sql = "select * from price_matrix order by price_matrix_id"
set rs = getMysqlUpdateRecordSet(sql, con)

while not rs.eof
	id = rs("price_matrix_id")
	
	'response.write("<br>del = " &request("del-" & id))
	
	if request("del-" & id) = "y" then
		rs.delete
	else
		rs("price_type_id") = request("price_type_id-" & id)
		rs("componentid") = request("componentid-" & id)
		call updateRs(rs, "dim1", request("dim1-" & id))
		call updateRs(rs, "dim2", request("dim2-" & id))
		call updateRs(rs, "dim3", request("dim3-" & id))
		call updateRs(rs, "compid_set1", request("compid_set1-" & id))
		call updateRs(rs, "compid_set2", request("compid_set2-" & id))
		call updateRsNumber(rs, "gbp", request("gbp-" & id))
		call updateRsNumber(rs, "usd", request("usd-" & id))
		call updateRsNumber(rs, "eur", request("eur-" & id))
		call updateRsNumber(rs, "gbp_wholesale", request("gbp_wholesale-" & id))
		call updateRsNumber(rs, "usd_wholesale", request("usd_wholesale-" & id))
		call updateRsNumber(rs, "eur_wholesale", request("eur_wholesale-" & id))
		call updateRsNumber(rs, "ex_works_revenue", request("ex_works_revenue-" & id))
		rs.update
	end if
	
	rs.movenext
wend

if isNumeric(request("gbp-0")) or isNumeric(request("usd-0")) or isNumeric(request("eur-0")) or isNumeric(request("gbp_wholesale-0")) or isNumeric(request("usd_wholesale-0")) or isNumeric(request("eur_wholesale-0")) or isNumeric(request("ex_works_revenue-0")) then
	rs.addnew
	rs("price_type_id") = request("price_type_id-0")
	rs("componentid") = request("componentid-0")
	call updateRs(rs, "dim1", request("dim1-0"))
	call updateRs(rs, "dim2", request("dim2-0"))
	call updateRs(rs, "dim3", request("dim3-0"))
	call updateRs(rs, "compid_set1", request("compid_set1-0"))
	call updateRs(rs, "compid_set2", request("compid_set2-0"))
	call updateRsNumber(rs, "gbp", request("gbp-0"))
	call updateRsNumber(rs, "usd", request("usd-0"))
	call updateRsNumber(rs, "eur", request("eur-0"))
	call updateRsNumber(rs, "gbp_wholesale", request("gbp_wholesale-0"))
	call updateRsNumber(rs, "usd_wholesale", request("usd_wholesale-0"))
	call updateRsNumber(rs, "eur_wholesale", request("eur_wholesale-0"))
	call updateRsNumber(rs, "ex_works_revenue", request("ex_works_revenue-0"))
	rs.update
end if

call closemysqlrs(rs)
con.committrans
call closemysqlcon(con)

response.redirect("maintain-price-matrix.asp?jsmsg=" & server.urlencode("Updates Saved"))

sub updateRsNumber(byref ars, aColName, aVal)
	if not isnull(aVal) and not isempty(aVal) and aVal <> "" then
		aVal = replace(aVal, ",", "")
		if not isNumeric(aVal) then
			aVal = cleanToNumber(aVal)
		end if
	end if
	call updateRs(ars, aColName, aVal)
end sub

sub updateRs(byref ars, aColName, aVal)
	if isnull(aVal) or isempty(aVal) or aVal = "" then
		ars(aColName) = null
	else
		ars(aColName) = trim(aVal)
	end if
end sub
%>
<!-- #include file="common/logger-out.inc" -->
