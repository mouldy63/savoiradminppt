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
<%
Dim  Con, rs, rs2, sql, total, paymentsTotal, balanceOutstanding, calculatedBalanceOutstanding, probCount, orderCount, paymentsSum
Set Con = getMysqlConnection()

sql = "select * from purchase where order_date is not null and order_date > '2014-01-01' and (cancelled is null or cancelled = 'n') and purchase_no=73246 order by order_date"
Set rs = getMysqlUpdateRecordSet(sql, con)
probCount = 0
orderCount = 0

while not rs.eof
	total = safeCur(rs("TOTAL"))
	paymentsTotal = safeCur(rs("PAYMENTSTOTAL"))
	balanceOutstanding = safeCur(rs("BALANCEOUTSTANDING"))
	calculatedBalanceOutstanding = total - paymentsTotal
	if calculatedBalanceOutstanding <> balanceOutstanding then
		response.write("<br>Order = " & rs("ORDER_NUMBER") & " Outstanding = " & balanceOutstanding & " Calc Outstanding = " & calculatedBalanceOutstanding)
		probCount = probCount + 1
	end if
	
	sql = "select * from payment where purchase_no=" & rs("purchase_no")
	Set rs2 = getMysqlUpdateRecordSet(sql, con)
	paymentsSum = 0.0
	while not rs2.eof
		paymentsSum = paymentsSum + safeCur(rs2("AMOUNT"))
		rs2.movenext
	wend
	rs2.close

	'if paymentsSum <> paymentsTotal then
		response.write("<br>Order = " & rs("ORDER_NUMBER") & " Payments total = " & paymentsTotal & " Payments sum = " & paymentsSum)
		probCount = probCount + 1
	'end if
	
	rs.movenext
	orderCount = orderCount + 1
wend

rs.close
set rs=nothing

con.close

response.write("<br>" & orderCount & " orders checked. " & probCount & " problems found")
%>
<!-- #include file="common/logger-out.inc" -->
