<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="componentfuncs.asp" -->
<%
dim con, sql, rs, rs2, pn, compid, compname, width, length, boxname, weight, RoundToNearest, depth, awidth, alength, adepth
RoundToNearest=0.1
pn=request("pn")
compid=request("compid")
compname=request("compname")
width=request("width")
length=request("length")
if right(width,2)="cm" or right(width,2)="in" then width=left(width,len(width)-2)
if right(length,2)="cm" or right(length,2)="in" then length=left(length,len(length)-2)
boxname=request("boxname")
if boxname="Leg Box" then boxname="LegBox"
if boxname="Double Leg Box" then boxname="DoubleLegBox"



Set con = getMysqlConnection()

if compId = 8 then
	' hb
	width=getHbWidth(con,pn)
	'length=getHbHeight(con,pn)
end if

weight=checkMattKg(con,compid,compname,boxname,width,length)

if compId = 9 then
	sql = "Select SUM(qty) AS AccQty from orderaccessory where purchase_no = " & pn
	'response.Write(sql)
	set rs = getMysqlQueryRecordSet(sql, con)
	if not rs.eof then
	    weight=CDbl(rs("AccQty")) * 0.5 
	end if
	rs.close
	set rs=nothing
	sql = "Select * from shippingbox where sname = '" & boxname & "'"
	'response.Write("sql=" & asql)
	set rs = getMysqlQueryRecordSet(sql, con)
	if not rs.eof then
		awidth=CDbl(rs("width"))
		alength=CDbl(rs("length"))
		adepth=CDbl(rs("depth"))
		weight=weight + CDbl(rs("WEIGHT"))
	end if
end if
if boxname="Leg Box" then weight=0.8
if boxname="Double Leg Box" then weight=1.6

weight=round(weight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
response.write(weight & "," & awidth & "," & alength & "," & adepth)

con.close
set con=nothing
%>
