<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
Dim con, rs, invno, str, sql, pn, invdt
invno = request("invno")
pn = request("pn")
invdt = request("invdt")
set con = getMysqlConnection()
Set rs = getMysqlUpdateRecordSet("Select * from final_invoicenos where purchase_no=" & pn, con)
if rs.eof then
	rs.AddNew
end if
rs("purchase_no") = pn
rs("invoice_date") = invdt
rs("invoice_no") = invno
rs.update
rs.close
set rs = nothing
con.close
set con=nothing

response.write("success")
%>
