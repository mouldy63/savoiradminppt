<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="componentfuncs.asp" -->
<%
dim con, sql, rs, rs2, pn, compid, compname, width, length, boxname, weight, RoundToNearest, depth, awidth, alength, adepth
RoundToNearest=1
pn=request("pn")
compid=request("compid")
compname=request("compname")
width=request("width")
length=request("length")
boxname=request("boxname")


Set con = getMysqlConnection()

if compId = 9 then
	sql = "Select SUM(qty) AS AccQty from orderaccessory where purchase_no = " & pn
	set rs = getMysqlQueryRecordSet(sql, con)
	if not rs.eof then
	    weight=CDbl(rs("AccQty")) * 0.5 
	end if
	rs.close
	set rs=nothing
	sql = "Select * from shippingbox where sname = '" & boxname & "'"
	set rs = getMysqlQueryRecordSet(sql, con)
	if not rs.eof then
		awidth=CDbl(rs("width"))
		alength=CDbl(rs("length"))
		adepth=CDbl(rs("depth"))
		weight=weight + CDbl(rs("WEIGHT"))
	end if
end if
weight=round(weight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)

response.write(weight & "," & awidth & "," & alength & "," & adepth)

con.close
set con=nothing
%>
