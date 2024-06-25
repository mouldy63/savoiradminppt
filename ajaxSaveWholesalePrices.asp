<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<%
Dim con, rs, sql, pn, n
Dim Wmattressprice, Wtopperprice, WBaseFabricprice, WBaseUphprice, WBaseTrimprice, WBaseDrawerprice, WBaseprice, Wlegsprice, WSupportlegsprice, WHBFabricprice
Dim WHBTrimprice, WHBprice, Wvalanceprice, Wvalancefabprice
Dim manhattantrim, acc_id, acc_wholesalePrice

pn = request("pn")
Wmattressprice = request("Wmattressprice")
Wtopperprice = request("Wtopperprice")
WBaseFabricprice = request("WBaseFabricprice")
WBaseUphprice = request("WBaseUphprice")
WBaseTrimprice = request("WBaseTrimprice")
WBaseDrawerprice = request("WBaseDrawerprice")
WBaseprice = request("WBaseprice")
Wlegsprice = request("Wlegsprice")
WSupportlegsprice = request("WSupportlegsprice")
WHBFabricprice = request("WHBFabricprice")
WHBTrimprice = request("WHBTrimprice")
WHBprice = request("WHBprice")
Wvalanceprice = request("Wvalanceprice")
Wvalancefabprice = request("Wvalancefabprice")
manhattantrim = request("manhattantrim")
If left(manhattantrim,2) = "--" then WHBTrimprice = "" ' so that the row is deleted by saveWholesalePrice


set con = getMysqlConnection()

call saveWholesalePrice(con, pn, 1, Wmattressprice)
call saveWholesalePrice(con, pn, 5, Wtopperprice)
call saveWholesalePrice(con, pn, 17, WBaseFabricprice)
call saveWholesalePrice(con, pn, 12, WBaseUphprice)
call saveWholesalePrice(con, pn, 11, WBaseTrimprice)
call saveWholesalePrice(con, pn, 13, WBaseDrawerprice)
call saveWholesalePrice(con, pn, 3, WBaseprice)
call saveWholesalePrice(con, pn, 7, Wlegsprice)
call saveWholesalePrice(con, pn, 16, WSupportlegsprice)
call saveWholesalePrice(con, pn, 15, WHBFabricprice)
call saveWholesalePrice(con, pn, 10, WHBTrimprice)
call saveWholesalePrice(con, pn, 8, WHBprice)
call saveWholesalePrice(con, pn, 6, Wvalanceprice)
call saveWholesalePrice(con, pn, 18, Wvalancefabprice)
	
for n = 1 to 20
	acc_id = request("acc_id" & n)
	if acc_id <> "" then
		acc_wholesalePrice = request("acc_wholesalePrice" & n)
		if acc_wholesalePrice = "" then acc_wholesalePrice = 0.0
		sql = "update orderaccessory set wholesalePrice=" & safeCCur(acc_wholesalePrice) & " where orderaccessory_id=" & acc_id
		'response.write("<br>" & sql)
		'response.end
		con.execute(sql)
	end if
next

call closemysqlcon(con)

response.write("success")
%>
