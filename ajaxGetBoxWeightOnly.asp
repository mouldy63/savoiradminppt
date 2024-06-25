<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="componentfuncs.asp" -->
<%
dim con, boxname, weight, RoundToNearest
RoundToNearest=1
boxname=request("boxname")

Set con = getMysqlConnection()
if boxname="Leg Box" then boxname="LegBox"
if boxname="Double Leg Box" then boxname="DoubleLegBox"
weight = getBoxWeight(con, boxname)
'weight=round(weight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
con.close
set con=nothing
response.write(FormatNumber(weight, 0))
%>
