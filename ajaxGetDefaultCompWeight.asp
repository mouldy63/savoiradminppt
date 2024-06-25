<%Option Explicit%>
<!-- #include file="adovbs2.inc" -->

<!-- #include file="common/mysqldbfuncs.asp" -->
<!-- #include file="common/utilfuncs.asp" -->
<!-- #include file="orderfuncs.asp" -->
<!-- #include file="componentfuncs.asp" -->
<%
dim con, sql, rs, rs2, pn, compId
dim width, length, defaultBoxSize1, defaultBoxSize2, defaultWeight1, defaultWeight2, m1width, m2width, m1length, m2length, t1width, t1length
dim defaultPackWidth, defaultPackHeight, defaultPackDepth, defaultPackKG, defaultCrateQty, mattressonly, mattresstopper, compdepth, internalCrateAllow, PackAllowance, RoundToNearest, AddCrateAllow, mattresszipped, topperdepth, legsmattress, legsDepth, cratemultiplier, shippingcrateweight, componentweight, basenumber, legsbase, legstopper, legshb, legsWidth, legsHeight, legno, legweight, valanceweight, valancebase, valancemattress, valancetopper, valancehb, totalwidth, topperonly, overallwidth, overalllength, crateName, crateLength, crateWidth, crateHeight, crateWeight, crateName2, crateLength2, crateWidth2, crateHeight2, crateWeight2, crateName3, crateLength3, crateWidth3, crateHeight3, crateWeight3, crateName4, crateLength4, crateWidth4, crateHeight4, crateWeight4, defaultPackLength, crateExpak, crateQty, expak, compno, accessoryqty
accessoryqty=0
RoundToNearest=1
compno=request("compno")
pn=request("pn")
Set con = getMysqlConnection()
sql = "Select SUM(qty) AS AccQty from orderaccessory where purchase_no = " & pn & ""
set rs = getMysqlQueryRecordSet(sql, con)
if not rs.eof and not isnull(rs("AccQty")) then
    accessoryqty=CDbl(rs("AccQty")) 
end if
rs.close
set rs=nothing
sql = "select * from purchase where purchase_no = " & pn & ""
set rs = getMysqlQueryRecordSet(sql, con)
if rs("legqty")<>"" then legno=rs("legqty")
if rs("addlegqty")<>"" then legno=CDbl(legno) + CDbl(rs("addlegqty"))
if rs("headboardlegqty")<>"" then legno=CDbl(legno) + CDbl(rs("headboardlegqty"))
legweight=getLegWeight(con)
if compno=7 then
	componentweight=(CDbl(legno) * 27 * CDbl(legweight))/1000
	componentweight=round(componentweight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
end if
if compno=6 then
	componentweight=6
end if
if compno=9 then
	componentweight=0.5 * accessoryqty
	componentweight=round(componentweight/CDbl(RoundToNearest)+0.4999)*CDbl(RoundToNearest)
end if
rs.close
set rs=nothing


response.write(componentweight)

con.close
set con=nothing
%>
