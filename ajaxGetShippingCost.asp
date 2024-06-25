<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<%
const NUMBERS = "0123456789"
Dim con, country, postcode, sql, pcstub, n, l, rs, price, vatrate, isTrade
country = request("country")
if country = "" then country = "United Kingdom"
postcode = trim(request("postcode"))
vatrate = cdbl(request("vatrate"))
isTrade = request("istrade") = "y"
Set con = getMysqlConnection()

l = 0
for n = 1 to len(postcode)
	if l = 0 and instr(1, NUMBERS, mid(postcode, n, 1), 1) <> 0 then
		l = n - 1
	end if
next
pcstub = ucase(left(postcode, l))
'response.write("pcstub=" & pcstub)
sql = "select * from shipping s, countrylist c where s.countryid=c.countryid and replace(c.country,'\r','')='" & country & "' and s.postcodepart='" & pcstub & "'"
'response.write("sql=" & sql)
set rs = getMysqlQueryRecordSet(sql, con)

price = 0.0
if not rs.eof then
	price = ccur(rs("price"))
else
	rs.close
	sql = "select * from shipping s, countrylist c where s.countryid=c.countryid and replace(c.country,'\r','')='" & country & "' and s.postcodepart='OTHER'"
	set rs = getMysqlQueryRecordSet(sql, con)
	if not rs.eof then
		price = ccur(rs("price"))
	end if
end if

if isTrade then
	price = price / (1.0 + vatrate / 100.0)
end if

response.write(fmtCurr(price, false))

rs.close
set rs = nothing
con.close
set con=nothing
%>