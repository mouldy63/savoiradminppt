<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
Dim con, rs, delAddrId, str, sql
delAddrId = request("id")
set con = getMysqlConnection()

sql = "select * from delivery_address where delivery_address_id=" & delAddrId
set rs = getMysqlQueryRecordSet(sql, con)

if not rs.eof then
	str = rs("add1") & "~" & rs("add2") & "~" & rs("add3") & "~" & rs("town") & "~" & rs("countystate") & "~" & rs("postcode") & "~" & rs("country") & "~" & rs("phone") & "~" & rs("phone2") & "~" & rs("phone3") & "~" & rs("contacttype1") & "~" & rs("contacttype2") & "~" & rs("contacttype3")
	response.write(str)
end if

con.close
set con=nothing
%>