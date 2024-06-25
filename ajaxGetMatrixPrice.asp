<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="pricematrixfuncs.asp" -->
<%
Dim con, compId, priceTypeName, dim1, dim2, dim3, price, curr, compIdSet1, compIdSet2, multiplier, exWorksRevenue, wholesalePrice, isTrade, vatRate

compId = request("compid")
priceTypeName = request("type")
dim1 = request("dim1")
dim2 = request("dim2")
dim3 = request("dim3")
curr = request("curr")
multiplier = cdbl(request("multiplier"))
compIdSet1 = request("compidset1")
compIdSet2 = request("compidset2")
isTrade = request("trade") = "y"
vatRate = cdbl(request("vatrate"))

set con = getMysqlConnection()

price = getMatrixPrice(con, exWorksRevenue, wholesalePrice, compId, priceTypeName, dim1, dim2, dim3, curr, compIdSet1, compIdSet2)
'response.write("<br>ajaxGetmatrixPrice: price=" & price & "<br>")

if price = -1.0 and (compIdSet1 <> "" or compIdSet2 <> "") then
	' no price found for the set, so try with just the component
price = getMatrixPrice(con, exWorksRevenue, wholesalePrice, compId, priceTypeName, dim1, dim2, dim3, curr, "", "")
end if

if price = -1.0 and (dim1 <> "" or dim2 <> "" or dim3 <> "") then
' no price found for the set, or with the dimensions, so try without the dimensions
price = getMatrixPrice(con, exWorksRevenue, wholesalePrice, compId, priceTypeName, "", "", "", curr, "", "")
end if

if price <> -1.0 then
	price = price * multiplier
	if isTrade and curr <> "USD" then ' prices in price matrix table for USD are VAT excl
		price = price / (1.0 + vatRate/100.0)
	end if
end if

response.write(fmtCurr2(price, false, curr))

con.close
set con=nothing
%>