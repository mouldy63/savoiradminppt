<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
Dim con, func, sql, rs, priceTypeId, dim1, dim2, dim3

func = request("func")
set con = getMysqlConnection()

if func = "getPriceTypeDims" then
	priceTypeId = request("ptid")
	sql = "select * from price_matrix_type where price_type_id=" & priceTypeId
	set rs = getMysqlUpdateRecordSet(sql, con)
	dim1 = rs("dim1_name")
	if isnull(dim1) then dim1 = ""
	dim2 = rs("dim2_name")
	if isnull(dim2) then dim2 = ""
	dim3 = rs("dim3_name")
	if isnull(dim3) then dim3 = ""
	response.write("{ ""DIM1_NAME"":""" & dim1 & """, ""DIM2_NAME"":""" & dim2 & """, ""DIM3_NAME"":""" & dim3 & """ }")
	call closemysqlrs(rs)
end if

call closemysqlcon(con)
%>